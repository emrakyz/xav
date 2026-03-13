#[cfg(feature = "vship")]
use std::path::Path;
use std::{io::Write as _, process::ChildStdin};

use crate::{
    encode::get_frame,
    ffms::{
        DecodeStrat,
        DecodeStrat::{
            B8Crop, B8CropFast, B8CropStride, B8Fast, B8Stride, B10Crop, B10CropFast,
            B10CropFastRem, B10CropRem, B10CropStride, B10CropStrideRem, B10Fast, B10FastRem,
            B10Raw, B10RawCrop, B10RawCropFast, B10RawCropStride, B10RawStride, B10Stride,
            B10StrideRem, HwNv12, HwNv12Crop, HwNv12CropTo10, HwNv12To10, HwP010CropPack,
            HwP010Pack, HwP010Raw, HwP010RawCrop,
        },
        VidInf, calc_8bit_size, calc_packed_size, conv_to_10b, nv12_to_10b, unpack_10b,
        unpack_10b_rem,
    },
};
#[cfg(feature = "vship")]
use crate::{
    progs::ProgsTrack,
    tq::{calc_metrics_8bit, calc_metrics_10b},
    vship::VshipProcessor,
    worker::WorkPkg,
};

pub type UnpackFn = fn(&[u8], &mut [u8], &Pipeline);
pub type WriteFn = fn(&mut ChildStdin, &[u8], usize, &mut [u8], &Pipeline);

const fn unpack_noop(_: &[u8], _: &mut [u8], _: &Pipeline) {}

#[cfg(feature = "vship")]
pub struct MetricsProgress<'a> {
    pub prog: &'a ProgsTrack,
    pub slot: usize,
    pub crf: f32,
    pub last_score: Option<f64>,
}

#[cfg(feature = "vship")]
pub type CalcMetricsFn = fn(
    &WorkPkg,
    &Path,
    &Pipeline,
    &VshipProcessor,
    &str,
    &mut [u8],
    &MetricsProgress,
) -> (f64, Vec<f64>);

#[cfg(feature = "vship")]
pub type ComputeMetricFn =
    fn(&VshipProcessor, [*const u8; 3], [*const u8; 3], [i64; 3], [i64; 3]) -> f64;

#[cfg(feature = "vship")]
pub type AggregateScoresFn = fn(&mut Vec<f64>) -> f64;

fn unpack_10b_wrap(input: &[u8], output: &mut [u8], pipe: &Pipeline) {
    unpack_10b(input, output, pipe.final_w, pipe.final_h);
}

fn unpack_10b_rem_wrap(input: &[u8], output: &mut [u8], pipe: &Pipeline) {
    unpack_10b_rem(input, output, pipe.final_w, pipe.final_h);
}

fn nv12_to_10b_wrap(input: &[u8], output: &mut [u8], pipe: &Pipeline) {
    nv12_to_10b(input, output, pipe.final_w, pipe.final_h);
}

pub fn write_frames_10b(
    stdin: &mut ChildStdin,
    frames: &[u8],
    frame_count: usize,
    buf: &mut [u8],
    pipe: &Pipeline,
) {
    for i in 0..frame_count {
        let frame = get_frame(frames, i, pipe.frame_size);
        (pipe.unpack)(frame, buf, pipe);
        _ = stdin.write_all(buf);
    }
}

pub fn write_frames_8bit(
    stdin: &mut ChildStdin,
    frames: &[u8],
    frame_count: usize,
    buf: &mut [u8],
    pipe: &Pipeline,
) {
    for i in 0..frame_count {
        let frame = get_frame(frames, i, pipe.frame_size);
        conv_to_10b(frame, buf);
        _ = stdin.write_all(buf);
    }
}

#[derive(Clone)]
pub struct Pipeline {
    pub final_w: usize,
    pub final_h: usize,
    pub frame_size: usize,
    pub y_size: usize,
    pub uv_size: usize,
    pub conv_buf_size: usize,
    pub unpack: UnpackFn,
    pub write_frames: WriteFn,
    #[cfg(feature = "vship")]
    pub calc_metrics: CalcMetricsFn,
    #[cfg(feature = "vship")]
    pub compute_metric: ComputeMetricFn,
    #[cfg(feature = "vship")]
    pub reset_cvvdp: bool,
    #[cfg(feature = "vship")]
    pub sort_descending: bool,
}

impl Pipeline {
    #[must_use]
    pub fn new(
        inf: &VidInf,
        strat: DecodeStrat,
        #[cfg(feature = "vship")] target_quality: Option<&str>,
    ) -> Self {
        let (final_w, final_h) = match strat {
            B10CropFast { cc }
            | B10CropFastRem { cc }
            | B10Crop { cc }
            | B10CropRem { cc }
            | B10CropStride { cc }
            | B10CropStrideRem { cc }
            | B8CropFast { cc }
            | B8Crop { cc }
            | B8CropStride { cc }
            | B10RawCropFast { cc }
            | B10RawCrop { cc }
            | B10RawCropStride { cc }
            | HwNv12Crop { cc }
            | HwNv12CropTo10 { cc }
            | HwP010RawCrop { cc }
            | HwP010CropPack { cc } => (cc.new_w as usize, cc.new_h as usize),
            _ => (inf.width as usize, inf.height as usize),
        };

        let frame_size = match strat {
            B10Raw
            | B10RawStride
            | B10RawCropFast { .. }
            | B10RawCrop { .. }
            | B10RawCropStride { .. }
            | HwP010Raw
            | HwP010RawCrop { .. } => final_w * final_h * 3,
            B10Fast
            | B10FastRem
            | B10Stride
            | B10StrideRem
            | B10CropFast { .. }
            | B10CropFastRem { .. }
            | B10Crop { .. }
            | B10CropRem { .. }
            | B10CropStride { .. }
            | B10CropStrideRem { .. }
            | HwP010Pack
            | HwP010CropPack { .. } => calc_packed_size(final_w as u32, final_h as u32),
            B8Fast
            | B8Stride
            | B8CropFast { .. }
            | B8Crop { .. }
            | B8CropStride { .. }
            | HwNv12
            | HwNv12Crop { .. }
            | HwNv12To10
            | HwNv12CropTo10 { .. } => calc_8bit_size(final_w as u32, final_h as u32),
        };

        let is_10b_output = inf.is_10b;
        let pixel_size = if is_10b_output { 2 } else { 1 };
        let y_size = final_w * final_h * pixel_size;
        let uv_size = y_size / 4;

        let is_raw = strat.is_raw();
        let conv_buf_size = if is_raw {
            0
        } else {
            final_w * final_h * 3 / 2 * 2
        };

        let has_rem = inf.is_10b && (final_w % 8) != 0;

        let is_nv12_to_10 = matches!(strat, HwNv12To10 | HwNv12CropTo10 { .. });

        let (unpack, write_frames): (UnpackFn, WriteFn) = if is_nv12_to_10 {
            (nv12_to_10b_wrap, write_frames_10b)
        } else if is_raw {
            (unpack_noop, write_frames_10b)
        } else if !is_10b_output {
            (unpack_noop, write_frames_8bit)
        } else if has_rem {
            (unpack_10b_rem_wrap, write_frames_10b)
        } else {
            (unpack_10b_wrap, write_frames_10b)
        };

        #[cfg(feature = "vship")]
        let (compute_metric, reset_cvvdp, sort_descending, calc_metrics) =
            resolve_metrics(is_10b_output, target_quality);

        Self {
            final_w,
            final_h,
            frame_size,
            y_size,
            uv_size,
            conv_buf_size,
            unpack,
            write_frames,
            #[cfg(feature = "vship")]
            calc_metrics,
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
fn resolve_metrics(
    is_10b: bool,
    target_quality: Option<&str>,
) -> (ComputeMetricFn, bool, bool, CalcMetricsFn) {
    let calc: CalcMetricsFn = if is_10b {
        calc_metrics_10b
    } else {
        calc_metrics_8bit
    };

    target_quality.map_or(
        (compute_ssimulacra2 as ComputeMetricFn, false, false, calc),
        |tq| {
            let tq_parts: Vec<f64> = tq.split('-').filter_map(|s| s.parse().ok()).collect();
            let tq_target = f64::midpoint(tq_parts[0], tq_parts[1]);

            let use_butteraugli = tq_target < 8.0;
            let use_cvvdp = tq_target > 8.0 && tq_target <= 10.0;

            let compute = if use_butteraugli {
                compute_butteraugli as ComputeMetricFn
            } else if use_cvvdp {
                compute_cvvdp as ComputeMetricFn
            } else {
                compute_ssimulacra2 as ComputeMetricFn
            };

            (compute, use_cvvdp, use_butteraugli, calc)
        },
    )
}

#[cfg(feature = "vship")]
fn compute_ssimulacra2(
    vship: &VshipProcessor,
    input_planes: [*const u8; 3],
    output_planes: [*const u8; 3],
    input_strides: [i64; 3],
    output_strides: [i64; 3],
) -> f64 {
    unsafe {
        vship
            .compute_ssimulacra2(input_planes, output_planes, input_strides, output_strides)
            .unwrap_unchecked()
    }
}

#[cfg(feature = "vship")]
fn compute_butteraugli(
    vship: &VshipProcessor,
    input_planes: [*const u8; 3],
    output_planes: [*const u8; 3],
    input_strides: [i64; 3],
    output_strides: [i64; 3],
) -> f64 {
    unsafe {
        vship
            .compute_butteraugli(input_planes, output_planes, input_strides, output_strides)
            .unwrap_unchecked()
    }
}

#[cfg(feature = "vship")]
fn compute_cvvdp(
    vship: &VshipProcessor,
    input_planes: [*const u8; 3],
    output_planes: [*const u8; 3],
    input_strides: [i64; 3],
    output_strides: [i64; 3],
) -> f64 {
    unsafe {
        vship
            .compute_cvvdp(input_planes, output_planes, input_strides, output_strides)
            .unwrap_unchecked()
    }
}
