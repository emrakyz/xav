use std::{
    collections::HashSet,
    fs::remove_file,
    path::{Path, PathBuf},
    process::{Command, ExitStatus},
    sync::Arc,
};

use ebur128::{EbuR128, Mode};

use crate::{
    chunk::add_mp4_subs,
    error::Xerr,
    ffms::{
        VidIdx, VidInf, aud_src_new, destroy_aud_src, get_audinf, get_audio, set_aud_output_fmt,
    },
    opus,
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
            AudioBitrate::Auto
        } else if parts[0].starts_with("norm") {
            AudioBitrate::Norm(parse_norm(parts[0])?)
        } else {
            AudioBitrate::Fixed(parts[0].parse()?)
        },
        streams: if parts[1] == "all" {
            AudioStreams::All
        } else {
            AudioStreams::Specific(
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

fn frame_to_sample(frame: usize, fps_num: u32, fps_den: u32, rate: u32) -> i64 {
    #[allow(clippy::cast_possible_wrap)]
    let f = frame as i64;
    (f * i64::from(fps_den) * i64::from(rate)) / i64::from(fps_num)
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

fn downmix_to_stereo(input: &[f32], channels: usize, num_samples: usize) -> Vec<f32> {
    let mut out = Vec::with_capacity(num_samples * 2);
    for i in 0..num_samples {
        let b = i * channels;
        let fl = input[b];
        let fr = input[b + 1];
        let fc = if channels >= 3 { input[b + 2] } else { 0.0 };
        let (sl, sr, bl, br, bc) = match channels {
            6 => (input[b + 4], input[b + 5], 0.0, 0.0, 0.0),
            7 => (input[b + 5], input[b + 6], 0.0, 0.0, input[b + 4]),
            8 => (input[b + 6], input[b + 7], input[b + 4], input[b + 5], 0.0),
            _ => (0.0, 0.0, 0.0, 0.0, 0.0),
        };
        out.push(0.707f32.mul_add(
            fc,
            0.707f32.mul_add(sl, 0.5f32.mul_add(bl, 0.5f32.mul_add(bc, fl))),
        ));
        out.push(0.707f32.mul_add(
            fc,
            0.707f32.mul_add(sr, 0.5f32.mul_add(br, 0.5f32.mul_add(bc, fr))),
        ));
    }
    out
}

fn encode_direct(
    idx: &VidIdx,
    stream: &AudioStream,
    bitrate: u32,
    output: &Path,
    ranges: Option<&[(usize, usize)]>,
    inf: &VidInf,
    progs_line: usize,
) -> Result<(), Xerr> {
    #[allow(clippy::cast_possible_wrap)]
    let aud = aud_src_new(idx, stream.index as i32)?;
    set_aud_output_fmt(aud, 48000)?;
    let ainf = get_audinf(aud);

    let ch = ainf.channels as usize;
    let channels = ainf.channels as u8;
    let family = if channels <= 2 {
        opus::FAMILY_MONO_STEREO
    } else {
        opus::FAMILY_SURROUND
    };

    let sample_ranges: Vec<(i64, i64)> = ranges.map_or_else(
        || vec![(0, ainf.num_samples)],
        |r| {
            r.iter()
                .map(|&(s, e)| {
                    (
                        frame_to_sample(s, inf.fps_num, inf.fps_den, 48000),
                        frame_to_sample(e, inf.fps_num, inf.fps_den, 48000),
                    )
                })
                .collect()
        },
    );

    let total_samples: i64 = sample_ranges.iter().map(|&(s, e)| e - s).sum();
    let mut enc = opus::Encoder::new(output, channels, bitrate, family)?;

    let chunk_size: i64 = 48000;
    let mut buf = vec![0f32; chunk_size as usize * ch];
    let mut progs = ProgsBar::new();
    let mut encoded: i64 = 0;

    for &(start, end) in &sample_ranges {
        let mut pos = start;
        while pos < end {
            let count = chunk_size.min(end - pos);
            let sl = &mut buf[..count as usize * ch];
            get_audio(aud, sl.as_mut_ptr().cast::<u8>(), pos, count)?;

            if ch > 2 {
                reorder_surround(sl, ch, count as usize);
            }

            enc.write_float(sl, ch)?;

            encoded += count;
            progs.up_audio(encoded as usize, total_samples as usize, progs_line, 1);
            pos += count;
        }
    }

    drop(enc);
    destroy_aud_src(aud);
    ProgsBar::finish_audio();
    Ok(())
}

fn encode_norm(
    idx: &VidIdx,
    stream: &AudioStream,
    output: &Path,
    ranges: Option<&[(usize, usize)]>,
    inf: &VidInf,
    np: NormParams,
    progs_line: usize,
) -> Result<(), Xerr> {
    #[allow(clippy::cast_possible_wrap)]
    let aud = aud_src_new(idx, stream.index as i32)?;
    set_aud_output_fmt(aud, 48000)?;
    let ainf = get_audinf(aud);

    let ch = ainf.channels as usize;

    let sample_ranges: Vec<(i64, i64)> = ranges.map_or_else(
        || vec![(0, ainf.num_samples)],
        |r| {
            r.iter()
                .map(|&(s, e)| {
                    (
                        frame_to_sample(s, inf.fps_num, inf.fps_den, 48000),
                        frame_to_sample(e, inf.fps_num, inf.fps_den, 48000),
                    )
                })
                .collect()
        },
    );

    let total_samples: i64 = sample_ranges.iter().map(|&(s, e)| e - s).sum();

    let mut progs = ProgsBar::new();

    let mut raw = Vec::with_capacity(total_samples as usize * ch);
    let chunk_size: i64 = 48000;
    let mut buf = vec![0f32; chunk_size as usize * ch];
    let mut decoded: i64 = 0;

    for &(start, end) in &sample_ranges {
        let mut pos = start;
        while pos < end {
            let count = chunk_size.min(end - pos);
            let sl = &mut buf[..count as usize * ch];
            get_audio(aud, sl.as_mut_ptr().cast::<u8>(), pos, count)?;
            raw.extend_from_slice(sl);
            decoded += count;
            progs.up_audio(decoded as usize, total_samples as usize, progs_line, 1);
            pos += count;
        }
    }

    destroy_aud_src(aud);

    let mut stereo = if ch > 2 {
        downmix_to_stereo(&raw, ch, total_samples as usize)
    } else {
        raw
    };

    let mut ebur =
        EbuR128::new(2, 48000, Mode::I | Mode::TRUE_PEAK | Mode::LRA).map_err(|e| e.to_string())?;
    ebur.add_frames_f32(&stereo).map_err(|e| e.to_string())?;
    let lufs = ebur.loudness_global().map_err(|e| e.to_string())?;
    let lra = ebur.loudness_range().map_err(|e| e.to_string())?;

    let mut gain = 10f64.powf((np.i - lufs) / 20.0);
    if lra > np.lra {
        gain *= np.lra / lra;
    }
    let tp_limit = 10f32.powf(np.tp / 20.0);

    for s in &mut stereo {
        *s = (f64::from(*s) * gain) as f32;
        *s = s.clamp(-tp_limit, tp_limit);
    }

    let stereo_samples = stereo.len() / 2;
    let mut enc = opus::Encoder::new(output, 2, np.bitrate, opus::FAMILY_MONO_STEREO)?;
    progs = ProgsBar::new();
    let enc_chunk = 48000usize;
    let mut pos = 0;

    while pos < stereo_samples {
        let count = enc_chunk.min(stereo_samples - pos);
        let start = pos * 2;
        let end = start + count * 2;
        enc.write_float(&stereo[start..end], 2)?;
        pos += count;
        progs.up_audio(pos, stereo_samples, progs_line, 2);
    }

    drop(enc);
    ProgsBar::finish_audio();
    Ok(())
}

pub fn encode_audio_streams(
    spec: &AudioSpec,
    input: &Path,
    idx: &Arc<VidIdx>,
    ranges: Option<&[(usize, usize)]>,
    inf: &VidInf,
    work_dir: &Path,
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

    sel.iter()
        .map(|s| {
            let do_norm = norm_params.is_some() && s.channels > 2;
            let br = if do_norm {
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
            let path = work_dir.join(format!(
                "{}_{:02}.opus",
                s.lang.as_deref().unwrap_or("und"),
                s.index
            ));

            if let Some(np) = norm_params
                && do_norm
            {
                encode_norm(idx, s, &path, ranges, inf, np, progs_line)?;
            } else {
                encode_direct(idx, s, br, &path, ranges, inf, progs_line)?;
            }
            Ok::<_, Xerr>(((*s).clone(), path))
        })
        .collect()
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
