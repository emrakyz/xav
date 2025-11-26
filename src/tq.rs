use std::path::Path;

use crate::interp::{akima, lerp, natural_cubic, pchip};

#[derive(Clone)]
pub struct Probe {
    pub crf: f64,
    pub score: f64,
    pub frame_scores: Vec<f64>,
}

#[derive(Clone)]
pub struct ProbeLog {
    pub chunk_idx: usize,
    pub probes: Vec<(f64, f64)>,
    pub final_crf: f64,
    pub final_score: f64,
    pub round: usize,
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

    let n = sorted.len();
    let x: Vec<f64> = sorted.iter().map(|p| p.score).collect();
    let y: Vec<f64> = sorted.iter().map(|p| p.crf).collect();

    let result = match round {
        3 if n >= 2 => lerp(&[x[0], x[1]], &[y[0], y[1]], target),
        4 if n >= 3 => natural_cubic(&x, &y, target),
        5 if n >= 4 => pchip(&[x[0], x[1], x[2], x[3]], &[y[0], y[1], y[2], y[3]], target),
        6 if n >= 5 => {
            akima(&[x[0], x[1], x[2], x[3], x[4]], &[y[0], y[1], y[2], y[3], y[4]], target)
        }
        _ => None,
    };

    result.map(round_crf)
}

pub fn calc_metrics(
    pkg: &crate::worker::WorkPkg,
    probe_path: &Path,
    inf: &crate::ffms::VidInf,
    vship: &crate::vship::VshipProcessor,
    metric_mode: &str,
    use_cvvdp: bool,
    use_butteraugli: bool,
    mut unpacked_buf: Option<&mut Vec<u8>>,
    prog: Option<&std::sync::Arc<crate::progs::ProgsTrack>>,
    worker_id: usize,
    crf: f32,
    last_score: Option<f64>,
) -> (f64, Vec<f64>) {
    if use_cvvdp {
        vship.reset_cvvdp().unwrap();
    }

    let idx = crate::ffms::VidIdx::new(probe_path, true).unwrap();
    let threads =
        std::thread::available_parallelism().map_or(8, |n| n.get().try_into().unwrap_or(8));
    let src = crate::ffms::thr_vid_src(&idx, threads).unwrap();

    let mut scores = Vec::with_capacity(pkg.frame_count);
    let frame_size = pkg.yuv.len() / pkg.frame_count;

    let mut working_inf = inf.clone();
    working_inf.width = pkg.width;
    working_inf.height = pkg.height;

    let start = std::time::Instant::now();

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

        let input_yuv: &[u8] = if inf.is_10bit {
            let buf = unpacked_buf.as_mut().unwrap();
            crate::ffms::unpack_10bit(input_frame, buf);
            buf
        } else {
            input_frame
        };

        let pixel_size = if working_inf.is_10bit { 2 } else { 1 };
        let y_size = (working_inf.width * working_inf.height) as usize * pixel_size;
        let uv_size = y_size / 4;

        let input_planes = [
            input_yuv.as_ptr(),
            input_yuv[y_size..].as_ptr(),
            input_yuv[y_size + uv_size..].as_ptr(),
        ];
        let input_strides = [
            i64::from(working_inf.width * pixel_size as u32),
            i64::from(working_inf.width / 2 * pixel_size as u32),
            i64::from(working_inf.width / 2 * pixel_size as u32),
        ];

        let output_planes =
            unsafe { [(*output_frame).data[0], (*output_frame).data[1], (*output_frame).data[2]] };
        let output_strides = unsafe {
            [
                i64::from((*output_frame).linesize[0]),
                i64::from((*output_frame).linesize[1]),
                i64::from((*output_frame).linesize[2]),
            ]
        };

        let score = if use_butteraugli {
            vship
                .compute_butteraugli(input_planes, output_planes, input_strides, output_strides)
                .unwrap()
        } else if use_cvvdp {
            vship.compute_cvvdp(input_planes, output_planes, input_strides, output_strides).unwrap()
        } else {
            vship
                .compute_ssimulacra2(input_planes, output_planes, input_strides, output_strides)
                .unwrap()
        };
        scores.push(score);
    }

    crate::ffms::destroy_vid_src(src);

    let result = if use_cvvdp {
        scores.last().copied().unwrap_or(0.0)
    } else if metric_mode == "mean" {
        scores.iter().sum::<f64>() / scores.len() as f64
    } else if let Some(p) = metric_mode.strip_prefix('p') {
        let percentile: f64 = p.parse().unwrap_or(15.0);
        if use_butteraugli {
            scores.sort_unstable_by(|a, b| b.partial_cmp(a).unwrap());
        } else {
            scores.sort_unstable_by(|a, b| a.partial_cmp(b).unwrap());
        }
        let cutoff = ((scores.len() as f64 * percentile / 100.0).ceil() as usize).min(scores.len());
        scores[..cutoff].iter().sum::<f64>() / cutoff as f64
    } else {
        scores.iter().sum::<f64>() / scores.len() as f64
    };

    (result, scores)
}
