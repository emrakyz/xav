use std::fs;
use std::path::Path;
use std::process::Command;

use crate::encoder::Encoder;

#[derive(Clone)]
pub struct Scene {
    pub s_frame: usize,
    pub e_frame: usize,
}

#[derive(Clone)]
pub struct Chunk {
    pub idx: usize,
    pub start: usize,
    pub end: usize,
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
    let mut s_frames: Vec<usize> =
        content.lines().filter_map(|line| line.trim().parse().ok()).collect();

    s_frames.sort_unstable();

    let mut scenes = Vec::new();
    for i in 0..s_frames.len() {
        let s = s_frames[i];
        let e = s_frames.get(i + 1).copied().unwrap_or(t_frames);
        scenes.push(Scene { s_frame: s, e_frame: e });
    }

    Ok(scenes)
}

pub fn validate_scenes(
    scenes: &[Scene],
    fps_num: u32,
    fps_den: u32,
) -> Result<(), Box<dyn std::error::Error>> {
    let max_len = ((fps_num * 10 + fps_den / 2) / fps_den).min(300);

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
        .map(|(i, s)| Chunk { idx: i, start: s.s_frame, end: s.e_frame })
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

#[cfg(target_os = "windows")]
const BATCH_SIZE: usize = usize::MAX;
#[cfg(not(target_os = "windows"))]
const BATCH_SIZE: usize = 960;

pub fn merge_out(
    encode_dir: &Path,
    output: &Path,
    inf: &crate::ffms::VidInf,
    input: Option<&Path>,
    encoder: Encoder,
) -> Result<(), Box<dyn std::error::Error>> {
    let mut files: Vec<_> = fs::read_dir(encode_dir)?
        .filter_map(Result::ok)
        .filter(|e| e.path().extension().is_some_and(|ext| ext == "ivf"))
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

    if files.len() <= BATCH_SIZE {
        return run_merge(
            &files.iter().map(fs::DirEntry::path).collect::<Vec<_>>(),
            output,
            inf,
            input,
        );
    }

    let temp_dir = encode_dir.join("temp_merge");
    fs::create_dir_all(&temp_dir)?;

    let batches: Vec<_> = files
        .chunks(BATCH_SIZE)
        .enumerate()
        .map(|(i, chunk)| {
            let path = temp_dir.join(format!("batch_{i}.ivf"));
            run_merge(&chunk.iter().map(fs::DirEntry::path).collect::<Vec<_>>(), &path, inf, None)?;
            Ok(path)
        })
        .collect::<Result<_, Box<dyn std::error::Error>>>()?;

    run_merge(&batches, output, inf, input)?;
    fs::remove_dir_all(&temp_dir)?;
    Ok(())
}

fn run_merge(
    files: &[std::path::PathBuf],
    output: &Path,
    inf: &crate::ffms::VidInf,
    input: Option<&Path>,
) -> Result<(), Box<dyn std::error::Error>> {
    let concat_list = output.with_extension("txt");
    let mut content = String::new();
    for file in files {
        use std::fmt::Write;
        let abs_path = file.canonicalize()?;
        let _ = writeln!(content, "file '{}'", abs_path.display());
    }
    fs::write(&concat_list, content)?;

    let ff_flags = [
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

    let temp_dir = output.parent().unwrap();
    let video = if input.is_some() { temp_dir.join("video.mkv") } else { output.to_path_buf() };

    let fps = format!("{}/{}", inf.fps_num, inf.fps_den);

    let mut cmd = Command::new("ffmpeg");
    cmd.args(["-f", "concat", "-safe", "0", "-i"])
        .arg(&concat_list)
        .args(["-loglevel", "error", "-hide_banner", "-nostdin", "-stats", "-y"])
        .args(["-c", "copy", "-r", &fps])
        .args(ff_flags)
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
        let mut cmd_audio = Command::new("ffmpeg");
        cmd_audio
            .args(["-loglevel", "quiet", "-hide_banner", "-nostdin", "-stats", "-y"])
            .args(["-i"])
            .arg(input)
            .args(["-vn", "-sn", "-dn", "-map", "0:a", "-c", "copy"])
            .args(["-map_metadata", "-1", "-map_chapters", "-1"])
            .args(ff_flags)
            .arg(&temp_audio);

        let _ = cmd_audio.status();
        let has_audio =
            temp_audio.exists() && fs::metadata(&temp_audio).map(|m| m.len() > 0).unwrap_or(false);

        let mut cmd2 = Command::new("ffmpeg");
        cmd2.args(["-loglevel", "error", "-hide_banner", "-nostdin", "-stats", "-y"])
            .args(["-i", &video.to_string_lossy()]);

        if has_audio {
            cmd2.args(["-i", &temp_audio.to_string_lossy()]);
        }

        cmd2.args(["-i"]).arg(input);

        let idx = if has_audio { "2" } else { "1" };

        cmd2.args(["-map", "0:v"]);
        if has_audio {
            cmd2.args(["-map", "1:a"]);
        }
        cmd2.args(["-map", &format!("{idx}:s?"), "-map", &format!("{idx}:t?")])
            .args(["-map_chapters", idx, "-c", "copy"])
            .args(ff_flags)
            .arg(output);

        let status2 = cmd2.status()?;
        let _ = fs::remove_file(&video);
        let _ = fs::remove_file(&temp_audio);

        if !status2.success() {
            return Err("FFmpeg mux failed".into());
        }
    }

    Ok(())
}
