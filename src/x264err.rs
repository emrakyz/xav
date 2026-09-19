use crate::{
    error::Xerr,
    paramerr::{
        auto_err, chk_deblock, chk_frange, chk_name, chk_range, chk_switch, err, name_of, off_err,
    },
    util::{C, Y},
};

const NOT_RELEVANT: &[&str] = &[
    "profile",
    "bitrate",
    "pass",
    "stats",
    "ratetol",
    "vbv-maxrate",
    "vbv-bufsize",
    "vbv-init",
    "filler",
    "crf-max",
    "interlaced",
    "tff",
    "bff",
    "fake-interlaced",
    "pic-struct",
    "bluray-compat",
    "avcintra-class",
    "avcintra-flavor",
    "stitchable",
    "opencl",
    "opencl-clbin",
    "opencl-device",
    "psnr",
    "ssim",
    "log",
    "dump-yuv",
    "zones",
    "crop-rect",
    "overscan",
    "videoformat",
    "level",
    "level-idc",
    "slices",
    "slices-max",
    "slice-max-size",
    "slice-max-mbs",
    "slice-min-mbs",
    "sliced-threads",
    "frame-packing",
    "cqmfile",
    "alternative-transfer",
    "sps-id",
    "global-header",
    "aud",
    "intra-refresh",
    "mvrange-thread",
    "mv-range-thread",
];

const AUTO_SET: &[&str] = &[
    "keyint",
    "min-keyint",
    "keyint-min",
    "scenecut",
    "bframes",
    "b-adapt",
    "rc-lookahead",
    "threads",
    "lookahead-threads",
    "sync-lookahead",
    "deterministic",
    "n-deterministic",
    "force-cfr",
    "nal-hrd",
    "fps",
    "sar",
    "annexb",
    "repeat-headers",
    "asm",
    "colorprim",
    "transfer",
    "colormatrix",
    "fullrange",
    "chromaloc",
    "mastering-display",
    "cll",
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
];

const TUNES: &[&str] = &[
    "film",
    "animation",
    "grain",
    "stillimage",
    "psnr",
    "ssim",
    "fastdecode",
];

const ME_NAMES: &[&str] = &["dia", "hex", "umh", "esa", "tesa"];

const DIRECT_NAMES: &[&str] = &["none", "spatial", "temporal", "auto"];

const CQM_NAMES: &[&str] = &["flat", "jvt"];

// 51 + 6 * (10 - 8)
const QP_MAX_SPEC: i64 = 63;

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
        "cpu-independent" => err(
            key,
            format_args!(
                "{Y}xav wants the highest simd the build target has; this forces the canonical \
                 (slower) kernels"
            ),
        ),
        "open-gop" => err(
            key,
            format_args!(
                "{Y}Self contained chunks. Single IDR start; rest inter-frames; open-gop not \
                 relevant"
            ),
        ),
        "b-pyramid" => err(
            key,
            format_args!(
                "{Y}The b-pyramid reference structure makes random access efficient;\nxav encodes \
                 offline only, there is none to gain by turning it off and it helps for internal \
                 truths to fix it"
            ),
        ),
        _ => return None,
    })
}

fn chk_pair(key: &str, name: &str, val: &str, lo: f32, hi: f32) -> Result<(), Xerr> {
    let mut n = 0;
    for v in val.split([':', ',']) {
        n += 1;
        match v.parse::<f32>() {
            Ok(o) if n <= 2 && o >= lo && o <= hi => {}
            _ => {
                return Err(err(
                    key,
                    format_args!("{Y}{name} takes one or two values from {C}{lo} {Y}to {C}{hi}"),
                ));
            }
        }
    }
    Ok(())
}

fn check_param(name: &str, key: &str, val: &str) -> Result<(), Xerr> {
    match name {
        "preset" => chk_name(
            key,
            name,
            val,
            PRESETS,
            "ultrafast superfast veryfast faster fast medium slow slower veryslow placebo",
        )?,
        "tune" => chk_name(
            key,
            name,
            val,
            TUNES,
            "film animation grain stillimage psnr ssim fastdecode (zerolatency disables the \
             lookahead xav relies on)",
        )?,
        "me" => chk_name(key, name, val, ME_NAMES, "dia hex umh esa tesa")?,
        "direct" | "direct-pred" => {
            chk_name(key, name, val, DIRECT_NAMES, "none spatial temporal auto")?;
        }
        "cqm" => chk_name(key, name, val, CQM_NAMES, "flat jvt")?,
        "deblock" | "filter" | "nf" => chk_deblock(key, val)?,
        "psy-rd" => chk_pair(key, name, val, 0.0, 10.0)?,

        "qp" | "qp_constant" => {
            if val != "0" {
                return Err(err(
                    key,
                    format_args!("{Y}qp is lossless only: {C}--qp 0{Y}; lossy is {C}--crf"),
                ));
            }
        }
        "crf" => chk_frange(key, name, val, 0.0, 51.0)?,
        "qpmin" | "qp-min" | "qpmax" | "qp-max" | "qpstep" | "qp-step" => {
            chk_range(key, name, val, 0, QP_MAX_SPEC)?;
        }
        "ref" | "frameref" | "dpb-size" => {
            chk_range(key, name, val, 1, 16)?;
        }
        "subme" | "subq" => {
            chk_range(key, name, val, 0, 11)?;
        }
        "merange" | "me-range" => {
            chk_range(key, name, val, 4, 1024)?;
        }
        "mvrange" | "mv-range" => {
            chk_range(key, name, val, -1, 0x8000)?;
        }
        "trellis" | "weightp" => {
            chk_range(key, name, val, 0, 2)?;
        }
        "aq-mode" => {
            chk_range(key, name, val, 0, 3)?;
        }
        "cabac-idc" => {
            chk_range(key, name, val, -1, 2)?;
        }
        "chroma-qp-offset" => {
            chk_range(key, name, val, -12, 12)?;
        }
        "b-bias" => {
            chk_range(key, name, val, -100, 100)?;
        }
        "nr" => {
            chk_range(key, name, val, 0, 100_000)?;
        }
        "deadzone-inter" | "deadzone-intra" => {
            chk_range(key, name, val, 0, 32)?;
        }
        "aq-strength" => chk_frange(key, name, val, 0.0, 3.0)?,
        "qcomp" => chk_frange(key, name, val, 0.0, 1.0)?,
        "qblur" | "cplxblur" | "cplx-blur" => chk_frange(key, name, val, 0.0, 999.0)?,
        "ipratio" | "ip-factor" | "pbratio" | "pb-factor" => {
            chk_frange(key, name, val, 0.0, 10.0)?;
        }

        "8x8dct" | "cabac" | "mbtree" | "mixed-refs" | "fast-pskip" | "dct-decimate"
        | "chroma-me" | "psy" | "weightb" | "weight-b" | "constrained-intra" => {
            chk_switch(key, name, val)?;
        }

        _ => {}
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
