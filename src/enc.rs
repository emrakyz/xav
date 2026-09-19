#[cfg(feature = "vship")]
use alloc::collections::BTreeMap;
#[cfg(all(target_os = "linux", feature = "vship"))]
use alloc::string::String;
#[cfg(target_os = "linux")]
use alloc::vec::Vec;
use alloc::{boxed::Box, collections::BTreeSet, sync::Arc};
#[cfg(feature = "x264")]
use core::ffi::c_int;
#[cfg(any(feature = "avm", feature = "vvenc", feature = "x264", feature = "x265"))]
use core::ffi::c_void;
#[cfg(any(feature = "avm", feature = "vship", feature = "x265"))]
use core::ptr::null;
#[cfg(any(feature = "avm", feature = "vvenc"))]
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
#[cfg(not(target_os = "linux"))]
use std::path::MAIN_SEPARATOR;

#[cfg(feature = "avm")]
use crate::avm::{
    AVM_CFG_SIZE, AVM_CODEC_CX_FRAME_PKT, AVM_CODEC_OK, AVM_CTRL_CNT, AVM_IMG_FMT_I42016,
    AVM_MAX_LAG, AVM_TMPL_HDR, AvmCodecCtx, AvmCodecEncCfg, AvmImage, AvmTmpl, avm_blit,
    avm_codec_av2_cx, avm_codec_destroy, avm_codec_enc_config_default, avm_codec_encode,
    avm_codec_get_cx_data, avm_init, avm_snapshot, avm_split, set_avm_base,
};
#[cfg(feature = "vship")]
use crate::chan::{mpmc_close, mpmc_recv, mpmc_send, mpsc_recv, mpsc_send};
#[cfg(any(feature = "vvenc", feature = "x264", feature = "x265"))]
use crate::encoder::ParamBufs;
#[cfg(any(feature = "x264", feature = "x265"))]
use crate::encoder::{H26xArgv, h26x_zone_args};
#[cfg(all(target_os = "linux", not(test), feature = "vship"))]
use crate::fmath::FloatExt as _;
#[cfg(all(feature = "x264", feature = "vship"))]
use crate::tq::make_avc;
#[cfg(all(feature = "x265", feature = "vship"))]
use crate::tq::make_hevc;
#[cfg(all(feature = "vship", any(feature = "x264", feature = "x265")))]
use crate::tq::{
    calc_butter_8b_annexb, calc_butter_10b_annexb, calc_butter_rem_annexb, calc_cvvdp_8b_annexb,
    calc_cvvdp_10b_annexb, calc_cvvdp_rem_annexb, calc_ssimu2_8b_annexb, calc_ssimu2_10b_annexb,
    calc_ssimu2_rem_annexb, pad_probe, prep_annexb,
};
#[cfg(all(feature = "vvenc", feature = "vship"))]
use crate::tq::{
    calc_butter_8b_vvdec, calc_butter_10b_vvdec, calc_butter_rem_vvdec, calc_cvvdp_8b_vvdec,
    calc_cvvdp_10b_vvdec, calc_cvvdp_rem_vvdec, calc_ssimu2_8b_vvdec, calc_ssimu2_10b_vvdec,
    calc_ssimu2_rem_vvdec, make_vvdec, prep_vvdec,
};
#[cfg(not(all(feature = "avm", feature = "vvenc", feature = "x264", feature = "x265")))]
use crate::util::assume_unreachable;
#[cfg(all(feature = "x264", feature = "vship"))]
use crate::x264::x264_crf;
#[cfg(all(feature = "x265", feature = "vship"))]
use crate::x265::x265_crf;
use crate::{
    Args,
    chan::{Semaphore, SeqRing, sem_release, spmc_close, spmc_recv, spmc_send},
    chunk::{Chunk, ChunkComp, ResumeInf, get_resume, zone_tmpls},
    dec::{Bufs, dec_chnks, dec_pipe},
    encoder::{
        EncConfig, Encoder,
        Encoder::{Avm, SvtAv1, Vvenc, X264, X265},
        SVT_CONF_SIZE, Tmpl, parse_svt_params, set_svt_base,
    },
    error::fatal,
    ffms::{DecStrat, VidInf, nv12_10b, nv12_10b_rem},
    fs::File,
    io::{BUF as SINK, BufWriter, Write},
    pack::{
        PACK_CHUNK, SHIFT_CHUNK, UNPACK_CHUNK, xav_conv_10b, xav_conv_10b_rem, xav_unpack_10b,
        xav_unpack_10b_rem,
    },
    path::{Path, leak_path},
    pipeline::Pipeline,
    progs::{ProgsTrack, Tracker},
    svt::{
        EB_BUFFERFLAG_EOS, EB_ERROR_NONE, EbBufferHeaderType, EbComponentType,
        EbSvtAv1EncConfiguration, EbSvtIOFormat, svt_av1_enc_deinit, svt_av1_enc_deinit_handle,
        svt_av1_enc_init, svt_av1_enc_init_handle, svt_av1_enc_send_picture,
        svt_av1_enc_set_parameter,
    },
    sync::{Mutex, OnceLock},
    thread::{JoinHandle, spawn},
    worker::WorkPkg,
    y4m::PipeReader,
};
#[cfg(feature = "vship")]
use crate::{
    atofu::{TqChunkLine, parse_chunks},
    chunk::MAX_CHNK_FRAMES,
    fs::{File as FsFile, OpenOptions, read, write},
    pipeline::MetricProgs,
    thread::{PHandle, available_parallelism, pspawn},
    tq::{
        Agg, MetricBufs, Probe, calc_butter_8b_dav1d, calc_butter_10b_dav1d, calc_butter_rem_dav1d,
        calc_cvvdp_8b_dav1d, calc_cvvdp_10b_dav1d, calc_cvvdp_rem_dav1d, calc_ssimu2_8b_dav1d,
        calc_ssimu2_10b_dav1d, calc_ssimu2_rem_dav1d, interpolate_crf, make_dav1d, prep_dav1d,
    },
    vship::{Disp, PinnedBuf, VshipProcessor, init_device},
    worker::TQState,
};
#[cfg(feature = "vship")]
use crate::{encoder::set_svt_crf, interp::bisect};
#[cfg(feature = "x264")]
use crate::{
    encoder::x264_args,
    x264::{
        X264_PARAM_SIZE, X264Nal, X264Pics, x264_encoder_close, x264_encoder_encode, x264_open,
        x264_parse, x264_simd,
    },
};
#[cfg(feature = "x265")]
use crate::{
    encoder::x265_args,
    x265::{
        X265_PARAM_SIZE, X265Nal, X265Pic, x265_encoder_close, x265_encoder_encode,
        x265_encoder_headers, x265_open, x265_parse, x265_simd,
    },
};
#[cfg(feature = "vvenc")]
use crate::{
    encoder::{Argv, vvenc_args, vvenc_zone_args},
    vvenc::{
        VVENC_CFG_SIZE, VVENC_MAX_QP, VVENC_OK, VVENC_TQ_HDR, VvencAccessUnit, VvencYuvBuffer,
        VvencYuvPlane, vvenc_derive, vvenc_encode, vvenc_encoder_close, vvenc_open, vvenc_parse,
        vvenc_qp, vvenc_simd,
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

fn dot_ext(ext: &str) -> [u8; 4] {
    let mut tail = [b'.', 0, 0, 0];
    tail[1..].copy_from_slice(ext.as_bytes());
    tail
}

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
    buf: String,
    at: usize,
    tail: [u8; 4],
}

#[cfg(not(target_os = "linux"))]
impl OutPath {
    #[cold]
    #[inline(never)]
    fn new(work_dir: &Path, ext: &str) -> Self {
        let dir = work_dir.join("encode");
        let dir = dir.to_string_lossy();
        let mut buf = String::with_capacity(dir.len() + ext.len() + 16);
        buf.push_str(&dir);
        buf.push(MAIN_SEPARATOR);
        let at = buf.len();
        buf.push_str("00000.");
        buf.push_str(ext);
        Self {
            buf,
            at,
            tail: dot_ext(ext),
        }
    }

    #[inline]
    fn set(&mut self, idx: u16) -> &Path {
        let dig = idx_digits(idx);
        let skip = usize::from(idx < 10000);
        unsafe {
            let b = self.buf.as_mut_vec();
            let p = b.as_mut_ptr().add(self.at);
            p.cast::<[u8; 8]>()
                .write_unaligned((dig >> (skip * 8)).to_le_bytes());
            p.add(5 - skip).cast::<[u8; 4]>().write_unaligned(self.tail);
            b.set_len(self.at + 9 - skip);
        }
        Path::new(&self.buf)
    }
}

struct WorkerStats {
    completed: Arc<AtomicUsize>,
    completed_frames: Arc<AtomicUsize>,
    tot_sz: Arc<AtomicU64>,
    completions: Arc<Mutex<ResumeInf>>,
}

impl WorkerStats {
    fn new(cnt: usize, frames: usize, sz: u64, resume_data: ResumeInf) -> Self {
        Self {
            completed: Arc::new(AtomicUsize::new(cnt)),
            completed_frames: Arc::new(AtomicUsize::new(frames)),
            tot_sz: Arc::new(AtomicU64::new(sz)),
            completions: Arc::new(Mutex::new(resume_data)),
        }
    }

    fn add_completion(&self, completion: ChunkComp) {
        self.completed.fetch_add(1, Relaxed);
        self.completed_frames.fetch_add(completion.frames, Relaxed);
        self.tot_sz.fetch_add(completion.sz, Relaxed);
        let mut data = self.completions.lock();
        data.finish(completion);
        drop(data);
    }
}

fn load_resume_data(work_dir: &Path) -> ResumeInf {
    get_resume(work_dir).unwrap_or_else(|| ResumeInf::new(Vec::new(), work_dir))
}

struct Resumed {
    skip: BTreeSet<u16>,
    cnt: usize,
    frames: usize,
    sz: u64,
}

fn build_skip_set(resume_data: &ResumeInf) -> Resumed {
    let mut skip = BTreeSet::new();
    let (mut frames, mut sz) = (0usize, 0u64);
    for c in &resume_data.chnks_done {
        skip.insert(c.idx);
        frames += c.frames;
        sz += c.sz;
    }
    Resumed {
        cnt: skip.len(),
        skip,
        frames,
        sz,
    }
}

fn create_stats(cnt: usize, frames: usize, sz: u64, resume_data: ResumeInf) -> Arc<WorkerStats> {
    Arc::new(WorkerStats::new(cnt, frames, sz, resume_data))
}

struct EncTrack {
    worker_id: usize,
    track_frames: bool,
    crf_score: Option<(f32, Option<f32>)>,
}

struct Scratch {
    conv: Vec<u8>,
    #[cfg(feature = "x265")]
    pic: *mut X265Pic,
    #[cfg(feature = "x264")]
    pics: *mut X264Pics,
    #[cfg(any(feature = "vvenc", feature = "x264", feature = "x265"))]
    params: ParamBufs,
}

impl Scratch {
    #[cold]
    #[inline(never)]
    fn new(ctx: &EncWorkerCtx) -> Self {
        #[cfg_attr(not(any(feature = "x264", feature = "x265")), expect(unused_mut))]
        let mut conv = vec![0u8; ctx.pipe.conv_buf_sz];
        #[cfg(any(feature = "x264", feature = "x265"))]
        let e = &ctx.pipe.enc;
        Self {
            // raw; conv is empty; its ptr dangles
            #[cfg(feature = "x265")]
            pic: if matches!(ctx.encoder, Encoder::X265) {
                let mut p = X265Pic::boxed(e.y_stride, e.c_stride);
                if !conv.is_empty() {
                    p.point(conv.as_mut_ptr(), e.y_sz, e.cr_off);
                }
                Box::into_raw(p)
            } else {
                null_mut()
            },
            #[cfg(feature = "x264")]
            pics: if matches!(ctx.encoder, Encoder::X264) {
                let mut p = X264Pics::boxed(e.y_stride, e.c_stride);
                if !conv.is_empty() {
                    p.point(conv.as_mut_ptr(), e.y_sz, e.cr_off);
                }
                Box::into_raw(p)
            } else {
                null_mut()
            },
            conv,
            #[cfg(any(feature = "vvenc", feature = "x264", feature = "x265"))]
            params: ParamBufs::new(),
        }
    }
}

#[cfg(any(feature = "x264", feature = "x265"))]
impl Drop for Scratch {
    fn drop(&mut self) {
        #[cfg(feature = "x265")]
        if !self.pic.is_null() {
            drop(unsafe { Box::from_raw(self.pic) });
        }
        #[cfg(feature = "x264")]
        if !self.pics.is_null() {
            drop(unsafe { Box::from_raw(self.pics) });
        }
    }
}

type LibEncFn =
    fn(&mut Vec<u8>, &mut dyn Write, &EncConfig, &EncWorkerCtx, &mut Scratch, &EncTrack) -> u64;

type ChnkFn = fn(&mut WorkPkg, &EncWorkerCtx, &Path, &mut Scratch, &mut Vec<u8>, usize) -> u64;

type FillFn = fn(&mut Scratch, &[Arc<[u64]>], &[Arc<[u64]>]) -> usize;

#[cfg(feature = "vship")]
type ProbeFn = fn(&mut WorkPkg, f32, Tmpl, &EncWorkerCtx, &mut Scratch, usize, Option<&Path>);

#[cold]
const fn resolve_chnk_fn(zoned: bool, raw: bool) -> ChnkFn {
    match (zoned, raw) {
        (true, true) => enc_chnk_raw_zoned,
        (true, false) => enc_chnk_lib_zoned,
        (false, true) => enc_chnk_raw,
        (false, false) => enc_chnk_lib,
    }
}

// annexb parser reads past last au; probes carry pad
#[cfg(feature = "vship")]
#[cold]
const fn resolve_probe_fn(encoder: Encoder) -> ProbeFn {
    match encoder {
        #[cfg(any(feature = "x264", feature = "x265"))]
        X264 | X265 => enc_tq_probe_annexb,
        _ => enc_tq_probe_lib,
    }
}

struct EncWorkerCtx<'a> {
    pipe: &'a Pipeline,
    work_dir: &'a Path,
    prog: &'a Arc<ProgsTrack>,
    encoder: Encoder,
    lib_enc: LibEncFn,
    tmpl: *const u8,
    tmpls: &'a [Arc<[u64]>],
    bufs: &'a Bufs,
    #[cfg(feature = "vship")]
    probe_fn: ProbeFn,
}

#[cfg(feature = "vship")]
pub struct TqLog {
    line: String,
    file: Option<FsFile>,
}

#[cfg(feature = "vship")]
struct TQWorkerCtx<'a> {
    inf: &'a VidInf,
    pipe: &'a Pipeline,
    work_dir: &'a Path,
    agg: &'a Agg,
    prog: &'a Arc<ProgsTrack>,
    done_tx: &'a SeqRing,
    stats: &'a Arc<WorkerStats>,
    tq_logger: &'a Arc<Mutex<TqLog>>,
    tq_ctx: &'a TQCtx,
    bufs: &'a Bufs,
    use_alt_param: bool,
    worker_cnt: usize,
    threads: i32,
    ext: &'static str,
}

#[cold]
#[inline(never)]
fn resolve_svt_enc(strat: &DecStrat, is_nv12: bool, inf: &VidInf, pipe: &Pipeline) -> LibEncFn {
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
        && (pipe.half_w * pipe.half_h).is_multiple_of(SHIFT_CHUNK * 2)
}

const fn unpack_exact(pipe: &Pipeline) -> bool {
    pipe.final_w.is_multiple_of(PACK_CHUNK) && pipe.frame_sz.is_multiple_of(UNPACK_CHUNK)
}

#[cfg(feature = "avm")]
#[cold]
#[inline(never)]
fn resolve_avm_enc(strat: &DecStrat, is_nv12: bool, inf: &VidInf, pipe: &Pipeline) -> LibEncFn {
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
fn resolve_vvenc_enc(strat: &DecStrat, is_nv12: bool, inf: &VidInf, pipe: &Pipeline) -> LibEncFn {
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

#[cfg(feature = "x265")]
#[cold]
#[inline(never)]
fn resolve_x265_enc(strat: &DecStrat, is_nv12: bool, inf: &VidInf, pipe: &Pipeline) -> LibEncFn {
    if strat.is_raw() {
        enc_x265_direct
    } else if is_nv12 {
        if nv12_exact(pipe) {
            enc_x265_nv12
        } else {
            enc_x265_nv12_rem
        }
    } else if inf.is_10b {
        if unpack_exact(pipe) {
            enc_x265_unpack
        } else {
            enc_x265_unpack_rem
        }
    } else if pipe.frame_sz.is_multiple_of(SHIFT_CHUNK) {
        enc_x265_conv
    } else {
        enc_x265_conv_rem
    }
}

#[cfg(all(feature = "x265", feature = "vship"))]
#[cold]
#[inline(never)]
fn resolve_x265_crf_enc(inf: &VidInf, pipe: &Pipeline) -> LibEncFn {
    if inf.is_10b {
        if unpack_exact(pipe) {
            enc_x265_lib_unpack
        } else {
            enc_x265_lib_unpack_rem
        }
    } else if pipe.frame_sz.is_multiple_of(SHIFT_CHUNK) {
        enc_x265_lib
    } else {
        enc_x265_lib_rem
    }
}

#[cfg(feature = "x264")]
#[cold]
#[inline(never)]
fn resolve_x264_enc(strat: &DecStrat, is_nv12: bool, inf: &VidInf, pipe: &Pipeline) -> LibEncFn {
    if strat.is_raw() {
        enc_x264_direct
    } else if is_nv12 {
        if nv12_exact(pipe) {
            enc_x264_nv12
        } else {
            enc_x264_nv12_rem
        }
    } else if inf.is_10b {
        if unpack_exact(pipe) {
            enc_x264_unpack
        } else {
            enc_x264_unpack_rem
        }
    } else if pipe.frame_sz.is_multiple_of(SHIFT_CHUNK) {
        enc_x264_conv
    } else {
        enc_x264_conv_rem
    }
}

#[cfg(all(feature = "x264", feature = "vship"))]
#[cold]
#[inline(never)]
fn resolve_x264_crf_enc(inf: &VidInf, pipe: &Pipeline) -> LibEncFn {
    if inf.is_10b {
        if unpack_exact(pipe) {
            enc_x264_lib_unpack
        } else {
            enc_x264_lib_unpack_rem
        }
    } else if pipe.frame_sz.is_multiple_of(SHIFT_CHUNK) {
        enc_x264_lib
    } else {
        enc_x264_lib_rem
    }
}

#[cfg(feature = "vship")]
#[cold]
fn resolve_crf_enc(encoder: Encoder, inf: &VidInf, pipe: &Pipeline) -> LibEncFn {
    match encoder {
        #[cfg(feature = "vvenc")]
        Vvenc => resolve_vvenc_crf_enc(inf, pipe),
        #[cfg(feature = "x265")]
        X265 => resolve_x265_crf_enc(inf, pipe),
        #[cfg(feature = "x264")]
        X264 => resolve_x264_crf_enc(inf, pipe),
        _ => resolve_svt_crf_enc(inf, pipe),
    }
}

#[cold]
fn resolve_lib_enc(
    encoder: Encoder,
    strat: &DecStrat,
    is_nv12: bool,
    inf: &VidInf,
    pipe: &Pipeline,
) -> LibEncFn {
    match encoder {
        #[cfg(feature = "avm")]
        Avm => resolve_avm_enc(strat, is_nv12, inf, pipe),
        #[cfg(feature = "vvenc")]
        Vvenc => resolve_vvenc_enc(strat, is_nv12, inf, pipe),
        #[cfg(feature = "x265")]
        X265 => resolve_x265_enc(strat, is_nv12, inf, pipe),
        #[cfg(feature = "x264")]
        X264 => resolve_x264_enc(strat, is_nv12, inf, pipe),
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
    #[cfg(feature = "vvenc")]
    if args.encoder == Vvenc {
        vvenc_simd();
    }

    #[cfg(feature = "vship")]
    {
        if args.tq.is_some() {
            enc_tq(chnks, inf, args, path, work_dir, pipe_reader);
            return;
        }
    }

    let resume_data = load_resume_data(work_dir);

    let Resumed {
        skip,
        cnt,
        frames: done_frames,
        sz: done_sz,
    } = build_skip_set(&resume_data);
    let stats = create_stats(cnt, done_frames, done_sz, resume_data);
    let (prog, display_handle) = ProgsTrack::new(
        chnks,
        inf,
        args.worker,
        done_frames,
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
    let strat = if inf.is_10b && args.chnk_buff == args.worker {
        strat.to_raw()
    } else {
        strat
    };
    let pipe = Pipeline::new(inf, &strat);
    let lib_enc_fn = resolve_lib_enc(args.encoder, &strat, is_nv12, inf, &pipe);
    #[cfg(feature = "vship")]
    let probe_fn = resolve_probe_fn(args.encoder);

    let ring = Arc::new(SeqRing::new());
    let bufs = Arc::new(Bufs::new(args.chnk_buff, max_chnk_bytes(chnks, &pipe)));

    let build = resolve_build_tmpl(args.encoder);
    let mut chnks = chnks.to_vec();
    let zones = zone_tmpls(&mut chnks, tmpl_scale(args.encoder, (-1, -1)));

    let inf: &'static VidInf = Box::leak(Box::new(inf.clone()));
    let pipe: &'static Pipeline = Box::leak(Box::new(pipe));
    let path = leak_path(path);
    let work_dir = leak_path(work_dir);
    let params: &'static str = Box::leak(args.params.clone().into_boxed_str());

    let decoder = {
        let ring = Arc::clone(&ring);
        let bufs = Arc::clone(&bufs);
        spawn(move || {
            let rp = Arc::as_ptr(&ring);
            let send = move |p: *mut WorkPkg| unsafe { spmc_send(rp, p as u64) };
            let sk = bufs.sink(&send);
            if let Some(mut reader) = pipe_reader {
                dec_pipe(&chnks, &mut reader, inf, &skip, &strat, &sk);
            } else {
                dec_chnks(&chnks, path, inf, &skip, &strat, &sk);
            }
            unsafe { spmc_close(rp) };
        })
    };

    let tmpls = build_zoned(build, inf, params, pipe, &zones, (-1, -1));
    let chnk_fn = resolve_chnk_fn(!zones.is_empty(), !args.encoder.lib_params());
    let fill = resolve_fill(args.encoder);

    let mut workers = Vec::new();
    for worker_id in 0..args.worker {
        let rx_clone = Arc::clone(&ring);
        let stats_clone = Arc::clone(&stats);
        let prog_clone = Arc::clone(&prog);
        let bufs_clone = Arc::clone(&bufs);
        let encoder = args.encoder;
        let tmpls = tmpls.clone();

        let handle = spawn(move || {
            let tset: &[Arc<[u64]>] = &tmpls;
            let ctx = EncWorkerCtx {
                pipe,
                work_dir,
                prog: &prog_clone,
                encoder,
                lib_enc: lib_enc_fn,
                tmpl: unsafe { tset.get_unchecked(0) }.as_ptr().cast(),
                tmpls: tset,
                bufs: &bufs_clone,
                #[cfg(feature = "vship")]
                probe_fn,
            };
            run_enc_worker(&rx_clone, chnk_fn, fill, &ctx, &stats_clone, worker_id);
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
pub struct TQCtx {
    target: f32,
    tolerance: f32,
    qp_min: f32,
    qp_max: f32,
    bound_step: f32,
    grid: f32,
    use_butter: bool,
    use_cvvdp: bool,
    pub txt: &'static str,
}

#[cfg(feature = "vship")]
impl TQCtx {
    #[must_use]
    pub fn new(t: [f32; 2], q: [f32; 2], step: f32, txt: &'static str) -> Self {
        let target = f32::midpoint(t[0], t[1]);
        Self {
            target,
            tolerance: (t[1] - t[0]) / 2.0,
            qp_min: q[0],
            qp_max: q[1],
            bound_step: step,
            grid: 1.0 / step,
            use_butter: target < 8.0,
            use_cvvdp: target > 8.0 && target <= 10.0,
            txt,
        }
    }

    #[must_use]
    pub const fn is_cvvdp(&self) -> bool {
        self.use_cvvdp
    }

    #[inline(always)]
    fn converged(&self, score: f32) -> bool {
        (score - self.target).abs() <= self.tolerance
    }

    #[inline(always)]
    fn up_bounds(&self, state: &mut TQState, score: f32) -> bool {
        if self.use_butter {
            if score > self.target + self.tolerance {
                state.search_max = state.last_crf - self.bound_step;
            } else if score < self.target - self.tolerance {
                state.search_min = state.last_crf + self.bound_step;
            }
        } else if score < self.target - self.tolerance {
            state.search_max = state.last_crf - self.bound_step;
        } else if score > self.target + self.tolerance {
            state.search_min = state.last_crf + self.bound_step;
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
fn max_chnk_bytes(chnks: &[Chunk], pipe: &Pipeline) -> usize {
    chnks.iter().map(|c| c.end - c.start).max().unwrap_or(0) * pipe.frame_sz
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
    best: Probe,
) {
    unsafe { mpsc_send(ctx.done_tx, 1) };

    let comp = ChunkComp {
        idx: chnk_idx,
        frames: chnk_frames,
        sz: file_sz,
    };

    ctx.stats.add_completion(comp);

    let mut log = ctx.tq_logger.lock();
    let TqLog {
        ref mut line,
        ref mut file,
    } = *log;
    line.clear();
    _ = write!(
        line,
        "{{\"id\":{chnk_idx},\"r\":{},\"f\":{chnk_frames},\"p\":[",
        tq_state.round
    );
    let mut it = tq_state.probes.iter().zip(&tq_state.probe_szs);
    let (p, &(_, sz)) = unsafe { it.next().unwrap_unchecked() };
    _ = write!(line, "[{:.2},{:.4},{sz}]", p.crf, p.score);
    for (p, &(_, sz)) in it {
        _ = write!(line, ",[{:.2},{:.4},{sz}]", p.crf, p.score);
    }
    _ = writeln!(
        line,
        "],\"fc\":{:.2},\"fs\":{:.4},\"fz\":{file_sz}}}",
        best.crf, best.score
    );

    if let Some(f) = file.as_mut() {
        _ = f.write_all(line.as_bytes());
    }
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
fn output_bytes(dst: &Path, tq: &TQState, _: u16, _: f32, _: usize) -> u64 {
    _ = write(dst, &tq.best_probe);
    tq.best_probe.len() as u64
}

#[cfg(feature = "vship")]
const fn output_probe(_: &Path, _: &TQState, _: u16, _: f32, n: usize) -> u64 {
    n as u64
}

#[cfg(feature = "vship")]
type MetricLoopFn = fn(&SeqRing, &SeqRing, &TQWorkerCtx, usize, Option<Disp>);

#[cfg(feature = "vship")]
macro_rules! make_metric_loop {
    ($name:ident, $mk_dec:expr, $prep:expr, $retain:expr, $output:expr, $calc:expr) => {
        fn $name(
            rx: &SeqRing,
            work_tx: &SeqRing,
            ctx: &TQWorkerCtx,
            worker_id: usize,
            disp: Option<Disp>,
        ) {
            let (w, h) = (ctx.pipe.final_w as u32, ctx.pipe.final_h as u32);
            let vship = VshipProcessor::new(
                w,
                h,
                ctx.inf,
                ctx.tq_ctx.use_cvvdp,
                ctx.tq_ctx.use_butter,
                disp,
            )
            .unwrap_or_else(|e| fatal(e));
            let mut d = ($mk_dec)(ctx.threads, w, h);
            let mut scores: Vec<f32> = Vec::with_capacity(MAX_CHNK_FRAMES);
            let mut unpacked_buf =
                PinnedBuf::new(ctx.pipe.unpack_buf_sz).unwrap_or_else(|e| fatal(e));
            // 8 bit never unpacks & PinnedBuf::new(0) dangles
            let planes = if ctx.pipe.unpack_buf_sz == 0 {
                [null(); 3]
            } else {
                let b = unpacked_buf.as_ptr();
                unsafe { [b, b.add(ctx.pipe.met.y_sz), b.add(ctx.pipe.met.cr_off)] }
            };
            let mut bufs = MetricBufs {
                unpacked: &mut unpacked_buf,
                scores: &mut scores,
                planes,
            };
            let mut enc_path = OutPath::new(ctx.work_dir, ctx.ext);
            let metric_slot = ctx.worker_cnt + worker_id;

            loop {
                let m = unsafe { mpmc_recv(rx) };
                if m == 0 {
                    cold_path();
                    break;
                }
                let slot = m as *mut WorkPkg;
                let pkg = unsafe { &mut *slot };
                let tq_st = unsafe { pkg.tq_state.as_ref().unwrap_unchecked() };
                if tq_st.final_enc {
                    let best = tq_st.best;
                    let sz = ($output)(
                        enc_path.set(pkg.chnk.idx),
                        tq_st,
                        pkg.chnk.idx,
                        best.crf,
                        pkg.probe.len(),
                    );
                    complete_chnk(pkg.chnk.idx, pkg.frame_cnt, sz, ctx, tq_st, best);
                    ctx.bufs.give(slot);
                    continue;
                }

                let crf = tq_st.last_crf;
                let last_score = tq_st.probes.last().map(|probe| probe.score);

                let probe_sz = ($prep)(&mut d, &pkg, pkg.chnk.idx, crf);
                unsafe { pkg.tq_state.as_mut().unwrap_unchecked() }
                    .probe_szs
                    .push((crf, probe_sz));

                let mp = MetricProgs {
                    prog: ctx.prog,
                    slot: metric_slot,
                    crf,
                    last_score,
                };
                let score = ($calc)(&pkg, &mut d, ctx.pipe, &vship, ctx.agg, &mut bufs, &mp);

                ($retain)(pkg, score);

                let tq_state = unsafe { pkg.tq_state.as_mut().unwrap_unchecked() };

                let should_complete = ctx.tq_ctx.converged(score)
                    || tq_state
                        .probes
                        .iter()
                        .any(|p| (p.crf - crf) * (p.score - score) >= 0.0)
                    || ctx.tq_ctx.up_bounds(tq_state, score);

                tq_state.probes.push(Probe { crf, score });

                if should_complete {
                    let best = *ctx.tq_ctx.best_probe(&tq_state.probes);
                    if ctx.use_alt_param {
                        tq_state.final_enc = true;
                        tq_state.best = best;
                        unsafe { mpsc_send(work_tx, slot as u64) };
                    } else {
                        let sz = ($output)(
                            enc_path.set(pkg.chnk.idx),
                            tq_state,
                            pkg.chnk.idx,
                            best.crf,
                            pkg.probe.len(),
                        );
                        complete_chnk(pkg.chnk.idx, pkg.frame_cnt, sz, ctx, tq_state, best);
                        ctx.bufs.give(slot);
                    }
                } else {
                    unsafe { mpsc_send(work_tx, slot as u64) };
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
        make_metric_loop!($ss8, $mk_dec, $prep, $retain, $output, $c_ss8);
        make_metric_loop!($ss10, $mk_dec, $prep, $retain, $output, $c_ss10);
        make_metric_loop!($ssr, $mk_dec, $prep, $retain, $output, $c_ssr);
        make_metric_loop!($bu8, $mk_dec, $prep, $retain, $output, $c_bu8);
        make_metric_loop!($bu10, $mk_dec, $prep, $retain, $output, $c_bu10);
        make_metric_loop!($bur, $mk_dec, $prep, $retain, $output, $c_bur);
        make_metric_loop!($cv8, $mk_dec, $prep, $retain, $output, $c_cv8);
        make_metric_loop!($cv10, $mk_dec, $prep, $retain, $output, $c_cv10);
        make_metric_loop!($cvr, $mk_dec, $prep, $retain, $output, $c_cvr);
    };
}

#[cfg(feature = "vship")]
make_metric_group!(
    make_dav1d,
    prep_dav1d,
    retain_swap,
    output_bytes,
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
#[cfg(all(feature = "vship", feature = "x265"))]
make_metric_group!(
    make_hevc,
    prep_annexb,
    retain_swap,
    output_bytes,
    met_h_ss_8b,
    calc_ssimu2_8b_annexb,
    met_h_ss_10b,
    calc_ssimu2_10b_annexb,
    met_h_ss_rem,
    calc_ssimu2_rem_annexb,
    met_h_bu_8b,
    calc_butter_8b_annexb,
    met_h_bu_10b,
    calc_butter_10b_annexb,
    met_h_bu_rem,
    calc_butter_rem_annexb,
    met_h_cv_8b,
    calc_cvvdp_8b_annexb,
    met_h_cv_10b,
    calc_cvvdp_10b_annexb,
    met_h_cv_rem,
    calc_cvvdp_rem_annexb
);
#[cfg(all(feature = "vship", feature = "x265"))]
make_metric_group!(
    make_hevc,
    prep_annexb,
    retain_noop,
    output_probe,
    met_ha_ss_8b,
    calc_ssimu2_8b_annexb,
    met_ha_ss_10b,
    calc_ssimu2_10b_annexb,
    met_ha_ss_rem,
    calc_ssimu2_rem_annexb,
    met_ha_bu_8b,
    calc_butter_8b_annexb,
    met_ha_bu_10b,
    calc_butter_10b_annexb,
    met_ha_bu_rem,
    calc_butter_rem_annexb,
    met_ha_cv_8b,
    calc_cvvdp_8b_annexb,
    met_ha_cv_10b,
    calc_cvvdp_10b_annexb,
    met_ha_cv_rem,
    calc_cvvdp_rem_annexb
);
#[cfg(all(feature = "vship", feature = "x264"))]
make_metric_group!(
    make_avc,
    prep_annexb,
    retain_swap,
    output_bytes,
    met_a_ss_8b,
    calc_ssimu2_8b_annexb,
    met_a_ss_10b,
    calc_ssimu2_10b_annexb,
    met_a_ss_rem,
    calc_ssimu2_rem_annexb,
    met_a_bu_8b,
    calc_butter_8b_annexb,
    met_a_bu_10b,
    calc_butter_10b_annexb,
    met_a_bu_rem,
    calc_butter_rem_annexb,
    met_a_cv_8b,
    calc_cvvdp_8b_annexb,
    met_a_cv_10b,
    calc_cvvdp_10b_annexb,
    met_a_cv_rem,
    calc_cvvdp_rem_annexb
);
#[cfg(all(feature = "vship", feature = "x264"))]
make_metric_group!(
    make_avc,
    prep_annexb,
    retain_noop,
    output_probe,
    met_aa_ss_8b,
    calc_ssimu2_8b_annexb,
    met_aa_ss_10b,
    calc_ssimu2_10b_annexb,
    met_aa_ss_rem,
    calc_ssimu2_rem_annexb,
    met_aa_bu_8b,
    calc_butter_8b_annexb,
    met_aa_bu_10b,
    calc_butter_10b_annexb,
    met_aa_bu_rem,
    calc_butter_rem_annexb,
    met_aa_cv_8b,
    calc_cvvdp_8b_annexb,
    met_aa_cv_10b,
    calc_cvvdp_10b_annexb,
    met_aa_cv_rem,
    calc_cvvdp_rem_annexb
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

#[cfg(all(feature = "vship", feature = "x265"))]
#[cold]
fn hevc_loop(tq: &TQCtx, inf: &VidInf, pipe: &Pipeline) -> MetricLoopFn {
    if tq.use_butter {
        by_shape(inf, pipe, met_h_bu_8b, met_h_bu_10b, met_h_bu_rem)
    } else if tq.use_cvvdp {
        by_shape(inf, pipe, met_h_cv_8b, met_h_cv_10b, met_h_cv_rem)
    } else {
        by_shape(inf, pipe, met_h_ss_8b, met_h_ss_10b, met_h_ss_rem)
    }
}

#[cfg(all(feature = "vship", feature = "x265"))]
#[cold]
fn hevc_alt_loop(tq: &TQCtx, inf: &VidInf, pipe: &Pipeline) -> MetricLoopFn {
    if tq.use_butter {
        by_shape(inf, pipe, met_ha_bu_8b, met_ha_bu_10b, met_ha_bu_rem)
    } else if tq.use_cvvdp {
        by_shape(inf, pipe, met_ha_cv_8b, met_ha_cv_10b, met_ha_cv_rem)
    } else {
        by_shape(inf, pipe, met_ha_ss_8b, met_ha_ss_10b, met_ha_ss_rem)
    }
}

#[cfg(all(feature = "vship", feature = "x264"))]
#[cold]
fn avc_loop(tq: &TQCtx, inf: &VidInf, pipe: &Pipeline) -> MetricLoopFn {
    if tq.use_butter {
        by_shape(inf, pipe, met_a_bu_8b, met_a_bu_10b, met_a_bu_rem)
    } else if tq.use_cvvdp {
        by_shape(inf, pipe, met_a_cv_8b, met_a_cv_10b, met_a_cv_rem)
    } else {
        by_shape(inf, pipe, met_a_ss_8b, met_a_ss_10b, met_a_ss_rem)
    }
}

#[cfg(all(feature = "vship", feature = "x264"))]
#[cold]
fn avc_alt_loop(tq: &TQCtx, inf: &VidInf, pipe: &Pipeline) -> MetricLoopFn {
    if tq.use_butter {
        by_shape(inf, pipe, met_aa_bu_8b, met_aa_bu_10b, met_aa_bu_rem)
    } else if tq.use_cvvdp {
        by_shape(inf, pipe, met_aa_cv_8b, met_aa_cv_10b, met_aa_cv_rem)
    } else {
        by_shape(inf, pipe, met_aa_ss_8b, met_aa_ss_10b, met_aa_ss_rem)
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
        #[cfg(feature = "x265")]
        (X265, false) => hevc_loop(tq, inf, pipe),
        #[cfg(feature = "x265")]
        (X265, true) => hevc_alt_loop(tq, inf, pipe),
        #[cfg(feature = "x264")]
        (X264, false) => avc_loop(tq, inf, pipe),
        #[cfg(feature = "x264")]
        (X264, true) => avc_alt_loop(tq, inf, pipe),
        (_, false) => dav1d_loop(tq, inf, pipe),
        (_, true) => dav1d_alt_loop(tq, inf, pipe),
    }
}

#[cfg(feature = "vship")]
fn tq_coord(coord: &SeqRing, enc: &SeqRing, tot_chnks: usize) {
    let mut completed = 0;
    while completed < tot_chnks {
        let m = unsafe { mpsc_recv(coord) };
        if m == 1 {
            completed += 1;
        } else {
            unsafe { spmc_send(enc, m) };
        }
    }
    unsafe { spmc_close(enc) };
}

#[cfg(feature = "vship")]
#[inline]
fn tq_search_crf(tq: &mut TQState, ctx: &TQCtx) -> f32 {
    tq.round += 1;
    let d = if tq.round <= 2 {
        bisect(tq.search_min, tq.search_max)
    } else {
        interpolate_crf(&tq.probes, tq.target, tq.round, &mut tq.interp)
    };
    let c = ((d * ctx.grid).round() * ctx.bound_step).clamp(tq.search_min, tq.search_max);
    tq.last_crf = c;
    c
}

#[cfg(feature = "vship")]
struct TqEncParams<'a> {
    tmpls: &'a TqTmpls,
    fill: FillFn,
}

#[cfg(feature = "vship")]
type TqLoopFn = fn(&SeqRing, &SeqRing, &EncWorkerCtx, &TqEncParams, &TQCtx, usize);

#[cfg(feature = "vship")]
macro_rules! make_tq_loop {
    (
        $name:ident,
        $pkg:ident,
        $crf:ident,
        $fin:ident,
        $probe:ident,
        $poff:ident,
        $is_final:ident,
        $sel:expr
    ) => {
        fn $name(
            rx: &SeqRing,
            tx: &SeqRing,
            ctx: &EncWorkerCtx,
            enc: &TqEncParams,
            tq_ctx: &TQCtx,
            worker_id: usize,
        ) {
            let TqEncParams { tmpls, fill } = *enc;
            let mut sc = Scratch::new(ctx);
            let ext = ctx.encoder.extension();
            let mut enc_path = OutPath::new(ctx.work_dir, ext);
            let alt = tmpls.alt.as_deref().unwrap_or(&[]);
            let $fin = tmpls.base.as_slice();
            // probes after finals; no alt = both draw one copy
            let $probe = if alt.is_empty() { $fin } else { alt };
            let $poff = (fill)(&mut sc, $fin, alt);
            loop {
                let m = unsafe { spmc_recv(rx) };
                if m == 0 {
                    cold_path();
                    break;
                }
                let $pkg = unsafe { &mut *(m as *mut WorkPkg) };
                if !$pkg.armed {
                    cold_path();
                    unsafe { $pkg.tq_state.as_mut().unwrap_unchecked() }.arm(
                        tq_ctx.qp_min,
                        tq_ctx.qp_max,
                        tq_ctx.target,
                    );
                    $pkg.armed = true;
                }
                let tq = unsafe { $pkg.tq_state.as_mut().unwrap_unchecked() };
                let $is_final = tq.final_enc;
                let $crf = if $is_final {
                    tq.best.crf
                } else {
                    tq_search_crf(tq, tq_ctx)
                };
                let dst = $is_final.then(|| enc_path.set($pkg.chnk.idx));
                (ctx.probe_fn)($pkg, $crf, $sel, ctx, &mut sc, worker_id, dst);
                unsafe { mpmc_send(tx, m) };
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
    _probe,
    poff,
    is_final,
    Tmpl {
        off: if is_final { 0 } else { poff }
    }
);
#[cfg(feature = "vship")]
make_tq_loop!(
    tq_enc_raw,
    pkg,
    crf,
    fin,
    probe,
    _poff,
    is_final,
    Tmpl {
        ptr: unsafe { if is_final { fin } else { probe }.get_unchecked(0) }
            .as_ptr()
            .cast()
    }
);
#[cfg(feature = "vship")]
make_tq_loop!(
    tq_enc_loop_zoned,
    pkg,
    crf,
    fin,
    _probe,
    poff,
    is_final,
    Tmpl {
        off: if is_final { 0 } else { poff } + pkg.chnk.tmpl as usize
    }
);
#[cfg(feature = "vship")]
make_tq_loop!(
    tq_enc_raw_zoned,
    pkg,
    crf,
    fin,
    probe,
    _poff,
    is_final,
    Tmpl {
        ptr: unsafe { if is_final { fin } else { probe }.get_unchecked(pkg.chnk.tmpl as usize) }
            .as_ptr()
            .cast()
    }
);

#[cfg(feature = "vship")]
#[cold]
const fn resolve_tq_loop(zoned: bool, raw: bool) -> TqLoopFn {
    match (zoned, raw) {
        (true, true) => tq_enc_raw_zoned,
        (true, false) => tq_enc_loop_zoned,
        (false, true) => tq_enc_raw,
        (false, false) => tq_enc_loop,
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
    path: &'static Path,
    inf: &'static VidInf,
    skip: BTreeSet<u16>,
    strat: &DecStrat,
    bufs: &Arc<Bufs>,
    pipe_reader: Option<PipeReader>,
) -> TQDecodeResult {
    let tot = chnks.iter().filter(|c| !skip.contains(&c.idx)).count();
    let strat = *strat;
    let enc = Arc::new(SeqRing::new());
    let coord = Arc::new(SeqRing::new());

    let chnks = chnks.to_vec();
    let enc2 = Arc::clone(&enc);
    let coord2 = Arc::clone(&coord);
    let coord_dec = Arc::clone(&coord);
    let bufs_dec = Arc::clone(bufs);
    let handle = spawn(move || {
        let dec = pspawn(move || {
            let rp = Arc::as_ptr(&coord_dec);
            let send = move |p: *mut WorkPkg| unsafe { mpsc_send(rp, p as u64) };
            let sk = bufs_dec.sink(&send);
            if let Some(mut r) = pipe_reader {
                dec_pipe(&chnks, &mut r, inf, &skip, &strat, &sk);
            } else {
                dec_chnks(&chnks, path, inf, &skip, &strat, &sk);
            }
        });
        tq_coord(&coord2, &enc2, tot);
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
    let Resumed {
        skip,
        cnt,
        frames: done_frames,
        sz: done_sz,
    } = build_skip_set(&resume_data);
    let tq_ctx = unsafe { args.tq.unwrap_unchecked() };
    let strat = unsafe { args.dec_strat.unwrap_unchecked() };
    let pipe = Pipeline::new(inf, &strat);
    let bufs = Arc::new(Bufs::new(args.chnk_buff, max_chnk_bytes(chnks, &pipe)));
    let inf: &'static VidInf = Box::leak(Box::new(inf.clone()));
    let pipe: &'static Pipeline = Box::leak(Box::new(pipe));
    let path = leak_path(path);
    let work_dir = leak_path(work_dir);
    let agg: &'static Agg = Box::leak(Box::new(Agg::new(
        &args.metric_mode,
        tq_ctx.use_cvvdp,
        tq_ctx.use_butter,
    )));
    let build = resolve_build_tmpl(args.encoder);
    let mut chnks = chnks.to_vec();
    let qp = (tq_ctx.qp_min as i32, tq_ctx.qp_max as i32);
    let zones = zone_tmpls(&mut chnks, tmpl_scale(args.encoder, qp));
    let chnks = &chnks;

    let dec = spawn_tq_dec(chnks, path, inf, skip, &strat, &bufs, pipe_reader);
    let met = Arc::new(SeqRing::new());

    let tq_logger = Arc::new(Mutex::new(TqLog {
        line: String::new(),
        file: OpenOptions::new()
            .create(true)
            .append(true)
            .open(work_dir.join("chunks.json"))
            .ok(),
    }));
    let stats = create_stats(cnt, done_frames, done_sz, resume_data);
    let (prog, display_handle) = ProgsTrack::new(
        chnks,
        inf,
        args.worker + args.metric_worker,
        done_frames,
        Arc::clone(&stats.completed),
        Arc::clone(&stats.completed_frames),
        Arc::clone(&stats.tot_sz),
    );
    let prog = Arc::new(prog);
    let sc = TQSpawnCtx {
        inf,
        pipe,
        work_dir,
        agg,
        args,
        prog: &prog,
        stats,
        tq_logger: &tq_logger,
        tq_ctx,
        bufs: &bufs,
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
    inf: &'static VidInf,
    pipe: &'static Pipeline,
    work_dir: &'static Path,
    agg: &'static Agg,
    args: &'a Args,
    prog: &'a Arc<ProgsTrack>,
    stats: Arc<WorkerStats>,
    tq_logger: &'a Arc<Mutex<TqLog>>,
    tq_ctx: TQCtx,
    bufs: &'a Arc<Bufs>,
    zones: &'a [&'static str],
    build: BuildTmpl,
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
        let (inf, pipe, wd) = (sc.inf, sc.pipe, sc.work_dir);
        let (agg, st) = (sc.agg, Arc::clone(&sc.stats));
        let (tq_logger, prog_clone) = (Arc::clone(sc.tq_logger), Arc::clone(sc.prog));
        let (tq_ctx, use_alt_param, worker_cnt) = (sc.tq_ctx, sc.use_alt_param, sc.worker_cnt);
        let bufs = Arc::clone(sc.bufs);
        metric_workers.push(pspawn(move || {
            let ctx = TQWorkerCtx {
                inf,
                pipe,
                work_dir: wd,
                agg,
                prog: &prog_clone,
                done_tx: &coord,
                stats: &st,
                tq_logger: &tq_logger,
                tq_ctx: &tq_ctx,
                bufs: &bufs,
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
    base: Vec<Arc<[u64]>>,
    alt: Option<Vec<Arc<[u64]>>>,
}

#[cfg(feature = "vship")]
fn spawn_tq_encoders(
    enc: &Arc<SeqRing>,
    met: &Arc<SeqRing>,
    sc: &TQSpawnCtx,
) -> Vec<JoinHandle<()>> {
    let qp = (sc.tq_ctx.qp_min as i32, sc.tq_ctx.qp_max as i32);
    let build = sc.build;
    let tmpls = TqTmpls {
        base: build_zoned(build, sc.inf, &sc.args.params, sc.pipe, sc.zones, qp),
        alt: sc
            .args
            .alt_param
            .as_deref()
            .map(|ap| build_zoned(build, sc.inf, ap, sc.pipe, sc.zones, qp)),
    };
    let mut workers = Vec::new();
    let fill = resolve_fill_crf(sc.encoder);
    let probe_fn = resolve_probe_fn(sc.encoder);
    let crf_enc = resolve_crf_enc(sc.encoder, sc.inf, sc.pipe);
    let tq_loop = resolve_tq_loop(!sc.zones.is_empty(), !sc.encoder.lib_params());
    for worker_id in 0..sc.worker_cnt {
        let (rx, tx) = (Arc::clone(enc), Arc::clone(met));
        let (pipe, wd) = (sc.pipe, sc.work_dir);
        let prog_clone = Arc::clone(sc.prog);
        let (tq_ctx, encoder) = (sc.tq_ctx, sc.encoder);
        let bufs = Arc::clone(sc.bufs);
        let tmpls = tmpls.clone();
        workers.push(spawn(move || {
            let ctx = EncWorkerCtx {
                pipe,
                work_dir: wd,
                prog: &prog_clone,
                encoder,
                lib_enc: crf_enc,
                tmpl: null(),
                tmpls: &[],
                bufs: &bufs,
                probe_fn,
            };
            tq_loop(
                &rx,
                &tx,
                &ctx,
                &TqEncParams {
                    tmpls: &tmpls,
                    fill,
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
    tmpl: Tmpl,
    ctx: &EncWorkerCtx,
    sc: &mut Scratch,
    worker_id: usize,
    dst: Option<&Path>,
) {
    let last_score = unsafe { pkg.tq_state.as_ref().unwrap_unchecked() }
        .probes
        .last()
        .map(|probe| probe.score);
    let cfg = EncConfig {
        tmpl,
        crf: Some(crf),
        chnk_idx: pkg.chnk.idx,
        #[cfg(feature = "avm")]
        width: pkg.width,
        #[cfg(feature = "avm")]
        height: pkg.height,
        frames: pkg.frame_cnt,
    };
    pkg.probe.clear();
    (ctx.lib_enc)(
        &mut pkg.yuv,
        &mut pkg.probe,
        &cfg,
        ctx,
        sc,
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

#[cfg(all(feature = "vship", any(feature = "x264", feature = "x265")))]
fn enc_tq_probe_annexb(
    pkg: &mut WorkPkg,
    crf: f32,
    tmpl: Tmpl,
    ctx: &EncWorkerCtx,
    sc: &mut Scratch,
    worker_id: usize,
    dst: Option<&Path>,
) {
    enc_tq_probe_lib(pkg, crf, tmpl, ctx, sc, worker_id, dst);
    pad_probe(&mut pkg.probe);
}

#[cfg(any(feature = "vvenc", feature = "x264", feature = "x265"))]
#[cold]
#[inline(never)]
fn fill_fixed(sc: &mut Scratch, a: &[Arc<[u64]>], b: &[Arc<[u64]>]) -> usize {
    let t = unsafe { a.first().unwrap_unchecked() };
    b.len()
        * sc.params
            .fill(a.len() + b.len(), t.len(), a.iter().chain(b).map(|x| &**x))
}

// templ is header; one config per crf
#[cfg(all(feature = "vvenc", feature = "vship"))]
#[cold]
#[inline(never)]
fn fill_qp(sc: &mut Scratch, a: &[Arc<[u64]>], b: &[Arc<[u64]>]) -> usize {
    const W: usize = VVENC_TQ_HDR / size_of::<u64>();
    let t = unsafe { a.first().unwrap_unchecked() };
    sc.params.set_qlo(unsafe { *t.get_unchecked(0) } as u32);
    b.len()
        * sc.params.fill(
            a.len() + b.len(),
            t.len() - W,
            a.iter().chain(b).map(|x| unsafe { x.get_unchecked(W..) }),
        )
}

const fn fill_none(_: &mut Scratch, _: &[Arc<[u64]>], _: &[Arc<[u64]>]) -> usize {
    0
}

#[cold]
#[cfg_attr(not(feature = "vvenc"), expect(unused_variables))]
const fn tmpl_scale(encoder: Encoder, qp: (i32, i32)) -> u32 {
    match encoder {
        SvtAv1 | Avm => 1,
        #[cfg(feature = "vvenc")]
        Vvenc => (vvenc_cfg_cnt(qp) * VVENC_CFG_SIZE) as u32,
        #[cfg(not(feature = "vvenc"))]
        Vvenc => assume_unreachable(),
        #[cfg(feature = "x265")]
        X265 => X265_PARAM_SIZE as u32,
        #[cfg(not(feature = "x265"))]
        X265 => assume_unreachable(),
        #[cfg(feature = "x264")]
        X264 => X264_PARAM_SIZE as u32,
        #[cfg(not(feature = "x264"))]
        X264 => assume_unreachable(),
    }
}

#[cold]
const fn resolve_fill(encoder: Encoder) -> FillFn {
    match encoder {
        #[cfg(feature = "vvenc")]
        Vvenc => fill_fixed,
        #[cfg(feature = "x264")]
        X264 => fill_fixed,
        #[cfg(feature = "x265")]
        X265 => fill_fixed,
        _ => fill_none,
    }
}

#[cfg(feature = "vship")]
#[cold]
const fn resolve_fill_crf(encoder: Encoder) -> FillFn {
    match encoder {
        #[cfg(all(feature = "vvenc", feature = "vship"))]
        Vvenc => fill_qp,
        #[cfg(feature = "x264")]
        X264 => fill_fixed,
        #[cfg(feature = "x265")]
        X265 => fill_fixed,
        _ => fill_none,
    }
}

fn run_enc_worker(
    rx: &SeqRing,
    chnk_fn: ChnkFn,
    fill: FillFn,
    ctx: &EncWorkerCtx,
    stats: &Arc<WorkerStats>,
    worker_id: usize,
) {
    let mut sc = Scratch::new(ctx);
    (fill)(&mut sc, ctx.tmpls, &[]);
    let mut sink = Vec::with_capacity(SINK);
    let mut enc_path = OutPath::new(ctx.work_dir, ctx.encoder.extension());

    loop {
        let m = unsafe { spmc_recv(rx) };
        if m == 0 {
            cold_path();
            break;
        }
        let slot = m as *mut WorkPkg;
        let pkg = unsafe { &mut *slot };
        let out = enc_path.set(pkg.chnk.idx);
        let sz = (chnk_fn)(pkg, ctx, out, &mut sc, &mut sink, worker_id);

        stats.add_completion(ChunkComp {
            idx: pkg.chnk.idx,
            frames: pkg.frame_cnt,
            sz,
        });

        ctx.bufs.give(slot);
    }
}

macro_rules! make_chnk_lib {
    ($name:ident, $ctx:ident, $pkg:ident, $tmpl:expr) => {
        fn $name(
            $pkg: &mut WorkPkg,
            $ctx: &EncWorkerCtx,
            out: &Path,
            sc: &mut Scratch,
            buf: &mut Vec<u8>,
            worker_id: usize,
        ) -> u64 {
            let cfg = EncConfig {
                tmpl: $tmpl,
                #[cfg(feature = "vship")]
                crf: None,
                chnk_idx: $pkg.chnk.idx,
                #[cfg(feature = "avm")]
                width: $pkg.width,
                #[cfg(feature = "avm")]
                height: $pkg.height,
                frames: $pkg.frame_cnt,
            };
            let mut sink = BufWriter::new(File::create(out).unwrap_or_else(|e| fatal(e)), buf);
            ($ctx.lib_enc)(
                &mut $pkg.yuv,
                &mut sink,
                &cfg,
                $ctx,
                sc,
                &EncTrack {
                    worker_id,
                    track_frames: true,
                    crf_score: None,
                },
            )
        }
    };
}

make_chnk_lib!(enc_chnk_lib, ctx, pkg, Tmpl { off: 0 });
make_chnk_lib!(enc_chnk_raw, ctx, pkg, Tmpl { ptr: ctx.tmpl });
make_chnk_lib!(
    enc_chnk_lib_zoned,
    ctx,
    pkg,
    Tmpl {
        off: pkg.chnk.tmpl as usize
    }
);
make_chnk_lib!(
    enc_chnk_raw_zoned,
    ctx,
    pkg,
    Tmpl {
        ptr: unsafe { ctx.tmpls.get_unchecked(pkg.chnk.tmpl as usize) }
            .as_ptr()
            .cast()
    }
);

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

type BuildTmpl = fn(&VidInf, &str, &[&'static str], u32, u32, (i32, i32)) -> Vec<Arc<[u64]>>;

#[cold]
#[inline(never)]
fn tmpl_alloc(words: usize) -> (Arc<[MaybeUninit<u64>]>, *mut u8) {
    let mut a = Arc::<[u64]>::new_uninit_slice(words);
    let p = unsafe { Arc::get_mut_unchecked(&mut a) }
        .as_mut_ptr()
        .cast::<u8>();
    (a, p)
}

const SVT_WORDS: usize = SVT_CONF_SIZE / size_of::<u64>();

#[cold]
#[inline(never)]
fn build_zoned(
    build: BuildTmpl,
    inf: &VidInf,
    params: &str,
    pipe: &Pipeline,
    zones: &[&'static str],
    qp: (i32, i32),
) -> Vec<Arc<[u64]>> {
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
fn resolve_build_tmpl(encoder: Encoder) -> BuildTmpl {
    match encoder {
        SvtAv1 => build_svt_templates,
        #[cfg(feature = "avm")]
        Avm => build_avm_templates,
        #[cfg(not(feature = "avm"))]
        Avm => assume_unreachable(),
        #[cfg(feature = "vvenc")]
        Vvenc => build_vvenc_templates,
        #[cfg(not(feature = "vvenc"))]
        Vvenc => assume_unreachable(),
        #[cfg(feature = "x265")]
        X265 => build_x265_templates,
        #[cfg(not(feature = "x265"))]
        X265 => assume_unreachable(),
        #[cfg(feature = "x264")]
        X264 => build_x264_templates,
        #[cfg(not(feature = "x264"))]
        X264 => assume_unreachable(),
    }
}

#[cold]
#[inline(never)]
fn build_svt_templates(
    inf: &VidInf,
    params: &str,
    zones: &[&'static str],
    width: u32,
    height: u32,
    _: (i32, i32),
) -> Vec<Arc<[u64]>> {
    let (a, p) = tmpl_alloc(SVT_WORDS);
    unsafe { copy_nonoverlapping(svt_defaults().as_ptr(), p, SVT_CONF_SIZE) };
    set_svt_base(p.cast(), inf, params, width, height);

    let mut v = Vec::with_capacity(zones.len() + 1);
    v.push(unsafe { a.assume_init() });
    for z in zones {
        let (za, zp) = tmpl_alloc(SVT_WORDS);
        unsafe { copy_nonoverlapping(p, zp, SVT_CONF_SIZE) };
        parse_svt_params(zp.cast(), z);
        v.push(unsafe { za.assume_init() });
    }
    v
}

fn init_svt(cfg: &EncConfig) -> *mut EbComponentType {
    let mut conf = MaybeUninit::<EbSvtAv1EncConfiguration>::uninit();
    let handle = svt_handle(null_mut());
    unsafe {
        let t = cfg.tmpl.ptr;
        copy_nonoverlapping(t, conf.as_mut_ptr().cast::<u8>(), SVT_CONF_SIZE);
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
        let t = cfg.tmpl.ptr;
        copy_nonoverlapping(t, conf.as_mut_ptr().cast::<u8>(), SVT_CONF_SIZE);
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
            sc: &mut Scratch,
            track: &EncTrack,
        ) -> (*mut EbComponentType, Tracker) {
            let &EncTrack {
                worker_id,
                track_frames,
                crf_score,
            } = track;
            let handle = $init(cfg);

            let mut io_fmt = EbSvtIOFormat {
                luma: sc.conv.as_mut_ptr(),
                cb: unsafe { sc.conv.as_mut_ptr().add(ctx.pipe.enc.y_sz) },
                cr: unsafe { sc.conv.as_mut_ptr().add(ctx.pipe.enc.cr_off) },
                y_stride: ctx.pipe.final_w as u32,
                cb_stride: ctx.pipe.half_w as u32,
                cr_stride: ctx.pipe.half_w as u32,
            };
            let io_ptr = &raw mut io_fmt;

            let mut in_hdr = unsafe { zeroed::<EbBufferHeaderType>() };
            in_hdr.size = size_of::<EbBufferHeaderType>() as u32;
            in_hdr.p_buffer = io_ptr.cast::<u8>();
            in_hdr.n_filled_len = ctx.pipe.enc.frame_sz as u32;
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
            let mut src = yuv.as_ptr();
            for i in 0..cfg.frames {
                ($conv)(src, sc.conv.as_mut_ptr(), ctx.pipe);
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
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b(s, d, p.conv_iters) }
);
make_send_svt!(
    send_svt_conv_rem,
    init_svt,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b_rem(s, d, p.frame_sz) }
);
make_send_svt!(
    send_svt_unpack,
    init_svt,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_unpack_10b(s, d, p.unpack_iters) }
);
make_send_svt!(
    send_svt_unpack_rem,
    init_svt,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe {
        xav_unpack_10b_rem(s, d, p.final_w, p.final_h);
    }
);
make_send_svt!(
    send_svt_nv12,
    init_svt,
    |s: *const u8, d: *mut u8, p: &Pipeline| nv12_10b(s, d, p)
);
make_send_svt!(
    send_svt_nv12_rem,
    init_svt,
    |s: *const u8, d: *mut u8, p: &Pipeline| nv12_10b_rem(s, d, p)
);

#[cfg(feature = "vship")]
make_send_svt!(
    send_svt_crf,
    init_svt_crf,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b(s, d, p.conv_iters) }
);
#[cfg(feature = "vship")]
make_send_svt!(
    send_svt_crf_rem,
    init_svt_crf,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b_rem(s, d, p.frame_sz) }
);
#[cfg(feature = "vship")]
make_send_svt!(
    send_svt_crf_unpack,
    init_svt_crf,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_unpack_10b(s, d, p.unpack_iters) }
);
#[cfg(feature = "vship")]
make_send_svt!(
    send_svt_crf_unpack_rem,
    init_svt_crf,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe {
        xav_unpack_10b_rem(s, d, p.final_w, p.final_h);
    }
);
macro_rules! make_enc_svt {
    ($name:ident, $send:ident) => {
        fn $name(
            yuv: &mut Vec<u8>,
            out: &mut dyn Write,
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            sc: &mut Scratch,
            track: &EncTrack,
        ) -> u64 {
            let (handle, tracker) = $send(out, yuv, cfg, ctx, sc, track);
            yuv.clear();
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
            sc: &mut Scratch,
            track: &EncTrack,
        ) -> u64 {
            let (handle, tracker) = $send(out, yuv.as_slice(), cfg, ctx, sc, track);
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
    _sc: &mut Scratch,
    track: &EncTrack,
) -> u64 {
    let &EncTrack {
        worker_id,
        track_frames,
        crf_score,
    } = track;
    let handle = init_svt(cfg);

    let mut io_fmt = EbSvtIOFormat {
        luma: null_mut(),
        cb: null_mut(),
        cr: null_mut(),
        y_stride: ctx.pipe.final_w as u32,
        cb_stride: ctx.pipe.half_w as u32,
        cr_stride: ctx.pipe.half_w as u32,
    };
    let io_ptr = &raw mut io_fmt;

    let mut in_hdr = unsafe { zeroed::<EbBufferHeaderType>() };
    in_hdr.size = size_of::<EbBufferHeaderType>() as u32;
    in_hdr.p_buffer = io_ptr.cast::<u8>();
    in_hdr.n_filled_len = ctx.pipe.enc.frame_sz as u32;
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

    let (y_sz, cr_off) = (ctx.pipe.enc.y_sz, ctx.pipe.enc.cr_off);
    let frame_sz = ctx.pipe.frame_sz;
    let mut src = yuv.as_ptr().cast_mut();
    for i in 0..cfg.frames {
        unsafe {
            (*io_ptr).luma = src;
            (*io_ptr).cb = src.add(y_sz);
            (*io_ptr).cr = src.add(cr_off);
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
    yuv.clear();

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
    zones: &[&'static str],
    width: u32,
    height: u32,
    _: (i32, i32),
) -> Vec<Arc<[u64]>> {
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
fn assemble_avm_tmpl(
    conf: &AvmCodecEncCfg,
    ctrls: &[i32; AVM_CTRL_CNT],
    opts: &[u8],
) -> Arc<[u64]> {
    let (hdr, extra) = avm_snapshot(conf, ctrls, opts);
    let bytes = AVM_TMPL_HDR + extra.len();
    let words = bytes.div_ceil(size_of::<u64>());
    let (a, p) = tmpl_alloc(words);
    unsafe {
        copy_nonoverlapping((&raw const *conf).cast::<u8>(), p, AVM_CFG_SIZE);
        copy_nonoverlapping(
            (&raw const hdr).cast::<u8>(),
            p.add(AVM_CFG_SIZE),
            size_of::<AvmTmpl>(),
        );
        copy_nonoverlapping(extra.as_ptr(), p.add(AVM_TMPL_HDR), extra.len());
        write_bytes(p.add(bytes), 0, words * size_of::<u64>() - bytes);
        a.assume_init()
    }
}

#[cfg(feature = "avm")]
fn init_avm(cfg: &EncConfig, ec: *mut AvmCodecCtx) {
    let t = unsafe { cfg.tmpl.ptr };
    let mut conf = unsafe { t.cast::<AvmCodecEncCfg>().read_unaligned() };
    conf.g_limit = cfg.frames as u32;
    conf.g_lag_in_frames = conf.g_limit.min(AVM_MAX_LAG);
    let hdr = unsafe { t.add(AVM_CFG_SIZE).cast::<AvmTmpl>().read_unaligned() };

    avm_init(&conf, ec);
    avm_blit(ec, hdr, unsafe { t.add(AVM_TMPL_HDR) });
}

#[cfg(feature = "avm")]
const fn avm_img(cfg: &EncConfig, pipe: &Pipeline) -> AvmImage {
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
    let (y, c) = (pipe.enc.y_stride as i32, pipe.enc.c_stride as i32);
    img.stride = [y, c, c];
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
            sc: &mut Scratch,
            track: &EncTrack,
        ) -> (Tracker, usize, u64) {
            let &EncTrack {
                worker_id,
                track_frames,
                crf_score,
            } = track;
            init_avm(cfg, ec);

            let mut img = avm_img(cfg, ctx.pipe);
            img.planes = [
                sc.conv.as_mut_ptr(),
                unsafe { sc.conv.as_mut_ptr().add(ctx.pipe.enc.y_sz) },
                unsafe { sc.conv.as_mut_ptr().add(ctx.pipe.enc.cr_off) },
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
            let frame_sz = ctx.pipe.frame_sz;
            let mut src = yuv.as_ptr();

            for i in 0..cfg.frames {
                ($conv)(src, sc.conv.as_mut_ptr(), ctx.pipe);
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
make_send_avm!(
    send_avm_conv,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b(s, d, p.conv_iters) }
);
#[cfg(feature = "avm")]
make_send_avm!(
    send_avm_conv_rem,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b_rem(s, d, p.frame_sz) }
);
#[cfg(feature = "avm")]
make_send_avm!(
    send_avm_unpack,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_unpack_10b(s, d, p.unpack_iters) }
);
#[cfg(feature = "avm")]
make_send_avm!(
    send_avm_unpack_rem,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe {
        xav_unpack_10b_rem(s, d, p.final_w, p.final_h);
    }
);
#[cfg(feature = "avm")]
make_send_avm!(send_avm_nv12, |s: *const u8, d: *mut u8, p: &Pipeline| {
    nv12_10b(s, d, p);
});
#[cfg(feature = "avm")]
make_send_avm!(
    send_avm_nv12_rem,
    |s: *const u8, d: *mut u8, p: &Pipeline| nv12_10b_rem(s, d, p)
);

#[cfg(feature = "avm")]
macro_rules! make_enc_avm {
    ($name:ident, $send:ident) => {
        fn $name(
            yuv: &mut Vec<u8>,
            out: &mut dyn Write,
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            sc: &mut Scratch,
            track: &EncTrack,
        ) -> u64 {
            let mut ec = MaybeUninit::<AvmCodecCtx>::uninit();
            let ecp = ec.as_mut_ptr();
            let (tracker, mut done, sz) = $send(ecp, out, yuv, cfg, ctx, sc, track);
            yuv.clear();
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
    _sc: &mut Scratch,
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

    let mut img = avm_img(cfg, ctx.pipe);
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
    let (y_sz, cr_off) = (ctx.pipe.enc.y_sz, ctx.pipe.enc.cr_off);
    let frame_sz = ctx.pipe.frame_sz;
    let mut src = yuv.as_ptr().cast_mut();

    for i in 0..cfg.frames {
        unsafe {
            (*img_ptr).planes = [src, src.add(y_sz), src.add(cr_off)];
            src = src.add(frame_sz);
        }

        let ret = unsafe { avm_codec_encode(ecp, img_ptr, i as i64, 1, 0) };
        if ret != AVM_CODEC_OK {
            cold_path();
            fatal(format_args!("avm_codec_encode failed at frame {i}: {ret}"));
        }

        sz += drain_avm_packets(ecp, out, &tracker, &mut done);
    }
    yuv.clear();

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
const fn vvenc_cfg_cnt(qp: (i32, i32)) -> usize {
    if qp.0 < 0 {
        return 1;
    }
    let hi = if qp.1 < VVENC_MAX_QP {
        qp.1 + 1
    } else {
        VVENC_MAX_QP
    };
    (hi - qp.0 + 1) as usize
}

#[cfg(feature = "vvenc")]
#[cold]
#[inline(never)]
fn build_vvenc_templates(
    inf: &VidInf,
    params: &str,
    zones: &[&'static str],
    width: u32,
    height: u32,
    qp: (i32, i32),
) -> Vec<Arc<[u64]>> {
    let lo = qp.0;
    let n = vvenc_cfg_cnt(qp);
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
fn vvenc_tmpl(args: &Argv, zone: &Argv, lo: i32, n: usize, hdr: usize, sz: usize) -> Arc<[u64]> {
    let (a, base) = tmpl_alloc(sz / size_of::<u64>());
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
        a.assume_init()
    }
}

#[cfg(feature = "vvenc")]
fn init_vvenc(cfg: &EncConfig, sc: &Scratch) -> *mut c_void {
    vvenc_open(sc.params.get(unsafe { cfg.tmpl.off }), cfg.frames)
}

#[cfg(all(feature = "vvenc", feature = "vship"))]
fn init_vvenc_crf(cfg: &EncConfig, sc: &Scratch) -> *mut c_void {
    let q = unsafe { cfg.crf.unwrap_unchecked() } as u32;
    let off = (q - sc.params.qlo()) as usize * VVENC_CFG_SIZE;
    vvenc_open(unsafe { sc.params.get(cfg.tmpl.off).add(off) }, cfg.frames)
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
const fn vvenc_yuv(pipe: &Pipeline) -> VvencYuvBuffer {
    let (w, h) = (pipe.final_w as i32, pipe.final_h as i32);
    let (hw, hh) = (pipe.half_w as i32, pipe.half_h as i32);
    VvencYuvBuffer {
        planes: [vvenc_plane(w, h), vvenc_plane(hw, hh), vvenc_plane(hw, hh)],
        sequence_number: 0,
        cts: 0,
        cts_valid: false,
    }
}

// worst-case au at 4:2:0: luma plane plus headers
#[cfg(feature = "vvenc")]
const fn vvenc_au(pipe: &Pipeline) -> VvencAccessUnit {
    let mut au = unsafe { zeroed::<VvencAccessUnit>() };
    au.payload_size = (pipe.enc.y_sz + 1024) as i32;
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
            sc: &mut Scratch,
            track: &EncTrack,
        ) -> (*mut c_void, Tracker, usize, u64, usize) {
            let &EncTrack {
                worker_id,
                track_frames,
                crf_score,
            } = track;
            let enc = $init(cfg, sc);

            let mut yb = vvenc_yuv(ctx.pipe);
            yb.planes[0].ptr = sc.conv.as_mut_ptr().cast();
            yb.planes[1].ptr = unsafe { sc.conv.as_mut_ptr().add(ctx.pipe.enc.y_sz).cast() };
            yb.planes[2].ptr = unsafe { sc.conv.as_mut_ptr().add(ctx.pipe.enc.cr_off).cast() };

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
            let mut src = yuv.as_ptr();
            // nothing vvenc does to the au modifies payload_size; never reloads
            let cap = au.payload_size as usize;
            let mut pend = 0;

            for i in 0..cfg.frames {
                ($conv)(src, sc.conv.as_mut_ptr(), ctx.pipe);
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
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b(s, d, p.conv_iters) }
);
#[cfg(feature = "vvenc")]
make_send_vvenc!(
    send_vvenc_conv_rem,
    init_vvenc,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b_rem(s, d, p.frame_sz) }
);
#[cfg(feature = "vvenc")]
make_send_vvenc!(
    send_vvenc_unpack,
    init_vvenc,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_unpack_10b(s, d, p.unpack_iters) }
);
#[cfg(feature = "vvenc")]
make_send_vvenc!(
    send_vvenc_unpack_rem,
    init_vvenc,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe {
        xav_unpack_10b_rem(s, d, p.final_w, p.final_h);
    }
);
#[cfg(feature = "vvenc")]
make_send_vvenc!(
    send_vvenc_nv12,
    init_vvenc,
    |s: *const u8, d: *mut u8, p: &Pipeline| nv12_10b(s, d, p)
);
#[cfg(feature = "vvenc")]
make_send_vvenc!(
    send_vvenc_nv12_rem,
    init_vvenc,
    |s: *const u8, d: *mut u8, p: &Pipeline| nv12_10b_rem(s, d, p)
);

#[cfg(all(feature = "vvenc", feature = "vship"))]
make_send_vvenc!(
    send_vvenc_crf,
    init_vvenc_crf,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b(s, d, p.conv_iters) }
);
#[cfg(all(feature = "vvenc", feature = "vship"))]
make_send_vvenc!(
    send_vvenc_crf_rem,
    init_vvenc_crf,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b_rem(s, d, p.frame_sz) }
);
#[cfg(all(feature = "vvenc", feature = "vship"))]
make_send_vvenc!(
    send_vvenc_crf_unpack,
    init_vvenc_crf,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_unpack_10b(s, d, p.unpack_iters) }
);
#[cfg(all(feature = "vvenc", feature = "vship"))]
make_send_vvenc!(
    send_vvenc_crf_unpack_rem,
    init_vvenc_crf,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe {
        xav_unpack_10b_rem(s, d, p.final_w, p.final_h);
    }
);

#[cfg(feature = "vvenc")]
macro_rules! make_enc_vvenc {
    ($name:ident, $send:ident) => {
        fn $name(
            yuv: &mut Vec<u8>,
            out: &mut dyn Write,
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            sc: &mut Scratch,
            track: &EncTrack,
        ) -> u64 {
            let mut au = vvenc_au(ctx.pipe);
            let (enc, tracker, mut done, sz, pend) = $send(&mut au, out, yuv, cfg, ctx, sc, track);
            yuv.clear();
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
            sc: &mut Scratch,
            track: &EncTrack,
        ) -> u64 {
            let mut au = vvenc_au(ctx.pipe);
            let (enc, tracker, mut done, sz, pend) =
                $send(&mut au, out, yuv.as_slice(), cfg, ctx, sc, track);
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
    sc: &mut Scratch,
    track: &EncTrack,
) -> u64 {
    let &EncTrack {
        worker_id,
        track_frames,
        crf_score,
    } = track;
    let enc = init_vvenc(cfg, sc);

    let mut au = vvenc_au(ctx.pipe);
    let mut yb = vvenc_yuv(ctx.pipe);

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
    let (y_sz, cr_off) = (ctx.pipe.enc.y_sz, ctx.pipe.enc.cr_off);
    let frame_sz = ctx.pipe.frame_sz;
    let mut src = yuv.as_ptr().cast_mut();
    // no payload_size change; never reloads
    let cap = au.payload_size as usize;
    let mut pend = 0;

    for i in 0..cfg.frames {
        unsafe {
            yb.planes[0].ptr = src.cast();
            yb.planes[1].ptr = src.add(y_sz).cast();
            yb.planes[2].ptr = src.add(cr_off).cast();
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

    yuv.clear();

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

#[cfg(any(feature = "x264", feature = "x265"))]
#[cold]
#[inline(never)]
fn h26x_tmpl<F>(args: &H26xArgv, zone: &H26xArgv, sz: usize, parse: F) -> Arc<[u64]>
where
    F: Fn(*mut u8, &[u8], &[u8], &[u8], &[u8]),
{
    let pick = |z: &'static [u8], b: &'static [u8]| if z.is_empty() { b } else { z };

    let (a, base) = tmpl_alloc(sz / size_of::<u64>());
    parse(
        base,
        pick(zone.preset, args.preset),
        pick(zone.tune, args.tune),
        args.args,
        zone.args,
    );
    unsafe { a.assume_init() }
}

#[cfg(feature = "x265")]
#[cold]
#[inline(never)]
fn build_x265_templates(
    inf: &VidInf,
    params: &str,
    zones: &[&'static str],
    width: u32,
    height: u32,
    _: (i32, i32),
) -> Vec<Arc<[u64]>> {
    let a = x265_args(inf, params, width, height);
    let tmpl = |z: &H26xArgv| h26x_tmpl(&a, z, X265_PARAM_SIZE, x265_parse);

    let mut v = Vec::with_capacity(zones.len() + 1);
    v.push(tmpl(&H26xArgv::EMPTY));
    for z in zones {
        v.push(tmpl(&h26x_zone_args(z, false)));
    }
    x265_simd(unsafe { v.get_unchecked(0) });
    v
}

#[cfg(feature = "x265")]
fn init_x265(cfg: &EncConfig, sc: &Scratch) -> *mut c_void {
    x265_open(sc.params.get(unsafe { cfg.tmpl.off }), cfg.frames)
}

#[cfg(all(feature = "x265", feature = "vship"))]
fn init_x265_crf(cfg: &EncConfig, sc: &Scratch) -> *mut c_void {
    let d = sc.params.get(unsafe { cfg.tmpl.off });
    x265_crf(d, unsafe { cfg.crf.unwrap_unchecked() });
    x265_open(d, cfg.frames)
}

#[cfg(feature = "x264")]
#[cold]
#[inline(never)]
fn build_x264_templates(
    inf: &VidInf,
    params: &str,
    zones: &[&'static str],
    width: u32,
    height: u32,
    _: (i32, i32),
) -> Vec<Arc<[u64]>> {
    let a = x264_args(inf, params);
    let res = [width, height];
    let tmpl = |z: &H26xArgv| {
        h26x_tmpl(&a, z, X264_PARAM_SIZE, |d, p, t, ar, zo| {
            x264_parse(d, p, t, ar, zo, res);
        })
    };

    let mut v = Vec::with_capacity(zones.len() + 1);
    v.push(tmpl(&H26xArgv::EMPTY));
    for z in zones {
        v.push(tmpl(&h26x_zone_args(z, true)));
    }
    x264_simd(unsafe { v.get_unchecked(0) });
    v
}

#[cfg(feature = "x264")]
fn init_x264(cfg: &EncConfig, sc: &Scratch) -> *mut c_void {
    x264_open(sc.params.get(unsafe { cfg.tmpl.off }), cfg.frames)
}

#[cfg(all(feature = "x264", feature = "vship"))]
fn init_x264_crf(cfg: &EncConfig, sc: &Scratch) -> *mut c_void {
    let d = sc.params.get(unsafe { cfg.tmpl.off });
    x264_crf(d, unsafe { cfg.crf.unwrap_unchecked() });
    x264_open(d, cfg.frames)
}

#[cfg(feature = "x265")]
#[inline]
fn emit_nals(nal: *const X265Nal, n: u32, out: &mut dyn Write) -> u64 {
    let first = unsafe { &*nal };
    let last = unsafe { &*nal.add(n as usize - 1) };
    let sz = unsafe {
        last.payload
            .add(last.size_bytes as usize)
            .offset_from_unsigned(first.payload)
    };
    _ = out.write_all(unsafe { from_raw_parts(first.payload, sz) });
    sz as u64
}

#[cfg(feature = "x265")]
#[inline]
fn hdrs_x265(enc: *mut c_void, out: &mut dyn Write) -> u64 {
    let mut nal = MaybeUninit::<*mut X265Nal>::uninit();
    let mut nnal = MaybeUninit::<u32>::uninit();
    let hdr = unsafe { x265_encoder_headers(enc, nal.as_mut_ptr(), nnal.as_mut_ptr()) };
    if hdr < 0 {
        cold_path();
        fatal("x265_encoder_headers failed");
    }
    _ = out.write_all(unsafe { from_raw_parts((*nal.assume_init()).payload, hdr as usize) });
    hdr as u64
}

// x265 returns frame count, no size
#[cfg(feature = "x265")]
#[inline]
fn step_x265(enc: *mut c_void, pic: &mut X265Pic, pts: i64, out: &mut dyn Write) -> u64 {
    let mut nal = MaybeUninit::<*mut X265Nal>::uninit();
    let mut nnal = MaybeUninit::<u32>::uninit();
    pic.head.pts = pts;
    let ret = unsafe {
        x265_encoder_encode(
            enc,
            nal.as_mut_ptr(),
            nnal.as_mut_ptr(),
            &raw const *pic,
            null_mut(),
        )
    };
    if ret > 0 {
        return emit_nals(
            unsafe { nal.assume_init() },
            unsafe { nnal.assume_init() },
            out,
        );
    }
    if ret < 0 {
        cold_path();
        fatal(format_args!("x265_encoder_encode failed at frame {pts}"));
    }
    0
}

#[cfg(feature = "x265")]
fn flush_x265(
    enc: *mut c_void,
    _: &mut Scratch,
    out: &mut dyn Write,
    tracker: &Tracker,
    done: &mut usize,
) -> u64 {
    let mut nal = MaybeUninit::<*mut X265Nal>::uninit();
    let mut nnal = MaybeUninit::<u32>::uninit();
    let mut sz = 0;

    loop {
        let ret = unsafe {
            x265_encoder_encode(enc, nal.as_mut_ptr(), nnal.as_mut_ptr(), null(), null_mut())
        };
        if ret <= 0 {
            break;
        }
        sz += emit_nals(
            unsafe { nal.assume_init() },
            unsafe { nnal.assume_init() },
            out,
        );
        *done += 1;
        tracker.set(*done);
    }

    unsafe { x265_encoder_close(enc) };

    sz
}

// x264 repeats headers before one idr; nothing to pull
#[cfg(feature = "x264")]
#[inline]
const fn hdrs_x264(_: *mut c_void, _: &mut dyn Write) -> u64 {
    0
}

#[cfg(feature = "x264")]
#[inline]
fn step_x264(enc: *mut c_void, pics: &mut X264Pics, pts: i64, out: &mut dyn Write) -> u64 {
    let mut nal = MaybeUninit::<*mut X264Nal>::uninit();
    let mut nnal = MaybeUninit::<c_int>::uninit();
    pics.inp.head.pts = pts;
    let ret = unsafe {
        x264_encoder_encode(
            enc,
            nal.as_mut_ptr(),
            nnal.as_mut_ptr(),
            &raw mut pics.inp,
            &raw mut pics.out,
        )
    };
    if ret > 0 {
        let nal = unsafe { nal.assume_init() };
        _ = out.write_all(unsafe { from_raw_parts((*nal).payload, ret as usize) });
        return ret as u64;
    }
    if ret < 0 {
        cold_path();
        fatal(format_args!("x264_encoder_encode failed at frame {pts}"));
    }
    0
}

#[cfg(feature = "x264")]
fn flush_x264(
    enc: *mut c_void,
    sc: &mut Scratch,
    out: &mut dyn Write,
    tracker: &Tracker,
    done: &mut usize,
) -> u64 {
    let mut nal = MaybeUninit::<*mut X264Nal>::uninit();
    let mut nnal = MaybeUninit::<c_int>::uninit();
    let mut sz = 0;
    let pic_out = unsafe { &raw mut (*sc.pics).out };

    // single thread; null feed returns 0 only when encoder empty
    loop {
        let ret = unsafe {
            x264_encoder_encode(
                enc,
                nal.as_mut_ptr(),
                nnal.as_mut_ptr(),
                null_mut(),
                pic_out,
            )
        };
        if ret <= 0 {
            break;
        }
        _ = out.write_all(unsafe { from_raw_parts((*nal.assume_init()).payload, ret as usize) });
        sz += ret as u64;
        *done += 1;
        tracker.set(*done);
    }

    unsafe { x264_encoder_close(enc) };

    sz
}

#[cfg(any(feature = "x264", feature = "x265"))]
macro_rules! make_send_h26x {
    ($name:ident, $pic:ident, $init:ident, $hdrs:ident, $step:ident, $conv:expr) => {
        fn $name(
            out: &mut dyn Write,
            yuv: &[u8],
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            sc: &mut Scratch,
            track: &EncTrack,
        ) -> (*mut c_void, Tracker, usize, u64) {
            let &EncTrack {
                worker_id,
                track_frames,
                crf_score,
            } = track;
            let enc = $init(cfg, sc);

            let pic = unsafe { &mut *sc.$pic };

            let tracker = Tracker::new(
                ctx.prog,
                worker_id,
                cfg.chnk_idx,
                cfg.frames,
                track_frames,
                crf_score,
            );

            let mut done = 0;
            let mut sz = $hdrs(enc, out);
            let frame_sz = ctx.pipe.frame_sz;
            let mut src = yuv.as_ptr();

            for i in 0..cfg.frames {
                ($conv)(src, sc.conv.as_mut_ptr(), ctx.pipe);
                src = unsafe { src.add(frame_sz) };

                let n = $step(enc, pic, i as i64, out);
                if n != 0 {
                    sz += n;
                    done += 1;
                    tracker.set(done);
                }
            }

            (enc, tracker, done, sz)
        }
    };
}

// raw inp already encoder layout
#[cfg(any(feature = "x264", feature = "x265"))]
macro_rules! make_send_h26x_direct {
    ($name:ident, $pic:ident, $init:ident, $hdrs:ident, $step:ident) => {
        fn $name(
            out: &mut dyn Write,
            yuv: &[u8],
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            sc: &mut Scratch,
            track: &EncTrack,
        ) -> (*mut c_void, Tracker, usize, u64) {
            let &EncTrack {
                worker_id,
                track_frames,
                crf_score,
            } = track;
            let enc = $init(cfg, sc);

            let pic = unsafe { &mut *sc.$pic };

            let tracker = Tracker::new(
                ctx.prog,
                worker_id,
                cfg.chnk_idx,
                cfg.frames,
                track_frames,
                crf_score,
            );

            let mut done = 0;
            let mut sz = $hdrs(enc, out);
            let (y_sz, cr_off) = (ctx.pipe.enc.y_sz, ctx.pipe.enc.cr_off);
            let frame_sz = ctx.pipe.frame_sz;
            let mut src = yuv.as_ptr().cast_mut();

            for i in 0..cfg.frames {
                pic.point(src, y_sz, cr_off);
                src = unsafe { src.add(frame_sz) };

                let n = $step(enc, pic, i as i64, out);
                if n != 0 {
                    sz += n;
                    done += 1;
                    tracker.set(done);
                }
            }

            (enc, tracker, done, sz)
        }
    };
}

#[cfg(any(feature = "x264", feature = "x265"))]
macro_rules! make_enc_h26x {
    ($name:ident, $send:ident, $flush:ident) => {
        fn $name(
            yuv: &mut Vec<u8>,
            out: &mut dyn Write,
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            sc: &mut Scratch,
            track: &EncTrack,
        ) -> u64 {
            let (enc, tracker, mut done, sz) = $send(out, yuv, cfg, ctx, sc, track);
            yuv.clear();
            let sz = sz + $flush(enc, sc, out, &tracker, &mut done);
            tracker.finish();
            sz
        }
    };
}

#[cfg(all(feature = "vship", any(feature = "x264", feature = "x265")))]
macro_rules! make_enc_h26x_tq {
    ($name:ident, $send:ident, $flush:ident) => {
        fn $name(
            yuv: &mut Vec<u8>,
            out: &mut dyn Write,
            cfg: &EncConfig,
            ctx: &EncWorkerCtx,
            sc: &mut Scratch,
            track: &EncTrack,
        ) -> u64 {
            let (enc, tracker, mut done, sz) = $send(out, yuv.as_slice(), cfg, ctx, sc, track);
            let sz = sz + $flush(enc, sc, out, &tracker, &mut done);
            tracker.finish();
            sz
        }
    };
}

#[cfg(feature = "x265")]
make_send_h26x!(
    send_x265_conv,
    pic,
    init_x265,
    hdrs_x265,
    step_x265,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b(s, d, p.conv_iters) }
);
#[cfg(feature = "x265")]
make_send_h26x!(
    send_x265_conv_rem,
    pic,
    init_x265,
    hdrs_x265,
    step_x265,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b_rem(s, d, p.frame_sz) }
);
#[cfg(feature = "x265")]
make_send_h26x!(
    send_x265_unpack,
    pic,
    init_x265,
    hdrs_x265,
    step_x265,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_unpack_10b(s, d, p.unpack_iters) }
);
#[cfg(feature = "x265")]
make_send_h26x!(
    send_x265_unpack_rem,
    pic,
    init_x265,
    hdrs_x265,
    step_x265,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe {
        xav_unpack_10b_rem(s, d, p.final_w, p.final_h);
    }
);
#[cfg(feature = "x265")]
make_send_h26x!(
    send_x265_nv12,
    pic,
    init_x265,
    hdrs_x265,
    step_x265,
    |s: *const u8, d: *mut u8, p: &Pipeline| nv12_10b(s, d, p)
);
#[cfg(feature = "x265")]
make_send_h26x!(
    send_x265_nv12_rem,
    pic,
    init_x265,
    hdrs_x265,
    step_x265,
    |s: *const u8, d: *mut u8, p: &Pipeline| nv12_10b_rem(s, d, p)
);
#[cfg(feature = "x265")]
make_send_h26x_direct!(send_x265_direct, pic, init_x265, hdrs_x265, step_x265);
#[cfg(all(feature = "x265", feature = "vship"))]
make_send_h26x!(
    send_x265_crf,
    pic,
    init_x265_crf,
    hdrs_x265,
    step_x265,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b(s, d, p.conv_iters) }
);
#[cfg(all(feature = "x265", feature = "vship"))]
make_send_h26x!(
    send_x265_crf_rem,
    pic,
    init_x265_crf,
    hdrs_x265,
    step_x265,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b_rem(s, d, p.frame_sz) }
);
#[cfg(all(feature = "x265", feature = "vship"))]
make_send_h26x!(
    send_x265_crf_unpack,
    pic,
    init_x265_crf,
    hdrs_x265,
    step_x265,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_unpack_10b(s, d, p.unpack_iters) }
);
#[cfg(all(feature = "x265", feature = "vship"))]
make_send_h26x!(
    send_x265_crf_unpack_rem,
    pic,
    init_x265_crf,
    hdrs_x265,
    step_x265,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe {
        xav_unpack_10b_rem(s, d, p.final_w, p.final_h);
    }
);

#[cfg(feature = "x265")]
make_enc_h26x!(enc_x265_conv, send_x265_conv, flush_x265);
#[cfg(feature = "x265")]
make_enc_h26x!(enc_x265_conv_rem, send_x265_conv_rem, flush_x265);
#[cfg(feature = "x265")]
make_enc_h26x!(enc_x265_unpack, send_x265_unpack, flush_x265);
#[cfg(feature = "x265")]
make_enc_h26x!(enc_x265_unpack_rem, send_x265_unpack_rem, flush_x265);
#[cfg(feature = "x265")]
make_enc_h26x!(enc_x265_nv12, send_x265_nv12, flush_x265);
#[cfg(feature = "x265")]
make_enc_h26x!(enc_x265_nv12_rem, send_x265_nv12_rem, flush_x265);
#[cfg(feature = "x265")]
make_enc_h26x!(enc_x265_direct, send_x265_direct, flush_x265);

#[cfg(all(feature = "x265", feature = "vship"))]
make_enc_h26x_tq!(enc_x265_lib, send_x265_crf, flush_x265);
#[cfg(all(feature = "x265", feature = "vship"))]
make_enc_h26x_tq!(enc_x265_lib_rem, send_x265_crf_rem, flush_x265);
#[cfg(all(feature = "x265", feature = "vship"))]
make_enc_h26x_tq!(enc_x265_lib_unpack, send_x265_crf_unpack, flush_x265);
#[cfg(all(feature = "x265", feature = "vship"))]
make_enc_h26x_tq!(
    enc_x265_lib_unpack_rem,
    send_x265_crf_unpack_rem,
    flush_x265
);

#[cfg(feature = "x264")]
make_send_h26x!(
    send_x264_conv,
    pics,
    init_x264,
    hdrs_x264,
    step_x264,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b(s, d, p.conv_iters) }
);
#[cfg(feature = "x264")]
make_send_h26x!(
    send_x264_conv_rem,
    pics,
    init_x264,
    hdrs_x264,
    step_x264,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b_rem(s, d, p.frame_sz) }
);
#[cfg(feature = "x264")]
make_send_h26x!(
    send_x264_unpack,
    pics,
    init_x264,
    hdrs_x264,
    step_x264,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_unpack_10b(s, d, p.unpack_iters) }
);
#[cfg(feature = "x264")]
make_send_h26x!(
    send_x264_unpack_rem,
    pics,
    init_x264,
    hdrs_x264,
    step_x264,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe {
        xav_unpack_10b_rem(s, d, p.final_w, p.final_h);
    }
);
#[cfg(feature = "x264")]
make_send_h26x!(
    send_x264_nv12,
    pics,
    init_x264,
    hdrs_x264,
    step_x264,
    |s: *const u8, d: *mut u8, p: &Pipeline| nv12_10b(s, d, p)
);
#[cfg(feature = "x264")]
make_send_h26x!(
    send_x264_nv12_rem,
    pics,
    init_x264,
    hdrs_x264,
    step_x264,
    |s: *const u8, d: *mut u8, p: &Pipeline| nv12_10b_rem(s, d, p)
);
#[cfg(feature = "x264")]
make_send_h26x_direct!(send_x264_direct, pics, init_x264, hdrs_x264, step_x264);
#[cfg(all(feature = "x264", feature = "vship"))]
make_send_h26x!(
    send_x264_crf,
    pics,
    init_x264_crf,
    hdrs_x264,
    step_x264,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b(s, d, p.conv_iters) }
);
#[cfg(all(feature = "x264", feature = "vship"))]
make_send_h26x!(
    send_x264_crf_rem,
    pics,
    init_x264_crf,
    hdrs_x264,
    step_x264,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_conv_10b_rem(s, d, p.frame_sz) }
);
#[cfg(all(feature = "x264", feature = "vship"))]
make_send_h26x!(
    send_x264_crf_unpack,
    pics,
    init_x264_crf,
    hdrs_x264,
    step_x264,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe { xav_unpack_10b(s, d, p.unpack_iters) }
);
#[cfg(all(feature = "x264", feature = "vship"))]
make_send_h26x!(
    send_x264_crf_unpack_rem,
    pics,
    init_x264_crf,
    hdrs_x264,
    step_x264,
    |s: *const u8, d: *mut u8, p: &Pipeline| unsafe {
        xav_unpack_10b_rem(s, d, p.final_w, p.final_h);
    }
);

#[cfg(feature = "x264")]
make_enc_h26x!(enc_x264_conv, send_x264_conv, flush_x264);
#[cfg(feature = "x264")]
make_enc_h26x!(enc_x264_conv_rem, send_x264_conv_rem, flush_x264);
#[cfg(feature = "x264")]
make_enc_h26x!(enc_x264_unpack, send_x264_unpack, flush_x264);
#[cfg(feature = "x264")]
make_enc_h26x!(enc_x264_unpack_rem, send_x264_unpack_rem, flush_x264);
#[cfg(feature = "x264")]
make_enc_h26x!(enc_x264_nv12, send_x264_nv12, flush_x264);
#[cfg(feature = "x264")]
make_enc_h26x!(enc_x264_nv12_rem, send_x264_nv12_rem, flush_x264);
#[cfg(feature = "x264")]
make_enc_h26x!(enc_x264_direct, send_x264_direct, flush_x264);

#[cfg(all(feature = "x264", feature = "vship"))]
make_enc_h26x_tq!(enc_x264_lib, send_x264_crf, flush_x264);
#[cfg(all(feature = "x264", feature = "vship"))]
make_enc_h26x_tq!(enc_x264_lib_rem, send_x264_crf_rem, flush_x264);
#[cfg(all(feature = "x264", feature = "vship"))]
make_enc_h26x_tq!(enc_x264_lib_unpack, send_x264_crf_unpack, flush_x264);
#[cfg(all(feature = "x264", feature = "vship"))]
make_enc_h26x_tq!(
    enc_x264_lib_unpack_rem,
    send_x264_crf_unpack_rem,
    flush_x264
);

#[cfg(test)]
pub mod test_access {
    use super::*;

    pub fn run_chunk(
        inf: &VidInf,
        pipe: &Pipeline,
        strat: DecStrat,
        yuv: &mut Vec<u8>,
        frames: usize,
        params: &str,
        out: &mut dyn Write,
    ) -> Vec<u8> {
        let tmpls = build_svt_templates(
            inf,
            params,
            &[],
            pipe.final_w as u32,
            pipe.final_h as u32,
            (-1, -1),
        );
        let chnks = [Chunk {
            idx: 0,
            tmpl: 0,
            start: 0,
            end: frames,
            params: None,
        }];
        let (prog, disp) = ProgsTrack::new(
            &chnks,
            inf,
            1,
            0,
            Arc::new(AtomicUsize::new(0)),
            Arc::new(AtomicUsize::new(0)),
            Arc::new(AtomicU64::new(0)),
        );
        let prog = Arc::new(prog);
        let bufs = Bufs::new(1, frames * pipe.frame_sz);
        let ctx = EncWorkerCtx {
            pipe,
            work_dir: Path::new("."),
            prog: &prog,
            encoder: SvtAv1,
            lib_enc: resolve_lib_enc(
                SvtAv1,
                &strat,
                matches!(
                    strat,
                    DecStrat::HwNv12To10
                        | DecStrat::HwNv12To10Stride
                        | DecStrat::HwNv12CropTo10 { .. }
                ),
                inf,
                pipe,
            ),
            tmpl: tmpls[0].as_ptr().cast(),
            tmpls: &tmpls,
            bufs: &bufs,
            #[cfg(feature = "vship")]
            probe_fn: resolve_probe_fn(SvtAv1),
        };
        let mut sc = Scratch::new(&ctx);
        let cfg = EncConfig {
            tmpl: Tmpl {
                ptr: tmpls[0].as_ptr().cast(),
            },
            #[cfg(feature = "vship")]
            crf: None,
            chnk_idx: 0,
            #[cfg(feature = "avm")]
            width: pipe.final_w as u32,
            #[cfg(feature = "avm")]
            height: pipe.final_h as u32,
            frames,
        };
        (ctx.lib_enc)(
            yuv,
            out,
            &cfg,
            &ctx,
            &mut sc,
            &EncTrack {
                worker_id: 0,
                track_frames: false,
                crf_score: None,
            },
        );
        drop(prog);
        disp.join();
        core::mem::take(&mut sc.conv)
    }
}
