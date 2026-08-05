#[cfg(target_os = "linux")]
use alloc::{boxed::Box, sync::Arc, vec::Vec};
#[cfg(target_os = "linux")]
use core::ffi::c_void;
#[cfg(not(target_os = "linux"))]
use core::ptr::from_ref;
use core::time::Duration;
#[cfg(target_os = "linux")]
use core::{
    cell::{Cell, UnsafeCell},
    marker::PhantomData,
    mem::MaybeUninit,
    ptr::{null, null_mut},
    sync::atomic::{
        AtomicU32, AtomicUsize,
        Ordering::{Relaxed, Release},
    },
};
#[cfg(not(target_os = "linux"))]
use std::thread::{available_parallelism as std_ap, sleep as std_sleep};

#[cfg(target_os = "linux")]
use crate::sys::{futex_wake, nanosleep, sched_getaffinity};

#[cfg(target_os = "linux")]
const PARKED: u32 = u32::MAX;
#[cfg(target_os = "linux")]
const NOTIFIED: u32 = 1;

#[cfg(target_os = "linux")]
unsafe extern "C" {
    fn pthread_create(
        t: *mut u64,
        attr: *const c_void,
        start: extern "C" fn(*mut c_void) -> *mut c_void,
        arg: *mut c_void,
    ) -> i32;
    fn pthread_join(t: u64, ret: *mut *mut c_void) -> i32;
}

#[cfg(target_os = "linux")]
#[thread_local]
static CUR: Cell<*const AtomicU32> = Cell::new(null());

#[cfg(target_os = "linux")]
struct Start<F, T> {
    f: F,
    result: *mut MaybeUninit<T>,
    park: Arc<AtomicU32>,
}
#[cfg(target_os = "linux")]
unsafe impl<F: Send, T> Send for Start<F, T> {}

#[cfg(target_os = "linux")]
extern "C" fn start<F: FnOnce() -> T, T>(arg: *mut c_void) -> *mut c_void {
    let boxed = unsafe { Box::from_raw(arg.cast::<Start<F, T>>()) };
    let Start { f, result, park } = *boxed;
    CUR.set(Arc::as_ptr(&park));
    let r = f();
    unsafe { (*result).write(r) };
    null_mut()
}

#[cfg(target_os = "linux")]
pub struct Thread {
    park: Arc<AtomicU32>,
}

#[cfg(target_os = "linux")]
impl Thread {
    pub fn unpark(&self) {
        unpark_on(&self.park);
    }
}

#[cfg(target_os = "linux")]
pub struct JoinHandle<T> {
    t: u64,
    result: *mut MaybeUninit<T>,
}

#[cfg(target_os = "linux")]
unsafe impl<T: Send> Send for JoinHandle<T> {}

#[cfg(target_os = "linux")]
impl<T> JoinHandle<T> {
    pub fn join(self) -> T {
        unsafe { pthread_join(self.t, null_mut()) };
        let r = unsafe { (*self.result).assume_init_read() };
        unsafe {
            drop(Box::from_raw(self.result));
        }
        r
    }
}

#[cfg(target_os = "linux")]
pub fn spawn<F, T>(f: F) -> JoinHandle<T>
where
    F: FnOnce() -> T + Send + 'static,
    T: Send + 'static,
{
    let park = Arc::new(AtomicU32::new(0));
    let result = Box::into_raw(Box::new(MaybeUninit::<T>::uninit()));
    let arg = Box::into_raw(Box::new(Start { f, result, park }));
    let mut t = 0u64;
    unsafe { pthread_create(&raw mut t, null(), start::<F, T>, arg.cast()) };
    JoinHandle { t, result }
}

#[cfg(all(target_os = "linux", feature = "vship"))]
pub struct PHandle(u64);

#[cfg(all(target_os = "linux", feature = "vship"))]
extern "C" fn pstart<F: FnOnce()>(arg: *mut c_void) -> *mut c_void {
    let f = unsafe { *Box::from_raw(arg.cast::<F>()) };
    f();
    null_mut()
}

#[cfg(all(target_os = "linux", feature = "vship"))]
pub fn pspawn<F: FnOnce() + Send + 'static>(f: F) -> PHandle {
    let arg = Box::into_raw(Box::new(f));
    let mut t: u64 = 0;
    unsafe { pthread_create(&raw mut t, null(), pstart::<F>, arg.cast()) };
    PHandle(t)
}

#[cfg(all(target_os = "linux", feature = "vship"))]
impl PHandle {
    pub fn join(self) {
        unsafe { pthread_join(self.0, null_mut()) };
    }
}

#[cfg(target_os = "linux")]
pub fn park_state() -> *const u8 {
    CUR.get().cast()
}

#[cfg(target_os = "linux")]
fn unpark_on(s: &AtomicU32) {
    if s.swap(NOTIFIED, Release) == PARKED {
        futex_wake(s.as_ptr());
    }
}

#[cfg(target_os = "linux")]
#[repr(C)]
struct Slot<T> {
    taken: bool,
    val: MaybeUninit<T>,
}

#[cfg(target_os = "linux")]
struct Raw {
    t: u64,
    slot: *mut u8,
    free: unsafe fn(*mut u8),
}

#[cfg(target_os = "linux")]
unsafe fn free_slot<T>(p: *mut u8) {
    let mut b = unsafe { Box::from_raw(p.cast::<Slot<T>>()) };
    if !b.taken {
        unsafe { b.val.assume_init_drop() };
    }
}

#[cfg(target_os = "linux")]
pub struct Scope<'scope, 'env: 'scope> {
    list: UnsafeCell<Vec<Raw>>,
    _s: PhantomData<&'scope mut &'scope ()>,
    _e: PhantomData<&'env mut &'env ()>,
}

#[cfg(target_os = "linux")]
struct ScopedStart<F, T> {
    f: F,
    slot: *mut Slot<T>,
    park: Arc<AtomicU32>,
}
#[cfg(target_os = "linux")]
unsafe impl<F: Send, T> Send for ScopedStart<F, T> {}

#[cfg(target_os = "linux")]
extern "C" fn scoped_start<F: FnOnce() -> T, T>(arg: *mut c_void) -> *mut c_void {
    let boxed = unsafe { Box::from_raw(arg.cast::<ScopedStart<F, T>>()) };
    let ScopedStart { f, slot, park } = *boxed;
    CUR.set(Arc::as_ptr(&park));
    let r = f();
    unsafe { (*slot).val.write(r) };
    null_mut()
}

#[cfg(target_os = "linux")]
pub struct ScopedJoinHandle<'scope, T> {
    t: u64,
    slot: *mut Slot<T>,
    park: Arc<AtomicU32>,
    _s: PhantomData<&'scope ()>,
}

#[cfg(target_os = "linux")]
impl<T> ScopedJoinHandle<'_, T> {
    pub fn join(self) -> T {
        unsafe { pthread_join(self.t, null_mut()) };
        let slot = unsafe { &mut *self.slot };
        slot.taken = true;
        unsafe { slot.val.assume_init_read() }
    }

    pub fn thread(&self) -> Thread {
        Thread {
            park: Arc::clone(&self.park),
        }
    }
}

#[cfg(target_os = "linux")]
impl<'scope> Scope<'scope, '_> {
    pub fn spawn<F, T>(&'scope self, f: F) -> ScopedJoinHandle<'scope, T>
    where
        F: FnOnce() -> T + Send + 'scope,
        T: Send + 'scope,
    {
        let park = Arc::new(AtomicU32::new(0));
        let slot = Box::into_raw(Box::new(Slot {
            taken: false,
            val: MaybeUninit::<T>::uninit(),
        }));
        let arg = Box::into_raw(Box::new(ScopedStart {
            f,
            slot,
            park: Arc::clone(&park),
        }));
        let mut t = 0u64;
        unsafe {
            pthread_create(&raw mut t, null(), scoped_start::<F, T>, arg.cast());
            (*self.list.get()).push(Raw {
                t,
                slot: slot.cast(),
                free: free_slot::<T>,
            });
        }
        ScopedJoinHandle {
            t,
            slot,
            park,
            _s: PhantomData,
        }
    }
}

#[cfg(target_os = "linux")]
pub fn scope<'env, F, T>(f: F) -> T
where
    F: for<'scope> FnOnce(&'scope Scope<'scope, 'env>) -> T,
{
    let sc = Scope {
        list: UnsafeCell::new(Vec::new()),
        _s: PhantomData,
        _e: PhantomData,
    };
    let result = f(&sc);
    for raw in unsafe { &mut *sc.list.get() }.drain(..) {
        unsafe {
            if !*raw.slot.cast::<bool>() {
                pthread_join(raw.t, null_mut());
            }
            (raw.free)(raw.slot);
        }
    }
    result
}

#[cfg(target_os = "linux")]
static NPROC: AtomicUsize = AtomicUsize::new(0);

#[cfg(target_os = "linux")]
pub fn available_parallelism() -> usize {
    let c = NPROC.load(Relaxed);
    if c != 0 {
        return c;
    }
    compute()
}

#[cfg(target_os = "linux")]
#[cold]
#[inline(never)]
fn compute() -> usize {
    let mut mask = [0u64; 8]; // max 512 workers for now
    let n = if sched_getaffinity(mask.as_mut_ptr(), 64) <= 0 {
        1
    } else {
        let c: u32 = mask.iter().map(|w| w.count_ones()).sum();
        (c as usize).max(1)
    };
    NPROC.store(n, Relaxed);
    n
}

#[cfg(target_os = "linux")]
pub fn sleep(dur: Duration) {
    nanosleep(dur.as_secs() as i64, i64::from(dur.subsec_nanos()));
}

#[cfg(not(target_os = "linux"))]
pub type Thread = std::thread::Thread;

#[cfg(not(target_os = "linux"))]
pub struct JoinHandle<T>(std::thread::JoinHandle<T>);

#[cfg(not(target_os = "linux"))]
impl<T> JoinHandle<T> {
    pub fn join(self) -> T {
        self.0.join().unwrap()
    }

    pub fn thread(&self) -> Thread {
        self.0.thread().clone()
    }
}

#[cfg(not(target_os = "linux"))]
#[repr(transparent)]
pub struct Scope<'scope, 'env: 'scope>(std::thread::Scope<'scope, 'env>);

#[cfg(not(target_os = "linux"))]
pub struct ScopedJoinHandle<'scope, T>(std::thread::ScopedJoinHandle<'scope, T>);

#[cfg(not(target_os = "linux"))]
impl<T> ScopedJoinHandle<'_, T> {
    pub fn join(self) -> T {
        self.0.join().unwrap()
    }

    pub fn thread(&self) -> Thread {
        self.0.thread().clone()
    }
}

#[cfg(not(target_os = "linux"))]
impl<'scope> Scope<'scope, '_> {
    pub fn spawn<F, T>(&'scope self, f: F) -> ScopedJoinHandle<'scope, T>
    where
        F: FnOnce() -> T + Send + 'scope,
        T: Send + 'scope,
    {
        ScopedJoinHandle(self.0.spawn(f))
    }
}

#[cfg(not(target_os = "linux"))]
pub fn spawn<F, T>(f: F) -> JoinHandle<T>
where
    F: FnOnce() -> T + Send + 'static,
    T: Send + 'static,
{
    JoinHandle(std::thread::spawn(f))
}

#[cfg(all(not(target_os = "linux"), feature = "vship"))]
pub struct PHandle(std::thread::JoinHandle<()>);

#[cfg(all(not(target_os = "linux"), feature = "vship"))]
pub fn pspawn<F: FnOnce() + Send + 'static>(f: F) -> PHandle {
    PHandle(std::thread::spawn(f))
}

#[cfg(all(not(target_os = "linux"), feature = "vship"))]
impl PHandle {
    pub fn join(self) {
        self.0.join().unwrap();
    }
}

#[cfg(not(target_os = "linux"))]
pub fn scope<'env, F, T>(f: F) -> T
where
    F: for<'scope> FnOnce(&'scope Scope<'scope, 'env>) -> T,
{
    std::thread::scope(|s| f(unsafe { &*from_ref(s).cast() }))
}

#[cfg(not(target_os = "linux"))]
pub fn available_parallelism() -> usize {
    std_ap().map_or(1, |n| n.get())
}

#[cfg(not(target_os = "linux"))]
pub fn sleep(dur: Duration) {
    std_sleep(dur);
}
