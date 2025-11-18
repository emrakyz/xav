use std::path::Path;
use std::sync::Arc;

use crate::chunk::Chunk;
use crate::ffms::VidInf;
use crate::interp::{akima, lerp, natural_cubic, pchip};

pub type ProbeInfoMap = Arc<std::sync::Mutex<std::collections::HashMap<usize, (f32, Option<f64>)>>>;

#[derive(Clone)]
struct Probe {
    crf: f64,
    score: f64,
    frame_scores: Vec<f64>,
}

#[derive(Clone)]
pub struct ProbeLog {
    pub chunk_idx: usize,
    pub probes: Vec<(f64, f64)>,
    pub final_crf: f64,
    pub final_score: f64,
    pub round: usize,
}

pub type ProbeLogger = Arc<std::sync::Mutex<Vec<ProbeLog>>>;

struct TQConfig {
    target: f64,
    tolerance: f64,
    min_crf: f64,
    max_crf: f64,
}

impl TQConfig {
    fn new(tq_range: &str, qp_range: &str) -> Self {
        let tq_parts: Vec<f64> = tq_range.split('-').filter_map(|s| s.parse().ok()).collect();
        let qp_parts: Vec<f64> = qp_range.split('-').filter_map(|s| s.parse().ok()).collect();

        let target = f64::midpoint(tq_parts[0], tq_parts[1]);
        let tolerance = (tq_parts[1] - tq_parts[0]) / 2.0;

        Self { target, tolerance, min_crf: qp_parts[0], max_crf: qp_parts[1] }
    }

    fn in_range(&self, score: f64) -> bool {
        (score - self.target).abs() <= self.tolerance
    }

    fn in_range_reversed(&self, score: f64) -> bool {
        (self.target - score).abs() <= self.tolerance
    }
}

pub struct QualityContext<'a> {
    pub chunk: &'a Chunk,
    pub yuv_frames: &'a [u8],
    pub frame_count: usize,
    pub inf: &'a VidInf,
    pub params: &'a str,
    pub work_dir: &'a Path,
    pub prog: Option<&'a Arc<crate::progs::ProgsTrack>>,
    pub vship: &'a crate::vship::VshipProcessor,
    pub grain_table: Option<&'a Path>,
    pub use_cvvdp: bool,
    pub use_butteraugli: bool,
}

fn round_crf(crf: f64) -> f64 {
    (crf * 4.0).round() / 4.0
}

fn binary_search(min: f64, max: f64) -> f64 {
    round_crf(f64::midpoint(min, max))
}

fn encode_probe(ctx: &QualityContext, crf: f64, last_score: Option<f64>) -> String {
    let probe_name = format!("{:04}_{:.2}.ivf", ctx.chunk.idx, crf);
    crate::svt::encode_single_probe(
        &crate::svt::ProbeConfig {
            yuv_frames: ctx.yuv_frames,
            frame_count: ctx.frame_count,
            inf: ctx.inf,
            params: ctx.params,
            crf: crf as f32,
            probe_name: &probe_name,
            work_dir: ctx.work_dir,
            idx: ctx.chunk.idx,
            crf_score: Some((crf as f32, last_score)),
            grain_table: ctx.grain_table,
        },
        ctx.prog,
    );
    probe_name
}

fn measure_quality(
    ctx: &mut QualityContext,
    probe_path: &Path,
    crf: f32,
    last_score: Option<f64>,
    metric_mode: &str,
) -> (f64, Vec<f64>) {
    if ctx.use_cvvdp {
        ctx.vship.reset_cvvdp().unwrap();
    }

    let idx = crate::ffms::VidIdx::new(probe_path, true).unwrap();
    let threads =
        std::thread::available_parallelism().map_or(8, |n| n.get().try_into().unwrap_or(8));
    let output_source = crate::ffms::thr_vid_src(&idx, threads).unwrap();

    let mut scores = Vec::with_capacity(ctx.frame_count);

    let start = std::time::Instant::now();
    let frame_size = ctx.yuv_frames.len() / ctx.frame_count;
    let tot = ctx.frame_count;

    let mut unpacked_buf = vec![0u8; crate::ffms::calc_10bit_size(ctx.inf)];

    for frame_idx in 0..ctx.frame_count {
        let frame_start = frame_idx * frame_size;
        let frame_end = frame_start + frame_size;
        let input_yuv_packed = &ctx.yuv_frames[frame_start..frame_end];
        let output_frame = crate::ffms::get_frame(output_source, frame_idx).unwrap();

        let input_yuv: &[u8] = if ctx.inf.is_10bit {
            crate::ffms::unpack_10bit(input_yuv_packed, &mut unpacked_buf);
            &unpacked_buf
        } else {
            input_yuv_packed
        };

        let pixel_size = if ctx.inf.is_10bit { 2 } else { 1 };
        let y_size = (ctx.inf.width * ctx.inf.height) as usize * pixel_size;
        let uv_size = y_size / 4;

        let input_y_stride = i64::from(ctx.inf.width * pixel_size as u32);
        let input_uv_stride = i64::from(ctx.inf.width / 2 * pixel_size as u32);

        let input_planes = [
            input_yuv.as_ptr(),
            input_yuv[y_size..].as_ptr(),
            input_yuv[y_size + uv_size..].as_ptr(),
        ];
        let input_line_sizes = [input_y_stride, input_uv_stride, input_uv_stride];

        let output_planes =
            unsafe { [(*output_frame).data[0], (*output_frame).data[1], (*output_frame).data[2]] };
        let output_line_sizes = unsafe {
            [
                i64::from((*output_frame).linesize[0]),
                i64::from((*output_frame).linesize[1]),
                i64::from((*output_frame).linesize[2]),
            ]
        };

        let score = if ctx.use_butteraugli {
            ctx.vship
                .compute_butteraugli(
                    input_planes,
                    output_planes,
                    input_line_sizes,
                    output_line_sizes,
                )
                .unwrap()
        } else if ctx.use_cvvdp {
            ctx.vship
                .compute_cvvdp(input_planes, output_planes, input_line_sizes, output_line_sizes)
                .unwrap()
        } else {
            ctx.vship
                .compute_ssimulacra2(
                    input_planes,
                    output_planes,
                    input_line_sizes,
                    output_line_sizes,
                )
                .unwrap()
        };
        scores.push(score);

        if let Some(p) = ctx.prog {
            let elapsed = start.elapsed().as_secs_f32().max(0.001);
            let fps = (frame_idx + 1) as f32 / elapsed;
            p.show_metric(ctx.chunk.idx, frame_idx + 1, tot, fps, crf, last_score);
        }
    }

    crate::ffms::destroy_vid_src(output_source);

    let result = if ctx.use_cvvdp {
        scores.last().copied().unwrap_or(0.0)
    } else if metric_mode == "mean" {
        scores.iter().sum::<f64>() / scores.len() as f64
    } else if let Some(percentile_str) = metric_mode.strip_prefix('p') {
        let percentile: f64 = percentile_str.parse().unwrap_or(15.0);
        if ctx.use_butteraugli {
            scores.sort_unstable_by(|a, b| b.partial_cmp(a).unwrap());
        } else {
            scores.sort_unstable_by(|a, b| a.partial_cmp(b).unwrap());
        }
        let cutoff_idx =
            ((scores.len() as f64 * percentile / 100.0).ceil() as usize).min(scores.len());
        scores[..cutoff_idx].iter().sum::<f64>() / cutoff_idx as f64
    } else {
        scores.iter().sum::<f64>() / scores.len() as f64
    };
    (result, scores)
}

fn interpolate_crf(probes: &[Probe], target: f64, round: usize) -> Option<f64> {
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

fn log_probe(
    logger: Option<&ProbeLogger>,
    log_path: Option<&Path>,
    work_dir: Option<&Path>,
    probe_log: ProbeLog,
) {
    if let (Some(log), Some(lp), Some(wd)) = (logger, log_path, work_dir) {
        crate::svt::write_chunk_log(&probe_log, lp, wd);
        log.lock().unwrap().push(probe_log);
    }
}

pub fn find_target_quality(
    ctx: &mut QualityContext,
    tq_range: &str,
    qp_range: &str,
    probe_info: &ProbeInfoMap,
    metric_mode: &str,
    logger: Option<&ProbeLogger>,
    log_path: Option<&Path>,
    work_dir: Option<&Path>,
) -> Option<String> {
    let config = TQConfig::new(tq_range, qp_range);
    let mut probes = Vec::new();
    let mut search_min = config.min_crf;
    let mut search_max = config.max_crf;

    for round in 1..=10 {
        let crf = if round <= 2 || round > 6 {
            binary_search(search_min, search_max)
        } else {
            interpolate_crf(&probes, config.target, round)
                .unwrap_or_else(|| binary_search(search_min, search_max))
        }
        .clamp(search_min, search_max);

        let last_score_val = probes.last().map(|p| p.score);
        let probe_name = encode_probe(ctx, crf, last_score_val);
        let probe_path = ctx.work_dir.join("split").join(&probe_name);

        let (score, frame_scores) =
            measure_quality(ctx, &probe_path, crf as f32, last_score_val, metric_mode);

        {
            let mut info = probe_info.lock().unwrap();
            info.insert(ctx.chunk.idx, (crf as f32, Some(score)));
        }

        probes.push(Probe { crf, score, frame_scores });

        let in_range = if ctx.use_butteraugli {
            config.in_range_reversed(score)
        } else {
            config.in_range(score)
        };

        if in_range {
            log_probe(
                logger,
                log_path,
                work_dir,
                ProbeLog {
                    chunk_idx: ctx.chunk.idx,
                    probes: probes.iter().map(|p| (p.crf, p.score)).collect(),
                    final_crf: crf,
                    final_score: score,
                    round,
                },
            );

            if ctx.use_cvvdp {
                crate::svt::TQ_SCORES
                    .get_or_init(|| std::sync::Mutex::new(Vec::new()))
                    .lock()
                    .unwrap()
                    .push(score);
            } else {
                crate::svt::TQ_SCORES
                    .get_or_init(|| std::sync::Mutex::new(Vec::new()))
                    .lock()
                    .unwrap()
                    .extend_from_slice(&probes.last().unwrap().frame_scores);
            }
            return Some(probe_name);
        }

        if ctx.use_butteraugli {
            if score > config.target + config.tolerance {
                search_max = crf - 0.25;
            } else if score < config.target - config.tolerance {
                search_min = crf + 0.25;
            }
        } else if score < config.target - config.tolerance {
            search_max = crf - 0.25;
        } else if score > config.target + config.tolerance {
            search_min = crf + 0.25;
        }

        if search_min > search_max {
            break;
        }
    }

    probes.sort_unstable_by(|a, b| {
        let diff_a = (a.score - config.target).abs();
        let diff_b = (b.score - config.target).abs();
        diff_a.partial_cmp(&diff_b).unwrap()
    });

    log_probe(
        logger,
        log_path,
        work_dir,
        ProbeLog {
            chunk_idx: ctx.chunk.idx,
            probes: probes.iter().map(|p| (p.crf, p.score)).collect(),
            final_crf: probes[0].crf,
            final_score: probes[0].score,
            round: 10,
        },
    );

    if ctx.use_cvvdp {
        crate::svt::TQ_SCORES
            .get_or_init(|| std::sync::Mutex::new(Vec::new()))
            .lock()
            .unwrap()
            .push(probes[0].score);
    } else {
        crate::svt::TQ_SCORES
            .get_or_init(|| std::sync::Mutex::new(Vec::new()))
            .lock()
            .unwrap()
            .extend_from_slice(&probes[0].frame_scores);
    }

    probes.first().map(|p| format!("{:04}_{:.2}.ivf", ctx.chunk.idx, p.crf))
}
