use alloc::{ffi::CString, vec::Vec};
use core::{
    arch::x86_64::_mm_sfence,
    mem::zeroed,
    ptr::null_mut,
    slice::{from_raw_parts, from_raw_parts_mut},
};

use crate::{
    error::Xerr,
    fs::{File, OpenOptions},
    mkv_mux::Mux,
    path::Path,
    progs::ProgsBar,
    sys::{
        MADV_HUGEPAGE, MADV_SEQUENTIAL, MAP_PRIVATE, MAP_SHARED, PROT_READ, PROT_WRITE, Statfs,
        madvise, mmap, munmap, statfs,
    },
    uring::RingWriter,
};

pub struct Mmap {
    ptr: *const u8,
    len: usize,
}

impl Mmap {
    pub fn open(path: &Path) -> Result<Self, Xerr> {
        let f = File::open(path)?;
        let len = f.size()? as usize;
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

const TMPFS_MAGIC: i64 = 0x0102_1994;
const RAMFS_MAGIC: i64 = 0x8584_58f6;

enum Dev {
    Ram,
    Disk,
}

// anon-bdev fs has no /sys/dev/block entry
fn classify(path: &Path) -> Result<Dev, Xerr> {
    let dir = path
        .parent()
        .filter(|p| !p.as_bytes().is_empty())
        .unwrap_or_else(|| Path::new("."));
    let c = CString::new(dir.as_bytes())?;
    let ram = unsafe {
        let mut sf: Statfs = zeroed();
        if statfs(c.as_ptr(), &raw mut sf) != 0 {
            return Err(format!("statfs failed for {}", dir.display()).into());
        }
        matches!(sf.f_type, TMPFS_MAGIC | RAMFS_MAGIC)
    };
    Ok(if ram { Dev::Ram } else { Dev::Disk })
}

#[inline]
pub fn write_mux(out: &Path, mux: &Mux, progs: &mut ProgsBar) -> Result<(), Xerr> {
    match classify(out)? {
        Dev::Ram => mmap_write(out, mux, progs),
        Dev::Disk => ring_write(out, mux, progs),
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

    let mut segs: Vec<Seg> = Vec::new();
    let mut c0 = 0usize;
    let mut acc = 0usize;
    let mut frames = 0usize;
    for (ci, p) in mux.plans.iter().enumerate() {
        acc += p.size;
        frames += unsafe { mux.clusters.get_unchecked(ci) }.len();
        if acc >= SEG_BYTES {
            segs.push(Seg {
                c0,
                c1: ci + 1,
                bytes: acc,
                frames,
            });
            c0 = ci + 1;
            acc = 0;
            frames = 0;
        }
    }
    if c0 < mux.plans.len() {
        segs.push(Seg {
            c0,
            c1: mux.plans.len(),
            bytes: acc,
            frames,
        });
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

struct Seg {
    c0: usize,
    c1: usize,
    bytes: usize,
    frames: usize,
}

fn ring_segments<const HAS_SUBS: bool, const IS_NAL: bool>(
    mux: &Mux,
    w: &mut RingWriter,
    segs: &[Seg],
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
            // ui >= 1 so ui-1 indexes segs; bytes <= cap
            let sg = unsafe { segs.get_unchecked(ui - 1) };
            mux.build_clusters::<HAS_SUBS, IS_NAL>(
                unsafe { buf.get_unchecked_mut(..sg.bytes) },
                sg.c0,
                sg.c1,
                None,
            );
            sg.bytes
        };
        unsafe { _mm_sfence() };
        w.submit(idx, off, len as u32)?;
        off += len as u64;
        if ui > 0 {
            done += unsafe { segs.get_unchecked(ui - 1) }.frames;
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
    if (mptr as isize) < 0 {
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
