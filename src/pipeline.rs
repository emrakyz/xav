use std::{io::Write as _, process::ChildStdin};

use crate::{
    enc::get_frame,
    ffms::{
        DecStrat,
        DecStrat::{
            B8Crop, B8CropFast, B8CropStride, B10Crop, B10CropFast, B10CropFastRem, B10CropRem,
            B10CropStride, B10CropStrideRem, B10RawCrop, B10RawCropFast, B10RawCropStride,
            HwNv12Crop, HwNv12CropTo10, HwNv12To10, HwNv12To10Stride, HwP010CropPack,
            HwP010CropPackPkRem, HwP010CropPackRem, HwP010CropPackRemPkRem, HwP010RawCrop,
            HwP010RawCropRem,
        },
        VidInf, nv12_10b, nv12_10b_rem,
    },
    pack::{
        PACK_CHUNK, SHIFT_CHUNK, UNPACK_CHUNK, calc_8b_sz, calc_packed_sz, conv_10b, conv_10b_rem,
        unpack_10b, unpack_10b_rem,
    },
};
#[cfg(feature = "vship")]
use crate::{
    progs::ProgsTrack,
    tq::{ProbeDec, calc_metric_8b, calc_metric_10b},
    vship::VshipProcessor,
    worker::WorkPkg,
};

pub type UnpackFn = fn(&[u8], &mut [u8], &Pipeline);
pub type WriteFn = fn(&mut ChildStdin, &[u8], usize, &mut [u8], &Pipeline);

const fn unpack_noop(_: &[u8], _: &mut [u8], _: &Pipeline) {}

#[cfg(feature = "vship")]
pub struct MetricProgs<'a> {
    pub prog: &'a ProgsTrack,
    pub slot: usize,
    pub crf: f32,
    pub last_score: Option<f32>,
}

#[cfg(feature = "vship")]
pub type CalcMetricFn = fn(
    &WorkPkg,
    &mut ProbeDec,
    &Pipeline,
    &VshipProcessor,
    &str,
    &mut [u8],
    &MetricProgs,
) -> (f32, Vec<f32>);

#[cfg(feature = "vship")]
pub type ComputeMetricFn =
    fn(&VshipProcessor, [*const u8; 3], [*const u8; 3], [i64; 3], [i64; 3]) -> f32;

#[cfg(feature = "vship")]
pub type AggregateScoresFn = fn(&mut Vec<f32>) -> f32;

fn unpack_10b_wrap(inp: &[u8], out: &mut [u8], _pipe: &Pipeline) {
    unpack_10b(inp, out);
}

fn unpack_10b_rem_wrap(inp: &[u8], out: &mut [u8], pipe: &Pipeline) {
    unpack_10b_rem(inp, out, pipe.final_w, pipe.final_h);
}

fn nv12_10b_wrap(inp: &[u8], out: &mut [u8], pipe: &Pipeline) {
    nv12_10b(inp, out, pipe.final_w, pipe.final_h);
}

fn nv12_10b_rem_wrap(inp: &[u8], out: &mut [u8], pipe: &Pipeline) {
    nv12_10b_rem(inp, out, pipe.final_w, pipe.final_h);
}

pub fn write_frames_10b(
    stdin: &mut ChildStdin,
    frames: &[u8],
    frame_cnt: usize,
    buf: &mut [u8],
    pipe: &Pipeline,
) {
    for i in 0..frame_cnt {
        let frame = get_frame(frames, i, pipe.frame_sz);
        (pipe.unpack)(frame, buf, pipe);
        _ = stdin.write_all(buf);
    }
}

pub fn write_frames_8b(
    stdin: &mut ChildStdin,
    frames: &[u8],
    frame_cnt: usize,
    buf: &mut [u8],
    pipe: &Pipeline,
) {
    for i in 0..frame_cnt {
        let frame = get_frame(frames, i, pipe.frame_sz);
        conv_10b(frame, buf);
        _ = stdin.write_all(buf);
    }
}

pub fn write_frames_8b_rem(
    stdin: &mut ChildStdin,
    frames: &[u8],
    frame_cnt: usize,
    buf: &mut [u8],
    pipe: &Pipeline,
) {
    for i in 0..frame_cnt {
        let frame = get_frame(frames, i, pipe.frame_sz);
        conv_10b_rem(frame, buf);
        _ = stdin.write_all(buf);
    }
}

#[derive(Clone)]
pub struct Pipeline {
    pub final_w: usize,
    pub final_h: usize,
    pub frame_sz: usize,
    pub y_sz: usize,
    pub uv_sz: usize,
    pub conv_buf_sz: usize,
    #[cfg(feature = "vship")]
    pub unpack_buf_sz: usize,
    pub unpack: UnpackFn,
    pub write_frames: WriteFn,
    #[cfg(feature = "vship")]
    pub calc_metric: CalcMetricFn,
    #[cfg(feature = "vship")]
    pub compute_metric: ComputeMetricFn,
    #[cfg(feature = "vship")]
    pub reset_cvvdp: bool,
    #[cfg(feature = "vship")]
    pub sort_descending: bool,
}

impl Pipeline {
    #[must_use]
    pub fn new(inf: &VidInf, strat: DecStrat, #[cfg(feature = "vship")] tq: Option<&str>) -> Self {
        let (final_w, final_h) = match strat {
            B10Crop { cc }
            | B10CropRem { cc }
            | B10CropFast { cc }
            | B10CropFastRem { cc }
            | B10CropStride { cc }
            | B10CropStrideRem { cc }
            | B8Crop { cc }
            | B8CropFast { cc }
            | B8CropStride { cc }
            | B10RawCrop { cc }
            | B10RawCropFast { cc }
            | B10RawCropStride { cc }
            | HwNv12Crop { cc }
            | HwNv12CropTo10 { cc }
            | HwP010RawCrop { cc }
            | HwP010RawCropRem { cc }
            | HwP010CropPack { cc }
            | HwP010CropPackPkRem { cc }
            | HwP010CropPackRem { cc }
            | HwP010CropPackRemPkRem { cc } => (cc.new_w as usize, cc.new_h as usize),
            _ => (inf.width as usize, inf.height as usize),
        };

        let frame_sz = if strat.is_raw() {
            final_w * final_h * 3
        } else if inf.is_10b {
            calc_packed_sz(final_w as u32, final_h as u32)
        } else {
            calc_8b_sz(final_w as u32, final_h as u32)
        };

        let is_10b_out = inf.is_10b;
        let pix_sz = if is_10b_out { 2 } else { 1 };
        let y_sz = final_w * final_h * pix_sz;
        let uv_sz = y_sz / 4;

        let is_raw = strat.is_raw();
        let conv_buf_sz = if is_raw {
            0
        } else {
            final_w * final_h * 3 / 2 * 2
        };

        #[cfg(feature = "vship")]
        let unpack_buf_sz = if is_10b_out { conv_buf_sz } else { 0 };

        let has_rem = inf.is_10b
            && (!final_w.is_multiple_of(PACK_CHUNK) || !frame_sz.is_multiple_of(UNPACK_CHUNK));

        let is_nv12_10 = matches!(strat, HwNv12To10 | HwNv12To10Stride | HwNv12CropTo10 { .. });

        let (unpack, write_frames): (UnpackFn, WriteFn) = if is_nv12_10 {
            let y_ok = (final_w * final_h).is_multiple_of(SHIFT_CHUNK);
            let uv_ok = (final_w / 2 * (final_h / 2)).is_multiple_of(SHIFT_CHUNK * 2);
            if y_ok && uv_ok {
                (nv12_10b_wrap, write_frames_10b)
            } else {
                (nv12_10b_rem_wrap, write_frames_10b)
            }
        } else if is_raw {
            (unpack_noop, write_frames_10b)
        } else if !is_10b_out {
            if frame_sz.is_multiple_of(SHIFT_CHUNK) {
                (unpack_noop, write_frames_8b)
            } else {
                (unpack_noop, write_frames_8b_rem)
            }
        } else if has_rem {
            (unpack_10b_rem_wrap, write_frames_10b)
        } else {
            (unpack_10b_wrap, write_frames_10b)
        };

        #[cfg(feature = "vship")]
        let (compute_metric, reset_cvvdp, sort_descending, calc_metric) =
            resolve_metric(is_10b_out, tq);

        Self {
            final_w,
            final_h,
            frame_sz,
            y_sz,
            uv_sz,
            conv_buf_sz,
            #[cfg(feature = "vship")]
            unpack_buf_sz,
            unpack,
            write_frames,
            #[cfg(feature = "vship")]
            calc_metric,
            #[cfg(feature = "vship")]
            compute_metric,
            #[cfg(feature = "vship")]
            reset_cvvdp,
            #[cfg(feature = "vship")]
            sort_descending,
        }
    }
}

#[cfg(feature = "vship")]
fn resolve_metric(is_10b: bool, tq: Option<&str>) -> (ComputeMetricFn, bool, bool, CalcMetricFn) {
    let calc: CalcMetricFn = if is_10b {
        calc_metric_10b
    } else {
        calc_metric_8b
    };

    tq.map_or((comp_ssimu2 as ComputeMetricFn, false, false, calc), |tq| {
        let tq_parts: Vec<f32> = tq.split('-').filter_map(|s| s.parse().ok()).collect();
        let tq_target = f32::midpoint(tq_parts[0], tq_parts[1]);

        let use_butter = tq_target < 8.0;
        let use_cvvdp = tq_target > 8.0 && tq_target <= 10.0;

        let compute = if use_butter {
            comp_butter as ComputeMetricFn
        } else if use_cvvdp {
            comp_cvvdp as ComputeMetricFn
        } else {
            comp_ssimu2 as ComputeMetricFn
        };

        (compute, use_cvvdp, use_butter, calc)
    })
}

#[cfg(feature = "vship")]
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

#[cfg(feature = "vship")]
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

#[cfg(feature = "vship")]
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

#[cfg(test)]
pub mod test_access {
    use super::*;

    pub const UNPACK_NOOP: UnpackFn = unpack_noop;
    pub const UNPACK_10B: UnpackFn = unpack_10b_wrap;
    pub const UNPACK_10B_REM: UnpackFn = unpack_10b_rem_wrap;
    pub const NV12_10B: UnpackFn = nv12_10b_wrap;
    pub const NV12_10B_REM: UnpackFn = nv12_10b_rem_wrap;

    #[cfg(feature = "vship")]
    #[allow(dead_code)]
    pub const COMPUTE_SSIMULACRA2: ComputeMetricFn = comp_ssimu2;
    #[cfg(feature = "vship")]
    #[allow(dead_code)]
    pub const COMPUTE_BUTTERAUGLI: ComputeMetricFn = comp_butter;
    #[cfg(feature = "vship")]
    pub const COMPUTE_CVVDP: ComputeMetricFn = comp_cvvdp;
}
