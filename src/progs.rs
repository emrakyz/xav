use alloc::sync::Arc;
#[cfg(target_os = "linux")]
use alloc::vec::Vec;
use core::{
    iter::repeat_with,
    mem::{MaybeUninit, size_of},
    sync::atomic::{
        AtomicBool, AtomicU32, AtomicU64, AtomicUsize,
        Ordering::{Relaxed, Release},
    },
    time::Duration as Durat,
};

use crate::{
    chunk::{Chunk, PRIOR_SECS},
    clk::Mono,
    ffms::VidInf,
    io::{Write as _, print_fmt, stdout as io_stdout},
    thread::{JoinHandle, park_state, sleep, spawn},
};

pub const INTERVAL_MS: u64 = 512;

// FMTSLOT -> 7+1+4+18+17+160+16+3+17+6+16+3+15+3 = 286
// + 6 for line sept; rest is store overshoot slack
const DRAW_CAP: usize = 320;

const TAG_EMPTY: u32 = 0;
const TAG_LIB: u32 = 1;
#[cfg(feature = "vship")]
const TAG_MET: u32 = 2;
#[cfg(feature = "vship")]
const TAG_MET_DONE: u32 = 3;

// pbf.asm walks boards by SLOTSZ; reads these by S_* offset
const _: [(); 64] = [(); size_of::<Slot>()];

#[repr(C, align(64))]
struct Slot {
    tag: AtomicU32,
    cnt: u32,
    enced: AtomicUsize,
    flu: AtomicUsize,
    tot: usize,
    idx: usize,
    fl: usize,
    start: u64,
    c: f32,
    s: f32,
}

impl Slot {
    const fn new() -> Self {
        Self {
            tag: AtomicU32::new(TAG_EMPTY),
            cnt: 0,
            enced: AtomicUsize::new(0),
            flu: AtomicUsize::new(0),
            tot: 0,
            idx: 0,
            fl: 0,
            start: 0,
            c: 0.0,
            s: 0.0,
        }
    }
}

unsafe extern "C" {
    fn xav_pb_init(p: *mut ProgsBar);
    fn xav_pb_copy(p: *mut ProgsBar, cur: usize, tot: usize);
    fn xav_pb_au(p: *mut ProgsBar, cur: usize, tot: usize, ln: usize, ps: usize, ti: usize);
    fn xav_pb_mon(dn: *const u8, st: *const u8, pk: *const u8, tot: usize, ln: usize, pi: usize);
    fn xav_pb_frames(p: *mut ProgsBar, cur: usize, tot: usize, ln: usize, lb: *const u8, ll: usize);
    fn xav_pb_fin(sl: *mut u8, prc: *mut u8);
    fn xav_pb_draw(dw: *const Draw);
    fn xav_svt_drain_tick(workers: usize);
}

#[repr(C)]
pub struct ProgsBar {
    start_ns: u64,
    last_ns: u64,
    tsc_next: u64,
    tsc_last: u64,
    tsc_ival: u64,
    cnt: i32,
    stride: i32,
    checks: u32,
}

impl ProgsBar {
    pub fn new() -> Self {
        let mut s = MaybeUninit::<Self>::uninit();
        unsafe {
            xav_pb_init(s.as_mut_ptr());
            s.assume_init()
        }
    }

    pub fn up_frames(&mut self, current: usize, tot: usize, line: usize, label: &str) {
        unsafe {
            xav_pb_frames(
                &raw mut *self,
                current,
                tot,
                line,
                label.as_ptr(),
                label.len(),
            );
        }
    }

    pub fn up_au(&mut self, current: usize, tot: usize, line: usize, pass: u8, track_id: u8) {
        unsafe {
            xav_pb_au(
                &raw mut *self,
                current,
                tot,
                line,
                pass as usize,
                track_id as usize,
            );
        }
    }

    pub fn up_copy(&mut self, current: usize, tot: usize) {
        unsafe { xav_pb_copy(&raw mut *self, current, tot) }
    }
}

pub fn monitor_au(
    done: &AtomicUsize,
    stop: &AtomicBool,
    tot: usize,
    line: usize,
    pass: u8,
    tid: u8,
) {
    unsafe {
        xav_pb_mon(
            (&raw const *done).cast(),
            (&raw const *stop).cast(),
            park_state(),
            tot,
            line,
            usize::from(pass) | (usize::from(tid) << 8),
        );
    }
}

struct Shared {
    boards: Vec<Slot>,
    processed: AtomicUsize,
    stop: AtomicBool,
    start: Mono,
    tot_chnks: usize,
    tot_frames: usize,
    fps_num: u32,
    fps_den: u32,
    completed: Arc<AtomicUsize>,
    completed_frames: Arc<AtomicUsize>,
    tot_sz: Arc<AtomicU64>,
    init_frames: usize,
}

impl Shared {
    fn board(&self, id: usize) -> *mut Slot {
        unsafe { (&raw const *self.boards.get_unchecked(id)).cast_mut() }
    }
}

pub struct ProgsTrack {
    inner: Arc<Shared>,
}

impl Drop for ProgsTrack {
    fn drop(&mut self) {
        self.inner.stop.store(true, Relaxed);
    }
}

impl ProgsTrack {
    pub fn new(
        chnks: &[Chunk],
        inf: &VidInf,
        worker_cnt: usize,
        init_frames: usize,
        completed: Arc<AtomicUsize>,
        completed_frames: Arc<AtomicUsize>,
        tot_sz: Arc<AtomicU64>,
    ) -> (Self, JoinHandle<()>) {
        print!("\x1b[s");
        _ = io_stdout().flush();

        let tot_frames = chnks.iter().map(|c| c.end - c.start).sum();

        let inner = Arc::new(Shared {
            boards: repeat_with(Slot::new).take(worker_cnt).collect(),
            processed: AtomicUsize::new(0),
            stop: AtomicBool::new(false),
            start: Mono::now(),
            tot_chnks: chnks.len(),
            tot_frames,
            fps_num: inf.fps_num,
            fps_den: inf.fps_den,
            completed,
            completed_frames,
            tot_sz,
            init_frames,
        });

        let disp = Arc::clone(&inner);
        let handle = spawn(move || display_loop(&disp));

        (Self { inner }, handle)
    }
}

#[repr(C)]
struct Draw {
    boards: *const u8,
    nb: usize,
    buf: *mut u8,
    cmp: *const u8,
    cfr: *const u8,
    tsz: *const u8,
    prc: *const u8,
    pri: *const u8,
    start_ns: u64,
    tot_chnks: usize,
    tot_frames: usize,
    init_frames: usize,
    fps_num: u32,
    fps_den: u32,
}

pub struct Tracker {
    slot: *mut Slot,
    prc: *mut u8,
}

impl Tracker {
    fn mk(
        prog: &ProgsTrack,
        worker_id: usize,
        chnk_idx: u16,
        tot: usize,
        track_frames: bool,
        crf_score: Option<(f32, Option<f32>)>,
        tag: u32,
    ) -> Self {
        let (c, s, fl) = match crf_score {
            Some((c, Some(s))) => (c, s, 3),
            Some((c, None)) => (c, 0.0, 1),
            None => (0.0, 0.0, 0),
        };
        let slot = prog.inner.board(worker_id);
        unsafe {
            (*slot).cnt = u32::from(track_frames);
            (*slot).enced.store(0, Relaxed);
            (*slot).flu.store(0, Relaxed);
            (*slot).tot = tot;
            (*slot).idx = usize::from(chnk_idx);
            (*slot).fl = fl;
            (*slot).start = Mono::now().raw();
            (*slot).c = c;
            (*slot).s = s;
            (*slot).tag.store(tag, Release);
        }
        Self {
            slot,
            prc: (&raw const prog.inner.processed).cast_mut().cast(),
        }
    }

    pub fn new(
        prog: &ProgsTrack,
        worker_id: usize,
        chnk_idx: u16,
        tot: usize,
        track_frames: bool,
        crf_score: Option<(f32, Option<f32>)>,
    ) -> Self {
        Self::mk(
            prog,
            worker_id,
            chnk_idx,
            tot,
            track_frames,
            crf_score,
            TAG_LIB,
        )
    }

    #[cfg(feature = "vship")]
    pub fn new_met(
        prog: &ProgsTrack,
        worker_id: usize,
        chnk_idx: u16,
        tot: usize,
        crf_score: Option<(f32, Option<f32>)>,
    ) -> Self {
        Self::mk(prog, worker_id, chnk_idx, tot, false, crf_score, TAG_MET)
    }

    #[cfg(any(
        feature = "vship",
        feature = "avm",
        feature = "vvenc",
        feature = "x264",
        feature = "x265"
    ))]
    #[inline]
    pub fn set(&self, n: usize) {
        unsafe { (*self.slot).enced.store(n, Relaxed) }
    }

    #[inline]
    pub const fn enced(&self) -> *mut usize {
        unsafe { (&raw mut (*self.slot).enced).cast::<usize>() }
    }

    pub fn finish(&self) {
        unsafe { xav_pb_fin(self.slot.cast(), self.prc) }
    }

    // start becomes the frozen elapsed; line stays; fps stops
    #[cfg(feature = "vship")]
    pub fn freeze(&self) {
        unsafe {
            (*self.slot).start = Mono::now().raw() - (*self.slot).start;
            (*self.slot).tag.store(TAG_MET_DONE, Release);
        }
    }
}

fn display_loop(s: &Shared) {
    let nb = s.boards.len();
    let mut buf: Vec<u8> = Vec::with_capacity(nb * DRAW_CAP + 1024);
    let dw = Draw {
        boards: s.boards.as_ptr().cast(),
        nb,
        buf: buf.as_mut_ptr(),
        cmp: (&raw const *s.completed).cast(),
        cfr: (&raw const *s.completed_frames).cast(),
        tsz: (&raw const *s.tot_sz).cast(),
        prc: (&raw const s.processed).cast(),
        pri: (&raw const PRIOR_SECS).cast(),
        start_ns: s.start.raw(),
        tot_chnks: s.tot_chnks,
        tot_frames: s.tot_frames,
        init_frames: s.init_frames,
        fps_num: s.fps_num,
        fps_den: s.fps_den,
    };
    loop {
        sleep(Durat::from_millis(INTERVAL_MS));
        unsafe { xav_svt_drain_tick(nb) };
        if s.stop.load(Relaxed) {
            break;
        }
        unsafe { xav_pb_draw(&raw const dw) }
    }
    unsafe { xav_pb_draw(&raw const dw) }
}
