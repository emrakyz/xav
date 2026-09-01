#[cfg(target_os = "linux")]
use alloc::vec::Vec;
#[cfg(target_os = "linux")]
use core::{ptr::null, slice::from_raw_parts};

#[cfg(target_os = "linux")]
use crate::io::{Error, Read, Result, Write};
#[cfg(target_os = "linux")]
use crate::process::Stdio::{Inherit, Null, Piped};
#[cfg(target_os = "linux")]
use crate::sys::{
    O_CLOEXEC, O_RDONLY, O_WRONLY, close, dup2, execve, exit_group, faccessat, fork, getpid,
    openat, pipe2, read as sys_read, wait4, write as sys_write,
};

#[cfg(target_os = "linux")]
unsafe extern "C" {
    static environ: *const *const u8;
}

#[cfg(target_os = "linux")]
const DEVNULL: &[u8] = b"/dev/null\0";

#[cfg(target_os = "linux")]
const fn err<T>(ret: i64) -> Result<T> {
    Err(Error::from_raw_os_error((-ret) as i32))
}

#[cfg(target_os = "linux")]
fn cstr(bytes: &[u8]) -> Vec<u8> {
    let mut v = Vec::with_capacity(bytes.len() + 1);
    v.extend_from_slice(bytes);
    v.push(0);
    v
}

#[cfg(target_os = "linux")]
const unsafe fn bytes_of(p: *const u8) -> &'static [u8] {
    let mut len = 0;
    while unsafe { *p.add(len) } != 0 {
        len += 1;
    }
    unsafe { from_raw_parts(p, len) }
}

#[cfg(target_os = "linux")]
fn getenv(name: &[u8]) -> Option<&'static [u8]> {
    let mut p = unsafe { environ };
    while !unsafe { *p }.is_null() {
        let e = unsafe { bytes_of(*p) };
        if e.len() > name.len() && e[name.len()] == b'=' && &e[..name.len()] == name {
            return Some(&e[name.len() + 1..]);
        }
        p = unsafe { p.add(1) };
    }
    None
}

#[cfg(target_os = "linux")]
fn resolve(prog: &[u8]) -> Option<Vec<u8>> {
    let name = &prog[..prog.len() - 1];
    if name.contains(&b'/') {
        return Some(prog.to_vec());
    }
    for dir in getenv(b"PATH")?.split(|&b| b == b':') {
        if dir.is_empty() {
            continue;
        }
        let mut cand = dir.to_vec();
        cand.push(b'/');
        cand.extend_from_slice(name);
        cand.push(0);
        if faccessat(cand.as_ptr()) == 0 {
            return Some(cand);
        }
    }
    None
}

#[cfg(target_os = "linux")]
#[derive(Clone, Copy)]
pub enum Stdio {
    Inherit,
    Null,
    Piped,
}
#[cfg(not(target_os = "linux"))]
pub type Stdio = std::process::Stdio;

#[cfg(target_os = "linux")]
impl Stdio {
    #[inline]
    pub const fn piped() -> Self {
        Self::Piped
    }

    #[inline]
    pub const fn null() -> Self {
        Self::Null
    }
}

#[cfg(target_os = "linux")]
fn setup(cfg: Stdio, input: bool) -> Result<(Option<i32>, Option<i32>)> {
    match cfg {
        Inherit => Ok((None, None)),
        Null => {
            let flags = if input { O_RDONLY } else { O_WRONLY };
            let fd = openat(DEVNULL.as_ptr(), flags, 0);
            if fd < 0 {
                return err(i64::from(fd));
            }
            Ok((None, Some(fd)))
        }
        Piped => {
            let mut fds = [0i32; 2];
            let r = pipe2(fds.as_mut_ptr(), O_CLOEXEC);
            if r < 0 {
                return err(i64::from(r));
            }
            if input {
                Ok((Some(fds[1]), Some(fds[0])))
            } else {
                Ok((Some(fds[0]), Some(fds[1])))
            }
        }
    }
}

#[cfg(target_os = "linux")]
pub struct Command {
    prog: Vec<u8>,
    args: Vec<Vec<u8>>,
    envs: Vec<(Vec<u8>, Vec<u8>)>,
    stdin: Stdio,
    stdout: Stdio,
    stderr: Stdio,
}
#[cfg(not(target_os = "linux"))]
pub type Command = std::process::Command;

#[cfg(target_os = "linux")]
impl Command {
    pub fn new<S: AsRef<[u8]>>(prog: S) -> Self {
        Self {
            prog: cstr(prog.as_ref()),
            args: Vec::new(),
            envs: Vec::new(),
            stdin: Inherit,
            stdout: Inherit,
            stderr: Inherit,
        }
    }

    pub fn arg<S: AsRef<[u8]>>(&mut self, arg: S) -> &mut Self {
        self.args.push(cstr(arg.as_ref()));
        self
    }

    pub fn args<I: IntoIterator<Item = S>, S: AsRef<[u8]>>(&mut self, args: I) -> &mut Self {
        for a in args {
            self.args.push(cstr(a.as_ref()));
        }
        self
    }

    pub fn env<K: AsRef<[u8]>, V: AsRef<[u8]>>(&mut self, key: K, val: V) -> &mut Self {
        self.envs
            .push((key.as_ref().to_vec(), val.as_ref().to_vec()));
        self
    }

    #[inline]
    pub const fn stdin(&mut self, cfg: Stdio) -> &mut Self {
        self.stdin = cfg;
        self
    }

    #[inline]
    pub const fn stdout(&mut self, cfg: Stdio) -> &mut Self {
        self.stdout = cfg;
        self
    }

    #[inline]
    pub const fn stderr(&mut self, cfg: Stdio) -> &mut Self {
        self.stderr = cfg;
        self
    }

    pub fn spawn(&self) -> Result<Child> {
        let path = resolve(&self.prog).ok_or_else(|| Error::from_raw_os_error(2))?;

        let mut argv: Vec<*const u8> = Vec::with_capacity(self.args.len() + 2);
        argv.push(self.prog.as_ptr());
        for a in &self.args {
            argv.push(a.as_ptr());
        }
        argv.push(null());

        let owned: Vec<Vec<u8>> = self
            .envs
            .iter()
            .map(|kv| {
                let mut s = kv.0.clone();
                s.push(b'=');
                s.extend_from_slice(&kv.1);
                s.push(0);
                s
            })
            .collect();
        let mut envp: Vec<*const u8> = Vec::new();
        let mut p = unsafe { environ };
        while !unsafe { *p }.is_null() {
            let keep = self.envs.is_empty() || {
                let e = unsafe { bytes_of(*p) };
                let key = e.split(|&b| b == b'=').next().unwrap_or(e);
                !self.envs.iter().any(|kv| kv.0 == key)
            };
            if keep {
                envp.push(unsafe { *p });
            }
            p = unsafe { p.add(1) };
        }
        for s in &owned {
            envp.push(s.as_ptr());
        }
        envp.push(null());

        let (in_p, in_c) = setup(self.stdin, true)?;
        let (out_p, out_c) = setup(self.stdout, false)?;
        let (err_p, err_c) = setup(self.stderr, false)?;

        let pid = unsafe { fork() };
        if pid < 0 {
            return err(pid);
        }
        if pid == 0 {
            if let Some(fd) = in_c {
                unsafe { dup2(fd, 0) };
            }
            if let Some(fd) = out_c {
                unsafe { dup2(fd, 1) };
            }
            if let Some(fd) = err_c {
                unsafe { dup2(fd, 2) };
            }
            unsafe { execve(path.as_ptr(), argv.as_ptr(), envp.as_ptr()) };
            unsafe { exit_group(127) };
        }

        if let Some(fd) = in_c {
            unsafe { close(fd) };
        }
        if let Some(fd) = out_c {
            unsafe { close(fd) };
        }
        if let Some(fd) = err_c {
            unsafe { close(fd) };
        }

        Ok(Child {
            pid,
            stdin: in_p.map(ChildStdin),
            stdout: out_p.map(ChildStdout),
            stderr: err_p.map(ChildStderr),
        })
    }

    pub fn output(&mut self) -> Result<Output> {
        self.stdout = Piped;
        self.stderr = Piped;
        self.spawn()?.wait_with_output()
    }
}

#[cfg(target_os = "linux")]
pub struct Child {
    pid: i64,
    pub stdin: Option<ChildStdin>,
    pub stdout: Option<ChildStdout>,
    pub stderr: Option<ChildStderr>,
}
#[cfg(not(target_os = "linux"))]
pub type Child = std::process::Child;

#[cfg(target_os = "linux")]
impl Child {
    pub fn wait(&mut self) -> Result<ExitStatus> {
        self.stdin = None;
        let mut status = 0i32;
        let r = wait4(self.pid as i32, &raw mut status, 0);
        if r < 0 {
            return err(r);
        }
        Ok(ExitStatus(status))
    }

    pub fn wait_with_output(mut self) -> Result<Output> {
        self.stdin = None;
        let stdout = read_all(self.stdout.take());
        let stderr = read_all(self.stderr.take());
        #[cfg(test)]
        let status = self.wait()?;
        #[cfg(not(test))]
        self.wait()?;
        Ok(Output {
            #[cfg(test)]
            status,
            stdout,
            stderr,
        })
    }
}

#[cfg(target_os = "linux")]
fn read_all<R: Read>(r: Option<R>) -> Vec<u8> {
    let mut v = Vec::new();
    if let Some(mut r) = r {
        _ = r.read_to_end(&mut v);
    }
    v
}

#[cfg(target_os = "linux")]
pub struct ChildStdin(i32);
#[cfg(target_os = "linux")]
pub struct ChildStdout(i32);
#[cfg(target_os = "linux")]
pub struct ChildStderr(i32);
#[cfg(not(target_os = "linux"))]
pub type ChildStdin = std::process::ChildStdin;

#[cfg(target_os = "linux")]
impl Write for ChildStdin {
    fn write(&mut self, buf: &[u8]) -> Result<usize> {
        let n = sys_write(self.0, buf.as_ptr(), buf.len());
        if n < 0 {
            return err(n as i64);
        }
        Ok(n as usize)
    }

    #[inline]
    fn flush(&mut self) -> Result<()> {
        Ok(())
    }
}

#[cfg(target_os = "linux")]
impl Read for ChildStdout {
    fn read(&mut self, buf: &mut [u8]) -> Result<usize> {
        let n = sys_read(self.0, buf.as_mut_ptr(), buf.len());
        if n < 0 {
            return err(n as i64);
        }
        Ok(n as usize)
    }
}

#[cfg(target_os = "linux")]
impl Read for ChildStderr {
    fn read(&mut self, buf: &mut [u8]) -> Result<usize> {
        let n = sys_read(self.0, buf.as_mut_ptr(), buf.len());
        if n < 0 {
            return err(n as i64);
        }
        Ok(n as usize)
    }
}

#[cfg(target_os = "linux")]
impl ChildStdout {
    #[inline]
    pub const fn as_raw_fd(&self) -> i32 {
        self.0
    }
}

#[cfg(target_os = "linux")]
impl Drop for ChildStdin {
    #[inline]
    fn drop(&mut self) {
        unsafe { close(self.0) };
    }
}

#[cfg(target_os = "linux")]
impl Drop for ChildStdout {
    #[inline]
    fn drop(&mut self) {
        unsafe { close(self.0) };
    }
}

#[cfg(target_os = "linux")]
impl Drop for ChildStderr {
    #[inline]
    fn drop(&mut self) {
        unsafe { close(self.0) };
    }
}

#[cfg(target_os = "linux")]
pub struct ExitStatus(i32);

#[cfg(target_os = "linux")]
impl ExitStatus {
    #[inline]
    pub const fn success(&self) -> bool {
        self.0.trailing_zeros() >= 7 && (self.0 >> 8).trailing_zeros() >= 8
    }
}

#[cfg(target_os = "linux")]
pub struct Output {
    #[cfg(test)]
    pub status: ExitStatus,
    pub stdout: Vec<u8>,
    pub stderr: Vec<u8>,
}

#[cfg(target_os = "linux")]
#[inline]
pub fn id() -> u32 {
    getpid() as u32
}
