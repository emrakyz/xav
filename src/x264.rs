use alloc::{
    alloc::{alloc_zeroed, handle_alloc_error},
    boxed::Box,
};
use core::{
    alloc::Layout,
    ffi::{c_char, c_int, c_void},
    hint::cold_path,
    mem::{MaybeUninit, offset_of, size_of},
    ptr::{copy_nonoverlapping, null},
};

use crate::{
    error::fatal,
    h26x::{log, parse_pairs},
};

pub const X264_PARAM_SIZE: usize = 1024;
pub const X264_PIC_SIZE: usize = 240;

pub const OFF_WIDTH: usize = 28;
pub const OFF_FRAME_TOTAL: usize = 48;
pub const OFF_LOG_LEVEL: usize = 528;
#[cfg(feature = "vship")]
pub const OFF_RF_CONSTANT: usize = 680;

const X264_CSP_I420: c_int = 0x0002;
const X264_CSP_HIGH_DEPTH: c_int = 0x2000;
const X264_LOG_WARNING: c_int = 1;
const X264_PLANES: c_int = 3;

// x264_encoder_open is macro on X264_BUILD; bump is link error
#[link(name = "x264")]
unsafe extern "C" {
    fn x264_param_default_preset(p: *mut u8, preset: *const c_char, tune: *const c_char) -> c_int;
    fn x264_param_parse(p: *mut u8, name: *const c_char, value: *const c_char) -> c_int;
    fn x264_encoder_open_165(p: *mut u8) -> *mut c_void;
    fn xav_x264_setup(p: *mut u8);

    pub fn x264_encoder_encode(
        enc: *mut c_void,
        nal: *mut *mut X264Nal,
        n: *mut c_int,
        pic_in: *mut X264Pic,
        pic_out: *mut X264Pic,
    ) -> c_int;

    pub fn x264_encoder_close(enc: *mut c_void);
}

#[repr(C)]
pub struct X264Nal {
    pub ref_idc: c_int,
    pub kind: c_int,
    pub long_startcode: c_int,
    pub first_mb: c_int,
    pub last_mb: c_int,
    pub payload_sz: c_int,
    pub payload: *mut u8,
    pub padding: c_int,
}

const _: [(); 40] = [(); size_of::<X264Nal>()];
const _: [(); 24] = [(); offset_of!(X264Nal, payload)];

#[repr(C)]
pub struct PicHead {
    pub kind: c_int,
    pub qpplus1: c_int,
    pub pic_struct: c_int,
    pub keyframe: c_int,
    pub pts: i64,
    pub dts: i64,
    pub param: *mut c_void,
    pub color_space: c_int,
    pub plane_cnt: c_int,
    pub stride: [c_int; 4],
    pub planes: [*mut c_void; 4],
}

const _: [(); 16] = [(); offset_of!(PicHead, pts)];
const _: [(); 40] = [(); offset_of!(PicHead, color_space)];
const _: [(); 48] = [(); offset_of!(PicHead, stride)];
const _: [(); 64] = [(); offset_of!(PicHead, planes)];

const PIC_HEAD: usize = size_of::<PicHead>();

const _: [(); 96] = [(); PIC_HEAD];

// x264_picture holds doubles and pointers: 8-align
#[repr(C, align(8))]
pub struct X264Pic {
    pub head: PicHead,
    _tail: [u8; X264_PIC_SIZE - PIC_HEAD],
}

const _: [(); X264_PIC_SIZE] = [(); size_of::<X264Pic>()];

// x264 fills pic_out per frame; never takes a null; 1 pair for a worker
#[repr(C, align(8))]
pub struct X264Pics {
    pub inp: X264Pic,
    pub out: X264Pic,
}

impl X264Pics {
    #[cold]
    #[inline(never)]
    #[must_use]
    pub fn boxed(y_stride: usize, c_stride: usize) -> Box<Self> {
        const L: Layout = Layout::new::<X264Pics>();
        unsafe {
            let p = alloc_zeroed(L).cast::<Self>();
            if p.is_null() {
                cold_path();
                handle_alloc_error(L);
            }
            // zeroed is x264_picture_init: AUTO type, AUTO qp, AUTO pic_struct
            let h = &raw mut (*p).inp.head;
            (*h).color_space = X264_CSP_I420 | X264_CSP_HIGH_DEPTH;
            (*h).plane_cnt = X264_PLANES;
            (*h).stride[0] = y_stride as c_int;
            (*h).stride[1] = c_stride as c_int;
            (*h).stride[2] = c_stride as c_int;
            Box::from_raw(p)
        }
    }

    #[inline(always)]
    pub const fn point(&mut self, base: *mut u8, y_sz: usize, cr_off: usize) {
        let h = &mut self.inp.head;
        h.planes[0] = base.cast();
        h.planes[1] = unsafe { base.add(y_sz).cast() };
        h.planes[2] = unsafe { base.add(cr_off).cast() };
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn xav_x264_log(msg: *const c_char, len: c_int) {
    log(msg, len as usize);
}

// x264_param holds doubles and pointers: 8-align
#[repr(C, align(8))]
struct ParamBuf([u8; X264_PARAM_SIZE]);

const _: [(); 0] = [(); X264_PARAM_SIZE % size_of::<u64>()];

#[inline]
pub const fn x264_frames(p: *mut u8, n: usize) {
    unsafe { p.add(OFF_FRAME_TOTAL).cast::<c_int>().write(n as c_int) };
}

#[cfg(feature = "vship")]
#[inline]
pub const fn x264_crf(p: *mut u8, crf: f32) {
    unsafe { p.add(OFF_RF_CONSTANT).cast::<f32>().write(crf) };
}

#[cold]
#[inline(never)]
pub fn x264_parse(
    dst: *mut u8,
    preset: &[u8],
    tune: &[u8],
    args: &[u8],
    zone: &[u8],
    res: [u32; 2],
) {
    let pp = if preset.is_empty() {
        null()
    } else {
        preset.as_ptr().cast::<c_char>()
    };
    let tp = if tune.is_empty() {
        null()
    } else {
        tune.as_ptr().cast::<c_char>()
    };
    if unsafe { x264_param_default_preset(dst, pp, tp) } < 0 {
        cold_path();
        fatal("x264: unknown preset or tune");
    }

    parse_pairs(dst, [args, zone], x264_param_parse, "x264");

    // csp & depth = fixed by config flags; no param reaches these
    unsafe {
        let d = dst.add(OFF_WIDTH).cast::<c_int>();
        d.write(res[0] as c_int);
        d.add(1).write(res[1] as c_int);
        dst.add(OFF_LOG_LEVEL)
            .cast::<c_int>()
            .write(X264_LOG_WARNING);
    }
}

// dispatch tables = process wide; every open copies them
#[cold]
#[inline(never)]
pub fn x264_simd(tmpl: &[u64]) {
    let mut p = MaybeUninit::<ParamBuf>::uninit();
    let d = p.as_mut_ptr().cast::<u8>();
    unsafe {
        copy_nonoverlapping(tmpl.as_ptr().cast::<u8>(), d, X264_PARAM_SIZE);
        xav_x264_setup(d);
    }
}

#[inline]
pub fn x264_open(d: *mut u8, frames: usize) -> *mut c_void {
    x264_frames(d, frames);
    let enc = unsafe { x264_encoder_open_165(d) };
    if enc.is_null() {
        cold_path();
        fatal("x264_encoder_open failed");
    }
    enc
}
