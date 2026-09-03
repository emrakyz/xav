use alloc::ffi::NulError;
#[cfg(target_os = "linux")]
use alloc::string::String;
#[cfg(all(target_os = "linux", not(test)))]
use core::panic::PanicInfo;
use core::{
    fmt::{self, Arguments, Display, Formatter},
    num::{ParseFloatError, ParseIntError},
    sync::atomic::{AtomicBool, Ordering::Relaxed},
};

#[cfg(target_os = "linux")]
use crate::sys::{self, exit_group, sigactions};
use crate::{
    error::Xerr::Msg,
    io::{Error, Write as _, print_fmt, stderr, stdout},
};

pub static IN_ALT_SCREEN: AtomicBool = AtomicBool::new(false);

#[derive(Debug)]
pub enum Xerr {
    Io(Error),
    Ffi(NulError),
    ParseInt(ParseIntError),
    ParseFloat(ParseFloatError),
    Msg(String),
    Help,
}

impl Display for Xerr {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        match *self {
            Self::Io(ref e) => Display::fmt(e, f),
            Self::Ffi(ref e) => Display::fmt(e, f),
            Self::ParseInt(ref e) => Display::fmt(e, f),
            Self::ParseFloat(ref e) => Display::fmt(e, f),
            Self::Msg(ref s) => f.write_str(s),
            Self::Help => Ok(()),
        }
    }
}

impl From<Error> for Xerr {
    #[cold]
    #[inline(never)]
    fn from(e: Error) -> Self {
        Self::Io(e)
    }
}

impl From<NulError> for Xerr {
    #[cold]
    #[inline(never)]
    fn from(e: NulError) -> Self {
        Self::Ffi(e)
    }
}

impl From<ParseIntError> for Xerr {
    #[cold]
    #[inline(never)]
    fn from(e: ParseIntError) -> Self {
        Self::ParseInt(e)
    }
}

impl From<ParseFloatError> for Xerr {
    #[cold]
    #[inline(never)]
    fn from(e: ParseFloatError) -> Self {
        Self::ParseFloat(e)
    }
}

impl From<&str> for Xerr {
    #[cold]
    #[inline(never)]
    fn from(s: &str) -> Self {
        Msg(s.into())
    }
}

impl From<String> for Xerr {
    #[cold]
    #[inline(never)]
    fn from(s: String) -> Self {
        Msg(s)
    }
}

#[cfg(target_os = "linux")]
pub fn reraise(sig: i32) {
    sys::reraise(sig);
}

#[cfg(target_os = "linux")]
pub fn exit(code: i32) -> ! {
    unsafe { exit_group(code) }
}

#[cfg(not(target_os = "linux"))]
pub fn exit(code: i32) -> ! {
    unsafe extern "C" {
        fn _exit(code: i32) -> !;
    }
    unsafe { _exit(code) }
}

#[cfg(target_os = "linux")]
const TERM_SIGS: [i32; 9] = [1, 2, 3, 4, 6, 7, 8, 11, 15];
#[cfg(not(target_os = "linux"))]
const TERM_SIGS: [i32; 6] = [2, 4, 8, 11, 15, 22];

#[cfg(target_os = "linux")]
pub fn signals(handler: usize) {
    sigactions(&TERM_SIGS, handler);
}

#[cfg(not(target_os = "linux"))]
pub fn signals(handler: usize) {
    unsafe extern "C" {
        #[link_name = "signal"]
        fn c_signal(sig: i32, handler: usize) -> usize;
    }
    for sig in TERM_SIGS {
        unsafe {
            c_signal(sig, handler);
        }
    }
}

#[cfg(not(target_os = "linux"))]
pub fn reraise(_: i32) {}

#[cold]
#[inline(never)]
pub fn fatal<E: Display>(e: E) -> ! {
    if IN_ALT_SCREEN.load(Relaxed) {
        print!("\x1b[?25h\x1b[?1049l");
        _ = stdout().flush();
    }
    _ = writeln!(stderr(), "{e}");
    exit(1)
}

#[cold]
#[inline(never)]
pub fn eprint(args: Arguments<'_>) {
    if IN_ALT_SCREEN.load(Relaxed) {
        print!("\x1b[?1049l");
        _ = stdout().flush();
    }
    _ = writeln!(stderr(), "{args}");
}

#[cfg(all(target_os = "linux", not(test)))]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    if IN_ALT_SCREEN.load(Relaxed) {
        print!("\x1b[?25h\x1b[?1049l");
        _ = stdout().flush();
    }
    eprint(format_args!("{info}"));
    exit(1)
}

#[cfg(all(target_os = "linux", not(test)))]
#[unsafe(no_mangle)]
const extern "C" fn rust_eh_personality() {}
