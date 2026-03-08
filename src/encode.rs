#[cfg(feature = "vship")]
use std::{
    collections::BTreeMap,
    fmt::Write as _,
    fs::{OpenOptions, copy},
    io::{BufRead as _, BufReader as StdBufReader},
    sync::OnceLock,
};
use std::{
    collections::HashSet,
    fs::{File, metadata},
    io::{BufWriter, Write},
    mem::{size_of, zeroed},
    panic::resume_unwind,
    path::{Path, PathBuf},
    ptr::null_mut,
    slice::from_raw_parts,
    sync::{
        Arc, Mutex,
        atomic::{AtomicU64, AtomicUsize, Ordering::Relaxed},
    },
    thread::{JoinHandle, spawn},
};

#[cfg(feature = "vship")]
use crossbeam_channel::Sender;
#[cfg(feature = "vship")]
use crossbeam_channel::select;
use crossbeam_channel::{Receiver, bounded};
#[cfg(feature = "vship")]
use sonic_rs::from_str;

#[cfg(feature = "vship")]
use crate::ffms::DecodeStrat;
use crate::{
    Args,
    chunk::{Chunk, ChunkComp, ResumeInf, get_resume, save_resume},
    decode::{decode_chunks, decode_pipe},
    encoder::{
        EncConfig, Encoder,
        Encoder::{Avm, SvtAv1, Vvenc, X264, X265},
        make_enc_cmd, set_svt_config,
    },
    error::fatal,
    ffms::{VidInf, conv_to_10bit},
    pipeline::Pipeline,
    progs::{LibEncTracker, ProgsTrack},
    svt::{
        EB_BUFFERFLAG_EOS, EB_ERROR_NONE, EbBufferHeaderType, EbComponentType,
        EbSvtAv1EncConfiguration, EbSvtIOFormat, svt_av1_enc_deinit, svt_av1_enc_deinit_handle,
        svt_av1_enc_get_packet, svt_av1_enc_init, svt_av1_enc_init_handle,
        svt_av1_enc_release_out_buffer, svt_av1_enc_send_picture, svt_av1_enc_set_parameter,
    },
    util::assume_unreachable,
    worker::{Semaphore, WorkPkg},
    y4m::PipeReader,
};
#[cfg(feature = "vship")]
use crate::{
    pipeline::MetricsProgress,
    tq::{Probe, ProbeLog, binary_search, interpolate_crf},
    vship::{VshipProcessor, init_device},
    worker::TQState,
};

#[cfg(feature = "vship")]
pub static TQ_SCORES: OnceLock<Mutex<Vec<f64>>> = OnceLock::new();

fn join_one(handle: JoinHandle<()>) {
    if let Err(e) = handle.join() {
        resume_unwind(e);
    }
}

fn join_all(handles: Vec<JoinHandle<()>>) {
    for h in handles {
        join_one(h);
    }
}

#[inline]
pub fn get_frame(frames: &[u8], i: usize, frame_size: usize) -> &[u8] {
    let start = i * frame_size;
    &frames[start..start + frame_size]
}

struct WorkerStats {
    completed: Arc<AtomicUsize>,
    completed_frames: Arc<AtomicUsize>,
    total_size: Arc<AtomicU64>,
    completions: Arc<Mutex<ResumeInf>>,
}

impl WorkerStats {
    fn new(completed_count: usize, resume_data: &ResumeInf) -> Self {
        let init_frames: usize = resume_data.chnks_done.iter().map(|c| c.frames).sum();
        let init_size: u64 = resume_data.chnks_done.iter().map(|c| c.size).sum();
        Self {
            completed: Arc::new(AtomicUsize::new(completed_count)),
            completed_frames: Arc::new(AtomicUsize::new(init_frames)),
            total_size: Arc::new(AtomicU64::new(init_size)),
            completions: Arc::new(Mutex::new(resume_data.clone())),
        }
    }

    fn add_completion(&self, completion: ChunkComp, work_dir: &Path) {
        self.completed_frames.fetch_add(completion.frames, Relaxed);
        self.total_size.fetch_add(completion.size, Relaxed);
        let mut data = unsafe { self.completions.lock().unwrap_unchecked() };
        data.chnks_done.push(completion);
        _ = save_resume(&data, work_dir);
        drop(data);
    }
}

fn load_resume_data(work_dir: &Path) -> ResumeInf {
    get_resume(work_dir).unwrap_or(ResumeInf {
        chnks_done: Vec::new(),
        prior_secs: 0,
    })
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

type SvtEncFn =
    fn(&mut Vec<u8>, &EncConfig, &EncWorkerCtx, &mut [u8], usize, bool, Option<(f32, Option<f64>)>);

struct EncWorkerCtx<'a> {
    inf: &'a VidInf,
    pipe: &'a Pipeline,
    work_dir: &'a Path,
    grain: Option<&'a Path>,
    prog: &'a Arc<ProgsTrack>,
    encoder: Encoder,
    svt_enc: SvtEncFn,
}

#[cfg(feature = "vship")]
struct TQWorkerCtx<'a> {
    inf: &'a VidInf,
    pipe: &'a Pipeline,
    work_dir: &'a Path,
    metric_mode: &'a str,
    prog: &'a Arc<ProgsTrack>,
    done_tx: &'a Sender<usize>,
    resume_state: &'a Arc<Mutex<ResumeInf>>,
    stats: Option<&'a Arc<WorkerStats>>,
    tq_logger: &'a Arc<Mutex<Vec<ProbeLog>>>,
    tq_ctx: &'a TQCtx,
    encoder: Encoder,
    use_probe_params: bool,
    worker_count: usize,
}

pub fn encode_all(
    chunks: &[Chunk],
    inf: &VidInf,
    args: &Args,
    path: &Path,
    work_dir: &Path,
    grain_table: Option<&PathBuf>,
    pipe_reader: Option<PipeReader>,
) {
    let resume_data = load_resume_data(work_dir);

    #[cfg(feature = "vship")]
    {
        let is_tq = args.target_quality.is_some() && args.qp_range.is_some();
        if is_tq {
            encode_tq(chunks, inf, args, path, work_dir, grain_table, pipe_reader);
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
        Arc::clone(&unsafe { stats.as_ref().unwrap_unchecked() }.completed),
        Arc::clone(&unsafe { stats.as_ref().unwrap_unchecked() }.completed_frames),
        Arc::clone(&unsafe { stats.as_ref().unwrap_unchecked() }.total_size),
    );
    let prog = Arc::new(prog);

    let strat = unsafe { args.decode_strat.unwrap_unchecked() };
    let (strat, svt_enc_fn): (_, SvtEncFn) =
        if args.encoder == SvtAv1 && inf.is_10bit && args.chunk_buffer == args.worker {
            (strat.to_raw(), enc_svt_direct)
        } else {
            (strat, enc_svt_drop)
        };
    let pipe = Pipeline::new(
        inf,
        strat,
        #[cfg(feature = "vship")]
        None,
    );

    let (tx, rx) = bounded::<WorkPkg>(args.chunk_buffer);
    let rx = Arc::new(rx);
    let sem = Arc::new(Semaphore::new(args.chunk_buffer));

    let decoder = {
        let chunks = chunks.to_vec();
        let path = path.to_path_buf();
        let inf = inf.clone();
        let sem = Arc::clone(&sem);
        spawn(move || {
            if let Some(mut reader) = pipe_reader {
                decode_pipe(&chunks, &mut reader, &inf, &tx, &skip_indices, strat, &sem);
            } else {
                decode_chunks(&chunks, &path, &inf, &tx, &skip_indices, strat, &sem);
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

        let handle = spawn(move || {
            let ctx = EncWorkerCtx {
                inf: &inf,
                pipe: &pipe,
                work_dir: &wd,
                grain: grain.as_deref(),
                prog: &prog_clone,
                encoder,
                svt_enc: svt_enc_fn,
            };
            run_enc_worker(
                &rx_clone,
                &params,
                &ctx,
                stats_clone.as_ref(),
                worker_id,
                &sem_clone,
            );
        });
        workers.push(handle);
    }

    join_one(decoder);
    join_all(workers);
    drop(prog);
    join_one(display_handle);
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
    fn best_probe<'a>(&self, probes: &'a [Probe]) -> &'a Probe {
        unsafe {
            probes
                .iter()
                .min_by(|a, b| {
                    (a.score - self.target)
                        .abs()
                        .total_cmp(&(b.score - self.target).abs())
                })
                .unwrap_unchecked()
        }
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
    best: &Probe,
) {
    let dst = ctx
        .work_dir
        .join("encode")
        .join(format!("{chunk_idx:04}.{}", ctx.encoder.extension()));
    if probe_path != dst {
        _ = copy(probe_path, &dst);
    }
    _ = ctx.done_tx.send(chunk_idx);

    let file_size = metadata(&dst).map_or(0, |m| m.len());
    let comp = ChunkComp {
        idx: chunk_idx,
        frames: chunk_frames,
        size: file_size,
    };

    let mut resume = unsafe { ctx.resume_state.lock().unwrap_unchecked() };
    resume.chnks_done.push(comp.clone());
    _ = save_resume(&resume, ctx.work_dir);
    drop(resume);

    if let Some(s) = ctx.stats {
        s.completed.fetch_add(1, Relaxed);
        s.completed_frames.fetch_add(comp.frames, Relaxed);
        s.total_size.fetch_add(comp.size, Relaxed);
    }

    let probes_with_size: Vec<(f64, f64, u64)> = tq_state
        .probes
        .iter()
        .map(|p| {
            let sz = tq_state
                .probe_sizes
                .iter()
                .find(|&&(c, _)| (c - p.crf).abs() < 0.001)
                .map_or(0, |&(_, s)| s);
            (p.crf, p.score, sz)
        })
        .collect();

    let log_entry = ProbeLog {
        chunk_idx,
        probes: probes_with_size,
        final_crf: best.crf,
        final_score: best.score,
        final_size: file_size,
        round: tq_state.round,
        frames: chunk_frames,
    };
    write_chunk_log(&log_entry, ctx.work_dir);
    unsafe { ctx.tq_logger.lock().unwrap_unchecked() }.push(log_entry);

    let mut tq_scores = unsafe {
        TQ_SCORES
            .get_or_init(|| Mutex::new(Vec::new()))
            .lock()
            .unwrap_unchecked()
    };
    if ctx.tq_ctx.use_cvvdp && !ctx.tq_ctx.cvvdp_per_frame {
        tq_scores.push(best.score);
    } else {
        let matched = unsafe {
            tq_state
                .probes
                .iter()
                .find(|p| (p.crf - best.crf).abs() < 0.001)
                .unwrap_unchecked()
        };
        tq_scores.extend_from_slice(&matched.frame_scores);
    }
}

#[cfg(feature = "vship")]
#[inline]
fn probe_path(dir: &Path, idx: usize, crf: f64, ext: &str) -> PathBuf {
    dir.join("split").join(format!("{idx:04}_{crf:.2}.{ext}"))
}

#[cfg(feature = "vship")]
fn run_metrics_worker(
    rx: &Arc<Receiver<WorkPkg>>,
    rework_tx: &Sender<WorkPkg>,
    ctx: &TQWorkerCtx,
    worker_id: usize,
) {
    let mut vship: Option<VshipProcessor> = None;
    let mut unpacked_buf = vec![
        0u8;
        if ctx.inf.is_10bit {
            ctx.pipe.conv_buf_size
        } else {
            0
        }
    ];

    while let Ok(mut pkg) = rx.recv() {
        let tq_st = unsafe { pkg.tq_state.as_ref().unwrap_unchecked() };
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
            let v = VshipProcessor::new(
                pkg.width,
                pkg.height,
                ctx.inf,
                ctx.tq_ctx.use_cvvdp,
                ctx.tq_ctx.use_butteraugli,
                Some("xav"),
                ctx.tq_ctx.cvvdp_config,
            )
            .unwrap_or_else(|e| fatal(e));
            vship = Some(v);
        }

        let tq_st = unsafe { pkg.tq_state.as_ref().unwrap_unchecked() };
        let crf = tq_st.last_crf;
        let pp = probe_path(ctx.work_dir, pkg.chunk.idx, crf, ctx.encoder.extension());
        let last_score = tq_st.probes.last().map(|probe| probe.score);
        let metrics_slot = ctx.worker_count + worker_id;

        let probe_size = metadata(&pp).map_or(0, |m| m.len());
        unsafe { pkg.tq_state.as_mut().unwrap_unchecked() }
            .probe_sizes
            .push((crf, probe_size));

        let mp = MetricsProgress {
            prog: ctx.prog,
            slot: metrics_slot,
            crf: crf as f32,
            last_score,
        };
        let (score, frame_scores) = (ctx.pipe.calc_metrics)(
            &pkg,
            &pp,
            ctx.pipe,
            unsafe { vship.as_ref().unwrap_unchecked() },
            ctx.metric_mode,
            &mut unpacked_buf,
            &mp,
        );

        let tq_state = unsafe { pkg.tq_state.as_mut().unwrap_unchecked() };
        tq_state.probes.push(Probe {
            crf,
            score,
            frame_scores,
        });

        let should_complete = ctx.tq_ctx.converged(score)
            || tq_state.round > 10
            || ctx.tq_ctx.update_bounds_and_check(tq_state, score);

        if should_complete {
            let best = ctx.tq_ctx.best_probe(&tq_state.probes);
            if ctx.use_probe_params {
                tq_state.final_encode = true;
                tq_state.last_crf = best.crf;
                _ = rework_tx.send(pkg);
            } else {
                let bp = probe_path(
                    ctx.work_dir,
                    pkg.chunk.idx,
                    best.crf,
                    ctx.encoder.extension(),
                );
                complete_chunk(pkg.chunk.idx, pkg.frame_count, &bp, ctx, tq_state, best);
            }
        } else {
            _ = rework_tx.send(pkg);
        }
    }
}

#[cfg(feature = "vship")]
fn parse_tq_ctx(args: &Args) -> TQCtx {
    let tq_str = unsafe { args.target_quality.as_ref().unwrap_unchecked() };
    let qp_str = unsafe { args.qp_range.as_ref().unwrap_unchecked() };
    let tq_parts: Vec<f64> = tq_str.split('-').filter_map(|s| s.parse().ok()).collect();
    let qp_parts: Vec<f64> = qp_str.split('-').filter_map(|s| s.parse().ok()).collect();
    let tq_target = f64::midpoint(tq_parts[0], tq_parts[1]);
    let cvvdp_config: Option<&'static str> = args
        .cvvdp_config
        .as_ref()
        .map(|s| Box::leak(s.clone().into_boxed_str()) as &'static str);
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
    decode_rx: &Receiver<WorkPkg>,
    rework_rx: &Receiver<WorkPkg>,
    done_rx: &Receiver<usize>,
    enc_tx: &Sender<WorkPkg>,
    total_chunks: usize,
    permits: &Semaphore,
) {
    let mut completed = 0;
    while completed < total_chunks {
        select! {
            recv(decode_rx) -> pkg => { if let Ok(pkg) = pkg { _ =enc_tx.send(pkg); } }
            recv(rework_rx) -> pkg => { if let Ok(pkg) = pkg { _ =enc_tx.send(pkg); } }
            recv(done_rx) -> result => { if result.is_ok() { permits.release(); completed += 1; } }
        }
    }
}

#[cfg(feature = "vship")]
#[inline]
fn tq_search_crf(tq: &mut TQState, encoder: Encoder) -> f64 {
    tq.round += 1;
    let c = if tq.round <= 2 {
        binary_search(tq.search_min, tq.search_max)
    } else {
        interpolate_crf(&tq.probes, tq.target, tq.round)
            .unwrap_or_else(|| binary_search(tq.search_min, tq.search_max))
    }
    .clamp(tq.search_min, tq.search_max);
    let c = if encoder.integer_qp() { c.round() } else { c };
    tq.last_crf = c;
    c
}

#[cfg(feature = "vship")]
fn tq_enc_loop(
    rx: &Receiver<WorkPkg>,
    tx: &Sender<WorkPkg>,
    ctx: &EncWorkerCtx,
    params: &str,
    probe_params: Option<&str>,
    tq_ctx: &TQCtx,
    worker_id: usize,
) {
    let mut conv_buf = vec![0u8; ctx.pipe.conv_buf_size];
    while let Ok(mut pkg) = rx.recv() {
        let tq = pkg.tq_state.get_or_insert_with(|| TQState {
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
        let crf = if is_final {
            tq.last_crf
        } else {
            tq_search_crf(tq, ctx.encoder)
        };
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
        enc_tq_probe(
            &mut pkg,
            crf,
            p,
            ctx,
            &mut conv_buf,
            worker_id,
            out.as_deref(),
        );
        _ = tx.send(pkg);
    }
}

#[cfg(feature = "vship")]
struct TQDecodeResult {
    enc_tx: Sender<WorkPkg>,
    enc_rx: Receiver<WorkPkg>,
    rework_tx: Sender<WorkPkg>,
    done_tx: Sender<usize>,
    handle: JoinHandle<()>,
}

#[cfg(feature = "vship")]
fn spawn_tq_decode(
    chunks: &[Chunk],
    path: &Path,
    inf: &VidInf,
    skip: HashSet<usize>,
    strat: DecodeStrat,
    permits: &Arc<Semaphore>,
    pipe_reader: Option<PipeReader>,
) -> TQDecodeResult {
    let total = chunks.iter().filter(|c| !skip.contains(&c.idx)).count();
    let (enc_tx, enc_rx) = bounded::<WorkPkg>(2);
    let (rework_tx, rework_rx) = bounded::<WorkPkg>(2);
    let (done_tx, done_rx) = bounded::<usize>(4);

    let chunks = chunks.to_vec();
    let path = path.to_path_buf();
    let inf = inf.clone();
    let enc_tx2 = enc_tx.clone();
    let permits_dec = Arc::clone(permits);
    let permits_done = Arc::clone(permits);
    let handle = spawn(move || {
        let (dtx, drx) = bounded::<WorkPkg>(2);
        let inf2 = inf.clone();
        let dec = spawn(move || {
            if let Some(mut r) = pipe_reader {
                decode_pipe(&chunks, &mut r, &inf2, &dtx, &skip, strat, &permits_dec);
            } else {
                decode_chunks(&chunks, &path, &inf2, &dtx, &skip, strat, &permits_dec);
            }
        });
        tq_coordinate(&drx, &rework_rx, &done_rx, &enc_tx2, total, &permits_done);
        join_one(dec);
    });
    TQDecodeResult {
        enc_tx,
        enc_rx,
        rework_tx,
        done_tx,
        handle,
    }
}

#[cfg(feature = "vship")]
fn encode_tq(
    chunks: &[Chunk],
    inf: &VidInf,
    args: &Args,
    path: &Path,
    work_dir: &Path,
    grain_table: Option<&PathBuf>,
    pipe_reader: Option<PipeReader>,
) {
    let resume_data = load_resume_data(work_dir);
    let (skip_indices, completed_count, completed_frames) = build_skip_set(&resume_data);
    let tq_ctx = parse_tq_ctx(args);
    let strat = unsafe { args.decode_strat.unwrap_unchecked() };
    let pipe = Pipeline::new(inf, strat, args.target_quality.as_deref());
    let permits = Arc::new(Semaphore::new(args.chunk_buffer));

    let dec = spawn_tq_decode(
        chunks,
        path,
        inf,
        skip_indices,
        strat,
        &permits,
        pipe_reader,
    );
    let (met_tx, met_rx) = bounded::<WorkPkg>(2);
    let (enc_rx, met_rx) = (Arc::new(dec.enc_rx), Arc::new(met_rx));

    let resume_state = Arc::new(Mutex::new(resume_data.clone()));
    let tq_logger = Arc::new(Mutex::new(Vec::new()));
    let stats = create_stats(completed_count, &resume_data);
    let (prog, display_handle) = ProgsTrack::new(
        chunks,
        inf,
        args.worker + args.metric_worker,
        completed_frames,
        Arc::clone(&stats.completed),
        Arc::clone(&stats.completed_frames),
        Arc::clone(&stats.total_size),
    );
    let stats = Some(stats);
    let prog = Arc::new(prog);
    let sc = TQSpawnCtx {
        inf,
        pipe: &pipe,
        work_dir,
        args,
        prog: &prog,
        stats,
        resume_state: &resume_state,
        tq_logger: &tq_logger,
        tq_ctx,
        encoder: args.encoder,
        use_probe_params: args.probe_params.is_some(),
        worker_count: args.worker,
    };

    let metrics_workers = spawn_tq_metrics(
        args.metric_worker,
        &met_rx,
        &dec.rework_tx,
        &dec.done_tx,
        &sc,
    );

    let workers = spawn_tq_encoders(&enc_rx, &met_tx, &sc, grain_table);

    init_device().unwrap_or_else(|e| fatal(e));
    join_one(dec.handle);
    drop(dec.enc_tx);
    join_all(workers);
    drop(dec.rework_tx);
    drop(met_tx);
    join_all(metrics_workers);

    write_tq_log(&args.input, work_dir, inf, sc.tq_ctx.metric_name());
    drop(prog);
    join_one(display_handle);
}

#[cfg(feature = "vship")]
struct TQSpawnCtx<'a> {
    inf: &'a VidInf,
    pipe: &'a Pipeline,
    work_dir: &'a Path,
    args: &'a Args,
    prog: &'a Arc<ProgsTrack>,
    stats: Option<Arc<WorkerStats>>,
    resume_state: &'a Arc<Mutex<ResumeInf>>,
    tq_logger: &'a Arc<Mutex<Vec<ProbeLog>>>,
    tq_ctx: TQCtx,
    encoder: Encoder,
    use_probe_params: bool,
    worker_count: usize,
}

#[cfg(feature = "vship")]
fn spawn_tq_metrics(
    metric_worker: usize,
    met_rx: &Arc<Receiver<WorkPkg>>,
    rework_tx: &Sender<WorkPkg>,
    done_tx: &Sender<usize>,
    sc: &TQSpawnCtx,
) -> Vec<JoinHandle<()>> {
    let mut metrics_workers = Vec::new();
    for worker_id in 0..metric_worker {
        let (rx, rework_tx) = (Arc::clone(met_rx), rework_tx.clone());
        let done_tx = done_tx.clone();
        let (inf, pipe, wd) = (sc.inf.clone(), sc.pipe.clone(), sc.work_dir.to_path_buf());
        let (metric_mode, st) = (sc.args.metric_mode.clone(), sc.stats.clone());
        let (resume_state, tq_logger, prog_clone) = (
            Arc::clone(sc.resume_state),
            Arc::clone(sc.tq_logger),
            Arc::clone(sc.prog),
        );
        let (tq_ctx, encoder, use_probe_params, worker_count) =
            (sc.tq_ctx, sc.encoder, sc.use_probe_params, sc.worker_count);
        metrics_workers.push(spawn(move || {
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
    metrics_workers
}

#[cfg(feature = "vship")]
fn spawn_tq_encoders(
    enc_rx: &Arc<Receiver<WorkPkg>>,
    met_tx: &Sender<WorkPkg>,
    sc: &TQSpawnCtx,
    grain_table: Option<&PathBuf>,
) -> Vec<JoinHandle<()>> {
    let mut workers = Vec::new();
    for worker_id in 0..sc.worker_count {
        let (rx, tx) = (Arc::clone(enc_rx), met_tx.clone());
        let (inf, pipe, wd) = (sc.inf.clone(), sc.pipe.clone(), sc.work_dir.to_path_buf());
        let (params, probe_params, grain) = (
            sc.args.params.clone(),
            sc.args.probe_params.clone(),
            grain_table.cloned(),
        );
        let prog_clone = Arc::clone(sc.prog);
        let (tq_ctx, encoder) = (sc.tq_ctx, sc.encoder);
        workers.push(spawn(move || {
            let ctx = EncWorkerCtx {
                inf: &inf,
                pipe: &pipe,
                work_dir: &wd,
                grain: grain.as_deref(),
                prog: &prog_clone,
                encoder,
                svt_enc: enc_svt_lib,
            };
            tq_enc_loop(
                &rx,
                &tx,
                &ctx,
                &params,
                probe_params.as_deref(),
                &tq_ctx,
                worker_id,
            );
        }));
    }
    workers
}

#[cfg(feature = "vship")]
fn enc_tq_probe(
    pkg: &mut WorkPkg,
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
        default_out = probe_path(ctx.work_dir, pkg.chunk.idx, crf, ctx.encoder.extension());
        &default_out
    };
    if ctx.encoder == SvtAv1 {
        let last_score = pkg
            .tq_state
            .as_ref()
            .and_then(|tq| tq.probes.last().map(|probe| probe.score));
        let cfg = EncConfig {
            inf: ctx.inf,
            params,
            zone_params: pkg.chunk.params.as_deref(),
            crf: crf as f32,
            output: out,
            grain_table: ctx.grain,
            chunk_idx: pkg.chunk.idx,
            width: pkg.width,
            height: pkg.height,
            frames: pkg.frame_count,
        };
        (ctx.svt_enc)(
            &mut pkg.yuv,
            &cfg,
            ctx,
            conv_buf,
            worker_id,
            false,
            Some((crf as f32, last_score)),
        );
        return out.to_path_buf();
    }
    let cfg = EncConfig {
        inf: ctx.inf,
        params,
        zone_params: pkg.chunk.params.as_deref(),
        crf: crf as f32,
        output: out,
        grain_table: ctx.grain,
        chunk_idx: pkg.chunk.idx,
        width: pkg.width,
        height: pkg.height,
        frames: pkg.frame_count,
    };

    let mut cmd = make_enc_cmd(ctx.encoder, &cfg);
    let mut child = cmd.spawn().unwrap_or_else(|e| fatal(e));

    let last_score = pkg
        .tq_state
        .as_ref()
        .and_then(|tq| tq.probes.last().map(|probe| probe.score));
    match ctx.encoder {
        SvtAv1 => assume_unreachable(),
        X265 | X264 => ctx.prog.watch_enc(
            unsafe { child.stderr.take().unwrap_unchecked() },
            worker_id,
            pkg.chunk.idx,
            false,
            Some((crf as f32, last_score)),
            ctx.encoder,
        ),
        Avm | Vvenc => ctx.prog.watch_enc(
            unsafe { child.stdout.take().unwrap_unchecked() },
            worker_id,
            pkg.chunk.idx,
            false,
            Some((crf as f32, last_score)),
            ctx.encoder,
        ),
    }
    (ctx.pipe.write_frames)(
        unsafe { child.stdin.as_mut().unwrap_unchecked() },
        &pkg.yuv,
        pkg.frame_count,
        conv_buf,
        ctx.pipe,
    );

    let status = child.wait().unwrap_or_else(|e| fatal(e));
    if !status.success() {
        fatal(format_args!("probe encode failed: {}", out.display()));
    }

    out.to_path_buf()
}

fn run_enc_worker(
    rx: &Arc<Receiver<WorkPkg>>,
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
            s.completed.fetch_add(1, Relaxed);
            let out = ctx.work_dir.join("encode").join(format!(
                "{:04}.{}",
                pkg.chunk.idx,
                ctx.encoder.extension()
            ));
            let file_size = metadata(&out).map_or(0, |m| m.len());
            let comp = ChunkComp {
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
    pkg: &mut WorkPkg,
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
    if ctx.encoder == SvtAv1 {
        let cfg = EncConfig {
            inf: ctx.inf,
            params,
            zone_params: pkg.chunk.params.as_deref(),
            crf,
            output: &out,
            grain_table: ctx.grain,
            chunk_idx: pkg.chunk.idx,
            width: pkg.width,
            height: pkg.height,
            frames: pkg.frame_count,
        };
        (ctx.svt_enc)(&mut pkg.yuv, &cfg, ctx, conv_buf, worker_id, true, None);
        return;
    }
    let cfg = EncConfig {
        inf: ctx.inf,
        params,
        zone_params: pkg.chunk.params.as_deref(),
        crf,
        output: &out,
        grain_table: ctx.grain,
        chunk_idx: pkg.chunk.idx,
        width: pkg.width,
        height: pkg.height,
        frames: pkg.frame_count,
    };

    let mut cmd = make_enc_cmd(ctx.encoder, &cfg);
    let mut child = cmd.spawn().unwrap_or_else(|e| fatal(e));

    match ctx.encoder {
        SvtAv1 => assume_unreachable(),
        X265 | X264 => ctx.prog.watch_enc(
            unsafe { child.stderr.take().unwrap_unchecked() },
            worker_id,
            pkg.chunk.idx,
            true,
            None,
            ctx.encoder,
        ),
        Avm | Vvenc => ctx.prog.watch_enc(
            unsafe { child.stdout.take().unwrap_unchecked() },
            worker_id,
            pkg.chunk.idx,
            true,
            None,
            ctx.encoder,
        ),
    }

    (ctx.pipe.write_frames)(
        unsafe { child.stdin.as_mut().unwrap_unchecked() },
        &pkg.yuv,
        pkg.frame_count,
        conv_buf,
        ctx.pipe,
    );
    pkg.yuv = Vec::new();

    let status = child.wait().unwrap_or_else(|e| fatal(e));
    if !status.success() {
        fatal(format_args!("encode failed: chunk {:04}", pkg.chunk.idx));
    }
}

#[cfg(feature = "vship")]
pub fn write_chunk_log(chunk_log: &ProbeLog, work_dir: &Path) {
    let chunks_path = work_dir.join("chunks.json");
    let probes_str = chunk_log
        .probes
        .iter()
        .map(|&(c, s, sz)| format!("[{c:.2},{s:.4},{sz}]"))
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

    if let Ok(mut file) = OpenOptions::new()
        .create(true)
        .append(true)
        .open(chunks_path)
    {
        _ = file.write_all(line.as_bytes());
    }
}

#[cfg(feature = "vship")]
fn format_tq_json(
    all_logs: &[TqChunkLine],
    metric_name: &str,
    fps: f64,
    round_counts: &BTreeMap<usize, usize>,
    crf_counts: &BTreeMap<u64, usize>,
) -> String {
    let total = all_logs.len();
    let avg_probes = all_logs.iter().map(|l| l.p.len()).sum::<usize>() as f64 / total as f64;
    let in_range = all_logs.iter().filter(|l| l.r <= 6).count();

    let calc_kbs = |size: u64, frames: usize| -> f64 {
        let d = frames as f64 / fps;
        if d > 0.0 {
            (size as f64 * 8.0) / d / 1000.0
        } else {
            0.0
        }
    };

    let method_name = |round: usize| match round {
        1 | 2 => "binary",
        3 => "linear",
        4 => "fritsch_carlson",
        5 => "pchip",
        _ => "akima",
    };

    let mut out = String::new();
    _ = writeln!(out, "{{");
    _ = writeln!(out, "  \"chunks_{metric_name}\": [");

    for (i, l) in all_logs.iter().enumerate() {
        let mut sp: Vec<_> = l.p.iter().collect();
        sp.sort_by(|&&(a, ..), &&(b, ..)| a.total_cmp(&b));
        _ = writeln!(out, "    {{");
        _ = writeln!(out, "      \"id\": {},", l.id);
        _ = writeln!(out, "      \"probes\": [");
        for (j, &&(c, s, sz)) in sp.iter().enumerate() {
            let comma = if j + 1 < sp.len() { "," } else { "" };
            _ = writeln!(
                out,
                "        {{ \"crf\": {c:.2}, \"score\": {s:.3}, \"kbs\": {:.0} }}{comma}",
                calc_kbs(sz, l.f)
            );
        }
        _ = writeln!(out, "      ],");
        _ = writeln!(
            out,
            "      \"final\": {{ \"crf\": {:.2}, \"score\": {:.3}, \"kbs\": {:.0} }}",
            l.fc,
            l.fs,
            calc_kbs(l.fz, l.f)
        );
        let comma = if i + 1 < all_logs.len() { "," } else { "" };
        _ = writeln!(out, "    }}{comma}");
        if i + 1 < all_logs.len() {
            _ = writeln!(out);
        }
    }

    _ = writeln!(out, "  ],");
    _ = writeln!(out);
    _ = writeln!(
        out,
        "  \"average_probes\": {:.1},",
        (avg_probes * 10.0).round() / 10.0
    );
    _ = writeln!(out, "  \"in_range\": {in_range},");
    _ = writeln!(out, "  \"out_range\": {},", total - in_range);
    _ = writeln!(out);
    _ = writeln!(out, "  \"rounds\": {{");
    let rv: Vec<_> = round_counts.iter().collect();
    for (i, &(round, count)) in rv.iter().enumerate() {
        let pct = (*count as f64 / total as f64 * 100.0 * 100.0).round() / 100.0;
        let comma = if i + 1 < rv.len() { "," } else { "" };
        _ = writeln!(
            out,
            "    \"{round}\": {{ \"count\": {count}, \"method\": \"{}\", \"%\": {pct:.2} }}{comma}",
            method_name(*round)
        );
    }
    _ = writeln!(out, "  }},");
    _ = writeln!(out);
    _ = writeln!(out, "  \"common_crfs\": [");
    let mut cv: Vec<_> = crf_counts.iter().collect();
    cv.sort_by(|&(_, a), &(_, b)| b.cmp(a));
    let top: Vec<_> = cv.iter().take(25).collect();
    for (i, &&(&crf, &count)) in top.iter().enumerate() {
        let comma = if i + 1 < top.len() { "," } else { "" };
        _ = writeln!(
            out,
            "    {{ \"crf\": {:.2}, \"count\": {} }}{comma}",
            crf as f64 / 100.0,
            count
        );
    }
    _ = writeln!(out, "  ]");
    _ = write!(out, "}}");
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
    let log_path = input.with_extension("json");
    let chunks_path = work_dir.join("chunks.json");
    let fps = f64::from(inf.fps_num) / f64::from(inf.fps_den);

    let mut all_logs: Vec<TqChunkLine> = Vec::new();
    if let Ok(file) = File::open(&chunks_path) {
        for line in StdBufReader::new(file).lines().map_while(Result::ok) {
            if let Ok(cl) = from_str::<TqChunkLine>(&line) {
                all_logs.push(cl);
            }
        }
    }
    if all_logs.is_empty() {
        return;
    }

    let mut round_counts: BTreeMap<usize, usize> = BTreeMap::new();
    let mut crf_counts: BTreeMap<u64, usize> = BTreeMap::new();
    for l in &all_logs {
        *round_counts.entry(l.p.len()).or_insert(0) += 1;
        *crf_counts.entry((l.fc * 100.0).round() as u64).or_insert(0) += 1;
    }
    all_logs.sort_by_key(|l| l.id);

    let out = format_tq_json(&all_logs, metric_name, fps, &round_counts, &crf_counts);
    if let Ok(mut file) = OpenOptions::new()
        .create(true)
        .write(true)
        .truncate(true)
        .open(&log_path)
    {
        _ = file.write_all(out.as_bytes());
    }
}

fn write_ivf_header(f: &mut impl Write, cfg: &EncConfig) {
    let mut hdr = [0u8; 32];
    hdr[0..4].copy_from_slice(b"DKIF");
    hdr[6..8].copy_from_slice(&32u16.to_le_bytes());
    hdr[8..12].copy_from_slice(b"AV01");
    hdr[12..14].copy_from_slice(&(cfg.width as u16).to_le_bytes());
    hdr[14..16].copy_from_slice(&(cfg.height as u16).to_le_bytes());
    hdr[16..20].copy_from_slice(&cfg.inf.fps_num.to_le_bytes());
    hdr[20..24].copy_from_slice(&cfg.inf.fps_den.to_le_bytes());
    _ = f.write_all(&hdr);
}

fn write_ivf_frame(f: &mut impl Write, data: &[u8], pts: u64) {
    _ = f.write_all(&(data.len() as u32).to_le_bytes());
    _ = f.write_all(&pts.to_le_bytes());
    _ = f.write_all(data);
}

fn drain_svt_packets(handle: *mut EbComponentType, out: &mut impl Write, done: bool) -> usize {
    let mut count = 0;
    loop {
        let mut pkt: *mut EbBufferHeaderType = null_mut();
        let ret = unsafe { svt_av1_enc_get_packet(handle, &raw mut pkt, u8::from(done)) };
        if ret != EB_ERROR_NONE {
            break;
        }
        let p = unsafe { &*pkt };
        if p.n_filled_len > 0 {
            let data = unsafe { from_raw_parts(p.p_buffer, p.n_filled_len as usize) };
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

fn init_svt(cfg: &EncConfig) -> *mut EbComponentType {
    let mut handle: *mut EbComponentType = null_mut();
    let mut config = unsafe { zeroed::<EbSvtAv1EncConfiguration>() };
    let ret = unsafe { svt_av1_enc_init_handle(&raw mut handle, &raw mut config) };
    if ret != EB_ERROR_NONE {
        fatal(format_args!("svt_av1_enc_init_handle failed: {ret}"));
    }
    set_svt_config(&raw mut config, cfg);
    let ret = unsafe { svt_av1_enc_set_parameter(handle, &raw mut config) };
    if ret != EB_ERROR_NONE {
        fatal(format_args!("svt_av1_enc_set_parameter failed: {ret}"));
    }
    let ret = unsafe { svt_av1_enc_init(handle) };
    if ret != EB_ERROR_NONE {
        fatal(format_args!("svt_av1_enc_init failed: {ret}"));
    }
    handle
}

fn send_svt_conv(
    yuv: &[u8],
    cfg: &EncConfig,
    ctx: &EncWorkerCtx,
    conv_buf: &mut [u8],
    worker_id: usize,
    track_frames: bool,
    crf_score: Option<(f32, Option<f64>)>,
) -> (*mut EbComponentType, BufWriter<File>, LibEncTracker) {
    let handle = init_svt(cfg);
    let mut out = BufWriter::new(File::create(cfg.output).unwrap_or_else(|e| fatal(e)));
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
    let io_ptr = &raw mut io_fmt;

    let mut in_hdr = unsafe { zeroed::<EbBufferHeaderType>() };
    in_hdr.size = size_of::<EbBufferHeaderType>() as u32;
    in_hdr.p_buffer = io_ptr.cast::<u8>();
    in_hdr.n_filled_len = (y_size + uv_size * 2) as u32;
    in_hdr.n_alloc_len = in_hdr.n_filled_len;

    let mut tracker = LibEncTracker::new(
        worker_id,
        cfg.chunk_idx,
        cfg.frames,
        track_frames,
        crf_score,
    );
    ctx.prog.update_lib_enc(
        worker_id,
        cfg.chunk_idx,
        (0, cfg.frames),
        0.0,
        None,
        crf_score,
    );

    let is_raw = ctx.pipe.conv_buf_size == 0;
    for i in 0..cfg.frames {
        let frame = get_frame(yuv, i, ctx.pipe.frame_size);
        if is_raw {
            unsafe {
                (*io_ptr).luma = frame.as_ptr().cast_mut();
                (*io_ptr).cb = frame[y_size..].as_ptr().cast_mut();
                (*io_ptr).cr = frame[y_size + uv_size..].as_ptr().cast_mut();
            }
        } else if cfg.inf.is_10bit {
            (ctx.pipe.unpack)(frame, conv_buf, ctx.pipe);
        } else {
            conv_to_10bit(frame, conv_buf);
        }

        in_hdr.pts = i as i64;
        in_hdr.flags = 0;

        let ret = unsafe { svt_av1_enc_send_picture(handle, &raw mut in_hdr) };
        if ret != EB_ERROR_NONE {
            fatal(format_args!(
                "svt_av1_enc_send_picture failed at frame {i}: {ret}"
            ));
        }

        tracker.encoded += drain_svt_packets(handle, &mut out, false);
        tracker.report(ctx.prog);
    }

    (handle, out, tracker)
}

#[cfg(feature = "vship")]
fn enc_svt_lib(
    yuv: &mut Vec<u8>,
    cfg: &EncConfig,
    ctx: &EncWorkerCtx,
    conv_buf: &mut [u8],
    worker_id: usize,
    track_frames: bool,
    crf_score: Option<(f32, Option<f64>)>,
) {
    let (handle, mut out, mut tracker) = send_svt_conv(
        yuv.as_slice(),
        cfg,
        ctx,
        conv_buf,
        worker_id,
        track_frames,
        crf_score,
    );
    finish_svt(handle, &mut out, &mut tracker, ctx.prog);
}

fn enc_svt_drop(
    yuv: &mut Vec<u8>,
    cfg: &EncConfig,
    ctx: &EncWorkerCtx,
    conv_buf: &mut [u8],
    worker_id: usize,
    track_frames: bool,
    crf_score: Option<(f32, Option<f64>)>,
) {
    let (handle, mut out, mut tracker) =
        send_svt_conv(yuv, cfg, ctx, conv_buf, worker_id, track_frames, crf_score);
    *yuv = Vec::new();
    finish_svt(handle, &mut out, &mut tracker, ctx.prog);
}

fn enc_svt_direct(
    yuv: &mut Vec<u8>,
    cfg: &EncConfig,
    ctx: &EncWorkerCtx,
    _conv_buf: &mut [u8],
    worker_id: usize,
    track_frames: bool,
    crf_score: Option<(f32, Option<f64>)>,
) {
    let handle = init_svt(cfg);
    let mut out = BufWriter::new(File::create(cfg.output).unwrap_or_else(|e| fatal(e)));
    write_ivf_header(&mut out, cfg);

    let w = cfg.width as usize;
    let h = cfg.height as usize;
    let y_size = w * h * 2;
    let uv_size = (w / 2) * (h / 2) * 2;

    let mut io_fmt = EbSvtIOFormat {
        luma: null_mut(),
        cb: null_mut(),
        cr: null_mut(),
        y_stride: w as u32,
        cb_stride: (w / 2) as u32,
        cr_stride: (w / 2) as u32,
    };
    let io_ptr = &raw mut io_fmt;

    let mut in_hdr = unsafe { zeroed::<EbBufferHeaderType>() };
    in_hdr.size = size_of::<EbBufferHeaderType>() as u32;
    in_hdr.p_buffer = io_ptr.cast::<u8>();
    in_hdr.n_filled_len = (y_size + uv_size * 2) as u32;
    in_hdr.n_alloc_len = in_hdr.n_filled_len;

    let mut tracker = LibEncTracker::new(
        worker_id,
        cfg.chunk_idx,
        cfg.frames,
        track_frames,
        crf_score,
    );
    ctx.prog.update_lib_enc(
        worker_id,
        cfg.chunk_idx,
        (0, cfg.frames),
        0.0,
        None,
        crf_score,
    );

    for i in 0..cfg.frames {
        let off = i * ctx.pipe.frame_size;
        unsafe {
            (*io_ptr).luma = yuv[off..].as_ptr().cast_mut();
            (*io_ptr).cb = yuv[off + y_size..].as_ptr().cast_mut();
            (*io_ptr).cr = yuv[off + y_size + uv_size..].as_ptr().cast_mut();
        }

        in_hdr.pts = i as i64;
        in_hdr.flags = 0;

        let ret = unsafe { svt_av1_enc_send_picture(handle, &raw mut in_hdr) };
        if ret != EB_ERROR_NONE {
            fatal(format_args!(
                "svt_av1_enc_send_picture failed at frame {i}: {ret}"
            ));
        }

        tracker.encoded += drain_svt_packets(handle, &mut out, false);
        tracker.report(ctx.prog);
    }
    *yuv = Vec::new();

    finish_svt(handle, &mut out, &mut tracker, ctx.prog);
}

fn finish_svt(
    handle: *mut EbComponentType,
    out: &mut BufWriter<File>,
    tracker: &mut LibEncTracker,
    prog: &ProgsTrack,
) {
    let mut eos = unsafe { zeroed::<EbBufferHeaderType>() };
    eos.flags = EB_BUFFERFLAG_EOS;
    unsafe { svt_av1_enc_send_picture(handle, &raw mut eos) };

    loop {
        let mut pkt: *mut EbBufferHeaderType = null_mut();
        let ret = unsafe { svt_av1_enc_get_packet(handle, &raw mut pkt, 1) };
        if ret != EB_ERROR_NONE {
            break;
        }
        let p = unsafe { &*pkt };
        if p.n_filled_len > 0 {
            let data = unsafe { from_raw_parts(p.p_buffer, p.n_filled_len as usize) };
            write_ivf_frame(out, data, p.pts.cast_unsigned());
            tracker.encoded += 1;
        }
        let is_eos = p.flags & EB_BUFFERFLAG_EOS != 0;
        unsafe { svt_av1_enc_release_out_buffer(&raw mut pkt) };
        tracker.report(prog);
        if is_eos {
            break;
        }
    }

    prog.clear_lib_enc(tracker.worker_id);

    unsafe {
        svt_av1_enc_deinit(handle);
        svt_av1_enc_deinit_handle(handle);
    }
}
