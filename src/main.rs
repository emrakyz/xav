use std::collections::hash_map::DefaultHasher;
use std::fs;
use std::hash::{Hash, Hasher};
use std::io::Write;
use std::path::{Path, PathBuf};

mod chunk;
mod ffms;
mod interp;
mod progs;
mod scd;
mod svt;
mod tq;
mod vship;
mod zimg;

#[derive(Clone)]
pub struct Args {
    pub worker: usize,
    pub scene_file: PathBuf,
    pub target_quality: Option<String>,
    pub metric_mode: String,
    pub qp_range: Option<String>,
    pub params: String,
    pub resume: bool,
    pub quiet: bool,
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
    println!("-w|--worker    Number of `svt-av1` instances to run");
    println!("-s|--sc        SCD file to use. Runs SCD and creates the file if not specified");
    println!("-r|--resume    Resume the encoding. Example below");
    println!("-q|--quiet     Do not run any code related to any progress");
    println!();
    println!("TQ:");
    println!("-t|--tq        Allowed SSIMU2 Range for Target Quality. Example: `74.00-76.00`");
    println!("-m|--mode      TQ metric evaluation mode. `mean` or mean of under certain percentile. Example: `p15`");
    println!("-c|--qp        Allowed CRF/QP search range for Target Quality. Example: `12.25-44.75`");
    println!();
    println!("Examples:");
    println!("xav -r i.mkv");
    println!("xav -w 8 -s sc.txt -p \"--lp 3 --tune 0\" i.mkv o.mkv");
    println!(
        "xav -q -w 8 -s sc.txt -t 70-75 -c 6-63 -m mean -p \"--lp 3 --tune 0\" i.mkv o.mkv"
    );
    println!("xav i.mkv  # Uses all defaults, creates `scd_i.txt` and output will be `i_av1.mkv`");
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
        args.scene_file = PathBuf::from(format!("scd_{stem}.txt"));
    }

    if args.target_quality.is_some() && args.qp_range.is_none() {
        args.qp_range = Some("10.0-40.0".to_string());
    }
}

fn get_args(args: &[String]) -> Result<Args, Box<dyn std::error::Error>> {
    if args.len() < 2 {
        return Err("Usage: xav [options] <input> <output>".into());
    }

    let mut worker = 0;
    let mut scene_file = PathBuf::new();
    let mut target_quality = None;
    let mut metric_mode = "mean".to_string();
    let mut qp_range = None;
    let mut params = String::new();
    let mut resume = false;
    let mut quiet = false;
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
            "-t" | "--tq" => {
                i += 1;
                if i < args.len() {
                    target_quality = Some(args[i].clone());
                }
            }
            "-m" | "--mode" => {
                i += 1;
                if i < args.len() {
                    metric_mode.clone_from(&args[i]);
                }
            }
            "-c" | "--qp" => {
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

    if resume {
        let mut saved_args = get_saved_args(&input)?;
        saved_args.resume = true;
        return Ok(saved_args);
    }

    let mut result = Args {
        worker,
        scene_file,
        target_quality,
        metric_mode,
        qp_range,
        params,
        resume,
        quiet,
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
    let cmd: Vec<String> = std::env::args().collect();
    let quoted_cmd: Vec<String> = cmd
        .iter()
        .map(|arg| if arg.contains(' ') { format!("\"{arg}\"") } else { arg.clone() })
        .collect();
    fs::write(work_dir.join("cmd.txt"), quoted_cmd.join(" "))?;
    Ok(())
}

fn get_saved_args(input: &Path) -> Result<Args, Box<dyn std::error::Error>> {
    let hash = hash_input(input);
    let work_dir = PathBuf::from(format!(".{}", &hash[..7]));
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
        print!("\x1b[?1049h\x1b[H");
        std::io::stdout().flush().unwrap();
    }

    ensure_scene_file(args)?;

    if !args.quiet {
        println!();
    }

    let hash = hash_input(&args.input);
    let work_dir = PathBuf::from(format!(".{}", &hash[..7]));

    if !args.resume && work_dir.exists() {
        fs::remove_dir_all(&work_dir)?;
    }

    fs::create_dir_all(work_dir.join("split"))?;
    fs::create_dir_all(work_dir.join("encode"))?;

    if !args.resume {
        save_args(&work_dir)?;
    }

    let idx = ffms::VidIdx::new(&args.input, args.quiet)?;
    let inf = ffms::get_vidinf(&idx)?;
    let scenes = chunk::load_scenes(&args.scene_file, inf.frames)?;

    let chunks = chunk::chunkify(&scenes);

    svt::encode_all(&chunks, &inf, args, &idx, &work_dir);

    chunk::merge_out(&work_dir.join("encode"), &args.output, &inf)?;

    print!("\x1b[?25h\x1b[?1049l");
    std::io::stdout().flush().unwrap();

    let input_size = fs::metadata(&args.input)?.len();
    let output_size = fs::metadata(&args.output)?.len();
    let duration = inf.frames as f64 * inf.fps_den as f64 / inf.fps_num as f64;
    let input_br = (input_size as f64 * 8.0) / duration / 1000.0;
    let output_br = (output_size as f64 * 8.0) / duration / 1000.0;
    let change = ((output_size as f64 / input_size as f64) - 1.0) * 100.0;

    let fmt = |b: u64| {
        if b > 1_000_000_000 {
            format!("{:.2}GB", b as f64 / 1_000_000_000.0)
        } else {
            format!("{:.2}MB", b as f64 / 1_000_000.0)
        }
    };

    eprintln!(
        "{}, SUCCESS, {} ({:.0} kb/s) --> {} ({:.0} kb/s), {:+.2}%",
        args.output.display(),
        fmt(input_size),
        input_br,
        fmt(output_size),
        output_br,
        change
    );

    fs::remove_dir_all(&work_dir)?;

    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = parse_args();
    let output = args.output.clone();

    std::panic::set_hook(Box::new(move |panic_info| {
        print!("\x1b[?25h\x1b[?1049l");
        let _ = std::io::stdout().flush();
        eprintln!("{}", panic_info);
        eprintln!("{}, FAIL", output.display());
    }));

    unsafe {
        libc::atexit(restore);
        libc::signal(libc::SIGINT, exit_restore as usize);
    }

    if let Err(e) = main_with_args(&args) {
        print!("\x1b[?1049l");
        std::io::stdout().flush().unwrap();
        eprintln!("{}, FAIL", args.output.display());
        return Err(e);
    }

    Ok(())
}
