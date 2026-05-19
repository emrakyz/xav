use std::{path::Path, thread::available_parallelism, time::Instant};

use crate::{
    error::fatal,
    ffms::VideoDecoder,
    interp::{fritsch_carlson, lerp, pchip},
    pipeline::{MetricsProgress, Pipeline},
    vship::VshipProcessor,
    worker::WorkPkg,
};

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
    pub chunk_idx: u16,
    pub probes: Vec<(f32, f32, u64)>,
    pub final_crf: f32,
    pub final_score: f32,
    pub final_size: u64,
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
        4 => fritsch_carlson(&x, &y, target),
        _ => pchip(&x, &y, target),
    };

    round_crf(result)
}

macro_rules! calc_metrics_impl {
    ($name:ident, $is_10b:expr) => {
        pub fn $name(
            pkg: &WorkPkg,
            probe_path: &Path,
            pipe: &Pipeline,
            vship: &VshipProcessor,
            metric_mode: &str,
            unpacked_buf: &mut [u8],
            mp: &MetricsProgress,
        ) -> (f32, Vec<f32>) {
            let cvvdp_per_frame = pipe.reset_cvvdp && metric_mode.starts_with('p');
            if pipe.reset_cvvdp {
                vship.reset_cvvdp();
            }

            let threads = unsafe { available_parallelism().unwrap_unchecked().get() as i32 };
            let mut dec = VideoDecoder::new(probe_path, threads).unwrap_or_else(|e| fatal(e));

            let mut scores = Vec::with_capacity(pkg.frame_count);
            let frame_size = pipe.frame_size;
            let start = Instant::now();

            let pixel_size = if $is_10b { 2 } else { 1 };
            let y_size = pipe.final_w * pipe.final_h * pixel_size;
            let uv_size = y_size / 4;
            let ys = i64::try_from(pipe.final_w * pixel_size).unwrap_or(0);
            let cs = i64::try_from(pipe.final_w / 2 * pixel_size).unwrap_or(0);

            macro_rules! process_frame {
                ($frame_idx: expr) => {{
                    let elapsed = start.elapsed().as_secs_f32().max(0.001);
                    let fps = ($frame_idx + 1) as f32 / elapsed;
                    mp.prog.show_metric_progress(
                        mp.slot,
                        pkg.chunk.idx,
                        ($frame_idx + 1, pkg.frame_count),
                        fps,
                        (mp.crf, mp.last_score),
                    );

                    let input_frame =
                        &pkg.yuv[$frame_idx * frame_size..($frame_idx + 1) * frame_size];
                    let of = dec.decode_next();

                    let input_yuv: &[u8] = if $is_10b {
                        (pipe.unpack)(input_frame, unpacked_buf, pipe);
                        unpacked_buf
                    } else {
                        input_frame
                    };

                    let input_planes = [
                        input_yuv.as_ptr(),
                        input_yuv[y_size..].as_ptr(),
                        input_yuv[y_size + uv_size..].as_ptr(),
                    ];

                    let of = unsafe { &*of };
                    let output_planes = [
                        of.data[0].cast_const(),
                        of.data[1].cast_const(),
                        of.data[2].cast_const(),
                    ];
                    let output_strides = [
                        i64::from(of.linesize[0]),
                        i64::from(of.linesize[1]),
                        i64::from(of.linesize[2]),
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
                for frame_idx in 0..pkg.frame_count {
                    process_frame!(frame_idx);
                    vship.reset_cvvdp_score();
                }
            } else {
                for frame_idx in 0..pkg.frame_count {
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
        let percentile: f32 = metric_mode
            .strip_prefix('p')
            .and_then(|p| p.parse().ok())
            .unwrap_or(15.0);
        let mut q: Vec<f32> = scores.iter().map(|&s| inverse_jod(s)).collect();
        q.sort_unstable_by(|a, b| b.total_cmp(a));
        let cutoff = ((q.len() as f32 * percentile / 100.0).ceil() as usize).min(q.len());
        jod(q[..cutoff].iter().sum::<f32>() / cutoff as f32)
    } else if metric_mode == "mean" {
        scores.iter().sum::<f32>() / scores.len() as f32
    } else if let Some(p) = metric_mode.strip_prefix('p') {
        let percentile: f32 = p.parse().unwrap_or(15.0);
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

calc_metrics_impl!(calc_metrics_8b, false);
calc_metrics_impl!(calc_metrics_10b, true);
