use std::{
    ffi::{c_int, c_void},
    hint::cold_path,
    mem::zeroed,
    ptr::null_mut,
};

use crate::{Xerr, error::fatal};

const DAV1D_ERR_AGAIN: c_int = -11;

#[repr(C, align(8))]
struct Settings {
    n_threads: c_int,
    max_frame_delay: c_int,
    _rest: [u8; 88],
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
    _rest: [u8; 216],
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
    ctx: *mut c_void,
    lowlat: *mut c_void,
    active: *mut c_void,
    frame_delay: usize,
    threads: i32,
    pic: Picture,
}

impl Dav1dDec {
    pub fn new(threads: i32) -> Result<Self, Xerr> {
        let (ctx, frame_delay) = Self::open(threads, 0)?;
        Ok(Self {
            ctx,
            lowlat: null_mut(),
            active: ctx,
            frame_delay,
            threads,
            pic: unsafe { zeroed() },
        })
    }

    fn open(threads: i32, max_frame_delay: c_int) -> Result<(*mut c_void, usize), Xerr> {
        unsafe {
            let mut settings = zeroed::<Settings>();
            dav1d_default_settings(&raw mut settings);
            settings.n_threads = threads.min(256);
            settings.max_frame_delay = max_frame_delay;
            let frame_delay = dav1d_get_frame_delay(&raw const settings).max(1) as usize;

            let mut ctx: *mut c_void = null_mut();
            if dav1d_open(&raw mut ctx, &raw const settings) < 0 {
                return Err("dav1d: open failed".into());
            }
            Ok((ctx, frame_delay))
        }
    }

    pub fn load(&mut self, obu: &[u8], frame_cnt: usize) {
        unsafe {
            self.active = if frame_cnt <= self.frame_delay {
                if self.lowlat.is_null() {
                    self.lowlat = Self::open(self.threads, 1).unwrap_or_else(|e| fatal(e)).0;
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
