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

#[cfg(feature = "vship")]
pub static TQ_SCORES: std::sync::OnceLock<std::sync::Mutex<Vec<f64>>> = std::sync::OnceLock::new();

struct ChunkData {
    idx: usize,
    frames: Vec<u8>,
    frame_size: usize,
    frame_count: usize,
    width: u32,
    height: u32,
}

struct EncConfig<'a> {
    inf: &'a VidInf,
    params: &'a str,
    crf: f32,
    output: &'a Path,
    grain_table: Option<&'a Path>,
}

fn make_enc_cmd(cfg: &EncConfig, quiet: bool, width: u32, height: u32) -> Command {
    let mut cmd = Command::new("SvtAv1EncApp");

    let width_str = width.to_string();
    let height_str = height.to_string();

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
        "0",
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

fn dec_10bit(
    chunks: &[Chunk],
    source: *mut std::ffi::c_void,
    inf: &VidInf,
    tx: &Sender<ChunkData>,
    crop: (u32, u32),
) {
    if crop == (0, 0) {
        let frame_size = calc_10bit_size(inf);
        let packed_size = calc_packed_size(inf);
        let mut frame_buf = vec![0u8; frame_size];

        for chunk in chunks {
            let chunk_len = chunk.end - chunk.start;
            let mut frames_data = vec![0u8; chunk_len * packed_size];
            let mut valid = 0;

            for (i, idx) in (chunk.start..chunk.end).enumerate() {
                let start = i * packed_size;
                let dest = &mut frames_data[start..start + packed_size];

                if extr_10bit(source, idx, &mut frame_buf).is_err() {
                    continue;
                }

                pack_10bit(&frame_buf, dest);
                valid += 1;
            }

            if valid > 0 {
                frames_data.truncate(valid * packed_size);
                tx.send(ChunkData {
                    idx: chunk.idx,
                    frames: frames_data,
                    frame_size: packed_size,
                    frame_count: valid,
                    width: inf.width,
                    height: inf.height,
                })
                .ok();
            }
        }
    } else {
        let (crop_v, crop_h) = crop;
        let new_width = inf.width - crop_h * 2;
        let new_height = inf.height - crop_v * 2;

        let orig_frame_size = calc_10bit_size(inf);
        let new_y_size = (new_width * new_height * 2) as usize;
        let new_uv_size = (new_width * new_height / 2) as usize;
        let new_frame_size = new_y_size + new_uv_size * 2;
        let new_packed_size = (new_frame_size * 5).div_ceil(4);

        let y_stride = (inf.width * 2) as usize;
        let uv_stride = (inf.width / 2 * 2) as usize;
        let y_start = ((crop_v * inf.width + crop_h) as usize) * 2;
        let y_plane_size = (inf.width * inf.height) as usize * 2;
        let uv_plane_size = (inf.width / 2 * inf.height / 2) as usize * 2;
        let u_start = y_plane_size + ((crop_v / 2 * inf.width / 2 + crop_h / 2) as usize * 2);
        let v_start =
            y_plane_size + uv_plane_size + ((crop_v / 2 * inf.width / 2 + crop_h / 2) as usize * 2);
        let y_len = (new_width * 2) as usize;
        let uv_len = (new_width / 2 * 2) as usize;

        let mut frame_buf = vec![0u8; orig_frame_size];
        let mut cropped_buf = vec![0u8; new_frame_size];

        for chunk in chunks {
            let chunk_len = chunk.end - chunk.start;
            let mut frames_data = vec![0u8; chunk_len * new_packed_size];
            let mut valid = 0;

            for (i, idx) in (chunk.start..chunk.end).enumerate() {
                if extr_10bit(source, idx, &mut frame_buf).is_err() {
                    continue;
                }

                let mut pos = 0;

                for row in 0..new_height {
                    let src = y_start + row as usize * y_stride;
                    cropped_buf[pos..pos + y_len].copy_from_slice(&frame_buf[src..src + y_len]);
                    pos += y_len;
                }

                for row in 0..new_height / 2 {
                    let src = u_start + row as usize * uv_stride;
                    cropped_buf[pos..pos + uv_len].copy_from_slice(&frame_buf[src..src + uv_len]);
                    pos += uv_len;
                }

                for row in 0..new_height / 2 {
                    let src = v_start + row as usize * uv_stride;
                    cropped_buf[pos..pos + uv_len].copy_from_slice(&frame_buf[src..src + uv_len]);
                    pos += uv_len;
                }

                let dest_start = i * new_packed_size;
                pack_10bit(
                    &cropped_buf,
                    &mut frames_data[dest_start..dest_start + new_packed_size],
                );
                valid += 1;
            }

            if valid > 0 {
                frames_data.truncate(valid * new_packed_size);
                tx.send(ChunkData {
                    idx: chunk.idx,
                    frames: frames_data,
                    frame_size: new_packed_size,
                    frame_count: valid,
                    width: new_width,
                    height: new_height,
                })
                .ok();
            }
        }
    }
}

fn dec_8bit(
    chunks: &[Chunk],
    source: *mut std::ffi::c_void,
    inf: &VidInf,
    tx: &Sender<ChunkData>,
    crop: (u32, u32),
) {
    if crop == (0, 0) {
        let frame_size = calc_8bit_size(inf);

        for chunk in chunks {
            let chunk_len = chunk.end - chunk.start;
            let mut frames_data = vec![0u8; chunk_len * frame_size];
            let mut valid = 0;

            for (i, idx) in (chunk.start..chunk.end).enumerate() {
                let start = i * frame_size;
                let dest = &mut frames_data[start..start + frame_size];

                if extr_8bit(source, idx, dest).is_ok() {
                    valid += 1;
                }
            }

            if valid > 0 {
                frames_data.truncate(valid * frame_size);
                tx.send(ChunkData {
                    idx: chunk.idx,
                    frames: frames_data,
                    frame_size,
                    frame_count: valid,
                    width: inf.width,
                    height: inf.height,
                })
                .ok();
            }
        }
    } else {
        let (crop_v, crop_h) = crop;
        let new_width = inf.width - crop_h * 2;
        let new_height = inf.height - crop_v * 2;

        let orig_frame_size = calc_8bit_size(inf);
        let new_y_size = (new_width * new_height) as usize;
        let new_uv_size = (new_width * new_height / 4) as usize;
        let new_frame_size = new_y_size + new_uv_size * 2;

        let y_stride = inf.width as usize;
        let uv_stride = (inf.width / 2) as usize;
        let y_start = (crop_v * inf.width + crop_h) as usize;
        let y_plane_size = (inf.width * inf.height) as usize;
        let uv_plane_size = (inf.width / 2 * inf.height / 2) as usize;
        let u_start = y_plane_size + ((crop_v / 2 * inf.width / 2 + crop_h / 2) as usize);
        let v_start =
            y_plane_size + uv_plane_size + ((crop_v / 2 * inf.width / 2 + crop_h / 2) as usize);
        let y_len = new_width as usize;
        let uv_len = (new_width / 2) as usize;

        let mut frame_buf = vec![0u8; orig_frame_size];

        for chunk in chunks {
            let chunk_len = chunk.end - chunk.start;
            let mut frames_data = vec![0u8; chunk_len * new_frame_size];
            let mut valid = 0;

            for (i, idx) in (chunk.start..chunk.end).enumerate() {
                if extr_8bit(source, idx, &mut frame_buf).is_err() {
                    continue;
                }

                let dest_start = i * new_frame_size;
                let mut pos = dest_start;

                for row in 0..new_height {
                    let src = y_start + row as usize * y_stride;
                    frames_data[pos..pos + y_len].copy_from_slice(&frame_buf[src..src + y_len]);
                    pos += y_len;
                }

                for row in 0..new_height / 2 {
                    let src = u_start + row as usize * uv_stride;
                    frames_data[pos..pos + uv_len].copy_from_slice(&frame_buf[src..src + uv_len]);
                    pos += uv_len;
                }

                for row in 0..new_height / 2 {
                    let src = v_start + row as usize * uv_stride;
                    frames_data[pos..pos + uv_len].copy_from_slice(&frame_buf[src..src + uv_len]);
                    pos += uv_len;
                }

                valid += 1;
            }

            if valid > 0 {
                frames_data.truncate(valid * new_frame_size);
                tx.send(ChunkData {
                    idx: chunk.idx,
                    frames: frames_data,
                    frame_size: new_frame_size,
                    frame_count: valid,
                    width: new_width,
                    height: new_height,
                })
                .ok();
            }
        }
    }
}

fn decode_chunks(
    chunks: &[Chunk],
    idx: &Arc<VidIdx>,
    inf: &VidInf,
    tx: &Sender<ChunkData>,
    skip_indices: &HashSet<usize>,
    crop: (u32, u32),
) {
    let threads =
        std::thread::available_parallelism().map_or(8, |n| n.get().try_into().unwrap_or(8));
    let Ok(source) = thr_vid_src(idx, threads) else { return };
    let filtered: Vec<Chunk> =
        chunks.iter().filter(|c| !skip_indices.contains(&c.idx)).cloned().collect();

    if inf.is_10bit {
        dec_10bit(&filtered, source, inf, tx, crop);
    } else {
        dec_8bit(&filtered, source, inf, tx, crop);
    }

    destroy_vid_src(source);
}

#[inline]
fn get_frame(frames: &[u8], i: usize, frame_size: usize) -> &[u8] {
    let start = i * frame_size;
    let end = start + frame_size;
    &frames[start..end]
}

fn write_frames(
    child: &mut std::process::Child,
    frames: &[u8],
    frame_size: usize,
    frame_count: usize,
    inf: &VidInf,
    conversion_buf: &mut Option<Vec<u8>>,
) -> usize {
    let Some(mut stdin) = child.stdin.take() else {
        return 0;
    };

    let mut written = 0;

    if let Some(buf) = conversion_buf {
        if inf.is_10bit {
            for i in 0..frame_count {
                let frame = get_frame(frames, i, frame_size);
                unpack_10bit(frame, buf);
                if stdin.write_all(buf).is_err() {
                    break;
                }
                written += 1;
            }
        } else {
            for i in 0..frame_count {
                let frame = get_frame(frames, i, frame_size);
                conv_to_10bit(frame, buf);
                if stdin.write_all(buf).is_err() {
                    break;
                }
                written += 1;
            }
        }
    } else {
        for i in 0..frame_count {
            let frame = get_frame(frames, i, frame_size);
            if stdin.write_all(frame).is_err() {
                break;
            }
            written += 1;
        }
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
    data: &ChunkData,
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
    let mut cmd = make_enc_cmd(&enc_cfg, config.quiet, data.width, data.height);
    let mut child = cmd.spawn().unwrap_or_else(|_| std::process::exit(1));

    if !config.quiet
        && let Some(stderr) = child.stderr.take()
        && let Some(p) = prog
    {
        p.watch_enc(stderr, data.idx, true, None);
    }

    let frame_count = data.frame_count;
    let written = write_frames(
        &mut child,
        &data.frames,
        data.frame_size,
        data.frame_count,
        config.inf,
        conversion_buf,
    );

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
    let mut current_inf = inf.clone();
    let mut conversion_buf = Some(vec![0u8; calc_10bit_size(&current_inf)]);
    let mut first_chunk = true;

    while let Ok(data) = rx.recv() {
        if first_chunk || (data.width != current_inf.width || data.height != current_inf.height) {
            current_inf.width = data.width;
            current_inf.height = data.height;
            conversion_buf = Some(vec![0u8; calc_10bit_size(&current_inf)]);
            first_chunk = false;
        }

        let config = ProcConfig {
            inf: &current_inf,
            params,
            quiet: ctx.quiet,
            work_dir,
            grain_table: ctx.grain_table,
        };
        let (written, completion) =
            proc_chunk(&data, &config, prog.map(AsRef::as_ref), &mut conversion_buf);

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

    let crop = args.crop.unwrap_or((0, 0));

    let decoder = {
        let chunks = chunks.to_vec();
        let idx = Arc::clone(idx);
        let inf = inf.clone();
        thread::spawn(move || decode_chunks(&chunks, &idx, &inf, &tx, &skip_indices, crop))
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
    pub yuv_frames: &'a [u8],
    pub frame_count: usize,
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
    let mut cmd = make_enc_cmd(&enc_cfg, false, config.inf.width, config.inf.height);
    let mut child = cmd.spawn().unwrap_or_else(|_| std::process::exit(1));

    if let Some(p) = prog
        && let Some(stderr) = child.stderr.take()
    {
        p.watch_enc(stderr, config.idx, false, config.crf_score);
    }

    let mut buf = Some(vec![0u8; calc_10bit_size(config.inf)]);
    let frame_size = config.yuv_frames.len() / config.frame_count;
    write_frames(
        &mut child,
        config.yuv_frames,
        frame_size,
        config.frame_count,
        config.inf,
        &mut buf,
    );
    child.wait().unwrap();
}

#[cfg(feature = "vship")]
fn create_tq_worker(
    inf: &VidInf,
    use_cvvdp: bool,
    use_butteraugli: bool,
) -> crate::vship::VshipProcessor {
    let fps = inf.fps_num as f32 / inf.fps_den as f32;
    crate::vship::VshipProcessor::new(
        inf.width,
        inf.height,
        inf.is_10bit,
        inf.matrix_coefficients,
        inf.transfer_characteristics,
        inf.color_primaries,
        inf.color_range,
        inf.chroma_sample_position,
        fps,
        use_cvvdp,
        use_butteraugli,
    )
    .unwrap()
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
    probe_info: &'a crate::tq::ProbeInfoMap,
    stats: Option<&'a Arc<WorkerStats>>,
    grain_table: Option<&'a Path>,
    metric_mode: &'a str,
    use_cvvdp: bool,
    use_butteraugli: bool,
}

#[cfg(feature = "vship")]
fn process_tq_chunk(
    data: &ChunkData,
    config: &TQChunkConfig,
    vship: &crate::vship::VshipProcessor,
    logger: Option<&crate::tq::ProbeLogger>,
    log_path: &Path,
    work_dir: &Path,
) {
    let mut ctx = crate::tq::QualityContext {
        chunk: &config.chunks[data.idx],
        yuv_frames: &data.frames,
        frame_count: data.frame_count,
        inf: config.inf,
        params: config.params,
        work_dir: config.work_dir,
        prog: config.prog,
        vship,
        grain_table: config.grain_table,
        use_cvvdp: config.use_cvvdp,
        use_butteraugli: config.use_butteraugli,
    };

    if let Some(best) = crate::tq::find_target_quality(
        &mut ctx,
        config.tq,
        config.qp,
        config.probe_info,
        config.metric_mode,
        logger,
        Some(log_path),
        Some(work_dir),
    ) {
        let src = config.work_dir.join("split").join(&best);
        let dst = config.work_dir.join("encode").join(format!("{:04}.ivf", data.idx));
        std::fs::copy(&src, &dst).unwrap();

        if let Some(s) = config.stats {
            let meta = std::fs::metadata(&dst).unwrap();
            let comp = ChunkComp { idx: data.idx, frames: data.frame_count, size: meta.len() };
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
            completed_frames,
            Arc::clone(&s.completed),
            Arc::clone(&s.completions),
        ))
    });

    let probe_info = Arc::new(std::sync::Mutex::new(std::collections::HashMap::new()));
    let logger = Arc::new(std::sync::Mutex::new(Vec::new()));
    let log_path = args.input.with_extension("log");

    let (tx, rx) = bounded::<ChunkData>(0);
    let rx = Arc::new(rx);

    let crop = args.crop.unwrap_or((0, 0));

    let dec = {
        let c = chunks.to_vec();
        let i = Arc::clone(idx);
        let inf = inf.clone();
        thread::spawn(move || {
            decode_chunks(&c, &i, &inf, &tx, &skip_indices, crop);
        })
    };

    crate::vship::init_device().unwrap();

    let mut workers = Vec::new();
    for _ in 0..args.worker {
        let probe_info = Arc::clone(&probe_info);
        let logger = Arc::clone(&logger);
        let rx = Arc::clone(&rx);
        let lp = log_path.clone();
        let c = chunks.to_vec();
        let inf = inf.clone();
        let params = args.params.clone();
        let tq = args.target_quality.clone().unwrap();
        let qp = args.qp_range.clone().unwrap();
        let stats = stats.clone();
        let prog = prog.clone();
        let wd = work_dir.to_path_buf();
        let grain = grain_table.cloned();
        let metric_mode = args.metric_mode.clone();

        let use_cvvdp = {
            let tq_parts: Vec<f64> = tq.split('-').filter_map(|s| s.parse().ok()).collect();
            let target = f64::midpoint(tq_parts[0], tq_parts[1]);
            target > 8.0 && target <= 10.0
        };

        let use_butteraugli = {
            let tq_parts: Vec<f64> = tq.split('-').filter_map(|s| s.parse().ok()).collect();
            let target = f64::midpoint(tq_parts[0], tq_parts[1]);
            target < 8.0
        };

        workers.push(thread::spawn(move || {
            let mut init = false;
            let mut vship = None;
            let mut working_inf = inf.clone();

            while let Ok(data) = rx.recv() {
                if !init {
                    working_inf.width = data.width;
                    working_inf.height = data.height;

                    let vs = create_tq_worker(&working_inf, use_cvvdp, use_butteraugli);
                    vship = Some(vs);
                    init = true;
                }

                let config = TQChunkConfig {
                    chunks: &c,
                    inf: &working_inf,
                    params: &params,
                    tq: &tq,
                    qp: &qp,
                    work_dir: &wd,
                    prog: prog.as_ref(),
                    probe_info: &probe_info,
                    stats: stats.as_ref(),
                    grain_table: grain.as_deref(),
                    metric_mode: &metric_mode,
                    use_cvvdp,
                    use_butteraugli,
                };

                process_tq_chunk(&data, &config, vship.as_ref().unwrap(), Some(&logger), &lp, &wd);
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

    write_tq_log(&args.input, work_dir);
}

#[cfg(feature = "vship")]
pub fn write_chunk_log(chunk_log: &crate::tq::ProbeLog, log_path: &Path, work_dir: &Path) {
    use std::fmt::Write;
    use std::fs::OpenOptions;
    use std::io::Write as IoWrite;

    let chunks_path = work_dir.join("chunks.log");
    let mut content = String::new();
    let probes_str = chunk_log
        .probes
        .iter()
        .map(|(c, s)| format!("({c:.2}, {s:.2})"))
        .collect::<Vec<_>>()
        .join(", ");
    let _ = writeln!(
        content,
        "{:04}:{}:{}:{:.2}:{:.2}",
        chunk_log.chunk_idx,
        chunk_log.probes.len(),
        chunk_log.round,
        chunk_log.final_crf,
        chunk_log.final_score
    );

    if let Ok(mut file) = OpenOptions::new().create(true).append(true).open(chunks_path) {
        let _ = file.write_all(content.as_bytes());
    }

    let mut readable = String::new();
    let _ = writeln!(
        readable,
        "{:04}: [{}] = {:.2}, {:.2}",
        chunk_log.chunk_idx, probes_str, chunk_log.final_crf, chunk_log.final_score
    );

    if let Ok(mut file) = OpenOptions::new().create(true).append(true).open(log_path) {
        let _ = file.write_all(readable.as_bytes());
    }
}

#[cfg(feature = "vship")]
fn write_tq_log(input: &Path, work_dir: &Path) {
    use std::collections::HashMap;
    use std::fmt::Write;
    use std::fs::OpenOptions;
    use std::io::Write as IoWrite;

    let log_path = input.with_extension("log");
    let chunks_path = work_dir.join("chunks.log");

    let mut all_logs = Vec::new();

    if let Ok(content) = std::fs::read_to_string(&chunks_path) {
        for line in content.lines() {
            let parts: Vec<&str> = line.split(':').collect();
            if parts.len() == 5
                && let (Ok(idx), Ok(probes), Ok(round), Ok(crf), Ok(score)) = (
                    parts[0].parse::<usize>(),
                    parts[1].parse::<usize>(),
                    parts[2].parse::<usize>(),
                    parts[3].parse::<f64>(),
                    parts[4].parse::<f64>(),
                )
            {
                all_logs.push((idx, probes, round, crf, score));
            }
        }
    }

    let total = all_logs.len();
    if total == 0 {
        return;
    }

    let avg_probes = all_logs.iter().map(|(_, p, _, _, _)| p).sum::<usize>() as f64 / total as f64;
    let in_range = all_logs.iter().filter(|(_, _, r, _, _)| *r < 10).count();
    let out_range = total - in_range;

    let mut round_counts: HashMap<usize, usize> = HashMap::new();
    let mut crf_counts: HashMap<String, usize> = HashMap::new();

    for (_, probes, _, crf, _) in &all_logs {
        *round_counts.entry(*probes).or_insert(0) += 1;
        *crf_counts.entry(format!("{crf:.2}")).or_insert(0) += 1;
    }

    let mut summary = String::new();
    let _ = writeln!(summary, "\nAverage No of Probes: {avg_probes:.1}");
    let _ = writeln!(summary, "In-range: {in_range} chunks");
    let _ = writeln!(summary, "Out-range: {out_range} chunks\n");

    let method_name = |round: usize| match round {
        3 => "linear",
        4 => "natural",
        5 => "PCHIP",
        6 => "AKIMA",
        _ => "binary",
    };

    let mut rounds: Vec<_> = round_counts.iter().collect();
    rounds.sort_by_key(|(r, _)| *r);

    for (round, count) in rounds {
        let pct = *count as f64 / total as f64 * 100.0;
        let _ = writeln!(
            summary,
            "{round} probe finish: {count} scenes ({}) -> {pct:.2}%",
            method_name(*round)
        );
    }

    let mut crfs: Vec<_> = crf_counts.iter().collect();
    crfs.sort_by(|(_, a), (_, b)| b.cmp(a));

    let _ = writeln!(summary, "\nMost popular CRFs:");
    for (crf, count) in crfs {
        let _ = writeln!(summary, "{crf}: {count} times");
    }

    if let Ok(mut file) = OpenOptions::new().create(true).append(true).open(&log_path) {
        let _ = file.write_all(summary.as_bytes());
    }
}
