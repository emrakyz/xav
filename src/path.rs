#[cfg(target_os = "linux")]
use alloc::{borrow::Cow, string::String, vec::Vec};
#[cfg(target_os = "linux")]
use core::{
    fmt::{self, Display, Formatter},
    hash::{Hash, Hasher},
    mem::MaybeUninit,
    ops::Deref,
    ptr::{copy_nonoverlapping, from_ref},
    str::from_utf8,
};

#[cfg(target_os = "linux")]
use crate::{
    error::Xerr,
    sys::{O_CLOEXEC, close, faccessat, openat, readlinkat},
};

#[cfg(target_os = "linux")]
const O_PATH: i32 = 0o10_000_000;
#[cfg(target_os = "linux")]
const CBUF: usize = 4096;

#[cfg(target_os = "linux")]
#[repr(transparent)]
pub struct Path([u8]);

#[cfg(target_os = "linux")]
#[derive(Clone, Default, PartialEq, Eq, Hash)]
pub struct PathBuf(Vec<u8>);

#[cfg(not(target_os = "linux"))]
pub type Path = std::path::Path;
#[cfg(not(target_os = "linux"))]
pub type PathBuf = std::path::PathBuf;

#[cfg(target_os = "linux")]
fn split_name(b: &[u8]) -> Option<&[u8]> {
    if b.is_empty() {
        return None;
    }
    let start = b.iter().rposition(|&c| c == b'/').map_or(0, |i| i + 1);
    let name = &b[start..];
    if name.is_empty() || name == b".." || name == b"." {
        None
    } else {
        Some(name)
    }
}

#[cfg(target_os = "linux")]
fn dot_pos(name: &[u8]) -> Option<usize> {
    name.iter().rposition(|&c| c == b'.').filter(|&i| i != 0)
}

#[cfg(target_os = "linux")]
impl Path {
    #[inline]
    pub const fn from_bytes(b: &[u8]) -> &Self {
        unsafe { &*(from_ref::<[u8]>(b) as *const Self) }
    }

    #[inline]
    pub const fn new(s: &str) -> &Self {
        Self::from_bytes(s.as_bytes())
    }

    #[inline]
    pub const fn as_bytes(&self) -> &[u8] {
        &self.0
    }

    pub fn file_name(&self) -> Option<&Self> {
        split_name(&self.0).map(Self::from_bytes)
    }

    pub fn file_stem(&self) -> Option<&Self> {
        split_name(&self.0).map(|n| Self::from_bytes(&n[..dot_pos(n).unwrap_or(n.len())]))
    }

    pub fn extension(&self) -> Option<&Self> {
        let n = split_name(&self.0)?;
        dot_pos(n).map(|i| Self::from_bytes(&n[i + 1..]))
    }

    pub fn parent(&self) -> Option<&Self> {
        let i = self.0.iter().rposition(|&c| c == b'/')?;
        Some(Self::from_bytes(if i == 0 { b"/" } else { &self.0[..i] }))
    }

    pub fn join<P: AsRef<Self>>(&self, p: P) -> PathBuf {
        let mut buf = self.to_path_buf();
        buf.push(p);
        buf
    }

    pub fn with_file_name<S: AsRef<str>>(&self, name: S) -> PathBuf {
        let mut v = self.parent().map_or_else(Vec::new, |p| {
            let mut v = p.0.to_vec();
            if v.last() != Some(&b'/') {
                v.push(b'/');
            }
            v
        });
        v.extend_from_slice(name.as_ref().as_bytes());
        PathBuf(v)
    }

    pub fn with_extension(&self, ext: &str) -> PathBuf {
        let n = split_name(&self.0).unwrap_or(&self.0);
        let stem = &n[..dot_pos(n).unwrap_or(n.len())];
        let base = self.0.len() - n.len();
        let mut v = self.0[..base].to_vec();
        v.extend_from_slice(stem);
        v.push(b'.');
        v.extend_from_slice(ext.as_bytes());
        PathBuf(v)
    }

    #[inline]
    pub fn to_str(&self) -> Option<&str> {
        from_utf8(&self.0).ok()
    }

    #[inline]
    pub fn to_string_lossy(&self) -> Cow<'_, str> {
        String::from_utf8_lossy(&self.0)
    }

    #[inline]
    pub fn to_path_buf(&self) -> PathBuf {
        PathBuf(self.0.to_vec())
    }

    #[inline]
    pub const fn display(&self) -> Disp<'_> {
        Disp(self)
    }

    pub fn with_cstr<R, F: FnOnce(*const u8) -> R>(&self, f: F) -> R {
        let b = &self.0;
        let n = b.len();
        if n < CBUF {
            let mut buf = [MaybeUninit::<u8>::uninit(); CBUF];
            unsafe {
                copy_nonoverlapping(b.as_ptr(), buf.as_mut_ptr().cast::<u8>(), n);
                buf[n].write(0);
                f(buf.as_ptr().cast::<u8>())
            }
        } else {
            let mut v = Vec::with_capacity(n + 1);
            v.extend_from_slice(b);
            v.push(0);
            f(v.as_ptr())
        }
    }

    pub fn exists(&self) -> bool {
        self.with_cstr(|p| faccessat(p) == 0)
    }

    #[cold]
    #[inline(never)]
    pub fn canonicalize(&self) -> Result<PathBuf, Xerr> {
        let fd = self.with_cstr(|p| openat(p, O_PATH | O_CLOEXEC, 0));
        if fd < 0 {
            return Err("canonicalize: open failed".into());
        }
        let mut link = *b"/proc/self/fd/\0\0\0\0\0\0\0\0\0\0\0\0";
        let mut n = 14;
        let mut d = fd as u32;
        let mut digits = [0u8; 10];
        let mut k = 0;
        loop {
            digits[k] = b'0' + (d % 10) as u8;
            d /= 10;
            k += 1;
            if d == 0 {
                break;
            }
        }
        while k > 0 {
            k -= 1;
            link[n] = digits[k];
            n += 1;
        }
        link[n] = 0;
        let mut buf = [0u8; CBUF];
        let got = readlinkat(link.as_ptr(), buf.as_mut_ptr(), CBUF);
        unsafe { close(fd) };
        if got <= 0 {
            return Err("canonicalize: readlink failed".into());
        }
        Ok(PathBuf(buf[..got as usize].to_vec()))
    }
}

#[cfg(target_os = "linux")]
impl PathBuf {
    #[inline]
    pub const fn new() -> Self {
        Self(Vec::new())
    }

    #[inline]
    pub fn as_path(&self) -> &Path {
        Path::from_bytes(&self.0)
    }

    pub fn push<P: AsRef<Path>>(&mut self, p: P) {
        let p = p.as_ref().as_bytes();
        if p.first() == Some(&b'/') {
            self.0.clear();
        } else if !self.0.is_empty() && self.0.last() != Some(&b'/') {
            self.0.push(b'/');
        }
        self.0.extend_from_slice(p);
    }
}

#[cfg(target_os = "linux")]
impl Deref for PathBuf {
    type Target = Path;

    #[inline]
    fn deref(&self) -> &Path {
        self.as_path()
    }
}

#[cfg(target_os = "linux")]
impl From<&str> for PathBuf {
    #[inline]
    fn from(s: &str) -> Self {
        Self(s.as_bytes().to_vec())
    }
}

#[cfg(target_os = "linux")]
impl From<String> for PathBuf {
    #[inline]
    fn from(s: String) -> Self {
        Self(s.into_bytes())
    }
}

#[cfg(target_os = "linux")]
impl AsRef<Self> for Path {
    #[inline]
    fn as_ref(&self) -> &Self {
        self
    }
}

#[cfg(target_os = "linux")]
impl AsRef<Path> for PathBuf {
    #[inline]
    fn as_ref(&self) -> &Path {
        self.as_path()
    }
}

#[cfg(target_os = "linux")]
impl AsRef<Path> for str {
    #[inline]
    fn as_ref(&self) -> &Path {
        Path::from_bytes(self.as_bytes())
    }
}

#[cfg(target_os = "linux")]
impl AsRef<Path> for String {
    #[inline]
    fn as_ref(&self) -> &Path {
        Path::from_bytes(self.as_bytes())
    }
}

#[cfg(target_os = "linux")]
impl PartialEq for Path {
    #[inline]
    fn eq(&self, other: &Self) -> bool {
        self.0 == other.0
    }
}

#[cfg(target_os = "linux")]
impl Eq for Path {}

#[cfg(target_os = "linux")]
impl PartialEq<str> for Path {
    #[inline]
    fn eq(&self, other: &str) -> bool {
        self.0 == *other.as_bytes()
    }
}

#[cfg(target_os = "linux")]
impl Hash for Path {
    #[inline]
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.0.hash(state);
    }
}

#[cfg(target_os = "linux")]
impl AsRef<[u8]> for Path {
    #[inline]
    fn as_ref(&self) -> &[u8] {
        &self.0
    }
}

#[cfg(target_os = "linux")]
pub struct Disp<'a>(&'a Path);

#[cfg(target_os = "linux")]
impl Display for Disp<'_> {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        f.write_str(&String::from_utf8_lossy(&self.0.0))
    }
}
