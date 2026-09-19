use core::fmt::Arguments;

#[cfg(feature = "avm")]
use crate::avmerr::val as avm_val;
#[cfg(feature = "vvenc")]
use crate::vvencerr::val as vvenc_val;
#[cfg(feature = "x264")]
use crate::x264err::val as x264_val;
#[cfg(feature = "x265")]
use crate::x265err::val as x265_val;
use crate::{
    encoder::Encoder::{self, Avm, SvtAv1, Vvenc, X264, X265},
    error::Xerr,
    svterr::val as svt_val,
    util::{C, N, R, W, Y},
};

#[cold]
#[inline(never)]
pub fn err(key: &str, msg: Arguments<'_>) -> Xerr {
    format!("{R}{key} {msg}{N}").into()
}

#[cold]
#[inline(never)]
pub fn chk_range(key: &str, name: &str, val: &str, lo: i64, hi: i64) -> Result<i64, Xerr> {
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
pub fn chk_switch(key: &str, name: &str, val: &str) -> Result<i64, Xerr> {
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
pub fn chk_custom(key: &str, val: &str, lo: i64, hi: i64, msg: Arguments<'_>) -> Result<i64, Xerr> {
    match val.parse::<i64>() {
        Ok(v) if v >= lo && v <= hi => Ok(v),
        Ok(_) => Err(err(key, msg)),
        Err(_) => Err(err(key, format_args!("{Y}{val} {W}is not a valid integer"))),
    }
}

#[cold]
#[inline(never)]
pub fn chk_frange(key: &str, name: &str, val: &str, lo: f32, hi: f32) -> Result<(), Xerr> {
    match val.parse::<f32>() {
        Ok(v) if v >= lo && v <= hi => Ok(()),
        Ok(_) => Err(err(
            key,
            format_args!("{Y}{name} must be between {C}{lo} {Y}and {C}{hi}"),
        )),
        Err(_) => Err(err(key, format_args!("{Y}{val} {W}is not a valid number"))),
    }
}

pub fn name_of(key: &str) -> Result<&str, Xerr> {
    key.strip_prefix("--")
        .filter(|n| !n.contains('='))
        .ok_or_else(|| {
            err(
                key,
                format_args!("{Y}parameters must be given as {C}--name value"),
            )
        })
}

#[cold]
#[inline(never)]
pub fn auto_err(key: &str) -> Xerr {
    err(
        key,
        format_args!(
            "{Y}The parameter {R}{key} {Y}is used by xav automatically, you should never set it."
        ),
    )
}

#[cold]
#[inline(never)]
pub fn off_err(key: &str) -> Xerr {
    err(
        key,
        format_args!("{Y}The parameter {R}{key} {Y}is not relevant with xav and should not be set"),
    )
}

#[cfg(any(feature = "x264", feature = "x265"))]
pub const DEBLOCK_HINT: &str =
    "deblock takes tC and beta offsets as one value, or tc:beta; -6 to 6";

#[cfg(any(feature = "x264", feature = "x265"))]
#[cold]
#[inline(never)]
pub fn chk_name(key: &str, name: &str, val: &str, names: &[&str], hint: &str) -> Result<(), Xerr> {
    if names.contains(&val) {
        return Ok(());
    }
    Err(err(key, format_args!("{Y}{name} must be one of {C}{hint}")))
}

#[cfg(any(feature = "x264", feature = "x265"))]
#[cold]
#[inline(never)]
pub fn chk_deblock(key: &str, val: &str) -> Result<(), Xerr> {
    let mut n = 0;
    for v in val.split([':', ',']) {
        n += 1;
        match v.parse::<i64>() {
            Ok(o) if n <= 2 && (-6..=6).contains(&o) => {}
            _ => return Err(err(key, format_args!("{Y}{DEBLOCK_HINT}"))),
        }
    }
    Ok(())
}

pub fn val(enc: Encoder, params: &str) -> Result<(), Xerr> {
    match enc {
        SvtAv1 => svt_val(params),
        #[cfg(feature = "vvenc")]
        Vvenc => vvenc_val(params),
        #[cfg(not(feature = "vvenc"))]
        Vvenc => Ok(()),
        #[cfg(feature = "avm")]
        Avm => avm_val(params),
        #[cfg(not(feature = "avm"))]
        Avm => Ok(()),
        #[cfg(feature = "x265")]
        X265 => x265_val(params),
        #[cfg(not(feature = "x265"))]
        X265 => Ok(()),
        #[cfg(feature = "x264")]
        X264 => x264_val(params),
        #[cfg(not(feature = "x264"))]
        X264 => Ok(()),
    }
}
