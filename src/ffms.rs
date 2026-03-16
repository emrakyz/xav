use std::{
    ffi::{CStr, CString, c_char, c_int, c_uint, c_void},
    path::Path,
    ptr::{addr_of_mut, copy_nonoverlapping, null, null_mut},
    slice::{from_raw_parts, from_raw_parts_mut},
    sync::Mutex,
    thread::available_parallelism,
};

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
use crate::avx2::{
    PACK_CHUNK, SHIFT_CHUNK, conv_to_10b, deint_nv12, deint_nv12_to_10b, deint_p010, pack_10b,
    shift_p010, shift_p010_rem,
};
#[cfg(target_feature = "avx512bw")]
use crate::avx512::{
    PACK_CHUNK, SHIFT_CHUNK, conv_to_10b, deint_nv12, deint_nv12_to_10b, deint_p010, pack_10b,
    shift_p010, shift_p010_rem,
};
#[cfg(not(any(target_feature = "avx2", target_feature = "avx512bw")))]
use crate::scalar::{
    PACK_CHUNK, SHIFT_CHUNK, conv_to_10b, deint_nv12, deint_nv12_to_10b, deint_p010, pack_10b,
    shift_p010, shift_p010_rem,
};
use crate::{
    Xerr,
    decode::CropCalc,
    error::Xerr::Msg,
    ffms::DecodeStrat::{
        B8Crop, B8CropFast, B8CropStride, B8Fast, B8Stride, B10Crop, B10CropFast,
        B10CropFastRem, B10CropRem, B10CropStride, B10CropStrideRem, B10Fast, B10FastRem,
        B10Raw, B10RawCrop, B10RawCropFast, B10RawCropStride, B10RawStride, B10StrideRem,
        HwNv12, HwNv12Crop, HwNv12CropTo10, HwNv12Stride, HwNv12To10,
        HwNv12To10Stride, HwP010CropPack, HwP010CropPackPkRem, HwP010CropPackRem,
        HwP010CropPackRemPkRem, HwP010Pack, HwP010PackPkRem, HwP010PackRem, HwP010PackRemPkRem,
        HwP010PackRemPkRemStride, HwP010Raw, HwP010RawCrop, HwP010RawCropRem, HwP010RawRem,
        HwP010RawRemStride,
    },
    pack::{
        copy_with_stride, pack_4_pix_10b, pack_10b_rem, pack_stride, pack_stride_rem,
        packed_row_size,
    },
    util::assume_unreachable,
};

const AVMEDIA_TYPE_VIDEO: c_int = 0;
const AVERROR_EOF: c_int = -541_478_725;
const AVERROR_EAGAIN: c_int = -11;
const AVSEEK_FLAG_BACKWARD: c_int = 1;
const AV_FRAME_DATA_MASTERING_DISPLAY_METADATA: c_int = 11;
const AV_FRAME_DATA_CONTENT_LIGHT_LEVEL: c_int = 14;
const AV_PIX_FMT_YUV420P10LE: c_int = 62;
const AV_HWDEVICE_TYPE_VULKAN: c_int = 11;
const AV_CODEC_ID_AV1: c_int = 225;
const HW_DEVICE_CTX_OFFSET: usize = 560;

#[repr(C)]
#[derive(Clone, Copy)]
pub struct AVRational {
    pub num: c_int,
    pub den: c_int,
}

#[repr(C)]
pub struct AVChannelLayout {
    _order: c_int,
    pub nb_channels: c_int,
    _mask: u64,
    _opaque: *mut c_void,
}

#[repr(C)]
pub struct AVCodecParameters {
    pub codec_type: c_int,
    codec_id: c_int,
    _codec_tag: u32,
    _extradata: *mut u8,
    _extradata_size: c_int,
    _coded_side_data: *mut c_void,
    _nb_coded_side_data: c_int,
    pub format: c_int,
    _bit_rate: i64,
    _bits_per_coded_sample: c_int,
    bits_per_raw_sample: c_int,
    _profile: c_int,
    _level: c_int,
    width: c_int,
    height: c_int,
    sample_aspect_ratio: AVRational,
    framerate: AVRational,
    _field_order: c_int,
    _color_range: c_int,
    _color_primaries: c_int,
    _color_trc: c_int,
    color_space: c_int,
    _chroma_location: c_int,
    _video_delay: c_int,
    pub ch_layout: AVChannelLayout,
    pub sample_rate: c_int,
}

#[repr(C)]
pub struct AVStream {
    _av_class: *const c_void,
    pub index: c_int,
    _id: c_int,
    pub codecpar: *mut AVCodecParameters,
    _priv_data: *mut c_void,
    pub time_base: AVRational,
    pub start_time: i64,
    pub duration: i64,
    nb_frames: i64,
    _disposition: c_int,
    pub discard: c_int,
    sample_aspect_ratio: AVRational,
    metadata: *mut c_void,
    avg_frame_rate: AVRational,
}

#[repr(C)]
pub struct AVFormatContext {
    _av_class: *const c_void,
    _iformat: *const c_void,
    _oformat: *const c_void,
    _priv_data: *mut c_void,
    _pb: *mut c_void,
    _ctx_flags: c_int,
    pub nb_streams: u32,
    pub streams: *mut *mut AVStream,
    _nb_stream_groups: u32,
    _stream_groups: *mut c_void,
    _nb_chapters: u32,
    _chapters: *mut c_void,
    _url: *mut i8,
    _start_time: i64,
    pub duration: i64,
}

#[repr(C)]
pub struct VidFrame {
    pub data: [*mut u8; 8],
    pub linesize: [c_int; 8],
    pub extended_data: *mut *mut u8,
    pub width: c_int,
    pub height: c_int,
    pub nb_samples: c_int,
    pub format: c_int,
    _pict_type: c_int,
    _sample_aspect_ratio: AVRational,
    _pad0: [u8; 4],
    _pts: i64,
    _pkt_dts: i64,
    _time_base: AVRational,
    _quality: c_int,
    _pad1: [u8; 4],
    _opaque: *mut c_void,
    _repeat_pict: c_int,
    _sample_rate: c_int,
    _buf: [*mut c_void; 8],
    _extended_buf: *mut *mut c_void,
    _nb_extended_buf: c_int,
    _pad2: [u8; 4],
    side_data: *mut *mut AVFrameSideData,
    nb_side_data: c_int,
    _flags: c_int,
    color_range: c_int,
    color_primaries: c_int,
    color_trc: c_int,
    colorspace: c_int,
    chroma_location: c_int,
    best_effort_timestamp: i64,
}

#[repr(C)]
struct AVFrameSideData {
    type_: c_int,
    _pad: [u8; 4],
    data: *mut u8,
    _size: usize,
    _metadata: *mut c_void,
    _buf: *mut c_void,
}

#[repr(C)]
struct AVMasteringDisplayMetadata {
    display_primaries: [[AVRational; 2]; 3],
    white_point: [AVRational; 2],
    min_luminance: AVRational,
    max_luminance: AVRational,
    has_primaries: c_int,
    has_luminance: c_int,
}

#[repr(C)]
struct AVContentLightMetadata {
    max_cll: c_uint,
    max_fall: c_uint,
}

#[repr(C)]
pub struct AVPacket {
    _buf: *mut c_void,
    pub pts: i64,
    _dts: i64,
    _data: *mut u8,
    _size: c_int,
    pub stream_index: c_int,
}

unsafe extern "C" {
    pub fn avformat_open_input(
        ps: *mut *mut AVFormatContext,
        url: *const i8,
        fmt: *const c_void,
        options: *mut *mut c_void,
    ) -> c_int;
    pub fn avformat_find_stream_info(ic: *mut AVFormatContext, options: *mut *mut c_void) -> c_int;
    pub fn avformat_close_input(ps: *mut *mut AVFormatContext);
    pub fn av_opt_set_int(
        obj: *mut c_void,
        name: *const i8,
        val: i64,
        search_flags: c_int,
    ) -> c_int;
    pub fn av_find_best_stream(
        ic: *mut AVFormatContext,
        type_: c_int,
        wanted: c_int,
        related: c_int,
        decoder: *mut *const c_void,
        flags: c_int,
    ) -> c_int;
    pub fn avcodec_alloc_context3(codec: *const c_void) -> *mut c_void;
    pub fn avcodec_parameters_to_context(
        codec: *mut c_void,
        par: *const AVCodecParameters,
    ) -> c_int;
    pub fn avcodec_open2(
        avctx: *mut c_void,
        codec: *const c_void,
        options: *mut *mut c_void,
    ) -> c_int;
    pub fn avcodec_send_packet(avctx: *mut c_void, avpkt: *const AVPacket) -> c_int;
    pub fn avcodec_receive_frame(avctx: *mut c_void, frame: *mut VidFrame) -> c_int;
    pub fn avcodec_free_context(avctx: *mut *mut c_void);
    fn avcodec_flush_buffers(avctx: *mut c_void);
    pub fn av_packet_alloc() -> *mut AVPacket;
    pub fn av_packet_free(pkt: *mut *mut AVPacket);
    pub fn av_packet_unref(pkt: *mut AVPacket);
    pub fn av_read_frame(s: *mut AVFormatContext, pkt: *mut AVPacket) -> c_int;
    pub fn av_frame_alloc() -> *mut VidFrame;
    pub fn av_frame_free(frame: *mut *mut VidFrame);
    fn av_seek_frame(
        s: *mut AVFormatContext,
        stream_index: c_int,
        timestamp: i64,
        flags: c_int,
    ) -> c_int;
    fn av_frame_get_side_data(frame: *const VidFrame, type_: c_int) -> *const AVFrameSideData;
    fn av_log_set_level(level: c_int);
    fn av_log_set_callback(
        callback: unsafe extern "C" fn(*mut c_void, c_int, *const c_char, *mut c_void),
    );
    fn av_log_format_line2(
        ptr: *mut c_void,
        level: c_int,
        fmt: *const c_char,
        vl: *mut c_void,
        line: *mut c_char,
        line_size: c_int,
        print_prefix: *mut c_int,
    ) -> c_int;
    fn av_dict_get(
        m: *const c_void,
        key: *const i8,
        prev: *const AVDictEntry,
        flags: c_int,
    ) -> *const AVDictEntry;
    fn av_hwdevice_ctx_create(
        device_ctx: *mut *mut c_void,
        type_: c_int,
        device: *const c_char,
        opts: *mut c_void,
        flags: c_int,
    ) -> c_int;
    fn av_hwframe_transfer_data(dst: *mut VidFrame, src: *const VidFrame, flags: c_int) -> c_int;
    fn av_buffer_ref(buf: *mut c_void) -> *mut c_void;
    fn av_buffer_unref(buf: *mut *mut c_void);
    fn avcodec_find_decoder_by_name(name: *const c_char) -> *const c_void;
}

const AV_LOG_ERROR: c_int = 16;
const AVMEDIA_TYPE_AUDIO: c_int = 1;

static LAST_FF_LOG: Mutex<String> = Mutex::new(String::new());

unsafe extern "C" fn ff_log_callback(
    ptr: *mut c_void,
    level: c_int,
    fmt: *const c_char,
    vl: *mut c_void,
) {
    if level > AV_LOG_ERROR {
        return;
    }
    let mut buf = [0u8; 512];
    let mut prefix: c_int = 1;
    unsafe {
        av_log_format_line2(
            ptr,
            level,
            fmt,
            vl,
            buf.as_mut_ptr().cast::<c_char>(),
            512,
            addr_of_mut!(prefix),
        );
    }
    let msg = unsafe { CStr::from_ptr(buf.as_ptr().cast::<c_char>()) };
    if let Ok(s) = msg.to_str()
        && let Ok(mut last) = LAST_FF_LOG.lock()
    {
        last.clear();
        last.push_str(s.trim());
    }
}

fn ff_err(context: &str) -> Xerr {
    let detail = LAST_FF_LOG
        .lock()
        .ok()
        .filter(|s| !s.is_empty())
        .map(|mut s| {
            let out = s.clone();
            s.clear();
            out
        });
    detail.map_or_else(|| Msg(context.into()), |d| Msg(format!("{context}: {d}")))
}

#[repr(C)]
struct AVDictEntry {
    key: *const i8,
    value: *const i8,
}

const unsafe fn set_thread_count(codec_ctx: *mut c_void, threads: c_int) {
    unsafe {
        codec_ctx
            .cast::<u8>()
            .add(THREAD_COUNT_OFFSET)
            .cast::<c_int>()
            .write_unaligned(threads);
    }
}

const THREAD_COUNT_OFFSET: usize = 656;

const unsafe fn set_hw_device_ctx(codec_ctx: *mut c_void, buf_ref: *mut c_void) {
    unsafe {
        codec_ctx
            .cast::<u8>()
            .add(HW_DEVICE_CTX_OFFSET)
            .cast::<*mut c_void>()
            .write_unaligned(buf_ref);
    }
}

pub const fn gcd(mut a: u64, mut b: u64) -> u64 {
    while b != 0 {
        let t = b;
        b = a % b;
        a = t;
    }
    a
}

#[derive(Clone)]
pub struct VidInf {
    pub width: u32,
    pub height: u32,
    pub dar: Option<(u32, u32)>,
    pub fps_num: u32,
    pub fps_den: u32,
    pub frames: usize,
    pub color_primaries: Option<i32>,
    pub transfer_characteristics: Option<i32>,
    pub matrix_coefficients: Option<i32>,
    pub is_10b: bool,
    pub color_range: Option<i32>,
    pub chroma_sample_position: Option<i32>,
    pub mastering_display: Option<String>,
    pub content_light: Option<String>,
    pub y_linesize: usize,
}

pub struct VideoDecoder {
    fmt_ctx: *mut AVFormatContext,
    codec_ctx: *mut c_void,
    pkt: *mut AVPacket,
    frame: *mut VidFrame,
    sw_frame: *mut VidFrame,
    hw_device_ctx: *mut c_void,
    stream_idx: c_int,
    next_frame: usize,
    eof: bool,
    hw: bool,
    ts_mul: i64,
    ts_div: i64,
}

unsafe impl Send for VideoDecoder {}

pub unsafe fn probe_streams(fmt_ctx: *mut AVFormatContext, keep_type: c_int, probesize: i64) {
    unsafe {
        let n = (*fmt_ctx).nb_streams as usize;
        for i in 0..n {
            let stream = &mut *(*(*fmt_ctx).streams.add(i));
            if (*stream.codecpar).codec_type != keep_type {
                stream.discard = 48;
            }
        }
        av_opt_set_int(fmt_ctx.cast(), c"probesize".as_ptr(), probesize, 1);
        av_opt_set_int(fmt_ctx.cast(), c"analyzeduration".as_ptr(), 0, 1);
        avformat_find_stream_info(fmt_ctx, null_mut());
    }
}

impl VideoDecoder {
    pub fn new(path: &Path, threads: i32) -> Result<Self, Xerr> {
        unsafe {
            let cpath = CString::new(path.to_str().ok_or("invalid path")?)?;
            let mut fmt_ctx: *mut AVFormatContext = null_mut();

            if avformat_open_input(addr_of_mut!(fmt_ctx), cpath.as_ptr(), null(), null_mut()) < 0 {
                return Err(ff_err("decoder: open failed"));
            }

            probe_streams(fmt_ctx, AVMEDIA_TYPE_VIDEO, 0x8000);

            let mut dec: *const c_void = null();
            let idx =
                av_find_best_stream(fmt_ctx, AVMEDIA_TYPE_VIDEO, -1, -1, addr_of_mut!(dec), 0);
            if idx < 0 {
                avformat_close_input(addr_of_mut!(fmt_ctx));
                return Err(ff_err("decoder: no video stream"));
            }

            let stream = *(*fmt_ctx).streams.add(idx as usize);
            let par = &*(*stream).codecpar;
            let (ts_mul, ts_div) = ts_factors((*stream).time_base, (*stream).avg_frame_rate);

            let mut codec_ctx = avcodec_alloc_context3(dec);
            if codec_ctx.is_null() {
                avformat_close_input(addr_of_mut!(fmt_ctx));
                return Err(ff_err("decoder: alloc codec failed"));
            }

            avcodec_parameters_to_context(codec_ctx, par);
            set_thread_count(codec_ctx, threads);

            if avcodec_open2(codec_ctx, dec, null_mut()) < 0 {
                avcodec_free_context(addr_of_mut!(codec_ctx));
                avformat_close_input(addr_of_mut!(fmt_ctx));
                return Err(ff_err("decoder: codec open failed"));
            }

            Ok(Self {
                fmt_ctx,
                codec_ctx,
                pkt: av_packet_alloc(),
                frame: av_frame_alloc(),
                sw_frame: null_mut(),
                hw_device_ctx: null_mut(),
                stream_idx: idx,
                next_frame: 0,
                eof: false,
                hw: false,
                ts_mul,
                ts_div,
            })
        }
    }

    pub fn new_hw(path: &Path, threads: i32) -> Result<Self, Xerr> {
        unsafe {
            let mut hw_device_ctx: *mut c_void = null_mut();
            if av_hwdevice_ctx_create(
                addr_of_mut!(hw_device_ctx),
                AV_HWDEVICE_TYPE_VULKAN,
                null(),
                null_mut(),
                0,
            ) < 0
            {
                return Err(ff_err("hwaccel: vulkan device creation failed"));
            }

            let cpath = CString::new(path.to_str().ok_or("invalid path")?)?;
            let mut fmt_ctx: *mut AVFormatContext = null_mut();

            if avformat_open_input(addr_of_mut!(fmt_ctx), cpath.as_ptr(), null(), null_mut()) < 0 {
                av_buffer_unref(addr_of_mut!(hw_device_ctx));
                return Err(ff_err("decoder: open failed"));
            }

            probe_streams(fmt_ctx, AVMEDIA_TYPE_VIDEO, 0x8000);

            let mut dec: *const c_void = null();
            let idx =
                av_find_best_stream(fmt_ctx, AVMEDIA_TYPE_VIDEO, -1, -1, addr_of_mut!(dec), 0);
            if idx < 0 {
                avformat_close_input(addr_of_mut!(fmt_ctx));
                av_buffer_unref(addr_of_mut!(hw_device_ctx));
                return Err(ff_err("decoder: no video stream"));
            }

            let stream = *(*fmt_ctx).streams.add(idx as usize);
            let par = &*(*stream).codecpar;

            if par.codec_id == AV_CODEC_ID_AV1 {
                let native = avcodec_find_decoder_by_name(c"av1".as_ptr());
                if !native.is_null() {
                    dec = native;
                }
            }

            let (ts_mul, ts_div) = ts_factors((*stream).time_base, (*stream).avg_frame_rate);

            let mut codec_ctx = avcodec_alloc_context3(dec);
            if codec_ctx.is_null() {
                avformat_close_input(addr_of_mut!(fmt_ctx));
                av_buffer_unref(addr_of_mut!(hw_device_ctx));
                return Err(ff_err("decoder: alloc codec failed"));
            }

            avcodec_parameters_to_context(codec_ctx, par);
            set_thread_count(codec_ctx, threads);
            set_hw_device_ctx(codec_ctx, av_buffer_ref(hw_device_ctx));

            if avcodec_open2(codec_ctx, dec, null_mut()) < 0 {
                avcodec_free_context(addr_of_mut!(codec_ctx));
                avformat_close_input(addr_of_mut!(fmt_ctx));
                av_buffer_unref(addr_of_mut!(hw_device_ctx));
                return Err(ff_err("decoder: codec open failed"));
            }

            Ok(Self {
                fmt_ctx,
                codec_ctx,
                pkt: av_packet_alloc(),
                frame: av_frame_alloc(),
                sw_frame: av_frame_alloc(),
                hw_device_ctx,
                stream_idx: idx,
                next_frame: 0,
                eof: false,
                hw: true,
                ts_mul,
                ts_div,
            })
        }
    }

    pub const fn is_eof(&self) -> bool {
        self.eof
    }

    #[inline]
    fn got_frame(&mut self) -> *const VidFrame {
        self.next_frame += 1;
        if self.hw {
            unsafe { av_hwframe_transfer_data(self.sw_frame, self.frame, 0) };
            self.sw_frame
        } else {
            self.frame
        }
    }

    pub fn decode_next(&mut self) -> *const VidFrame {
        unsafe {
            loop {
                let ret = avcodec_receive_frame(self.codec_ctx, self.frame);
                if ret == 0 {
                    return self.got_frame();
                }
                if ret == AVERROR_EOF {
                    self.eof = true;
                    return self.frame.cast();
                }

                loop {
                    let r = av_read_frame(self.fmt_ctx, self.pkt);
                    if r < 0 {
                        avcodec_send_packet(self.codec_ctx, null());
                        break;
                    }
                    if (*self.pkt).stream_index != self.stream_idx {
                        av_packet_unref(self.pkt);
                        continue;
                    }
                    let s = avcodec_send_packet(self.codec_ctx, self.pkt);
                    av_packet_unref(self.pkt);
                    if s != AVERROR_EAGAIN {
                        break;
                    }
                    let r2 = avcodec_receive_frame(self.codec_ctx, self.frame);
                    if r2 == 0 {
                        return self.got_frame();
                    }
                }
            }
        }
    }

    #[inline]
    const fn pts_to_frame(&self, pts: i64) -> usize {
        ((pts * self.ts_div + self.ts_mul / 2) / self.ts_mul) as usize
    }

    pub fn seek_near(&mut self, frame_idx: usize) {
        unsafe {
            let ts = frame_idx as i64 * self.ts_mul / self.ts_div;
            av_seek_frame(self.fmt_ctx, self.stream_idx, ts, AVSEEK_FLAG_BACKWARD);
            avcodec_flush_buffers(self.codec_ctx);
            self.eof = false;
            self.decode_next();
            self.next_frame = self.pts_to_frame((*self.frame).best_effort_timestamp) + 1;
        }
    }

    pub fn skip_to(&mut self, frame_idx: usize) {
        if frame_idx == self.next_frame {
            return;
        }
        if frame_idx < self.next_frame || frame_idx - self.next_frame > 150 {
            self.seek_near(frame_idx);
        }
        while self.next_frame < frame_idx && !self.eof {
            self.decode_next();
        }
    }

    pub const fn frame_ref(&self) -> *const VidFrame {
        self.frame
    }
}

impl Drop for VideoDecoder {
    fn drop(&mut self) {
        unsafe {
            if !self.sw_frame.is_null() {
                av_frame_free(addr_of_mut!(self.sw_frame));
            }
            if !self.hw_device_ctx.is_null() {
                av_buffer_unref(addr_of_mut!(self.hw_device_ctx));
            }
            av_frame_free(addr_of_mut!(self.frame));
            av_packet_free(addr_of_mut!(self.pkt));
            avcodec_free_context(addr_of_mut!(self.codec_ctx));
            avformat_close_input(addr_of_mut!(self.fmt_ctx));
        }
    }
}

fn rat_to_f64(r: AVRational) -> f64 {
    if r.den == 0 {
        return 0.0;
    }
    f64::from(r.num) / f64::from(r.den)
}

fn count_video_packets(fmt_ctx: *mut AVFormatContext, stream_idx: c_int) -> usize {
    unsafe {
        let mut count = 0usize;
        let mut pkt = av_packet_alloc();
        while av_read_frame(fmt_ctx, pkt) >= 0 {
            if (*pkt).stream_index == stream_idx {
                count += 1;
            }
            av_packet_unref(pkt);
        }
        av_packet_free(addr_of_mut!(pkt));
        av_seek_frame(fmt_ctx, stream_idx, 0, AVSEEK_FLAG_BACKWARD);
        count
    }
}

const fn ts_factors(tb: AVRational, fps: AVRational) -> (i64, i64) {
    if fps.num > 0 && fps.den > 0 {
        (
            tb.den as i64 * fps.den as i64,
            tb.num as i64 * fps.num as i64,
        )
    } else {
        (1, 1)
    }
}

fn frames_from_last_pts(
    fmt_ctx: *mut AVFormatContext,
    idx: c_int,
    dur: i64,
    start: i64,
    tb: AVRational,
    fps: AVRational,
) -> usize {
    unsafe {
        let target = if dur > 0 { dur } else { i64::MAX / 2 };
        if av_seek_frame(fmt_ctx, idx, target, AVSEEK_FLAG_BACKWARD) < 0 {
            av_seek_frame(fmt_ctx, idx, 0, AVSEEK_FLAG_BACKWARD);
            return 0;
        }
        let mut pkt = av_packet_alloc();
        let mut max_pts: i64 = -1;
        let mut seek_verified = dur <= 0;
        while av_read_frame(fmt_ctx, pkt) >= 0 {
            if (*pkt).stream_index == idx {
                if !seek_verified {
                    seek_verified = true;
                    if (*pkt).pts < dur / 2 {
                        av_packet_unref(pkt);
                        av_packet_free(addr_of_mut!(pkt));
                        av_seek_frame(fmt_ctx, idx, 0, AVSEEK_FLAG_BACKWARD);
                        return 0;
                    }
                }
                max_pts = max_pts.max((*pkt).pts);
            }
            av_packet_unref(pkt);
        }
        av_packet_free(addr_of_mut!(pkt));
        av_seek_frame(fmt_ctx, idx, 0, AVSEEK_FLAG_BACKWARD);
        if max_pts < 0 {
            return 0;
        }
        let origin = if start >= 0 { start } else { 0 };
        let num = (max_pts - origin) * i64::from(tb.num) * i64::from(fps.num);
        let den = i64::from(tb.den) * i64::from(fps.den);
        ((num + den / 2) / den + 1) as usize
    }
}

fn decode_first_frame(
    fmt_ctx: *mut AVFormatContext,
    dec: *const c_void,
    par: &AVCodecParameters,
    idx: c_int,
) -> FrameMeta {
    unsafe {
        let mut codec_ctx = avcodec_alloc_context3(dec);
        avcodec_parameters_to_context(codec_ctx, par);
        let thr = available_parallelism().unwrap_unchecked().get() as c_int;
        set_thread_count(codec_ctx, thr);
        avcodec_open2(codec_ctx, dec, null_mut());

        let mut pkt = av_packet_alloc();
        let mut frame = av_frame_alloc();

        let mut decoded = false;
        loop {
            let r = av_read_frame(fmt_ctx, pkt);
            if r < 0 {
                break;
            }
            if (*pkt).stream_index != idx {
                av_packet_unref(pkt);
                continue;
            }
            avcodec_send_packet(codec_ctx, pkt);
            av_packet_unref(pkt);
            if avcodec_receive_frame(codec_ctx, frame) == 0 {
                decoded = true;
                break;
            }
        }

        let fmeta = if decoded {
            extract_frame_meta(&*frame, par.color_space)
        } else {
            FrameMeta::default(par.width as usize)
        };

        av_frame_free(addr_of_mut!(frame));
        av_packet_free(addr_of_mut!(pkt));
        avcodec_free_context(addr_of_mut!(codec_ctx));
        fmeta
    }
}

pub fn get_vidinf(path: &Path) -> Result<VidInf, Xerr> {
    unsafe {
        av_log_set_level(AV_LOG_ERROR);
        av_log_set_callback(ff_log_callback);

        let cpath = CString::new(path.to_str().ok_or("invalid path")?)?;
        let mut fmt_ctx: *mut AVFormatContext = null_mut();

        if avformat_open_input(addr_of_mut!(fmt_ctx), cpath.as_ptr(), null(), null_mut()) < 0 {
            return Err(ff_err("decoder: open failed"));
        }

        probe_streams(fmt_ctx, AVMEDIA_TYPE_VIDEO, 0x8000);

        let mut dec: *const c_void = null();
        let idx = av_find_best_stream(fmt_ctx, AVMEDIA_TYPE_VIDEO, -1, -1, addr_of_mut!(dec), 0);
        if idx < 0 {
            avformat_close_input(addr_of_mut!(fmt_ctx));
            return Err(ff_err("decoder: no video stream"));
        }

        let stream = &*(*(*fmt_ctx).streams.add(idx as usize));
        let par = &*stream.codecpar;

        let width = par.width.cast_unsigned();
        let height = par.height.cast_unsigned();

        let fps = stream.avg_frame_rate;
        let fps_num = fps.num.cast_unsigned();
        let fps_den = fps.den.cast_unsigned();

        let frames = if stream.nb_frames > 0 {
            stream.nb_frames as usize
        } else if fps.den > 0 {
            let from_pts = frames_from_last_pts(
                fmt_ctx,
                idx,
                stream.duration,
                stream.start_time,
                stream.time_base,
                fps,
            );
            if from_pts > 0 {
                from_pts
            } else {
                count_video_packets(fmt_ctx, idx)
            }
        } else {
            count_video_packets(fmt_ctx, idx)
        };

        let (sar_n, sar_d) = if stream.sample_aspect_ratio.num > 0 {
            (
                stream.sample_aspect_ratio.num,
                stream.sample_aspect_ratio.den,
            )
        } else {
            (par.sample_aspect_ratio.num, par.sample_aspect_ratio.den)
        };

        let dar = (sar_n > 0 && sar_d > 0 && sar_n != sar_d).then(|| {
            let dw = u64::from(width) * sar_n as u64;
            let dh = u64::from(height) * sar_d as u64;
            let g = gcd(dw, dh);
            ((dw / g) as u32, (dh / g) as u32)
        });

        let fmeta = decode_first_frame(fmt_ctx, dec, par, idx);
        avformat_close_input(addr_of_mut!(fmt_ctx));

        Ok(VidInf {
            width,
            height,
            dar,
            fps_num,
            fps_den,
            frames,
            color_primaries: fmeta.color_primaries,
            transfer_characteristics: fmeta.transfer_characteristics,
            matrix_coefficients: fmeta.matrix_coefficients,
            is_10b: fmeta.is_10b,
            color_range: fmeta.color_range,
            chroma_sample_position: fmeta.chroma_sample_position,
            mastering_display: fmeta.mastering_display,
            content_light: fmeta.content_light,
            y_linesize: fmeta.y_linesize,
        })
    }
}

pub fn get_audio_streams(path: &Path) -> Result<Vec<(usize, u32, Option<String>)>, Xerr> {
    unsafe {
        let cpath = CString::new(path.to_str().ok_or("invalid path")?)?;
        let mut fmt_ctx: *mut AVFormatContext = null_mut();

        if avformat_open_input(addr_of_mut!(fmt_ctx), cpath.as_ptr(), null(), null_mut()) < 0 {
            return Err(ff_err("decoder: open failed"));
        }

        probe_streams(fmt_ctx, AVMEDIA_TYPE_AUDIO, 0x8000);

        let n = (*fmt_ctx).nb_streams as usize;
        let mut result = Vec::new();
        let lang_key = CString::new("language").unwrap_unchecked();

        for i in 0..n {
            let stream = &*(*(*fmt_ctx).streams.add(i));
            let par = &*stream.codecpar;
            if par.codec_type != AVMEDIA_TYPE_AUDIO {
                continue;
            }
            let channels = par.ch_layout.nb_channels.cast_unsigned();
            let lang = {
                let entry = av_dict_get(stream.metadata, lang_key.as_ptr(), null(), 0);
                if entry.is_null() {
                    None
                } else {
                    CStr::from_ptr((*entry).value)
                        .to_str()
                        .ok()
                        .map(ToOwned::to_owned)
                }
            };
            result.push((stream.index as usize, channels, lang));
        }

        avformat_close_input(addr_of_mut!(fmt_ctx));
        Ok(result)
    }
}

struct FrameMeta {
    color_primaries: Option<c_int>,
    transfer_characteristics: Option<c_int>,
    matrix_coefficients: Option<c_int>,
    color_range: Option<c_int>,
    chroma_sample_position: Option<c_int>,
    mastering_display: Option<String>,
    content_light: Option<String>,
    is_10b: bool,
    y_linesize: usize,
}

impl FrameMeta {
    const fn default(width: usize) -> Self {
        Self {
            color_primaries: None,
            transfer_characteristics: None,
            matrix_coefficients: None,
            color_range: None,
            chroma_sample_position: None,
            mastering_display: None,
            content_light: None,
            is_10b: false,
            y_linesize: width,
        }
    }
}

unsafe fn extract_frame_meta(f: &VidFrame, par_color_space: c_int) -> FrameMeta {
    let matrix_coeff = match if f.colorspace == 3 {
        par_color_space
    } else {
        f.colorspace
    } {
        0 => 2,
        x => x,
    };

    FrameMeta {
        color_primaries: Some(f.color_primaries),
        transfer_characteristics: Some(f.color_trc),
        matrix_coefficients: Some(matrix_coeff),
        color_range: match f.color_range {
            1 => Some(0),
            2 => Some(1),
            _ => None,
        },
        chroma_sample_position: match f.chroma_location {
            1 => Some(1),
            3 => Some(2),
            _ => None,
        },
        mastering_display: unsafe { extract_mastering_display(f) },
        content_light: unsafe { extract_content_light(f) },
        is_10b: f.format == AV_PIX_FMT_YUV420P10LE,
        y_linesize: f.linesize[0] as usize,
    }
}

unsafe fn extract_mastering_display(f: &VidFrame) -> Option<String> {
    unsafe {
        let sd = av_frame_get_side_data(f, AV_FRAME_DATA_MASTERING_DISPLAY_METADATA);
        if sd.is_null() {
            return None;
        }
        let md = &*(((*sd).data as usize) as *const AVMasteringDisplayMetadata);
        if md.has_primaries == 0 || md.has_luminance == 0 {
            return None;
        }
        Some(format!(
            "G({:.4},{:.4})B({:.4},{:.4})R({:.4},{:.4})WP({:.4},{:.4})L({:.4},{:.4})",
            rat_to_f64(md.display_primaries[1][0]),
            rat_to_f64(md.display_primaries[1][1]),
            rat_to_f64(md.display_primaries[2][0]),
            rat_to_f64(md.display_primaries[2][1]),
            rat_to_f64(md.display_primaries[0][0]),
            rat_to_f64(md.display_primaries[0][1]),
            rat_to_f64(md.white_point[0]),
            rat_to_f64(md.white_point[1]),
            rat_to_f64(md.max_luminance),
            rat_to_f64(md.min_luminance),
        ))
    }
}

unsafe fn extract_content_light(f: &VidFrame) -> Option<String> {
    unsafe {
        let sd = av_frame_get_side_data(f, AV_FRAME_DATA_CONTENT_LIGHT_LEVEL);
        if sd.is_null() {
            return None;
        }
        let cl = &*(((*sd).data as usize) as *const AVContentLightMetadata);
        Some(format!("{},{}", cl.max_cll, cl.max_fall))
    }
}

pub fn extr_8b(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let width = inf.width as usize;
        let height = inf.height as usize;
        let y_size = width * height;
        let uv_size = y_size / 4;

        let y_linesize = f.linesize[0] as usize;
        copy_with_stride(f.data[0], y_linesize, width, height, output.as_mut_ptr());
        copy_with_stride(
            f.data[1],
            f.linesize[1] as usize,
            width / 2,
            height / 2,
            output.as_mut_ptr().add(y_size),
        );
        copy_with_stride(
            f.data[2],
            f.linesize[2] as usize,
            width / 2,
            height / 2,
            output.as_mut_ptr().add(y_size + uv_size),
        );
    }
}

pub const fn extr_8b_crop_fast(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let y_sz = cc.new_w as usize * cc.new_h as usize;
        let uv_sz = y_sz / 4;

        copy_nonoverlapping(f.data[0].add(cc.y_start), output.as_mut_ptr(), y_sz);
        copy_nonoverlapping(
            f.data[1].add(cc.uv_off),
            output.as_mut_ptr().add(y_sz),
            uv_sz,
        );
        copy_nonoverlapping(
            f.data[2].add(cc.uv_off),
            output.as_mut_ptr().add(y_sz + uv_sz),
            uv_sz,
        );
    }
}

pub fn extr_8b_crop(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let mut pos = 0;

        for row in 0..cc.new_h as usize {
            copy_nonoverlapping(
                f.data[0].add(cc.y_start + row * cc.y_stride),
                output.as_mut_ptr().add(pos),
                cc.y_len,
            );
            pos += cc.y_len;
        }

        for row in 0..cc.new_h as usize / 2 {
            copy_nonoverlapping(
                f.data[1].add(cc.uv_off + row * cc.uv_stride),
                output.as_mut_ptr().add(pos),
                cc.uv_len,
            );
            pos += cc.uv_len;
        }

        for row in 0..cc.new_h as usize / 2 {
            copy_nonoverlapping(
                f.data[2].add(cc.uv_off + row * cc.uv_stride),
                output.as_mut_ptr().add(pos),
                cc.uv_len,
            );
            pos += cc.uv_len;
        }
    }
}

pub const fn extr_8b_fast(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let width = inf.width as usize;
        let height = inf.height as usize;
        let y_size = width * height;
        let uv_size = y_size / 4;

        copy_nonoverlapping(f.data[0], output.as_mut_ptr(), y_size);
        copy_nonoverlapping(f.data[1], output.as_mut_ptr().add(y_size), uv_size);
        copy_nonoverlapping(
            f.data[2],
            output.as_mut_ptr().add(y_size + uv_size),
            uv_size,
        );
    }
}

pub fn extr_10b_crop_fast(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let w = cc.new_w as usize;
        let h = cc.new_h as usize;
        let y_pack = (w * h * 5) / 4;
        let uv_pack = (w * h / 4 * 5) / 4;

        let y_src = from_raw_parts(f.data[0].add(cc.y_start), w * h * 2);
        pack_10b(y_src, &mut output[..y_pack]);

        let u_src = from_raw_parts(f.data[1].add(cc.uv_off), w * h / 2);
        pack_10b(u_src, &mut output[y_pack..y_pack + uv_pack]);

        let v_src = from_raw_parts(f.data[2].add(cc.uv_off), w * h / 2);
        pack_10b(v_src, &mut output[y_pack + uv_pack..]);
    }
}

pub fn extr_10b_crop(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let w = cc.new_w as usize;
        let h = cc.new_h as usize;
        let y_pack = (w * h * 5) / 4;
        let uv_pack = (w * h / 4 * 5) / 4;

        pack_stride(
            f.data[0].add(cc.y_start),
            f.linesize[0] as usize,
            w,
            h,
            output.as_mut_ptr(),
        );
        pack_stride(
            f.data[1].add(cc.uv_off),
            f.linesize[1] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack),
        );
        pack_stride(
            f.data[2].add(cc.uv_off),
            f.linesize[2] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack + uv_pack),
        );
    }
}

#[derive(Debug, Clone, Copy)]
pub enum DecodeStrat {
    B10Fast,
    B10FastRem,
    B10StrideRem,
    B10Crop { cc: CropCalc },
    B10CropRem { cc: CropCalc },
    B10CropFast { cc: CropCalc },
    B10CropFastRem { cc: CropCalc },
    B10CropStride { cc: CropCalc },
    B10CropStrideRem { cc: CropCalc },
    B10Raw,
    B10RawStride,
    B10RawCrop { cc: CropCalc },
    B10RawCropFast { cc: CropCalc },
    B10RawCropStride { cc: CropCalc },
    B8Fast,
    B8Stride,
    B8Crop { cc: CropCalc },
    B8CropFast { cc: CropCalc },
    B8CropStride { cc: CropCalc },
    HwNv12,
    HwNv12Crop { cc: CropCalc },
    HwNv12To10,
    HwNv12CropTo10 { cc: CropCalc },
    HwP010Raw,
    HwP010RawRem,
    HwP010RawCrop { cc: CropCalc },
    HwP010RawCropRem { cc: CropCalc },
    HwP010Pack,
    HwP010PackRem,
    HwP010CropPack { cc: CropCalc },
    HwP010CropPackRem { cc: CropCalc },
    HwP010PackPkRem,
    HwP010PackRemPkRem,
    HwP010CropPackPkRem { cc: CropCalc },
    HwP010CropPackRemPkRem { cc: CropCalc },
    HwP010PackRemPkRemStride,
    HwNv12Stride,
    HwNv12To10Stride,
    HwP010RawRemStride,
}

impl DecodeStrat {
    pub const fn to_raw(self) -> Self {
        match self {
            B10Fast | B10FastRem => B10Raw,
            B10StrideRem => B10RawStride,
            B10CropFast { cc } | B10CropFastRem { cc } => B10RawCropFast { cc },
            B10Crop { cc } | B10CropRem { cc } => B10RawCrop { cc },
            B10CropStride { cc } | B10CropStrideRem { cc } => B10RawCropStride { cc },
            HwP010Pack | HwP010PackPkRem => HwP010Raw,
            HwP010PackRem | HwP010PackRemPkRem => HwP010RawRem,
            HwP010CropPack { cc } | HwP010CropPackPkRem { cc } => HwP010RawCrop { cc },
            HwP010CropPackRem { cc } | HwP010CropPackRemPkRem { cc } => HwP010RawCropRem { cc },
            HwP010PackRemPkRemStride => HwP010RawRemStride,
            other => other,
        }
    }

    pub const fn is_raw(self) -> bool {
        matches!(
            self,
            B10Raw
                | B10RawStride
                | B10RawCrop { .. }
                | B10RawCropFast { .. }
                | B10RawCropStride { .. }
                | HwP010Raw
                | HwP010RawRem
                | HwP010RawRemStride
                | HwP010RawCrop { .. }
                | HwP010RawCropRem { .. }
        )
    }

    pub const fn is_hw(self) -> bool {
        matches!(
            self,
            HwNv12
                | HwNv12Stride
                | HwNv12Crop { .. }
                | HwNv12To10
                | HwNv12To10Stride
                | HwNv12CropTo10 { .. }
                | HwP010Raw
                | HwP010RawRem
                | HwP010RawRemStride
                | HwP010RawCrop { .. }
                | HwP010RawCropRem { .. }
                | HwP010Pack
                | HwP010PackPkRem
                | HwP010PackRem
                | HwP010PackRemPkRem
                | HwP010PackRemPkRemStride
                | HwP010CropPack { .. }
                | HwP010CropPackPkRem { .. }
                | HwP010CropPackRem { .. }
                | HwP010CropPackRemPkRem { .. }
        )
    }
}

pub fn get_decode_strat(inf: &VidInf, crop: (u32, u32), hwaccel: bool, tq: bool) -> DecodeStrat {
    if hwaccel {
        let has_crop = crop != (0, 0);
        let pix_sz = if inf.is_10b { 2 } else { 1 };
        let has_pad = inf.y_linesize != inf.width as usize * pix_sz;
        return match (inf.is_10b, has_crop, tq, has_pad) {
            (false, false, false, false) => HwNv12To10,
            (false, false, false, true) => HwNv12To10Stride,
            (false, true, false, _) => HwNv12CropTo10 {
                cc: CropCalc::new(inf, crop, 1),
            },
            (false, false, true, false) => HwNv12,
            (false, false, true, true) => HwNv12Stride,
            (false, true, true, _) => HwNv12Crop {
                cc: CropCalc::new(inf, crop, 1),
            },
            (true, false, _, false) => {
                let w = inf.width as usize;
                match (w.is_multiple_of(SHIFT_CHUNK), w.is_multiple_of(PACK_CHUNK)) {
                    (true, true) => HwP010Pack,
                    (true, false) => HwP010PackPkRem,
                    (false, true) => HwP010PackRem,
                    (false, false) => HwP010PackRemPkRem,
                }
            }
            (true, false, _, true) => HwP010PackRemPkRemStride,
            (true, true, ..) => {
                let cc = CropCalc::new(inf, crop, 2);
                let w = cc.new_w as usize;
                match (w.is_multiple_of(SHIFT_CHUNK), w.is_multiple_of(PACK_CHUNK)) {
                    (true, true) => HwP010CropPack { cc },
                    (true, false) => HwP010CropPackPkRem { cc },
                    (false, true) => HwP010CropPackRem { cc },
                    (false, false) => HwP010CropPackRemPkRem { cc },
                }
            }
        };
    }
    let pix_sz = if inf.is_10b { 2 } else { 1 };
    let has_pad = inf.y_linesize != inf.width as usize * pix_sz;
    let has_crop = crop != (0, 0);
    let w_crop = crop.1 != 0;

    let final_w = if has_crop {
        inf.width - crop.1 * 2
    } else {
        inf.width
    };
    let has_rem = inf.is_10b && !(final_w as usize).is_multiple_of(PACK_CHUNK);

    match (inf.is_10b, has_crop, has_pad, w_crop, has_rem) {
        (true, false, false, _, false) => B10Fast,
        (true, false, false, _, true) => B10FastRem,
        (true, false, true, _, true) => B10StrideRem,
        (true, true, false, false, false) => B10CropFast {
            cc: CropCalc::new(inf, crop, 2),
        },
        (true, true, false, false, true) => B10CropFastRem {
            cc: CropCalc::new(inf, crop, 2),
        },
        (true, true, false, true, false) => B10Crop {
            cc: CropCalc::new(inf, crop, 2),
        },
        (true, true, false, true, true) => B10CropRem {
            cc: CropCalc::new(inf, crop, 2),
        },
        (true, true, true, _, false) => B10CropStride {
            cc: CropCalc::new(inf, crop, 2),
        },
        (true, true, true, _, true) => B10CropStrideRem {
            cc: CropCalc::new(inf, crop, 2),
        },
        (false, false, false, ..) => B8Fast,
        (false, false, true, ..) => B8Stride,
        (false, true, false, false, _) => B8CropFast {
            cc: CropCalc::new(inf, crop, 1),
        },
        (false, true, false, true, _) => B8Crop {
            cc: CropCalc::new(inf, crop, 1),
        },
        (false, true, true, ..) => B8CropStride {
            cc: CropCalc::new(inf, crop, 1),
        },
        _ => assume_unreachable(),
    }
}

pub fn extr_10b_pack(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let w = inf.width as usize;
        let h = inf.height as usize;
        let y_pack = (w * h * 5) / 4;
        let uv_pack = (w * h / 4 * 5) / 4;

        let y_src = from_raw_parts(f.data[0], w * h * 2);
        pack_10b(y_src, &mut output[..y_pack]);

        let u_src = from_raw_parts(f.data[1], w * h / 2);
        pack_10b(u_src, &mut output[y_pack..y_pack + uv_pack]);

        let v_src = from_raw_parts(f.data[2], w * h / 2);
        pack_10b(v_src, &mut output[y_pack + uv_pack..]);
    }
}

pub fn extr_8b_stride(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let width = inf.width as usize;
        let height = inf.height as usize;

        let y_linesize = f.linesize[0] as usize;
        let uv_linesize = f.linesize[1] as usize;

        let mut pos = 0;

        for row in 0..height {
            copy_nonoverlapping(
                f.data[0].add(row * y_linesize),
                output.as_mut_ptr().add(pos),
                width,
            );
            pos += width;
        }

        for row in 0..height / 2 {
            copy_nonoverlapping(
                f.data[1].add(row * uv_linesize),
                output.as_mut_ptr().add(pos),
                width / 2,
            );
            pos += width / 2;
        }

        for row in 0..height / 2 {
            copy_nonoverlapping(
                f.data[2].add(row * uv_linesize),
                output.as_mut_ptr().add(pos),
                width / 2,
            );
            pos += width / 2;
        }
    }
}

pub fn extr_10b_crop_pack_stride(frame: *const VidFrame, output: &mut [u8], crop_calc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let w = crop_calc.new_w as usize;
        let h = crop_calc.new_h as usize;
        let pix_sz = 2;

        let y_linesize = f.linesize[0] as usize;
        let uv_linesize = f.linesize[1] as usize;

        let mut dst_pos = 0;
        let pack_row_y = (w * 2 * 5) / 8;

        for row in 0..h {
            let src_off = (crop_calc.crop_h as usize * pix_sz)
                + (row + crop_calc.crop_v as usize) * y_linesize;
            let src_row = from_raw_parts(f.data[0].add(src_off), crop_calc.y_len);
            let dst_row = from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), pack_row_y);

            pack_10b(src_row, dst_row);

            dst_pos += pack_row_y;
        }

        let pack_row_uv = (w / 2 * 2 * 5) / 8;

        for row in 0..h / 2 {
            let src_off = (crop_calc.crop_h as usize / 2 * pix_sz)
                + (row + crop_calc.crop_v as usize / 2) * uv_linesize;
            let src_row = from_raw_parts(f.data[1].add(src_off), crop_calc.uv_len);
            let dst_row = from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), pack_row_uv);

            pack_10b(src_row, dst_row);

            dst_pos += pack_row_uv;
        }

        for row in 0..h / 2 {
            let src_off = (crop_calc.crop_h as usize / 2 * pix_sz)
                + (row + crop_calc.crop_v as usize / 2) * uv_linesize;
            let src_row = from_raw_parts(f.data[2].add(src_off), crop_calc.uv_len);
            let dst_row = from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), pack_row_uv);

            pack_10b(src_row, dst_row);

            dst_pos += pack_row_uv;
        }
    }
}

pub fn extr_10b_pack_rem(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let w = inf.width as usize;
        let h = inf.height as usize;

        let y_row = packed_row_size(w);
        let uv_row = packed_row_size(w / 2);
        let y_pack = y_row * h;
        let uv_pack = uv_row * h / 2;

        let y_src = from_raw_parts(f.data[0], w * h * 2);
        pack_10b_rem(y_src, &mut output[..y_pack], w, h);

        let u_src = from_raw_parts(f.data[1], w * h / 2);
        pack_10b_rem(u_src, &mut output[y_pack..y_pack + uv_pack], w / 2, h / 2);

        let v_src = from_raw_parts(f.data[2], w * h / 2);
        pack_10b_rem(v_src, &mut output[y_pack + uv_pack..], w / 2, h / 2);
    }
}

pub fn extr_10b_pack_stride_rem(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let w = inf.width as usize;
        let h = inf.height as usize;

        let y_row = packed_row_size(w);
        let uv_row = packed_row_size(w / 2);
        let y_pack = y_row * h;
        let uv_pack = uv_row * h / 2;

        pack_stride_rem(f.data[0], f.linesize[0] as usize, w, h, output.as_mut_ptr());
        pack_stride_rem(
            f.data[1],
            f.linesize[1] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack),
        );
        pack_stride_rem(
            f.data[2],
            f.linesize[2] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack + uv_pack),
        );
    }
}

pub fn extr_10b_crop_fast_rem(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let w = cc.new_w as usize;
        let h = cc.new_h as usize;

        let y_row = packed_row_size(w);
        let uv_row = packed_row_size(w / 2);
        let y_pack = y_row * h;
        let uv_pack = uv_row * h / 2;

        let y_src = from_raw_parts(f.data[0].add(cc.y_start), w * h * 2);
        pack_10b_rem(y_src, &mut output[..y_pack], w, h);

        let u_src = from_raw_parts(f.data[1].add(cc.uv_off), w * h / 2);
        pack_10b_rem(u_src, &mut output[y_pack..y_pack + uv_pack], w / 2, h / 2);

        let v_src = from_raw_parts(f.data[2].add(cc.uv_off), w * h / 2);
        pack_10b_rem(v_src, &mut output[y_pack + uv_pack..], w / 2, h / 2);
    }
}

pub fn extr_10b_crop_rem(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let w = cc.new_w as usize;
        let h = cc.new_h as usize;

        let y_row = packed_row_size(w);
        let uv_row = packed_row_size(w / 2);
        let y_pack = y_row * h;
        let uv_pack = uv_row * h / 2;

        pack_stride_rem(
            f.data[0].add(cc.y_start),
            f.linesize[0] as usize,
            w,
            h,
            output.as_mut_ptr(),
        );
        pack_stride_rem(
            f.data[1].add(cc.uv_off),
            f.linesize[1] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack),
        );
        pack_stride_rem(
            f.data[2].add(cc.uv_off),
            f.linesize[2] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack + uv_pack),
        );
    }
}

pub fn extr_10b_crop_pack_stride_rem(
    frame: *const VidFrame,
    output: &mut [u8],
    crop_calc: &CropCalc,
) {
    unsafe {
        let f = &*frame;
        let w = crop_calc.new_w as usize;
        let h = crop_calc.new_h as usize;
        let pix_sz = 2;

        let y_linesize = f.linesize[0] as usize;
        let uv_linesize = f.linesize[1] as usize;

        let y_row = packed_row_size(w);
        let uv_row = packed_row_size(w / 2);

        let y_simd_in = crop_calc.y_len / PACK_CHUNK * PACK_CHUNK;
        let y_simd_out = (y_simd_in * 5) / 8;
        let y_aligned = crop_calc.y_len & !7;
        let y_pack_aligned = (y_aligned * 5) / 8;

        let uv_simd_in = crop_calc.uv_len / PACK_CHUNK * PACK_CHUNK;
        let uv_simd_out = (uv_simd_in * 5) / 8;
        let uv_aligned = crop_calc.uv_len & !7;
        let uv_pack_aligned = (uv_aligned * 5) / 8;

        let mut dst_pos = 0;

        for row in 0..h {
            let src_off = (crop_calc.crop_h as usize * pix_sz)
                + (row + crop_calc.crop_v as usize) * y_linesize;
            let src_row = from_raw_parts(f.data[0].add(src_off), crop_calc.y_len);
            let dst_row = from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), y_row);

            pack_10b(&src_row[..y_simd_in], &mut dst_row[..y_simd_out]);

            src_row[y_simd_in..y_aligned]
                .chunks_exact(8)
                .zip(dst_row[y_simd_out..y_pack_aligned].chunks_exact_mut(5))
                .for_each(|(i, o)| {
                    pack_4_pix_10b(
                        i.try_into().unwrap_unchecked(),
                        o.try_into().unwrap_unchecked(),
                    );
                });

            let rem = crop_calc.y_len % 8;
            if rem > 0 {
                let mut tmp = [0u8; 8];
                tmp[..rem].copy_from_slice(&src_row[crop_calc.y_len - rem..]);
                pack_4_pix_10b(
                    tmp,
                    (&mut dst_row[y_row - 5..]).try_into().unwrap_unchecked(),
                );
            }

            dst_pos += y_row;
        }

        for row in 0..h / 2 {
            let src_off = (crop_calc.crop_h as usize / 2 * pix_sz)
                + (row + crop_calc.crop_v as usize / 2) * uv_linesize;
            let src_row = from_raw_parts(f.data[1].add(src_off), crop_calc.uv_len);
            let dst_row = from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), uv_row);

            pack_10b(&src_row[..uv_simd_in], &mut dst_row[..uv_simd_out]);

            src_row[uv_simd_in..uv_aligned]
                .chunks_exact(8)
                .zip(dst_row[uv_simd_out..uv_pack_aligned].chunks_exact_mut(5))
                .for_each(|(i, o)| {
                    pack_4_pix_10b(
                        i.try_into().unwrap_unchecked(),
                        o.try_into().unwrap_unchecked(),
                    );
                });

            let rem = crop_calc.uv_len % 8;
            if rem > 0 {
                let mut tmp = [0u8; 8];
                tmp[..rem].copy_from_slice(&src_row[crop_calc.uv_len - rem..]);
                pack_4_pix_10b(
                    tmp,
                    (&mut dst_row[uv_row - 5..]).try_into().unwrap_unchecked(),
                );
            }

            dst_pos += uv_row;
        }

        for row in 0..h / 2 {
            let src_off = (crop_calc.crop_h as usize / 2 * pix_sz)
                + (row + crop_calc.crop_v as usize / 2) * uv_linesize;
            let src_row = from_raw_parts(f.data[2].add(src_off), crop_calc.uv_len);
            let dst_row = from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), uv_row);

            pack_10b(&src_row[..uv_simd_in], &mut dst_row[..uv_simd_out]);

            src_row[uv_simd_in..uv_aligned]
                .chunks_exact(8)
                .zip(dst_row[uv_simd_out..uv_pack_aligned].chunks_exact_mut(5))
                .for_each(|(i, o)| {
                    pack_4_pix_10b(
                        i.try_into().unwrap_unchecked(),
                        o.try_into().unwrap_unchecked(),
                    );
                });

            let rem = crop_calc.uv_len % 8;
            if rem > 0 {
                let mut tmp = [0u8; 8];
                tmp[..rem].copy_from_slice(&src_row[crop_calc.uv_len - rem..]);
                pack_4_pix_10b(
                    tmp,
                    (&mut dst_row[uv_row - 5..]).try_into().unwrap_unchecked(),
                );
            }

            dst_pos += uv_row;
        }
    }
}

pub const fn extr_10b_raw(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let w = inf.width as usize;
        let h = inf.height as usize;
        let y_size = w * h * 2;
        let uv_size = y_size / 4;

        copy_nonoverlapping(f.data[0], output.as_mut_ptr(), y_size);
        copy_nonoverlapping(f.data[1], output.as_mut_ptr().add(y_size), uv_size);
        copy_nonoverlapping(
            f.data[2],
            output.as_mut_ptr().add(y_size + uv_size),
            uv_size,
        );
    }
}

pub fn extr_10b_raw_stride(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let w = inf.width as usize;
        let h = inf.height as usize;
        let y_linesize = f.linesize[0] as usize;
        let uv_linesize = f.linesize[1] as usize;
        let w_bytes = w * 2;
        let uv_w_bytes = w;

        let mut pos = 0;
        for row in 0..h {
            copy_nonoverlapping(
                f.data[0].add(row * y_linesize),
                output.as_mut_ptr().add(pos),
                w_bytes,
            );
            pos += w_bytes;
        }
        for row in 0..h / 2 {
            copy_nonoverlapping(
                f.data[1].add(row * uv_linesize),
                output.as_mut_ptr().add(pos),
                uv_w_bytes,
            );
            pos += uv_w_bytes;
        }
        for row in 0..h / 2 {
            copy_nonoverlapping(
                f.data[2].add(row * uv_linesize),
                output.as_mut_ptr().add(pos),
                uv_w_bytes,
            );
            pos += uv_w_bytes;
        }
    }
}

pub const fn extr_10b_raw_crop_fast(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let y_sz = cc.new_w as usize * cc.new_h as usize * 2;
        let uv_sz = y_sz / 4;

        copy_nonoverlapping(f.data[0].add(cc.y_start), output.as_mut_ptr(), y_sz);
        copy_nonoverlapping(
            f.data[1].add(cc.uv_off),
            output.as_mut_ptr().add(y_sz),
            uv_sz,
        );
        copy_nonoverlapping(
            f.data[2].add(cc.uv_off),
            output.as_mut_ptr().add(y_sz + uv_sz),
            uv_sz,
        );
    }
}

pub fn extr_10b_raw_crop(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let mut pos = 0;

        for row in 0..cc.new_h as usize {
            copy_nonoverlapping(
                f.data[0].add(cc.y_start + row * cc.y_stride),
                output.as_mut_ptr().add(pos),
                cc.y_len,
            );
            pos += cc.y_len;
        }
        for row in 0..cc.new_h as usize / 2 {
            copy_nonoverlapping(
                f.data[1].add(cc.uv_off + row * cc.uv_stride),
                output.as_mut_ptr().add(pos),
                cc.uv_len,
            );
            pos += cc.uv_len;
        }
        for row in 0..cc.new_h as usize / 2 {
            copy_nonoverlapping(
                f.data[2].add(cc.uv_off + row * cc.uv_stride),
                output.as_mut_ptr().add(pos),
                cc.uv_len,
            );
            pos += cc.uv_len;
        }
    }
}

pub fn extr_10b_raw_crop_stride(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let w = cc.new_w as usize;
        let h = cc.new_h as usize;
        let pix_sz = 2;
        let y_linesize = f.linesize[0] as usize;
        let uv_linesize = f.linesize[1] as usize;
        let w_bytes = w * pix_sz;
        let uv_w_bytes = w / 2 * pix_sz;

        let mut pos = 0;
        for row in 0..h {
            let src_off = cc.crop_h as usize * pix_sz + (row + cc.crop_v as usize) * y_linesize;
            copy_nonoverlapping(
                f.data[0].add(src_off),
                output.as_mut_ptr().add(pos),
                w_bytes,
            );
            pos += w_bytes;
        }
        for row in 0..h / 2 {
            let src_off =
                cc.crop_h as usize / 2 * pix_sz + (row + cc.crop_v as usize / 2) * uv_linesize;
            copy_nonoverlapping(
                f.data[1].add(src_off),
                output.as_mut_ptr().add(pos),
                uv_w_bytes,
            );
            pos += uv_w_bytes;
        }
        for row in 0..h / 2 {
            let src_off =
                cc.crop_h as usize / 2 * pix_sz + (row + cc.crop_v as usize / 2) * uv_linesize;
            copy_nonoverlapping(
                f.data[2].add(src_off),
                output.as_mut_ptr().add(pos),
                uv_w_bytes,
            );
            pos += uv_w_bytes;
        }
    }
}

pub fn nv12_to_10b(input: &[u8], output: &mut [u8], w: usize, h: usize) {
    let y_in = w * h;
    let y_out = y_in * 2;
    let uv_plane = w / 2 * (h / 2);

    unsafe {
        conv_to_10b(
            input.get_unchecked(..y_in),
            from_raw_parts_mut(output.as_mut_ptr(), y_out),
        );
        let chroma = from_raw_parts_mut(output.as_mut_ptr().add(y_out).cast::<u16>(), uv_plane * 2);
        let (u_dst, v_dst) = chroma.split_at_mut(uv_plane);
        deint_nv12_to_10b(input.get_unchecked(y_in..), u_dst, v_dst);
    }
}

fn deint_nv12_rem(src: &[u8], u_dst: &mut [u8], v_dst: &mut [u8]) {
    let chunk = SHIFT_CHUNK * 2;
    let aligned = u_dst.len() / chunk * chunk;
    if aligned > 0 {
        deint_nv12(
            &src[..aligned * 2],
            &mut u_dst[..aligned],
            &mut v_dst[..aligned],
        );
    }
    for i in aligned..u_dst.len() {
        u_dst[i] = src[i * 2];
        v_dst[i] = src[i * 2 + 1];
    }
}

fn deint_p010_rem(src: &[u16], u_dst: &mut [u16], v_dst: &mut [u16]) {
    let aligned = u_dst.len() / SHIFT_CHUNK * SHIFT_CHUNK;
    if aligned > 0 {
        deint_p010(
            &src[..aligned * 2],
            &mut u_dst[..aligned],
            &mut v_dst[..aligned],
        );
    }
    for i in aligned..u_dst.len() {
        u_dst[i] = src[i * 2] >> 6;
        v_dst[i] = src[i * 2 + 1] >> 6;
    }
}

fn deint_nv12_to_10b_rem(src: &[u8], u_dst: &mut [u16], v_dst: &mut [u16]) {
    let chunk = SHIFT_CHUNK * 2;
    let aligned = u_dst.len() / chunk * chunk;
    if aligned > 0 {
        deint_nv12_to_10b(
            &src[..aligned * 2],
            &mut u_dst[..aligned],
            &mut v_dst[..aligned],
        );
    }
    for i in aligned..u_dst.len() {
        u_dst[i] = u16::from(src[i * 2]) << 2;
        v_dst[i] = u16::from(src[i * 2 + 1]) << 2;
    }
}

pub fn nv12_to_10b_rem(input: &[u8], output: &mut [u8], w: usize, h: usize) {
    let y_in = w * h;
    let y_out = y_in * 2;
    let uv_plane = w / 2 * (h / 2);

    unsafe {
        let y_src = input.get_unchecked(..y_in);
        let y_dst = from_raw_parts_mut(output.as_mut_ptr(), y_out);
        let aligned = y_in / SHIFT_CHUNK * SHIFT_CHUNK;
        if aligned > 0 {
            conv_to_10b(
                y_src.get_unchecked(..aligned),
                from_raw_parts_mut(y_dst.as_mut_ptr(), aligned * 2),
            );
        }
        for i in aligned..y_in {
            let [lo, hi] = (u16::from(y_src[i]) << 2).to_le_bytes();
            y_dst[i * 2] = lo;
            y_dst[i * 2 + 1] = hi;
        }

        let chroma = from_raw_parts_mut(output.as_mut_ptr().add(y_out).cast::<u16>(), uv_plane * 2);
        let (u_dst, v_dst) = chroma.split_at_mut(uv_plane);
        deint_nv12_to_10b_rem(input.get_unchecked(y_in..), u_dst, v_dst);
    }
}

pub fn extr_hw_nv12(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let w = inf.width as usize;
        let h = inf.height as usize;
        let y_size = w * h;
        let uv_w = w / 2;
        let uv_size = uv_w * (h / 2);

        copy_nonoverlapping(f.data[0], output.as_mut_ptr(), y_size);

        let src = from_raw_parts(f.data[1], w * (h / 2));
        let u_dst = from_raw_parts_mut(output.as_mut_ptr().add(y_size), uv_size);
        let v_dst = from_raw_parts_mut(output.as_mut_ptr().add(y_size + uv_size), uv_size);
        deint_nv12(src, u_dst, v_dst);
    }
}

pub fn extr_hw_nv12_stride(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let w = inf.width as usize;
        let h = inf.height as usize;
        let y_ls = f.linesize[0] as usize;
        let uv_ls = f.linesize[1] as usize;
        let y_size = w * h;
        let uv_w = w / 2;
        let uv_size = uv_w * (h / 2);

        for row in 0..h {
            copy_nonoverlapping(
                f.data[0].add(row * y_ls),
                output.as_mut_ptr().add(row * w),
                w,
            );
        }

        for row in 0..h / 2 {
            let src = from_raw_parts(f.data[1].add(row * uv_ls), uv_w * 2);
            let u_dst = from_raw_parts_mut(output.as_mut_ptr().add(y_size + row * uv_w), uv_w);
            let v_dst =
                from_raw_parts_mut(output.as_mut_ptr().add(y_size + uv_size + row * uv_w), uv_w);
            deint_nv12_rem(src, u_dst, v_dst);
        }
    }
}

pub fn extr_hw_nv12_crop(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let w = cc.new_w as usize;
        let h = cc.new_h as usize;
        let y_ls = f.linesize[0] as usize;
        let uv_ls = f.linesize[1] as usize;
        let cv = cc.crop_v as usize;
        let ch = cc.crop_h as usize;
        let y_size = w * h;
        let uv_w = w / 2;
        let uv_size = uv_w * (h / 2);

        for row in 0..h {
            let src = from_raw_parts(f.data[0].add((row + cv) * y_ls + ch), w);
            let dst = from_raw_parts_mut(output.as_mut_ptr().add(row * w), w);
            dst.copy_from_slice(src);
        }

        for row in 0..h / 2 {
            let src = from_raw_parts(f.data[1].add((row + cv / 2) * uv_ls + ch), uv_w * 2);
            let u_dst = from_raw_parts_mut(output.as_mut_ptr().add(y_size + row * uv_w), uv_w);
            let v_dst =
                from_raw_parts_mut(output.as_mut_ptr().add(y_size + uv_size + row * uv_w), uv_w);
            deint_nv12_rem(src, u_dst, v_dst);
        }
    }
}

pub const fn extr_hw_nv12_to10(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let w = inf.width as usize;
        let h = inf.height as usize;
        let y_size = w * h;

        copy_nonoverlapping(f.data[0], output.as_mut_ptr(), y_size);
        copy_nonoverlapping(f.data[1], output.as_mut_ptr().add(y_size), w * (h / 2));
    }
}

pub fn extr_hw_nv12_to10_stride(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let w = inf.width as usize;
        let h = inf.height as usize;
        let y_ls = f.linesize[0] as usize;
        let uv_ls = f.linesize[1] as usize;
        let y_size = w * h;

        for row in 0..h {
            copy_nonoverlapping(
                f.data[0].add(row * y_ls),
                output.as_mut_ptr().add(row * w),
                w,
            );
        }
        for row in 0..h / 2 {
            copy_nonoverlapping(
                f.data[1].add(row * uv_ls),
                output.as_mut_ptr().add(y_size + row * w),
                w,
            );
        }
    }
}

pub fn extr_hw_nv12_crop_to10(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let w = cc.new_w as usize;
        let h = cc.new_h as usize;
        let y_ls = f.linesize[0] as usize;
        let uv_ls = f.linesize[1] as usize;
        let cv = cc.crop_v as usize;
        let ch = cc.crop_h as usize;
        let y_size = w * h;

        for row in 0..h {
            copy_nonoverlapping(
                f.data[0].add((row + cv) * y_ls + ch),
                output.as_mut_ptr().add(row * w),
                w,
            );
        }
        for row in 0..h / 2 {
            copy_nonoverlapping(
                f.data[1].add((row + cv / 2) * uv_ls + ch),
                output.as_mut_ptr().add(y_size + row * w),
                w,
            );
        }
    }
}

#[inline]
pub fn extr_hw_p010_raw_wh(frame: *const VidFrame, output: &mut [u8], w: usize, h: usize) {
    unsafe {
        let f = &*frame;
        let y_size = w * h * 2;
        let uv_w = w / 2;
        let uv_size = uv_w * (h / 2) * 2;

        let src = from_raw_parts(f.data[0].cast::<u16>(), w * h);
        let dst = from_raw_parts_mut(output.as_mut_ptr().cast::<u16>(), w * h);
        shift_p010(src, dst);

        let src = from_raw_parts(f.data[1].cast::<u16>(), w * (h / 2));
        let u_dst = from_raw_parts_mut(
            output.as_mut_ptr().add(y_size).cast::<u16>(),
            uv_w * (h / 2),
        );
        let v_dst = from_raw_parts_mut(
            output.as_mut_ptr().add(y_size + uv_size).cast::<u16>(),
            uv_w * (h / 2),
        );
        deint_p010_rem(src, u_dst, v_dst);
    }
}

pub fn extr_hw_p010_raw(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    extr_hw_p010_raw_wh(frame, output, inf.width as usize, inf.height as usize);
}

#[inline]
pub fn extr_hw_p010_raw_wh_rem(frame: *const VidFrame, output: &mut [u8], w: usize, h: usize) {
    unsafe {
        let f = &*frame;
        let y_size = w * h * 2;
        let uv_w = w / 2;
        let uv_size = uv_w * (h / 2) * 2;

        let src = from_raw_parts(f.data[0].cast::<u16>(), w * h);
        let dst = from_raw_parts_mut(output.as_mut_ptr().cast::<u16>(), w * h);
        shift_p010_rem(src, dst);

        let src = from_raw_parts(f.data[1].cast::<u16>(), w * (h / 2));
        let u_dst = from_raw_parts_mut(
            output.as_mut_ptr().add(y_size).cast::<u16>(),
            uv_w * (h / 2),
        );
        let v_dst = from_raw_parts_mut(
            output.as_mut_ptr().add(y_size + uv_size).cast::<u16>(),
            uv_w * (h / 2),
        );
        deint_p010_rem(src, u_dst, v_dst);
    }
}

#[inline]
pub fn extr_hw_p010_raw_wh_rem_stride(
    frame: *const VidFrame,
    output: &mut [u8],
    w: usize,
    h: usize,
) {
    unsafe {
        let f = &*frame;
        let y_ls = f.linesize[0] as usize;
        let uv_ls = f.linesize[1] as usize;
        let w_bytes = w * 2;
        let y_size = w * h * 2;
        let uv_w = w / 2;
        let uv_size = uv_w * (h / 2) * 2;

        for row in 0..h {
            let src = from_raw_parts(f.data[0].add(row * y_ls).cast::<u16>(), w);
            let dst = from_raw_parts_mut(output.as_mut_ptr().add(row * w_bytes).cast::<u16>(), w);
            shift_p010_rem(src, dst);
        }

        for row in 0..h / 2 {
            let src = from_raw_parts(f.data[1].add(row * uv_ls).cast::<u16>(), w);
            let u_dst = from_raw_parts_mut(
                output
                    .as_mut_ptr()
                    .add(y_size + row * uv_w * 2)
                    .cast::<u16>(),
                uv_w,
            );
            let v_dst = from_raw_parts_mut(
                output
                    .as_mut_ptr()
                    .add(y_size + uv_size + row * uv_w * 2)
                    .cast::<u16>(),
                uv_w,
            );
            deint_p010_rem(src, u_dst, v_dst);
        }
    }
}

pub fn extr_hw_p010_raw_rem(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    extr_hw_p010_raw_wh_rem(frame, output, inf.width as usize, inf.height as usize);
}

pub fn extr_hw_p010_raw_rem_stride(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    extr_hw_p010_raw_wh_rem_stride(frame, output, inf.width as usize, inf.height as usize);
}

pub fn extr_hw_p010_raw_crop(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let w = cc.new_w as usize;
        let h = cc.new_h as usize;
        let y_ls = f.linesize[0] as usize;
        let uv_ls = f.linesize[1] as usize;
        let cv = cc.crop_v as usize;
        let ch = cc.crop_h as usize;
        let y_size = w * h * 2;
        let uv_w = w / 2;
        let uv_size = uv_w * (h / 2) * 2;

        for row in 0..h {
            let src = from_raw_parts(f.data[0].add((row + cv) * y_ls + ch * 2).cast::<u16>(), w);
            let dst = from_raw_parts_mut(output.as_mut_ptr().add(row * w * 2).cast::<u16>(), w);
            shift_p010_rem(src, dst);
        }

        for row in 0..h / 2 {
            let src = from_raw_parts(
                f.data[1].add((row + cv / 2) * uv_ls + ch * 2).cast::<u16>(),
                w,
            );
            let u_dst = from_raw_parts_mut(
                output
                    .as_mut_ptr()
                    .add(y_size + row * uv_w * 2)
                    .cast::<u16>(),
                uv_w,
            );
            let v_dst = from_raw_parts_mut(
                output
                    .as_mut_ptr()
                    .add(y_size + uv_size + row * uv_w * 2)
                    .cast::<u16>(),
                uv_w,
            );
            deint_p010_rem(src, u_dst, v_dst);
        }
    }
}

pub fn extr_hw_p010_raw_crop_rem(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let w = cc.new_w as usize;
        let h = cc.new_h as usize;
        let y_ls = f.linesize[0] as usize;
        let uv_ls = f.linesize[1] as usize;
        let cv = cc.crop_v as usize;
        let ch = cc.crop_h as usize;
        let y_size = w * h * 2;
        let uv_w = w / 2;
        let uv_size = uv_w * (h / 2) * 2;

        for row in 0..h {
            let src = from_raw_parts(f.data[0].add((row + cv) * y_ls + ch * 2).cast::<u16>(), w);
            let dst = from_raw_parts_mut(output.as_mut_ptr().add(row * w * 2).cast::<u16>(), w);
            shift_p010_rem(src, dst);
        }

        for row in 0..h / 2 {
            let src = from_raw_parts(
                f.data[1].add((row + cv / 2) * uv_ls + ch * 2).cast::<u16>(),
                w,
            );
            let u_dst = from_raw_parts_mut(
                output
                    .as_mut_ptr()
                    .add(y_size + row * uv_w * 2)
                    .cast::<u16>(),
                uv_w,
            );
            let v_dst = from_raw_parts_mut(
                output
                    .as_mut_ptr()
                    .add(y_size + uv_size + row * uv_w * 2)
                    .cast::<u16>(),
                uv_w,
            );
            deint_p010_rem(src, u_dst, v_dst);
        }
    }
}
