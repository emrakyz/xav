use std::{
    sync::atomic::Ordering::{Acquire, Relaxed, Release},
    thread::yield_now,
};

const MASK: u32 = CAP - 1;

fn sp_lock(r: &SpscRing) {
    while r
        .avail
        .compare_exchange_weak(0, 1, Acquire, Relaxed)
        .is_err()
    {
        yield_now();
    }
}

#[inline(always)]
pub unsafe fn spsc_send(r: *const SpscRing, x: u64) {
    let r = unsafe { &*r };
    loop {
        sp_lock(r);
        let t = r.tail.load(Relaxed);
        let h = r.head.load(Relaxed);
        if t.wrapping_sub(h) < CAP {
            unsafe { (*r.slots.get())[(t & MASK) as usize] = x };
            r.tail.store(t.wrapping_add(1), Relaxed);
            r.avail.store(0, Release);
            return;
        }
        r.avail.store(0, Release);
        yield_now();
    }
}

#[inline(always)]
pub unsafe fn spsc_recv(r: *const SpscRing) -> u64 {
    let r = unsafe { &*r };
    loop {
        sp_lock(r);
        let h = r.head.load(Relaxed);
        let t = r.tail.load(Relaxed);
        if h != t {
            let x = unsafe { (*r.slots.get())[(h & MASK) as usize] };
            r.head.store(h.wrapping_add(1), Relaxed);
            r.avail.store(0, Release);
            return x;
        }
        let c = r.closed.load(Relaxed);
        r.avail.store(0, Release);
        if c != 0 {
            return 0;
        }
        yield_now();
    }
}

#[cold]
#[inline(never)]
pub unsafe fn spsc_close(r: *const SpscRing) {
    unsafe { &*r }.closed.store(1, Release);
}

fn seq_lock(r: &SeqRing) {
    while r
        .space
        .compare_exchange_weak(0, 1, Acquire, Relaxed)
        .is_err()
    {
        yield_now();
    }
}

#[inline(always)]
unsafe fn seq_send(r: *const SeqRing, x: u64) {
    let r = unsafe { &*r };
    loop {
        seq_lock(r);
        let t = r.tail.load(Relaxed);
        let h = r.head.load(Relaxed);
        if t.wrapping_sub(h) < CAP {
            unsafe { (*r.vals.get())[(t & MASK) as usize] = x };
            r.tail.store(t.wrapping_add(1), Relaxed);
            r.space.store(0, Release);
            return;
        }
        r.space.store(0, Release);
        yield_now();
    }
}

#[inline(always)]
unsafe fn seq_recv(r: *const SeqRing) -> u64 {
    let r = unsafe { &*r };
    loop {
        seq_lock(r);
        let h = r.head.load(Relaxed);
        let t = r.tail.load(Relaxed);
        if h != t {
            let x = unsafe { (*r.vals.get())[(h & MASK) as usize] };
            r.head.store(h.wrapping_add(1), Relaxed);
            r.space.store(0, Release);
            return x;
        }
        let c = r.closed.load(Relaxed);
        r.space.store(0, Release);
        if c != 0 {
            return 0;
        }
        yield_now();
    }
}

#[cold]
#[inline(never)]
unsafe fn seq_close(r: *const SeqRing) {
    unsafe { &*r }.closed.store(1, Release);
}

#[inline(always)]
pub unsafe fn spmc_send(r: *const SeqRing, x: u64) {
    unsafe { seq_send(r, x) };
}
#[inline(always)]
pub unsafe fn spmc_recv(r: *const SeqRing) -> u64 {
    unsafe { seq_recv(r) }
}
#[cold]
#[inline(never)]
pub unsafe fn spmc_close(r: *const SeqRing) {
    unsafe { seq_close(r) };
}

#[cfg(feature = "vship")]
#[inline(always)]
pub unsafe fn mpmc_send(r: *const SeqRing, x: u64) {
    unsafe { seq_send(r, x) };
}
#[cfg(feature = "vship")]
#[inline(always)]
pub unsafe fn mpmc_recv(r: *const SeqRing) -> u64 {
    unsafe { seq_recv(r) }
}
#[cfg(feature = "vship")]
#[cold]
#[inline(never)]
pub unsafe fn mpmc_close(r: *const SeqRing) {
    unsafe { seq_close(r) };
}

#[cfg(feature = "vship")]
#[inline(always)]
pub unsafe fn mpsc_send(r: *const SeqRing, x: u64) {
    unsafe { seq_send(r, x) };
}
#[cfg(feature = "vship")]
#[inline(always)]
pub unsafe fn mpsc_recv(r: *const SeqRing) -> u64 {
    unsafe { seq_recv(r) }
}

#[inline(always)]
pub fn sem_acq(s: &Semaphore) {
    loop {
        let c = s.count.load(Relaxed);
        if c != 0
            && s.count
                .compare_exchange_weak(c, c.wrapping_sub(1), Acquire, Relaxed)
                .is_ok()
        {
            return;
        }
        yield_now();
    }
}
#[inline(always)]
pub fn sem_release(s: &Semaphore) {
    s.count.fetch_add(1, Release);
}
