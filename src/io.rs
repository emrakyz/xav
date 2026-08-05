use alloc::{string::String, vec::Vec};
use core::{
    fmt::{
        Arguments, Display, Error as FmtErr, Formatter, Result as FmtResult, Write as FmtWrite,
        write as fmt_write,
    },
    mem::MaybeUninit,
    ptr::copy_nonoverlapping,
    result::Result as CoreResult,
    slice::from_raw_parts_mut,
    str::from_utf8,
};
#[cfg(not(target_os = "linux"))]
use std::fs::File as StdFile;
#[cfg(not(target_os = "linux"))]
use std::io::ErrorKind::{InvalidData, UnexpectedEof, WriteZero};
#[cfg(not(target_os = "linux"))]
use std::io::{
    Error as StdError, IsTerminal as StdIsTerminal, Read as StdRead, Seek as StdSeek,
    SeekFrom as StdSeekFrom, Stderr as StdStderr, Stdin as StdStdin, Stdout as StdStdout,
    Write as StdWrite, stderr as std_stderr, stdin as std_stdin, stdout as std_stdout,
};
#[cfg(not(target_os = "linux"))]
use std::process::{
    ChildStderr as StdChildStderr, ChildStdin as StdChildStdin, ChildStdout as StdChildStdout,
};

#[cfg(target_os = "linux")]
use crate::sys::{isatty, read as sys_read, write as sys_write};

#[cfg(target_os = "linux")]
#[derive(Debug)]
pub enum Error {
    Os(i32),
    UnexpectedEof,
    InvalidData,
    WriteZero,
}
#[cfg(not(target_os = "linux"))]
pub type Error = StdError;

pub type Result<T> = CoreResult<T, Error>;

#[cfg(target_os = "linux")]
impl Error {
    #[inline]
    pub const fn from_raw_os_error(e: i32) -> Self {
        Self::Os(e)
    }
}

#[cfg(target_os = "linux")]
impl Display for Error {
    fn fmt(&self, f: &mut Formatter<'_>) -> FmtResult {
        match *self {
            Self::Os(e) => write!(f, "os error {e}"),
            Self::UnexpectedEof => f.write_str("unexpected end of file"),
            Self::InvalidData => f.write_str("invalid utf-8 data"),
            Self::WriteZero => f.write_str("write returned zero"),
        }
    }
}

#[cfg(target_os = "linux")]
const fn eof() -> Error {
    Error::UnexpectedEof
}
#[cfg(target_os = "linux")]
const fn invalid_data() -> Error {
    Error::InvalidData
}
#[cfg(target_os = "linux")]
const fn write_zero() -> Error {
    Error::WriteZero
}
#[cfg(not(target_os = "linux"))]
fn eof() -> Error {
    UnexpectedEof.into()
}
#[cfg(not(target_os = "linux"))]
fn invalid_data() -> Error {
    InvalidData.into()
}
#[cfg(not(target_os = "linux"))]
fn write_zero() -> Error {
    WriteZero.into()
}

#[cfg(target_os = "linux")]
#[derive(Clone, Copy)]
pub enum SeekFrom {
    Start(u64),
}
#[cfg(not(target_os = "linux"))]
pub type SeekFrom = StdSeekFrom;

pub trait Read {
    fn read(&mut self, buf: &mut [u8]) -> Result<usize>;

    fn read_exact(&mut self, mut buf: &mut [u8]) -> Result<()> {
        while !buf.is_empty() {
            match self.read(buf)? {
                0 => return Err(eof()),
                n => buf = &mut buf[n..],
            }
        }
        Ok(())
    }

    fn read_to_end(&mut self, buf: &mut Vec<u8>) -> Result<usize> {
        let start = buf.len();
        loop {
            if buf.len() == buf.capacity() {
                buf.reserve(32);
            }
            let spare = buf.spare_capacity_mut();
            let dst = unsafe { from_raw_parts_mut(spare.as_mut_ptr().cast::<u8>(), spare.len()) };
            match self.read(dst)? {
                0 => return Ok(buf.len() - start),
                n => unsafe { buf.set_len(buf.len() + n) },
            }
        }
    }

    fn read_to_string(&mut self, buf: &mut String) -> Result<usize> {
        let mut bytes = Vec::new();
        let n = self.read_to_end(&mut bytes)?;
        buf.push_str(from_utf8(&bytes).map_err(|_e| invalid_data())?);
        Ok(n)
    }
}

pub trait Write {
    fn write(&mut self, buf: &[u8]) -> Result<usize>;
    fn flush(&mut self) -> Result<()>;

    fn write_all(&mut self, mut buf: &[u8]) -> Result<()> {
        while !buf.is_empty() {
            match self.write(buf)? {
                0 => return Err(write_zero()),
                n => buf = &buf[n..],
            }
        }
        Ok(())
    }

    fn write_fmt(&mut self, args: Arguments<'_>) -> Result<()> {
        let mut a = Adapter {
            inner: self,
            err: None,
        };
        if fmt_write(&mut a, args).is_err() {
            return Err(a.err.unwrap_or_else(write_zero));
        }
        Ok(())
    }
}

struct Adapter<'a, W: ?Sized> {
    inner: &'a mut W,
    err: Option<Error>,
}

impl<W: Write + ?Sized> FmtWrite for Adapter<'_, W> {
    fn write_str(&mut self, s: &str) -> FmtResult {
        match self.inner.write_all(s.as_bytes()) {
            Ok(()) => Ok(()),
            Err(e) => {
                self.err = Some(e);
                Err(FmtErr)
            }
        }
    }
}

impl Write for Vec<u8> {
    #[inline]
    fn write(&mut self, buf: &[u8]) -> Result<usize> {
        self.extend_from_slice(buf);
        Ok(buf.len())
    }

    #[inline]
    fn flush(&mut self) -> Result<()> {
        Ok(())
    }
}

pub trait Seek {
    fn seek(&mut self, pos: SeekFrom) -> Result<u64>;
}

pub trait BufRead: Read {
    fn fill_buf(&mut self) -> Result<&[u8]>;
    fn consume(&mut self, amt: usize);

    #[cold]
    #[inline(never)]
    fn read_line(&mut self, buf: &mut String) -> Result<usize> {
        let mut total = 0;
        loop {
            let (done, used) = {
                let available = self.fill_buf()?;
                if available.is_empty() {
                    return Ok(total);
                }
                let (chunk, done) = available
                    .iter()
                    .position(|&b| b == b'\n')
                    .map_or((available, false), |i| (&available[..=i], true));
                match from_utf8(chunk) {
                    Ok(s) => buf.push_str(s),
                    Err(_) => return Err(invalid_data()),
                }
                (done, chunk.len())
            };
            total += used;
            self.consume(used);
            if done {
                return Ok(total);
            }
        }
    }
}

pub trait IsTerminal {
    fn is_terminal(&self) -> bool;
}

const BUF: usize = 1 << 16;

pub struct BufWriter<W: Write> {
    inner: W,
    buf: Vec<u8>,
}

impl<W: Write> BufWriter<W> {
    #[inline]
    pub fn new(inner: W) -> Self {
        Self {
            inner,
            buf: Vec::with_capacity(BUF),
        }
    }

    fn drain(&mut self) -> Result<()> {
        if !self.buf.is_empty() {
            self.inner.write_all(&self.buf)?;
            self.buf.clear();
        }
        Ok(())
    }
}

impl<W: Write> Write for BufWriter<W> {
    fn write(&mut self, buf: &[u8]) -> Result<usize> {
        if self.buf.len() + buf.len() > BUF {
            self.drain()?;
        }
        if buf.len() >= BUF {
            self.inner.write(buf)
        } else {
            self.buf.extend_from_slice(buf);
            Ok(buf.len())
        }
    }

    fn flush(&mut self) -> Result<()> {
        self.drain()?;
        self.inner.flush()
    }
}

impl<W: Write> Drop for BufWriter<W> {
    fn drop(&mut self) {
        _ = self.drain();
    }
}

pub struct BufReader<R: Read> {
    inner: R,
    buf: Vec<u8>,
    pos: usize,
    cap: usize,
}

impl<R: Read> BufReader<R> {
    #[cold]
    #[inline(never)]
    pub fn new(inner: R) -> Self {
        Self {
            inner,
            buf: vec![0; BUF],
            pos: 0,
            cap: 0,
        }
    }
}

impl<R: Read> Read for BufReader<R> {
    fn read(&mut self, buf: &mut [u8]) -> Result<usize> {
        if self.pos >= self.cap && buf.len() >= self.buf.len() {
            return self.inner.read(buf);
        }
        let available = self.fill_buf()?;
        let n = available.len().min(buf.len());
        buf[..n].copy_from_slice(&available[..n]);
        self.consume(n);
        Ok(n)
    }
}

impl<R: Read> BufRead for BufReader<R> {
    fn fill_buf(&mut self) -> Result<&[u8]> {
        if self.pos >= self.cap {
            self.cap = self.inner.read(&mut self.buf)?;
            self.pos = 0;
        }
        Ok(&self.buf[self.pos..self.cap])
    }

    fn consume(&mut self, amt: usize) {
        self.pos = (self.pos + amt).min(self.cap);
    }
}

#[cfg(target_os = "linux")]
pub struct Stdin;
#[cfg(target_os = "linux")]
pub struct Stdout;
#[cfg(target_os = "linux")]
pub struct Stderr;

#[cfg(target_os = "linux")]
#[inline]
pub const fn stdin() -> Stdin {
    Stdin
}
#[cfg(target_os = "linux")]
#[inline]
pub const fn stdout() -> Stdout {
    Stdout
}
#[cfg(target_os = "linux")]
#[inline]
pub const fn stderr() -> Stderr {
    Stderr
}

#[cfg(target_os = "linux")]
fn write_fd(fd: i32, buf: &[u8]) -> Result<usize> {
    let n = sys_write(fd, buf.as_ptr(), buf.len());
    if n < 0 {
        return Err(Error::from_raw_os_error((-n) as i32));
    }
    Ok(n as usize)
}

#[cfg(target_os = "linux")]
impl Read for Stdin {
    fn read(&mut self, buf: &mut [u8]) -> Result<usize> {
        let n = sys_read(0, buf.as_mut_ptr(), buf.len());
        if n < 0 {
            return Err(Error::from_raw_os_error((-n) as i32));
        }
        Ok(n as usize)
    }
}

#[cfg(target_os = "linux")]
impl Write for Stdout {
    #[inline]
    fn write(&mut self, buf: &[u8]) -> Result<usize> {
        write_fd(1, buf)
    }

    #[inline]
    fn flush(&mut self) -> Result<()> {
        Ok(())
    }
}

#[cfg(target_os = "linux")]
impl Write for Stderr {
    #[inline]
    fn write(&mut self, buf: &[u8]) -> Result<usize> {
        write_fd(2, buf)
    }

    #[inline]
    fn flush(&mut self) -> Result<()> {
        Ok(())
    }
}

#[cfg(target_os = "linux")]
impl IsTerminal for Stdin {
    #[inline]
    fn is_terminal(&self) -> bool {
        isatty(0)
    }
}

#[cfg(target_os = "linux")]
struct Line {
    buf: [MaybeUninit<u8>; 512],
    len: usize,
}

#[cfg(target_os = "linux")]
impl Line {
    fn drain(&mut self) {
        if self.len > 0 {
            sys_write(1, self.buf.as_ptr().cast::<u8>(), self.len);
            self.len = 0;
        }
    }
}

#[cfg(target_os = "linux")]
impl FmtWrite for Line {
    fn write_str(&mut self, s: &str) -> FmtResult {
        let mut b = s.as_bytes();
        while !b.is_empty() {
            let n = (512 - self.len).min(b.len());
            unsafe {
                copy_nonoverlapping(
                    b.as_ptr(),
                    self.buf.as_mut_ptr().add(self.len).cast::<u8>(),
                    n,
                );
            }
            self.len += n;
            b = &b[n..];
            if self.len == 512 {
                self.drain();
            }
        }
        Ok(())
    }
}

#[cfg(target_os = "linux")]
pub fn print_fmt(args: Arguments<'_>) {
    let mut w = Line {
        buf: [MaybeUninit::uninit(); 512],
        len: 0,
    };
    _ = fmt_write(&mut w, args);
    w.drain();
}

#[cfg(target_os = "linux")]
pub fn println_fmt(args: Arguments<'_>) {
    let mut w = Line {
        buf: [MaybeUninit::uninit(); 512],
        len: 0,
    };
    _ = fmt_write(&mut w, args);
    _ = w.write_str("\n");
    w.drain();
}

#[cfg(not(target_os = "linux"))]
pub struct Stdin(StdStdin);
#[cfg(not(target_os = "linux"))]
pub struct Stdout(StdStdout);
#[cfg(not(target_os = "linux"))]
pub struct Stderr(StdStderr);

#[cfg(not(target_os = "linux"))]
#[inline]
pub fn stdin() -> Stdin {
    Stdin(std_stdin())
}
#[cfg(not(target_os = "linux"))]
#[inline]
pub fn stdout() -> Stdout {
    Stdout(std_stdout())
}
#[cfg(not(target_os = "linux"))]
#[inline]
pub fn stderr() -> Stderr {
    Stderr(std_stderr())
}

#[cfg(not(target_os = "linux"))]
impl Read for Stdin {
    fn read(&mut self, buf: &mut [u8]) -> Result<usize> {
        StdRead::read(&mut self.0, buf)
    }
}

#[cfg(not(target_os = "linux"))]
impl Write for Stdout {
    fn write(&mut self, buf: &[u8]) -> Result<usize> {
        StdWrite::write(&mut self.0, buf)
    }

    fn flush(&mut self) -> Result<()> {
        StdWrite::flush(&mut self.0)
    }
}

#[cfg(not(target_os = "linux"))]
impl Write for Stderr {
    fn write(&mut self, buf: &[u8]) -> Result<usize> {
        StdWrite::write(&mut self.0, buf)
    }

    fn flush(&mut self) -> Result<()> {
        StdWrite::flush(&mut self.0)
    }
}

#[cfg(not(target_os = "linux"))]
impl IsTerminal for Stdin {
    fn is_terminal(&self) -> bool {
        StdIsTerminal::is_terminal(&self.0)
    }
}

#[cfg(not(target_os = "linux"))]
pub fn print_fmt(args: Arguments<'_>) {
    let mut o = std_stdout();
    _ = StdWrite::write_fmt(&mut o, args);
}

#[cfg(not(target_os = "linux"))]
pub fn println_fmt(args: Arguments<'_>) {
    let mut o = std_stdout();
    _ = StdWrite::write_fmt(&mut o, args);
    _ = StdWrite::write_all(&mut o, b"\n");
}

#[cfg(not(target_os = "linux"))]
impl Read for StdFile {
    fn read(&mut self, buf: &mut [u8]) -> Result<usize> {
        StdRead::read(self, buf)
    }
}

#[cfg(not(target_os = "linux"))]
impl Write for StdFile {
    fn write(&mut self, buf: &[u8]) -> Result<usize> {
        StdWrite::write(self, buf)
    }

    fn flush(&mut self) -> Result<()> {
        StdWrite::flush(self)
    }
}

#[cfg(not(target_os = "linux"))]
impl Seek for StdFile {
    fn seek(&mut self, pos: SeekFrom) -> Result<u64> {
        StdSeek::seek(self, pos)
    }
}

#[cfg(not(target_os = "linux"))]
impl Write for StdChildStdin {
    fn write(&mut self, buf: &[u8]) -> Result<usize> {
        StdWrite::write(self, buf)
    }

    fn flush(&mut self) -> Result<()> {
        StdWrite::flush(self)
    }
}

#[cfg(not(target_os = "linux"))]
impl Read for StdChildStdout {
    fn read(&mut self, buf: &mut [u8]) -> Result<usize> {
        StdRead::read(self, buf)
    }
}

#[cfg(not(target_os = "linux"))]
impl Read for StdChildStderr {
    fn read(&mut self, buf: &mut [u8]) -> Result<usize> {
        StdRead::read(self, buf)
    }
}
