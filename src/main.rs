#[cfg(unix)]
use std::process::{Command, Stdio};
use std::{
    collections::hash_map::DefaultHasher,
    env::args as env_args,
    fs::{
        create_dir_all, read_to_string as read_to_str, remove_dir_all as rm_dir_all,
        remove_file as rm_file, write as write_to,
    },
    hash::{Hash as _, Hasher as _},
    io::{Write as _, stdout},
    mem::transmute_copy,
    panic::set_hook,
    path::{Path, PathBuf},
    sync::atomic::Ordering::Relaxed,
    thread::{JoinHandle, available_parallelism, spawn},
    time::{Duration as Durat, Instant},
};

use libc::{_exit, SIGINT, SIGSEGV, atexit, signal};

use crate::{
    encoder::Encoder::{Avm, SvtAv1},
    error::Xerr::{Help, Msg},
};

mod audio;
mod byte_range;
mod chunk;
mod copy;
mod crop;
#[cfg(feature = "vship")]
mod dav1d;
mod dec;
mod enc;
mod encoder;
mod error;
mod ffms;
#[cfg(feature = "vship")]
mod interp;
mod lang;
mod lavf;
mod mkv;
mod mkv_mux;
mod mux_webm;
mod nal_config;
mod nal_parse;
mod nal_scan;
mod obu_parse;
mod ogg;
mod opus;
mod pack;
pub mod pipeline;
mod platform;
mod progs;
mod scd;
mod svt;
mod svterr;
#[cfg(feature = "vship")]
mod tq;
#[cfg(target_os = "linux")]
mod uring;
mod util;
#[cfg(feature = "vship")]
mod vship;
mod worker;
mod y4m;

use audio::{AuSpec, AuStream, enc_au_streams, frame_samp, parse_au_arg};
use chunk::{
    Chunk, Scene, chnkify, get_resume, init_elapsed, load_scenes, merge_out, trans_scenes,
    val_scenes,
};
use crop::{CropConf, detect_crop};
use enc::enc_all;
use encoder::Encoder;
use error::{IN_ALT_SCREEN, Xerr, eprint, fatal};
use ffms::{DecStrat, VidDecoder, VidInf, get_dec_strat, get_vidinf, vid_bytes};
use scd::fd_scenes;
use svterr::val;
#[cfg(target_os = "linux")]
use y4m::vspipe_resume;
use y4m::{PipeReader, init_pipe, is_pipe};

#[cfg(test)]
#[allow(clippy::unwrap_used, clippy::expect_used, clippy::panic)]
mod tests;

use util::{B, C, G, N, P, R, W, Y};

#[derive(Clone)]
pub struct Args {
    pub encoder: Encoder,
    pub worker: usize,
    pub sc_file: PathBuf,
    pub params: String,
    pub au: Option<AuSpec>,
    pub inp: PathBuf,
    pub out: PathBuf,
    pub dec_strat: Option<DecStrat>,
    pub chnk_buff: usize,
    pub ranges: Option<Vec<(usize, usize)>>,
    #[cfg(feature = "vship")]
    pub qp_range: Option<String>,
    #[cfg(feature = "vship")]
    pub metric_worker: usize,
    #[cfg(feature = "vship")]
    pub tq: Option<String>,
    #[cfg(feature = "vship")]
    pub metric_mode: String,
    #[cfg(feature = "vship")]
    pub cvvdp_conf: Option<String>,
    #[cfg(feature = "vship")]
    pub alt_param: Option<String>,
    pub sc_only: bool,
    pub hwdec: bool,
}

extern "C" fn restore() {
    if IN_ALT_SCREEN.load(Relaxed) {
        print!("\x1b[?25h\x1b[?1049l");
        _ = stdout().flush();
    }
}
extern "C" fn exit_restore(_: i32) {
    restore();
    unsafe { _exit(130) };
}

#[rustfmt::skip]
fn print_help() {
    println!("{P}Format: {Y}xav {C}[options] {G}<INPUT> {B}[<OUTPUT>]{W}");
    println!();
    println!("{C}-e {P}┃ {C}--encoder    {W}Encoder used: {R}<{G}svt-av1{P}┃{G}avm{P}┃{G}vvenc{P}┃{G}x265{P}┃{G}x264{R}>");
    println!("{C}-w {P}┃ {C}--worker     {W}Encoder count");
    println!("{C}-b {P}┃ {C}--buff       {W}Extra chunks to pre-decode");
    println!("{C}-p {P}┃ {C}--param      {W}Encoder params");
    println!("{C}-s {P}┃ {C}--sc         {W}Specify SCD file");
    println!("   {P}┃ {C}--sc-only    {W}Exit after SCD");
    println!("   {P}┃ {C}--hwdec      {W}Use GPU decode");
    println!("{C}-r {P}┃ {C}--range      {W}Trim and splice: {G}\"10-20,90-100\"");
    println!("{C}-a {P}┃ {C}--audio      {W}Opus Enc: {Y}-a {G}\"{R}<{G}auto{P}┃{G}norm{P}┃{G}bitrate{R}> {R}<{G}all{P}┃{G}stream_ids{R}>{G}\"");
    println!("   {P}┃ {C}--guide      {W}Fullscreen and Nerd Fonts recommended");
    #[cfg(feature = "vship")]
    {
        println!("{C}-t {P}┃ {C}--tq         {W}TQ Range: {R}<8{B}={W}Butter, {R}8-10{B}={W}CVVDP, {R}>10{B}={W}SSIMU2");
        println!("{C}-m {P}┃ {C}--mode       {W}TQ Metric stat: {G}mean {W}or pN%");
        println!("{C}-f {P}┃ {C}--qp         {W}CRF range for TQ: {G}crf-crf{W}");
        println!("{C}-v {P}┃ {C}--vship      {W}Metric worker count");
        println!("{C}-d {P}┃ {C}--display    {W}CVVDP display file. Set screen name as {R}xav{W}");
        println!("{C}-P {P}┃ {C}--alt-param  {W}Alt params for TQ probes ({R}NOT RECOMMENDED{W}; expert-only)");
    }
}

fn print_guide() {
    let guide = include_str!("guide.txt")
        .replace("{G}", G)
        .replace("{R}", R)
        .replace("{B}", B)
        .replace("{P}", P)
        .replace("{Y}", Y)
        .replace("{C}", C)
        .replace("{W}", W);

    #[cfg(unix)]
    if let Ok(mut pager) = Command::new("less")
        .args(["-R", "-F", "-n"])
        .env("LESSUTFCHARDEF", "E000-F8FF:p,F0000-FFFFD:p")
        .stdin(Stdio::piped())
        .spawn()
    {
        if let Some(mut si) = pager.stdin.take() {
            _ = si.write_all(guide.as_bytes());
        }
        _ = pager.wait();
        return;
    }

    print!("{guide}");
    _ = stdout().flush();
}

fn parse_args() -> Result<Args, Xerr> {
    let args: Vec<String> = env_args().collect();
    match get_args(&args, true) {
        Ok(args) => Ok(args),
        Err(Help) => Err(Help),
        Err(e) => {
            eprint(format_args!("\n{R}Error: {e}{N}\n"));
            fatal("argument parsing failed");
        }
    }
}

fn parse_ranges(s: &str) -> Result<Vec<(usize, usize)>, Xerr> {
    s.split(',')
        .map(|p| {
            let (a, b) = p.trim().split_once('-').ok_or("invalid range")?;
            Ok((a.trim().parse()?, b.trim().parse()?))
        })
        .collect()
}

fn apply_defaults(args: &mut Args) {
    if args.out == PathBuf::new() {
        let stem = unsafe { args.inp.file_stem().unwrap_unchecked() }.to_string_lossy();
        let ext = if args.encoder == Avm { "ivf" } else { "mkv" };
        args.out = args.inp.with_file_name(format!("{stem}_xav.{ext}"));
    }

    if args.sc_file == PathBuf::new() {
        let stem = unsafe { args.inp.file_stem().unwrap_unchecked() }.to_string_lossy();
        args.sc_file = args.inp.with_file_name(format!("{stem}_scd.txt"));
    }

    #[cfg(feature = "vship")]
    {
        if args.tq.is_some() && args.qp_range.is_none() {
            args.qp_range = Some("8.0-48.0".to_owned());
        }
    }
}

fn next_arg<'a>(args: &'a [String], i: &mut usize) -> Option<&'a str> {
    *i += 1;
    args.get(*i).map(String::as_str)
}

fn val_out(out: &Path, encoder: Encoder) -> Result<(), Xerr> {
    let ext = out.extension().and_then(|e| e.to_str()).unwrap_or("");
    match (encoder, ext) {
        (Avm, "ivf") | (SvtAv1, "webm") => Ok(()),
        (Avm, _) => Err(format!("Invalid extension .{ext} for {encoder:?}. Use: ivf").into()),
        (_, "mkv") => Ok(()),
        (_, "webm") => Err(format!("webm output requires svt-av1, not {encoder:?}").into()),
        _ => Err(format!("Invalid extension .{ext} for {encoder:?}. Use: mkv, webm").into()),
    }
}

#[cfg(feature = "vship")]
fn val_range(s: &str, name: &str) -> Result<(), Xerr> {
    let parts: Vec<f32> = s.split('-').filter_map(|v| v.parse().ok()).collect();
    if parts.len() != 2 {
        return Err(format!("{name} requires a range: <min>-<max>").into());
    }
    if parts[0] >= parts[1] {
        return Err(format!("{name} min must be less than max: {s}").into());
    }
    Ok(())
}

macro_rules! arg {
    (str $a:ident, $i:ident, $v:expr) => {
        if let Some(v) = next_arg($a, &mut $i) {
            $v = v.to_string();
        }
    };
    (opt $a:ident, $i:ident, $v:expr) => {
        if let Some(v) = next_arg($a, &mut $i) {
            $v = Some(v.to_string());
        }
    };
    (parse $a:ident, $i:ident, $v:expr) => {
        if let Some(v) = next_arg($a, &mut $i) {
            $v = v.parse()?;
        }
    };
    (opt_parse $a:ident, $i:ident, $v:expr) => {
        if let Some(v) = next_arg($a, &mut $i) {
            $v = Some(v.parse()?);
        }
    };
    (path $a:ident, $i:ident, $v:expr) => {
        if let Some(v) = next_arg($a, &mut $i) {
            $v = PathBuf::from(v);
        }
    };
}

fn parse_args_loop(args: &[String]) -> Result<Args, Xerr> {
    let (mut worker, mut chnk_buff, mut sc_only, mut hwdec) = (1usize, None, false, false);
    let (mut sc_file, mut inp, mut out) = (PathBuf::new(), PathBuf::new(), PathBuf::new());
    let (mut encoder, mut params) = (Encoder::default(), String::new());
    let (mut au, mut ranges) = (None, None);
    #[cfg(feature = "vship")]
    let (mut tq, mut qp_range, mut cvvdp_conf, mut alt_param) = (
        None::<String>,
        None::<String>,
        None::<String>,
        None::<String>,
    );
    #[cfg(feature = "vship")]
    let (mut metric_mode, mut metric_worker) = ("mean".to_owned(), 1usize);

    let mut i = 1;
    while i < args.len() {
        match args[i].as_str() {
            "-e" | "--encoder" => {
                if let Some(v) = next_arg(args, &mut i) {
                    encoder =
                        Encoder::from_str(v).ok_or_else(|| format!("Unknown encoder: {v}"))?;
                }
            }
            "-w" | "--worker" => arg!(parse args, i, worker),
            "-s" | "--sc" => arg!(path args, i, sc_file),
            "-p" | "--param" => arg!(str args, i, params),
            "-b" | "--buff" => arg!(opt_parse args, i, chnk_buff),
            "-r" | "--range" => {
                if let Some(v) = next_arg(args, &mut i) {
                    ranges = Some(parse_ranges(v)?);
                }
            }
            "-a" | "--audio" => {
                if let Some(v) = next_arg(args, &mut i) {
                    au = Some(parse_au_arg(v)?);
                }
            }
            #[cfg(feature = "vship")]
            "-t" | "--tq" => arg!(opt args, i, tq),
            #[cfg(feature = "vship")]
            "-m" | "--mode" => arg!(str args, i, metric_mode),
            #[cfg(feature = "vship")]
            "-f" | "--qp" => arg!(opt args, i, qp_range),
            #[cfg(feature = "vship")]
            "-v" | "--vship" => arg!(parse args, i, metric_worker),
            #[cfg(feature = "vship")]
            "-d" | "--display" => arg!(opt args, i, cvvdp_conf),
            #[cfg(feature = "vship")]
            "-P" | "--alt-param" => arg!(opt args, i, alt_param),
            "--hwdec" => hwdec = true,
            "--sc-only" => sc_only = true,
            "-h" | "--help" => {
                print_help();
                return Err(Help);
            }
            "--guide" => {
                print_guide();
                return Err(Help);
            }
            arg if !arg.starts_with('-') => {
                if inp == PathBuf::new() {
                    inp = PathBuf::from(arg);
                } else if out == PathBuf::new() {
                    out = PathBuf::from(arg);
                }
            }
            _ => return Err(format!("Unknown arg: {}", args[i]).into()),
        }
        i += 1;
    }

    Ok(Args {
        encoder,
        worker,
        sc_file,
        params,
        au,
        inp,
        out,
        dec_strat: None,
        chnk_buff: worker + chnk_buff.unwrap_or(0),
        ranges,
        sc_only,
        hwdec,
        #[cfg(feature = "vship")]
        tq,
        #[cfg(feature = "vship")]
        metric_mode,
        #[cfg(feature = "vship")]
        qp_range,
        #[cfg(feature = "vship")]
        metric_worker,
        #[cfg(feature = "vship")]
        cvvdp_conf,
        #[cfg(feature = "vship")]
        alt_param,
    })
}

fn get_args(args: &[String], allow_resume: bool) -> Result<Args, Xerr> {
    if args.len() < 2 {
        return Err("Usage: xav [options] <input> <output>".into());
    }

    let mut result = parse_args_loop(args)?;

    if result.inp == PathBuf::new() {
        return Err("Missing input".into());
    }

    if allow_resume && let Ok(saved_args) = get_saved_args(&result.inp) {
        return Ok(saved_args);
    }
    if result.out != PathBuf::new() {
        val_out(&result.out, result.encoder)?;
    }

    apply_defaults(&mut result);

    #[cfg(feature = "vship")]
    if let Some(ref tq) = result.tq {
        val_range(tq, "-t/--tq")?;
        val_range(
            unsafe { result.qp_range.as_ref().unwrap_unchecked() },
            "-f/--qp",
        )?;
    }

    if result.encoder == SvtAv1 {
        val(&result.params)?;
        #[cfg(feature = "vship")]
        if let Some(ref pp) = result.alt_param {
            val(pp)?;
        }
    }

    if result.hwdec && is_pipe() {
        return Err("Hardware accelerated decoding can not be used with a pipe".into());
    }

    Ok(result)
}

fn hash_inp(path: &Path) -> String {
    let canon = path.canonicalize().unwrap_or_else(|_| path.to_path_buf());
    let mut hasher = DefaultHasher::new();
    canon.hash(&mut hasher);
    format!("{:x}", hasher.finish())
}

fn save_args(work_dir: &Path) -> Result<(), Xerr> {
    let cmd: Vec<String> = env_args().collect();
    let quoted_cmd: Vec<String> = cmd
        .iter()
        .map(|arg| {
            if arg.contains(' ') {
                format!("\"{arg}\"")
            } else {
                arg.clone()
            }
        })
        .collect();
    write_to(work_dir.join("cmd.txt"), quoted_cmd.join(" "))?;
    Ok(())
}

fn get_saved_args(inp: &Path) -> Result<Args, Xerr> {
    let canon = inp.canonicalize()?;
    let hash = hash_inp(&canon);
    let work_dir = canon.with_file_name(format!(".{}", &hash[..7]));
    let cmd_path = work_dir.join("cmd.txt");

    if cmd_path.exists() && get_resume(&work_dir).is_some_and(|r| !r.chnks_done.is_empty()) {
        let cmd_line = read_to_str(cmd_path)?;
        let saved_args = parse_quoted_args(&cmd_line);
        get_args(&saved_args, false)
    } else {
        Err("No tmp dir found".into())
    }
}

fn parse_quoted_args(cmd_line: &str) -> Vec<String> {
    let mut args = Vec::new();
    let mut current_arg = String::new();
    let mut in_quotes = false;

    for ch in cmd_line.chars() {
        match ch {
            '"' => in_quotes = !in_quotes,
            ' ' if !in_quotes => {
                if !current_arg.is_empty() {
                    args.push(current_arg.clone());
                    current_arg.clear();
                }
            }
            _ => current_arg.push(ch),
        }
    }

    if !current_arg.is_empty() {
        args.push(current_arg);
    }

    args
}

fn ensure_sc_file(args: &Args, inf: &VidInf, crop: (u32, u32), line: usize) -> Result<(), Xerr> {
    if !args.sc_file.exists() {
        fd_scenes(&args.inp, &args.sc_file, inf, crop, line, args.hwdec)?;
    }
    Ok(())
}

const fn scale_crop(
    crop: (u32, u32),
    orig_w: u32,
    orig_h: u32,
    pipe_w: u32,
    pipe_h: u32,
) -> (u32, u32) {
    let (cv, ch) = crop;
    let scaled_v = (cv * pipe_h / orig_h) & !1;
    let scaled_h = (ch * pipe_w / orig_w) & !1;
    (scaled_v, scaled_h)
}

fn init_pipe_crop(
    inf: VidInf,
    crop: (u32, u32),
    pipe_start: usize,
) -> (VidInf, (u32, u32), Option<PipeReader>) {
    let pipe_init = init_pipe(pipe_start);

    if let Some((y, reader)) = pipe_init {
        let (cv, ch) = crop;
        let target_w = inf.width - ch * 2;
        let target_h = inf.height - cv * 2;
        let match_orig_ar = y.width * inf.height == y.height * inf.width;
        let match_crop_ar = y.width * target_h == y.height * target_w;
        let new_crop = if match_crop_ar {
            (0, 0)
        } else if match_orig_ar {
            scale_crop(crop, inf.width, inf.height, y.width, y.height)
        } else {
            (0, 0)
        };
        let mut inf = inf;
        inf.width = y.width;
        inf.height = y.height;
        inf.is_10b = y.is_10b;
        inf.dar = None;
        (inf, new_crop, Some(reader))
    } else {
        (inf, crop, None)
    }
}

fn acq_au(
    spec: &AuSpec,
    cached: Option<Vec<(AuStream, PathBuf)>>,
    args: &Args,
    inf: &VidInf,
    work_dir: &Path,
) -> Result<Vec<(AuStream, PathBuf)>, Xerr> {
    if let Some(f) = cached {
        return Ok(f);
    }
    print!("\x1b[H\x1b[2J");
    _ = stdout().flush();
    let samp_ranges = args.ranges.as_ref().map(|r| {
        r.iter()
            .map(|&(s, e)| {
                (
                    frame_samp(s, inf.fps_num, inf.fps_den, 48000),
                    frame_samp(e, inf.fps_num, inf.fps_den, 48000),
                )
            })
            .collect::<Vec<_>>()
    });
    enc_au_streams(spec, &args.inp, work_dir, samp_ranges.as_deref(), 1)
}

type AuResult = Vec<(AuStream, PathBuf)>;
type AuHandle = JoinHandle<Result<AuResult, Xerr>>;

fn spawn_au(args: &Args, work_dir: &Path, inf: &VidInf) -> Option<AuHandle> {
    (!args.sc_file.exists() && args.au.is_some() && args.encoder != Avm).then(|| {
        let spec = unsafe { args.au.as_ref().unwrap_unchecked() }.clone();
        let inp = args.inp.clone();
        let wd = work_dir.to_path_buf();
        let ranges = args.ranges.clone();
        let fps_num = inf.fps_num;
        let fps_den = inf.fps_den;

        spawn(move || {
            let samp_ranges = ranges.as_ref().map(|r| {
                r.iter()
                    .map(|&(s, e)| {
                        (
                            frame_samp(s, fps_num, fps_den, 48000),
                            frame_samp(e, fps_num, fps_den, 48000),
                        )
                    })
                    .collect::<Vec<_>>()
            });
            enc_au_streams(&spec, &inp, &wd, samp_ranges.as_deref(), 5)
        })
    })
}

fn scd_and_au(
    args: &Args,
    inf: &VidInf,
    crop: (u32, u32),
    au_handle: Option<AuHandle>,
) -> Result<Option<AuResult>, Xerr> {
    if let Some(handle) = au_handle {
        fd_scenes(&args.inp, &args.sc_file, inf, crop, 3, args.hwdec)?;
        let result = handle
            .join()
            .map_err(|_e| Msg("Audio encoding thread panicked".into()))?;
        Ok(Some(result?))
    } else {
        ensure_sc_file(args, inf, crop, 3)?;
        Ok(None)
    }
}

fn val_all_scenes(scenes: &[Scene], enc: Encoder) -> Result<(), Xerr> {
    val_scenes(scenes)?;
    if enc == SvtAv1 {
        for s in scenes {
            if let Some(ref p) = s.params {
                val(p)?;
            }
        }
    }
    Ok(())
}

fn main_with_args(args: &Args) -> Result<(), Xerr> {
    print!("\x1b[?1049h\x1b[H\x1b[?25l");
    _ = stdout().flush();
    IN_ALT_SCREEN.store(true, Relaxed);

    let canon_inp = args.inp.canonicalize()?;
    let hash = hash_inp(&canon_inp);
    let work_dir = canon_inp.with_file_name(format!(".{}", &hash[..7]));

    create_dir_all(&work_dir)?;

    if get_resume(&work_dir).is_none_or(|r| r.chnks_done.is_empty()) {
        save_args(&work_dir)?;
    }

    if args.sc_only && args.sc_file.exists() {
        return Err(format!("Scene file already exists: {}", args.sc_file.display()).into());
    }

    let inf = get_vidinf(&args.inp)?;

    let au_handle = spawn_au(args, &work_dir, &inf);

    let thr = unsafe { available_parallelism().unwrap_unchecked().get() as i32 };
    let conf = CropConf {
        sample_cnt: 13,
        min_black_pix: 2,
    };
    let crop = match detect_crop(&args.inp, &inf, &conf, thr, 1) {
        Ok(detected) if detected.has_crop() => detected.to_tuple(),
        _ => (0, 0),
    };

    let au_files = scd_and_au(args, &inf, crop, au_handle)?;

    print!("\x1b[H\x1b[2J");
    _ = stdout().flush();

    let mut args = args.clone();

    let scenes = load_scenes(&args.sc_file, inf.frames)?;

    let scenes = if let Some(ref r) = args.ranges {
        trans_scenes(&scenes, r)
    } else {
        scenes
    };

    val_all_scenes(&scenes, args.encoder)?;
    if args.sc_only {
        return Ok(());
    }

    create_dir_all(work_dir.join("split"))?;
    create_dir_all(work_dir.join("encode"))?;

    let chnks = chnkify(&scenes);

    #[cfg(target_os = "linux")]
    let pipe_start = vspipe_resume(&chnks, &work_dir).unwrap_or(0);
    #[cfg(not(target_os = "linux"))]
    let pipe_start = 0usize;

    let (mut inf, crop, pipe_reader) = init_pipe_crop(inf, crop, pipe_start);

    #[cfg(feature = "vship")]
    let tq = args.tq.is_some();
    #[cfg(not(feature = "vship"))]
    let tq = false;
    if args.hwdec {
        let mut dec = VidDecoder::new_hw(&args.inp, 1)?;
        inf.y_linesz = unsafe { (*dec.dec_next()).linesize[0] as usize };
    }
    args.dec_strat = Some(get_dec_strat(&inf, crop, args.hwdec, tq));

    let prior_secs = get_resume(&work_dir).map_or(0, |r| r.prior_secs);
    init_elapsed(prior_secs);
    let enc_start = Instant::now();
    enc_all(&chnks, &inf, &args, &args.inp, &work_dir, pipe_reader);
    let enc_time = enc_start.elapsed() + Durat::from_secs(prior_secs);

    let au_tracks = if let Some(ref au_spec) = args.au
        && args.encoder != Avm
    {
        acq_au(au_spec, au_files, &args, &inf, &work_dir)?
    } else {
        Vec::new()
    };

    merge_out(&args, &work_dir.join("encode"), &inf, &au_tracks, crop)?;

    for t in &au_tracks {
        _ = rm_file(&t.1);
    }

    print_sum(&args, &inf, &chnks, crop, enc_time);
    rm_dir_all(&work_dir)?;
    Ok(())
}

fn print_sum(args: &Args, inf: &VidInf, chnks: &[Chunk], crop: (u32, u32), enc_time: Durat) {
    let tot_frames: usize = chnks.iter().map(|c| c.end - c.start).sum();
    let inp_sz = vid_bytes(&args.inp, args.ranges.as_deref(), tot_frames);
    let out_sz = vid_bytes(&args.out, None, tot_frames);

    print!("\x1b[?25h\x1b[?1049l");
    _ = stdout().flush();
    let durat = tot_frames as f32 * inf.fps_den as f32 / inf.fps_num as f32;
    let inp_br = inp_sz as f32 * 8.0 / durat / 1000.0;
    let out_br = out_sz as f32 * 8.0 / durat / 1000.0;
    let change = ((out_sz as f32 / inp_sz as f32) - 1.0) * 100.0;

    let fmt_sz = |b: u64| {
        if b >= 1_000_000_000 {
            format!("{:.2} GB", b as f32 / 1_000_000_000.0)
        } else if b >= 1_000_000 {
            format!("{:.2} MB", b as f32 / 1_000_000.0)
        } else {
            format!("{} KB", b / 1_000)
        }
    };

    let arrow = if change < 0.0 {
        "\u{f06c0}"
    } else {
        "\u{f06c3}"
    };
    let change_color = if change < 0.0 { G } else { R };
    let fps_rate = inf.fps_num as f32 / inf.fps_den as f32;
    let enc_spd = tot_frames as f32 / enc_time.as_secs_f32();
    let enc_secs = enc_time.as_secs();
    let (eh, em, es) = (enc_secs / 3600, (enc_secs % 3600) / 60, enc_secs % 60);
    let dur_secs = durat as u64;
    let (dh, dm, ds) = (dur_secs / 3600, (dur_secs % 3600) / 60, dur_secs % 60);
    let (final_width, final_height) = (inf.width - crop.1 * 2, inf.height - crop.0 * 2);

    println!(
    "\n{P}┏━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓\n\
{P}┃ {G} {Y}DONE   {P}┃ {R}{:<30.30} {G} {G}{:<30.30} {P}┃\n\
{P}┣━━━━━━━━━━━╋━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫\n\
{P}┃ {Y}Size      {P}┃ {R}{:<98} {P}┃\n\
{P}┣━━━━━━━━━━━╋━━━━━━━━━━━┳━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫\n\
{P}┃ {Y}Video     {P}┃ {W}{:>4}x{:<4} {P}┃ {B}{:.3} fps {P}┃ {W}{:02}{C}:{W}{:02}{C}:{W}{:02}{:<30} {P}┃\n\
{P}┣━━━━━━━━━━━╋━━━━━━━━━━━┻━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫\n\
{P}┃ {Y}Time      {P}┃ {W}{:02}{C}:{W}{:02}{C}:{W}{:02} {B}@ {:>6.2} fps{:<42} {P}┃\n\
{P}┗━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛{N}",
    unsafe { args.inp.file_name().unwrap_unchecked() }.to_string_lossy(),
    unsafe { args.out.file_name().unwrap_unchecked() }.to_string_lossy(),
    format!("{} {C}({:.0} kb/s) {G} {G}{} {C}({:.0} kb/s) {}{} {:.2}%",
        fmt_sz(inp_sz), inp_br, fmt_sz(out_sz), out_br, change_color, arrow, change.abs()),
    final_width, final_height, fps_rate, dh, dm, ds, "",
    eh, em, es, enc_spd, ""
);
}

fn main() -> Result<(), Xerr> {
    let args = match parse_args() {
        Ok(a) => a,
        Err(Help) => return Ok(()),
        Err(e) => return Err(e),
    };
    let out = args.out.clone();

    set_hook(Box::new(move |panic_info| {
        print!("\x1b[?25h\x1b[?1049l");
        _ = stdout().flush();
        eprint(format_args!("{panic_info}"));
        eprint(format_args!("{}, FAIL", out.display()));
    }));

    unsafe {
        atexit(restore);

        let h: usize = transmute_copy(&(exit_restore as extern "C" fn(i32)));
        signal(SIGINT, h);
        signal(SIGSEGV, h);
    }

    if let Err(e) = main_with_args(&args) {
        print!("\x1b[?1049l");
        _ = stdout().flush();
        fatal(format_args!("{e}\n{}, FAIL", args.out.display()));
    }

    Ok(())
}
