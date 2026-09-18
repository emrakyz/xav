#[cfg(target_os = "linux")]
use alloc::{boxed::Box, vec::Vec};
use core::{
    hint::{cold_path, spin_loop},
    sync::atomic::{
        AtomicU64,
        Ordering::{AcqRel, Acquire, Release},
    },
};

use crate::chunk::Chunk;
#[cfg(feature = "vship")]
use crate::tq::{Interp, Probe};

pub struct WorkPkg {
    pub chnk: Chunk,
    pub yuv: Vec<u8>,
    pub frame_cnt: usize,
    pub width: u32,
    pub height: u32,
    #[cfg(feature = "vship")]
    pub probe: Vec<u8>,
    #[cfg(feature = "vship")]
    pub tq_state: Option<TQState>,
    #[cfg(feature = "vship")]
    pub armed: bool,
}

#[cfg(feature = "vship")]
pub struct TQState {
    pub probes: Vec<Probe>,
    pub probe_szs: Vec<(f32, u64)>,
    pub search_min: f32,
    pub search_max: f32,
    pub round: u8,
    pub target: f32,
    pub last_crf: f32,
    pub final_enc: bool,
    pub best: Probe,
    pub best_probe: Vec<u8>,
    pub best_diff: f32,
    pub interp: Interp,
}

#[cfg(feature = "vship")]
impl TQState {
    pub const fn empty() -> Self {
        Self {
            probes: Vec::new(),
            probe_szs: Vec::new(),
            search_min: 0.0,
            search_max: 0.0,
            round: 0,
            target: 0.0,
            last_crf: 0.0,
            final_enc: false,
            best: Probe {
                crf: 0.0,
                score: 0.0,
            },
            best_probe: Vec::new(),
            best_diff: f32::INFINITY,
            interp: Interp::new(),
        }
    }

    pub fn arm(&mut self, min: f32, max: f32, target: f32) {
        self.probes.clear();
        self.probe_szs.clear();
        self.best_probe.clear();
        self.interp.clear();
        self.search_min = min;
        self.search_max = max;
        self.round = 0;
        self.target = target;
        self.last_crf = 0.0;
        self.final_enc = false;
        self.best_diff = f32::INFINITY;
    }
}

impl WorkPkg {
    const fn empty() -> Self {
        Self {
            chnk: Chunk {
                idx: 0,
                tmpl: 0,
                start: 0,
                end: 0,
                params: None,
            },
            yuv: Vec::new(),
            frame_cnt: 0,
            width: 0,
            height: 0,
            #[cfg(feature = "vship")]
            probe: Vec::new(),
            #[cfg(feature = "vship")]
            tq_state: Some(TQState::empty()),
            #[cfg(feature = "vship")]
            armed: false,
        }
    }

    #[inline]
    #[cfg_attr(not(feature = "vship"), allow(clippy::missing_const_for_fn))]
    pub fn set(&mut self, chnk: Chunk, frame_cnt: usize, width: u32, height: u32) {
        self.chnk = chnk;
        self.frame_cnt = frame_cnt;
        self.width = width;
        self.height = height;
        #[cfg(feature = "vship")]
        {
            self.probe.clear();
            self.armed = false;
        }
    }

    // decode writes every byte before anything reads
    #[inline]
    #[allow(clippy::uninit_vec)]
    pub fn fit(&mut self, n: usize) -> *mut u8 {
        self.yuv.clear();
        self.yuv.reserve(n);
        unsafe { self.yuv.set_len(n) };
        self.yuv.as_mut_ptr()
    }

    #[cold]
    #[inline(never)]
    pub fn truncate(&mut self, i: usize, fsz: usize) -> usize {
        self.yuv.truncate(i * fsz);
        i
    }
}

pub struct PkgPool {
    slots: *mut WorkPkg,
    free: *const AtomicU64,
    words: usize,
}

unsafe impl Sync for PkgPool {}
unsafe impl Send for PkgPool {}

impl PkgPool {
    #[cold]
    #[inline(never)]
    #[must_use]
    pub fn new(n: usize, cap: usize) -> Self {
        let mut slots = Vec::with_capacity(n);
        for _ in 0..n {
            let mut p = Self::empty_pkg();
            p.yuv.reserve_exact(cap);
            slots.push(p);
        }
        let words = n.div_ceil(64);
        let mut free = Vec::with_capacity(words);
        for w in 0..words {
            let bits = (n - w * 64).min(64);
            free.push(AtomicU64::new(if bits == 64 {
                u64::MAX
            } else {
                (1u64 << bits) - 1
            }));
        }
        Self {
            slots: Box::leak(slots.into_boxed_slice()).as_mut_ptr(),
            free: Box::leak(free.into_boxed_slice()).as_ptr(),
            words,
        }
    }

    const fn empty_pkg() -> WorkPkg {
        WorkPkg::empty()
    }

    // permit is already held; free slot exists or 1 release away
    pub fn take(&self) -> *mut WorkPkg {
        loop {
            for w in 0..self.words {
                let word = unsafe { &*self.free.add(w) };
                let mut bits = word.load(Acquire);
                while bits != 0 {
                    let b = bits.trailing_zeros();
                    let mask = 1u64 << b;
                    let prev = word.fetch_and(!mask, AcqRel);
                    if prev & mask != 0 {
                        return unsafe { self.slots.add(w * 64 + b as usize) };
                    }
                    bits = prev & !mask;
                }
            }
            cold_path();
            spin_loop();
        }
    }

    pub fn give(&self, p: *mut WorkPkg) {
        let i = unsafe { p.offset_from(self.slots) } as usize;
        unsafe { (*self.free.add(i / 64)).fetch_or(1u64 << (i % 64), Release) };
    }
}
