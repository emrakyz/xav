#[cfg(target_os = "linux")]
use alloc::vec::Vec;
#[cfg(any(feature = "x264", feature = "x265"))]
use core::{
    ffi::{CStr, c_int},
    ptr::write_bytes,
};

#[cfg(any(feature = "x264", feature = "x265"))]
use crate::annexb::{AnnexbDec, PAD};
#[cfg(feature = "x264")]
use crate::ffms::AV_CODEC_ID_H264;
#[cfg(feature = "x265")]
use crate::ffms::AV_CODEC_ID_HEVC;
#[cfg(all(target_os = "linux", not(test)))]
use crate::fmath::{FloatExt as _, Powf as _};
#[cfg(feature = "vvenc")]
use crate::vvdec::VvdecDec;
use crate::{
    dav1d::Dav1dDec,
    error::fatal,
    interp::{fc_spline, lerp, pchip},
    pack::{xav_unpack_10b, xav_unpack_10b_rem},
    pipeline::{MetricProgs, Pipeline},
    progs::Tracker,
    vship::VshipProcessor,
    worker::WorkPkg,
};

pub struct ProbeDec {
    dav1d: Option<Dav1dDec>,
    #[cfg(feature = "vvenc")]
    vvdec: Option<VvdecDec>,
    #[cfg(any(feature = "x264", feature = "x265"))]
    annexb: Option<AnnexbDec>,
}

pub fn make_dav1d(threads: i32, w: u32, h: u32) -> ProbeDec {
    ProbeDec {
        dav1d: Some(Dav1dDec::new(threads, w, h).unwrap_or_else(|e| fatal(e))),
        #[cfg(feature = "vvenc")]
        vvdec: None,
        #[cfg(any(feature = "x264", feature = "x265"))]
        annexb: None,
    }
}

#[cfg(feature = "vvenc")]
pub fn make_vvdec(threads: i32, _: u32, _: u32) -> ProbeDec {
    ProbeDec {
        dav1d: None,
        vvdec: Some(VvdecDec::new(threads).unwrap_or_else(|e| fatal(e))),
        #[cfg(any(feature = "x264", feature = "x265"))]
        annexb: None,
    }
}

#[cfg(any(feature = "x264", feature = "x265"))]
fn make_annexb(threads: i32, id: c_int, name: &'static CStr) -> ProbeDec {
    ProbeDec {
        dav1d: None,
        #[cfg(feature = "vvenc")]
        vvdec: None,
        annexb: Some(AnnexbDec::new(threads, id, name).unwrap_or_else(|e| fatal(e))),
    }
}

#[cfg(feature = "x265")]
pub fn make_hevc(threads: i32, _: u32, _: u32) -> ProbeDec {
    make_annexb(threads, AV_CODEC_ID_HEVC, c"hevc")
}

#[cfg(feature = "x264")]
pub fn make_avc(threads: i32, _: u32, _: u32) -> ProbeDec {
    make_annexb(threads, AV_CODEC_ID_H264, c"h264")
}

pub fn prep_dav1d(d: &mut ProbeDec, pkg: &WorkPkg, _: u16, _: f32) -> u64 {
    unsafe { d.dav1d.as_mut().unwrap_unchecked() }.load(&pkg.probe, pkg.frame_cnt);
    pkg.probe.len() as u64
}

#[cfg(feature = "vvenc")]
pub fn prep_vvdec(d: &mut ProbeDec, pkg: &WorkPkg, _: u16, _: f32) -> u64 {
    unsafe { d.vvdec.as_mut().unwrap_unchecked() }.load(&pkg.probe, pkg.frame_cnt);
    pkg.probe.len() as u64
}

#[cfg(any(feature = "x264", feature = "x265"))]
pub fn prep_annexb(d: &mut ProbeDec, pkg: &WorkPkg, _: u16, _: f32) -> u64 {
    unsafe { d.annexb.as_mut().unwrap_unchecked() }.load(&pkg.probe);
    pkg.probe.len() as u64
}

// bitreader reads past an au; PAD zeros in spare cap
#[cfg(any(feature = "x264", feature = "x265"))]
pub fn pad_probe(probe: &mut Vec<u8>) {
    let n = probe.len();
    probe.reserve(PAD);
    unsafe { write_bytes(probe.as_mut_ptr().add(n), 0, PAD) };
}

fn frame_dav1d(d: &mut ProbeDec) -> [*const u8; 3] {
    unsafe { d.dav1d.as_mut().unwrap_unchecked() }.dec_next()
}

const fn strides_dav1d(d: &ProbeDec) -> [i64; 3] {
    unsafe { d.dav1d.as_ref().unwrap_unchecked() }.strides()
}

#[cfg(feature = "vvenc")]
fn frame_vvdec(d: &mut ProbeDec) -> [*const u8; 3] {
    unsafe { d.vvdec.as_mut().unwrap_unchecked() }.dec_next()
}

#[cfg(feature = "vvenc")]
fn strides_vvdec(d: &ProbeDec) -> [i64; 3] {
    unsafe { d.vvdec.as_ref().unwrap_unchecked() }.strides()
}

#[cfg(any(feature = "x264", feature = "x265"))]
fn frame_annexb(d: &mut ProbeDec) -> [*const u8; 3] {
    unsafe { d.annexb.as_mut().unwrap_unchecked() }.dec_next()
}

#[cfg(any(feature = "x264", feature = "x265"))]
fn strides_annexb(d: &ProbeDec) -> [i64; 3] {
    unsafe { d.annexb.as_ref().unwrap_unchecked() }.strides()
}

fn comp_ssimu2(
    vship: &VshipProcessor,
    inp_planes: [*const u8; 3],
    out_planes: [*const u8; 3],
    inp_strides: [i64; 3],
    out_strides: [i64; 3],
) -> f32 {
    unsafe {
        vship
            .comp_ssimu2(inp_planes, out_planes, inp_strides, out_strides)
            .unwrap_unchecked()
    }
}

fn comp_butter(
    vship: &VshipProcessor,
    inp_planes: [*const u8; 3],
    out_planes: [*const u8; 3],
    inp_strides: [i64; 3],
    out_strides: [i64; 3],
) -> f32 {
    unsafe {
        vship
            .comp_butter(inp_planes, out_planes, inp_strides, out_strides)
            .unwrap_unchecked()
    }
}

fn comp_cvvdp(
    vship: &VshipProcessor,
    inp_planes: [*const u8; 3],
    out_planes: [*const u8; 3],
    inp_strides: [i64; 3],
    out_strides: [i64; 3],
) -> f32 {
    unsafe {
        vship
            .comp_cvvdp(inp_planes, out_planes, inp_strides, out_strides)
            .unwrap_unchecked()
    }
}

pub const JOD_A: f32 = 0.043_956_94;
pub const JOD_EXP: f32 = 0.930_204_3;

pub fn inverse_jod(score: f32) -> f32 {
    ((10.0 - score) / JOD_A).powf(1.0 / JOD_EXP)
}

pub fn jod(q: f32) -> f32 {
    JOD_A.mul_add(-q.powf(JOD_EXP), 10.0)
}

#[derive(Clone, Copy)]
pub struct Probe {
    pub crf: f32,
    pub score: f32,
}

pub struct Interp {
    pairs: Vec<(f32, f32)>,
    x: Vec<f32>,
    y: Vec<f32>,
}

impl Interp {
    pub const fn new() -> Self {
        Self {
            pairs: Vec::new(),
            x: Vec::new(),
            y: Vec::new(),
        }
    }

    pub fn clear(&mut self) {
        self.pairs.clear();
        self.x.clear();
        self.y.clear();
    }
}

pub fn interpolate_crf(probes: &[Probe], target: f32, round: u8, sc: &mut Interp) -> f32 {
    sc.clear();
    sc.pairs.extend(probes.iter().map(|p| (p.score, p.crf)));
    sc.pairs.sort_unstable_by(|a, b| a.0.total_cmp(&b.0));

    sc.x.extend(sc.pairs.iter().map(|p| p.0));
    sc.y.extend(sc.pairs.iter().map(|p| p.1));

    match round {
        3 => lerp(&sc.x, &sc.y, target),
        4 => fc_spline(&sc.x, &sc.y, target),
        _ => pchip(&sc.x, &sc.y, target),
    }
}

pub struct MetricBufs<'a> {
    pub unpacked: &'a mut [u8],
    pub scores: &'a mut Vec<f32>,
    pub planes: [*const u8; 3],
}

macro_rules! calc_metric_impl {
    (
        $name:ident,
        $is_10b:expr,
        $is_cvvdp:expr,
        $unpack:expr,
        $frame:expr,
        $strides:expr,
        $compute:expr
    ) => {
        pub fn $name(
            pkg: &WorkPkg,
            dec: &mut ProbeDec,
            pipe: &Pipeline,
            vship: &VshipProcessor,
            agg: &Agg,
            bufs: &mut MetricBufs,
            mp: &MetricProgs,
        ) -> f32 {
            let unpacked_buf = &mut *bufs.unpacked;
            let scores = &mut *bufs.scores;
            let planes = bufs.planes;
            let cvvdp_per_frame = $is_cvvdp && agg.per_frame;
            if $is_cvvdp {
                vship.reset_cvvdp();
            }

            scores.clear();
            let frame_sz = pipe.frame_sz;
            let tk = Tracker::new_met(
                mp.prog,
                mp.slot,
                pkg.chnk.idx,
                pkg.frame_cnt,
                Some((mp.crf, mp.last_score)),
            );

            let (y_sz, cr_off) = (pipe.met.y_sz, pipe.met.cr_off);
            let in_strides = pipe.met_strides;
            let mut src = pkg.yuv.as_ptr();

            let mut out_strides = [0i64; 3];
            let dst = scores.as_mut_ptr();

            macro_rules! process_frame {
                ($frame_idx: expr,$first: expr) => {{
                    tk.set($frame_idx + 1);

                    let output_planes = ($frame)(dec);
                    if $first {
                        out_strides = ($strides)(dec);
                    }

                    let input_planes = if $is_10b {
                        ($unpack)(src, unpacked_buf.as_mut_ptr(), pipe);
                        planes
                    } else {
                        unsafe { [src, src.add(y_sz), src.add(cr_off)] }
                    };
                    src = unsafe { src.add(frame_sz) };

                    let score =
                        ($compute)(vship, input_planes, output_planes, in_strides, out_strides);
                    unsafe { dst.add($frame_idx).write(score) };
                }};
            }

            process_frame!(0, true);
            if cvvdp_per_frame {
                vship.reset_cvvdp_score();
                for frame_idx in 1..pkg.frame_cnt {
                    process_frame!(frame_idx, false);
                    vship.reset_cvvdp_score();
                }
            } else {
                for frame_idx in 1..pkg.frame_cnt {
                    process_frame!(frame_idx, false);
                }
            }

            tk.freeze();
            unsafe { scores.set_len(pkg.frame_cnt) };
            (agg.f)(scores, agg.frac)
        }
    };
}

pub struct Agg {
    f: fn(&mut [f32], f32) -> f32,
    frac: f32,
    per_frame: bool,
}

impl Agg {
    #[cold]
    #[inline(never)]
    #[must_use]
    pub fn new(mode: &str, reset_cvvdp: bool, sort_desc: bool) -> Self {
        let pct = mode
            .strip_prefix('p')
            .and_then(|p| p.parse::<f32>().ok())
            .map(|p| p / 100.0);
        match (reset_cvvdp, pct) {
            (true, Some(p)) => Self {
                f: agg_cvvdp_pct,
                frac: p,
                per_frame: true,
            },
            (true, None) => Self {
                f: agg_last,
                frac: 0.0,
                per_frame: false,
            },
            (false, Some(p)) => Self {
                f: if sort_desc { agg_pct_desc } else { agg_pct_asc },
                frac: p,
                per_frame: false,
            },
            (false, None) => Self {
                f: agg_mean,
                frac: 0.0,
                per_frame: false,
            },
        }
    }
}

// cvvdp accumulates to last frame
const fn agg_last(scores: &mut [f32], _frac: f32) -> f32 {
    unsafe { *scores.last().unwrap_unchecked() }
}

fn agg_mean(scores: &mut [f32], _frac: f32) -> f32 {
    scores.iter().sum::<f32>() / scores.len() as f32
}

// non-linear jod space
fn agg_cvvdp_pct(scores: &mut [f32], frac: f32) -> f32 {
    for s in &mut *scores {
        *s = inverse_jod(*s);
    }
    scores.sort_unstable_by(|a, b| b.total_cmp(a));
    jod(pct_mean(scores, frac))
}

fn agg_pct_desc(scores: &mut [f32], frac: f32) -> f32 {
    scores.sort_unstable_by(|a, b| b.total_cmp(a));
    pct_mean(scores, frac)
}

fn agg_pct_asc(scores: &mut [f32], frac: f32) -> f32 {
    scores.sort_unstable_by(f32::total_cmp);
    pct_mean(scores, frac)
}

#[inline]
fn pct_mean(scores: &[f32], frac: f32) -> f32 {
    let cutoff = ((scores.len() as f32 * frac).ceil() as usize).min(scores.len());
    unsafe { scores.get_unchecked(..cutoff) }
        .iter()
        .sum::<f32>()
        / cutoff as f32
}

macro_rules! make_metric_shapes {
    ($compute:expr, $cv:expr, $frame:ident, $str:ident, $b8:ident, $p10:ident, $r10:ident) => {
        calc_metric_impl!(
            $b8,
            false,
            $cv,
            |_: *const u8, _: *mut u8, _: &Pipeline| (),
            $frame,
            $str,
            $compute
        );
        calc_metric_impl!(
            $p10,
            true,
            $cv,
            |s: *const u8, d: *mut u8, p: &Pipeline| unsafe {
                xav_unpack_10b(s, d, p.unpack_iters);
            },
            $frame,
            $str,
            $compute
        );
        calc_metric_impl!(
            $r10,
            true,
            $cv,
            |s: *const u8, d: *mut u8, p: &Pipeline| unsafe {
                xav_unpack_10b_rem(s, d, p.final_w, p.final_h);
            },
            $frame,
            $str,
            $compute
        );
    };
}

make_metric_shapes!(
    comp_ssimu2,
    false,
    frame_dav1d,
    strides_dav1d,
    calc_ssimu2_8b_dav1d,
    calc_ssimu2_10b_dav1d,
    calc_ssimu2_rem_dav1d
);
make_metric_shapes!(
    comp_butter,
    false,
    frame_dav1d,
    strides_dav1d,
    calc_butter_8b_dav1d,
    calc_butter_10b_dav1d,
    calc_butter_rem_dav1d
);
make_metric_shapes!(
    comp_cvvdp,
    true,
    frame_dav1d,
    strides_dav1d,
    calc_cvvdp_8b_dav1d,
    calc_cvvdp_10b_dav1d,
    calc_cvvdp_rem_dav1d
);

#[cfg(feature = "vvenc")]
make_metric_shapes!(
    comp_ssimu2,
    false,
    frame_vvdec,
    strides_vvdec,
    calc_ssimu2_8b_vvdec,
    calc_ssimu2_10b_vvdec,
    calc_ssimu2_rem_vvdec
);
#[cfg(feature = "vvenc")]
make_metric_shapes!(
    comp_butter,
    false,
    frame_vvdec,
    strides_vvdec,
    calc_butter_8b_vvdec,
    calc_butter_10b_vvdec,
    calc_butter_rem_vvdec
);
#[cfg(feature = "vvenc")]
make_metric_shapes!(
    comp_cvvdp,
    true,
    frame_vvdec,
    strides_vvdec,
    calc_cvvdp_8b_vvdec,
    calc_cvvdp_10b_vvdec,
    calc_cvvdp_rem_vvdec
);

#[cfg(any(feature = "x264", feature = "x265"))]
make_metric_shapes!(
    comp_ssimu2,
    false,
    frame_annexb,
    strides_annexb,
    calc_ssimu2_8b_annexb,
    calc_ssimu2_10b_annexb,
    calc_ssimu2_rem_annexb
);
#[cfg(any(feature = "x264", feature = "x265"))]
make_metric_shapes!(
    comp_butter,
    false,
    frame_annexb,
    strides_annexb,
    calc_butter_8b_annexb,
    calc_butter_10b_annexb,
    calc_butter_rem_annexb
);
#[cfg(any(feature = "x264", feature = "x265"))]
make_metric_shapes!(
    comp_cvvdp,
    true,
    frame_annexb,
    strides_annexb,
    calc_cvvdp_8b_annexb,
    calc_cvvdp_10b_annexb,
    calc_cvvdp_rem_annexb
);
