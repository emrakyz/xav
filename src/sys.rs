use core::{arch::asm, ffi::c_void};

macro_rules! syscall {
    ($nr:expr) => { syscall!(@ $nr,) };
    ($nr:expr, $a:expr) => { syscall!(@ $nr, in("rdi") $a,) };
    ($nr:expr, $a:expr, $b:expr) => { syscall!(@ $nr, in("rdi") $a, in("rsi") $b,) };
    ($nr:expr, $a:expr, $b:expr, $c:expr) => {
        syscall!(@ $nr, in("rdi") $a, in("rsi") $b, in("rdx") $c,)
    };
    ($nr:expr, $a:expr, $b:expr, $c:expr, $d:expr) => {
        syscall!(@ $nr, in("rdi") $a, in("rsi") $b, in("rdx") $c, in("r10") $d,)
    };
    ($nr:expr, $a:expr, $b:expr, $c:expr, $d:expr, $e:expr) => {
        syscall!(@ $nr, in("rdi") $a, in("rsi") $b, in("rdx") $c, in("r10") $d, in("r8") $e,)
    };
    ($nr:expr, $a:expr, $b:expr, $c:expr, $d:expr, $e:expr, $f:expr) => {
        syscall!(@ $nr, in("rdi") $a, in("rsi") $b, in("rdx") $c, in("r10") $d, in("r8") $e, in("r9") $f,)
    };
    (@ $nr:expr, $($in:tt)*) => {{
        let ret: i64;
        unsafe {
            asm!(
                "syscall",
                inlateout("rax") $nr as i64 => ret,
                $($in)*
                lateout("rcx") _,
                lateout("r11") _,
                options(nostack, preserves_flags),
            );
        }
        ret
    }};
}

pub const PROT_READ: i32 = 1;
pub const PROT_WRITE: i32 = 2;
pub const MAP_SHARED: i32 = 1;
pub const MAP_PRIVATE: i32 = 2;
pub const MAP_ANONYMOUS: i32 = 0x20;
pub const MADV_SEQUENTIAL: i32 = 2;
pub const MADV_HUGEPAGE: i32 = 14;
pub const MADV_NOHUGEPAGE: i32 = 15;

#[repr(C)]
pub struct Statfs {
    pub f_type: i64,
    _pad: [i64; 14],
}

#[inline]
pub unsafe fn dup2(oldfd: i32, newfd: i32) -> i32 {
    syscall!(33, oldfd, newfd) as i32
}

#[inline]
pub unsafe fn mmap(
    addr: *mut c_void,
    len: usize,
    prot: i32,
    flags: i32,
    fd: i32,
    off: i64,
) -> *mut c_void {
    syscall!(9, addr, len, prot, flags, fd, off) as *mut c_void
}

#[inline]
pub unsafe fn munmap(addr: *mut c_void, len: usize) -> i32 {
    syscall!(11, addr, len) as i32
}

#[inline]
pub unsafe fn madvise(addr: *mut c_void, len: usize, advice: i32) -> i32 {
    syscall!(28, addr, len, advice) as i32
}

#[inline]
pub unsafe fn statfs(path: *const i8, buf: *mut Statfs) -> i32 {
    syscall!(137, path, buf) as i32
}

#[inline]
pub unsafe fn close(fd: i32) -> i32 {
    syscall!(3, fd) as i32
}

#[inline]
pub unsafe fn io_uring_setup(entries: u32, p: *mut c_void) -> i64 {
    syscall!(425, entries, p)
}

#[inline]
pub unsafe fn io_uring_enter(
    fd: i32,
    to_submit: u32,
    min_complete: u32,
    flags: u32,
    arg: *const c_void,
    argsz: usize,
) -> i64 {
    syscall!(426, fd, to_submit, min_complete, flags, arg, argsz)
}

#[inline]
pub unsafe fn io_uring_register(fd: i32, opcode: u32, arg: *const c_void, nr_args: u32) -> i64 {
    syscall!(427, fd, opcode, arg, nr_args)
}

#[inline]
pub unsafe fn exit_group(code: i32) -> ! {
    unsafe {
        asm!(
            "syscall",
            in("rax") 231i64,
            in("rdi") code,
            options(noreturn, nostack),
        );
    }
}

#[repr(C)]
struct Sigaction {
    handler: usize,
    flags: usize,
    restorer: usize,
    mask: u64,
}

pub fn sigaction(sig: i32, handler: usize) {
    let act = Sigaction {
        handler,
        flags: 0,
        restorer: 0,
        mask: 0,
    };
    syscall!(13, sig, &raw const act, 0usize, 8usize);
}

#[repr(C)]
struct Timespec {
    tv_sec: i64,
    tv_nsec: i64,
}

fn clock_gettime(clockid: i32) -> Timespec {
    let mut ts = Timespec {
        tv_sec: 0,
        tv_nsec: 0,
    };
    syscall!(228, clockid, &raw mut ts);
    ts
}

pub fn clock_mono_ns() -> u64 {
    let ts = clock_gettime(1);
    ts.tv_sec as u64 * 1_000_000_000 + ts.tv_nsec as u64
}

pub fn nanosleep(sec: i64, nsec: i64) {
    let ts = Timespec {
        tv_sec: sec,
        tv_nsec: nsec,
    };
    syscall!(35, &raw const ts, 0usize);
}

pub fn sched_getaffinity(mask: *mut u64, size: usize) -> i64 {
    syscall!(204, 0i32, size, mask)
}

pub fn clock_real() -> (u64, u32) {
    let ts = clock_gettime(0);
    (ts.tv_sec as u64, ts.tv_nsec as u32)
}

#[cold]
#[inline(never)]
pub fn futex_wait(addr: *const u32, val: u32) {
    syscall!(202, addr, 128i32, val, 0usize);
}

#[cold]
#[inline(never)]
pub fn futex_wake(addr: *const u32) {
    syscall!(202, addr, 129i32, 1i32);
}

pub const O_RDONLY: i32 = 0;
pub const O_WRONLY: i32 = 1;
pub const O_RDWR: i32 = 2;
pub const O_CREAT: i32 = 0o100;
pub const O_TRUNC: i32 = 0o1000;
pub const O_APPEND: i32 = 0o2000;
pub const O_DIRECTORY: i32 = 0o200_000;
pub const O_CLOEXEC: i32 = 0o2_000_000;
pub const AT_REMOVEDIR: i32 = 0x200;
pub const SEEK_SET: i32 = 0;
const AT_FDCWD: i64 = -100;

pub fn openat(path: *const u8, flags: i32, mode: u32) -> i32 {
    syscall!(257, AT_FDCWD, path, flags, mode) as i32
}

pub fn read(fd: i32, buf: *mut u8, count: usize) -> isize {
    syscall!(0, fd, buf, count) as isize
}

pub fn write(fd: i32, buf: *const u8, count: usize) -> isize {
    syscall!(1, fd, buf, count) as isize
}

pub fn lseek(fd: i32, offset: i64, whence: i32) -> i64 {
    syscall!(8, fd, offset, whence)
}

pub fn mkdirat(path: *const u8, mode: u32) -> i32 {
    syscall!(258, AT_FDCWD, path, mode) as i32
}

pub fn unlinkat(path: *const u8, flags: i32) -> i32 {
    syscall!(263, AT_FDCWD, path, flags) as i32
}

pub fn getdents64(fd: i32, buf: *mut u8, count: usize) -> isize {
    syscall!(217, fd, buf, count) as isize
}

pub fn pipe2(fds: *mut i32, flags: i32) -> i32 {
    syscall!(293, fds, flags) as i32
}

pub unsafe fn fork() -> i64 {
    syscall!(57)
}

pub unsafe fn execve(path: *const u8, argv: *const *const u8, envp: *const *const u8) -> i64 {
    syscall!(59, path, argv, envp)
}

pub fn wait4(pid: i32, status: *mut i32, options: i32) -> i64 {
    syscall!(61, pid, status, options, 0usize)
}

pub fn getpid() -> i32 {
    syscall!(39) as i32
}

#[cold]
#[inline(never)]
pub fn isatty(fd: i32) -> bool {
    let mut termios = [0u8; 64];
    syscall!(16, fd, 0x5401i32, termios.as_mut_ptr()) == 0
}

pub fn faccessat(path: *const u8) -> i32 {
    syscall!(269, AT_FDCWD, path, 0i32, 0i32) as i32
}

pub fn readlinkat(path: *const u8, buf: *mut u8, size: usize) -> isize {
    syscall!(267, AT_FDCWD, path, buf, size) as isize
}

pub fn ftruncate(fd: i32, len: i64) -> i32 {
    syscall!(77, fd, len) as i32
}

#[repr(C)]
pub struct Stat {
    _pre: [u8; 24],
    pub st_mode: u32,
    _mid: [u8; 20],
    pub st_size: i64,
    _post: [u8; 88],
}

#[cfg(feature = "vship")]
pub fn copy_file_range(fd_in: i32, fd_out: i32, len: usize) -> isize {
    syscall!(326, fd_in, 0usize, fd_out, 0usize, len, 0usize) as isize
}

pub fn fstat(fd: i32, buf: *mut Stat) -> i32 {
    syscall!(5, fd, buf) as i32
}

pub fn newfstatat(path: *const u8, buf: *mut Stat) -> i32 {
    syscall!(262, AT_FDCWD, path, buf, 0i32) as i32
}
