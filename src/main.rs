use std::collections::hash_map::DefaultHasher;
use std::fs;
use std::hash::{Hash, Hasher};
use std::io::Write;
use std::path::{Path, PathBuf};

mod chunk;
mod ffms;
mod progs;
mod scd;
mod svt;

#[derive(Clone)]
pub struct Args {
    pub worker: usize,
    pub scene_file: PathBuf,
    pub target_quality: Option<String>,
    pub metric_mode: String,
    pub qp_range: Option<String>,
    pub params: String,
    pub resume: bool,
    pub high_mem: bool,
    pub quiet: bool,
    pub input: PathBuf,
    pub output: PathBuf,
}

extern "C" fn restore() {
    print!("\x1b[?25h");
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
    println!("-w|--worker    Number of `svt-av1` to run");
    println!("-s|--sc        SCD file to use. Runs SCD and creates the file if not specified");
    println!("-r|--resume    Add it to same cmd or use with the input file");
    // println!("-h|--high-mem  Enable high memory mode: ");
    // println!("               Default Low: Bit-pack 10b or convert to 10b on worker threads");
    // println!("               High: Keep full data, do everything on decoder thread");
    // println!("               High also keeps +1 chunk in the buffer");
    //
    println!("-q|--quiet     Do not run any code related to any progress");
    println!();
    println!("TQ:");
    println!("WORK IN PROGRESS");
    // println!("-t|--tq        Allowed SSIMU2 Range for Target Quality. Takes single values or ranges formatted like `70.0-75.0`");
    // println!("-m|--mode      TQ metric evaluation mode. `mean` or percentile mean formatted like `p15`");
    // println!("-c|--qp        Allowed CRF/QP search range for Target Quality. Takes single values or ranges formatted like `10.0-55.0`");
    println!();
    println!("Examples:");
    println!("xav -r i.mkv");
    println!("xav -w 8 -s sc.txt -p \"--lp 3 --tune 0\" i.mkv o.mkv");
    println!(
        "xav -q -h -w 8 -s sc.txt -t 70-75 -c 4-70 -m mean -p \"--lp 3 --tune 0\" i.mkv o.mkv"
    );
    println!("xav i.mkv  # Uses all defaults, creates `scd_i.txt` and output will be `i_av1.mkv`.");
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
    let high_mem = false;
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
            "-m" | "--mod" => {
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
            // "-h" | "--high-mem" => {
            //     high_mem = true;
            // }
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

    // if high_mem && input == PathBuf::new() {
    //     print_help();
    //     std::process::exit(0);
    // }

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
        high_mem,
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
        print!("\x1b[?25l");
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

    unsafe {
        libc::atexit(restore);
        libc::signal(libc::SIGINT, exit_restore as usize);
    }

    let idx = ffms::VidIdx::new(&args.input, args.quiet)?;
    let inf = ffms::get_vidinf(&idx)?;
    let scenes = chunk::load_scenes(&args.scene_file, inf.frames)?;

    let chunks = chunk::chunkify(&scenes);

    svt::encode_all(&chunks, &inf, args, 25.0, &idx, &work_dir);

    chunk::merge_out(&work_dir.join("encode"), &args.output, &inf)?;

    print!("\x1b[?25h");
    std::io::stdout().flush().unwrap();

    fs::remove_dir_all(&work_dir)?;

    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = parse_args();
    main_with_args(&args)
}
