#[cfg(target_os = "linux")]
use alloc::vec::Vec;
use core::slice::from_raw_parts;

#[cfg(all(target_os = "linux", not(test)))]
use crate::fmath::{FloatExt as _, Powf as _};
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
    vid: Option<VidDecoder>,
    threads: i32,
}

pub fn make_dav1d(threads: i32) -> ProbeDec {
    ProbeDec {
        dav1d: Some(Dav1dDec::new(threads).unwrap_or_else(|e| fatal(e))),
        vid: None,
        threads,
    }
}

pub const fn make_ff(threads: i32) -> ProbeDec {
    ProbeDec {
        dav1d: None,
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

fn frame_dav1d(d: &mut ProbeDec) -> ([*const u8; 3], [i64; 3]) {
    unsafe { d.dav1d.as_mut().unwrap_unchecked() }.dec_next()
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

#[derive(Clone)]
pub struct Probe {
    pub crf: f32,
    pub score: f32,
}

#[derive(Clone)]
pub struct ProbeLog {
    pub chnk_idx: u16,
    pub probes: Vec<(f32, f32, u64)>,
    pub final_crf: f32,
    pub final_score: f32,
    pub final_sz: u64,
    pub round: u8,
    pub frames: usize,
}

fn round_crf(crf: f32) -> f32 {
    (crf * 4.0).round() / 4.0
}

pub fn interpolate_crf(probes: &[Probe], target: f32, round: u8) -> f32 {
    let mut pairs: Vec<(f32, f32)> = probes.iter().map(|p| (p.score, p.crf)).collect();
    pairs.sort_unstable_by(|a, b| a.0.total_cmp(&b.0));

    let x: Vec<f32> = pairs.iter().map(|p| p.0).collect();
    let y: Vec<f32> = pairs.iter().map(|p| p.1).collect();

    let result = match round {
        3 => lerp(&x, &y, target),
        4 => fc_spline(&x, &y, target),
        _ => pchip(&x, &y, target),
    };

    round_crf(result)
}

macro_rules! calc_metric_impl {
    ($name:ident, $is_10b:expr, $unpack:expr, $frame:expr, $compute:expr) => {
        pub fn $name(
            pkg: &WorkPkg,
            dec: &mut ProbeDec,
            pipe: &Pipeline,
            vship: &VshipProcessor,
            metric_mode: &str,
            unpacked_buf: &mut [u8],
            mp: &MetricProgs,
        ) -> f32 {
            let cvvdp_per_frame = pipe.reset_cvvdp && metric_mode.starts_with('p');
            if pipe.reset_cvvdp {
                vship.reset_cvvdp();
            }

            let mut scores = Vec::with_capacity(pkg.frame_cnt);
            let frame_sz = pipe.frame_sz;
            let tk = Tracker::new_met(
                mp.prog,
                mp.slot,
                pkg.chnk.idx,
                pkg.frame_cnt,
                Some((mp.crf, mp.last_score)),
            );

            let pix_sz = if $is_10b { 2 } else { 1 };
            let (fw, fh) = (pipe.final_w, pipe.final_h);
            let y_sz = fw * fh * pix_sz;
            let uv_sz = y_sz / 4;
            let ys = (fw * pix_sz) as i64;
            let cs = (fw / 2 * pix_sz) as i64;
            let mut src = pkg.yuv.as_ptr();

            macro_rules! process_frame {
                ($frame_idx: expr) => {{
                    tk.set($frame_idx + 1);

                    let input_frame = unsafe { from_raw_parts(src, frame_sz) };
                    src = unsafe { src.add(frame_sz) };
                    let (output_planes, output_strides) = ($frame)(dec);

                    let base = if $is_10b {
                        ($unpack)(input_frame, unpacked_buf, fw, fh);
                        unpacked_buf.as_ptr()
                    } else {
                        input_frame.as_ptr()
                    };

                    let input_planes = unsafe { [base, base.add(y_sz), base.add(y_sz + uv_sz)] };

                    scores.push(($compute)(
                        vship,
                        input_planes,
                        output_planes,
                        [ys, cs, cs],
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

            aggregate_scores(&mut scores, pipe, metric_mode, cvvdp_per_frame)
        }
    };
}

fn aggregate_scores(
    scores: &mut [f32],
    pipe: &Pipeline,
    metric_mode: &str,
    cvvdp_per_frame: bool,
) -> f32 {
    if pipe.reset_cvvdp && !cvvdp_per_frame {
        scores.last().copied().unwrap_or(0.0)
    } else if cvvdp_per_frame {
        let percentile: f32 = unsafe {
            metric_mode
                .strip_prefix('p')
                .and_then(|p| p.parse().ok())
                .unwrap_unchecked()
        };
        let mut q: Vec<f32> = scores.iter().map(|&s| inverse_jod(s)).collect();
        q.sort_unstable_by(|a, b| b.total_cmp(a));
        let cutoff = ((q.len() as f32 * percentile / 100.0).ceil() as usize).min(q.len());
        jod(q[..cutoff].iter().sum::<f32>() / cutoff as f32)
    } else if metric_mode == "mean" {
        scores.iter().sum::<f32>() / scores.len() as f32
    } else if let Some(p) = metric_mode.strip_prefix('p') {
        let percentile: f32 = unsafe { p.parse().unwrap_unchecked() };
        if pipe.sort_descending {
            scores.sort_unstable_by(|a, b| b.total_cmp(a));
        } else {
            scores.sort_unstable_by(f32::total_cmp);
        }
        let cutoff = ((scores.len() as f32 * percentile / 100.0).ceil() as usize).min(scores.len());
        scores[..cutoff].iter().sum::<f32>() / cutoff as f32
    } else {
        scores.iter().sum::<f32>() / scores.len() as f32
    }
}

macro_rules! make_metric_set {
    ($compute:expr, $b8d:ident, $b8f:ident, $p10d:ident, $p10f:ident, $r10d:ident, $r10f:ident) => {
        calc_metric_impl!(
            $b8d,
            false,
            |_: &[u8], _: &mut [u8], _: usize, _: usize| (),
            frame_dav1d,
            $compute
        );
        calc_metric_impl!(
            $b8f,
            false,
            |_: &[u8], _: &mut [u8], _: usize, _: usize| (),
            frame_ff,
            $compute
        );
        calc_metric_impl!(
            $p10d,
            true,
            |f: &[u8], b: &mut [u8], _w: usize, _h: usize| unpack_10b(f, b),
            frame_dav1d,
            $compute
        );
        calc_metric_impl!(
            $p10f,
            true,
            |f: &[u8], b: &mut [u8], _w: usize, _h: usize| unpack_10b(f, b),
            frame_ff,
            $compute
        );
        calc_metric_impl!(
            $r10d,
            true,
            |f: &[u8], b: &mut [u8], w: usize, h: usize| unpack_10b_rem(f, b, w, h),
            frame_dav1d,
            $compute
        );
        calc_metric_impl!(
            $r10f,
            true,
            |f: &[u8], b: &mut [u8], w: usize, h: usize| unpack_10b_rem(f, b, w, h),
            frame_ff,
            $compute
        );
    };
}

make_metric_set!(
    comp_ssimu2,
    calc_ssimu2_8b_dav1d,
    calc_ssimu2_8b_ff,
    calc_ssimu2_10b_dav1d,
    calc_ssimu2_10b_ff,
    calc_ssimu2_rem_dav1d,
    calc_ssimu2_rem_ff
);
make_metric_set!(
    comp_butter,
    calc_butter_8b_dav1d,
    calc_butter_8b_ff,
    calc_butter_10b_dav1d,
    calc_butter_10b_ff,
    calc_butter_rem_dav1d,
    calc_butter_rem_ff
);
make_metric_set!(
    comp_cvvdp,
    calc_cvvdp_8b_dav1d,
    calc_cvvdp_8b_ff,
    calc_cvvdp_10b_dav1d,
    calc_cvvdp_10b_ff,
    calc_cvvdp_rem_dav1d,
    calc_cvvdp_rem_ff
);
