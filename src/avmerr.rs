use crate::{
    error::Xerr,
    paramerr::{auto_err, chk_custom, chk_range, chk_switch, err, name_of, off_err},
    util::{C, Y},
};

const NOT_RELEVANT: &[&str] = &[
    "help",
    "debug",
    "verbose",
    "codec",
    "cfg",
    "usage",
    "ivf",
    "webm",
    "raw",
    "recon",
    "skip",
    "limit",
    "step",
    "test-decode",
    "rate-hist",
    "force-video-mode",
    "disable-warnings",
    "disable-warning-prompt",
    "frame-hash",
    "use-per-plane-frame-hash",
    "global-error-resilient",
    "full-still-picture-hdr",
    "monochrome",
    "drop-frame",
    "resize-mode",
    "resize-denominator",
    "resize-kf-denominator",
    "target-bitrate",
    "max-intra-rate",
    "max-inter-rate",
    "undershoot-pct",
    "overshoot-pct",
    "buf-sz",
    "buf-initial-sz",
    "buf-optimal-sz",
    "minsection-pct",
    "maxsection-pct",
    "passes",
    "pass",
    "fpf",
    "frame-boost",
    "gf-cbr-boost",
    "vbr-corpus-complexity-lap",
    "enable-sframe",
    "sframe-dist",
    "sframe-mode",
    "sframe-type",
    "enable-atlas",
    "enable-operating-point-sets",
    "num-operating-point-sets",
    "operating-points-count",
    "film-grain-table",
    "film-grain-test",
    "film-grain-block-size",
    "denoise-noise-level",
    "denoise-block-size",
    "tune",
    "vmaf-model-path",
    "frame-parallel",
    "row-mt",
    "tile-columns",
    "tile-rows",
    "tile-width",
    "tile-height",
    "num-tile-groups",
    "mtu-size",
    "disable-loopfilters-across-tiles",
    "sb-multipass-unit-test",
    "motion-vector-unit-test",
    "multi-seq-header-test",
    "frame-multi-qmatrix-unit-test",
    "sef-with-order-hint-test",
    "film-grain-test-vector",
    "subgop-config-path",
    "subgop-config-str",
    "target-seq-level-idx",
    "set-tier-mask",
    "timing-info",
    "scan-type-info",
    "stereo-mode",
    "enable-cropping-window",
    "crop-win-left-offset",
    "crop-win-right-offset",
    "crop-win-top-offset",
    "crop-win-bottom-offset",
];

const AUTO_SET: &[&str] = &[
    "threads",
    "width",
    "height",
    "forced_max_frame_width",
    "forced_max_frame_height",
    "bit-depth",
    "input-bit-depth",
    "input-chroma-subsampling-x",
    "input-chroma-subsampling-y",
    "timebase",
    "fps",
    "end-usage",
    "min-qp",
    "max-qp",
    "min-q",
    "max-q",
    "disable-kf",
    "enable-fwd-kf",
    "kf-min-dist",
    "kf-max-dist",
    "color-primaries",
    "transfer-characteristics",
    "matrix-coefficients",
    "chroma-sample-position",
    "color-range",
    "lag-in-frames",
    "use-fixed-qp-offsets",
    "fixed-qp-offsets",
];

const U32_MAX: i64 = 0xFFFF_FFFF;

fn reject_msg(name: &str, key: &str) -> Option<Xerr> {
    if NOT_RELEVANT.contains(&name) {
        return Some(off_err(key));
    }
    if AUTO_SET.contains(&name) {
        return Some(auto_err(key));
    }
    Some(match name {
        "profile" => err(
            key,
            format_args!("{Y}xav encodes 10-bit 4:2:0, which fixes the profile"),
        ),
        "cq-level" => err(
            key,
            format_args!("{Y}cq-level is an aomenc name. Use {C}--qp {Y}instead"),
        ),
        "lossless" => err(
            key,
            format_args!(
                "{Y}xav only encodes lossy CRF. Lossless also forbids aq-mode and \
                 enable-chroma-deltaq"
            ),
        ),
        "enable-overlay" => err(
            key,
            format_args!("{Y}Overlay frames are always dangerous and not beneficial"),
        ),
        "aq-mode" => err(
            key,
            format_args!(
                "{Y}aq-mode is the legacy segment based AQ. Any nonzero value makes AV2 skip \
                 the\nTPL path outright, so it must stay at {C}0{Y}. AV2 adapts through delta q"
            ),
        ),
        _ => return None,
    })
}

fn chk_block(key: &str, name: &str, val: &str) -> Result<i64, Xerr> {
    let v = chk_range(key, name, val, 4, 256)?;
    if v & (v - 1) == 0 {
        return Ok(v);
    }
    Err(err(key, format_args!("{Y}{name} must be a power of two")))
}

fn chk_drl(key: &str, name: &str, val: &str, hi: i64) -> Result<(), Xerr> {
    let v = chk_range(key, name, val, 0, hi)?;
    if v != 1 {
        return Ok(());
    }
    Err(err(
        key,
        format_args!("{Y}{name} must be {C}0 {Y}(auto) or between {C}2 {Y}and {C}{hi}"),
    ))
}

fn chk_gf(key: &str, name: &str, val: &str) -> Result<i64, Xerr> {
    let v = chk_range(key, name, val, 0, 34)?;
    if v == 0 || v >= 4 {
        return Ok(v);
    }
    Err(err(
        key,
        format_args!("{Y}{name} must be {C}0 {Y}(auto) or between {C}4 {Y}and {C}34"),
    ))
}

fn check_param(name: &str, key: &str, val: &str) -> Result<(), Xerr> {
    match name {
        "tune-content" => {
            if !matches!(val, "default" | "screen") {
                return Err(err(
                    key,
                    format_args!("{Y}tune-content must be {C}default {Y}or {C}screen"),
                ));
            }
        }

        "sb-size" => {
            if !matches!(val, "dynamic" | "64" | "128" | "256") {
                return Err(err(
                    key,
                    format_args!("{Y}sb-size must be {C}dynamic{Y}, {C}64{Y}, {C}128 {Y}or {C}256"),
                ));
            }
        }

        "max-pb-aspect-ratio" => {
            if !matches!(val, "2" | "4" | "8") {
                return Err(err(
                    key,
                    format_args!("{Y}max-pb-aspect-ratio must be {C}2{Y}, {C}4 {Y}or {C}8"),
                ));
            }
        }

        "auto-alt-ref"
        | "add-sef-for-output"
        | "avg-cdf-type"
        | "ccso-unit-matches-sb"
        | "cross-frame-cdf-init-mode"
        | "enable-adaptive-mvd"
        | "enable-angle-delta"
        | "enable-avg-cdf"
        | "enable-banding-metadata"
        | "enable-bawp"
        | "enable-ccso"
        | "enable-cctx"
        | "enable-cdef"
        | "enable-cfl-intra"
        | "enable-chroma-dctonly"
        | "enable-chroma-deltaq"
        | "enable-cwp"
        | "enable-deblocking"
        | "enable-diff-wtd-comp"
        | "enable-ext-partitions"
        | "enable-ext-seg"
        | "enable-extended-sdp"
        | "enable-flex-mvres"
        | "enable-flip-idtx"
        | "enable-fsc"
        | "enable-gdf"
        | "enable-global-motion"
        | "enable-high-motion"
        | "enable-ibp"
        | "enable-idtx-intra"
        | "enable-imp-msk-bld"
        | "enable-inter-ddt"
        | "enable-inter-ist"
        | "enable-interinter-wedge"
        | "enable-interintra-comp"
        | "enable-interintra-wedge"
        | "enable-intra-dip"
        | "enable-intra-edge-filter"
        | "enable-intrabc"
        | "enable-ist"
        | "enable-joint-mvd"
        | "enable-lcr"
        | "enable-lf-sub-pu"
        | "enable-masked-comp"
        | "enable-mfh-obu-signaling"
        | "enable-mhccp"
        | "enable-mrls"
        | "enable-mv-traj"
        | "enable-mvd-sign-derive"
        | "enable-onesided-comp"
        | "enable-paeth-intra"
        | "enable-palette"
        | "enable-parity-hiding"
        | "enable-pc-wiener"
        | "enable-qm"
        | "enable-rect-partitions"
        | "enable-ref-frame-mvs"
        | "enable-refinemv"
        | "enable-refmvbank"
        | "enable-restoration"
        | "enable-short-refresh-frame-flags"
        | "enable-six-param-warp-delta"
        | "enable-skip-mode"
        | "enable-smooth-interintra"
        | "enable-smooth-intra"
        | "enable-tip-refinemv"
        | "enable-tpl-model"
        | "enable-tx-partition"
        | "enable-uneven-4way-partitions"
        | "enable-warp-causal"
        | "enable-warp-delta"
        | "enable-warp-extend"
        | "enable-warped-motion"
        | "enable-wiener-nonsep"
        | "explicit-ref-frame-map"
        | "gdf-unit-matches-sb"
        | "quant-b-adapt"
        | "reduced-ref-frame-mvs-mode"
        | "reduced-reference-set"
        | "reduced-tx-part-set"
        | "disable-ml-partition-speed-features"
        | "disable-ml-transform-speed-features"
        | "use-inter-dct-only"
        | "use-intra-dct-only"
        | "use-intra-default-tx-only"
        | "use-short-metadata" => {
            chk_switch(key, name, val)?;
        }

        "cdf-update-mode"
        | "coeff-cost-upd-freq"
        | "enable-bru"
        | "enable-cdef-on-skip-txfm"
        | "enable-drl-reorder"
        | "enable-intrabc-ext"
        | "enable-tcq"
        | "enable-tip"
        | "mode-cost-upd-freq" => {
            chk_range(key, name, val, 0, 2)?;
        }
        "enable-opfl-refine"
        | "enable-trellis-quant"
        | "mv-cost-upd-freq"
        | "reduced-tx-type-set"
        | "select-adaptive-ds"
        | "use-ml-erp-pruning" => {
            chk_range(key, name, val, 0, 3)?;
        }
        "arnr-strength" | "erp-pruning-level" | "noise-sensitivity" => {
            chk_range(key, name, val, 0, 6)?;
        }
        "sharpness" => {
            chk_range(key, name, val, 0, 7)?;
        }
        "cpu-used" => {
            chk_range(key, name, val, 0, 9)?;
        }
        "arnr-maxframes" => {
            chk_range(key, name, val, 0, 15)?;
        }
        "max-reference-frames" => {
            chk_range(key, name, val, 1, 7)?;
        }
        "dpb-size" => {
            chk_range(key, name, val, 1, 16)?;
        }
        "max-drl-refmvs" => {
            chk_drl(key, name, val, 8)?;
        }
        "max-drl-refbvs" => {
            chk_drl(key, name, val, 4)?;
        }
        "deltaq-mode" => {
            chk_custom(
                key,
                val,
                1,
                2,
                format_args!(
                    "{Y}deltaq-mode must be {C}1 {Y}(objective, TPL driven) or {C}2 {Y}(variance \
                     based perceptual).\n{C}0 {Y}is raw QP with no adaptation at all"
                ),
            )?;
        }
        "qp" => {
            chk_range(key, name, val, -48, 255)?;
        }
        "min-cr" | "static-thresh" => {
            chk_range(key, name, val, 0, U32_MAX)?;
        }

        _ => {
            return Err(err(key, format_args!("{Y}unknown or wrong parameter")));
        }
    }
    Ok(())
}

pub fn val(params: &str) -> Result<(), Xerr> {
    let mut sdp: i64 = 1;
    let mut kff: i64 = 2;
    let mut mono: Option<&str> = None;
    let mut part: [Option<(i64, &str)>; 2] = [None; 2];
    let mut qm: [Option<(i64, &str)>; 2] = [None; 2];
    let mut pyr: [Option<(i64, &str)>; 2] = [None; 2];
    let mut gf: [Option<(i64, &str)>; 2] = [None; 2];
    let mut iter = params.split_whitespace();

    while let Some(key) = iter.next() {
        let name = name_of(key)?;

        if let Some(e) = reject_msg(name, key) {
            return Err(e);
        }

        let Some(val) = iter.next() else {
            return Err(err(key, format_args!("{Y}missing value")));
        };

        match name {
            "enable-keyframe-filtering" => {
                kff = chk_range(key, name, val, 0, 2)?;
            }
            "monotonic-output-order" => {
                if chk_switch(key, name, val)? == 1 {
                    mono = Some(key);
                }
            }
            "enable-sdp" => {
                sdp = chk_switch(key, name, val)?;
            }
            "min-partition-size" => {
                part[0] = Some((chk_block(key, name, val)?, key));
            }
            "max-partition-size" => {
                part[1] = Some((chk_block(key, name, val)?, key));
            }
            "qm-min" => {
                qm[0] = Some((chk_range(key, name, val, 0, 15)?, key));
            }
            "qm-max" => {
                qm[1] = Some((chk_range(key, name, val, 0, 15)?, key));
            }
            "gf-min-pyr-height" => {
                pyr[0] = Some((chk_range(key, name, val, 0, 5)?, key));
            }
            "gf-max-pyr-height" => {
                pyr[1] = Some((chk_range(key, name, val, 0, 5)?, key));
            }
            "min-gf-interval" => {
                gf[0] = Some((chk_gf(key, name, val)?, key));
            }
            "max-gf-interval" => {
                gf[1] = Some((chk_gf(key, name, val)?, key));
            }
            _ => check_param(name, key, val)?,
        }
    }

    if let Some(key) = mono
        && kff != 0
    {
        return Err(err(
            key,
            format_args!("{Y}monotonic-output-order needs {C}--enable-keyframe-filtering 0"),
        ));
    }

    if let Some((hi, key)) = part[1]
        && sdp == 1
        && hi < 8
    {
        return Err(err(
            key,
            format_args!("{Y}max-partition-size must be at least {C}8 {Y}while enable-sdp is on"),
        ));
    }

    if let Some((lo, _)) = part[0]
        && let Some((hi, key)) = part[1]
        && lo > hi
    {
        return Err(err(
            key,
            format_args!(
                "{Y}max-partition-size ({C}{hi}{Y}) must be >= min-partition-size ({C}{lo}{Y})"
            ),
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

    if let Some((lo, _)) = pyr[0]
        && let Some((hi, key)) = pyr[1]
        && lo > hi
    {
        return Err(err(
            key,
            format_args!(
                "{Y}gf-max-pyr-height ({C}{hi}{Y}) must be >= gf-min-pyr-height ({C}{lo}{Y})"
            ),
        ));
    }

    if let Some((lo, _)) = gf[0]
        && let Some((hi, key)) = gf[1]
        && hi != 0
        && lo > hi
    {
        return Err(err(
            key,
            format_args!("{Y}max-gf-interval ({C}{hi}{Y}) must be >= min-gf-interval ({C}{lo}{Y})"),
        ));
    }

    Ok(())
}
