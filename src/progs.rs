use std::{
    fmt::{self, Write as _},
    io::{Read, Write as _, stdout as io_stdout},
    iter::repeat_with,
    str::{from_utf8, from_utf8_unchecked},
    sync::{
        Arc, Mutex, MutexGuard, PoisonError,
        atomic::{AtomicBool, AtomicU64, AtomicUsize, Ordering::Relaxed},
    },
    thread::{JoinHandle, sleep, spawn},
    time::{Duration, Instant},
};

use crate::{
    chunk::{Chunk, PRIOR_SECS},
    encoder::{
        Encoder,
        Encoder::{Avm, SvtAv1, Vvenc, X264, X265},
    },
    error::eprint,
    ffms::VidInf,
};

const BAR_WIDTH: usize = 20;
const INTERVAL_MS: u64 = 500;
const READ_CAP: usize = 8192;

use crate::util::{B, C, G, N, P, R, W, Y, assume_unreachable};

const G_HASH: &str = "\x1b[1;92m#";
const R_DASH: &str = "\x1b[1;91m-";
const B_HASH: &str = "\x1b[1;94m#";
const Y_DASH: &str = "\x1b[1;93m-";

const LINE_CAP: usize = 512;

#[derive(Clone)]
struct Line {
    buf: [u8; LINE_CAP],
    len: usize,
}

impl Line {
    const fn new() -> Self {
        Self {
            buf: [0; LINE_CAP],
            len: 0,
        }
    }

    fn as_str(&self) -> &str {
        unsafe { from_utf8_unchecked(self.buf.get_unchecked(..self.len)) }
    }
}

impl fmt::Write for Line {
    fn write_str(&mut self, s: &str) -> fmt::Result {
        let b = s.as_bytes();
        let n = b.len().min(LINE_CAP - self.len);
        unsafe {
            self.buf
                .get_unchecked_mut(self.len..self.len + n)
                .copy_from_slice(b.get_unchecked(..n));
        }
        self.len += n;
        Ok(())
    }
}

fn write_el(w: &mut impl fmt::Write, h: usize, m: usize) {
    if h != 0 || m != 0 {
        _ = write!(w, "{W}{h:02}{P}:{W}{m:02} ");
    }
}

fn write_eta(w: &mut impl fmt::Write, h: usize, m: usize) {
    if h != 0 || m != 0 {
        _ = write!(w, "{C}, {W}-{h:02}{P}:{W}{m:02}");
    }
}

fn write_tag(w: &mut impl fmt::Write, idx: u16, cs: Option<(f32, Option<f32>)>) {
    match cs {
        Some((c, Some(s))) => _ = write!(w, "{C}[{idx:04} / F {c:5.2} / {s:5.2}{C}]"),
        Some((c, None)) => _ = write!(w, "{C}[{idx:04} / F {c:5.2} / {:5}{C}]", ""),
        None => _ = write!(w, "{C}[{idx:04}{C}]"),
    }
}

fn write_bar(w: &mut impl fmt::Write, filled: usize, hash: &str, dash: &str) {
    for _ in 0..filled {
        _ = w.write_str(hash);
    }
    for _ in filled..BAR_WIDTH {
        _ = w.write_str(dash);
    }
}

pub struct ProgsBar {
    start: Instant,
    total: usize,
    last_update: Instant,
}

impl ProgsBar {
    pub fn new() -> Self {
        let now = Instant::now();
        Self {
            start: now,
            total: 0,
            last_update: now,
        }
    }

    pub fn up_scenes(&mut self, current: usize, total: usize, line: usize) {
        if self.last_update.elapsed() < Duration::from_millis(INTERVAL_MS) {
            return;
        }
        self.last_update = Instant::now();

        self.total = total;
        let elapsed = self.start.elapsed().as_secs() as usize;
        let fps = current / elapsed.max(1);
        let remaining = total.saturating_sub(current);
        let eta_secs = remaining * elapsed / current.max(1);
        let filled = (BAR_WIDTH * current / total.max(1)).min(BAR_WIDTH);
        let perc = (current * 100 / total.max(1)).min(100);

        let mut l = Line::new();
        if line > 0 {
            _ = write!(l, "\x1b[{line};1H\x1b[2K");
        } else {
            _ = write!(l, "\r\x1b[2K");
        }
        write_el(&mut l, elapsed / 3600, (elapsed % 3600) / 60);
        _ = write!(l, "{W}SCD: {C}[");
        write_bar(&mut l, filled, G_HASH, R_DASH);
        _ = write!(l, "{C}] {W}{perc}%{C}, {Y}{fps} FPS");
        write_eta(&mut l, eta_secs / 3600, (eta_secs % 3600) / 60);
        _ = write!(l, "{C}, {G}{current}{C}/{R}{total}{N}");
        print!("{}", l.as_str());
        _ = io_stdout().flush();
    }

    pub fn up_scenes_final(&mut self, total: usize, line: usize) {
        self.last_update = unsafe {
            Instant::now()
                .checked_sub(Duration::from_secs(1))
                .unwrap_unchecked()
        };
        self.up_scenes(total, total, line);
    }

    pub fn up_audio(&mut self, current: usize, total: usize, line: usize, pass: u8, track_id: u8) {
        if self.last_update.elapsed() < Duration::from_millis(INTERVAL_MS) {
            return;
        }
        self.last_update = Instant::now();

        self.total = total;
        let elapsed = self.start.elapsed().as_secs() as usize;
        let speed = current as f32 / elapsed.max(1) as f32 / 48000.0;
        let remaining = total.saturating_sub(current);
        let eta_secs = remaining * elapsed / current.max(1);
        let filled = (BAR_WIDTH * current / total.max(1)).min(BAR_WIDTH);
        let perc = (current * 100 / total.max(1)).min(100);
        let dur = total / 48000;
        let (dh, dm, ds) = (dur / 3600, (dur % 3600) / 60, dur % 60);

        let mut l = Line::new();
        if line > 0 {
            _ = write!(l, "\x1b[{line};1H\x1b[2K");
        } else {
            _ = write!(l, "\r\x1b[2K");
        }
        _ = write!(l, "{C}[{W}{track_id:02}{C}] ");
        write_el(&mut l, elapsed / 3600, (elapsed % 3600) / 60);
        _ = write!(l, "{W}AU P{pass}: {C}[");
        write_bar(&mut l, filled, G_HASH, R_DASH);
        _ = write!(l, "{C}] {W}{perc}%{C}, {Y}{speed:.1}x");
        write_eta(&mut l, eta_secs / 3600, (eta_secs % 3600) / 60);
        _ = write!(l, "{C}, {G}{dh:02}{P}:{G}{dm:02}{P}:{G}{ds:02}{N}");
        print!("{}", l.as_str());
        _ = io_stdout().flush();
    }

    pub fn up_audio_final(&mut self, total: usize, line: usize, pass: u8, track_id: u8) {
        self.last_update = unsafe {
            Instant::now()
                .checked_sub(Duration::from_secs(1))
                .unwrap_unchecked()
        };
        self.up_audio(total, total, line, pass, track_id);
    }

    pub const fn finish_audio() {}

    pub const fn finish_scenes() {}
}

fn guard(m: &Mutex<Line>) -> MutexGuard<'_, Line> {
    m.lock().unwrap_or_else(PoisonError::into_inner)
}

struct Shared {
    boards: Vec<Mutex<Line>>,
    processed: AtomicUsize,
    stop: AtomicBool,
    start: Instant,
    total_chunks: usize,
    total_frames: usize,
    fps_num: u32,
    fps_den: u32,
    completed: Arc<AtomicUsize>,
    completed_frames: Arc<AtomicUsize>,
    total_size: Arc<AtomicU64>,
    init_frames: usize,
}

impl Shared {
    fn put(&self, id: usize, line: Line) {
        if let Some(m) = self.boards.get(id) {
            *guard(m) = line;
        }
    }

    fn clear(&self, id: usize) {
        if let Some(m) = self.boards.get(id) {
            *guard(m) = Line::new();
        }
    }
}

#[derive(Clone, Copy)]
pub struct Watch {
    pub worker_id: usize,
    pub chunk_idx: u16,
    pub frames: usize,
    pub track_frames: bool,
    pub crf_score: Option<(f32, Option<f32>)>,
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
        chunks: &[Chunk],
        inf: &VidInf,
        worker_count: usize,
        init_frames: usize,
        completed: Arc<AtomicUsize>,
        completed_frames: Arc<AtomicUsize>,
        total_size: Arc<AtomicU64>,
    ) -> (Self, JoinHandle<()>) {
        print!("\x1b[s");
        _ = io_stdout().flush();

        let total_frames = chunks.iter().map(|c| c.end - c.start).sum();

        let inner = Arc::new(Shared {
            boards: repeat_with(|| Mutex::new(Line::new()))
                .take(worker_count)
                .collect(),
            processed: AtomicUsize::new(0),
            stop: AtomicBool::new(false),
            start: Instant::now(),
            total_chunks: chunks.len(),
            total_frames,
            fps_num: inf.fps_num,
            fps_den: inf.fps_den,
            completed,
            completed_frames,
            total_size,
            init_frames,
        });

        let disp = Arc::clone(&inner);
        let handle = spawn(move || display_loop(&disp));

        (Self { inner }, handle)
    }

    pub fn watch_enc<R: Read + Send + 'static>(&self, stderr: R, w: Watch, encoder: Encoder) {
        let inner = Arc::clone(&self.inner);

        spawn(move || match encoder {
            SvtAv1 => assume_unreachable(),
            Avm => watch_avm(&inner, stderr, w),
            X265 | X264 => watch_x265(&inner, stderr, w),
            Vvenc => watch_vvenc(&inner, stderr, w),
        });
    }

    #[cfg(feature = "vship")]
    pub fn show_metric_progress(
        &self,
        worker_id: usize,
        chunk_idx: u16,
        progress: (usize, usize),
        fps: f32,
        crf_score: (f32, Option<f32>),
    ) {
        let (current, total) = progress;
        let filled = (BAR_WIDTH * current / total.max(1)).min(BAR_WIDTH);
        let perc = (current * 100 / total.max(1)).min(100);

        let mut line = Line::new();
        write_tag(&mut line, chunk_idx, Some(crf_score));
        _ = write!(line, " [");
        write_bar(&mut line, filled, G_HASH, R_DASH);
        _ = write!(
            line,
            "{C}] {W}{perc:3}%{C}, {Y}{fps:6.2}{C}, {G}{current:3}{C}/{R}{total:3}"
        );

        self.inner.put(worker_id, line);
    }

    pub fn update_lib_enc(
        &self,
        worker_id: usize,
        chunk_idx: u16,
        progress: (usize, usize),
        fps: f32,
        frames_delta: Option<usize>,
        crf_score: Option<(f32, Option<f32>)>,
    ) {
        let (current, total) = progress;
        let filled = (BAR_WIDTH * current / total.max(1)).min(BAR_WIDTH);
        let perc = (current * 100 / total.max(1)).min(100);

        let mut line = Line::new();
        write_tag(&mut line, chunk_idx, crf_score);
        _ = write!(line, " {P}[");
        write_bar(&mut line, filled, B_HASH, Y_DASH);
        _ = write!(
            line,
            "{P}] {W}{perc:3}%{C}, {Y}{fps:6.2}{C}, {G}{current:3}{C}/{R}{total:3}"
        );

        if let Some(d) = frames_delta {
            self.inner.processed.fetch_add(d, Relaxed);
        }
        self.inner.put(worker_id, line);
    }

    pub fn clear_lib_enc(&self, worker_id: usize) {
        self.inner.clear(worker_id);
    }
}

pub struct LibEncTracker {
    start: Instant,
    pub encoded: usize,
    last_reported: usize,
    pub worker_id: usize,
    chunk_idx: u16,
    total: usize,
    track_frames: bool,
    crf_score: Option<(f32, Option<f32>)>,
}

impl LibEncTracker {
    pub fn new(
        worker_id: usize,
        chunk_idx: u16,
        total: usize,
        track_frames: bool,
        crf_score: Option<(f32, Option<f32>)>,
    ) -> Self {
        Self {
            start: Instant::now(),
            encoded: 0,
            last_reported: 0,
            worker_id,
            chunk_idx,
            total,
            track_frames,
            crf_score,
        }
    }

    pub fn report(&mut self, prog: &ProgsTrack) {
        if self.encoded == self.last_reported {
            return;
        }
        let fps = self.encoded as f32 / self.start.elapsed().as_secs_f32().max(0.001);
        let delta = self.encoded - self.last_reported;
        self.last_reported = self.encoded;
        prog.update_lib_enc(
            self.worker_id,
            self.chunk_idx,
            (self.encoded, self.total),
            fps,
            self.track_frames.then_some(delta),
            self.crf_score,
        );
    }
}

fn watch_avm(inner: &Shared, rd: impl Read, w: Watch) {
    let Watch {
        worker_id,
        chunk_idx,
        frames,
        track_frames,
        crf_score,
    } = w;
    let started = Instant::now();
    let mut lr = LineReader::new(rd, b'\n');
    let mut poc_count = 0;
    let mut last_poc = 0;
    let mut last_update = Instant::now();

    loop {
        if !lr.fill() {
            break;
        }

        while let Some(rec) = lr.next_buffered() {
            let Ok(raw) = from_utf8(rec) else {
                continue;
            };
            let text = raw.trim();
            if text.contains("error") || text.contains("Error") {
                eprint(format_args!("{text}"));
            }
            if text.starts_with("POC") {
                poc_count += 1;
            }
        }

        if last_update.elapsed() >= Duration::from_millis(INTERVAL_MS) {
            last_update = Instant::now();

            let total = frames.max(poc_count);
            let fps = poc_count as f32 / started.elapsed().as_secs_f32().max(0.001);
            let filled = (BAR_WIDTH * poc_count / total.max(1)).min(BAR_WIDTH);
            let perc = (poc_count * 100 / total.max(1)).min(100);

            let mut line = Line::new();
            write_tag(&mut line, chunk_idx, crf_score);
            _ = write!(line, " {P}[");
            write_bar(&mut line, filled, B_HASH, Y_DASH);
            _ = write!(
                line,
                "{P}] {W}{perc:3}%{C}, {Y}{fps:6.2}{C}, {G}{poc_count:3}{C}/{R}{total:3}"
            );

            if track_frames {
                let d = poc_count.saturating_sub(last_poc);
                last_poc = poc_count;
                inner.processed.fetch_add(d, Relaxed);
            }
            inner.put(worker_id, line);
        }
    }

    inner.clear(worker_id);
}

struct LineReader<R: Read> {
    rd: R,
    acc: [u8; READ_CAP],
    len: usize,
    start: usize,
    delim: u8,
}

impl<R: Read> LineReader<R> {
    const fn new(rd: R, delim: u8) -> Self {
        Self {
            rd,
            acc: [0; READ_CAP],
            len: 0,
            start: 0,
            delim,
        }
    }

    fn fill(&mut self) -> bool {
        match self.rd.read(&mut self.acc[self.len..]) {
            Ok(0) | Err(_) => false,
            Ok(n) => {
                self.len += n;
                true
            }
        }
    }

    fn next_buffered(&mut self) -> Option<&[u8]> {
        let buf = &self.acc[self.start..self.len];
        if let Some(rel) = buf.iter().position(|&b| b == self.delim) {
            let s = self.start;
            self.start = s + rel + 1;
            return Some(&self.acc[s..s + rel]);
        }
        self.acc.copy_within(self.start..self.len, 0);
        self.len -= self.start;
        self.start = 0;
        if self.len == READ_CAP {
            self.len = 0;
        }
        None
    }
}

fn watch_vvenc(inner: &Shared, rd: impl Read, w: Watch) {
    let Watch {
        worker_id,
        chunk_idx,
        frames,
        track_frames,
        crf_score,
    } = w;
    let started = Instant::now();
    let mut lr = LineReader::new(rd, b'\n');
    let mut poc_count = 0;
    let mut last_poc = 0;
    let mut last_update = Instant::now();

    loop {
        if !lr.fill() {
            break;
        }

        while let Some(rec) = lr.next_buffered() {
            let Ok(raw) = from_utf8(rec) else {
                continue;
            };
            let text = raw.trim();
            if text.contains("error") || text.contains("Error") {
                eprint(format_args!("{text}"));
            }
            if text.starts_with("POC") {
                poc_count += 1;
            }
        }

        if last_update.elapsed() >= Duration::from_millis(INTERVAL_MS) {
            last_update = Instant::now();

            let total = frames.max(poc_count);
            let fps = poc_count as f32 / started.elapsed().as_secs_f32().max(0.001);
            let filled = (BAR_WIDTH * poc_count / total.max(1)).min(BAR_WIDTH);
            let perc = (poc_count * 100 / total.max(1)).min(100);

            let mut line = Line::new();
            write_tag(&mut line, chunk_idx, crf_score);
            _ = write!(line, " {P}[");
            write_bar(&mut line, filled, B_HASH, Y_DASH);
            _ = write!(
                line,
                "{P}] {W}{perc:3}%{C}, {Y}{fps:6.2}{C}, {G}{poc_count:3}{C}/{R}{total:3}"
            );

            if track_frames {
                let d = poc_count.saturating_sub(last_poc);
                last_poc = poc_count;
                inner.processed.fetch_add(d, Relaxed);
            }
            inner.put(worker_id, line);
        }
    }

    inner.clear(worker_id);
}

fn watch_x265(inner: &Shared, rd: impl Read, w: Watch) {
    let Watch {
        worker_id,
        chunk_idx,
        frames,
        track_frames,
        crf_score,
    } = w;
    let mut lr = LineReader::new(rd, b'\r');
    let mut last_frames = 0;
    let mut last_update = Instant::now();

    loop {
        if !lr.fill() {
            break;
        }

        while let Some(rec) = lr.next_buffered() {
            let Ok(raw) = from_utf8(rec) else {
                continue;
            };
            let text = raw.trim();

            if text.is_empty() {
                continue;
            }

            if !text.starts_with('[') {
                if !text.starts_with("encoded") {
                    eprint(format_args!("{text}"));
                }
                continue;
            }

            if last_update.elapsed() < Duration::from_millis(INTERVAL_MS) {
                continue;
            }
            last_update = Instant::now();

            let Some((cur, fps, kbps)) = parse_x265(text) else {
                continue;
            };

            let filled = (BAR_WIDTH * cur / frames.max(1)).min(BAR_WIDTH);
            let perc = cur * 100 / frames.max(1);

            let mut line = Line::new();
            write_tag(&mut line, chunk_idx, crf_score);
            _ = write!(line, " {P}[");
            write_bar(&mut line, filled, B_HASH, Y_DASH);
            _ = write!(
                line,
                "{P}] {W}{perc:3}% {Y}{cur:3}/{frames:3} {G}{fps:6.2} {W}| {P}{kbps:.0} kb/s"
            );

            if track_frames {
                let d = cur.saturating_sub(last_frames);
                last_frames = cur;
                inner.processed.fetch_add(d, Relaxed);
            }
            inner.put(worker_id, line);
        }
    }

    inner.clear(worker_id);
}

fn parse_x265(s: &str) -> Option<(usize, f32, f32)> {
    let rest = s.split(']').nth(1)?;
    let mut parts = rest.split(',');

    let cur = parts
        .next()?
        .trim()
        .split('/')
        .next()?
        .trim()
        .parse()
        .ok()?;
    let fps = parts.next()?.split_whitespace().next()?.parse().ok()?;
    let kbps = parts.next()?.split_whitespace().next()?.parse().ok()?;

    Some((cur, fps, kbps))
}

fn display_loop(s: &Shared) {
    loop {
        sleep(Duration::from_millis(INTERVAL_MS));
        if s.stop.load(Relaxed) {
            break;
        }
        draw_screen(s);
    }
    draw_screen(s);
}

fn draw_screen(s: &Shared) {
    print!("\x1b[u");

    for m in &s.boards {
        let snap = guard(m).clone();
        if snap.len == 0 {
            print!("\r\x1b[2K\n");
        } else {
            print!("\r\x1b[2K{}\n", snap.as_str());
        }
    }

    print!("\r\x1b[2K\n");

    let completed_frames = s.completed_frames.load(Relaxed);
    let total_size = s.total_size.load(Relaxed);

    let processed_frames = s.processed.load(Relaxed);
    let frames_done = completed_frames.max(s.init_frames + processed_frames);

    let elapsed_secs = PRIOR_SECS.load(Relaxed) as usize + s.start.elapsed().as_secs() as usize;
    let fps = frames_done as f32 / elapsed_secs.max(1) as f32;
    let remaining = s.total_frames.saturating_sub(frames_done);
    let eta_secs = remaining * elapsed_secs / frames_done.max(1);
    let chunks_done = s.completed.load(Relaxed);

    let progress = (frames_done * BAR_WIDTH / s.total_frames.max(1)).min(BAR_WIDTH);
    let perc = (frames_done * 100 / s.total_frames.max(1)).min(100);

    let mut agg = Line::new();
    _ = write!(agg, "\r\x1b[2K");
    write_el(&mut agg, elapsed_secs / 3600, (elapsed_secs % 3600) / 60);
    _ = write!(agg, "{C}[{G}{chunks_done}{C}/{R}{}{C}] [", s.total_chunks);
    write_bar(&mut agg, progress, G_HASH, R_DASH);
    _ = write!(
        agg,
        "{C}] {W}{perc}% {G}{frames_done}{C}/{R}{} {C}({Y}{fps:.2}",
        s.total_frames
    );
    if eta_secs >= 99 * 3600 {
        _ = write!(agg, "{C}, {W}-99:99");
    } else {
        write_eta(&mut agg, eta_secs / 3600, (eta_secs % 3600) / 60);
    }
    _ = write!(agg, "{C}, ");
    if completed_frames > 0 {
        let dur = completed_frames as f32 * s.fps_den as f32 / s.fps_num as f32;
        let kbps = total_size as f32 * 8.0 / dur / 1000.0;
        let total_dur = s.total_frames as f32 * s.fps_den as f32 / s.fps_num as f32;
        let est_size = kbps * total_dur * 1000.0 / 8.0;
        _ = write!(agg, "{B}{kbps:.0}k{C}, ");
        if est_size > 1_000_000_000.0 {
            _ = write!(agg, "{R}{:.1}g", est_size / 1_000_000_000.0);
        } else {
            _ = write!(agg, "{R}{:.1}m", est_size / 1_000_000.0);
        }
    } else {
        _ = write!(agg, "{B}0k{C}, {R}0m");
    }
    _ = writeln!(agg, "{C}{N})");
    print!("{}", agg.as_str());
    _ = io_stdout().flush();
}
