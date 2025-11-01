use std::collections::HashSet;
use std::io::Write;
use std::path::{Path, PathBuf};
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

fn get_tile_params(width: u32, height: u32) -> (&'static str, &'static str) {
    let is_vertical = height > width;
    let max_dim = width.max(height);

    match max_dim {
        0..=1080 => ("0", "0"),
        1081..=2160 => {
            if is_vertical {
                ("0", "1")
            } else {
                ("1", "0")
            }
        }
        _ => {
            if is_vertical {
                ("0", "2")
            } else {
                ("2", "0")
            }
        }
    }
}

struct ChunkData {
    idx: usize,
    frames: Vec<Vec<u8>>,
}

struct EncConfig<'a> {
    inf: &'a VidInf,
    params: &'a str,
    crf: f32,
    output: &'a Path,
    grain_table: Option<&'a Path>,
}

fn make_enc_cmd(cfg: &EncConfig, quiet: bool) -> Command {
    let mut cmd = Command::new("SvtAv1EncApp");

    let width_str = cfg.inf.width.to_string();
    let height_str = cfg.inf.height.to_string();
    let fps_num_str = cfg.inf.fps_num.to_string();
    let fps_den_str = cfg.inf.fps_den.to_string();

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

    if cfg.crf >= 0.0 {
        let crf_str = format!("{:.2}", cfg.crf);
        cmd.arg("--crf").arg(crf_str);
    }

    colorize(&mut cmd, cfg.inf);

    let (tile_cols, tile_rows) = get_tile_params(cfg.inf.width, cfg.inf.height);
    cmd.args(["--tile-columns", tile_cols, "--tile-rows", tile_rows]);

    if let Some(grain_path) = cfg.grain_table {
        cmd.arg("--fgs-table").arg(grain_path);
    }

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

fn get_max_chunk_size(inf: &VidInf) -> usize {
    ((inf.fps_num * 10 + inf.fps_den / 2) / inf.fps_den).min(300) as usize
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

    let max_chunk_size = get_max_chunk_size(inf);
    let mut frames_buffer: Vec<Vec<u8>> =
        (0..max_chunk_size).map(|_| vec![0u8; packed_size]).collect();

    for chunk in chunks {
        let mut valid = 0;

        for (i, idx) in (chunk.start..chunk.end).enumerate() {
            if extr_10bit(source, idx, &mut frame_buf).is_err() {
                continue;
            }

            pack_10bit(&frame_buf, &mut frames_buffer[i]);
            valid += 1;
        }

        if valid > 0 {
            tx.send(ChunkData { idx: chunk.idx, frames: frames_buffer[..valid].to_vec() }).ok();
        }
    }
}

fn dec_8bit(chunks: &[Chunk], source: *mut std::ffi::c_void, inf: &VidInf, tx: &Sender<ChunkData>) {
    let max_chunk_size = get_max_chunk_size(inf);
    let frame_size = calc_8bit_size(inf);
    let mut frames_buffer: Vec<Vec<u8>> =
        (0..max_chunk_size).map(|_| vec![0u8; frame_size]).collect();

    for chunk in chunks {
        let mut valid = 0;

        for (i, idx) in (chunk.start..chunk.end).enumerate() {
            if extr_8bit(source, idx, &mut frames_buffer[i]).is_ok() {
                valid += 1;
            }
        }

        if valid > 0 {
            tx.send(ChunkData { idx: chunk.idx, frames: frames_buffer[..valid].to_vec() }).ok();
        }
    }
}

fn decode_chunks(
    chunks: &[Chunk],
    idx: &Arc<VidIdx>,
    inf: &VidInf,
    tx: &Sender<ChunkData>,
    skip_indices: &HashSet<usize>,
) {
    let threads =
        std::thread::available_parallelism().map_or(8, |n| n.get().try_into().unwrap_or(8));
    let Ok(source) = thr_vid_src(idx, threads) else { return };
    let filtered: Vec<Chunk> =
        chunks.iter().filter(|c| !skip_indices.contains(&c.idx)).cloned().collect();

    if inf.is_10bit {
        dec_10bit(&filtered, source, inf, tx);
    } else {
        dec_8bit(&filtered, source, inf, tx);
    }

    destroy_vid_src(source);
}

fn write_frames(
    child: &mut std::process::Child,
    frames: Vec<Vec<u8>>,
    inf: &VidInf,
    conversion_buf: &mut Option<Vec<u8>>,
) -> usize {
    let Some(mut stdin) = child.stdin.take() else {
        return 0;
    };

    let mut written = 0;

    for frame in frames {
        let result = if let Some(buf) = conversion_buf {
            if inf.is_10bit {
                unpack_10bit(&frame, buf);
            } else {
                conv_to_10bit(&frame, buf);
            }
            stdin.write_all(buf)
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
    quiet: bool,
    work_dir: &'a Path,
    grain_table: Option<&'a Path>,
}

fn proc_chunk(
    data: ChunkData,
    config: &ProcConfig,
    prog: Option<&ProgsTrack>,
    conversion_buf: &mut Option<Vec<u8>>,
) -> (usize, Option<ChunkComp>) {
    let output = config.work_dir.join("encode").join(format!("{:04}.ivf", data.idx));
    let enc_cfg = EncConfig {
        inf: config.inf,
        params: config.params,
        crf: -1.0,
        output: &output,
        grain_table: config.grain_table,
    };
    let mut cmd = make_enc_cmd(&enc_cfg, config.quiet);
    let mut child = cmd.spawn().unwrap_or_else(|_| std::process::exit(1));

    if !config.quiet
        && let Some(stderr) = child.stderr.take()
        && let Some(p) = prog
    {
        p.watch_enc(stderr, data.idx, true, None);
    }

    let frame_count = data.frames.len();
    let written = write_frames(&mut child, data.frames, config.inf, conversion_buf);

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

struct WorkerCtx<'a> {
    quiet: bool,
    grain_table: Option<&'a Path>,
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
    let mut conversion_buf = Some(vec![0u8; calc_10bit_size(inf)]);

    while let Ok(data) = rx.recv() {
        let config =
            ProcConfig { inf, params, quiet: ctx.quiet, work_dir, grain_table: ctx.grain_table };
        let (written, completion) =
            proc_chunk(data, &config, prog.map(AsRef::as_ref), &mut conversion_buf);

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
    idx: &Arc<VidIdx>,
    work_dir: &Path,
    grain_table: Option<&PathBuf>,
) {
    let resume_data = if args.resume {
        get_resume(work_dir).unwrap_or(ResumeInf { chnks_done: Vec::new() })
    } else {
        ResumeInf { chnks_done: Vec::new() }
    };

    #[cfg(feature = "vship")]
    {
        let is_tq = args.target_quality.is_some() && args.qp_range.is_some();
        if is_tq {
            encode_tq(chunks, inf, args, idx, work_dir, grain_table);
            return;
        }
    }

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

    let buffer_size = 0;
    let (tx, rx) = bounded::<ChunkData>(buffer_size);
    let rx = Arc::new(rx);

    let decoder = {
        let chunks = chunks.to_vec();
        let idx = Arc::clone(idx);
        let inf = inf.clone();
        thread::spawn(move || decode_chunks(&chunks, &idx, &inf, &tx, &skip_indices))
    };

    let mut workers = Vec::new();
    let quiet = args.quiet;
    for _ in 0..args.worker {
        let rx = Arc::clone(&rx);
        let inf = inf.clone();
        let params = args.params.clone();
        let stats = stats.clone();
        let prog = prog.clone();
        let grain = grain_table.cloned();
        let work_dir = work_dir.to_path_buf();

        let handle = thread::spawn(move || {
            let ctx = WorkerCtx { quiet, grain_table: grain.as_deref() };
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

#[cfg(feature = "vship")]
pub struct ProbeConfig<'a> {
    pub yuv_frames: &'a [Vec<u8>],
    pub inf: &'a VidInf,
    pub params: &'a str,
    pub crf: f32,
    pub probe_name: &'a str,
    pub work_dir: &'a Path,
    pub idx: usize,
    pub crf_score: Option<(f32, Option<f64>)>,
    pub grain_table: Option<&'a Path>,
}

#[cfg(feature = "vship")]
pub fn encode_single_probe(config: &ProbeConfig, prog: Option<&Arc<ProgsTrack>>) {
    let output = config.work_dir.join("split").join(config.probe_name);
    let enc_cfg = EncConfig {
        inf: config.inf,
        params: config.params,
        crf: config.crf,
        output: &output,
        grain_table: config.grain_table,
    };
    let mut cmd = make_enc_cmd(&enc_cfg, false);
    let mut child = cmd.spawn().unwrap_or_else(|_| std::process::exit(1));

    if let Some(p) = prog
        && let Some(stderr) = child.stderr.take()
    {
        p.watch_enc(stderr, config.idx, false, config.crf_score);
    }

    let mut buf = Some(vec![0u8; calc_10bit_size(config.inf)]);
    write_frames(&mut child, config.yuv_frames.to_vec(), config.inf, &mut buf);
    child.wait().unwrap();
}

#[cfg(feature = "vship")]
fn create_tq_worker(
    inf: &VidInf,
    stride: u32,
) -> (crate::zimg::ZimgProcessor, crate::zimg::ZimgProcessor, crate::vship::VshipProcessor) {
    let ref_zimg = crate::zimg::ZimgProcessor::new(
        stride,
        inf.width,
        inf.height,
        inf.is_10bit,
        crate::zimg::ColorParams {
            matrix: inf.matrix_coefficients,
            transfer: inf.transfer_characteristics,
            primaries: inf.color_primaries,
            color_range: inf.color_range,
        },
    )
    .unwrap();

    let dist_zimg = crate::zimg::ZimgProcessor::new(
        stride,
        inf.width,
        inf.height,
        true,
        crate::zimg::ColorParams {
            matrix: inf.matrix_coefficients,
            transfer: inf.transfer_characteristics,
            primaries: inf.color_primaries,
            color_range: inf.color_range,
        },
    )
    .unwrap();

    let vship = crate::vship::VshipProcessor::new(
        inf.width,
        inf.height,
        inf.fps_num as f32 / inf.fps_den as f32,
    )
    .unwrap();

    (ref_zimg, dist_zimg, vship)
}

#[cfg(feature = "vship")]
struct TQChunkConfig<'a> {
    chunks: &'a [Chunk],
    inf: &'a VidInf,
    params: &'a str,
    tq: &'a str,
    qp: &'a str,
    work_dir: &'a Path,
    prog: Option<&'a Arc<ProgsTrack>>,
    stride: u32,
    rgb_size: usize,
    probe_info: &'a crate::tq::ProbeInfoMap,
    stats: Option<&'a Arc<WorkerStats>>,
    grain_table: Option<&'a Path>,
}

#[cfg(feature = "vship")]
fn process_tq_chunk(
    data: &ChunkData,
    config: &TQChunkConfig,
    ref_zimg: &mut crate::zimg::ZimgProcessor,
    dist_zimg: &mut crate::zimg::ZimgProcessor,
    vship: &crate::vship::VshipProcessor,
) {
    let mut ctx = crate::tq::QualityContext {
        chunk: &config.chunks[data.idx],
        yuv_frames: &data.frames,
        inf: config.inf,
        params: config.params,
        work_dir: config.work_dir,
        prog: config.prog,
        ref_zimg,
        dist_zimg,
        vship,
        stride: config.stride,
        rgb_size: config.rgb_size,
        grain_table: config.grain_table,
    };

    if let Some(best) =
        crate::tq::find_target_quality(&mut ctx, config.tq, config.qp, config.probe_info)
    {
        let src = config.work_dir.join("split").join(&best);
        let dst = config.work_dir.join("encode").join(format!("{:04}.ivf", data.idx));
        std::fs::copy(&src, &dst).unwrap();

        if let Some(s) = config.stats {
            let meta = std::fs::metadata(&dst).unwrap();
            let comp = ChunkComp { idx: data.idx, frames: data.frames.len(), size: meta.len() };
            s.frames_done.fetch_add(data.frames.len(), Ordering::Relaxed);
            s.completed.fetch_add(1, Ordering::Relaxed);
            s.add_completion(comp, config.work_dir);
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

    let prog = stats.as_ref().map(|s| {
        Arc::new(ProgsTrack::new(
            chunks,
            inf,
            args.worker,
            0,
            Arc::clone(&s.completed),
            Arc::clone(&s.completions),
        ))
    });

    let probe_info = Arc::new(std::sync::Mutex::new(std::collections::HashMap::new()));

    let (tx, rx) = bounded::<ChunkData>(0);
    let rx = Arc::new(rx);

    let dec = {
        let c = chunks.to_vec();
        let i = Arc::clone(idx);
        let inf = inf.clone();
        thread::spawn(move || {
            decode_chunks(&c, &i, &inf, &tx, &skip_indices);
        })
    };

    let mut workers = Vec::new();
    for _ in 0..args.worker {
        let probe_info = Arc::clone(&probe_info);
        let rx = Arc::clone(&rx);
        let c = chunks.to_vec();
        let inf = inf.clone();
        let params = args.params.clone();
        let tq = args.target_quality.clone().unwrap();
        let qp = args.qp_range.clone().unwrap();
        let stats = stats.clone();
        let prog = prog.clone();
        let wd = work_dir.to_path_buf();
        let grain = grain_table.cloned();

        workers.push(thread::spawn(move || {
            let stride = (inf.width * 2).div_ceil(32) * 32;
            let rgb_size = (inf.width * inf.height * 2) as usize;

            let (mut ref_zimg, mut dist_zimg, vship) = create_tq_worker(&inf, stride);

            let config = TQChunkConfig {
                chunks: &c,
                inf: &inf,
                params: &params,
                tq: &tq,
                qp: &qp,
                work_dir: &wd,
                prog: prog.as_ref(),
                stride,
                rgb_size,
                probe_info: &probe_info,
                stats: stats.as_ref(),
                grain_table: grain.as_deref(),
            };

            while let Ok(data) = rx.recv() {
                process_tq_chunk(&data, &config, &mut ref_zimg, &mut dist_zimg, &vship);
            }
        }));
    }

    dec.join().unwrap();
    for w in workers {
        w.join().unwrap();
    }
    if let Some(p) = prog {
        p.final_update();
    }
}
