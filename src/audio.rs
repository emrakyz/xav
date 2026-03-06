use std::{
    collections::HashSet,
    fs::remove_file,
    path::{Path, PathBuf},
    process::{Command, ExitStatus},
    thread::scope,
};

use ebur128::{EbuR128, Mode};

use crate::{
    audio::{
        AudioBitrate::{Auto, Fixed, Norm},
        AudioStreams::{All, Specific},
    },
    chunk::add_mp4_subs,
    error::{
        Xerr,
        Xerr::{Done, Msg},
    },
    lavf::AudioDecoder,
    opus::{Encoder, FAMILY_MONO_STEREO, FAMILY_SURROUND},
    progs::ProgsBar,
};

#[derive(Clone, Copy)]
pub struct NormParams {
    pub i: f64,
    pub tp: f32,
    pub lra: f64,
    pub bitrate: u32,
}

impl NormParams {
    const fn default() -> Self {
        Self {
            i: -16.0,
            tp: -1.5,
            lra: 16.0,
            bitrate: 128,
        }
    }
}

#[derive(Clone)]
#[non_exhaustive]
pub enum AudioBitrate {
    Auto,
    Fixed(u32),
    Norm(NormParams),
}

#[derive(Clone)]
#[non_exhaustive]
pub enum AudioStreams {
    All,
    Specific(Vec<usize>),
}

#[derive(Clone)]
pub struct AudioSpec {
    pub bitrate: AudioBitrate,
    pub streams: AudioStreams,
}

#[derive(Clone)]
pub struct AudioStream {
    pub index: usize,
    pub channels: u32,
    pub lang: Option<String>,
}

const FF_FLAGS: [&str; 13] = [
    "-fflags",
    "+genpts+igndts+discardcorrupt+bitexact",
    "-bitexact",
    "-avoid_negative_ts",
    "make_zero",
    "-err_detect",
    "ignore_err",
    "-ignore_unknown",
    "-reset_timestamps",
    "1",
    "-start_at_zero",
    "-output_ts_offset",
    "0",
];

fn parse_norm(s: &str) -> Result<NormParams, Xerr> {
    if s == "norm" {
        return Ok(NormParams::default());
    }
    let inner = s
        .strip_prefix("norm(")
        .and_then(|r| r.strip_suffix(')'))
        .ok_or("norm format: norm or norm(I,TP,LRA)")?;
    let vals: Vec<&str> = inner.split(',').collect();
    if vals.len() != 3 {
        return Err("norm format: norm(I,TP,LRA) e.g. norm(-16,-1.5,16)".into());
    }
    Ok(NormParams {
        i: vals[0].parse()?,
        tp: vals[1].parse()?,
        lra: vals[2].parse()?,
        bitrate: 128,
    })
}

pub fn parse_audio_arg(arg: &str) -> Result<AudioSpec, Xerr> {
    let parts: Vec<&str> = arg.split_whitespace().collect();
    if parts.len() != 2 {
        return Err("Audio format: -a <auto|norm|norm(I,TP,LRA)|bitrate> <all|stream_ids>".into());
    }

    Ok(AudioSpec {
        bitrate: if parts[0] == "auto" {
            Auto
        } else if parts[0].starts_with("norm") {
            Norm(parse_norm(parts[0])?)
        } else {
            Fixed(parts[0].parse()?)
        },
        streams: if parts[1] == "all" {
            All
        } else {
            Specific(
                parts[1]
                    .split(',')
                    .map(str::parse)
                    .collect::<Result<_, _>>()?,
            )
        },
    })
}

fn lang_name(code: &str) -> &str {
    match code {
        "eng" => "English",
        "rus" => "Russian",
        "jpn" => "Japanese",
        "spa" => "Spanish",
        "fre" | "fra" => "French",
        "ger" | "deu" => "German",
        "ita" => "Italian",
        "por" => "Portuguese",
        "chi" | "zho" => "Chinese",
        "kor" => "Korean",
        "ara" => "Arabic",
        "hin" => "Hindi",
        "tur" => "Turkish",
        "pol" => "Polish",
        "ukr" => "Ukrainian",
        "dut" | "nld" => "Dutch",
        "swe" => "Swedish",
        "dan" => "Danish",
        "nor" => "Norwegian",
        "fin" => "Finnish",
        "gre" | "ell" => "Greek",
        "cze" | "ces" => "Czech",
        "hun" => "Hungarian",
        "rum" | "ron" => "Romanian",
        "tha" => "Thai",
        "vie" => "Vietnamese",
        "ind" => "Indonesian",
        "may" | "msa" => "Malay",
        "heb" => "Hebrew",
        "per" | "fas" => "Persian",
        "bul" => "Bulgarian",
        "srp" => "Serbian",
        "hrv" => "Croatian",
        "slk" | "slo" => "Slovak",
        "slv" => "Slovenian",
        "bel" => "Belarusian",
        "ben" => "Bengali",
        "tam" => "Tamil",
        "tel" => "Telugu",
        "mar" => "Marathi",
        "urd" => "Urdu",
        "pan" => "Punjabi",
        "tgl" => "Filipino",
        "mya" | "bur" => "Burmese",
        "khm" => "Khmer",
        "swa" => "Swahili",
        "zul" => "Zulu",
        "xho" => "Xhosa",
        "hau" => "Hausa",
        "amh" => "Amharic",
        "isl" | "ice" => "Icelandic",
        "mlt" => "Maltese",
        "gle" => "Irish",
        "lav" => "Latvian",
        "lit" => "Lithuanian",
        "est" => "Estonian",
        "nep" => "Nepali",
        "sin" => "Sinhala",
        "pus" | "pbt" => "Pashto",
        "lao" => "Lao",
        "mon" => "Mongolian",
        _ => code,
    }
}

fn get_streams(input: &Path) -> Result<Vec<AudioStream>, Xerr> {
    let out = Command::new("ffprobe")
        .args([
            "-v",
            "quiet",
            "-select_streams",
            "a",
            "-show_entries",
            "stream=index,channels:stream_tags=language",
            "-of",
            "csv=p=0",
        ])
        .arg(input)
        .output()?;

    let mut seen = HashSet::new();
    let mut streams: Vec<_> = String::from_utf8_lossy(&out.stdout)
        .lines()
        .rev()
        .filter_map(|l| {
            let p: Vec<_> = l.split(',').collect();
            (p.len() >= 2).then(|| {
                let idx = p[0].parse().ok()?;
                seen.insert(idx).then(|| AudioStream {
                    index: idx,
                    channels: p[1].parse().unwrap_or(2),
                    lang: p.get(2).filter(|s| !s.is_empty()).map(ToString::to_string),
                })
            })?
        })
        .collect();
    streams.reverse();
    streams.sort_by_key(|s| s.index);
    Ok(streams)
}

pub fn frame_to_sample(frame: usize, fps_num: u32, fps_den: u32, rate: u32) -> i64 {
    let f = frame as i64;
    (f * i64::from(fps_den) * i64::from(rate)) / i64::from(fps_num)
}

pub fn get_fps(input: &Path) -> Result<(u32, u32), Xerr> {
    let out = Command::new("ffprobe")
        .args([
            "-v",
            "quiet",
            "-select_streams",
            "v:0",
            "-show_entries",
            "stream=r_frame_rate",
            "-of",
            "csv=p=0",
        ])
        .arg(input)
        .output()?;
    let s = String::from_utf8_lossy(&out.stdout);
    let s = s.trim();
    let (num, den) = s.split_once('/').ok_or("Failed to parse fps")?;
    Ok((num.parse()?, den.parse()?))
}

fn reorder_surround(buf: &mut [f32], channels: usize, num_samples: usize) {
    let map: &[usize] = match channels {
        6 => &[0, 2, 1, 4, 5, 3],
        7 => &[0, 2, 1, 5, 6, 4, 3],
        8 => &[0, 2, 1, 6, 7, 4, 5, 3],
        _ => return,
    };
    let mut tmp = [0.0f32; 8];
    for i in 0..num_samples {
        let base = i * channels;
        for (j, &m) in map.iter().enumerate() {
            tmp[j] = buf[base + m];
        }
        buf[base..base + channels].copy_from_slice(&tmp[..channels]);
    }
}

fn downmix_chunk(src: &[f32], dst: &mut [f32], ch: usize, n: usize) {
    for i in 0..n {
        let b = i * ch;
        let fl = src[b];
        let fr = src[b + 1];
        let fc = if ch >= 3 { src[b + 2] } else { 0.0 };
        let (sl, sr, bl, br, bc) = match ch {
            6 => (src[b + 4], src[b + 5], 0.0, 0.0, 0.0),
            7 => (src[b + 5], src[b + 6], 0.0, 0.0, src[b + 4]),
            8 => (src[b + 6], src[b + 7], src[b + 4], src[b + 5], 0.0),
            _ => (0.0, 0.0, 0.0, 0.0, 0.0),
        };
        let o = i * 2;
        dst[o] = 0.707f32.mul_add(
            fc,
            0.707f32.mul_add(sl, 0.5f32.mul_add(bl, 0.5f32.mul_add(bc, fl))),
        );
        dst[o + 1] = 0.707f32.mul_add(
            fc,
            0.707f32.mul_add(sr, 0.5f32.mul_add(br, 0.5f32.mul_add(bc, fr))),
        );
    }
}

fn encode_direct(
    input: &Path,
    stream: &AudioStream,
    bitrate: u32,
    output: &Path,
    sample_ranges: Option<&[(i64, i64)]>,
    progs_line: usize,
) -> Result<(), Xerr> {
    let mut dec = AudioDecoder::new(input, stream.index as i32)?;
    let ch = dec.channels() as usize;
    let total: i64 = sample_ranges.map_or_else(
        || dec.total_samples(),
        |r| r.iter().map(|&(s, e)| e - s).sum(),
    );
    let family = if ch <= 2 {
        FAMILY_MONO_STEREO
    } else {
        FAMILY_SURROUND
    };
    let mut enc = Encoder::new(output, ch as u8, bitrate, family)?;
    let mut progs = ProgsBar::new();
    let mut encoded: i64 = 0;
    let tid = stream.index;
    let needs_reorder = ch > 2;
    let mut pos: i64 = 0;
    let mut ri: usize = 0;

    dec.decode_to(|chunk| {
        let n = (chunk.len() / ch) as i64;
        if let Some(ranges) = sample_ranges {
            let chunk_end = pos + n;
            while ri < ranges.len() && ranges[ri].0 < chunk_end {
                let (rs, re) = ranges[ri];
                let start = (rs - pos).max(0) as usize;
                let end = ((re - pos).min(n)) as usize;
                if start < end {
                    let sl = &mut chunk[start * ch..end * ch];
                    if needs_reorder {
                        reorder_surround(sl, ch, end - start);
                    }
                    enc.write_float(sl, ch)?;
                    encoded += (end - start) as i64;
                }
                if re <= chunk_end {
                    ri += 1;
                    if ri >= ranges.len() {
                        return Err(Done);
                    }
                } else {
                    break;
                }
            }
        } else {
            if needs_reorder {
                reorder_surround(chunk, ch, n as usize);
            }
            enc.write_float(chunk, ch)?;
            encoded += n;
        }
        pos += n;
        progs.up_audio(encoded as usize, total as usize, progs_line, 1, tid);
        Ok(())
    })?;

    progs.up_audio_final(total as usize, progs_line, 1, tid);
    drop(enc);
    ProgsBar::finish_audio();
    Ok(())
}

fn analyze_loudness(
    input: &Path,
    stream_idx: i32,
    ch: usize,
    sample_ranges: Option<&[(i64, i64)]>,
    total: i64,
    progs_line: usize,
    tid: usize,
) -> Result<EbuR128, Xerr> {
    let mut dec = AudioDecoder::new(input, stream_idx)?;
    let mut ebur =
        EbuR128::new(2, 48000, Mode::I | Mode::TRUE_PEAK | Mode::LRA).map_err(|e| e.to_string())?;
    let mut stereo = vec![0f32; 96000 * 2];
    let mut progs = ProgsBar::new();
    let mut decoded: i64 = 0;
    let mut pos: i64 = 0;
    let mut ri: usize = 0;

    dec.decode_to(|chunk| {
        let n = (chunk.len() / ch) as i64;
        if let Some(ranges) = sample_ranges {
            let chunk_end = pos + n;
            while ri < ranges.len() && ranges[ri].0 < chunk_end {
                let (rs, re) = ranges[ri];
                let start = (rs - pos).max(0) as usize;
                let end = ((re - pos).min(n)) as usize;
                if start < end {
                    let cnt = end - start;
                    let st = &mut stereo[..cnt * 2];
                    if ch > 2 {
                        downmix_chunk(&chunk[start * ch..end * ch], st, ch, cnt);
                    } else {
                        st.copy_from_slice(&chunk[start * ch..end * ch]);
                    }
                    ebur.add_frames_f32(st).map_err(|e| e.to_string())?;
                    decoded += cnt as i64;
                }
                if re <= chunk_end {
                    ri += 1;
                    if ri >= ranges.len() {
                        return Err(Done);
                    }
                } else {
                    break;
                }
            }
        } else {
            let n = n as usize;
            let st = &mut stereo[..n * 2];
            if ch > 2 {
                downmix_chunk(chunk, st, ch, n);
            } else {
                st.copy_from_slice(chunk);
            }
            ebur.add_frames_f32(st).map_err(|e| e.to_string())?;
            decoded += n as i64;
        }
        pos += (chunk.len() / ch) as i64;
        progs.up_audio(decoded as usize, total as usize, progs_line, 1, tid);
        Ok(())
    })?;

    progs.up_audio_final(total as usize, progs_line, 1, tid);
    Ok(ebur)
}

fn encode_norm(
    input: &Path,
    stream: &AudioStream,
    output: &Path,
    sample_ranges: Option<&[(i64, i64)]>,
    np: NormParams,
    progs_line: usize,
) -> Result<(), Xerr> {
    let dec = AudioDecoder::new(input, stream.index as i32)?;
    let ch = dec.channels() as usize;
    let total: i64 = sample_ranges.map_or_else(
        || dec.total_samples(),
        |r| r.iter().map(|&(s, e)| e - s).sum(),
    );
    let tid = stream.index;
    drop(dec);

    let ebur = analyze_loudness(
        input,
        stream.index as i32,
        ch,
        sample_ranges,
        total,
        progs_line,
        tid,
    )?;
    let lufs = ebur.loudness_global().map_err(|e| e.to_string())?;
    let lra = ebur.loudness_range().map_err(|e| e.to_string())?;

    let mut gain = 10f64.powf((np.i - lufs) / 20.0);
    if lra > np.lra {
        gain *= np.lra / lra;
    }
    let tp_limit = 10f32.powf(np.tp / 20.0);

    let mut dec2 = AudioDecoder::new(input, stream.index as i32)?;
    let mut enc = Encoder::new(output, 2, np.bitrate, FAMILY_MONO_STEREO)?;
    let mut stereo = vec![0f32; 96000 * 2];
    let mut progs = ProgsBar::new();
    let mut encoded: i64 = 0;
    let mut pos: i64 = 0;
    let mut ri: usize = 0;

    dec2.decode_to(|chunk| {
        let n = (chunk.len() / ch) as i64;
        if let Some(ranges) = sample_ranges {
            let chunk_end = pos + n;
            while ri < ranges.len() && ranges[ri].0 < chunk_end {
                let (rs, re) = ranges[ri];
                let start = (rs - pos).max(0) as usize;
                let end = ((re - pos).min(n)) as usize;
                if start < end {
                    let cnt = end - start;
                    let st = &mut stereo[..cnt * 2];
                    if ch > 2 {
                        downmix_chunk(&chunk[start * ch..end * ch], st, ch, cnt);
                    } else {
                        st.copy_from_slice(&chunk[start * ch..end * ch]);
                    }
                    for s in st.iter_mut() {
                        *s = (f64::from(*s) * gain) as f32;
                        *s = s.clamp(-tp_limit, tp_limit);
                    }
                    enc.write_float(st, 2)?;
                    encoded += cnt as i64;
                }
                if re <= chunk_end {
                    ri += 1;
                } else {
                    break;
                }
            }
        } else {
            let n = n as usize;
            let st = &mut stereo[..n * 2];
            if ch > 2 {
                downmix_chunk(chunk, st, ch, n);
            } else {
                st.copy_from_slice(chunk);
            }
            for s in st.iter_mut() {
                *s = (f64::from(*s) * gain) as f32;
                *s = s.clamp(-tp_limit, tp_limit);
            }
            enc.write_float(st, 2)?;
            encoded += n as i64;
        }
        pos += (chunk.len() / ch) as i64;
        progs.up_audio(encoded as usize, total as usize, progs_line, 2, tid);
        Ok(())
    })?;

    progs.up_audio_final(total as usize, progs_line, 2, tid);
    drop(enc);
    ProgsBar::finish_audio();
    Ok(())
}

struct TrackJob {
    stream: AudioStream,
    do_norm: bool,
    bitrate: u32,
    path: PathBuf,
    line: usize,
}

pub fn encode_audio_streams(
    spec: &AudioSpec,
    input: &Path,
    work_dir: &Path,
    sample_ranges: Option<&[(i64, i64)]>,
    progs_line: usize,
) -> Result<Vec<(AudioStream, PathBuf)>, Xerr> {
    let all = get_streams(input)?;
    let sel: Vec<_> = match spec.streams {
        AudioStreams::All => all.iter().collect(),
        AudioStreams::Specific(ref ids) => all.iter().filter(|s| ids.contains(&s.index)).collect(),
    };

    let norm_params = match spec.bitrate {
        AudioBitrate::Norm(p) => Some(p),
        _ => None,
    };

    let jobs: Vec<_> = sel
        .iter()
        .enumerate()
        .map(|(i, s)| {
            let do_norm = norm_params.is_some() && s.channels > 2;
            let bitrate = if do_norm {
                128
            } else {
                match spec.bitrate {
                    AudioBitrate::Auto | AudioBitrate::Norm(_) => {
                        let cc = match s.channels {
                            1 => 1.0,
                            2 => 2.0,
                            3 => 2.1,
                            4 => 3.1,
                            5 => 4.1,
                            6 => 5.1,
                            7 => 6.1,
                            8 => 7.1,
                            _ => f64::from(s.channels),
                        };
                        (128.0 * (cc / 2.0f64).powf(0.75)) as u32
                    }
                    AudioBitrate::Fixed(b) => b,
                }
            };
            TrackJob {
                stream: (*s).clone(),
                do_norm,
                bitrate,
                path: work_dir.join(format!(
                    "{}_{:02}.opus",
                    s.lang.as_deref().unwrap_or("und"),
                    s.index
                )),
                line: if progs_line > 0 { progs_line + i } else { 0 },
            }
        })
        .collect();

    scope(|scope| {
        jobs.iter()
            .map(|j| {
                scope.spawn(|| {
                    if let Some(np) = norm_params
                        && j.do_norm
                    {
                        encode_norm(input, &j.stream, &j.path, sample_ranges, np, j.line)?;
                    } else {
                        encode_direct(input, &j.stream, j.bitrate, &j.path, sample_ranges, j.line)?;
                    }
                    Ok::<_, Xerr>((j.stream.clone(), j.path.clone()))
                })
            })
            .collect::<Vec<_>>()
            .into_iter()
            .map(|h| h.join().map_err(|_e| Msg("Audio thread panicked".into()))?)
            .collect()
    })
}

fn mux_files(
    video: &Path,
    files: &[(AudioStream, PathBuf)],
    input: &Path,
    output: &Path,
    has_ranges: bool,
    dar: Option<(u32, u32)>,
) -> Result<(), Xerr> {
    let mut cmd = Command::new("ffmpeg");
    cmd.args([
        "-loglevel",
        "error",
        "-hide_banner",
        "-nostdin",
        "-stats",
        "-y",
        "-i",
    ])
    .arg(video);

    for item in files {
        cmd.arg("-i").arg(&item.1);
    }

    let is_mp4 = output.extension().is_some_and(|e| e == "mp4");

    if !has_ranges && !is_mp4 {
        cmd.arg("-i").arg(input);
    }

    cmd.args(["-map", "0:v"]);

    for i in 0..files.len() {
        cmd.args(["-map", &format!("{}:a", i + 1)]);
    }

    if !has_ranges && !is_mp4 {
        let input_idx = files.len() + 1;
        cmd.args(["-map", &format!("{input_idx}")])
            .args(["-map", &format!("-{input_idx}:V")])
            .args(["-map", &format!("-{input_idx}:a")])
            .args(["-map_chapters", &input_idx.to_string()]);
    }

    for (i, item) in files.iter().enumerate() {
        let code = item.0.lang.as_deref().unwrap_or("und");
        cmd.args([&format!("-metadata:s:a:{i}"), &format!("language={code}")]);
        cmd.args([
            &format!("-metadata:s:a:{i}"),
            &format!("title={}", lang_name(code)),
        ]);
    }

    cmd.args(["-c", "copy"]);
    if let Some((dw, dh)) = dar {
        cmd.args(["-aspect", &format!("{dw}:{dh}")]);
    }
    cmd.args(FF_FLAGS)
        .arg(output)
        .status()
        .ok()
        .filter(ExitStatus::success)
        .ok_or("Muxing failed")?;
    Ok(())
}

pub fn mux_audio(
    files: &[(AudioStream, PathBuf)],
    video: &Path,
    input: &Path,
    output: &Path,
    has_ranges: bool,
    dar: Option<(u32, u32)>,
) -> Result<(), Xerr> {
    mux_files(video, files, input, output, has_ranges, dar)?;

    if !has_ranges && output.extension().is_some_and(|e| e == "mp4") {
        add_mp4_subs(input, output);
    }

    for item in files {
        _ = remove_file(&item.1);
    }
    Ok(())
}
