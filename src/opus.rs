#[cfg(target_os = "linux")]
use alloc::{string::String, vec::Vec};
use core::ffi::{CStr, c_char, c_int};

use crate::{byte_range::ByteRange, error::Xerr};

const FS: i32 = 48000;
pub const FRAME: usize = 960;

const APPLICATION_AUDIO: c_int = 2049;
const BANDWIDTH_FULLBAND: c_int = 1105;
const SET_BITRATE: c_int = 4002;
const SET_MAX_BANDWIDTH: c_int = 4004;
const SET_VBR: c_int = 4006;
const SET_COMPLEXITY: c_int = 4010;
const SET_VBR_CONSTRAINT: c_int = 4020;
const GET_LOOKAHEAD: c_int = 4027;

#[repr(C)]
struct OpusEncoder {
    _opaque: [u8; 0],
}

#[repr(C)]
struct OpusMSEncoder {
    _opaque: [u8; 0],
}

unsafe extern "C" {
    fn opus_encoder_create(fs: i32, ch: c_int, app: c_int, err: *mut c_int) -> *mut OpusEncoder;
    fn opus_encode_float(
        st: *mut OpusEncoder,
        pcm: *const f32,
        n: c_int,
        data: *mut u8,
        max: i32,
    ) -> i32;
    fn opus_encoder_ctl(st: *mut OpusEncoder, req: c_int, ...) -> c_int;
    fn opus_encoder_destroy(st: *mut OpusEncoder);
    fn opus_multistream_surround_encoder_create(
        fs: i32,
        ch: c_int,
        family: c_int,
        streams: *mut c_int,
        coupled: *mut c_int,
        mapping: *mut u8,
        app: c_int,
        err: *mut c_int,
    ) -> *mut OpusMSEncoder;
    fn opus_multistream_encode_float(
        st: *mut OpusMSEncoder,
        pcm: *const f32,
        n: c_int,
        data: *mut u8,
        max: i32,
    ) -> i32;
    fn opus_multistream_encoder_ctl(st: *mut OpusMSEncoder, req: c_int, ...) -> c_int;
    fn opus_multistream_encoder_destroy(st: *mut OpusMSEncoder);
    fn opus_strerror(err: c_int) -> *const c_char;
    fn opus_get_version_string() -> *const c_char;
}

pub fn version() -> String {
    unsafe {
        CStr::from_ptr(opus_get_version_string())
            .to_string_lossy()
            .into_owned()
    }
}

fn oerr(code: c_int) -> Xerr {
    unsafe { CStr::from_ptr(opus_strerror(code)) }
        .to_string_lossy()
        .into_owned()
        .into()
}

pub struct OpusPacket {
    pub range: ByteRange,
    pub samples: u32,
}

pub struct OpusStream {
    pub head: Vec<u8>,
    pub pre_skip: u16,
    pub channels: u8,
    pub packets: Vec<OpusPacket>,
}

enum Backend {
    Mono(*mut OpusEncoder),
    Multi(*mut OpusMSEncoder),
}

pub struct Encoder {
    backend: Backend,
    pre_skip: u16,
    channels: u8,
    family: u8,
    streams: u8,
    coupled: u8,
    mapping: [u8; 8],
}

impl Encoder {
    pub fn new(channels: u8, brate: u16) -> Result<Self, Xerr> {
        let ch = c_int::from(channels);
        let mut err: c_int = 0;
        let (backend, family, streams, coupled, mapping) = if channels <= 2 {
            let p = unsafe { opus_encoder_create(FS, ch, APPLICATION_AUDIO, &raw mut err) };
            if p.is_null() {
                return Err(oerr(err));
            }
            (Backend::Mono(p), 0u8, 0u8, 0u8, [0u8; 8])
        } else {
            let mut s: c_int = 0;
            let mut c: c_int = 0;
            let mut m = [0u8; 8];
            let p = unsafe {
                opus_multistream_surround_encoder_create(
                    FS,
                    ch,
                    1,
                    &raw mut s,
                    &raw mut c,
                    m.as_mut_ptr(),
                    APPLICATION_AUDIO,
                    &raw mut err,
                )
            };
            if p.is_null() {
                return Err(oerr(err));
            }
            (Backend::Multi(p), 1u8, s as u8, c as u8, m)
        };
        let mut e = Self {
            backend,
            pre_skip: 0,
            channels,
            family,
            streams,
            coupled,
            mapping,
        };
        e.set(SET_BITRATE, c_int::from(brate) * 1000)?;
        e.set(SET_VBR, 1)?;
        e.set(SET_VBR_CONSTRAINT, 0)?;
        e.set(SET_COMPLEXITY, 10)?;
        e.set(SET_MAX_BANDWIDTH, BANDWIDTH_FULLBAND)?;
        e.pre_skip = e.lookahead()? as u16;
        Ok(e)
    }

    pub fn head(&self) -> Vec<u8> {
        build_head(
            self.channels,
            self.pre_skip,
            self.family,
            self.streams,
            self.coupled,
            &self.mapping,
        )
    }

    fn set(&self, req: c_int, val: c_int) -> Result<(), Xerr> {
        let r = unsafe {
            match self.backend {
                Backend::Mono(p) => opus_encoder_ctl(p, req, val),
                Backend::Multi(p) => opus_multistream_encoder_ctl(p, req, val),
            }
        };
        if r == 0 { Ok(()) } else { Err(oerr(r)) }
    }

    fn lookahead(&self) -> Result<c_int, Xerr> {
        let mut out: c_int = 0;
        let r = unsafe {
            match self.backend {
                Backend::Mono(p) => opus_encoder_ctl(p, GET_LOOKAHEAD, &raw mut out),
                Backend::Multi(p) => opus_multistream_encoder_ctl(p, GET_LOOKAHEAD, &raw mut out),
            }
        };
        if r == 0 { Ok(out) } else { Err(oerr(r)) }
    }

    pub fn encode(&mut self, pcm: &[f32], out: &mut [u8]) -> Result<usize, Xerr> {
        let len = unsafe {
            match self.backend {
                Backend::Mono(p) => opus_encode_float(
                    p,
                    pcm.as_ptr(),
                    FRAME as c_int,
                    out.as_mut_ptr(),
                    out.len() as i32,
                ),
                Backend::Multi(p) => opus_multistream_encode_float(
                    p,
                    pcm.as_ptr(),
                    FRAME as c_int,
                    out.as_mut_ptr(),
                    out.len() as i32,
                ),
            }
        };
        if len < 0 {
            return Err(oerr(len));
        }
        Ok(len as usize)
    }
}

impl Drop for Encoder {
    fn drop(&mut self) {
        unsafe {
            match self.backend {
                Backend::Mono(p) => opus_encoder_destroy(p),
                Backend::Multi(p) => opus_multistream_encoder_destroy(p),
            }
        }
    }
}

fn build_head(
    channels: u8,
    pre_skip: u16,
    family: u8,
    streams: u8,
    coupled: u8,
    mapping: &[u8],
) -> Vec<u8> {
    let mut h = Vec::with_capacity(if family == 0 {
        19
    } else {
        21 + channels as usize
    });
    h.extend_from_slice(b"OpusHead");
    h.push(1);
    h.push(channels);
    h.extend_from_slice(&pre_skip.to_le_bytes());
    h.extend_from_slice(&(FS as u32).to_le_bytes());
    h.extend_from_slice(&0i16.to_le_bytes());
    h.push(family);
    if family != 0 {
        h.push(streams);
        h.push(coupled);
        h.extend_from_slice(&mapping[..channels as usize]);
    }
    h
}

pub fn read(buf: &[u8]) -> OpusStream {
    let hl = u16::from_le_bytes(unsafe { [*buf.get_unchecked(0), *buf.get_unchecked(1)] }) as usize;
    let head = unsafe { buf.get_unchecked(2..2 + hl) }.to_vec();
    let channels = unsafe { *head.get_unchecked(9) };
    let pre_skip =
        u16::from_le_bytes(unsafe { [*head.get_unchecked(10), *head.get_unchecked(11)] });
    let mut packets = Vec::new();
    let mut pos = 2 + hl;
    while pos < buf.len() {
        let len =
            u16::from_le_bytes(unsafe { [*buf.get_unchecked(pos), *buf.get_unchecked(pos + 1)] })
                as usize;
        pos += 2;
        packets.push(OpusPacket {
            range: ByteRange { offset: pos, len },
            samples: FRAME as u32,
        });
        pos += len;
    }
    OpusStream {
        head,
        pre_skip,
        channels,
        packets,
    }
}
