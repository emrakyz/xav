use std::{fs::metadata, path::Path, time::Instant};

use crate::{
    dav1d::Dav1dDec,
    enc::probe_path,
    error::fatal,
    ffms::VidDecoder,
    interp::{fc_spline, lerp, pchip},
    pipeline::{MetricProgs, Pipeline},
    vship::VshipProcessor,
    worker::WorkPkg,
};

pub struct ProbeDec {
    dav1d: Option<Dav1dDec>,
    vid: Option<VidDecoder>,
    threads: i32,
    prepare: fn(&mut Self, &WorkPkg, &Path, u16, f32, &str) -> u64,
    frame: fn(&mut Self) -> ([*const u8; 3], [i64; 3]),
}

pub fn make_dav1d(threads: i32) -> ProbeDec {
    ProbeDec {
        dav1d: Some(Dav1dDec::new(threads).unwrap_or_else(|e| fatal(e))),
        vid: None,
        threads,
        prepare: prep_dav1d,
        frame: frame_dav1d,
    }
}

pub fn make_ff(threads: i32) -> ProbeDec {
    ProbeDec {
        dav1d: None,
        vid: None,
        threads,
        prepare: prep_ff,
        frame: frame_ff,
    }
}

fn prep_dav1d(d: &mut ProbeDec, pkg: &WorkPkg, _: &Path, _: u16, _: f32, _: &str) -> u64 {
    unsafe { d.dav1d.as_mut().unwrap_unchecked() }.load(&pkg.probe);
    pkg.probe.len() as u64
}

fn prep_ff(d: &mut ProbeDec, _: &WorkPkg, dir: &Path, idx: u16, crf: f32, ext: &str) -> u64 {
    let pp = probe_path(dir, idx, crf, ext);
    let sz = metadata(&pp).map_or(0, |m| m.len());
    d.vid = Some(VidDecoder::new(&pp, d.threads).unwrap_or_else(|e| fatal(e)));
    sz
}

fn frame_dav1d(d: &mut ProbeDec) -> ([*const u8; 3], [i64; 3]) {
    unsafe { d.dav1d.as_mut().unwrap_unchecked() }.dec_next()
}

fn frame_ff(d: &mut ProbeDec) -> ([*const u8; 3], [i64; 3]) {
    let vid = unsafe { d.vid.as_mut().unwrap_unchecked() };
    let of = unsafe { &*vid.dec_next() };
    (
        [
            of.data[0].cast_const(),
            of.data[1].cast_const(),
            of.data[2].cast_const(),
        ],
        [
            i64::from(of.linesize[0]),
            i64::from(of.linesize[1]),
            i64::from(of.linesize[2]),
        ],
    )
}

impl ProbeDec {
    #[inline]
    pub fn prep(&mut self, pkg: &WorkPkg, dir: &Path, idx: u16, crf: f32, ext: &str) -> u64 {
        let prepare = self.prepare;
        prepare(self, pkg, dir, idx, crf, ext)
    }
}

pub const JOD_A: f32 = 0.043_956_94;
pub const JOD_EXP: f32 = 0.930_204_3;

pub fn inverse_jod(score: f32) -> f32 {
    ((10.0 - score) / JOD_A).powf(1.0 / JOD_EXP)
}

pub fn jod(q: f32) -> f32 {
    JOD_A.mul_add(-q.powf(JOD_EXP), 10.0)
}

#[derive(Clone)]
pub struct Probe {
    pub crf: f32,
    pub score: f32,
    pub frame_scores: Vec<f32>,
}

#[derive(Clone)]
pub struct ProbeLog {
    pub chnk_idx: u16,
    pub probes: Vec<(f32, f32, u64)>,
    pub final_crf: f32,
    pub final_score: f32,
    pub final_sz: u64,
    pub round: u8,
    pub frames: usize,
}

fn round_crf(crf: f32) -> f32 {
    (crf * 4.0).round() / 4.0
}

pub fn interpolate_crf(probes: &[Probe], target: f32, round: u8) -> f32 {
    let mut pairs: Vec<(f32, f32)> = probes.iter().map(|p| (p.score, p.crf)).collect();
    pairs.sort_unstable_by(|a, b| a.0.total_cmp(&b.0));

    let x: Vec<f32> = pairs.iter().map(|p| p.0).collect();
    let y: Vec<f32> = pairs.iter().map(|p| p.1).collect();

    let result = match round {
        3 => lerp(&x, &y, target),
        4 => fc_spline(&x, &y, target),
        _ => pchip(&x, &y, target),
    };

    round_crf(result)
}

macro_rules! calc_metric_impl {
    ($name:ident, $is_10b:expr) => {
        pub fn $name(
            pkg: &WorkPkg,
            dec: &mut ProbeDec,
            pipe: &Pipeline,
            vship: &VshipProcessor,
            metric_mode: &str,
            unpacked_buf: &mut [u8],
            mp: &MetricProgs,
        ) -> (f32, Vec<f32>) {
            let cvvdp_per_frame = pipe.reset_cvvdp && metric_mode.starts_with('p');
            if pipe.reset_cvvdp {
                vship.reset_cvvdp();
            }

            let frame_fn = dec.frame;

            let mut scores = Vec::with_capacity(pkg.frame_cnt);
            let frame_sz = pipe.frame_sz;
            let start = Instant::now();

            let pix_sz = if $is_10b { 2 } else { 1 };
            let y_sz = pipe.final_w * pipe.final_h * pix_sz;
            let uv_sz = y_sz / 4;
            let ys = (pipe.final_w * pix_sz) as i64;
            let cs = (pipe.final_w / 2 * pix_sz) as i64;

            macro_rules! process_frame {
                ($frame_idx: expr) => {{
                    let elapsed = start.elapsed().as_secs_f32().max(0.001);
                    let fps = ($frame_idx + 1) as f32 / elapsed;
                    mp.prog.show_metric_progs(
                        mp.slot,
                        pkg.chnk.idx,
                        ($frame_idx + 1, pkg.frame_cnt),
                        fps,
                        (mp.crf, mp.last_score),
                    );

                    let input_frame = &pkg.yuv[$frame_idx * frame_sz..($frame_idx + 1) * frame_sz];
                    let (output_planes, output_strides) = frame_fn(dec);

                    let input_yuv: &[u8] = if $is_10b {
                        (pipe.unpack)(input_frame, unpacked_buf, pipe);
                        unpacked_buf
                    } else {
                        input_frame
                    };

                    let input_planes = [
                        input_yuv.as_ptr(),
                        input_yuv[y_sz..].as_ptr(),
                        input_yuv[y_sz + uv_sz..].as_ptr(),
                    ];

                    scores.push((pipe.compute_metric)(
                        vship,
                        input_planes,
                        output_planes,
                        [ys, cs, cs],
                        output_strides,
                    ));
                }};
            }

            if cvvdp_per_frame {
                for frame_idx in 0..pkg.frame_cnt {
                    process_frame!(frame_idx);
                    vship.reset_cvvdp_score();
                }
            } else {
                for frame_idx in 0..pkg.frame_cnt {
                    process_frame!(frame_idx);
                }
            }

            let result = aggregate_scores(&mut scores, pipe, metric_mode, cvvdp_per_frame);
            (result, scores)
        }
    };
}

fn aggregate_scores(
    scores: &mut [f32],
    pipe: &Pipeline,
    metric_mode: &str,
    cvvdp_per_frame: bool,
) -> f32 {
    if pipe.reset_cvvdp && !cvvdp_per_frame {
        scores.last().copied().unwrap_or(0.0)
    } else if cvvdp_per_frame {
        let percentile: f32 = unsafe {
            metric_mode
                .strip_prefix('p')
                .and_then(|p| p.parse().ok())
                .unwrap_unchecked()
        };
        let mut q: Vec<f32> = scores.iter().map(|&s| inverse_jod(s)).collect();
        q.sort_unstable_by(|a, b| b.total_cmp(a));
        let cutoff = ((q.len() as f32 * percentile / 100.0).ceil() as usize).min(q.len());
        jod(q[..cutoff].iter().sum::<f32>() / cutoff as f32)
    } else if metric_mode == "mean" {
        scores.iter().sum::<f32>() / scores.len() as f32
    } else if let Some(p) = metric_mode.strip_prefix('p') {
        let percentile: f32 = unsafe { p.parse().unwrap_unchecked() };
        if pipe.sort_descending {
            scores.sort_unstable_by(|a, b| b.total_cmp(a));
        } else {
            scores.sort_unstable_by(f32::total_cmp);
        }
        let cutoff = ((scores.len() as f32 * percentile / 100.0).ceil() as usize).min(scores.len());
        scores[..cutoff].iter().sum::<f32>() / cutoff as f32
    } else {
        scores.iter().sum::<f32>() / scores.len() as f32
    }
}

calc_metric_impl!(calc_metric_8b, false);
calc_metric_impl!(calc_metric_10b, true);
