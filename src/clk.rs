use core::time::Duration;
#[cfg(not(target_os = "linux"))]
use std::time::{Instant, SystemTime, UNIX_EPOCH};

#[cfg(target_os = "linux")]
use crate::sys::{clock_mono_ns, clock_real};

#[cfg(target_os = "linux")]
#[derive(Clone, Copy)]
pub struct Mono(u64);

#[cfg(not(target_os = "linux"))]
#[derive(Clone, Copy)]
pub struct Mono(Instant);

#[cfg(target_os = "linux")]
impl Mono {
    #[inline]
    pub fn now() -> Self {
        Self(clock_mono_ns())
    }

    #[inline]
    pub fn elapsed(self) -> Duration {
        Duration::from_nanos(clock_mono_ns() - self.0)
    }

    #[inline]
    pub const fn raw(self) -> u64 {
        self.0
    }
}

#[cfg(not(target_os = "linux"))]
impl Mono {
    #[inline]
    pub fn now() -> Self {
        Self(Instant::now())
    }

    #[inline]
    pub fn elapsed(self) -> Duration {
        self.0.elapsed()
    }
}

#[cfg(target_os = "linux")]
pub fn realtime() -> (u64, u32) {
    clock_real()
}

#[cfg(not(target_os = "linux"))]
pub fn realtime() -> (u64, u32) {
    let d = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap_or_default();
    (d.as_secs(), d.subsec_nanos())
}
