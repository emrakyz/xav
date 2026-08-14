#[cfg(target_os = "linux")]
use alloc::{boxed::Box, string::String, vec::Vec};
use core::{
    fmt::Write as _,
    sync::atomic::{AtomicU64, Ordering::Relaxed},
};

use crate::{
    Args,
    audio::AuStream,
    clk::Mono,
    copy::{demux, read_chapters},
    error::Xerr,
    ffms::{AVMEDIA_TYPE_AUDIO, VidInf},
    fs::{read_dir, read_to_string as read_to_str, write},
    io::{Write as _, print_fmt, stdout},
    mkv_mux::{AudioSrc, Aux, mux_mkv},
    mux_webm::mux_webm,
    path::{Path, PathBuf},
    sync::OnceLock,
};

pub static PRIOR_SECS: AtomicU64 = AtomicU64::new(0);
static ENC_START: OnceLock<Mono> = OnceLock::new();
pub fn init_elapsed(prior: u64) {
    PRIOR_SECS.store(prior, Relaxed);
    _ = ENC_START.set(Mono::now());
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
    pub tmpl: u16,
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

pub fn has_rc(s: &str) -> bool {
    s.contains("crf ") || s.contains("qp ") || s.contains("QP ") || s.contains("-q ")
}

pub fn load_scenes(path: &Path, t_frames: usize, tq: bool) -> Result<Vec<Scene>, Xerr> {
    let content = read_to_str(path)?;
    if tq && has_rc(&content) {
        return Err(
            "zones file must not set CRF/QP in target-quality mode: CRF is chosen automatically"
                .into(),
        );
    }
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
            tmpl: 0,
            start: s.s_frame,
            end: s.e_frame,
            params: s.params.clone(),
        })
        .collect()
}

#[cold]
#[inline(never)]
pub fn zone_tmpls(chnks: &mut [Chunk]) -> Vec<Box<str>> {
    let mut zones: Vec<Box<str>> = Vec::new();
    for c in chnks {
        let Some(ref p) = c.params else {
            continue;
        };
        c.tmpl = zones.iter().position(|z| z == p).map_or_else(
            || {
                zones.push(p.clone());
                zones.len() as u16
            },
            |i| i as u16 + 1,
        );
    }
    zones
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

pub fn merge_out(
    args: &Args,
    enc_dir: &Path,
    inf: &VidInf,
    au: &[(AuStream, PathBuf)],
    crop: (u32, u32),
) -> Result<(), Xerr> {
    let mut files: Vec<(usize, PathBuf)> = read_dir(enc_dir)?
        .filter_map(Result::ok)
        .map(|e| e.path())
        .filter(|p| {
            p.extension()
                .is_some_and(|ext| ext == args.encoder.extension())
        })
        .map(|p| {
            let idx = p
                .file_stem()
                .and_then(|s| s.to_str())
                .and_then(|s| s.parse::<usize>().ok())
                .unwrap_or(0);
            (idx, p)
        })
        .collect();

    files.sort_unstable_by_key(|&(idx, _)| idx);

    let paths: Vec<PathBuf> = files.into_iter().map(|(_, p)| p).collect();

    if args.out.extension().is_some_and(|e| e == "webm") {
        let dims = (inf.width - crop.1 * 2, inf.height - crop.0 * 2);
        return mux_webm(&paths, &args.out, inf, dims, au);
    }

    let (enc_w, enc_h) = (inf.width - crop.1 * 2, inf.height - crop.0 * 2);
    #[cfg(feature = "vship")]
    let dtag = args.disp.map(|d| d.tag(enc_w, enc_h));
    #[cfg(feature = "vship")]
    let cvvdp = args.tq.as_deref().zip(dtag.as_deref());
    #[cfg(not(feature = "vship"))]
    let cvvdp: Option<(&str, &str)> = None;
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
            cvvdp,
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
