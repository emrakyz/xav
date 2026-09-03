use crate::{
    error::Xerr,
    paramerr::{auto_err, chk_range, chk_switch, err, name_of, off_err},
    util::{C, Y},
};

const NOT_RELEVANT: &[&str] = &[
    "help",
    "fullhelp",
    "version",
    "WriteConfig",
    "WarnUnknowParameter",
    "InputFile",
    "input",
    "BitstreamFile",
    "output",
    "ReconFile",
    "logofile",
    "y4m",
    "PYUV",
    "ClipInputVideoToRec709Range",
    "ClipOutputVideoToRec709Range",
    "PackedInput",
    "FrameSkip",
    "tracefile",
    "tracerule",
    "tracechannellist",
    "SummaryOutFilename",
    "SummaryPicFilenameBase",
    "SummaryVerboseness",
    "PrintFrameMSE",
    "PrintHexPSNR",
    "PrintSequenceMSE",
    "MSEBasedSequencePSNR",
    "decodedpicturehash",
    "SEIDecodedPictureHash",
    "TargetBitrate",
    "bitrate",
    "MaxBitrate",
    "maxrate",
    "RCInitialQP",
    "RCStatsFile",
    "rcstatsfile",
    "Pass",
    "pass",
    "stats",
    "FirstPassMode",
    "LookAhead",
    "segment",
    "LeadFrames",
    "TrailFrames",
    "MinIntraDistance",
    "MaxParallelFrames",
    "NumParallelGOPs",
    "SIMD",
    "MTProfile",
    "mtprofile",
    "additional",
    "MaxPicWidth",
    "MaxPicHeight",
    "MaxPicSize",
    "RPR",
    "Tiles",
    "tiles",
    "TileColumnWidthArray",
    "TileRowHeightArray",
    "TileParallelCtuEnc",
    "EnablePicPartitioning",
    "TreatAsSubPic",
    "ForceSCC",
    "FastSearchSCC",
    "NumRefPicsSCC",
    "IntraConstraintFlag",
];

const AUTO_SET: &[&str] = &[
    "InputBitDepth",
    "InputBitDepthC",
    "InputChromaFormat",
    "format",
    "InternalBitDepth",
    "internal-bitdepth",
    "OutputBitDepth",
    "OutputBitDepthC",
    "MaxBitDepthConstraint",
    "MSBExtendedBitDepth",
    "MSBExtendedBitDepthC",
    "ChromaFormatIDC",
    "Profile",
    "Level",
    "Tier",
    "IntraPeriod",
    "intraperiod",
    "RefreshSec",
    "refreshsec",
    "DecodingRefreshType",
    "refreshtype",
    "POC0IDR",
    "GOPSize",
    "NumPasses",
    "Passes",
    "passes",
    "Threads",
    "threads",
    "AMaxBT",
    "CabacInitPresent",
    "WppBitEqual",
    "SaoEncodingRate",
    "SaoEncodingRateChroma",
    "Verbosity",
    "SourceWidth",
    "SourceHeight",
    "Size",
    "size",
    "FrameRate",
    "framerate",
    "FrameScale",
    "framescale",
    "fps",
    "TicksPerSecond",
    "tickspersec",
    "FramesToBeEncoded",
    "frames",
    "Hdr",
    "hdr",
    "Sdr",
    "sdr",
    "ColourPrimaries",
    "TransferCharacteristics",
    "MatrixCoefficients",
    "Range",
    "range",
    "VideoFullRange",
    "ColourDescriptionPresent",
    "ChromaSampleLocType",
    "ChromaLocInfoPresent",
    "MasteringDisplayColourVolume",
    "MaxContentLightLevel",
    "PerceptQPATempFiltIPic",
    "GOPQPA",
];

const PRESETS: &[&str] = &["faster", "fast", "medium", "slow", "slower"];

const FLAGS: &[&str] = &["auto", "-1", "off", "disable", "0", "on", "enable", "1"];

const QPA_ON: &[&str] = &["on", "enable", "1", "2", "3", "4", "5"];

const QPA_OFF: &[&str] = &["off", "disable", "0"];

fn reject_msg(name: &str, key: &str) -> Option<Xerr> {
    if NOT_RELEVANT.contains(&name) {
        return Some(off_err(key));
    }
    if AUTO_SET.contains(&name) {
        return Some(auto_err(key));
    }
    Some(match name {
        "CostMode" => err(
            key,
            format_args!(
                "{Y}xav only encodes lossy. The lossless cost modes replace the QP and disable \
                 delta QP,\nand {C}mixed_lossless_lossy {Y}has no effect in vvenc at all"
            ),
        ),
        "PicReordering" => err(
            key,
            format_args!(
                "{Y}PicReordering {C}0 {Y}is low delay. xav encodes Random Access only and every \
                 chunk\nstarts on an IDR, which low delay refuses"
            ),
        ),
        "SEIBufferingPeriod" | "SEIPictureTiming" | "SEIDecodingUnitInfo" => err(
            key,
            format_args!(
                "{Y}These SEI messages need rate control. xav encodes CRF only, so vvenc always \
                 rejects them"
            ),
        ),
        "STA" => err(
            key,
            format_args!(
                "{Y}xav already does scene change detection and forces {C}--STA 0{Y}.\nvvenc's \
                 slice type adaptation turns a mid GOP frame into an I slice, which would break \
                 the one keyframe per chunk rule"
            ),
        ),
        "MCTFFrame" | "MCTFStrength" => err(
            key,
            format_args!(
                "{Y}vvenc derives the temporal filter taps from GOPSize and the QP.\nxav sweeps \
                 the QP per chunk, so a fixed list would be wrong for every QP but one"
            ),
        ),
        "NumRefPics" => err(
            key,
            format_args!("{Y}The reference picture lists are derived from the GOP structure"),
        ),
        "IntraQPOffset"
        | "MaxDeltaQP"
        | "MaxCuDQPSubdiv"
        | "MaxCuChromaQpOffsetSubdiv"
        | "CbQpOffset"
        | "CrQpOffset"
        | "CbCrQpOffset"
        | "CbQpOffsetDualTree"
        | "CrQpOffsetDualTree"
        | "CbCrQpOffsetDualTree"
        | "SliceCbQpOffsetIntraOrPeriodic"
        | "SliceCrQpOffsetIntraOrPeriodic"
        | "SliceChromaQPOffsetPeriodicity" => err(
            key,
            format_args!(
                "{Y}QP offsets are derived by the encoder from the GOP and the QP.\nxav sweeps \
                 the QP per chunk, so a fixed offset cannot be right for all of them"
            ),
        ),
        _ => return None,
    })
}

fn chk_flag(key: &str, name: &str, val: &str) -> Result<(), Xerr> {
    if FLAGS.contains(&val) {
        return Ok(());
    }
    Err(err(
        key,
        format_args!(
            "{Y}{name} must be {C}auto{Y}/{C}-1{Y}, {C}off{Y}/{C}disable{Y}/{C}0 {Y}or \
             {C}on{Y}/{C}enable{Y}/{C}1"
        ),
    ))
}

fn chk_block(key: &str, name: &str, val: &str, lo: i64, hi: i64) -> Result<i64, Xerr> {
    let v = chk_range(key, name, val, lo, hi)?;
    if v & (v - 1) == 0 {
        return Ok(v);
    }
    Err(err(key, format_args!("{Y}{name} must be a power of two")))
}

fn check_param(name: &str, key: &str, val: &str) -> Result<(), Xerr> {
    match name {
        "preset" => {
            if !PRESETS.contains(&val) {
                return Err(err(
                    key,
                    format_args!(
                        "{Y}preset must be one of {C}faster{Y}, {C}fast{Y}, {C}medium{Y}, {C}slow \
                         {Y}or {C}slower"
                    ),
                ));
            }
        }

        "AccessUnitDelimiter"
        | "accessunitdelimiter"
        | "VuiParametersPresent"
        | "vuiparameterspresent"
        | "WaveFrontSynchro"
        | "IFP"
        | "ifp" => {
            chk_flag(key, name, val)?;
        }

        "ALF"
        | "AffineType"
        | "CCALF"
        | "ALFTempPred"
        | "ASR"
        | "BDOF"
        | "BIO"
        | "ChromaTS"
        | "DMVR"
        | "DepQuant"
        | "DisableIntraInInter"
        | "FDM"
        | "FastHAD"
        | "FastMEAssumingSmootherMVEnabled"
        | "FastMEForGenBLowDelayEnabled"
        | "FastQtBtEnc"
        | "FastUDIUseMPMEnabled"
        | "ClipForBiPredMEEnabled"
        | "ContentBasedFastQtbt"
        | "HadamardME"
        | "IntegerET"
        | "JointCbCr"
        | "LCTUFast"
        | "LMChroma"
        | "LambdaFromQpEnable"
        | "MIP"
        | "MRL"
        | "MTS"
        | "MTSImplicit"
        | "PROF"
        | "RDOQTS"
        | "ReWriteParamSets"
        | "SbTMVP"
        | "SignHideFlag"
        | "UseNonLinearAlfChroma"
        | "UseNonLinearAlfLuma"
        | "VerCollocatedChroma"
        | "HorCollocatedChroma"
        | "SameCQPTablesForAllChroma"
        | "AddGOP32refPics"
        | "AllowDisFracMMVD"
        | "DisableLoopFilterAcrossSlices"
        | "DisableLoopFilterAcrossTiles"
        | "EntryPointsPresent"
        | "LoopFilterOffsetInPPS"
        | "HrdParametersPresent"
        | "hrdparameterspresent"
        | "AspectRatioInfoPresent"
        | "OverscanInfoPresent"
        | "OverscanAppropriate"
        | "CabacZeroWordPaddingEnabled"
        | "EnableDecodingParameterSet"
        | "MCTFFutureReference"
        | "ReduceIntraChromaModesFullRD"
        | "UseIdentityTableForNon420Chroma"
        | "IDRRefParamList" => {
            chk_switch(key, name, val)?;
        }

        "AMVR" | "IMV" | "ExplicitAPSid" | "QtbttExtraFast" | "FastTTSplit" => {
            chk_range(key, name, val, 0, 7)?;
        }
        "Affine" | "ALFSpeed" => {
            chk_range(key, name, val, 0, 5)?;
        }
        "IBCFastMethod" => {
            chk_range(key, name, val, 0, 6)?;
        }
        "Geo" | "MMVD" | "MTSIntraMaxCand" | "FastInferMerge" | "MCTFSpeed" => {
            chk_range(key, name, val, 0, 4)?;
        }
        "SMVD" | "SBT" | "ISP" | "LFNST" | "CIIP" | "FastMIP" | "FastMrg" | "FEN" => {
            chk_range(key, name, val, 0, 3)?;
        }
        "BCW"
        | "EDO"
        | "EncDbOpt"
        | "FastIntraTools"
        | "FastSubPel"
        | "BDPCM"
        | "ECU"
        | "FastLocalDualTreeMode"
        | "PBIntraFast"
        | "RDOQ"
        | "ReduceFilterME"
        | "SAO"
        | "SelectiveRDOQ"
        | "TransformSkip"
        | "TMVPMode"
        | "IBC" => {
            chk_range(key, name, val, 0, 2)?;
        }
        "NumIntraModesFullRD" => {
            if !matches!(chk_range(key, name, val, -1, 3)?, -1 | 1..=3) {
                return Err(err(
                    key,
                    format_args!(
                        "{Y}NumIntraModesFullRD must be {C}-1 {Y}or between {C}1 {Y}and {C}3"
                    ),
                ));
            }
        }
        "FastSearch" => {
            if !matches!(chk_range(key, name, val, 0, 4)?, 0 | 1 | 3 | 4) {
                return Err(err(
                    key,
                    format_args!("{Y}FastSearch must be {C}0{Y}, {C}1{Y}, {C}3 {Y}or {C}4"),
                ));
            }
        }
        "QP" | "qp" => {
            chk_range(key, name, val, 0, 63)?;
        }
        "TransformSkipLog2MaxSize" => {
            chk_range(key, name, val, 2, 5)?;
        }
        "LoopFilterBetaOffset_div2"
        | "LoopFilterTcOffset_div2"
        | "LoopFilterCbBetaOffset_div2"
        | "LoopFilterCbTcOffset_div2"
        | "LoopFilterCrBetaOffset_div2"
        | "LoopFilterCrTcOffset_div2" => {
            chk_range(key, name, val, -12, 12)?;
        }
        "SearchRange" | "BipredSearchRange" | "MinSearchWindow" => {
            chk_range(key, name, val, 0, i64::from(i32::MAX))?;
        }
        "MmvdDisNum" | "MaxNumAlfAlternativesChroma" => {
            chk_range(key, name, val, 1, 8)?;
        }
        "MaxNumAffineMergeCand" => {
            chk_range(key, name, val, 1, 5)?;
        }
        "Log2MaxTbSize" => {
            chk_range(key, name, val, 5, 6)?;
        }
        "Log2MinCodingBlockSize" => {
            chk_range(key, name, val, 2, 6)?;
        }
        "MaxMTTDepthI" | "MaxMTTDepthISliceL" | "MaxMTTDepthISliceC" => {
            chk_range(key, name, val, 0, 9)?;
        }
        "MaxMTTDepth" => {
            if !matches!(chk_range(key, name, val, 0, 0xFFFF_FFFF)?, 0..=9 | 100_000..) {
                return Err(err(
                    key,
                    format_args!(
                        "{Y}MaxMTTDepth must be between {C}0 {Y}and {C}9 {Y}for all temporal \
                         layers, or one digit per temporal layer (at least {C}100000{Y})"
                    ),
                ));
            }
        }
        "MinQTChromaISliceInChromaSamples" => {
            chk_block(key, name, val, 2, 64)?;
        }
        "MinQTISlice" | "MinQTLumaISlice" | "MinQTNonISlice" | "MaxBTChromaISlice"
        | "MaxBTNonISlice" | "MaxTTLumaISlice" | "MaxTTChromaISlice" | "MaxTTNonISlice" => {
            chk_block(key, name, val, 4, 128)?;
        }
        "MCTFUnitSize" => {
            chk_block(key, name, val, 8, 32)?;
        }
        "IFPLines" | "FppLinesSynchro" => {
            chk_range(key, name, val, -1, 127)?;
        }

        _ => {
            return Err(err(key, format_args!("{Y}unknown or wrong parameter")));
        }
    }
    Ok(())
}

pub fn val(params: &str) -> Result<(), Xerr> {
    let mut ctu: i64 = 128;
    let mut alfu: Option<(i64, &str)> = None;
    let mut mrgc: i64 = 5;
    let mut geoc: Option<(i64, &str)> = None;
    let mut lfd: i64 = 0;
    let mut dblk: Option<(i64, &str)> = None;
    let mut qpa = false;
    let mut bim: i64 = 1;
    let mut lldq: i64 = -1;
    let mut dit: i64 = 1;
    let mut mbt: Option<(i64, &str)> = None;
    let mut mctf: Option<(i64, &str)> = None;
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
            "CTUSize" => {
                ctu = match val {
                    "32" => 32,
                    "64" => 64,
                    "128" => 128,
                    _ => {
                        return Err(err(
                            key,
                            format_args!("{Y}CTUSize must be {C}32{Y}, {C}64 {Y}or {C}128"),
                        ));
                    }
                };
            }
            "ALFUnitSize" => {
                alfu = Some((chk_range(key, name, val, -1, i64::from(i32::MAX))?, key));
            }
            "DualITree" => {
                dit = chk_switch(key, name, val)?;
            }
            "MaxBTLumaISlice" => {
                mbt = Some((chk_block(key, name, val, 4, 128)?, key));
            }
            "MaxNumMergeCand" => {
                mrgc = chk_range(key, name, val, 1, 6)?;
            }
            "MaxNumGeoCand" => {
                let v = chk_range(key, name, val, 0, 6)?;
                if v == 1 {
                    return Err(err(
                        key,
                        format_args!("{Y}MaxNumGeoCand must be {C}0 {Y}or at least {C}2"),
                    ));
                }
                geoc = Some((v, key));
            }
            "LoopFilterDisable" => {
                lfd = chk_switch(key, name, val)?;
            }
            "DeblockLastTLayers" => {
                dblk = Some((chk_range(key, name, val, 0, 4)?, key));
            }
            "qpa" | "PerceptQPA" => {
                if QPA_ON.contains(&val) {
                    qpa = true;
                } else if !QPA_OFF.contains(&val) {
                    return Err(err(
                        key,
                        format_args!(
                            "{Y}{name} must be {C}off{Y}/{C}disable{Y}/{C}0 {Y}or \
                             {C}on{Y}/{C}enable{Y}/{C}1"
                        ),
                    ));
                }
            }
            "MCTF" => {
                mctf = Some((chk_range(key, name, val, 0, 2)?, key));
            }
            "BIM" => {
                bim = chk_switch(key, name, val)?;
            }
            "LumaLevelToDeltaQPMode" => {
                lldq = chk_range(key, name, val, -1, 1)?;
            }
            _ => check_param(name, key, val)?,
        }
    }

    if let Some((v, key)) = alfu
        && v != -1
        && (v < ctu || v % ctu != 0)
    {
        return Err(err(
            key,
            format_args!("{Y}ALFUnitSize must be {C}-1 {Y}or a multiple of CTUSize ({C}{ctu}{Y})"),
        ));
    }

    if let Some((v, key)) = mbt
        && v == 128
        && ctu == 128
        && dit == 1
    {
        return Err(err(
            key,
            format_args!("{Y}MaxBTLumaISlice must be below {C}128 {Y}while DualITree is on"),
        ));
    }

    if let Some((v, key)) = mctf
        && v == 0
        && bim == 1
    {
        return Err(err(
            key,
            format_args!("{Y}MCTF cannot be disabled while BIM is on; add {C}--BIM 0"),
        ));
    }

    if let Some((v, key)) = geoc
        && v > mrgc
    {
        return Err(err(
            key,
            format_args!("{Y}MaxNumGeoCand must not exceed MaxNumMergeCand ({C}{mrgc}{Y})"),
        ));
    }

    if let Some((v, key)) = dblk
        && v > 0
        && lfd == 1
    {
        return Err(err(
            key,
            format_args!("{Y}DeblockLastTLayers needs the deblocking filter enabled"),
        ));
    }

    if qpa && lldq == 1 {
        return Err(err(
            "--LumaLevelToDeltaQPMode",
            format_args!("{Y}LumaLevelToDeltaQPMode cannot be used when PerceptQPA is enabled"),
        ));
    }

    Ok(())
}
