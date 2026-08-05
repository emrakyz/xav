#[cfg(not(target_os = "linux"))]
use core::ops::{Deref, DerefMut};
#[cfg(target_os = "linux")]
use core::{
    cell::UnsafeCell,
    hint::{cold_path, spin_loop},
    mem::MaybeUninit,
    ops::{Deref, DerefMut},
    sync::atomic::{
        AtomicU32,
        Ordering::{Acquire, Relaxed, Release},
    },
};

#[cfg(target_os = "linux")]
use crate::sys::{futex_wait, futex_wake};

#[cfg(target_os = "linux")]
const SPIN: u32 = 100;

#[cfg(target_os = "linux")]
#[repr(C)]
pub struct Mutex<T> {
    state: AtomicU32,
    value: UnsafeCell<T>,
}
#[cfg(not(target_os = "linux"))]
pub struct Mutex<T>(std::sync::Mutex<T>);

#[cfg(target_os = "linux")]
unsafe impl<T: Send> Send for Mutex<T> {}
#[cfg(target_os = "linux")]
unsafe impl<T: Send> Sync for Mutex<T> {}

#[cfg(target_os = "linux")]
impl<T> Mutex<T> {
    #[inline]
    pub const fn new(value: T) -> Self {
        Self {
            state: AtomicU32::new(0),
            value: UnsafeCell::new(value),
        }
    }

    #[inline]
    pub fn lock(&self) -> Guard<'_, T> {
        if self.state.compare_exchange(0, 1, Acquire, Relaxed).is_err() {
            cold_path();
            lock_slow(&self.state);
        }
        Guard { mtx: self }
    }
}
#[cfg(not(target_os = "linux"))]
impl<T> Mutex<T> {
    #[inline]
    pub const fn new(value: T) -> Self {
        Self(std::sync::Mutex::new(value))
    }

    #[inline]
    pub fn lock(&self) -> Guard<'_, T> {
        Guard(
            self.0
                .lock()
                .unwrap_or_else(std::sync::PoisonError::into_inner),
        )
    }
}

#[cfg(target_os = "linux")]
#[cold]
#[inline(never)]
fn lock_slow(state: &AtomicU32) {
    let mut spin = 0;
    while state.load(Relaxed) == 1 && spin < SPIN {
        spin_loop();
        spin += 1;
    }
    if state.compare_exchange(0, 1, Acquire, Relaxed).is_ok() {
        return;
    }
    while state.swap(2, Acquire) != 0 {
        futex_wait(state.as_ptr(), 2);
    }
}

#[cfg(target_os = "linux")]
pub struct Guard<'a, T> {
    mtx: &'a Mutex<T>,
}
#[cfg(not(target_os = "linux"))]
pub struct Guard<'a, T>(std::sync::MutexGuard<'a, T>);

impl<T> Deref for Guard<'_, T> {
    type Target = T;

    #[inline]
    fn deref(&self) -> &T {
        #[cfg(target_os = "linux")]
        unsafe {
            &*self.mtx.value.get()
        }
        #[cfg(not(target_os = "linux"))]
        &self.0
    }
}

impl<T> DerefMut for Guard<'_, T> {
    #[inline]
    fn deref_mut(&mut self) -> &mut T {
        #[cfg(target_os = "linux")]
        unsafe {
            &mut *self.mtx.value.get()
        }
        #[cfg(not(target_os = "linux"))]
        &mut self.0
    }
}

#[cfg(target_os = "linux")]
impl<T> Drop for Guard<'_, T> {
    #[inline]
    fn drop(&mut self) {
        if self.mtx.state.swap(0, Release) == 2 {
            cold_path();
            futex_wake(self.mtx.state.as_ptr());
        }
    }
}

#[cfg(target_os = "linux")]
pub struct OnceLock<T> {
    state: AtomicU32,
    value: UnsafeCell<MaybeUninit<T>>,
}
#[cfg(not(target_os = "linux"))]
pub struct OnceLock<T>(std::sync::OnceLock<T>);

#[cfg(target_os = "linux")]
unsafe impl<T: Send> Send for OnceLock<T> {}
#[cfg(target_os = "linux")]
unsafe impl<T: Send + Sync> Sync for OnceLock<T> {}

#[cfg(target_os = "linux")]
impl<T> Default for OnceLock<T> {
    #[inline]
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(target_os = "linux")]
impl<T> OnceLock<T> {
    #[inline]
    pub const fn new() -> Self {
        Self {
            state: AtomicU32::new(0),
            value: UnsafeCell::new(MaybeUninit::uninit()),
        }
    }

    #[inline]
    pub fn get(&self) -> Option<&T> {
        (self.state.load(Acquire) == 2).then(|| unsafe { (*self.value.get()).assume_init_ref() })
    }

    pub fn set(&self, value: T) -> Result<(), T> {
        if self.state.compare_exchange(0, 1, Acquire, Relaxed).is_ok() {
            unsafe { (*self.value.get()).write(value) };
            self.state.store(2, Release);
            futex_wake(self.state.as_ptr());
            Ok(())
        } else {
            Err(value)
        }
    }

    #[inline]
    pub fn get_or_init<F: FnOnce() -> T>(&self, f: F) -> &T {
        if let Some(v) = self.get() {
            return v;
        }
        self.init_slow(f)
    }

    #[cold]
    #[inline(never)]
    fn init_slow<F: FnOnce() -> T>(&self, f: F) -> &T {
        if self.state.compare_exchange(0, 1, Acquire, Relaxed).is_ok() {
            unsafe { (*self.value.get()).write(f()) };
            self.state.store(2, Release);
            futex_wake(self.state.as_ptr());
        } else {
            while self.state.load(Acquire) != 2 {
                futex_wait(self.state.as_ptr(), 1);
            }
        }
        unsafe { (*self.value.get()).assume_init_ref() }
    }
}
#[cfg(not(target_os = "linux"))]
impl<T> OnceLock<T> {
    #[inline]
    pub const fn new() -> Self {
        Self(std::sync::OnceLock::new())
    }

    #[inline]
    pub fn get(&self) -> Option<&T> {
        self.0.get()
    }

    #[inline]
    pub fn set(&self, value: T) -> Result<(), T> {
        self.0.set(value)
    }

    #[inline]
    pub fn get_or_init<F: FnOnce() -> T>(&self, f: F) -> &T {
        self.0.get_or_init(f)
    }
}

#[cfg(all(test, target_os = "linux"))]
pub struct Once {
    state: AtomicU32,
}
#[cfg(all(test, not(target_os = "linux")))]
pub struct Once(std::sync::Once);

#[cfg(all(test, target_os = "linux"))]
impl Once {
    #[inline]
    pub const fn new() -> Self {
        Self {
            state: AtomicU32::new(0),
        }
    }

    #[inline]
    pub fn call_once<F: FnOnce()>(&self, f: F) {
        if self.state.load(Acquire) != 2 {
            cold_path();
            self.call_slow(f);
        }
    }

    #[cold]
    #[inline(never)]
    fn call_slow<F: FnOnce()>(&self, f: F) {
        if self.state.compare_exchange(0, 1, Acquire, Relaxed).is_ok() {
            f();
            self.state.store(2, Release);
            futex_wake(self.state.as_ptr());
        } else {
            while self.state.load(Acquire) != 2 {
                futex_wait(self.state.as_ptr(), 1);
            }
        }
    }
}
#[cfg(all(test, not(target_os = "linux")))]
impl Once {
    #[inline]
    pub const fn new() -> Self {
        Self(std::sync::Once::new())
    }

    #[inline]
    pub fn call_once<F: FnOnce()>(&self, f: F) {
        self.0.call_once(f);
    }
}
