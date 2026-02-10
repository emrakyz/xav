use std::path::Path;
use std::process::{Command, Stdio};

use crate::ffms::VidInf;

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum Encoder {
    #[default]
    SvtAv1,
    Avm,
    Vvenc,
    X265,
    X264,
}

impl Encoder {
    pub fn from_str(s: &str) -> Option<Self> {
        match s.to_lowercase().as_str() {
            "svt-av1" => Some(Self::SvtAv1),
            "avm" => Some(Self::Avm),
            "vvenc" => Some(Self::Vvenc),
            "x265" => Some(Self::X265),
            "x264" => Some(Self::X264),
            _ => None,
        }
    }

    pub const fn extension(self) -> &'static str {
        match self {
            Self::SvtAv1 | Self::Avm => "ivf",
            Self::Vvenc => "266",
            Self::X265 => "265",
            Self::X264 => "264",
        }
    }

    pub const fn integer_qp(self) -> bool {
        matches!(self, Self::Avm | Self::Vvenc)
    }
}

pub struct EncConfig<'a> {
    pub inf: &'a VidInf,
    pub params: &'a str,
    pub zone_params: Option<&'a str>,
    pub crf: f32,
    pub output: &'a Path,
    pub grain_table: Option<&'a Path>,
    pub width: u32,
    pub height: u32,
    pub frames: usize,
}

pub fn make_enc_cmd(encoder: Encoder, cfg: &EncConfig) -> Command {
    let mut cmd = match encoder {
        Encoder::SvtAv1 => make_svt_cmd(cfg),
        Encoder::Avm => make_avm_cmd(cfg),
        Encoder::Vvenc => make_vvenc_cmd(cfg),
        Encoder::X265 => make_x265_cmd(cfg),
        Encoder::X264 => make_x264_cmd(cfg),
    };
    if let Some(z) = cfg.zone_params {
        cmd.args(z.split_whitespace());
    }
    cmd
}

fn make_svt_cmd(cfg: &EncConfig) -> Command {
    let mut cmd = Command::new("SvtAv1EncApp");

    let width_str = cfg.width.to_string();
    let height_str = cfg.height.to_string();
    let fps_num_str = cfg.inf.fps_num.to_string();
    let fps_den_str = cfg.inf.fps_den.to_string();
    let frames_str = cfg.frames.to_string();

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
        "--frames",
        &frames_str,
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
        "--disable-kf",
    ]);

    cmd.arg(format!("--width={width_str}"));
    cmd.arg(format!("--height={height_str}"));
    cmd.arg(format!("--forced_max_frame_width={width_str}"));
    cmd.arg(format!("--forced_max_frame_height={height_str}"));
    cmd.arg(format!("--fps={fps_str}"));
    cmd.arg(format!("--limit={}", cfg.frames));
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

fn make_vvenc_cmd(cfg: &EncConfig) -> Command {
    let mut cmd = Command::new("vvencFFapp");

    let width_str = cfg.width.to_string();
    let height_str = cfg.height.to_string();
    let fps_str = format!("{}/{}", cfg.inf.fps_num, cfg.inf.fps_den);
    let frames_str = cfg.frames.to_string();

    cmd.args([
        "-v",
        "4",
        "--stats",
        "0",
        "--InputBitDepth",
        "10",
        "--InputChromaFormat",
        "420",
        "--IntraPeriod",
        "-1",
        "--RefreshSec",
        "0",
        "--DecodingRefreshType",
        "idr",
        "--POC0IDR",
        "1",
        "--NumPasses",
        "1",
        "--Passes",
        "1",
        "--Profile",
        "main_10",
        "--Tier",
        "main",
        "--MaxBitDepthConstraint",
        "10",
        "--InternalBitDepth",
        "10",
        "--OutputBitDepth",
        "10",
    ]);

    cmd.arg("--SourceWidth").arg(&width_str);
    cmd.arg("--SourceHeight").arg(&height_str);
    cmd.arg("--fps").arg(&fps_str);
    cmd.arg("--FramesToBeEncoded").arg(&frames_str);

    if cfg.crf >= 0.0 {
        cmd.arg("--QP").arg(format!("{}", cfg.crf as i32));
    }

    colorize_vvenc(&mut cmd, cfg.inf);

    cmd.args(cfg.params.split_whitespace());

    cmd.arg("-i").arg("-");
    cmd.arg("-b").arg(cfg.output);

    cmd.stdin(Stdio::piped()).stdout(Stdio::piped()).stderr(Stdio::piped());

    cmd
}

fn make_x265_cmd(cfg: &EncConfig) -> Command {
    let mut cmd = Command::new("x265");

    cmd.args([
        "--log-level",
        "error",
        "--input-csp",
        "1",
        "--input-depth",
        "10",
        "--output-depth",
        "10",
        "--profile",
        "main10",
        "--gop-lookahead",
        "0",
        "--open-gop",
        "--keyint",
        "-1",
        "--min-keyint",
        "9999",
        "--no-scenecut",
        "--rc-lookahead",
        "250",
        "--lookahead-slices",
        "1",
        "--lookahead-threads",
        "1",
        "--frame-threads",
        "1",
        "--slices",
        "1",
        "--no-info",
        "--no-vui-hrd-info",
        "--no-vui-timing-info",
        "--fps",
    ]);

    cmd.arg(format!("{}/{}", cfg.inf.fps_num, cfg.inf.fps_den));
    cmd.arg("--input-res").arg(format!("{}x{}", cfg.width, cfg.height));
    cmd.arg("--frames").arg(cfg.frames.to_string());

    if cfg.crf >= 0.0 {
        cmd.arg("--crf").arg(format!("{:.2}", cfg.crf));
    }

    if let Some(preset) = x265_signal_preset(cfg.inf) {
        cmd.arg("--video-signal-type-preset");
        let cv = preset
            .starts_with("BT2100_PQ")
            .then(|| cfg.inf.mastering_display.as_deref().and_then(x265_color_volume))
            .flatten();
        if let Some(cv) = cv {
            cmd.arg(format!("{preset}:{cv}"));
        } else {
            cmd.arg(preset);
        }
        if let Some(ref md) = cfg.inf.mastering_display
            && let Some(converted) = h26x_mastering(md, false)
        {
            cmd.args(["--master-display", &converted]);
        }
        if let Some(ref cl) = cfg.inf.content_light {
            cmd.args(["--max-cll", cl]);
        }
    } else {
        colorize_h26x(&mut cmd, cfg.inf, false);
    }

    #[cfg(target_arch = "x86_64")]
    if std::arch::is_x86_feature_detected!("avx512f") {
        cmd.args(["--asm", "avx512"]);
    }

    cmd.args(cfg.params.split_whitespace());
    cmd.arg("--output").arg(cfg.output);
    cmd.args(["--input", "-"]);
    cmd.stdin(Stdio::piped()).stderr(Stdio::piped());

    cmd
}

fn make_x264_cmd(cfg: &EncConfig) -> Command {
    let mut cmd = Command::new("x264");

    cmd.args([
        "--log-level",
        "error",
        "--input-csp",
        "i420",
        "--output-csp",
        "i420",
        "--input-depth",
        "10",
        "--output-depth",
        "10",
        "--profile",
        "high10",
        "--keyint",
        "infinite",
        "--min-keyint",
        "9999",
        "--no-scenecut",
        "--open-gop",
        "--b-adapt",
        "2",
        "--muxer",
        "raw",
        "--demuxer",
        "raw",
        "--threads",
        "1",
        "--lookahead-threads",
        "1",
        "--fps",
    ]);

    cmd.arg(format!("{}/{}", cfg.inf.fps_num, cfg.inf.fps_den));
    cmd.arg("--input-res").arg(format!("{}x{}", cfg.width, cfg.height));
    cmd.arg("--frames").arg(cfg.frames.to_string());

    if cfg.crf >= 0.0 {
        cmd.arg("--crf").arg(format!("{:.2}", cfg.crf));
    }

    if let Some(cr) = cfg.inf.color_range {
        cmd.args(["--input-range", if cr == 1 { "pc" } else { "tv" }]);
    }

    colorize_h26x(&mut cmd, cfg.inf, true);

    #[cfg(target_arch = "x86_64")]
    if std::arch::is_x86_feature_detected!("avx512f") {
        cmd.args(["--asm", "avx512"]);
    }

    cmd.args(cfg.params.split_whitespace());
    cmd.arg("--output").arg(cfg.output);
    cmd.arg("-");
    cmd.stdin(Stdio::piped()).stderr(Stdio::piped());

    cmd
}

fn colorize_h26x(cmd: &mut Command, inf: &VidInf, is_x264: bool) {
    let unk = |s| if is_x264 && s == "unknown" { "undef" } else { s };

    if let Some(cp) = inf.color_primaries {
        cmd.args(["--colorprim", unk(h26x_color_primaries_str(cp))]);
    }
    if let Some(tc) = inf.transfer_characteristics {
        cmd.args(["--transfer", unk(h26x_transfer_char_str(tc))]);
    }
    if let Some(mc) = inf.matrix_coefficients {
        cmd.args(["--colormatrix", unk(h26x_matrix_coeff_str(mc))]);
    }
    if let Some(cr) = inf.color_range {
        if is_x264 {
            cmd.args(["--range", if cr == 1 { "pc" } else { "tv" }]);
        } else {
            cmd.args(["--range", if cr == 1 { "full" } else { "limited" }]);
        }
    }
    if let Some(csp) = inf.chroma_sample_position
        && (1..=6).contains(&csp)
    {
        cmd.args(["--chromaloc", &(csp - 1).to_string()]);
    }
    if let Some(ref md) = inf.mastering_display
        && let Some(converted) = h26x_mastering(md, is_x264)
    {
        cmd.args([if is_x264 { "--mastering-display" } else { "--master-display" }, &converted]);
    }
    if let Some(ref cl) = inf.content_light {
        cmd.args([if is_x264 { "--cll" } else { "--max-cll" }, cl]);
    }
}

fn x265_signal_preset(inf: &VidInf) -> Option<&'static str> {
    match (
        inf.color_primaries?,
        inf.transfer_characteristics?,
        inf.matrix_coefficients?,
        inf.color_range.unwrap_or(0),
    ) {
        (9, 16, 9, 0) => Some("BT2100_PQ_YCC"),
        (9, 16, 14, 0) => Some("BT2100_PQ_ICTCP"),
        (9, 16, 0, 0) => Some("BT2100_PQ_RGB"),
        (9, 18, 9, 0) => Some("BT2100_HLG_YCC"),
        (9, 18, 0, 0) => Some("BT2100_HLG_RGB"),
        (9, 14, 9, 0) => Some("BT2020_YCC_NCL"),
        (1, 1, 1, 0) => Some("BT709_YCC"),
        (1, 1, 0, 0) => Some("BT709_RGB"),
        (1, 1, 0, 1) => Some("FR709_RGB"),
        (6, 6, 6, 0) => Some("BT601_525"),
        (5, 6, 5, 0) => Some("BT601_626"),
        _ => None,
    }
}

fn x265_color_volume(md: &str) -> Option<&'static str> {
    let pair = |s: &str, p: &str| -> Option<(u32, u32)> {
        let start = s.find(p)? + p.len();
        let end = s[start..].find(')')? + start;
        let mut parts = s[start..end].split(',');
        let a: f64 = parts.next()?.parse().ok()?;
        let b: f64 = parts.next()?.parse().ok()?;
        Some(((a * 50000.0) as u32, (b * 50000.0) as u32))
    };

    let g = pair(md, "G(")?;
    let b = pair(md, "B(")?;
    let r = pair(md, "R(")?;
    let wp = pair(md, "WP(")?;

    let start = md.find("L(")? + 2;
    let end = md[start..].find(')')? + start;
    let mut parts = md[start..end].split(',');
    let lmax = (parts.next()?.parse::<f64>().ok()? * 10000.0) as u32;
    let lmin = (parts.next()?.parse::<f64>().ok()? * 10000.0) as u32;

    match (g, b, r, wp, lmax, lmin) {
        ((13250, 34500), (7500, 3000), (34000, 16000), (15635, 16450), 10_000_000, 5) => {
            Some("P3D65x1000n0005")
        }
        ((13250, 34500), (7500, 3000), (34000, 16000), (15635, 16450), 40_000_000, 50) => {
            Some("P3D65x4000n005")
        }
        ((8500, 39850), (6550, 2300), (34000, 146_000), (15635, 16450), 10_000_000, 1) => {
            Some("BT2100x108n0005")
        }
        _ => None,
    }
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

fn h26x_mastering(md: &str, x264_format: bool) -> Option<String> {
    let pair = |s: &str, p: &str| -> Option<(f64, f64)> {
        let start = s.find(p)? + p.len();
        let end = s[start..].find(')')? + start;
        let mut parts = s[start..end].split(',');
        Some((parts.next()?.parse().ok()?, parts.next()?.parse().ok()?))
    };

    let (gx, gy) = pair(md, "G(")?;
    let (bx, by) = pair(md, "B(")?;
    let (rx, ry) = pair(md, "R(")?;
    let (wx, wy) = pair(md, "WP(")?;
    let (lmax, lmin) = pair(md, "L(")?;

    let gx = (gx * 50000.0) as u32;
    let gy = (gy * 50000.0) as u32;
    let bx = (bx * 50000.0) as u32;
    let by = (by * 50000.0) as u32;
    let rx = (rx * 50000.0) as u32;
    let ry = (ry * 50000.0) as u32;
    let wx = (wx * 50000.0) as u32;
    let wy = (wy * 50000.0) as u32;
    let lmax = (lmax * 10000.0) as u32;
    let lmin = (lmin * 10000.0) as u32;

    if x264_format {
        Some(format!("G({gx},{gy})B({bx},{by})R({rx},{ry})WP({wx},{wy})L({lmax},{lmin})"))
    } else {
        Some(format!("{gx},{gy},{bx},{by},{rx},{ry},{wx},{wy},{lmax},{lmin}"))
    }
}

fn colorize_vvenc(cmd: &mut Command, inf: &VidInf) {
    let tc = inf.transfer_characteristics.unwrap_or(2);
    let cp = inf.color_primaries.unwrap_or(2);

    let is_hlg = tc == 18;
    let is_pq = tc == 16;
    let is_bt2020 = cp == 9;
    let is_bt470bg = cp == 5;

    if is_pq || is_hlg {
        let hdr_mode = match (is_pq, is_hlg, is_bt2020) {
            (true, _, true) => "pq_2020",
            (true, _, false) => "pq",
            (_, true, true) => "hlg_2020",
            (_, true, false) => "hlg",
            _ => "off",
        };
        cmd.args(["--Hdr", hdr_mode]);
    } else {
        let sdr_mode = match (is_bt2020, is_bt470bg) {
            (true, _) => "sdr_2020",
            (_, true) => "sdr_470bg",
            _ => "sdr_709",
        };
        cmd.args(["--Sdr", sdr_mode]);
    }

    if let Some(cp) = inf.color_primaries {
        cmd.args(["--ColourPrimaries", h26x_color_primaries_str(cp)]);
    }
    if let Some(tc) = inf.transfer_characteristics {
        cmd.args(["--TransferCharacteristics", h26x_transfer_char_str(tc)]);
    }
    if let Some(mc) = inf.matrix_coefficients {
        cmd.args(["--MatrixCoefficients", h26x_matrix_coeff_str(mc)]);
    }
    if let Some(cr) = inf.color_range {
        cmd.args(["--Range", if cr == 1 { "full" } else { "limited" }]);
    }
    if let Some(csp) = inf.chroma_sample_position
        && (1..=6).contains(&csp)
    {
        cmd.args(["--ChromaSampleLocType", &(csp - 1).to_string()]);
    }
    if let Some(ref md) = inf.mastering_display
        && let Some(converted) = h26x_mastering(md, false)
    {
        cmd.args(["--MasteringDisplayColourVolume", &converted]);
    }
    if let Some(ref cl) = inf.content_light {
        cmd.args(["--MaxContentLightLevel", cl]);
    }
}

const fn h26x_color_primaries_str(v: i32) -> &'static str {
    match v {
        1 => "bt709",
        4 => "bt470m",
        5 => "bt470bg",
        6 => "smpte170m",
        7 => "smpte240m",
        8 => "film",
        9 => "bt2020",
        10 => "smpte428",
        11 => "smpte431",
        12 => "smpte432",
        _ => "unknown",
    }
}

const fn h26x_transfer_char_str(v: i32) -> &'static str {
    match v {
        1 => "bt709",
        4 => "bt470m",
        5 => "bt470bg",
        6 => "smpte170m",
        7 => "smpte240m",
        8 => "linear",
        9 => "log100",
        10 => "log316",
        11 => "iec61966-2-4",
        12 => "bt1361e",
        13 => "iec61966-2-1",
        14 => "bt2020-10",
        15 => "bt2020-12",
        16 => "smpte2084",
        17 => "smpte428",
        18 => "arib-std-b67",
        _ => "unknown",
    }
}

const fn h26x_matrix_coeff_str(v: i32) -> &'static str {
    match v {
        0 => "gbr",
        1 => "bt709",
        4 => "fcc",
        5 => "bt470bg",
        6 => "smpte170m",
        7 => "smpte240m",
        8 => "ycgco",
        9 => "bt2020nc",
        10 => "bt2020c",
        11 => "smpte2085",
        12 => "chroma-derived-nc",
        13 => "chroma-derived-c",
        14 => "ictcp",
        _ => "unknown",
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

#[cfg(feature = "libsvtav1")]
fn parse_svt_param(config: *mut crate::svt::EbSvtAv1EncConfiguration, name: &str, value: &str) {
    let n = std::ffi::CString::new(name).unwrap();
    let v = std::ffi::CString::new(value).unwrap();
    unsafe { crate::svt::svt_av1_enc_parse_parameter(config, n.as_ptr(), v.as_ptr()) };
}

#[cfg(feature = "libsvtav1")]
fn parse_svt_params(config: *mut crate::svt::EbSvtAv1EncConfiguration, params: &str) {
    let mut iter = params.split_whitespace();
    while let Some(key) = iter.next() {
        if let Some(name) = key.strip_prefix("--")
            && let Some(val) = iter.next()
        {
            parse_svt_param(config, name, val);
        }
    }
}

#[cfg(feature = "libsvtav1")]
pub fn set_svt_config(config: *mut crate::svt::EbSvtAv1EncConfiguration, cfg: &EncConfig) {
    let w = cfg.width.to_string();
    let h = cfg.height.to_string();

    for (name, value) in [
        ("input-depth", "10"),
        ("color-format", "1"),
        ("profile", "0"),
        ("tile-rows", "0"),
        ("tile-columns", "0"),
        ("keyint", "0"),
        ("rc", "0"),
        ("scd", "0"),
    ] {
        parse_svt_param(config, name, value);
    }

    parse_svt_param(config, "width", &w);
    parse_svt_param(config, "forced-max-frame-width", &w);
    parse_svt_param(config, "height", &h);
    parse_svt_param(config, "forced-max-frame-height", &h);
    parse_svt_param(config, "fps-num", &cfg.inf.fps_num.to_string());
    parse_svt_param(config, "fps-denom", &cfg.inf.fps_den.to_string());

    if cfg.crf >= 0.0 {
        parse_svt_param(config, "crf", &format!("{:.2}", cfg.crf));
    }

    if let Some(cp) = cfg.inf.color_primaries {
        parse_svt_param(config, "color-primaries", &cp.to_string());
    }
    if let Some(tc) = cfg.inf.transfer_characteristics {
        parse_svt_param(config, "transfer-characteristics", &tc.to_string());
    }
    if let Some(mc) = cfg.inf.matrix_coefficients {
        parse_svt_param(config, "matrix-coefficients", &mc.to_string());
    }
    if let Some(cr) = cfg.inf.color_range {
        parse_svt_param(config, "color-range", &cr.to_string());
    }
    if let Some(csp) = cfg.inf.chroma_sample_position {
        parse_svt_param(config, "chroma-sample-position", &csp.to_string());
    }
    if let Some(ref md) = cfg.inf.mastering_display {
        parse_svt_param(config, "mastering-display", md);
    }
    if let Some(ref cl) = cfg.inf.content_light {
        parse_svt_param(config, "content-light", cl);
    }

    if let Some(gt) = cfg.grain_table {
        parse_svt_param(config, "fgs-table", &gt.display().to_string());
    }

    parse_svt_params(config, cfg.params);

    if let Some(z) = cfg.zone_params {
        parse_svt_params(config, z);
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
