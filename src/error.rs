#[derive(thiserror::Error, Debug)]
pub enum Error {
    #[error("{0}")]
    Io(#[from] std::io::Error),

    #[error("{0}")]
    Ffi(#[from] std::ffi::NulError),

    #[error("{0}")]
    ParseInt(#[from] std::num::ParseIntError),

    #[error("{0}")]
    Msg(String),
}

impl From<&str> for Error {
    fn from(s: &str) -> Self {
        Self::Msg(s.into())
    }
}

impl From<String> for Error {
    fn from(s: String) -> Self {
        Self::Msg(s)
    }
}
