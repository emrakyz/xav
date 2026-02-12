use std::io::{BufRead, BufReader, Write};
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::{Duration, Instant};

use crate::encoder::Encoder;

const BAR_WIDTH: usize = 20;
const INTERVAL_MS: u64 = 500;

const G: &str = "\x1b[1;92m";
const R: &str = "\x1b[1;91m";
const B: &str = "\x1b[1;94m";
const P: &str = "\x1b[1;95m";
const Y: &str = "\x1b[1;93m";
const C: &str = "\x1b[1;96m";
const W: &str = "\x1b[1;97m";
const N: &str = "\x1b[0m";

const G_HASH: &str = "\x1b[1;92m#";
const R_DASH: &str = "\x1b[1;91m-";
const B_HASH: &str = "\x1b[1;94m#";
const Y_DASH: &str = "\x1b[1;93m-";

pub struct ProgsBar {
    start: Instant,
    total: usize,
    last_update: Instant,
}

struct ProgState {
    total_chunks: usize,
    total_frames: usize,
    fps_num: usize,
    fps_den: usize,
    completed: Arc<AtomicUsize>,
    completions: Arc<Mutex<crate::chunk::ResumeInf>>,
}

impl ProgsBar {
    pub fn new() -> Self {
        let now = Instant::now();
        Self { start: now, total: 0, last_update: now }
    }

    pub fn up_idx(&mut self, current: usize, total: usize) {
        if self.last_update.elapsed() < Duration::from_millis(INTERVAL_MS) {
            return;
        }
        self.last_update = Instant::now();

        self.total = total;
        let elapsed = self.start.elapsed().as_secs() as usize;
        let mb_current = current / (1024 * 1024);
        let mb_total = total / (1024 * 1024);
        let mbps = mb_current / elapsed.max(1);
        let remaining = total.saturating_sub(current);
        let eta_secs = remaining * elapsed / current.max(1);
        let filled = (BAR_WIDTH * current / total.max(1)).min(BAR_WIDTH);
        let bar = format!("{}{}", G_HASH.repeat(filled), R_DASH.repeat(BAR_WIDTH - filled));
        let perc = (current * 100 / total.max(1)).min(100);
        let (eta_h, eta_m, eta_s) = (eta_secs / 3600, (eta_secs % 3600) / 60, eta_secs % 60);

        print!(
            "\r\x1b[2K{W}IDX: {C}[{bar}{C}] {W}{perc}%{C}, {Y}{mbps} MBs{C}, \
             {W}{eta_h:02}{P}:{W}{eta_m:02}{P}:{W}{eta_s:02}{C}, \
             {G}{mb_current}{C}/{R}{mb_total}{N}"
        );
        std::io::stdout().flush().unwrap();
    }

    pub fn up_scenes(&mut self, current: usize, total: usize) {
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
        let bar = format!("{}{}", G_HASH.repeat(filled), R_DASH.repeat(BAR_WIDTH - filled));
        let perc = (current * 100 / total.max(1)).min(100);
        let (eta_m, eta_s) = ((eta_secs % 3600) / 60, eta_secs % 60);

        print!(
            "\r\x1b[2K{W}SCD: {C}[{bar}{C}] {W}{perc}%{C}, {Y}{fps} FPS{C}, \
             {W}{eta_m:02}{P}:{W}{eta_s:02}{C}, {G}{current}{C}/{R}{total}{N}"
        );
        std::io::stdout().flush().unwrap();
    }

    pub fn finish() {
        print!("\r\x1b[2K");
        std::io::stdout().flush().unwrap();
    }

    pub fn finish_scenes() {
        print!("\r\x1b[2K");
        std::io::stdout().flush().unwrap();
    }
}

enum WorkerMsg {
    Update { worker_id: usize, line: String, frames: Option<usize> },
    Clear(usize),
}

pub struct ProgsTrack {
    tx: crossbeam_channel::Sender<WorkerMsg>,
}

impl ProgsTrack {
    pub fn new(
        chunks: &[crate::chunk::Chunk],
        inf: &crate::ffms::VidInf,
        worker_count: usize,
        init_frames: usize,
        completed: Arc<AtomicUsize>,
        completions: Arc<Mutex<crate::chunk::ResumeInf>>,
    ) -> (Self, thread::JoinHandle<()>) {
        let (tx, rx) = crossbeam_channel::unbounded();

        print!("\x1b[s");
        std::io::stdout().flush().unwrap();

        let total_chunks = chunks.len();
        let total_frames = chunks.iter().map(|c| c.end - c.start).sum();
        let fps_num = inf.fps_num as usize;
        let fps_den = inf.fps_den as usize;

        let state =
            ProgState { total_chunks, total_frames, fps_num, fps_den, completed, completions };

        let handle = thread::spawn(move || {
            display_loop(&rx, worker_count, init_frames, &state);
        });

        (Self { tx }, handle)
    }

    pub fn watch_enc(
        &self,
        stderr: impl std::io::Read + Send + 'static,
        worker_id: usize,
        chunk_idx: usize,
        track_frames: bool,
        crf_score: Option<(f32, Option<f64>)>,
        encoder: Encoder,
    ) {
        let tx = self.tx.clone();

        thread::spawn(move || match encoder {
            Encoder::SvtAv1 => {
                watch_svt(&tx, stderr, worker_id, chunk_idx, track_frames, crf_score);
            }
            Encoder::Avm => watch_avm(&tx, stderr, worker_id, chunk_idx, track_frames, crf_score),
            Encoder::X265 | Encoder::X264 => {
                watch_x265(&tx, stderr, worker_id, chunk_idx, track_frames, crf_score);
            }
            Encoder::Vvenc => {
                watch_vvenc(&tx, stderr, worker_id, chunk_idx, track_frames, crf_score);
            }
        });
    }

    #[cfg(feature = "vship")]
    pub fn show_metric_progress(
        &self,
        worker_id: usize,
        chunk_idx: usize,
        progress: (usize, usize),
        fps: f32,
        crf_score: (f32, Option<f64>),
    ) {
        let (current, total) = progress;
        let (crf, last_score) = crf_score;
        let filled = (BAR_WIDTH * current / total.max(1)).min(BAR_WIDTH);
        let bar = format!("{}{}", G_HASH.repeat(filled), R_DASH.repeat(BAR_WIDTH - filled));
        let perc = (current * 100 / total.max(1)).min(100);
        let score_str = last_score.map_or(String::new(), |s| format!(" / {s:.2}"));

        let line = format!(
            "{C}[{chunk_idx:04} / F {crf:.2}{score_str}{C}] [{bar}{C}] {W}{perc}%{C}, \
             {Y}{fps:.2}{C}, {G}{current}{C}/{R}{total}"
        );

        self.tx.send(WorkerMsg::Update { worker_id, line, frames: None }).ok();
    }

    #[cfg(feature = "libsvtav1")]
    pub fn update_lib_enc(
        &self,
        worker_id: usize,
        chunk_idx: usize,
        current: usize,
        total: usize,
        fps: f32,
        frames_delta: Option<usize>,
        crf_score: Option<(f32, Option<f64>)>,
    ) {
        let filled = (BAR_WIDTH * current / total.max(1)).min(BAR_WIDTH);
        let bar = format!("{}{}", B_HASH.repeat(filled), Y_DASH.repeat(BAR_WIDTH - filled));
        let perc = (current * 100 / total.max(1)).min(100);

        let prefix = match crf_score {
            Some((crf, Some(score))) => {
                format!("{C}[{chunk_idx:04} / F {crf:.2} / {score:.2}{C}]")
            }
            Some((crf, None)) => format!("{C}[{chunk_idx:04} / F {crf:.2}{C}]"),
            None => format!("{C}[{chunk_idx:04}{C}]"),
        };

        let line = format!(
            "{prefix} {P}[{bar}{P}] {W}{perc}%{C}, {Y}{fps:.2}{C}, {G}{current}{C}/{R}{total}"
        );

        self.tx.send(WorkerMsg::Update { worker_id, line, frames: frames_delta }).ok();
    }

    #[cfg(feature = "libsvtav1")]
    pub fn clear_lib_enc(&self, worker_id: usize) {
        self.tx.send(WorkerMsg::Clear(worker_id)).ok();
    }
}

#[cfg(feature = "libsvtav1")]
pub struct LibEncTracker {
    start: Instant,
    pub encoded: usize,
    last_reported: usize,
}

#[cfg(feature = "libsvtav1")]
impl LibEncTracker {
    pub fn new() -> Self {
        Self { start: Instant::now(), encoded: 0, last_reported: 0 }
    }

    pub fn report(
        &mut self,
        prog: &ProgsTrack,
        worker_id: usize,
        chunk_idx: usize,
        total: usize,
        track_frames: bool,
        crf_score: Option<(f32, Option<f64>)>,
    ) {
        if self.encoded == self.last_reported {
            return;
        }
        let fps = self.encoded as f32 / self.start.elapsed().as_secs_f32().max(0.001);
        let delta = self.encoded - self.last_reported;
        self.last_reported = self.encoded;
        prog.update_lib_enc(
            worker_id,
            chunk_idx,
            self.encoded,
            total,
            fps,
            if track_frames { Some(delta) } else { None },
            crf_score,
        );
    }
}

fn watch_svt(
    tx: &crossbeam_channel::Sender<WorkerMsg>,
    stderr: impl std::io::Read,
    worker_id: usize,
    chunk_idx: usize,
    track_frames: bool,
    crf_score: Option<(f32, Option<f64>)>,
) {
    let reader = BufReader::new(stderr);
    let mut last_frames = 0;

    for line in reader.split(b'\r').filter_map(Result::ok) {
        let Ok(text) = std::str::from_utf8(&line) else { continue };
        let text = text.trim();

        if text.contains("error") || text.contains("Error") {
            print!("\x1b[?1049l");
            std::io::stdout().flush().unwrap();
            eprintln!("{text}");
        }

        if text.is_empty() || !text.contains("Encoding:") || text.contains("SUMMARY") {
            continue;
        }

        let content = text.strip_prefix("Encoding: ").unwrap_or(text);

        let mut cleaned = content
            .replace(" Frames\x1b[0m @ ", " ")
            .replace("Size: ", "")
            .replace(" MB", "")
            .replace(" fps", "")
            .replace("Time: \u{1b}[36m0:", "")
            .replace("33m   ", "33m")
            .replace("33m  ", "33m")
            .replace("33m ", "33m");

        let parts: Vec<&str> = cleaned.split("\u{1b}[38;5;248m").collect();
        if parts.len() > 1 {
            cleaned = parts[0].to_string();
        }

        let parts: Vec<&str> = cleaned.rsplitn(2, '|').collect();
        if parts.len() > 1 && parts[0].trim().contains(':') {
            cleaned = parts[1].to_string();
        }

        if let Some(p) = cleaned.find(" kb/s") {
            cleaned.truncate(p + 5);
            if let Some(dot_pos) = cleaned[..p].rfind('.') {
                cleaned = format!("{} kb/s", &cleaned[..dot_pos]);
            }
        }

        if cleaned.contains("fpm") {
            let parts: Vec<&str> = cleaned.split_whitespace().collect();
            if let Some(fpm_pos) = parts.iter().position(|&s| s == "fpm")
                && fpm_pos > 0
            {
                let num_str = parts[fpm_pos - 1];
                let num_clean = num_str.replace("\u{1b}[32m", "").replace("\u{1b}[0m", "");
                if let Ok(fpm) = num_clean.parse::<f32>() {
                    let fps = fpm / 60.0;
                    cleaned = cleaned.replacen(
                        &format!("{num_str} fpm"),
                        &format!("\u{1b}[32m{fps:.2}\u{1b}[0m"),
                        1,
                    );
                }
            }
        }

        let prefix = match crf_score {
            Some((crf, Some(score))) => {
                format!("{C}[{chunk_idx:04} / F {crf:.2} / {score:.2}{C}]")
            }
            Some((crf, None)) => format!("{C}[{chunk_idx:04} / F {crf:.2}{C}]"),
            None => format!("{C}[{chunk_idx:04}{C}]"),
        };

        let display_line = if let Some((current, total)) = parse_svt_frames_total(text) {
            let filled = (BAR_WIDTH * current / total.max(1)).min(BAR_WIDTH);
            let bar = format!("{}{}", B_HASH.repeat(filled), Y_DASH.repeat(BAR_WIDTH - filled));
            let perc = (current * 100 / total.max(1)).min(100);
            format!("{prefix} {P}[{bar}{P}] {W}{perc}% {cleaned}")
        } else {
            format!("{prefix} {cleaned}")
        };

        let frames_delta = if track_frames {
            parse_svt_frames(text).map(|current| {
                let delta = current.saturating_sub(last_frames);
                last_frames = current;
                delta
            })
        } else {
            None
        };

        tx.send(WorkerMsg::Update { worker_id, line: display_line, frames: frames_delta }).ok();
    }

    tx.send(WorkerMsg::Clear(worker_id)).ok();
}

fn watch_avm(
    tx: &crossbeam_channel::Sender<WorkerMsg>,
    mut stdout: impl std::io::Read,
    worker_id: usize,
    chunk_idx: usize,
    _track_frames: bool,
    _crf_score: Option<(f32, Option<f64>)>,
) {
    tx.send(WorkerMsg::Update {
        worker_id,
        line: format!("{C}[{chunk_idx:04}]{W} Encoding: Progress updates when chunk finishes"),
        frames: None,
    })
    .ok();

    let mut buf = [0u8; 4096];
    while stdout.read(&mut buf).unwrap_or(0) > 0 {}

    tx.send(WorkerMsg::Clear(worker_id)).ok();
}

fn watch_vvenc(
    tx: &crossbeam_channel::Sender<WorkerMsg>,
    mut stdout: impl std::io::Read,
    worker_id: usize,
    chunk_idx: usize,
    track_frames: bool,
    crf_score: Option<(f32, Option<f64>)>,
) {
    let start = Instant::now();
    let mut buf = [0u8; 4096];
    let mut line_buf = String::new();
    let mut poc_count = 0;
    let mut total_frames = 0;
    let mut last_poc_count = 0;
    let mut last_update = Instant::now();

    loop {
        match stdout.read(&mut buf) {
            Ok(0) | Err(_) => break,
            Ok(n) => {
                line_buf.push_str(&String::from_utf8_lossy(&buf[..n]));

                while let Some(pos) = line_buf.find('\n') {
                    let line = line_buf[..pos].trim().to_string();
                    line_buf = line_buf[pos + 1..].to_string();

                    if line.contains("error") || line.contains("Error") {
                        print!("\x1b[?1049l");
                        std::io::stdout().flush().unwrap();
                        eprintln!("{line}");
                    }

                    if total_frames == 0 && line.contains("encode ") {
                        total_frames =
                            line.split_whitespace().find_map(|s| s.parse().ok()).unwrap_or(0);
                    }

                    if line.starts_with("POC") {
                        poc_count += 1;
                    }
                }

                if last_update.elapsed() >= Duration::from_millis(INTERVAL_MS) {
                    last_update = Instant::now();

                    let total = total_frames.max(poc_count);
                    let fps = poc_count as f32 / start.elapsed().as_secs_f32().max(0.001);
                    let filled = (BAR_WIDTH * poc_count / total.max(1)).min(BAR_WIDTH);
                    let bar =
                        format!("{}{}", B_HASH.repeat(filled), Y_DASH.repeat(BAR_WIDTH - filled));
                    let perc = (poc_count * 100 / total.max(1)).min(100);

                    let prefix = match crf_score {
                        Some((crf, Some(score))) => {
                            format!("{C}[{chunk_idx:04} / F {crf:.2} / {score:.2}{C}]")
                        }
                        Some((crf, None)) => format!("{C}[{chunk_idx:04} / F {crf:.2}{C}]"),
                        None => format!("{C}[{chunk_idx:04}{C}]"),
                    };

                    let display = format!(
                        "{prefix} {P}[{bar}{P}] {W}{perc}%{C}, {Y}{fps:.2}{C}, \
                         {G}{poc_count}{C}/{R}{total}"
                    );

                    let delta = if track_frames {
                        let d = poc_count.saturating_sub(last_poc_count);
                        last_poc_count = poc_count;
                        Some(d)
                    } else {
                        None
                    };

                    tx.send(WorkerMsg::Update { worker_id, line: display, frames: delta }).ok();
                }
            }
        }
    }

    tx.send(WorkerMsg::Clear(worker_id)).ok();
}

fn parse_svt_frames(line: &str) -> Option<usize> {
    let frames_pos = line.find(" Frames")?;
    let bytes = line.as_bytes();

    let mut start = frames_pos;
    while start > 0 {
        let b = bytes[start - 1];
        if b.is_ascii_digit() || b == b'/' {
            start -= 1;
        } else {
            break;
        }
    }

    let num_part = &line[start..frames_pos];
    let first_num = num_part.split('/').next()?;
    first_num.parse().ok()
}

fn parse_svt_frames_total(line: &str) -> Option<(usize, usize)> {
    let frames_pos = line.find(" Frames")?;
    let bytes = line.as_bytes();

    let mut start = frames_pos;
    while start > 0 {
        let b = bytes[start - 1];
        if b.is_ascii_digit() || b == b'/' {
            start -= 1;
        } else {
            break;
        }
    }

    let num_part = &line[start..frames_pos];
    let mut parts = num_part.split('/');
    let current = parts.next()?.parse().ok()?;
    let total = parts.next()?.parse().ok()?;
    Some((current, total))
}

fn watch_x265(
    tx: &crossbeam_channel::Sender<WorkerMsg>,
    stderr: impl std::io::Read,
    worker_id: usize,
    chunk_idx: usize,
    track_frames: bool,
    crf_score: Option<(f32, Option<f64>)>,
) {
    let reader = BufReader::new(stderr);
    let mut last_frames = 0;
    let mut last_update = Instant::now();

    for line in reader.split(b'\r').filter_map(Result::ok) {
        let Ok(text) = std::str::from_utf8(&line) else { continue };
        let text = text.trim();

        if text.is_empty() {
            continue;
        }

        if !text.starts_with('[') {
            if text.starts_with("encoded") {
                continue;
            }
            print!("\x1b[?1049l");
            std::io::stdout().flush().unwrap();
            eprintln!("{text}");
            continue;
        }

        if last_update.elapsed() < Duration::from_millis(INTERVAL_MS) {
            continue;
        }
        last_update = Instant::now();

        let Some((cur, tot, fps, kbps)) = parse_x265(text) else { continue };

        let filled = (BAR_WIDTH * cur / tot.max(1)).min(BAR_WIDTH);
        let bar = format!("{}{}", B_HASH.repeat(filled), Y_DASH.repeat(BAR_WIDTH - filled));

        let prefix = match crf_score {
            Some((crf, Some(s))) => format!("{C}[{chunk_idx:04} / F {crf:.2} / {s:.2}{C}]"),
            Some((crf, None)) => format!("{C}[{chunk_idx:04} / F {crf:.2}{C}]"),
            None => format!("{C}[{chunk_idx:04}{C}]"),
        };

        let line = format!(
            "{prefix} {P}[{bar}{P}] {W}{}% {Y}{cur}/{tot} {G}{fps:.2} {W}| {P}{kbps:.0} kb/s",
            cur * 100 / tot.max(1)
        );

        let delta = track_frames.then(|| {
            let d = cur.saturating_sub(last_frames);
            last_frames = cur;
            d
        });

        tx.send(WorkerMsg::Update { worker_id, line, frames: delta }).ok();
    }

    tx.send(WorkerMsg::Clear(worker_id)).ok();
}

fn parse_x265(s: &str) -> Option<(usize, usize, f32, f32)> {
    let rest = s.split(']').nth(1)?;
    let mut parts = rest.split(',');

    let fp = parts.next()?.trim();
    let mut fs = fp.split('/');
    let cur = fs.next()?.trim().parse().ok()?;
    let tot = fs.next()?.split_whitespace().next()?.parse().ok()?;

    let fps = parts.next()?.split_whitespace().next()?.parse().ok()?;
    let kbps = parts.next()?.split_whitespace().next()?.parse().ok()?;

    Some((cur, tot, fps, kbps))
}

fn display_loop(
    rx: &crossbeam_channel::Receiver<WorkerMsg>,
    worker_count: usize,
    init_frames: usize,
    state: &ProgState,
) {
    let start = Instant::now();
    let mut lines = vec![String::new(); worker_count];
    let processed = Arc::new(AtomicUsize::new(0));
    let mut last_draw = Instant::now();

    loop {
        match rx.recv_timeout(Duration::from_millis(INTERVAL_MS)) {
            Ok(WorkerMsg::Update { worker_id, line, frames }) => {
                if worker_id < worker_count {
                    lines[worker_id] = line;
                    if let Some(delta) = frames {
                        processed.fetch_add(delta, Ordering::Relaxed);
                    }
                }
            }
            Ok(WorkerMsg::Clear(worker_id)) => {
                if worker_id < worker_count {
                    lines[worker_id].clear();
                }
            }
            Err(crossbeam_channel::RecvTimeoutError::Timeout) => {}
            Err(crossbeam_channel::RecvTimeoutError::Disconnected) => break,
        }

        if last_draw.elapsed() >= Duration::from_millis(INTERVAL_MS) {
            draw_screen(&lines, worker_count, &start, state, &processed, init_frames);
            last_draw = Instant::now();
        }
    }

    draw_screen(&lines, worker_count, &start, state, &processed, init_frames);
}

fn draw_screen(
    lines: &[String],
    worker_count: usize,
    start: &Instant,
    state: &ProgState,
    processed: &Arc<AtomicUsize>,
    init_frames: usize,
) {
    print!("\x1b[u");

    for line in lines.iter().take(worker_count) {
        if line.is_empty() {
            print!("\r\x1b[2K\n");
        } else {
            print!("\r\x1b[2K{line}\n");
        }
    }

    print!("\r\x1b[2K\n");

    let data = state.completions.lock().unwrap();
    let completed_frames: usize = data.chnks_done.iter().map(|c| c.frames).sum();
    let total_size: u64 = data.chnks_done.iter().map(|c| c.size).sum();
    drop(data);

    let processed_frames = processed.load(Ordering::Relaxed);
    let frames_done = completed_frames.max(init_frames + processed_frames);

    let elapsed_secs = start.elapsed().as_secs() as usize;
    let fps = (frames_done.saturating_sub(init_frames)) as f32 / elapsed_secs.max(1) as f32;
    let remaining = state.total_frames.saturating_sub(frames_done);
    let eta_secs = remaining * elapsed_secs / frames_done.max(1);
    let chunks_done = state.completed.load(Ordering::Relaxed);

    let (bitrate_str, est_str) = if completed_frames > 0 {
        let dur = completed_frames as f32 * state.fps_den as f32 / state.fps_num as f32;
        let kbps = total_size as f32 * 8.0 / dur / 1000.0;
        let total_dur = state.total_frames as f32 * state.fps_den as f32 / state.fps_num as f32;
        let est_size = kbps * total_dur * 1000.0 / 8.0;
        let est = if est_size > 1_000_000_000.0 {
            format!("{:.1}g", est_size / 1_000_000_000.0)
        } else {
            format!("{:.1}m", est_size / 1_000_000.0)
        };
        (format!("{B}{kbps:.0}k"), format!("{R}{est}"))
    } else {
        (format!("{B}0k"), format!("{R}0m"))
    };

    let progress = (frames_done * BAR_WIDTH / state.total_frames.max(1)).min(BAR_WIDTH);
    let perc = (frames_done * 100 / state.total_frames.max(1)).min(100);
    let bar = format!("{}{}", G_HASH.repeat(progress), R_DASH.repeat(BAR_WIDTH - progress));

    let (h, m) = (elapsed_secs / 3600, (elapsed_secs % 3600) / 60);
    let eta_h = (eta_secs / 3600).min(99);
    let eta_m = (eta_secs % 3600) / 60;

    print!(
        "\r\x1b[2K{W}{h:02}{P}:{W}{m:02} {C}[{G}{chunks_done}{C}/{R}{}{C}] [{bar}{C}] {W}{perc}% \
         {G}{frames_done}{C}/{R}{} {C}({Y}{fps:.2}{C}, {W}{eta_h:02}{P}:{W}{eta_m:02}{C}, \
         {bitrate_str}{C}, {est_str}{C}{N})\n",
        state.total_chunks, state.total_frames
    );
    std::io::stdout().flush().unwrap();
}
