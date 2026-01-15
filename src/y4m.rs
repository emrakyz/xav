use std::io::{BufRead, BufReader, Read, StdinLock};

pub fn is_pipe() -> bool {
    unsafe { libc::isatty(libc::STDIN_FILENO) == 0 }
}

pub struct PipeReader {
    reader: BufReader<StdinLock<'static>>,
    pub frame_size: usize,
    frame_header: [u8; 6],
}

impl PipeReader {
    pub fn new(frame_size: usize) -> Self {
        let stdin = Box::leak(Box::new(std::io::stdin())).lock();
        let mut reader = BufReader::new(stdin);
        let mut header = String::new();
        reader.read_line(&mut header).unwrap();
        Self { reader, frame_size, frame_header: [0u8; 6] }
    }

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
