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
) -> Result<(), Box<dyn std::error::Error>> {
    let idx = ffms::VidIdx::new(vid_path, quiet)?;
    let inf = ffms::get_vidinf(&idx)?;

    let min_dist = (inf.fps_num + inf.fps_den / 2) / inf.fps_den;
    let max_dist = ((inf.fps_num * 10 + inf.fps_den / 2) / inf.fps_den).min(300);
    let tot_frames = inf.frames;
    drop(idx);

    let mut decoder = av_decoders::Decoder::from_file(vid_path)?;

    let opts = DetectionOptions {
        analysis_speed: SceneDetectionSpeed::Standard,
        detect_flashes: false,
        min_scenecut_distance: Some(min_dist as usize),
        max_scenecut_distance: Some(max_dist as usize),
        lookahead_distance: 1,
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

    let mut content = String::new();
    for &scene_frame in &results.scene_changes {
        writeln!(content, "{scene_frame}").unwrap();
    }

    fs::write(scene_file, content)?;
    Ok(())
}
