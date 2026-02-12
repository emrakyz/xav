use std::collections::HashSet;
use std::fs;
use std::path::Path;
use std::process::Command;

#[derive(Clone)]
pub enum AudioBitrate {
    Auto,
    Fixed(u32),
    Norm,
}

#[derive(Clone)]
pub enum AudioStreams {
    All,
    Specific(Vec<usize>),
}

#[derive(Clone)]
pub struct AudioSpec {
    pub bitrate: AudioBitrate,
    pub streams: AudioStreams,
}

#[derive(Clone)]
struct AudioStream {
    index: usize,
    channels: u32,
    lang: Option<String>,
}

const FF_FLAGS: [&str; 13] = [
    "-fflags",
    "+genpts+igndts+discardcorrupt+bitexact",
    "-bitexact",
    "-avoid_negative_ts",
    "make_zero",
    "-err_detect",
    "ignore_err",
    "-ignore_unknown",
    "-reset_timestamps",
    "1",
    "-start_at_zero",
    "-output_ts_offset",
    "0",
];

pub fn parse_audio_arg(arg: &str) -> Result<AudioSpec, Box<dyn std::error::Error>> {
    let parts: Vec<&str> = arg.split_whitespace().collect();
    if parts.len() != 2 {
        return Err("Audio format: -a <auto|norm|bitrate> <all|stream_ids>".into());
    }

    Ok(AudioSpec {
        bitrate: match parts[0] {
            "auto" => AudioBitrate::Auto,
            "norm" => AudioBitrate::Norm,
            _ => AudioBitrate::Fixed(parts[0].parse()?),
        },
        streams: if parts[1] == "all" {
            AudioStreams::All
        } else {
            AudioStreams::Specific(parts[1].split(',').map(str::parse).collect::<Result<_, _>>()?)
        },
    })
}

fn lang_name(code: &str) -> &str {
    match code {
        "eng" => "English",
        "rus" => "Russian",
        "jpn" => "Japanese",
        "spa" => "Spanish",
        "fre" | "fra" => "French",
        "ger" | "deu" => "German",
        "ita" => "Italian",
        "por" => "Portuguese",
        "chi" | "zho" => "Chinese",
        "kor" => "Korean",
        "ara" => "Arabic",
        "hin" => "Hindi",
        "tur" => "Turkish",
        "pol" => "Polish",
        "ukr" => "Ukrainian",
        "dut" | "nld" => "Dutch",
        "swe" => "Swedish",
        "dan" => "Danish",
        "nor" => "Norwegian",
        "fin" => "Finnish",
        "gre" | "ell" => "Greek",
        "cze" | "ces" => "Czech",
        "hun" => "Hungarian",
        "rum" | "ron" => "Romanian",
        "tha" => "Thai",
        "vie" => "Vietnamese",
        "ind" => "Indonesian",
        "may" | "msa" => "Malay",
        "heb" => "Hebrew",
        "per" | "fas" => "Persian",
        "bul" => "Bulgarian",
        "srp" => "Serbian",
        "hrv" => "Croatian",
        "slk" | "slo" => "Slovak",
        "slv" => "Slovenian",
        "bel" => "Belarusian",
        "ben" => "Bengali",
        "tam" => "Tamil",
        "tel" => "Telugu",
        "mar" => "Marathi",
        "urd" => "Urdu",
        "pan" => "Punjabi",
        "tgl" => "Filipino",
        "mya" | "bur" => "Burmese",
        "khm" => "Khmer",
        "swa" => "Swahili",
        "zul" => "Zulu",
        "xho" => "Xhosa",
        "hau" => "Hausa",
        "amh" => "Amharic",
        "isl" | "ice" => "Icelandic",
        "mlt" => "Maltese",
        "gle" => "Irish",
        "lav" => "Latvian",
        "lit" => "Lithuanian",
        "est" => "Estonian",
        "nep" => "Nepali",
        "sin" => "Sinhala",
        "pus" | "pbt" => "Pashto",
        "lao" => "Lao",
        "mon" => "Mongolian",
        _ => code,
    }
}

fn get_streams(input: &Path) -> Result<Vec<AudioStream>, Box<dyn std::error::Error>> {
    let out = Command::new("ffprobe")
        .args([
            "-v",
            "quiet",
            "-select_streams",
            "a",
            "-show_entries",
            "stream=index,channels:stream_tags=language",
            "-of",
            "csv=p=0",
        ])
        .arg(input)
        .output()?;

    let mut seen = HashSet::new();
    let mut streams: Vec<_> = String::from_utf8_lossy(&out.stdout)
        .lines()
        .rev()
        .filter_map(|l| {
            let p: Vec<_> = l.split(',').collect();
            (p.len() >= 2).then(|| {
                let idx = p[0].parse().ok()?;
                seen.insert(idx).then(|| AudioStream {
                    index: idx,
                    channels: p[1].parse().unwrap_or(2),
                    lang: p.get(2).filter(|s| !s.is_empty()).map(std::string::ToString::to_string),
                })
            })?
        })
        .collect();
    streams.reverse();
    streams.sort_by_key(|s| s.index);
    Ok(streams)
}

fn add_opus_args(cmd: &mut Command, bitrate: u32, channels: u32, normalize: bool) {
    if !normalize && matches!(channels, 6..=8) {
        let layout = ["5.1", "6.1", "7.1"][channels as usize - 6];
        cmd.args(["-af", &format!("channelmap=channel_layout={layout}")]);
    }
    cmd.args([
        "-c:a",
        "libopus",
        "-ar",
        "48000",
        "-b:a",
        &format!("{bitrate}k"),
        "-application",
        "audio",
        "-frame_duration",
        "120",
        "-compression_level",
        "10",
        "-vbr",
        "on",
        "-mapping_family",
        if normalize || channels <= 2 { "0" } else { "1" },
        "-apply_phase_inv",
        "true",
        "-packet_loss",
        "0",
    ]);
}

fn encode_stream(
    input: &Path,
    stream: &AudioStream,
    bitrate: u32,
    output: &Path,
    normalize: bool,
    times: Option<&[(f64, f64)]>,
) -> Result<(), Box<dyn std::error::Error>> {
    if let Some(t) = times
        && t.len() > 1
    {
        return encode_stream_multi(input, stream, bitrate, output, normalize, t);
    }

    let mut cmd = Command::new("ffmpeg");
    cmd.args(["-loglevel", "error", "-hide_banner", "-nostdin", "-stats", "-y"]);

    if let Some(t) = times
        && t.len() == 1
    {
        cmd.args(["-ss", &format!("{:.6}", t[0].0)]);
        cmd.args(["-t", &format!("{:.6}", t[0].1 - t[0].0)]);
    }

    cmd.arg("-i")
        .arg(input)
        .args(["-map_metadata", "-1", "-map_chapters", "-1", "-dn", "-sn", "-vn", "-map"])
        .arg(format!("0:{}", stream.index));

    if normalize {
        cmd.args([
            "-af",
            "pan=stereo|FL=FL+0.707*FC+0.707*SL+0.5*BL+0.5*BC|FR=FR+0.707*FC+0.707*SR+0.5*BR+0.5*\
             BC,loudnorm=I=-14:TP=-2.5:LRA=14",
        ]);
    }

    add_opus_args(&mut cmd, bitrate, stream.channels, normalize);
    cmd.args(FF_FLAGS)
        .arg(output)
        .status()
        .ok()
        .filter(std::process::ExitStatus::success)
        .ok_or_else(|| format!("Failed to encode stream {}", stream.index))?;
    Ok(())
}

fn encode_stream_multi(
    input: &Path,
    stream: &AudioStream,
    bitrate: u32,
    output: &Path,
    normalize: bool,
    times: &[(f64, f64)],
) -> Result<(), Box<dyn std::error::Error>> {
    let temp_dir = output.parent().unwrap();
    let mut segments = Vec::new();

    for (i, (start, end)) in times.iter().enumerate() {
        let seg_path = temp_dir.join(format!("audio_enc_{i}.opus"));

        let mut cmd = Command::new("ffmpeg");
        cmd.args(["-loglevel", "error", "-hide_banner", "-nostdin", "-y"])
            .args(["-ss", &format!("{start:.6}")])
            .args(["-t", &format!("{:.6}", end - start)])
            .arg("-i")
            .arg(input)
            .args(["-map_metadata", "-1", "-map_chapters", "-1", "-dn", "-sn", "-vn", "-map"])
            .arg(format!("0:{}", stream.index));

        if normalize {
            cmd.args([
                "-af",
                "pan=stereo|FL=FL+0.707*FC+0.707*SL+0.5*BL+0.5*BC|FR=FR+0.707*FC+0.707*SR+0.5*\
                 BR+0.5*BC,loudnorm=I=-14:TP=-2.5:LRA=14",
            ]);
        }

        add_opus_args(&mut cmd, bitrate, stream.channels, normalize);
        cmd.arg(&seg_path);

        if cmd.status().is_ok_and(|s| s.success()) {
            segments.push(seg_path);
        }
    }

    if segments.is_empty() {
        return Err("No audio segments encoded".into());
    }

    let concat_list = temp_dir.join(format!("concat_{}.txt", stream.index));
    let mut content = String::new();
    for seg in &segments {
        use std::fmt::Write;
        let _ = writeln!(content, "file '{}'", seg.canonicalize()?.display());
    }
    fs::write(&concat_list, content)?;

    let mut cmd = Command::new("ffmpeg");
    cmd.args(["-loglevel", "error", "-hide_banner", "-nostdin", "-y"])
        .args(["-f", "concat", "-safe", "0", "-i"])
        .arg(&concat_list)
        .args(["-c", "copy"])
        .arg(output);

    let status = cmd.status()?;

    let _ = fs::remove_file(&concat_list);
    for seg in &segments {
        let _ = fs::remove_file(seg);
    }

    if !status.success() {
        return Err(format!("Failed to concat stream {}", stream.index).into());
    }

    Ok(())
}

fn mux_files(
    video: &Path,
    files: &[(AudioStream, std::path::PathBuf)],
    input: &Path,
    output: &Path,
    has_ranges: bool,
    dar: Option<(u32, u32)>,
) -> Result<(), Box<dyn std::error::Error>> {
    let mut cmd = Command::new("ffmpeg");
    cmd.args(["-loglevel", "error", "-hide_banner", "-nostdin", "-stats", "-y", "-i"]).arg(video);

    for (_, path) in files {
        cmd.arg("-i").arg(path);
    }

    let is_mp4 = output.extension().is_some_and(|e| e == "mp4");

    if !has_ranges && !is_mp4 {
        cmd.arg("-i").arg(input);
    }

    cmd.args(["-map", "0:v"]);

    for i in 0..files.len() {
        cmd.args(["-map", &format!("{}:a", i + 1)]);
    }

    if !has_ranges && !is_mp4 {
        let input_idx = files.len() + 1;
        cmd.args(["-map", &format!("{input_idx}")])
            .args(["-map", &format!("-{input_idx}:V")])
            .args(["-map", &format!("-{input_idx}:a")])
            .args(["-map_chapters", &input_idx.to_string()]);
    }

    for (i, (info, _)) in files.iter().enumerate() {
        let code = info.lang.as_deref().unwrap_or("und");
        cmd.args([&format!("-metadata:s:a:{i}"), &format!("language={code}")]);
        cmd.args([&format!("-metadata:s:a:{i}"), &format!("title={}", lang_name(code))]);
    }

    cmd.args(["-c", "copy"]);
    if let Some((dw, dh)) = dar {
        cmd.args(["-aspect", &format!("{dw}:{dh}")]);
    }
    cmd.args(FF_FLAGS)
        .arg(output)
        .status()
        .ok()
        .filter(std::process::ExitStatus::success)
        .ok_or("Muxing failed")?;
    Ok(())
}

pub fn process_audio(
    spec: &AudioSpec,
    input: &Path,
    video: &Path,
    output: &Path,
    ranges: Option<&[(usize, usize)]>,
    fps_num: u32,
    fps_den: u32,
    dar: Option<(u32, u32)>,
) -> Result<(), Box<dyn std::error::Error>> {
    let all = get_streams(input)?;
    let sel: Vec<_> = match &spec.streams {
        AudioStreams::All => all.iter().collect(),
        AudioStreams::Specific(ids) => all.iter().filter(|s| ids.contains(&s.index)).collect(),
    };

    let times = ranges.map(|r| crate::chunk::ranges_to_times(r, fps_num, fps_den));

    let work = input.parent().unwrap();
    let (use_norm, base_bitrate) = match &spec.bitrate {
        AudioBitrate::Norm => (true, 128),
        AudioBitrate::Auto | AudioBitrate::Fixed(_) => (false, 0),
    };

    let files: Vec<_> = sel
        .iter()
        .map(|s| {
            let br = if use_norm {
                base_bitrate
            } else {
                match &spec.bitrate {
                    AudioBitrate::Auto => {
                        let cc = match s.channels {
                            1 => 1.0,
                            2 => 2.0,
                            3 => 2.1,
                            4 => 3.1,
                            5 => 4.1,
                            6 => 5.1,
                            7 => 6.1,
                            8 => 7.1,
                            _ => f64::from(s.channels),
                        };
                        (128.0 * ((cc / 2.0) * 0.75)) as u32
                    }
                    AudioBitrate::Fixed(b) => *b,
                    AudioBitrate::Norm => unreachable!(),
                }
            };
            let path =
                work.join(format!("{}_{:02}.opus", s.lang.as_deref().unwrap_or("und"), s.index));

            encode_stream(input, s, br, &path, use_norm, times.as_deref())?;
            Ok::<_, Box<dyn std::error::Error>>(((*s).clone(), path))
        })
        .collect::<Result<Vec<_>, _>>()?;

    mux_files(video, &files, input, output, ranges.is_some(), dar)?;

    if ranges.is_none() && output.extension().is_some_and(|e| e == "mp4") {
        crate::chunk::add_mp4_subs(input, output);
    }

    for (_, p) in &files {
        let _ = fs::remove_file(p);
    }
    Ok(())
}
