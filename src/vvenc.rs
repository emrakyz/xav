use alloc::vec::Vec;
use core::{
    ffi::{c_char, c_int, c_void},
    hint::cold_path,
    mem::{MaybeUninit, offset_of, size_of},
    ptr::{copy_nonoverlapping, null_mut},
    slice::from_raw_parts,
    str::from_utf8_unchecked,
};

use crate::error::{eprint, fatal};

// build.rs asserts this against vvencCfg.h
pub const VVENC_CFG_SIZE: usize = 47312;
pub const VVENC_TQ_HDR: usize = size_of::<u64>();

const _: [(); 0] = [(); VVENC_CFG_SIZE % VVENC_TQ_HDR];

pub const VVENC_OK: c_int = 0;
const VVENC_WARNING: c_int = 2;
// VVENC_MAX_STRING_LEN: vvenc's own bound on any string it emits
const MSG_BUF: usize = 1024;

// leading fields of vvenc_config; the rest arrives through vvenc_set_param_list
#[repr(C)]
struct CfgHead {
    source_width: i32,
    source_height: i32,
    frame_rate: i32,
    frame_scale: i32,
    ticks_per_second: i32,
    frames_to_be_encoded: i32,
    input_bit_depth: [i32; 2],
    num_threads: i32,
    qp: i32,
}

const _: [(); 20] = [(); offset_of!(CfgHead, frames_to_be_encoded)];
const _: [(); 36] = [(); offset_of!(CfgHead, qp)];

#[repr(C)]
pub struct VvencYuvPlane {
    pub ptr: *mut i16,
    pub width: i32,
    pub height: i32,
    pub stride: i32,
}

#[repr(C)]
pub struct VvencYuvBuffer {
    pub planes: [VvencYuvPlane; 3],
    pub sequence_number: u64,
    pub cts: i64,
    pub cts_valid: bool,
}

#[repr(C)]
pub struct VvencAccessUnit {
    pub payload: *mut u8,
    pub payload_size: c_int,
    pub payload_used_size: c_int,
    pub cts: i64,
    pub dts: i64,
    pub cts_valid: bool,
    pub dts_valid: bool,
    pub rap: bool,
    pub slice_type: c_int,
    pub ref_pic: bool,
    pub temporal_layer: c_int,
    pub poc: u64,
    pub status: c_int,
    pub essential_bytes: c_int,
    pub info_string: [u8; 1024],
}

const _: [(); 96] = [(); size_of::<VvencYuvBuffer>()];
const _: [(); 1088] = [(); size_of::<VvencAccessUnit>()];

type MsgCb = unsafe extern "C" fn(*mut c_void, c_int, *const c_char, *mut c_void);

unsafe extern "C" {
    fn vsnprintf(s: *mut c_char, n: usize, fmt: *const c_char, ap: *mut c_void) -> c_int;
}

#[link(name = "vvenc")]
unsafe extern "C" {
    fn vvenc_config_default(cfg: *mut u8);
    fn vvenc_set_param_list(cfg: *mut u8, argc: c_int, argv: *mut *mut c_char) -> c_int;
    fn vvenc_init_config_parameter(cfg: *mut u8) -> bool;
    fn vvenc_set_msg_callback(cfg: *mut u8, ctx: *mut c_void, cb: Option<MsgCb>);
    fn vvenc_set_SIMD_extension(id: *const c_char) -> *const c_char;
    fn vvenc_encoder_create() -> *mut c_void;
    fn vvenc_encoder_open(enc: *mut c_void, cfg: *mut u8) -> c_int;

    pub fn vvenc_encode(
        enc: *mut c_void,
        yuv: *mut VvencYuvBuffer,
        au: *mut VvencAccessUnit,
        done: *mut bool,
    ) -> c_int;

    pub fn vvenc_encoder_close(enc: *mut c_void) -> c_int;
}

// x86 feature detection and the SIMD dispatch tables are process-wide
#[cold]
#[inline(never)]
pub fn vvenc_simd() {
    unsafe { vvenc_set_SIMD_extension(c"".as_ptr()) };
}

#[cold]
#[inline(never)]
unsafe extern "C" fn msg_cb(_: *mut c_void, level: c_int, fmt: *const c_char, ap: *mut c_void) {
    if level > VVENC_WARNING {
        return;
    }
    let mut buf = [0u8; MSG_BUF];
    let n = unsafe { vsnprintf(buf.as_mut_ptr().cast(), MSG_BUF, fmt, ap) };
    if n > 0 {
        let raw = unsafe { from_raw_parts(buf.as_ptr(), (n as usize).min(MSG_BUF - 1)) };
        let msg = unsafe { from_utf8_unchecked(raw) };
        eprint(format_args!("{}", msg.trim_end()));
    }
}

// `args` and `zone`: NUL-separated argv arenas holding `argc` tokens between them
#[cold]
#[inline(never)]
pub fn vvenc_parse(dst: *mut u8, args: &[u8], zone: &[u8], argc: usize) {
    unsafe {
        vvenc_config_default(dst);
        vvenc_set_msg_callback(dst, null_mut(), Some(msg_cb));
    }

    let mut argv: Vec<*mut c_char> = Vec::with_capacity(argc);
    argv.extend(
        args.split(|&b| b == 0)
            .chain(zone.split(|&b| b == 0))
            .filter(|a| !a.is_empty())
            .map(|a| a.as_ptr().cast_mut().cast::<c_char>()),
    );

    let ret = unsafe { vvenc_set_param_list(dst, argv.len() as c_int, argv.as_mut_ptr()) };
    if ret != VVENC_OK {
        cold_path();
        fatal(format_args!("vvenc: bad encoder parameter ({ret})"));
    }
}

#[inline]
pub fn vvenc_qp(dst: *mut u8, qp: i32) {
    unsafe { (*dst.cast::<CfgHead>()).qp = qp };
}

#[cold]
#[inline(never)]
pub fn vvenc_derive(dst: *mut u8) {
    if unsafe { vvenc_init_config_parameter(dst) } {
        cold_path();
        fatal("vvenc: inconsistent encoder configuration");
    }
    unsafe { vvenc_set_msg_callback(dst, null_mut(), None) };
}

// vvenc_config holds doubles and pointers: the copy the encoder reads must be 8-aligned
#[repr(C, align(8))]
struct CfgBuf([u8; VVENC_CFG_SIZE]);

pub fn vvenc_open(tmpl: &[u8], frames: usize) -> *mut c_void {
    let mut cfg = MaybeUninit::<CfgBuf>::uninit();
    let p = cfg.as_mut_ptr().cast::<u8>();
    unsafe {
        copy_nonoverlapping(tmpl.as_ptr(), p, VVENC_CFG_SIZE);
        (*p.cast::<CfgHead>()).frames_to_be_encoded = frames as i32;
    }

    let enc = unsafe { vvenc_encoder_create() };
    let ret = unsafe { vvenc_encoder_open(enc, p) };
    if ret != VVENC_OK {
        cold_path();
        fatal(format_args!("vvenc_encoder_open failed: {ret}"));
    }
    enc
}
