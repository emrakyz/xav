use crate::{
    error::Xerr,
    paramerr::{
        auto_err, chk_deblock, chk_frange, chk_name, chk_range, chk_switch, err, name_of, off_err,
    },
    util::{C, Y},
};

const NOT_RELEVANT: &[&str] = &[
    "help",
    "fullhelp",
    "version",
    "input",
    "output",
    "y4m",
    "dither",
    "recon",
    "recon-depth",
    "recon-y4m-exec",
    "seek",
    "frame-skip",
    "frames",
    "progress",
    "no-progress",
    "qpfile",
    "zones",
    "zonefile",
    "zonefile-rc-init",
    "nalu-file",
    "csv",
    "csv-log-level",
    "cu-stats",
    "ssim",
    "psnr",
    "ssim-rd",
    "lambda-file",
    "bitrate",
    "pass",
    "stats",
    "slow-firstpass",
    "multi-pass-opt-rps",
    "multi-pass-opt-analysis",
    "multi-pass-opt-distortion",
    "strict-cbr",
    "vbv-maxrate",
    "vbv-bufsize",
    "vbv-init",
    "vbv-end",
    "vbv-end-fr-adj",
    "min-vbv-fullness",
    "max-vbv-fullness",
    "const-vbv",
    "vbv-live-multi-pass",
    "hrd",
    "hrd-concat",
    "frame-rc",
    "sbrc",
    "analysis-save",
    "analysis-load",
    "analysis-reuse-file",
    "analysis-reuse-mode",
    "analysis-reuse-level",
    "analysis-save-reuse-level",
    "analysis-load-reuse-level",
    "refine-intra",
    "refine-inter",
    "refine-mv",
    "refine-analysis-type",
    "refine-ctu-distortion",
    "dynamic-refine",
    "scale-factor",
    "ctu-info",
    "analyze-src-pics",
    "interlace",
    "field",
    "pic-struct",
    "chunk-start",
    "chunk-end",
    "force-flush",
    "alpha",
    "format",
    "num-views",
    "multiview-config",
    "scc",
    "dolby-vision-profile",
    "dolby-vision-rpu",
    "dhdr10-info",
    "dhdr10-opt",
    "frame-dup",
    "dup-threshold",
    "svt",
    "svt-hme",
    "svt-search-width",
    "svt-search-height",
    "svt-compressed-ten-bit-format",
    "svt-speed-control",
    "svt-preset-tuner",
    "svt-hierarchical-level",
    "svt-base-layer-switch-mode",
    "svt-pred-struct",
    "svt-fps-in-vps",
    "pme",
    "pmode",
    "threaded-me",
    "display-window",
    "crop-rect",
    "overscan",
    "videoformat",
    "uhd-bd",
    "level-idc",
    "level",
    "high-tier",
    "allow-non-conformance",
    "log2-max-poc-lsb",
    "atc-sei",
    "idr-recovery-sei",
    "hash",
    "aud",
    "eob",
    "eos",
    "scenecut-aware-qp",
    "masking-strength",
    "scenecut-bias",
    "hist-scenecut",
    "fades",
    "radl",
    "intra-refresh",
    "temporal-layers",
    "opt-cu-delta-qp",
    "max-ausize-factor",
    "single-sei",
    "lft",
];

const AUTO_SET: &[&str] = &[
    "log-level",
    "log",
    "gop-lookahead",
    "rc-lookahead",
    "keyint",
    "min-keyint",
    "scenecut",
    "lookahead-slices",
    "lookahead-threads",
    "frame-threads",
    "slices",
    "pools",
    "numa-pools",
    "wpp",
    "ctu",
    "min-cu-size",
    "opt-qp-pps",
    "opt-ref-list-length-pps",
    "info",
    "vui-hrd-info",
    "vui-timing-info",
    "input-res",
    "fps",
    "sar",
    "total-frames",
    "input-csp",
    "input-depth",
    "output-depth",
    "profile",
    "annexb",
    "repeat-headers",
    "asm",
    "colorprim",
    "transfer",
    "colormatrix",
    "range",
    "chromaloc",
    "master-display",
    "max-cll",
    "cll",
    "hdr10",
    "hdr",
    "video-signal-type-preset",
];

const PRESETS: &[&str] = &[
    "ultrafast",
    "superfast",
    "veryfast",
    "faster",
    "fast",
    "medium",
    "slow",
    "slower",
    "veryslow",
    "placebo",
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
];

const TUNES: &[&str] = &["psnr", "ssim", "grain", "fastdecode", "animation"];

const ME_NAMES: &[&str] = &[
    "dia", "hex", "umh", "star", "sea", "full", "0", "1", "2", "3", "4", "5",
];

#[cold]
#[inline(never)]
fn reject_msg(name: &str, key: &str) -> Option<Xerr> {
    if NOT_RELEVANT.contains(&name) {
        return Some(off_err(key));
    }
    if AUTO_SET.contains(&name) {
        return Some(auto_err(key));
    }
    Some(match name {
        "qp" => err(
            key,
            format_args!("{Y}Use x264 for lossless; xav only uses CRF for everything"),
        ),
        "open-gop" => err(
            key,
            format_args!("{Y}Self contained chunks. Starts on IDR. open-gop not relevant"),
        ),
        "cra-nal" => err(key, format_args!("{Y}xav writes IDR keyframes only")),
        "b-pyramid" => err(
            key,
            format_args!(
                "{Y}The b-pyramid reference structure makes random access efficient;\nxav encodes \
                 offline only, there is none to gain by turning it off and it helps for internal \
                 truths to fix it"
            ),
        ),
        "copy-pic" => err(
            key,
            format_args!("{Y}part of a future integration; skipped for now"),
        ),
        "lowpass-dct" => err(
            key,
            format_args!(
                "{Y}The lowpass DCT swaps the process wide transform table; cannot differ \
                 between\nzones or workers & trades quality for decode speed"
            ),
        ),
        "lossless" | "cu-lossless" => err(
            key,
            format_args!("{Y}xav only encodes lossy; x264 for lossless"),
        ),
        "scaling-list" => err(
            key,
            format_args!(
                "{Y}Scaling list overrides the quantisation matrix for every chunk; cannot be \
                 reproduced from the output"
            ),
        ),
        _ => return None,
    })
}

fn chk_set<const N: usize>(key: &str, name: &str, val: &str, set: &[i64; N]) -> Result<(), Xerr> {
    let (lo, hi) = (set[0], set[N - 1]);
    if set.contains(&chk_range(key, name, val, lo, hi)?) {
        return Ok(());
    }
    Err(err(
        key,
        format_args!("{Y}{name} must be one of {C}{lo} {Y}.. {C}{hi} {Y}in powers of two"),
    ))
}

fn check_param(name: &str, key: &str, val: &str) -> Result<(), Xerr> {
    match name {
        "preset" => chk_name(
            key,
            name,
            val,
            PRESETS,
            "ultrafast superfast veryfast faster fast medium slow slower veryslow placebo, or 0-9",
        )?,
        "tune" => chk_name(
            key,
            name,
            val,
            TUNES,
            "psnr ssim grain fastdecode animation (zerolatency disables the lookahead xav relies \
             on)",
        )?,
        "me" => chk_name(
            key,
            name,
            val,
            ME_NAMES,
            "dia hex umh star sea full, or 0-5",
        )?,
        "deblock" => chk_deblock(key, val)?,

        "crf" | "crf-max" | "crf-min" => {
            chk_frange(key, name, val, 0.0, 51.0)?;
        }
        "qpmin" | "qpmax" => {
            chk_range(key, name, val, 0, 69)?;
        }
        "max-tu-size" => chk_set(key, name, val, &[4, 8, 16, 32])?,
        "qg-size" => chk_set(key, name, val, &[8, 16, 32, 64])?,
        "tu-intra-depth" | "tu-inter-depth" => {
            chk_range(key, name, val, 1, 4)?;
        }
        "limit-tu" | "aq-mode" | "selective-sao" => {
            chk_range(key, name, val, 0, 4)?;
        }
        "subme" => {
            chk_range(key, name, val, 0, 7)?;
        }
        "merange" => {
            chk_range(key, name, val, 0, 0x7FFF)?;
        }
        "max-merge" => {
            chk_range(key, name, val, 1, 5)?;
        }
        "ref" => {
            chk_range(key, name, val, 1, 16)?;
        }
        "limit-refs" => {
            chk_range(key, name, val, 0, 3)?;
        }
        "rd" => {
            chk_range(key, name, val, 1, 6)?;
        }
        "rdoq-level" | "rdoq" | "rskip" | "rdpenalty" | "b-adapt" => {
            chk_range(key, name, val, 0, 2)?;
        }
        "rskip-edge-threshold" => {
            chk_range(key, name, val, 0, 100)?;
        }
        "dynamic-rd" => {
            chk_frange(key, name, val, 0.0, 4.0)?;
        }
        "psy-rd" => {
            chk_frange(key, name, val, 0.0, 5.0)?;
        }
        "psy-rdoq" => {
            chk_frange(key, name, val, 0.0, 50.0)?;
        }
        "aq-strength" => {
            chk_frange(key, name, val, 0.0, 3.0)?;
        }
        "qp-adaptation-range" => {
            chk_frange(key, name, val, 1.0, 6.0)?;
        }
        "qcomp" => {
            chk_frange(key, name, val, 0.5, 1.0)?;
        }
        "qpstep" => {
            chk_range(key, name, val, 0, 51)?;
        }
        "cplxblur" | "qblur" => {
            chk_frange(key, name, val, 0.0, 999.0)?;
        }
        "ipratio" | "ip-factor" | "pbratio" | "pb-factor" => {
            chk_frange(key, name, val, 1.0, 10.0)?;
        }
        "cbqpoffs" | "crqpoffs" => {
            chk_range(key, name, val, -12, 12)?;
        }
        "bframes" => {
            chk_range(key, name, val, 0, 16)?;
        }
        "bframe-bias" => {
            chk_range(key, name, val, -90, 100)?;
        }
        "nr-intra" | "nr-inter" => {
            chk_range(key, name, val, 0, 2000)?;
        }
        "min-luma" | "max-luma" => {
            chk_range(key, name, val, 0, 1023)?;
        }
        "hme-range" | "hme-search" => {}

        "rect"
        | "amp"
        | "temporal-mvp"
        | "early-skip"
        | "tskip"
        | "tskip-fast"
        | "strong-intra-smoothing"
        | "constrained-intra"
        | "cip"
        | "fast-intra"
        | "limit-modes"
        | "weightp"
        | "weightb"
        | "rd-refine"
        | "signhide"
        | "b-intra"
        | "sao"
        | "sao-non-deblock"
        | "limit-sao"
        | "cutree"
        | "rc-grain"
        | "hevc-aq"
        | "aq-motion"
        | "splitrd-skip"
        | "hdr10-opt"
        | "hdr-opt"
        | "mcstf"
        | "hme" => {
            chk_switch(key, name, val)?;
        }

        _ => {
            return Err(err(key, format_args!("{Y}unknown or wrong parameter")));
        }
    }
    Ok(())
}

pub fn val(params: &str) -> Result<(), Xerr> {
    let mut iter = params.split_whitespace();

    while let Some(key) = iter.next() {
        let name = name_of(key)?;

        if let Some(e) = reject_msg(name, key) {
            return Err(e);
        }

        let Some(val) = iter.next() else {
            return Err(err(key, format_args!("{Y}missing value")));
        };

        check_param(name, key, val)?;
    }

    Ok(())
}
