use core::ffi::c_void;
use std::{
    fs::{File, OpenOptions},
    os::unix::io::AsRawFd as _,
    path::Path,
    ptr::null_mut,
    slice::{from_raw_parts, from_raw_parts_mut},
};

use crate::{error::Xerr, mkv_mux::Mux, progs::ProgsBar};

const PROT_READ: i32 = 1;
const PROT_WRITE: i32 = 2;
const MAP_SHARED: i32 = 1;
const MAP_PRIVATE: i32 = 2;
const MADV_SEQUENTIAL: i32 = 2;

unsafe extern "C" {
    fn mmap(addr: *mut c_void, len: usize, prot: i32, flags: i32, fd: i32, off: i64) -> *mut c_void;
    fn munmap(addr: *mut c_void, len: usize) -> i32;
    fn madvise(addr: *mut c_void, len: usize, advice: i32) -> i32;
}

pub struct Mmap {
    ptr: *const u8,
    len: usize,
}

impl Mmap {
    pub fn open(path: &Path) -> Result<Self, Xerr> {
        let f = File::open(path)?;
        let len = f.metadata()?.len() as usize;
        let ptr = unsafe { mmap(null_mut(), len, PROT_READ, MAP_PRIVATE, f.as_raw_fd(), 0) };
        if (ptr as isize) < 0 {
            return Err("mmap (input chunk) failed".into());
        }
        Ok(Self {
            ptr: ptr.cast(),
            len,
        })
    }

    #[inline]
    pub const fn slice(&self) -> &[u8] {
        unsafe { from_raw_parts(self.ptr, self.len) }
    }

    #[inline]
    fn advise(&self, advice: i32) {
        unsafe { madvise(self.ptr.cast_mut().cast(), self.len, advice) };
    }
}

impl Drop for Mmap {
    fn drop(&mut self) {
        unsafe { munmap(self.ptr.cast_mut().cast(), self.len) };
    }
}

unsafe impl Sync for Mmap {}

#[inline]
pub fn write_mux(out: &Path, mux: &Mux, progs: &mut ProgsBar) -> Result<(), Xerr> {
    let f = OpenOptions::new()
        .read(true)
        .write(true)
        .create(true)
        .truncate(true)
        .open(out)?;
    let file_size = mux.lay.file_size;
    f.set_len(file_size)?;
    let size = file_size as usize;
    let mptr = unsafe {
        mmap(
            null_mut(),
            size,
            PROT_READ | PROT_WRITE,
            MAP_SHARED,
            f.as_raw_fd(),
            0,
        )
    };
    if (mptr as isize) < 0 {
        return Err("mmap (output) failed".into());
    }
    for m in mux.maps {
        m.advise(MADV_SEQUENTIAL);
    }
    let dst = unsafe { from_raw_parts_mut(mptr.cast::<u8>(), size) };
    mux.build(dst, progs);
    unsafe { munmap(mptr, size) };
    Ok(())
}
