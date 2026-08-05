use alloc::borrow::Cow;
#[cfg(target_os = "linux")]
use alloc::vec::Vec;
use core::{
    hint::cold_path,
    iter::repeat_with,
    mem::take,
    sync::atomic::{
        AtomicBool, AtomicUsize,
        Ordering::{Acquire, Relaxed, Release},
    },
    time::Duration,
};

#[cfg(all(target_os = "linux", not(test)))]
use crate::fmath::Powf as _;
use crate::{
    audio::{
        AuBrate::{Auto, Fixed, Norm},
        AuStreams::{All, Specific},
    },
    error::Xerr,
    ffms::get_au_streams,
    fs::{File, write},
    io::{BufWriter, Write as _},
    lavf::AuDecoder,
    norm::{downmix, measure},
    opus::{Encoder, FRAME},
    path::{Path, PathBuf},
    progs::{ProgsBar, monitor_au},
    thread::{ScopedJoinHandle, available_parallelism, scope, sleep},
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
    pub lang: Option<Cow<'static, str>>,
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

#[inline]
fn reord_surround(buf: &mut [f32], channels: usize, num_samples: usize) {
    let map: &[usize] = match channels {
        6 => &[0, 2, 1, 4, 5, 3],
        7 => &[0, 2, 1, 5, 6, 4, 3],
        8 => &[0, 2, 1, 6, 7, 4, 5, 3],
        _ => {
            cold_path();
            return;
        }
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

fn enc_stream(
    inp: &Path,
    stream: &AuStream,
    brate: u16,
    np: Option<NormParams>,
    out: &Path,
    samp_ranges: Option<&[(i64, i64)]>,
    progs_line: usize,
) -> Result<(), Xerr> {
    let whole;
    let ranges: &[(i64, i64)] = if let Some(rs) = samp_ranges {
        rs
    } else {
        whole = [(
            0,
            AuDecoder::new(inp, i32::from(stream.index))?.tot_samples(),
        )];
        &whole
    };
    if let Some(np) = np {
        let mut pcm = par_decode(inp, stream, ranges, progs_line)?;
        let (lufs, lra) = measure(&pcm);
        let mut gain = 10f32.powf((np.i - lufs) / 20.0);
        if lra > np.lra {
            gain *= np.lra / lra;
        }
        let tp = 10f32.powf(np.tp / 20.0);
        for s in &mut pcm {
            *s = (*s * gain).clamp(-tp, tp);
        }
        chunk_encode(&mut pcm, 2, brate, out, stream.index, progs_line)
    } else {
        fused_encode(inp, stream, brate, out, ranges, progs_line)
    }
}

fn par_decode(
    inp: &Path,
    stream: &AuStream,
    ranges: &[(i64, i64)],
    progs_line: usize,
) -> Result<Vec<f32>, Xerr> {
    let ch = usize::from(stream.channels);
    let out_ch = 2;
    let tid = stream.index;
    let total: usize = ranges.iter().map(|&(s, e)| (e - s) as usize).sum();
    let nproc = available_parallelism();

    let mut regions: Vec<(i64, i64, bool, bool)> = Vec::new();
    let mut rmeta: Vec<(usize, usize, i64, i64)> = Vec::new();
    let lastr = ranges.len() - 1;
    for (ri, &(rs, re)) in ranges.iter().enumerate() {
        let rstart = regions.len();
        let nr = nproc as i64;
        for c in 0..nr {
            let s0 = rs + (re - rs) * c / nr;
            let s1 = if c == nr - 1 {
                re
            } else {
                rs + (re - rs) * (c + 1) / nr
            };
            regions.push((s0, s1, c == 0, ri == lastr && c == nr - 1));
        }
        rmeta.push((rstart, regions.len() - rstart, rs, re));
    }
    let nreg = regions.len();

    let mut results: Vec<(Vec<f32>, i64)> = vec![(Vec::new(), 0); nreg];
    let base = results.as_mut_ptr() as usize;
    let counter = AtomicUsize::new(0);
    let done = AtomicUsize::new(0);
    let failed = AtomicBool::new(false);
    let nthreads = nproc.min(nreg.max(1));
    let fin = AtomicBool::new(false);

    scope(|s| {
        let mut handles = Vec::with_capacity(nthreads);
        for _ in 0..nthreads {
            handles.push(s.spawn(|| {
                let r = (|| -> Result<(), Xerr> {
                    let mut dec = AuDecoder::new(inp, i32::from(stream.index))?;
                    loop {
                        let u = counter.fetch_add(1, Relaxed);
                        if u >= nreg || failed.load(Relaxed) {
                            break;
                        }
                        let (s0, s1, isf, isl) = regions[u];
                        let mut local: Vec<f32> = Vec::new();
                        let bpos = dec.decode_range(s0, s1, isf, isl, |chnk: &mut [f32]| {
                            let n = chnk.len() / ch;
                            let off = local.len();
                            local.resize(off + n * out_ch, 0.0);
                            downmix(chnk, &mut local[off..], ch, n);
                            Ok(())
                        })?;
                        done.fetch_add(local.len() / out_ch, Relaxed);
                        unsafe { *(base as *mut (Vec<f32>, i64)).add(u) = (local, bpos) };
                    }
                    Ok(())
                })();
                if r.is_err() {
                    failed.store(true, Relaxed);
                }
                r
            }));
        }
        let mon = s.spawn(|| monitor_au(&done, &fin, total, progs_line, 1, tid));
        let res = handles.into_iter().try_for_each(ScopedJoinHandle::join);
        fin.store(true, Relaxed);
        mon.thread().unpark();
        res
    })?;

    let mut pcm: Vec<f32> = Vec::with_capacity(total * out_ch);
    for &(rstart, rcount, rs, re) in &rmeta {
        let target = pcm.len() + (re - rs) as usize * out_ch;
        for (i, slot) in results[rstart..rstart + rcount].iter_mut().enumerate() {
            if pcm.len() >= target {
                break;
            }
            let (r, bpos) = take(slot);
            let drop = if i == 0 {
                ((rs - bpos).max(0) as usize) * out_ch
            } else {
                0
            };
            let from = drop.min(r.len());
            let need = target - pcm.len();
            pcm.extend_from_slice(&r[from..][..need.min(r.len() - from)]);
        }
        pcm.resize(target, 0.0);
    }
    Ok(pcm)
}

const UNIT_SAMPLES: usize = 480_000;

fn fused_encode(
    inp: &Path,
    stream: &AuStream,
    brate: u16,
    out: &Path,
    ranges: &[(i64, i64)],
    progs_line: usize,
) -> Result<(), Xerr> {
    let ch = usize::from(stream.channels);
    let tid = stream.index;
    let total: usize = ranges.iter().map(|&(s, e)| (e - s) as usize).sum();
    let nproc = available_parallelism();

    let mut units: Vec<(i64, i64, bool, usize)> = Vec::new();
    for &(rs, re) in ranges {
        let rl = (re - rs) as usize;
        let nu = rl.div_ceil(UNIT_SAMPLES).max(1);
        for c in 0..nu {
            let ts = rs + (c * UNIT_SAMPLES) as i64;
            let last = c == nu - 1;
            let te = if last {
                re
            } else {
                rs + ((c + 1) * UNIT_SAMPLES) as i64
            };
            units.push((ts, te, last, if c == 0 { rl } else { 0 }));
        }
    }
    let nunits = units.len();

    let mut results: Vec<(Vec<f32>, usize)> = vec![(Vec::new(), 0); nunits];
    let base = results.as_mut_ptr() as usize;
    let ready: Vec<AtomicBool> = repeat_with(|| AtomicBool::new(false))
        .take(nunits)
        .collect();
    let counter = AtomicUsize::new(0);
    let consumed = AtomicUsize::new(0);
    let failed = AtomicBool::new(false);

    let mut w = BufWriter::new(File::create(out)?);

    scope(|s| -> Result<(), Xerr> {
        let mut handles = Vec::with_capacity(nproc);
        for _ in 0..nproc.min(nunits.max(1)) {
            handles.push(s.spawn(|| {
                let r = (|| -> Result<(), Xerr> {
                    let mut dec = AuDecoder::new(inp, i32::from(stream.index))?;
                    loop {
                        let u = counter.fetch_add(1, Relaxed);
                        if u >= nunits || failed.load(Relaxed) {
                            break;
                        }
                        while u >= consumed.load(Relaxed) + nproc {
                            if failed.load(Relaxed) {
                                return Ok(());
                            }
                            sleep(Duration::from_micros(100));
                        }
                        let (ts, te, last, rl) = units[u];
                        let mut pcm: Vec<f32> = Vec::new();
                        let bpos =
                            dec.decode_range(ts, te, rl > 0, last, |chnk: &mut [f32]| {
                                let n = chnk.len() / ch;
                                if ch > 2 {
                                    reord_surround(chnk, ch, n);
                                }
                                pcm.extend_from_slice(chnk);
                                Ok(())
                            })?;
                        let drop_front = if rl > 0 {
                            (ts - bpos).max(0) as usize
                        } else {
                            0
                        };
                        unsafe { *(base as *mut (Vec<f32>, usize)).add(u) = (pcm, drop_front) };
                        ready[u].store(true, Release);
                    }
                    Ok(())
                })();
                if r.is_err() {
                    failed.store(true, Relaxed);
                }
                r
            }));
        }

        let mut buf: Vec<f32> = Vec::new();
        let mut enc_off = 0usize;
        let mut remaining = 0usize;
        let mut done = 0usize;
        let mut first = true;
        let mut progs = ProgsBar::new();
        let seg = nproc * CHUNK_FRAMES;
        let enc_res = (|| -> Result<(), Xerr> {
            for u in 0..nunits {
                while !ready[u].load(Acquire) {
                    if failed.load(Relaxed) {
                        return Ok(());
                    }
                    sleep(Duration::from_micros(100));
                }
                let (pcm, drop_front) =
                    take(unsafe { &mut *(base as *mut (Vec<f32>, usize)).add(u) });
                if units[u].3 > 0 {
                    remaining = units[u].3;
                }
                let emit = (pcm.len() / ch - drop_front).min(remaining);
                buf.extend_from_slice(&pcm[drop_front * ch..(drop_front + emit) * ch]);
                remaining -= emit;
                done += emit;
                consumed.store(u + 1, Relaxed);
                while buf.len() / (ch * FRAME) >= enc_off + seg + POSTROLL {
                    w.write_all(&par_encode_seg(&buf, enc_off, seg, ch, brate, first)?)?;
                    first = false;
                    buf.drain(..(enc_off + seg - PREROLL) * FRAME * ch);
                    enc_off = PREROLL;
                    progs.up_au(done.min(total), total, progs_line, 2, tid);
                }
            }
            let bframes = buf.len().div_ceil(ch * FRAME);
            if bframes > enc_off {
                buf.resize(bframes * FRAME * ch, 0.0);
                w.write_all(&par_encode_seg(
                    &buf,
                    enc_off,
                    bframes - enc_off,
                    ch,
                    brate,
                    first,
                )?)?;
            }
            w.flush()?;
            progs.up_au(total, total, progs_line, 2, tid);
            Ok(())
        })();
        if enc_res.is_err() {
            failed.store(true, Relaxed);
        }
        handles.into_iter().try_for_each(ScopedJoinHandle::join)?;
        enc_res
    })
}

const CHUNK_FRAMES: usize = 500;
const PREROLL: usize = 25;
const POSTROLL: usize = 2;

fn chunk_encode(
    pcm: &mut Vec<f32>,
    out_ch: usize,
    brate: u16,
    out: &Path,
    tid: u8,
    progs_line: usize,
) -> Result<(), Xerr> {
    let nframes = (pcm.len() / out_ch).div_ceil(FRAME);
    let stride = FRAME * out_ch;
    pcm.resize(nframes * stride, 0.0);
    let pcm = &*pcm;
    let k = nframes.div_ceil(CHUNK_FRAMES).max(1);
    let mut results: Vec<Vec<u8>> = vec![Vec::new(); k];
    let base = results.as_mut_ptr() as usize;
    let counter = AtomicUsize::new(0);
    let done = AtomicUsize::new(0);
    let failed = AtomicBool::new(false);
    let fin = AtomicBool::new(false);
    let samples = nframes * FRAME;
    let nthreads = available_parallelism().min(k);
    let seg = Seg {
        keep_off: 0,
        nkeep: nframes,
        out_ch,
        brate,
        head: true,
    };

    scope(|s| {
        let mut handles = Vec::with_capacity(nthreads);
        for _ in 0..nthreads {
            handles.push(s.spawn(|| {
                let mut pkt = vec![0u8; out_ch * 1276 + 256];
                loop {
                    let c = counter.fetch_add(1, Relaxed);
                    if c >= k || failed.load(Relaxed) {
                        break;
                    }
                    match encode_chunk(pcm, c, &seg, &mut pkt) {
                        Ok(bytes) => unsafe { *(base as *mut Vec<u8>).add(c) = bytes },
                        Err(e) => {
                            failed.store(true, Relaxed);
                            return Err(e);
                        }
                    }
                    done.fetch_add(CHUNK_FRAMES * FRAME, Relaxed);
                }
                Ok::<(), Xerr>(())
            }));
        }
        let mon = s.spawn(|| monitor_au(&done, &fin, samples, progs_line, 2, tid));
        let res = handles.into_iter().try_for_each(ScopedJoinHandle::join);
        fin.store(true, Relaxed);
        mon.thread().unpark();
        res
    })?;

    let mut file: Vec<u8> = Vec::with_capacity(results.iter().map(Vec::len).sum());
    for r in &results {
        file.extend_from_slice(r);
    }
    write(out, file)?;
    Ok(())
}

struct Seg {
    keep_off: usize,
    nkeep: usize,
    out_ch: usize,
    brate: u16,
    head: bool,
}

fn encode_chunk(pcm: &[f32], c: usize, seg: &Seg, pkt: &mut [u8]) -> Result<Vec<u8>, Xerr> {
    let stride = FRAME * seg.out_ch;
    let total = pcm.len() / stride;
    let keep_start = seg.keep_off + c * CHUNK_FRAMES;
    let keep_end = (seg.keep_off + (c + 1) * CHUNK_FRAMES).min(seg.keep_off + seg.nkeep);
    let fed_start = keep_start.saturating_sub(PREROLL);
    let fed_end = (keep_end + POSTROLL).min(total);
    let mut enc = Encoder::new(seg.out_ch as u8, seg.brate)?;
    let mut out = Vec::with_capacity((keep_end - keep_start) * (seg.brate as usize * 3));
    if seg.head && c == 0 {
        let h = enc.head();
        out.extend_from_slice(&(h.len() as u16).to_le_bytes());
        out.extend_from_slice(&h);
    }
    for f in fed_start..keep_start {
        enc.encode(
            unsafe { pcm.get_unchecked(f * stride..f * stride + stride) },
            pkt,
        )?;
    }
    for f in keep_start..keep_end {
        let len = enc.encode(
            unsafe { pcm.get_unchecked(f * stride..f * stride + stride) },
            pkt,
        )?;
        out.extend_from_slice(&(len as u16).to_le_bytes());
        out.extend_from_slice(&pkt[..len]);
    }
    for f in keep_end..fed_end {
        enc.encode(
            unsafe { pcm.get_unchecked(f * stride..f * stride + stride) },
            pkt,
        )?;
    }
    Ok(out)
}

fn par_encode_seg(
    buf: &[f32],
    keep_off: usize,
    nkeep: usize,
    out_ch: usize,
    brate: u16,
    head: bool,
) -> Result<Vec<u8>, Xerr> {
    let k = nkeep.div_ceil(CHUNK_FRAMES).max(1);
    let mut results: Vec<Vec<u8>> = vec![Vec::new(); k];
    let base = results.as_mut_ptr() as usize;
    let counter = AtomicUsize::new(0);
    let failed = AtomicBool::new(false);
    let nthreads = available_parallelism().min(k);
    let seg = Seg {
        keep_off,
        nkeep,
        out_ch,
        brate,
        head,
    };

    scope(|s| {
        let mut handles = Vec::with_capacity(nthreads);
        for _ in 0..nthreads {
            handles.push(s.spawn(|| {
                let mut pkt = vec![0u8; out_ch * 1276 + 256];
                loop {
                    let c = counter.fetch_add(1, Relaxed);
                    if c >= k || failed.load(Relaxed) {
                        break;
                    }
                    match encode_chunk(buf, c, &seg, &mut pkt) {
                        Ok(bytes) => unsafe { *(base as *mut Vec<u8>).add(c) = bytes },
                        Err(e) => {
                            failed.store(true, Relaxed);
                            return Err(e);
                        }
                    }
                }
                Ok::<(), Xerr>(())
            }));
        }
        handles.into_iter().try_for_each(ScopedJoinHandle::join)
    })?;

    let mut out = Vec::with_capacity(results.iter().map(Vec::len).sum());
    for r in &results {
        out.extend_from_slice(r);
    }
    Ok(out)
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

    jobs.iter()
        .map(|j| {
            enc_stream(
                inp,
                &j.stream,
                j.brate,
                norm_params.filter(|_| j.do_norm),
                &j.path,
                samp_ranges,
                j.line,
            )?;
            Ok((j.stream.clone(), j.path.clone()))
        })
        .collect()
}
