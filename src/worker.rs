use std::sync::{Condvar, Mutex};

use crate::chunk::Chunk;
#[cfg(feature = "vship")]
use crate::tq::Probe;

pub struct WorkPkg {
    pub chnk: Chunk,
    pub yuv: Vec<u8>,
    pub frame_cnt: usize,
    pub width: u32,
    pub height: u32,
    #[cfg(feature = "vship")]
    pub tq_state: Option<TQState>,
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
}

impl WorkPkg {
    pub const fn new(chnk: Chunk, yuv: Vec<u8>, frame_cnt: usize, width: u32, height: u32) -> Self {
        Self {
            chnk,
            yuv,
            frame_cnt,
            width,
            height,
            #[cfg(feature = "vship")]
            tq_state: None,
        }
    }
}

pub struct Semaphore {
    state: Mutex<usize>,
    cvar: Condvar,
}

impl Semaphore {
    pub const fn new(permits: usize) -> Self {
        Self {
            state: Mutex::new(permits),
            cvar: Condvar::new(),
        }
    }

    pub fn acq(&self) {
        let mut cnt = unsafe { self.state.lock().unwrap_unchecked() };
        while *cnt == 0 {
            cnt = unsafe { self.cvar.wait(cnt).unwrap_unchecked() };
        }
        *cnt -= 1;
    }

    pub fn release(&self) {
        *unsafe { self.state.lock().unwrap_unchecked() } += 1;
        self.cvar.notify_one();
    }
}
