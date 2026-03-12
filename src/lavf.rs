use std::{
    ffi::{CString, c_int, c_void},
    path::Path,
    ptr::{from_ref, null, null_mut},
};

use crate::{
    error::{Xerr, Xerr::Done},
    ffms::{
        AVFormatContext, AVPacket, VidFrame, av_find_best_stream, av_frame_alloc, av_frame_free,
        av_opt_set_int, av_packet_alloc, av_packet_free, av_packet_unref, av_read_frame,
        avcodec_alloc_context3, avcodec_free_context, avcodec_open2, avcodec_parameters_to_context,
        avcodec_receive_frame, avcodec_send_packet, avformat_close_input,
        avformat_find_stream_info, avformat_open_input,
    },
};

const AVMEDIA_TYPE_AUDIO: c_int = 1;
const AV_SAMPLE_FMT_FLT: c_int = 3;
const AV_TIME_BASE: i64 = 1_000_000;
const AVERROR_EOF: c_int = -541_478_725;
const AVERROR_EAGAIN: c_int = -11;

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

pub struct AudioDecoder {
    fmt_ctx: *mut AVFormatContext,
    codec_ctx: *mut c_void,
    swr: *mut c_void,
    pkt: *mut AVPacket,
    frame: *mut VidFrame,
    stream_idx: c_int,
    channels: u32,
    total_samples: i64,
}

unsafe impl Send for AudioDecoder {}

impl AudioDecoder {
    pub fn new(input: &Path, stream_index: i32) -> Result<Self, Xerr> {
        unsafe {
            let path = CString::new(input.to_str().ok_or("invalid path")?)?;
            let mut fmt_ctx: *mut AVFormatContext = null_mut();

            if avformat_open_input(&raw mut fmt_ctx, path.as_ptr(), null(), null_mut()) < 0 {
                return Err("lavf: open failed".into());
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

            let stream = *(*fmt_ctx).streams.add(idx as usize);
            let par = &*(*stream).codecpar;

            if par.format < 0 {
                av_opt_set_int(fmt_ctx.cast(), c"probesize".as_ptr(), 0x40000, 1);
                avformat_find_stream_info(fmt_ctx, null_mut());
            }

            let channels = par.ch_layout.nb_channels as u32;

            let total_samples = if (*stream).duration > 0 && (*stream).time_base.den > 0 {
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

            Ok(Self {
                fmt_ctx,
                codec_ctx,
                swr,
                pkt: av_packet_alloc(),
                frame: av_frame_alloc(),
                stream_idx: idx,
                channels,
                total_samples,
            })
        }
    }

    pub const fn channels(&self) -> u32 {
        self.channels
    }

    pub const fn total_samples(&self) -> i64 {
        self.total_samples
    }

    pub fn decode_to<F: FnMut(&mut [f32]) -> Result<(), Xerr>>(
        &mut self,
        mut cb: F,
    ) -> Result<(), Xerr> {
        let result = (|| -> Result<(), Xerr> {
            const MAX_OUT: usize = 96000;
            let ch = self.channels as usize;
            let mut out_buf = vec![0f32; MAX_OUT * ch];

            unsafe {
                loop {
                    if av_read_frame(self.fmt_ctx, self.pkt) < 0 {
                        break;
                    }

                    if (*self.pkt).stream_index != self.stream_idx {
                        av_packet_unref(self.pkt);
                        continue;
                    }

                    loop {
                        if avcodec_send_packet(self.codec_ctx, self.pkt) != AVERROR_EAGAIN {
                            break;
                        }
                        self.drain_frames(&mut out_buf, &mut cb)?;
                    }
                    av_packet_unref(self.pkt);
                    self.drain_frames(&mut out_buf, &mut cb)?;
                }

                avcodec_send_packet(self.codec_ctx, null());
                self.drain_frames(&mut out_buf, &mut cb)?;

                loop {
                    let mut out_ptr = out_buf.as_mut_ptr().cast::<u8>();
                    let n = swr_convert(self.swr, &raw mut out_ptr, MAX_OUT as c_int, null(), 0);
                    if n <= 0 {
                        break;
                    }
                    cb(&mut out_buf[..n as usize * ch])?;
                }
            }

            Ok(())
        })();
        match result {
            Err(Done) => Ok(()),
            r => r,
        }
    }

    unsafe fn drain_frames<F: FnMut(&mut [f32]) -> Result<(), Xerr>>(
        &mut self,
        out_buf: &mut [f32],
        cb: &mut F,
    ) -> Result<(), Xerr> {
        let ch = self.channels as usize;
        let max_per_ch = (out_buf.len() / ch) as c_int;

        loop {
            let ret = unsafe { avcodec_receive_frame(self.codec_ctx, self.frame) };
            if ret == AVERROR_EAGAIN || ret == AVERROR_EOF {
                return Ok(());
            }
            if ret < 0 {
                return Err("lavf: decode error".into());
            }

            let nb = unsafe { (*self.frame).nb_samples };
            let mut out_ptr = out_buf.as_mut_ptr().cast::<u8>();
            let in_ptr = unsafe { (*self.frame).extended_data.cast::<*const u8>() };
            let n = unsafe { swr_convert(self.swr, &raw mut out_ptr, max_per_ch, in_ptr, nb) };
            if n > 0 {
                cb(&mut out_buf[..n as usize * ch])?;
            }
        }
    }
}

impl Drop for AudioDecoder {
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
