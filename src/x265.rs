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
    slice::from_raw_parts,
    str::from_utf8_unchecked,
};

use crate::error::{eprint, fatal};
#[cfg(all(target_os = "linux", not(test)))]
use crate::fmath::FloatExt as _;

pub const X265_PARAM_SIZE: usize = 4736;
pub const X265_PIC_SIZE: usize = 17496;

pub const OFF_TOTAL_FRAMES: usize = 584;
pub const OFF_RF_CONSTANT: usize = 1456;
pub const OFF_SOURCE_BIT_DEPTH: usize = 4020;

const X265_CSP_I420: c_int = 1;
const X265_BIT_DEPTH: c_int = 10;

// x265_encoder_open is macro on X265_BUILD; bump is link error
#[link(name = "x265")]
unsafe extern "C" {
    fn x265_param_default_preset(p: *mut u8, preset: *const c_char, tune: *const c_char) -> c_int;
    fn x265_param_parse(p: *mut u8, name: *const c_char, value: *const c_char) -> c_int;
    fn x265_encoder_open_216(p: *mut u8) -> *mut c_void;
    fn xav_x265_setup(p: *mut u8);

    pub fn x265_encoder_headers(enc: *mut c_void, nal: *mut *mut X265Nal, n: *mut u32) -> c_int;

    pub fn x265_encoder_encode(
        enc: *mut c_void,
        nal: *mut *mut X265Nal,
        n: *mut u32,
        pic_in: *const X265Pic,
        pic_out: *mut X265Pic,
    ) -> c_int;

    pub fn x265_encoder_close(enc: *mut c_void);
}

#[repr(C)]
pub struct X265Nal {
    pub kind: u32,
    pub size_bytes: u32,
    pub payload: *mut u8,
}

const _: [(); 16] = [(); size_of::<X265Nal>()];

#[repr(C)]
pub struct PicHead {
    pub pts: i64,
    pub dts: i64,
    pub vbv_end_flag: c_int,
    _pad: c_int,
    pub user_data: *mut c_void,
    pub planes: [*mut c_void; 4],
    pub stride: [c_int; 4],
    pub bit_depth: c_int,
    pub slice_type: c_int,
    pub poc: c_int,
    pub color_space: c_int,
    pub forceqp: c_int,
}

const _: [(); 32] = [(); offset_of!(PicHead, planes)];
const _: [(); 64] = [(); offset_of!(PicHead, stride)];
const _: [(); 80] = [(); offset_of!(PicHead, bit_depth)];
const _: [(); 96] = [(); offset_of!(PicHead, forceqp)];

const PIC_HEAD: usize = size_of::<PicHead>();

const _: [(); 104] = [(); PIC_HEAD];

// x265_picture holds doubles and pointers: 8-align
#[repr(C, align(8))]
pub struct X265Pic {
    pub head: PicHead,
    _tail: [u8; X265_PIC_SIZE - PIC_HEAD],
}

const _: [(); X265_PIC_SIZE] = [(); size_of::<X265Pic>()];

impl X265Pic {
    // x265 never writes a pic it is handed; 1 for a worker for the run
    #[cold]
    #[inline(never)]
    #[must_use]
    pub fn boxed(y_stride: usize, c_stride: usize) -> Box<Self> {
        const L: Layout = Layout::new::<X265Pic>();
        unsafe {
            let p = alloc_zeroed(L).cast::<Self>();
            if p.is_null() {
                cold_path();
                handle_alloc_error(L);
            }
            let h = &raw mut (*p).head;
            (*h).bit_depth = X265_BIT_DEPTH;
            (*h).color_space = X265_CSP_I420;
            (*h).stride[0] = y_stride as c_int;
            (*h).stride[1] = c_stride as c_int;
            (*h).stride[2] = c_stride as c_int;
            Box::from_raw(p)
        }
    }

    #[inline(always)]
    pub const fn point(&mut self, base: *mut u8, y_sz: usize, cr_off: usize) {
        self.head.planes[0] = base.cast();
        self.head.planes[1] = unsafe { base.add(y_sz).cast() };
        self.head.planes[2] = unsafe { base.add(cr_off).cast() };
    }
}

const MSG_BUF: usize = 4096;

// x265 logs here; no line inside progs frame
#[cold]
#[inline(never)]
#[unsafe(no_mangle)]
pub extern "C" fn xav_x265_log(msg: *const c_char) {
    let raw = unsafe { from_raw_parts(msg.cast::<u8>(), MSG_BUF) };
    let n = raw.iter().position(|&c| c == 0).unwrap_or(MSG_BUF);
    eprint(format_args!(
        "{}",
        text(unsafe { raw.get_unchecked(..n) }).trim_end()
    ));
}

// x265_param holds doubles and pointers: 8-align
#[repr(C, align(8))]
struct ParamBuf([u8; X265_PARAM_SIZE]);

const _: [(); 0] = [(); X265_PARAM_SIZE % size_of::<u64>()];

#[inline]
pub const fn x265_frames(p: *mut u8, n: usize) {
    unsafe { p.add(OFF_TOTAL_FRAMES).cast::<c_int>().write(n as c_int) };
}

#[inline]
pub fn x265_crf(p: *mut u8, crf: f32) {
    unsafe {
        p.add(OFF_RF_CONSTANT)
            .cast::<f64>()
            .write((f64::from(crf) * 100.0).round() / 100.0);
    }
}

fn nul(b: &[u8]) -> usize {
    unsafe { b.iter().position(|&c| c == 0).unwrap_unchecked() }
}

const fn text(b: &[u8]) -> &str {
    unsafe { from_utf8_unchecked(b) }
}

#[cold]
#[inline(never)]
pub fn x265_parse(dst: *mut u8, preset: &[u8], tune: &[u8], args: &[u8], zone: &[u8]) {
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
    if unsafe { x265_param_default_preset(dst, pp, tp) } < 0 {
        cold_path();
        fatal("x265: unknown preset or tune");
    }

    for mut p in [args, zone] {
        while !p.is_empty() {
            let n = nul(p);
            let (name, rest) = unsafe { (p.get_unchecked(..n), p.get_unchecked(n + 1..)) };
            let m = nul(rest);
            let val = unsafe { rest.get_unchecked(..m) };
            if unsafe { x265_param_parse(dst, name.as_ptr().cast(), val.as_ptr().cast()) } != 0 {
                cold_path();
                fatal(format_args!(
                    "x265: rejected --{} {}",
                    text(name),
                    text(val)
                ));
            }
            p = unsafe { rest.get_unchecked(m + 1..) };
        }
    }

    // no param 4 inp depth; field is interface; last wins
    unsafe { dst.add(OFF_SOURCE_BIT_DEPTH).cast::<c_int>().write(10) };
}

#[cold]
#[inline(never)]
pub fn x265_simd(tmpl: &[u8]) {
    let mut p = MaybeUninit::<ParamBuf>::uninit();
    let d = p.as_mut_ptr().cast::<u8>();
    unsafe {
        copy_nonoverlapping(tmpl.as_ptr(), d, X265_PARAM_SIZE);
        xav_x265_setup(d);
    }
}

pub fn x265_open(tmpl: &[u8], frames: usize, crf: Option<f32>) -> *mut c_void {
    let mut p = MaybeUninit::<ParamBuf>::uninit();
    let d = p.as_mut_ptr().cast::<u8>();
    unsafe { copy_nonoverlapping(tmpl.as_ptr(), d, X265_PARAM_SIZE) };
    x265_frames(d, frames);
    if let Some(c) = crf {
        x265_crf(d, c);
    }

    let enc = unsafe { x265_encoder_open_216(d) };
    if enc.is_null() {
        cold_path();
        fatal("x265_encoder_open failed");
    }
    enc
}
