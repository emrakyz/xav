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
    _rest: [u8; 92],
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
    pic: Picture,
}

impl Dav1dDec {
    pub fn new(threads: i32) -> Result<Self, Xerr> {
        unsafe {
            let mut settings = zeroed::<Settings>();
            dav1d_default_settings(&raw mut settings);
            settings.n_threads = threads.min(256);

            let mut ctx: *mut c_void = null_mut();
            if dav1d_open(&raw mut ctx, &raw const settings) < 0 {
                return Err("dav1d: open failed".into());
            }
            Ok(Self { ctx, pic: zeroed() })
        }
    }

    pub fn load(&mut self, obu: &[u8]) {
        unsafe {
            dav1d_flush(self.ctx);
            let mut data = zeroed::<Data>();
            dav1d_data_wrap(
                &raw mut data,
                obu.as_ptr(),
                obu.len(),
                noop_free,
                null_mut(),
            );
            dav1d_send_data(self.ctx, &raw mut data);
        }
    }

    pub fn dec_next(&mut self) -> ([*const u8; 3], [i64; 3]) {
        unsafe {
            dav1d_picture_unref(&raw mut self.pic);
            let r = dav1d_get_picture(self.ctx, &raw mut self.pic);
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
            dav1d_close(&raw mut self.ctx);
        }
    }
}
