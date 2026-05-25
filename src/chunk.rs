use std::{
    ffi::{CString, c_void},
    fmt::Write as _,
    fs::{DirEntry, File, read_dir, read_to_string as read_to_str, write},
    io::{Read as _, Seek as _, SeekFrom, Write as _, copy},
    mem::size_of,
    os::raw::c_int,
    path::{Path, PathBuf},
    ptr::{null, null_mut},
    sync::{
        OnceLock,
        atomic::{AtomicU64, Ordering::Relaxed},
    },
    time::Instant,
};

use crate::{
    audio::{AuStream, lang_name},
    encoder::{Encoder, Encoder::Avm},
    error::Xerr,
    ffms::{
        AV_NOPTS_VALUE, AVChapter, AVCodecParameters, AVFMT_FLAG_BITEXACT, AVFormatContext,
        AVIO_FLAG_WRITE, AVMEDIA_TYPE_AUDIO, AVMEDIA_TYPE_SUBTITLE, AVMEDIA_TYPE_VIDEO, AVPacket,
        AVRational, AVSEEK_FLAG_BACKWARD, AVStream, VidInf, av_dict_copy, av_dict_free,
        av_dict_set, av_find_best_stream, av_interleaved_write_frame, av_mallocz, av_packet_alloc,
        av_packet_free, av_packet_rescale_ts, av_packet_unref, av_read_frame, av_seek_frame,
        av_write_trailer, avcodec_parameters_copy, avformat_alloc_output_context2,
        avformat_close_input, avformat_find_stream_info, avformat_free_context,
        avformat_new_stream, avformat_open_input, avformat_query_codec, avformat_write_header,
        avio_closep, avio_open, gcd,
    },
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
    let mut out = File::create(out)?;

    for (i, file) in files.iter().enumerate() {
        let mut f = File::open(file)?;
        if i != 0 {
            let mut buf = [0u8; 32];
            f.read_exact(&mut buf)?;
        }
        copy(&mut f, &mut out)?;
    }

    out.seek(SeekFrom::Start(24))?;
    out.write_all(&tot_frames.to_le_bytes())?;

    Ok(())
}

fn open_in(path: &Path) -> Result<*mut AVFormatContext, Xerr> {
    let c = CString::new(path.to_str().ok_or("invalid input path")?)?;
    let mut ctx: *mut AVFormatContext = null_mut();
    unsafe {
        if avformat_open_input(&raw mut ctx, c.as_ptr(), null(), null_mut()) < 0 {
            return Err("could not open input".into());
        }
        if avformat_find_stream_info(ctx, null_mut()) < 0 {
            avformat_close_input(&raw mut ctx);
            return Err("could not read stream info".into());
        }
    }
    Ok(ctx)
}

fn close_in(ctx: *mut AVFormatContext) {
    if !ctx.is_null() {
        let mut c = ctx;
        unsafe { avformat_close_input(&raw mut c) };
    }
}

fn ostream(ctx: *mut AVFormatContext, idx: c_int) -> *mut AVStream {
    unsafe { *(*ctx).streams.add(idx as usize) }
}

fn best(ctx: *mut AVFormatContext, kind: c_int) -> c_int {
    unsafe { av_find_best_stream(ctx, kind, -1, -1, null_mut(), 0) }
}

fn add_stream(octx: *mut AVFormatContext, par: *const AVCodecParameters) -> Option<c_int> {
    unsafe {
        let os = avformat_new_stream(octx, null());
        (!os.is_null() && avcodec_parameters_copy((*os).codecpar, par) >= 0).then(|| (*os).index)
    }
}

fn set_meta(st: *mut AVStream, key: &str, val: &str) {
    if let (Ok(k), Ok(v)) = (CString::new(key), CString::new(val)) {
        unsafe { av_dict_set(&raw mut (*st).metadata, k.as_ptr(), v.as_ptr(), 0) };
    }
}

fn add_video(octx: *mut AVFormatContext, chnk0: &Path, inf: &VidInf) -> Result<c_int, Xerr> {
    let cin = open_in(chnk0)?;
    let v = best(cin, AVMEDIA_TYPE_VIDEO);
    let res = if v < 0 {
        Err("no video stream in chunk".into())
    } else {
        add_stream(octx, unsafe { (*ostream(cin, v)).codecpar })
            .ok_or_else(|| Xerr::from("could not init video stream"))
    };
    close_in(cin);
    let oi = res?;
    let ov = ostream(octx, oi);
    unsafe {
        (*ov).time_base = AVRational {
            num: inf.fps_den as c_int,
            den: inf.fps_num as c_int,
        };
        (*ov).avg_frame_rate = AVRational {
            num: inf.fps_num as c_int,
            den: inf.fps_den as c_int,
        };
        if let Some((dw, dh)) = inf.dar {
            let n = u64::from(dw) * u64::from(inf.height);
            let d = u64::from(dh) * u64::from(inf.width);
            let g = gcd(n, d).max(1);
            (*(*ov).codecpar).sample_aspect_ratio = AVRational {
                num: (n / g) as c_int,
                den: (d / g) as c_int,
            };
        }
    }
    Ok(oi)
}

fn add_opus(
    octx: *mut AVFormatContext,
    au: &[(AuStream, PathBuf)],
) -> Vec<(*mut AVFormatContext, c_int, c_int)> {
    let mut maps = Vec::new();
    for entry in au {
        let Ok(ai) = open_in(&entry.1) else { continue };
        let si = best(ai, AVMEDIA_TYPE_AUDIO);
        let oi = if si < 0 {
            None
        } else {
            add_stream(octx, unsafe { (*ostream(ai, si)).codecpar })
        };
        match oi {
            Some(oi) => {
                let code = entry.0.lang.as_deref().unwrap_or("und");
                set_meta(ostream(octx, oi), "language", code);
                set_meta(ostream(octx, oi), "title", lang_name(code));
                maps.push((ai, si, oi));
            }
            None => close_in(ai),
        }
    }
    maps
}

fn add_src_streams(
    octx: *mut AVFormatContext,
    oformat: *const c_void,
    src_ctx: *mut AVFormatContext,
    passthrough_au: bool,
) -> Vec<(c_int, c_int)> {
    let mut maps = Vec::new();
    if src_ctx.is_null() {
        return maps;
    }
    unsafe {
        for i in 0..(*src_ctx).nb_streams {
            let ist = *(*src_ctx).streams.add(i as usize);
            let par = (*ist).codecpar;
            let kind = (*par).codec_type;
            let want =
                (kind == AVMEDIA_TYPE_AUDIO && passthrough_au) || kind == AVMEDIA_TYPE_SUBTITLE;
            if want
                && avformat_query_codec(oformat, (*par).codec_id, 0) != 0
                && let Some(oi) = add_stream(octx, par)
            {
                av_dict_copy(&raw mut (*ostream(octx, oi)).metadata, (*ist).metadata, 0);
                maps.push(((*ist).index, oi));
            }
        }
    }
    maps
}

fn cpy_chapters(octx: *mut AVFormatContext, src_ctx: *mut AVFormatContext) {
    unsafe {
        let n = (*src_ctx).nb_chapters;
        if n == 0 {
            return;
        }
        let arr = av_mallocz(n as usize * size_of::<*mut AVChapter>()).cast::<*mut AVChapter>();
        for i in 0..n as usize {
            let inc = *(*src_ctx).chapters.add(i);
            let oc = av_mallocz(size_of::<AVChapter>()).cast::<AVChapter>();
            (*oc).id = (*inc).id;
            (*oc).time_base = (*inc).time_base;
            (*oc).start = (*inc).start;
            (*oc).end = (*inc).end;
            av_dict_copy(&raw mut (*oc).metadata, (*inc).metadata, 0);
            *arr.add(i) = oc;
        }
        (*octx).chapters = arr;
        (*octx).nb_chapters = n;
    }
}

const TB_US: AVRational = AVRational {
    num: 1,
    den: 1_000_000,
};

fn rescale(a: i64, src: AVRational, dst: AVRational) -> i64 {
    let d = i128::from(src.den) * i128::from(dst.num);
    if d == 0 {
        return 0;
    }
    let n = i128::from(a) * i128::from(src.num) * i128::from(dst.den);
    let h = d.abs() / 2;
    (if n >= 0 { (n + h) / d } else { (n - h) / d }) as i64
}

fn pkt_us(pkt: *mut AVPacket, tb: AVRational) -> i64 {
    let ts = unsafe {
        if (*pkt).dts == AV_NOPTS_VALUE {
            (*pkt).pts
        } else {
            (*pkt).dts
        }
    };
    if ts == AV_NOPTS_VALUE {
        0
    } else {
        rescale(ts, tb, TB_US)
    }
}

struct VidSt {
    chnks: Vec<PathBuf>,
    idx: usize,
    ctx: *mut AVFormatContext,
    cv: c_int,
    frame: i64,
    fps_tb: AVRational,
    vidx: c_int,
}

struct Splice {
    fps: AVRational,
    map: Vec<(i64, i64, i64)>,
}

enum Src {
    Video(VidSt),
    Stream {
        ctx: *mut AVFormatContext,
        maps: Vec<(c_int, c_int)>,
        splice: Option<Splice>,
    },
}

struct Feed {
    src: Src,
    pkt: *mut AVPacket,
    has: bool,
    done: bool,
    time: i64,
    oi: c_int,
    in_tb: AVRational,
}

fn fill_video(pkt: *mut AVPacket, v: &mut VidSt) -> Option<(i64, c_int, AVRational)> {
    loop {
        if v.ctx.is_null() {
            let path = v.chnks.get(v.idx)?;
            v.idx += 1;
            if let Ok(c) = open_in(path) {
                v.ctx = c;
                v.cv = best(c, AVMEDIA_TYPE_VIDEO);
                if v.cv < 0 {
                    close_in(v.ctx);
                    v.ctx = null_mut();
                }
            }
            continue;
        }
        if unsafe { av_read_frame(v.ctx, pkt) } < 0 {
            close_in(v.ctx);
            v.ctx = null_mut();
            continue;
        }
        if unsafe { (*pkt).stream_index } != v.cv {
            unsafe { av_packet_unref(pkt) };
            continue;
        }
        unsafe {
            (*pkt).pts = v.frame;
            (*pkt).dts = v.frame;
            (*pkt).duration = 1;
        }
        let t = rescale(v.frame, v.fps_tb, TB_US);
        v.frame += 1;
        return Some((t, v.vidx, v.fps_tb));
    }
}

fn build_splice(ranges: &[(usize, usize)], fps: AVRational) -> Splice {
    let mut map = Vec::with_capacity(ranges.len());
    let mut off: i64 = 0;
    for &(s, e) in ranges {
        let s = s as i64;
        let ee = e as i64 + 1;
        map.push((s, ee, off));
        off += ee - s;
    }
    Splice { fps, map }
}

fn splice_pkt(pkt: *mut AVPacket, tb: AVRational, sp: &Splice) -> Option<i64> {
    let pts = unsafe { (*pkt).pts };
    if pts == AV_NOPTS_VALUE {
        return None;
    }
    let dur = unsafe { (*pkt).duration }.max(0);
    for &(s, ee, off) in &sp.map {
        let s_t = rescale(s, sp.fps, tb);
        let e_t = rescale(ee, sp.fps, tb);
        if pts >= s_t && pts < e_t {
            let out_pts = pts - s_t + rescale(off, sp.fps, tb);
            unsafe {
                (*pkt).pts = out_pts;
                (*pkt).dts = out_pts;
                (*pkt).duration = dur.min(e_t - pts);
            }
            return Some(out_pts);
        }
    }
    None
}

fn fill_stream(
    pkt: *mut AVPacket,
    ctx: *mut AVFormatContext,
    maps: &[(c_int, c_int)],
    splice: Option<&Splice>,
) -> Option<(i64, c_int, AVRational)> {
    let max_e_us: i64 = splice
        .and_then(|sp| {
            sp.map
                .iter()
                .map(|&(_, ee, _)| rescale(ee, sp.fps, TB_US))
                .max()
        })
        .unwrap_or(i64::MAX);
    loop {
        if unsafe { av_read_frame(ctx, pkt) } < 0 {
            return None;
        }
        let si = unsafe { (*pkt).stream_index };
        if let Some(&(_, oi)) = maps.iter().find(|&&(s, _)| s == si) {
            let in_tb = unsafe { (*ostream(ctx, si)).time_base };
            match splice {
                Some(sp) => {
                    if let Some(op) = splice_pkt(pkt, in_tb, sp) {
                        return Some((rescale(op, in_tb, TB_US), oi, in_tb));
                    }
                    let pts = unsafe { (*pkt).pts };
                    unsafe { av_packet_unref(pkt) };
                    if pts != AV_NOPTS_VALUE && rescale(pts, in_tb, TB_US) > max_e_us {
                        return None;
                    }
                    continue;
                }
                None => return Some((pkt_us(pkt, in_tb), oi, in_tb)),
            }
        }
        unsafe { av_packet_unref(pkt) };
    }
}

impl Feed {
    fn video(chnks: Vec<PathBuf>, fps_tb: AVRational, vidx: c_int) -> Self {
        Self {
            src: Src::Video(VidSt {
                chnks,
                idx: 0,
                ctx: null_mut(),
                cv: -1,
                frame: 0,
                fps_tb,
                vidx,
            }),
            pkt: unsafe { av_packet_alloc() },
            has: false,
            done: false,
            time: 0,
            oi: vidx,
            in_tb: fps_tb,
        }
    }

    fn stream(
        ctx: *mut AVFormatContext,
        maps: Vec<(c_int, c_int)>,
        splice: Option<Splice>,
    ) -> Self {
        Self {
            src: Src::Stream { ctx, maps, splice },
            pkt: unsafe { av_packet_alloc() },
            has: false,
            done: false,
            time: 0,
            oi: -1,
            in_tb: AVRational { num: 0, den: 1 },
        }
    }

    fn fill(&mut self) {
        let pkt = self.pkt;
        let r = match self.src {
            Src::Video(ref mut v) => fill_video(pkt, v),
            Src::Stream {
                ref mut ctx,
                ref mut maps,
                ref splice,
            } => fill_stream(pkt, *ctx, maps, splice.as_ref()),
        };
        match r {
            Some((time, oi, in_tb)) => {
                self.time = time;
                self.oi = oi;
                self.in_tb = in_tb;
                self.has = true;
            }
            None => self.done = true,
        }
    }

    fn write(&mut self, octx: *mut AVFormatContext) {
        unsafe {
            let out_tb = (*ostream(octx, self.oi)).time_base;
            (*self.pkt).stream_index = self.oi;
            av_packet_rescale_ts(self.pkt, self.in_tb, out_tb);
            _ = av_interleaved_write_frame(octx, self.pkt);
            av_packet_unref(self.pkt);
        }
        self.has = false;
    }

    fn close(self) {
        let mut p = self.pkt;
        unsafe { av_packet_free(&raw mut p) };
        if let Src::Video(v) = self.src {
            close_in(v.ctx);
        }
    }
}

fn mux_streams(octx: *mut AVFormatContext, feeds: &mut [Feed]) {
    loop {
        for f in feeds.iter_mut() {
            if !f.has && !f.done {
                f.fill();
            }
        }
        let pick = feeds
            .iter()
            .enumerate()
            .filter(|&(_, f)| f.has)
            .min_by_key(|&(_, f)| f.time)
            .map(|(i, _)| i);
        match pick {
            Some(i) => feeds[i].write(octx),
            None => break,
        }
    }
}

fn remux(
    chnks: &[PathBuf],
    au: &[(AuStream, PathBuf)],
    src: Option<&Path>,
    ranges: Option<&[(usize, usize)]>,
    out: &Path,
    inf: &VidInf,
) -> Result<(), Xerr> {
    let first = chnks.first().ok_or("no encoded chunks to mux")?;
    let out_c = CString::new(out.to_str().ok_or("invalid output path")?)?;

    let mut octx: *mut AVFormatContext = null_mut();
    if unsafe { avformat_alloc_output_context2(&raw mut octx, null(), null(), out_c.as_ptr()) } < 0
        || octx.is_null()
    {
        return Err("could not create output container".into());
    }
    let oformat = unsafe { (*octx).oformat };

    let vidx = match add_video(octx, first, inf) {
        Ok(v) => v,
        Err(e) => {
            unsafe { avformat_free_context(octx) };
            return Err(e);
        }
    };

    let src_ctx = src.map_or(null_mut(), |s| open_in(s).unwrap_or(null_mut()));

    let opus = add_opus(octx, au);
    let src_maps = add_src_streams(octx, oformat, src_ctx, au.is_empty() && ranges.is_none());
    if ranges.is_none() && !src_ctx.is_null() {
        cpy_chapters(octx, src_ctx);
    }
    let splice = ranges.map(|r| {
        build_splice(
            r,
            AVRational {
                num: inf.fps_den as c_int,
                den: inf.fps_num as c_int,
            },
        )
    });

    if !src_ctx.is_null()
        && let Some(rs) = ranges
        && let Some(min_s) = rs.iter().map(|&(s, _)| s as i64).min()
    {
        let ts = min_s * 1_000_000 * i64::from(inf.fps_den) / i64::from(inf.fps_num);
        unsafe { av_seek_frame(src_ctx, -1, ts, AVSEEK_FLAG_BACKWARD) };
    }

    unsafe { (*octx).flags |= AVFMT_FLAG_BITEXACT };

    let avio_ok = unsafe { avio_open(&raw mut (*octx).pb, out_c.as_ptr(), AVIO_FLAG_WRITE) } >= 0;
    let mut err = (!avio_ok).then_some("could not open output file");

    if avio_ok {
        let mut opts: *mut c_void = null_mut();
        if let (Ok(k), Ok(v)) = (CString::new("write_crc32"), CString::new("0")) {
            unsafe { av_dict_set(&raw mut opts, k.as_ptr(), v.as_ptr(), 0) };
        }
        let hdr = unsafe { avformat_write_header(octx, &raw mut opts) };
        unsafe { av_dict_free(&raw mut opts) };

        if hdr < 0 {
            err = Some("could not write container header");
        } else {
            let mut feeds: Vec<Feed> = Vec::with_capacity(opus.len() + 2);
            feeds.push(Feed::video(
                chnks.to_vec(),
                AVRational {
                    num: inf.fps_den as c_int,
                    den: inf.fps_num as c_int,
                },
                vidx,
            ));
            for entry in &opus {
                feeds.push(Feed::stream(entry.0, vec![(entry.1, entry.2)], None));
            }
            if !src_ctx.is_null() && !src_maps.is_empty() {
                feeds.push(Feed::stream(src_ctx, src_maps, splice));
            }
            mux_streams(octx, &mut feeds);
            unsafe { av_write_trailer(octx) };
            for f in feeds {
                f.close();
            }
        }
        unsafe { avio_closep(&raw mut (*octx).pb) };
    }

    for entry in &opus {
        close_in(entry.0);
    }
    close_in(src_ctx);
    unsafe { avformat_free_context(octx) };

    err.map_or(Ok(()), |e| Err(e.into()))
}

pub fn merge_out(
    enc_dir: &Path,
    out: &Path,
    inf: &VidInf,
    encoder: Encoder,
    au: &[(AuStream, PathBuf)],
    src: Option<&Path>,
    ranges: Option<&[(usize, usize)]>,
) -> Result<(), Xerr> {
    let mut files: Vec<_> = read_dir(enc_dir)?
        .filter_map(Result::ok)
        .filter(|e| {
            e.path()
                .extension()
                .is_some_and(|ext| ext == encoder.extension())
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

    if encoder == Avm {
        return concat_ivf(&paths, out, inf.frames as u32);
    }

    remux(&paths, au, src, ranges, out, inf)
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
