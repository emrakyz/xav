#[cfg(target_arch = "x86_64")]
use core::arch::x86_64::_mm_sfence;
use std::{
    borrow::Cow,
    num::NonZeroUsize,
    path::{Path, PathBuf},
    sync::atomic::{AtomicUsize, Ordering},
    thread::{available_parallelism, scope, sleep},
    time::{Duration, SystemTime, UNIX_EPOCH},
};

use crate::{
    audio::AuStream,
    byte_range::ByteRange,
    copy::{Chapter, Stream, codec_map},
    encoder::Encoder::{self, Vvenc, X264, X265},
    error::Xerr,
    ffms::{AVMEDIA_TYPE_AUDIO, AVMEDIA_TYPE_SUBTITLE, VidInf},
    lang::lang_name,
    mkv::{
        block_group::build_block_group,
        chapters::{ChapterEntry, chapters_size, write_chapters},
        cluster::build_cluster_header,
        crc32::{Crc32, crc32_combine, patch_crc},
        cues::write_cues,
        ebml_header::EBML_HEADER,
        info::{info_size, write_info},
        mux::{ClusterPlan, Layout, assign_audio, assign_subs, layout, nal_timing, plan_clusters},
        seek_head::write_seek_head,
        segment::write_segment_header,
        simple_block::build_simple_block,
        tags::{TrackStatistics, enc_settings, tags_size, write_tags},
        tracks::{Audio, Colour, Mastering, Subtitle, Track, tracks_size, write_tracks},
    },
    nal_config::nal_codec_private,
    nal_parse::{NalSink, ParamSets, parse_h264, parse_h265, parse_h266},
    obu_parse::parse,
    ogg::demux,
    opus::version as opus_version,
    platform::{Mmap, write_mux},
    progs::ProgsBar,
};

#[inline]
#[must_use]
pub fn seq_level(seq_obu: &[u8]) -> u8 {
    (unsafe { *seq_obu.get_unchecked(5) } >> 3) & 0x1F // AV1 OBU > 6b always
}

#[must_use]
pub fn av1_codec_private(seq_obu: &[u8], level: u8, chroma_pos: u8) -> Vec<u8> {
    let mut rec = Vec::with_capacity(4 + seq_obu.len());
    rec.push(0x81); // marker=1 version=1
    rec.push(level & 0x1F); // seq_profile=0 | seq_level_idx_0(5)
    rec.push(0x4C | (chroma_pos & 0x03)); // tier=0 hbd=1 12b=0 mono=0 sub_x=1 sub_y=1 chroma_pos
    rec.push(0x00); // reserved(3)=0 | initial_presentation_delay_present=0 | reserved(4)=0
    rec.extend_from_slice(seq_obu);
    rec
}

#[inline]
const fn chroma_siting(pos: i8) -> (u8, u8) {
    match pos {
        1 => (1, 2), // 1 CSP_VERTICAL (left/MPEG-2)
        2 => (1, 1), // 2 CSP_COLOCATED
        _ => (0, 0),
    }
}

#[must_use]
pub fn colour_of(inf: &VidInf) -> Colour {
    let (h, v) = chroma_siting(inf.chroma_sample_position);
    Colour {
        range: (inf.color_range + 1) as u8, // AV1 0=tv,1=pc -> mkv 1,2
        matrix: inf.matrix_coefficients as u8,
        transfer: inf.transfer_characteristics as u8,
        primaries: inf.color_primaries as u8,
        chroma_siting_h: h,
        chroma_siting_v: v,
        // chroma 2^16, max-luma 2^8, min-luma 2^14 both carriers must match
        mastering: inf.mastering.map(|m| {
            let q = |v: f64| (v * 65536.0).round().min(65535.0) / 65536.0;
            Mastering {
                r: (q(m.r.0), q(m.r.1)),
                g: (q(m.g.0), q(m.g.1)),
                b: (q(m.b.0), q(m.b.1)),
                wp: (q(m.wp.0), q(m.wp.1)),
                lum_max: (m.lum_max * 256.0).round() / 256.0,
                lum_min: (m.lum_min * 16384.0).round() / 16384.0,
            }
        }),
        content_light: inf.content_light_level,
    }
}

#[inline]
const fn mix(state: &mut u64) -> u64 {
    *state = state.wrapping_add(0x9E37_79B9_7F4A_7C15);
    let mut z = *state;
    z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
    z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
    z ^ (z >> 31)
}

fn now_utc() -> (i64, String) {
    let d = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap_or_default();
    let secs = d.as_secs();
    let date_ns = (secs as i64 - 978_307_200) * 1_000_000_000 + i64::from(d.subsec_nanos());

    let (rem, days) = (secs % 86_400, (secs / 86_400) as i64);
    let (hh, mm, ss) = (rem / 3600, (rem / 60) % 60, rem % 60);
    let z = days + 719_468;
    let era = (if z >= 0 { z } else { z - 146_096 }) / 146_097;
    let doe = (z - era * 146_097) as u64;
    let yoe = (doe - doe / 1460 + doe / 36_524 - doe / 146_096) / 365;
    let doy = doe - (365 * yoe + yoe / 4 - yoe / 100);
    let mp = (5 * doy + 2) / 153;
    let day = doy - (153 * mp + 2) / 5 + 1;
    let month = if mp < 10 { mp + 3 } else { mp - 9 };
    let year = yoe as i64 + era * 400 + i64::from(month <= 2);
    (
        date_ns,
        format!("{year:04}-{month:02}-{day:02} {hh:02}:{mm:02}:{ss:02} UTC"),
    )
}

#[inline]
fn put(dst: &mut [u8], pos: &mut usize, bytes: &[u8]) {
    unsafe {
        dst.get_unchecked_mut(*pos..*pos + bytes.len())
            .copy_from_slice(bytes);
    };
    *pos += bytes.len();
}

#[non_exhaustive]
pub enum AudioSrc<'a> {
    Encode(&'a [(AuStream, PathBuf)]),
    Copy(Vec<Stream>),
}

pub struct Aux<'a> {
    pub audio: AudioSrc<'a>,
    pub subs: Vec<Stream>,
    pub chapters: Vec<Chapter>,
}

pub fn mux_mkv(
    paths: &[PathBuf],
    out: &Path,
    inf: &VidInf,
    dims: (u32, u32),
    encoder: Encoder,
    params: &str,
    aux: Aux<'_>,
) -> Result<(), Xerr> {
    let (enc_w, enc_h) = dims;
    let Aux {
        audio,
        subs,
        chapters,
    } = aux;
    let is_nal = matches!(encoder, X264 | X265 | Vvenc);
    let Prep {
        maps,
        arena,
        ranges,
        nal_arena,
        nal_ranges,
        displays,
        codec_private,
    } = if is_nal {
        prep_nal(paths, inf, encoder)?
    } else {
        prep_av1(paths, inf)?
    };

    let (fps_num, fps_den) = (inf.fps_num, inf.fps_den);
    let colour = colour_of(inf);
    let n_frames = arena.len() as u64;
    let n_bytes: u64 = arena.iter().map(|b| b.len as u64).sum();
    let dur_ms = n_frames as f64 * 1000.0 * f64::from(fps_den) / f64::from(fps_num);
    let dur_ns = n_frames * 1_000_000_000 * u64::from(fps_den) / u64::from(fps_num);
    let frame_dur_ns = 1_000_000_000 * u64::from(fps_den) / u64::from(fps_num);
    // n_bytes*8*1e9 overflows u64 over 2.3G
    let bps = (u128::from(n_bytes) * 8 * 1_000_000_000)
        .checked_div(u128::from(dur_ns))
        .unwrap_or(0) as u64;

    let (date_ns, date_str) = now_utc();
    let mut seed = date_ns.cast_unsigned();
    let mut uid = [0u8; 16];
    uid[..8].copy_from_slice(&mix(&mut seed).to_le_bytes());
    uid[8..].copy_from_slice(&mix(&mut seed).to_le_bytes());
    let track_uid = mix(&mut seed);
    let title = out.file_stem().and_then(|s| s.to_str()).unwrap_or("");

    let info_len = info_size(title.len());
    let display = inf.dar.and_then(|(dw, dh)| {
        let (n, d) = (
            u64::from(dw) * u64::from(inf.height),
            u64::from(dh) * u64::from(inf.width),
        );
        (n != d).then(|| (((u64::from(enc_w) * n + d / 2) / d) as u32, enc_h))
    });

    // (start, len) spans valid by const
    let clusters: Vec<&[ByteRange]> = ranges
        .iter()
        .map(|&(s, l)| unsafe { arena.get_unchecked(s..s + l) })
        .collect();
    let nal_clusters: Vec<&[ByteRange]> = nal_ranges
        .iter()
        .map(|&(s, l)| unsafe { nal_arena.get_unchecked(s..s + l) })
        .collect();
    let disp_clusters: Vec<&[u32]> = if is_nal {
        ranges
            .iter()
            .map(|&(s, l)| unsafe { displays.get_unchecked(s..s + l) })
            .collect()
    } else {
        Vec::new()
    };
    let mut plans = plan_clusters(&clusters, &disp_clusters, fps_num, fps_den);

    let (atracks, ainfos) = match audio {
        AudioSrc::Encode(au) => build_audio_tracks(au, &mut plans, &mut seed)?,
        AudioSrc::Copy(streams) => build_copy_audio(streams, &mut plans, &mut seed),
    };
    let (stracks, sinfos) = build_copy_subs(subs, ainfos.len(), &mut plans, &mut seed);

    let video_track = Track {
        uid: track_uid,
        name: title.as_bytes(),
        codec_id: encoder.codec_id(),
        codec_private: &codec_private,
        codec_name: encoder.codec_name(),
        width: enc_w,
        height: enc_h,
        default_duration_ns: frame_dur_ns,
        display,
        colour,
    };
    let audio_entries: Vec<Audio<'_>> = ainfos
        .iter()
        .map(|a| Audio {
            number: a.number,
            uid: a.uid,
            default: a.default,
            name: a.name.as_bytes(),
            lang: a.lang.as_bytes(),
            codec_id: a.codec_id,
            codec_name: a.codec_name,
            codec_private: &a.codec_private,
            default_duration_ns: a.default_duration_ns,
            channels: a.channels,
            sample_rate: a.sample_rate,
            bit_depth: a.bit_depth,
            codec_delay_ns: a.codec_delay_ns,
            seek_preroll_ns: a.seek_preroll_ns,
        })
        .collect();
    let sub_entries: Vec<Subtitle<'_>> = sinfos
        .iter()
        .map(|s| Subtitle {
            number: s.number,
            uid: s.uid,
            default: s.default,
            name: s.name.as_bytes(),
            lang: s.lang.as_bytes(),
            codec_id: s.codec_id,
            codec_name: s.codec_name,
            codec_private: &s.codec_private,
        })
        .collect();
    let tracks_len = tracks_size(&video_track, &audio_entries, &sub_entries);

    let enc_name = encoder.version();
    let v_settings = enc_settings(params);
    let mut stats: Vec<TrackStatistics<'_>> = Vec::with_capacity(1 + ainfos.len() + sinfos.len());
    stats.push(TrackStatistics {
        track_uid,
        bps,
        duration_ns: dur_ns,
        n_frames,
        n_bytes,
        date_utc_str: &date_str,
        encoder: &enc_name,
        settings: &v_settings,
    });
    for a in &ainfos {
        stats.push(TrackStatistics {
            track_uid: a.uid,
            bps: a.bps,
            duration_ns: a.duration_ns,
            n_frames: a.n_frames,
            n_bytes: a.n_bytes,
            date_utc_str: &date_str,
            encoder: &a.encoder,
            settings: &a.settings,
        });
    }
    for s in &sinfos {
        stats.push(TrackStatistics {
            track_uid: s.uid,
            bps: s.bps,
            duration_ns: s.duration_ns,
            n_frames: s.n_frames,
            n_bytes: s.n_bytes,
            date_utc_str: &date_str,
            encoder: "",
            settings: "",
        });
    }
    let tags_len = tags_size(&stats);

    let (edition_uid, atoms) = if chapters.is_empty() {
        (0, Vec::new())
    } else {
        let edition_uid = mix(&mut seed);
        let atoms: Vec<ChapterEntry<'_>> = chapters
            .iter()
            .map(|c| ChapterEntry {
                uid: mix(&mut seed),
                start_ns: c.start_ns.max(0) as u64,
                end_ns: c.end_ns.max(0) as u64,
                title: c.title.as_deref().unwrap_or("").as_bytes(),
                lang: c.lang.as_deref().unwrap_or("und").as_bytes(),
            })
            .collect();
        (edition_uid, atoms)
    };
    let chapters_len = if atoms.is_empty() {
        0
    } else {
        chapters_size(edition_uid, &atoms)
    };

    let lay = layout(
        info_len,
        tracks_len,
        chapters_len,
        tags_len,
        &mut plans,
        fps_num,
        fps_den,
    );

    let mux = Mux {
        lay: &lay,
        seg_uid: &uid,
        date_ns,
        dur_ms,
        title,
        video: &video_track,
        audio_meta: &audio_entries,
        subs_meta: &sub_entries,
        stats: &stats,
        edition_uid,
        atoms: &atoms,
        plans: &plans,
        clusters: &clusters,
        displays: &disp_clusters,
        maps: &maps,
        audio: &atracks,
        subs: &stracks,
        fps_num,
        fps_den,
        is_nal,
        nal_clusters: &nal_clusters,
    };
    let mut progs = ProgsBar::new();
    write_mux(out, &mux, &mut progs)?;
    println!();
    Ok(())
}

struct Prep {
    maps: Vec<Mmap>,
    arena: Vec<ByteRange>,
    ranges: Vec<(usize, usize)>,
    nal_arena: Vec<ByteRange>,       // NAL byte-extents into the chunk maps
    nal_ranges: Vec<(usize, usize)>, // per-chunk span into nal_arena
    displays: Vec<u32>,              // empty for AV1
    codec_private: Vec<u8>,
}

fn prep_av1(paths: &[PathBuf], inf: &VidInf) -> Result<Prep, Xerr> {
    let maps = paths
        .iter()
        .map(|p| Mmap::open(p))
        .collect::<Result<Vec<_>, _>>()?;
    let mut arena: Vec<ByteRange> = Vec::with_capacity(inf.frames);
    let mut ranges: Vec<(usize, usize)> = Vec::with_capacity(maps.len());
    let mut max_level = 0u8;
    let mut conf_seq: &[u8] = &[];
    for m in &maps {
        let buf = m.slice();
        let start = arena.len();
        let seq = parse(buf, &mut arena).ok_or("chunk missing sequence header")?;
        let s = seq.slice(buf);
        let lvl = seq_level(s);
        if lvl >= max_level {
            max_level = lvl;
            conf_seq = s;
        }
        ranges.push((start, arena.len() - start));
    }
    let codec_private = av1_codec_private(conf_seq, max_level, inf.chroma_sample_position as u8);
    Ok(Prep {
        maps,
        arena,
        ranges,
        nal_arena: Vec::new(),
        nal_ranges: Vec::new(),
        displays: Vec::new(),
        codec_private,
    })
}

fn prep_nal(paths: &[PathBuf], inf: &VidInf, encoder: Encoder) -> Result<Prep, Xerr> {
    let mut maps = Vec::with_capacity(paths.len());
    let mut arena = Vec::with_capacity(inf.frames);
    let mut ranges = Vec::with_capacity(paths.len());
    let mut nal_arena = Vec::with_capacity(inf.frames);
    let mut nal_ranges = Vec::with_capacity(paths.len());
    let mut displays = Vec::with_capacity(inf.frames);
    let mut params = ParamSets::default();
    let mut order = Vec::new();
    let mut codec_private = Vec::new();
    for (ci, src) in paths.iter().enumerate() {
        let raw = Mmap::open(src)?;
        let fstart = arena.len();
        let nstart = nal_arena.len();
        let mut sink = NalSink {
            arena: &mut arena,
            nal_arena: &mut nal_arena,
            displays: &mut displays,
            params: &mut params,
            order: &mut order,
        };
        match encoder {
            X264 => parse_h264(raw.slice(), &mut sink),
            X265 => parse_h265(raw.slice(), &mut sink),
            _ => parse_h266(raw.slice(), &mut sink),
        }
        if ci == 0 {
            codec_private = nal_codec_private(encoder, &params);
        }
        ranges.push((fstart, arena.len() - fstart));
        nal_ranges.push((nstart, nal_arena.len() - nstart));
        maps.push(raw);
    }
    Ok(Prep {
        maps,
        arena,
        ranges,
        nal_arena,
        nal_ranges,
        displays,
        codec_private,
    })
}

const MIN_PAR: usize = 4 << 20;

enum AudioData {
    Mapped(Mmap),
    Owned(Vec<u8>),
}

impl AudioData {
    #[inline]
    const fn slice(&self) -> &[u8] {
        match *self {
            Self::Mapped(ref m) => m.slice(),
            Self::Owned(ref v) => v.as_slice(),
        }
    }
}

struct AudioTrack {
    data: AudioData,
    packets: Vec<ByteRange>,
    ts_ms: Vec<u64>,    // per-packet start ms
    bounds: Vec<usize>, // per-cluster packet split points (len = n_clusters + 1)
    number: u64,
}

struct AudioInfo {
    number: u64,
    uid: u64,
    default: bool,
    name: Cow<'static, str>,
    lang: Cow<'static, str>,
    settings: String,
    encoder: String,
    codec_id: &'static [u8],
    codec_name: &'static [u8],
    codec_private: Vec<u8>,
    sample_rate: u32,
    channels: u8,
    bit_depth: Option<u8>,
    codec_delay_ns: u64,
    seek_preroll_ns: u64,
    default_duration_ns: u64,
    bps: u64,
    duration_ns: u64,
    n_frames: u64,
    n_bytes: u64,
}

fn build_audio_tracks(
    au: &[(AuStream, PathBuf)],
    plans: &mut [ClusterPlan],
    seed: &mut u64,
) -> Result<(Vec<AudioTrack>, Vec<AudioInfo>), Xerr> {
    let mut atracks = Vec::new();
    let mut ainfos = Vec::new();
    for entry in au {
        let map = Mmap::open(&entry.1)?;
        let os = demux(map.slice())?;
        if os.packets.is_empty() {
            continue;
        }
        let number = 2 + ainfos.len() as u64;
        let default = ainfos.is_empty();
        let mut ts_ms = Vec::with_capacity(os.packets.len());
        let mut lens = Vec::with_capacity(os.packets.len());
        let mut cum = 0u64;
        let mut n_bytes = 0u64;
        for p in &os.packets {
            ts_ms.push((cum * 1000 + 24_000) / 48_000); // round samples@48k to ms
            lens.push(p.range.len);
            cum += u64::from(p.samples);
            n_bytes += p.range.len as u64;
        }
        let bounds = assign_audio(plans, &ts_ms, &lens, number);
        let duration_ns = cum * 1_000_000_000 / 48_000;
        let bps = (u128::from(n_bytes) * 8 * 1_000_000_000)
            .checked_div(u128::from(duration_ns))
            .unwrap_or(0) as u64;
        let tag = entry.0.lang.clone().unwrap_or(Cow::Borrowed("und"));
        let name = lang_name(&tag);
        ainfos.push(AudioInfo {
            number,
            uid: mix(seed),
            default,
            name,
            lang: tag,
            settings: "vbr=1 vbr-constraint=0 complexity=10 bandwidth=fullband application=audio"
                .to_owned(),
            encoder: opus_version(),
            codec_id: b"A_OPUS",
            codec_name: b"Opus interactive speech and audio codec",
            codec_private: os.head,
            sample_rate: 48000,
            channels: os.channels,
            bit_depth: Some(32),
            codec_delay_ns: u64::from(os.pre_skip) * 1_000_000_000 / 48_000,
            seek_preroll_ns: 80_000_000,
            default_duration_ns: u64::from(unsafe { os.packets.get_unchecked(0) }.samples)
                * 1_000_000_000
                / 48_000,
            bps,
            duration_ns,
            n_frames: os.packets.len() as u64,
            n_bytes,
        });
        let packets = os.packets.into_iter().map(|p| p.range).collect();
        atracks.push(AudioTrack {
            data: AudioData::Mapped(map),
            packets,
            ts_ms,
            bounds,
            number,
        });
    }
    Ok((atracks, ainfos))
}

fn build_copy_audio(
    streams: Vec<Stream>,
    plans: &mut [ClusterPlan],
    seed: &mut u64,
) -> (Vec<AudioTrack>, Vec<AudioInfo>) {
    let mut atracks = Vec::new();
    let mut ainfos = Vec::new();
    for s in streams {
        if s.codec_type != AVMEDIA_TYPE_AUDIO || s.packets.is_empty() {
            continue;
        }
        let Some((codec_id, codec_name)) = codec_map(s.codec_id) else {
            continue;
        };
        let Stream {
            data,
            packets,
            channels,
            sample_rate,
            bit_depth,
            tb_num,
            tb_den,
            origin,
            extradata,
            lang,
            ..
        } = s;
        let number = 2 + ainfos.len() as u64;
        let default = ainfos.is_empty();
        let tb_num = i64::from(tb_num);
        let tb_den = i64::from(tb_den);
        let mut ts_ms = Vec::with_capacity(packets.len());
        let mut lens = Vec::with_capacity(packets.len());
        let mut n_bytes = 0u64;
        let mut min_start = i64::MAX;
        let mut max_end = i64::MIN;
        for p in &packets {
            let rel = (p.pts - origin).max(0);
            ts_ms.push(((rel * tb_num * 1000 + tb_den / 2) / tb_den) as u64);
            lens.push(p.range.len);
            n_bytes += p.range.len as u64;
            min_start = min_start.min(p.pts);
            max_end = max_end.max(p.pts + p.duration);
        }
        let bounds = assign_audio(plans, &ts_ms, &lens, number);
        // span (first start -> last end) stays right when per-packet durations are 0 (TrueHD)
        let span_tb = (max_end - min_start).max(0);
        let duration_ns =
            (i128::from(span_tb) * i128::from(tb_num) * 1_000_000_000 / i128::from(tb_den)) as u64;
        let bps = (u128::from(n_bytes) * 8 * 1_000_000_000)
            .checked_div(u128::from(duration_ns))
            .unwrap_or(0) as u64;
        let default_duration_ns =
            (unsafe { packets.get_unchecked(0) }.duration * tb_num * 1_000_000_000 / tb_den) as u64;
        let tag = lang.unwrap_or(Cow::Borrowed("und"));
        let name = lang_name(&tag);
        ainfos.push(AudioInfo {
            number,
            uid: mix(seed),
            default,
            name,
            lang: tag,
            settings: String::new(),
            encoder: String::new(),
            codec_id: codec_id.as_bytes(),
            codec_name: codec_name.as_bytes(),
            codec_private: extradata,
            sample_rate,
            channels,
            bit_depth: (bit_depth > 0).then_some(bit_depth),
            codec_delay_ns: 0,
            seek_preroll_ns: 0,
            default_duration_ns,
            bps,
            duration_ns,
            n_frames: packets.len() as u64,
            n_bytes,
        });
        let block_ranges = packets.into_iter().map(|p| p.range).collect();
        atracks.push(AudioTrack {
            data: AudioData::Owned(data),
            packets: block_ranges,
            ts_ms,
            bounds,
            number,
        });
    }
    (atracks, ainfos)
}

struct SubtitleTrack {
    data: Vec<u8>,
    packets: Vec<ByteRange>,
    ts_ms: Vec<u64>,
    dur_ms: Vec<u64>,
    bounds: Vec<usize>,
    number: u64,
}

struct SubtitleInfo {
    number: u64,
    uid: u64,
    default: bool,
    name: Cow<'static, str>,
    lang: Cow<'static, str>,
    codec_id: &'static [u8],
    codec_name: &'static [u8],
    codec_private: Vec<u8>,
    bps: u64,
    duration_ns: u64,
    n_frames: u64,
    n_bytes: u64,
}

fn build_copy_subs(
    streams: Vec<Stream>,
    n_audio: usize,
    plans: &mut [ClusterPlan],
    seed: &mut u64,
) -> (Vec<SubtitleTrack>, Vec<SubtitleInfo>) {
    let mut stracks = Vec::new();
    let mut sinfos = Vec::new();
    for s in streams {
        if s.codec_type != AVMEDIA_TYPE_SUBTITLE || s.packets.is_empty() {
            continue;
        }
        let Some((codec_id, codec_name)) = codec_map(s.codec_id) else {
            continue;
        };
        let Stream {
            data,
            packets,
            tb_num,
            tb_den,
            origin,
            extradata,
            lang,
            ..
        } = s;
        let number = 2 + (n_audio + sinfos.len()) as u64;
        let tb_num = i64::from(tb_num);
        let tb_den = i64::from(tb_den);
        let mut ts_ms = Vec::with_capacity(packets.len());
        let mut dur_ms = Vec::with_capacity(packets.len());
        let mut lens = Vec::with_capacity(packets.len());
        let mut n_bytes = 0u64;
        let mut min_start = i64::MAX;
        let mut max_end = i64::MIN;
        for p in &packets {
            let rel = (p.pts - origin).max(0);
            ts_ms.push(((rel * tb_num * 1000 + tb_den / 2) / tb_den) as u64);
            dur_ms.push(((p.duration.max(0) * tb_num * 1000 + tb_den / 2) / tb_den) as u64);
            lens.push(p.range.len);
            n_bytes += p.range.len as u64;
            min_start = min_start.min(p.pts);
            max_end = max_end.max(p.pts + p.duration);
        }
        let bounds = assign_subs(plans, &ts_ms, &lens, &dur_ms, number);
        let span_tb = (max_end - min_start).max(0);
        let duration_ns =
            (i128::from(span_tb) * i128::from(tb_num) * 1_000_000_000 / i128::from(tb_den)) as u64;
        let bps = (u128::from(n_bytes) * 8 * 1_000_000_000)
            .checked_div(u128::from(duration_ns))
            .unwrap_or(0) as u64;
        let tag = lang.unwrap_or(Cow::Borrowed("und"));
        let name = lang_name(&tag);
        sinfos.push(SubtitleInfo {
            number,
            uid: mix(seed),
            default: false,
            name,
            lang: tag,
            codec_id: codec_id.as_bytes(),
            codec_name: codec_name.as_bytes(),
            codec_private: extradata,
            bps,
            duration_ns,
            n_frames: packets.len() as u64,
            n_bytes,
        });
        let block_ranges = packets.into_iter().map(|p| p.range).collect();
        stracks.push(SubtitleTrack {
            data,
            packets: block_ranges,
            ts_ms,
            dur_ms,
            bounds,
            number,
        });
    }
    (stracks, sinfos)
}

trait Interleave {
    fn bound(&self, ci: usize) -> usize;
    fn ts(&self, i: usize) -> u64;
}

impl Interleave for AudioTrack {
    #[inline]
    fn bound(&self, ci: usize) -> usize {
        // ci <= n_clusters (bounds.len() == n_clusters + 1); i < bound <= ts_ms.len() (earliest invariant)
        unsafe { *self.bounds.get_unchecked(ci) }
    }

    #[inline]
    fn ts(&self, i: usize) -> u64 {
        unsafe { *self.ts_ms.get_unchecked(i) }
    }
}

impl Interleave for SubtitleTrack {
    #[inline]
    fn bound(&self, ci: usize) -> usize {
        // ci <= n_clusters (bounds.len() == n_clusters + 1); i < bound <= ts_ms.len() (earliest)
        unsafe { *self.bounds.get_unchecked(ci) }
    }

    #[inline]
    fn ts(&self, i: usize) -> u64 {
        unsafe { *self.ts_ms.get_unchecked(i) }
    }
}

#[inline]
fn earliest<T: Interleave>(tracks: &[T], cursors: &[usize], ci: usize) -> (usize, u64) {
    let mut best = usize::MAX;
    let mut best_ts = u64::MAX;
    for (t, tr) in tracks.iter().enumerate() {
        let c = unsafe { *cursors.get_unchecked(t) }; // cursors.len() == tracks.len()
        if c < tr.bound(ci + 1) && tr.ts(c) < best_ts {
            best_ts = tr.ts(c);
            best = t;
        }
    }
    (best, best_ts)
}

pub struct Mux<'a> {
    pub lay: &'a Layout,
    // header src serialized by write_headers
    seg_uid: &'a [u8; 16],
    date_ns: i64,
    dur_ms: f64,
    title: &'a str,
    video: &'a Track<'a>,
    audio_meta: &'a [Audio<'a>],
    subs_meta: &'a [Subtitle<'a>],
    stats: &'a [TrackStatistics<'a>],
    edition_uid: u64,
    atoms: &'a [ChapterEntry<'a>],
    pub plans: &'a [ClusterPlan],
    pub clusters: &'a [&'a [ByteRange]],
    displays: &'a [&'a [u32]], // NAL POC display ranks, parallel to clusters; empty for AV1
    pub maps: &'a [Mmap],
    audio: &'a [AudioTrack],
    subs: &'a [SubtitleTrack],
    fps_num: u32,
    fps_den: u32,
    pub is_nal: bool,
    nal_clusters: &'a [&'a [ByteRange]], // NAL byte-extents per chunk; empty for AV1
}

impl Mux<'_> {
    #[inline]
    pub const fn subs_empty(&self) -> bool {
        self.subs.is_empty()
    }

    pub fn write_headers(&self, dst: &mut [u8]) -> usize {
        let mut pos = 0;
        put(dst, &mut pos, EBML_HEADER);
        unsafe {
            pos += write_segment_header(dst.get_unchecked_mut(pos..), self.lay.segment_content);
            pos += write_seek_head(dst.get_unchecked_mut(pos..), &self.lay.seek);
            pos += write_info(
                dst.get_unchecked_mut(pos..),
                self.seg_uid,
                self.date_ns,
                self.dur_ms,
                self.title,
            );
            pos += write_tracks(
                dst.get_unchecked_mut(pos..),
                self.video,
                self.audio_meta,
                self.subs_meta,
            );
            if !self.atoms.is_empty() {
                pos += write_chapters(dst.get_unchecked_mut(pos..), self.edition_uid, self.atoms);
            }
            pos += write_tags(dst.get_unchecked_mut(pos..), self.stats);
            pos += write_cues(
                dst.get_unchecked_mut(pos..),
                self.plans,
                self.lay.pos_width,
                self.lay.frame_dur,
            );
        }
        pos
    }

    #[cfg(not(windows))]
    pub fn build(&self, dst: &mut [u8], progs: &mut ProgsBar) {
        let pos = self.write_headers(dst);
        let rest = unsafe { dst.get_unchecked_mut(pos..) };
        let n = self.plans.len();
        let progs = Some(progs);
        match (self.subs_empty(), self.is_nal) {
            (true, false) => self.build_clusters::<false, false>(rest, 0, n, progs),
            (false, false) => self.build_clusters::<true, false>(rest, 0, n, progs),
            (true, true) => self.build_clusters::<false, true>(rest, 0, n, progs),
            (false, true) => self.build_clusters::<true, true>(rest, 0, n, progs),
        }
    }

    pub fn build_clusters<const HAS_SUBS: bool, const IS_NAL: bool>(
        &self,
        dst: &mut [u8],
        c0: usize,
        c1: usize,
        mut progs: Option<&mut ProgsBar>,
    ) {
        let mut rest = &mut dst[..];
        let mut regions: Vec<(&mut [u8], usize)> = Vec::with_capacity(c1 - c0);
        for ci in c0..c1 {
            // sum of plan sizes over [c0,c1] equals rest.len() exactly, split is in bounds
            let (r, tail) =
                unsafe { rest.split_at_mut_unchecked(self.plans.get_unchecked(ci).size) };
            regions.push((r, ci));
            rest = tail;
        }

        let bytes: usize = unsafe { self.plans.get_unchecked(c0..c1) }
            .iter()
            .map(|p| p.size)
            .sum();
        let total: usize = unsafe { self.clusters.get_unchecked(c0..c1) }
            .iter()
            .map(|c| c.len())
            .sum();
        let nthr = available_parallelism()
            .map_or(1, NonZeroUsize::get)
            .min(c1 - c0)
            .min((bytes / MIN_PAR).max(1));

        if nthr <= 1 {
            let mut vf = 0;
            let mut cursors = Vec::new();
            let mut s_cursors = Vec::new();
            for (r, ci) in regions {
                self.build_cluster::<HAS_SUBS, IS_NAL>(r, ci, &mut cursors, &mut s_cursors);
                vf += unsafe { self.clusters.get_unchecked(ci) }.len();
                if let Some(p) = progs.as_deref_mut() {
                    p.up_frames(vf, total, 0, "MUX");
                }
            }
            return;
        }

        let per = bytes.div_ceil(nthr);
        let mut batches: Vec<Vec<(&mut [u8], usize)>> = Vec::with_capacity(nthr);
        let mut cur = Vec::new();
        let mut acc = 0;
        for region in regions {
            acc += region.0.len();
            cur.push(region);
            if acc >= per && batches.len() + 1 < nthr {
                batches.push(cur);
                cur = Vec::new();
                acc = 0;
            }
        }
        if !cur.is_empty() {
            batches.push(cur);
        }

        let done = AtomicUsize::new(0);
        scope(|s| {
            for batch in batches {
                let done = &done;
                s.spawn(move || {
                    let mut cursors = Vec::new();
                    let mut s_cursors = Vec::new();
                    for (r, ci) in batch {
                        self.build_cluster::<HAS_SUBS, IS_NAL>(r, ci, &mut cursors, &mut s_cursors);
                        done.fetch_add(
                            unsafe { self.clusters.get_unchecked(ci) }.len(),
                            Ordering::Relaxed,
                        );
                    }
                    // flush this batch non-temporal stores before the join publishes
                    #[cfg(target_arch = "x86_64")]
                    unsafe {
                        _mm_sfence();
                    }
                });
            }
            if let Some(p) = progs.as_deref_mut() {
                while done.load(Ordering::Relaxed) < total {
                    p.up_frames(done.load(Ordering::Relaxed), total, 0, "MUX");
                    sleep(Duration::from_millis(30));
                }
            }
        });
        if let Some(p) = progs {
            p.up_frames(total, total, 0, "MUX");
        }
    }

    fn build_cluster<const HAS_SUBS: bool, const IS_NAL: bool>(
        &self,
        region: &mut [u8],
        ci: usize,
        cursors: &mut Vec<usize>,
        s_cursors: &mut Vec<usize>,
    ) {
        // ci < plans.len(); per-cluster vecs are parallel
        let blocks = unsafe { *self.clusters.get_unchecked(ci) };
        let disp: &[u32] = if IS_NAL {
            unsafe { self.displays.get_unchecked(ci) }
        } else {
            &[]
        };
        let nals: &[ByteRange] = if IS_NAL {
            unsafe { self.nal_clusters.get_unchecked(ci) }
        } else {
            &[]
        };
        let plan = unsafe { self.plans.get_unchecked(ci) };
        let vsrc = unsafe { self.maps.get_unchecked(ci) }.slice();
        let mut p = 0;
        let mut hdr = [0u8; 48];
        let ch = build_cluster_header(
            &mut hdr,
            plan.ts,
            plan.bg_total + plan.sb_total + if HAS_SUBS { plan.sub_total } else { 0 },
            plan.position,
            self.lay.pos_width,
            plan.prev_size,
        );
        put(region, &mut p, unsafe { hdr.get_unchecked(..ch.len) });
        let mut cc = Crc32::new();
        cc.update(unsafe { hdr.get_unchecked(ch.timestamp_start..ch.len) }); // Timestamp + Position + PrevSize
        let mut sink = ClusterSink {
            p,
            crc: cc.finalize(),
        };

        let num = u64::from(self.fps_num);
        let step = u64::from(self.fps_den) * 1000;
        let (ms_step, rem_step) = (step / num, step % num);
        let r0 = plan.base_frame * step + num / 2;
        let (mut ms, mut rem) = (r0 / num, r0 % num);
        let mut nal_cur = 0usize;

        if self.audio.is_empty() && (!HAS_SUBS || self.subs.is_empty()) {
            for (i, b) in blocks.iter().enumerate() {
                let (rel, dur) = if IS_NAL {
                    let d = unsafe { *disp.get_unchecked(i) };
                    nal_timing(plan.base_frame, d, plan.ts, self.fps_num, self.fps_den)
                } else {
                    (
                        (ms - plan.ts) as i16,
                        ms_step + u64::from(rem + rem_step >= num),
                    )
                };
                if IS_NAL {
                    let frame_nals = unsafe { nals.get_unchecked(nal_cur..nal_cur + b.offset) };
                    nal_cur += b.offset;
                    emit_nal(
                        &mut sink,
                        region,
                        1,
                        NalFrame {
                            nals: frame_nals,
                            vsrc,
                            flen: b.len,
                        },
                        rel,
                        dur,
                        i == 0,
                    );
                } else {
                    emit_block_group(&mut sink, region, 1, b.slice(vsrc), rel, dur, i == 0);
                }
                if !IS_NAL {
                    ms += ms_step;
                    rem += rem_step;
                    if rem >= num {
                        ms += 1;
                        rem -= num;
                    }
                }
            }
            patch_crc(region, ch.crc_offset, sink.crc);
            return;
        }

        cursors.clear();
        cursors.extend(
            self.audio
                .iter()
                .map(|a| unsafe { *a.bounds.get_unchecked(ci) }),
        );
        if HAS_SUBS {
            s_cursors.clear();
            s_cursors.extend(
                self.subs
                    .iter()
                    .map(|s| unsafe { *s.bounds.get_unchecked(ci) }),
            );
        }
        let mut vi = 0;
        loop {
            let (best_a, best_a_ts) = earliest(self.audio, cursors, ci);
            let (best_s, best_s_ts) = if HAS_SUBS {
                earliest(self.subs, s_cursors, ci)
            } else {
                (usize::MAX, u64::MAX)
            };
            let aux_ts = best_a_ts.min(best_s_ts);
            if vi < blocks.len() && ms <= aux_ts {
                let (rel, dur) = if IS_NAL {
                    let d = unsafe { *disp.get_unchecked(vi) };
                    nal_timing(plan.base_frame, d, plan.ts, self.fps_num, self.fps_den)
                } else {
                    (
                        (ms - plan.ts) as i16,
                        ms_step + u64::from(rem + rem_step >= num),
                    )
                };
                if IS_NAL {
                    let b = unsafe { blocks.get_unchecked(vi) };
                    let frame_nals = unsafe { nals.get_unchecked(nal_cur..nal_cur + b.offset) };
                    nal_cur += b.offset;
                    emit_nal(
                        &mut sink,
                        region,
                        1,
                        NalFrame {
                            nals: frame_nals,
                            vsrc,
                            flen: b.len,
                        },
                        rel,
                        dur,
                        vi == 0,
                    );
                } else {
                    emit_block_group(
                        &mut sink,
                        region,
                        1,
                        unsafe { blocks.get_unchecked(vi) }.slice(vsrc),
                        rel,
                        dur,
                        vi == 0,
                    );
                }
                vi += 1;
                ms += ms_step;
                rem += rem_step;
                if rem >= num {
                    ms += 1;
                    rem -= num;
                }
            } else if best_a != usize::MAX && best_a_ts <= best_s_ts {
                // best_a < self.audio.len(); cursor < bound <= packets.len() (earliest)
                let a = unsafe { self.audio.get_unchecked(best_a) };
                let cur = unsafe { cursors.get_unchecked_mut(best_a) };
                let rel = (best_a_ts - plan.ts) as i16;
                emit_simple_block(
                    &mut sink,
                    region,
                    a.number,
                    unsafe { *a.packets.get_unchecked(*cur) },
                    a.data.slice(),
                    rel,
                );
                *cur += 1;
            } else if HAS_SUBS && best_s != usize::MAX {
                let s = unsafe { self.subs.get_unchecked(best_s) };
                let cur = unsafe { s_cursors.get_unchecked_mut(best_s) };
                let c = *cur;
                let rel = (best_s_ts - plan.ts) as i16;
                let blk = unsafe { s.packets.get_unchecked(c) }.slice(&s.data);
                emit_block_group(
                    &mut sink,
                    region,
                    s.number,
                    blk,
                    rel,
                    unsafe { *s.dur_ms.get_unchecked(c) },
                    true,
                );
                *cur += 1;
            } else {
                break;
            }
        }
        patch_crc(region, ch.crc_offset, sink.crc);
    }
}

struct ClusterSink {
    p: usize,
    crc: u32,
}

#[inline]
fn emit_block_group(
    sink: &mut ClusterSink,
    region: &mut [u8],
    track: u64,
    data: &[u8],
    rel: i16,
    dur: u64,
    is_kf: bool,
) {
    let bg_base = sink.p;
    let flen = data.len();
    // region is plan-sized; in bounds
    let bg = build_block_group(
        unsafe { region.get_unchecked_mut(bg_base..) },
        track,
        flen,
        rel,
        is_kf,
        dur,
    );
    let (bf, af) = (bg.before_frame_len, bg.after_frame_len);

    let mut c = Crc32::new();
    c.update(unsafe { region.get_unchecked(bg_base + bg.crc_offset + 4..bg_base + bf) }); // block header
    let fp = unsafe { region.as_mut_ptr().add(bg_base + bf) };
    unsafe { c.copy_nt(data.as_ptr(), fp, flen) };
    c.update(unsafe { region.get_unchecked(bg_base + bf + flen..bg_base + bf + flen + af) }); // BlockDuration + ref
    let frame_crc = c.finalize();
    patch_crc(region, bg_base + bg.crc_offset, frame_crc);
    sink.p = bg_base + bf + flen + af;

    let pre = bg.crc_offset + 4;
    let mut pc = Crc32::new();
    pc.update(unsafe { region.get_unchecked(bg_base..bg_base + pre) }); // BlockGroup header + the patched CRC
    sink.crc = crc32_combine(sink.crc, pc.finalize(), pre as u64);
    sink.crc = crc32_combine(sink.crc, frame_crc, ((bf - pre) + flen + af) as u64);
}

// NAL extents into the chunk map + the block octet count (flen)
#[derive(Clone, Copy)]
struct NalFrame<'a> {
    nals: &'a [ByteRange],
    vsrc: &'a [u8],
    flen: usize,
}

// frame data assembled inline [4-byte len][nal] per NAL from the chunk map
#[inline]
fn emit_nal(
    sink: &mut ClusterSink,
    region: &mut [u8],
    track: u64,
    frame: NalFrame<'_>,
    rel: i16,
    dur: u64,
    is_kf: bool,
) {
    let NalFrame { nals, vsrc, flen } = frame;
    let bg_base = sink.p;
    // flen == sum(4 + nal len); region plan-sized
    let bg = build_block_group(
        unsafe { region.get_unchecked_mut(bg_base..) },
        track,
        flen,
        rel,
        is_kf,
        dur,
    );
    let (bf, af) = (bg.before_frame_len, bg.after_frame_len);

    let mut c = Crc32::new();
    c.update(unsafe { region.get_unchecked(bg_base + bg.crc_offset + 4..bg_base + bf) }); // block header
    let mut fp = bg_base + bf;
    for nal in nals {
        let lb = (nal.len as u32).to_be_bytes();
        unsafe { region.get_unchecked_mut(fp..fp + 4).copy_from_slice(&lb) };
        c.update(&lb);
        let dp = unsafe { region.as_mut_ptr().add(fp + 4) };
        unsafe { c.copy_nt(vsrc.as_ptr().add(nal.offset), dp, nal.len) };
        fp += 4 + nal.len;
    }
    c.update(unsafe { region.get_unchecked(bg_base + bf + flen..bg_base + bf + flen + af) }); // BlockDuration + ref
    let frame_crc = c.finalize();
    patch_crc(region, bg_base + bg.crc_offset, frame_crc);
    sink.p = bg_base + bf + flen + af;

    let pre = bg.crc_offset + 4;
    let mut pc = Crc32::new();
    pc.update(unsafe { region.get_unchecked(bg_base..bg_base + pre) }); // BlockGroup header + the patched CRC
    sink.crc = crc32_combine(sink.crc, pc.finalize(), pre as u64);
    sink.crc = crc32_combine(sink.crc, frame_crc, ((bf - pre) + flen + af) as u64);
}

#[inline]
fn emit_simple_block(
    sink: &mut ClusterSink,
    region: &mut [u8],
    track: u64,
    pkt: ByteRange,
    asrc: &[u8],
    rel: i16,
) {
    let base = sink.p;
    let off = build_simple_block(
        unsafe { region.get_unchecked_mut(base..) },
        track,
        rel,
        pkt.len,
    );
    let mut c = Crc32::new();
    c.update(unsafe { region.get_unchecked(base..base + off) }); // SimpleBlock header
    let dp = unsafe { region.as_mut_ptr().add(base + off) };
    unsafe { c.copy_nt(asrc.as_ptr().add(pkt.offset), dp, pkt.len) };
    sink.crc = crc32_combine(sink.crc, c.finalize(), (off + pkt.len) as u64);
    sink.p = base + off + pkt.len;
}
