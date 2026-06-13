use std::{
    borrow::Cow,
    ffi::{CStr, CString, c_int},
    path::Path,
    ptr::{null, null_mut},
    slice::from_raw_parts,
};

use crate::{
    byte_range::ByteRange,
    error::Xerr,
    ffms::{
        AV_NOPTS_VALUE, AVCodecParameters, AVFormatContext, AVMEDIA_TYPE_AUDIO,
        AVMEDIA_TYPE_SUBTITLE, AVMEDIA_TYPE_VIDEO, AVStream, av_packet_alloc, av_packet_free,
        av_packet_unref, av_read_frame, avcodec_get_name, avformat_close_input,
        avformat_find_stream_info, avformat_open_input, dict_get, is_matroska, stream_lang,
    },
    mkv::read::{chapter_langs, track_langs},
    platform::Mmap,
    progs::ProgsBar,
};

pub struct Packet {
    pub range: ByteRange,
    pub pts: i64,
    pub duration: i64,
}

pub struct Stream {
    pub data: Vec<u8>,
    pub packets: Vec<Packet>,
    pub codec_id: c_int,
    pub codec_type: c_int,
    pub channels: u8,
    pub sample_rate: u32,
    pub bit_depth: u8,
    pub tb_num: c_int,
    pub tb_den: c_int,
    pub origin: i64,
    pub extradata: Vec<u8>,
    pub lang: Option<Cow<'static, str>>,
}

pub struct Chapter {
    pub start_ns: i64,
    pub end_ns: i64,
    pub title: Option<String>,
    pub lang: Option<Cow<'static, str>>,
}

pub fn demux(inp: &Path, want_audio: bool, want_subs: bool) -> Result<Vec<Stream>, Xerr> {
    unsafe {
        let path = CString::new(inp.to_str().unwrap_unchecked()).unwrap_unchecked();
        let mut fmt_ctx: *mut AVFormatContext = null_mut();
        if avformat_open_input(&raw mut fmt_ctx, path.as_ptr(), null(), null_mut()) < 0 {
            return Err("copy: open failed".into());
        }
        if avformat_find_stream_info(fmt_ctx, null_mut()) < 0 {
            avformat_close_input(&raw mut fmt_ctx);
            return Err("copy: stream info failed".into());
        }

        let n = (*fmt_ctx).nb_streams as usize;
        let origin_us = video_origin_us(fmt_ctx);
        let mut routes = vec![None; n];
        let mut streams = Vec::new();
        let map = is_matroska(fmt_ctx).then(|| Mmap::open(inp).ok()).flatten();
        let tags = map
            .as_ref()
            .map_or_else(Vec::new, |m| track_langs(m.slice()));
        for (i, route) in routes.iter_mut().enumerate() {
            let st = *(*fmt_ctx).streams.add(i);
            let par = &*(*st).codecpar;
            let want = (par.codec_type == AVMEDIA_TYPE_AUDIO && want_audio)
                || (par.codec_type == AVMEDIA_TYPE_SUBTITLE && want_subs);
            if want {
                *route = Some(streams.len());
                let mut s = describe(st, par, origin_us);
                s.lang = tags
                    .iter()
                    .find(|t| t.0 == i as u64)
                    .map(|t| Cow::Owned(t.1.to_owned()))
                    .or_else(|| stream_lang((*st).metadata));
                streams.push(s);
            }
        }
        if !streams.is_empty() {
            read_packets(fmt_ctx, &routes, &mut streams);
        }
        avformat_close_input(&raw mut fmt_ctx);
        Ok(streams)
    }
}

pub fn read_chapters(inp: &Path) -> Result<Vec<Chapter>, Xerr> {
    unsafe {
        let path = CString::new(inp.to_str().unwrap_unchecked()).unwrap_unchecked();
        let mut fmt_ctx: *mut AVFormatContext = null_mut();
        if avformat_open_input(&raw mut fmt_ctx, path.as_ptr(), null(), null_mut()) < 0 {
            return Err("chapters: open failed".into());
        }
        if avformat_find_stream_info(fmt_ctx, null_mut()) < 0 {
            avformat_close_input(&raw mut fmt_ctx);
            return Err("chapters: stream info failed".into());
        }
        let n = (*fmt_ctx).nb_chapters as usize;
        let mut chapters = Vec::with_capacity(n);
        let map = (n != 0 && is_matroska(fmt_ctx))
            .then(|| Mmap::open(inp).ok())
            .flatten();
        let ctags = map
            .as_ref()
            .map_or_else(Vec::new, |m| chapter_langs(m.slice()));
        for i in 0..n {
            let ch = *(*fmt_ctx).chapters.add(i);
            let tb = (*ch).time_base;
            let ns = |t: i64| {
                (i128::from(t) * i128::from(tb.num) * 1_000_000_000 / i128::from(tb.den)) as i64
            };
            let lang = ctags
                .iter()
                .find(|t| t.0 == i as u64)
                .map(|t| Cow::Owned(t.1.to_owned()))
                .or_else(|| stream_lang((*ch).metadata));
            chapters.push(Chapter {
                start_ns: ns((*ch).start),
                end_ns: ns((*ch).end),
                title: dict_get((*ch).metadata, c"title".as_ptr()),
                lang,
            });
        }
        avformat_close_input(&raw mut fmt_ctx);
        Ok(chapters)
    }
}

unsafe fn video_origin_us(fmt_ctx: *mut AVFormatContext) -> i64 {
    unsafe {
        let n = (*fmt_ctx).nb_streams as usize;
        for i in 0..n {
            let st = *(*fmt_ctx).streams.add(i);
            if (*(*st).codecpar).codec_type != AVMEDIA_TYPE_VIDEO {
                continue;
            }
            let start = (*st).start_time;
            if start == AV_NOPTS_VALUE {
                return 0;
            }
            let tb = (*st).time_base;
            return (i128::from(start) * i128::from(tb.num) * 1_000_000 / i128::from(tb.den))
                as i64;
        }
        0
    }
}

unsafe fn describe(st: *mut AVStream, par: &AVCodecParameters, origin_us: i64) -> Stream {
    unsafe {
        let tb = (*st).time_base;
        let extradata = if par.extradata.is_null() || par.extradata_size <= 0 {
            Vec::new()
        } else {
            from_raw_parts(par.extradata, par.extradata_size as usize).to_vec()
        };
        Stream {
            data: Vec::new(),
            packets: Vec::new(),
            codec_id: par.codec_id,
            codec_type: par.codec_type,
            channels: par.ch_layout.nb_channels as u8,
            sample_rate: par.sample_rate as u32,
            bit_depth: par.bits_per_raw_sample as u8,
            tb_num: tb.num,
            tb_den: tb.den,
            origin: (i128::from(origin_us) * i128::from(tb.den) / (i128::from(tb.num) * 1_000_000))
                as i64,
            extradata,
            lang: None,
        }
    }
}

unsafe fn read_packets(
    fmt_ctx: *mut AVFormatContext,
    routes: &[Option<usize>],
    streams: &mut [Stream],
) {
    unsafe {
        let dur_ms = ((*fmt_ctx).duration / 1000).max(0) as usize;
        let mut progs = ProgsBar::new();
        let mut max_ms = 0usize;
        let mut pkt = av_packet_alloc();
        while av_read_frame(fmt_ctx, pkt) >= 0 {
            let si = (*pkt).stream_index as usize;
            if let Some(out) = routes.get(si).copied().flatten()
                && let Some(s) = streams.get_mut(out)
            {
                let len = (*pkt).size as usize;
                let off = s.data.len();
                s.data.extend_from_slice(from_raw_parts((*pkt).data, len));
                s.packets.push(Packet {
                    range: ByteRange { offset: off, len },
                    pts: (*pkt).pts,
                    duration: (*pkt).duration,
                });
            }
            if dur_ms > 0 && (*pkt).pts != AV_NOPTS_VALUE {
                let tb = (*(*(*fmt_ctx).streams.add(si))).time_base;
                let ms = (i128::from((*pkt).pts) * i128::from(tb.num) * 1000 / i128::from(tb.den))
                    .max(0) as usize;
                if ms > max_ms {
                    max_ms = ms;
                    progs.up_copy(max_ms.min(dur_ms), dur_ms);
                }
            }
            av_packet_unref(pkt);
        }
        av_packet_free(&raw mut pkt);
        if dur_ms > 0 {
            progs.up_copy(dur_ms, dur_ms);
        }
    }
}

pub fn codec_map(codec_id: c_int) -> Option<(&'static str, &'static str)> {
    let name = unsafe { CStr::from_ptr(avcodec_get_name(codec_id)) }
        .to_str()
        .ok()?;
    let pair = match name {
        "ac3" => ("A_AC3", "Dolby Digital / AC-3"),
        "eac3" => ("A_EAC3", "Dolby Digital Plus / E-AC-3"),
        "dts" => ("A_DTS", "Digital Theatre System"),
        "truehd" => ("A_TRUEHD", "Dolby TrueHD"),
        "mlp" => ("A_MLP", "Meridian Lossless Packing / MLP"),
        "aac" => ("A_AAC", "Advanced Audio Coding (AAC)"),
        "flac" => ("A_FLAC", "FLAC (Free Lossless Audio Codec)"),
        "mp1" => ("A_MPEG/L1", "MPEG Audio 1, 2 Layer I"),
        "mp2" => ("A_MPEG/L2", "MPEG Audio 1, 2 Layer II"),
        "mp3" => ("A_MPEG/L3", "MPEG Audio 1, 2, 2.5 Layer III"),
        "opus" => ("A_OPUS", "Opus interactive speech and audio codec"),
        "vorbis" => ("A_VORBIS", "Vorbis"),
        "alac" => ("A_ALAC", "ALAC (Apple Lossless Audio Codec)"),
        "tta" => ("A_TTA1", "The True Audio lossless audio compressor"),
        "wavpack" => ("A_WAVPACK4", "WavPack lossless audio compressor"),
        "subrip" => ("S_TEXT/UTF8", "UTF-8 Plain Text"),
        "ass" => ("S_TEXT/ASS", "Advanced SubStation Alpha Format"),
        "webvtt" => ("S_TEXT/WEBVTT", "Web Video Text Tracks Format (WebVTT)"),
        "hdmv_pgs_subtitle" => ("S_HDMV/PGS", "HDMV presentation graphics subtitles (PGS)"),
        "dvd_subtitle" => ("S_VOBSUB", "VobSub subtitles"),
        "dvb_subtitle" => ("S_DVBSUB", "Digital Video Broadcasting (DVB) subtitles"),
        _ => return pcm_pair(name),
    };
    Some(pair)
}

fn pcm_pair(name: &str) -> Option<(&'static str, &'static str)> {
    if !name.starts_with("pcm_") {
        return None;
    }
    Some(if name.starts_with("pcm_f") {
        ("A_PCM/FLOAT/IEEE", "Floating-Point, IEEE compatible")
    } else if name.ends_with("be") || name == "pcm_bluray" || name == "pcm_dvd" {
        ("A_PCM/INT/BIG", "PCM Integer Big Endian")
    } else {
        ("A_PCM/INT/LIT", "PCM Integer Little Endian")
    })
}
