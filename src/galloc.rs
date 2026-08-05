use core::{
    alloc::{GlobalAlloc, Layout},
    ffi::c_void,
    hint::cold_path,
    ptr::null_mut,
};

use crate::sys::{
    MADV_HUGEPAGE, MAP_ANONYMOUS, MAP_PRIVATE, PROT_READ, PROT_WRITE, madvise, mmap, munmap,
};

unsafe extern "C" {
    fn malloc(size: usize) -> *mut c_void;
    fn calloc(nmemb: usize, size: usize) -> *mut c_void;
    fn free(ptr: *mut c_void);
    fn posix_memalign(memptr: *mut *mut c_void, align: usize, size: usize) -> i32;
}

const THRESH: usize = 128 * 1024;
const SLACK: usize = 64;
const MIN_ALIGN: usize = 16;

#[inline]
unsafe fn memalign(layout: Layout) -> *mut u8 {
    let mut p: *mut c_void = null_mut();
    if unsafe { posix_memalign(&raw mut p, layout.align(), layout.size()) } == 0 {
        p.cast()
    } else {
        cold_path();
        null_mut()
    }
}

const fn big(l: Layout) -> bool {
    l.size() >= THRESH
}

#[inline]
fn map(size: usize) -> *mut u8 {
    let n = size + SLACK;
    let p = unsafe {
        mmap(
            null_mut(),
            n,
            PROT_READ | PROT_WRITE,
            MAP_PRIVATE | MAP_ANONYMOUS,
            -1,
            0,
        )
    };
    if (p as isize) < 0 {
        cold_path();
        return null_mut();
    }
    unsafe { madvise(p, n, MADV_HUGEPAGE) };
    p.cast()
}

struct Galloc;

unsafe impl GlobalAlloc for Galloc {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        if big(layout) {
            map(layout.size())
        } else if layout.align() <= MIN_ALIGN {
            unsafe { malloc(layout.size()).cast() }
        } else {
            unsafe { memalign(layout) }
        }
    }

    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        if big(layout) {
            map(layout.size())
        } else if layout.align() <= MIN_ALIGN {
            unsafe { calloc(1, layout.size()).cast() }
        } else {
            let p = unsafe { memalign(layout) };
            if !p.is_null() {
                unsafe { p.write_bytes(0, layout.size()) };
            }
            p
        }
    }

    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        if big(layout) {
            unsafe { munmap(ptr.cast(), layout.size() + SLACK) };
        } else {
            unsafe { free(ptr.cast()) };
        }
    }
}

#[global_allocator]
static GALLOC: Galloc = Galloc;
