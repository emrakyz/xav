use std::path::Path;
use std::process::{Command, Stdio};

use crate::ffms::VidInf;

#[derive(Clone, Copy, Default, PartialEq, Eq)]
pub enum Encoder {
    #[default]
    SvtAv1,
    Avm,
}

impl Encoder {
    pub fn from_str(s: &str) -> Option<Self> {
        match s.to_lowercase().as_str() {
            "svt-av1" => Some(Self::SvtAv1),
            "avm" => Some(Self::Avm),
            _ => None,
        }
    }
}

pub struct EncConfig<'a> {
    pub inf: &'a VidInf,
    pub params: &'a str,
    pub crf: f32,
    pub output: &'a Path,
    pub grain_table: Option<&'a Path>,
    pub width: u32,
    pub height: u32,
}

pub fn make_enc_cmd(encoder: Encoder, cfg: &EncConfig) -> Command {
    match encoder {
        Encoder::SvtAv1 => make_svt_cmd(cfg),
        Encoder::Avm => make_avm_cmd(cfg),
    }
}

fn make_svt_cmd(cfg: &EncConfig) -> Command {
    let mut cmd = Command::new("SvtAv1EncApp");

    let width_str = cfg.width.to_string();
    let height_str = cfg.height.to_string();
    let fps_num_str = cfg.inf.fps_num.to_string();
    let fps_den_str = cfg.inf.fps_den.to_string();

    let base_args = [
        "-i",
        "stdin",
        "--input-depth",
        "10",
        "--color-format",
        "1",
        "--profile",
        "0",
        "--passes",
        "1",
        "--tile-rows",
        "0",
        "--tile-columns",
        "0",
        "--width",
        &width_str,
        "--forced-max-frame-width",
        &width_str,
        "--height",
        &height_str,
        "--forced-max-frame-height",
        &height_str,
        "--fps-num",
        &fps_num_str,
        "--fps-denom",
        &fps_den_str,
        "--keyint",
        "0",
        "--rc",
        "0",
        "--scd",
        "0",
        "--progress",
        "2",
    ];

    for i in (0..base_args.len()).step_by(2) {
        cmd.arg(base_args[i]).arg(base_args[i + 1]);
    }

    if cfg.crf >= 0.0 {
        cmd.arg("--crf").arg(format!("{:.2}", cfg.crf));
    }

    colorize_svt(&mut cmd, cfg.inf);

    if let Some(grain_path) = cfg.grain_table {
        cmd.arg("--fgs-table").arg(grain_path);
    }

    cmd.args(cfg.params.split_whitespace())
        .arg("-b")
        .arg(cfg.output)
        .stdin(Stdio::piped())
        .stderr(Stdio::piped());

    cmd
}

fn colorize_svt(cmd: &mut Command, inf: &VidInf) {
    if let Some(cp) = inf.color_primaries {
        cmd.args(["--color-primaries", &cp.to_string()]);
    }
    if let Some(tc) = inf.transfer_characteristics {
        cmd.args(["--transfer-characteristics", &tc.to_string()]);
    }
    if let Some(mc) = inf.matrix_coefficients {
        cmd.args(["--matrix-coefficients", &mc.to_string()]);
    }
    if let Some(cr) = inf.color_range {
        cmd.args(["--color-range", &cr.to_string()]);
    }
    if let Some(csp) = inf.chroma_sample_position {
        cmd.args(["--chroma-sample-position", &csp.to_string()]);
    }
    if let Some(ref md) = inf.mastering_display {
        cmd.args(["--mastering-display", md]);
    }
    if let Some(ref cl) = inf.content_light {
        cmd.args(["--content-light", cl]);
    }
}

fn make_avm_cmd(cfg: &EncConfig) -> Command {
    let mut cmd = Command::new("avmenc");

    let width_str = cfg.width.to_string();
    let height_str = cfg.height.to_string();
    let fps_str = format!("{}/{}", cfg.inf.fps_num, cfg.inf.fps_den);

    cmd.args([
        "--codec=av2",
        "--profile=0",
        "--usage=0",
        "--passes=1",
        "--i420",
        "--bit-depth=10",
        "--input-bit-depth=10",
        "--good",
        "--end-usage=q",
        "--psnr=0",
        "--ivf",
        "--disable-warnings",
        "--disable-warning-prompt",
        "--test-decode=off",
        "--enable-fwd-kf=1",
        "--kf-min-dist=9999",
        "--kf-max-dist=9999",
        "--disable-kf",
    ]);

    cmd.arg(format!("--width={width_str}"));
    cmd.arg(format!("--height={height_str}"));
    cmd.arg(format!("--forced_max_frame_width={width_str}"));
    cmd.arg(format!("--forced_max_frame_height={height_str}"));
    cmd.arg(format!("--fps={fps_str}"));
    cmd.arg(format!("--output={}", cfg.output.display()));

    colorize_avm(&mut cmd, cfg.inf);

    if cfg.crf >= 0.0 {
        cmd.arg(format!("--qp={}", cfg.crf as u32));
    }

    cmd.args(cfg.params.split_whitespace());
    cmd.arg("-");
    cmd.stdin(Stdio::piped()).stdout(Stdio::piped()).stderr(Stdio::null());

    cmd
}

fn colorize_avm(cmd: &mut Command, inf: &VidInf) {
    if let Some(cp) = inf.color_primaries {
        cmd.arg(format!("--color-primaries={}", color_primaries_str(cp)));
    }
    if let Some(tc) = inf.transfer_characteristics {
        cmd.arg(format!("--transfer-characteristics={}", transfer_char_str(tc)));
    }
    if let Some(mc) = inf.matrix_coefficients {
        cmd.arg(format!("--matrix-coefficients={}", matrix_coeff_str(mc)));
    }
    if let Some(csp) = inf.chroma_sample_position {
        cmd.arg(format!("--chroma-sample-position={}", chroma_pos_str(csp)));
    }
}

const fn color_primaries_str(v: i32) -> &'static str {
    match v {
        1 => "bt709",
        4 => "bt470m",
        5 => "bt470bg",
        6 => "bt601",
        7 => "smpte240",
        8 => "film",
        9 => "bt2020",
        10 => "xyz",
        11 => "smpte431",
        12 => "smpte432",
        22 => "ebu3213",
        _ => "unspecified",
    }
}

const fn transfer_char_str(v: i32) -> &'static str {
    match v {
        1 => "bt709",
        4 => "bt470m",
        5 => "bt470bg",
        6 => "bt601",
        7 => "smpte240",
        8 => "lin",
        9 => "log100",
        10 => "log100sq10",
        11 => "iec61966",
        12 => "bt1361",
        13 => "srgb",
        14 => "bt2020-10bit",
        15 => "bt2020-12bit",
        16 => "smpte2084",
        17 => "smpte428",
        18 => "hlg",
        _ => "unspecified",
    }
}

const fn matrix_coeff_str(v: i32) -> &'static str {
    match v {
        0 => "identity",
        1 => "bt709",
        4 => "fcc73",
        5 => "bt470bg",
        6 => "bt601",
        7 => "smpte240",
        8 => "ycgco",
        9 => "bt2020ncl",
        10 => "bt2020cl",
        11 => "smpte2085",
        12 => "chromncl",
        13 => "chromcl",
        14 => "ictcp",
        _ => "unspecified",
    }
}

const fn chroma_pos_str(v: i32) -> &'static str {
    match v {
        1 => "left",
        2 => "center",
        3 => "topleft",
        4 => "top",
        5 => "bottomleft",
        6 => "bottom",
        _ => "unspecified",
    }
}
