use std::{
    path::{Path, PathBuf},
    thread::scope,
};

use ebur128::{EbuR128, Mode};

use crate::{
    audio::{
        AuBrate::{Auto, Fixed, Norm},
        AuStreams::{All, Specific},
    },
    error::{Xerr, Xerr::Msg},
    ffms::get_au_streams,
    lavf::AuDecoder,
    opus::{Encoder, FAMILY_MONO_STEREO, FAMILY_SURROUND},
    progs::ProgsBar,
};

#[derive(Clone, Copy)]
pub struct NormParams {
    pub i: f32,
    pub tp: f32,
    pub lra: f32,
    pub brate: u16,
}

impl NormParams {
    const fn default() -> Self {
        Self {
            i: -16.0,
            tp: -1.5,
            lra: 16.0,
            brate: 128,
        }
    }
}

#[derive(Clone)]
#[non_exhaustive]
pub enum AuBrate {
    Auto,
    Fixed(u16),
    Norm(NormParams),
}

#[derive(Clone)]
#[non_exhaustive]
pub enum AuStreams {
    All,
    Specific(Vec<u8>),
}

#[derive(Clone)]
pub struct AuSpec {
    pub brate: AuBrate,
    pub streams: AuStreams,
}

#[derive(Clone)]
pub struct AuStream {
    pub index: u8,
    pub channels: u8,
    pub lang: Option<String>,
    pub bitrate: u16,
}

fn parse_norm(s: &str) -> Result<NormParams, Xerr> {
    if s == "norm" {
        return Ok(NormParams::default());
    }
    let inner = s
        .strip_prefix("norm(")
        .and_then(|r| r.strip_suffix(')'))
        .ok_or("norm format: norm or norm(I,TP,LRA[,BITRATE])")?;
    let (i, tp, lra, brate) = match *inner.split(',').collect::<Vec<_>>() {
        [i, tp, lra] => (i, tp, lra, "128"),
        [i, tp, lra, b] => (i, tp, lra, b),
        _ => return Err("norm format: norm(I,TP,LRA[,BITRATE]) e.g. norm(-16,-1.5,16,192)".into()),
    };
    Ok(NormParams {
        i: i.parse()?,
        tp: tp.parse()?,
        lra: lra.parse()?,
        brate: brate.parse()?,
    })
}

pub fn parse_au_arg(arg: &str) -> Result<AuSpec, Xerr> {
    let parts: Vec<&str> = arg.split_whitespace().collect();
    if parts.len() != 2 {
        return Err("Audio format: -a <auto|norm|norm(I,TP,LRA)|brate> <all|stream_ids>".into());
    }

    Ok(AuSpec {
        brate: if parts[0] == "auto" {
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

pub fn lang_name(code: &str) -> &str {
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

fn get_streams(inp: &Path) -> Result<Vec<AuStream>, Xerr> {
    get_au_streams(inp).map(|v| {
        v.into_iter()
            .map(|(index, channels, lang)| AuStream {
                index,
                channels,
                lang,
                bitrate: 0,
            })
            .collect()
    })
}

pub fn frame_samp(frame: usize, fps_num: u32, fps_den: u32, rate: u32) -> i64 {
    let f = frame as i64;
    (f * i64::from(fps_den) * i64::from(rate)) / i64::from(fps_num)
}

fn reord_surround(buf: &mut [f32], channels: usize, num_samples: usize) {
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

fn downmix_chnk(src: &[f32], dst: &mut [f32], ch: usize, n: usize) {
    for i in 0..n {
        let b = i * ch;
        let fl = src[b];
        let fr = src[b + 1];
        let fc = if ch >= 3 { src[b + 2] } else { 0.0 };
        let (sl, sr, bl, br, bc) = match ch {
            6 => (src[b + 4], src[b + 5], 0.0, 0.0, 0.0),
            7 => (src[b + 5], src[b + 6], 0.0, 0.0, src[b + 4]),
            8 => (
                src[b + 6] * 0.707,
                src[b + 7] * 0.707,
                src[b + 4],
                src[b + 5],
                0.0,
            ),
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

fn enc_direct(
    inp: &Path,
    stream: &AuStream,
    brate: u16,
    out: &Path,
    samp_ranges: Option<&[(i64, i64)]>,
    progs_line: usize,
) -> Result<(), Xerr> {
    let mut dec = AuDecoder::new(inp, i32::from(stream.index))?;
    let ch = usize::from(dec.channels());
    let tot: i64 = samp_ranges.map_or_else(
        || dec.tot_samples(),
        |r| r.iter().map(|&(s, e)| e - s).sum(),
    );
    let family = if ch <= 2 {
        FAMILY_MONO_STEREO
    } else {
        FAMILY_SURROUND
    };
    let mut enc = Encoder::new(out, ch as u8, brate, family)?;
    let mut progs = ProgsBar::new();
    let mut enced: i64 = 0;
    let tid = stream.index;
    let need_reord = ch > 2;

    let cb = |chnk: &mut [f32]| -> Result<(), Xerr> {
        let n = (chnk.len() / ch) as i64;
        if need_reord {
            reord_surround(chnk, ch, n as usize);
        }
        enc.write_float(chnk, ch)?;
        enced += n;
        progs.up_au(enced as usize, tot as usize, progs_line, 1, tid);
        Ok(())
    };
    match samp_ranges {
        Some(rs) => dec.dec_ranges(rs, cb)?,
        None => dec.dec_all(cb)?,
    }

    progs.up_au(tot as usize, tot as usize, progs_line, 1, tid);
    drop(enc);
    Ok(())
}

fn calc_loudness(
    inp: &Path,
    stream_idx: i32,
    ch: usize,
    samp_ranges: Option<&[(i64, i64)]>,
    tot: i64,
    progs_line: usize,
    tid: u8,
) -> Result<EbuR128, Xerr> {
    let mut dec = AuDecoder::new(inp, stream_idx)?;
    let mut ebur =
        EbuR128::new(2, 48000, Mode::I | Mode::TRUE_PEAK | Mode::LRA).map_err(|e| e.to_string())?;
    let mut stereo = vec![0f32; 96000 * 2];
    let mut progs = ProgsBar::new();
    let mut decoded: i64 = 0;

    let cb = |chnk: &mut [f32]| -> Result<(), Xerr> {
        let n = chnk.len() / ch;
        let st = &mut stereo[..n * 2];
        if ch > 2 {
            downmix_chnk(chnk, st, ch, n);
        } else {
            st.copy_from_slice(chnk);
        }
        ebur.add_frames_f32(st).map_err(|e| e.to_string())?;
        decoded += n as i64;
        progs.up_au(decoded as usize, tot as usize, progs_line, 1, tid);
        Ok(())
    };
    match samp_ranges {
        Some(rs) => dec.dec_ranges(rs, cb)?,
        None => dec.dec_all(cb)?,
    }

    progs.up_au(tot as usize, tot as usize, progs_line, 1, tid);
    Ok(ebur)
}

fn enc_norm(
    inp: &Path,
    stream: &AuStream,
    out: &Path,
    samp_ranges: Option<&[(i64, i64)]>,
    np: NormParams,
    progs_line: usize,
) -> Result<(), Xerr> {
    let dec = AuDecoder::new(inp, i32::from(stream.index))?;
    let ch = usize::from(dec.channels());
    let tot: i64 = samp_ranges.map_or_else(
        || dec.tot_samples(),
        |r| r.iter().map(|&(s, e)| e - s).sum(),
    );
    let tid = stream.index;
    drop(dec);

    let ebur = calc_loudness(
        inp,
        i32::from(stream.index),
        ch,
        samp_ranges,
        tot,
        progs_line,
        tid,
    )?;
    let lufs = ebur.loudness_global().map_err(|e| e.to_string())? as f32;
    let lra = ebur.loudness_range().map_err(|e| e.to_string())? as f32;

    let mut gain = 10f32.powf((np.i - lufs) / 20.0);
    if lra > np.lra {
        gain *= np.lra / lra;
    }
    let tp_limit = 10f32.powf(np.tp / 20.0);

    let mut dec2 = AuDecoder::new(inp, i32::from(stream.index))?;
    let mut enc = Encoder::new(out, 2, np.brate, FAMILY_MONO_STEREO)?;
    let mut stereo = vec![0f32; 96000 * 2];
    let mut progs = ProgsBar::new();
    let mut enced: i64 = 0;

    let cb = |chnk: &mut [f32]| -> Result<(), Xerr> {
        let n = chnk.len() / ch;
        let st = &mut stereo[..n * 2];
        if ch > 2 {
            downmix_chnk(chnk, st, ch, n);
        } else {
            st.copy_from_slice(chnk);
        }
        for s in st.iter_mut() {
            *s = (*s * gain).clamp(-tp_limit, tp_limit);
        }
        enc.write_float(st, 2)?;
        enced += n as i64;
        progs.up_au(enced as usize, tot as usize, progs_line, 2, tid);
        Ok(())
    };
    match samp_ranges {
        Some(rs) => dec2.dec_ranges(rs, cb)?,
        None => dec2.dec_all(cb)?,
    }

    progs.up_au(tot as usize, tot as usize, progs_line, 2, tid);
    drop(enc);
    Ok(())
}

struct TrackJob {
    stream: AuStream,
    do_norm: bool,
    brate: u16,
    path: PathBuf,
    line: usize,
}

pub fn enc_au_streams(
    spec: &AuSpec,
    inp: &Path,
    work_dir: &Path,
    samp_ranges: Option<&[(i64, i64)]>,
    progs_line: usize,
) -> Result<Vec<(AuStream, PathBuf)>, Xerr> {
    let all = get_streams(inp)?;
    let sel: Vec<_> = match spec.streams {
        AuStreams::All => all.iter().collect(),
        AuStreams::Specific(ref ids) => all.iter().filter(|s| ids.contains(&s.index)).collect(),
    };

    let norm_params = match spec.brate {
        AuBrate::Norm(p) => Some(p),
        _ => None,
    };

    let jobs: Vec<_> = sel
        .iter()
        .enumerate()
        .map(|(i, s)| {
            let np = norm_params.filter(|_| s.channels > 2);
            let do_norm = np.is_some();
            let brate = np.map_or_else(
                || match spec.brate {
                    AuBrate::Auto | AuBrate::Norm(_) => {
                        let cc = match s.channels {
                            1 => 1.0,
                            2 => 2.0,
                            3 => 2.1,
                            4 => 3.1,
                            5 => 4.1,
                            6 => 5.1,
                            7 => 6.1,
                            8 => 7.1,
                            _ => f32::from(s.channels),
                        };
                        (128.0 * (cc / 2.0f32).powf(0.75)) as u16
                    }
                    AuBrate::Fixed(b) => b,
                },
                |p| p.brate,
            );
            let mut stream = (*s).clone();
            stream.bitrate = brate;
            TrackJob {
                stream,
                do_norm,
                brate,
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
                        enc_norm(inp, &j.stream, &j.path, samp_ranges, np, j.line)?;
                    } else {
                        enc_direct(inp, &j.stream, j.brate, &j.path, samp_ranges, j.line)?;
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
