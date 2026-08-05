#[cfg(feature = "vship")]
use core::arch::x86_64::{_mm_ceil_sd, _mm_ceil_ss};
use core::arch::x86_64::{
    _MM_FROUND_NO_EXC, _MM_FROUND_TO_ZERO, _mm_cvtsd_f64, _mm_cvtss_f32, _mm_fmadd_sd,
    _mm_fmadd_ss, _mm_round_sd, _mm_round_ss, _mm_set_sd, _mm_set_ss,
};

const F64_SIGN: u64 = 1 << 63;
const F32_SIGN: u32 = 1 << 31;
const TRUNC: i32 = _MM_FROUND_TO_ZERO | _MM_FROUND_NO_EXC;

unsafe extern "C" {
    fn xav_powf32(x: f32, n: f32) -> f32;
    fn xav_log10(x: f64) -> f64;
}

pub trait FloatExt {
    fn round(self) -> Self;
    fn mul_add(self, a: Self, b: Self) -> Self;
    #[cfg(feature = "vship")]
    fn ceil(self) -> Self;
}

pub trait Powf {
    fn powf(self, n: Self) -> Self;
}

pub trait Log10 {
    fn log10(self) -> Self;
}

impl Powf for f32 {
    #[inline]
    fn powf(self, n: Self) -> Self {
        unsafe { xav_powf32(self, n) }
    }
}

impl Log10 for f64 {
    #[inline]
    fn log10(self) -> Self {
        unsafe { xav_log10(self) }
    }
}

impl FloatExt for f64 {
    #[cfg(feature = "vship")]
    #[inline]
    fn ceil(self) -> Self {
        let x = unsafe { _mm_set_sd(self) };
        unsafe { _mm_cvtsd_f64(_mm_ceil_sd(x, x)) }
    }

    #[inline]
    fn round(self) -> Self {
        let half = Self::from_bits((0.5f64).to_bits() | (self.to_bits() & F64_SIGN));
        let y = unsafe { _mm_set_sd(self + half) };
        unsafe { _mm_cvtsd_f64(_mm_round_sd::<TRUNC>(y, y)) }
    }

    #[inline]
    fn mul_add(self, a: Self, b: Self) -> Self {
        unsafe { _mm_cvtsd_f64(_mm_fmadd_sd(_mm_set_sd(self), _mm_set_sd(a), _mm_set_sd(b))) }
    }
}

impl FloatExt for f32 {
    #[cfg(feature = "vship")]
    #[inline]
    fn ceil(self) -> Self {
        let x = unsafe { _mm_set_ss(self) };
        unsafe { _mm_cvtss_f32(_mm_ceil_ss(x, x)) }
    }

    #[inline]
    fn round(self) -> Self {
        let half = Self::from_bits((0.5f32).to_bits() | (self.to_bits() & F32_SIGN));
        let y = unsafe { _mm_set_ss(self + half) };
        unsafe { _mm_cvtss_f32(_mm_round_ss::<TRUNC>(y, y)) }
    }

    #[inline]
    fn mul_add(self, a: Self, b: Self) -> Self {
        unsafe { _mm_cvtss_f32(_mm_fmadd_ss(_mm_set_ss(self), _mm_set_ss(a), _mm_set_ss(b))) }
    }
}
