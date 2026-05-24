use std::path::Path;

use crate::{
    error::Xerr,
    ffms::{self, VidDecoder, VidInf},
};

#[derive(Debug, Clone)]
pub struct CropConf {
    pub sample_cnt: usize,
    pub min_black_pix: usize,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct CropResult {
    pub top: u32,
    pub bottom: u32,
    pub left: u32,
    pub right: u32,
}

impl CropResult {
    pub const fn no_crop() -> Self {
        Self {
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
        }
    }

    #[inline(always)]
    pub const fn has_crop(&self) -> bool {
        self.top > 0 || self.bottom > 0 || self.left > 0 || self.right > 0
    }

    #[inline(always)]
    pub const fn to_tuple(self) -> (u32, u32) {
        let v = if self.top < self.bottom {
            self.top
        } else {
            self.bottom
        };
        let h = if self.left < self.right {
            self.left
        } else {
            self.right
        };

        let v_even = v & !1;
        let h_even = h & !1;

        (v_even, h_even)
    }
}

#[cfg(target_feature = "avx512bw")]
include!("avx512.rs");
#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
include!("avx2.rs");
#[cfg(not(any(target_feature = "avx2", target_feature = "avx512bw")))]
include!("scalar.rs");

pub fn detect_crop(
    path: &Path,
    inf: &VidInf,
    conf: &CropConf,
    threads: i32,
) -> Result<CropResult, Xerr> {
    let mut dec = VidDecoder::new(path, threads)?;
    let frame_indices = calc_samp_frames(inf.frames, conf.sample_cnt);

    let mut best = CropResult {
        top: u32::MAX,
        bottom: u32::MAX,
        left: u32::MAX,
        right: u32::MAX,
    };

    for &frame_idx in &frame_indices {
        dec.seek_near(frame_idx as usize);
        let frame = dec.frame_ref();
        if let Some(crop) = detect_frame_crop(frame, inf, conf.min_black_pix) {
            up_best(&mut best, crop);
            if best.top <= 1 && best.bottom <= 1 && best.left <= 1 && best.right <= 1 {
                return Ok(CropResult::no_crop());
            }
        }
    }

    if best.top == u32::MAX {
        return Ok(CropResult::no_crop());
    }

    Ok(CropResult {
        top: prev_even(best.top),
        bottom: prev_even(best.bottom),
        left: prev_even(best.left),
        right: prev_even(best.right),
    })
}

#[inline(always)]
const fn up_best(best: &mut CropResult, crop: CropResult) {
    if crop.top < best.top {
        best.top = crop.top;
    }
    if crop.bottom < best.bottom {
        best.bottom = crop.bottom;
    }
    if crop.left < best.left {
        best.left = crop.left;
    }
    if crop.right < best.right {
        best.right = crop.right;
    }
}

#[inline]
const fn prev_even(n: u32) -> u32 {
    n & !1
}
