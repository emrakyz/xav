use std::{
    ffi::NulError,
    fmt::Display,
    io::{self, Write, stdout},
    num::ParseIntError,
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
pub fn fatal(e: impl Display) -> ! {
    use std::process;
    print!("\x1b[?25h\x1b[?1049l");
    let _ = stdout().flush();
    eprintln!("{e}");
    process::exit(1)
}
