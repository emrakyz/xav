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
    time::{Duration as Durat, Instant},
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
    _ = write!(w, "{W}{h:02}{P}:{W}{m:02} ");
}

fn write_eta(w: &mut impl fmt::Write, h: usize, m: usize) {
    _ = write!(w, "{C}, {W}-{h:02}{P}:{W}{m:02}");
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
    tot: usize,
    last_update: Instant,
}

impl ProgsBar {
    pub fn new() -> Self {
        let now = Instant::now();
        Self {
            start: now,
            tot: 0,
            last_update: now,
        }
    }

    pub fn up_frames(&mut self, current: usize, tot: usize, line: usize, label: &str) {
        if current < tot && self.last_update.elapsed() < Durat::from_millis(INTERVAL_MS) {
            return;
        }
        self.last_update = Instant::now();

        self.tot = tot;
        let elapsed = self.start.elapsed().as_secs() as usize;
        let fps = current / elapsed.max(1);
        let remaining = tot.saturating_sub(current);
        let eta_secs = remaining * elapsed / current.max(1);
        let filled = (BAR_WIDTH * current / tot.max(1)).min(BAR_WIDTH);
        let perc = (current * 100 / tot.max(1)).min(100);

        let mut l = Line::new();
        if line > 0 {
            _ = write!(l, "\x1b[{line};1H\x1b[2K");
        } else {
            _ = write!(l, "\r\x1b[2K");
        }
        write_el(&mut l, elapsed / 3600, (elapsed % 3600) / 60);
        _ = write!(l, "{W}{label}: {C}[");
        write_bar(&mut l, filled, G_HASH, R_DASH);
        _ = write!(l, "{C}] {W}{perc}%{C}, {Y}{fps} FPS");
        write_eta(&mut l, eta_secs / 3600, (eta_secs % 3600) / 60);
        _ = write!(l, "{C}, {G}{current}{C}/{R}{tot}{N}");
        print!("{}", l.as_str());
        _ = io_stdout().flush();
    }

    pub fn up_au(&mut self, current: usize, tot: usize, line: usize, pass: u8, track_id: u8) {
        if current < tot && self.last_update.elapsed() < Durat::from_millis(INTERVAL_MS) {
            return;
        }
        self.last_update = Instant::now();

        self.tot = tot;
        let elapsed = self.start.elapsed().as_secs() as usize;
        let spd = current as f32 / elapsed.max(1) as f32 / 48000.0;
        let remaining = tot.saturating_sub(current);
        let eta_secs = remaining * elapsed / current.max(1);
        let filled = (BAR_WIDTH * current / tot.max(1)).min(BAR_WIDTH);
        let perc = (current * 100 / tot.max(1)).min(100);
        let dur = tot / 48000;
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
        _ = write!(l, "{C}] {W}{perc}%{C}, {Y}{spd:.1}x");
        write_eta(&mut l, eta_secs / 3600, (eta_secs % 3600) / 60);
        _ = write!(l, "{C}, {G}{dh:02}{P}:{G}{dm:02}{P}:{G}{ds:02}{N}");
        print!("{}", l.as_str());
        _ = io_stdout().flush();
    }
}

fn guard(m: &Mutex<Line>) -> MutexGuard<'_, Line> {
    m.lock().unwrap_or_else(PoisonError::into_inner)
}

struct Shared {
    boards: Vec<Mutex<Line>>,
    processed: AtomicUsize,
    stop: AtomicBool,
    start: Instant,
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
    pub chnk_idx: u16,
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
            boards: repeat_with(|| Mutex::new(Line::new()))
                .take(worker_cnt)
                .collect(),
            processed: AtomicUsize::new(0),
            stop: AtomicBool::new(false),
            start: Instant::now(),
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
    pub fn show_metric_progs(
        &self,
        worker_id: usize,
        chnk_idx: u16,
        progs: (usize, usize),
        fps: f32,
        crf_score: (f32, Option<f32>),
    ) {
        let (current, tot) = progs;
        let filled = (BAR_WIDTH * current / tot.max(1)).min(BAR_WIDTH);
        let perc = (current * 100 / tot.max(1)).min(100);

        let mut line = Line::new();
        write_tag(&mut line, chnk_idx, Some(crf_score));
        _ = write!(line, " [");
        write_bar(&mut line, filled, G_HASH, R_DASH);
        _ = write!(
            line,
            "{C}] {W}{perc:3}%{C}, {Y}{fps:6.2}{C}, {G}{current:3}{C}/{R}{tot:3}"
        );

        self.inner.put(worker_id, line);
    }

    pub fn up_lib_enc(
        &self,
        worker_id: usize,
        chnk_idx: u16,
        progs: (usize, usize),
        fps: f32,
        frames_delta: Option<usize>,
        crf_score: Option<(f32, Option<f32>)>,
    ) {
        let (current, tot) = progs;
        let filled = (BAR_WIDTH * current / tot.max(1)).min(BAR_WIDTH);
        let perc = (current * 100 / tot.max(1)).min(100);

        let mut line = Line::new();
        write_tag(&mut line, chnk_idx, crf_score);
        _ = write!(line, " {P}[");
        write_bar(&mut line, filled, B_HASH, Y_DASH);
        _ = write!(
            line,
            "{P}] {W}{perc:3}%{C}, {Y}{fps:6.2}{C}, {G}{current:3}{C}/{R}{tot:3}"
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
    pub enced: usize,
    last_reported: usize,
    pub worker_id: usize,
    chnk_idx: u16,
    tot: usize,
    track_frames: bool,
    crf_score: Option<(f32, Option<f32>)>,
}

impl LibEncTracker {
    pub fn new(
        worker_id: usize,
        chnk_idx: u16,
        tot: usize,
        track_frames: bool,
        crf_score: Option<(f32, Option<f32>)>,
    ) -> Self {
        Self {
            start: Instant::now(),
            enced: 0,
            last_reported: 0,
            worker_id,
            chnk_idx,
            tot,
            track_frames,
            crf_score,
        }
    }

    pub fn report(&mut self, prog: &ProgsTrack) {
        if self.enced == self.last_reported {
            return;
        }
        let fps = self.enced as f32 / self.start.elapsed().as_secs_f32().max(0.001);
        let delta = self.enced - self.last_reported;
        self.last_reported = self.enced;
        prog.up_lib_enc(
            self.worker_id,
            self.chnk_idx,
            (self.enced, self.tot),
            fps,
            self.track_frames.then_some(delta),
            self.crf_score,
        );
    }
}

fn watch_avm(inner: &Shared, rd: impl Read, w: Watch) {
    let Watch {
        worker_id,
        chnk_idx,
        frames,
        track_frames,
        crf_score,
    } = w;
    let started = Instant::now();
    let mut lr = LineReader::new(rd, b'\n');
    let mut poc_cnt = 0;
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
                poc_cnt += 1;
            }
        }

        if last_update.elapsed() >= Durat::from_millis(INTERVAL_MS) {
            last_update = Instant::now();

            let tot = frames.max(poc_cnt);
            let fps = poc_cnt as f32 / started.elapsed().as_secs_f32().max(0.001);
            let filled = (BAR_WIDTH * poc_cnt / tot.max(1)).min(BAR_WIDTH);
            let perc = (poc_cnt * 100 / tot.max(1)).min(100);

            let mut line = Line::new();
            write_tag(&mut line, chnk_idx, crf_score);
            _ = write!(line, " {P}[");
            write_bar(&mut line, filled, B_HASH, Y_DASH);
            _ = write!(
                line,
                "{P}] {W}{perc:3}%{C}, {Y}{fps:6.2}{C}, {G}{poc_cnt:3}{C}/{R}{tot:3}"
            );

            if track_frames {
                let d = poc_cnt.saturating_sub(last_poc);
                last_poc = poc_cnt;
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
        chnk_idx,
        frames,
        track_frames,
        crf_score,
    } = w;
    let started = Instant::now();
    let mut lr = LineReader::new(rd, b'\n');
    let mut poc_cnt = 0;
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
                poc_cnt += 1;
            }
        }

        if last_update.elapsed() >= Durat::from_millis(INTERVAL_MS) {
            last_update = Instant::now();

            let tot = frames.max(poc_cnt);
            let fps = poc_cnt as f32 / started.elapsed().as_secs_f32().max(0.001);
            let filled = (BAR_WIDTH * poc_cnt / tot.max(1)).min(BAR_WIDTH);
            let perc = (poc_cnt * 100 / tot.max(1)).min(100);

            let mut line = Line::new();
            write_tag(&mut line, chnk_idx, crf_score);
            _ = write!(line, " {P}[");
            write_bar(&mut line, filled, B_HASH, Y_DASH);
            _ = write!(
                line,
                "{P}] {W}{perc:3}%{C}, {Y}{fps:6.2}{C}, {G}{poc_cnt:3}{C}/{R}{tot:3}"
            );

            if track_frames {
                let d = poc_cnt.saturating_sub(last_poc);
                last_poc = poc_cnt;
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
        chnk_idx,
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

            if last_update.elapsed() < Durat::from_millis(INTERVAL_MS) {
                continue;
            }
            last_update = Instant::now();

            let Some((cur, fps, kbps)) = parse_x265(text) else {
                continue;
            };

            let filled = (BAR_WIDTH * cur / frames.max(1)).min(BAR_WIDTH);
            let perc = cur * 100 / frames.max(1);

            let mut line = Line::new();
            write_tag(&mut line, chnk_idx, crf_score);
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
        sleep(Durat::from_millis(INTERVAL_MS));
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
    let tot_sz = s.tot_sz.load(Relaxed);

    let processed_frames = s.processed.load(Relaxed);
    let frames_done = completed_frames.max(s.init_frames + processed_frames);

    let elapsed_secs = PRIOR_SECS.load(Relaxed) as usize + s.start.elapsed().as_secs() as usize;
    let fps = frames_done as f32 / elapsed_secs.max(1) as f32;
    let remaining = s.tot_frames.saturating_sub(frames_done);
    let eta_secs = remaining * elapsed_secs / frames_done.max(1);
    let chnks_done = s.completed.load(Relaxed);

    let progs = (frames_done * BAR_WIDTH / s.tot_frames.max(1)).min(BAR_WIDTH);
    let perc = (frames_done * 100 / s.tot_frames.max(1)).min(100);

    let mut agg = Line::new();
    _ = write!(agg, "\r\x1b[2K");
    write_el(&mut agg, elapsed_secs / 3600, (elapsed_secs % 3600) / 60);
    _ = write!(agg, "{C}[{G}{chnks_done}{C}/{R}{}{C}] [", s.tot_chnks);
    write_bar(&mut agg, progs, G_HASH, R_DASH);
    _ = write!(
        agg,
        "{C}] {W}{perc}% {G}{frames_done}{C}/{R}{} {C}({Y}{fps:.2}",
        s.tot_frames
    );
    if eta_secs >= 99 * 3600 {
        _ = write!(agg, "{C}, {W}-99:99");
    } else {
        write_eta(&mut agg, eta_secs / 3600, (eta_secs % 3600) / 60);
    }
    _ = write!(agg, "{C}, ");
    if completed_frames > 0 {
        let dur = completed_frames as f32 * s.fps_den as f32 / s.fps_num as f32;
        let kbps = tot_sz as f32 * 8.0 / dur / 1000.0;
        let tot_dur = s.tot_frames as f32 * s.fps_den as f32 / s.fps_num as f32;
        let est_sz = kbps * tot_dur * 1000.0 / 8.0;
        _ = write!(agg, "{B}{kbps:.0}k{C}, ");
        if est_sz > 1_000_000_000.0 {
            _ = write!(agg, "{R}{:.1}g", est_sz / 1_000_000_000.0);
        } else {
            _ = write!(agg, "{R}{:.1}m", est_sz / 1_000_000.0);
        }
    } else {
        _ = write!(agg, "{B}0k{C}, {R}0m");
    }
    _ = writeln!(agg, "{C}{N})");
    print!("{}", agg.as_str());
    _ = io_stdout().flush();
}
