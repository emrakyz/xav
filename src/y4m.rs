use std::io::{BufRead as _, BufReader, IsTerminal as _, Read as _, Stdin, stdin};
#[cfg(target_os = "linux")]
use std::{
    fs::{read, read_dir, read_link},
    os::unix::io::AsRawFd as _,
    path::Path,
    process::{Command, Stdio, id},
};

#[cfg(target_os = "linux")]
use libc::dup2;

#[cfg(target_os = "linux")]
use crate::chunk::{Chunk, get_resume};

pub fn is_pipe() -> bool {
    !stdin().is_terminal()
}

pub struct Y4mInfo {
    pub width: u32,
    pub height: u32,
    pub is_10b: bool,
}

pub struct PipeReader {
    reader: BufReader<Stdin>,
    pub frame_sz: usize,
    pub start_idx: usize,
    frame_header: [u8; 6],
}

impl PipeReader {
    pub fn read_frame(&mut self, dst: &mut [u8]) -> bool {
        if self.reader.read_exact(&mut self.frame_header).is_err() {
            return false;
        }
        self.reader.read_exact(dst).is_ok()
    }

    pub fn skip_frames(&mut self, cnt: usize) {
        let mut discard = vec![0u8; self.frame_sz];
        for _ in 0..cnt {
            _ = self.reader.read_exact(&mut self.frame_header);
            _ = self.reader.read_exact(&mut discard);
        }
    }
}

pub fn init_pipe(start_idx: usize) -> Option<(Y4mInfo, PipeReader)> {
    if !is_pipe() {
        return None;
    }

    let stdin = stdin();
    let mut reader = BufReader::new(stdin);
    let mut header = String::new();
    _ = reader.read_line(&mut header);

    let mut width = 0;
    let mut height = 0;
    let mut is_10b = false;

    for part in header.split_whitespace() {
        if let Some(w) = part.strip_prefix('W') {
            width = w.parse().unwrap_or(0);
        } else if let Some(h) = part.strip_prefix('H') {
            height = h.parse().unwrap_or(0);
        } else if let Some(c) = part.strip_prefix('C') {
            is_10b = c.contains("p10");
        }
    }

    let frame_sz = width as usize * height as usize * 3 / 2 * if is_10b { 2 } else { 1 };
    let info = Y4mInfo {
        width,
        height,
        is_10b,
    };
    let pipe_reader = PipeReader {
        reader,
        frame_sz,
        start_idx,
        frame_header: [0u8; 6],
    };

    Some((info, pipe_reader))
}

#[cfg(target_os = "linux")]
pub fn vspipe_resume(chnks: &[Chunk], work_dir: &Path) -> Option<usize> {
    is_pipe().then_some(())?;
    let resume = get_resume(work_dir).filter(|r| !r.chnks_done.is_empty())?;
    let skip: Vec<u16> = resume.chnks_done.iter().map(|c| c.idx).collect();
    let (first, c0) = chnks
        .iter()
        .enumerate()
        .find(|&(_, c)| !skip.contains(&c.idx))?;
    let argv = vspipe_argv()?;
    let (prog, rest) = argv.split_first()?;
    let mut child = Command::new(prog)
        .args(rest)
        .arg("-s")
        .arg(c0.start.to_string())
        .stderr(Stdio::null())
        .stdout(Stdio::piped())
        .spawn()
        .ok()?;
    unsafe { dup2(child.stdout.take()?.as_raw_fd(), 0) };
    Some(first)
}

#[cfg(target_os = "linux")]
fn vspipe_argv() -> Option<Vec<String>> {
    let pipe = read_link("/proc/self/fd/0").ok()?;
    let me = id();
    read_dir("/proc").ok()?.flatten().find_map(|ent| {
        let dir = ent.path();
        let pid: u32 = dir.file_name()?.to_str()?.parse().ok()?;
        let shares = pid != me
            && read_dir(dir.join("fd"))
                .ok()?
                .flatten()
                .any(|fd| read_link(fd.path()).is_ok_and(|l| l == pipe));
        if !shares {
            return None;
        }
        let exe = read_link(dir.join("exe")).ok()?;
        if exe.file_name()?.to_str()? != "vspipe" {
            return None;
        }
        let mut argv: Vec<String> = read(dir.join("cmdline"))
            .ok()?
            .split(|&b| b == 0)
            .filter(|s| !s.is_empty())
            .map(|s| String::from_utf8_lossy(s).into_owned())
            .collect();
        *argv.first_mut()? = exe.to_string_lossy().into_owned();
        Some(argv)
    })
}
