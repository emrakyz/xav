#[cfg(target_feature = "avx512bw")]
include!("avx512.rs");
#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
include!("avx2.rs");
#[cfg(not(any(target_feature = "avx2", target_feature = "avx512bw")))]
include!("scalar.rs");

use std::{
    cmp::min,
    collections::VecDeque,
    fmt::Write as _,
    fs::write as fs_write,
    hint::cold_path,
    mem::size_of,
    path::Path,
    sync::Arc,
    thread::{available_parallelism, spawn},
};

use crate::{
    chan::{SpscRing, spsc_close, spsc_recv, spsc_send},
    error::Xerr,
    ffms::{VidDecoder, VidFrame, VidInf, av_frame_alloc, av_frame_free, av_frame_move_ref},
    progs::ProgsBar,
};

const LOOKAHEAD: usize = 5;
const BIAS: f64 = 0.7;
const IMP_BLOCK_DIFF_THRESHOLD: f64 = 7.0;
const MAX_DIST: usize = 300;
const BLK: usize = 8;

type Weights = Vec<Option<(f32, f32)>>;

trait Pixel: Copy + 'static + Send + Into<i32> {
    unsafe fn satd_dc<const S: bool>(src: *const Self, stride: usize) -> u32;
    unsafe fn satd<const S: bool>(cur: *const Self, rf: *const Self, stride: usize) -> u32;
    unsafe fn imp<const S: bool>(cur: *const Self, rf: *const Self, stride: usize) -> u32;
}

const fn butterfly(a: i32, b: i32) -> (i32, i32) {
    (a + b, a - b)
}

fn hadamard8_1d<const S0: usize, const S1: usize>(d: &mut [i32; 64]) {
    let mut i = 0;
    while i < 8 {
        let o = i * S0;
        let (a0, a1) = butterfly(d[o], d[o + S1]);
        let (a2, a3) = butterfly(d[o + 2 * S1], d[o + 3 * S1]);
        let (a4, a5) = butterfly(d[o + 4 * S1], d[o + 5 * S1]);
        let (a6, a7) = butterfly(d[o + 6 * S1], d[o + 7 * S1]);
        let (b0, b2) = butterfly(a0, a2);
        let (b1, b3) = butterfly(a1, a3);
        let (b4, b6) = butterfly(a4, a6);
        let (b5, b7) = butterfly(a5, a7);
        d[o] = b0 + b4;
        d[o + S1] = b1 + b5;
        d[o + 2 * S1] = b2 + b6;
        d[o + 3 * S1] = b3 + b7;
        d[o + 4 * S1] = b0 - b4;
        d[o + 5 * S1] = b1 - b5;
        d[o + 6 * S1] = b2 - b6;
        d[o + 7 * S1] = b3 - b7;
        i += 1;
    }
}

#[inline]
fn satd_buf(buf: &mut [i32; 64]) -> u32 {
    hadamard8_1d::<8, 1>(buf);
    hadamard8_1d::<1, 8>(buf);
    let sum: u64 = buf.iter().map(|a| u64::from(a.unsigned_abs())).sum();
    ((sum + 4) >> 3) as u32
}

#[inline]
fn satd8x8_blk<T: Pixel, const S: bool>(org: *const T, os: usize, rf: *const T, rs: usize) -> u32 {
    let mut buf = [0i32; 64];
    for r in 0..BLK {
        for c in 0..BLK {
            let a: i32 = unsafe { *org.add(r * os + c) }.into();
            let b: i32 = unsafe { *rf.add(r * rs + c) }.into();
            let (a, b) = if S { (a >> 6, b >> 6) } else { (a, b) };
            buf[r * BLK + c] = a - b;
        }
    }
    satd_buf(&mut buf)
}

#[inline]
fn satd8x8_dc_blk<T: Pixel, const S: bool>(org: *const T, os: usize, dc: i32) -> u32 {
    let mut buf = [0i32; 64];
    for r in 0..BLK {
        for c in 0..BLK {
            let v: i32 = unsafe { *org.add(r * os + c) }.into();
            let v = if S { v >> 6 } else { v };
            buf[r * BLK + c] = v - dc;
        }
    }
    satd_buf(&mut buf)
}

#[inline]
fn sum8x8_blk<T: Pixel, const S: bool>(p: *const T, s: usize) -> i32 {
    let mut acc = 0i32;
    for r in 0..BLK {
        for c in 0..BLK {
            let v: i32 = unsafe { *p.add(r * s + c) }.into();
            acc += if S { v >> 6 } else { v };
        }
    }
    acc
}

#[inline]
const fn dc_val<T: Pixel>() -> i32 {
    if size_of::<T>() == 1 { 128 } else { 512 }
}

const _: [(); 0] = [(); IMP_BATCH % SATD_BATCH];

fn cost_sums<T: Pixel, const S: bool>(
    cur: *const T,
    rf: *const T,
    stride: usize,
    wb: usize,
    hb: usize,
) -> (u64, u64, u64) {
    const K: usize = IMP_BATCH / SATD_BATCH;
    let full = wb / IMP_BATCH;
    let dc = dc_val::<T>();
    let (mut intra, mut inter, mut imp) = (0u64, 0u64, 0u64);
    for by in 0..hb {
        let crow = unsafe { cur.add(by * BLK * stride) };
        let rrow = unsafe { rf.add(by * BLK * stride) };
        for ib in 0..full {
            let ibo = ib * IMP_BATCH * BLK;
            for k in 0..K {
                let o = ibo + k * SATD_BATCH * BLK;
                let c = unsafe { crow.add(o) };
                let r = unsafe { rrow.add(o) };
                intra += u64::from(unsafe { T::satd_dc::<S>(c, stride) });
                inter += u64::from(unsafe { T::satd::<S>(c, r, stride) });
            }
            imp += u64::from(unsafe { T::imp::<S>(crow.add(ibo), rrow.add(ibo), stride) });
        }
        for bx in full * IMP_BATCH..wb {
            let o = bx * BLK;
            let c = unsafe { crow.add(o) };
            let r = unsafe { rrow.add(o) };
            intra += u64::from(satd8x8_dc_blk::<T, S>(c, stride, dc));
            inter += u64::from(satd8x8_blk::<T, S>(c, stride, r, stride));
            let cs = sum8x8_blk::<T, S>(c, stride);
            let rs = sum8x8_blk::<T, S>(r, stride);
            imp += u64::from((((cs + 32) >> 6) - ((rs + 32) >> 6)).unsigned_abs());
        }
    }
    (intra, inter, imp)
}

#[derive(Clone, Copy, Default)]
struct ScenecutResult {
    inter_cost: f64,
    imp_block_cost: f64,
    threshold: f64,
    backward_adjusted_cost: f64,
    forward_adjusted_cost: f64,
}

#[derive(Clone, Copy)]
struct Dims {
    w: usize,
    h: usize,
    cv: usize,
    ch: usize,
}

struct Fr {
    av: *mut VidFrame,
    data: *const u8,
    stride: usize,
}

unsafe impl Send for Fr {}
unsafe impl Sync for Fr {}

impl Drop for Fr {
    fn drop(&mut self) {
        let mut a = self.av;
        unsafe { av_frame_free(&raw mut a) };
    }
}

unsafe fn make_fr<T: Pixel>(av: *mut VidFrame, dims: &Dims) -> Fr {
    unsafe {
        let lb = (*av).linesize[0] as usize;
        let data = (*av).data[0].add(dims.cv * lb + dims.ch * size_of::<T>());
        Fr {
            av,
            data,
            stride: lb / size_of::<T>(),
        }
    }
}

struct Detector {
    deque_offset: usize,
    score_deque: VecDeque<ScenecutResult>,
    bit_depth: usize,
    npix: f64,
    wb: usize,
    hb: usize,
}

impl Detector {
    fn new(bit_depth: usize, wb: usize, hb: usize) -> Self {
        Self {
            deque_offset: LOOKAHEAD,
            score_deque: VecDeque::with_capacity(2 * LOOKAHEAD + 1),
            bit_depth,
            npix: (wb * hb) as f64,
            wb,
            hb,
        }
    }

    fn run_comparison<T: Pixel, const S: bool>(
        &mut self,
        prev: &Fr,
        cur: &Fr,
        input_frameno: usize,
    ) {
        let cp = cur.data.cast::<T>();
        let pp = prev.data.cast::<T>();
        let st = cur.stride;
        let (intra, inter, imp) = cost_sums::<T, S>(cp, pp, st, self.wb, self.hb);
        let n = self.npix;
        let mut result = ScenecutResult {
            inter_cost: inter as f64 / n,
            imp_block_cost: imp as f64 / n,
            threshold: (intra as f64 / n) * (1.0 - BIAS),
            backward_adjusted_cost: 0.0,
            forward_adjusted_cost: 0.0,
        };
        if self.deque_offset > 0 {
            if input_frameno == 1 {
                result.backward_adjusted_cost = 0.0;
            } else {
                let mut adjusted = f64::MAX;
                for other in self
                    .score_deque
                    .iter()
                    .take(self.deque_offset)
                    .map(|i| i.inter_cost)
                {
                    let this = result.inter_cost - other;
                    if this < adjusted {
                        adjusted = this;
                    }
                    if adjusted < 0.0 {
                        adjusted = 0.0;
                        break;
                    }
                }
                result.backward_adjusted_cost = adjusted;
            }
            for (i, s) in self
                .score_deque
                .iter_mut()
                .take(self.deque_offset)
                .enumerate()
            {
                let adj = s.inter_cost - result.inter_cost;
                if i == 0 || adj < s.forward_adjusted_cost {
                    s.forward_adjusted_cost = adj;
                }
                if s.forward_adjusted_cost < 0.0 {
                    s.forward_adjusted_cost = 0.0;
                }
            }
        }
        self.score_deque.push_front(result);
    }

    fn adaptive_scenecut(&self) -> (bool, ScenecutResult) {
        let score = self.score_deque[self.deque_offset];
        let imp_threshold = IMP_BLOCK_DIFF_THRESHOLD * self.bit_depth as f64 / 8.0;
        if !self
            .score_deque
            .iter()
            .skip(self.deque_offset)
            .any(|r| r.imp_block_cost >= imp_threshold)
        {
            return (false, score);
        }

        let cost = score.forward_adjusted_cost;
        if cost >= score.threshold {
            let back_over = self
                .score_deque
                .iter()
                .skip(self.deque_offset + 1)
                .filter(|r| r.backward_adjusted_cost >= r.threshold)
                .count();
            let forward_over = self
                .score_deque
                .iter()
                .take(self.deque_offset)
                .filter(|r| r.forward_adjusted_cost >= r.threshold)
                .count();

            if forward_over == 0 && back_over >= 1 {
                return (true, score);
            }
            if back_over == 0
                && forward_over == 1
                && self.score_deque[0].forward_adjusted_cost >= self.score_deque[0].threshold
            {
                return (true, score);
            }
            if back_over != 0 || forward_over != 0 {
                return (false, score);
            }
        }
        (cost >= score.threshold, score)
    }

    fn analyze_next_frame<T: Pixel, const S: bool>(
        &mut self,
        window: &VecDeque<Fr>,
        set_len: usize,
        frameno: usize,
    ) -> (bool, Option<ScenecutResult>) {
        if set_len <= LOOKAHEAD {
            return (false, None);
        }
        if self.deque_offset > 0 && set_len > self.deque_offset + 1 && self.score_deque.is_empty() {
            for x in 0..self.deque_offset {
                self.run_comparison::<T, S>(&window[x], &window[x + 1], frameno + x);
            }
        } else if self.score_deque.is_empty() {
            for x in 0..set_len - 1 {
                self.run_comparison::<T, S>(&window[x], &window[x + 1], frameno + x);
            }
            self.deque_offset = set_len - 2;
        }
        if set_len > self.deque_offset + 1 {
            self.run_comparison::<T, S>(
                &window[self.deque_offset],
                &window[self.deque_offset + 1],
                frameno + self.deque_offset,
            );
        } else {
            self.deque_offset -= 1;
        }

        let (scenecut, score) = self.adaptive_scenecut();
        if self.score_deque.len() > 2 * LOOKAHEAD {
            self.score_deque.pop_back();
        }
        (scenecut, Some(score))
    }
}

fn run_detection<T: Pixel, const S: bool>(
    ring: &SpscRing,
    dims: Dims,
    bit_depth: usize,
    tot_frames: usize,
) -> (Vec<usize>, Weights) {
    let wb = dims.w / BLK;
    let hb = dims.h / BLK;
    let mut detector = Detector::new(bit_depth, wb, hb);
    let mut keyframes = vec![0usize];
    let mut weights: Weights = vec![None; tot_frames];
    let mut window: VecDeque<Fr> = VecDeque::new();
    let mut frameno = 0usize;
    let mut next_in = 0usize;
    loop {
        let max_needed = (frameno + LOOKAHEAD + 1).min(tot_frames);
        while next_in < max_needed {
            let p = unsafe { spsc_recv(ring) };
            if p == 0 {
                cold_path();
                break;
            }
            window.push_back(unsafe { make_fr::<T>(p as *mut VidFrame, &dims) });
            next_in += 1;
        }
        let set_len = window.len().min(LOOKAHEAD + 2);
        if set_len < 2 {
            break;
        }
        if frameno != 0 {
            let (cut, score) = detector.analyze_next_frame::<T, S>(&window, set_len, frameno);
            if let Some(s) = score {
                weights[frameno] = Some((s.inter_cost as f32, s.threshold as f32));
            }
            if cut {
                keyframes.push(frameno);
            }
            window.pop_front();
        }
        frameno += 1;
    }
    (keyframes, weights)
}

fn detect<T: Pixel, const S: bool>(
    dec: &mut VidDecoder,
    dims: &Dims,
    tot_frames: usize,
    bit_depth: usize,
    line: usize,
) -> (Vec<usize>, Weights) {
    let dims = *dims;
    let ring = Arc::new(SpscRing::new());
    let ring2 = Arc::clone(&ring);
    let det = spawn(move || run_detection::<T, S>(&ring2, dims, bit_depth, tot_frames));
    let rp = Arc::as_ptr(&ring);
    let mut pb = ProgsBar::new();
    let mut i = 0usize;
    while i < tot_frames {
        let vf = dec.dec_next();
        if dec.is_eof() {
            break;
        }
        let av = unsafe { av_frame_alloc() };
        unsafe { av_frame_move_ref(av, vf.cast_mut()) };
        unsafe { spsc_send(rp, av as u64) };
        i += 1;
        pb.up_frames(i, tot_frames, line, "SCD");
    }
    unsafe { spsc_close(rp) };
    pb.up_frames(tot_frames, tot_frames, line, "SCD");
    unsafe { det.join().unwrap_unchecked() }
}

pub fn fd_scenes(
    vid_path: &Path,
    sc_file: &Path,
    inf: &VidInf,
    crop: (u32, u32),
    line: usize,
    hwdec: bool,
) -> Result<(), Xerr> {
    let tot_frames = inf.frames;
    let (cv, ch) = crop;
    let dims = Dims {
        w: (inf.width - ch * 2) as usize,
        h: (inf.height - cv * 2) as usize,
        cv: cv as usize,
        ch: ch as usize,
    };

    let thr = unsafe { available_parallelism().unwrap_unchecked() }.get() as i32;
    let mut dec = if hwdec {
        VidDecoder::new_hw(vid_path, thr)
    } else {
        VidDecoder::new(vid_path, thr)
    }
    .map_err(|e| e.to_string())?;

    let bit_depth = if inf.is_10b { 10 } else { 8 };

    let (scene_changes, weights) = match (inf.is_10b, hwdec) {
        (false, _) => detect::<u8, false>(&mut dec, &dims, tot_frames, bit_depth, line),
        (true, false) => detect::<u16, false>(&mut dec, &dims, tot_frames, bit_depth, line),
        (true, true) => detect::<u16, true>(&mut dec, &dims, tot_frames, bit_depth, line),
    };

    let new_scenes = refine_scenes(&scene_changes, tot_frames, &weights);

    let mut content = String::new();
    for &scene_frame in &new_scenes {
        _ = writeln!(content, "{scene_frame}");
    }
    fs_write(sc_file, content)?;
    Ok(())
}

fn refine_scenes(
    scene_changes: &[usize],
    tot_frames: usize,
    scores: &[Option<(f32, f32)>],
) -> Vec<usize> {
    let mut new_scenes = vec![0];
    let mut last = 0;

    for (i, &s_frame) in scene_changes.iter().enumerate() {
        let e_frame = scene_changes.get(i + 1).copied().unwrap_or(tot_frames);
        let mut current_start = s_frame.max(last);
        let mut distance = e_frame - current_start;

        while distance > MAX_DIST {
            let minimum_split_cnt = distance / MAX_DIST;
            let middle_point = distance / (minimum_split_cnt + 1);
            let min_sz = middle_point / 2;
            let max_sz = min(MAX_DIST, middle_point + min_sz);
            let range_sz = max_sz - min_sz;

            let split_point = (min_sz..=max_sz)
                .filter_map(|size| {
                    scores[current_start + size].map(|(inter, threshold)| {
                        let inter_score = inter / threshold;
                        let dist_from_mid = middle_point.abs_diff(size) as f32;
                        let weight = 1.0 - dist_from_mid / range_sz as f32;
                        (size, inter_score * weight)
                    })
                })
                .max_by_key(|&(_, score)| (score * 10000.0).round() as u64)
                .map_or(middle_point, |(size, _)| size);

            current_start += split_point;
            new_scenes.push(current_start);
            distance = e_frame - current_start;
        }

        new_scenes.push(e_frame);
        last = e_frame;
    }

    if new_scenes.last() == Some(&tot_frames) {
        new_scenes.pop();
    }

    new_scenes
}
