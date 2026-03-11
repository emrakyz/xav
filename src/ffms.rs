use std::{
    ffi::{CStr, CString, c_char, c_int, c_uint, c_void},
    path::Path,
    ptr::{addr_of_mut, copy_nonoverlapping, null, null_mut},
    slice::{from_raw_parts, from_raw_parts_mut},
    sync::Mutex,
    thread::available_parallelism,
};

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
use crate::simd::{conv_to_10bit_avx2, pack_10bit_avx2, unpack_10bit_avx2};
#[cfg(target_feature = "avx512bw")]
use crate::simd::{conv_to_10bit_avx512, pack_10bit_avx512, unpack_10bit_avx512};
use crate::{
    Xerr,
    decode::CropCalc,
    error::Xerr::Msg,
    ffms::DecodeStrat::{
        B8Crop, B8CropFast, B8CropStride, B8Fast, B8Stride, B10Crop, B10CropFast, B10CropFastRem,
        B10CropRem, B10CropStride, B10CropStrideRem, B10Fast, B10FastRem, B10Raw, B10RawCrop,
        B10RawCropFast, B10RawCropStride, B10RawStride, B10Stride, B10StrideRem, HwNv12,
        HwNv12Crop, HwNv12CropTo10, HwNv12To10, HwP010CropPack, HwP010Pack, HwP010Raw,
        HwP010RawCrop,
    },
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
    pts: i64,
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
    pub is_10bit: bool,
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
    stream_tb: AVRational,
    fps: AVRational,
}

unsafe impl Send for VideoDecoder {}

impl VideoDecoder {
    pub fn new(path: &Path, threads: i32) -> Result<Self, Xerr> {
        unsafe {
            let cpath = CString::new(path.to_str().ok_or("invalid path")?)?;
            let mut fmt_ctx: *mut AVFormatContext = null_mut();

            if avformat_open_input(addr_of_mut!(fmt_ctx), cpath.as_ptr(), null(), null_mut()) < 0 {
                return Err(ff_err("decoder: open failed"));
            }

            avformat_find_stream_info(fmt_ctx, null_mut());

            let mut dec: *const c_void = null();
            let idx =
                av_find_best_stream(fmt_ctx, AVMEDIA_TYPE_VIDEO, -1, -1, addr_of_mut!(dec), 0);
            if idx < 0 {
                avformat_close_input(addr_of_mut!(fmt_ctx));
                return Err(ff_err("decoder: no video stream"));
            }

            let stream = *(*fmt_ctx).streams.add(idx as usize);
            let par = &*(*stream).codecpar;
            let stream_tb = (*stream).time_base;
            let fps = (*stream).avg_frame_rate;

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
                stream_tb,
                fps,
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

            avformat_find_stream_info(fmt_ctx, null_mut());

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

            let stream_tb = (*stream).time_base;
            let fps = (*stream).avg_frame_rate;

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
                stream_tb,
                fps,
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

    fn pts_to_frame(&self, pts: i64) -> usize {
        if self.fps.num > 0 && self.fps.den > 0 {
            let num = pts * i64::from(self.stream_tb.num) * i64::from(self.fps.num);
            let den = i64::from(self.stream_tb.den) * i64::from(self.fps.den);
            ((num + den / 2) / den) as usize
        } else {
            pts as usize
        }
    }

    pub fn seek_to(&mut self, frame_idx: usize) {
        if self.next_frame == frame_idx + 1 {
            return;
        }
        if frame_idx < self.next_frame || self.next_frame == 0 || frame_idx - self.next_frame > 150
        {
            unsafe {
                let ts = if self.fps.num > 0 && self.fps.den > 0 {
                    frame_idx as i64 * i64::from(self.stream_tb.den) * i64::from(self.fps.den)
                        / (i64::from(self.stream_tb.num) * i64::from(self.fps.num))
                } else {
                    frame_idx as i64
                };
                av_seek_frame(self.fmt_ctx, self.stream_idx, ts, AVSEEK_FLAG_BACKWARD);
                avcodec_flush_buffers(self.codec_ctx);
                self.eof = false;
                self.decode_next();
                self.next_frame = self.pts_to_frame((*self.frame).pts) + 1;
            }
        }
        while self.next_frame <= frame_idx && !self.eof {
            self.decode_next();
        }
    }

    pub fn skip_to(&mut self, frame_idx: usize) {
        if frame_idx == self.next_frame {
            return;
        }
        if frame_idx < self.next_frame || frame_idx - self.next_frame > 150 {
            unsafe {
                let ts = if self.fps.num > 0 && self.fps.den > 0 {
                    frame_idx as i64 * i64::from(self.stream_tb.den) * i64::from(self.fps.den)
                        / (i64::from(self.stream_tb.num) * i64::from(self.fps.num))
                } else {
                    frame_idx as i64
                };
                av_seek_frame(self.fmt_ctx, self.stream_idx, ts, AVSEEK_FLAG_BACKWARD);
                avcodec_flush_buffers(self.codec_ctx);
                self.eof = false;
                self.decode_next();
                self.next_frame = self.pts_to_frame((*self.frame).pts) + 1;
            }
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

fn frames_from_last_pts(
    fmt_ctx: *mut AVFormatContext,
    idx: c_int,
    dur: i64,
    start: i64,
    tb: AVRational,
    fps: AVRational,
) -> usize {
    unsafe {
        av_seek_frame(
            fmt_ctx,
            idx,
            if dur > 0 { dur } else { i64::MAX / 2 },
            AVSEEK_FLAG_BACKWARD,
        );
        let mut pkt = av_packet_alloc();
        let mut max_pts: i64 = -1;
        while av_read_frame(fmt_ctx, pkt) >= 0 {
            if (*pkt).stream_index == idx {
                max_pts = max_pts.max((*pkt).pts);
            }
            av_packet_unref(pkt);
        }
        av_packet_free(addr_of_mut!(pkt));
        av_seek_frame(fmt_ctx, idx, 0, AVSEEK_FLAG_BACKWARD);
        if max_pts < 0 {
            return count_video_packets(fmt_ctx, idx);
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

        let n = (*fmt_ctx).nb_streams as usize;
        for i in 0..n {
            let stream = &mut *(*(*fmt_ctx).streams.add(i));
            if (*stream.codecpar).codec_type != AVMEDIA_TYPE_VIDEO {
                stream.discard = 48;
            }
        }

        let probesize = c"probesize";
        let analyzeduration = c"analyzeduration";
        av_opt_set_int(fmt_ctx.cast(), probesize.as_ptr(), 0x8000, 1);
        av_opt_set_int(fmt_ctx.cast(), analyzeduration.as_ptr(), 0, 1);
        avformat_find_stream_info(fmt_ctx, null_mut());

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

        let frames = if fps.den > 0 {
            let from_pts = frames_from_last_pts(
                fmt_ctx,
                idx,
                stream.duration,
                stream.start_time,
                stream.time_base,
                fps,
            );
            if stream.nb_frames > 0 {
                from_pts.min(stream.nb_frames as usize)
            } else {
                from_pts
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
            is_10bit: fmeta.is_10bit,
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

        let n = (*fmt_ctx).nb_streams as usize;
        for i in 0..n {
            let stream = &mut *(*(*fmt_ctx).streams.add(i));
            if (*stream.codecpar).codec_type != AVMEDIA_TYPE_AUDIO {
                stream.discard = 48;
            }
        }

        let probesize = c"probesize";
        let analyzeduration = c"analyzeduration";
        av_opt_set_int(fmt_ctx.cast(), probesize.as_ptr(), 0x8000, 1);
        av_opt_set_int(fmt_ctx.cast(), analyzeduration.as_ptr(), 0, 1);
        avformat_find_stream_info(fmt_ctx, null_mut());

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
    is_10bit: bool,
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
            is_10bit: false,
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
        is_10bit: f.format == AV_PIX_FMT_YUV420P10LE,
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

#[inline]
const fn packed_row_size(w: usize) -> usize {
    (w * 2 * 5).div_ceil(8).next_multiple_of(5)
}

pub const fn calc_8bit_size(w: u32, h: u32) -> usize {
    (w * h * 3 / 2) as usize
}

pub const fn calc_packed_size(w: u32, h: u32) -> usize {
    let y_row = packed_row_size(w as usize);
    let uv_row = packed_row_size(w as usize / 2);
    y_row * h as usize + uv_row * h as usize
}

fn copy_with_stride(src: *const u8, stride: usize, width: usize, height: usize, dst: *mut u8) {
    unsafe {
        for row in 0..height {
            copy_nonoverlapping(src.add(row * stride), dst.add(row * width), width);
        }
    }
}

pub fn extr_8bit(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
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

pub const fn extr_8bit_crop_fast(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
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

pub fn extr_8bit_crop(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
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

pub const fn extr_8bit_fast(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
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

pub fn conv_to_10bit(input: &[u8], output: &mut [u8]) {
    #[cfg(target_feature = "avx512bw")]
    unsafe {
        conv_to_10bit_avx512(input, output);
    }
    #[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
    unsafe {
        conv_to_10bit_avx2(input, output);
    }
    #[cfg(not(any(target_feature = "avx2", target_feature = "avx512bw")))]
    input
        .iter()
        .zip(output.chunks_exact_mut(2))
        .for_each(|(&pixel, out_chunk)| {
            let pixel_10bit = (u16::from(pixel) << 2).to_le_bytes();
            out_chunk.copy_from_slice(&pixel_10bit);
        });
}

#[inline]
pub fn pack_4_pix_10bit(input: [u8; 8], output: &mut [u8; 5]) {
    let raw = u64::from_le_bytes(input);
    let p0 = u64::from(raw as u16);
    let p1 = u64::from((raw >> 16) as u16);
    let p2 = u64::from((raw >> 32) as u16);
    let p3 = raw >> 48;
    let packed = p0 | (p1 << 10) | (p2 << 20) | (p3 << 30);
    output.copy_from_slice(&packed.to_le_bytes()[..5]);
}

#[inline]
pub const fn unpack_4_pix_10bit(input: [u8; 5], output: &mut [u8; 8]) {
    let packed = u64::from_le_bytes([input[0], input[1], input[2], input[3], input[4], 0, 0, 0]);
    let result = (packed & 0x3FF)
        | (((packed >> 10) & 0x3FF) << 16)
        | (((packed >> 20) & 0x3FF) << 32)
        | (((packed >> 30) & 0x3FF) << 48);
    *output = result.to_le_bytes();
}

pub fn pack_10bit(input: &[u8], output: &mut [u8]) {
    #[cfg(target_feature = "avx512bw")]
    unsafe {
        pack_10bit_avx512(input.as_ptr(), output.as_mut_ptr(), input.len());
    }
    #[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
    unsafe {
        pack_10bit_avx2(input.as_ptr(), output.as_mut_ptr(), input.len());
    }
    #[cfg(not(any(target_feature = "avx2", target_feature = "avx512bw")))]
    input
        .chunks_exact(8)
        .zip(output.chunks_exact_mut(5))
        .for_each(|(i_chunk, o_chunk)| {
            let i_arr: &[u8; 8] = unsafe { i_chunk.try_into().unwrap_unchecked() };
            let o_arr: &mut [u8; 5] = unsafe { o_chunk.try_into().unwrap_unchecked() };
            pack_4_pix_10bit(*i_arr, o_arr);
        });
}

pub fn unpack_10bit(input: &[u8], output: &mut [u8], _w: usize, _h: usize) {
    #[cfg(target_feature = "avx512bw")]
    unsafe {
        unpack_10bit_avx512(input.as_ptr(), output.as_mut_ptr(), input.len());
    }
    #[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
    unsafe {
        unpack_10bit_avx2(input.as_ptr(), output.as_mut_ptr(), input.len());
    }
    #[cfg(not(any(target_feature = "avx2", target_feature = "avx512bw")))]
    input
        .chunks_exact(5)
        .zip(output.chunks_exact_mut(8))
        .for_each(|(i_chunk, o_chunk)| {
            let i_arr: &[u8; 5] = unsafe { i_chunk.try_into().unwrap_unchecked() };
            let o_arr: &mut [u8; 8] = unsafe { o_chunk.try_into().unwrap_unchecked() };
            unpack_4_pix_10bit(*i_arr, o_arr);
        });
}

pub fn unpack_10bit_rem(input: &[u8], output: &mut [u8], w: usize, h: usize) {
    let y_packed = packed_row_size(w) * h;
    let uv_packed = packed_row_size(w / 2) * (h / 2);

    unpack_plane_rem(&input[..y_packed], &mut output[..w * h * 2], w, h);
    unpack_plane_rem(
        &input[y_packed..y_packed + uv_packed],
        &mut output[w * h * 2..w * h * 2 + w * h / 2],
        w / 2,
        h / 2,
    );
    unpack_plane_rem(
        &input[y_packed + uv_packed..],
        &mut output[w * h * 2 + w * h / 2..],
        w / 2,
        h / 2,
    );
}

fn unpack_plane_rem(input: &[u8], output: &mut [u8], w: usize, h: usize) {
    let unpacked_row = w * 2;
    let packed_row = packed_row_size(w);

    for row in 0..h {
        let src = &input[row * packed_row..row * packed_row + packed_row];
        let dst = &mut output[row * unpacked_row..row * unpacked_row + unpacked_row];

        src.chunks_exact(5)
            .zip(dst.chunks_exact_mut(8))
            .for_each(|(i, o)| {
                unpack_4_pix_10bit(unsafe { i.try_into().unwrap_unchecked() }, unsafe {
                    o.try_into().unwrap_unchecked()
                });
            });

        let rem = unpacked_row % 8;
        if rem > 0 {
            let mut tmp = [0u8; 8];
            unpack_4_pix_10bit(
                unsafe { (&src[packed_row - 5..]).try_into().unwrap_unchecked() },
                &mut tmp,
            );
            dst[unpacked_row - rem..].copy_from_slice(&tmp[..rem]);
        }
    }
}

fn pack_stride(src: *const u8, stride: usize, w: usize, h: usize, out: *mut u8) {
    unsafe {
        let w_bytes = w * 2;
        let pack_row = (w_bytes * 5) / 8;
        let mut pos = 0;

        for row in 0..h {
            let src_row = from_raw_parts(src.add(row * stride), w_bytes);
            let dst_row = from_raw_parts_mut(out.add(pos), pack_row);

            src_row
                .chunks_exact(8)
                .zip(dst_row.chunks_exact_mut(5))
                .for_each(|(i, o)| {
                    pack_4_pix_10bit(
                        i.try_into().unwrap_unchecked(),
                        o.try_into().unwrap_unchecked(),
                    );
                });

            pos += pack_row;
        }
    }
}

pub fn extr_10bit_crop_fast(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let w = cc.new_w as usize;
        let h = cc.new_h as usize;
        let y_pack = (w * h * 5) / 4;
        let uv_pack = (w * h / 4 * 5) / 4;

        let y_src = from_raw_parts(f.data[0].add(cc.y_start), w * h * 2);
        pack_10bit(y_src, &mut output[..y_pack]);

        let u_src = from_raw_parts(f.data[1].add(cc.uv_off), w * h / 2);
        pack_10bit(u_src, &mut output[y_pack..y_pack + uv_pack]);

        let v_src = from_raw_parts(f.data[2].add(cc.uv_off), w * h / 2);
        pack_10bit(v_src, &mut output[y_pack + uv_pack..]);
    }
}

pub fn extr_10bit_crop(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
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

#[derive(Clone, Copy)]
pub enum DecodeStrat {
    B10Fast,
    B10FastRem,
    B10Stride,
    B10StrideRem,
    B10Crop { cc: CropCalc },
    B10CropRem { cc: CropCalc },
    B10CropFast { cc: CropCalc },
    B10CropFastRem { cc: CropCalc },
    B10CropStride { cc: CropCalc },
    B10CropStrideRem { cc: CropCalc },
    B10Raw,
    B10RawStride,
    B10RawCropFast { cc: CropCalc },
    B10RawCrop { cc: CropCalc },
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
    HwP010RawCrop { cc: CropCalc },
    HwP010Pack,
    HwP010CropPack { cc: CropCalc },
}

impl DecodeStrat {
    pub const fn to_raw(self) -> Self {
        match self {
            B10Fast | B10FastRem => B10Raw,
            B10Stride | B10StrideRem => B10RawStride,
            B10CropFast { cc } | B10CropFastRem { cc } => B10RawCropFast { cc },
            B10Crop { cc } | B10CropRem { cc } => B10RawCrop { cc },
            B10CropStride { cc } | B10CropStrideRem { cc } => B10RawCropStride { cc },
            HwP010Pack => HwP010Raw,
            HwP010CropPack { cc } => HwP010RawCrop { cc },
            other => other,
        }
    }

    pub const fn is_raw(self) -> bool {
        matches!(
            self,
            B10Raw
                | B10RawStride
                | B10RawCropFast { .. }
                | B10RawCrop { .. }
                | B10RawCropStride { .. }
                | HwP010Raw
                | HwP010RawCrop { .. }
        )
    }

    pub const fn is_hw(self) -> bool {
        matches!(
            self,
            HwNv12
                | HwNv12Crop { .. }
                | HwNv12To10
                | HwNv12CropTo10 { .. }
                | HwP010Raw
                | HwP010RawCrop { .. }
                | HwP010Pack
                | HwP010CropPack { .. }
        )
    }
}

pub fn get_decode_strat(inf: &VidInf, crop: (u32, u32), hwaccel: bool, tq: bool) -> DecodeStrat {
    if hwaccel {
        let has_crop = crop != (0, 0);
        return match (inf.is_10bit, has_crop, tq) {
            (false, false, false) => HwNv12To10,
            (false, true, false) => HwNv12CropTo10 {
                cc: CropCalc::new(inf, crop, 1),
            },
            (false, false, true) => HwNv12,
            (false, true, true) => HwNv12Crop {
                cc: CropCalc::new(inf, crop, 1),
            },
            (true, false, _) => HwP010Pack,
            (true, true, _) => HwP010CropPack {
                cc: CropCalc::new(inf, crop, 2),
            },
        };
    }
    let y_ls = inf.y_linesize;
    let pix_sz = if inf.is_10bit { 2 } else { 1 };
    let expected = inf.width as usize * pix_sz;
    let has_pad = y_ls != expected;
    let has_crop = crop != (0, 0);
    let h_crop = crop.1 != 0;

    let final_w = if has_crop {
        inf.width - crop.1 * 2
    } else {
        inf.width
    };
    let has_rem = inf.is_10bit && (final_w % 8) != 0;

    match (inf.is_10bit, has_crop, has_pad, h_crop, has_rem) {
        (true, false, false, _, false) => B10Fast,
        (true, false, false, _, true) => B10FastRem,
        (true, false, true, _, false) => B10Stride,
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
    }
}

pub fn extr_10bit_pack(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let w = inf.width as usize;
        let h = inf.height as usize;
        let y_pack = (w * h * 5) / 4;
        let uv_pack = (w * h / 4 * 5) / 4;

        let y_src = from_raw_parts(f.data[0], w * h * 2);
        pack_10bit(y_src, &mut output[..y_pack]);

        let u_src = from_raw_parts(f.data[1], w * h / 2);
        pack_10bit(u_src, &mut output[y_pack..y_pack + uv_pack]);

        let v_src = from_raw_parts(f.data[2], w * h / 2);
        pack_10bit(v_src, &mut output[y_pack + uv_pack..]);
    }
}

pub fn extr_10bit_pack_stride(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let w = inf.width as usize;
        let h = inf.height as usize;
        let y_pack = (w * h * 5) / 4;
        let uv_pack = (w * h / 4 * 5) / 4;

        pack_stride(f.data[0], f.linesize[0] as usize, w, h, output.as_mut_ptr());
        pack_stride(
            f.data[1],
            f.linesize[1] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack),
        );
        pack_stride(
            f.data[2],
            f.linesize[2] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack + uv_pack),
        );
    }
}

pub fn extr_8bit_stride(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
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

pub fn extr_10bit_crop_pack_stride(
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

        let mut dst_pos = 0;
        let pack_row_y = (w * 2 * 5) / 8;

        for row in 0..h {
            let src_off = (crop_calc.crop_h as usize * pix_sz)
                + (row + crop_calc.crop_v as usize) * y_linesize;
            let src_row = from_raw_parts(f.data[0].add(src_off), crop_calc.y_len);
            let dst_row = from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), pack_row_y);

            src_row
                .chunks_exact(8)
                .zip(dst_row.chunks_exact_mut(5))
                .for_each(|(i, o)| {
                    pack_4_pix_10bit(
                        i.try_into().unwrap_unchecked(),
                        o.try_into().unwrap_unchecked(),
                    );
                });

            dst_pos += pack_row_y;
        }

        let pack_row_uv = (w / 2 * 2 * 5) / 8;

        for row in 0..h / 2 {
            let src_off = (crop_calc.crop_h as usize / 2 * pix_sz)
                + (row + crop_calc.crop_v as usize / 2) * uv_linesize;
            let src_row = from_raw_parts(f.data[1].add(src_off), crop_calc.uv_len);
            let dst_row = from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), pack_row_uv);

            src_row
                .chunks_exact(8)
                .zip(dst_row.chunks_exact_mut(5))
                .for_each(|(i, o)| {
                    pack_4_pix_10bit(
                        i.try_into().unwrap_unchecked(),
                        o.try_into().unwrap_unchecked(),
                    );
                });

            dst_pos += pack_row_uv;
        }

        for row in 0..h / 2 {
            let src_off = (crop_calc.crop_h as usize / 2 * pix_sz)
                + (row + crop_calc.crop_v as usize / 2) * uv_linesize;
            let src_row = from_raw_parts(f.data[2].add(src_off), crop_calc.uv_len);
            let dst_row = from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), pack_row_uv);

            src_row
                .chunks_exact(8)
                .zip(dst_row.chunks_exact_mut(5))
                .for_each(|(i, o)| {
                    pack_4_pix_10bit(
                        i.try_into().unwrap_unchecked(),
                        o.try_into().unwrap_unchecked(),
                    );
                });

            dst_pos += pack_row_uv;
        }
    }
}

fn pack_stride_rem(src: *const u8, stride: usize, w: usize, h: usize, out: *mut u8) {
    let w_bytes = w * 2;
    let y_row = packed_row_size(w);

    unsafe {
        for row in 0..h {
            let src_row = from_raw_parts(src.add(row * stride), w_bytes);
            let dst_row = from_raw_parts_mut(out.add(row * y_row), y_row);

            src_row
                .chunks_exact(8)
                .zip(dst_row.chunks_exact_mut(5))
                .for_each(|(i, o)| {
                    pack_4_pix_10bit(
                        i.try_into().unwrap_unchecked(),
                        o.try_into().unwrap_unchecked(),
                    );
                });

            let rem = w_bytes % 8;
            if rem > 0 {
                let mut tmp = [0u8; 8];
                tmp[..rem].copy_from_slice(&src_row[w_bytes - rem..]);
                pack_4_pix_10bit(
                    tmp,
                    (&mut dst_row[y_row - 5..]).try_into().unwrap_unchecked(),
                );
            }
        }
    }
}

pub fn pack_10bit_rem(input: &[u8], output: &mut [u8], w: usize, h: usize) {
    let unpacked_row = w * 2;
    let y_row = packed_row_size(w);

    for row in 0..h {
        let src = &input[row * unpacked_row..][..unpacked_row];
        let dst = &mut output[row * y_row..][..y_row];

        src.chunks_exact(8)
            .zip(dst.chunks_exact_mut(5))
            .for_each(|(i, o)| {
                pack_4_pix_10bit(unsafe { i.try_into().unwrap_unchecked() }, unsafe {
                    o.try_into().unwrap_unchecked()
                });
            });

        let rem = unpacked_row % 8;
        if rem > 0 {
            let mut tmp = [0u8; 8];
            tmp[..rem].copy_from_slice(&src[unpacked_row - rem..]);
            pack_4_pix_10bit(tmp, unsafe {
                (&mut dst[y_row - 5..]).try_into().unwrap_unchecked()
            });
        }
    }
}

pub fn extr_10bit_pack_rem(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let w = inf.width as usize;
        let h = inf.height as usize;

        let y_row = packed_row_size(w);
        let uv_row = packed_row_size(w / 2);
        let y_pack = y_row * h;
        let uv_pack = uv_row * h / 2;

        let y_src = from_raw_parts(f.data[0], w * h * 2);
        pack_10bit_rem(y_src, &mut output[..y_pack], w, h);

        let u_src = from_raw_parts(f.data[1], w * h / 2);
        pack_10bit_rem(u_src, &mut output[y_pack..y_pack + uv_pack], w / 2, h / 2);

        let v_src = from_raw_parts(f.data[2], w * h / 2);
        pack_10bit_rem(v_src, &mut output[y_pack + uv_pack..], w / 2, h / 2);
    }
}

pub fn extr_10bit_pack_stride_rem(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
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

pub fn extr_10bit_crop_fast_rem(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
    unsafe {
        let f = &*frame;
        let w = cc.new_w as usize;
        let h = cc.new_h as usize;

        let y_row = packed_row_size(w);
        let uv_row = packed_row_size(w / 2);
        let y_pack = y_row * h;
        let uv_pack = uv_row * h / 2;

        let y_src = from_raw_parts(f.data[0].add(cc.y_start), w * h * 2);
        pack_10bit_rem(y_src, &mut output[..y_pack], w, h);

        let u_src = from_raw_parts(f.data[1].add(cc.uv_off), w * h / 2);
        pack_10bit_rem(u_src, &mut output[y_pack..y_pack + uv_pack], w / 2, h / 2);

        let v_src = from_raw_parts(f.data[2].add(cc.uv_off), w * h / 2);
        pack_10bit_rem(v_src, &mut output[y_pack + uv_pack..], w / 2, h / 2);
    }
}

pub fn extr_10bit_crop_rem(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
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

pub fn extr_10bit_crop_pack_stride_rem(
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

        let mut dst_pos = 0;

        for row in 0..h {
            let src_off = (crop_calc.crop_h as usize * pix_sz)
                + (row + crop_calc.crop_v as usize) * y_linesize;
            let src_row = from_raw_parts(f.data[0].add(src_off), crop_calc.y_len);
            let dst_row = from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), y_row);

            src_row
                .chunks_exact(8)
                .zip(dst_row.chunks_exact_mut(5))
                .for_each(|(i, o)| {
                    pack_4_pix_10bit(
                        i.try_into().unwrap_unchecked(),
                        o.try_into().unwrap_unchecked(),
                    );
                });

            let rem = crop_calc.y_len % 8;
            if rem > 0 {
                let mut tmp = [0u8; 8];
                tmp[..rem].copy_from_slice(&src_row[crop_calc.y_len - rem..]);
                pack_4_pix_10bit(
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

            src_row
                .chunks_exact(8)
                .zip(dst_row.chunks_exact_mut(5))
                .for_each(|(i, o)| {
                    pack_4_pix_10bit(
                        i.try_into().unwrap_unchecked(),
                        o.try_into().unwrap_unchecked(),
                    );
                });

            let rem = crop_calc.uv_len % 8;
            if rem > 0 {
                let mut tmp = [0u8; 8];
                tmp[..rem].copy_from_slice(&src_row[crop_calc.uv_len - rem..]);
                pack_4_pix_10bit(
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

            src_row
                .chunks_exact(8)
                .zip(dst_row.chunks_exact_mut(5))
                .for_each(|(i, o)| {
                    pack_4_pix_10bit(
                        i.try_into().unwrap_unchecked(),
                        o.try_into().unwrap_unchecked(),
                    );
                });

            let rem = crop_calc.uv_len % 8;
            if rem > 0 {
                let mut tmp = [0u8; 8];
                tmp[..rem].copy_from_slice(&src_row[crop_calc.uv_len - rem..]);
                pack_4_pix_10bit(
                    tmp,
                    (&mut dst_row[uv_row - 5..]).try_into().unwrap_unchecked(),
                );
            }

            dst_pos += uv_row;
        }
    }
}

pub const fn extr_10bit_raw(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
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

pub fn extr_10bit_raw_stride(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
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

pub const fn extr_10bit_raw_crop_fast(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
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

pub fn extr_10bit_raw_crop(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
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

pub fn extr_10bit_raw_crop_stride(frame: *const VidFrame, output: &mut [u8], cc: &CropCalc) {
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

#[inline]
unsafe fn hw_copy_plane(src: *const u8, dst: *mut u8, ls: usize, row_bytes: usize, rows: usize) {
    unsafe {
        if ls == row_bytes {
            copy_nonoverlapping(src, dst, row_bytes * rows);
        } else {
            for row in 0..rows {
                copy_nonoverlapping(src.add(row * ls), dst.add(row * row_bytes), row_bytes);
            }
        }
    }
}

fn deinterleave_nv12_row(src: &[u8], u_dst: &mut [u8], v_dst: &mut [u8]) {
    src.chunks_exact(2)
        .zip(u_dst.iter_mut().zip(v_dst.iter_mut()))
        .for_each(|(uv, (u, v))| unsafe {
            *u = *uv.get_unchecked(0);
            *v = *uv.get_unchecked(1);
        });
}

fn deinterleave_p010_row(src: &[u16], u_dst: &mut [u16], v_dst: &mut [u16]) {
    src.chunks_exact(2)
        .zip(u_dst.iter_mut().zip(v_dst.iter_mut()))
        .for_each(|(uv, (u, v))| unsafe {
            *u = *uv.get_unchecked(0) >> 6;
            *v = *uv.get_unchecked(1) >> 6;
        });
}

fn shift_p010_row(src: &[u16], dst: &mut [u16]) {
    src.iter()
        .zip(dst.iter_mut())
        .for_each(|(&s, d)| *d = s >> 6);
}

fn deinterleave_nv12_row_to_10bit(src: &[u8], u_dst: &mut [u16], v_dst: &mut [u16]) {
    src.chunks_exact(2)
        .zip(u_dst.iter_mut().zip(v_dst.iter_mut()))
        .for_each(|(uv, (u, v))| unsafe {
            *u = u16::from(*uv.get_unchecked(0)) << 2;
            *v = u16::from(*uv.get_unchecked(1)) << 2;
        });
}

pub fn nv12_to_10bit(input: &[u8], output: &mut [u8], w: usize, h: usize) {
    let y_in = w * h;
    let y_out = y_in * 2;
    let uv_plane = w / 2 * (h / 2);

    unsafe {
        conv_to_10bit(
            input.get_unchecked(..y_in),
            from_raw_parts_mut(output.as_mut_ptr(), y_out),
        );
        let chroma = from_raw_parts_mut(output.as_mut_ptr().add(y_out).cast::<u16>(), uv_plane * 2);
        let (u_dst, v_dst) = chroma.split_at_mut(uv_plane);
        deinterleave_nv12_row_to_10bit(input.get_unchecked(y_in..), u_dst, v_dst);
    }
}

pub fn extr_hw_nv12(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let w = inf.width as usize;
        let h = inf.height as usize;
        let y_ls = f.linesize[0] as usize;
        let uv_ls = f.linesize[1] as usize;
        let y_size = w * h;
        let uv_w = w / 2;
        let uv_size = uv_w * (h / 2);

        hw_copy_plane(f.data[0], output.as_mut_ptr(), y_ls, w, h);

        if uv_ls == w {
            let src = from_raw_parts(f.data[1], w * (h / 2));
            let u_dst = from_raw_parts_mut(output.as_mut_ptr().add(y_size), uv_size);
            let v_dst = from_raw_parts_mut(output.as_mut_ptr().add(y_size + uv_size), uv_size);
            deinterleave_nv12_row(src, u_dst, v_dst);
        } else {
            for row in 0..h / 2 {
                let src = from_raw_parts(f.data[1].add(row * uv_ls), uv_w * 2);
                let u_dst = from_raw_parts_mut(output.as_mut_ptr().add(y_size + row * uv_w), uv_w);
                let v_dst = from_raw_parts_mut(
                    output.as_mut_ptr().add(y_size + uv_size + row * uv_w),
                    uv_w,
                );
                deinterleave_nv12_row(src, u_dst, v_dst);
            }
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
            deinterleave_nv12_row(src, u_dst, v_dst);
        }
    }
}

pub fn extr_hw_nv12_to10(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    unsafe {
        let f = &*frame;
        let w = inf.width as usize;
        let h = inf.height as usize;
        let y_ls = f.linesize[0] as usize;
        let uv_ls = f.linesize[1] as usize;
        let y_size = w * h;

        hw_copy_plane(f.data[0], output.as_mut_ptr(), y_ls, w, h);
        hw_copy_plane(f.data[1], output.as_mut_ptr().add(y_size), uv_ls, w, h / 2);
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
        let y_ls = f.linesize[0] as usize;
        let uv_ls = f.linesize[1] as usize;
        let w_bytes = w * 2;
        let y_size = w * h * 2;
        let uv_w = w / 2;
        let uv_size = uv_w * (h / 2) * 2;

        if y_ls == w_bytes {
            let src = from_raw_parts(f.data[0].cast::<u16>(), w * h);
            let dst = from_raw_parts_mut(output.as_mut_ptr().cast::<u16>(), w * h);
            shift_p010_row(src, dst);
        } else {
            for row in 0..h {
                let src = from_raw_parts(f.data[0].add(row * y_ls).cast::<u16>(), w);
                let dst =
                    from_raw_parts_mut(output.as_mut_ptr().add(row * w_bytes).cast::<u16>(), w);
                shift_p010_row(src, dst);
            }
        }

        if uv_ls == w_bytes {
            let src = from_raw_parts(f.data[1].cast::<u16>(), w * (h / 2));
            let u_dst = from_raw_parts_mut(
                output.as_mut_ptr().add(y_size).cast::<u16>(),
                uv_w * (h / 2),
            );
            let v_dst = from_raw_parts_mut(
                output.as_mut_ptr().add(y_size + uv_size).cast::<u16>(),
                uv_w * (h / 2),
            );
            deinterleave_p010_row(src, u_dst, v_dst);
        } else {
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
                deinterleave_p010_row(src, u_dst, v_dst);
            }
        }
    }
}

pub fn extr_hw_p010_raw(frame: *const VidFrame, output: &mut [u8], inf: &VidInf) {
    extr_hw_p010_raw_wh(frame, output, inf.width as usize, inf.height as usize);
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
            shift_p010_row(src, dst);
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
            deinterleave_p010_row(src, u_dst, v_dst);
        }
    }
}
