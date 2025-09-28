use std::collections::HashSet;
use std::io::Write;
use std::path::Path;
use std::process::{Command, Stdio};
use std::sync::Arc;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::thread;

use crossbeam_channel::{Receiver, Sender, bounded};

use crate::chunk::{Chunk, ChunkComp, ResumeInf, get_resume, save_resume};
use crate::ffms::{
    VidIdx, VidInf, calc_8bit_size, calc_10bit_size, calc_packed_size, conv_to_10bit,
    destroy_vid_src, extr_8bit, extr_10bit, pack_10bit, thr_vid_src, unpack_10bit,
};
use crate::progs::ProgsTrack;

struct ChunkData {
    idx: usize,
    frames: Vec<Vec<u8>>,
}

struct EncConfig<'a> {
    inf: &'a VidInf,
    params: &'a str,
    crf: f32,
    output: &'a Path,
}

fn make_enc_cmd(cfg: &EncConfig, quiet: bool) -> Command {
    let mut cmd = Command::new("SvtAv1EncApp");

    let width_str = cfg.inf.width.to_string();
    let height_str = cfg.inf.height.to_string();
    let fps_num_str = cfg.inf.fps_num.to_string();
    let fps_den_str = cfg.inf.fps_den.to_string();
    let crf_str = format!("{:.2}", cfg.crf);

    let base_args = [
        "-i",
        "stdin",
        "--input-depth",
        "10",
        "--width",
        &width_str,
        "--forced-max-frame-width",
        &width_str,
        "--height",
        &height_str,
        "--forced-max-frame-height",
        &height_str,
        "--fps-num",
        &fps_num_str,
        "--fps-denom",
        &fps_den_str,
        "--crf",
        &crf_str,
        "--keyint",
        "-1",
        "--rc",
        "0",
        "--scd",
        "0",
        "--scm",
        "0",
        "--progress",
        if quiet { "0" } else { "3" },
    ];

    for i in (0..base_args.len()).step_by(2) {
        cmd.arg(base_args[i]).arg(base_args[i + 1]);
    }

    colorize(&mut cmd, cfg.inf);

    if quiet {
        cmd.arg("--no-progress").arg("1");
    }

    cmd.args(cfg.params.split_whitespace())
        .arg("-b")
        .arg(cfg.output)
        .stdin(Stdio::piped())
        .stderr(Stdio::piped());

    cmd
}

fn colorize(cmd: &mut Command, inf: &VidInf) {
    if let Some(cp) = inf.color_primaries {
        cmd.args(["--color-primaries", &cp.to_string()]);
    }
    if let Some(tc) = inf.transfer_characteristics {
        cmd.args(["--transfer-characteristics", &tc.to_string()]);
    }
    if let Some(mc) = inf.matrix_coefficients {
        cmd.args(["--matrix-coefficients", &mc.to_string()]);
    }
    if let Some(cr) = inf.color_range {
        cmd.args(["--color-range", &cr.to_string()]);
    }
    if let Some(csp) = inf.chroma_sample_position {
        cmd.args(["--chroma-sample-position", &csp.to_string()]);
    }
    if let Some(ref md) = inf.mastering_display {
        cmd.args(["--mastering-display", md]);
    }
    if let Some(ref cl) = inf.content_light {
        cmd.args(["--content-light", cl]);
    }
}

fn dec_10bit(
    chunks: &[Chunk],
    source: *mut std::ffi::c_void,
    inf: &VidInf,
    tx: &Sender<ChunkData>,
) {
    let frame_size = calc_10bit_size(inf);
    let packed_size = calc_packed_size(inf);
    let mut frame_buf = vec![0u8; frame_size];
    let mut temp_pack = [0u8; 8];

    for chunk in chunks {
        let n = chunk.end - chunk.start;
        let mut frames = vec![vec![0u8; packed_size]; n];
        let mut valid = 0;

        for (i, idx) in (chunk.start..chunk.end).enumerate() {
            if extr_10bit(source, idx, &mut frame_buf).is_err() {
                continue;
            }

            pack_10bit(&frame_buf, &mut frames[i], &mut temp_pack);
            valid += 1;
        }

        if valid == 0 {
            continue;
        }
        frames.truncate(valid);
        if tx.send(ChunkData { idx: chunk.idx, frames }).is_err() {
            break;
        }
    }
}

fn dec_8bit(chunks: &[Chunk], source: *mut std::ffi::c_void, inf: &VidInf, tx: &Sender<ChunkData>) {
    let frame_size = calc_8bit_size(inf);

    for chunk in chunks {
        let n = chunk.end - chunk.start;
        let mut frames = vec![vec![0u8; frame_size]; n];
        let mut valid = 0;

        for (i, idx) in (chunk.start..chunk.end).enumerate() {
            if extr_8bit(source, idx, &mut frames[i]).is_ok() {
                valid += 1;
            }
        }

        if valid == 0 {
            continue;
        }
        frames.truncate(valid);
        if tx.send(ChunkData { idx: chunk.idx, frames }).is_err() {
            break;
        }
    }
}

fn dec_10bit_full(
    chunks: &[Chunk],
    source: *mut std::ffi::c_void,
    inf: &VidInf,
    tx: &Sender<ChunkData>,
) {
    let frame_size = calc_10bit_size(inf);

    for chunk in chunks {
        let n = chunk.end - chunk.start;
        let mut frames = vec![vec![0u8; frame_size]; n];
        let mut valid = 0;

        for (i, idx) in (chunk.start..chunk.end).enumerate() {
            if extr_10bit(source, idx, &mut frames[i]).is_ok() {
                valid += 1;
            }
        }

        if valid == 0 {
            continue;
        }
        frames.truncate(valid);
        if tx.send(ChunkData { idx: chunk.idx, frames }).is_err() {
            break;
        }
    }
}

fn dec_8bit_to_10bit(
    chunks: &[Chunk],
    source: *mut std::ffi::c_void,
    inf: &VidInf,
    tx: &Sender<ChunkData>,
) {
    let size_8bit = calc_8bit_size(inf);
    let size_10bit = calc_10bit_size(inf);
    let mut buf_8bit = vec![0u8; size_8bit];

    for chunk in chunks {
        let n = chunk.end - chunk.start;
        let mut frames = vec![vec![0u8; size_10bit]; n];
        let mut valid = 0;

        for (i, idx) in (chunk.start..chunk.end).enumerate() {
            if extr_8bit(source, idx, &mut buf_8bit).is_err() {
                continue;
            }

            conv_to_10bit(&buf_8bit, &mut frames[i]);
            valid += 1;
        }

        if valid == 0 {
            continue;
        }
        frames.truncate(valid);
        if tx.send(ChunkData { idx: chunk.idx, frames }).is_err() {
            break;
        }
    }
}

fn decode_chunks(
    chunks: &[Chunk],
    idx: &Arc<VidIdx>,
    inf: &VidInf,
    tx: &Sender<ChunkData>,
    high_mem: bool,
    skip_indices: &HashSet<usize>,
) {
    let threads =
        std::thread::available_parallelism().map_or(8, |n| n.get().try_into().unwrap_or(8));

    let Ok(source) = thr_vid_src(idx, threads) else {
        return;
    };

    let filtered_chunks: Vec<Chunk> =
        chunks.iter().filter(|c| !skip_indices.contains(&c.idx)).cloned().collect();

    match (high_mem, inf.is_10bit) {
        (false, true) => dec_10bit(&filtered_chunks, source, inf, tx),
        (false, false) => dec_8bit(&filtered_chunks, source, inf, tx),
        (true, true) => dec_10bit_full(&filtered_chunks, source, inf, tx),
        (true, false) => dec_8bit_to_10bit(&filtered_chunks, source, inf, tx),
    }

    destroy_vid_src(source);
}

fn write_frames(
    child: &mut std::process::Child,
    frames: Vec<Vec<u8>>,
    inf: &VidInf,
    high_mem: bool,
) -> usize {
    let Some(mut stdin) = child.stdin.take() else {
        return 0;
    };

    let mut written = 0;
    let mut buf = if high_mem { None } else { Some(vec![0u8; calc_10bit_size(inf)]) };

    for frame in frames {
        let result = if let Some(ref mut b) = buf {
            if inf.is_10bit {
                unpack_10bit(&frame, b);
            } else {
                conv_to_10bit(&frame, b);
            }
            stdin.write_all(b)
        } else {
            stdin.write_all(&frame)
        };

        if result.is_err() {
            break;
        }
        written += 1;
    }

    written
}

struct ProcConfig<'a> {
    inf: &'a VidInf,
    params: &'a str,
    crf: f32,
    high_mem: bool,
    quiet: bool,
    work_dir: &'a Path,
}

fn proc_chunk(
    data: ChunkData,
    config: &ProcConfig,
    prog: Option<&ProgsTrack>,
) -> (usize, Option<ChunkComp>) {
    let output = config.work_dir.join("encode").join(format!("{:04}.ivf", data.idx));
    let enc_cfg =
        EncConfig { inf: config.inf, params: config.params, crf: config.crf, output: &output };
    let mut cmd = make_enc_cmd(&enc_cfg, config.quiet);
    let mut child = cmd.spawn().unwrap_or_else(|_| std::process::exit(1));

    if !config.quiet
        && let Some(stderr) = child.stderr.take()
        && let Some(p) = prog
    {
        p.watch_enc(stderr, data.idx);
    }

    let frame_count = data.frames.len();
    let written = write_frames(&mut child, data.frames, config.inf, config.high_mem);

    let status = child.wait().unwrap();
    if !status.success() {
        std::process::exit(1);
    }

    let completion = std::fs::metadata(&output).ok().map(|metadata| ChunkComp {
        idx: data.idx,
        frames: frame_count,
        size: metadata.len(),
    });

    (written, completion)
}

struct WorkerCtx {
    crf: f32,
    high_mem: bool,
    quiet: bool,
}

fn run_worker(
    rx: &Arc<Receiver<ChunkData>>,
    inf: &VidInf,
    params: &str,
    ctx: &WorkerCtx,
    stats: Option<&Arc<WorkerStats>>,
    prog: Option<&Arc<ProgsTrack>>,
    work_dir: &Path,
) {
    loop {
        let Ok(data) = rx.recv() else { break };
        let config = ProcConfig {
            inf,
            params,
            crf: ctx.crf,
            high_mem: ctx.high_mem,
            quiet: ctx.quiet,
            work_dir,
        };
        let (written, completion) = proc_chunk(data, &config, prog.map(AsRef::as_ref));

        if let Some(s) = stats {
            s.completed.fetch_add(1, Ordering::Relaxed);
            s.frames_done.fetch_add(written, Ordering::Relaxed);

            if let Some(comp) = completion {
                s.add_completion(comp, work_dir);
            }
        }
    }
}

struct WorkerStats {
    completed: Arc<AtomicUsize>,
    frames_done: AtomicUsize,
    completions: Arc<std::sync::Mutex<ResumeInf>>,
}

impl WorkerStats {
    fn new(initial_completed: usize, init_frames: usize, initial_data: ResumeInf) -> Self {
        Self {
            completed: Arc::new(AtomicUsize::new(initial_completed)),
            frames_done: AtomicUsize::new(init_frames),
            completions: Arc::new(std::sync::Mutex::new(initial_data)),
        }
    }

    fn add_completion(&self, completion: ChunkComp, work_dir: &Path) {
        let mut data = self.completions.lock().unwrap();
        data.chnks_done.push(completion);
        let _ = save_resume(&data, work_dir);
        drop(data);
    }
}

pub fn encode_all(
    chunks: &[Chunk],
    inf: &VidInf,
    args: &crate::Args,
    crf: f32,
    idx: &Arc<VidIdx>,
    work_dir: &Path,
) {
    let resume_data = if args.resume {
        get_resume(work_dir).unwrap_or(ResumeInf { chnks_done: Vec::new() })
    } else {
        ResumeInf { chnks_done: Vec::new() }
    };

    let skip_indices: HashSet<usize> = resume_data.chnks_done.iter().map(|c| c.idx).collect();
    let completed_count = skip_indices.len();
    let completed_frames: usize = resume_data.chnks_done.iter().map(|c| c.frames).sum();

    let stats = if args.quiet {
        None
    } else {
        Some(Arc::new(WorkerStats::new(completed_count, completed_frames, resume_data)))
    };

    let prog = if args.quiet {
        None
    } else {
        Some(Arc::new(ProgsTrack::new(
            chunks,
            inf,
            args.worker,
            completed_frames,
            Arc::clone(&stats.as_ref().unwrap().completed),
            Arc::clone(&stats.as_ref().unwrap().completions),
        )))
    };

    let buffer_size = if args.high_mem { args.worker.min(1) } else { 0 };
    let (tx, rx) = bounded::<ChunkData>(buffer_size);
    let rx = Arc::new(rx);

    let decoder = {
        let chunks = chunks.to_vec();
        let idx = Arc::clone(idx);
        let inf = inf.clone();
        let high_mem = args.high_mem;
        thread::spawn(move || decode_chunks(&chunks, &idx, &inf, &tx, high_mem, &skip_indices))
    };

    let mut workers = Vec::new();
    for _ in 0..args.worker {
        let rx = Arc::clone(&rx);
        let inf = inf.clone();
        let params = args.params.clone();
        let stats = stats.clone();
        let prog = prog.clone();
        let ctx = WorkerCtx { crf, high_mem: args.high_mem, quiet: args.quiet };
        let work_dir = work_dir.to_path_buf();

        let handle = thread::spawn(move || {
            run_worker(&rx, &inf, &params, &ctx, stats.as_ref(), prog.as_ref(), &work_dir);
        });
        workers.push(handle);
    }

    decoder.join().unwrap();

    for handle in workers {
        handle.join().unwrap();
    }

    if let Some(ref p) = prog {
        p.final_update();
    }
}
