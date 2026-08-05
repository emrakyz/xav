use alloc::ffi::CString;
#[cfg(target_os = "linux")]
use alloc::vec::Vec;
use core::{
    ffi::{c_int, c_void},
    ptr::{from_ref, null, null_mut},
};

use crate::{
    error::Xerr,
    ffms::{
        AVFormatContext, AVPacket, AVSEEK_FLAG_BACKWARD, VidFrame, av_find_best_stream,
        av_frame_alloc, av_frame_free, av_packet_alloc, av_packet_free, av_packet_unref,
        av_read_frame, av_seek_frame, avcodec_alloc_context3, avcodec_flush_buffers,
        avcodec_free_context, avcodec_open2, avcodec_parameters_to_context, avcodec_receive_frame,
        avcodec_send_packet, avformat_close_input, avformat_open_input, probe_streams,
    },
    path::Path,
};

const AVMEDIA_TYPE_AUDIO: c_int = 1;
const AVDISCARD_ALL: c_int = 48;
const AV_SAMPLE_FMT_FLT: c_int = 3;
const AV_TIME_BASE: i64 = 1_000_000;
const AVERROR_EOF: c_int = -541_478_725;
const AVERROR_EAGAIN: c_int = -11;
const MAX_OUT: usize = 96000;

unsafe extern "C" {
    fn swr_alloc_set_opts2(
        ps: *mut *mut c_void,
        out_ch_layout: *const c_void,
        out_sample_fmt: c_int,
        out_sample_rate: c_int,
        in_ch_layout: *const c_void,
        in_sample_fmt: c_int,
        in_sample_rate: c_int,
        log_offset: c_int,
        log_ctx: *mut c_void,
    ) -> c_int;
    fn swr_init(s: *mut c_void) -> c_int;
    fn swr_convert(
        s: *mut c_void,
        out: *mut *mut u8,
        out_count: c_int,
        in_: *const *const u8,
        in_count: c_int,
    ) -> c_int;
    fn swr_free(s: *mut *mut c_void);
}

pub struct AuDecoder {
    fmt_ctx: *mut AVFormatContext,
    codec_ctx: *mut c_void,
    swr: *mut c_void,
    pkt: *mut AVPacket,
    frame: *mut VidFrame,
    out_buf: Vec<f32>,
    stream_idx: c_int,
    channels: u8,
    tot_samples: i64,
    tb_num: i64,
    tb_den: i64,
    start_time: i64,
}

unsafe impl Send for AuDecoder {}

impl AuDecoder {
    pub fn new(inp: &Path, stream_index: i32) -> Result<Self, Xerr> {
        unsafe {
            let path = CString::new(inp.to_str().unwrap_unchecked()).unwrap_unchecked();
            let mut fmt_ctx: *mut AVFormatContext = null_mut();

            if avformat_open_input(&raw mut fmt_ctx, path.as_ptr(), null(), null_mut()) < 0 {
                return Err("lavf: open failed".into());
            }

            probe_streams(fmt_ctx, AVMEDIA_TYPE_AUDIO, 0x40000);

            let mut dec: *const c_void = null();
            let idx = av_find_best_stream(
                fmt_ctx,
                AVMEDIA_TYPE_AUDIO,
                stream_index,
                -1,
                &raw mut dec,
                0,
            );
            if idx < 0 {
                avformat_close_input(&raw mut fmt_ctx);
                return Err("lavf: audio stream not found".into());
            }

            for i in 0..(*fmt_ctx).nb_streams {
                if i as c_int != idx {
                    (*(*(*fmt_ctx).streams.add(i as usize))).discard = AVDISCARD_ALL;
                }
            }

            let stream = *(*fmt_ctx).streams.add(idx as usize);
            let par = &*(*stream).codecpar;
            let channels = par.ch_layout.nb_channels as u8;
            let tb = (*stream).time_base;
            let tb_num = i64::from(tb.num);
            let tb_den = i64::from(tb.den);
            let start_time = (*stream).start_time.max(0);

            let tot_samples = if (*stream).duration > 0 && (*stream).time_base.den > 0 {
                (*stream).duration * i64::from((*stream).time_base.num) * 48000
                    / i64::from((*stream).time_base.den)
            } else if (*fmt_ctx).duration > 0 {
                (*fmt_ctx).duration * 48000 / AV_TIME_BASE
            } else {
                0
            };

            let mut codec_ctx = avcodec_alloc_context3(dec);
            if codec_ctx.is_null() {
                avformat_close_input(&raw mut fmt_ctx);
                return Err("lavf: alloc codec failed".into());
            }

            avcodec_parameters_to_context(codec_ctx, par);

            if avcodec_open2(codec_ctx, dec, null_mut()) < 0 {
                avcodec_free_context(&raw mut codec_ctx);
                avformat_close_input(&raw mut fmt_ctx);
                return Err("lavf: codec open failed".into());
            }

            let ch_layout_ptr = from_ref(&par.ch_layout).cast::<c_void>();
            let mut swr: *mut c_void = null_mut();
            if swr_alloc_set_opts2(
                &raw mut swr,
                ch_layout_ptr,
                AV_SAMPLE_FMT_FLT,
                48000,
                ch_layout_ptr,
                par.format,
                par.sample_rate,
                0,
                null_mut(),
            ) < 0
                || swr_init(swr) < 0
            {
                avcodec_free_context(&raw mut codec_ctx);
                avformat_close_input(&raw mut fmt_ctx);
                return Err("lavf: swr init failed".into());
            }

            let out_buf = vec![0f32; MAX_OUT * usize::from(channels)];

            Ok(Self {
                fmt_ctx,
                codec_ctx,
                swr,
                pkt: av_packet_alloc(),
                frame: av_frame_alloc(),
                out_buf,
                stream_idx: idx,
                channels,
                tot_samples,
                tb_num,
                tb_den,
                start_time,
            })
        }
    }

    pub const fn tot_samples(&self) -> i64 {
        self.tot_samples
    }

    #[inline]
    const fn pts_to_sample(&self, pts: i64) -> i64 {
        (pts - self.start_time) * 48000 * self.tb_num / self.tb_den
    }

    pub fn decode_range<F: FnMut(&mut [f32]) -> Result<(), Xerr>>(
        &mut self,
        s_start: i64,
        s_end: i64,
        is_first: bool,
        is_last: bool,
        mut cb: F,
    ) -> Result<i64, Xerr> {
        const WARMUP: i64 = 4096;
        let seek = (s_start - WARMUP) * self.tb_den / (48000 * self.tb_num);
        unsafe {
            av_seek_frame(self.fmt_ctx, self.stream_idx, seek, AVSEEK_FLAG_BACKWARD);
            avcodec_flush_buffers(self.codec_ctx);
        }
        let mut started = false;
        let mut base = i64::MIN;
        unsafe {
            loop {
                if av_read_frame(self.fmt_ctx, self.pkt) < 0 {
                    break;
                }
                if (*self.pkt).stream_index != self.stream_idx {
                    av_packet_unref(self.pkt);
                    continue;
                }
                let key = (*self.pkt).flags & 1 != 0;
                let pts = (*self.pkt).pts;
                if key && pts != i64::MIN {
                    let pos = self.pts_to_sample(pts);
                    if !started {
                        if is_first || pos >= s_start {
                            started = true;
                            base = pos;
                        }
                    } else if !is_last && pos >= s_end {
                        av_packet_unref(self.pkt);
                        break;
                    }
                }
                loop {
                    if avcodec_send_packet(self.codec_ctx, self.pkt) != AVERROR_EAGAIN {
                        break;
                    }
                    self.drain_unit(started, &mut cb)?;
                }
                av_packet_unref(self.pkt);
                self.drain_unit(started, &mut cb)?;
            }
            avcodec_send_packet(self.codec_ctx, null());
            self.drain_unit(started, &mut cb)?;
        }
        Ok(base)
    }

    unsafe fn drain_unit<F: FnMut(&mut [f32]) -> Result<(), Xerr>>(
        &mut self,
        emit: bool,
        cb: &mut F,
    ) -> Result<(), Xerr> {
        let ch = usize::from(self.channels);
        let max_per_ch = (self.out_buf.len() / ch) as c_int;
        loop {
            let ret = unsafe { avcodec_receive_frame(self.codec_ctx, self.frame) };
            if ret == AVERROR_EAGAIN || ret == AVERROR_EOF {
                return Ok(());
            }
            if ret < 0 {
                return Err(decode_err());
            }
            if !emit {
                continue;
            }
            let nb = unsafe { (*self.frame).nb_samples };
            let mut out_ptr = self.out_buf.as_mut_ptr().cast::<u8>();
            let in_ptr = unsafe { (*self.frame).extended_data.cast::<*const u8>() };
            let n = unsafe { swr_convert(self.swr, &raw mut out_ptr, max_per_ch, in_ptr, nb) };
            if n > 0 {
                cb(&mut self.out_buf[..n as usize * ch])?;
            }
        }
    }
}

#[cold]
#[inline(never)]
fn decode_err() -> Xerr {
    "lavf: decode error".into()
}

impl Drop for AuDecoder {
    fn drop(&mut self) {
        unsafe {
            swr_free(&raw mut self.swr);
            av_frame_free(&raw mut self.frame);
            av_packet_free(&raw mut self.pkt);
            avcodec_free_context(&raw mut self.codec_ctx);
            avformat_close_input(&raw mut self.fmt_ctx);
        }
    }
}
