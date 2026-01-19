use std::sync::Arc;

use ffms2_sys::FFMS_VideoSource;

use crate::ffms::{VidIdx, VidInf, destroy_vid_src};

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
        Self { top: 0, bottom: 0, left: 0, right: 0 }
    }

    pub const fn has_crop(&self) -> bool {
        self.top > 0 || self.bottom > 0 || self.left > 0 || self.right > 0
    }

    pub const fn to_tuple(self) -> (u32, u32) {
        let v = if self.top < self.bottom { self.top } else { self.bottom };
        let h = if self.left < self.right { self.left } else { self.right };

        let v_even = v & !1;
        let h_even = h & !1;

        (v_even, h_even)
    }
}

pub fn detect_crop(
    idx: &Arc<VidIdx>,
    inf: &VidInf,
    config: &CropDetectConfig,
) -> Result<CropResult, Box<dyn std::error::Error>> {
    unsafe {
        let source = std::ffi::CString::new(idx.path.as_str())?;
        let mut err = std::mem::zeroed::<ffms2_sys::FFMS_ErrorInfo>();

        let threads =
            std::thread::available_parallelism().map_or(8, |n| n.get().try_into().unwrap_or(8));

        let src = ffms2_sys::FFMS_CreateVideoSource(
            source.as_ptr(),
            idx.track,
            idx.idx_handle,
            threads,
            1,
            std::ptr::addr_of_mut!(err),
        );

        if src.is_null() {
            return Err("Failed to create video source".into());
        }

        let frame_indices = calculate_sample_frames(inf.frames, config.sample_count);

        let mut crop_samples = Vec::with_capacity(frame_indices.len());
        for &frame_idx in &frame_indices {
            if let Some(crop) = detect_frame_crop(src, frame_idx, inf, config.min_black_pixels) {
                crop_samples.push(crop);
            }
        }

        destroy_vid_src(src);

        let result = min_crop(&crop_samples);

        Ok(result)
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
    src: *mut FFMS_VideoSource,
    frame_idx: usize,
    inf: &VidInf,
    min_pixels: usize,
) -> Option<CropResult> {
    let frame = crate::ffms::get_frame(src, frame_idx).ok()?;

    unsafe {
        let y_data = (*frame).Data[0];
        let y_stride = (*frame).Linesize[0] as usize;
        let width = inf.width as usize;
        let height = inf.height as usize;

        Some(CropResult {
            top: detect_top_crop(y_data, width, height, y_stride, min_pixels, inf.is_10bit)?,
            bottom: detect_bottom_crop(y_data, width, height, y_stride, min_pixels, inf.is_10bit)?,
            left: detect_left_crop(y_data, width, height, y_stride, min_pixels, inf.is_10bit)?,
            right: detect_right_crop(y_data, width, height, y_stride, min_pixels, inf.is_10bit)?,
        })
    }
}

#[inline]
unsafe fn read_pixel(row_start: *const u8, col: usize, is_10bit: bool, black_clamp: u16) -> u16 {
    let val = unsafe {
        if is_10bit {
            u16::from_le_bytes([*row_start.add(col * 2), *row_start.add(col * 2 + 1)])
        } else {
            u16::from(*row_start.add(col))
        }
    };
    if val < black_clamp { black_clamp } else { val }
}

#[inline]
const fn get_thresholds(is_10bit: bool) -> (u16, u16, u16) {
    if is_10bit { (128, 64, 64) } else { (32, 16, 16) }
}

unsafe fn detect_top_crop(
    data: *const u8,
    width: usize,
    height: usize,
    stride: usize,
    _min_pixels: usize,
    is_10bit: bool,
) -> Option<u32> {
    let (dark_threshold, variance_threshold, black_clamp) = get_thresholds(is_10bit);

    for row in 0..height {
        let row_start = unsafe { data.add(row * stride) };
        let mut sum = 0u64;

        for col in 0..width {
            let pixel_value = unsafe { read_pixel(row_start, col, is_10bit, black_clamp) };
            sum += u64::from(pixel_value);
        }

        let avg = (sum / width as u64) as u16;
        if avg >= dark_threshold {
            return Some(row as u32);
        }

        for col in 0..width {
            let pixel_value = unsafe { read_pixel(row_start, col, is_10bit, black_clamp) };
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
    is_10bit: bool,
) -> Option<u32> {
    let (dark_threshold, variance_threshold, black_clamp) = get_thresholds(is_10bit);

    for row in (0..height).rev() {
        let row_start = unsafe { data.add(row * stride) };
        let mut sum = 0u64;

        for col in 0..width {
            let pixel_value = unsafe { read_pixel(row_start, col, is_10bit, black_clamp) };
            sum += u64::from(pixel_value);
        }

        let avg = (sum / width as u64) as u16;
        if avg >= dark_threshold {
            return Some((height - 1 - row) as u32);
        }

        for col in 0..width {
            let pixel_value = unsafe { read_pixel(row_start, col, is_10bit, black_clamp) };
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
    is_10bit: bool,
) -> Option<u32> {
    let (dark_threshold, variance_threshold, black_clamp) = get_thresholds(is_10bit);

    for col in 0..width {
        let mut sum = 0u64;

        for row in 0..height {
            let row_start = unsafe { data.add(row * stride) };
            let pixel_value = unsafe { read_pixel(row_start, col, is_10bit, black_clamp) };
            sum += u64::from(pixel_value);
        }

        let avg = (sum / height as u64) as u16;
        if avg >= dark_threshold {
            return Some(col as u32);
        }

        for row in 0..height {
            let row_start = unsafe { data.add(row * stride) };
            let pixel_value = unsafe { read_pixel(row_start, col, is_10bit, black_clamp) };
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
    is_10bit: bool,
) -> Option<u32> {
    let (dark_threshold, variance_threshold, black_clamp) = get_thresholds(is_10bit);

    for col in (0..width).rev() {
        let mut sum = 0u64;

        for row in 0..height {
            let row_start = unsafe { data.add(row * stride) };
            let pixel_value = unsafe { read_pixel(row_start, col, is_10bit, black_clamp) };
            sum += u64::from(pixel_value);
        }

        let avg = (sum / height as u64) as u16;
        if avg >= dark_threshold {
            return Some((width - 1 - col) as u32);
        }

        for row in 0..height {
            let row_start = unsafe { data.add(row * stride) };
            let pixel_value = unsafe { read_pixel(row_start, col, is_10bit, black_clamp) };
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

fn min_crop(samples: &[CropResult]) -> CropResult {
    if samples.is_empty() {
        return CropResult::no_crop();
    }

    CropResult {
        top: prev_multiple_of_2(samples.iter().map(|c| c.top).min().unwrap_or(0)),
        bottom: prev_multiple_of_2(samples.iter().map(|c| c.bottom).min().unwrap_or(0)),
        left: prev_multiple_of_2(samples.iter().map(|c| c.left).min().unwrap_or(0)),
        right: prev_multiple_of_2(samples.iter().map(|c| c.right).min().unwrap_or(0)),
    }
}
