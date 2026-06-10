fn calc_samp_frames(tot_frames: usize, sample_cnt: usize) -> Vec<u32> {
    if tot_frames <= sample_cnt {
        return (0..tot_frames as u32).collect();
    }

    let mut frames = Vec::with_capacity(sample_cnt);
    let step = tot_frames as f32 / (sample_cnt + 1) as f32;

    for i in 1..=sample_cnt {
        let frame_idx = (i as f32 * step).round() as u32;
        frames.push(frame_idx.min(tot_frames as u32 - 1));
    }

    frames
}

fn detect_frame_crop(
    frame: *const VidFrame,
    inf: &VidInf,
    min_pix: usize,
) -> Option<CropResult> {
    unsafe {
        let f = &*frame;
        let y_data = f.data[0];
        let y_stride = f.linesize[0] as usize;
        let width = inf.width as usize;
        let height = inf.height as usize;

        Some(CropResult {
            top: detect_top_crop(y_data, width, height, y_stride, min_pix, inf.is_10b)?,
            bottom: detect_bottom_crop(y_data, width, height, y_stride, min_pix, inf.is_10b)?,
            left: detect_left_crop(y_data, width, height, y_stride, min_pix, inf.is_10b)?,
            right: detect_right_crop(y_data, width, height, y_stride, min_pix, inf.is_10b)?,
        })
    }
}

#[inline(always)]
unsafe fn read_pix(row_start: *const u8, col: usize, is_10b: bool, black_clamp: u16) -> u16 {
    let val = unsafe {
        if is_10b {
            u16::from_le_bytes([*row_start.add(col * 2), *row_start.add(col * 2 + 1)])
        } else {
            u16::from(*row_start.add(col))
        }
    };
    if val < black_clamp { black_clamp } else { val }
}

#[inline(always)]
const fn get_thresh(is_10b: bool) -> (u16, u16, u16) {
    if is_10b { (128, 64, 64) } else { (32, 16, 16) }
}

unsafe fn detect_top_crop(
    data: *const u8,
    width: usize,
    height: usize,
    stride: usize,
    _min_pix: usize,
    is_10b: bool,
) -> Option<u32> {
    let (dark_threshold, variance_threshold, black_clamp) = get_thresh(is_10b);

    for row in 0..height {
        let row_start = unsafe { data.add(row * stride) };
        let mut sum = 0u64;

        for col in 0..width {
            let pix_value = unsafe { read_pix(row_start, col, is_10b, black_clamp) };
            sum += u64::from(pix_value);
        }

        let avg = (sum / width as u64) as u16;
        if avg >= dark_threshold {
            return Some(row as u32);
        }

        for col in 0..width {
            let pix_value = unsafe { read_pix(row_start, col, is_10b, black_clamp) };
            if pix_value.abs_diff(avg) > variance_threshold {
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
    _min_pix: usize,
    is_10b: bool,
) -> Option<u32> {
    let (dark_threshold, variance_threshold, black_clamp) = get_thresh(is_10b);

    for row in (0..height).rev() {
        let row_start = unsafe { data.add(row * stride) };
        let mut sum = 0u64;

        for col in 0..width {
            let pix_value = unsafe { read_pix(row_start, col, is_10b, black_clamp) };
            sum += u64::from(pix_value);
        }

        let avg = (sum / width as u64) as u16;
        if avg >= dark_threshold {
            return Some((height - 1 - row) as u32);
        }

        for col in 0..width {
            let pix_value = unsafe { read_pix(row_start, col, is_10b, black_clamp) };
            if pix_value.abs_diff(avg) > variance_threshold {
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
    _min_pix: usize,
    is_10b: bool,
) -> Option<u32> {
    let (dark_threshold, variance_threshold, black_clamp) = get_thresh(is_10b);

    for col in 0..width {
        let mut sum = 0u64;

        for row in 0..height {
            let row_start = unsafe { data.add(row * stride) };
            let pix_value = unsafe { read_pix(row_start, col, is_10b, black_clamp) };
            sum += u64::from(pix_value);
        }

        let avg = (sum / height as u64) as u16;
        if avg >= dark_threshold {
            return Some(col as u32);
        }

        for row in 0..height {
            let row_start = unsafe { data.add(row * stride) };
            let pix_value = unsafe { read_pix(row_start, col, is_10b, black_clamp) };
            if pix_value.abs_diff(avg) > variance_threshold {
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
    _min_pix: usize,
    is_10b: bool,
) -> Option<u32> {
    let (dark_threshold, variance_threshold, black_clamp) = get_thresh(is_10b);

    for col in (0..width).rev() {
        let mut sum = 0u64;

        for row in 0..height {
            let row_start = unsafe { data.add(row * stride) };
            let pix_value = unsafe { read_pix(row_start, col, is_10b, black_clamp) };
            sum += u64::from(pix_value);
        }

        let avg = (sum / height as u64) as u16;
        if avg >= dark_threshold {
            return Some((width - 1 - col) as u32);
        }

        for row in 0..height {
            let row_start = unsafe { data.add(row * stride) };
            let pix_value = unsafe { read_pix(row_start, col, is_10b, black_clamp) };
            if pix_value.abs_diff(avg) > variance_threshold {
                return Some((width - 1 - col) as u32);
            }
        }
    }

    None
}
