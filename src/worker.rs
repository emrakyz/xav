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
    pub probe: Vec<u8>,
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
    pub best_probe: Vec<u8>,
    pub best_diff: f32,
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
            probe: Vec::new(),
            #[cfg(feature = "vship")]
            tq_state: None,
        }
    }
}
