#[cfg(target_os = "linux")]
use alloc::vec::Vec;
#[cfg(feature = "x265")]
use core::ptr::write_bytes;
use core::{ptr::null, slice::from_raw_parts};

#[cfg(all(target_os = "linux", not(test)))]
use crate::fmath::{FloatExt as _, Powf as _};
#[cfg(feature = "x265")]
use crate::hevc::{HevcDec, PAD};
#[cfg(feature = "vvenc")]
use crate::vvdec::VvdecDec;
use crate::{
    dav1d::Dav1dDec,
    enc::SplitPath,
    error::fatal,
    ffms::VidDecoder,
    fs::metadata,
    interp::{fc_spline, lerp, pchip},
    pack::{unpack_10b, unpack_10b_rem},
    pipeline::{MetricProgs, Pipeline},
    progs::Tracker,
    vship::VshipProcessor,
    worker::WorkPkg,
};

pub struct ProbeDec {
    dav1d: Option<Dav1dDec>,
    #[cfg(feature = "vvenc")]
    vvdec: Option<VvdecDec>,
    #[cfg(feature = "x265")]
    hevc: Option<HevcDec>,
    vid: Option<VidDecoder>,
    threads: i32,
}

pub fn make_dav1d(threads: i32, w: u32, h: u32) -> ProbeDec {
    ProbeDec {
        dav1d: Some(Dav1dDec::new(threads, w, h).unwrap_or_else(|e| fatal(e))),
        #[cfg(feature = "vvenc")]
        vvdec: None,
        #[cfg(feature = "x265")]
        hevc: None,
        vid: None,
        threads,
    }
}

#[cfg(feature = "vvenc")]
pub fn make_vvdec(threads: i32, _: u32, _: u32) -> ProbeDec {
    ProbeDec {
        dav1d: None,
        vvdec: Some(VvdecDec::new(threads).unwrap_or_else(|e| fatal(e))),
        #[cfg(feature = "x265")]
        hevc: None,
        vid: None,
        threads,
    }
}

#[cfg(feature = "x265")]
pub fn make_hevc(threads: i32, _: u32, _: u32) -> ProbeDec {
    ProbeDec {
        dav1d: None,
        #[cfg(feature = "vvenc")]
        vvdec: None,
        hevc: Some(HevcDec::new(threads).unwrap_or_else(|e| fatal(e))),
        vid: None,
        threads,
    }
}

pub const fn make_ff(threads: i32, _: u32, _: u32) -> ProbeDec {
    ProbeDec {
        dav1d: None,
        #[cfg(feature = "vvenc")]
        vvdec: None,
        #[cfg(feature = "x265")]
        hevc: None,
        vid: None,
        threads,
    }
}

pub fn prep_dav1d(d: &mut ProbeDec, pkg: &WorkPkg, _: &mut SplitPath, _: u16, _: f32) -> u64 {
    unsafe { d.dav1d.as_mut().unwrap_unchecked() }.load(&pkg.probe, pkg.frame_cnt);
    pkg.probe.len() as u64
}

pub fn prep_ff(d: &mut ProbeDec, _: &WorkPkg, sp: &mut SplitPath, idx: u16, crf: f32) -> u64 {
    let pp = sp.set(idx, crf);
    let sz = metadata(pp).unwrap_or(0);
    d.vid = Some(VidDecoder::new(pp, d.threads).unwrap_or_else(|e| fatal(e)));
    sz
}

#[cfg(feature = "vvenc")]
pub fn prep_vvdec(d: &mut ProbeDec, pkg: &WorkPkg, _: &mut SplitPath, _: u16, _: f32) -> u64 {
    unsafe { d.vvdec.as_mut().unwrap_unchecked() }.load(&pkg.probe, pkg.frame_cnt);
    pkg.probe.len() as u64
}

#[cfg(feature = "x265")]
pub fn prep_hevc(d: &mut ProbeDec, pkg: &WorkPkg, _: &mut SplitPath, _: u16, _: f32) -> u64 {
    unsafe { d.hevc.as_mut().unwrap_unchecked() }.load(&pkg.probe);
    pkg.probe.len() as u64
}

// bitreader reads past an au; PAD zeros in spare cap
#[cfg(feature = "x265")]
pub fn pad_probe(probe: &mut Vec<u8>) {
    let n = probe.len();
    probe.reserve(PAD);
    unsafe { write_bytes(probe.as_mut_ptr().add(n), 0, PAD) };
}

fn frame_dav1d(d: &mut ProbeDec) -> ([*const u8; 3], [i64; 3]) {
    unsafe { d.dav1d.as_mut().unwrap_unchecked() }.dec_next()
}

#[cfg(feature = "vvenc")]
fn frame_vvdec(d: &mut ProbeDec) -> ([*const u8; 3], [i64; 3]) {
    unsafe { d.vvdec.as_mut().unwrap_unchecked() }.dec_next()
}

#[cfg(feature = "x265")]
fn frame_hevc(d: &mut ProbeDec) -> ([*const u8; 3], [i64; 3]) {
    unsafe { d.hevc.as_mut().unwrap_unchecked() }.dec_next()
}

fn frame_ff(d: &mut ProbeDec) -> ([*const u8; 3], [i64; 3]) {
    let vid = unsafe { d.vid.as_mut().unwrap_unchecked() };
    let of = unsafe { &*vid.dec_next() };
    (
        [
            of.data[0].cast_const(),
            of.data[1].cast_const(),
            of.data[2].cast_const(),
        ],
        [
            i64::from(of.linesize[0]),
            i64::from(of.linesize[1]),
            i64::from(of.linesize[2]),
        ],
    )
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

fn round_crf(crf: f32) -> f32 {
    (crf * 4.0).round() / 4.0
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

    let result = match round {
        3 => lerp(&sc.x, &sc.y, target),
        4 => fc_spline(&sc.x, &sc.y, target),
        _ => pchip(&sc.x, &sc.y, target),
    };

    round_crf(result)
}

pub struct MetricBufs<'a> {
    pub unpacked: &'a mut [u8],
    pub scores: &'a mut Vec<f32>,
}

macro_rules! calc_metric_impl {
    ($name:ident, $is_10b:expr, $is_cvvdp:expr, $unpack:expr, $frame:expr, $compute:expr) => {
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

            let (fw, fh) = (pipe.final_w, pipe.final_h);
            let (y_sz, cr_off) = (pipe.met.y_sz, pipe.met.cr_off);
            let cs = pipe.met.c_stride as i64;
            let inp_strides = [pipe.met.y_stride as i64, cs, cs];
            let unp_planes = if $is_10b {
                let b = unpacked_buf.as_ptr();
                unsafe { [b, b.add(y_sz), b.add(cr_off)] }
            } else {
                [null(); 3]
            };
            let mut src = pkg.yuv.as_ptr();

            macro_rules! process_frame {
                ($frame_idx: expr) => {{
                    tk.set($frame_idx + 1);

                    let input_frame = unsafe { from_raw_parts(src, frame_sz) };
                    src = unsafe { src.add(frame_sz) };
                    let (output_planes, output_strides) = ($frame)(dec);

                    let input_planes = if $is_10b {
                        ($unpack)(input_frame, unpacked_buf, fw, fh);
                        unp_planes
                    } else {
                        let b = input_frame.as_ptr();
                        unsafe { [b, b.add(y_sz), b.add(cr_off)] }
                    };

                    scores.push(($compute)(
                        vship,
                        input_planes,
                        output_planes,
                        inp_strides,
                        output_strides,
                    ));
                }};
            }

            if cvvdp_per_frame {
                for frame_idx in 0..pkg.frame_cnt {
                    process_frame!(frame_idx);
                    vship.reset_cvvdp_score();
                }
            } else {
                for frame_idx in 0..pkg.frame_cnt {
                    process_frame!(frame_idx);
                }
            }

            (agg.f)(scores, agg.pctl)
        }
    };
}

pub struct Agg {
    f: fn(&mut [f32], f32) -> f32,
    pctl: f32,
    per_frame: bool,
}

impl Agg {
    #[cold]
    #[inline(never)]
    #[must_use]
    pub fn new(mode: &str, reset_cvvdp: bool, sort_desc: bool) -> Self {
        let pct = mode.strip_prefix('p').and_then(|p| p.parse::<f32>().ok());
        match (reset_cvvdp, pct) {
            (true, Some(p)) => Self {
                f: agg_cvvdp_pct,
                pctl: p,
                per_frame: true,
            },
            (true, None) => Self {
                f: agg_last,
                pctl: 0.0,
                per_frame: false,
            },
            (false, Some(p)) => Self {
                f: if sort_desc { agg_pct_desc } else { agg_pct_asc },
                pctl: p,
                per_frame: false,
            },
            (false, None) => Self {
                f: agg_mean,
                pctl: 0.0,
                per_frame: false,
            },
        }
    }
}

// cvvdp accumulates to last frame
fn agg_last(scores: &mut [f32], _pctl: f32) -> f32 {
    scores.last().copied().unwrap_or(0.0)
}

fn agg_mean(scores: &mut [f32], _pctl: f32) -> f32 {
    scores.iter().sum::<f32>() / scores.len() as f32
}

// non-linear jod space
fn agg_cvvdp_pct(scores: &mut [f32], pctl: f32) -> f32 {
    for s in &mut *scores {
        *s = inverse_jod(*s);
    }
    scores.sort_unstable_by(|a, b| b.total_cmp(a));
    jod(pct_mean(scores, pctl))
}

fn agg_pct_desc(scores: &mut [f32], pctl: f32) -> f32 {
    scores.sort_unstable_by(|a, b| b.total_cmp(a));
    pct_mean(scores, pctl)
}

fn agg_pct_asc(scores: &mut [f32], pctl: f32) -> f32 {
    scores.sort_unstable_by(f32::total_cmp);
    pct_mean(scores, pctl)
}

#[inline]
fn pct_mean(scores: &[f32], pctl: f32) -> f32 {
    let cutoff = ((scores.len() as f32 * pctl / 100.0).ceil() as usize).min(scores.len());
    scores[..cutoff].iter().sum::<f32>() / cutoff as f32
}

macro_rules! make_metric_shapes {
    ($compute:expr, $cv:expr, $frame:ident, $b8:ident, $p10:ident, $r10:ident) => {
        calc_metric_impl!(
            $b8,
            false,
            $cv,
            |_: &[u8], _: &mut [u8], _: usize, _: usize| (),
            $frame,
            $compute
        );
        calc_metric_impl!(
            $p10,
            true,
            $cv,
            |f: &[u8], b: &mut [u8], _w: usize, _h: usize| unpack_10b(f, b),
            $frame,
            $compute
        );
        calc_metric_impl!(
            $r10,
            true,
            $cv,
            |f: &[u8], b: &mut [u8], w: usize, h: usize| unpack_10b_rem(f, b, w, h),
            $frame,
            $compute
        );
    };
}

macro_rules! make_metric_set {
    (
        $compute:expr,
        $cv:expr,
        $b8d:ident,
        $b8f:ident,
        $p10d:ident,
        $p10f:ident,
        $r10d:ident,
        $r10f:ident
    ) => {
        make_metric_shapes!($compute, $cv, frame_dav1d, $b8d, $p10d, $r10d);
        make_metric_shapes!($compute, $cv, frame_ff, $b8f, $p10f, $r10f);
    };
}

make_metric_set!(
    comp_ssimu2,
    false,
    calc_ssimu2_8b_dav1d,
    calc_ssimu2_8b_ff,
    calc_ssimu2_10b_dav1d,
    calc_ssimu2_10b_ff,
    calc_ssimu2_rem_dav1d,
    calc_ssimu2_rem_ff
);
make_metric_set!(
    comp_butter,
    false,
    calc_butter_8b_dav1d,
    calc_butter_8b_ff,
    calc_butter_10b_dav1d,
    calc_butter_10b_ff,
    calc_butter_rem_dav1d,
    calc_butter_rem_ff
);
make_metric_set!(
    comp_cvvdp,
    true,
    calc_cvvdp_8b_dav1d,
    calc_cvvdp_8b_ff,
    calc_cvvdp_10b_dav1d,
    calc_cvvdp_10b_ff,
    calc_cvvdp_rem_dav1d,
    calc_cvvdp_rem_ff
);

#[cfg(feature = "vvenc")]
make_metric_shapes!(
    comp_ssimu2,
    false,
    frame_vvdec,
    calc_ssimu2_8b_vvdec,
    calc_ssimu2_10b_vvdec,
    calc_ssimu2_rem_vvdec
);
#[cfg(feature = "vvenc")]
make_metric_shapes!(
    comp_butter,
    false,
    frame_vvdec,
    calc_butter_8b_vvdec,
    calc_butter_10b_vvdec,
    calc_butter_rem_vvdec
);
#[cfg(feature = "vvenc")]
make_metric_shapes!(
    comp_cvvdp,
    true,
    frame_vvdec,
    calc_cvvdp_8b_vvdec,
    calc_cvvdp_10b_vvdec,
    calc_cvvdp_rem_vvdec
);

#[cfg(feature = "x265")]
make_metric_shapes!(
    comp_ssimu2,
    false,
    frame_hevc,
    calc_ssimu2_8b_hevc,
    calc_ssimu2_10b_hevc,
    calc_ssimu2_rem_hevc
);
#[cfg(feature = "x265")]
make_metric_shapes!(
    comp_butter,
    false,
    frame_hevc,
    calc_butter_8b_hevc,
    calc_butter_10b_hevc,
    calc_butter_rem_hevc
);
#[cfg(feature = "x265")]
make_metric_shapes!(
    comp_cvvdp,
    true,
    frame_hevc,
    calc_cvvdp_8b_hevc,
    calc_cvvdp_10b_hevc,
    calc_cvvdp_rem_hevc
);
