use std::{
    ffi::{CStr, CString},
    mem::size_of,
    path::Path,
    process::{Command, Stdio},
};

use crate::{
    Encoder::{Avm, SvtAv1, Vvenc, X264, X265},
    ffms::{VidInf, gcd},
    svt::{
        ChromaPoints, ContentLightLevel, EbSvtAv1EncConfiguration, MasteringDisplayInfo,
        svt_av1_enc_parse_parameter, svt_av1_get_version,
    },
    util::assume_unreachable,
};

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
            "svt-av1" => Some(SvtAv1),
            "avm" => Some(Avm),
            "vvenc" => Some(Vvenc),
            "x265" => Some(X265),
            "x264" => Some(X264),
            _ => None,
        }
    }

    pub const fn extension(self) -> &'static str {
        match self {
            SvtAv1 => "obu",
            Avm => "ivf",
            Vvenc => "266",
            X265 => "265",
            X264 => "264",
        }
    }

    pub const fn codec_id(self) -> &'static [u8] {
        match self {
            SvtAv1 => b"V_AV1",
            Avm => b"V_AV2",
            Vvenc => b"V_MPEGI/ISO/VVC",
            X265 => b"V_MPEGH/ISO/HEVC",
            X264 => b"V_MPEG4/ISO/AVC",
        }
    }

    pub const fn codec_name(self) -> &'static [u8] {
        match self {
            SvtAv1 => b"Alliance for Open Media AV1 Video codec",
            Avm => b"Alliance for Open Media AV2 Video codec",
            Vvenc => b"VVC/H.266",
            X265 => b"HEVC/H.265",
            X264 => b"AVC/H.264",
        }
    }

    pub fn version(self) -> String {
        match self {
            SvtAv1 => {
                let v = unsafe { CStr::from_ptr(svt_av1_get_version()).to_string_lossy() };
                format!("SVT-AV1 {}", v.trim_end_matches("-dirty"))
            }
            Avm => "AVM".into(),
            X264 => run_version("x264", "x264", None),
            X265 => run_version("x265", "x265", Some("version ")),
            Vvenc => run_version("vvencFFapp", "vvenc", Some("version ")),
        }
    }

    pub const fn integer_qp(self) -> bool {
        matches!(self, Avm | Vvenc)
    }
}

fn run_version(prog: &str, name: &str, marker: Option<&str>) -> String {
    let Ok(out) = Command::new(prog).arg("--version").output() else {
        return name.to_owned();
    };
    let mut t = String::from_utf8_lossy(&out.stdout).into_owned();
    t.push_str(&String::from_utf8_lossy(&out.stderr));
    marker.map_or_else(
        || {
            t.lines()
                .map(str::trim)
                .find(|l| !l.is_empty())
                .unwrap_or(name)
                .to_owned()
        },
        |m| {
            t.lines()
                .find_map(|l| l.split_once(m))
                .and_then(|(_, rest)| rest.split_whitespace().next())
                .map_or_else(|| name.to_owned(), |v| format!("{name} {v}"))
        },
    )
}

pub const SVT_CONF_SIZE: usize = size_of::<EbSvtAv1EncConfiguration>();

pub struct EncConfig<'a> {
    pub inf: &'a VidInf,
    pub template: Option<&'a [u8]>,
    pub params: &'a str,
    pub zone_params: Option<&'a str>,
    pub crf: Option<f32>,
    pub out: &'a Path,
    pub chnk_idx: u16,
    pub width: u32,
    pub height: u32,
    pub frames: usize,
}

pub fn make_enc_cmd(encoder: Encoder, cfg: &EncConfig) -> Command {
    let mut cmd = match encoder {
        SvtAv1 => assume_unreachable(),
        Avm => make_avm_cmd(cfg),
        Vvenc => make_vvenc_cmd(cfg),
        X265 => make_x265_cmd(cfg),
        X264 => make_x264_cmd(cfg),
    };
    if let Some(z) = cfg.zone_params {
        cmd.args(z.split_whitespace());
    }
    cmd
}

fn make_avm_cmd(cfg: &EncConfig) -> Command {
    let mut cmd = Command::new("avmenc");

    let width_str = cfg.width.to_string();
    let height_str = cfg.height.to_string();
    let fps_str = format!("{}/{}", cfg.inf.fps_num, cfg.inf.fps_den);

    cmd.args([
        "--threads=1",
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
    cmd.arg(format!("--output={}", cfg.out.display()));

    colorize_avm(&mut cmd, cfg.inf);

    if let Some(crf) = cfg.crf {
        cmd.arg(format!("--qp={}", crf as u32));
    }

    cmd.args(cfg.params.split_whitespace());
    cmd.arg("-");
    cmd.stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::null());

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
        "--Threads",
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
        "--LookAhead",
        "1",
    ]);

    cmd.arg("--SourceWidth").arg(&width_str);
    cmd.arg("--SourceHeight").arg(&height_str);
    cmd.arg("--fps").arg(&fps_str);
    cmd.arg("--FramesToBeEncoded").arg(&frames_str);

    if let Some(crf) = cfg.crf {
        cmd.arg("--QP").arg(format!("{}", crf as i32));
    }

    colorize_vvenc(&mut cmd, cfg.inf);

    cmd.args(cfg.params.split_whitespace());

    cmd.arg("-i").arg("-");
    cmd.arg("-b").arg(cfg.out);

    cmd.stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped());

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
        "--rc-lookahead",
        "250",
        "--keyint",
        "-1",
        "--min-keyint",
        "9999",
        "--no-scenecut",
        "--lookahead-slices",
        "1",
        "--lookahead-threads",
        "1",
        "--frame-threads",
        "1",
        "--slices",
        "1",
        "--pools",
        "1",
        "--no-wpp",
        "--no-info",
        "--no-vui-hrd-info",
        "--no-vui-timing-info",
        "--fps",
    ]);

    cmd.arg(format!("{}/{}", cfg.inf.fps_num, cfg.inf.fps_den));
    cmd.arg("--input-res")
        .arg(format!("{}x{}", cfg.width, cfg.height));
    cmd.arg("--frames").arg(cfg.frames.to_string());

    let (sar_n, sar_d) = h26x_sar(cfg.inf);
    cmd.arg("--sar").arg(format!("{sar_n}:{sar_d}"));

    if let Some(crf) = cfg.crf {
        cmd.arg("--crf").arg(format!("{crf:.2}"));
    }

    if let Some(preset) = x265_signal_preset(cfg.inf) {
        cmd.arg("--video-signal-type-preset");
        let cv = preset
            .starts_with("BT2100_PQ")
            .then(|| {
                cfg.inf
                    .mastering_display
                    .as_deref()
                    .and_then(x265_color_volume)
            })
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

    #[cfg(all(target_arch = "x86_64", target_feature = "avx512f"))]
    cmd.args(["--asm", "avx512"]);

    cmd.args(cfg.params.split_whitespace());
    cmd.arg("--output").arg(cfg.out);
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
        "--force-cfr",
        "--non-deterministic",
        "--nal-hrd",
        "none",
        "--rc-lookahead",
        "250",
        "--fps",
    ]);

    cmd.arg(format!("{}/{}", cfg.inf.fps_num, cfg.inf.fps_den));
    cmd.arg("--input-res")
        .arg(format!("{}x{}", cfg.width, cfg.height));
    cmd.arg("--frames").arg(cfg.frames.to_string());

    let (sar_n, sar_d) = h26x_sar(cfg.inf);
    cmd.arg("--sar").arg(format!("{sar_n}:{sar_d}"));

    if let Some(crf) = cfg.crf {
        cmd.arg("--crf").arg(format!("{crf:.2}"));
    }

    let cr = cfg.inf.color_range;
    cmd.args(["--input-range", if cr == 1 { "pc" } else { "tv" }]);

    colorize_h26x(&mut cmd, cfg.inf, true);

    #[cfg(all(target_arch = "x86_64", target_feature = "avx512f"))]
    cmd.args(["--asm", "avx512"]);

    cmd.args(cfg.params.split_whitespace());
    cmd.arg("--output").arg(cfg.out);
    cmd.arg("-");
    cmd.stdin(Stdio::piped()).stderr(Stdio::piped());

    cmd
}

fn h26x_sar(inf: &VidInf) -> (u64, u64) {
    match inf.dar {
        Some((dw, dh)) => {
            let n = u64::from(dw) * u64::from(inf.height);
            let d = u64::from(dh) * u64::from(inf.width);
            let g = gcd(n, d).max(1);
            (n / g, d / g)
        }
        None => (1, 1),
    }
}

fn colorize_h26x(cmd: &mut Command, inf: &VidInf, is_x264: bool) {
    let unk = |s| {
        if is_x264 && s == "unknown" {
            "undef"
        } else {
            s
        }
    };

    cmd.args([
        "--colorprim",
        unk(h26x_color_prims_str(inf.color_primaries)),
    ]);
    cmd.args([
        "--transfer",
        unk(h26x_trans_char_str(inf.transfer_characteristics)),
    ]);
    cmd.args([
        "--colormatrix",
        unk(h26x_matrix_coef_str(inf.matrix_coefficients)),
    ]);
    let cr = inf.color_range;
    if is_x264 {
        cmd.args(["--range", if cr == 1 { "pc" } else { "tv" }]);
    } else {
        cmd.args(["--range", if cr == 1 { "full" } else { "limited" }]);
    }
    let csp = inf.chroma_sample_position;
    if (1..=6).contains(&csp) {
        cmd.args(["--chromaloc", &(csp - 1).to_string()]);
    }
    if let Some(ref md) = inf.mastering_display
        && let Some(converted) = h26x_mastering(md, is_x264)
    {
        cmd.args([
            if is_x264 {
                "--mastering-display"
            } else {
                "--master-display"
            },
            &converted,
        ]);
    }
    if let Some(ref cl) = inf.content_light {
        cmd.args([if is_x264 { "--cll" } else { "--max-cll" }, cl]);
    }
}

const fn x265_signal_preset(inf: &VidInf) -> Option<&'static str> {
    match (
        inf.color_primaries,
        inf.transfer_characteristics,
        inf.matrix_coefficients,
        inf.color_range,
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
    cmd.arg(format!(
        "--color-primaries={}",
        color_prims_str(inf.color_primaries)
    ));
    cmd.arg(format!(
        "--transfer-characteristics={}",
        trans_char_str(inf.transfer_characteristics)
    ));
    cmd.arg(format!(
        "--matrix-coefficients={}",
        matrix_coef_str(inf.matrix_coefficients)
    ));
    cmd.arg(format!(
        "--chroma-sample-position={}",
        chroma_pos_str(inf.chroma_sample_position)
    ));
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
        Some(format!(
            "G({gx},{gy})B({bx},{by})R({rx},{ry})WP({wx},{wy})L({lmax},{lmin})"
        ))
    } else {
        Some(format!(
            "{gx},{gy},{bx},{by},{rx},{ry},{wx},{wy},{lmax},{lmin}"
        ))
    }
}

fn colorize_vvenc(cmd: &mut Command, inf: &VidInf) {
    let tc = inf.transfer_characteristics;
    let cp = inf.color_primaries;

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

    cmd.args([
        "--ColourPrimaries",
        h26x_color_prims_str(inf.color_primaries),
    ]);
    cmd.args([
        "--TransferCharacteristics",
        h26x_trans_char_str(inf.transfer_characteristics),
    ]);
    cmd.args([
        "--MatrixCoefficients",
        h26x_matrix_coef_str(inf.matrix_coefficients),
    ]);
    let cr = inf.color_range;
    cmd.args(["--Range", if cr == 1 { "full" } else { "limited" }]);
    let csp = inf.chroma_sample_position;
    if (1..=6).contains(&csp) {
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

const fn h26x_color_prims_str(v: i8) -> &'static str {
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

const fn h26x_trans_char_str(v: i8) -> &'static str {
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

const fn h26x_matrix_coef_str(v: i8) -> &'static str {
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

const fn color_prims_str(v: i8) -> &'static str {
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

const fn trans_char_str(v: i8) -> &'static str {
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

const fn matrix_coef_str(v: i8) -> &'static str {
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

fn parse_svt_param(conf: *mut EbSvtAv1EncConfiguration, name: &str, value: &str) {
    let Ok(n) = CString::new(name) else {
        return;
    };
    let Ok(v) = CString::new(value) else {
        return;
    };
    unsafe { svt_av1_enc_parse_parameter(conf, n.as_ptr(), v.as_ptr()) };
}

fn parse_svt_params(conf: *mut EbSvtAv1EncConfiguration, params: &str) {
    let mut iter = params.split_whitespace();
    while let Some(key) = iter.next() {
        if let Some(name) = key.strip_prefix("--")
            && let Some(val) = iter.next()
        {
            parse_svt_param(conf, name, val);
        }
    }
}

pub fn set_svt_base(
    conf: *mut EbSvtAv1EncConfiguration,
    inf: &VidInf,
    params: &str,
    width: u32,
    height: u32,
) {
    unsafe {
        (*conf).intra_period_length = -1;
        (*conf).source_width = width;
        (*conf).source_height = height;
        (*conf).scene_change_detection = 0;
        (*conf).screen_content_mode = 0;
        (*conf).encoder_bit_depth = 10;
        (*conf).encoder_color_format = 1;
        (*conf).profile = 0;
        (*conf).rate_control_mode = 0;
        (*conf).frame_rate_numerator = inf.fps_num;
        (*conf).frame_rate_denominator = inf.fps_den;
        (*conf).color_primaries = i32::from(inf.color_primaries);
        (*conf).transfer_characteristics = i32::from(inf.transfer_characteristics);
        (*conf).matrix_coefficients = i32::from(inf.matrix_coefficients);
        (*conf).color_range = i32::from(inf.color_range);
        (*conf).chroma_sample_position = i32::from(inf.chroma_sample_position);
        if let Some(m) = inf.mastering {
            let q = |v: f64| ((v * 65536.0).round().min(65535.0) as u16).to_be();
            let cp = |(x, y): (f64, f64)| ChromaPoints { x: q(x), y: q(y) };
            (*conf).mastering_display = MasteringDisplayInfo {
                r: cp(m.r),
                g: cp(m.g),
                b: cp(m.b),
                white_point: cp(m.wp),
                max_luma: ((m.lum_max * 256.0).round() as u32).to_be(),
                min_luma: ((m.lum_min * 16384.0).round() as u32).to_be(),
            };
        }
        if let Some((c, f)) = inf.content_light_level {
            (*conf).content_light_level = ContentLightLevel {
                max_cll: c.to_be(),
                max_fall: f.to_be(),
            };
        }
    }

    parse_svt_params(conf, params);
}

pub fn set_svt_chunk(conf: *mut EbSvtAv1EncConfiguration, cfg: &EncConfig) {
    if let Some(crf) = cfg.crf {
        parse_svt_param(conf, "crf", &format!("{crf:.2}"));
    }
    if let Some(z) = cfg.zone_params {
        parse_svt_params(conf, z);
    }
}

const fn chroma_pos_str(v: i8) -> &'static str {
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
