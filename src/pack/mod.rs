use std::{
    ptr::copy_nonoverlapping,
    slice::{from_raw_parts, from_raw_parts_mut},
};

#[cfg(target_feature = "avx512bw")]
include!("avx512.rs");
#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
include!("avx2.rs");
#[cfg(not(any(target_feature = "avx2", target_feature = "avx512bw")))]
include!("scalar.rs");

include!("common.rs");
