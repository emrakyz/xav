use std::io::{BufRead, BufReader, Write};
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::{Duration, Instant};

const BAR_WIDTH: usize = 28;

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

pub struct ProgsBar {
    start: Instant,
    total: usize,
    quiet: bool,
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
    pub fn new(quiet: bool) -> Self {
        let now = Instant::now();
        Self { start: now, total: 0, quiet, last_update: now }
    }

    pub fn up_idx(&mut self, current: usize, total: usize) {
        if self.quiet {
            return;
        }

        if self.last_update.elapsed() < Duration::from_millis(1000) {
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
        if self.quiet {
            return;
        }

        if self.last_update.elapsed() < Duration::from_millis(1000) {
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
        let (eta_h, eta_m, eta_s) = (eta_secs / 3600, (eta_secs % 3600) / 60, eta_secs % 60);

        print!(
            "\r\x1b[2K{W}SCD: {C}[{bar}{C}] {W}{perc}%{C}, {Y}{fps} FPS{C}, \
             {W}{eta_h:02}{P}:{W}{eta_m:02}{P}:{W}{eta_s:02}{C}, {G}{current}{C}/{R}{total}{N}"
        );
        std::io::stdout().flush().unwrap();
    }

    pub fn finish(&self) {
        if !self.quiet {
            print!("\r\x1b[2K");
            std::io::stdout().flush().unwrap();
        }
    }

    pub fn finish_scenes(&self) {
        if !self.quiet {
            print!("\r\x1b[2K");
            std::io::stdout().flush().unwrap();
        }
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
    ) -> Self {
        let (tx, rx) = crossbeam_channel::unbounded();

        print!("\x1b[s");
        std::io::stdout().flush().unwrap();

        let total_chunks = chunks.len();
        let total_frames = inf.frames;
        let fps_num = inf.fps_num as usize;
        let fps_den = inf.fps_den as usize;

        let state =
            ProgState { total_chunks, total_frames, fps_num, fps_den, completed, completions };

        thread::spawn(move || {
            display_loop(&rx, worker_count, init_frames, &state);
        });

        Self { tx }
    }

    pub fn watch_enc(
        &self,
        stderr: impl std::io::Read + Send + 'static,
        worker_id: usize,
        chunk_idx: usize,
        track_frames: bool,
        crf_score: Option<(f32, Option<f64>)>,
    ) {
        let tx = self.tx.clone();

        thread::spawn(move || {
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
                    .replace(" kb/s", "")
                    .replace("Size: ", "")
                    .replace(" MB", "")
                    .replace("Time: \u{1b}[36m0:", "")
                    .replace("33m   ", "33m")
                    .replace("33m  ", "33m")
                    .replace("33m ", "33m")
                    .replace("[-0:", "[");

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
                                &format!("\u{1b}[32m{fps:.2}\u{1b}[0m fps"),
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

                let display_line = format!("{prefix} {cleaned}");

                let frames_delta = if track_frames {
                    parse_frame_count(text).map(|current| {
                        let delta = current.saturating_sub(last_frames);
                        last_frames = current;
                        delta
                    })
                } else {
                    None
                };

                tx.send(WorkerMsg::Update { worker_id, line: display_line, frames: frames_delta })
                    .ok();
            }

            tx.send(WorkerMsg::Clear(worker_id)).ok();
        });
    }

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
            "{C}[{chunk_idx:04} / F {crf:.2}{score_str}{C}] [{bar}{C}] {W}{perc}%{C}, {Y}{fps:.2} \
             FPS{C}, {G}{current}{C}/{R}{total}"
        );

        self.tx.send(WorkerMsg::Update { worker_id, line, frames: None }).ok();
    }
}

fn parse_frame_count(line: &str) -> Option<usize> {
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
        match rx.recv_timeout(Duration::from_millis(1000)) {
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

        if last_draw.elapsed() >= Duration::from_millis(1000) {
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
            format!("{:.1} GB", est_size / 1_000_000_000.0)
        } else {
            format!("{:.1} MB", est_size / 1_000_000.0)
        };
        (format!("{B}{kbps:.0} kb"), format!("{R}{est}"))
    } else {
        (format!("{B}0 kb"), format!("{R}0 MB"))
    };

    let progress = (frames_done * BAR_WIDTH / state.total_frames.max(1)).min(BAR_WIDTH);
    let perc = (frames_done * 100 / state.total_frames.max(1)).min(100);
    let bar = format!("{}{}", G_HASH.repeat(progress), R_DASH.repeat(BAR_WIDTH - progress));

    let (m, s) = (elapsed_secs / 60, elapsed_secs % 60);
    let (eta_m, eta_s) = (eta_secs / 60, eta_secs % 60);

    println!(
        "{W}{m:02}{P}:{W}{s:02} {C}[{G}{chunks_done}{C}/{R}{}{C}] [{bar}{C}] {W}{perc}% \
         {G}{frames_done}{C}/{R}{} {C}({Y}{fps:.2} FPS{C}, {W}{eta_m:02}{P}:{W}{eta_s:02}{C}, \
         {bitrate_str}{C}, {est_str}{C}){N}",
        state.total_chunks, state.total_frames
    );

    std::io::stdout().flush().unwrap();
}
