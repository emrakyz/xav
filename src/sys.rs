use core::{arch::asm, ffi::c_void};

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
    let ret: i64;
    unsafe {
        asm!(
            "syscall",
            inlateout("rax") 33i64 => ret,
            in("rdi") oldfd,
            in("rsi") newfd,
            lateout("rcx") _,
            lateout("r11") _,
            options(nostack, preserves_flags),
        );
    }
    ret as i32
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
    let ret: *mut c_void;
    unsafe {
        asm!(
            "syscall",
            inlateout("rax") 9i64 => ret,
            in("rdi") addr,
            in("rsi") len,
            in("rdx") prot,
            in("r10") flags,
            in("r8") fd,
            in("r9") off,
            lateout("rcx") _,
            lateout("r11") _,
            options(nostack, preserves_flags),
        );
    }
    ret
}

#[inline]
pub unsafe fn munmap(addr: *mut c_void, len: usize) -> i32 {
    let ret: i64;
    unsafe {
        asm!(
            "syscall",
            inlateout("rax") 11i64 => ret,
            in("rdi") addr,
            in("rsi") len,
            lateout("rcx") _,
            lateout("r11") _,
            options(nostack, preserves_flags),
        );
    }
    ret as i32
}

#[inline]
pub unsafe fn madvise(addr: *mut c_void, len: usize, advice: i32) -> i32 {
    let ret: i64;
    unsafe {
        asm!(
            "syscall",
            inlateout("rax") 28i64 => ret,
            in("rdi") addr,
            in("rsi") len,
            in("rdx") advice,
            lateout("rcx") _,
            lateout("r11") _,
            options(nostack, preserves_flags),
        );
    }
    ret as i32
}

#[inline]
pub unsafe fn statfs(path: *const i8, buf: *mut Statfs) -> i32 {
    let ret: i64;
    unsafe {
        asm!(
            "syscall",
            inlateout("rax") 137i64 => ret,
            in("rdi") path,
            in("rsi") buf,
            lateout("rcx") _,
            lateout("r11") _,
            options(nostack, preserves_flags),
        );
    }
    ret as i32
}

#[inline]
pub unsafe fn close(fd: i32) -> i32 {
    let ret: i64;
    unsafe {
        asm!(
            "syscall",
            inlateout("rax") 3i64 => ret,
            in("rdi") fd,
            lateout("rcx") _,
            lateout("r11") _,
            options(nostack, preserves_flags),
        );
    }
    ret as i32
}

#[inline]
pub unsafe fn io_uring_setup(entries: u32, p: *mut c_void) -> i64 {
    let ret: i64;
    unsafe {
        asm!(
            "syscall",
            inlateout("rax") 425i64 => ret,
            in("rdi") entries,
            in("rsi") p,
            lateout("rcx") _,
            lateout("r11") _,
            options(nostack, preserves_flags),
        );
    }
    ret
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
    let ret: i64;
    unsafe {
        asm!(
            "syscall",
            inlateout("rax") 426i64 => ret,
            in("rdi") fd,
            in("rsi") to_submit,
            in("rdx") min_complete,
            in("r10") flags,
            in("r8") arg,
            in("r9") argsz,
            lateout("rcx") _,
            lateout("r11") _,
            options(nostack, preserves_flags),
        );
    }
    ret
}

#[inline]
pub unsafe fn io_uring_register(fd: i32, opcode: u32, arg: *const c_void, nr_args: u32) -> i64 {
    let ret: i64;
    unsafe {
        asm!(
            "syscall",
            inlateout("rax") 427i64 => ret,
            in("rdi") fd,
            in("rsi") opcode,
            in("rdx") arg,
            in("r10") nr_args,
            lateout("rcx") _,
            lateout("r11") _,
            options(nostack, preserves_flags),
        );
    }
    ret
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
    unsafe {
        asm!(
            "syscall",
            inlateout("rax") 13i64 => _,
            in("rdi") sig,
            in("rsi") &raw const act,
            in("rdx") 0usize,
            in("r10") 8usize,
            lateout("rcx") _,
            lateout("r11") _,
            options(nostack, preserves_flags),
        );
    }
}
