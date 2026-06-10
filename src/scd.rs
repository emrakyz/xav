use std::{
    cmp::min,
    fmt::Write as _,
    fs::write as fs_write,
    mem::size_of,
    path::Path,
    slice::from_raw_parts,
    sync::{Arc, Mutex},
    thread::available_parallelism,
};

use av_scenechange::{
    VideoDetails, detect_scene_changes,
    frame::{Pixel, Plane},
};

use crate::{
    error::Xerr,
    ffms::{VidDecoder, VidInf},
    pack::shift_p010_rem,
    progs::ProgsBar,
};

fn build_luma_frame<T: Pixel>(
    dec: &mut VidDecoder,
    w: usize,
    h: usize,
    crop_v: usize,
    crop_h: usize,
) -> Option<Plane<T>> {
    let vf = dec.dec_next();
    if dec.is_eof() {
        return None;
    }
    let mut frame = Plane::<T>::new(w, h);
    unsafe {
        let stride = (*vf).linesize[0] as usize;
        let bpp = size_of::<T>();
        let src = from_raw_parts(
            (*vf).data[0].add(crop_v * stride + crop_h * bpp),
            stride * h,
        );
        frame.copy_from_u8_with_stride(src, stride);
    }
    Some(frame)
}

fn build_luma_frame_p010(
    dec: &mut VidDecoder,
    w: usize,
    h: usize,
    crop_v: usize,
    crop_h: usize,
) -> Option<Plane<u16>> {
    let vf = dec.dec_next();
    if dec.is_eof() {
        return None;
    }
    let mut frame = Plane::<u16>::new(w, h);
    unsafe {
        let stride = (*vf).linesize[0] as usize;
        let base = (*vf).data[0].add(crop_v * stride + crop_h * size_of::<u16>());
        for (row, dst) in frame.data_mut().chunks_exact_mut(w).enumerate() {
            let src = from_raw_parts(base.add(row * stride).cast::<u16>(), w);
            shift_p010_rem(src, dst);
        }
    }
    Some(frame)
}

pub fn fd_scenes(
    vid_path: &Path,
    sc_file: &Path,
    inf: &VidInf,
    crop: (u32, u32),
    line: usize,
    hwdec: bool,
) -> Result<(), Xerr> {
    let max_dist = 300;
    let tot_frames = inf.frames;
    let (cv, ch) = crop;
    let cropped_w = inf.width - ch * 2;
    let cropped_h = inf.height - cv * 2;

    let thr = unsafe { available_parallelism().unwrap_unchecked().get() as i32 };
    let mut dec = if hwdec {
        VidDecoder::new_hw(vid_path, thr)
    } else {
        VidDecoder::new(vid_path, thr)
    }
    .map_err(|e| e.to_string())?;

    let details = VideoDetails {
        bit_depth: if inf.is_10b { 10 } else { 8 },
    };

    let progs = Arc::new(Mutex::new(ProgsBar::new()));

    let progs_callback = {
        let progs_clone = Arc::clone(&progs);
        move |current: usize, _keyframes: usize| {
            if let Ok(mut pb) = progs_clone.lock() {
                pb.up_frames(current, tot_frames, line, "SCD");
            }
        }
    };

    let w = cropped_w as usize;
    let h = cropped_h as usize;
    let crop_v = cv as usize;
    let crop_h = ch as usize;

    let results = if inf.is_10b {
        detect_scene_changes::<u16, _>(&details, None, Some(&progs_callback), || {
            if hwdec {
                build_luma_frame_p010(&mut dec, w, h, crop_v, crop_h)
            } else {
                build_luma_frame::<u16>(&mut dec, w, h, crop_v, crop_h)
            }
        })
    } else {
        detect_scene_changes::<u8, _>(&details, None, Some(&progs_callback), || {
            build_luma_frame::<u8>(&mut dec, w, h, crop_v, crop_h)
        })
    };

    if let Ok(mut pb) = progs.lock() {
        pb.up_frames(tot_frames, tot_frames, line, "SCD");
    }

    let mut scores: Vec<Option<(f32, f32)>> = vec![None; tot_frames];
    for (k, v) in results.scores {
        if k < tot_frames {
            scores[k] = Some((v.inter_cost as f32, v.threshold as f32));
        }
    }

    let new_scenes = refine_scenes(&results.scene_changes, tot_frames, max_dist, &scores);

    let mut content = String::new();
    for &scene_frame in &new_scenes {
        _ = writeln!(content, "{scene_frame}");
    }

    fs_write(sc_file, content)?;

    Ok(())
}

fn refine_scenes(
    scene_changes: &[usize],
    tot_frames: usize,
    max_dist: usize,
    scores: &[Option<(f32, f32)>],
) -> Vec<usize> {
    let mut new_scenes = vec![0];
    let mut last = 0;

    for (i, &s_frame) in scene_changes.iter().enumerate() {
        let e_frame = scene_changes.get(i + 1).copied().unwrap_or(tot_frames);
        let mut current_start = s_frame.max(last);
        let mut distance = e_frame - current_start;

        while distance > max_dist {
            let minimum_split_cnt = distance / max_dist;
            let middle_point = distance / (minimum_split_cnt + 1);
            let min_sz = middle_point / 2;
            let max_sz = min(max_dist, middle_point + min_sz);
            let range_sz = max_sz - min_sz;

            let split_point = (min_sz..=max_sz)
                .filter_map(|size| {
                    scores[current_start + size].map(|(inter_cost, threshold)| {
                        let inter_score = inter_cost / threshold;
                        let dist_from_mid = middle_point.abs_diff(size) as f32;
                        let weight = 1.0 - dist_from_mid / range_sz as f32;
                        (size, inter_score * weight)
                    })
                })
                .max_by_key(|&(_, score)| (score * 10000.0).round() as u64)
                .map_or(middle_point, |(size, _)| size);

            current_start += split_point;
            new_scenes.push(current_start);
            distance = e_frame - current_start;
        }

        new_scenes.push(e_frame);
        last = e_frame;
    }

    if new_scenes.last() == Some(&tot_frames) {
        new_scenes.pop();
    }

    new_scenes
}
