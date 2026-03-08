use std::{
    cmp::min,
    fmt::Write as _,
    fs::write as fs_write,
    mem::size_of,
    num::{NonZeroU8, NonZeroUsize},
    path::Path,
    slice::from_raw_parts,
    sync::{Arc, Mutex},
    thread::available_parallelism,
};

use av_scenechange::{
    DetectionOptions, Rational32,
    SceneDetectionSpeed::Standard,
    VideoDetails, detect_scene_changes,
    v_frame::{
        chroma::ChromaSubsampling,
        frame::{Frame, FrameBuilder},
        pixel::Pixel,
    },
};

use crate::{
    error::Xerr,
    ffms::{VidInf, VideoDecoder},
    progs::ProgsBar,
};

const LUMA_PADDING: usize = 80;

fn build_luma_frame<T: Pixel>(
    dec: &mut VideoDecoder,
    w: NonZeroUsize,
    h: NonZeroUsize,
    bit_depth: NonZeroU8,
    crop_v: usize,
    crop_h: usize,
) -> Option<Frame<T>> {
    let vf = dec.decode_next();
    if dec.is_eof() {
        return None;
    }
    let mut frame = unsafe {
        FrameBuilder::new(w, h, ChromaSubsampling::Monochrome, bit_depth)
            .luma_padding_left(LUMA_PADDING)
            .luma_padding_right(LUMA_PADDING)
            .luma_padding_top(LUMA_PADDING)
            .luma_padding_bottom(LUMA_PADDING)
            .build::<T>()
            .unwrap_unchecked()
    };
    unsafe {
        let stride = NonZeroUsize::new_unchecked((*vf).linesize[0] as usize);
        let bpp = size_of::<T>();
        let src = from_raw_parts(
            (*vf).data[0].add(crop_v * stride.get() + crop_h * bpp),
            stride.get() * h.get(),
        );
        frame
            .y_plane
            .copy_from_u8_slice_with_stride(src, stride)
            .unwrap_unchecked();
    }
    Some(frame)
}

pub fn fd_scenes(
    vid_path: &Path,
    scene_file: &Path,
    inf: &VidInf,
    crop: (u32, u32),
    line: usize,
    hwaccel: bool,
) -> Result<(), Xerr> {
    let max_dist = 300;
    let tot_frames = inf.frames;
    let (cv, ch) = crop;
    let cropped_w = inf.width - ch * 2;
    let cropped_h = inf.height - cv * 2;

    let thr = unsafe { available_parallelism().unwrap_unchecked().get() as i32 };
    let mut dec = if hwaccel {
        VideoDecoder::new_hw(vid_path, thr)
    } else {
        VideoDecoder::new(vid_path, thr)
    }
    .map_err(|e| e.to_string())?;

    let details = VideoDetails {
        width: cropped_w as usize,
        height: cropped_h as usize,
        bit_depth: if inf.is_10bit { 10 } else { 8 },
        chroma_sampling: ChromaSubsampling::Yuv420,
        frame_rate: Rational32::new(inf.fps_num as i32, inf.fps_den as i32),
    };

    let opts = DetectionOptions {
        analysis_speed: Standard,
        detect_flashes: true,
        min_scenecut_distance: None,
        max_scenecut_distance: None,
        lookahead_distance: 5,
    };

    let progs = Arc::new(Mutex::new(ProgsBar::new()));

    let progs_callback = {
        let progs_clone = Arc::clone(&progs);
        move |current: usize, _keyframes: usize| {
            if let Ok(mut pb) = progs_clone.lock() {
                pb.up_scenes(current, tot_frames, line);
            }
        }
    };

    let w = unsafe { NonZeroUsize::new_unchecked(cropped_w as usize) };
    let h = unsafe { NonZeroUsize::new_unchecked(cropped_h as usize) };
    let crop_v = cv as usize;
    let crop_h = ch as usize;

    let results = if inf.is_10bit {
        let bd = unsafe { NonZeroU8::new_unchecked(10) };
        detect_scene_changes::<u16>(&details, opts, None, Some(&progs_callback), || {
            build_luma_frame::<u16>(&mut dec, w, h, bd, crop_v, crop_h)
        })
    } else {
        let bd = unsafe { NonZeroU8::new_unchecked(8) };
        detect_scene_changes::<u8>(&details, opts, None, Some(&progs_callback), || {
            build_luma_frame::<u8>(&mut dec, w, h, bd, crop_v, crop_h)
        })
    };

    if let Ok(mut pb) = progs.lock() {
        pb.up_scenes_final(tot_frames, line);
    }
    ProgsBar::finish_scenes();

    let mut scores: Vec<Option<(f64, f64)>> = vec![None; tot_frames];
    for (k, v) in results.scores {
        if k < tot_frames {
            scores[k] = Some((v.inter_cost, v.threshold));
        }
    }

    let new_scenes = refine_scenes(&results.scene_changes, tot_frames, max_dist, &scores);

    let mut content = String::new();
    for &scene_frame in &new_scenes {
        _ = writeln!(content, "{scene_frame}");
    }

    fs_write(scene_file, content)?;

    Ok(())
}

fn refine_scenes(
    scene_changes: &[usize],
    tot_frames: usize,
    max_dist: usize,
    scores: &[Option<(f64, f64)>],
) -> Vec<usize> {
    let mut scenes = Vec::new();
    for i in 0..scene_changes.len() {
        let s = scene_changes[i];
        let e = scene_changes.get(i + 1).copied().unwrap_or(tot_frames);
        scenes.push((s, e));
    }

    let mut new_scenes = vec![0];

    for &(s_frame, e_frame) in &scenes {
        let mut current_start = s_frame.max(*unsafe { new_scenes.last().unwrap_unchecked() });
        let mut distance = e_frame - current_start;

        while distance > max_dist {
            let minimum_split_count = distance / max_dist;
            let middle_point = distance / (minimum_split_count + 1);
            let min_size = middle_point / 2;
            let max_size = min(max_dist, middle_point + min_size);
            let range_size = max_size - min_size;

            let split_point = (min_size..=max_size)
                .filter_map(|size| {
                    let idx = current_start + size;
                    scores[idx].map(|(inter_cost, threshold)| {
                        let inter_score = inter_cost / threshold;
                        let distance_from_mid =
                            (middle_point.max(size) - middle_point.min(size)) as f64;
                        let distance_weighting = 1.0 - distance_from_mid / range_size as f64;
                        (size, inter_score * distance_weighting)
                    })
                })
                .max_by_key(|&(_, score)| (score * 10000.0).round() as u64)
                .unwrap_or((middle_point, 0.0))
                .0;

            current_start += split_point;
            new_scenes.push(current_start);
            distance = e_frame - current_start;
        }
        new_scenes.push(e_frame);
    }

    if new_scenes.last() == Some(&tot_frames) {
        new_scenes.pop();
    }

    new_scenes
}
