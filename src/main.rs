use std::collections::hash_map::DefaultHasher;
use std::fs;
use std::hash::{Hash, Hasher};
use std::io::Write;
use std::path::{Path, PathBuf};

mod audio;
mod chunk;
mod crop;
mod decode;
mod ffms;
#[cfg(feature = "vship")]
mod interp;
mod noise;
pub mod pipeline;
mod progs;
mod scd;
mod svt;
#[cfg(feature = "vship")]
mod tq;
#[cfg(feature = "vship")]
mod vship;
mod worker;

#[cfg(test)]
mod tests;

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
    pub params: String,
    pub noise: Option<u32>,
    pub audio: Option<audio::AudioSpec>,
    pub input: PathBuf,
    pub output: PathBuf,
    pub decode_strat: Option<ffms::DecodeStrat>,
    pub chunk_buffer: usize,
    #[cfg(feature = "vship")]
    pub qp_range: Option<String>,
    #[cfg(feature = "vship")]
    pub metric_worker: usize,
    #[cfg(feature = "vship")]
    pub target_quality: Option<String>,
    #[cfg(feature = "vship")]
    pub metric_mode: String,
    #[cfg(feature = "vship")]
    pub cvvdp_config: Option<String>,
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
    println!("{P}Format: {Y}xav {C}[options] {G}<INPUT> {B}[<OUTPUT>]{W}");
    println!();
    println!("{C}-p {P}┃ {C}--param    {W}Encoder params");
    println!("{C}-w {P}┃ {C}--worker   {W}Encoder count");
    println!("{C}-b {P}┃ {C}--buffer   {W}Extra chunks to hold in front buffer");
    println!("{C}-s {P}┃ {C}--sc       {W}Specify SCD file. Auto gen if not specified");
    println!("{C}-n {P}┃ {C}--noise    {W}Add noise {B}[1-64]{W}: {R}1{B}={W}ISO100, {R}64{B}={W}ISO6400");
    println!("{C}-a {P}┃ {C}--audio    {W}Encode to Opus: {Y}-a {G}\"{R}<{G}auto{P}┃{G}norm{P}┃{G}bitrate{R}> {R}<{G}all{P}┃{G}stream_ids{R}>{G}\"");
    println!("                {B}Examples: {Y}-a {G}\"auto all\"{W}, {Y}-a {G}\"norm 1\"{W}, {Y}-a {G}\"128 1,2\"");
    #[cfg(feature = "vship")]
    {
        println!("{C}-t {P}┃ {C}--tq       {W}TQ Range: {R}<8{B}={W}Butter5pn, {R}8-10{B}={W}CVVDP, {R}>10{B}={W}SSIMU2: {Y}-t {G}9.00-9.01");
        println!("{C}-m {P}┃ {C}--mode     {W}TQ Metric aggregation: {G}mean {W}or mean of worst N%: {G}p0.1");
        println!("{C}-f {P}┃ {C}--qp       {W}CRF range for TQ: {Y}-f {G}0.25-69.75{W}");
        println!("{C}-v {P}┃ {C}--vship    {W}Metric worker count");
        println!("{C}-d {P}┃ {C}--display  {W}Display JSON file for CVVDP. Screen name must be {R}xav_screen{W}");
    }

    println!();
    println!("{P}Example:{W}");
    println!("{Y}xav {P}\\{W}");
    println!("  {C}-p {G}\"--scm 0 --lp 5\" {P}\\  {B}# {W}Params (after defaults) used by the encoder");
    println!("  {C}-w {R}5                {P}\\  {B}# {W}Spawn {R}5 {W}encoder instances simultaneously");
    println!("  {C}-b {R}1                {P}\\  {B}# {W}Decode {R}1 {W}extra chunk in memory for less waiting");
    println!("  {C}-s {G}scd.txt          {P}\\  {B}# {W}Optionally use a scene file from external SCD tools");
    println!("  {C}-n {R}4                {P}\\  {B}# {W}Add ISO-{R}400 {W}photon noise");
    println!("  {C}-a {G}\"norm 1,2\"       {P}\\  {B}# {W}Encode {R}2 {W}streams using Opus with stereo downmixing");
    #[cfg(feature = "vship")]
    {
        println!("  {C}-t {G}9.444-9.555      {P}\\  {B}# {W}Enable TQ mode with CVVDP using this allowed range");
        println!("  {C}-m {G}p1.25            {P}\\  {B}# {W}Use the mean of worst {R}1.25% {W}of frames for TQ scoring");
        println!("  {C}-f {G}4.25-63.75       {P}\\  {B}# {W}Allowed CRF range for target quality mode");
        println!("  {C}-v {R}3                {P}\\  {B}# {W}Spawn {R}3 {W}vship/metric workers");
        println!("  {C}-d {G}display.json     {P}\\  {B}# {W}Uses {G}display.json {W}for CVVDP screen specification");
    }
    println!("  {G}input.mkv           {P}\\  {B}# {W}Name or path of the input file");
    println!("  {G}output.mkv             {B}# {W}Optional output name");
    println!();
    println!("{Y}Worker {P}┃ {Y}Buffer {P}┃ {Y}Metric worker count {W}depend on the OS,");
    println!("hardware, content, parameters and other variables.");
    println!("Experiment and use the sweet spot values for your case.");
}

fn parse_args() -> Args {
    let args: Vec<String> = std::env::args().collect();
    get_args(&args, true).unwrap_or_else(|_| {
        print_help();
        std::process::exit(1);
    })
}

fn apply_defaults(args: &mut Args) {
    if args.output == PathBuf::new() {
        let stem = args.input.file_stem().unwrap().to_string_lossy();
        args.output = args.input.with_file_name(format!("{stem}_av1.mkv"));
    }

    if args.scene_file == PathBuf::new() {
        let stem = args.input.file_stem().unwrap().to_string_lossy();
        args.scene_file = args.input.with_file_name(format!("{stem}_scd.txt"));
    }

    #[cfg(feature = "vship")]
    {
        if args.target_quality.is_some() && args.qp_range.is_none() {
            args.qp_range = Some("8.0-48.0".to_string());
        }
    }
}

fn get_args(args: &[String], allow_resume: bool) -> Result<Args, Box<dyn std::error::Error>> {
    if args.len() < 2 {
        return Err("Usage: xav [options] <input> <output>".into());
    }

    let mut worker = 1;
    let mut scene_file = PathBuf::new();
    #[cfg(feature = "vship")]
    let mut target_quality = None;
    #[cfg(feature = "vship")]
    let mut metric_mode = "mean".to_string();
    #[cfg(feature = "vship")]
    let mut qp_range = None;
    let mut params = String::new();
    let mut noise = None;
    let mut audio = None;
    let mut input = PathBuf::new();
    let mut output = PathBuf::new();
    #[cfg(feature = "vship")]
    let mut metric_worker = 1;
    let mut chunk_buffer = None;
    #[cfg(feature = "vship")]
    let mut cvvdp_config = None;

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
            "-a" | "--audio" => {
                i += 1;
                if i < args.len() {
                    audio = Some(audio::parse_audio_arg(&args[i])?);
                }
            }

            #[cfg(feature = "vship")]
            "-v" | "--metric-worker" => {
                i += 1;
                if i < args.len() {
                    metric_worker = args[i].parse()?;
                }
            }
            "-b" | "--buffer" => {
                i += 1;
                if i < args.len() {
                    chunk_buffer = Some(args[i].parse()?);
                }
            }
            #[cfg(feature = "vship")]
            "-d" | "--display" => {
                i += 1;
                if i < args.len() {
                    cvvdp_config = Some(args[i].clone());
                }
            }

            arg if !arg.starts_with('-') => {
                if input == PathBuf::new() {
                    input = PathBuf::from(arg);
                } else if output == PathBuf::new() {
                    output = PathBuf::from(arg);
                }
            }
            _ => return Err(format!("Unknown arg: {}", args[i]).into()),
        }
        i += 1;
    }

    if allow_resume && let Ok(saved_args) = get_saved_args(&input) {
        return Ok(saved_args);
    }

    let chunk_buffer = worker + chunk_buffer.unwrap_or(0);

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
        noise,
        audio,
        input,
        output,
        decode_strat: None,
        chunk_buffer,
        #[cfg(feature = "vship")]
        metric_worker,
        #[cfg(feature = "vship")]
        cvvdp_config,
    };

    apply_defaults(&mut result);

    if result.scene_file == PathBuf::new()
        || result.input == PathBuf::new()
        || result.output == PathBuf::new()
    {
        return Err("Missing args".into());
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
    let work_dir = input.with_file_name(format!(".{}", &hash[..7]));
    let cmd_path = work_dir.join("cmd.txt");

    if cmd_path.exists() {
        let cmd_line = fs::read_to_string(cmd_path)?;
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

fn ensure_scene_file(args: &Args) -> Result<(), Box<dyn std::error::Error>> {
    if !args.scene_file.exists() {
        scd::fd_scenes(&args.input, &args.scene_file)?;
    }
    Ok(())
}

fn main_with_args(args: &Args) -> Result<(), Box<dyn std::error::Error>> {
    print!("\x1b[?1049h\x1b[H\x1b[?25l");
    std::io::stdout().flush().unwrap();

    ensure_scene_file(args)?;

    println!();

    let hash = hash_input(&args.input);
    let work_dir = args.input.with_file_name(format!(".{}", &hash[..7]));

    let is_new_encode = !work_dir.exists();

    fs::create_dir_all(work_dir.join("split"))?;
    fs::create_dir_all(work_dir.join("encode"))?;

    if is_new_encode {
        save_args(&work_dir)?;
    }

    let idx = ffms::VidIdx::new(&args.input, true)?;
    let inf = ffms::get_vidinf(&idx)?;

    let mut args = args.clone();

    let crop = {
        let config = crop::CropDetectConfig { sample_count: 13, min_black_pixels: 2 };

        match crop::detect_crop(&idx, &inf, &config) {
            Ok(detected) if detected.has_crop() => detected.to_tuple(),
            _ => (0, 0),
        }
    };

    args.decode_strat = Some(ffms::get_decode_strat(&idx, &inf, crop)?);

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

    chunk::merge_out(
        &work_dir.join("encode"),
        if args.audio.is_some() { &video_mkv } else { &args.output },
        &inf,
        if args.audio.is_some() { None } else { Some(&args.input) },
    )?;

    if let Some(ref audio_spec) = args.audio {
        audio::process_audio(audio_spec, &args.input, &video_mkv, &args.output)?;
        fs::remove_file(&video_mkv)?;
    }

    print!("\x1b[?25h\x1b[?1049l");
    std::io::stdout().flush().unwrap();

    let input_size = fs::metadata(&args.input)?.len();
    let output_size = fs::metadata(&args.output)?.len();
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

    let (final_width, final_height) = (inf.width - crop.1 * 2, inf.height - crop.0 * 2);

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

        libc::signal(libc::SIGINT, exit_restore as *const () as usize);
        libc::signal(libc::SIGSEGV, exit_restore as *const () as usize);
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
        eprintln!("\nBelow stats are only for the last run if resume was used");
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
