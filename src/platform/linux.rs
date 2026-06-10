use std::{
    arch::x86_64::_mm_sfence,
    ffi::CString,
    fs::{File, OpenOptions, read_link},
    mem::zeroed,
    os::unix::{ffi::OsStrExt as _, io::AsRawFd as _},
    path::Path,
    ptr::null_mut,
    slice::{from_raw_parts, from_raw_parts_mut},
};

use libc::{
    MADV_HUGEPAGE, MADV_SEQUENTIAL, MAP_FAILED, MAP_PRIVATE, MAP_SHARED, PROT_READ, PROT_WRITE,
    madvise, major, minor, mmap, munmap, stat, statfs,
};

use crate::{error::Xerr, mkv_mux::Mux, progs::ProgsBar, uring::RingWriter};

pub struct Mmap {
    ptr: *const u8,
    len: usize,
}

impl Mmap {
    pub fn open(path: &Path) -> Result<Self, Xerr> {
        let f = File::open(path)?;
        let len = f.metadata()?.len() as usize;
        let ptr = unsafe { mmap(null_mut(), len, PROT_READ, MAP_PRIVATE, f.as_raw_fd(), 0) };
        if ptr == MAP_FAILED {
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

const TMPFS_MAGIC: i64 = 0x0102_1994;
const RAMFS_MAGIC: i64 = 0x8584_58f6;

enum Dev {
    Ram,
    Nvme,
    Disk,
}

fn classify(path: &Path) -> Result<Dev, Xerr> {
    let dir = path
        .parent()
        .filter(|p| !p.as_os_str().is_empty())
        .unwrap_or_else(|| Path::new("."));
    let c = CString::new(dir.as_os_str().as_bytes())?;
    let st_dev = unsafe {
        let mut sf: statfs = zeroed();
        if statfs(c.as_ptr(), &raw mut sf) != 0 {
            return Err(format!("statfs failed for {}", dir.display()).into());
        }
        if matches!(sf.f_type, TMPFS_MAGIC | RAMFS_MAGIC) {
            return Ok(Dev::Ram);
        }
        let mut st: stat = zeroed();
        if stat(c.as_ptr(), &raw mut st) != 0 {
            return Err(format!("stat failed for {}", dir.display()).into());
        }
        st.st_dev
    };
    let link = format!("/sys/dev/block/{}:{}", major(st_dev), minor(st_dev));
    let target =
        read_link(&link).map_err(|e| format!("cannot resolve block device {link}: {e}"))?;
    Ok(if target.to_str().is_some_and(|s| s.contains("nvme")) {
        Dev::Nvme
    } else {
        Dev::Disk
    })
}

#[inline]
pub fn write_mux(out: &Path, mux: &Mux, progs: &mut ProgsBar) -> Result<(), Xerr> {
    match classify(out)? {
        Dev::Ram => mmap_write(out, mux, progs),
        Dev::Nvme | Dev::Disk => ring_write(out, mux, progs),
    }
}

const SEG_BYTES: usize = 64 << 20;
const RING_BUFS: usize = 3;

fn ring_write(out: &Path, mux: &Mux, progs: &mut ProgsBar) -> Result<(), Xerr> {
    let file = OpenOptions::new()
        .write(true)
        .create(true)
        .truncate(true)
        .open(out)?;
    let file_size = mux.lay.file_size;
    let cluster_bytes: u64 = mux.plans.iter().map(|p| p.size as u64).sum();
    let header_len = (file_size - cluster_bytes) as usize;
    let max_cluster = mux.plans.iter().map(|p| p.size).max().unwrap_or(0);
    let cap = (SEG_BYTES + max_cluster).max(header_len);

    let mut segs: Vec<(usize, usize)> = Vec::new();
    let mut c0 = 0usize;
    let mut acc = 0usize;
    for (ci, p) in mux.plans.iter().enumerate() {
        acc += p.size;
        if acc >= SEG_BYTES {
            segs.push((c0, ci + 1));
            c0 = ci + 1;
            acc = 0;
        }
    }
    if c0 < mux.plans.len() {
        segs.push((c0, mux.plans.len()));
    }

    let mut w = RingWriter::new(file.as_raw_fd(), RING_BUFS, cap)?;
    let total: usize = mux.clusters.iter().map(|c| c.len()).sum();

    match (mux.subs_empty(), mux.is_nal) {
        (true, false) => ring_segments::<false, false>(mux, &mut w, &segs, total, progs)?,
        (false, false) => ring_segments::<true, false>(mux, &mut w, &segs, total, progs)?,
        (true, true) => ring_segments::<false, true>(mux, &mut w, &segs, total, progs)?,
        (false, true) => ring_segments::<true, true>(mux, &mut w, &segs, total, progs)?,
    }
    w.drain()?;
    Ok(())
}

fn ring_segments<const HAS_SUBS: bool, const IS_NAL: bool>(
    mux: &Mux,
    w: &mut RingWriter,
    segs: &[(usize, usize)],
    total: usize,
    progs: &mut ProgsBar,
) -> Result<(), Xerr> {
    let mut off = 0u64;
    let mut done = 0usize;
    for ui in 0..=segs.len() {
        let idx = w.acquire()?;
        let buf = w.buf_mut(idx);
        let len = if ui == 0 {
            mux.write_headers(buf)
        } else {
            // ui in 1..=segs.len() so ui-1 indexes segs; (c0,c1) valid plan;
            // seg <= cap (buffer holds one SEG_BYTES batch + one max cluster)
            let (c0, c1) = unsafe { *segs.get_unchecked(ui - 1) };
            let seg: usize = unsafe { mux.plans.get_unchecked(c0..c1) }
                .iter()
                .map(|p| p.size)
                .sum();
            mux.build_clusters::<HAS_SUBS, IS_NAL>(
                unsafe { buf.get_unchecked_mut(..seg) },
                c0,
                c1,
                None,
            );
            seg
        };
        unsafe { _mm_sfence() };
        w.submit(idx, off, len as u32)?;
        off += len as u64;
        if ui > 0 {
            let (c0, c1) = unsafe { *segs.get_unchecked(ui - 1) };
            done += unsafe { mux.clusters.get_unchecked(c0..c1) }
                .iter()
                .map(|c| c.len())
                .sum::<usize>();
            progs.up_frames(done, total, 0, "MUX");
        }
    }
    Ok(())
}

fn mmap_write(out: &Path, mux: &Mux, progs: &mut ProgsBar) -> Result<(), Xerr> {
    let f = OpenOptions::new()
        .read(true)
        .write(true)
        .create(true)
        .truncate(true)
        .open(out)?;
    let file_size = mux.lay.file_size;
    f.set_len(file_size)?;
    let fd = f.as_raw_fd();
    let size = file_size as usize;
    let mptr = unsafe { mmap(null_mut(), size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0) };
    if mptr == MAP_FAILED {
        return Err("mmap (output) failed".into());
    }
    unsafe { madvise(mptr, size, MADV_HUGEPAGE) };
    for m in mux.maps {
        m.advise(MADV_SEQUENTIAL);
    }
    let dst = unsafe { from_raw_parts_mut(mptr.cast::<u8>(), size) };
    mux.build(dst, progs);
    unsafe {
        _mm_sfence();
        munmap(mptr, size);
    }
    Ok(())
}
