use std::process::ChildStdin;

use crate::encode::get_frame;
use crate::ffms::{
    DecodeStrat, VidInf, calc_8bit_size, calc_packed_size, conv_to_10bit, unpack_10bit,
    unpack_10bit_rem,
};

pub type UnpackFn = fn(&[u8], &mut [u8], &Pipeline);
pub type WriteFn = fn(&mut ChildStdin, &[u8], usize, &mut [u8], &Pipeline);

const fn unpack_noop(_: &[u8], _: &mut [u8], _: &Pipeline) {}

#[cfg(feature = "vship")]
pub struct MetricsProgress<'a> {
    pub prog: &'a crate::progs::ProgsTrack,
    pub slot: usize,
    pub crf: f32,
    pub last_score: Option<f64>,
}

#[cfg(feature = "vship")]
pub type CalcMetricsFn = fn(
    &crate::worker::WorkPkg,
    &std::path::Path,
    &Pipeline,
    &crate::vship::VshipProcessor,
    &str,
    &mut [u8],
    &MetricsProgress,
) -> (f64, Vec<f64>);

#[cfg(feature = "vship")]
pub type ComputeMetricFn =
    fn(&crate::vship::VshipProcessor, [*const u8; 3], [*const u8; 3], [i64; 3], [i64; 3]) -> f64;

#[cfg(feature = "vship")]
pub type AggregateScoresFn = fn(&mut Vec<f64>) -> f64;

fn unpack_10bit_wrap(input: &[u8], output: &mut [u8], pipe: &Pipeline) {
    unpack_10bit(input, output, pipe.final_w, pipe.final_h);
}

fn unpack_10bit_rem_wrap(input: &[u8], output: &mut [u8], pipe: &Pipeline) {
    unpack_10bit_rem(input, output, pipe.final_w, pipe.final_h);
}

pub fn write_frames_10bit(
    stdin: &mut ChildStdin,
    frames: &[u8],
    frame_count: usize,
    buf: &mut [u8],
    pipe: &Pipeline,
) {
    for i in 0..frame_count {
        let frame = get_frame(frames, i, pipe.frame_size);
        (pipe.unpack)(frame, buf, pipe);
        let _ = std::io::Write::write_all(stdin, buf);
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
        conv_to_10bit(frame, buf);
        let _ = std::io::Write::write_all(stdin, buf);
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
        #[allow(unused_variables)]
        #[cfg(feature = "vship")]
        target_quality: Option<&str>,
    ) -> Self {
        let (final_w, final_h) = match strat {
            DecodeStrat::B10CropFast { cc }
            | DecodeStrat::B10CropFastRem { cc }
            | DecodeStrat::B10Crop { cc }
            | DecodeStrat::B10CropRem { cc }
            | DecodeStrat::B10CropStride { cc }
            | DecodeStrat::B10CropStrideRem { cc }
            | DecodeStrat::B8CropFast { cc }
            | DecodeStrat::B8Crop { cc }
            | DecodeStrat::B8CropStride { cc } => (cc.new_w as usize, cc.new_h as usize),
            _ => (inf.width as usize, inf.height as usize),
        };

        let frame_size = match strat {
            DecodeStrat::B10Fast
            | DecodeStrat::B10FastRem
            | DecodeStrat::B10Stride
            | DecodeStrat::B10StrideRem
            | DecodeStrat::B10CropFast { .. }
            | DecodeStrat::B10CropFastRem { .. }
            | DecodeStrat::B10Crop { .. }
            | DecodeStrat::B10CropRem { .. }
            | DecodeStrat::B10CropStride { .. }
            | DecodeStrat::B10CropStrideRem { .. } => {
                calc_packed_size(final_w as u32, final_h as u32)
            }
            DecodeStrat::B8Fast
            | DecodeStrat::B8Stride
            | DecodeStrat::B8CropFast { .. }
            | DecodeStrat::B8Crop { .. }
            | DecodeStrat::B8CropStride { .. } => calc_8bit_size(final_w as u32, final_h as u32),
        };

        let pixel_size = if inf.is_10bit { 2 } else { 1 };
        let y_size = final_w * final_h * pixel_size;
        let uv_size = y_size / 4;
        let conv_buf_size = final_w * final_h * 3 / 2 * 2;

        let has_rem = inf.is_10bit && (final_w % 8) != 0;

        let (unpack, write_frames): (UnpackFn, WriteFn) = if !inf.is_10bit {
            (unpack_noop, write_frames_8bit)
        } else if has_rem {
            (unpack_10bit_rem_wrap, write_frames_10bit)
        } else {
            (unpack_10bit_wrap, write_frames_10bit)
        };

        #[cfg(feature = "vship")]
        let (compute_metric, reset_cvvdp, sort_descending, calc_metrics): (
            ComputeMetricFn,
            bool,
            bool,
            CalcMetricsFn,
        ) = target_quality.map_or_else(
            || {
                let calc: CalcMetricsFn = if inf.is_10bit {
                    crate::tq::calc_metrics_10bit
                } else {
                    crate::tq::calc_metrics_8bit
                };
                (compute_ssimulacra2 as ComputeMetricFn, false, false, calc)
            },
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

                let calc: CalcMetricsFn = if inf.is_10bit {
                    crate::tq::calc_metrics_10bit
                } else {
                    crate::tq::calc_metrics_8bit
                };

                (compute, use_cvvdp, use_butteraugli, calc)
            },
        );

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
fn compute_ssimulacra2(
    vship: &crate::vship::VshipProcessor,
    input_planes: [*const u8; 3],
    output_planes: [*const u8; 3],
    input_strides: [i64; 3],
    output_strides: [i64; 3],
) -> f64 {
    vship.compute_ssimulacra2(input_planes, output_planes, input_strides, output_strides).unwrap()
}

#[cfg(feature = "vship")]
fn compute_butteraugli(
    vship: &crate::vship::VshipProcessor,
    input_planes: [*const u8; 3],
    output_planes: [*const u8; 3],
    input_strides: [i64; 3],
    output_strides: [i64; 3],
) -> f64 {
    vship.compute_butteraugli(input_planes, output_planes, input_strides, output_strides).unwrap()
}

#[cfg(feature = "vship")]
fn compute_cvvdp(
    vship: &crate::vship::VshipProcessor,
    input_planes: [*const u8; 3],
    output_planes: [*const u8; 3],
    input_strides: [i64; 3],
    output_strides: [i64; 3],
) -> f64 {
    vship.compute_cvvdp(input_planes, output_planes, input_strides, output_strides).unwrap()
}
