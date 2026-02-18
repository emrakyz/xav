use std::cmp::min;
use std::fmt::Write;
use std::fs;
use std::path::Path;
use std::sync::{Arc, Mutex};

use av_scenechange::{DetectionOptions, SceneDetectionSpeed, av_decoders, detect_scene_changes};

use crate::ffms;
use crate::progs::ProgsBar;

pub fn fd_scenes(vid_path: &Path, scene_file: &Path) -> Result<(), Box<dyn std::error::Error>> {
    let idx = ffms::VidIdx::new(vid_path, true)?;
    let inf = ffms::get_vidinf(&idx)?;

    let max_dist = 300;
    let tot_frames = inf.frames;
    drop(idx);

    let mut decoder = av_decoders::Decoder::from_file(vid_path)?;
    decoder.set_luma_only(true);

    let opts = DetectionOptions {
        analysis_speed: SceneDetectionSpeed::Standard,
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
                pb.up_scenes(current, tot_frames);
            }
        }
    };

    let results = if inf.is_10bit {
        detect_scene_changes::<u16>(&mut decoder, opts, None, Some(&progs_callback))?
    } else {
        detect_scene_changes::<u8>(&mut decoder, opts, None, Some(&progs_callback))?
    };

    ProgsBar::finish_scenes();

    let mut scores: Vec<Option<(f64, f64)>> = vec![None; tot_frames];
    for (k, v) in results.scores {
        if k < tot_frames {
            scores[k] = Some((v.inter_cost, v.threshold));
        }
    }

    let mut scenes = Vec::new();
    for i in 0..results.scene_changes.len() {
        let s = results.scene_changes[i];
        let e = results.scene_changes.get(i + 1).copied().unwrap_or(tot_frames);
        scenes.push((s, e));
    }

    let mut new_scenes = vec![0];

    for &(s_frame, e_frame) in &scenes {
        let mut current_start = s_frame.max(*new_scenes.last().unwrap());
        let mut distance = e_frame - current_start;
        let split_size = max_dist as usize;

        while distance > split_size {
            let minimum_split_count = distance / split_size;
            let middle_point = distance / (minimum_split_count + 1);
            let min_size = middle_point / 2;
            let max_size = min(split_size, middle_point + min_size);
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
                .max_by_key(|(_, score)| (*score * 10000.0).round() as u64)
                .expect("split scores is not empty")
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

    let mut content = String::new();
    for &scene_frame in &new_scenes {
        writeln!(content, "{scene_frame}").unwrap();
    }

    fs::write(scene_file, content)?;

    Ok(())
}
