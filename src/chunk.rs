#[cfg(target_os = "linux")]
use alloc::{boxed::Box, string::String, vec::Vec};
use core::{
    fmt::Write as _,
    hint::cold_path,
    sync::atomic::{AtomicU64, Ordering::Relaxed},
};

use crate::{
    Args,
    audio::AuStream,
    clk::Mono,
    copy::demux_extras,
    error::Xerr,
    ffms::{AVMEDIA_TYPE_AUDIO, VidInf},
    fs::{File, read_dir, read_to_string as read_to_str, write_at},
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

pub const MAX_CHNK_FRAMES: usize = 300;

#[derive(Clone, Copy)]
pub struct Scene {
    pub s_frame: usize,
    pub e_frame: usize,
    pub params: Option<&'static str>,
}

#[derive(Clone, Copy)]
pub struct Chunk {
    pub idx: u16,
    pub tmpl: u32,
    pub start: usize,
    pub end: usize,
    pub params: Option<&'static str>,
}

#[derive(Clone, Copy)]
pub struct ChunkComp {
    pub idx: u16,
    pub frames: usize,
    pub sz: u64,
}

pub struct ResumeInf {
    pub chnks_done: Vec<ChunkComp>,
    buf: String,
    tail: usize,
    path: PathBuf,
    // creating in new would truncate file
    file: Option<File>,
}

impl ResumeInf {
    #[cold]
    #[inline(never)]
    #[must_use]
    pub fn new(chnks_done: Vec<ChunkComp>, work_dir: &Path) -> Self {
        let mut buf = String::with_capacity(chnks_done.len() * 24 + 64);
        for c in &chnks_done {
            Self::line(&mut buf, c);
        }
        Self {
            chnks_done,
            tail: buf.len(),
            buf,
            path: work_dir.join("done.txt"),
            file: None,
        }
    }

    fn line(buf: &mut String, c: &ChunkComp) {
        _ = writeln!(buf, "{} {} {}", c.idx, c.frames, c.sz);
    }

    pub fn finish(&mut self, comp: ChunkComp) {
        let at = self.tail;
        self.buf.truncate(at);
        Self::line(&mut self.buf, &comp);
        self.tail = self.buf.len();
        let secs = PRIOR_SECS.load(Relaxed)
            + unsafe { ENC_START.get().unwrap_unchecked() }
                .elapsed()
                .as_secs();
        _ = writeln!(self.buf, "elapsed {secs}");
        let from = if self.file.is_none() {
            cold_path();
            self.file = File::create(&self.path).ok();
            0
        } else {
            at
        };
        if let Some(f) = self.file.as_ref() {
            _ = write_at(
                f,
                unsafe { self.buf.get_unchecked(from..) }.as_bytes(),
                from as u64,
            );
        }
    }
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
                Some(r.trim())
                    .filter(|s| !s.is_empty())
                    .map(|s| &*Box::leak(Box::<str>::from(s))),
            ))
        })
        .collect();

    parsed.sort_unstable_by_key(|&(f, _)| f);

    let mut scenes = Vec::new();
    for i in 0..parsed.len() {
        let (s, params) = parsed[i];
        let e = parsed.get(i + 1).map_or(t_frames, |&(f, _)| f);
        scenes.push(Scene {
            s_frame: s,
            e_frame: e,
            params,
        });
    }

    Ok(scenes)
}

pub fn val_scenes(scenes: &[Scene]) -> Result<(), Xerr> {
    for (i, scene) in scenes.iter().enumerate() {
        let len = scene.e_frame.saturating_sub(scene.s_frame);

        if len == 0 || len > MAX_CHNK_FRAMES {
            return Err(format!(
                "Scene {} (frames {}-{}) has invalid length {}: must be up to {} frames",
                i, scene.s_frame, scene.e_frame, len, MAX_CHNK_FRAMES
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
            params: s.params,
        })
        .collect()
}

#[cold]
#[inline(never)]
pub fn zone_tmpls(chnks: &mut [Chunk], scale: u32) -> Vec<&'static str> {
    let mut zones: Vec<&'static str> = Vec::new();
    for c in chnks {
        let Some(p) = c.params else {
            continue;
        };
        c.tmpl = zones.iter().position(|&z| z == p).map_or_else(
            || {
                zones.push(p);
                zones.len() as u32
            },
            |i| i as u32 + 1,
        ) * scale;
    }
    zones
}

pub fn read_done(work_dir: &Path) -> Option<(Vec<ChunkComp>, u64)> {
    let content = read_to_str(work_dir.join("done.txt")).ok()?;
    let mut chnks_done = Vec::new();
    let mut prior_secs = 0u64;

    for line in content.lines() {
        if let Some(s) = line.strip_prefix("elapsed ") {
            prior_secs = s.parse().unwrap_or(0);
            continue;
        }
        let mut it = line.split_whitespace();
        if let (Some(a), Some(b), Some(c), None) = (it.next(), it.next(), it.next(), it.next())
            && let (Ok(idx), Ok(frames), Ok(sz)) =
                (a.parse::<u16>(), b.parse::<usize>(), c.parse::<u64>())
        {
            chnks_done.push(ChunkComp { idx, frames, sz });
        }
    }

    Some((chnks_done, prior_secs))
}

pub fn get_resume(work_dir: &Path) -> Option<ResumeInf> {
    Some(ResumeInf::new(read_done(work_dir)?.0, work_dir))
}

pub fn merge_out(
    args: &Args,
    enc_dir: &Path,
    inf: &VidInf,
    au: &[(AuStream, PathBuf)],
    crop: (u32, u32),
    vary: bool,
) -> Result<(), Xerr> {
    let mut paths: Vec<PathBuf> = Vec::new();
    for e in read_dir(enc_dir)?.filter_map(Result::ok) {
        let p = e.path();
        if !p
            .extension()
            .is_some_and(|ext| ext == args.encoder.extension())
        {
            continue;
        }
        let Some(idx) = p
            .file_stem()
            .and_then(|s| s.to_str())
            .and_then(|s| s.parse::<usize>().ok())
        else {
            cold_path();
            continue;
        };
        if idx >= paths.len() {
            paths.resize_with(idx + 1, PathBuf::new);
        }
        unsafe { *paths.get_unchecked_mut(idx) = p };
    }

    if args.out.extension().is_some_and(|e| e == "webm") {
        let dims = (inf.width - crop.1 * 2, inf.height - crop.0 * 2);
        return mux_webm(&paths, &args.out, inf, dims, au);
    }

    let (enc_w, enc_h) = (inf.width - crop.1 * 2, inf.height - crop.0 * 2);
    #[cfg(feature = "vship")]
    let dtag = args.disp.map(|d| d.tag(enc_w, enc_h));
    #[cfg(feature = "vship")]
    let cvvdp = args.tq.map(|t| t.txt).zip(dtag.as_deref());
    #[cfg(not(feature = "vship"))]
    let cvvdp: Option<(&str, &str)> = None;
    let want_extras = args.ranges.is_none();
    let src = args.inp.as_path();
    let copy_audio = au.is_empty() && want_extras;
    let (chapters, audio, subs) = if want_extras {
        println!();
        _ = stdout().flush();
        let (chapters, streams) = demux_extras(src, copy_audio, true)?;
        if copy_audio {
            let (au_s, sub_s): (Vec<_>, Vec<_>) = streams
                .into_iter()
                .partition(|s| s.codec_type == AVMEDIA_TYPE_AUDIO);
            (chapters, AudioSrc::Copy(au_s), sub_s)
        } else {
            (chapters, AudioSrc::Encode(au), streams)
        }
    } else {
        (Vec::new(), AudioSrc::Encode(au), Vec::new())
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
            vary,
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
                .and_then(|sc| sc.params);
            out.push(Scene {
                s_frame: s,
                e_frame: e.min(re + 1),
                params,
            });
        }
    }
    out
}
