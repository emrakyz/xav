use std::path::Path;

use crate::{
    error::Xerr,
    ffms::{self, VidInf, VideoDecoder},
};

#[derive(Debug, Clone)]
pub struct CropDetectConfig {
    pub sample_count: usize,
    pub min_black_pixels: usize,
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

    pub const fn has_crop(&self) -> bool {
        self.top > 0 || self.bottom > 0 || self.left > 0 || self.right > 0
    }

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

pub fn detect_crop(
    path: &Path,
    inf: &VidInf,
    config: &CropDetectConfig,
    threads: i32,
) -> Result<CropResult, Xerr> {
    let mut dec = VideoDecoder::new(path, threads)?;
    let frame_indices = calculate_sample_frames(inf.frames, config.sample_count);

    let mut best = CropResult {
        top: u32::MAX,
        bottom: u32::MAX,
        left: u32::MAX,
        right: u32::MAX,
    };

    for &frame_idx in &frame_indices {
        dec.seek_near(frame_idx);
        let frame = dec.frame_ref();
        if let Some(crop) = detect_frame_crop(frame, inf, config.min_black_pixels) {
            update_best(&mut best, crop);
            if best.top <= 1 && best.bottom <= 1 && best.left <= 1 && best.right <= 1 {
                return Ok(CropResult::no_crop());
            }
        }
    }

    if best.top == u32::MAX {
        return Ok(CropResult::no_crop());
    }

    Ok(CropResult {
        top: prev_multiple_of_2(best.top),
        bottom: prev_multiple_of_2(best.bottom),
        left: prev_multiple_of_2(best.left),
        right: prev_multiple_of_2(best.right),
    })
}

#[inline]
const fn update_best(best: &mut CropResult, crop: CropResult) {
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

fn calculate_sample_frames(total_frames: usize, sample_count: usize) -> Vec<usize> {
    if total_frames <= sample_count {
        return (0..total_frames).collect();
    }

    let mut frames = Vec::with_capacity(sample_count);
    let step = total_frames as f64 / (sample_count + 1) as f64;

    for i in 1..=sample_count {
        let frame_idx = (i as f64 * step).round() as usize;
        frames.push(frame_idx.min(total_frames - 1));
    }

    frames
}

fn detect_frame_crop(
    frame: *const ffms::VidFrame,
    inf: &VidInf,
    min_pixels: usize,
) -> Option<CropResult> {
    unsafe {
        let f = &*frame;
        let y_data = f.data[0];
        let y_stride = f.linesize[0] as usize;
        let width = inf.width as usize;
        let height = inf.height as usize;

        Some(CropResult {
            top: detect_top_crop(y_data, width, height, y_stride, min_pixels, inf.is_10b)?,
            bottom: detect_bottom_crop(y_data, width, height, y_stride, min_pixels, inf.is_10b)?,
            left: detect_left_crop(y_data, width, height, y_stride, min_pixels, inf.is_10b)?,
            right: detect_right_crop(y_data, width, height, y_stride, min_pixels, inf.is_10b)?,
        })
    }
}

#[inline]
unsafe fn read_pixel(row_start: *const u8, col: usize, is_10b: bool, black_clamp: u16) -> u16 {
    let val = unsafe {
        if is_10b {
            u16::from_le_bytes([*row_start.add(col * 2), *row_start.add(col * 2 + 1)])
        } else {
            u16::from(*row_start.add(col))
        }
    };
    if val < black_clamp { black_clamp } else { val }
}

#[inline]
const fn get_thresholds(is_10b: bool) -> (u16, u16, u16) {
    if is_10b { (128, 64, 64) } else { (32, 16, 16) }
}

unsafe fn detect_top_crop(
    data: *const u8,
    width: usize,
    height: usize,
    stride: usize,
    _min_pixels: usize,
    is_10b: bool,
) -> Option<u32> {
    let (dark_threshold, variance_threshold, black_clamp) = get_thresholds(is_10b);

    for row in 0..height {
        let row_start = unsafe { data.add(row * stride) };
        let mut sum = 0u64;

        for col in 0..width {
            let pixel_value = unsafe { read_pixel(row_start, col, is_10b, black_clamp) };
            sum += u64::from(pixel_value);
        }

        let avg = (sum / width as u64) as u16;
        if avg >= dark_threshold {
            return Some(row as u32);
        }

        for col in 0..width {
            let pixel_value = unsafe { read_pixel(row_start, col, is_10b, black_clamp) };
            if pixel_value.abs_diff(avg) > variance_threshold {
                return Some(row as u32);
            }
        }
    }

    None
}

unsafe fn detect_bottom_crop(
    data: *const u8,
    width: usize,
    height: usize,
    stride: usize,
    _min_pixels: usize,
    is_10b: bool,
) -> Option<u32> {
    let (dark_threshold, variance_threshold, black_clamp) = get_thresholds(is_10b);

    for row in (0..height).rev() {
        let row_start = unsafe { data.add(row * stride) };
        let mut sum = 0u64;

        for col in 0..width {
            let pixel_value = unsafe { read_pixel(row_start, col, is_10b, black_clamp) };
            sum += u64::from(pixel_value);
        }

        let avg = (sum / width as u64) as u16;
        if avg >= dark_threshold {
            return Some((height - 1 - row) as u32);
        }

        for col in 0..width {
            let pixel_value = unsafe { read_pixel(row_start, col, is_10b, black_clamp) };
            if pixel_value.abs_diff(avg) > variance_threshold {
                return Some((height - 1 - row) as u32);
            }
        }
    }

    None
}

unsafe fn detect_left_crop(
    data: *const u8,
    width: usize,
    height: usize,
    stride: usize,
    _min_pixels: usize,
    is_10b: bool,
) -> Option<u32> {
    let (dark_threshold, variance_threshold, black_clamp) = get_thresholds(is_10b);

    for col in 0..width {
        let mut sum = 0u64;

        for row in 0..height {
            let row_start = unsafe { data.add(row * stride) };
            let pixel_value = unsafe { read_pixel(row_start, col, is_10b, black_clamp) };
            sum += u64::from(pixel_value);
        }

        let avg = (sum / height as u64) as u16;
        if avg >= dark_threshold {
            return Some(col as u32);
        }

        for row in 0..height {
            let row_start = unsafe { data.add(row * stride) };
            let pixel_value = unsafe { read_pixel(row_start, col, is_10b, black_clamp) };
            if pixel_value.abs_diff(avg) > variance_threshold {
                return Some(col as u32);
            }
        }
    }

    None
}

unsafe fn detect_right_crop(
    data: *const u8,
    width: usize,
    height: usize,
    stride: usize,
    _min_pixels: usize,
    is_10b: bool,
) -> Option<u32> {
    let (dark_threshold, variance_threshold, black_clamp) = get_thresholds(is_10b);

    for col in (0..width).rev() {
        let mut sum = 0u64;

        for row in 0..height {
            let row_start = unsafe { data.add(row * stride) };
            let pixel_value = unsafe { read_pixel(row_start, col, is_10b, black_clamp) };
            sum += u64::from(pixel_value);
        }

        let avg = (sum / height as u64) as u16;
        if avg >= dark_threshold {
            return Some((width - 1 - col) as u32);
        }

        for row in 0..height {
            let row_start = unsafe { data.add(row * stride) };
            let pixel_value = unsafe { read_pixel(row_start, col, is_10b, black_clamp) };
            if pixel_value.abs_diff(avg) > variance_threshold {
                return Some((width - 1 - col) as u32);
            }
        }
    }

    None
}

const fn prev_multiple_of_2(n: u32) -> u32 {
    n & !1
}
