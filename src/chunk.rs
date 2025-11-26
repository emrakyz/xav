use std::fs;
use std::path::Path;
use std::process::Command;

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
    let min_len = (fps_num + fps_den / 2) / fps_den;
    let max_len = ((fps_num * 10 + fps_den / 2) / fps_den).min(300);

    for (i, scene) in scenes.iter().enumerate() {
        let len = scene.e_frame.saturating_sub(scene.s_frame);
        let is_last = i == scenes.len() - 1;

        if (!is_last && len < min_len as usize) || len > max_len as usize {
            return Err(format!(
                "Scene {} (frames {}-{}) has invalid length {}: must be between {} and {} frames",
                i, scene.s_frame, scene.e_frame, len, min_len, max_len
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

pub fn merge_out(
    encode_dir: &Path,
    output: &Path,
    inf: &crate::ffms::VidInf,
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

    if files.len() <= 1024 {
        return run_merge(&files.iter().map(fs::DirEntry::path).collect::<Vec<_>>(), output, inf);
    }

    let temp_dir = encode_dir.join("temp_merge");
    fs::create_dir_all(&temp_dir)?;

    let batches: Vec<_> = files
        .chunks(1024)
        .enumerate()
        .map(|(i, chunk)| {
            let path = temp_dir.join(format!("batch_{i}.ivf"));
            run_merge(&chunk.iter().map(fs::DirEntry::path).collect::<Vec<_>>(), &path, inf)?;
            Ok(path)
        })
        .collect::<Result<_, Box<dyn std::error::Error>>>()?;

    run_merge(&batches, output, inf)?;
    fs::remove_dir_all(&temp_dir)?;
    Ok(())
}

fn run_merge(
    files: &[std::path::PathBuf],
    output: &Path,
    inf: &crate::ffms::VidInf,
) -> Result<(), Box<dyn std::error::Error>> {
    let mut cmd = Command::new("mkvmerge");
    cmd.arg("-q")
        .arg("-o")
        .arg(output)
        .arg("-A")
        .arg("-S")
        .arg("-B")
        .arg("-M")
        .arg("-T")
        .arg("--no-global-tags")
        .arg("--no-chapters")
        .arg("--no-date")
        .arg("--disable-language-ietf")
        .arg("--disable-track-statistics-tags");

    for (i, file) in files.iter().enumerate() {
        if i == 0 {
            cmd.arg(file);
        } else {
            cmd.arg("+").arg(file);
        }
    }

    cmd.arg("--default-duration").arg(format!("0:{}/{}fps", inf.fps_num, inf.fps_den));
    cmd.status()?;
    Ok(())
}
