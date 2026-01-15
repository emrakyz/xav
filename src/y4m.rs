use std::fs::File;
use std::io::{BufRead, BufReader, Read};
use std::os::unix::io::FromRawFd;

pub fn is_pipe() -> bool {
    unsafe { libc::isatty(libc::STDIN_FILENO) == 0 }
}

pub struct Y4mInfo {
    pub width: u32,
    pub height: u32,
    pub is_10bit: bool,
}

pub struct PipeReader {
    reader: BufReader<File>,
    pub frame_size: usize,
    frame_header: [u8; 6],
}

impl PipeReader {
    pub fn read_frame(&mut self, dst: &mut [u8]) -> bool {
        if self.reader.read_exact(&mut self.frame_header).is_err() {
            return false;
        }
        self.reader.read_exact(dst).is_ok()
    }

    pub fn skip_frames(&mut self, count: usize) {
        let mut discard = vec![0u8; self.frame_size];
        for _ in 0..count {
            self.reader.read_exact(&mut self.frame_header).unwrap();
            self.reader.read_exact(&mut discard).unwrap();
        }
    }
}

pub fn init_pipe() -> Option<(Y4mInfo, PipeReader)> {
    if !is_pipe() {
        return None;
    }

    let file = unsafe { File::from_raw_fd(libc::STDIN_FILENO) };
    let mut reader = BufReader::new(file);
    let mut header = String::new();
    reader.read_line(&mut header).unwrap();

    let mut width = 0;
    let mut height = 0;
    let mut is_10bit = false;

    for part in header.split_whitespace() {
        if let Some(w) = part.strip_prefix('W') {
            width = w.parse().unwrap_or(0);
        } else if let Some(h) = part.strip_prefix('H') {
            height = h.parse().unwrap_or(0);
        } else if let Some(c) = part.strip_prefix('C') {
            is_10bit = c.contains("p10");
        }
    }

    let frame_size = width as usize * height as usize * 3 / 2 * if is_10bit { 2 } else { 1 };
    let info = Y4mInfo { width, height, is_10bit };
    let pipe_reader = PipeReader { reader, frame_size, frame_header: [0u8; 6] };

    Some((info, pipe_reader))
}
