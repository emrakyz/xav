#[cfg(feature = "vship")]
use crate::progs::ProgsTrack;
use crate::{
    ffms::{
        DecStrat,
        DecStrat::{
            B8Crop, B8CropFast, B10Crop, B10CropFast, B10CropFastRem, B10CropRem, B10RawCrop,
            B10RawCropFast, HwNv12Crop, HwNv12CropTo10, HwP010CropPack, HwP010CropPackPkRem,
            HwP010RawCrop,
        },
        VidInf,
    },
    pack::{SHIFT_CHUNK, UNPACK_CHUNK, calc_8b_sz, calc_packed_sz},
};

#[cfg(feature = "vship")]
pub struct MetricProgs<'a> {
    pub prog: &'a ProgsTrack,
    pub slot: usize,
    pub crf: f32,
    pub last_score: Option<f32>,
}

#[derive(Clone, Copy)]
pub struct Planes {
    pub y_sz: usize,
    pub uv_sz: usize,
    pub cr_off: usize,
    pub frame_sz: usize,
    pub y_stride: usize,
    pub c_stride: usize,
}

impl Planes {
    const fn new(w: usize, h: usize, pix_sz: usize) -> Self {
        let y_stride = w * pix_sz;
        let c_stride = w / 2 * pix_sz;
        let y_sz = y_stride * h;
        let uv_sz = c_stride * (h / 2);
        Self {
            y_sz,
            uv_sz,
            cr_off: y_sz + uv_sz,
            frame_sz: y_sz + uv_sz * 2,
            y_stride,
            c_stride,
        }
    }
}

#[derive(Clone)]
pub struct Pipeline {
    pub final_w: usize,
    pub final_h: usize,
    pub half_w: usize,
    pub half_h: usize,
    pub frame_sz: usize,
    pub met: Planes,
    pub enc: Planes,
    pub conv_buf_sz: usize,
    #[cfg(feature = "vship")]
    pub unpack_buf_sz: usize,
    #[cfg(feature = "vship")]
    pub met_strides: [i64; 3],
    pub conv_iters: usize,
    pub unpack_iters: usize,
    pub nv12_y_iters: usize,
    pub nv12_c_iters: usize,
}

impl Pipeline {
    #[must_use]
    pub const fn new(inf: &VidInf, strat: &DecStrat) -> Self {
        let (final_w, final_h) = match *strat {
            B10Crop { ref cc }
            | B10CropRem { ref cc }
            | B10CropFast { ref cc }
            | B10CropFastRem { ref cc }
            | B8Crop { ref cc }
            | B8CropFast { ref cc }
            | B10RawCrop { ref cc }
            | B10RawCropFast { ref cc }
            | HwNv12Crop { ref cc }
            | HwNv12CropTo10 { ref cc }
            | HwP010RawCrop { ref cc }
            | HwP010CropPack { ref cc }
            | HwP010CropPackPkRem { ref cc } => (cc.new_w as usize, cc.new_h as usize),
            _ => (inf.width as usize, inf.height as usize),
        };

        let is_raw = strat.is_raw();
        let frame_sz = if is_raw {
            final_w * final_h * 3
        } else if inf.is_10b {
            calc_packed_sz(final_w as u32, final_h as u32)
        } else {
            calc_8b_sz(final_w as u32, final_h as u32)
        };

        let is_10b_out = inf.is_10b;
        let pix_sz = if is_10b_out { 2 } else { 1 };
        let met = Planes::new(final_w, final_h, pix_sz);
        let enc = Planes::new(final_w, final_h, 2);

        let conv_buf_sz = if is_raw { 0 } else { enc.frame_sz };

        #[cfg(feature = "vship")]
        let unpack_buf_sz = if is_10b_out { conv_buf_sz } else { 0 };
        #[cfg(feature = "vship")]
        let met_strides = [
            met.y_stride as i64,
            met.c_stride as i64,
            met.c_stride as i64,
        ];

        Self {
            final_w,
            final_h,
            half_w: final_w / 2,
            half_h: final_h / 2,
            frame_sz,
            met,
            enc,
            conv_buf_sz,
            #[cfg(feature = "vship")]
            unpack_buf_sz,
            #[cfg(feature = "vship")]
            met_strides,
            conv_iters: frame_sz / SHIFT_CHUNK,
            unpack_iters: frame_sz / UNPACK_CHUNK,
            nv12_y_iters: met.y_sz / SHIFT_CHUNK,
            nv12_c_iters: met.uv_sz / (2 * SHIFT_CHUNK),
        }
    }
}
