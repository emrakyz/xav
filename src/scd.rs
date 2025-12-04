use std::cmp::min;
use std::collections::BTreeMap;
use std::fmt::Write;
use std::fs;
use std::path::Path;
use std::sync::{Arc, Mutex};

use av_scenechange::{DetectionOptions, SceneDetectionSpeed, av_decoders, detect_scene_changes};

use crate::ffms;
use crate::progs::ProgsBar;

pub fn fd_scenes(
    vid_path: &Path,
    scene_file: &Path,
    quiet: bool,
) -> Result<BTreeMap<usize, (f64, f64)>, Box<dyn std::error::Error>> {
    let idx = ffms::VidIdx::new(vid_path, quiet)?;
    let inf = ffms::get_vidinf(&idx)?;

    let min_dist = (inf.fps_num + inf.fps_den / 2) / inf.fps_den;
    let max_dist = ((inf.fps_num * 10 + inf.fps_den / 2) / inf.fps_den).min(300);
    let tot_frames = inf.frames;
    drop(idx);

    let mut decoder = av_decoders::Decoder::from_file(vid_path)?;

    let opts = DetectionOptions {
        analysis_speed: SceneDetectionSpeed::Standard,
        detect_flashes: true,
        min_scenecut_distance: Some(min_dist as usize),
        max_scenecut_distance: None,
        lookahead_distance: 5,
    };

    let progs = if quiet { None } else { Some(Arc::new(Mutex::new(ProgsBar::new(false)))) };

    let results = if let Some(p) = &progs {
        let progs_callback = {
            let progs_clone = Arc::clone(p);
            move |current: usize, _keyframes: usize| {
                if let Ok(mut pb) = progs_clone.lock() {
                    pb.up_scenes(current, tot_frames);
                }
            }
        };

        if inf.is_10bit {
            detect_scene_changes::<u16>(&mut decoder, opts, None, Some(&progs_callback))?
        } else {
            detect_scene_changes::<u8>(&mut decoder, opts, None, Some(&progs_callback))?
        }
    } else if inf.is_10bit {
        detect_scene_changes::<u16>(&mut decoder, opts, None, None)?
    } else {
        detect_scene_changes::<u8>(&mut decoder, opts, None, None)?
    };

    if let Some(p) = progs
        && let Ok(pb) = p.lock()
    {
        pb.finish_scenes();
    }

    let scores: BTreeMap<usize, (f64, f64)> =
        results.scores.into_iter().map(|(k, v)| (k, (v.inter_cost, v.threshold))).collect();

    let mut scenes = Vec::new();
    for i in 0..results.scene_changes.len() {
        let s = results.scene_changes[i];
        let e = results.scene_changes.get(i + 1).copied().unwrap_or(tot_frames);
        scenes.push((s, e));
    }

    let mut new_scenes = vec![0];

    for (scene_idx, &(s_frame, e_frame)) in scenes.iter().enumerate() {
        if scene_idx == 0 {
            new_scenes.push(e_frame);
            continue;
        }

        let mut distance = e_frame - s_frame;
        let split_size = max_dist as usize;

        while distance > split_size {
            let minimum_split_count = distance / split_size;
            let middle_point = distance / (minimum_split_count + 1);
            let min_size = middle_point / 2;
            let max_size = min(split_size, middle_point + min_size);
            let range_size = max_size - min_size;

            let start_frame = *new_scenes.last().unwrap();

            let split_point = (min_size..=max_size)
                .filter_map(|size| {
                    scores.get(&(start_frame + size)).map(|(inter_cost, threshold)| {
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

            distance = e_frame - (start_frame + split_point);
            new_scenes.push(start_frame + split_point);
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

    Ok(scores)
}
