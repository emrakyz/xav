#[cfg(not(debug_assertions))]
use std::hint::unreachable_unchecked;

pub const G: &str = "\x1b[1;92m";
pub const R: &str = "\x1b[1;91m";
pub const B: &str = "\x1b[1;94m";
pub const P: &str = "\x1b[1;95m";
pub const Y: &str = "\x1b[1;93m";
pub const C: &str = "\x1b[1;96m";
pub const W: &str = "\x1b[1;97m";
pub const N: &str = "\x1b[0m";

#[inline(always)]
#[allow(clippy::inline_always, reason = "thin compiler-elided wrapper")]
#[allow(
    clippy::panic,
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
