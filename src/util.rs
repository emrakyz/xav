#[cfg(not(debug_assertions))]
use std::hint::unreachable_unchecked;

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
