#[cfg(target_feature = "avx2")]
include!("avx2.rs");
#[cfg(not(target_feature = "avx2"))]
include!("scalar.rs");
