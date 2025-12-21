use crate::interp::{akima, fritsch_carlson, lerp, pchip};

#[derive(Clone)]
pub struct Probe {
    pub crf: f64,
    pub score: f64,
    pub frame_scores: Vec<f64>,
}

#[derive(Clone)]
pub struct ProbeLog {
    pub chunk_idx: usize,
    pub probes: Vec<(f64, f64, u64)>,
    pub final_crf: f64,
    pub final_score: f64,
    pub final_size: u64,
    pub round: usize,
    pub frames: usize,
}

fn round_crf(crf: f64) -> f64 {
    (crf * 4.0).round() / 4.0
}

pub fn binary_search(min: f64, max: f64) -> f64 {
    round_crf(f64::midpoint(min, max))
}

pub fn interpolate_crf(probes: &[Probe], target: f64, round: usize) -> Option<f64> {
    let mut sorted = probes.to_vec();
    sorted.sort_unstable_by(|a, b| a.score.partial_cmp(&b.score).unwrap());

    let x: Vec<f64> = sorted.iter().map(|p| p.score).collect();
    let y: Vec<f64> = sorted.iter().map(|p| p.crf).collect();

    let result = match round {
        1 | 2 => None,
        3 => lerp(&[x[0], x[1]], &[y[0], y[1]], target),
        4 => fritsch_carlson(&x, &y, target),
        5 => pchip(&[x[0], x[1], x[2], x[3]], &[y[0], y[1], y[2], y[3]], target),
        _ => akima(&x, &y, target),
    };

    result.map(round_crf)
}

macro_rules! calc_metrics_impl {
    ($name:ident, $is_10bit:expr) => {
        pub fn $name(
            pkg: &crate::worker::WorkPkg,
            probe_path: &std::path::Path,
            _inf: &crate::ffms::VidInf,
            pipe: &crate::pipeline::Pipeline,
            vship: &crate::vship::VshipProcessor,
            metric_mode: &str,
            unpacked_buf: &mut [u8],
            prog: Option<&std::sync::Arc<crate::progs::ProgsTrack>>,
            worker_id: usize,
            crf: f32,
            last_score: Option<f64>,
        ) -> (f64, Vec<f64>) {
            if pipe.reset_cvvdp {
                vship.reset_cvvdp();
            }

            let idx = crate::ffms::VidIdx::new(probe_path, true).unwrap();
            let threads =
                std::thread::available_parallelism().map_or(8, |n| n.get().try_into().unwrap_or(8));
            let src = crate::ffms::thr_vid_src(&idx, threads).unwrap();

            let mut scores = Vec::with_capacity(pkg.frame_count);
            let frame_size = pipe.frame_size;
            let start = std::time::Instant::now();

            let pixel_size = if $is_10bit { 2 } else { 1 };
            let y_size = pipe.final_w * pipe.final_h * pixel_size;
            let uv_size = y_size / 4;

            for frame_idx in 0..pkg.frame_count {
                if let Some(p) = prog {
                    let elapsed = start.elapsed().as_secs_f32().max(0.001);
                    let fps = (frame_idx + 1) as f32 / elapsed;
                    p.show_metric_progress(
                        worker_id,
                        pkg.chunk.idx,
                        (frame_idx + 1, pkg.frame_count),
                        fps,
                        (crf, last_score),
                    );
                }

                let input_frame = &pkg.yuv[frame_idx * frame_size..(frame_idx + 1) * frame_size];
                let output_frame = crate::ffms::get_frame(src, frame_idx).unwrap();

                let input_yuv: &[u8] = if $is_10bit {
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
                let input_strides = [
                    i64::try_from(pipe.final_w * pixel_size).unwrap(),
                    i64::try_from(pipe.final_w / 2 * pixel_size).unwrap(),
                    i64::try_from(pipe.final_w / 2 * pixel_size).unwrap(),
                ];

                let output_planes = unsafe {
                    [(*output_frame).Data[0], (*output_frame).Data[1], (*output_frame).Data[2]]
                };
                let output_strides = unsafe {
                    [
                        i64::from((*output_frame).Linesize[0]),
                        i64::from((*output_frame).Linesize[1]),
                        i64::from((*output_frame).Linesize[2]),
                    ]
                };

                let score = (pipe.compute_metric)(
                    vship,
                    input_planes,
                    output_planes,
                    input_strides,
                    output_strides,
                );
                scores.push(score);
            }

            crate::ffms::destroy_vid_src(src);

            let result = if pipe.reset_cvvdp {
                scores.last().copied().unwrap_or(0.0)
            } else if metric_mode == "mean" {
                scores.iter().sum::<f64>() / scores.len() as f64
            } else if let Some(p) = metric_mode.strip_prefix('p') {
                let percentile: f64 = p.parse().unwrap_or(15.0);
                if pipe.sort_descending {
                    scores.sort_unstable_by(|a, b| b.partial_cmp(a).unwrap());
                } else {
                    scores.sort_unstable_by(|a, b| a.partial_cmp(b).unwrap());
                }
                let cutoff =
                    ((scores.len() as f64 * percentile / 100.0).ceil() as usize).min(scores.len());
                scores[..cutoff].iter().sum::<f64>() / cutoff as f64
            } else {
                scores.iter().sum::<f64>() / scores.len() as f64
            };

            (result, scores)
        }
    };
}

calc_metrics_impl!(calc_metrics_8bit, false);
calc_metrics_impl!(calc_metrics_10bit, true);
