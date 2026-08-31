use alloc::boxed::Box;
use core::{
    ffi::{c_int, c_void},
    hint::cold_path,
    mem::{offset_of, size_of, zeroed},
    ptr::null_mut,
};

use crate::{Xerr, error::fatal, vship::PinPool};

const DAV1D_ERR_AGAIN: c_int = -11;
const PIC_ALIGN: usize = 64;

#[repr(C)]
struct PicAllocator {
    cookie: *const c_void,
    alloc: Option<unsafe extern "C" fn(*mut Picture, *const c_void) -> c_int>,
    release: Option<unsafe extern "C" fn(*mut Picture, *const c_void)>,
}

#[repr(C, align(8))]
struct Settings {
    n_threads: c_int,
    max_frame_delay: c_int,
    apply_grain: c_int,
    _mid: [c_int; 3],
    allocator: PicAllocator,
    _rest: [u8; 48],
}

#[repr(C)]
struct Data {
    _ptr: *const u8,
    _rest: [u8; 64],
}

#[repr(C)]
struct Picture {
    _hdr: [*mut c_void; 2],
    data: [*mut c_void; 3],
    stride: [isize; 2],
    _mid: [u8; 208],
    allocator_data: *mut u8,
}

const _: [(); 96] = [(); size_of::<Settings>()];
const _: [(); 272] = [(); size_of::<Picture>()];
const _: [(); 24] = [(); offset_of!(Settings, allocator)];
const _: [(); 264] = [(); offset_of!(Picture, allocator_data)];

// size, align, pin, resolve only once
#[repr(align(64))]
struct PicCtx {
    pool: PinPool<1>,
    stride: [isize; 2],
    off: [u32; 2],
    total: u32,
}

impl PicCtx {
    const fn new(w: u32, h: u32) -> Self {
        let aligned_w = (w as usize + 127) & !127;
        let aligned_h = (h as usize + 127) & !127;
        let mut y_stride = aligned_w * 2;
        let mut uv_stride = aligned_w;
        if y_stride.trailing_zeros() >= 10 {
            y_stride += PIC_ALIGN;
        }
        if uv_stride.trailing_zeros() >= 10 {
            uv_stride += PIC_ALIGN;
        }
        let y_sz = y_stride * aligned_h;
        let uv_sz = uv_stride * (aligned_h >> 1);
        Self {
            pool: PinPool::new(),
            stride: [y_stride as isize, uv_stride as isize],
            off: [y_sz as u32, (y_sz + uv_sz) as u32],
            total: (y_sz + 2 * uv_sz + PIC_ALIGN) as u32,
        }
    }
}

const _: [(); 64] = [(); size_of::<PicCtx>()];

unsafe extern "C" fn pic_alloc(pic: *mut Picture, ctx: *const c_void) -> c_int {
    let c = unsafe { &*ctx.cast::<PicCtx>() };
    let base = c.pool.get(0, || c.total as usize);
    let p = unsafe { &mut *pic };
    p.allocator_data = base;
    p.stride = c.stride;
    unsafe {
        p.data[0] = base.cast();
        p.data[1] = base.add(c.off[0] as usize).cast();
        p.data[2] = base.add(c.off[1] as usize).cast();
    }
    0
}

unsafe extern "C" fn pic_release(pic: *mut Picture, ctx: *const c_void) {
    unsafe { &*ctx.cast::<PicCtx>() }
        .pool
        .put(0, unsafe { (*pic).allocator_data });
}

unsafe extern "C" {
    fn dav1d_default_settings(s: *mut Settings);
    fn dav1d_get_frame_delay(s: *const Settings) -> c_int;
    fn dav1d_open(c_out: *mut *mut c_void, s: *const Settings) -> c_int;
    fn dav1d_send_data(c: *mut c_void, data: *mut Data) -> c_int;
    fn dav1d_get_picture(c: *mut c_void, out: *mut Picture) -> c_int;
    fn dav1d_data_wrap(
        data: *mut Data,
        buf: *const u8,
        sz: usize,
        free_callback: unsafe extern "C" fn(*const u8, *mut c_void),
        cookie: *mut c_void,
    ) -> c_int;
    fn dav1d_picture_unref(p: *mut Picture);
    fn dav1d_flush(c: *mut c_void);
    fn dav1d_close(c_out: *mut *mut c_void);
}

const unsafe extern "C" fn noop_free(_: *const u8, _: *mut c_void) {}

pub struct Dav1dDec {
    pic_ctx: Box<PicCtx>,
    ctx: *mut c_void,
    lowlat: *mut c_void,
    active: *mut c_void,
    frame_delay: usize,
    threads: i32,
    pic: Picture,
}

impl Dav1dDec {
    pub fn new(threads: i32, w: u32, h: u32) -> Result<Self, Xerr> {
        let pic_ctx = Box::new(PicCtx::new(w, h));
        let settings = Self::settings(threads, 0, (&raw const *pic_ctx).cast());
        let frame_delay = unsafe { dav1d_get_frame_delay(&raw const settings) }.max(1) as usize;
        let ctx = Self::open(&settings)?;
        Ok(Self {
            pic_ctx,
            ctx,
            lowlat: null_mut(),
            active: ctx,
            frame_delay,
            threads,
            pic: unsafe { zeroed() },
        })
    }

    fn settings(threads: i32, max_frame_delay: c_int, ctx: *const c_void) -> Settings {
        let mut settings = unsafe { zeroed::<Settings>() };
        unsafe { dav1d_default_settings(&raw mut settings) };
        settings.n_threads = threads.min(256);
        settings.max_frame_delay = max_frame_delay;
        settings.apply_grain = 0;
        settings.allocator = PicAllocator {
            cookie: ctx,
            alloc: Some(pic_alloc),
            release: Some(pic_release),
        };
        settings
    }

    fn open(settings: &Settings) -> Result<*mut c_void, Xerr> {
        let mut ctx: *mut c_void = null_mut();
        if unsafe { dav1d_open(&raw mut ctx, settings) } < 0 {
            return Err("dav1d: open failed".into());
        }
        Ok(ctx)
    }

    pub fn load(&mut self, obu: &[u8], frame_cnt: usize) {
        unsafe {
            self.active = if frame_cnt <= self.frame_delay {
                if self.lowlat.is_null() {
                    let s = Self::settings(self.threads, 1, (&raw const *self.pic_ctx).cast());
                    self.lowlat = Self::open(&s).unwrap_or_else(|e| fatal(e));
                }
                self.lowlat
            } else {
                self.ctx
            };
            dav1d_flush(self.active);
            let mut data = zeroed::<Data>();
            dav1d_data_wrap(
                &raw mut data,
                obu.as_ptr(),
                obu.len(),
                noop_free,
                null_mut(),
            );
            dav1d_send_data(self.active, &raw mut data);
        }
    }

    pub fn dec_next(&mut self) -> ([*const u8; 3], [i64; 3]) {
        unsafe {
            dav1d_picture_unref(&raw mut self.pic);
            let r = dav1d_get_picture(self.active, &raw mut self.pic);
            if r != 0 {
                cold_path();
                if r == DAV1D_ERR_AGAIN {
                    fatal(format_args!("dav1d: probe truncated"));
                }
                fatal(format_args!("dav1d: decode error {r}"));
            }
            let p = &self.pic;
            (
                [
                    p.data[0].cast::<u8>().cast_const(),
                    p.data[1].cast::<u8>().cast_const(),
                    p.data[2].cast::<u8>().cast_const(),
                ],
                [p.stride[0] as i64, p.stride[1] as i64, p.stride[1] as i64],
            )
        }
    }
}

impl Drop for Dav1dDec {
    fn drop(&mut self) {
        unsafe {
            dav1d_picture_unref(&raw mut self.pic);
            if !self.lowlat.is_null() {
                dav1d_close(&raw mut self.lowlat);
            }
            dav1d_close(&raw mut self.ctx);
        }
    }
}
