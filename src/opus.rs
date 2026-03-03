use std::{
    ffi::{CStr, CString, c_char, c_float, c_int},
    path::Path,
};

use crate::error::Xerr;

#[repr(C)]
struct OggOpusComments {
    _opaque: [u8; 0],
}

#[repr(C)]
struct OggOpusEnc {
    _opaque: [u8; 0],
}

const OPUS_SET_APPLICATION_REQUEST: c_int = 4000;
const OPUS_SET_BITRATE_REQUEST: c_int = 4002;
const OPUS_SET_VBR_REQUEST: c_int = 4006;
const OPUS_SET_VBR_CONSTRAINT_REQUEST: c_int = 4020;
const OPUS_SET_MAX_BANDWIDTH_REQUEST: c_int = 4004;
const OPUS_SET_COMPLEXITY_REQUEST: c_int = 4010;
const OPUS_APPLICATION_AUDIO: c_int = 2049;
const OPUS_BANDWIDTH_FULLBAND: c_int = 1105;

pub const FAMILY_MONO_STEREO: c_int = 0;
pub const FAMILY_SURROUND: c_int = 1;

unsafe extern "C" {
    fn ope_comments_create() -> *mut OggOpusComments;
    fn ope_comments_destroy(comments: *mut OggOpusComments);
    fn ope_encoder_create_file(
        path: *const c_char,
        comments: *mut OggOpusComments,
        rate: i32,
        channels: c_int,
        family: c_int,
        error: *mut c_int,
    ) -> *mut OggOpusEnc;
    fn ope_encoder_write_float(
        enc: *mut OggOpusEnc,
        pcm: *const c_float,
        samples_per_channel: c_int,
    ) -> c_int;
    fn ope_encoder_drain(enc: *mut OggOpusEnc) -> c_int;
    fn ope_encoder_destroy(enc: *mut OggOpusEnc);
    fn ope_encoder_ctl(enc: *mut OggOpusEnc, request: c_int, ...) -> c_int;
    fn ope_strerror(error: c_int) -> *const c_char;
}

fn check(code: c_int) -> Result<(), Xerr> {
    if code == 0 {
        return Ok(());
    }
    let msg = unsafe {
        let ptr = ope_strerror(code);
        if ptr.is_null() {
            "unknown opus error".to_owned()
        } else {
            CStr::from_ptr(ptr).to_string_lossy().into_owned()
        }
    };
    Err(msg.into())
}

pub struct Encoder {
    ptr: *mut OggOpusEnc,
}

impl Encoder {
    pub fn new(path: &Path, channels: u8, bitrate: u32, family: c_int) -> Result<Self, Xerr> {
        let path_str = path.to_str().ok_or("invalid audio output path")?;
        let c_path = CString::new(path_str).map_err(|e| e.to_string())?;

        let comments = unsafe { ope_comments_create() };
        if comments.is_null() {
            return Err("failed to create opus comments".into());
        }

        let mut error: c_int = 0;
        let ptr = unsafe {
            ope_encoder_create_file(
                c_path.as_ptr(),
                comments,
                48000,
                c_int::from(channels),
                family,
                &raw mut error,
            )
        };
        unsafe { ope_comments_destroy(comments) };

        if ptr.is_null() {
            return Err(format!("opus encoder failed (error {error})").into());
        }

        unsafe {
            check(ope_encoder_ctl(
                ptr,
                OPUS_SET_BITRATE_REQUEST,
                bitrate.cast_signed() * 1000,
            ))?;
            check(ope_encoder_ctl(ptr, OPUS_SET_VBR_REQUEST, 1i32))?;
            check(ope_encoder_ctl(ptr, OPUS_SET_VBR_CONSTRAINT_REQUEST, 0i32))?;
            check(ope_encoder_ctl(ptr, OPUS_SET_COMPLEXITY_REQUEST, 10i32))?;
            check(ope_encoder_ctl(
                ptr,
                OPUS_SET_MAX_BANDWIDTH_REQUEST,
                OPUS_BANDWIDTH_FULLBAND,
            ))?;
            check(ope_encoder_ctl(
                ptr,
                OPUS_SET_APPLICATION_REQUEST,
                OPUS_APPLICATION_AUDIO,
            ))?;
        }

        Ok(Self { ptr })
    }

    pub fn write_float(&mut self, pcm: &[f32], channels: usize) -> Result<(), Xerr> {
        check(unsafe {
            ope_encoder_write_float(self.ptr, pcm.as_ptr(), (pcm.len() / channels) as c_int)
        })
    }
}

impl Drop for Encoder {
    fn drop(&mut self) {
        unsafe {
            ope_encoder_drain(self.ptr);
            ope_encoder_destroy(self.ptr);
        }
    }
}
