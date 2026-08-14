#[cfg(all(target_os = "linux", feature = "vship"))]
use alloc::vec::Vec;
use core::slice::from_raw_parts;

#[cfg(feature = "vship")]
use crate::progs::ProgsTrack;
use crate::{
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
    io::Write as _,
    pack::{
        PACK_CHUNK, SHIFT_CHUNK, UNPACK_CHUNK, calc_8b_sz, calc_packed_sz, conv_10b, conv_10b_rem,
        unpack_10b, unpack_10b_rem,
    },
    process::ChildStdin,
    util::assume_unreachable,
};

pub type WriteFn = fn(&mut ChildStdin, &[u8], usize, &mut [u8], &Pipeline);

#[cfg(feature = "vship")]
pub struct MetricProgs<'a> {
    pub prog: &'a ProgsTrack,
    pub slot: usize,
    pub crf: f32,
    pub last_score: Option<f32>,
}

macro_rules! make_write_frames {
    ($name:ident, $conv:expr) => {
        pub fn $name(
            stdin: &mut ChildStdin,
            frames: &[u8],
            frame_cnt: usize,
            buf: &mut [u8],
            pipe: &Pipeline,
        ) {
            let (fw, fh) = (pipe.final_w, pipe.final_h);
            let frame_sz = pipe.frame_sz;
            let mut src = frames.as_ptr();
            for _ in 0..frame_cnt {
                ($conv)(unsafe { from_raw_parts(src, frame_sz) }, buf, fw, fh);
                src = unsafe { src.add(frame_sz) };
                _ = stdin.write_all(buf);
            }
        }
    };
}

make_write_frames!(
    write_frames_8b,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| conv_10b(f, b)
);
make_write_frames!(
    write_frames_8b_rem,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| conv_10b_rem(f, b)
);
make_write_frames!(
    write_frames_unpack,
    |f: &[u8], b: &mut [u8], _w: usize, _h: usize| unpack_10b(f, b)
);
make_write_frames!(
    write_frames_unpack_rem,
    |f: &[u8], b: &mut [u8], w: usize, h: usize| unpack_10b_rem(f, b, w, h)
);
make_write_frames!(
    write_frames_nv12,
    |f: &[u8], b: &mut [u8], w: usize, h: usize| nv12_10b(f, b, w, h)
);
make_write_frames!(
    write_frames_nv12_rem,
    |f: &[u8], b: &mut [u8], w: usize, h: usize| nv12_10b_rem(f, b, w, h)
);

const fn write_frames_raw(_: &mut ChildStdin, _: &[u8], _: usize, _: &mut [u8], _: &Pipeline) {
    assume_unreachable();
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
    pub write_frames: WriteFn,
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

        let write_frames: WriteFn = if is_nv12_10 {
            let y_ok = (final_w * final_h).is_multiple_of(SHIFT_CHUNK);
            let uv_ok = (final_w / 2 * (final_h / 2)).is_multiple_of(SHIFT_CHUNK * 2);
            if y_ok && uv_ok {
                write_frames_nv12
            } else {
                write_frames_nv12_rem
            }
        } else if is_raw {
            write_frames_raw
        } else if !is_10b_out {
            if frame_sz.is_multiple_of(SHIFT_CHUNK) {
                write_frames_8b
            } else {
                write_frames_8b_rem
            }
        } else if has_rem {
            write_frames_unpack_rem
        } else {
            write_frames_unpack
        };

        #[cfg(feature = "vship")]
        let (reset_cvvdp, sort_descending) = resolve_metric(tq);

        Self {
            final_w,
            final_h,
            frame_sz,
            y_sz,
            uv_sz,
            conv_buf_sz,
            #[cfg(feature = "vship")]
            unpack_buf_sz,
            write_frames,
            #[cfg(feature = "vship")]
            reset_cvvdp,
            #[cfg(feature = "vship")]
            sort_descending,
        }
    }
}

#[cfg(feature = "vship")]
#[cold]
fn resolve_metric(tq: Option<&str>) -> (bool, bool) {
    tq.map_or((false, false), |tq| {
        let tq_parts: Vec<f32> = tq.split('-').filter_map(|s| s.parse().ok()).collect();
        let tq_target = f32::midpoint(tq_parts[0], tq_parts[1]);
        (tq_target > 8.0 && tq_target <= 10.0, tq_target < 8.0)
    })
}

#[cfg(test)]
pub mod test_access {
    use super::*;

    pub const WRITE_RAW: WriteFn = write_frames_raw;
    pub const WRITE_8B: WriteFn = write_frames_8b;
    pub const WRITE_8B_REM: WriteFn = write_frames_8b_rem;
    pub const WRITE_UNPACK: WriteFn = write_frames_unpack;
    pub const WRITE_UNPACK_REM: WriteFn = write_frames_unpack_rem;
    pub const WRITE_NV12: WriteFn = write_frames_nv12;
    pub const WRITE_NV12_REM: WriteFn = write_frames_nv12_rem;
}
