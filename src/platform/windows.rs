use std::{
    arch::x86_64::_mm_sfence,
    ffi::c_void,
    iter::once,
    os::windows::ffi::OsStrExt as _,
    path::Path,
    ptr::{null, null_mut},
    slice::{from_raw_parts, from_raw_parts_mut},
};

use crate::{error::Xerr, mkv_mux::Mux, progs::ProgsBar};

type Handle = *mut c_void;
type Hioring = *mut c_void;

const GENERIC_READ: u32 = 0x8000_0000;
const GENERIC_WRITE: u32 = 0x4000_0000;
const FILE_SHARE_READ: u32 = 0x0000_0001;
const FILE_SHARE_DELETE: u32 = 0x0000_0004;
const CREATE_ALWAYS: u32 = 2;
const OPEN_EXISTING: u32 = 3;
const FILE_ATTRIBUTE_NORMAL: u32 = 0x0000_0080;
const PAGE_READONLY: u32 = 0x02;
const PAGE_READWRITE: u32 = 0x04;
const FILE_MAP_READ: u32 = 0x0004;

const MEM_COMMIT: u32 = 0x0000_1000;
const MEM_RESERVE: u32 = 0x0000_2000;
const MEM_RELEASE: u32 = 0x0000_8000;

const IORING_VERSION_4: u32 = 400;
const IORING_REF_RAW: u32 = 0;
const INFINITE: u32 = 0xFFFF_FFFF;

const SEG_BYTES: usize = 64 << 20;
const RING_BUFS: usize = 3;
const STREAM_QD: u32 = 64;

#[repr(C)]
struct IoringCreateFlags {
    required: u32,
    advisory: u32,
}

#[repr(C)]
struct IoringHandleRef {
    kind: u32,
    handle: Handle,
}

#[repr(C)]
struct IoringBufferRef {
    kind: u32,
    address: *mut c_void,
}

#[repr(C)]
struct IoringCqe {
    user_data: usize,
    result_code: i32,
    information: usize,
}

#[link(name = "kernel32")]
unsafe extern "system" {
    fn CreateFileW(
        name: *const u16,
        access: u32,
        share: u32,
        sa: *mut c_void,
        disposition: u32,
        flags: u32,
        template: Handle,
    ) -> Handle;
    fn GetFileSizeEx(file: Handle, size: *mut i64) -> i32;
    fn CreateFileMappingW(
        file: Handle,
        sa: *mut c_void,
        protect: u32,
        max_hi: u32,
        max_lo: u32,
        name: *const u16,
    ) -> Handle;
    fn MapViewOfFile(
        map: Handle,
        access: u32,
        off_hi: u32,
        off_lo: u32,
        bytes: usize,
    ) -> *mut c_void;
    fn UnmapViewOfFile(base: *const c_void) -> i32;
    fn CloseHandle(obj: Handle) -> i32;
    fn GetLastError() -> u32;
    fn VirtualAlloc(addr: *mut c_void, size: usize, kind: u32, protect: u32) -> *mut c_void;
    fn VirtualFree(addr: *mut c_void, size: usize, kind: u32) -> i32;
}

#[link(name = "onecore")]
unsafe extern "system" {
    fn CreateIoRing(
        version: u32,
        flags: IoringCreateFlags,
        sq_size: u32,
        cq_size: u32,
        ring: *mut Hioring,
    ) -> i32;
    fn BuildIoRingWriteFile(
        ring: Hioring,
        file: IoringHandleRef,
        buffer: IoringBufferRef,
        len: u32,
        offset: u64,
        write_flags: u32,
        user_data: usize,
        sqe_flags: u32,
    ) -> i32;
    fn SubmitIoRing(ring: Hioring, wait_ops: u32, ms: u32, submitted: *mut u32) -> i32;
    fn PopIoRingCompletion(ring: Hioring, cqe: *mut IoringCqe) -> i32;
    fn CloseIoRing(ring: Hioring) -> i32;
}

#[inline]
fn wide(path: &Path) -> Vec<u16> {
    path.as_os_str().encode_wide().chain(once(0)).collect()
}

#[inline]
fn invalid(h: Handle) -> bool {
    h as usize == usize::MAX
}

pub struct Mmap {
    view: *const u8,
    len: usize,
    map: Handle,
    file: Handle,
}

impl Mmap {
    pub fn open(path: &Path) -> Result<Self, Xerr> {
        let w = wide(path);
        let file = unsafe {
            CreateFileW(
                w.as_ptr(),
                GENERIC_READ,
                FILE_SHARE_READ | FILE_SHARE_DELETE,
                null_mut(),
                OPEN_EXISTING,
                FILE_ATTRIBUTE_NORMAL,
                null_mut(),
            )
        };
        if invalid(file) {
            let e = unsafe { GetLastError() };
            return Err(format!("CreateFileW (input) failed (error {e})").into());
        }
        let mut len: i64 = 0;
        if unsafe { GetFileSizeEx(file, &raw mut len) } == 0 {
            let e = unsafe { GetLastError() };
            unsafe { CloseHandle(file) };
            return Err(format!("GetFileSizeEx failed (error {e})").into());
        }
        let map = unsafe { CreateFileMappingW(file, null_mut(), PAGE_READONLY, 0, 0, null()) };
        if map.is_null() {
            let e = unsafe { GetLastError() };
            unsafe { CloseHandle(file) };
            return Err(format!("CreateFileMappingW (input) failed (error {e})").into());
        }
        let view = unsafe { MapViewOfFile(map, FILE_MAP_READ, 0, 0, 0) };
        if view.is_null() {
            let e = unsafe { GetLastError() };
            unsafe {
                CloseHandle(map);
                CloseHandle(file);
            }
            return Err(format!("MapViewOfFile (input) failed (error {e})").into());
        }
        Ok(Self {
            view: view.cast(),
            len: len as usize,
            map,
            file,
        })
    }

    #[inline]
    pub const fn slice(&self) -> &[u8] {
        unsafe { from_raw_parts(self.view, self.len) }
    }
}

impl Drop for Mmap {
    fn drop(&mut self) {
        unsafe {
            UnmapViewOfFile(self.view.cast());
            CloseHandle(self.map);
            CloseHandle(self.file); // delete-on-close temporaries gone
        }
    }
}

unsafe impl Sync for Mmap {}

struct Buf {
    ptr: *mut u8,
    cap: usize,
}

impl Buf {
    fn new(cap: usize) -> Result<Self, Xerr> {
        let ptr =
            unsafe { VirtualAlloc(null_mut(), cap, MEM_RESERVE | MEM_COMMIT, PAGE_READWRITE) };
        if ptr.is_null() {
            let e = unsafe { GetLastError() };
            return Err(format!("VirtualAlloc (write buffer) failed (error {e})").into());
        }
        Ok(Self {
            ptr: ptr.cast(),
            cap,
        })
    }
}

impl Drop for Buf {
    fn drop(&mut self) {
        unsafe { VirtualFree(self.ptr.cast(), 0, MEM_RELEASE) };
    }
}

struct Slot {
    off: u64,
    len: u32,
    acked: u32,
}

struct IoRingWriter {
    ring: Hioring,
    file: Handle,
    bufs: Vec<Buf>,
    slots: Vec<Slot>,
}

impl IoRingWriter {
    fn new(file: Handle, n_bufs: usize, cap: usize) -> Result<Self, Xerr> {
        let mut ring: Hioring = null_mut();
        let flags = IoringCreateFlags {
            required: 0,
            advisory: 0,
        };
        let hr =
            unsafe { CreateIoRing(IORING_VERSION_4, flags, STREAM_QD, STREAM_QD, &raw mut ring) };
        if hr != 0 {
            return Err(format!("CreateIoRing failed (hr {hr:#x})").into());
        }
        let bufs = (0..n_bufs)
            .map(|_| Buf::new(cap))
            .collect::<Result<Vec<_>, _>>()?;
        let slots = (0..n_bufs)
            .map(|_| Slot {
                off: 0,
                len: 0,
                acked: 0,
            })
            .collect();
        Ok(Self {
            ring,
            file,
            bufs,
            slots,
        })
    }

    fn push(&self, user_data: usize, off: u64, addr: *mut u8, len: u32) -> Result<(), Xerr> {
        let file = IoringHandleRef {
            kind: IORING_REF_RAW,
            handle: self.file,
        };
        let buffer = IoringBufferRef {
            kind: IORING_REF_RAW,
            address: addr.cast(),
        };
        let hr =
            unsafe { BuildIoRingWriteFile(self.ring, file, buffer, len, off, 0, user_data, 0) };
        if hr != 0 {
            return Err(format!("BuildIoRingWriteFile failed (hr {hr:#x})").into());
        }
        let mut submitted = 0u32;
        let hr = unsafe { SubmitIoRing(self.ring, 0, 0, &raw mut submitted) };
        if hr != 0 {
            return Err(format!("SubmitIoRing failed (hr {hr:#x})").into());
        }
        Ok(())
    }

    fn reap(&mut self, block: bool) -> Result<(), Xerr> {
        if block {
            let mut submitted = 0u32;
            let hr = unsafe { SubmitIoRing(self.ring, 1, INFINITE, &raw mut submitted) };
            if hr != 0 {
                return Err(format!("SubmitIoRing (wait) failed (hr {hr:#x})").into());
            }
        }
        loop {
            let mut cqe = IoringCqe {
                user_data: 0,
                result_code: 0,
                information: 0,
            };
            if unsafe { PopIoRingCompletion(self.ring, &raw mut cqe) } != 0 {
                break;
            }
            if cqe.result_code != 0 {
                return Err(format!("io_ring write failed (hr {:#x})", cqe.result_code).into());
            }
            let idx = cqe.user_data;
            let slot = &mut self.slots[idx];
            slot.acked += cqe.information as u32;
            let (off, acked, len) = (slot.off, slot.acked, slot.len);
            if acked < len {
                let addr = unsafe { self.bufs[idx].ptr.add(acked as usize) };
                self.push(idx, off + u64::from(acked), addr, len - acked)?;
            }
        }
        Ok(())
    }

    fn acquire(&mut self) -> Result<usize, Xerr> {
        loop {
            if let Some(i) = self.slots.iter().position(|s| s.acked >= s.len) {
                return Ok(i);
            }
            self.reap(true)?;
        }
    }

    fn buf_mut(&mut self, idx: usize) -> &mut [u8] {
        let b = &self.bufs[idx];
        unsafe { from_raw_parts_mut(b.ptr, b.cap) }
    }

    fn submit(&mut self, idx: usize, off: u64, len: u32) -> Result<(), Xerr> {
        self.slots[idx] = Slot { off, len, acked: 0 };
        let addr = self.bufs[idx].ptr;
        self.push(idx, off, addr, len)
    }

    fn drain(&mut self) -> Result<(), Xerr> {
        while self.slots.iter().any(|s| s.acked < s.len) {
            self.reap(true)?;
        }
        Ok(())
    }
}

impl Drop for IoRingWriter {
    fn drop(&mut self) {
        unsafe { CloseIoRing(self.ring) };
    }
}

pub fn write_mux(out: &Path, mux: &Mux, progs: &mut ProgsBar) -> Result<(), Xerr> {
    let w = wide(out);
    let file = unsafe {
        CreateFileW(
            w.as_ptr(),
            GENERIC_WRITE,
            0,
            null_mut(),
            CREATE_ALWAYS,
            FILE_ATTRIBUTE_NORMAL,
            null_mut(),
        )
    };
    if invalid(file) {
        let e = unsafe { GetLastError() };
        return Err(format!("CreateFileW (output) failed (error {e})").into());
    }
    let res = ring_write(file, mux, progs);
    unsafe { CloseHandle(file) };
    res
}

fn ring_write(file: Handle, mux: &Mux, progs: &mut ProgsBar) -> Result<(), Xerr> {
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

    let mut w = IoRingWriter::new(file, RING_BUFS, cap)?;
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
    w: &mut IoRingWriter,
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
            let (c0, c1) = segs[ui - 1];
            let seg: usize = mux.plans[c0..c1].iter().map(|p| p.size).sum();
            mux.build_clusters::<HAS_SUBS, IS_NAL>(&mut buf[..seg], c0, c1, None);
            seg
        };
        unsafe { _mm_sfence() };
        w.submit(idx, off, len as u32)?;
        off += len as u64;
        if ui > 0 {
            let (c0, c1) = segs[ui - 1];
            done += mux.clusters[c0..c1].iter().map(|c| c.len()).sum::<usize>();
            progs.up_frames(done, total, 0, "MUX");
        }
    }
    Ok(())
}
