use std::{
    iter::repeat_with,
    mem::zeroed,
    ptr::{from_mut, null_mut},
    slice::from_raw_parts_mut,
    sync::atomic::{
        AtomicU32,
        Ordering::{Acquire, Relaxed, Release},
    },
};

use libc::{
    MADV_NOHUGEPAGE, MAP_ANONYMOUS, MAP_FAILED, MAP_PRIVATE, MAP_SHARED, PROT_READ, PROT_WRITE,
    SYS_io_uring_enter, SYS_io_uring_register, SYS_io_uring_setup, c_void, close, madvise, mmap,
    munmap, syscall,
};

use crate::error::Xerr;

const IORING_SETUP_SQPOLL: u32 = 1 << 1;
const IORING_FEAT_SINGLE_MMAP: u32 = 1 << 0;
const IORING_OFF_SQ_RING: i64 = 0;
const IORING_OFF_CQ_RING: i64 = 0x0800_0000;
const IORING_OFF_SQES: i64 = 0x1000_0000;

const IORING_OP_WRITE: u8 = 23;
const IORING_REGISTER_FILES: u32 = 2;
const IORING_ENTER_GETEVENTS: u32 = 1 << 0;
const IORING_ENTER_SQ_WAKEUP: u32 = 1 << 1;
const IORING_SQ_NEED_WAKEUP: u32 = 1 << 0;
const IOSQE_FIXED_FILE: u8 = 1 << 0;

const STREAM_QD: u32 = 64;

const SQ_THREAD_IDLE_MS: u32 = 1000;

#[repr(C)]
#[derive(Clone, Copy)]
struct SqRingOffsets {
    head: u32,
    tail: u32,
    ring_mask: u32,
    ring_entries: u32,
    flags: u32,
    dropped: u32,
    array: u32,
    resv1: u32,
    resv2: u64,
}

#[repr(C)]
#[derive(Clone, Copy)]
struct CqRingOffsets {
    head: u32,
    tail: u32,
    ring_mask: u32,
    ring_entries: u32,
    overflow: u32,
    cqes: u32,
    flags: u32,
    resv1: u32,
    resv2: u64,
}

#[repr(C)]
struct Params {
    sq_entries: u32,
    cq_entries: u32,
    flags: u32,
    sq_thread_cpu: u32,
    sq_thread_idle: u32,
    features: u32,
    wq_fd: u32,
    resv: [u32; 3],
    sq_off: SqRingOffsets,
    cq_off: CqRingOffsets,
}

#[repr(C)]
struct Sqe {
    opcode: u8,
    flags: u8,
    ioprio: u16,
    fd: i32,
    off: u64,
    addr: u64,
    len: u32,
    op_flags: u32,
    user_data: u64,
    buf_index: u16,
    personality: u16,
    splice_fd_in: i32,
    addr3: u64,
    tail_pad: u64,
}

#[repr(C)]
struct Cqe {
    user_data: u64,
    res: i32,
    flags: u32,
}

// can't check kernel ABI by read - pin every size at compile
const _: [(); 64] = [(); size_of::<Sqe>()];
const _: [(); 16] = [(); size_of::<Cqe>()];
const _: [(); 40] = [(); size_of::<SqRingOffsets>()];
const _: [(); 40] = [(); size_of::<CqRingOffsets>()];
const _: [(); 120] = [(); size_of::<Params>()];

#[inline]
unsafe fn setup(entries: u32, p: &mut Params) -> i64 {
    unsafe { syscall(SYS_io_uring_setup, i64::from(entries), from_mut(p)) }
}

#[inline]
unsafe fn enter(fd: i32, to_submit: u32, min_complete: u32, flags: u32) -> i64 {
    unsafe {
        syscall(
            SYS_io_uring_enter,
            i64::from(fd),
            i64::from(to_submit),
            i64::from(min_complete),
            i64::from(flags),
            null_mut::<c_void>(),
            0i64,
        )
    }
}

#[inline]
unsafe fn register(fd: i32, opcode: u32, arg: *const c_void, nr: u32) -> i64 {
    unsafe {
        syscall(
            SYS_io_uring_register,
            i64::from(fd),
            i64::from(opcode),
            arg,
            i64::from(nr),
        )
    }
}

pub struct Ring {
    fd: i32,
    sq_map: *mut c_void,
    sq_map_len: usize,
    cq_map: *mut c_void,
    cq_map_len: usize, // 0 when SINGLE_MMAP folds CQ into the SQ mapping
    sqes: *mut Sqe,
    sqes_map_len: usize,

    sq_tail: *mut AtomicU32,
    sq_array: *mut u32,
    sq_ring_mask: u32,
    sq_flags: *const AtomicU32,
    cq_head: *mut AtomicU32,
    cq_tail: *const AtomicU32,
    cqes: *mut Cqe,
    cq_ring_mask: u32,

    sqpoll: bool,
}

impl Ring {
    pub fn new(entries: u32, sqpoll: bool) -> Result<Self, Xerr> {
        let mut p: Params = unsafe { zeroed() };
        if sqpoll {
            p.flags = IORING_SETUP_SQPOLL;
            p.sq_thread_idle = SQ_THREAD_IDLE_MS;
        }
        let ret = unsafe { setup(entries, &mut p) };
        if ret < 0 {
            return Err(format!("io_uring_setup failed (errno {})", -ret).into());
        }
        let fd = ret as i32;

        let single = p.features & IORING_FEAT_SINGLE_MMAP != 0;
        let mut sq_sz = p.sq_off.array as usize + p.sq_entries as usize * size_of::<u32>();
        let mut cq_sz = p.cq_off.cqes as usize + p.cq_entries as usize * size_of::<Cqe>();
        if single {
            let m = sq_sz.max(cq_sz);
            sq_sz = m;
            cq_sz = m;
        }
        let sqes_sz = p.sq_entries as usize * size_of::<Sqe>();

        let map = |len: usize, off: i64| unsafe {
            mmap(null_mut(), len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, off)
        };
        let sq_map = map(sq_sz, IORING_OFF_SQ_RING);
        if sq_map == MAP_FAILED {
            unsafe { close(fd) };
            return Err("io_uring SQ ring mmap failed".into());
        }
        let cq_map = if single {
            sq_map
        } else {
            let v = map(cq_sz, IORING_OFF_CQ_RING);
            if v == MAP_FAILED {
                unsafe {
                    munmap(sq_map, sq_sz);
                    close(fd);
                }
                return Err("io_uring CQ ring mmap failed".into());
            }
            v
        };
        let sqe_map = map(sqes_sz, IORING_OFF_SQES);
        if sqe_map == MAP_FAILED {
            unsafe {
                if !single {
                    munmap(cq_map, cq_sz);
                }
                munmap(sq_map, sq_sz);
                close(fd);
            }
            return Err("io_uring SQE array mmap failed".into());
        }

        let (sqb, cqb) = (sq_map.cast::<u8>(), cq_map.cast::<u8>());
        let (so, co) = (p.sq_off, p.cq_off);
        Ok(Self {
            fd,
            sq_map,
            sq_map_len: sq_sz,
            cq_map,
            cq_map_len: if single { 0 } else { cq_sz },
            sqes: sqe_map.cast::<Sqe>(),
            sqes_map_len: sqes_sz,
            sq_tail: unsafe { sqb.add(so.tail as usize).cast::<AtomicU32>() },
            sq_array: unsafe { sqb.add(so.array as usize).cast::<u32>() },
            sq_ring_mask: unsafe { *sqb.add(so.ring_mask as usize).cast::<u32>() },
            sq_flags: unsafe { sqb.add(so.flags as usize).cast::<AtomicU32>() },
            cq_head: unsafe { cqb.add(co.head as usize).cast::<AtomicU32>() },
            cq_tail: unsafe { cqb.add(co.tail as usize).cast::<AtomicU32>() },
            cqes: unsafe { cqb.add(co.cqes as usize).cast::<Cqe>() },
            cq_ring_mask: unsafe { *cqb.add(co.ring_mask as usize).cast::<u32>() },
            sqpoll,
        })
    }

    unsafe fn write_sqe(&self, slot: usize, off: u64, addr: u64, len: u32, user_data: u64) {
        unsafe {
            *self.sqes.add(slot) = Sqe {
                opcode: IORING_OP_WRITE,
                flags: IOSQE_FIXED_FILE,
                ioprio: 0,
                fd: 0,
                off,
                addr,
                len,
                op_flags: 0,
                user_data,
                buf_index: 0,
                personality: 0,
                splice_fd_in: 0,
                addr3: 0,
                tail_pad: 0,
            };
        }
    }

    fn submit_and_wait(&self, n: u32, min_complete: u32) -> Result<(), Xerr> {
        if self.sqpoll {
            let need = unsafe { (*self.sq_flags).load(Acquire) } & IORING_SQ_NEED_WAKEUP != 0;
            if need {
                let r = unsafe { enter(self.fd, 0, 0, IORING_ENTER_SQ_WAKEUP) };
                if r < 0 {
                    return Err(format!("io_uring_enter (wakeup) failed (errno {})", -r).into());
                }
            }
            if min_complete > 0 {
                let r = unsafe { enter(self.fd, 0, min_complete, IORING_ENTER_GETEVENTS) };
                if r < 0 {
                    return Err(format!("io_uring_enter (wait) failed (errno {})", -r).into());
                }
            }
        } else {
            let flags = if min_complete > 0 {
                IORING_ENTER_GETEVENTS
            } else {
                0
            };
            let r = unsafe { enter(self.fd, n, min_complete, flags) };
            if r < 0 {
                return Err(format!("io_uring_enter failed (errno {})", -r).into());
            }
        }
        Ok(())
    }
}

impl Drop for Ring {
    fn drop(&mut self) {
        unsafe {
            munmap(self.sqes.cast::<c_void>(), self.sqes_map_len);
            if self.cq_map_len != 0 {
                munmap(self.cq_map, self.cq_map_len);
            }
            munmap(self.sq_map, self.sq_map_len);
            close(self.fd);
        }
    }
}

pub struct AlignedBuf {
    ptr: *mut u8,
    len: usize,
}

impl AlignedBuf {
    pub fn new(len: usize) -> Result<Self, Xerr> {
        let len = (len + 4095) & !4095;
        let ptr = unsafe {
            mmap(
                null_mut(),
                len,
                PROT_READ | PROT_WRITE,
                MAP_PRIVATE | MAP_ANONYMOUS,
                -1,
                0,
            )
        };
        if ptr == MAP_FAILED {
            return Err("anonymous mmap (write buffer) failed".into());
        }
        unsafe { madvise(ptr, len, MADV_NOHUGEPAGE) };
        Ok(Self {
            ptr: ptr.cast(),
            len,
        })
    }

    pub const fn as_mut_slice(&mut self) -> &mut [u8] {
        unsafe { from_raw_parts_mut(self.ptr, self.len) }
    }
}

impl Drop for AlignedBuf {
    fn drop(&mut self) {
        unsafe { munmap(self.ptr.cast::<c_void>(), self.len) };
    }
}

struct Slot {
    off: u64,
    len: u32,
    acked: u32,
}

pub struct RingWriter {
    ring: Ring,
    bufs: Vec<AlignedBuf>,
    slots: Vec<Slot>,
}

impl RingWriter {
    pub fn new(out_fd: i32, n_bufs: usize, cap: usize) -> Result<Self, Xerr> {
        let ring = Ring::new(STREAM_QD, true)?;
        let fds = [out_fd];
        let r = unsafe { register(ring.fd, IORING_REGISTER_FILES, fds.as_ptr().cast(), 1) };
        if r < 0 {
            return Err(format!("IORING_REGISTER_FILES failed (errno {})", -r).into());
        }
        let bufs = repeat_with(|| AlignedBuf::new(cap))
            .take(n_bufs)
            .collect::<Result<Vec<_>, _>>()?;
        let slots = repeat_with(|| Slot {
            off: 0,
            len: 0,
            acked: 0,
        })
        .take(n_bufs)
        .collect();
        Ok(Self { ring, bufs, slots })
    }

    fn push(&self, user_data: u64, off: u64, addr: u64, len: u32) -> Result<(), Xerr> {
        let r = &self.ring;
        let tail = unsafe { (*r.sq_tail).load(Relaxed) };
        let slot = (tail & r.sq_ring_mask) as usize;
        unsafe {
            r.write_sqe(slot, off, addr, len, user_data);
            *r.sq_array.add(slot) = slot as u32;
            (*r.sq_tail).store(tail.wrapping_add(1), Release);
        }
        r.submit_and_wait(1, 0)
    }

    fn reap(&mut self, block: bool) -> Result<(), Xerr> {
        if block {
            self.ring.submit_and_wait(0, 1)?;
        }
        let mask = self.ring.cq_ring_mask;
        let mut head = unsafe { (*self.ring.cq_head).load(Relaxed) };
        let ctail = unsafe { (*self.ring.cq_tail).load(Acquire) };
        while head != ctail {
            let cqe = unsafe { &*self.ring.cqes.add((head & mask) as usize) };
            let (ud, res) = (cqe.user_data, cqe.res);
            head = head.wrapping_add(1);
            if res < 0 {
                unsafe { (*self.ring.cq_head).store(head, Release) };
                return Err(format!("io_uring write failed (errno {})", -res).into());
            }
            let slot = &mut self.slots[ud as usize];
            slot.acked += res as u32;
            if slot.acked < slot.len {
                let (off, acked, len) = (slot.off, slot.acked, slot.len);
                let addr = self.bufs[ud as usize].ptr as u64 + u64::from(acked);
                self.push(ud, off + u64::from(acked), addr, len - acked)?;
            }
        }
        unsafe { (*self.ring.cq_head).store(head, Release) };
        Ok(())
    }

    pub fn acquire(&mut self) -> Result<usize, Xerr> {
        loop {
            if let Some(i) = self.slots.iter().position(|s| s.acked >= s.len) {
                return Ok(i);
            }
            self.reap(true)?;
        }
    }

    pub fn buf_mut(&mut self, idx: usize) -> &mut [u8] {
        self.bufs[idx].as_mut_slice()
    }

    pub fn submit(&mut self, idx: usize, off: u64, len: u32) -> Result<(), Xerr> {
        self.slots[idx] = Slot { off, len, acked: 0 };
        let addr = self.bufs[idx].ptr as u64;
        self.push(idx as u64, off, addr, len)
    }

    pub fn drain(&mut self) -> Result<(), Xerr> {
        while self.slots.iter().any(|s| s.acked < s.len) {
            self.reap(true)?;
        }
        Ok(())
    }
}
