use core::{
    ptr::copy_nonoverlapping,
    slice::{from_raw_parts, from_raw_parts_mut},
};

#[cfg(target_feature = "avx512bw")]
include!("avx512.rs");
#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
include!("avx2.rs");

include!("common.rs");
