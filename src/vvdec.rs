use alloc::boxed::Box;
use core::{
    ffi::{c_int, c_void},
    hint::cold_path,
    mem::zeroed,
    ptr::{null, null_mut},
    slice::from_raw_parts,
};

use crate::{Xerr, error::fatal, nal_scan::find_start_code, vship::PinPool};

// VVDEC_MAX_NUM_COMPONENT; 1 pool class per plane tagged in handle low bits
// pinned alloc page alignment leaves free
const PLANES: usize = 3;
const PLANE_TAG: usize = PLANES.next_power_of_two() - 1;

const VVDEC_OK: c_int = 0;
const VVDEC_TRY_AGAIN: c_int = -40;
const VVDEC_EOF: c_int = -50;

#[repr(C)]
struct Params {
    threads: c_int,
    parse_delay: c_int,
    log_level: c_int,
    verify_picture_hash: bool,
    film_grain_synthesis: bool,
    simd: c_int,
    opaque: *mut c_void,
    err_handling_flags: c_int,
    _reserved: [i32; 4],
}

#[repr(C)]
struct Au {
    payload: *mut u8,
    payload_size: c_int,
    payload_used_size: c_int,
    cts: u64,
    dts: u64,
    cts_valid: bool,
    dts_valid: bool,
    rap: bool,
}

#[repr(C)]
struct Plane {
    ptr: *mut u8,
    _dim: [u32; 2],
    stride: u32,
    _bps: u32,
    _alloc: *mut c_void,
}

#[repr(C)]
struct Frame {
    planes: [Plane; PLANES],
    _rest: [u8; 56],
}

type CreateCb = unsafe extern "C" fn(*mut c_void, c_int, u32, u32, *mut *mut c_void) -> *mut c_void;
type UnrefCb = unsafe extern "C" fn(*mut c_void, *mut c_void);

#[link(name = "vvdec")]
unsafe extern "C" {
    fn vvdec_params_default(p: *mut Params);
    fn vvdec_decoder_open_with_allocator(
        p: *mut Params,
        create: CreateCb,
        unref: UnrefCb,
    ) -> *mut c_void;
    fn vvdec_decoder_close(d: *mut c_void) -> c_int;
    fn vvdec_decode(d: *mut c_void, au: *mut Au, frame: *mut *mut Frame) -> c_int;
    fn vvdec_flush(d: *mut c_void, frame: *mut *mut Frame) -> c_int;
    fn vvdec_frame_unref(d: *mut c_void, frame: *mut Frame) -> c_int;
}

unsafe extern "C" fn buf_create(
    ctx: *mut c_void,
    comp: c_int,
    size: u32,
    _: u32,
    handle: *mut *mut c_void,
) -> *mut c_void {
    let cls = comp as usize;
    let base = unsafe { &*ctx.cast::<PinPool<PLANES>>() }.get(cls, || size as usize);
    unsafe { *handle = base.add(cls).cast() };
    base.cast()
}

unsafe extern "C" fn buf_unref(ctx: *mut c_void, handle: *mut c_void) {
    let h = handle.cast::<u8>();
    let cls = h.addr() & PLANE_TAG;
    unsafe { &*ctx.cast::<PinPool<PLANES>>() }.put(cls, h.wrapping_sub(cls));
}

pub struct VvdecDec {
    _pool: Box<PinPool<PLANES>>,
    dec: *mut c_void,
    frame: *mut Frame,
    au: Au,
    data: *const u8,
    len: usize,
    pos: usize,
    active: bool,
}

impl VvdecDec {
    pub fn new(threads: i32) -> Result<Self, Xerr> {
        let mut pool = Box::new(PinPool::new());
        let dec = unsafe {
            let mut p = zeroed::<Params>();
            vvdec_params_default(&raw mut p);
            p.threads = threads;
            p.film_grain_synthesis = false;
            p.opaque = (&raw mut *pool).cast();
            vvdec_decoder_open_with_allocator(&raw mut p, buf_create, buf_unref)
        };
        if dec.is_null() {
            return Err("vvdec: open failed".into());
        }
        Ok(Self {
            _pool: pool,
            dec,
            frame: null_mut(),
            au: unsafe { zeroed() },
            data: null(),
            len: 0,
            pos: 0,
            active: false,
        })
    }

    pub fn load(&mut self, bs: &[u8], _: usize) {
        if self.active {
            self.drain();
        }
        self.data = bs.as_ptr();
        self.len = bs.len();
        self.pos = 0;
        self.active = true;
    }

    // flush to EOF so the next decode call restarts the decoder state
    fn drain(&mut self) {
        self.unref();
        loop {
            let mut f: *mut Frame = null_mut();
            let r = unsafe { vvdec_flush(self.dec, &raw mut f) };
            if f.is_null() {
                return;
            }
            unsafe { vvdec_frame_unref(self.dec, f) };
            if r != VVDEC_OK {
                return;
            }
        }
    }

    fn unref(&mut self) {
        if !self.frame.is_null() {
            unsafe { vvdec_frame_unref(self.dec, self.frame) };
            self.frame = null_mut();
        }
    }

    // annex-b -> the next start code ends this nal
    fn nal_end(&self) -> usize {
        let raw = unsafe { from_raw_parts(self.data, self.len) };
        find_start_code(raw, self.pos + 3).map_or(self.len, |sc| {
            sc - usize::from(unsafe { *raw.get_unchecked(sc - 1) } == 0)
        })
    }

    pub fn dec_next(&mut self) -> ([*const u8; 3], [i64; 3]) {
        self.unref();
        loop {
            let mut f: *mut Frame = null_mut();
            let r = if self.pos < self.len {
                let end = self.nal_end();
                self.au.payload = unsafe { self.data.add(self.pos).cast_mut() };
                self.au.payload_size = (end - self.pos) as c_int;
                self.au.payload_used_size = self.au.payload_size;
                self.pos = end;
                unsafe { vvdec_decode(self.dec, &raw mut self.au, &raw mut f) }
            } else {
                unsafe { vvdec_flush(self.dec, &raw mut f) }
            };

            if !f.is_null() {
                self.frame = f;
                let p = unsafe { &(*f).planes };
                return (
                    [
                        p[0].ptr.cast_const(),
                        p[1].ptr.cast_const(),
                        p[2].ptr.cast_const(),
                    ],
                    [
                        i64::from(p[0].stride),
                        i64::from(p[1].stride),
                        i64::from(p[1].stride),
                    ],
                );
            }

            if r == VVDEC_EOF {
                cold_path();
                fatal(format_args!("vvdec: probe truncated"));
            }
            if r < 0 && r != VVDEC_TRY_AGAIN {
                cold_path();
                fatal(format_args!("vvdec: decode error {r}"));
            }
        }
    }
}

impl Drop for VvdecDec {
    fn drop(&mut self) {
        self.unref();
        unsafe { vvdec_decoder_close(self.dec) };
    }
}
