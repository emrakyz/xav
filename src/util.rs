use core::hash::Hasher;
#[cfg(not(debug_assertions))]
use core::hint::unreachable_unchecked;

pub const G: &str = "\x1b[1;92m";
pub const R: &str = "\x1b[1;91m";
pub const B: &str = "\x1b[1;94m";
pub const P: &str = "\x1b[1;95m";
pub const Y: &str = "\x1b[1;93m";
pub const C: &str = "\x1b[1;96m";
pub const W: &str = "\x1b[1;97m";
pub const N: &str = "\x1b[0m";

pub struct Fnv(u64);

impl Fnv {
    #[inline]
    pub const fn new() -> Self {
        Self(0xcbf2_9ce4_8422_2325)
    }
}

impl Default for Fnv {
    #[inline]
    fn default() -> Self {
        Self::new()
    }
}

impl Hasher for Fnv {
    #[inline]
    fn write(&mut self, bytes: &[u8]) {
        for &b in bytes {
            self.0 ^= u64::from(b);
            self.0 = self.0.wrapping_mul(0x0000_0100_0000_01b3);
        }
    }

    #[inline]
    fn finish(&self) -> u64 {
        self.0
    }
}

#[inline(always)]
#[allow(
    clippy::panic,
    clippy::unreachable,
    reason = "debug-only panic for catching logic errors in tests"
)]
pub const fn assume_unreachable() -> ! {
    #[cfg(debug_assertions)]
    unreachable!();

    #[cfg(not(debug_assertions))]
    unsafe {
        unreachable_unchecked();
    }
}
