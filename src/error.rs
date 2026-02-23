use std::{
    ffi::NulError,
    fmt::{Arguments, Display},
    io::{self, Write as _, stderr, stdout},
    num::ParseIntError,
    process,
};

#[derive(thiserror::Error, Debug)]
pub enum Xerr {
    #[error("{0}")]
    Io(#[from] io::Error),

    #[error("{0}")]
    Ffi(#[from] NulError),

    #[error("{0}")]
    ParseInt(#[from] ParseIntError),

    #[error("{0}")]
    Msg(String),

    #[error("")]
    Help,
}

impl From<&str> for Xerr {
    fn from(s: &str) -> Self {
        Self::Msg(s.into())
    }
}

impl From<String> for Xerr {
    fn from(s: String) -> Self {
        Self::Msg(s)
    }
}

#[cold]
#[allow(clippy::exit)]
pub fn fatal<E: Display>(e: E) -> ! {
    print!("\x1b[?25h\x1b[?1049l");
    _ = stdout().flush();
    _ = writeln!(stderr(), "{e}");
    process::exit(1)
}

pub fn eprint(args: Arguments<'_>) {
    print!("\x1b[?1049l");
    _ = stdout().flush();
    _ = writeln!(stderr(), "{args}");
}
