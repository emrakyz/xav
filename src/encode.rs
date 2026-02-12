use std::collections::HashSet;
use std::path::{Path, PathBuf};
use std::sync::Arc;
use std::thread;

use crossbeam_channel::bounded;
#[cfg(feature = "vship")]
use crossbeam_channel::select;

use crate::chunk::{Chunk, ChunkComp, ResumeInf, get_resume};
use crate::decode::{decode_chunks, decode_pipe};
use crate::encoder::{EncConfig, Encoder, make_enc_cmd};
use crate::ffms::{VidIdx, VidInf};
use crate::pipeline::Pipeline;
use crate::progs::ProgsTrack;
use crate::worker::Semaphore;
#[cfg(feature = "vship")]
use crate::worker::TQState;

#[cfg(feature = "vship")]
pub static TQ_SCORES: std::sync::OnceLock<std::sync::Mutex<Vec<f64>>> = std::sync::OnceLock::new();

#[inline]
pub fn get_frame(frames: &[u8], i: usize, frame_size: usize) -> &[u8] {
    let start = i * frame_size;
    &frames[start..start + frame_size]
}

struct WorkerStats {
    completed: Arc<std::sync::atomic::AtomicUsize>,
    completions: Arc<std::sync::Mutex<ResumeInf>>,
}

impl WorkerStats {
    fn new(completed_count: usize, resume_data: ResumeInf) -> Self {
        Self {
            completed: Arc::new(std::sync::atomic::AtomicUsize::new(completed_count)),
            completions: Arc::new(std::sync::Mutex::new(resume_data)),
        }
    }

    fn add_completion(&self, completion: ChunkComp, work_dir: &Path) {
        {
            let mut data = self.completions.lock().unwrap();
            data.chnks_done.push(completion);
        }
        let data = self.completions.lock().unwrap();
        let _ = crate::chunk::save_resume(&data, work_dir);
    }
}

fn load_resume_data(work_dir: &Path) -> ResumeInf {
    get_resume(work_dir).unwrap_or(ResumeInf { chnks_done: Vec::new() })
}

fn build_skip_set(resume_data: &ResumeInf) -> (HashSet<usize>, usize, usize) {
    let skip_indices: HashSet<usize> = resume_data.chnks_done.iter().map(|c| c.idx).collect();
    let completed_count = skip_indices.len();
    let completed_frames: usize = resume_data.chnks_done.iter().map(|c| c.frames).sum();
    (skip_indices, completed_count, completed_frames)
}

fn create_stats(completed_count: usize, resume_data: ResumeInf) -> Arc<WorkerStats> {
    Arc::new(WorkerStats::new(completed_count, resume_data))
}

pub fn encode_all(
    chunks: &[Chunk],
    inf: &VidInf,
    args: &crate::Args,
    idx: &Arc<VidIdx>,
    work_dir: &Path,
    grain_table: Option<&PathBuf>,
    pipe_reader: Option<crate::y4m::PipeReader>,
) {
    let resume_data = load_resume_data(work_dir);

    #[cfg(feature = "vship")]
    {
        let is_tq = args.target_quality.is_some() && args.qp_range.is_some();
        if is_tq {
            encode_tq(chunks, inf, args, idx, work_dir, grain_table, pipe_reader);
            return;
        }
    }

    let (skip_indices, completed_count, completed_frames) = build_skip_set(&resume_data);
    let stats = Some(create_stats(completed_count, resume_data));
    let (prog, display_handle) = ProgsTrack::new(
        chunks,
        inf,
        args.worker,
        completed_frames,
        Arc::clone(&stats.as_ref().unwrap().completed),
        Arc::clone(&stats.as_ref().unwrap().completions),
    );
    let prog = Arc::new(prog);

    let strat = args.decode_strat.unwrap();
    let pipe = Pipeline::new(
        inf,
        strat,
        #[cfg(feature = "vship")]
        None,
    );

    let (tx, rx) = bounded::<crate::worker::WorkPkg>(args.chunk_buffer);
    let rx = Arc::new(rx);
    let sem = Arc::new(Semaphore::new(args.chunk_buffer));

    let decoder = {
        let chunks = chunks.to_vec();
        let idx = Arc::clone(idx);
        let inf = inf.clone();
        let sem = Arc::clone(&sem);
        thread::spawn(move || {
            if let Some(mut reader) = pipe_reader {
                decode_pipe(&chunks, &mut reader, &inf, &tx, &skip_indices, strat, &sem);
            } else {
                decode_chunks(&chunks, &idx, &inf, &tx, &skip_indices, strat, &sem);
            }
        })
    };

    let mut workers = Vec::new();
    for worker_id in 0..args.worker {
        let rx_clone = Arc::clone(&rx);
        let inf = inf.clone();
        let pipe = pipe.clone();
        let params = args.params.clone();
        let stats_clone = stats.clone();
        let grain = grain_table.cloned();
        let wd = work_dir.to_path_buf();
        let prog_clone = Arc::clone(&prog);
        let sem_clone = Arc::clone(&sem);
        let encoder = args.encoder;

        let handle = thread::spawn(move || {
            run_enc_worker(
                &rx_clone,
                &params,
                &inf,
                &pipe,
                &wd,
                grain.as_deref(),
                stats_clone.as_ref(),
                &prog_clone,
                worker_id,
                &sem_clone,
                encoder,
            );
        });
        workers.push(handle);
    }

    decoder.join().unwrap();
    for handle in workers {
        handle.join().unwrap();
    }
    drop(prog);
    display_handle.join().unwrap();
}

#[derive(Copy, Clone)]
#[cfg(feature = "vship")]
struct TQCtx {
    target: f64,
    tolerance: f64,
    qp_min: f64,
    qp_max: f64,
    use_butteraugli: bool,
    use_cvvdp: bool,
    cvvdp_per_frame: bool,
    cvvdp_config: Option<&'static str>,
}

#[cfg(feature = "vship")]
impl TQCtx {
    #[inline]
    fn converged(&self, score: f64) -> bool {
        if self.use_butteraugli {
            (self.target - score).abs() <= self.tolerance
        } else {
            (score - self.target).abs() <= self.tolerance
        }
    }

    #[inline]
    fn update_bounds_and_check(&self, state: &mut TQState, score: f64) -> bool {
        if self.use_butteraugli {
            if score > self.target + self.tolerance {
                state.search_max = state.last_crf - 0.25;
            } else if score < self.target - self.tolerance {
                state.search_min = state.last_crf + 0.25;
            }
        } else if score < self.target - self.tolerance {
            state.search_max = state.last_crf - 0.25;
        } else if score > self.target + self.tolerance {
            state.search_min = state.last_crf + 0.25;
        }
        state.search_min > state.search_max
    }

    #[inline]
    fn best_probe<'a>(&self, probes: &'a [crate::tq::Probe]) -> &'a crate::tq::Probe {
        probes
            .iter()
            .min_by(|a, b| {
                (a.score - self.target).abs().partial_cmp(&(b.score - self.target).abs()).unwrap()
            })
            .unwrap()
    }
}

#[inline]
#[cfg(feature = "vship")]
fn complete_chunk(
    chunk_idx: usize,
    chunk_frames: usize,
    probe_path: &Path,
    work_dir: &Path,
    done_tx: &crossbeam_channel::Sender<usize>,
    resume_state: &Arc<std::sync::Mutex<crate::chunk::ResumeInf>>,
    stats: Option<&Arc<WorkerStats>>,
    tq_logger: &Arc<std::sync::Mutex<Vec<crate::tq::ProbeLog>>>,
    round: usize,
    final_crf: f64,
    final_score: f64,
    probes: &[crate::tq::Probe],
    probe_sizes: &[(f64, u64)],
    use_cvvdp: bool,
    cvvdp_per_frame: bool,
    encoder: Encoder,
) {
    let dst = work_dir.join("encode").join(format!("{chunk_idx:04}.{}", encoder.extension()));
    if probe_path != dst {
        std::fs::copy(probe_path, &dst).unwrap();
    }
    done_tx.send(chunk_idx).unwrap();

    let file_size = std::fs::metadata(&dst).map_or(0, |m| m.len());
    let comp = crate::chunk::ChunkComp { idx: chunk_idx, frames: chunk_frames, size: file_size };

    let mut resume = resume_state.lock().unwrap();
    resume.chnks_done.push(comp.clone());
    crate::chunk::save_resume(&resume, work_dir).ok();
    drop(resume);

    if let Some(s) = stats {
        s.completed.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        s.completions.lock().unwrap().chnks_done.push(comp);
    }

    let probes_with_size: Vec<(f64, f64, u64)> = probes
        .iter()
        .map(|p| {
            let sz =
                probe_sizes.iter().find(|(c, _)| (*c - p.crf).abs() < 0.001).map_or(0, |(_, s)| *s);
            (p.crf, p.score, sz)
        })
        .collect();

    let log_entry = crate::tq::ProbeLog {
        chunk_idx,
        probes: probes_with_size,
        final_crf,
        final_score,
        final_size: file_size,
        round,
        frames: chunk_frames,
    };
    write_chunk_log(&log_entry, work_dir);
    tq_logger.lock().unwrap().push(log_entry);

    let mut tq_scores = TQ_SCORES.get_or_init(|| std::sync::Mutex::new(Vec::new())).lock().unwrap();
    if use_cvvdp && !cvvdp_per_frame {
        tq_scores.push(final_score);
    } else {
        tq_scores.extend_from_slice(&probes.last().unwrap().frame_scores);
    }
}

#[cfg(feature = "vship")]
fn run_metrics_worker(
    rx: &Arc<crossbeam_channel::Receiver<crate::worker::WorkPkg>>,
    rework_tx: &crossbeam_channel::Sender<crate::worker::WorkPkg>,
    done_tx: &crossbeam_channel::Sender<usize>,
    inf: &crate::ffms::VidInf,
    pipe: &Pipeline,
    work_dir: &Path,
    metric_mode: &str,
    stats: Option<&Arc<WorkerStats>>,
    resume_state: &Arc<std::sync::Mutex<crate::chunk::ResumeInf>>,
    tq_logger: &Arc<std::sync::Mutex<Vec<crate::tq::ProbeLog>>>,
    prog: &Arc<crate::progs::ProgsTrack>,
    worker_id: usize,
    worker_count: usize,
    tq_ctx: &TQCtx,
    encoder: Encoder,
    use_probe_params: bool,
) {
    let mut vship: Option<crate::vship::VshipProcessor> = None;
    let mut unpacked_buf = vec![0u8; if inf.is_10bit { pipe.conv_buf_size } else { 0 }];

    while let Ok(mut pkg) = rx.recv() {
        let tq_st = pkg.tq_state.as_ref().unwrap();
        if tq_st.final_encode {
            let best = tq_ctx.best_probe(&tq_st.probes);
            let p = work_dir.join("encode").join(format!(
                "{:04}.{}",
                pkg.chunk.idx,
                encoder.extension()
            ));
            complete_chunk(
                pkg.chunk.idx,
                pkg.frame_count,
                &p,
                work_dir,
                done_tx,
                resume_state,
                stats,
                tq_logger,
                tq_st.round,
                best.crf,
                best.score,
                &tq_st.probes,
                &tq_st.probe_sizes,
                tq_ctx.use_cvvdp,
                tq_ctx.cvvdp_per_frame,
                encoder,
            );
            continue;
        }

        if vship.is_none() {
            let fps = inf.fps_num as f32 / inf.fps_den as f32;
            vship = Some(
                crate::vship::VshipProcessor::new(
                    pkg.width,
                    pkg.height,
                    inf.is_10bit,
                    inf.matrix_coefficients,
                    inf.transfer_characteristics,
                    inf.color_primaries,
                    inf.color_range,
                    inf.chroma_sample_position,
                    fps,
                    tq_ctx.use_cvvdp,
                    tq_ctx.use_butteraugli,
                    Some("xav"),
                    tq_ctx.cvvdp_config,
                )
                .unwrap(),
            );
        }

        let tq_st = pkg.tq_state.as_ref().unwrap();
        let crf = tq_st.last_crf;
        let probe_path = work_dir.join("split").join(format!(
            "{:04}_{:.2}.{}",
            pkg.chunk.idx,
            crf,
            encoder.extension()
        ));
        let last_score = tq_st.probes.last().map(|probe| probe.score);
        let metrics_slot = worker_count + worker_id;

        let probe_size = std::fs::metadata(&probe_path).map_or(0, |m| m.len());
        pkg.tq_state.as_mut().unwrap().probe_sizes.push((crf, probe_size));

        let (score, frame_scores) = (pipe.calc_metrics)(
            &pkg,
            &probe_path,
            inf,
            pipe,
            vship.as_ref().unwrap(),
            metric_mode,
            &mut unpacked_buf,
            prog,
            metrics_slot,
            crf as f32,
            last_score,
        );

        let tq_state = pkg.tq_state.as_mut().unwrap();
        tq_state.probes.push(crate::tq::Probe { crf, score, frame_scores });

        let should_complete = tq_ctx.converged(score)
            || tq_state.round > 10
            || tq_ctx.update_bounds_and_check(tq_state, score);

        if should_complete {
            let best = tq_ctx.best_probe(&tq_state.probes);
            if use_probe_params {
                tq_state.final_encode = true;
                tq_state.last_crf = best.crf;
                rework_tx.send(pkg).unwrap();
            } else {
                let probe_path = work_dir.join("split").join(format!(
                    "{:04}_{:.2}.{}",
                    pkg.chunk.idx,
                    best.crf,
                    encoder.extension()
                ));
                complete_chunk(
                    pkg.chunk.idx,
                    pkg.frame_count,
                    &probe_path,
                    work_dir,
                    done_tx,
                    resume_state,
                    stats,
                    tq_logger,
                    tq_state.round,
                    best.crf,
                    best.score,
                    &tq_state.probes,
                    &tq_state.probe_sizes,
                    tq_ctx.use_cvvdp,
                    tq_ctx.cvvdp_per_frame,
                    encoder,
                );
            }
        } else {
            rework_tx.send(pkg).unwrap();
        }
    }
}

#[cfg(feature = "vship")]
fn encode_tq(
    chunks: &[Chunk],
    inf: &VidInf,
    args: &crate::Args,
    idx: &Arc<VidIdx>,
    work_dir: &Path,
    grain_table: Option<&PathBuf>,
    pipe_reader: Option<crate::y4m::PipeReader>,
) {
    let resume_data = load_resume_data(work_dir);
    let (skip_indices, completed_count, completed_frames) = build_skip_set(&resume_data);

    let tq_str = args.target_quality.as_ref().unwrap();
    let qp_str = args.qp_range.as_ref().unwrap();
    let tq_parts: Vec<f64> = tq_str.split('-').filter_map(|s| s.parse().ok()).collect();
    let qp_parts: Vec<f64> = qp_str.split('-').filter_map(|s| s.parse().ok()).collect();
    let tq_target = f64::midpoint(tq_parts[0], tq_parts[1]);
    let tq_tolerance = (tq_parts[1] - tq_parts[0]) / 2.0;

    let cvvdp_config_static: Option<&'static str> =
        args.cvvdp_config.as_ref().map(|s| Box::leak(s.clone().into_boxed_str()) as &'static str);

    let tq_ctx = TQCtx {
        target: tq_target,
        tolerance: tq_tolerance,
        qp_min: qp_parts[0],
        qp_max: qp_parts[1],
        use_butteraugli: tq_target < 8.0,
        use_cvvdp: tq_target > 8.0 && tq_target <= 10.0,
        cvvdp_per_frame: tq_target > 8.0 && tq_target <= 10.0 && args.metric_mode.starts_with('p'),
        cvvdp_config: cvvdp_config_static,
    };

    let strat = args.decode_strat.unwrap();
    let pipe = Pipeline::new(inf, strat, args.target_quality.as_deref());

    let (enc_tx, enc_rx) = bounded::<crate::worker::WorkPkg>(2);
    let (met_tx, met_rx) = bounded::<crate::worker::WorkPkg>(2);
    let (rework_tx, rework_rx) = bounded::<crate::worker::WorkPkg>(2);
    let (done_tx, done_rx) = bounded::<usize>(4);

    let enc_rx = Arc::new(enc_rx);
    let met_rx = Arc::new(met_rx);

    let total_chunks = chunks.iter().filter(|c| !skip_indices.contains(&c.idx)).count();
    let max_in_flight = args.chunk_buffer;
    let permits = Arc::new(Semaphore::new(max_in_flight));

    let bg_thread = {
        let chunks = chunks.to_vec();
        let idx = Arc::clone(idx);
        let inf = inf.clone();
        let enc_tx = enc_tx.clone();
        let permits_decoder = Arc::clone(&permits);
        let permits_done = Arc::clone(&permits);

        thread::spawn(move || {
            let (decode_tx, decode_rx) = bounded::<crate::worker::WorkPkg>(2);
            let inf_decode = inf.clone();

            let decoder_handle = thread::spawn(move || {
                if let Some(mut reader) = pipe_reader {
                    decode_pipe(
                        &chunks,
                        &mut reader,
                        &inf_decode,
                        &decode_tx,
                        &skip_indices,
                        strat,
                        &permits_decoder,
                    );
                } else {
                    decode_chunks(
                        &chunks,
                        &idx,
                        &inf_decode,
                        &decode_tx,
                        &skip_indices,
                        strat,
                        &permits_decoder,
                    );
                }
            });

            let mut completed = 0;
            while completed < total_chunks {
                select! {
                    recv(decode_rx) -> pkg => {
                        if let Ok(pkg) = pkg {
                            enc_tx.send(pkg).unwrap();
                        }
                    }
                    recv(rework_rx) -> pkg => {
                        if let Ok(pkg) = pkg {
                            enc_tx.send(pkg).unwrap();
                        }
                    }
                    recv(done_rx) -> result => {
                        if result.is_ok() {
                            permits_done.release();
                            completed += 1;
                        }
                    }
                }
            }
            decoder_handle.join().unwrap();
        })
    };

    let resume_state = Arc::new(std::sync::Mutex::new(resume_data.clone()));
    let tq_logger = Arc::new(std::sync::Mutex::new(Vec::new()));
    let stats = Some(create_stats(completed_count, resume_data));
    let (prog, display_handle) = ProgsTrack::new(
        chunks,
        inf,
        args.worker + args.metric_worker,
        completed_frames,
        Arc::clone(&stats.as_ref().unwrap().completed),
        Arc::clone(&stats.as_ref().unwrap().completions),
    );
    let prog = Arc::new(prog);

    let mut metrics_workers = Vec::new();
    for worker_id in 0..args.metric_worker {
        let rx = Arc::clone(&met_rx);
        let rework_tx = rework_tx.clone();
        let done_tx = done_tx.clone();
        let inf = inf.clone();
        let pipe = pipe.clone();
        let wd = work_dir.to_path_buf();
        let metric_mode = args.metric_mode.clone();
        let encoder = args.encoder;
        let st = stats.clone();
        let resume_state = Arc::clone(&resume_state);
        let tq_logger = Arc::clone(&tq_logger);
        let prog_clone = Arc::clone(&prog);
        let worker_count = args.worker;
        let use_probe_params = args.probe_params.is_some();

        metrics_workers.push(thread::spawn(move || {
            run_metrics_worker(
                &rx,
                &rework_tx,
                &done_tx,
                &inf,
                &pipe,
                &wd,
                &metric_mode,
                st.as_ref(),
                &resume_state,
                &tq_logger,
                &prog_clone,
                worker_id,
                worker_count,
                &tq_ctx,
                encoder,
                use_probe_params,
            );
        }));
    }

    let mut workers = Vec::new();
    for worker_id in 0..args.worker {
        let rx = Arc::clone(&enc_rx);
        let tx = met_tx.clone();
        let inf = inf.clone();
        let pipe = pipe.clone();
        let params = args.params.clone();
        let probe_params = args.probe_params.clone();
        let wd = work_dir.to_path_buf();
        let grain = grain_table.cloned();
        let prog_clone = prog.clone();
        let qp_min = tq_ctx.qp_min;
        let qp_max = tq_ctx.qp_max;
        let target = tq_ctx.target;
        let encoder = args.encoder;

        workers.push(thread::spawn(move || {
            let mut conv_buf = vec![0u8; pipe.conv_buf_size];

            while let Ok(mut pkg) = rx.recv() {
                let tq = pkg.tq_state.get_or_insert_with(|| crate::worker::TQState {
                    probes: Vec::new(),
                    probe_sizes: Vec::new(),
                    search_min: qp_min,
                    search_max: qp_max,
                    round: 0,
                    target,
                    last_crf: 0.0,
                    final_encode: false,
                });

                let is_final = tq.final_encode;
                let crf = if is_final {
                    tq.last_crf
                } else {
                    tq.round += 1;
                    let c = if tq.round <= 2 {
                        crate::tq::binary_search(tq.search_min, tq.search_max)
                    } else {
                        crate::tq::interpolate_crf(&tq.probes, tq.target, tq.round).unwrap_or_else(
                            || crate::tq::binary_search(tq.search_min, tq.search_max),
                        )
                    }
                    .clamp(tq.search_min, tq.search_max);
                    let c = if encoder.integer_qp() { c.round() } else { c };
                    tq.last_crf = c;
                    c
                };
                let (p, out) = if is_final {
                    (
                        &params,
                        Some(wd.join("encode").join(format!(
                            "{:04}.{}",
                            pkg.chunk.idx,
                            encoder.extension()
                        ))),
                    )
                } else {
                    (probe_params.as_ref().unwrap_or(&params), None)
                };
                enc_tq_probe(
                    &pkg,
                    crf,
                    p,
                    &inf,
                    &pipe,
                    &wd,
                    grain.as_deref(),
                    &mut conv_buf,
                    &prog_clone,
                    worker_id,
                    encoder,
                    out.as_deref(),
                );

                tx.send(pkg).unwrap();
            }
        }));
    }

    crate::vship::init_device().unwrap();

    bg_thread.join().unwrap();
    drop(enc_tx);

    for w in workers {
        w.join().unwrap();
    }

    drop(rework_tx);
    drop(met_tx);

    for mw in metrics_workers {
        mw.join().unwrap();
    }

    let metric_name = if tq_ctx.use_butteraugli {
        "butteraugli"
    } else if tq_ctx.use_cvvdp {
        "cvvdp"
    } else {
        "ssimulacra2"
    };
    write_tq_log(&args.input, work_dir, inf, metric_name);
    drop(prog);
    display_handle.join().unwrap();
}

#[cfg(feature = "vship")]
fn enc_tq_probe(
    pkg: &crate::worker::WorkPkg,
    crf: f64,
    params: &str,
    inf: &VidInf,
    pipe: &Pipeline,
    work_dir: &Path,
    grain: Option<&Path>,
    conv_buf: &mut [u8],
    prog: &Arc<ProgsTrack>,
    worker_id: usize,
    encoder: Encoder,
    output_override: Option<&Path>,
) -> PathBuf {
    let default_out;
    let out = if let Some(p) = output_override {
        p
    } else {
        default_out = work_dir.join("split").join(format!(
            "{:04}_{:.2}.{}",
            pkg.chunk.idx,
            crf,
            encoder.extension()
        ));
        &default_out
    };
    let cfg = EncConfig {
        inf,
        params,
        zone_params: pkg.chunk.params.as_deref(),
        crf: crf as f32,
        output: out,
        grain_table: grain,
        width: pkg.width,
        height: pkg.height,
        frames: pkg.frame_count,
    };
    #[cfg(feature = "libsvtav1")]
    if encoder == Encoder::SvtAv1 {
        let last_score =
            pkg.tq_state.as_ref().and_then(|tq| tq.probes.last().map(|probe| probe.score));
        enc_svt_lib(
            pkg,
            &cfg,
            pipe,
            conv_buf,
            prog,
            worker_id,
            false,
            Some((crf as f32, last_score)),
        );
        return out.to_path_buf();
    }

    let mut cmd = make_enc_cmd(encoder, &cfg);
    let mut child = cmd.spawn().unwrap();

    let last_score = pkg.tq_state.as_ref().and_then(|tq| tq.probes.last().map(|probe| probe.score));
    match encoder {
        Encoder::SvtAv1 | Encoder::X265 | Encoder::X264 => prog.watch_enc(
            child.stderr.take().unwrap(),
            worker_id,
            pkg.chunk.idx,
            false,
            Some((crf as f32, last_score)),
            encoder,
        ),
        Encoder::Avm | Encoder::Vvenc => prog.watch_enc(
            child.stdout.take().unwrap(),
            worker_id,
            pkg.chunk.idx,
            false,
            Some((crf as f32, last_score)),
            encoder,
        ),
    }
    (pipe.write_frames)(child.stdin.as_mut().unwrap(), &pkg.yuv, pkg.frame_count, conv_buf, pipe);

    let status = child.wait().unwrap();
    if !status.success() {
        std::process::exit(1);
    }

    out.to_path_buf()
}

fn run_enc_worker(
    rx: &Arc<crossbeam_channel::Receiver<crate::worker::WorkPkg>>,
    params: &str,
    inf: &VidInf,
    pipe: &Pipeline,
    work_dir: &Path,
    grain: Option<&Path>,
    stats: Option<&Arc<WorkerStats>>,
    prog: &Arc<ProgsTrack>,
    worker_id: usize,
    sem: &Arc<Semaphore>,
    encoder: Encoder,
) {
    let mut conv_buf = vec![0u8; pipe.conv_buf_size];

    while let Ok(mut pkg) = rx.recv() {
        enc_chunk(
            &mut pkg,
            -1.0,
            params,
            inf,
            pipe,
            work_dir,
            grain,
            &mut conv_buf,
            prog,
            worker_id,
            encoder,
        );

        if let Some(s) = stats {
            s.completed.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
            let out = work_dir.join("encode").join(format!(
                "{:04}.{}",
                pkg.chunk.idx,
                encoder.extension()
            ));
            let file_size = std::fs::metadata(&out).map_or(0, |m| m.len());
            let comp = crate::chunk::ChunkComp {
                idx: pkg.chunk.idx,
                frames: pkg.frame_count,
                size: file_size,
            };
            s.add_completion(comp, work_dir);
        }

        sem.release();
    }
}

fn enc_chunk(
    pkg: &mut crate::worker::WorkPkg,
    crf: f32,
    params: &str,
    inf: &VidInf,
    pipe: &Pipeline,
    work_dir: &Path,
    grain: Option<&Path>,
    conv_buf: &mut [u8],
    prog: &Arc<ProgsTrack>,
    worker_id: usize,
    encoder: Encoder,
) {
    let out = work_dir.join("encode").join(format!("{:04}.{}", pkg.chunk.idx, encoder.extension()));
    let cfg = EncConfig {
        inf,
        params,
        zone_params: pkg.chunk.params.as_deref(),
        crf,
        output: &out,
        grain_table: grain,
        width: pkg.width,
        height: pkg.height,
        frames: pkg.frame_count,
    };
    #[cfg(feature = "libsvtav1")]
    if encoder == Encoder::SvtAv1 {
        enc_svt_lib(pkg, &cfg, pipe, conv_buf, prog, worker_id, true, None);
        pkg.yuv = Vec::new();
        return;
    }

    let mut cmd = make_enc_cmd(encoder, &cfg);
    let mut child = cmd.spawn().unwrap();

    match encoder {
        Encoder::SvtAv1 | Encoder::X265 | Encoder::X264 => prog.watch_enc(
            child.stderr.take().unwrap(),
            worker_id,
            pkg.chunk.idx,
            true,
            None,
            encoder,
        ),
        Encoder::Avm | Encoder::Vvenc => prog.watch_enc(
            child.stdout.take().unwrap(),
            worker_id,
            pkg.chunk.idx,
            true,
            None,
            encoder,
        ),
    }

    (pipe.write_frames)(child.stdin.as_mut().unwrap(), &pkg.yuv, pkg.frame_count, conv_buf, pipe);
    pkg.yuv = Vec::new();

    let status = child.wait().unwrap();
    if !status.success() {
        std::process::exit(1);
    }
}

#[cfg(feature = "vship")]
pub fn write_chunk_log(chunk_log: &crate::tq::ProbeLog, work_dir: &Path) {
    use std::fs::OpenOptions;
    use std::io::Write as IoWrite;

    let chunks_path = work_dir.join("chunks.json");
    let probes_str = chunk_log
        .probes
        .iter()
        .map(|(c, s, sz)| format!("[{c:.2},{s:.4},{sz}]"))
        .collect::<Vec<_>>()
        .join(",");

    let line = format!(
        "{{\"id\":{},\"r\":{},\"f\":{},\"p\":[{}],\"fc\":{:.2},\"fs\":{:.4},\"fz\":{}}}\n",
        chunk_log.chunk_idx,
        chunk_log.round,
        chunk_log.frames,
        probes_str,
        chunk_log.final_crf,
        chunk_log.final_score,
        chunk_log.final_size
    );

    if let Ok(mut file) = OpenOptions::new().create(true).append(true).open(chunks_path) {
        let _ = file.write_all(line.as_bytes());
    }
}

#[cfg(feature = "vship")]
fn write_tq_log(input: &Path, work_dir: &Path, inf: &VidInf, metric_name: &str) {
    use std::collections::BTreeMap;
    use std::fmt::Write;
    use std::fs::OpenOptions;
    use std::io::{BufRead, Write as IoWrite};

    use serde::Deserialize;

    #[derive(Deserialize)]
    struct ChunkLine {
        id: usize,
        r: usize,
        f: usize,
        p: Vec<(f64, f64, u64)>,
        fc: f64,
        fs: f64,
        fz: u64,
    }

    let log_path = input.with_extension("json");
    let chunks_path = work_dir.join("chunks.json");

    let fps = f64::from(inf.fps_num) / f64::from(inf.fps_den);

    let calc_kbs = |size: u64, frames: usize| -> f64 {
        let duration = frames as f64 / fps;
        if duration > 0.0 { (size as f64 * 8.0) / duration / 1000.0 } else { 0.0 }
    };

    let mut all_logs: Vec<ChunkLine> = Vec::new();

    if let Ok(file) = std::fs::File::open(&chunks_path) {
        for line in std::io::BufReader::new(file).lines().map_while(Result::ok) {
            if let Ok(cl) = sonic_rs::from_str::<ChunkLine>(&line) {
                all_logs.push(cl);
            }
        }
    }

    let total = all_logs.len();
    if total == 0 {
        return;
    }

    let avg_probes = all_logs.iter().map(|l| l.p.len()).sum::<usize>() as f64 / total as f64;
    let in_range = all_logs.iter().filter(|l| l.r <= 6).count();
    let out_range = total - in_range;

    let mut round_counts: BTreeMap<usize, usize> = BTreeMap::new();
    let mut crf_counts: BTreeMap<u64, usize> = BTreeMap::new();

    for l in &all_logs {
        *round_counts.entry(l.p.len()).or_insert(0) += 1;
        let crf_key = (l.fc * 100.0).round() as u64;
        *crf_counts.entry(crf_key).or_insert(0) += 1;
    }

    let method_name = |round: usize| match round {
        1 | 2 => "binary",
        3 => "linear",
        4 => "fritsch_carlson",
        5 => "pchip",
        _ => "akima",
    };

    all_logs.sort_by_key(|l| l.id);

    let mut out = String::new();
    let _ = writeln!(out, "{{");
    let _ = writeln!(out, "  \"chunks_{metric_name}\": [");

    for (i, l) in all_logs.iter().enumerate() {
        let mut sorted_probes: Vec<_> = l.p.iter().collect();
        sorted_probes.sort_by(|(a, _, _), (b, _, _)| a.partial_cmp(b).unwrap());

        let _ = writeln!(out, "    {{");
        let _ = writeln!(out, "      \"id\": {},", l.id);
        let _ = writeln!(out, "      \"probes\": [");

        for (j, (c, s, sz)) in sorted_probes.iter().enumerate() {
            let comma = if j + 1 < sorted_probes.len() { "," } else { "" };
            let _ = writeln!(
                out,
                "        {{ \"crf\": {c:.2}, \"score\": {s:.3}, \"kbs\": {:.0} }}{comma}",
                calc_kbs(*sz, l.f)
            );
        }

        let _ = writeln!(out, "      ],");
        let _ = writeln!(
            out,
            "      \"final\": {{ \"crf\": {:.2}, \"score\": {:.3}, \"kbs\": {:.0} }}",
            l.fc,
            l.fs,
            calc_kbs(l.fz, l.f)
        );

        let comma = if i + 1 < all_logs.len() { "," } else { "" };
        let _ = writeln!(out, "    }}{comma}");

        if i + 1 < all_logs.len() {
            let _ = writeln!(out);
        }
    }

    let _ = writeln!(out, "  ],");
    let _ = writeln!(out);
    let _ = writeln!(out, "  \"average_probes\": {:.1},", (avg_probes * 10.0).round() / 10.0);
    let _ = writeln!(out, "  \"in_range\": {in_range},");
    let _ = writeln!(out, "  \"out_range\": {out_range},");
    let _ = writeln!(out);
    let _ = writeln!(out, "  \"rounds\": {{");

    let rounds_vec: Vec<_> = round_counts.iter().collect();
    for (i, (round, count)) in rounds_vec.iter().enumerate() {
        let pct = (**count as f64 / total as f64 * 100.0 * 100.0).round() / 100.0;
        let comma = if i + 1 < rounds_vec.len() { "," } else { "" };
        let _ = writeln!(
            out,
            "    \"{round}\": {{ \"count\": {count}, \"method\": \"{}\", \"%\": {pct:.2} }}{comma}",
            method_name(**round)
        );
    }

    let _ = writeln!(out, "  }},");
    let _ = writeln!(out);
    let _ = writeln!(out, "  \"common_crfs\": [");

    let mut crf_vec: Vec<_> = crf_counts.iter().collect();
    crf_vec.sort_by(|(_, a), (_, b)| b.cmp(a));
    let top_crfs: Vec<_> = crf_vec.iter().take(25).collect();

    for (i, (crf, count)) in top_crfs.iter().enumerate() {
        let comma = if i + 1 < top_crfs.len() { "," } else { "" };
        let _ = writeln!(
            out,
            "    {{ \"crf\": {:.2}, \"count\": {} }}{comma}",
            **crf as f64 / 100.0,
            **count
        );
    }

    let _ = writeln!(out, "  ]");
    let _ = write!(out, "}}");

    if let Ok(mut file) = OpenOptions::new().create(true).write(true).truncate(true).open(&log_path)
    {
        let _ = file.write_all(out.as_bytes());
    }
}

#[cfg(feature = "libsvtav1")]
fn write_ivf_header(f: &mut std::fs::File, cfg: &EncConfig) {
    use std::io::Write;
    let _ = f.write_all(b"DKIF");
    let _ = f.write_all(&0u16.to_le_bytes());
    let _ = f.write_all(&32u16.to_le_bytes());
    let _ = f.write_all(b"AV01");
    let _ = f.write_all(&(cfg.width as u16).to_le_bytes());
    let _ = f.write_all(&(cfg.height as u16).to_le_bytes());
    let _ = f.write_all(&cfg.inf.fps_num.to_le_bytes());
    let _ = f.write_all(&cfg.inf.fps_den.to_le_bytes());
    let _ = f.write_all(&0u32.to_le_bytes());
    let _ = f.write_all(&0u32.to_le_bytes());
}

#[cfg(feature = "libsvtav1")]
fn write_ivf_frame(f: &mut std::fs::File, data: &[u8], pts: u64) {
    use std::io::Write;
    let _ = f.write_all(&(data.len() as u32).to_le_bytes());
    let _ = f.write_all(&pts.to_le_bytes());
    let _ = f.write_all(data);
}

#[cfg(feature = "libsvtav1")]
fn drain_svt_packets(
    handle: *mut crate::svt::EbComponentType,
    out: &mut std::fs::File,
    done: bool,
) -> usize {
    use crate::svt::{
        EB_BUFFERFLAG_EOS, EB_ERROR_NONE, EbBufferHeaderType, svt_av1_enc_get_packet,
        svt_av1_enc_release_out_buffer,
    };
    let mut count = 0;
    loop {
        let mut pkt: *mut EbBufferHeaderType = std::ptr::null_mut();
        let ret = unsafe { svt_av1_enc_get_packet(handle, &raw mut pkt, u8::from(done)) };
        if ret != EB_ERROR_NONE {
            break;
        }
        let p = unsafe { &*pkt };
        if p.n_filled_len > 0 {
            let data = unsafe { std::slice::from_raw_parts(p.p_buffer, p.n_filled_len as usize) };
            write_ivf_frame(out, data, p.pts as u64);
            count += 1;
        }
        let eos = p.flags & EB_BUFFERFLAG_EOS != 0;
        unsafe { svt_av1_enc_release_out_buffer(&raw mut pkt) };
        if eos {
            break;
        }
    }
    count
}

#[cfg(feature = "libsvtav1")]
fn enc_svt_lib(
    pkg: &crate::worker::WorkPkg,
    cfg: &EncConfig,
    pipe: &Pipeline,
    conv_buf: &mut [u8],
    prog: &Arc<ProgsTrack>,
    worker_id: usize,
    track_frames: bool,
    crf_score: Option<(f32, Option<f64>)>,
) {
    use crate::svt::{
        EB_BUFFERFLAG_EOS, EB_ERROR_NONE, EbBufferHeaderType, EbComponentType,
        EbSvtAv1EncConfiguration, EbSvtIOFormat, svt_av1_enc_deinit, svt_av1_enc_deinit_handle,
        svt_av1_enc_get_packet, svt_av1_enc_init, svt_av1_enc_init_handle,
        svt_av1_enc_release_out_buffer, svt_av1_enc_send_picture, svt_av1_enc_set_parameter,
    };

    let mut handle: *mut EbComponentType = std::ptr::null_mut();
    let mut config = unsafe { std::mem::zeroed::<EbSvtAv1EncConfiguration>() };

    let ret = unsafe { svt_av1_enc_init_handle(&raw mut handle, &raw mut config) };
    if ret != EB_ERROR_NONE {
        std::process::exit(1);
    }

    crate::encoder::set_svt_config(&raw mut config, cfg);

    let ret = unsafe { svt_av1_enc_set_parameter(handle, &raw mut config) };
    if ret != EB_ERROR_NONE {
        std::process::exit(1);
    }

    let ret = unsafe { svt_av1_enc_init(handle) };
    if ret != EB_ERROR_NONE {
        std::process::exit(1);
    }

    let mut out = std::fs::File::create(cfg.output).unwrap();
    write_ivf_header(&mut out, cfg);

    let w = cfg.width as usize;
    let h = cfg.height as usize;
    let y_size = w * h * 2;
    let uv_size = (w / 2) * (h / 2) * 2;

    let mut io_fmt = EbSvtIOFormat {
        luma: conv_buf.as_mut_ptr(),
        cb: unsafe { conv_buf.as_mut_ptr().add(y_size) },
        cr: unsafe { conv_buf.as_mut_ptr().add(y_size + uv_size) },
        y_stride: w as u32,
        cb_stride: (w / 2) as u32,
        cr_stride: (w / 2) as u32,
    };

    let mut in_hdr = unsafe { std::mem::zeroed::<EbBufferHeaderType>() };
    in_hdr.size = std::mem::size_of::<EbBufferHeaderType>() as u32;
    in_hdr.p_buffer = (&raw mut io_fmt).cast::<u8>();
    in_hdr.n_filled_len = (y_size + uv_size * 2) as u32;
    in_hdr.n_alloc_len = in_hdr.n_filled_len;

    let mut tracker = crate::progs::LibEncTracker::new();
    prog.update_lib_enc(worker_id, pkg.chunk.idx, 0, pkg.frame_count, 0.0, None, crf_score);

    #[allow(clippy::cast_possible_wrap)]
    for i in 0..pkg.frame_count {
        let frame = get_frame(&pkg.yuv, i, pipe.frame_size);
        if cfg.inf.is_10bit {
            (pipe.unpack)(frame, conv_buf, pipe);
        } else {
            crate::ffms::conv_to_10bit(frame, conv_buf);
        }

        in_hdr.pts = i as i64;
        in_hdr.flags = 0;

        let ret = unsafe { svt_av1_enc_send_picture(handle, &raw mut in_hdr) };
        if ret != EB_ERROR_NONE {
            std::process::exit(1);
        }

        tracker.encoded += drain_svt_packets(handle, &mut out, false);
        tracker.report(prog, worker_id, pkg.chunk.idx, pkg.frame_count, track_frames, crf_score);
    }

    let mut eos = unsafe { std::mem::zeroed::<EbBufferHeaderType>() };
    eos.flags = EB_BUFFERFLAG_EOS;
    unsafe { svt_av1_enc_send_picture(handle, &raw mut eos) };

    loop {
        let mut pkt: *mut EbBufferHeaderType = std::ptr::null_mut();
        let ret = unsafe { svt_av1_enc_get_packet(handle, &raw mut pkt, 1) };
        if ret != EB_ERROR_NONE {
            break;
        }
        let p = unsafe { &*pkt };
        if p.n_filled_len > 0 {
            let data = unsafe { std::slice::from_raw_parts(p.p_buffer, p.n_filled_len as usize) };
            write_ivf_frame(&mut out, data, p.pts as u64);
            tracker.encoded += 1;
        }
        let is_eos = p.flags & EB_BUFFERFLAG_EOS != 0;
        unsafe { svt_av1_enc_release_out_buffer(&raw mut pkt) };
        tracker.report(prog, worker_id, pkg.chunk.idx, pkg.frame_count, track_frames, crf_score);
        if is_eos {
            break;
        }
    }

    prog.clear_lib_enc(worker_id);

    unsafe {
        svt_av1_enc_deinit(handle);
        svt_av1_enc_deinit_handle(handle);
    }
}
