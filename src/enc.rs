#[cfg(feature = "vship")]
use std::{
    collections::BTreeMap,
    fmt::Write as _,
    fs::{OpenOptions, copy, write},
    io::{BufRead as _, BufReader as StdBufReader},
    mem::swap,
    path::PathBuf,
};
use std::{
    collections::HashSet,
    fs::{File, metadata},
    hint::cold_path,
    io::{BufWriter, Write},
    mem::{size_of, zeroed},
    panic::resume_unwind,
    path::Path,
    process::Child,
    ptr::{copy_nonoverlapping, null_mut},
    slice::from_raw_parts,
    sync::{
        Arc, Mutex, OnceLock,
        atomic::{AtomicU64, AtomicUsize, Ordering::Relaxed},
    },
    thread::{JoinHandle, spawn},
};
#[cfg(feature = "vship")]
use std::thread::available_parallelism;

use crossbeam_channel::{Receiver, bounded};
#[cfg(feature = "vship")]
use {
    crossbeam_channel::{Sender, select},
    serde::Deserialize,
    sonic_rs::from_str,
};

#[cfg(feature = "vship")]
use crate::interp::bisect;
use crate::{
    Args,
    chunk::{Chunk, ChunkComp, ResumeInf, get_resume, save_resume},
    dec::{dec_chnks, dec_pipe},
    encoder::{
        EncConfig, Encoder,
        Encoder::{Avm, SvtAv1, Vvenc, X264, X265},
        SVT_CONF_SIZE, make_enc_cmd, set_svt_base, set_svt_chunk,
    },
    error::fatal,
    ffms::{DecStrat, VidInf, nv12_10b, nv12_10b_rem},
    pack::{SHIFT_CHUNK, conv_10b, conv_10b_rem},
    pipeline::Pipeline,
    progs::{LibEncTracker, ProgsTrack, Watch},
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
    pipeline::MetricProgs,
    tq::{Probe, ProbeDec, ProbeLog, interpolate_crf, make_dav1d, make_ff},
    vship::{PinnedBuf, VshipProcessor, init_device},
    worker::TQState,
};

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
pub fn get_frame(frames: &[u8], i: usize, frame_sz: usize) -> &[u8] {
    let start = i * frame_sz;
    &frames[start..start + frame_sz]
}

struct WorkerStats {
    completed: Arc<AtomicUsize>,
    completed_frames: Arc<AtomicUsize>,
    tot_sz: Arc<AtomicU64>,
    completions: Arc<Mutex<ResumeInf>>,
}

impl WorkerStats {
    fn new(completed_cnt: usize, resume_data: &ResumeInf) -> Self {
        let init_frames: usize = resume_data.chnks_done.iter().map(|c| c.frames).sum();
        let init_sz: u64 = resume_data.chnks_done.iter().map(|c| c.sz).sum();
        Self {
            completed: Arc::new(AtomicUsize::new(completed_cnt)),
            completed_frames: Arc::new(AtomicUsize::new(init_frames)),
            tot_sz: Arc::new(AtomicU64::new(init_sz)),
            completions: Arc::new(Mutex::new(resume_data.clone())),
        }
    }

    fn add_completion(&self, completion: ChunkComp, work_dir: &Path) {
        self.completed_frames.fetch_add(completion.frames, Relaxed);
        self.tot_sz.fetch_add(completion.sz, Relaxed);
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

fn build_skip_set(resume_data: &ResumeInf) -> (HashSet<u16>, usize, usize) {
    let skip_indices: HashSet<u16> = resume_data.chnks_done.iter().map(|c| c.idx).collect();
    let completed_cnt = skip_indices.len();
    let completed_frames: usize = resume_data.chnks_done.iter().map(|c| c.frames).sum();
    (skip_indices, completed_cnt, completed_frames)
}

fn create_stats(completed_cnt: usize, resume_data: &ResumeInf) -> Arc<WorkerStats> {
    Arc::new(WorkerStats::new(completed_cnt, resume_data))
}

struct EncTrack {
    worker_id: usize,
    track_frames: bool,
    crf_score: Option<(f32, Option<f32>)>,
}

type SvtEncFn = fn(&mut Vec<u8>, &mut dyn Write, &EncConfig, &EncWorkerCtx, &mut [u8], &EncTrack);

type WatchEncFn = fn(&Arc<ProgsTrack>, &mut Child, Watch, Encoder);

type ChnkFn = fn(&mut WorkPkg, &str, &EncWorkerCtx, Option<&[u8]>, &mut [u8], usize);

#[cfg(feature = "vship")]
struct EncRecipe<'a> {
    params: &'a str,
    template: Option<&'a [u8]>,
}

#[cfg(feature = "vship")]
type ProbeFn = fn(&mut WorkPkg, f32, &EncRecipe, &EncWorkerCtx, &mut [u8], usize, Option<&Path>);

fn watch_enc_stderr(prog: &Arc<ProgsTrack>, child: &mut Child, w: Watch, encoder: Encoder) {
    prog.watch_enc(
        unsafe { child.stderr.take().unwrap_unchecked() },
        w,
        encoder,
    );
}

fn watch_enc_stdout(prog: &Arc<ProgsTrack>, child: &mut Child, w: Watch, encoder: Encoder) {
    prog.watch_enc(
        unsafe { child.stdout.take().unwrap_unchecked() },
        w,
        encoder,
    );
}

const fn watch_enc_unreachable(_: &Arc<ProgsTrack>, _: &mut Child, _: Watch, _: Encoder) {
    assume_unreachable();
}

fn resolve_watch_enc(encoder: Encoder) -> WatchEncFn {
    match encoder {
        X265 | X264 => watch_enc_stderr,
        Avm | Vvenc => watch_enc_stdout,
        SvtAv1 => watch_enc_unreachable,
    }
}

fn resolve_chnk_fn(encoder: Encoder) -> ChnkFn {
    if encoder == SvtAv1 {
        enc_chnk_svt
    } else {
        enc_chnk_sub
    }
}

#[cfg(feature = "vship")]
fn resolve_probe_fn(encoder: Encoder) -> ProbeFn {
    if encoder == SvtAv1 {
        enc_tq_probe_svt
    } else {
        enc_tq_probe_sub
    }
}

struct EncWorkerCtx<'a> {
    inf: &'a VidInf,
    pipe: &'a Pipeline,
    work_dir: &'a Path,
    prog: &'a Arc<ProgsTrack>,
    encoder: Encoder,
    svt_enc: SvtEncFn,
    watch_enc: WatchEncFn,
    chnk_fn: ChnkFn,
    #[cfg(feature = "vship")]
    probe_fn: ProbeFn,
}

#[cfg(feature = "vship")]
struct TQWorkerCtx<'a> {
    inf: &'a VidInf,
    pipe: &'a Pipeline,
    work_dir: &'a Path,
    metric_mode: &'a str,
    prog: &'a Arc<ProgsTrack>,
    done_tx: &'a Sender<u16>,
    resume_state: &'a Arc<Mutex<ResumeInf>>,
    stats: Option<&'a Arc<WorkerStats>>,
    tq_logger: &'a Arc<Mutex<Vec<ProbeLog>>>,
    tq_ctx: &'a TQCtx,
    use_alt_param: bool,
    worker_cnt: usize,
    make_decoder: fn(i32) -> ProbeDec,
    retain: fn(&mut WorkPkg, f32),
    output: fn(&Path, &TQState, &Path),
    threads: i32,
    ext: &'static str,
}

fn resolve_svt_enc(strat: DecStrat, is_nv12: bool, inf: &VidInf, pipe: &Pipeline) -> SvtEncFn {
    if strat.is_raw() {
        enc_svt_direct
    } else if is_nv12 {
        let y_ok = (pipe.final_w * pipe.final_h).is_multiple_of(SHIFT_CHUNK);
        let uv_ok = (pipe.final_w / 2 * (pipe.final_h / 2)).is_multiple_of(SHIFT_CHUNK * 2);
        if y_ok && uv_ok {
            enc_svt_nv12_drop
        } else {
            enc_svt_nv12_drop_rem
        }
    } else if !inf.is_10b && !pipe.frame_sz.is_multiple_of(SHIFT_CHUNK) {
        enc_svt_drop_rem
    } else {
        enc_svt_drop
    }
}

pub fn enc_all(
    chnks: &[Chunk],
    inf: &VidInf,
    args: &Args,
    path: &Path,
    work_dir: &Path,
    pipe_reader: Option<PipeReader>,
) {
    let resume_data = load_resume_data(work_dir);

    #[cfg(feature = "vship")]
    {
        let is_tq = args.tq.is_some() && args.qp_range.is_some();
        if is_tq {
            enc_tq(chnks, inf, args, path, work_dir, pipe_reader);
            return;
        }
    }

    let (skip_indices, completed_cnt, completed_frames) = build_skip_set(&resume_data);
    let stats = Some(create_stats(completed_cnt, &resume_data));
    let (prog, display_handle) = ProgsTrack::new(
        chnks,
        inf,
        args.worker,
        completed_frames,
        Arc::clone(&unsafe { stats.as_ref().unwrap_unchecked() }.completed),
        Arc::clone(&unsafe { stats.as_ref().unwrap_unchecked() }.completed_frames),
        Arc::clone(&unsafe { stats.as_ref().unwrap_unchecked() }.tot_sz),
    );
    let prog = Arc::new(prog);

    let strat = unsafe { args.dec_strat.unwrap_unchecked() };
    let is_nv12 = matches!(
        strat,
        DecStrat::HwNv12To10 | DecStrat::HwNv12To10Stride | DecStrat::HwNv12CropTo10 { .. }
    );
    let strat = if args.encoder == SvtAv1 && inf.is_10b && args.chnk_buff == args.worker {
        strat.to_raw()
    } else {
        strat
    };
    let pipe = Pipeline::new(
        inf,
        strat,
        #[cfg(feature = "vship")]
        None,
    );
    let svt_enc_fn = resolve_svt_enc(strat, is_nv12, inf, &pipe);
    let chnk_fn = resolve_chnk_fn(args.encoder);
    #[cfg(feature = "vship")]
    let probe_fn = resolve_probe_fn(args.encoder);

    let (tx, rx) = bounded::<WorkPkg>(args.chnk_buff);
    let rx = Arc::new(rx);
    let sem = Arc::new(Semaphore::new(args.chnk_buff));

    let decoder = {
        let chnks = chnks.to_vec();
        let path = path.to_path_buf();
        let inf = inf.clone();
        let sem = Arc::clone(&sem);
        spawn(move || {
            if let Some(mut reader) = pipe_reader {
                dec_pipe(&chnks, &mut reader, &inf, &tx, &skip_indices, strat, &sem);
            } else {
                dec_chnks(&chnks, &path, &inf, &tx, &skip_indices, strat, &sem);
            }
        })
    };

    let template = resolve_build_tmpl(args.encoder)
        .map(|build| build(inf, &args.params, pipe.final_w as u32, pipe.final_h as u32));

    let mut workers = Vec::new();
    for worker_id in 0..args.worker {
        let rx_clone = Arc::clone(&rx);
        let inf = inf.clone();
        let pipe = pipe.clone();
        let params = args.params.clone();
        let stats_clone = stats.clone();
        let wd = work_dir.to_path_buf();
        let prog_clone = Arc::clone(&prog);
        let sem_clone = Arc::clone(&sem);
        let encoder = args.encoder;
        let template = template.clone();

        let handle = spawn(move || {
            let ctx = EncWorkerCtx {
                inf: &inf,
                pipe: &pipe,
                work_dir: &wd,
                prog: &prog_clone,
                encoder,
                svt_enc: svt_enc_fn,
                watch_enc: resolve_watch_enc(encoder),
                chnk_fn,
                #[cfg(feature = "vship")]
                probe_fn,
            };
            run_enc_worker(
                &rx_clone,
                &params,
                &ctx,
                template.as_deref(),
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
    target: f32,
    tolerance: f32,
    qp_min: f32,
    qp_max: f32,
    use_butter: bool,
    use_cvvdp: bool,
    cvvdp_conf: Option<&'static str>,
}

#[cfg(feature = "vship")]
impl TQCtx {
    #[inline(always)]
    fn converged(&self, score: f32) -> bool {
        if self.use_butter {
            (self.target - score).abs() <= self.tolerance
        } else {
            (score - self.target).abs() <= self.tolerance
        }
    }

    #[inline(always)]
    fn up_bounds(&self, state: &mut TQState, score: f32) -> bool {
        if self.use_butter {
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

    #[inline(always)]
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

    #[inline(always)]
    const fn metric_name(&self) -> &'static str {
        if self.use_butter {
            "butter"
        } else if self.use_cvvdp {
            "cvvdp"
        } else {
            "ssimulacra2"
        }
    }
}

#[cold]
#[inline(never)]
#[cfg(feature = "vship")]
fn complete_chnk(
    chnk_idx: u16,
    chnk_frames: usize,
    probe_path: &Path,
    ctx: &TQWorkerCtx,
    tq_state: &TQState,
    best: &Probe,
) {
    let dst = ctx
        .work_dir
        .join("encode")
        .join(format!("{chnk_idx:04}.{}", ctx.ext));
    (ctx.output)(&dst, tq_state, probe_path);
    _ = ctx.done_tx.send(chnk_idx);

    let file_sz = metadata(&dst).map_or(0, |m| m.len());
    let comp = ChunkComp {
        idx: chnk_idx,
        frames: chnk_frames,
        sz: file_sz,
    };

    let mut resume = unsafe { ctx.resume_state.lock().unwrap_unchecked() };
    resume.chnks_done.push(comp.clone());
    _ = save_resume(&resume, ctx.work_dir);
    drop(resume);

    if let Some(s) = ctx.stats {
        s.completed.fetch_add(1, Relaxed);
        s.completed_frames.fetch_add(comp.frames, Relaxed);
        s.tot_sz.fetch_add(comp.sz, Relaxed);
    }

    let probes_with_sz: Vec<(f32, f32, u64)> = tq_state
        .probes
        .iter()
        .map(|p| {
            let sz = tq_state
                .probe_szs
                .iter()
                .find(|&&(c, _)| (c - p.crf).abs() < 0.001)
                .map_or(0, |&(_, s)| s);
            (p.crf, p.score, sz)
        })
        .collect();

    let log_entry = ProbeLog {
        chnk_idx,
        probes: probes_with_sz,
        final_crf: best.crf,
        final_score: best.score,
        final_sz: file_sz,
        round: tq_state.round,
        frames: chnk_frames,
    };
    write_chnk_log(&log_entry, ctx.work_dir);
    unsafe { ctx.tq_logger.lock().unwrap_unchecked() }.push(log_entry);
}

#[cfg(feature = "vship")]
#[inline]
pub fn probe_path(dir: &Path, idx: u16, crf: f32, ext: &str) -> PathBuf {
    dir.join("split").join(format!("{idx:04}_{crf:.2}.{ext}"))
}

#[cfg(feature = "vship")]
fn retain_swap(pkg: &mut WorkPkg, score: f32) {
    let WorkPkg {
        ref mut probe,
        ref mut tq_state,
        ..
    } = *pkg;
    let tq = unsafe { tq_state.as_mut().unwrap_unchecked() };
    let diff = (score - tq.target).abs();
    if diff < tq.best_diff {
        tq.best_diff = diff;
        swap(probe, &mut tq.best_probe);
    }
}

#[cfg(feature = "vship")]
const fn retain_noop(_: &mut WorkPkg, _: f32) {}

#[cfg(feature = "vship")]
fn output_bytes(dst: &Path, tq: &TQState, _: &Path) {
    _ = write(dst, &tq.best_probe);
}

#[cfg(feature = "vship")]
const fn output_noop(_: &Path, _: &TQState, _: &Path) {}

#[cfg(feature = "vship")]
fn output_copy(dst: &Path, _: &TQState, probe_path: &Path) {
    if probe_path != dst {
        _ = copy(probe_path, dst);
    }
}

#[cfg(feature = "vship")]
fn resolve_output(svt: bool, use_alt: bool) -> fn(&Path, &TQState, &Path) {
    match (svt, use_alt) {
        (true, false) => output_bytes,
        (true, true) => output_noop,
        (false, _) => output_copy,
    }
}

#[cfg(feature = "vship")]
fn run_metric_worker(
    rx: &Arc<Receiver<WorkPkg>>,
    work_tx: &Sender<WorkPkg>,
    ctx: &TQWorkerCtx,
    worker_id: usize,
) {
    let mut vship: Option<VshipProcessor> = None;
    let mut dec: Option<ProbeDec> = None;
    let mut unpacked_buf = PinnedBuf::new(ctx.pipe.unpack_buf_sz).unwrap_or_else(|e| fatal(e));

    while let Ok(mut pkg) = rx.recv() {
        let tq_st = unsafe { pkg.tq_state.as_ref().unwrap_unchecked() };
        if tq_st.final_enc {
            let best = ctx.tq_ctx.best_probe(&tq_st.probes);
            let p = ctx
                .work_dir
                .join("encode")
                .join(format!("{:04}.{}", pkg.chnk.idx, ctx.ext));
            complete_chnk(pkg.chnk.idx, pkg.frame_cnt, &p, ctx, tq_st, best);
            continue;
        }

        if vship.is_none() {
            let v = VshipProcessor::new(
                pkg.width,
                pkg.height,
                ctx.inf,
                ctx.tq_ctx.use_cvvdp,
                ctx.tq_ctx.use_butter,
                Some("xav"),
                ctx.tq_ctx.cvvdp_conf,
            )
            .unwrap_or_else(|e| fatal(e));
            vship = Some(v);
        }

        let tq_st = unsafe { pkg.tq_state.as_ref().unwrap_unchecked() };
        let crf = tq_st.last_crf;
        let last_score = tq_st.probes.last().map(|probe| probe.score);
        let metric_slot = ctx.worker_cnt + worker_id;

        let d = dec.get_or_insert_with(|| (ctx.make_decoder)(ctx.threads));
        let probe_sz = d.prep(&pkg, ctx.work_dir, pkg.chnk.idx, crf, ctx.ext);
        unsafe { pkg.tq_state.as_mut().unwrap_unchecked() }
            .probe_szs
            .push((crf, probe_sz));

        let mp = MetricProgs {
            prog: ctx.prog,
            slot: metric_slot,
            crf,
            last_score,
        };
        let (score, frame_scores) = (ctx.pipe.calc_metric)(
            &pkg,
            d,
            ctx.pipe,
            unsafe { vship.as_ref().unwrap_unchecked() },
            ctx.metric_mode,
            &mut unpacked_buf,
            &mp,
        );

        (ctx.retain)(&mut pkg, score);

        let tq_state = unsafe { pkg.tq_state.as_mut().unwrap_unchecked() };

        let should_complete = ctx.tq_ctx.converged(score)
            || tq_state
                .probes
                .iter()
                .any(|p| (p.crf - crf) * (p.score - score) >= 0.0)
            || ctx.tq_ctx.up_bounds(tq_state, score);

        tq_state.probes.push(Probe {
            crf,
            score,
            frame_scores,
        });

        if should_complete {
            let best = ctx.tq_ctx.best_probe(&tq_state.probes);
            if ctx.use_alt_param {
                tq_state.final_enc = true;
                tq_state.last_crf = best.crf;
                _ = work_tx.send(pkg);
            } else {
                let bp = probe_path(ctx.work_dir, pkg.chnk.idx, best.crf, ctx.ext);
                complete_chnk(pkg.chnk.idx, pkg.frame_cnt, &bp, ctx, tq_state, best);
            }
        } else {
            _ = work_tx.send(pkg);
        }
    }
}

#[cfg(feature = "vship")]
fn parse_tq_ctx(args: &Args) -> TQCtx {
    let tq_str = unsafe { args.tq.as_ref().unwrap_unchecked() };
    let qp_str = unsafe { args.qp_range.as_ref().unwrap_unchecked() };
    let tq_parts: Vec<f32> = tq_str.split('-').filter_map(|s| s.parse().ok()).collect();
    let qp_parts: Vec<f32> = qp_str.split('-').filter_map(|s| s.parse().ok()).collect();
    let tq_target = f32::midpoint(tq_parts[0], tq_parts[1]);
    let cvvdp_conf: Option<&'static str> = args
        .cvvdp_conf
        .as_ref()
        .map(|s| Box::leak(s.clone().into_boxed_str()) as &'static str);
    TQCtx {
        target: tq_target,
        tolerance: (tq_parts[1] - tq_parts[0]) / 2.0,
        qp_min: qp_parts[0],
        qp_max: qp_parts[1],
        use_butter: tq_target < 8.0,
        use_cvvdp: tq_target > 8.0 && tq_target <= 10.0,
        cvvdp_conf,
    }
}

#[cfg(feature = "vship")]
fn tq_coord(
    work_rx: &Receiver<WorkPkg>,
    done_rx: &Receiver<u16>,
    enc_tx: &Sender<WorkPkg>,
    tot_chnks: usize,
    permits: &Semaphore,
) {
    let mut completed = 0;
    while completed < tot_chnks {
        select! {
            recv(work_rx) -> pkg => { if let Ok(pkg) = pkg { _ = enc_tx.send(pkg); } }
            recv(done_rx) -> result => { if result.is_ok() { permits.release(); completed += 1; } }
        }
    }
}

#[cfg(feature = "vship")]
#[inline]
fn tq_search_crf(tq: &mut TQState, encoder: Encoder) -> f32 {
    tq.round += 1;
    let c = if tq.round <= 2 {
        bisect(tq.search_min, tq.search_max)
    } else {
        interpolate_crf(&tq.probes, tq.target, tq.round)
    }
    .clamp(tq.search_min, tq.search_max);
    let c = if encoder.integer_qp() { c.round() } else { c };
    tq.last_crf = c;
    c
}

#[cfg(feature = "vship")]
struct TqEncParams<'a> {
    tmpls: Option<&'a TqTmpls>,
    params: &'a str,
    alt_param: Option<&'a str>,
}

#[cfg(feature = "vship")]
fn tq_enc_loop(
    rx: &Receiver<WorkPkg>,
    tx: &Sender<WorkPkg>,
    ctx: &EncWorkerCtx,
    enc: &TqEncParams,
    tq_ctx: &TQCtx,
    worker_id: usize,
) {
    let &TqEncParams {
        tmpls,
        params,
        alt_param,
    } = enc;
    let mut conv_buf = vec![0u8; ctx.pipe.conv_buf_sz];
    while let Ok(mut pkg) = rx.recv() {
        let tq = pkg.tq_state.get_or_insert_with(|| TQState {
            probes: Vec::new(),
            probe_szs: Vec::new(),
            search_min: tq_ctx.qp_min,
            search_max: tq_ctx.qp_max,
            round: 0,
            target: tq_ctx.target,
            last_crf: 0.0,
            final_enc: false,
            best_probe: Vec::new(),
            best_diff: f32::INFINITY,
        });
        let is_final = tq.final_enc;
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
                    pkg.chnk.idx,
                    ctx.encoder.extension()
                ))),
            )
        } else {
            (alt_param.unwrap_or(params), None)
        };
        let svt_t = tmpls.map(|t| {
            let base: &[u8] = &t.base;
            if is_final {
                base
            } else {
                t.alt.as_deref().unwrap_or(base)
            }
        });
        (ctx.probe_fn)(
            &mut pkg,
            crf,
            &EncRecipe {
                params: p,
                template: svt_t,
            },
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
    work_tx: Sender<WorkPkg>,
    done_tx: Sender<u16>,
    handle: JoinHandle<()>,
}

#[cfg(feature = "vship")]
fn spawn_tq_dec(
    chnks: &[Chunk],
    path: &Path,
    inf: &VidInf,
    skip: HashSet<u16>,
    strat: DecStrat,
    permits: &Arc<Semaphore>,
    pipe_reader: Option<PipeReader>,
) -> TQDecodeResult {
    let tot = chnks.iter().filter(|c| !skip.contains(&c.idx)).count();
    let (enc_tx, enc_rx) = bounded::<WorkPkg>(2);
    let (work_tx, work_rx) = bounded::<WorkPkg>(4);
    let (done_tx, done_rx) = bounded::<u16>(4);

    let chnks = chnks.to_vec();
    let path = path.to_path_buf();
    let inf = inf.clone();
    let enc_tx2 = enc_tx.clone();
    let work_tx_dec = work_tx.clone();
    let permits_dec = Arc::clone(permits);
    let permits_done = Arc::clone(permits);
    let handle = spawn(move || {
        let inf2 = inf.clone();
        let dec = spawn(move || {
            if let Some(mut r) = pipe_reader {
                dec_pipe(
                    &chnks,
                    &mut r,
                    &inf2,
                    &work_tx_dec,
                    &skip,
                    strat,
                    &permits_dec,
                );
            } else {
                dec_chnks(
                    &chnks,
                    &path,
                    &inf2,
                    &work_tx_dec,
                    &skip,
                    strat,
                    &permits_dec,
                );
            }
        });
        tq_coord(&work_rx, &done_rx, &enc_tx2, tot, &permits_done);
        join_one(dec);
    });
    TQDecodeResult {
        enc_tx,
        enc_rx,
        work_tx,
        done_tx,
        handle,
    }
}

#[cfg(feature = "vship")]
fn enc_tq(
    chnks: &[Chunk],
    inf: &VidInf,
    args: &Args,
    path: &Path,
    work_dir: &Path,
    pipe_reader: Option<PipeReader>,
) {
    let resume_data = load_resume_data(work_dir);
    let (skip_indices, completed_cnt, completed_frames) = build_skip_set(&resume_data);
    let tq_ctx = parse_tq_ctx(args);
    let strat = unsafe { args.dec_strat.unwrap_unchecked() };
    let pipe = Pipeline::new(inf, strat, args.tq.as_deref());
    let permits = Arc::new(Semaphore::new(args.chnk_buff));

    let dec = spawn_tq_dec(chnks, path, inf, skip_indices, strat, &permits, pipe_reader);
    let (met_tx, met_rx) = bounded::<WorkPkg>(2);
    let (enc_rx, met_rx) = (Arc::new(dec.enc_rx), Arc::new(met_rx));

    let resume_state = Arc::new(Mutex::new(resume_data.clone()));
    let tq_logger = Arc::new(Mutex::new(Vec::new()));
    let stats = create_stats(completed_cnt, &resume_data);
    let (prog, display_handle) = ProgsTrack::new(
        chnks,
        inf,
        args.worker + args.metric_worker,
        completed_frames,
        Arc::clone(&stats.completed),
        Arc::clone(&stats.completed_frames),
        Arc::clone(&stats.tot_sz),
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
        use_alt_param: args.alt_param.is_some(),
        worker_cnt: args.worker,
    };

    init_device().unwrap_or_else(|e| fatal(e));

    let metric_workers =
        spawn_tq_metric(args.metric_worker, &met_rx, &dec.work_tx, &dec.done_tx, &sc);

    let workers = spawn_tq_encoders(&enc_rx, &met_tx, &sc);

    join_one(dec.handle);
    drop(dec.enc_tx);
    join_all(workers);
    drop(dec.work_tx);
    drop(met_tx);
    join_all(metric_workers);

    write_tq_log(&args.inp, work_dir, inf, sc.tq_ctx.metric_name());
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
    use_alt_param: bool,
    worker_cnt: usize,
}

#[cfg(feature = "vship")]
fn spawn_tq_metric(
    metric_worker: usize,
    met_rx: &Arc<Receiver<WorkPkg>>,
    work_tx: &Sender<WorkPkg>,
    done_tx: &Sender<u16>,
    sc: &TQSpawnCtx,
) -> Vec<JoinHandle<()>> {
    let svt = sc.encoder == SvtAv1;
    let make_decoder: fn(i32) -> ProbeDec = if svt { make_dav1d } else { make_ff };
    let retain: fn(&mut WorkPkg, f32) = if svt && !sc.use_alt_param {
        retain_swap
    } else {
        retain_noop
    };
    let output = resolve_output(svt, sc.use_alt_param);
    let threads = unsafe { available_parallelism().unwrap_unchecked().get() as i32 };
    let ext = sc.encoder.extension();
    let mut metric_workers = Vec::new();
    for worker_id in 0..metric_worker {
        let (rx, work_tx) = (Arc::clone(met_rx), work_tx.clone());
        let done_tx = done_tx.clone();
        let (inf, pipe, wd) = (sc.inf.clone(), sc.pipe.clone(), sc.work_dir.to_path_buf());
        let (metric_mode, st) = (sc.args.metric_mode.clone(), sc.stats.clone());
        let (resume_state, tq_logger, prog_clone) = (
            Arc::clone(sc.resume_state),
            Arc::clone(sc.tq_logger),
            Arc::clone(sc.prog),
        );
        let (tq_ctx, use_alt_param, worker_cnt) = (sc.tq_ctx, sc.use_alt_param, sc.worker_cnt);
        metric_workers.push(spawn(move || {
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
                use_alt_param,
                worker_cnt,
                make_decoder,
                retain,
                output,
                threads,
                ext,
            };
            run_metric_worker(&rx, &work_tx, &ctx, worker_id);
        }));
    }
    metric_workers
}

#[cfg(feature = "vship")]
#[derive(Clone)]
struct TqTmpls {
    base: Arc<[u8]>,
    alt: Option<Arc<[u8]>>,
}

#[cfg(feature = "vship")]
fn spawn_tq_encoders(
    enc_rx: &Arc<Receiver<WorkPkg>>,
    met_tx: &Sender<WorkPkg>,
    sc: &TQSpawnCtx,
) -> Vec<JoinHandle<()>> {
    let tmpls = resolve_build_tmpl(sc.encoder).map(|build| {
        let (w, h) = (sc.pipe.final_w as u32, sc.pipe.final_h as u32);
        TqTmpls {
            base: build(sc.inf, &sc.args.params, w, h),
            alt: sc
                .args
                .alt_param
                .as_deref()
                .map(|ap| build(sc.inf, ap, w, h)),
        }
    });
    let mut workers = Vec::new();
    let chnk_fn = resolve_chnk_fn(sc.encoder);
    let probe_fn = resolve_probe_fn(sc.encoder);
    for worker_id in 0..sc.worker_cnt {
        let (rx, tx) = (Arc::clone(enc_rx), met_tx.clone());
        let (inf, pipe, wd) = (sc.inf.clone(), sc.pipe.clone(), sc.work_dir.to_path_buf());
        let (params, alt_param) = (sc.args.params.clone(), sc.args.alt_param.clone());
        let prog_clone = Arc::clone(sc.prog);
        let (tq_ctx, encoder) = (sc.tq_ctx, sc.encoder);
        let tmpls = tmpls.clone();
        let svt_enc: SvtEncFn = if !sc.inf.is_10b && !sc.pipe.frame_sz.is_multiple_of(SHIFT_CHUNK) {
            enc_svt_lib_rem
        } else {
            enc_svt_lib
        };
        workers.push(spawn(move || {
            let ctx = EncWorkerCtx {
                inf: &inf,
                pipe: &pipe,
                work_dir: &wd,
                prog: &prog_clone,
                encoder,
                svt_enc,
                watch_enc: resolve_watch_enc(encoder),
                chnk_fn,
                probe_fn,
            };
            tq_enc_loop(
                &rx,
                &tx,
                &ctx,
                &TqEncParams {
                    tmpls: tmpls.as_ref(),
                    params: &params,
                    alt_param: alt_param.as_deref(),
                },
                &tq_ctx,
                worker_id,
            );
        }));
    }
    workers
}

#[cfg(feature = "vship")]
fn enc_tq_probe_svt(
    pkg: &mut WorkPkg,
    crf: f32,
    recipe: &EncRecipe,
    ctx: &EncWorkerCtx,
    conv_buf: &mut [u8],
    worker_id: usize,
    out_override: Option<&Path>,
) {
    let &EncRecipe { params, template } = recipe;
    let last_score = pkg
        .tq_state
        .as_ref()
        .and_then(|tq| tq.probes.last().map(|probe| probe.score));
    let cfg = EncConfig {
        inf: ctx.inf,
        template,
        params,
        zone_params: pkg.chnk.params.as_deref(),
        crf: Some(crf),
        out: Path::new(""),
        chnk_idx: pkg.chnk.idx,
        width: pkg.width,
        height: pkg.height,
        frames: pkg.frame_cnt,
    };
    pkg.probe.clear();
    (ctx.svt_enc)(
        &mut pkg.yuv,
        &mut pkg.probe,
        &cfg,
        ctx,
        conv_buf,
        &EncTrack {
            worker_id,
            track_frames: false,
            crf_score: Some((crf, last_score)),
        },
    );
    if let Some(out_path) = out_override {
        _ = write(out_path, &pkg.probe);
    }
}

#[cfg(feature = "vship")]
fn enc_tq_probe_sub(
    pkg: &mut WorkPkg,
    crf: f32,
    recipe: &EncRecipe,
    ctx: &EncWorkerCtx,
    conv_buf: &mut [u8],
    worker_id: usize,
    out_override: Option<&Path>,
) {
    let &EncRecipe { params, template } = recipe;
    let default_out;
    let out = if let Some(p) = out_override {
        p
    } else {
        default_out = probe_path(ctx.work_dir, pkg.chnk.idx, crf, ctx.encoder.extension());
        &default_out
    };
    let cfg = EncConfig {
        inf: ctx.inf,
        template,
        params,
        zone_params: pkg.chnk.params.as_deref(),
        crf: Some(crf),
        out,
        chnk_idx: pkg.chnk.idx,
        width: pkg.width,
        height: pkg.height,
        frames: pkg.frame_cnt,
    };

    let mut cmd = make_enc_cmd(ctx.encoder, &cfg);
    let mut child = cmd.spawn().unwrap_or_else(|e| fatal(e));

    let last_score = pkg
        .tq_state
        .as_ref()
        .and_then(|tq| tq.probes.last().map(|probe| probe.score));
    (ctx.watch_enc)(
        ctx.prog,
        &mut child,
        Watch {
            worker_id,
            chnk_idx: pkg.chnk.idx,
            frames: pkg.frame_cnt,
            track_frames: false,
            crf_score: Some((crf, last_score)),
        },
        ctx.encoder,
    );
    (ctx.pipe.write_frames)(
        unsafe { child.stdin.as_mut().unwrap_unchecked() },
        &pkg.yuv,
        pkg.frame_cnt,
        conv_buf,
        ctx.pipe,
    );

    let status = child.wait().unwrap_or_else(|e| fatal(e));
    if !status.success() {
        fatal(format_args!("probe encode failed: {}", out.display()));
    }
}

fn run_enc_worker(
    rx: &Arc<Receiver<WorkPkg>>,
    params: &str,
    ctx: &EncWorkerCtx,
    template: Option<&[u8]>,
    stats: Option<&Arc<WorkerStats>>,
    worker_id: usize,
    sem: &Arc<Semaphore>,
) {
    let mut conv_buf = vec![0u8; ctx.pipe.conv_buf_sz];

    while let Ok(mut pkg) = rx.recv() {
        (ctx.chnk_fn)(&mut pkg, params, ctx, template, &mut conv_buf, worker_id);

        if let Some(s) = stats {
            s.completed.fetch_add(1, Relaxed);
            let out = ctx.work_dir.join("encode").join(format!(
                "{:04}.{}",
                pkg.chnk.idx,
                ctx.encoder.extension()
            ));
            let file_sz = metadata(&out).map_or(0, |m| m.len());
            let comp = ChunkComp {
                idx: pkg.chnk.idx,
                frames: pkg.frame_cnt,
                sz: file_sz,
            };
            s.add_completion(comp, ctx.work_dir);
        }

        sem.release();
    }
}

fn enc_chnk_svt(
    pkg: &mut WorkPkg,
    params: &str,
    ctx: &EncWorkerCtx,
    template: Option<&[u8]>,
    conv_buf: &mut [u8],
    worker_id: usize,
) {
    let out = ctx.work_dir.join("encode").join(format!(
        "{:04}.{}",
        pkg.chnk.idx,
        ctx.encoder.extension()
    ));
    let cfg = EncConfig {
        inf: ctx.inf,
        template,
        params,
        zone_params: pkg.chnk.params.as_deref(),
        crf: None,
        out: &out,
        chnk_idx: pkg.chnk.idx,
        width: pkg.width,
        height: pkg.height,
        frames: pkg.frame_cnt,
    };
    let mut sink = BufWriter::new(File::create(&out).unwrap_or_else(|e| fatal(e)));
    (ctx.svt_enc)(
        &mut pkg.yuv,
        &mut sink,
        &cfg,
        ctx,
        conv_buf,
        &EncTrack {
            worker_id,
            track_frames: true,
            crf_score: None,
        },
    );
}

fn enc_chnk_sub(
    pkg: &mut WorkPkg,
    params: &str,
    ctx: &EncWorkerCtx,
    template: Option<&[u8]>,
    conv_buf: &mut [u8],
    worker_id: usize,
) {
    let out = ctx.work_dir.join("encode").join(format!(
        "{:04}.{}",
        pkg.chnk.idx,
        ctx.encoder.extension()
    ));
    let cfg = EncConfig {
        inf: ctx.inf,
        template,
        params,
        zone_params: pkg.chnk.params.as_deref(),
        crf: None,
        out: &out,
        chnk_idx: pkg.chnk.idx,
        width: pkg.width,
        height: pkg.height,
        frames: pkg.frame_cnt,
    };

    let mut cmd = make_enc_cmd(ctx.encoder, &cfg);
    let mut child = cmd.spawn().unwrap_or_else(|e| fatal(e));

    (ctx.watch_enc)(
        ctx.prog,
        &mut child,
        Watch {
            worker_id,
            chnk_idx: pkg.chnk.idx,
            frames: pkg.frame_cnt,
            track_frames: true,
            crf_score: None,
        },
        ctx.encoder,
    );

    (ctx.pipe.write_frames)(
        unsafe { child.stdin.as_mut().unwrap_unchecked() },
        &pkg.yuv,
        pkg.frame_cnt,
        conv_buf,
        ctx.pipe,
    );
    pkg.yuv = Vec::new();

    let status = child.wait().unwrap_or_else(|e| fatal(e));
    if !status.success() {
        fatal(format_args!("encode failed: chunk {:04}", pkg.chnk.idx));
    }
}

#[cfg(feature = "vship")]
pub fn write_chnk_log(chnk_log: &ProbeLog, work_dir: &Path) {
    let chnks_path = work_dir.join("chunks.json");
    let probes_str = chnk_log
        .probes
        .iter()
        .map(|&(c, s, sz)| format!("[{c:.2},{s:.4},{sz}]"))
        .collect::<Vec<_>>()
        .join(",");

    let line = format!(
        "{{\"id\":{},\"r\":{},\"f\":{},\"p\":[{}],\"fc\":{:.2},\"fs\":{:.4},\"fz\":{}}}\n",
        chnk_log.chnk_idx,
        chnk_log.round,
        chnk_log.frames,
        probes_str,
        chnk_log.final_crf,
        chnk_log.final_score,
        chnk_log.final_sz
    );

    if let Ok(mut file) = OpenOptions::new()
        .create(true)
        .append(true)
        .open(chnks_path)
    {
        _ = file.write_all(line.as_bytes());
    }
}

#[cfg(feature = "vship")]
fn form_tq_json(
    all_logs: &[TqChunkLine],
    metric_name: &str,
    fps: f32,
    round_cnts: &BTreeMap<usize, usize>,
    crf_cnts: &BTreeMap<u64, usize>,
) -> String {
    let tot = all_logs.len();
    let avg_probes = all_logs.iter().map(|l| l.p.len()).sum::<usize>() as f32 / tot as f32;
    let in_range = all_logs.iter().filter(|l| l.r <= 6).count();

    let calc_kbs = |size: u64, frames: usize| -> f32 {
        let d = frames as f32 / fps;
        if d > 0.0 {
            (size as f32 * 8.0) / d / 1000.0
        } else {
            0.0
        }
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
    _ = writeln!(out, "  \"out_range\": {},", tot - in_range);
    _ = writeln!(out);
    _ = writeln!(out, "  \"rounds\": {{");
    let rv: Vec<_> = round_cnts.iter().collect();
    for (i, &(round, cnt)) in rv.iter().enumerate() {
        let pct = (*cnt as f32 / tot as f32 * 100.0 * 100.0).round() / 100.0;
        let comma = if i + 1 < rv.len() { "," } else { "" };
        _ = writeln!(
            out,
            "    \"{round}\": {{ \"count\": {cnt}, \"%\": {pct:.2} }}{comma}"
        );
    }
    _ = writeln!(out, "  }},");
    _ = writeln!(out);
    _ = writeln!(out, "  \"common_crfs\": [");
    let mut cv: Vec<_> = crf_cnts.iter().collect();
    cv.sort_by(|&(_, a), &(_, b)| b.cmp(a));
    let top: Vec<_> = cv.iter().take(25).collect();
    for (i, &&(&crf, &cnt)) in top.iter().enumerate() {
        let comma = if i + 1 < top.len() { "," } else { "" };
        _ = writeln!(
            out,
            "    {{ \"crf\": {:.2}, \"count\": {} }}{comma}",
            crf as f32 / 100.0,
            cnt
        );
    }
    _ = writeln!(out, "  ]");
    _ = write!(out, "}}");
    out
}

#[cfg(feature = "vship")]
#[derive(Deserialize)]
struct TqChunkLine {
    id: usize,
    r: usize,
    f: usize,
    p: Vec<(f32, f32, u64)>,
    fc: f32,
    fs: f32,
    fz: u64,
}

#[cfg(feature = "vship")]
fn write_tq_log(inp: &Path, work_dir: &Path, inf: &VidInf, metric_name: &str) {
    let log_path = inp.with_extension("json");
    let chnks_path = work_dir.join("chunks.json");
    let fps = inf.fps_num as f32 / inf.fps_den as f32;

    let mut all_logs: Vec<TqChunkLine> = Vec::new();
    if let Ok(file) = File::open(&chnks_path) {
        for line in StdBufReader::new(file).lines().map_while(Result::ok) {
            if let Ok(cl) = from_str::<TqChunkLine>(&line) {
                all_logs.push(cl);
            }
        }
    }
    if all_logs.is_empty() {
        return;
    }

    let mut round_cnts: BTreeMap<usize, usize> = BTreeMap::new();
    let mut crf_cnts: BTreeMap<u64, usize> = BTreeMap::new();
    for l in &all_logs {
        *round_cnts.entry(l.p.len()).or_insert(0) += 1;
        *crf_cnts.entry((l.fc * 100.0).round() as u64).or_insert(0) += 1;
    }
    all_logs.sort_by_key(|l| l.id);

    let out = form_tq_json(&all_logs, metric_name, fps, &round_cnts, &crf_cnts);
    if let Ok(mut file) = OpenOptions::new()
        .create(true)
        .write(true)
        .truncate(true)
        .open(&log_path)
    {
        _ = file.write_all(out.as_bytes());
    }
}

fn drain_svt_packets(handle: *mut EbComponentType, out: &mut dyn Write, done: bool) -> usize {
    let mut cnt = 0;
    loop {
        let mut pkt: *mut EbBufferHeaderType = null_mut();
        let ret = unsafe { svt_av1_enc_get_packet(handle, &raw mut pkt, u8::from(done)) };
        if ret != EB_ERROR_NONE {
            break;
        }
        let p = unsafe { &*pkt };
        if p.n_filled_len > 0 {
            let data = unsafe { from_raw_parts(p.p_buffer.add(2), p.n_filled_len as usize - 2) };
            _ = out.write_all(data);
            cnt += 1;
        }
        let eos = p.flags & EB_BUFFERFLAG_EOS != 0;
        unsafe { svt_av1_enc_release_out_buffer(&raw mut pkt) };
        if eos {
            break;
        }
    }
    cnt
}

fn svt_handle() -> (*mut EbComponentType, EbSvtAv1EncConfiguration) {
    let mut handle: *mut EbComponentType = null_mut();
    let mut conf = unsafe { zeroed::<EbSvtAv1EncConfiguration>() };
    let ret = unsafe { svt_av1_enc_init_handle(&raw mut handle, &raw mut conf) };
    if ret != EB_ERROR_NONE {
        fatal(format_args!("svt_av1_enc_init_handle failed: {ret}"));
    }
    (handle, conf)
}

fn svt_defaults() -> &'static [u8; SVT_CONF_SIZE] {
    static DEFAULTS: OnceLock<[u8; SVT_CONF_SIZE]> = OnceLock::new();
    DEFAULTS.get_or_init(|| {
        let (handle, conf) = svt_handle();
        unsafe { svt_av1_enc_deinit_handle(handle) };
        unsafe { (&raw const conf).cast::<[u8; SVT_CONF_SIZE]>().read() }
    })
}

type BuildTmpl = fn(&VidInf, &str, u32, u32) -> Arc<[u8]>;

fn resolve_build_tmpl(encoder: Encoder) -> Option<BuildTmpl> {
    match encoder {
        SvtAv1 => Some(build_svt_template),
        Avm | Vvenc | X265 | X264 => None,
    }
}

fn build_svt_template(inf: &VidInf, params: &str, width: u32, height: u32) -> Arc<[u8]> {
    let mut conf = unsafe {
        svt_defaults()
            .as_ptr()
            .cast::<EbSvtAv1EncConfiguration>()
            .read_unaligned()
    };
    set_svt_base(&raw mut conf, inf, params, width, height);
    Arc::new(unsafe { (&raw const conf).cast::<[u8; SVT_CONF_SIZE]>().read() })
}

fn init_svt(cfg: &EncConfig) -> *mut EbComponentType {
    let (handle, mut conf) = svt_handle();
    unsafe {
        let t = cfg.template.unwrap_unchecked();
        copy_nonoverlapping(t.as_ptr(), (&raw mut conf).cast::<u8>(), SVT_CONF_SIZE);
    }
    set_svt_chunk(&raw mut conf, cfg);
    let ret = unsafe { svt_av1_enc_set_parameter(handle, &raw mut conf) };
    if ret != EB_ERROR_NONE {
        fatal(format_args!("svt_av1_enc_set_parameter failed: {ret}"));
    }
    let ret = unsafe { svt_av1_enc_init(handle) };
    if ret != EB_ERROR_NONE {
        fatal(format_args!("svt_av1_enc_init failed: {ret}"));
    }
    handle
}

macro_rules! make_send_svt {
    ($name:ident, $conv_8b:expr) => {
        fn $name(
            out: &mut dyn Write,
            yuv: &[u8],
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            conv_buf: &mut [u8],
            track: &EncTrack,
        ) -> (*mut EbComponentType, LibEncTracker) {
            let &EncTrack {
                worker_id,
                track_frames,
                crf_score,
            } = track;
            let handle = init_svt(cfg);

            let w = cfg.width as usize;
            let h = cfg.height as usize;
            let y_sz = w * h * 2;
            let uv_sz = (w / 2) * (h / 2) * 2;

            let mut io_fmt = EbSvtIOFormat {
                luma: conv_buf.as_mut_ptr(),
                cb: unsafe { conv_buf.as_mut_ptr().add(y_sz) },
                cr: unsafe { conv_buf.as_mut_ptr().add(y_sz + uv_sz) },
                y_stride: w as u32,
                cb_stride: (w / 2) as u32,
                cr_stride: (w / 2) as u32,
            };
            let io_ptr = &raw mut io_fmt;

            let mut in_hdr = unsafe { zeroed::<EbBufferHeaderType>() };
            in_hdr.size = size_of::<EbBufferHeaderType>() as u32;
            in_hdr.p_buffer = io_ptr.cast::<u8>();
            in_hdr.n_filled_len = (y_sz + uv_sz * 2) as u32;
            in_hdr.n_alloc_len = in_hdr.n_filled_len;

            let mut tracker =
                LibEncTracker::new(worker_id, cfg.chnk_idx, cfg.frames, track_frames, crf_score);
            ctx.prog.up_lib_enc(
                worker_id,
                cfg.chnk_idx,
                (0, cfg.frames),
                0.0,
                None,
                crf_score,
            );

            let is_raw = ctx.pipe.conv_buf_sz == 0;
            for i in 0..cfg.frames {
                let frame = get_frame(yuv, i, ctx.pipe.frame_sz);
                if is_raw {
                    unsafe {
                        (*io_ptr).luma = frame.as_ptr().cast_mut();
                        (*io_ptr).cb = frame[y_sz..].as_ptr().cast_mut();
                        (*io_ptr).cr = frame[y_sz + uv_sz..].as_ptr().cast_mut();
                    }
                } else if cfg.inf.is_10b {
                    (ctx.pipe.unpack)(frame, conv_buf, ctx.pipe);
                } else {
                    ($conv_8b)(frame, conv_buf, ctx.pipe);
                }

                in_hdr.pts = i as i64;
                in_hdr.flags = 0;

                let ret = unsafe { svt_av1_enc_send_picture(handle, &raw mut in_hdr) };
                if ret != EB_ERROR_NONE {
                    cold_path();
                    fatal(format_args!(
                        "svt_av1_enc_send_picture failed at frame {i}: {ret}"
                    ));
                }

                tracker.enced += drain_svt_packets(handle, out, false);
                tracker.report(ctx.prog);
            }

            (handle, tracker)
        }
    };
}

make_send_svt!(
    send_svt_conv,
    |frame: &[u8], buf: &mut [u8], _pipe: &Pipeline| conv_10b(frame, buf)
);
make_send_svt!(
    send_svt_conv_rem,
    |frame: &[u8], buf: &mut [u8], _pipe: &Pipeline| conv_10b_rem(frame, buf)
);
make_send_svt!(
    send_svt_nv12,
    |frame: &[u8], buf: &mut [u8], pipe: &Pipeline| nv12_10b(
        frame,
        buf,
        pipe.final_w,
        pipe.final_h
    )
);
make_send_svt!(
    send_svt_nv12_rem,
    |frame: &[u8], buf: &mut [u8], pipe: &Pipeline| nv12_10b_rem(
        frame,
        buf,
        pipe.final_w,
        pipe.final_h
    )
);

#[cfg(feature = "vship")]
fn enc_svt_lib(
    yuv: &mut Vec<u8>,
    out: &mut dyn Write,
    cfg: &EncConfig,
    ctx: &EncWorkerCtx,
    conv_buf: &mut [u8],
    track: &EncTrack,
) {
    let (handle, mut tracker) = send_svt_conv(out, yuv.as_slice(), cfg, ctx, conv_buf, track);
    finish_svt(handle, out, &mut tracker, ctx.prog);
}

#[cfg(feature = "vship")]
fn enc_svt_lib_rem(
    yuv: &mut Vec<u8>,
    out: &mut dyn Write,
    cfg: &EncConfig,
    ctx: &EncWorkerCtx,
    conv_buf: &mut [u8],
    track: &EncTrack,
) {
    let (handle, mut tracker) = send_svt_conv_rem(out, yuv.as_slice(), cfg, ctx, conv_buf, track);
    finish_svt(handle, out, &mut tracker, ctx.prog);
}

fn enc_svt_drop(
    yuv: &mut Vec<u8>,
    out: &mut dyn Write,
    cfg: &EncConfig,
    ctx: &EncWorkerCtx,
    conv_buf: &mut [u8],
    track: &EncTrack,
) {
    let (handle, mut tracker) = send_svt_conv(out, yuv, cfg, ctx, conv_buf, track);
    *yuv = Vec::new();
    finish_svt(handle, out, &mut tracker, ctx.prog);
}

fn enc_svt_drop_rem(
    yuv: &mut Vec<u8>,
    out: &mut dyn Write,
    cfg: &EncConfig,
    ctx: &EncWorkerCtx,
    conv_buf: &mut [u8],
    track: &EncTrack,
) {
    let (handle, mut tracker) = send_svt_conv_rem(out, yuv, cfg, ctx, conv_buf, track);
    *yuv = Vec::new();
    finish_svt(handle, out, &mut tracker, ctx.prog);
}

fn enc_svt_nv12_drop(
    yuv: &mut Vec<u8>,
    out: &mut dyn Write,
    cfg: &EncConfig,
    ctx: &EncWorkerCtx,
    conv_buf: &mut [u8],
    track: &EncTrack,
) {
    let (handle, mut tracker) = send_svt_nv12(out, yuv, cfg, ctx, conv_buf, track);
    *yuv = Vec::new();
    finish_svt(handle, out, &mut tracker, ctx.prog);
}

fn enc_svt_nv12_drop_rem(
    yuv: &mut Vec<u8>,
    out: &mut dyn Write,
    cfg: &EncConfig,
    ctx: &EncWorkerCtx,
    conv_buf: &mut [u8],
    track: &EncTrack,
) {
    let (handle, mut tracker) = send_svt_nv12_rem(out, yuv, cfg, ctx, conv_buf, track);
    *yuv = Vec::new();
    finish_svt(handle, out, &mut tracker, ctx.prog);
}

fn enc_svt_direct(
    yuv: &mut Vec<u8>,
    out: &mut dyn Write,
    cfg: &EncConfig,
    ctx: &EncWorkerCtx,
    _conv_buf: &mut [u8],
    track: &EncTrack,
) {
    let &EncTrack {
        worker_id,
        track_frames,
        crf_score,
    } = track;
    let handle = init_svt(cfg);

    let w = cfg.width as usize;
    let h = cfg.height as usize;
    let y_sz = w * h * 2;
    let uv_sz = (w / 2) * (h / 2) * 2;

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
    in_hdr.n_filled_len = (y_sz + uv_sz * 2) as u32;
    in_hdr.n_alloc_len = in_hdr.n_filled_len;

    let mut tracker =
        LibEncTracker::new(worker_id, cfg.chnk_idx, cfg.frames, track_frames, crf_score);
    ctx.prog.up_lib_enc(
        worker_id,
        cfg.chnk_idx,
        (0, cfg.frames),
        0.0,
        None,
        crf_score,
    );

    for i in 0..cfg.frames {
        let off = i * ctx.pipe.frame_sz;
        unsafe {
            (*io_ptr).luma = yuv[off..].as_ptr().cast_mut();
            (*io_ptr).cb = yuv[off + y_sz..].as_ptr().cast_mut();
            (*io_ptr).cr = yuv[off + y_sz + uv_sz..].as_ptr().cast_mut();
        }

        in_hdr.pts = i as i64;
        in_hdr.flags = 0;

        let ret = unsafe { svt_av1_enc_send_picture(handle, &raw mut in_hdr) };
        if ret != EB_ERROR_NONE {
            cold_path();
            fatal(format_args!(
                "svt_av1_enc_send_picture failed at frame {i}: {ret}"
            ));
        }

        tracker.enced += drain_svt_packets(handle, out, false);
        tracker.report(ctx.prog);
    }
    *yuv = Vec::new();

    finish_svt(handle, out, &mut tracker, ctx.prog);
}

fn finish_svt(
    handle: *mut EbComponentType,
    out: &mut dyn Write,
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
            let data = unsafe { from_raw_parts(p.p_buffer.add(2), p.n_filled_len as usize - 2) };
            _ = out.write_all(data);
            tracker.enced += 1;
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

#[cfg(test)]
#[allow(function_casts_as_integer, clippy::fn_to_numeric_cast_any)]
pub mod test_access {
    use super::*;

    pub fn resolve_svt_enc_addr(
        strat: DecStrat,
        is_nv12: bool,
        inf: &VidInf,
        pipe: &Pipeline,
    ) -> usize {
        resolve_svt_enc(strat, is_nv12, inf, pipe) as usize
    }

    pub fn enc_svt_direct_addr() -> usize {
        (enc_svt_direct as SvtEncFn) as usize
    }
    pub fn enc_svt_drop_addr() -> usize {
        (enc_svt_drop as SvtEncFn) as usize
    }
    pub fn enc_svt_drop_rem_addr() -> usize {
        (enc_svt_drop_rem as SvtEncFn) as usize
    }
    pub fn enc_svt_nv12_drop_addr() -> usize {
        (enc_svt_nv12_drop as SvtEncFn) as usize
    }
    pub fn enc_svt_nv12_drop_rem_addr() -> usize {
        (enc_svt_nv12_drop_rem as SvtEncFn) as usize
    }
}
