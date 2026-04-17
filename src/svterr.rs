use std::fmt::Arguments;

use crate::{
    error::Xerr,
    util::{C, N, R, W, Y},
};

#[cold]
#[inline(never)]
fn err(key: &str, msg: Arguments<'_>) -> Xerr {
    format!("{R}{key} {msg}{N}").into()
}

#[cold]
#[inline(never)]
fn chk_range(key: &str, name: &str, val: &str, lo: i64, hi: i64) -> Result<i64, Xerr> {
    match val.parse::<i64>() {
        Ok(v) if v >= lo && v <= hi => Ok(v),
        Ok(_) => Err(err(
            key,
            format_args!("{Y}{name} must be between {C}{lo} {Y}and {C}{hi}"),
        )),
        Err(_) => Err(err(key, format_args!("{Y}{val} {W}is not a valid integer"))),
    }
}

#[cold]
#[inline(never)]
fn chk_switch(key: &str, name: &str, val: &str) -> Result<i64, Xerr> {
    match val.parse::<i64>() {
        Ok(v @ (0 | 1)) => Ok(v),
        Ok(_) => Err(err(
            key,
            format_args!("{Y}{name} is an on off switch. It should be {C}0 {Y}or {C}1"),
        )),
        Err(_) => Err(err(key, format_args!("{Y}{val} {W}is not a valid integer"))),
    }
}

#[cold]
#[inline(never)]
fn chk_custom(key: &str, val: &str, lo: i64, hi: i64, msg: Arguments<'_>) -> Result<i64, Xerr> {
    match val.parse::<i64>() {
        Ok(v) if v >= lo && v <= hi => Ok(v),
        Ok(_) => Err(err(key, msg)),
        Err(_) => Err(err(key, format_args!("{Y}{val} {W}is not a valid integer"))),
    }
}

#[cold]
#[inline(never)]
fn chk_frange(key: &str, name: &str, val: &str, lo: f64, hi: f64) -> Result<(), Xerr> {
    match val.parse::<f64>() {
        Ok(v) if v >= lo && v <= hi => Ok(()),
        Ok(_) => Err(err(
            key,
            format_args!("{Y}{name} must be between {C}{lo} {Y}and {C}{hi}"),
        )),
        Err(_) => Err(err(key, format_args!("{Y}{val} {W}is not a valid number"))),
    }
}

const NOT_RELEVANT: &[&str] = &[
    "help",
    "color-help",
    "version",
    "config",
    "c",
    "errlog",
    "recon",
    "r",
    "stat-file",
    "progress",
    "no-progress",
    "svtav1-params",
    "allow-mmap-file",
    "inj",
    "inj-frm-rt",
    "enable-stat-report",
    "asm",
    "qpfile",
    "max-qp",
    "min-qp",
    "use-fixed-qindex-offsets",
    "key-frame-qindex-offset",
    "key-frame-chroma-qindex-offset",
    "qindex-offsets",
    "chroma-qindex-offsets",
    "luma-y-dc-qindex-offset",
    "chroma-u-dc-qindex-offset",
    "chroma-u-ac-qindex-offset",
    "chroma-v-dc-qindex-offset",
    "chroma-v-ac-qindex-offset",
    "lambda-scale-factors",
    "undershoot-pct",
    "overshoot-pct",
    "gop-constraint-rc",
    "buf-sz",
    "buf-initial-sz",
    "buf-optimal-sz",
    "recode-loop",
    "minsection-pct",
    "maxsection-pct",
    "roi-map-file",
    "irefresh-type",
    "startup-qp-offset",
    "superres-mode",
    "superres-denom",
    "superres-kf-denom",
    "superres-qthres",
    "superres-kf-qthres",
    "sframe-dist",
    "sframe-mode",
    "sframe-posi",
    "sframe-qp",
    "sframe-qp-offset",
    "resize-mode",
    "resize-denom",
    "resize-kf-denom",
    "frame-resz-events",
    "frame-resz-kf-denoms",
    "frame-resz-denoms",
    "lossless",
    "avif",
    "zones",
    "quality",
    "speed",
    "auto-tiling",
    "low-memory",
    "fgs-table",
    "enable-mfmv",
];

const AUTO_SET: &[&str] = &[
    "width",
    "w",
    "height",
    "h",
    "forced-max-frame-width",
    "forced-max-frame-height",
    "skip",
    "n",
    "nb",
    "color-format",
    "profile",
    "level",
    "fps-num",
    "fps-denom",
    "rc",
    "input",
    "i",
    "output",
    "b",
];

fn reject_msg(name: &str, key: &str) -> Option<Xerr> {
    if NOT_RELEVANT.contains(&name) {
        return Some(err(
            key,
            format_args!(
                "{Y}The parameter {R}{key} {Y}is not relevant with xav and should not be set"
            ),
        ));
    }
    if AUTO_SET.contains(&name) {
        return Some(err(
            key,
            format_args!(
                "{Y}The parameter {R}{key} {Y}is used by xav automatically, you should never set \
                 it."
            ),
        ));
    }
    Some(match name {
        "input-depth" => err(
            key,
            format_args!(
                "{Y}xav only encodes in 10bit (yuv420p10le), and preferably with high-bit-depth \
                 mode decisions as it's objectively superior This parameter should not be set"
            ),
        ),
        "qp" | "q" => err(
            key,
            format_args!("{Y}xav does not use q|qp mode. CRF mode is used. It should not be set"),
        ),
        "tbr" => err(
            key,
            format_args!(
                "{Y}Target bitrate can not be used with CRF mode and should not be set\nxav only \
                 encodes in CRF"
            ),
        ),
        "aq-mode" => err(
            key,
            format_args!("{Y}aq-mode should not be changed as aq-mode 2 is objectively superior"),
        ),
        "pred-struct" => err(
            key,
            format_args!("{Y}pred-struct should not be changed as 2 is objectively superior"),
        ),
        "pass" | "passes" | "stats" => err(
            key,
            format_args!(
                "{Y}2 pass is not relevant for svt-av1 CRF encoding. This should not be set"
            ),
        ),
        "keyint" | "force-key-frames" => err(
            key,
            format_args!(
                "{Y}This parameter is set by xav automatically. You should not change it.\nWith \
                 chunked encoding, the optimal is to have keyframes at scene changes,\nmeaning \
                 each chunk's starting frame will be a keyframe. This should not be set."
            ),
        ),
        "scd" => err(
            key,
            format_args!(
                "{Y}xav already does scene change detection, you should not set this encoder \
                 parameter"
            ),
        ),
        "lookahead" => err(
            key,
            format_args!(
                "{Y}svt-av1 locks its lookahead mechanism internally, this parameter does not do \
                 anything\nremove it for safety"
            ),
        ),
        "rtc" => err(
            key,
            format_args!("{Y}Real time modes are not relevant with xav"),
        ),
        "enable-overlays" => err(
            key,
            format_args!("{Y}Overlay frames are always dangerous and not beneficial with svt-av1"),
        ),
        "film-grain-denoise" => err(
            key,
            format_args!(
                "{Y}film-grain-denoise should not be set as it is severely detrimental.\nUse \
                 external denoising if needed; or encoder options that don't\nprioritize sharpness"
            ),
        ),
        _ => return None,
    })
}

#[allow(clippy::too_many_lines)]
fn check_param(name: &str, key: &str, val: &str) -> Result<(), Xerr> {
    match name {
        "preset" => {
            chk_custom(
                key,
                val,
                0,
                7,
                format_args!(
                    "{Y}--preset should be between {C}0 {Y}and {C}7\n{Y}presets 8+ are intended \
                     for real-time usage and inconsistent\npresets below 0 are intended for \
                     debugging purposes"
                ),
            )?;
        }

        "lp" => {
            chk_custom(
                key,
                val,
                1,
                6,
                format_args!(
                    "{Y}lp must be between 1 and 6 and it is the level of parallelism (it is not \
                     the number of cores/threads used). It adapts the per-worker CPU usage based \
                     on the input video and your CPU\n{Y}For less workers, higher values are \
                     recommended\nFor many workers, lower values are recommended\nIt is always \
                     advised to test {C}3{Y}/{C}4{Y}/{C}5 {Y}first"
                ),
            )?;
        }

        "crf" => match val.parse::<f64>() {
            Ok(v) if (0.0..=70.0).contains(&v) => {}
            Ok(_) => {
                return Err(err(
                    key,
                    format_args!(
                        "{Y}Valid CRF levels are between {C}0 {Y}and {C}70\n{Y}Lower CRF is \
                         higher quality and higher bitrate"
                    ),
                ));
            }
            Err(_) => {
                return Err(err(key, format_args!("{Y}{val} {W}is not a valid number")));
            }
        },

        "mbr" => {
            chk_custom(
                key,
                val,
                1,
                100_000,
                format_args!("{Y}Maximum bitrate can be between {C}1 {Y}and {C}100000 {Y}kbps"),
            )?;
        }

        "enable-qm"
        | "enable-cdef"
        | "enable-restoration"
        | "enable-dg"
        | "enable-variance-boost"
        | "adaptive-film-grain"
        | "alt-lambda-factors"
        | "noise-chroma-from-luma"
        | "sharp-tx" => {
            chk_switch(key, name, val)?;
        }

        "fast-decode" | "hbd-mds" => {
            chk_range(key, name, val, 0, 2)?;
        }

        "enable-dlf"
        | "enable-tf"
        | "scm"
        | "variance-boost-curve"
        | "enable-alt-cdef"
        | "enable-alt-dlf"
        | "tx-bias" => {
            chk_range(key, name, val, 0, 3)?;
        }

        "tf-strength"
        | "noise-norm-strength"
        | "kf-tf-strength"
        | "noise-adaptive-filtering"
        | "distortion-bias-preset" => {
            chk_range(key, name, val, 0, 4)?;
        }

        "tile-rows" | "tile-columns" => {
            chk_range(key, name, val, 0, 6)?;
        }

        "sharpness" => {
            chk_range(key, name, val, 0, 7)?;
        }

        "film-grain" => {
            chk_range(key, name, val, 0, 50)?;
        }

        "mbr-overshoot-pct" | "luminance-qp-bias" => {
            chk_range(key, name, val, 0, 100)?;
        }

        "noise" => {
            chk_range(key, name, val, 0, 200)?;
        }

        "noise-chroma" => {
            chk_range(key, name, val, -1, 200)?;
        }

        "noise-size" => {
            chk_range(key, name, val, -1, 13)?;
        }

        "complex-hvs" => {
            chk_range(key, name, val, 0, 1)?;
        }

        "variance-boost-strength" => {
            chk_range(key, name, val, 1, 4)?;
        }

        "variance-octile" => {
            chk_range(key, name, val, 1, 8)?;
        }

        "cdef-scaling" => {
            chk_range(key, name, val, 1, 30)?;
        }

        "max-tx-size" => {
            let v = val
                .parse::<i64>()
                .map_err(|_e| err(key, format_args!("{Y}{val} {W}is not a valid integer")))?;
            if v != 32 && v != 64 {
                return Err(err(
                    key,
                    format_args!("{Y}max-tx-size should either be {C}32 {Y}or {C}64"),
                ));
            }
        }

        "qp-scale-compress-strength" | "ac-bias" => {
            chk_frange(key, name, val, 0.0, 8.0)?;
        }

        "color-primaries"
        | "transfer-characteristics"
        | "matrix-coefficients"
        | "color-range"
        | "chroma-sample-position"
        | "mastering-display"
        | "content-light" => {}

        _ => {
            return Err(err(key, format_args!("{Y}unknown or wrong parameter")));
        }
    }
    Ok(())
}

pub fn validate(params: &str) -> Result<(), Xerr> {
    let mut hl: i64 = 5;
    let mut smgs: Option<(i64, &str)> = None;
    let mut tune: Option<i64> = None;
    let mut ast: Option<&str> = None;
    let mut qm: [Option<(i64, &str)>; 2] = [None; 2];
    let mut cqm: [Option<(i64, &str)>; 2] = [None; 2];
    let mut iter = params.split_whitespace();

    while let Some(key) = iter.next() {
        let name = if let Some(n) = key.strip_prefix("--") {
            n
        } else if let Some(n) = key.strip_prefix('-') {
            n
        } else {
            return Err(err(key, format_args!("{Y}unknown or wrong parameter")));
        };

        if let Some(e) = reject_msg(name, key) {
            return Err(e);
        }

        let Some(val) = iter.next() else {
            return Err(err(key, format_args!("{Y}missing value")));
        };

        match name {
            "hierarchical-levels" => {
                hl = chk_range(key, name, val, 2, 5)?;
            }
            "startup-mg-size" => {
                let v = val
                    .parse::<i64>()
                    .map_err(|_e| err(key, format_args!("{Y}{val} {W}is not a valid integer")))?;
                if !matches!(v, 0 | 2 | 3 | 4) {
                    return Err(err(
                        key,
                        format_args!(
                            "{Y}startup-mg-size can only be set to {C}0{Y}, {C}2{Y}, {C}3{Y}, or \
                             {C}4"
                        ),
                    ));
                }
                smgs = Some((v, key));
            }
            "tune" => {
                tune = Some(chk_range(key, name, val, 0, 5)?);
            }
            "alt-ssim-tuning" => {
                chk_switch(key, name, val)?;
                ast = Some(key);
            }
            "qm-min" => {
                qm[0] = Some((chk_range(key, name, val, 0, 15)?, key));
            }
            "qm-max" => {
                qm[1] = Some((chk_range(key, name, val, 0, 15)?, key));
            }
            "chroma-qm-min" => {
                cqm[0] = Some((chk_range(key, name, val, 0, 15)?, key));
            }
            "chroma-qm-max" => {
                cqm[1] = Some((chk_range(key, name, val, 0, 15)?, key));
            }
            _ => check_param(name, key, val)?,
        }
    }

    if let Some((v, key)) = smgs
        && v >= hl
    {
        return Err(err(
            key,
            format_args!("{Y}startup-mg-size must be lower than hierarchical-levels"),
        ));
    }

    if let Some(key) = ast
        && !matches!(tune, Some(2))
    {
        return Err(err(
            key,
            format_args!("{Y}alt-ssim-tuning is only relevant with {C}--tune 2"),
        ));
    }

    if let Some((lo, _)) = qm[0]
        && let Some((hi, key)) = qm[1]
        && lo > hi
    {
        return Err(err(
            key,
            format_args!("{Y}qm-max ({C}{hi}{Y}) must be >= qm-min ({C}{lo}{Y})"),
        ));
    }

    if let Some((lo, _)) = cqm[0]
        && let Some((hi, key)) = cqm[1]
        && lo > hi
    {
        return Err(err(
            key,
            format_args!("{Y}chroma-qm-max ({C}{hi}{Y}) must be >= chroma-qm-min ({C}{lo}{Y})"),
        ));
    }

    Ok(())
}
