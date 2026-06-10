use std::{
    fmt::Write as _,
    fs::{DirEntry, File, read_dir, read_to_string as read_to_str, write},
    io::{Read as _, Seek as _, SeekFrom, Write as _, stdout},
    path::{Path, PathBuf},
    sync::{
        OnceLock,
        atomic::{AtomicU64, Ordering::Relaxed},
    },
    time::Instant,
};

use crate::{
    Args,
    audio::AuStream,
    copy::{demux, read_chapters},
    encoder::Encoder::Avm,
    error::Xerr,
    ffms::{AVMEDIA_TYPE_AUDIO, VidInf},
    mkv_mux::{AudioSrc, Aux, mux_mkv},
    mux_webm::mux_webm,
};

pub static PRIOR_SECS: AtomicU64 = AtomicU64::new(0);
static ENC_START: OnceLock<Instant> = OnceLock::new();
pub fn init_elapsed(prior: u64) {
    PRIOR_SECS.store(prior, Relaxed);
    _ = ENC_START.set(Instant::now());
}

#[derive(Clone)]
pub struct Scene {
    pub s_frame: usize,
    pub e_frame: usize,
    pub params: Option<Box<str>>,
}

#[derive(Clone)]
pub struct Chunk {
    pub idx: u16,
    pub start: usize,
    pub end: usize,
    pub params: Option<Box<str>>,
}

#[derive(Clone)]
pub struct ChunkComp {
    pub idx: u16,
    pub frames: usize,
    pub sz: u64,
}

#[derive(Clone)]
pub struct ResumeInf {
    pub chnks_done: Vec<ChunkComp>,
    pub prior_secs: u64,
}

pub fn load_scenes(path: &Path, t_frames: usize) -> Result<Vec<Scene>, Xerr> {
    let content = read_to_str(path)?;
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

    parsed.sort_unstable_by_key(|&(f, _)| f);

    let mut scenes = Vec::new();
    for i in 0..parsed.len() {
        let (s, ref params) = parsed[i];
        let e = parsed.get(i + 1).map_or(t_frames, |&(f, _)| f);
        scenes.push(Scene {
            s_frame: s,
            e_frame: e,
            params: params.clone(),
        });
    }

    Ok(scenes)
}

pub fn val_scenes(scenes: &[Scene]) -> Result<(), Xerr> {
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

pub fn chnkify(scenes: &[Scene]) -> Vec<Chunk> {
    scenes
        .iter()
        .enumerate()
        .map(|(i, s)| Chunk {
            idx: i as u16,
            start: s.s_frame,
            end: s.e_frame,
            params: s.params.clone(),
        })
        .collect()
}

pub fn get_resume(work_dir: &Path) -> Option<ResumeInf> {
    let path = work_dir.join("done.txt");
    path.exists()
        .then(|| {
            let content = read_to_str(path).ok()?;
            let mut chnks_done = Vec::new();
            let mut prior_secs = 0u64;

            for line in content.lines() {
                if let Some(s) = line.strip_prefix("elapsed ") {
                    prior_secs = s.parse().unwrap_or(0);
                    continue;
                }
                let parts: Vec<&str> = line.split_whitespace().collect();
                if parts.len() == 3
                    && let (Ok(idx), Ok(frames), Ok(sz)) = (
                        parts[0].parse::<u16>(),
                        parts[1].parse::<usize>(),
                        parts[2].parse::<u64>(),
                    )
                {
                    chnks_done.push(ChunkComp { idx, frames, sz });
                }
            }

            Some(ResumeInf {
                chnks_done,
                prior_secs,
            })
        })
        .flatten()
}

pub fn save_resume(data: &ResumeInf, work_dir: &Path) -> Result<(), Xerr> {
    let path = work_dir.join("done.txt");
    let mut content = String::new();
    let elapsed = PRIOR_SECS.load(Relaxed) + ENC_START.get().map_or(0, |s| s.elapsed().as_secs());
    _ = writeln!(content, "elapsed {elapsed}");

    for chnk in &data.chnks_done {
        _ = writeln!(
            content,
            "{idx} {frames} {sz}",
            idx = chnk.idx,
            frames = chnk.frames,
            sz = chnk.sz
        );
    }

    write(path, content)?;
    Ok(())
}

fn concat_ivf(files: &[PathBuf], out: &Path, tot_frames: u32) -> Result<(), Xerr> {
    let mut writer = File::create(out)?;
    let mut pts_off: u64 = 0;
    let mut buf: Vec<u8> = Vec::new();

    for (i, file) in files.iter().enumerate() {
        buf.clear();
        File::open(file)?.read_to_end(&mut buf)?;
        if buf.len() < 32 {
            continue;
        }

        let mut chunk_max: u64 = pts_off;
        unsafe {
            let base = buf.as_mut_ptr();
            let end = base.add(buf.len());
            let mut p = base.add(32);
            while end.offset_from(p) >= 12 {
                let sz = p.cast::<u32>().read_unaligned() as usize;
                let pts_ptr = p.add(4).cast::<u64>();
                let new_pts = pts_ptr.read_unaligned() + pts_off;
                pts_ptr.write_unaligned(new_pts);
                chunk_max = chunk_max.max(new_pts);
                p = p.add(12 + sz);
            }
        }

        writer.write_all(if i == 0 { &buf } else { &buf[32..] })?;
        pts_off = chunk_max + 1;
    }

    writer.seek(SeekFrom::Start(24))?;
    writer.write_all(&tot_frames.to_le_bytes())?;

    Ok(())
}

pub fn merge_out(
    args: &Args,
    enc_dir: &Path,
    inf: &VidInf,
    au: &[(AuStream, PathBuf)],
    crop: (u32, u32),
) -> Result<(), Xerr> {
    let mut files: Vec<_> = read_dir(enc_dir)?
        .filter_map(Result::ok)
        .filter(|e| {
            e.path()
                .extension()
                .is_some_and(|ext| ext == args.encoder.extension())
        })
        .collect();

    files.sort_unstable_by_key(|e| {
        e.path()
            .file_stem()
            .and_then(|s| s.to_str())
            .and_then(|s| s.parse::<usize>().ok())
            .unwrap_or(0)
    });

    let paths: Vec<PathBuf> = files.iter().map(DirEntry::path).collect();

    if args.out.extension().is_some_and(|e| e == "webm") {
        let dims = (inf.width - crop.1 * 2, inf.height - crop.0 * 2);
        return mux_webm(&paths, &args.out, inf, dims, au);
    }

    if args.encoder == Avm {
        return concat_ivf(&paths, &args.out, inf.frames as u32);
    }

    let (enc_w, enc_h) = (inf.width - crop.1 * 2, inf.height - crop.0 * 2);
    let want_extras = args.ranges.is_none();
    let src = args.inp.as_path();
    let chapters = if want_extras {
        read_chapters(src)?
    } else {
        Vec::new()
    };
    let copy_audio = au.is_empty() && want_extras;
    let (audio, subs) = if want_extras {
        println!();
        _ = stdout().flush();
        let streams = demux(src, copy_audio, true)?;
        if copy_audio {
            let (au_s, sub_s): (Vec<_>, Vec<_>) = streams
                .into_iter()
                .partition(|s| s.codec_type == AVMEDIA_TYPE_AUDIO);
            (AudioSrc::Copy(au_s), sub_s)
        } else {
            (AudioSrc::Encode(au), streams)
        }
    } else {
        (AudioSrc::Encode(au), Vec::new())
    };
    if want_extras {
        println!();
        println!();
        _ = stdout().flush();
    }
    mux_mkv(
        &paths,
        &args.out,
        inf,
        (enc_w, enc_h),
        args.encoder,
        &args.params,
        Aux {
            audio,
            subs,
            chapters,
        },
    )
}

pub fn trans_scenes(scenes: &[Scene], ranges: &[(usize, usize)]) -> Vec<Scene> {
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
            let params = scenes
                .iter()
                .rfind(|sc| sc.s_frame <= s)
                .and_then(|sc| sc.params.clone());
            out.push(Scene {
                s_frame: s,
                e_frame: e.min(re + 1),
                params,
            });
        }
    }
    out
}
