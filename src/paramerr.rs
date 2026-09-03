use core::fmt::Arguments;

#[cfg(feature = "avm")]
use crate::{avmerr::val as avm_val, encoder::Encoder::Avm};
#[cfg(feature = "vvenc")]
use crate::{encoder::Encoder::Vvenc, vvencerr::val as vvenc_val};
use crate::{
    encoder::Encoder::{self, SvtAv1},
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

pub fn val(enc: Encoder, params: &str) -> Result<(), Xerr> {
    match enc {
        SvtAv1 => svt_val(params),
        #[cfg(feature = "vvenc")]
        Vvenc => vvenc_val(params),
        #[cfg(feature = "avm")]
        Avm => avm_val(params),
        _ => Ok(()),
    }
}
