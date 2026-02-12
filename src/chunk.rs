use std::fs;
use std::path::Path;
use std::process::Command;

use crate::encoder::Encoder;

#[derive(Clone)]
pub struct Scene {
    pub s_frame: usize,
    pub e_frame: usize,
    pub params: Option<Box<str>>,
}

#[derive(Clone)]
pub struct Chunk {
    pub idx: usize,
    pub start: usize,
    pub end: usize,
    pub params: Option<Box<str>>,
}

#[derive(Clone)]
pub struct ChunkComp {
    pub idx: usize,
    pub frames: usize,
    pub size: u64,
}

#[derive(Clone)]
pub struct ResumeInf {
    pub chnks_done: Vec<ChunkComp>,
}

pub fn load_scenes(path: &Path, t_frames: usize) -> Result<Vec<Scene>, Box<dyn std::error::Error>> {
    let content = fs::read_to_string(path)?;
    let mut parsed: Vec<_> = content
        .lines()
        .filter_map(|line| {
            let t = line.trim();
            let (f, r) = t.split_once(char::is_whitespace).unwrap_or((t, ""));
            Some((
                f.parse::<usize>().ok()?,
                Some(r.trim()).filter(|s| !s.is_empty()).map(Box::from),
            ))
        })
        .collect();

    parsed.sort_unstable_by_key(|(f, _)| *f);

    let mut scenes = Vec::new();
    for i in 0..parsed.len() {
        let (s, params) = &parsed[i];
        let e = parsed.get(i + 1).map_or(t_frames, |(f, _)| *f);
        scenes.push(Scene { s_frame: *s, e_frame: e, params: params.clone() });
    }

    Ok(scenes)
}

pub fn validate_scenes(scenes: &[Scene]) -> Result<(), Box<dyn std::error::Error>> {
    let max_len = 300;

    for (i, scene) in scenes.iter().enumerate() {
        let len = scene.e_frame.saturating_sub(scene.s_frame);

        if len == 0 || len > max_len as usize {
            return Err(format!(
                "Scene {} (frames {}-{}) has invalid length {}: must be up to {} frames",
                i, scene.s_frame, scene.e_frame, len, max_len
            )
            .into());
        }
    }

    Ok(())
}

pub fn chunkify(scenes: &[Scene]) -> Vec<Chunk> {
    scenes
        .iter()
        .enumerate()
        .map(|(i, s)| Chunk { idx: i, start: s.s_frame, end: s.e_frame, params: s.params.clone() })
        .collect()
}

pub fn get_resume(work_dir: &Path) -> Option<ResumeInf> {
    let path = work_dir.join("done.txt");
    path.exists()
        .then(|| {
            let content = fs::read_to_string(path).ok()?;
            let mut chnks_done = Vec::new();

            for line in content.lines() {
                let parts: Vec<&str> = line.split_whitespace().collect();
                if parts.len() == 3
                    && let (Ok(idx), Ok(frames), Ok(size)) = (
                        parts[0].parse::<usize>(),
                        parts[1].parse::<usize>(),
                        parts[2].parse::<u64>(),
                    )
                {
                    chnks_done.push(ChunkComp { idx, frames, size });
                }
            }

            Some(ResumeInf { chnks_done })
        })
        .flatten()
}

pub fn save_resume(data: &ResumeInf, work_dir: &Path) -> Result<(), Box<dyn std::error::Error>> {
    let path = work_dir.join("done.txt");
    let mut content = String::new();

    for chunk in &data.chnks_done {
        use std::fmt::Write;
        let _ = writeln!(
            content,
            "{idx} {frames} {size}",
            idx = chunk.idx,
            frames = chunk.frames,
            size = chunk.size
        );
    }

    fs::write(path, content)?;
    Ok(())
}

fn concat_ivf(
    files: &[std::path::PathBuf],
    output: &Path,
    total_frames: u32,
) -> Result<(), Box<dyn std::error::Error>> {
    use std::io::{Read, Seek, SeekFrom, Write};

    let mut out = fs::File::create(output)?;

    for (i, file) in files.iter().enumerate() {
        let mut f = fs::File::open(file)?;
        if i != 0 {
            let mut buf = [0u8; 32];
            f.read_exact(&mut buf)?;
        }
        std::io::copy(&mut f, &mut out)?;
    }

    out.seek(SeekFrom::Start(24))?;
    out.write_all(&total_frames.to_le_bytes())?;

    Ok(())
}

fn concat_vvc(
    files: &[std::path::PathBuf],
    output: &Path,
    inf: &crate::ffms::VidInf,
) -> Result<(), Box<dyn std::error::Error>> {
    use std::io::Write;

    let temp_266 = output.with_extension("266");

    let mut out = fs::File::create(&temp_266)?;
    for file in files {
        let data = fs::read(file)?;
        out.write_all(&data)?;
    }
    drop(out);

    let fps = format!("{}/{}", inf.fps_num, inf.fps_den);

    let status = Command::new("MP4Box")
        .args(["-flat", "-new"])
        .args(["-for-test"])
        .args(["-no-iod"])
        .arg("-add")
        .arg(format!("{}:fps={}", temp_266.display(), fps))
        .arg(output)
        .status()?;

    let _ = fs::remove_file(&temp_266);

    if !status.success() {
        return Err("MP4Box VVC import failed".into());
    }

    Ok(())
}

fn concat_h26x(
    files: &[std::path::PathBuf],
    output: &Path,
    inf: &crate::ffms::VidInf,
    encoder: Encoder,
) -> Result<(), Box<dyn std::error::Error>> {
    use std::io::Write;

    let temp_26x = output.with_extension(encoder.extension());
    {
        let mut out = fs::File::create(&temp_26x)?;
        for file in files {
            out.write_all(&fs::read(file)?)?;
        }
    }

    let fps = format!("{}/{}", inf.fps_num, inf.fps_den);

    if Command::new("MP4Box").arg("-version").output().is_ok() {
        let status = Command::new("MP4Box")
            .args(["-flat", "-new", "-for-test", "-no-iod", "-add"])
            .arg(format!("{}:fps={}", temp_26x.display(), fps))
            .arg(output)
            .status()?;

        let _ = fs::remove_file(&temp_26x);
        if status.success() {
            return Ok(());
        }
    }

    if Command::new("mkvmerge").arg("--version").output().is_ok() {
        let mut cmd = Command::new("mkvmerge");
        cmd.arg("-o").arg(output);
        cmd.args(["--default-duration", &format!("0:{fps}fps")]);
        cmd.arg(&temp_26x);

        let status = cmd.status()?;
        let _ = fs::remove_file(&temp_26x);
        if status.success() {
            return Ok(());
        }
    }

    let _ = fs::remove_file(&temp_26x);
    Err("Neither MP4Box nor mkvmerge available for H.26x concat".into())
}

#[cfg(target_os = "windows")]
const BATCH_SIZE: usize = usize::MAX;
#[cfg(not(target_os = "windows"))]
const BATCH_SIZE: usize = 960;

const FF_FLAGS: [&str; 13] = [
    "-fflags",
    "+genpts+igndts+discardcorrupt+bitexact",
    "-bitexact",
    "-avoid_negative_ts",
    "make_zero",
    "-err_detect",
    "ignore_err",
    "-ignore_unknown",
    "-reset_timestamps",
    "1",
    "-start_at_zero",
    "-output_ts_offset",
    "0",
];

pub fn add_mp4_subs(input: &Path, output: &Path) {
    let Ok(out) = Command::new("MP4Box").arg("-info").arg(input).output() else { return };
    let info = String::from_utf8_lossy(&out.stdout);
    let stderr = String::from_utf8_lossy(&out.stderr);
    let combined = format!("{info}{stderr}");

    let mut cmd = Command::new("MP4Box");
    cmd.args(["-for-test", "-no-iod"]);
    let mut has_tracks = false;

    for line in combined.lines() {
        if line.contains("type: Text")
            && let Some(track) = line
                .split("Track ")
                .nth(1)
                .and_then(|s| s.split_whitespace().next())
                .and_then(|s| s.parse::<u32>().ok())
        {
            cmd.arg("-add").arg(format!("{}#{}", input.display(), track));
            has_tracks = true;
        }
    }

    if has_tracks {
        cmd.arg(output);
        let _ = cmd.status();
    }
}

pub fn merge_out(
    encode_dir: &Path,
    output: &Path,
    inf: &crate::ffms::VidInf,
    input: Option<&Path>,
    encoder: Encoder,
    ranges: Option<&[(usize, usize)]>,
) -> Result<(), Box<dyn std::error::Error>> {
    let mut files: Vec<_> = fs::read_dir(encode_dir)?
        .filter_map(Result::ok)
        .filter(|e| e.path().extension().is_some_and(|ext| ext == encoder.extension()))
        .collect();

    files.sort_unstable_by_key(|e| {
        e.path()
            .file_stem()
            .and_then(|s| s.to_str())
            .and_then(|s| s.parse::<usize>().ok())
            .unwrap_or(0)
    });

    if encoder == Encoder::Avm {
        return concat_ivf(
            &files.iter().map(fs::DirEntry::path).collect::<Vec<_>>(),
            output,
            inf.frames as u32,
        );
    }

    if encoder == Encoder::Vvenc {
        let temp_mp4 = encode_dir.join("temp_vvc.mp4");
        concat_vvc(&files.iter().map(fs::DirEntry::path).collect::<Vec<_>>(), &temp_mp4, inf)?;

        if input.is_none() {
            fs::rename(&temp_mp4, output)?;
            return Ok(());
        }

        let result = mux_av(&temp_mp4, output, inf, input.unwrap(), ranges);
        let _ = fs::remove_file(&temp_mp4);
        return result;
    }

    if matches!(encoder, Encoder::X265 | Encoder::X264) {
        let temp_video = encode_dir.join("temp_hevc.mkv");
        concat_h26x(
            &files.iter().map(std::fs::DirEntry::path).collect::<Vec<_>>(),
            &temp_video,
            inf,
            encoder,
        )?;

        if let Some(input_file) = input {
            let result = mux_av(&temp_video, output, inf, input_file, ranges);
            let _ = fs::remove_file(&temp_video);
            return result;
        }

        fs::rename(&temp_video, output)?;
        return Ok(());
    }

    if files.len() <= BATCH_SIZE {
        return run_merge(
            &files.iter().map(fs::DirEntry::path).collect::<Vec<_>>(),
            output,
            inf,
            input,
            ranges,
        );
    }

    let temp_dir = encode_dir.join("temp_merge");
    fs::create_dir_all(&temp_dir)?;

    let batches: Vec<_> = files
        .chunks(BATCH_SIZE)
        .enumerate()
        .map(|(i, chunk)| {
            let path = temp_dir.join(format!("batch_{i}.{}", encoder.extension()));
            run_merge(
                &chunk.iter().map(fs::DirEntry::path).collect::<Vec<_>>(),
                &path,
                inf,
                None,
                None,
            )?;
            Ok(path)
        })
        .collect::<Result<_, Box<dyn std::error::Error>>>()?;

    run_merge(&batches, output, inf, input, ranges)?;
    fs::remove_dir_all(&temp_dir)?;
    Ok(())
}

fn run_merge(
    files: &[std::path::PathBuf],
    output: &Path,
    inf: &crate::ffms::VidInf,
    input: Option<&Path>,
    ranges: Option<&[(usize, usize)]>,
) -> Result<(), Box<dyn std::error::Error>> {
    let concat_list = output.with_extension("txt");
    let mut content = String::new();
    for file in files {
        use std::fmt::Write;
        let abs_path = file.canonicalize()?;
        let _ = writeln!(content, "file '{}'", abs_path.display());
    }
    fs::write(&concat_list, content)?;

    let temp_dir = output.parent().unwrap();
    let video = if input.is_some() { temp_dir.join("video.mkv") } else { output.to_path_buf() };

    let fps = format!("{}/{}", inf.fps_num, inf.fps_den);

    let mut cmd = Command::new("ffmpeg");
    cmd.args(["-f", "concat", "-safe", "0", "-i"])
        .arg(&concat_list)
        .args(["-loglevel", "error", "-hide_banner", "-nostdin", "-stats", "-y"])
        .args(["-c", "copy", "-r", &fps])
        .args(FF_FLAGS)
        .arg(&video);

    let status = cmd.status()?;
    let _ = fs::remove_file(&concat_list);

    if !status.success() {
        if input.is_some() {
            let _ = fs::remove_file(&video);
        }
        return Err("FFmpeg video concat failed".into());
    }

    if let Some(input) = input {
        let temp_audio = temp_dir.join("audio.mka");

        let has_audio = if let Some(r) = ranges {
            let times = ranges_to_times(r, inf.fps_num, inf.fps_den);
            extract_audio_ranges(input, &times, &temp_audio)?
        } else {
            extract_audio_full(input, &temp_audio)
        };

        let mut cmd2 = Command::new("ffmpeg");
        cmd2.args(["-loglevel", "error", "-hide_banner", "-nostdin", "-stats", "-y"])
            .args(["-i", &video.to_string_lossy()]);

        if has_audio {
            cmd2.args(["-i", &temp_audio.to_string_lossy()]);
        }

        if ranges.is_none() {
            cmd2.args(["-i"]).arg(input);
        }

        let input_idx = if has_audio { "2" } else { "1" };

        cmd2.args(["-map", "0:v"]);
        if has_audio {
            cmd2.args(["-map", "1:a"]);
        }

        if ranges.is_none() {
            cmd2.args(["-map", input_idx])
                .args(["-map", &format!("-{input_idx}:V")])
                .args(["-map", &format!("-{input_idx}:a")])
                .args(["-map_chapters", input_idx]);
        }

        cmd2.args(["-c", "copy"]);
        if let Some((dw, dh)) = inf.dar {
            cmd2.args(["-aspect", &format!("{dw}:{dh}")]);
        }
        cmd2.args(FF_FLAGS).arg(output);

        let status2 = cmd2.status()?;
        let _ = fs::remove_file(&video);
        let _ = fs::remove_file(&temp_audio);

        if !status2.success() {
            return Err("FFmpeg mux failed".into());
        }
    }

    Ok(())
}

fn mux_av(
    video: &Path,
    output: &Path,
    inf: &crate::ffms::VidInf,
    input: &Path,
    ranges: Option<&[(usize, usize)]>,
) -> Result<(), Box<dyn std::error::Error>> {
    let temp_dir = video.parent().unwrap();
    let temp_audio = temp_dir.join("audio.mka");

    let has_audio = if let Some(r) = ranges {
        let times = ranges_to_times(r, inf.fps_num, inf.fps_den);
        extract_audio_ranges(input, &times, &temp_audio)?
    } else {
        extract_audio_full(input, &temp_audio)
    };

    let mut cmd = Command::new("ffmpeg");
    cmd.args(["-loglevel", "error", "-hide_banner", "-nostdin", "-stats", "-y"])
        .arg("-i")
        .arg(video);

    if has_audio {
        cmd.arg("-i").arg(&temp_audio);
    }

    if ranges.is_none() {
        cmd.arg("-i").arg(input);
    }

    let input_idx = if has_audio { "2" } else { "1" };

    cmd.args(["-map", "0:v"]);
    if has_audio {
        cmd.args(["-map", "1:a"]);
    }

    if ranges.is_none() {
        cmd.args(["-map", input_idx])
            .args(["-map", &format!("-{input_idx}:V")])
            .args(["-map", &format!("-{input_idx}:a")])
            .args(["-map_chapters", input_idx]);
    }

    cmd.args(["-c", "copy"]);
    if let Some((dw, dh)) = inf.dar {
        cmd.args(["-aspect", &format!("{dw}:{dh}")]);
    }
    cmd.args(FF_FLAGS).arg(output);

    let status = cmd.status()?;
    let _ = fs::remove_file(&temp_audio);

    if !status.success() {
        return Err("FFmpeg mux failed".into());
    }

    if ranges.is_none() && output.extension().is_some_and(|e| e == "mp4") {
        add_mp4_subs(input, output);
    }

    Ok(())
}

pub fn translate_scenes(scenes: &[Scene], ranges: &[(usize, usize)]) -> Vec<Scene> {
    let mut cuts: Vec<usize> = scenes.iter().map(|s| s.s_frame).collect();
    for &(s, e) in ranges {
        cuts.push(s);
        cuts.push(e + 1);
    }
    cuts.sort_unstable();
    cuts.dedup();

    let mut out = Vec::new();
    for i in 0..cuts.len() {
        let s = cuts[i];
        let e = cuts.get(i + 1).copied().unwrap_or(usize::MAX);
        if let Some(&(_, re)) = ranges.iter().find(|&&(rs, re)| s >= rs && s <= re) {
            let params = scenes.iter().rfind(|sc| sc.s_frame <= s).and_then(|sc| sc.params.clone());
            out.push(Scene { s_frame: s, e_frame: e.min(re + 1), params });
        }
    }
    out
}

fn extract_segment(input: &Path, output: &Path, start: Option<f64>, duration: Option<f64>) -> bool {
    let mut cmd = Command::new("ffmpeg");
    cmd.args(["-loglevel", "quiet", "-hide_banner", "-nostdin", "-y"]);

    if let Some(s) = start {
        cmd.args(["-ss", &format!("{s:.6}")]);
    }
    if let Some(d) = duration {
        cmd.args(["-t", &format!("{d:.6}")]);
    }

    cmd.arg("-i")
        .arg(input)
        .args(["-vn", "-sn", "-dn", "-map", "0:a", "-c", "copy"])
        .args(["-map_chapters", "-1"])
        .args(FF_FLAGS)
        .arg(output);

    let _ = cmd.status();
    output.exists() && fs::metadata(output).is_ok_and(|m| m.len() > 0)
}

fn concat_segments(
    segments: &[std::path::PathBuf],
    output: &Path,
) -> Result<bool, Box<dyn std::error::Error>> {
    let temp_dir = output.parent().unwrap();
    let concat_list = temp_dir.join("audio_concat.txt");

    let mut content = String::new();
    for seg in segments {
        use std::fmt::Write;
        let _ = writeln!(content, "file '{}'", seg.canonicalize()?.display());
    }
    fs::write(&concat_list, content)?;

    let mut cmd = Command::new("ffmpeg");
    cmd.args(["-loglevel", "error", "-hide_banner", "-nostdin", "-y"])
        .args(["-f", "concat", "-safe", "0", "-i"])
        .arg(&concat_list)
        .args(["-c", "copy"])
        .args(FF_FLAGS)
        .arg(output);

    let _ = cmd.status();
    let _ = fs::remove_file(&concat_list);

    Ok(output.exists() && fs::metadata(output).is_ok_and(|m| m.len() > 0))
}

fn extract_audio_full(input: &Path, output: &Path) -> bool {
    extract_segment(input, output, None, None)
}

fn extract_audio_ranges(
    input: &Path,
    times: &[(f64, f64)],
    output: &Path,
) -> Result<bool, Box<dyn std::error::Error>> {
    if times.len() == 1 {
        return Ok(extract_segment(input, output, Some(times[0].0), Some(times[0].1 - times[0].0)));
    }

    let temp_dir = output.parent().unwrap();
    let mut segments = Vec::new();

    for (i, (start, end)) in times.iter().enumerate() {
        let seg_path = temp_dir.join(format!("audio_seg_{i}.mka"));
        if extract_segment(input, &seg_path, Some(*start), Some(end - start)) {
            segments.push(seg_path);
        }
    }

    if segments.is_empty() {
        return Ok(false);
    }

    let result = concat_segments(&segments, output)?;

    for seg in &segments {
        let _ = fs::remove_file(seg);
    }

    Ok(result)
}

pub fn ranges_to_times(ranges: &[(usize, usize)], fps_num: u32, fps_den: u32) -> Vec<(f64, f64)> {
    let fps = f64::from(fps_num) / f64::from(fps_den);
    ranges.iter().map(|&(s, e)| (s as f64 / fps, (e + 1) as f64 / fps)).collect()
}
