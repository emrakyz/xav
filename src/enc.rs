#[cfg(feature = "vship")]
use alloc::collections::BTreeMap;
#[cfg(all(target_os = "linux", feature = "vship"))]
use alloc::string::String;
#[cfg(target_os = "linux")]
use alloc::{boxed::Box, vec::Vec};
use alloc::{collections::BTreeSet, sync::Arc};
#[cfg(any(feature = "avm", feature = "vvenc"))]
use core::ffi::c_void;
#[cfg(feature = "avm")]
use core::ptr::null;
#[cfg(feature = "vvenc")]
use core::ptr::write_bytes;
#[cfg(feature = "vship")]
use core::{fmt::Write as _, mem::swap};
use core::{
    hint::cold_path,
    mem::{MaybeUninit, size_of, transmute, zeroed},
    ptr::{copy_nonoverlapping, null_mut},
    slice::from_raw_parts,
    sync::atomic::{AtomicU64, AtomicUsize, Ordering::Relaxed},
};

#[cfg(feature = "avm")]
use crate::avm::{
    AVM_CFG_SIZE, AVM_CODEC_CX_FRAME_PKT, AVM_CODEC_OK, AVM_CTRL_CNT, AVM_IMG_FMT_I42016,
    AVM_MAX_LAG, AVM_TMPL_HDR, AvmCodecCtx, AvmCodecEncCfg, AvmImage, AvmTmpl, avm_blit,
    avm_codec_av2_cx, avm_codec_destroy, avm_codec_enc_config_default, avm_codec_encode,
    avm_codec_get_cx_data, avm_init, avm_snapshot, avm_split, set_avm_base,
};
#[cfg(feature = "vship")]
use crate::chan::{mpmc_close, mpmc_recv, mpmc_send, mpsc_recv, mpsc_send};
#[cfg(all(target_os = "linux", not(test), feature = "vship"))]
use crate::fmath::FloatExt as _;
#[cfg(not(target_os = "linux"))]
use crate::path::PathBuf;
#[cfg(all(feature = "vvenc", feature = "vship"))]
use crate::tq::{
    calc_butter_8b_vvdec, calc_butter_10b_vvdec, calc_butter_rem_vvdec, calc_cvvdp_8b_vvdec,
    calc_cvvdp_10b_vvdec, calc_cvvdp_rem_vvdec, calc_ssimu2_8b_vvdec, calc_ssimu2_10b_vvdec,
    calc_ssimu2_rem_vvdec, make_vvdec, prep_vvdec,
};
use crate::{
    Args,
    chan::{Semaphore, SeqRing, sem_release, spmc_close, spmc_recv, spmc_send},
    chunk::{Chunk, ChunkComp, ResumeInf, get_resume, save_resume, zone_tmpls},
    dec::{dec_chnks, dec_pipe},
    encoder::{
        EncConfig, Encoder,
        Encoder::{Avm, SvtAv1, Vvenc, X264, X265},
        SVT_CONF_SIZE, make_enc_cmd, parse_svt_params, set_svt_base,
    },
    error::fatal,
    ffms::{DecStrat, VidInf, nv12_10b, nv12_10b_rem},
    fs::{File, metadata},
    io::{BufWriter, Write},
    pack::{
        PACK_CHUNK, SHIFT_CHUNK, UNPACK_CHUNK, conv_10b, conv_10b_rem, unpack_10b, unpack_10b_rem,
    },
    path::Path,
    pipeline::Pipeline,
    process::Child,
    progs::{ProgsTrack, Tracker, Watch},
    svt::{
        EB_BUFFERFLAG_EOS, EB_ERROR_NONE, EbBufferHeaderType, EbComponentType,
        EbSvtAv1EncConfiguration, EbSvtIOFormat, svt_av1_enc_deinit, svt_av1_enc_deinit_handle,
        svt_av1_enc_init, svt_av1_enc_init_handle, svt_av1_enc_send_picture,
        svt_av1_enc_set_parameter,
    },
    sync::{Mutex, OnceLock},
    thread::{JoinHandle, spawn},
    util::assume_unreachable,
    worker::WorkPkg,
    y4m::PipeReader,
};
#[cfg(feature = "vship")]
use crate::{
    atofu::{TqChunkLine, parse_chunks},
    fs::{OpenOptions, copy, read, write},
    pipeline::MetricProgs,
    thread::{PHandle, available_parallelism, pspawn},
    tq::{
        Probe, ProbeDec, ProbeLog, calc_butter_8b_dav1d, calc_butter_8b_ff, calc_butter_10b_dav1d,
        calc_butter_10b_ff, calc_butter_rem_dav1d, calc_butter_rem_ff, calc_cvvdp_8b_dav1d,
        calc_cvvdp_8b_ff, calc_cvvdp_10b_dav1d, calc_cvvdp_10b_ff, calc_cvvdp_rem_dav1d,
        calc_cvvdp_rem_ff, calc_ssimu2_8b_dav1d, calc_ssimu2_8b_ff, calc_ssimu2_10b_dav1d,
        calc_ssimu2_10b_ff, calc_ssimu2_rem_dav1d, calc_ssimu2_rem_ff, interpolate_crf, make_dav1d,
        make_ff, prep_dav1d, prep_ff,
    },
    vship::{Disp, PinnedBuf, VshipProcessor, init_device},
    worker::TQState,
};
#[cfg(feature = "vship")]
use crate::{encoder::set_svt_crf, interp::bisect};
#[cfg(feature = "vvenc")]
use crate::{
    encoder::{Argv, vvenc_args, vvenc_zone_args},
    vvenc::{
        VVENC_CFG_SIZE, VVENC_OK, VVENC_TQ_HDR, VvencAccessUnit, VvencYuvBuffer, VvencYuvPlane,
        vvenc_derive, vvenc_encode, vvenc_encoder_close, vvenc_open, vvenc_parse, vvenc_qp,
        vvenc_simd,
    },
};

fn join_one(handle: JoinHandle<()>) {
    handle.join();
}

fn join_all(handles: Vec<JoinHandle<()>>) {
    for h in handles {
        join_one(h);
    }
}

#[cfg(target_os = "linux")]
struct OutPath {
    buf: Vec<u8>,
    at: usize,
    tail: [u8; 4],
}

#[cfg(target_os = "linux")]
fn dot_ext(ext: &str) -> [u8; 4] {
    let mut tail = [b'.', 0, 0, 0];
    tail[1..].copy_from_slice(ext.as_bytes());
    tail
}

#[cfg(target_os = "linux")]
fn idx_digits(idx: u16) -> u64 {
    let v0 = u32::from(idx);
    let v1 = (v0 * 0xCCCD) >> 19;
    let v2 = (v1 * 0xCCCD) >> 19;
    let v3 = (v2 * 0xCCCD) >> 19;
    let v4 = (v3 * 0xCCCD) >> 19;
    0x0030_3030_3030u64
        | u64::from(v4)
        | (u64::from(v3 - v4 * 10) << 8)
        | (u64::from(v2 - v3 * 10) << 16)
        | (u64::from(v1 - v2 * 10) << 24)
        | (u64::from(v0 - v1 * 10) << 32)
}

#[cfg(target_os = "linux")]
impl OutPath {
    #[cold]
    #[inline(never)]
    fn new(work_dir: &Path, ext: &str) -> Self {
        let dir = work_dir.as_bytes();
        let mut buf = Vec::with_capacity(dir.len() + ext.len() + 14);
        buf.extend_from_slice(dir);
        buf.extend_from_slice(b"/encode/00000.");
        buf.extend_from_slice(ext.as_bytes());
        Self {
            at: dir.len() + 8,
            tail: dot_ext(ext),
            buf,
        }
    }

    #[inline]
    fn set(&mut self, idx: u16) -> &Path {
        let dig = idx_digits(idx);
        let skip = usize::from(idx < 10000);
        unsafe {
            let p = self.buf.as_mut_ptr().add(self.at);
            p.cast::<[u8; 8]>()
                .write_unaligned((dig >> (skip * 8)).to_le_bytes());
            p.add(5 - skip).cast::<[u8; 4]>().write_unaligned(self.tail);
            self.buf.set_len(self.at + 9 - skip);
        }
        Path::from_bytes(&self.buf)
    }
}

#[cfg(not(target_os = "linux"))]
struct OutPath {
    dir: PathBuf,
    ext: &'static str,
    buf: PathBuf,
}

#[cfg(not(target_os = "linux"))]
impl OutPath {
    #[cold]
    #[inline(never)]
    fn new(work_dir: &Path, ext: &'static str) -> Self {
        Self {
            dir: work_dir.join("encode"),
            ext,
            buf: PathBuf::new(),
        }
    }

    #[inline]
    fn set(&mut self, idx: u16) -> &Path {
        self.buf = self.dir.join(format!("{idx:04}.{}", self.ext));
        &self.buf
    }
}

#[cfg(feature = "vship")]
#[inline]
fn hundredths(crf: f32) -> u32 {
    (crf * 100.0).round() as u32
}

#[cfg(all(target_os = "linux", feature = "vship"))]
pub struct SplitPath {
    buf: Vec<u8>,
    at: usize,
    tail: [u8; 4],
}

#[cfg(all(target_os = "linux", feature = "vship"))]
impl SplitPath {
    const fn unused() -> Self {
        Self {
            buf: Vec::new(),
            at: 0,
            tail: [0; 4],
        }
    }

    #[cold]
    #[inline(never)]
    fn new(work_dir: &Path, ext: &str) -> Self {
        let dir = work_dir.as_bytes();
        let mut buf = Vec::with_capacity(dir.len() + ext.len() + 20);
        buf.extend_from_slice(dir);
        buf.extend_from_slice(b"/split/00000_000.00.");
        buf.extend_from_slice(ext.as_bytes());
        Self {
            at: dir.len() + 7,
            tail: dot_ext(ext),
            buf,
        }
    }

    #[inline]
    pub fn set(&mut self, idx: u16, crf: f32) -> &Path {
        let h0 = u64::from(hundredths(crf));
        let h1 = (h0 * 0xCCCC_CCCD) >> 35;
        let h2 = (h1 * 0xCCCC_CCCD) >> 35;
        let h3 = (h2 * 0xCCCC_CCCD) >> 35;
        let h4 = (h3 * 0xCCCC_CCCD) >> 35;
        let qua = 0x0030_302E_3030_305Fu64
            | (h4 << 8)
            | ((h3 - h4 * 10) << 16)
            | ((h2 - h3 * 10) << 24)
            | ((h1 - h2 * 10) << 40)
            | ((h0 - h1 * 10) << 48);
        let dig = idx_digits(idx);
        let skip = usize::from(idx < 10000);
        unsafe {
            let p = self.buf.as_mut_ptr().add(self.at);
            p.cast::<[u8; 8]>()
                .write_unaligned((dig >> (skip * 8)).to_le_bytes());
            p.add(5 - skip)
                .cast::<[u8; 8]>()
                .write_unaligned(qua.to_le_bytes());
            p.add(12 - skip)
                .cast::<[u8; 4]>()
                .write_unaligned(self.tail);
            self.buf.set_len(self.at + 16 - skip);
        }
        Path::from_bytes(&self.buf)
    }
}

#[cfg(all(not(target_os = "linux"), feature = "vship"))]
pub struct SplitPath {
    dir: PathBuf,
    ext: &'static str,
    buf: PathBuf,
}

#[cfg(all(not(target_os = "linux"), feature = "vship"))]
impl SplitPath {
    const fn unused() -> Self {
        Self {
            dir: PathBuf::new(),
            ext: "",
            buf: PathBuf::new(),
        }
    }

    #[cold]
    #[inline(never)]
    fn new(work_dir: &Path, ext: &'static str) -> Self {
        Self {
            dir: work_dir.join("split"),
            ext,
            buf: PathBuf::new(),
        }
    }

    #[inline]
    pub fn set(&mut self, idx: u16, crf: f32) -> &Path {
        let h = hundredths(crf);
        self.buf = self.dir.join(format!(
            "{idx:04}_{:03}.{:02}.{}",
            h / 100,
            h % 100,
            self.ext
        ));
        &self.buf
    }
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
        let mut data = self.completions.lock();
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

fn build_skip_set(resume_data: &ResumeInf) -> (BTreeSet<u16>, usize, usize) {
    let skip_indices: BTreeSet<u16> = resume_data.chnks_done.iter().map(|c| c.idx).collect();
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

type LibEncFn =
    fn(&mut Vec<u8>, &mut dyn Write, &EncConfig, &EncWorkerCtx, &mut [u8], &EncTrack) -> u64;

type WatchEncFn = fn(&Arc<ProgsTrack>, &mut Child, Watch, Encoder);

type ChnkFn = fn(&mut WorkPkg, &str, &EncWorkerCtx, &Path, &mut [u8], usize) -> u64;

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

const fn watch_enc_unreachable(_: &Arc<ProgsTrack>, _: &mut Child, _: Watch, _: Encoder) {
    assume_unreachable();
}

#[cold]
fn resolve_watch_enc(encoder: Encoder) -> WatchEncFn {
    match encoder {
        X265 | X264 => watch_enc_stderr,
        SvtAv1 | Avm | Vvenc => watch_enc_unreachable,
    }
}

const fn is_lib_enc(encoder: Encoder) -> bool {
    matches!(encoder, SvtAv1 | Avm | Vvenc)
}

#[cold]
fn resolve_chnk_fn(encoder: Encoder, zoned: bool) -> ChnkFn {
    if !is_lib_enc(encoder) {
        enc_chnk_sub
    } else if zoned {
        enc_chnk_lib_zoned
    } else {
        enc_chnk_lib
    }
}

#[cfg(feature = "vship")]
#[cold]
fn resolve_probe_fn(encoder: Encoder) -> ProbeFn {
    if is_lib_enc(encoder) {
        enc_tq_probe_lib
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
    lib_enc: LibEncFn,
    watch_enc: WatchEncFn,
    chnk_fn: ChnkFn,
    tmpl: Option<&'a [u8]>,
    tmpls: &'a [Arc<[u8]>],
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
    done_tx: &'a SeqRing,
    resume_state: &'a Arc<Mutex<ResumeInf>>,
    stats: Option<&'a Arc<WorkerStats>>,
    tq_logger: &'a Arc<Mutex<Vec<ProbeLog>>>,
    tq_ctx: &'a TQCtx,
    use_alt_param: bool,
    worker_cnt: usize,
    threads: i32,
    ext: &'static str,
}

#[cold]
#[inline(never)]
fn resolve_svt_enc(strat: DecStrat, is_nv12: bool, inf: &VidInf, pipe: &Pipeline) -> LibEncFn {
    if strat.is_raw() {
        enc_svt_direct
    } else if is_nv12 {
        if nv12_exact(pipe) {
            enc_svt_nv12_drop
        } else {
            enc_svt_nv12_drop_rem
        }
    } else if inf.is_10b {
        if unpack_exact(pipe) {
            enc_svt_unpack_drop
        } else {
            enc_svt_unpack_drop_rem
        }
    } else if pipe.frame_sz.is_multiple_of(SHIFT_CHUNK) {
        enc_svt_drop
    } else {
        enc_svt_drop_rem
    }
}

#[cfg(feature = "vship")]
#[cold]
#[inline(never)]
fn resolve_svt_crf_enc(inf: &VidInf, pipe: &Pipeline) -> LibEncFn {
    if inf.is_10b {
        if unpack_exact(pipe) {
            enc_svt_lib_unpack
        } else {
            enc_svt_lib_unpack_rem
        }
    } else if pipe.frame_sz.is_multiple_of(SHIFT_CHUNK) {
        enc_svt_lib
    } else {
        enc_svt_lib_rem
    }
}

const fn nv12_exact(pipe: &Pipeline) -> bool {
    (pipe.final_w * pipe.final_h).is_multiple_of(SHIFT_CHUNK)
        && (pipe.final_w / 2 * (pipe.final_h / 2)).is_multiple_of(SHIFT_CHUNK * 2)
}

const fn unpack_exact(pipe: &Pipeline) -> bool {
    pipe.final_w.is_multiple_of(PACK_CHUNK) && pipe.frame_sz.is_multiple_of(UNPACK_CHUNK)
}

#[cfg(feature = "avm")]
#[cold]
#[inline(never)]
fn resolve_avm_enc(strat: DecStrat, is_nv12: bool, inf: &VidInf, pipe: &Pipeline) -> LibEncFn {
    if strat.is_raw() {
        enc_avm_direct
    } else if is_nv12 {
        if nv12_exact(pipe) {
            enc_avm_nv12
        } else {
            enc_avm_nv12_rem
        }
    } else if inf.is_10b {
        if unpack_exact(pipe) {
            enc_avm_unpack
        } else {
            enc_avm_unpack_rem
        }
    } else if pipe.frame_sz.is_multiple_of(SHIFT_CHUNK) {
        enc_avm_conv
    } else {
        enc_avm_conv_rem
    }
}

#[cfg(feature = "vvenc")]
#[cold]
#[inline(never)]
fn resolve_vvenc_enc(strat: DecStrat, is_nv12: bool, inf: &VidInf, pipe: &Pipeline) -> LibEncFn {
    if strat.is_raw() {
        enc_vvenc_direct
    } else if is_nv12 {
        if nv12_exact(pipe) {
            enc_vvenc_nv12
        } else {
            enc_vvenc_nv12_rem
        }
    } else if inf.is_10b {
        if unpack_exact(pipe) {
            enc_vvenc_unpack
        } else {
            enc_vvenc_unpack_rem
        }
    } else if pipe.frame_sz.is_multiple_of(SHIFT_CHUNK) {
        enc_vvenc_conv
    } else {
        enc_vvenc_conv_rem
    }
}

#[cfg(all(feature = "vvenc", feature = "vship"))]
#[cold]
#[inline(never)]
fn resolve_vvenc_crf_enc(inf: &VidInf, pipe: &Pipeline) -> LibEncFn {
    if inf.is_10b {
        if unpack_exact(pipe) {
            enc_vvenc_lib_unpack
        } else {
            enc_vvenc_lib_unpack_rem
        }
    } else if pipe.frame_sz.is_multiple_of(SHIFT_CHUNK) {
        enc_vvenc_lib
    } else {
        enc_vvenc_lib_rem
    }
}

#[cfg(feature = "vship")]
#[cold]
fn resolve_crf_enc(encoder: Encoder, inf: &VidInf, pipe: &Pipeline) -> LibEncFn {
    match encoder {
        #[cfg(feature = "vvenc")]
        Vvenc => resolve_vvenc_crf_enc(inf, pipe),
        _ => resolve_svt_crf_enc(inf, pipe),
    }
}

#[cold]
fn resolve_lib_enc(
    encoder: Encoder,
    strat: DecStrat,
    is_nv12: bool,
    inf: &VidInf,
    pipe: &Pipeline,
) -> LibEncFn {
    match encoder {
        #[cfg(feature = "avm")]
        Avm => resolve_avm_enc(strat, is_nv12, inf, pipe),
        #[cfg(feature = "vvenc")]
        Vvenc => resolve_vvenc_enc(strat, is_nv12, inf, pipe),
        _ => resolve_svt_enc(strat, is_nv12, inf, pipe),
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

    #[cfg(feature = "vvenc")]
    if args.encoder == Vvenc {
        vvenc_simd();
    }

    #[cfg(feature = "vship")]
    {
        let is_tq = args.tq.is_some() && args.qp_range.is_some();
        if is_tq {
            enc_tq(chnks, inf, args, path, work_dir, pipe_reader);
            return;
        }
    }

    let (skip_indices, completed_cnt, completed_frames) = build_skip_set(&resume_data);
    let stats = create_stats(completed_cnt, &resume_data);
    let (prog, display_handle) = ProgsTrack::new(
        chnks,
        inf,
        args.worker,
        completed_frames,
        Arc::clone(&stats.completed),
        Arc::clone(&stats.completed_frames),
        Arc::clone(&stats.tot_sz),
    );
    let prog = Arc::new(prog);

    let strat = unsafe { args.dec_strat.unwrap_unchecked() };
    let is_nv12 = matches!(
        strat,
        DecStrat::HwNv12To10 | DecStrat::HwNv12To10Stride | DecStrat::HwNv12CropTo10 { .. }
    );
    let strat = if is_lib_enc(args.encoder) && inf.is_10b && args.chnk_buff == args.worker {
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
    let lib_enc_fn = resolve_lib_enc(args.encoder, strat, is_nv12, inf, &pipe);
    #[cfg(feature = "vship")]
    let probe_fn = resolve_probe_fn(args.encoder);

    let ring = Arc::new(SeqRing::new());
    let sem = Arc::new(Semaphore::new(args.chnk_buff));

    let build = resolve_build_tmpl(args.encoder);
    let mut chnks = chnks.to_vec();
    let zones = build.map_or_else(Vec::new, |_| zone_tmpls(&mut chnks));

    let decoder = {
        let path = path.to_path_buf();
        let inf = inf.clone();
        let sem = Arc::clone(&sem);
        let ring = Arc::clone(&ring);
        spawn(move || {
            let rp = Arc::as_ptr(&ring);
            let send = move |p: WorkPkg| unsafe {
                spmc_send(rp, Box::into_raw(Box::new(p)) as u64);
            };
            if let Some(mut reader) = pipe_reader {
                dec_pipe(&chnks, &mut reader, &inf, &send, &skip_indices, strat, &sem);
            } else {
                dec_chnks(&chnks, &path, &inf, &send, &skip_indices, strat, &sem);
            }
            unsafe { spmc_close(rp) };
        })
    };

    let tmpls = build.map(|b| build_zoned(b, inf, &args.params, &pipe, &zones, (-1, -1)));
    let chnk_fn = resolve_chnk_fn(args.encoder, !zones.is_empty());
    let watch_enc = resolve_watch_enc(args.encoder);

    let mut workers = Vec::new();
    for worker_id in 0..args.worker {
        let rx_clone = Arc::clone(&ring);
        let inf = inf.clone();
        let pipe = pipe.clone();
        let params = args.params.clone();
        let stats_clone = Arc::clone(&stats);
        let wd = work_dir.to_path_buf();
        let prog_clone = Arc::clone(&prog);
        let sem_clone = Arc::clone(&sem);
        let encoder = args.encoder;
        let tmpls = tmpls.clone();

        let handle = spawn(move || {
            let tset: &[Arc<[u8]>] = tmpls.as_deref().unwrap_or(&[]);
            let ctx = EncWorkerCtx {
                inf: &inf,
                pipe: &pipe,
                work_dir: &wd,
                prog: &prog_clone,
                encoder,
                lib_enc: lib_enc_fn,
                watch_enc,
                chnk_fn,
                tmpl: tset.first().map(|t| &**t),
                tmpls: tset,
                #[cfg(feature = "vship")]
                probe_fn,
            };
            run_enc_worker(
                &rx_clone,
                &params,
                &ctx,
                &stats_clone,
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
}

#[cfg(feature = "vship")]
impl TQCtx {
    #[inline(always)]
    fn converged(&self, score: f32) -> bool {
        (score - self.target).abs() <= self.tolerance
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
    file_sz: u64,
    ctx: &TQWorkerCtx,
    tq_state: &TQState,
    best: &Probe,
) {
    unsafe { mpsc_send(ctx.done_tx, 1) };

    let comp = ChunkComp {
        idx: chnk_idx,
        frames: chnk_frames,
        sz: file_sz,
    };

    let mut resume = ctx.resume_state.lock();
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
    ctx.tq_logger.lock().push(log_entry);
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
fn output_bytes(dst: &Path, tq: &TQState, _: &mut SplitPath, _: u16, _: f32, _: usize) -> u64 {
    _ = write(dst, &tq.best_probe);
    tq.best_probe.len() as u64
}

#[cfg(feature = "vship")]
const fn output_probe(_: &Path, _: &TQState, _: &mut SplitPath, _: u16, _: f32, n: usize) -> u64 {
    n as u64
}

#[cfg(feature = "vship")]
fn output_copy(dst: &Path, _: &TQState, sp: &mut SplitPath, idx: u16, crf: f32, _: usize) -> u64 {
    copy(sp.set(idx, crf), dst).unwrap_or(0)
}

#[cold]
#[inline(never)]
#[cfg(feature = "vship")]
fn output_stat(dst: &Path, _: &TQState, _: &mut SplitPath, _: u16, _: f32, _: usize) -> u64 {
    metadata(dst).unwrap_or(0)
}

#[cfg(feature = "vship")]
const fn split_unused(_: &Path, _: &str) -> SplitPath {
    SplitPath::unused()
}

#[cfg(feature = "vship")]
type MetricLoopFn = fn(&SeqRing, &SeqRing, &TQWorkerCtx, usize, Option<Disp>);

#[cfg(feature = "vship")]
macro_rules! make_metric_loop {
    (
        $name:ident,
        $mk_dec:expr,
        $prep:expr,
        $retain:expr,
        $output:expr,
        $mk_split:expr,
        $calc:expr
    ) => {
        fn $name(
            rx: &SeqRing,
            work_tx: &SeqRing,
            ctx: &TQWorkerCtx,
            worker_id: usize,
            disp: Option<Disp>,
        ) {
            let mut vship: Option<VshipProcessor> = None;
            let mut dec: Option<ProbeDec> = None;
            let mut unpacked_buf =
                PinnedBuf::new(ctx.pipe.unpack_buf_sz).unwrap_or_else(|e| fatal(e));
            let mut enc_path = OutPath::new(ctx.work_dir, ctx.ext);
            let mut split_path = ($mk_split)(ctx.work_dir, ctx.ext);

            loop {
                let m = unsafe { mpmc_recv(rx) };
                if m == 0 {
                    cold_path();
                    break;
                }
                let mut pkg = unsafe { Box::from_raw(m as *mut WorkPkg) };
                let tq_st = unsafe { pkg.tq_state.as_ref().unwrap_unchecked() };
                if tq_st.final_enc {
                    let best = ctx.tq_ctx.best_probe(&tq_st.probes);
                    let sz = ($output)(
                        enc_path.set(pkg.chnk.idx),
                        tq_st,
                        &mut split_path,
                        pkg.chnk.idx,
                        best.crf,
                        pkg.probe.len(),
                    );
                    complete_chnk(pkg.chnk.idx, pkg.frame_cnt, sz, ctx, tq_st, best);
                    continue;
                }

                if vship.is_none() {
                    let v = VshipProcessor::new(
                        pkg.width,
                        pkg.height,
                        ctx.inf,
                        ctx.tq_ctx.use_cvvdp,
                        ctx.tq_ctx.use_butter,
                        disp,
                    )
                    .unwrap_or_else(|e| fatal(e));
                    vship = Some(v);
                }

                let tq_st = unsafe { pkg.tq_state.as_ref().unwrap_unchecked() };
                let crf = tq_st.last_crf;
                let last_score = tq_st.probes.last().map(|probe| probe.score);
                let metric_slot = ctx.worker_cnt + worker_id;

                let d = dec.get_or_insert_with(|| ($mk_dec)(ctx.threads, pkg.width, pkg.height));
                let probe_sz = ($prep)(d, &pkg, &mut split_path, pkg.chnk.idx, crf);
                unsafe { pkg.tq_state.as_mut().unwrap_unchecked() }
                    .probe_szs
                    .push((crf, probe_sz));

                let mp = MetricProgs {
                    prog: ctx.prog,
                    slot: metric_slot,
                    crf,
                    last_score,
                };
                let score = ($calc)(
                    &pkg,
                    d,
                    ctx.pipe,
                    unsafe { vship.as_ref().unwrap_unchecked() },
                    ctx.metric_mode,
                    &mut unpacked_buf,
                    &mp,
                );

                ($retain)(&mut pkg, score);

                let tq_state = unsafe { pkg.tq_state.as_mut().unwrap_unchecked() };

                let should_complete = ctx.tq_ctx.converged(score)
                    || tq_state
                        .probes
                        .iter()
                        .any(|p| (p.crf - crf) * (p.score - score) >= 0.0)
                    || ctx.tq_ctx.up_bounds(tq_state, score);

                tq_state.probes.push(Probe { crf, score });

                if should_complete {
                    let best = ctx.tq_ctx.best_probe(&tq_state.probes);
                    if ctx.use_alt_param {
                        tq_state.final_enc = true;
                        tq_state.last_crf = best.crf;
                        unsafe { mpsc_send(work_tx, Box::into_raw(pkg) as u64) };
                    } else {
                        let sz = ($output)(
                            enc_path.set(pkg.chnk.idx),
                            tq_state,
                            &mut split_path,
                            pkg.chnk.idx,
                            best.crf,
                            pkg.probe.len(),
                        );
                        complete_chnk(pkg.chnk.idx, pkg.frame_cnt, sz, ctx, tq_state, best);
                    }
                } else {
                    unsafe { mpsc_send(work_tx, Box::into_raw(pkg) as u64) };
                }
            }
        }
    };
}

#[cfg(feature = "vship")]
macro_rules! make_metric_group {
    (
        $mk_dec:expr,
        $prep:expr,
        $retain:expr,
        $output:expr,
        $mk_split:expr,
        $ss8:ident,
        $c_ss8:expr,
        $ss10:ident,
        $c_ss10:expr,
        $ssr:ident,
        $c_ssr:expr,
        $bu8:ident,
        $c_bu8:expr,
        $bu10:ident,
        $c_bu10:expr,
        $bur:ident,
        $c_bur:expr,
        $cv8:ident,
        $c_cv8:expr,
        $cv10:ident,
        $c_cv10:expr,
        $cvr:ident,
        $c_cvr:expr
    ) => {
        make_metric_loop!($ss8, $mk_dec, $prep, $retain, $output, $mk_split, $c_ss8);
        make_metric_loop!($ss10, $mk_dec, $prep, $retain, $output, $mk_split, $c_ss10);
        make_metric_loop!($ssr, $mk_dec, $prep, $retain, $output, $mk_split, $c_ssr);
        make_metric_loop!($bu8, $mk_dec, $prep, $retain, $output, $mk_split, $c_bu8);
        make_metric_loop!($bu10, $mk_dec, $prep, $retain, $output, $mk_split, $c_bu10);
        make_metric_loop!($bur, $mk_dec, $prep, $retain, $output, $mk_split, $c_bur);
        make_metric_loop!($cv8, $mk_dec, $prep, $retain, $output, $mk_split, $c_cv8);
        make_metric_loop!($cv10, $mk_dec, $prep, $retain, $output, $mk_split, $c_cv10);
        make_metric_loop!($cvr, $mk_dec, $prep, $retain, $output, $mk_split, $c_cvr);
    };
}

#[cfg(feature = "vship")]
make_metric_group!(
    make_dav1d,
    prep_dav1d,
    retain_swap,
    output_bytes,
    split_unused,
    met_d_ss_8b,
    calc_ssimu2_8b_dav1d,
    met_d_ss_10b,
    calc_ssimu2_10b_dav1d,
    met_d_ss_rem,
    calc_ssimu2_rem_dav1d,
    met_d_bu_8b,
    calc_butter_8b_dav1d,
    met_d_bu_10b,
    calc_butter_10b_dav1d,
    met_d_bu_rem,
    calc_butter_rem_dav1d,
    met_d_cv_8b,
    calc_cvvdp_8b_dav1d,
    met_d_cv_10b,
    calc_cvvdp_10b_dav1d,
    met_d_cv_rem,
    calc_cvvdp_rem_dav1d
);
#[cfg(feature = "vship")]
make_metric_group!(
    make_dav1d,
    prep_dav1d,
    retain_noop,
    output_probe,
    split_unused,
    met_da_ss_8b,
    calc_ssimu2_8b_dav1d,
    met_da_ss_10b,
    calc_ssimu2_10b_dav1d,
    met_da_ss_rem,
    calc_ssimu2_rem_dav1d,
    met_da_bu_8b,
    calc_butter_8b_dav1d,
    met_da_bu_10b,
    calc_butter_10b_dav1d,
    met_da_bu_rem,
    calc_butter_rem_dav1d,
    met_da_cv_8b,
    calc_cvvdp_8b_dav1d,
    met_da_cv_10b,
    calc_cvvdp_10b_dav1d,
    met_da_cv_rem,
    calc_cvvdp_rem_dav1d
);
#[cfg(all(feature = "vship", feature = "vvenc"))]
make_metric_group!(
    make_vvdec,
    prep_vvdec,
    retain_swap,
    output_bytes,
    split_unused,
    met_v_ss_8b,
    calc_ssimu2_8b_vvdec,
    met_v_ss_10b,
    calc_ssimu2_10b_vvdec,
    met_v_ss_rem,
    calc_ssimu2_rem_vvdec,
    met_v_bu_8b,
    calc_butter_8b_vvdec,
    met_v_bu_10b,
    calc_butter_10b_vvdec,
    met_v_bu_rem,
    calc_butter_rem_vvdec,
    met_v_cv_8b,
    calc_cvvdp_8b_vvdec,
    met_v_cv_10b,
    calc_cvvdp_10b_vvdec,
    met_v_cv_rem,
    calc_cvvdp_rem_vvdec
);
#[cfg(all(feature = "vship", feature = "vvenc"))]
make_metric_group!(
    make_vvdec,
    prep_vvdec,
    retain_noop,
    output_probe,
    split_unused,
    met_va_ss_8b,
    calc_ssimu2_8b_vvdec,
    met_va_ss_10b,
    calc_ssimu2_10b_vvdec,
    met_va_ss_rem,
    calc_ssimu2_rem_vvdec,
    met_va_bu_8b,
    calc_butter_8b_vvdec,
    met_va_bu_10b,
    calc_butter_10b_vvdec,
    met_va_bu_rem,
    calc_butter_rem_vvdec,
    met_va_cv_8b,
    calc_cvvdp_8b_vvdec,
    met_va_cv_10b,
    calc_cvvdp_10b_vvdec,
    met_va_cv_rem,
    calc_cvvdp_rem_vvdec
);
#[cfg(feature = "vship")]
make_metric_group!(
    make_ff,
    prep_ff,
    retain_noop,
    output_copy,
    SplitPath::new,
    met_f_ss_8b,
    calc_ssimu2_8b_ff,
    met_f_ss_10b,
    calc_ssimu2_10b_ff,
    met_f_ss_rem,
    calc_ssimu2_rem_ff,
    met_f_bu_8b,
    calc_butter_8b_ff,
    met_f_bu_10b,
    calc_butter_10b_ff,
    met_f_bu_rem,
    calc_butter_rem_ff,
    met_f_cv_8b,
    calc_cvvdp_8b_ff,
    met_f_cv_10b,
    calc_cvvdp_10b_ff,
    met_f_cv_rem,
    calc_cvvdp_rem_ff
);
#[cfg(feature = "vship")]
make_metric_group!(
    make_ff,
    prep_ff,
    retain_noop,
    output_stat,
    SplitPath::new,
    met_fa_ss_8b,
    calc_ssimu2_8b_ff,
    met_fa_ss_10b,
    calc_ssimu2_10b_ff,
    met_fa_ss_rem,
    calc_ssimu2_rem_ff,
    met_fa_bu_8b,
    calc_butter_8b_ff,
    met_fa_bu_10b,
    calc_butter_10b_ff,
    met_fa_bu_rem,
    calc_butter_rem_ff,
    met_fa_cv_8b,
    calc_cvvdp_8b_ff,
    met_fa_cv_10b,
    calc_cvvdp_10b_ff,
    met_fa_cv_rem,
    calc_cvvdp_rem_ff
);

#[cfg(feature = "vship")]
#[cold]
fn by_shape(
    inf: &VidInf,
    pipe: &Pipeline,
    b8: MetricLoopFn,
    p10: MetricLoopFn,
    rem: MetricLoopFn,
) -> MetricLoopFn {
    if !inf.is_10b {
        b8
    } else if unpack_exact(pipe) {
        p10
    } else {
        rem
    }
}

#[cfg(feature = "vship")]
#[cold]
fn dav1d_loop(tq: &TQCtx, inf: &VidInf, pipe: &Pipeline) -> MetricLoopFn {
    if tq.use_butter {
        by_shape(inf, pipe, met_d_bu_8b, met_d_bu_10b, met_d_bu_rem)
    } else if tq.use_cvvdp {
        by_shape(inf, pipe, met_d_cv_8b, met_d_cv_10b, met_d_cv_rem)
    } else {
        by_shape(inf, pipe, met_d_ss_8b, met_d_ss_10b, met_d_ss_rem)
    }
}

#[cfg(feature = "vship")]
#[cold]
fn dav1d_alt_loop(tq: &TQCtx, inf: &VidInf, pipe: &Pipeline) -> MetricLoopFn {
    if tq.use_butter {
        by_shape(inf, pipe, met_da_bu_8b, met_da_bu_10b, met_da_bu_rem)
    } else if tq.use_cvvdp {
        by_shape(inf, pipe, met_da_cv_8b, met_da_cv_10b, met_da_cv_rem)
    } else {
        by_shape(inf, pipe, met_da_ss_8b, met_da_ss_10b, met_da_ss_rem)
    }
}

#[cfg(all(feature = "vship", feature = "vvenc"))]
#[cold]
fn vvdec_loop(tq: &TQCtx, inf: &VidInf, pipe: &Pipeline) -> MetricLoopFn {
    if tq.use_butter {
        by_shape(inf, pipe, met_v_bu_8b, met_v_bu_10b, met_v_bu_rem)
    } else if tq.use_cvvdp {
        by_shape(inf, pipe, met_v_cv_8b, met_v_cv_10b, met_v_cv_rem)
    } else {
        by_shape(inf, pipe, met_v_ss_8b, met_v_ss_10b, met_v_ss_rem)
    }
}

#[cfg(all(feature = "vship", feature = "vvenc"))]
#[cold]
fn vvdec_alt_loop(tq: &TQCtx, inf: &VidInf, pipe: &Pipeline) -> MetricLoopFn {
    if tq.use_butter {
        by_shape(inf, pipe, met_va_bu_8b, met_va_bu_10b, met_va_bu_rem)
    } else if tq.use_cvvdp {
        by_shape(inf, pipe, met_va_cv_8b, met_va_cv_10b, met_va_cv_rem)
    } else {
        by_shape(inf, pipe, met_va_ss_8b, met_va_ss_10b, met_va_ss_rem)
    }
}

#[cfg(feature = "vship")]
#[cold]
fn ff_loop(tq: &TQCtx, inf: &VidInf, pipe: &Pipeline) -> MetricLoopFn {
    if tq.use_butter {
        by_shape(inf, pipe, met_f_bu_8b, met_f_bu_10b, met_f_bu_rem)
    } else if tq.use_cvvdp {
        by_shape(inf, pipe, met_f_cv_8b, met_f_cv_10b, met_f_cv_rem)
    } else {
        by_shape(inf, pipe, met_f_ss_8b, met_f_ss_10b, met_f_ss_rem)
    }
}

#[cfg(feature = "vship")]
#[cold]
fn ff_alt_loop(tq: &TQCtx, inf: &VidInf, pipe: &Pipeline) -> MetricLoopFn {
    if tq.use_butter {
        by_shape(inf, pipe, met_fa_bu_8b, met_fa_bu_10b, met_fa_bu_rem)
    } else if tq.use_cvvdp {
        by_shape(inf, pipe, met_fa_cv_8b, met_fa_cv_10b, met_fa_cv_rem)
    } else {
        by_shape(inf, pipe, met_fa_ss_8b, met_fa_ss_10b, met_fa_ss_rem)
    }
}

#[cfg(feature = "vship")]
#[cold]
#[inline(never)]
fn resolve_metric_loop(
    encoder: Encoder,
    use_alt: bool,
    tq: &TQCtx,
    inf: &VidInf,
    pipe: &Pipeline,
) -> MetricLoopFn {
    match (encoder, use_alt) {
        #[cfg(feature = "vvenc")]
        (Vvenc, false) => vvdec_loop(tq, inf, pipe),
        #[cfg(feature = "vvenc")]
        (Vvenc, true) => vvdec_alt_loop(tq, inf, pipe),
        (SvtAv1, false) => dav1d_loop(tq, inf, pipe),
        (SvtAv1, true) => dav1d_alt_loop(tq, inf, pipe),
        (_, false) => ff_loop(tq, inf, pipe),
        (_, true) => ff_alt_loop(tq, inf, pipe),
    }
}

#[cfg(feature = "vship")]
#[must_use]
pub fn tq_target(tq: &str) -> f32 {
    let mut p = tq.split('-').filter_map(|s| s.parse().ok());
    let a = unsafe { p.next().unwrap_unchecked() };
    f32::midpoint(a, unsafe { p.next().unwrap_unchecked() })
}

#[cfg(feature = "vship")]
#[must_use]
pub const fn is_cvvdp(target: f32) -> bool {
    target > 8.0 && target <= 10.0
}

#[cfg(feature = "vship")]
fn parse_tq_ctx(args: &Args) -> TQCtx {
    let tq_str = unsafe { args.tq.as_ref().unwrap_unchecked() };
    let qp_str = unsafe { args.qp_range.as_ref().unwrap_unchecked() };
    let tq_parts: Vec<f32> = tq_str.split('-').filter_map(|s| s.parse().ok()).collect();
    let qp_parts: Vec<f32> = qp_str.split('-').filter_map(|s| s.parse().ok()).collect();
    let tq_target = f32::midpoint(tq_parts[0], tq_parts[1]);
    TQCtx {
        target: tq_target,
        tolerance: (tq_parts[1] - tq_parts[0]) / 2.0,
        qp_min: qp_parts[0],
        qp_max: qp_parts[1],
        use_butter: tq_target < 8.0,
        use_cvvdp: is_cvvdp(tq_target),
    }
}

#[cfg(feature = "vship")]
fn tq_coord(coord: &SeqRing, enc: &SeqRing, tot_chnks: usize, permits: &Semaphore) {
    let mut completed = 0;
    while completed < tot_chnks {
        let m = unsafe { mpsc_recv(coord) };
        if m == 1 {
            sem_release(permits);
            completed += 1;
        } else {
            unsafe { spmc_send(enc, m) };
        }
    }
    unsafe { spmc_close(enc) };
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
type TqLoopFn = fn(&SeqRing, &SeqRing, &EncWorkerCtx, &TqEncParams, &TQCtx, usize);

#[cfg(feature = "vship")]
macro_rules! make_tq_loop {
    (
        $name:ident, $pkg:ident, $crf:ident, $fin:ident, $probe:ident, $is_final:ident,
        $sel:expr, $probe_dst:expr $(, $split:ident)?
    ) => {
        fn $name(
            rx: &SeqRing,
            tx: &SeqRing,
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
            let ext = ctx.encoder.extension();
            let mut enc_path = OutPath::new(ctx.work_dir, ext);
            $(let mut $split = SplitPath::new(ctx.work_dir, ext);)?
            let probe_params = alt_param.unwrap_or(params);
            let ($fin, $probe) = tmpls.map_or((&[][..], &[][..]), |t| {
                (t.base.as_slice(), t.alt.as_deref().unwrap_or(&t.base))
            });
            loop {
                let m = unsafe { spmc_recv(rx) };
                if m == 0 {
                    cold_path();
                    break;
                }
                let mut $pkg = unsafe { Box::from_raw(m as *mut WorkPkg) };
                let tq = $pkg.tq_state.get_or_insert_with(|| TQState {
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
                let $is_final = tq.final_enc;
                let $crf = if $is_final {
                    tq.last_crf
                } else {
                    tq_search_crf(tq, ctx.encoder)
                };
                let (p, dst) = if $is_final {
                    (params, Some(enc_path.set($pkg.chnk.idx)))
                } else {
                    (probe_params, $probe_dst)
                };
                let svt_t = $sel;
                (ctx.probe_fn)(
                    &mut $pkg,
                    $crf,
                    &EncRecipe {
                        params: p,
                        template: svt_t,
                    },
                    ctx,
                    &mut conv_buf,
                    worker_id,
                    dst,
                );
                unsafe { mpmc_send(tx, Box::into_raw($pkg) as u64) };
            }
        }
    };
}

#[cfg(feature = "vship")]
make_tq_loop!(
    tq_enc_loop,
    pkg,
    crf,
    fin,
    probe,
    is_final,
    if is_final { fin } else { probe }.first().map(|t| &**t),
    None
);
#[cfg(feature = "vship")]
make_tq_loop!(
    tq_enc_loop_zoned,
    pkg,
    crf,
    fin,
    probe,
    is_final,
    Some(&**unsafe { if is_final { fin } else { probe }.get_unchecked(pkg.chnk.tmpl as usize) }),
    None
);
#[cfg(feature = "vship")]
make_tq_loop!(
    tq_enc_loop_sub,
    pkg,
    crf,
    fin,
    probe,
    is_final,
    if is_final { fin } else { probe }.first().map(|t| &**t),
    Some(split.set(pkg.chnk.idx, crf)),
    split
);
#[cfg(feature = "vship")]
make_tq_loop!(
    tq_enc_loop_sub_zoned,
    pkg,
    crf,
    fin,
    probe,
    is_final,
    Some(&**unsafe { if is_final { fin } else { probe }.get_unchecked(pkg.chnk.tmpl as usize) }),
    Some(split.set(pkg.chnk.idx, crf)),
    split
);

#[cfg(feature = "vship")]
#[cold]
fn resolve_tq_loop(zoned: bool, lib: bool) -> TqLoopFn {
    match (lib, zoned) {
        (true, false) => tq_enc_loop,
        (true, true) => tq_enc_loop_zoned,
        (false, false) => tq_enc_loop_sub,
        (false, true) => tq_enc_loop_sub_zoned,
    }
}

#[cfg(feature = "vship")]
struct TQDecodeResult {
    enc: Arc<SeqRing>,
    coord: Arc<SeqRing>,
    handle: JoinHandle<()>,
}

#[cfg(feature = "vship")]
fn spawn_tq_dec(
    chnks: &[Chunk],
    path: &Path,
    inf: &VidInf,
    skip: BTreeSet<u16>,
    strat: DecStrat,
    permits: &Arc<Semaphore>,
    pipe_reader: Option<PipeReader>,
) -> TQDecodeResult {
    let tot = chnks.iter().filter(|c| !skip.contains(&c.idx)).count();
    let enc = Arc::new(SeqRing::new());
    let coord = Arc::new(SeqRing::new());

    let chnks = chnks.to_vec();
    let path = path.to_path_buf();
    let inf = inf.clone();
    let enc2 = Arc::clone(&enc);
    let coord2 = Arc::clone(&coord);
    let coord_dec = Arc::clone(&coord);
    let permits_dec = Arc::clone(permits);
    let permits_done = Arc::clone(permits);
    let handle = spawn(move || {
        let inf2 = inf.clone();
        let dec = pspawn(move || {
            let rp = Arc::as_ptr(&coord_dec);
            let send = move |p: WorkPkg| unsafe {
                mpsc_send(rp, Box::into_raw(Box::new(p)) as u64);
            };
            if let Some(mut r) = pipe_reader {
                dec_pipe(&chnks, &mut r, &inf2, &send, &skip, strat, &permits_dec);
            } else {
                dec_chnks(&chnks, &path, &inf2, &send, &skip, strat, &permits_dec);
            }
        });
        tq_coord(&coord2, &enc2, tot, &permits_done);
        dec.join();
    });
    TQDecodeResult { enc, coord, handle }
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
    let build = resolve_build_tmpl(args.encoder);
    let mut chnks = chnks.to_vec();
    let zones = build.map_or_else(Vec::new, |_| zone_tmpls(&mut chnks));
    let chnks = &chnks;

    let dec = spawn_tq_dec(chnks, path, inf, skip_indices, strat, &permits, pipe_reader);
    let met = Arc::new(SeqRing::new());

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
        zones: &zones,
        build,
        encoder: args.encoder,
        use_alt_param: args.alt_param.is_some(),
        worker_cnt: args.worker,
    };

    init_device().unwrap_or_else(|e| fatal(e));

    let metric_workers = spawn_tq_metric(args.metric_worker, &met, &dec.coord, &sc);

    let workers = spawn_tq_encoders(&dec.enc, &met, &sc);

    join_one(dec.handle);
    join_all(workers);
    unsafe { mpmc_close(Arc::as_ptr(&met)) };
    metric_workers.into_iter().for_each(PHandle::join);

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
    zones: &'a [Box<str>],
    build: Option<BuildTmpl>,
    encoder: Encoder,
    use_alt_param: bool,
    worker_cnt: usize,
}

#[cfg(feature = "vship")]
fn spawn_tq_metric(
    metric_worker: usize,
    met: &Arc<SeqRing>,
    coord: &Arc<SeqRing>,
    sc: &TQSpawnCtx,
) -> Vec<PHandle> {
    let metric_loop =
        resolve_metric_loop(sc.encoder, sc.use_alt_param, &sc.tq_ctx, sc.inf, sc.pipe);
    let threads = available_parallelism() as i32;
    let ext = sc.encoder.extension();
    let disp = sc.args.disp;
    let mut metric_workers = Vec::new();
    for worker_id in 0..metric_worker {
        let rx = Arc::clone(met);
        let coord = Arc::clone(coord);
        let (inf, pipe, wd) = (sc.inf.clone(), sc.pipe.clone(), sc.work_dir.to_path_buf());
        let (metric_mode, st) = (sc.args.metric_mode.clone(), sc.stats.clone());
        let (resume_state, tq_logger, prog_clone) = (
            Arc::clone(sc.resume_state),
            Arc::clone(sc.tq_logger),
            Arc::clone(sc.prog),
        );
        let (tq_ctx, use_alt_param, worker_cnt) = (sc.tq_ctx, sc.use_alt_param, sc.worker_cnt);
        metric_workers.push(pspawn(move || {
            let ctx = TQWorkerCtx {
                inf: &inf,
                pipe: &pipe,
                work_dir: &wd,
                metric_mode: &metric_mode,
                prog: &prog_clone,
                done_tx: &coord,
                resume_state: &resume_state,
                stats: st.as_ref(),
                tq_logger: &tq_logger,
                tq_ctx: &tq_ctx,
                use_alt_param,
                worker_cnt,
                threads,
                ext,
            };
            metric_loop(&rx, &coord, &ctx, worker_id, disp);
        }));
    }
    metric_workers
}

#[cfg(feature = "vship")]
#[derive(Clone)]
struct TqTmpls {
    base: Vec<Arc<[u8]>>,
    alt: Option<Vec<Arc<[u8]>>>,
}

#[cfg(feature = "vship")]
fn spawn_tq_encoders(
    enc: &Arc<SeqRing>,
    met: &Arc<SeqRing>,
    sc: &TQSpawnCtx,
) -> Vec<JoinHandle<()>> {
    let qp = (sc.tq_ctx.qp_min as i32, sc.tq_ctx.qp_max as i32);
    let tmpls = sc.build.map(|build| TqTmpls {
        base: build_zoned(build, sc.inf, &sc.args.params, sc.pipe, sc.zones, qp),
        alt: sc
            .args
            .alt_param
            .as_deref()
            .map(|ap| build_zoned(build, sc.inf, ap, sc.pipe, sc.zones, qp)),
    });
    let mut workers = Vec::new();
    let chnk_fn = resolve_chnk_fn(sc.encoder, false);
    let probe_fn = resolve_probe_fn(sc.encoder);
    let watch_enc = resolve_watch_enc(sc.encoder);
    let crf_enc = resolve_crf_enc(sc.encoder, sc.inf, sc.pipe);
    let tq_loop = resolve_tq_loop(
        !sc.zones.is_empty() && tmpls.is_some(),
        is_lib_enc(sc.encoder),
    );
    for worker_id in 0..sc.worker_cnt {
        let (rx, tx) = (Arc::clone(enc), Arc::clone(met));
        let (inf, pipe, wd) = (sc.inf.clone(), sc.pipe.clone(), sc.work_dir.to_path_buf());
        let (params, alt_param) = (sc.args.params.clone(), sc.args.alt_param.clone());
        let prog_clone = Arc::clone(sc.prog);
        let (tq_ctx, encoder) = (sc.tq_ctx, sc.encoder);
        let tmpls = tmpls.clone();
        workers.push(spawn(move || {
            let ctx = EncWorkerCtx {
                inf: &inf,
                pipe: &pipe,
                work_dir: &wd,
                prog: &prog_clone,
                encoder,
                lib_enc: crf_enc,
                watch_enc,
                chnk_fn,
                tmpl: None,
                tmpls: &[],
                probe_fn,
            };
            tq_loop(
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
fn enc_tq_probe_lib(
    pkg: &mut WorkPkg,
    crf: f32,
    recipe: &EncRecipe,
    ctx: &EncWorkerCtx,
    conv_buf: &mut [u8],
    worker_id: usize,
    dst: Option<&Path>,
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
        crf: Some(crf),
        out: Path::new(""),
        chnk_idx: pkg.chnk.idx,
        width: pkg.width,
        height: pkg.height,
        frames: pkg.frame_cnt,
    };
    pkg.probe.clear();
    (ctx.lib_enc)(
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
    if let Some(fin) = dst {
        _ = write(fin, &pkg.probe);
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
    dst: Option<&Path>,
) {
    let &EncRecipe { params, template } = recipe;
    let out = unsafe { dst.unwrap_unchecked() };
    let cfg = EncConfig {
        inf: ctx.inf,
        template,
        params,
        crf: Some(crf),
        out,
        chnk_idx: pkg.chnk.idx,
        width: pkg.width,
        height: pkg.height,
        frames: pkg.frame_cnt,
    };

    #[allow(unused_mut)]
    let mut cmd = make_enc_cmd(ctx.encoder, &cfg, pkg.chnk.params.as_deref());
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
    rx: &SeqRing,
    params: &str,
    ctx: &EncWorkerCtx,
    stats: &Arc<WorkerStats>,
    worker_id: usize,
    sem: &Arc<Semaphore>,
) {
    let mut conv_buf = vec![0u8; ctx.pipe.conv_buf_sz];
    let mut enc_path = OutPath::new(ctx.work_dir, ctx.encoder.extension());

    loop {
        let m = unsafe { spmc_recv(rx) };
        if m == 0 {
            cold_path();
            break;
        }
        let mut pkg = unsafe { Box::from_raw(m as *mut WorkPkg) };
        let out = enc_path.set(pkg.chnk.idx);
        let sz = (ctx.chnk_fn)(&mut pkg, params, ctx, out, &mut conv_buf, worker_id);

        stats.completed.fetch_add(1, Relaxed);
        stats.add_completion(
            ChunkComp {
                idx: pkg.chnk.idx,
                frames: pkg.frame_cnt,
                sz,
            },
            ctx.work_dir,
        );

        sem_release(sem);
    }
}

macro_rules! make_chnk_lib {
    ($name:ident, $ctx:ident, $pkg:ident, $tmpl:expr) => {
        fn $name(
            $pkg: &mut WorkPkg,
            params: &str,
            $ctx: &EncWorkerCtx,
            out: &Path,
            conv_buf: &mut [u8],
            worker_id: usize,
        ) -> u64 {
            let cfg = EncConfig {
                inf: $ctx.inf,
                template: $tmpl,
                params,
                crf: None,
                out,
                chnk_idx: $pkg.chnk.idx,
                width: $pkg.width,
                height: $pkg.height,
                frames: $pkg.frame_cnt,
            };
            let mut sink = BufWriter::new(File::create(out).unwrap_or_else(|e| fatal(e)));
            ($ctx.lib_enc)(
                &mut $pkg.yuv,
                &mut sink,
                &cfg,
                $ctx,
                conv_buf,
                &EncTrack {
                    worker_id,
                    track_frames: true,
                    crf_score: None,
                },
            )
        }
    };
}

make_chnk_lib!(enc_chnk_lib, ctx, pkg, ctx.tmpl);
make_chnk_lib!(
    enc_chnk_lib_zoned,
    ctx,
    pkg,
    Some(unsafe { &**ctx.tmpls.get_unchecked(pkg.chnk.tmpl as usize) })
);

fn enc_chnk_sub(
    pkg: &mut WorkPkg,
    params: &str,
    ctx: &EncWorkerCtx,
    out: &Path,
    conv_buf: &mut [u8],
    worker_id: usize,
) -> u64 {
    let cfg = EncConfig {
        inf: ctx.inf,
        template: None,
        params,
        crf: None,
        out,
        chnk_idx: pkg.chnk.idx,
        width: pkg.width,
        height: pkg.height,
        frames: pkg.frame_cnt,
    };

    #[allow(unused_mut)]
    let mut cmd = make_enc_cmd(ctx.encoder, &cfg, pkg.chnk.params.as_deref());
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
        cold_path();
        fatal(format_args!("encode failed: chunk {:04}", pkg.chnk.idx));
    }
    metadata(out).unwrap_or(0)
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
    tri: &[(f32, f32, u64)],
    metric_name: &str,
    fps: f32,
    round_cnts: &BTreeMap<usize, usize>,
    crf_cnts: &BTreeMap<u64, usize>,
) -> String {
    let tot = all_logs.len();
    let avg_probes = all_logs.iter().map(|l| l.pn).sum::<usize>() as f32 / tot as f32;
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
        let mut sp: Vec<_> = tri[l.po..l.po + l.pn].iter().collect();
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
fn write_tq_log(inp: &Path, work_dir: &Path, inf: &VidInf, metric_name: &str) {
    let log_path = inp.with_extension("json");
    let chnks_path = work_dir.join("chunks.json");
    let fps = inf.fps_num as f32 / inf.fps_den as f32;

    let Ok(mut buf) = read(&chnks_path) else {
        return;
    };
    buf.extend_from_slice(&[0u8; 16]);
    let (mut all_logs, tri) = parse_chunks(&buf);
    if all_logs.is_empty() {
        return;
    }

    let mut round_cnts: BTreeMap<usize, usize> = BTreeMap::new();
    let mut crf_cnts: BTreeMap<u64, usize> = BTreeMap::new();
    for l in &all_logs {
        *round_cnts.entry(l.pn).or_insert(0) += 1;
        *crf_cnts.entry((l.fc * 100.0).round() as u64).or_insert(0) += 1;
    }
    all_logs.sort_by_key(|l| l.id);

    let out = form_tq_json(&all_logs, &tri, metric_name, fps, &round_cnts, &crf_cnts);
    if let Ok(mut file) = OpenOptions::new()
        .create(true)
        .write(true)
        .truncate(true)
        .open(&log_path)
    {
        _ = file.write_all(out.as_bytes());
    }
}

unsafe extern "C" {
    fn xav_svt_drain_go(
        worker_id: usize,
        handle: *mut EbComponentType,
        d: usize,
        v: usize,
        enced: *mut usize,
        wr: unsafe extern "C" fn(*mut u8, *const u8, usize),
    ) -> *mut u8;
    fn xav_svt_drain_wait(worker_id: usize) -> u64;
}

#[inline(always)]
fn drain_poke(st: *mut u8) {
    sem_release(unsafe { &*st.cast::<Semaphore>() });
}

unsafe extern "C" fn wr_dyn(ctx: *mut u8, buf: *const u8, n: usize) {
    let w = unsafe { *ctx.cast::<*mut dyn Write>() };
    _ = unsafe { &mut *w }.write_all(unsafe { from_raw_parts(buf, n) });
}

fn drain_go(
    worker_id: usize,
    handle: *mut EbComponentType,
    out: &mut dyn Write,
    tr: &Tracker,
) -> *mut u8 {
    let (d, v) = unsafe { transmute::<*mut dyn Write, (usize, usize)>(out) };
    unsafe { xav_svt_drain_go(worker_id, handle, d, v, tr.enced(), wr_dyn) }
}

fn svt_handle(conf: *mut EbSvtAv1EncConfiguration) -> *mut EbComponentType {
    let mut handle: *mut EbComponentType = null_mut();
    let ret = unsafe { svt_av1_enc_init_handle(&raw mut handle, conf) };
    if ret != EB_ERROR_NONE {
        cold_path();
        fatal(format_args!("svt_av1_enc_init_handle failed: {ret}"));
    }
    handle
}

fn svt_defaults() -> &'static [u8; SVT_CONF_SIZE] {
    static DEFAULTS: OnceLock<[u8; SVT_CONF_SIZE]> = OnceLock::new();
    DEFAULTS.get_or_init(|| {
        let mut conf = unsafe { zeroed::<EbSvtAv1EncConfiguration>() };
        let handle = svt_handle(&raw mut conf);
        unsafe { svt_av1_enc_deinit_handle(handle) };
        unsafe { (&raw const conf).cast::<[u8; SVT_CONF_SIZE]>().read() }
    })
}

type BuildTmpl = fn(&VidInf, &str, &[Box<str>], u32, u32, (i32, i32)) -> Vec<Arc<[u8]>>;

#[cold]
#[inline(never)]
fn build_zoned(
    build: BuildTmpl,
    inf: &VidInf,
    params: &str,
    pipe: &Pipeline,
    zones: &[Box<str>],
    qp: (i32, i32),
) -> Vec<Arc<[u8]>> {
    build(
        inf,
        params,
        zones,
        pipe.final_w as u32,
        pipe.final_h as u32,
        qp,
    )
}

#[cold]
fn resolve_build_tmpl(encoder: Encoder) -> Option<BuildTmpl> {
    match encoder {
        SvtAv1 => Some(build_svt_templates),
        #[cfg(feature = "avm")]
        Avm => Some(build_avm_templates),
        #[cfg(not(feature = "avm"))]
        Avm => None,
        #[cfg(feature = "vvenc")]
        Vvenc => Some(build_vvenc_templates),
        #[cfg(not(feature = "vvenc"))]
        Vvenc => None,
        X265 | X264 => None,
    }
}

#[cold]
#[inline(never)]
fn build_svt_templates(
    inf: &VidInf,
    params: &str,
    zones: &[Box<str>],
    width: u32,
    height: u32,
    _: (i32, i32),
) -> Vec<Arc<[u8]>> {
    let mut conf = unsafe {
        svt_defaults()
            .as_ptr()
            .cast::<EbSvtAv1EncConfiguration>()
            .read_unaligned()
    };
    set_svt_base(&raw mut conf, inf, params, width, height);
    let base = unsafe { (&raw const conf).cast::<[u8; SVT_CONF_SIZE]>().read() };

    let mut v: Vec<Arc<[u8]>> = Vec::with_capacity(zones.len() + 1);
    v.push(Arc::new(base));
    for z in zones {
        let mut zc = unsafe {
            (&raw const base)
                .cast::<EbSvtAv1EncConfiguration>()
                .read_unaligned()
        };
        parse_svt_params(&raw mut zc, z);
        v.push(Arc::new(unsafe {
            (&raw const zc).cast::<[u8; SVT_CONF_SIZE]>().read()
        }));
    }
    v
}

fn init_svt(cfg: &EncConfig) -> *mut EbComponentType {
    let mut conf = MaybeUninit::<EbSvtAv1EncConfiguration>::uninit();
    let handle = svt_handle(null_mut());
    unsafe {
        let t = cfg.template.unwrap_unchecked();
        copy_nonoverlapping(t.as_ptr(), conf.as_mut_ptr().cast::<u8>(), SVT_CONF_SIZE);
    }
    let ret = unsafe { svt_av1_enc_set_parameter(handle, conf.as_mut_ptr()) };
    if ret != EB_ERROR_NONE {
        cold_path();
        fatal(format_args!("svt_av1_enc_set_parameter failed: {ret}"));
    }
    let ret = unsafe { svt_av1_enc_init(handle) };
    if ret != EB_ERROR_NONE {
        cold_path();
        fatal(format_args!("svt_av1_enc_init failed: {ret}"));
    }
    handle
}

#[cfg(feature = "vship")]
fn init_svt_crf(cfg: &EncConfig) -> *mut EbComponentType {
    let mut conf = MaybeUninit::<EbSvtAv1EncConfiguration>::uninit();
    let handle = svt_handle(null_mut());
    unsafe {
        let t = cfg.template.unwrap_unchecked();
        copy_nonoverlapping(t.as_ptr(), conf.as_mut_ptr().cast::<u8>(), SVT_CONF_SIZE);
        set_svt_crf(conf.as_mut_ptr(), cfg.crf.unwrap_unchecked());
    }
    let ret = unsafe { svt_av1_enc_set_parameter(handle, conf.as_mut_ptr()) };
    if ret != EB_ERROR_NONE {
        cold_path();
        fatal(format_args!("svt_av1_enc_set_parameter failed: {ret}"));
    }
    let ret = unsafe { svt_av1_enc_init(handle) };
    if ret != EB_ERROR_NONE {
        cold_path();
        fatal(format_args!("svt_av1_enc_init failed: {ret}"));
    }
    handle
}

macro_rules! make_send_svt {
    ($name:ident, $init:ident, $conv:expr) => {
        fn $name(
            out: &mut dyn Write,
            yuv: &[u8],
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            conv_buf: &mut [u8],
            track: &EncTrack,
        ) -> (*mut EbComponentType, Tracker) {
            let &EncTrack {
                worker_id,
                track_frames,
                crf_score,
            } = track;
            let handle = $init(cfg);

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

            let tracker = Tracker::new(
                ctx.prog,
                worker_id,
                cfg.chnk_idx,
                cfg.frames,
                track_frames,
                crf_score,
            );

            let st = drain_go(worker_id, handle, out, &tracker);

            let (fw, fh) = (ctx.pipe.final_w, ctx.pipe.final_h);
            let frame_sz = ctx.pipe.frame_sz;
            let mut src = yuv.as_ptr();
            for i in 0..cfg.frames {
                ($conv)(unsafe { from_raw_parts(src, frame_sz) }, conv_buf, fw, fh);
                src = unsafe { src.add(frame_sz) };

                in_hdr.pts = i as i64;

                let ret = unsafe { svt_av1_enc_send_picture(handle, &raw mut in_hdr) };
                if ret != EB_ERROR_NONE {
                    cold_path();
                    fatal(format_args!(
                        "svt_av1_enc_send_picture failed at frame {i}: {ret}"
                    ));
                }
                drain_poke(st);
            }

            (handle, tracker)
        }
    };
}

make_send_svt!(
    send_svt_conv,
    init_svt,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| {
        conv_10b(f, b);
    }
);
make_send_svt!(
    send_svt_conv_rem,
    init_svt,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| conv_10b_rem(f, b)
);
make_send_svt!(
    send_svt_unpack,
    init_svt,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| unpack_10b(f, b)
);
make_send_svt!(
    send_svt_unpack_rem,
    init_svt,
    |f: &[u8], b: &mut [u8], w: usize, h: usize| unpack_10b_rem(f, b, w, h)
);
make_send_svt!(
    send_svt_nv12,
    init_svt,
    |f: &[u8], b: &mut [u8], w: usize, h: usize| {
        nv12_10b(f, b, w, h);
    }
);
make_send_svt!(
    send_svt_nv12_rem,
    init_svt,
    |f: &[u8], b: &mut [u8], w: usize, h: usize| nv12_10b_rem(f, b, w, h)
);

#[cfg(feature = "vship")]
make_send_svt!(
    send_svt_crf,
    init_svt_crf,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| {
        conv_10b(f, b);
    }
);
#[cfg(feature = "vship")]
make_send_svt!(
    send_svt_crf_rem,
    init_svt_crf,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| conv_10b_rem(f, b)
);
#[cfg(feature = "vship")]
make_send_svt!(
    send_svt_crf_unpack,
    init_svt_crf,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| unpack_10b(f, b)
);
#[cfg(feature = "vship")]
make_send_svt!(
    send_svt_crf_unpack_rem,
    init_svt_crf,
    |f: &[u8], b: &mut [u8], w: usize, h: usize| unpack_10b_rem(f, b, w, h)
);
macro_rules! make_enc_svt {
    ($name:ident, $send:ident) => {
        fn $name(
            yuv: &mut Vec<u8>,
            out: &mut dyn Write,
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            conv_buf: &mut [u8],
            track: &EncTrack,
        ) -> u64 {
            let (handle, tracker) = $send(out, yuv, cfg, ctx, conv_buf, track);
            *yuv = Vec::new();
            finish_svt(handle, track.worker_id, &tracker)
        }
    };
}

#[cfg(feature = "vship")]
macro_rules! make_enc_svt_tq {
    ($name:ident, $send:ident) => {
        fn $name(
            yuv: &mut Vec<u8>,
            out: &mut dyn Write,
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            conv_buf: &mut [u8],
            track: &EncTrack,
        ) -> u64 {
            let (handle, tracker) = $send(out, yuv.as_slice(), cfg, ctx, conv_buf, track);
            finish_svt(handle, track.worker_id, &tracker)
        }
    };
}

make_enc_svt!(enc_svt_drop, send_svt_conv);
make_enc_svt!(enc_svt_drop_rem, send_svt_conv_rem);
make_enc_svt!(enc_svt_unpack_drop, send_svt_unpack);
make_enc_svt!(enc_svt_unpack_drop_rem, send_svt_unpack_rem);
make_enc_svt!(enc_svt_nv12_drop, send_svt_nv12);
make_enc_svt!(enc_svt_nv12_drop_rem, send_svt_nv12_rem);

#[cfg(feature = "vship")]
make_enc_svt_tq!(enc_svt_lib, send_svt_crf);
#[cfg(feature = "vship")]
make_enc_svt_tq!(enc_svt_lib_rem, send_svt_crf_rem);
#[cfg(feature = "vship")]
make_enc_svt_tq!(enc_svt_lib_unpack, send_svt_crf_unpack);
#[cfg(feature = "vship")]
make_enc_svt_tq!(enc_svt_lib_unpack_rem, send_svt_crf_unpack_rem);

fn enc_svt_direct(
    yuv: &mut Vec<u8>,
    out: &mut dyn Write,
    cfg: &EncConfig,
    ctx: &EncWorkerCtx,
    _conv_buf: &mut [u8],
    track: &EncTrack,
) -> u64 {
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

    let tracker = Tracker::new(
        ctx.prog,
        worker_id,
        cfg.chnk_idx,
        cfg.frames,
        track_frames,
        crf_score,
    );

    let st = drain_go(worker_id, handle, out, &tracker);

    let frame_sz = ctx.pipe.frame_sz;
    let mut src = yuv.as_ptr().cast_mut();
    for i in 0..cfg.frames {
        unsafe {
            (*io_ptr).luma = src;
            (*io_ptr).cb = src.add(y_sz);
            (*io_ptr).cr = src.add(y_sz + uv_sz);
            src = src.add(frame_sz);
        }

        in_hdr.pts = i as i64;

        let ret = unsafe { svt_av1_enc_send_picture(handle, &raw mut in_hdr) };
        if ret != EB_ERROR_NONE {
            cold_path();
            fatal(format_args!(
                "svt_av1_enc_send_picture failed at frame {i}: {ret}"
            ));
        }
        drain_poke(st);
    }
    *yuv = Vec::new();

    finish_svt(handle, worker_id, &tracker)
}

fn finish_svt(handle: *mut EbComponentType, worker_id: usize, tracker: &Tracker) -> u64 {
    let mut eos = unsafe { zeroed::<EbBufferHeaderType>() };
    eos.flags = EB_BUFFERFLAG_EOS;
    unsafe { svt_av1_enc_send_picture(handle, &raw mut eos) };

    let sz = unsafe { xav_svt_drain_wait(worker_id) };

    tracker.finish();

    unsafe {
        svt_av1_enc_deinit(handle);
        svt_av1_enc_deinit_handle(handle);
    }
    sz
}

#[cfg(feature = "avm")]
#[cold]
#[inline(never)]
fn build_avm_templates(
    inf: &VidInf,
    params: &str,
    zones: &[Box<str>],
    width: u32,
    height: u32,
    _: (i32, i32),
) -> Vec<Arc<[u8]>> {
    let mut conf = MaybeUninit::<AvmCodecEncCfg>::uninit();
    unsafe { avm_codec_enc_config_default(avm_codec_av2_cx(), conf.as_mut_ptr(), 0) };
    let mut conf = unsafe { conf.assume_init() };
    let ctrls = set_avm_base(&mut conf, inf, width, height);

    let mut opts = Vec::with_capacity(params.len());
    avm_split(&mut conf, params, &mut opts);

    let mut v = Vec::with_capacity(zones.len() + 1);
    v.push(assemble_avm_tmpl(&conf, &ctrls, &opts));
    for z in zones {
        let mut zc = conf;
        let mut zopts = Vec::with_capacity(opts.len() + z.len());
        zopts.extend_from_slice(&opts);
        avm_split(&mut zc, z, &mut zopts);
        v.push(assemble_avm_tmpl(&zc, &ctrls, &zopts));
    }
    v
}

#[cfg(feature = "avm")]
#[cold]
#[inline(never)]
fn assemble_avm_tmpl(conf: &AvmCodecEncCfg, ctrls: &[i32; AVM_CTRL_CNT], opts: &[u8]) -> Arc<[u8]> {
    let (hdr, extra) = avm_snapshot(conf, ctrls, opts);
    let mut tmpl = Vec::with_capacity(AVM_TMPL_HDR + extra.len());
    tmpl.extend_from_slice(unsafe {
        from_raw_parts((&raw const *conf).cast::<u8>(), AVM_CFG_SIZE)
    });
    tmpl.extend_from_slice(unsafe {
        from_raw_parts((&raw const hdr).cast::<u8>(), size_of::<AvmTmpl>())
    });
    tmpl.extend_from_slice(&extra);
    Arc::from(tmpl)
}

#[cfg(feature = "avm")]
fn init_avm(cfg: &EncConfig, ec: *mut AvmCodecCtx) {
    let t = unsafe { cfg.template.unwrap_unchecked() };
    let mut conf = unsafe { t.as_ptr().cast::<AvmCodecEncCfg>().read_unaligned() };
    conf.g_limit = cfg.frames as u32;
    conf.g_lag_in_frames = conf.g_limit.min(AVM_MAX_LAG);
    let hdr = unsafe {
        t.as_ptr()
            .add(AVM_CFG_SIZE)
            .cast::<AvmTmpl>()
            .read_unaligned()
    };

    avm_init(&conf, ec);
    avm_blit(ec, hdr, unsafe { t.get_unchecked(AVM_TMPL_HDR..) });
}

#[cfg(feature = "avm")]
const fn avm_img(cfg: &EncConfig) -> AvmImage {
    let mut img = unsafe { zeroed::<AvmImage>() };
    img.fmt = AVM_IMG_FMT_I42016;
    img.w = cfg.width;
    img.h = cfg.height;
    img.d_w = cfg.width;
    img.d_h = cfg.height;
    img.bit_depth = 16;
    img.bps = 24;
    img.x_chroma_shift = 1;
    img.y_chroma_shift = 1;
    img.stride = [(cfg.width * 2) as i32, cfg.width as i32, cfg.width as i32];
    img
}

#[cfg(feature = "avm")]
fn drain_avm_packets(
    ec: *mut AvmCodecCtx,
    out: &mut dyn Write,
    tracker: &Tracker,
    done: &mut usize,
) -> u64 {
    let mut iter: *const c_void = null();
    let mut sz = 0;
    loop {
        let pkt = unsafe { avm_codec_get_cx_data(ec, &raw mut iter) };
        if pkt.is_null() {
            return sz;
        }
        let p = unsafe { &*pkt };
        if p.kind == AVM_CODEC_CX_FRAME_PKT {
            _ = out.write_all(unsafe { from_raw_parts(p.frame.buf.cast::<u8>(), p.frame.sz) });
            sz += p.frame.sz as u64;
        } else {
            cold_path();
        }
        *done += 1;
        tracker.set(*done);
    }
}

#[cfg(feature = "avm")]
macro_rules! make_send_avm {
    ($name:ident, $conv:expr) => {
        fn $name(
            ec: *mut AvmCodecCtx,
            out: &mut dyn Write,
            yuv: &[u8],
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            conv_buf: &mut [u8],
            track: &EncTrack,
        ) -> (Tracker, usize, u64) {
            let &EncTrack {
                worker_id,
                track_frames,
                crf_score,
            } = track;
            init_avm(cfg, ec);

            let w = cfg.width as usize;
            let h = cfg.height as usize;
            let y_sz = w * h * 2;
            let uv_sz = (w / 2) * (h / 2) * 2;

            let mut img = avm_img(cfg);
            img.planes = [
                conv_buf.as_mut_ptr(),
                unsafe { conv_buf.as_mut_ptr().add(y_sz) },
                unsafe { conv_buf.as_mut_ptr().add(y_sz + uv_sz) },
            ];
            let img_ptr = &raw const img;

            let tracker = Tracker::new(
                ctx.prog,
                worker_id,
                cfg.chnk_idx,
                cfg.frames,
                track_frames,
                crf_score,
            );
            let mut done = 0;
            let mut sz = 0;
            let (fw, fh) = (ctx.pipe.final_w, ctx.pipe.final_h);
            let frame_sz = ctx.pipe.frame_sz;
            let mut src = yuv.as_ptr();

            for i in 0..cfg.frames {
                ($conv)(unsafe { from_raw_parts(src, frame_sz) }, conv_buf, fw, fh);
                src = unsafe { src.add(frame_sz) };

                let ret = unsafe { avm_codec_encode(ec, img_ptr, i as i64, 1, 0) };
                if ret != AVM_CODEC_OK {
                    cold_path();
                    fatal(format_args!("avm_codec_encode failed at frame {i}: {ret}"));
                }

                sz += drain_avm_packets(ec, out, &tracker, &mut done);
            }

            (tracker, done, sz)
        }
    };
}

#[cfg(feature = "avm")]
make_send_avm!(send_avm_conv, |f: &[u8],
                               b: &mut [u8],
                               _w: usize,
                               _h: usize| {
    conv_10b(f, b);
});
#[cfg(feature = "avm")]
make_send_avm!(
    send_avm_conv_rem,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| conv_10b_rem(f, b)
);
#[cfg(feature = "avm")]
make_send_avm!(
    send_avm_unpack,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| unpack_10b(f, b)
);
#[cfg(feature = "avm")]
make_send_avm!(
    send_avm_unpack_rem,
    |f: &[u8], b: &mut [u8], w: usize, h: usize| unpack_10b_rem(f, b, w, h)
);
#[cfg(feature = "avm")]
make_send_avm!(send_avm_nv12, |f: &[u8],
                               b: &mut [u8],
                               w: usize,
                               h: usize| {
    nv12_10b(f, b, w, h);
});
#[cfg(feature = "avm")]
make_send_avm!(
    send_avm_nv12_rem,
    |f: &[u8], b: &mut [u8], w: usize, h: usize| nv12_10b_rem(f, b, w, h)
);

#[cfg(feature = "avm")]
macro_rules! make_enc_avm {
    ($name:ident, $send:ident) => {
        fn $name(
            yuv: &mut Vec<u8>,
            out: &mut dyn Write,
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            conv_buf: &mut [u8],
            track: &EncTrack,
        ) -> u64 {
            let mut ec = MaybeUninit::<AvmCodecCtx>::uninit();
            let ecp = ec.as_mut_ptr();
            let (tracker, mut done, sz) = $send(ecp, out, yuv, cfg, ctx, conv_buf, track);
            *yuv = Vec::new();
            sz + finish_avm(ecp, out, &tracker, &mut done)
        }
    };
}

#[cfg(feature = "avm")]
make_enc_avm!(enc_avm_conv, send_avm_conv);
#[cfg(feature = "avm")]
make_enc_avm!(enc_avm_conv_rem, send_avm_conv_rem);
#[cfg(feature = "avm")]
make_enc_avm!(enc_avm_unpack, send_avm_unpack);
#[cfg(feature = "avm")]
make_enc_avm!(enc_avm_unpack_rem, send_avm_unpack_rem);
#[cfg(feature = "avm")]
make_enc_avm!(enc_avm_nv12, send_avm_nv12);
#[cfg(feature = "avm")]
make_enc_avm!(enc_avm_nv12_rem, send_avm_nv12_rem);

#[cfg(feature = "avm")]
fn enc_avm_direct(
    yuv: &mut Vec<u8>,
    out: &mut dyn Write,
    cfg: &EncConfig,
    ctx: &EncWorkerCtx,
    _conv_buf: &mut [u8],
    track: &EncTrack,
) -> u64 {
    let &EncTrack {
        worker_id,
        track_frames,
        crf_score,
    } = track;
    let mut ec = MaybeUninit::<AvmCodecCtx>::uninit();
    let ecp = ec.as_mut_ptr();
    init_avm(cfg, ecp);

    let w = cfg.width as usize;
    let h = cfg.height as usize;
    let y_sz = w * h * 2;
    let uv_sz = (w / 2) * (h / 2) * 2;

    let mut img = avm_img(cfg);
    let img_ptr = &raw mut img;

    let tracker = Tracker::new(
        ctx.prog,
        worker_id,
        cfg.chnk_idx,
        cfg.frames,
        track_frames,
        crf_score,
    );
    let mut done = 0;
    let mut sz = 0;
    let frame_sz = ctx.pipe.frame_sz;
    let mut src = yuv.as_ptr().cast_mut();

    for i in 0..cfg.frames {
        unsafe {
            (*img_ptr).planes = [src, src.add(y_sz), src.add(y_sz + uv_sz)];
            src = src.add(frame_sz);
        }

        let ret = unsafe { avm_codec_encode(ecp, img_ptr, i as i64, 1, 0) };
        if ret != AVM_CODEC_OK {
            cold_path();
            fatal(format_args!("avm_codec_encode failed at frame {i}: {ret}"));
        }

        sz += drain_avm_packets(ecp, out, &tracker, &mut done);
    }
    *yuv = Vec::new();

    sz + finish_avm(ecp, out, &tracker, &mut done)
}

#[cfg(feature = "avm")]
fn finish_avm(
    ec: *mut AvmCodecCtx,
    out: &mut dyn Write,
    tracker: &Tracker,
    done: &mut usize,
) -> u64 {
    let mut sz = 0;
    loop {
        unsafe { avm_codec_encode(ec, null(), 0, 0, 0) };
        let before = *done;
        sz += drain_avm_packets(ec, out, tracker, done);
        if *done == before {
            break;
        }
    }

    tracker.finish();

    unsafe { avm_codec_destroy(ec) };

    sz
}

#[cfg(feature = "vvenc")]
const VVENC_MAX_QP: i32 = 63;

#[cfg(feature = "vvenc")]
#[cold]
#[inline(never)]
fn build_vvenc_templates(
    inf: &VidInf,
    params: &str,
    zones: &[Box<str>],
    width: u32,
    height: u32,
    qp: (i32, i32),
) -> Vec<Arc<[u8]>> {
    if qp.0 >= 0 && (qp.0 > qp.1 || qp.1 > VVENC_MAX_QP) {
        cold_path();
        fatal(format_args!(
            "vvenc: -f/--qp range must be within 0-{VVENC_MAX_QP}"
        ));
    }
    let lo = qp.0;
    let hi = (qp.1 + 1).min(VVENC_MAX_QP);
    let n = if lo < 0 { 1 } else { (hi - lo + 1) as usize };
    let hdr = if lo < 0 { 0 } else { VVENC_TQ_HDR };
    let sz = hdr + n * VVENC_CFG_SIZE;

    let args = vvenc_args(inf, params, width, height);
    let mut v = Vec::with_capacity(zones.len() + 1);
    v.push(vvenc_tmpl(&args, &Argv::EMPTY, lo, n, hdr, sz));
    for z in zones {
        v.push(vvenc_tmpl(&args, &vvenc_zone_args(z), lo, n, hdr, sz));
    }
    v
}

// one parse feeds every qp
#[cfg(feature = "vvenc")]
#[cold]
#[inline(never)]
fn vvenc_tmpl(args: &Argv, zone: &Argv, lo: i32, n: usize, hdr: usize, sz: usize) -> Arc<[u8]> {
    // parse target holds doubles and pointers; must stay 8-aligned
    let mut t = Vec::<u64>::with_capacity(sz / size_of::<u64>());
    let base = t.as_mut_ptr().cast::<u8>();
    unsafe {
        let first = base.add(hdr);
        write_bytes(first, 0, VVENC_CFG_SIZE);
        vvenc_parse(first, &args.buf, &zone.buf, args.n + zone.n);
        for i in 1..n {
            let d = first.add(i * VVENC_CFG_SIZE);
            copy_nonoverlapping(first, d, VVENC_CFG_SIZE);
            vvenc_qp(d, lo + i as i32);
            vvenc_derive(d);
        }
        if hdr != 0 {
            base.cast::<u64>().write(lo as u64);
            vvenc_qp(first, lo);
        }
        vvenc_derive(first);
        Arc::from(from_raw_parts(base, sz))
    }
}

#[cfg(feature = "vvenc")]
fn init_vvenc(cfg: &EncConfig) -> *mut c_void {
    vvenc_open(unsafe { cfg.template.unwrap_unchecked() }, cfg.frames)
}

#[cfg(all(feature = "vvenc", feature = "vship"))]
fn init_vvenc_crf(cfg: &EncConfig) -> *mut c_void {
    let t = unsafe { cfg.template.unwrap_unchecked() };
    let lo = unsafe { t.as_ptr().cast::<u32>().read_unaligned() };
    let q = unsafe { cfg.crf.unwrap_unchecked() } as u32;
    let off = VVENC_TQ_HDR + (q - lo) as usize * VVENC_CFG_SIZE;
    vvenc_open(unsafe { t.get_unchecked(off..) }, cfg.frames)
}

#[cfg(feature = "vvenc")]
const fn vvenc_plane(width: i32, height: i32) -> VvencYuvPlane {
    VvencYuvPlane {
        ptr: null_mut(),
        width,
        height,
        stride: width,
    }
}

#[cfg(feature = "vvenc")]
const fn vvenc_yuv(cfg: &EncConfig) -> VvencYuvBuffer {
    let (w, h) = (cfg.width as i32, cfg.height as i32);
    VvencYuvBuffer {
        planes: [
            vvenc_plane(w, h),
            vvenc_plane(w / 2, h / 2),
            vvenc_plane(w / 2, h / 2),
        ],
        sequence_number: 0,
        cts: 0,
        cts_valid: false,
    }
}

// worst case access unit for <= 4:2:0
#[cfg(feature = "vvenc")]
const fn vvenc_au(cfg: &EncConfig) -> VvencAccessUnit {
    let mut au = unsafe { zeroed::<VvencAccessUnit>() };
    au.payload_size = (cfg.width as usize * cfg.height as usize * 2 + 1024) as i32;
    au
}

// bytes stay pending until the next spare folds them in; an au is one sink call
#[cfg(feature = "vvenc")]
fn emit_au(au: &VvencAccessUnit, tracker: &Tracker, done: &mut usize) -> usize {
    let n = au.payload_used_size as usize;
    if n == 0 {
        return 0;
    }
    *done += 1;
    tracker.set(*done);
    n
}

#[cfg(feature = "vvenc")]
macro_rules! make_send_vvenc {
    ($name:ident, $init:ident, $conv:expr) => {
        fn $name(
            au: &mut VvencAccessUnit,
            out: &mut dyn Write,
            yuv: &[u8],
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            conv_buf: &mut [u8],
            track: &EncTrack,
        ) -> (*mut c_void, Tracker, usize, u64, usize) {
            let &EncTrack {
                worker_id,
                track_frames,
                crf_score,
            } = track;
            let enc = $init(cfg);

            let w = cfg.width as usize;
            let h = cfg.height as usize;
            let y_sz = w * h * 2;
            let uv_sz = (w / 2) * (h / 2) * 2;

            let mut yb = vvenc_yuv(cfg);
            yb.planes[0].ptr = conv_buf.as_mut_ptr().cast();
            yb.planes[1].ptr = unsafe { conv_buf.as_mut_ptr().add(y_sz).cast() };
            yb.planes[2].ptr = unsafe { conv_buf.as_mut_ptr().add(y_sz + uv_sz).cast() };

            let tracker = Tracker::new(
                ctx.prog,
                worker_id,
                cfg.chnk_idx,
                cfg.frames,
                track_frames,
                crf_score,
            );
            let mut done = 0;
            let mut sz = 0;
            let mut fin = false;
            let (fw, fh) = (ctx.pipe.final_w, ctx.pipe.final_h);
            let frame_sz = ctx.pipe.frame_sz;
            let mut src = yuv.as_ptr();
            // nothing vvenc does to the au modifies payload_size; never reloads
            let cap = au.payload_size as usize;
            let mut pend = 0;

            for i in 0..cfg.frames {
                ($conv)(unsafe { from_raw_parts(src, frame_sz) }, conv_buf, fw, fh);
                src = unsafe { src.add(frame_sz) };

                au.payload = out.spare(pend, cap);

                let ret = unsafe { vvenc_encode(enc, &raw mut yb, au, &raw mut fin) };
                if ret != VVENC_OK {
                    cold_path();
                    fatal(format_args!("vvenc_encode failed at frame {i}: {ret}"));
                }

                pend = emit_au(au, &tracker, &mut done);
                sz += pend as u64;
            }

            (enc, tracker, done, sz, pend)
        }
    };
}

#[cfg(feature = "vvenc")]
make_send_vvenc!(
    send_vvenc_conv,
    init_vvenc,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| {
        conv_10b(f, b);
    }
);
#[cfg(feature = "vvenc")]
make_send_vvenc!(
    send_vvenc_conv_rem,
    init_vvenc,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| conv_10b_rem(f, b)
);
#[cfg(feature = "vvenc")]
make_send_vvenc!(
    send_vvenc_unpack,
    init_vvenc,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| unpack_10b(f, b)
);
#[cfg(feature = "vvenc")]
make_send_vvenc!(
    send_vvenc_unpack_rem,
    init_vvenc,
    |f: &[u8], b: &mut [u8], w: usize, h: usize| unpack_10b_rem(f, b, w, h)
);
#[cfg(feature = "vvenc")]
make_send_vvenc!(
    send_vvenc_nv12,
    init_vvenc,
    |f: &[u8], b: &mut [u8], w: usize, h: usize| {
        nv12_10b(f, b, w, h);
    }
);
#[cfg(feature = "vvenc")]
make_send_vvenc!(
    send_vvenc_nv12_rem,
    init_vvenc,
    |f: &[u8], b: &mut [u8], w: usize, h: usize| nv12_10b_rem(f, b, w, h)
);

#[cfg(all(feature = "vvenc", feature = "vship"))]
make_send_vvenc!(
    send_vvenc_crf,
    init_vvenc_crf,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| {
        conv_10b(f, b);
    }
);
#[cfg(all(feature = "vvenc", feature = "vship"))]
make_send_vvenc!(
    send_vvenc_crf_rem,
    init_vvenc_crf,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| conv_10b_rem(f, b)
);
#[cfg(all(feature = "vvenc", feature = "vship"))]
make_send_vvenc!(
    send_vvenc_crf_unpack,
    init_vvenc_crf,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| unpack_10b(f, b)
);
#[cfg(all(feature = "vvenc", feature = "vship"))]
make_send_vvenc!(
    send_vvenc_crf_unpack_rem,
    init_vvenc_crf,
    |f: &[u8], b: &mut [u8], w: usize, h: usize| unpack_10b_rem(f, b, w, h)
);

#[cfg(feature = "vvenc")]
macro_rules! make_enc_vvenc {
    ($name:ident, $send:ident) => {
        fn $name(
            yuv: &mut Vec<u8>,
            out: &mut dyn Write,
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            conv_buf: &mut [u8],
            track: &EncTrack,
        ) -> u64 {
            let mut au = vvenc_au(cfg);
            let (enc, tracker, mut done, sz, pend) =
                $send(&mut au, out, yuv, cfg, ctx, conv_buf, track);
            *yuv = Vec::new();
            sz + finish_vvenc(enc, &mut au, out, &tracker, &mut done, pend)
        }
    };
}

#[cfg(all(feature = "vvenc", feature = "vship"))]
macro_rules! make_enc_vvenc_tq {
    ($name:ident, $send:ident) => {
        fn $name(
            yuv: &mut Vec<u8>,
            out: &mut dyn Write,
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            conv_buf: &mut [u8],
            track: &EncTrack,
        ) -> u64 {
            let mut au = vvenc_au(cfg);
            let (enc, tracker, mut done, sz, pend) =
                $send(&mut au, out, yuv.as_slice(), cfg, ctx, conv_buf, track);
            sz + finish_vvenc(enc, &mut au, out, &tracker, &mut done, pend)
        }
    };
}

#[cfg(feature = "vvenc")]
make_enc_vvenc!(enc_vvenc_conv, send_vvenc_conv);
#[cfg(feature = "vvenc")]
make_enc_vvenc!(enc_vvenc_conv_rem, send_vvenc_conv_rem);
#[cfg(feature = "vvenc")]
make_enc_vvenc!(enc_vvenc_unpack, send_vvenc_unpack);
#[cfg(feature = "vvenc")]
make_enc_vvenc!(enc_vvenc_unpack_rem, send_vvenc_unpack_rem);
#[cfg(feature = "vvenc")]
make_enc_vvenc!(enc_vvenc_nv12, send_vvenc_nv12);
#[cfg(feature = "vvenc")]
make_enc_vvenc!(enc_vvenc_nv12_rem, send_vvenc_nv12_rem);

#[cfg(all(feature = "vvenc", feature = "vship"))]
make_enc_vvenc_tq!(enc_vvenc_lib, send_vvenc_crf);
#[cfg(all(feature = "vvenc", feature = "vship"))]
make_enc_vvenc_tq!(enc_vvenc_lib_rem, send_vvenc_crf_rem);
#[cfg(all(feature = "vvenc", feature = "vship"))]
make_enc_vvenc_tq!(enc_vvenc_lib_unpack, send_vvenc_crf_unpack);
#[cfg(all(feature = "vvenc", feature = "vship"))]
make_enc_vvenc_tq!(enc_vvenc_lib_unpack_rem, send_vvenc_crf_unpack_rem);

#[cfg(feature = "vvenc")]
fn enc_vvenc_direct(
    yuv: &mut Vec<u8>,
    out: &mut dyn Write,
    cfg: &EncConfig,
    ctx: &EncWorkerCtx,
    _conv_buf: &mut [u8],
    track: &EncTrack,
) -> u64 {
    let &EncTrack {
        worker_id,
        track_frames,
        crf_score,
    } = track;
    let enc = init_vvenc(cfg);

    let w = cfg.width as usize;
    let h = cfg.height as usize;
    let y_sz = w * h * 2;
    let uv_sz = (w / 2) * (h / 2) * 2;

    let mut au = vvenc_au(cfg);
    let mut yb = vvenc_yuv(cfg);

    let tracker = Tracker::new(
        ctx.prog,
        worker_id,
        cfg.chnk_idx,
        cfg.frames,
        track_frames,
        crf_score,
    );
    let mut done = 0;
    let mut sz = 0;
    let mut fin = false;
    let frame_sz = ctx.pipe.frame_sz;
    let mut src = yuv.as_ptr().cast_mut();
    // no payload_size change; never reloads
    let cap = au.payload_size as usize;
    let mut pend = 0;

    for i in 0..cfg.frames {
        unsafe {
            yb.planes[0].ptr = src.cast();
            yb.planes[1].ptr = src.add(y_sz).cast();
            yb.planes[2].ptr = src.add(y_sz + uv_sz).cast();
            src = src.add(frame_sz);
        }

        au.payload = out.spare(pend, cap);

        let ret = unsafe { vvenc_encode(enc, &raw mut yb, &raw mut au, &raw mut fin) };
        if ret != VVENC_OK {
            cold_path();
            fatal(format_args!("vvenc_encode failed at frame {i}: {ret}"));
        }

        pend = emit_au(&au, &tracker, &mut done);
        sz += pend as u64;
    }

    *yuv = Vec::new();

    sz + finish_vvenc(enc, &mut au, out, &tracker, &mut done, pend)
}

#[cfg(feature = "vvenc")]
fn finish_vvenc(
    enc: *mut c_void,
    au: &mut VvencAccessUnit,
    out: &mut dyn Write,
    tracker: &Tracker,
    done: &mut usize,
    mut pend: usize,
) -> u64 {
    let mut sz = 0;
    let mut fin = false;
    let cap = au.payload_size as usize;
    while !fin {
        au.payload = out.spare(pend, cap);
        unsafe { vvenc_encode(enc, null_mut(), au, &raw mut fin) };
        pend = emit_au(au, tracker, done);
        sz += pend as u64;
    }
    out.commit(pend);

    tracker.finish();

    unsafe { vvenc_encoder_close(enc) };

    sz
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
        (enc_svt_direct as LibEncFn) as usize
    }
    pub fn enc_svt_drop_addr() -> usize {
        (enc_svt_drop as LibEncFn) as usize
    }
    pub fn enc_svt_drop_rem_addr() -> usize {
        (enc_svt_drop_rem as LibEncFn) as usize
    }
    pub fn enc_svt_nv12_drop_addr() -> usize {
        (enc_svt_nv12_drop as LibEncFn) as usize
    }
    pub fn enc_svt_nv12_drop_rem_addr() -> usize {
        (enc_svt_nv12_drop_rem as LibEncFn) as usize
    }
    pub fn enc_svt_unpack_drop_addr() -> usize {
        (enc_svt_unpack_drop as LibEncFn) as usize
    }
    pub fn enc_svt_unpack_drop_rem_addr() -> usize {
        (enc_svt_unpack_drop_rem as LibEncFn) as usize
    }

    #[cfg(feature = "vship")]
    pub fn resolve_metric_loop_addr(
        dav1d: bool,
        use_alt: bool,
        cvvdp: bool,
        inf: &VidInf,
        pipe: &Pipeline,
    ) -> usize {
        let tq = TQCtx {
            target: 0.0,
            tolerance: 0.0,
            qp_min: 0.0,
            qp_max: 0.0,
            use_butter: false,
            use_cvvdp: cvvdp,
        };
        resolve_metric_loop(if dav1d { SvtAv1 } else { X265 }, use_alt, &tq, inf, pipe) as usize
    }

    #[cfg(feature = "vship")]
    pub fn met_cvvdp_8b_addr() -> usize {
        (met_d_cv_8b as MetricLoopFn) as usize
    }
    #[cfg(feature = "vship")]
    pub fn met_cvvdp_10b_addr() -> usize {
        (met_d_cv_10b as MetricLoopFn) as usize
    }
    #[cfg(feature = "vship")]
    pub fn met_cvvdp_rem_addr() -> usize {
        (met_d_cv_rem as MetricLoopFn) as usize
    }
}
