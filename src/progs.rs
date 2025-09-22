use std::collections::HashMap;
use std::io::{BufRead, BufReader, Write};
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::{Duration, Instant};

static DISPLAY_MUTEX: Mutex<()> = Mutex::new(());

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
    s_time: Instant,
    last_up: Instant,
    last_val: usize,
    tot: usize,
    quiet: bool,
}

impl ProgsBar {
    pub fn new(quiet: bool) -> Self {
        Self { s_time: Instant::now(), last_up: Instant::now(), last_val: 0, tot: 0, quiet }
    }

    pub fn up_idx(&mut self, current: usize, tot: usize) {
        if self.quiet {
            return;
        }
        self.tot = tot;
        let now = Instant::now();
        let elapsed = now.duration_since(self.s_time);

        let elapsed_secs = elapsed.as_secs() as usize;
        let mb_processed = current / (1024 * 1024);
        let mbps = mb_processed / elapsed_secs.max(1);

        let remaining = tot.saturating_sub(current);
        let eta_secs = remaining * elapsed_secs / current.max(1);
        let eta = Duration::from_secs(eta_secs as u64);

        let filled = (65 * current / tot.max(1)).min(65);

        let bar = format!("{}{}", G_HASH.repeat(filled), R_DASH.repeat(65 - filled));

        let eta_str = fmt_dur_colored(eta);
        let current_mb = current / (1024 * 1024);
        let tot_mb = tot / (1024 * 1024);

        let perc = (current * 100 / tot.max(1)).min(100);

        print!(
            "\r\x1b[2K{W}IDX: {C}[{bar}{C}] {W}{perc}%{C}, {Y}{mbps} MBs{C}, {W}{eta_str}{C}, \
             {G}{current_mb}{C}/{R}{tot_mb}{N}"
        );
        std::io::stdout().flush().unwrap();

        self.last_up = now;
        self.last_val = current;
    }

    pub fn up_scenes(&mut self, current: usize, tot: usize) {
        if self.quiet {
            return;
        }
        self.tot = tot;
        let now = Instant::now();
        let elapsed = now.duration_since(self.s_time);

        let elapsed_secs = elapsed.as_secs() as usize;
        let fps = current / elapsed_secs.max(1);

        let remaining = tot.saturating_sub(current);
        let eta_secs = remaining * elapsed_secs / current.max(1);
        let eta = Duration::from_secs(eta_secs as u64);

        let filled = (65 * current / tot.max(1)).min(65);
        let bar = format!("{}{}", G_HASH.repeat(filled), R_DASH.repeat(65 - filled));
        let eta_str = fmt_dur_colored(eta);
        let perc = (current * 100 / tot.max(1)).min(100);

        print!(
            "\r\x1b[2K{W}SCD: {C}[{bar}{C}] {W}{perc}%{C}, {Y}{fps} FPS{C}, {W}{eta_str}{C}, \
             {G}{current}{C}/{R}{tot}{N}"
        );
        std::io::stdout().flush().unwrap();

        self.last_up = now;
        self.last_val = current;
    }

    pub fn finish(&self) {
        if self.quiet {
            return;
        }

        let bar = G_HASH.repeat(65);
        let elapsed = self.s_time.elapsed();
        let elapsed_secs = elapsed.as_secs() as usize;
        let mb_processed = self.tot / (1024 * 1024);
        let mbps = mb_processed / elapsed_secs.max(1);
        let tot_mb = self.tot / (1024 * 1024);

        print!(
            "\r\x1b[2K{W}IDX: {C}[{bar}{C}] {W}100%{C}, {Y}{mbps} MBs{C}, \
             {W}00{P}:{W}00{P}:{W}00{C}, {G}{tot_mb}{C}/{R}{tot_mb}{N}"
        );
        std::io::stdout().flush().unwrap();
        println!();
        println!();
    }

    pub fn finish_scenes(&self) {
        if self.quiet {
            return;
        }

        let bar = G_HASH.repeat(65);
        let elapsed = self.s_time.elapsed();
        let elapsed_secs = elapsed.as_secs() as usize;
        let fps = self.tot / elapsed_secs.max(1);

        print!(
            "\r\x1b[2K{W}SCD: {C}[{bar}{C}] {W}100%{C}, {Y}{fps} FPS{C}, {W}00{P}:{W}00{C}, \
             {G}{}{C}/{R}{}{N}",
            self.tot, self.tot
        );
        std::io::stdout().flush().unwrap();
        println!();
    }
}

struct ProgsState {
    start: Instant,
    tot_chunks: usize,
    tot_frames: usize,
    init_frames: usize,
    worker_cnt: usize,
    completed: Arc<AtomicUsize>,
    completions: Arc<Mutex<crate::chunk::ResumeInf>>,
    fps_num: usize,
    fps_den: usize,
}

pub struct ProgsTrack {
    lines: Arc<Mutex<HashMap<usize, String>>>,
    processed: Arc<AtomicUsize>,
    state: Arc<ProgsState>,
}

impl ProgsTrack {
    pub fn new(
        chunks: &[crate::chunk::Chunk],
        inf: &crate::ffms::VidInf,
        worker_cnt: usize,
        init_frames: usize,
        completed: Arc<AtomicUsize>,
        completions: Arc<Mutex<crate::chunk::ResumeInf>>,
    ) -> Self {
        Self {
            lines: Arc::new(Mutex::new(HashMap::new())),
            processed: Arc::new(AtomicUsize::new(init_frames)),
            state: Arc::new(ProgsState {
                start: Instant::now(),
                tot_chunks: chunks.len(),
                tot_frames: inf.frames,
                init_frames,
                worker_cnt,
                completed,
                completions,
                fps_num: inf.fps_num as usize,
                fps_den: inf.fps_den as usize,
            }),
        }
    }

    pub fn watch_enc(&self, stderr: impl std::io::Read + Send + 'static, chunk_idx: usize) {
        let lines = Arc::clone(&self.lines);
        let processed = Arc::clone(&self.processed);
        let state = Arc::clone(&self.state);

        thread::spawn(move || {
            let mut reader = BufReader::new(stderr);
            let mut buffer = Vec::new();

            loop {
                buffer.clear();
                let read = reader.read_until(b'\r', &mut buffer);
                if read.is_err() || read.unwrap() == 0 {
                    break;
                }

                let Ok(line) = String::from_utf8(buffer.clone()) else {
                    continue;
                };
                let line = line.trim_end_matches('\r');

                if line.contains("error") {
                    eprintln!("{line}");
                }

                if !line.contains("Encoding:") || line.contains("SUMMARY") {
                    continue;
                }

                Self::up_line(&lines, &processed, chunk_idx, line);

                Self::show_progs(&lines, &processed, &state);
            }

            let mut map = lines.lock().unwrap();
            map.remove(&chunk_idx);
        });
    }

    fn get_frame_cnt(line: &str) -> Option<usize> {
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

    fn up_line(
        lines: &Arc<Mutex<HashMap<usize, String>>>,
        processed: &Arc<AtomicUsize>,
        chunk_idx: usize,
        line: &str,
    ) {
        let mut map = lines.lock().unwrap();

        let prev_frames =
            map.get(&chunk_idx).map_or(0, |prev| Self::get_frame_cnt(prev).unwrap_or(0));

        let cleaned = line.strip_prefix("Encoding: ").unwrap_or(line).to_string();
        map.insert(chunk_idx, format!("{C}[{chunk_idx:04}{C}] {cleaned}"));
        drop(map);

        if let Some(current) = Self::get_frame_cnt(line) {
            let diff = current.saturating_sub(prev_frames);
            processed.fetch_add(diff, Ordering::Relaxed);
        }
    }

    fn show_progs(
        lines: &Arc<Mutex<HashMap<usize, String>>>,
        processed: &Arc<AtomicUsize>,
        state: &Arc<ProgsState>,
    ) {
        let _guard = DISPLAY_MUTEX.lock().unwrap();
        let frames_done = processed.load(Ordering::Relaxed);
        let elapsed = state.start.elapsed();

        let new_frames = frames_done.saturating_sub(state.init_frames);
        let elapsed_secs = elapsed.as_secs() as usize;
        let fps = new_frames as f32 / elapsed_secs.max(1) as f32;

        let remaining = state.tot_frames.saturating_sub(frames_done);
        let eta_secs = remaining * elapsed_secs / new_frames.max(1);

        let chunks_done = state.completed.load(Ordering::Relaxed);
        let (bitrate_str, est_str) = get_bitrate_estimates(state);

        print!("\x1b[2J\x1b[H");

        let map = lines.lock().unwrap();
        for line in map.values() {
            println!("{line}");
        }
        for _ in map.len()..=state.worker_cnt {
            println!();
        }
        drop(map);

        let (h, m, s) = (elapsed_secs / 3600, (elapsed_secs % 3600) / 60, elapsed_secs % 60);
        let (eta_h, eta_m, eta_s) = (eta_secs / 3600, (eta_secs % 3600) / 60, eta_secs % 60);

        let progs = (frames_done * 65 / state.tot_frames.max(1)).min(65);
        let perc = (frames_done * 100 / state.tot_frames.max(1)).min(100) as u8;

        let bar = format!("{}{}", G_HASH.repeat(progs), R_DASH.repeat(65 - progs));

        println!(
            "{W}{h:02}{P}:{W}{m:02}{P}:{W}{s:02} {C}[{G}{chunks_done}{C}/{R}{}{C}] [{bar}{C}] \
             {W}{perc}% {G}{frames_done}{C}/{R}{} {C}({Y}{fps:.2} FPS{C}, \
             {W}{eta_h:02}{P}:{W}{eta_m:02}{P}:{W}{eta_s:02}{C}, {bitrate_str}{C}, \
             {R}{est_str}{C}){N}",
            state.tot_chunks, state.tot_frames
        );

        std::io::stdout().flush().unwrap();
    }

    pub fn final_update(&self) {
        Self::show_progs(&self.lines, &self.processed, &self.state);
    }
}

fn get_bitrate_estimates(state: &ProgsState) -> (String, String) {
    let data = state.completions.lock().unwrap();
    let tot_size: u64 = data.chnks_done.iter().map(|c| c.size).sum();
    let tot_chunk_frames: usize = data.chnks_done.iter().map(|c| c.frames).sum();
    drop(data);

    let dur_secs = tot_chunk_frames as f32 * state.fps_den as f32 / state.fps_num as f32;
    let bitrate_kbps = tot_size as f32 * 8.0 / dur_secs / 1000.0;

    let tot_dur = state.tot_frames as f32 * state.fps_den as f32 / state.fps_num as f32;
    let est_size = bitrate_kbps * tot_dur * 1000.0 / 8.0;

    let est_str = if est_size > 1_000_000_000.0 {
        format!("{:.1} GB", est_size / 1_000_000_000.0)
    } else {
        format!("{:.1} MB", est_size / 1_000_000.0)
    };

    (format!("{B}{bitrate_kbps:.0} kb{C}/{B}s"), format!("{R}{est_str}"))
}

fn fmt_dur_colored(d: Duration) -> String {
    let tot_secs = d.as_secs();
    let hours = tot_secs / 3600;
    let mins = (tot_secs % 3600) / 60;
    let secs = tot_secs % 60;

    format!("{W}{hours:02}{P}:{W}{mins:02}{P}:{W}{secs:02}")
}
