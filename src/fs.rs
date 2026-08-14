#[cfg(target_os = "linux")]
use alloc::{string::String, vec::Vec};
#[cfg(target_os = "linux")]
use core::mem::MaybeUninit;

#[cfg(target_os = "linux")]
use crate::io::{Error, Read, Result, Write};
#[cfg(all(target_os = "linux", feature = "vship"))]
use crate::sys::copy_file_range;
#[cfg(target_os = "linux")]
use crate::{
    path::{Path, PathBuf},
    sys::{
        AT_REMOVEDIR, O_APPEND, O_CLOEXEC, O_CREAT, O_DIRECTORY, O_RDONLY, O_RDWR, O_TRUNC,
        O_WRONLY, Stat, close, fstat, ftruncate, getdents64, mkdirat, newfstatat, openat,
        read as sys_read, readlinkat, unlinkat, write as sys_write,
    },
};

#[cfg(target_os = "linux")]
const EEXIST: i32 = 17;
#[cfg(target_os = "linux")]
const DT_DIR: u8 = 4;
#[cfg(target_os = "linux")]
const S_IFMT: u32 = 0o170_000;
#[cfg(target_os = "linux")]
const S_IFDIR: u32 = 0o040_000;

#[cfg(target_os = "linux")]
const fn err<T>(ret: i64) -> Result<T> {
    Err(Error::from_raw_os_error((-ret) as i32))
}

#[cfg(target_os = "linux")]
pub struct File {
    fd: i32,
}

#[cfg(target_os = "linux")]
impl File {
    #[inline]
    pub fn open<P: AsRef<Path>>(path: P) -> Result<Self> {
        Self::opts(path.as_ref(), O_RDONLY | O_CLOEXEC, 0)
    }

    #[inline]
    pub fn create<P: AsRef<Path>>(path: P) -> Result<Self> {
        Self::opts(
            path.as_ref(),
            O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC,
            0o644,
        )
    }

    fn opts(path: &Path, flags: i32, mode: u32) -> Result<Self> {
        let fd = path.with_cstr(|p| openat(p, flags, mode));
        if fd < 0 {
            return err(i64::from(fd));
        }
        Ok(Self { fd })
    }

    pub fn set_len(&self, len: u64) -> Result<()> {
        let r = ftruncate(self.fd, len as i64);
        if r < 0 {
            return err(i64::from(r));
        }
        Ok(())
    }

    pub fn size(&self) -> Result<u64> {
        let mut st = MaybeUninit::<Stat>::uninit();
        let r = fstat(self.fd, st.as_mut_ptr());
        if r < 0 {
            return err(i64::from(r));
        }
        Ok(unsafe { (*st.as_ptr()).st_size } as u64)
    }

    #[inline]
    pub const fn as_raw_fd(&self) -> i32 {
        self.fd
    }
}

#[cfg(target_os = "linux")]
impl Read for File {
    fn read(&mut self, buf: &mut [u8]) -> Result<usize> {
        let n = sys_read(self.fd, buf.as_mut_ptr(), buf.len());
        if n < 0 {
            return err(n as i64);
        }
        Ok(n as usize)
    }
}

#[cfg(target_os = "linux")]
impl Write for File {
    fn write(&mut self, buf: &[u8]) -> Result<usize> {
        let n = sys_write(self.fd, buf.as_ptr(), buf.len());
        if n < 0 {
            return err(n as i64);
        }
        Ok(n as usize)
    }

    #[inline]
    fn flush(&mut self) -> Result<()> {
        Ok(())
    }
}

#[cfg(target_os = "linux")]
impl Drop for File {
    #[inline]
    fn drop(&mut self) {
        unsafe { close(self.fd) };
    }
}

#[cfg(target_os = "linux")]
const OPT_READ: u8 = 1;
#[cfg(target_os = "linux")]
const OPT_WRITE: u8 = 2;
#[cfg(target_os = "linux")]
const OPT_APPEND: u8 = 4;
#[cfg(target_os = "linux")]
const OPT_CREATE: u8 = 8;
#[cfg(target_os = "linux")]
const OPT_TRUNC: u8 = 16;

#[cfg(target_os = "linux")]
#[derive(Default)]
pub struct OpenOptions(u8);

#[cfg(target_os = "linux")]
impl OpenOptions {
    #[inline]
    pub const fn new() -> Self {
        Self(0)
    }

    #[inline]
    pub const fn read(&mut self, v: bool) -> &mut Self {
        if v {
            self.0 |= OPT_READ;
        } else {
            self.0 &= !OPT_READ;
        }
        self
    }

    #[inline]
    pub const fn write(&mut self, v: bool) -> &mut Self {
        if v {
            self.0 |= OPT_WRITE;
        } else {
            self.0 &= !OPT_WRITE;
        }
        self
    }

    #[cfg(feature = "vship")]
    #[inline]
    pub const fn append(&mut self, v: bool) -> &mut Self {
        if v {
            self.0 |= OPT_APPEND;
        } else {
            self.0 &= !OPT_APPEND;
        }
        self
    }

    #[inline]
    pub const fn create(&mut self, v: bool) -> &mut Self {
        if v {
            self.0 |= OPT_CREATE;
        } else {
            self.0 &= !OPT_CREATE;
        }
        self
    }

    #[inline]
    pub const fn truncate(&mut self, v: bool) -> &mut Self {
        if v {
            self.0 |= OPT_TRUNC;
        } else {
            self.0 &= !OPT_TRUNC;
        }
        self
    }

    pub fn open<P: AsRef<Path>>(&self, path: P) -> Result<File> {
        let w = (self.0 & (OPT_WRITE | OPT_APPEND)) != 0;
        let mut flags = O_CLOEXEC
            | match ((self.0 & OPT_READ) != 0, w) {
                (true, true) => O_RDWR,
                (false, true) => O_WRONLY,
                _ => O_RDONLY,
            };
        if (self.0 & OPT_APPEND) != 0 {
            flags |= O_APPEND;
        }
        if (self.0 & OPT_CREATE) != 0 {
            flags |= O_CREAT;
        }
        if (self.0 & OPT_TRUNC) != 0 {
            flags |= O_TRUNC;
        }
        File::opts(path.as_ref(), flags, 0o644)
    }
}

#[cfg(target_os = "linux")]
pub struct DirEntry {
    path: PathBuf,
    ftype: u8,
}

#[cfg(target_os = "linux")]
impl DirEntry {
    #[inline]
    pub fn path(&self) -> PathBuf {
        self.path.clone()
    }

    fn is_dir(&self) -> bool {
        if self.ftype == DT_DIR {
            return true;
        }
        if self.ftype != 0 {
            return false;
        }
        let mut st = MaybeUninit::<Stat>::uninit();
        let r = self.path.with_cstr(|p| newfstatat(p, st.as_mut_ptr()));
        r == 0 && unsafe { (*st.as_ptr()).st_mode } & S_IFMT == S_IFDIR
    }
}

#[cfg(target_os = "linux")]
pub struct ReadDir {
    fd: i32,
    base: PathBuf,
    buf: [u8; 4096],
    len: usize,
    pos: usize,
}

#[cfg(target_os = "linux")]
impl Iterator for ReadDir {
    type Item = Result<DirEntry>;

    fn next(&mut self) -> Option<Result<DirEntry>> {
        loop {
            if self.pos >= self.len {
                let n = getdents64(self.fd, self.buf.as_mut_ptr(), self.buf.len());
                if n < 0 {
                    return Some(err(n as i64));
                }
                if n == 0 {
                    return None;
                }
                self.len = n as usize;
                self.pos = 0;
            }
            let p = self.pos;
            let reclen = u16::from_le_bytes([self.buf[p + 16], self.buf[p + 17]]) as usize;
            let ftype = self.buf[p + 18];
            self.pos = p + reclen;
            let raw = &self.buf[p + 19..p + reclen];
            let name = &raw[..raw.iter().position(|&c| c == 0).unwrap_or(raw.len())];
            if name == b"." || name == b".." {
                continue;
            }
            let mut path = self.base.clone();
            path.push(Path::from_bytes(name));
            return Some(Ok(DirEntry { path, ftype }));
        }
    }
}

#[cfg(target_os = "linux")]
impl Drop for ReadDir {
    #[inline]
    fn drop(&mut self) {
        unsafe { close(self.fd) };
    }
}

#[cfg(target_os = "linux")]
pub fn read<P: AsRef<Path>>(path: P) -> Result<Vec<u8>> {
    let mut f = File::open(path)?;
    let mut v = Vec::with_capacity(f.size().unwrap_or(0) as usize + 1);
    f.read_to_end(&mut v)?;
    Ok(v)
}

#[cfg(target_os = "linux")]
pub fn read_to_string<P: AsRef<Path>>(path: P) -> Result<String> {
    let mut f = File::open(path)?;
    let mut s = String::new();
    f.read_to_string(&mut s)?;
    Ok(s)
}

#[cfg(target_os = "linux")]
pub fn write<P: AsRef<Path>, D: AsRef<[u8]>>(path: P, data: D) -> Result<()> {
    let mut f = File::create(path)?;
    f.write_all(data.as_ref())
}

#[cfg(all(target_os = "linux", feature = "vship"))]
pub fn copy<P: AsRef<Path>, Q: AsRef<Path>>(from: P, to: Q) -> Result<u64> {
    let src = File::open(from)?;
    let dst = File::create(to)?;
    let len = src.size()?;
    let mut copied = 0;
    while copied < len {
        let n = copy_file_range(src.fd, dst.fd, (len - copied) as usize);
        if n < 0 {
            return err(n as i64);
        }
        if n == 0 {
            break;
        }
        copied += n as u64;
    }
    Ok(copied)
}

#[cfg(target_os = "linux")]
#[cold]
#[inline(never)]
pub fn read_link<P: AsRef<Path>>(path: P) -> Result<PathBuf> {
    let mut buf = [0u8; 4096];
    let n = path
        .as_ref()
        .with_cstr(|p| readlinkat(p, buf.as_mut_ptr(), 4096));
    if n < 0 {
        return err(n as i64);
    }
    Ok(Path::from_bytes(&buf[..n as usize]).to_path_buf())
}

#[cfg(target_os = "linux")]
pub fn metadata<P: AsRef<Path>>(path: P) -> Result<u64> {
    let mut st = MaybeUninit::<Stat>::uninit();
    let r = path.as_ref().with_cstr(|p| newfstatat(p, st.as_mut_ptr()));
    if r < 0 {
        return err(i64::from(r));
    }
    Ok(unsafe { (*st.as_ptr()).st_size } as u64)
}

#[cfg(target_os = "linux")]
fn mkdir_one(prefix: &[u8]) -> Result<()> {
    let r = Path::from_bytes(prefix).with_cstr(|p| mkdirat(p, 0o755));
    if r < 0 && r != -EEXIST {
        return err(i64::from(r));
    }
    Ok(())
}

#[cfg(target_os = "linux")]
pub fn create_dir_all<P: AsRef<Path>>(path: P) -> Result<()> {
    let b = path.as_ref().as_bytes();
    let mut i = 1;
    while i < b.len() {
        if b[i] == b'/' {
            mkdir_one(&b[..i])?;
        }
        i += 1;
    }
    if !b.is_empty() && b.last() != Some(&b'/') {
        mkdir_one(b)?;
    }
    Ok(())
}

#[cfg(target_os = "linux")]
pub fn remove_file<P: AsRef<Path>>(path: P) -> Result<()> {
    let r = path.as_ref().with_cstr(|p| unlinkat(p, 0));
    if r < 0 {
        return err(i64::from(r));
    }
    Ok(())
}

#[cfg(target_os = "linux")]
#[cold]
#[inline(never)]
pub fn remove_dir_all<P: AsRef<Path>>(path: P) -> Result<()> {
    rm_dir_all(path.as_ref())
}

#[cfg(target_os = "linux")]
#[cold]
#[inline(never)]
fn rm_dir_all(path: &Path) -> Result<()> {
    for entry in read_dir(path)? {
        let entry = entry?;
        let p = entry.path();
        if entry.is_dir() {
            rm_dir_all(&p)?;
        } else {
            let r = p.with_cstr(|q| unlinkat(q, 0));
            if r < 0 {
                return err(i64::from(r));
            }
        }
    }
    let r = path.with_cstr(|q| unlinkat(q, AT_REMOVEDIR));
    if r < 0 {
        return err(i64::from(r));
    }
    Ok(())
}

#[cfg(target_os = "linux")]
#[cold]
#[inline(never)]
pub fn read_dir<P: AsRef<Path>>(path: P) -> Result<ReadDir> {
    let path = path.as_ref();
    let fd = path.with_cstr(|p| openat(p, O_RDONLY | O_DIRECTORY | O_CLOEXEC, 0));
    if fd < 0 {
        return err(i64::from(fd));
    }
    Ok(ReadDir {
        fd,
        base: path.to_path_buf(),
        buf: [0; 4096],
        len: 0,
        pos: 0,
    })
}

#[cfg(not(target_os = "linux"))]
use std::fs::{
    copy as std_copy, create_dir_all as std_create_dir_all, metadata as std_metadata,
    read as std_read, read_dir as std_read_dir, read_link as std_read_link,
    read_to_string as std_read_to_string, remove_dir_all as std_remove_dir_all,
    remove_file as std_remove_file, write as std_write,
};
#[cfg(not(target_os = "linux"))]
use std::path::{Path, PathBuf};

#[cfg(not(target_os = "linux"))]
use crate::Result;

#[cfg(not(target_os = "linux"))]
pub type File = std::fs::File;
#[cfg(not(target_os = "linux"))]
pub type OpenOptions = std::fs::OpenOptions;
#[cfg(not(target_os = "linux"))]
pub type ReadDir = std::fs::ReadDir;
#[cfg(not(target_os = "linux"))]
pub type DirEntry = std::fs::DirEntry;

#[cfg(not(target_os = "linux"))]
pub fn read<P: AsRef<Path>>(path: P) -> Result<Vec<u8>> {
    std_read(path)
}

#[cfg(not(target_os = "linux"))]
pub fn read_to_string<P: AsRef<Path>>(path: P) -> Result<String> {
    std_read_to_string(path)
}

#[cfg(not(target_os = "linux"))]
pub fn write<P: AsRef<Path>, D: AsRef<[u8]>>(path: P, data: D) -> Result<()> {
    std_write(path, data)
}

#[cfg(all(not(target_os = "linux"), feature = "vship"))]
pub fn copy<P: AsRef<Path>, Q: AsRef<Path>>(from: P, to: Q) -> Result<u64> {
    std_copy(from, to)
}

#[cfg(not(target_os = "linux"))]
pub fn read_link<P: AsRef<Path>>(path: P) -> Result<PathBuf> {
    std_read_link(path)
}

#[cfg(not(target_os = "linux"))]
pub fn metadata<P: AsRef<Path>>(path: P) -> Result<u64> {
    std_metadata(path).map(|m| m.len())
}

#[cfg(not(target_os = "linux"))]
pub fn create_dir_all<P: AsRef<Path>>(path: P) -> Result<()> {
    std_create_dir_all(path)
}

#[cfg(not(target_os = "linux"))]
pub fn remove_file<P: AsRef<Path>>(path: P) -> Result<()> {
    std_remove_file(path)
}

#[cfg(not(target_os = "linux"))]
pub fn remove_dir_all<P: AsRef<Path>>(path: P) -> Result<()> {
    std_remove_dir_all(path)
}

#[cfg(not(target_os = "linux"))]
pub fn read_dir<P: AsRef<Path>>(path: P) -> Result<ReadDir> {
    std_read_dir(path)
}
