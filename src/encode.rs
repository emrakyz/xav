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
    completed_frames: Arc<std::sync::atomic::AtomicUsize>,
    total_size: Arc<std::sync::atomic::AtomicU64>,
    completions: Arc<std::sync::Mutex<ResumeInf>>,
}

impl WorkerStats {
    fn new(completed_count: usize, resume_data: &ResumeInf) -> Self {
        let init_frames: usize = resume_data.chnks_done.iter().map(|c| c.frames).sum();
        let init_size: u64 = resume_data.chnks_done.iter().map(|c| c.size).sum();
        Self {
            completed: Arc::new(std::sync::atomic::AtomicUsize::new(completed_count)),
            completed_frames: Arc::new(std::sync::atomic::AtomicUsize::new(init_frames)),
            total_size: Arc::new(std::sync::atomic::AtomicU64::new(init_size)),
            completions: Arc::new(std::sync::Mutex::new(resume_data.clone())),
        }
    }

    fn add_completion(&self, completion: ChunkComp, work_dir: &Path) {
        self.completed_frames.fetch_add(completion.frames, std::sync::atomic::Ordering::Relaxed);
        self.total_size.fetch_add(completion.size, std::sync::atomic::Ordering::Relaxed);
        let mut data = self.completions.lock().unwrap();
        data.chnks_done.push(completion);
        let _ = crate::chunk::save_resume(&data, work_dir);
        drop(data);
    }
}

fn load_resume_data(work_dir: &Path) -> ResumeInf {
    get_resume(work_dir).unwrap_or(ResumeInf { chnks_done: Vec::new(), prior_secs: 0 })
}

fn build_skip_set(resume_data: &ResumeInf) -> (HashSet<usize>, usize, usize) {
    let skip_indices: HashSet<usize> = resume_data.chnks_done.iter().map(|c| c.idx).collect();
    let completed_count = skip_indices.len();
    let completed_frames: usize = resume_data.chnks_done.iter().map(|c| c.frames).sum();
    (skip_indices, completed_count, completed_frames)
}

fn create_stats(completed_count: usize, resume_data: &ResumeInf) -> Arc<WorkerStats> {
    Arc::new(WorkerStats::new(completed_count, resume_data))
}

struct EncWorkerCtx<'a> {
    inf: &'a VidInf,
    pipe: &'a Pipeline,
    work_dir: &'a Path,
    grain: Option<&'a Path>,
    prog: &'a Arc<ProgsTrack>,
    encoder: Encoder,
}

#[cfg(feature = "vship")]
struct TQWorkerCtx<'a> {
    inf: &'a VidInf,
    pipe: &'a Pipeline,
    work_dir: &'a Path,
    metric_mode: &'a str,
    prog: &'a Arc<ProgsTrack>,
    done_tx: &'a crossbeam_channel::Sender<usize>,
    resume_state: &'a Arc<std::sync::Mutex<ResumeInf>>,
    stats: Option<&'a Arc<WorkerStats>>,
    tq_logger: &'a Arc<std::sync::Mutex<Vec<crate::tq::ProbeLog>>>,
    tq_ctx: &'a TQCtx,
    encoder: Encoder,
    use_probe_params: bool,
    worker_count: usize,
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
    let stats = Some(create_stats(completed_count, &resume_data));
    let (prog, display_handle) = ProgsTrack::new(
        chunks,
        inf,
        args.worker,
        completed_frames,
        Arc::clone(&stats.as_ref().unwrap().completed),
        Arc::clone(&stats.as_ref().unwrap().completed_frames),
        Arc::clone(&stats.as_ref().unwrap().total_size),
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
            let ctx = EncWorkerCtx {
                inf: &inf,
                pipe: &pipe,
                work_dir: &wd,
                grain: grain.as_deref(),
                prog: &prog_clone,
                encoder,
            };
            run_enc_worker(&rx_clone, &params, &ctx, stats_clone.as_ref(), worker_id, &sem_clone);
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

    #[inline]
    const fn metric_name(&self) -> &'static str {
        if self.use_butteraugli {
            "butteraugli"
        } else if self.use_cvvdp {
            "cvvdp"
        } else {
            "ssimulacra2"
        }
    }
}

#[inline]
#[cfg(feature = "vship")]
fn complete_chunk(
    chunk_idx: usize,
    chunk_frames: usize,
    probe_path: &Path,
    ctx: &TQWorkerCtx,
    tq_state: &TQState,
    best: &crate::tq::Probe,
) {
    let dst =
        ctx.work_dir.join("encode").join(format!("{chunk_idx:04}.{}", ctx.encoder.extension()));
    if probe_path != dst {
        std::fs::copy(probe_path, &dst).unwrap();
    }
    ctx.done_tx.send(chunk_idx).unwrap();

    let file_size = std::fs::metadata(&dst).map_or(0, |m| m.len());
    let comp = crate::chunk::ChunkComp { idx: chunk_idx, frames: chunk_frames, size: file_size };

    let mut resume = ctx.resume_state.lock().unwrap();
    resume.chnks_done.push(comp.clone());
    crate::chunk::save_resume(&resume, ctx.work_dir).ok();
    drop(resume);

    if let Some(s) = ctx.stats {
        s.completed.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        s.completed_frames.fetch_add(comp.frames, std::sync::atomic::Ordering::Relaxed);
        s.total_size.fetch_add(comp.size, std::sync::atomic::Ordering::Relaxed);
    }

    let probes_with_size: Vec<(f64, f64, u64)> = tq_state
        .probes
        .iter()
        .map(|p| {
            let sz = tq_state
                .probe_sizes
                .iter()
                .find(|(c, _)| (*c - p.crf).abs() < 0.001)
                .map_or(0, |(_, s)| *s);
            (p.crf, p.score, sz)
        })
        .collect();

    let log_entry = crate::tq::ProbeLog {
        chunk_idx,
        probes: probes_with_size,
        final_crf: best.crf,
        final_score: best.score,
        final_size: file_size,
        round: tq_state.round,
        frames: chunk_frames,
    };
    write_chunk_log(&log_entry, ctx.work_dir);
    ctx.tq_logger.lock().unwrap().push(log_entry);

    let mut tq_scores = TQ_SCORES.get_or_init(|| std::sync::Mutex::new(Vec::new())).lock().unwrap();
    if ctx.tq_ctx.use_cvvdp && !ctx.tq_ctx.cvvdp_per_frame {
        tq_scores.push(best.score);
    } else {
        let matched = tq_state.probes.iter().find(|p| (p.crf - best.crf).abs() < 0.001).unwrap();
        tq_scores.extend_from_slice(&matched.frame_scores);
    }
}

#[cfg(feature = "vship")]
fn run_metrics_worker(
    rx: &Arc<crossbeam_channel::Receiver<crate::worker::WorkPkg>>,
    rework_tx: &crossbeam_channel::Sender<crate::worker::WorkPkg>,
    ctx: &TQWorkerCtx,
    worker_id: usize,
) {
    let mut vship: Option<crate::vship::VshipProcessor> = None;
    let mut unpacked_buf = vec![0u8; if ctx.inf.is_10bit { ctx.pipe.conv_buf_size } else { 0 }];

    while let Ok(mut pkg) = rx.recv() {
        let tq_st = pkg.tq_state.as_ref().unwrap();
        if tq_st.final_encode {
            let best = ctx.tq_ctx.best_probe(&tq_st.probes);
            let p = ctx.work_dir.join("encode").join(format!(
                "{:04}.{}",
                pkg.chunk.idx,
                ctx.encoder.extension()
            ));
            complete_chunk(pkg.chunk.idx, pkg.frame_count, &p, ctx, tq_st, best);
            continue;
        }

        if vship.is_none() {
            vship = Some(
                crate::vship::VshipProcessor::new(
                    pkg.width,
                    pkg.height,
                    ctx.inf,
                    ctx.tq_ctx.use_cvvdp,
                    ctx.tq_ctx.use_butteraugli,
                    Some("xav"),
                    ctx.tq_ctx.cvvdp_config,
                )
                .unwrap(),
            );
        }

        let tq_st = pkg.tq_state.as_ref().unwrap();
        let crf = tq_st.last_crf;
        let probe_path = ctx.work_dir.join("split").join(format!(
            "{:04}_{:.2}.{}",
            pkg.chunk.idx,
            crf,
            ctx.encoder.extension()
        ));
        let last_score = tq_st.probes.last().map(|probe| probe.score);
        let metrics_slot = ctx.worker_count + worker_id;

        let probe_size = std::fs::metadata(&probe_path).map_or(0, |m| m.len());
        pkg.tq_state.as_mut().unwrap().probe_sizes.push((crf, probe_size));

        let mp = crate::pipeline::MetricsProgress {
            prog: ctx.prog,
            slot: metrics_slot,
            crf: crf as f32,
            last_score,
        };
        let (score, frame_scores) = (ctx.pipe.calc_metrics)(
            &pkg,
            &probe_path,
            ctx.pipe,
            vship.as_ref().unwrap(),
            ctx.metric_mode,
            &mut unpacked_buf,
            &mp,
        );

        let tq_state = pkg.tq_state.as_mut().unwrap();
        tq_state.probes.push(crate::tq::Probe { crf, score, frame_scores });

        let should_complete = ctx.tq_ctx.converged(score)
            || tq_state.round > 10
            || ctx.tq_ctx.update_bounds_and_check(tq_state, score);

        if should_complete {
            let best = ctx.tq_ctx.best_probe(&tq_state.probes);
            if ctx.use_probe_params {
                tq_state.final_encode = true;
                tq_state.last_crf = best.crf;
                rework_tx.send(pkg).unwrap();
            } else {
                let probe_path = ctx.work_dir.join("split").join(format!(
                    "{:04}_{:.2}.{}",
                    pkg.chunk.idx,
                    best.crf,
                    ctx.encoder.extension()
                ));
                complete_chunk(pkg.chunk.idx, pkg.frame_count, &probe_path, ctx, tq_state, best);
            }
        } else {
            rework_tx.send(pkg).unwrap();
        }
    }
}

#[cfg(feature = "vship")]
fn parse_tq_ctx(args: &crate::Args) -> TQCtx {
    let tq_str = args.target_quality.as_ref().unwrap();
    let qp_str = args.qp_range.as_ref().unwrap();
    let tq_parts: Vec<f64> = tq_str.split('-').filter_map(|s| s.parse().ok()).collect();
    let qp_parts: Vec<f64> = qp_str.split('-').filter_map(|s| s.parse().ok()).collect();
    let tq_target = f64::midpoint(tq_parts[0], tq_parts[1]);
    let cvvdp_config: Option<&'static str> =
        args.cvvdp_config.as_ref().map(|s| Box::leak(s.clone().into_boxed_str()) as &'static str);
    TQCtx {
        target: tq_target,
        tolerance: (tq_parts[1] - tq_parts[0]) / 2.0,
        qp_min: qp_parts[0],
        qp_max: qp_parts[1],
        use_butteraugli: tq_target < 8.0,
        use_cvvdp: tq_target > 8.0 && tq_target <= 10.0,
        cvvdp_per_frame: tq_target > 8.0 && tq_target <= 10.0 && args.metric_mode.starts_with('p'),
        cvvdp_config,
    }
}

#[cfg(feature = "vship")]
fn tq_coordinate(
    decode_rx: &crossbeam_channel::Receiver<crate::worker::WorkPkg>,
    rework_rx: &crossbeam_channel::Receiver<crate::worker::WorkPkg>,
    done_rx: &crossbeam_channel::Receiver<usize>,
    enc_tx: &crossbeam_channel::Sender<crate::worker::WorkPkg>,
    total_chunks: usize,
    permits: &Semaphore,
) {
    let mut completed = 0;
    while completed < total_chunks {
        select! {
            recv(decode_rx) -> pkg => { if let Ok(pkg) = pkg { enc_tx.send(pkg).unwrap(); } }
            recv(rework_rx) -> pkg => { if let Ok(pkg) = pkg { enc_tx.send(pkg).unwrap(); } }
            recv(done_rx) -> result => { if result.is_ok() { permits.release(); completed += 1; } }
        }
    }
}

#[cfg(feature = "vship")]
#[inline]
fn tq_search_crf(tq: &mut crate::worker::TQState, encoder: Encoder) -> f64 {
    tq.round += 1;
    let c = if tq.round <= 2 {
        crate::tq::binary_search(tq.search_min, tq.search_max)
    } else {
        crate::tq::interpolate_crf(&tq.probes, tq.target, tq.round)
            .unwrap_or_else(|| crate::tq::binary_search(tq.search_min, tq.search_max))
    }
    .clamp(tq.search_min, tq.search_max);
    let c = if encoder.integer_qp() { c.round() } else { c };
    tq.last_crf = c;
    c
}

#[cfg(feature = "vship")]
fn tq_enc_loop(
    rx: &crossbeam_channel::Receiver<crate::worker::WorkPkg>,
    tx: &crossbeam_channel::Sender<crate::worker::WorkPkg>,
    ctx: &EncWorkerCtx,
    params: &str,
    probe_params: Option<&str>,
    tq_ctx: &TQCtx,
    worker_id: usize,
) {
    let mut conv_buf = vec![0u8; ctx.pipe.conv_buf_size];
    while let Ok(mut pkg) = rx.recv() {
        let tq = pkg.tq_state.get_or_insert_with(|| crate::worker::TQState {
            probes: Vec::new(),
            probe_sizes: Vec::new(),
            search_min: tq_ctx.qp_min,
            search_max: tq_ctx.qp_max,
            round: 0,
            target: tq_ctx.target,
            last_crf: 0.0,
            final_encode: false,
        });
        let is_final = tq.final_encode;
        let crf = if is_final { tq.last_crf } else { tq_search_crf(tq, ctx.encoder) };
        let (p, out) = if is_final {
            (
                params,
                Some(ctx.work_dir.join("encode").join(format!(
                    "{:04}.{}",
                    pkg.chunk.idx,
                    ctx.encoder.extension()
                ))),
            )
        } else {
            (probe_params.unwrap_or(params), None)
        };
        enc_tq_probe(&pkg, crf, p, ctx, &mut conv_buf, worker_id, out.as_deref());
        tx.send(pkg).unwrap();
    }
}

#[cfg(feature = "vship")]
struct TQDecodeResult {
    enc_tx: crossbeam_channel::Sender<crate::worker::WorkPkg>,
    enc_rx: crossbeam_channel::Receiver<crate::worker::WorkPkg>,
    rework_tx: crossbeam_channel::Sender<crate::worker::WorkPkg>,
    done_tx: crossbeam_channel::Sender<usize>,
    handle: thread::JoinHandle<()>,
}

#[cfg(feature = "vship")]
fn spawn_tq_decode(
    chunks: &[Chunk],
    idx: &Arc<VidIdx>,
    inf: &VidInf,
    skip: HashSet<usize>,
    strat: crate::ffms::DecodeStrat,
    permits: &Arc<Semaphore>,
    pipe_reader: Option<crate::y4m::PipeReader>,
) -> TQDecodeResult {
    let total = chunks.iter().filter(|c| !skip.contains(&c.idx)).count();
    let (enc_tx, enc_rx) = bounded::<crate::worker::WorkPkg>(2);
    let (rework_tx, rework_rx) = bounded::<crate::worker::WorkPkg>(2);
    let (done_tx, done_rx) = bounded::<usize>(4);

    let chunks = chunks.to_vec();
    let idx = Arc::clone(idx);
    let inf = inf.clone();
    let enc_tx2 = enc_tx.clone();
    let permits_dec = Arc::clone(permits);
    let permits_done = Arc::clone(permits);
    let handle = thread::spawn(move || {
        let (dtx, drx) = bounded::<crate::worker::WorkPkg>(2);
        let inf2 = inf.clone();
        let dec = thread::spawn(move || {
            if let Some(mut r) = pipe_reader {
                decode_pipe(&chunks, &mut r, &inf2, &dtx, &skip, strat, &permits_dec);
            } else {
                decode_chunks(&chunks, &idx, &inf2, &dtx, &skip, strat, &permits_dec);
            }
        });
        tq_coordinate(&drx, &rework_rx, &done_rx, &enc_tx2, total, &permits_done);
        dec.join().unwrap();
    });
    TQDecodeResult { enc_tx, enc_rx, rework_tx, done_tx, handle }
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
    let tq_ctx = parse_tq_ctx(args);
    let strat = args.decode_strat.unwrap();
    let pipe = Pipeline::new(inf, strat, args.target_quality.as_deref());
    let permits = Arc::new(Semaphore::new(args.chunk_buffer));

    let dec = spawn_tq_decode(chunks, idx, inf, skip_indices, strat, &permits, pipe_reader);
    let (met_tx, met_rx) = bounded::<crate::worker::WorkPkg>(2);
    let (enc_rx, met_rx) = (Arc::new(dec.enc_rx), Arc::new(met_rx));

    let resume_state = Arc::new(std::sync::Mutex::new(resume_data.clone()));
    let tq_logger = Arc::new(std::sync::Mutex::new(Vec::new()));
    let stats = Some(create_stats(completed_count, &resume_data));
    let (prog, display_handle) = ProgsTrack::new(
        chunks,
        inf,
        args.worker + args.metric_worker,
        completed_frames,
        Arc::clone(&stats.as_ref().unwrap().completed),
        Arc::clone(&stats.as_ref().unwrap().completed_frames),
        Arc::clone(&stats.as_ref().unwrap().total_size),
    );
    let prog = Arc::new(prog);
    let (encoder, use_probe_params, worker_count) =
        (args.encoder, args.probe_params.is_some(), args.worker);

    let mut metrics_workers = Vec::new();
    for worker_id in 0..args.metric_worker {
        let (rx, rework_tx, done_tx) =
            (Arc::clone(&met_rx), dec.rework_tx.clone(), dec.done_tx.clone());
        let (inf, pipe, wd) = (inf.clone(), pipe.clone(), work_dir.to_path_buf());
        let (metric_mode, st) = (args.metric_mode.clone(), stats.clone());
        let (resume_state, tq_logger, prog_clone) =
            (Arc::clone(&resume_state), Arc::clone(&tq_logger), Arc::clone(&prog));
        metrics_workers.push(thread::spawn(move || {
            let ctx = TQWorkerCtx {
                inf: &inf,
                pipe: &pipe,
                work_dir: &wd,
                metric_mode: &metric_mode,
                prog: &prog_clone,
                done_tx: &done_tx,
                resume_state: &resume_state,
                stats: st.as_ref(),
                tq_logger: &tq_logger,
                tq_ctx: &tq_ctx,
                encoder,
                use_probe_params,
                worker_count,
            };
            run_metrics_worker(&rx, &rework_tx, &ctx, worker_id);
        }));
    }

    let mut workers = Vec::new();
    for worker_id in 0..worker_count {
        let (rx, tx) = (Arc::clone(&enc_rx), met_tx.clone());
        let (inf, pipe, wd) = (inf.clone(), pipe.clone(), work_dir.to_path_buf());
        let (params, probe_params, grain) =
            (args.params.clone(), args.probe_params.clone(), grain_table.cloned());
        let prog_clone = prog.clone();
        workers.push(thread::spawn(move || {
            let ctx = EncWorkerCtx {
                inf: &inf,
                pipe: &pipe,
                work_dir: &wd,
                grain: grain.as_deref(),
                prog: &prog_clone,
                encoder,
            };
            tq_enc_loop(&rx, &tx, &ctx, &params, probe_params.as_deref(), &tq_ctx, worker_id);
        }));
    }

    crate::vship::init_device().unwrap();
    dec.handle.join().unwrap();
    drop(dec.enc_tx);
    for w in workers {
        w.join().unwrap();
    }
    drop(dec.rework_tx);
    drop(met_tx);
    for mw in metrics_workers {
        mw.join().unwrap();
    }

    write_tq_log(&args.input, work_dir, inf, tq_ctx.metric_name());
    drop(prog);
    display_handle.join().unwrap();
}

#[cfg(feature = "vship")]
fn enc_tq_probe(
    pkg: &crate::worker::WorkPkg,
    crf: f64,
    params: &str,
    ctx: &EncWorkerCtx,
    conv_buf: &mut [u8],
    worker_id: usize,
    output_override: Option<&Path>,
) -> PathBuf {
    let default_out;
    let out = if let Some(p) = output_override {
        p
    } else {
        default_out = ctx.work_dir.join("split").join(format!(
            "{:04}_{:.2}.{}",
            pkg.chunk.idx,
            crf,
            ctx.encoder.extension()
        ));
        &default_out
    };
    let cfg = EncConfig {
        inf: ctx.inf,
        params,
        zone_params: pkg.chunk.params.as_deref(),
        crf: crf as f32,
        output: out,
        grain_table: ctx.grain,
        width: pkg.width,
        height: pkg.height,
        frames: pkg.frame_count,
    };
    #[cfg(feature = "libsvtav1")]
    if ctx.encoder == Encoder::SvtAv1 {
        let last_score =
            pkg.tq_state.as_ref().and_then(|tq| tq.probes.last().map(|probe| probe.score));
        enc_svt_lib(pkg, &cfg, ctx, conv_buf, worker_id, false, Some((crf as f32, last_score)));
        return out.to_path_buf();
    }

    let mut cmd = make_enc_cmd(ctx.encoder, &cfg);
    let mut child = cmd.spawn().unwrap();

    let last_score = pkg.tq_state.as_ref().and_then(|tq| tq.probes.last().map(|probe| probe.score));
    match ctx.encoder {
        Encoder::SvtAv1 | Encoder::X265 | Encoder::X264 => ctx.prog.watch_enc(
            child.stderr.take().unwrap(),
            worker_id,
            pkg.chunk.idx,
            false,
            Some((crf as f32, last_score)),
            ctx.encoder,
        ),
        Encoder::Avm | Encoder::Vvenc => ctx.prog.watch_enc(
            child.stdout.take().unwrap(),
            worker_id,
            pkg.chunk.idx,
            false,
            Some((crf as f32, last_score)),
            ctx.encoder,
        ),
    }
    (ctx.pipe.write_frames)(
        child.stdin.as_mut().unwrap(),
        &pkg.yuv,
        pkg.frame_count,
        conv_buf,
        ctx.pipe,
    );

    let status = child.wait().unwrap();
    if !status.success() {
        std::process::exit(1);
    }

    out.to_path_buf()
}

fn run_enc_worker(
    rx: &Arc<crossbeam_channel::Receiver<crate::worker::WorkPkg>>,
    params: &str,
    ctx: &EncWorkerCtx,
    stats: Option<&Arc<WorkerStats>>,
    worker_id: usize,
    sem: &Arc<Semaphore>,
) {
    let mut conv_buf = vec![0u8; ctx.pipe.conv_buf_size];

    while let Ok(mut pkg) = rx.recv() {
        enc_chunk(&mut pkg, -1.0, params, ctx, &mut conv_buf, worker_id);

        if let Some(s) = stats {
            s.completed.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
            let out = ctx.work_dir.join("encode").join(format!(
                "{:04}.{}",
                pkg.chunk.idx,
                ctx.encoder.extension()
            ));
            let file_size = std::fs::metadata(&out).map_or(0, |m| m.len());
            let comp = crate::chunk::ChunkComp {
                idx: pkg.chunk.idx,
                frames: pkg.frame_count,
                size: file_size,
            };
            s.add_completion(comp, ctx.work_dir);
        }

        sem.release();
    }
}

fn enc_chunk(
    pkg: &mut crate::worker::WorkPkg,
    crf: f32,
    params: &str,
    ctx: &EncWorkerCtx,
    conv_buf: &mut [u8],
    worker_id: usize,
) {
    let out = ctx.work_dir.join("encode").join(format!(
        "{:04}.{}",
        pkg.chunk.idx,
        ctx.encoder.extension()
    ));
    let cfg = EncConfig {
        inf: ctx.inf,
        params,
        zone_params: pkg.chunk.params.as_deref(),
        crf,
        output: &out,
        grain_table: ctx.grain,
        width: pkg.width,
        height: pkg.height,
        frames: pkg.frame_count,
    };
    #[cfg(feature = "libsvtav1")]
    if ctx.encoder == Encoder::SvtAv1 {
        enc_svt_lib(pkg, &cfg, ctx, conv_buf, worker_id, true, None);
        pkg.yuv = Vec::new();
        return;
    }

    let mut cmd = make_enc_cmd(ctx.encoder, &cfg);
    let mut child = cmd.spawn().unwrap();

    match ctx.encoder {
        Encoder::SvtAv1 | Encoder::X265 | Encoder::X264 => ctx.prog.watch_enc(
            child.stderr.take().unwrap(),
            worker_id,
            pkg.chunk.idx,
            true,
            None,
            ctx.encoder,
        ),
        Encoder::Avm | Encoder::Vvenc => ctx.prog.watch_enc(
            child.stdout.take().unwrap(),
            worker_id,
            pkg.chunk.idx,
            true,
            None,
            ctx.encoder,
        ),
    }

    (ctx.pipe.write_frames)(
        child.stdin.as_mut().unwrap(),
        &pkg.yuv,
        pkg.frame_count,
        conv_buf,
        ctx.pipe,
    );
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
fn format_tq_json(
    all_logs: &[TqChunkLine],
    metric_name: &str,
    fps: f64,
    round_counts: &std::collections::BTreeMap<usize, usize>,
    crf_counts: &std::collections::BTreeMap<u64, usize>,
) -> String {
    use std::fmt::Write;

    let total = all_logs.len();
    let avg_probes = all_logs.iter().map(|l| l.p.len()).sum::<usize>() as f64 / total as f64;
    let in_range = all_logs.iter().filter(|l| l.r <= 6).count();

    let calc_kbs = |size: u64, frames: usize| -> f64 {
        let d = frames as f64 / fps;
        if d > 0.0 { (size as f64 * 8.0) / d / 1000.0 } else { 0.0 }
    };

    let method_name = |round: usize| match round {
        1 | 2 => "binary",
        3 => "linear",
        4 => "fritsch_carlson",
        5 => "pchip",
        _ => "akima",
    };

    let mut out = String::new();
    let _ = writeln!(out, "{{");
    let _ = writeln!(out, "  \"chunks_{metric_name}\": [");

    for (i, l) in all_logs.iter().enumerate() {
        let mut sp: Vec<_> = l.p.iter().collect();
        sp.sort_by(|(a, _, _), (b, _, _)| a.partial_cmp(b).unwrap());
        let _ = writeln!(out, "    {{");
        let _ = writeln!(out, "      \"id\": {},", l.id);
        let _ = writeln!(out, "      \"probes\": [");
        for (j, (c, s, sz)) in sp.iter().enumerate() {
            let comma = if j + 1 < sp.len() { "," } else { "" };
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
    let _ = writeln!(out, "  \"out_range\": {},", total - in_range);
    let _ = writeln!(out);
    let _ = writeln!(out, "  \"rounds\": {{");
    let rv: Vec<_> = round_counts.iter().collect();
    for (i, (round, count)) in rv.iter().enumerate() {
        let pct = (**count as f64 / total as f64 * 100.0 * 100.0).round() / 100.0;
        let comma = if i + 1 < rv.len() { "," } else { "" };
        let _ = writeln!(
            out,
            "    \"{round}\": {{ \"count\": {count}, \"method\": \"{}\", \"%\": {pct:.2} }}{comma}",
            method_name(**round)
        );
    }
    let _ = writeln!(out, "  }},");
    let _ = writeln!(out);
    let _ = writeln!(out, "  \"common_crfs\": [");
    let mut cv: Vec<_> = crf_counts.iter().collect();
    cv.sort_by(|(_, a), (_, b)| b.cmp(a));
    let top: Vec<_> = cv.iter().take(25).collect();
    for (i, (crf, count)) in top.iter().enumerate() {
        let comma = if i + 1 < top.len() { "," } else { "" };
        let _ = writeln!(
            out,
            "    {{ \"crf\": {:.2}, \"count\": {} }}{comma}",
            **crf as f64 / 100.0,
            **count
        );
    }
    let _ = writeln!(out, "  ]");
    let _ = write!(out, "}}");
    out
}

#[cfg(feature = "vship")]
#[derive(serde::Deserialize)]
struct TqChunkLine {
    id: usize,
    r: usize,
    f: usize,
    p: Vec<(f64, f64, u64)>,
    fc: f64,
    fs: f64,
    fz: u64,
}

#[cfg(feature = "vship")]
fn write_tq_log(input: &Path, work_dir: &Path, inf: &VidInf, metric_name: &str) {
    use std::fs::OpenOptions;
    use std::io::{BufRead, Write as IoWrite};

    let log_path = input.with_extension("json");
    let chunks_path = work_dir.join("chunks.json");
    let fps = f64::from(inf.fps_num) / f64::from(inf.fps_den);

    let mut all_logs: Vec<TqChunkLine> = Vec::new();
    if let Ok(file) = std::fs::File::open(&chunks_path) {
        for line in std::io::BufReader::new(file).lines().map_while(Result::ok) {
            if let Ok(cl) = sonic_rs::from_str::<TqChunkLine>(&line) {
                all_logs.push(cl);
            }
        }
    }
    if all_logs.is_empty() {
        return;
    }

    let mut round_counts: std::collections::BTreeMap<usize, usize> =
        std::collections::BTreeMap::new();
    let mut crf_counts: std::collections::BTreeMap<u64, usize> = std::collections::BTreeMap::new();
    for l in &all_logs {
        *round_counts.entry(l.p.len()).or_insert(0) += 1;
        *crf_counts.entry((l.fc * 100.0).round() as u64).or_insert(0) += 1;
    }
    all_logs.sort_by_key(|l| l.id);

    let out = format_tq_json(&all_logs, metric_name, fps, &round_counts, &crf_counts);
    if let Ok(mut file) = OpenOptions::new().create(true).write(true).truncate(true).open(&log_path)
    {
        let _ = file.write_all(out.as_bytes());
    }
}

#[cfg(feature = "libsvtav1")]
fn write_ivf_header(f: &mut impl std::io::Write, cfg: &EncConfig) {
    let mut hdr = [0u8; 32];
    hdr[0..4].copy_from_slice(b"DKIF");
    hdr[6..8].copy_from_slice(&32u16.to_le_bytes());
    hdr[8..12].copy_from_slice(b"AV01");
    hdr[12..14].copy_from_slice(&(cfg.width as u16).to_le_bytes());
    hdr[14..16].copy_from_slice(&(cfg.height as u16).to_le_bytes());
    hdr[16..20].copy_from_slice(&cfg.inf.fps_num.to_le_bytes());
    hdr[20..24].copy_from_slice(&cfg.inf.fps_den.to_le_bytes());
    let _ = f.write_all(&hdr);
}

#[cfg(feature = "libsvtav1")]
fn write_ivf_frame(f: &mut impl std::io::Write, data: &[u8], pts: u64) {
    let _ = f.write_all(&(data.len() as u32).to_le_bytes());
    let _ = f.write_all(&pts.to_le_bytes());
    let _ = f.write_all(data);
}

#[cfg(feature = "libsvtav1")]
fn drain_svt_packets(
    handle: *mut crate::svt::EbComponentType,
    out: &mut impl std::io::Write,
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
            write_ivf_frame(out, data, p.pts.cast_unsigned());
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
    ctx: &EncWorkerCtx,
    conv_buf: &mut [u8],
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

    let mut out = std::io::BufWriter::new(std::fs::File::create(cfg.output).unwrap());
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
    ctx.prog.update_lib_enc(worker_id, pkg.chunk.idx, (0, pkg.frame_count), 0.0, None, crf_score);

    #[allow(clippy::cast_possible_wrap)]
    for i in 0..pkg.frame_count {
        let frame = get_frame(&pkg.yuv, i, ctx.pipe.frame_size);
        if cfg.inf.is_10bit {
            (ctx.pipe.unpack)(frame, conv_buf, ctx.pipe);
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
        tracker.report(
            ctx.prog,
            worker_id,
            pkg.chunk.idx,
            pkg.frame_count,
            track_frames,
            crf_score,
        );
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
            write_ivf_frame(&mut out, data, p.pts.cast_unsigned());
            tracker.encoded += 1;
        }
        let is_eos = p.flags & EB_BUFFERFLAG_EOS != 0;
        unsafe { svt_av1_enc_release_out_buffer(&raw mut pkt) };
        tracker.report(
            ctx.prog,
            worker_id,
            pkg.chunk.idx,
            pkg.frame_count,
            track_frames,
            crf_score,
        );
        if is_eos {
            break;
        }
    }

    ctx.prog.clear_lib_enc(worker_id);

    unsafe {
        svt_av1_enc_deinit(handle);
        svt_av1_enc_deinit_handle(handle);
    }
}
