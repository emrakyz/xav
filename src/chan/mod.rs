#[cfg(all(
    any(target_os = "linux", target_os = "windows"),
    target_feature = "avx2"
))]
include!("avx2.rs");
#[cfg(not(all(
    any(target_os = "linux", target_os = "windows"),
    target_feature = "avx2"
)))]
include!("scalar.rs");

use std::{array::from_fn, cell::UnsafeCell, sync::atomic::AtomicU32};

const CAP: u32 = 128;

#[repr(C, align(8))]
pub struct SpscRing {
    head: AtomicU32,
    tail: AtomicU32,
    avail: AtomicU32,
    pwait: AtomicU32,
    ppark: AtomicU32,
    cpark: AtomicU32,
    closed: AtomicU32,
    pad: u32,
    slots: UnsafeCell<[u64; CAP as usize]>,
}

#[repr(C, align(8))]
pub struct SeqRing {
    seq: [AtomicU32; CAP as usize],
    vals: UnsafeCell<[u64; CAP as usize]>,
    tail: AtomicU32,
    head: AtomicU32,
    cw: AtomicU32,
    pw: AtomicU32,
    avail: AtomicU32,
    space: AtomicU32,
    closed: AtomicU32,
}

unsafe impl Sync for SpscRing {}
unsafe impl Send for SpscRing {}
unsafe impl Sync for SeqRing {}
unsafe impl Send for SeqRing {}

impl Default for SpscRing {
    fn default() -> Self {
        Self::new()
    }
}

impl SpscRing {
    #[must_use]
    pub const fn new() -> Self {
        Self {
            head: AtomicU32::new(0),
            tail: AtomicU32::new(0),
            avail: AtomicU32::new(0),
            pwait: AtomicU32::new(0),
            ppark: AtomicU32::new(0),
            cpark: AtomicU32::new(0),
            closed: AtomicU32::new(0),
            pad: 0,
            slots: UnsafeCell::new([0; CAP as usize]),
        }
    }
}

impl Default for SeqRing {
    fn default() -> Self {
        Self::new()
    }
}

impl SeqRing {
    #[must_use]
    pub fn new() -> Self {
        Self {
            seq: from_fn(|i| AtomicU32::new(i as u32)),
            vals: UnsafeCell::new([0; CAP as usize]),
            tail: AtomicU32::new(0),
            head: AtomicU32::new(0),
            cw: AtomicU32::new(0),
            pw: AtomicU32::new(0),
            avail: AtomicU32::new(0),
            space: AtomicU32::new(0),
            closed: AtomicU32::new(0),
        }
    }
}

#[repr(C)]
pub struct Semaphore {
    count: AtomicU32,
    waiters: AtomicU32,
}

impl Semaphore {
    #[must_use]
    pub const fn new(permits: usize) -> Self {
        Self {
            count: AtomicU32::new(permits as u32),
            waiters: AtomicU32::new(0),
        }
    }
}
