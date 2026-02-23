//! This module contains various generic utilities that
//! are not specific to any area of xav's workflow.

#[cfg(not(debug_assertions))]
use std::hint::unreachable_unchecked;

/// In debug mode, this function calls the `unreachable!()` macro to panic.
/// In release mode, this function calls the `unreachable_unchecked` function.
#[inline(always)]
#[allow(clippy::inline_always, reason = "thin compiler-elided wrapper")]
pub const fn debug_unreachable() -> ! {
    #[cfg(debug_assertions)]
    unreachable!();

    #[cfg(not(debug_assertions))]
    unsafe {
        unreachable_unchecked();
    }
}
