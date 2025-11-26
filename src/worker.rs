#[allow(dead_code)]
use crate::chunk::Chunk;

pub struct WorkPkg {
    pub chunk: Chunk,
    pub yuv: Vec<u8>,
    pub frame_count: usize,
    pub width: u32,
    pub height: u32,
    pub tq_state: Option<TQState>,
}

pub struct TQState {
    pub probes: Vec<crate::tq::Probe>,
    pub search_min: f64,
    pub search_max: f64,
    pub round: usize,
    pub target: f64,
    pub last_crf: f64,
}

impl WorkPkg {
    pub const fn new(
        chunk: Chunk,
        yuv: Vec<u8>,
        frame_count: usize,
        width: u32,
        height: u32,
    ) -> Self {
        Self { chunk, yuv, frame_count, width, height, tq_state: None }
    }
}
