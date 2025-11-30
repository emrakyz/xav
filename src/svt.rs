use std::collections::HashSet;
use std::io::Write;
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};
use std::sync::Arc;
use std::thread;

#[cfg(feature = "vship")]
use crossbeam_channel::select;
use crossbeam_channel::{Sender, bounded};

use crate::FrameLayout;
use crate::chunk::{Chunk, ChunkComp, ResumeInf, get_resume};
use crate::ffms::{
    VidIdx, VidInf, calc_8bit_size, calc_10bit_size, calc_packed_size, conv_to_10bit,
    destroy_vid_src, extr_8bit, extr_8bit_crop, extr_8bit_stride, extr_10bit_crop_pack_stride,
    extr_10bit_pack, extr_10bit_pack_stride, extr_pack_10bit_crop, thr_vid_src, unpack_10bit,
};
use crate::progs::ProgsTrack;
#[cfg(feature = "vship")]
use crate::worker::TQState;

#[cfg(feature = "vship")]
pub static TQ_SCORES: std::sync::OnceLock<std::sync::Mutex<Vec<f64>>> = std::sync::OnceLock::new();

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
        if quiet { "0" } else { "2" },
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

pub struct CropCalc {
    pub new_w: u32,
    pub new_h: u32,
    pub y_stride: usize,
    pub uv_stride: usize,
    pub y_start: usize,
    pub u_start: usize,
    pub v_start: usize,
    pub y_len: usize,
    pub uv_len: usize,
}

impl CropCalc {
    const fn new(inf: &VidInf, crop: (u32, u32), pixel_sz: usize) -> Self {
        let (crop_v, crop_h) = crop;
        let new_w = inf.width - crop_h * 2;
        let new_h = inf.height - crop_v * 2;

        let y_stride = (inf.width * pixel_sz as u32) as usize;
        let uv_stride = (inf.width / 2 * pixel_sz as u32) as usize;
        let y_start = ((crop_v * inf.width + crop_h) as usize) * pixel_sz;
        let y_plane_sz = (inf.width * inf.height) as usize * pixel_sz;
        let uv_plane_sz = (inf.width / 2 * inf.height / 2) as usize * pixel_sz;
        let u_start = y_plane_sz + ((crop_v / 2 * inf.width / 2 + crop_h / 2) as usize * pixel_sz);
        let v_start = y_plane_sz
            + uv_plane_sz
            + ((crop_v / 2 * inf.width / 2 + crop_h / 2) as usize * pixel_sz);
        let y_len = (new_w * pixel_sz as u32) as usize;
        let uv_len = (new_w / 2 * pixel_sz as u32) as usize;

        Self { new_w, new_h, y_stride, uv_stride, y_start, u_start, v_start, y_len, uv_len }
    }

    fn crop_frame(&self, src: &[u8], dst: &mut [u8]) {
        let mut pos = 0;

        for row in 0..self.new_h {
            let src_off = self.y_start + row as usize * self.y_stride;
            dst[pos..pos + self.y_len].copy_from_slice(&src[src_off..src_off + self.y_len]);
            pos += self.y_len;
        }

        for row in 0..self.new_h / 2 {
            let src_off = self.u_start + row as usize * self.uv_stride;
            dst[pos..pos + self.uv_len].copy_from_slice(&src[src_off..src_off + self.uv_len]);
            pos += self.uv_len;
        }

        for row in 0..self.new_h / 2 {
            let src_off = self.v_start + row as usize * self.uv_stride;
            dst[pos..pos + self.uv_len].copy_from_slice(&src[src_off..src_off + self.uv_len]);
            pos += self.uv_len;
        }
    }
}

fn dec_10bit(
    chunks: &[Chunk],
    source: *mut std::ffi::c_void,
    inf: &VidInf,
    tx: &Sender<crate::worker::WorkPkg>,
    crop: (u32, u32),
    frame_layout: Option<FrameLayout>,
) {
    let crop_calc = (crop != (0, 0)).then(|| CropCalc::new(inf, crop, 2));
    let (width, height, packed_sz) = crop_calc.as_ref().map_or_else(
        || (inf.width, inf.height, calc_packed_size(inf)),
        |c| {
            let new_y_sz = (c.new_w * c.new_h * 2) as usize;
            let new_uv_sz = (c.new_w * c.new_h / 2) as usize;
            let new_frame_sz = new_y_sz + new_uv_sz * 2;
            (c.new_w, c.new_h, (new_frame_sz * 5).div_ceil(4))
        },
    );

    match (crop == (0, 0), frame_layout) {
        (true, Some(fl)) if !fl.has_padding && fl.is_contiguous => {
            for chunk in chunks {
                let chunk_len = chunk.end - chunk.start;
                let mut frames_data = vec![0u8; chunk_len * packed_sz];

                for (i, idx) in (chunk.start..chunk.end).enumerate() {
                    let dst = &mut frames_data[i * packed_sz..(i + 1) * packed_sz];
                    extr_10bit_pack(source, idx, dst, inf);
                }

                let pkg = crate::worker::WorkPkg::new(
                    chunk.clone(),
                    frames_data,
                    chunk_len,
                    width,
                    height,
                );
                tx.send(pkg).ok();
            }
        }

        (false, Some(fl)) if !fl.has_padding && fl.is_contiguous => {
            for chunk in chunks {
                let chunk_len = chunk.end - chunk.start;
                let mut frames_data = vec![0u8; chunk_len * packed_sz];

                for (i, idx) in (chunk.start..chunk.end).enumerate() {
                    let dst = &mut frames_data[i * packed_sz..(i + 1) * packed_sz];
                    let calc = crop_calc.as_ref().unwrap();
                    extr_pack_10bit_crop(
                        source,
                        idx,
                        calc.new_w,
                        calc.new_h,
                        calc.y_start,
                        calc.u_start,
                        dst,
                    );
                }

                let pkg = crate::worker::WorkPkg::new(
                    chunk.clone(),
                    frames_data,
                    chunk_len,
                    width,
                    height,
                );
                tx.send(pkg).ok();
            }
        }

        (true, _) => {
            for chunk in chunks {
                let chunk_len = chunk.end - chunk.start;
                let mut frames_data = vec![0u8; chunk_len * packed_sz];

                for (i, idx) in (chunk.start..chunk.end).enumerate() {
                    let dst = &mut frames_data[i * packed_sz..(i + 1) * packed_sz];
                    extr_10bit_pack_stride(source, idx, dst, inf);
                }

                let pkg = crate::worker::WorkPkg::new(
                    chunk.clone(),
                    frames_data,
                    chunk_len,
                    width,
                    height,
                );
                tx.send(pkg).ok();
            }
        }

        (false, _) => {
            for chunk in chunks {
                let chunk_len = chunk.end - chunk.start;
                let mut frames_data = vec![0u8; chunk_len * packed_sz];

                for (i, idx) in (chunk.start..chunk.end).enumerate() {
                    let dst = &mut frames_data[i * packed_sz..(i + 1) * packed_sz];
                    let calc = crop_calc.as_ref().unwrap();
                    extr_10bit_crop_pack_stride(source, idx, dst, calc);
                }

                let pkg = crate::worker::WorkPkg::new(
                    chunk.clone(),
                    frames_data,
                    chunk_len,
                    width,
                    height,
                );
                tx.send(pkg).ok();
            }
        }
    }
}

fn dec_8bit(
    chunks: &[Chunk],
    source: *mut std::ffi::c_void,
    inf: &VidInf,
    tx: &Sender<crate::worker::WorkPkg>,
    crop: (u32, u32),
    frame_layout: Option<FrameLayout>,
) {
    let crop_calc = (crop != (0, 0)).then(|| CropCalc::new(inf, crop, 1));
    let (width, height, frame_sz) = crop_calc.as_ref().map_or_else(
        || (inf.width, inf.height, calc_8bit_size(inf)),
        |c| {
            let new_y_sz = (c.new_w * c.new_h) as usize;
            let new_uv_sz = (c.new_w * c.new_h / 4) as usize;
            (c.new_w, c.new_h, new_y_sz + new_uv_sz * 2)
        },
    );

    match (crop == (0, 0), frame_layout) {
        (true, Some(fl)) if !fl.has_padding && fl.is_contiguous => {
            for chunk in chunks {
                let chunk_len = chunk.end - chunk.start;
                let mut frames_data = vec![0u8; chunk_len * frame_sz];

                for (i, idx) in (chunk.start..chunk.end).enumerate() {
                    let dst = &mut frames_data[i * frame_sz..(i + 1) * frame_sz];
                    unsafe {
                        let frame = crate::ffms::get_raw_frame(source, idx);
                        let total = inf.width as usize * inf.height as usize * 3 / 2;
                        std::ptr::copy_nonoverlapping((*frame).data[0], dst.as_mut_ptr(), total);
                    }
                }

                let pkg = crate::worker::WorkPkg::new(
                    chunk.clone(),
                    frames_data,
                    chunk_len,
                    width,
                    height,
                );
                tx.send(pkg).ok();
            }
        }

        (false, Some(fl)) if !fl.has_padding && fl.is_contiguous => {
            for chunk in chunks {
                let chunk_len = chunk.end - chunk.start;
                let mut frames_data = vec![0u8; chunk_len * frame_sz];

                for (i, idx) in (chunk.start..chunk.end).enumerate() {
                    let dst = &mut frames_data[i * frame_sz..(i + 1) * frame_sz];
                    let calc = crop_calc.as_ref().unwrap();
                    extr_8bit_crop(source, idx, dst, calc);
                }

                let pkg = crate::worker::WorkPkg::new(
                    chunk.clone(),
                    frames_data,
                    chunk_len,
                    width,
                    height,
                );
                tx.send(pkg).ok();
            }
        }

        (true, _) => {
            for chunk in chunks {
                let chunk_len = chunk.end - chunk.start;
                let mut frames_data = vec![0u8; chunk_len * frame_sz];

                for (i, idx) in (chunk.start..chunk.end).enumerate() {
                    let dst = &mut frames_data[i * frame_sz..(i + 1) * frame_sz];
                    extr_8bit_stride(source, idx, dst, inf);
                }

                let pkg = crate::worker::WorkPkg::new(
                    chunk.clone(),
                    frames_data,
                    chunk_len,
                    width,
                    height,
                );
                tx.send(pkg).ok();
            }
        }

        (false, _) => {
            let frame_layout_ref = frame_layout.as_ref().unwrap();
            let mut frame_buf = vec![0u8; calc_8bit_size(inf)];

            for chunk in chunks {
                let chunk_len = chunk.end - chunk.start;
                let mut frames_data = vec![0u8; chunk_len * frame_sz];

                for (i, idx) in (chunk.start..chunk.end).enumerate() {
                    extr_8bit(source, idx, &mut frame_buf, inf, frame_layout_ref);
                    let dst = &mut frames_data[i * frame_sz..(i + 1) * frame_sz];
                    let calc = crop_calc.as_ref().unwrap();
                    calc.crop_frame(&frame_buf, dst);
                }

                let pkg = crate::worker::WorkPkg::new(
                    chunk.clone(),
                    frames_data,
                    chunk_len,
                    width,
                    height,
                );
                tx.send(pkg).ok();
            }
        }
    }
}

fn decode_chunks(
    chunks: &[Chunk],
    idx: &Arc<VidIdx>,
    inf: &VidInf,
    tx: &Sender<crate::worker::WorkPkg>,
    skip_indices: &HashSet<usize>,
    crop: (u32, u32),
    frame_layout: Option<FrameLayout>,
) {
    let threads =
        std::thread::available_parallelism().map_or(8, |n| n.get().try_into().unwrap_or(8));
    let Ok(source) = thr_vid_src(idx, threads) else { return };
    let filtered: Vec<Chunk> =
        chunks.iter().filter(|c| !skip_indices.contains(&c.idx)).cloned().collect();

    if inf.is_10bit {
        dec_10bit(&filtered, source, inf, tx, crop, frame_layout);
    } else {
        dec_8bit(&filtered, source, inf, tx, crop, frame_layout);
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
        let mut data = self.completions.lock().unwrap();
        data.chnks_done.push(completion);
        let _ = crate::chunk::save_resume(&data, work_dir);
        drop(data);
    }
}

fn load_resume_data(work_dir: &Path, resume: bool) -> ResumeInf {
    if resume {
        get_resume(work_dir).unwrap_or(ResumeInf { chnks_done: Vec::new() })
    } else {
        ResumeInf { chnks_done: Vec::new() }
    }
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

fn create_progress(
    quiet: bool,
    chunks: &[Chunk],
    inf: &VidInf,
    worker_count: usize,
    completed_frames: usize,
    stats: &Arc<WorkerStats>,
) -> Option<Arc<ProgsTrack>> {
    if quiet {
        None
    } else {
        Some(Arc::new(ProgsTrack::new(
            chunks,
            inf,
            worker_count,
            completed_frames,
            Arc::clone(&stats.completed),
            Arc::clone(&stats.completions),
        )))
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
    let resume_data = load_resume_data(work_dir, args.resume);

    #[cfg(feature = "vship")]
    {
        let is_tq = args.target_quality.is_some() && args.qp_range.is_some();
        if is_tq {
            encode_tq(chunks, inf, args, idx, work_dir, grain_table);
            return;
        }
    }

    let (skip_indices, completed_count, completed_frames) = build_skip_set(&resume_data);
    let stats = Some(create_stats(completed_count, resume_data));
    let prog = create_progress(
        args.quiet,
        chunks,
        inf,
        args.worker,
        completed_frames,
        stats.as_ref().unwrap(),
    );
    let crop = args.crop.unwrap_or((0, 0));

    let (tx, rx) = bounded::<crate::worker::WorkPkg>(0);
    let rx = Arc::new(rx);

    let decoder = {
        let chunks = chunks.to_vec();
        let idx = Arc::clone(idx);
        let inf = inf.clone();
        let frame_layout = args.frame_layout;
        thread::spawn(move || {
            decode_chunks(&chunks, &idx, &inf, &tx, &skip_indices, crop, frame_layout);
        })
    };

    let mut workers = Vec::new();
    for worker_id in 0..args.worker {
        let rx_clone = Arc::clone(&rx);
        let inf = inf.clone();
        let params = args.params.clone();
        let stats_clone = stats.clone();
        let grain = grain_table.cloned();
        let wd = work_dir.to_path_buf();
        let prog_clone = prog.clone();
        let wid = worker_id;

        let handle = thread::spawn(move || {
            run_enc_worker(
                &rx_clone,
                &params,
                &inf,
                &wd,
                grain.as_deref(),
                stats_clone.as_ref(),
                prog_clone.as_ref(),
                wid,
            );
        });
        workers.push(handle);
    }

    decoder.join().unwrap();

    for handle in workers {
        handle.join().unwrap();
    }
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
    log_path: &Path,
    round: usize,
    final_crf: f64,
    final_score: f64,
    probes: &[crate::tq::Probe],
    use_cvvdp: bool,
) {
    let dst = work_dir.join("encode").join(format!("{chunk_idx:04}.ivf"));
    std::fs::copy(probe_path, &dst).unwrap();
    done_tx.send(chunk_idx).unwrap();

    let file_size = std::fs::metadata(&dst).map(|m| m.len()).unwrap_or(0);
    let comp = crate::chunk::ChunkComp { idx: chunk_idx, frames: chunk_frames, size: file_size };

    let mut resume = resume_state.lock().unwrap();
    resume.chnks_done.push(comp.clone());
    crate::chunk::save_resume(&resume, work_dir).ok();
    drop(resume);

    if let Some(s) = stats {
        s.completed.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        s.completions.lock().unwrap().chnks_done.push(comp);
    }

    let log_entry = crate::tq::ProbeLog {
        chunk_idx,
        probes: probes.iter().map(|p| (p.crf, p.score)).collect(),
        final_crf,
        final_score,
        round,
    };
    write_chunk_log(&log_entry, log_path, work_dir);
    tq_logger.lock().unwrap().push(log_entry);

    let mut tq_scores = TQ_SCORES.get_or_init(|| std::sync::Mutex::new(Vec::new())).lock().unwrap();

    if use_cvvdp {
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
    work_dir: &Path,
    metric_mode: &str,
    stats: Option<&Arc<WorkerStats>>,
    resume_state: &Arc<std::sync::Mutex<crate::chunk::ResumeInf>>,
    tq_logger: &Arc<std::sync::Mutex<Vec<crate::tq::ProbeLog>>>,
    log_path: &Path,
    prog: Option<&Arc<crate::progs::ProgsTrack>>,
    worker_id: usize,
    worker_count: usize,
    tq_ctx: &TQCtx,
) {
    let mut vship: Option<crate::vship::VshipProcessor> = None;
    let mut unpacked_buf: Option<Vec<u8>> = None;

    while let Ok(mut pkg) = rx.recv() {
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
                )
                .unwrap(),
            );

            if inf.is_10bit {
                let mut cropped_inf = inf.clone();
                cropped_inf.width = pkg.width;
                cropped_inf.height = pkg.height;
                unpacked_buf = Some(vec![0u8; crate::ffms::calc_10bit_size(&cropped_inf)]);
            }
        }

        let tq_st = pkg.tq_state.as_ref().unwrap();
        let crf = tq_st.last_crf;
        let probe_path =
            work_dir.join("split").join(format!("{:04}_{:.2}.ivf", pkg.chunk.idx, crf));
        let last_score = tq_st.probes.last().map(|probe| probe.score);
        let metrics_slot = worker_count + worker_id;

        let (score, frame_scores) = crate::tq::calc_metrics(
            &pkg,
            &probe_path,
            inf,
            vship.as_ref().unwrap(),
            metric_mode,
            tq_ctx.use_cvvdp,
            tq_ctx.use_butteraugli,
            unpacked_buf.as_mut(),
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
            complete_chunk(
                pkg.chunk.idx,
                pkg.frame_count,
                &probe_path,
                work_dir,
                done_tx,
                resume_state,
                stats,
                tq_logger,
                log_path,
                tq_state.round,
                tq_state.last_crf,
                score,
                &tq_state.probes,
                tq_ctx.use_cvvdp,
            );
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
) {
    let resume_data = load_resume_data(work_dir, args.resume);
    let (skip_indices, completed_count, completed_frames) = build_skip_set(&resume_data);

    let tq_str = args.target_quality.as_ref().unwrap();
    let qp_str = args.qp_range.as_ref().unwrap();
    let tq_parts: Vec<f64> = tq_str.split('-').filter_map(|s| s.parse().ok()).collect();
    let qp_parts: Vec<f64> = qp_str.split('-').filter_map(|s| s.parse().ok()).collect();
    let tq_target = f64::midpoint(tq_parts[0], tq_parts[1]);
    let tq_tolerance = (tq_parts[1] - tq_parts[0]) / 2.0;

    let tq_ctx = TQCtx {
        target: tq_target,
        tolerance: tq_tolerance,
        qp_min: qp_parts[0],
        qp_max: qp_parts[1],
        use_butteraugli: tq_target < 8.0,
        use_cvvdp: tq_target > 8.0 && tq_target <= 10.0,
    };

    let (enc_tx, enc_rx) = bounded::<crate::worker::WorkPkg>(0);
    let (met_tx, met_rx) = bounded::<crate::worker::WorkPkg>(0);
    let (rework_tx, rework_rx) = bounded::<crate::worker::WorkPkg>(0);
    let (done_tx, done_rx) = bounded::<usize>(0);

    let enc_rx = Arc::new(enc_rx);
    let met_rx = Arc::new(met_rx);

    let total_chunks = chunks.iter().filter(|c| !skip_indices.contains(&c.idx)).count();

    let bg_thread = {
        let chunks = chunks.to_vec();
        let idx = Arc::clone(idx);
        let inf = inf.clone();
        let enc_tx = enc_tx.clone();
        let worker_count = args.worker;
        let crop = args.crop.unwrap_or((0, 0));
        let frame_layout = args.frame_layout;

        thread::spawn(move || {
            let (decode_tx, decode_rx) = bounded::<crate::worker::WorkPkg>(1);
            let inf_decode = inf.clone();
            let decoder_handle = thread::spawn(move || {
                decode_chunks(
                    &chunks,
                    &idx,
                    &inf_decode,
                    &decode_tx,
                    &skip_indices,
                    crop,
                    frame_layout,
                );
            });

            let mut in_flight = 0;
            let max_in_flight = worker_count + 1;
            let mut completed = 0;

            while completed < total_chunks {
                if in_flight < max_in_flight {
                    select! {
                        recv(decode_rx) -> pkg => {
                            if let Ok(pkg) = pkg {
                                enc_tx.send(pkg).unwrap();
                                in_flight += 1;
                            }
                        }
                        recv(rework_rx) -> pkg => {
                            if let Ok(pkg) = pkg {
                                enc_tx.send(pkg).unwrap();
                            }
                        }
                        recv(done_rx) -> result => {
                            if result.is_ok() {
                                in_flight -= 1;
                                completed += 1;
                            }
                        }
                    }
                } else {
                    select! {
                        recv(rework_rx) -> pkg => {
                            if let Ok(pkg) = pkg {
                                enc_tx.send(pkg).unwrap();
                            }
                        }
                        recv(done_rx) -> result => {
                            if result.is_ok() {
                                in_flight -= 1;
                                completed += 1;
                            }
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
    let prog = create_progress(
        args.quiet,
        chunks,
        inf,
        args.worker * 2,
        completed_frames,
        stats.as_ref().unwrap(),
    );
    let log_path = args.input.with_extension("log");

    let mut metrics_workers = Vec::new();
    for worker_id in 0..args.worker {
        let rx = Arc::clone(&met_rx);
        let rework_tx = rework_tx.clone();
        let done_tx = done_tx.clone();
        let inf = inf.clone();
        let wd = work_dir.to_path_buf();
        let metric_mode = args.metric_mode.clone();
        let st = stats.clone();
        let resume_state = Arc::clone(&resume_state);
        let tq_logger = Arc::clone(&tq_logger);
        let log_path = log_path.clone();
        let prog_clone = prog.clone();
        let worker_count = args.worker;

        metrics_workers.push(thread::spawn(move || {
            run_metrics_worker(
                &rx,
                &rework_tx,
                &done_tx,
                &inf,
                &wd,
                &metric_mode,
                st.as_ref(),
                &resume_state,
                &tq_logger,
                &log_path,
                prog_clone.as_ref(),
                worker_id,
                worker_count,
                &tq_ctx,
            );
        }));
    }

    let mut workers = Vec::new();
    for worker_id in 0..args.worker {
        let rx = Arc::clone(&enc_rx);
        let tx = met_tx.clone();
        let inf = inf.clone();
        let params = args.params.clone();
        let wd = work_dir.to_path_buf();
        let grain = grain_table.cloned();
        let prog_clone = prog.clone();
        let qp_min = tq_ctx.qp_min;
        let qp_max = tq_ctx.qp_max;
        let target = tq_ctx.target;

        workers.push(thread::spawn(move || {
            let mut conv_buf: Option<Vec<u8>> = None;

            while let Ok(mut pkg) = rx.recv() {
                if conv_buf.is_none() {
                    let mut cropped_inf = inf.clone();
                    cropped_inf.width = pkg.width;
                    cropped_inf.height = pkg.height;
                    conv_buf = Some(vec![0u8; crate::ffms::calc_10bit_size(&cropped_inf)]);
                }

                if pkg.tq_state.is_none() {
                    pkg.tq_state = Some(crate::worker::TQState {
                        probes: Vec::new(),
                        search_min: qp_min,
                        search_max: qp_max,
                        round: 1,
                        target,
                        last_crf: 0.0,
                    });
                } else {
                    pkg.tq_state.as_mut().unwrap().round += 1;
                }

                let current_round = pkg.tq_state.as_ref().unwrap().round;
                let tq = pkg.tq_state.as_ref().unwrap();
                let crf = if current_round <= 2 || current_round > 6 {
                    crate::tq::binary_search(tq.search_min, tq.search_max)
                } else {
                    crate::tq::interpolate_crf(&tq.probes, tq.target, current_round)
                        .unwrap_or_else(|| crate::tq::binary_search(tq.search_min, tq.search_max))
                }
                .clamp(tq.search_min, tq.search_max);

                pkg.tq_state.as_mut().unwrap().last_crf = crf;

                enc_tq_probe(
                    &pkg,
                    crf,
                    &params,
                    &inf,
                    &wd,
                    grain.as_deref(),
                    &mut conv_buf,
                    prog_clone.as_ref(),
                    worker_id,
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

    write_tq_log(&args.input, work_dir);
}

#[cfg(feature = "vship")]
fn enc_tq_probe(
    pkg: &crate::worker::WorkPkg,
    crf: f64,
    params: &str,
    inf: &VidInf,
    work_dir: &Path,
    grain: Option<&Path>,
    conv_buf: &mut Option<Vec<u8>>,
    prog: Option<&Arc<ProgsTrack>>,
    worker_id: usize,
) -> PathBuf {
    let name = format!("{:04}_{:.2}.ivf", pkg.chunk.idx, crf);
    let out = work_dir.join("split").join(&name);
    let cfg = EncConfig { inf, params, crf: crf as f32, output: &out, grain_table: grain };
    let mut cmd = make_enc_cmd(&cfg, false, pkg.width, pkg.height);
    let mut child = cmd.spawn().unwrap();

    if let Some(p) = prog {
        let stderr = child.stderr.take().unwrap();
        let last_score =
            pkg.tq_state.as_ref().and_then(|tq| tq.probes.last().map(|probe| probe.score));
        p.watch_enc(stderr, worker_id, pkg.chunk.idx, false, Some((crf as f32, last_score)));
    }

    let frame_size = pkg.yuv.len() / pkg.frame_count;

    write_frames(&mut child, &pkg.yuv, frame_size, pkg.frame_count, inf, conv_buf);

    let status = child.wait().unwrap();
    if !status.success() {
        std::process::exit(1);
    }

    out
}

fn run_enc_worker(
    rx: &Arc<crossbeam_channel::Receiver<crate::worker::WorkPkg>>,
    params: &str,
    inf: &VidInf,
    work_dir: &Path,
    grain: Option<&Path>,
    stats: Option<&Arc<WorkerStats>>,
    prog: Option<&Arc<ProgsTrack>>,
    worker_id: usize,
) {
    let mut conv_buf: Option<Vec<u8>> = None;

    while let Ok(pkg) = rx.recv() {
        if conv_buf.is_none() {
            let mut cropped_inf = inf.clone();
            cropped_inf.width = pkg.width;
            cropped_inf.height = pkg.height;
            conv_buf = Some(vec![0u8; calc_10bit_size(&cropped_inf)]);
        }

        enc_chunk(&pkg, -1.0, params, inf, work_dir, grain, &mut conv_buf, prog, worker_id);

        if let Some(s) = stats {
            s.completed.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
            let out = work_dir.join("encode").join(format!("{:04}.ivf", pkg.chunk.idx));
            let file_size = std::fs::metadata(&out).map(|m| m.len()).unwrap_or(0);
            let comp = crate::chunk::ChunkComp {
                idx: pkg.chunk.idx,
                frames: pkg.frame_count,
                size: file_size,
            };
            s.add_completion(comp, work_dir);
        }
    }
}

fn enc_chunk(
    pkg: &crate::worker::WorkPkg,
    crf: f32,
    params: &str,
    inf: &VidInf,
    work_dir: &Path,
    grain: Option<&Path>,
    conv_buf: &mut Option<Vec<u8>>,
    prog: Option<&Arc<ProgsTrack>>,
    worker_id: usize,
) {
    let out = work_dir.join("encode").join(format!("{:04}.ivf", pkg.chunk.idx));
    let cfg = EncConfig { inf, params, crf, output: &out, grain_table: grain };
    let mut cmd = make_enc_cmd(&cfg, false, pkg.width, pkg.height);
    cmd.stderr(std::process::Stdio::piped());
    let mut child = cmd.spawn().unwrap();

    if let Some(p) = prog {
        let stderr = child.stderr.take().unwrap();
        p.watch_enc(stderr, worker_id, pkg.chunk.idx, true, None);
    }

    let frame_size = pkg.yuv.len() / pkg.frame_count;

    write_frames(&mut child, &pkg.yuv, frame_size, pkg.frame_count, inf, conv_buf);

    let status = child.wait().unwrap();
    if !status.success() {
        std::process::exit(1);
    }
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
