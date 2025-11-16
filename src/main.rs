use std::collections::hash_map::DefaultHasher;
use std::fs;
use std::hash::{Hash, Hasher};
use std::io::Write;
use std::path::{Path, PathBuf};

mod audio;
mod chunk;
mod ffms;
#[cfg(feature = "vship")]
mod interp;
mod noise;
mod progs;
mod scd;
mod svt;
#[cfg(feature = "vship")]
mod tq;
#[cfg(feature = "vship")]
mod vship;

const G: &str = "\x1b[1;92m";
const R: &str = "\x1b[1;91m";
const P: &str = "\x1b[1;95m";
const B: &str = "\x1b[1;94m";
const Y: &str = "\x1b[1;93m";
const C: &str = "\x1b[1;96m";
const W: &str = "\x1b[1;97m";
const N: &str = "\x1b[0m";

#[derive(Clone)]
pub struct Args {
    pub worker: usize,
    pub scene_file: PathBuf,
    #[cfg(feature = "vship")]
    pub target_quality: Option<String>,
    #[cfg(feature = "vship")]
    pub metric_mode: String,
    #[cfg(feature = "vship")]
    pub qp_range: Option<String>,
    pub params: String,
    pub resume: bool,
    pub quiet: bool,
    pub noise: Option<u32>,
    pub crop: Option<(u32, u32)>,
    pub crop_str: Option<String>,
    pub audio: Option<audio::AudioSpec>,
    pub input: PathBuf,
    pub output: PathBuf,
}

extern "C" fn restore() {
    print!("\x1b[?25h\x1b[?1049l");
    let _ = std::io::stdout().flush();
}
extern "C" fn exit_restore(_: i32) {
    restore();
    std::process::exit(130);
}

#[rustfmt::skip]
fn print_help() {
    println!("Format: xav [options] <INPUT> [<OUTPUT>]");
    println!();
    println!("<INPUT>        Input path");
    println!("<OUTPUT>       Output path. Adds `_av1` to the input name if not specified");
    println!();
    println!("Options:");
    println!("-p|--param     SVT AV1 parameters inside quotes");
    println!("-w|--worker    Number of `svt-av1` instances to run");
    println!();
    #[cfg(feature = "vship")]
    {
        println!("TQ:");
        println!("-t|--tq        Target quality range. Metric: <8=Butter5pn, 8-10=CVVDP, >10=SSIMU2");
        println!("               SSIMU2: `74.00-76.00`, Butter: `1.5-2.0`, CVVDP: `9.45-9.55`");
        println!("-m|--mode      Metric evaluation: `mean` or `pN` for mean of worst N%. Example: `p15`");
        println!("-f|--qp        CRF/QP search range. Example: `12.25-44.75`");
        println!();
    }
    println!("Misc:");
    println!("-n|--noise     Apply photon noise [1-64]: 1=ISO100, 64=ISO6400");
    println!("-c|--crop      Auto crop by original AR: `1.37` OR crop horizontal,vertical: `0,220`");
    println!("-s|--sc        SCD file to use. Runs SCD and creates the file if not specified");
    println!("-a|--audio     Encode with Opus: `-a \"<auto|norm|bitrate> <all|stream_ids>\"`");
    println!("               Examples: `-a \"auto all\"`, `-a \"norm 1\"`, `-a \"128 1,2,3\"`");
    println!("               `norm`: downmix to stereo + loudnorm + 128k bitrate");
    println!("               If enabled, subtitles/chapters are preserved in output");
    println!("-r|--resume    Resume the encoding. Example below");
    println!("-q|--quiet     Do not run any code related to any progress");
    println!();
    println!("Examples:");
    println!("xav -r i.mkv");
    println!("xav -w 8 -s sc.txt -p \"--lp 3 --tune 0\" i.mkv o.mkv");
    println!("xav -q -w 8 -s sc.txt -t 75-76 -f 6-63 -m p15 -p \"--lp 3 --tune 0\" i.mkv o.mkv");
    println!("xav -t 1.5-2.0 -f 20-50 -m mean i.mkv  # Butteraugli target");
    println!("xav i.mkv  # Uses all defaults, creates `i_scd.txt` and output will be `i_av1.mkv`");
}

fn parse_args() -> Args {
    let args: Vec<String> = std::env::args().collect();
    get_args(&args).unwrap_or_else(|_| {
        print_help();
        std::process::exit(1);
    })
}

fn apply_defaults(args: &mut Args) {
    if args.worker == 0 {
        let threads = std::thread::available_parallelism().map_or(8, std::num::NonZero::get);
        args.worker = match threads {
            32.. => 8,
            24..32 => 6,
            16..24 => 4,
            12..16 => 3,
            8..12 => 2,
            _ => 1,
        };
        args.params = format!("--lp 3 {}", args.params).trim().to_string();
    }

    if args.output == PathBuf::new() {
        let stem = args.input.file_stem().unwrap().to_string_lossy();
        args.output = args.input.with_file_name(format!("{stem}_av1.mkv"));
    }

    if args.scene_file == PathBuf::new() {
        let stem = args.input.file_stem().unwrap().to_string_lossy();
        args.scene_file = args.input.with_file_name(format!("{stem}_scd.txt"));
    }

    #[cfg(feature = "vship")]
    if args.target_quality.is_some() && args.qp_range.is_none() {
        args.qp_range = Some("8.0-48.0".to_string());
    }
}

fn get_args(args: &[String]) -> Result<Args, Box<dyn std::error::Error>> {
    if args.len() < 2 {
        return Err("Usage: xav [options] <input> <output>".into());
    }

    let mut worker = 0;
    let mut scene_file = PathBuf::new();
    #[cfg(feature = "vship")]
    let mut target_quality = None;
    #[cfg(feature = "vship")]
    let mut metric_mode = "mean".to_string();
    #[cfg(feature = "vship")]
    let mut qp_range = None;
    let mut params = String::new();
    let mut resume = false;
    let mut quiet = false;
    let mut noise = None;
    let crop = None;
    let mut crop_str = None;
    let mut audio = None;
    let mut input = PathBuf::new();
    let mut output = PathBuf::new();

    let mut i = 1;
    while i < args.len() {
        match args[i].as_str() {
            "-w" | "--worker" => {
                i += 1;
                if i < args.len() {
                    worker = args[i].parse()?;
                }
            }
            "-s" | "--sc" => {
                i += 1;
                if i < args.len() {
                    scene_file = PathBuf::from(&args[i]);
                }
            }
            #[cfg(feature = "vship")]
            "-t" | "--tq" => {
                i += 1;
                if i < args.len() {
                    target_quality = Some(args[i].clone());
                }
            }
            #[cfg(feature = "vship")]
            "-m" | "--mode" => {
                i += 1;
                if i < args.len() {
                    metric_mode.clone_from(&args[i]);
                }
            }
            #[cfg(feature = "vship")]
            "-f" | "--qp" => {
                i += 1;
                if i < args.len() {
                    qp_range = Some(args[i].clone());
                }
            }
            "-p" | "--param" => {
                i += 1;
                if i < args.len() {
                    params.clone_from(&args[i]);
                }
            }
            "-r" | "--resume" => {
                resume = true;
            }
            "-q" | "--quiet" => {
                quiet = true;
            }
            "-n" | "--noise" => {
                i += 1;
                if i < args.len() {
                    let val: u32 = args[i].parse()?;
                    if !(1..=64).contains(&val) {
                        return Err("Noise ISO must be between 1-64".into());
                    }
                    noise = Some(val * 100);
                }
            }
            "-c" | "--crop" => {
                i += 1;
                if i < args.len() {
                    crop_str = Some(args[i].clone());
                }
            }
            "-a" | "--audio" => {
                i += 1;
                if i < args.len() {
                    audio = Some(audio::parse_audio_arg(&args[i])?);
                }
            }

            arg if !arg.starts_with('-') => {
                if input == PathBuf::new() {
                    input = PathBuf::from(arg);
                } else if output == PathBuf::new() {
                    output = PathBuf::from(arg);
                }
            }
            _ => return Err(format!("Unknown argument: {}", args[i]).into()),
        }
        i += 1;
    }

    if resume && let Ok(mut saved_args) = get_saved_args(&input) {
        saved_args.resume = true;
        return Ok(saved_args);
    }

    let mut result = Args {
        worker,
        scene_file,
        #[cfg(feature = "vship")]
        target_quality,
        #[cfg(feature = "vship")]
        metric_mode,
        #[cfg(feature = "vship")]
        qp_range,
        params,
        resume,
        quiet,
        noise,
        crop,
        crop_str,
        audio,
        input,
        output,
    };

    apply_defaults(&mut result);

    if result.worker == 0
        || result.scene_file == PathBuf::new()
        || result.input == PathBuf::new()
        || result.output == PathBuf::new()
    {
        return Err("Missing required arguments".into());
    }

    Ok(result)
}

fn hash_input(path: &Path) -> String {
    let mut hasher = DefaultHasher::new();
    path.hash(&mut hasher);
    format!("{:x}", hasher.finish())
}

fn save_args(work_dir: &Path) -> Result<(), Box<dyn std::error::Error>> {
    let cmd: Vec<String> =
        std::env::args().filter(|arg| arg != "-r" && arg != "--resume").collect();
    let quoted_cmd: Vec<String> = cmd
        .iter()
        .map(|arg| if arg.contains(' ') { format!("\"{arg}\"") } else { arg.clone() })
        .collect();
    fs::write(work_dir.join("cmd.txt"), quoted_cmd.join(" "))?;
    Ok(())
}

fn get_saved_args(input: &Path) -> Result<Args, Box<dyn std::error::Error>> {
    let hash = hash_input(input);
    let work_dir = input.with_file_name(format!(".{}", &hash[..7]));
    let cmd_path = work_dir.join("cmd.txt");

    if cmd_path.exists() {
        let cmd_line = fs::read_to_string(cmd_path)?;
        let saved_args = parse_quoted_args(&cmd_line);
        get_args(&saved_args)
    } else {
        Err("No saved encoding found for this input file".into())
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

fn ensure_scene_file(args: &Args) -> Result<(), Box<dyn std::error::Error>> {
    if !args.scene_file.exists() {
        scd::fd_scenes(&args.input, &args.scene_file, args.quiet)?;
    }
    Ok(())
}

fn main_with_args(args: &Args) -> Result<(), Box<dyn std::error::Error>> {
    if !args.quiet {
        print!("\x1b[?1049h\x1b[H\x1b[?25l");
        std::io::stdout().flush().unwrap();
    }

    ensure_scene_file(args)?;

    if !args.quiet {
        println!();
    }

    let hash = hash_input(&args.input);
    let work_dir = args.input.with_file_name(format!(".{}", &hash[..7]));

    let is_new_encode = !work_dir.exists();

    if !args.resume && work_dir.exists() {
        fs::remove_dir_all(&work_dir)?;
    }

    fs::create_dir_all(work_dir.join("split"))?;
    fs::create_dir_all(work_dir.join("encode"))?;

    if is_new_encode {
        save_args(&work_dir)?;
    }

    let idx = ffms::VidIdx::new(&args.input, args.quiet)?;
    let inf = ffms::get_vidinf(&idx)?;

    let mut args = args.clone();
    if let Some(ref s) = args.crop_str {
        args.crop = Some(if let Ok(ar) = s.parse::<f64>() {
            let (cur_dim, new_exact, is_vert) = if ar > f64::from(inf.width) / f64::from(inf.height)
            {
                (inf.height, f64::from(inf.width) / ar, true)
            } else {
                (inf.width, f64::from(inf.height) * ar, false)
            };

            let mut new_dim = new_exact as u32;
            let cur_mod4 = cur_dim % 4;
            let new_mod4 = new_dim % 4;

            if new_mod4 != cur_mod4 || new_exact.fract() != 0.0 {
                let mut adj = (cur_mod4 + 4 - new_mod4) % 4;
                if adj == 0 {
                    adj = 4;
                }
                new_dim += adj;
            }

            let crop = ((cur_dim - new_dim) / 2) & !1;
            if is_vert { (crop, 0) } else { (0, crop) }
        } else {
            let p: Vec<u32> = s.split(',').filter_map(|x| x.parse().ok()).collect();
            if p.len() == 2 { (p[0] & !1, p[1] & !1) } else { (0, 0) }
        });
    }

    let grain_table = if let Some(iso) = args.noise {
        let table_path = work_dir.join("grain.tbl");
        noise::gen_table(iso, &inf, &table_path)?;
        Some(table_path)
    } else {
        None
    };

    let scenes = chunk::load_scenes(&args.scene_file, inf.frames)?;
    chunk::validate_scenes(&scenes, inf.fps_num, inf.fps_den)?;

    let chunks = chunk::chunkify(&scenes);

    let enc_start = std::time::Instant::now();
    svt::encode_all(&chunks, &inf, &args, &idx, &work_dir, grain_table.as_ref());
    let enc_time = enc_start.elapsed();

    let video_mkv = work_dir.join("encode").join("video.mkv");
    chunk::merge_out(&work_dir.join("encode"), &video_mkv, &inf)?;

    print!("\x1b[?25h\x1b[?1049l");
    std::io::stdout().flush().unwrap();

    let input_size = fs::metadata(&args.input)?.len();
    let output_size = fs::metadata(&video_mkv)?.len();
    let duration = inf.frames as f64 * f64::from(inf.fps_den) / f64::from(inf.fps_num);
    let input_br = (input_size as f64 * 8.0) / duration / 1000.0;
    let output_br = (output_size as f64 * 8.0) / duration / 1000.0;
    let change = ((output_size as f64 / input_size as f64) - 1.0) * 100.0;

    let fmt_size = |b: u64| {
        if b > 1_000_000_000 {
            format!("{:.2} GB", b as f64 / 1_000_000_000.0)
        } else {
            format!("{:.2} MB", b as f64 / 1_000_000.0)
        }
    };

    let arrow = if change < 0.0 { "󰛀" } else { "󰛃" };
    let change_color = if change < 0.0 { G } else { R };

    let fps_rate = f64::from(inf.fps_num) / f64::from(inf.fps_den);
    let enc_speed = inf.frames as f64 / enc_time.as_secs_f64();

    let enc_secs = enc_time.as_secs();
    let (eh, em, es) = (enc_secs / 3600, (enc_secs % 3600) / 60, enc_secs % 60);

    let dur_secs = duration as u64;
    let (dh, dm, ds) = (dur_secs / 3600, (dur_secs % 3600) / 60, dur_secs % 60);

    let (final_width, final_height) = if let Some((crop_v, crop_h)) = args.crop {
        (inf.width - crop_h * 2, inf.height - crop_v * 2)
    } else {
        (inf.width, inf.height)
    };

    eprintln!(
    "\n{P}┏━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓\n\
{P}┃ {G}✅ {Y}DONE   {P}┃ {R}{:<30.30} {G}󰛂 {G}{:<30.30} {P}┃\n\
{P}┣━━━━━━━━━━━╋━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫\n\
{P}┃ {Y}Size      {P}┃ {R}{:<98} {P}┃\n\
{P}┣━━━━━━━━━━━╋━━━━━━━━━━━┳━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫\n\
{P}┃ {Y}Video     {P}┃ {W}{}x{:<4} {P}┃ {B}{:.3} fps {P}┃ {W}{:02}{C}:{W}{:02}{C}:{W}{:02}{:<30} {P}┃\n\
{P}┣━━━━━━━━━━━╋━━━━━━━━━━━┻━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫\n\
{P}┃ {Y}Time      {P}┃ {W}{:02}{C}:{W}{:02}{C}:{W}{:02} {B}@ {:>6.2} fps{:<42} {P}┃\n\
{P}┗━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛{N}",
    args.input.file_name().unwrap().to_string_lossy(),
    args.output.file_name().unwrap().to_string_lossy(),
    format!("{} {C}({:.0} kb/s) {G}󰛂 {G}{} {C}({:.0} kb/s) {}{} {:.2}%", 
        fmt_size(input_size), input_br, fmt_size(output_size), output_br, change_color, arrow, change.abs()),
    final_width, final_height, fps_rate, dh, dm, ds, "",
    eh, em, es, enc_speed, ""
);

    if let Some(ref audio_spec) = args.audio {
        audio::process_audio(audio_spec, &args.input, &video_mkv, &args.output)?;
        fs::remove_file(&video_mkv)?;
    } else {
        fs::rename(&video_mkv, &args.output)?;
    }

    fs::remove_dir_all(&work_dir)?;

    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = parse_args();
    let output = args.output.clone();

    std::panic::set_hook(Box::new(move |panic_info| {
        print!("\x1b[?25h\x1b[?1049l");
        let _ = std::io::stdout().flush();
        eprintln!("{panic_info}");
        eprintln!("{}, FAIL", output.display());
    }));

    unsafe {
        libc::atexit(restore);
        libc::signal(libc::SIGINT, exit_restore as usize);
        libc::signal(libc::SIGSEGV, exit_restore as usize);
    }

    if let Err(e) = main_with_args(&args) {
        print!("\x1b[?1049l");
        std::io::stdout().flush().unwrap();
        eprintln!("{}, FAIL", args.output.display());
        return Err(e);
    }

    #[cfg(feature = "vship")]
    if args.target_quality.is_some()
        && let Some(v) = crate::svt::TQ_SCORES.get()
    {
        let mut s = v.lock().unwrap().clone();

        let tq_parts: Vec<f64> = args
            .target_quality
            .as_ref()
            .unwrap()
            .split('-')
            .filter_map(|s| s.parse().ok())
            .collect();
        let is_butteraugli = f64::midpoint(tq_parts[0], tq_parts[1]) < 8.0;

        if is_butteraugli {
            s.sort_unstable_by(|a, b| b.partial_cmp(a).unwrap());
        } else {
            s.sort_unstable_by(|a, b| a.partial_cmp(b).unwrap());
        }

        let m = s.iter().sum::<f64>() / s.len() as f64;
        eprintln!("\n{Y}Mean: {W}{m:.4}");
        for p in [25.0, 10.0, 5.0, 1.0, 0.1] {
            let i = ((s.len() as f64 * p / 100.0).ceil() as usize).min(s.len());
            eprintln!("{Y}Mean of worst {p}%: {W}{:.4}", s[..i].iter().sum::<f64>() / i as f64);
        }
        eprintln!(
            "{Y}STDDEV: {W}{:.4}{N}",
            (s.iter().map(|&x| (x - m).powi(2)).sum::<f64>() / s.len() as f64).sqrt()
        );
    }

    Ok(())
}
