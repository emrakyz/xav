#![cfg(windows)]

use std::time::Instant;

#[repr(C)]
pub struct Ts {
    sec: i64,
    nsec: i64,
}

static START: std::sync::OnceLock<Instant> = std::sync::OnceLock::new();

#[unsafe(no_mangle)]
extern "C" fn xav_plat_now(_clk: i32, out: *mut Ts) -> i32 {
    let d = START.get_or_init(Instant::now).elapsed();
    unsafe {
        (*out).sec = d.as_secs() as i64;
        (*out).nsec = i64::from(d.subsec_nanos());
    }
    0
}

#[unsafe(no_mangle)]
extern "C" fn xav_plat_write(buf: *const u8, len: usize) {
    use std::io::Write as _;
    let s = unsafe { std::slice::from_raw_parts(buf, len) };
    let mut o = std::io::stdout();
    _ = o.write_all(s);
    _ = o.flush();
}

unsafe extern "system" {
    fn WaitOnAddress(
        addr: *const core::ffi::c_void,
        cmp: *const core::ffi::c_void,
        size: usize,
        ms: u32,
    ) -> i32;
    fn WakeByAddressSingle(addr: *const core::ffi::c_void);
}

#[unsafe(no_mangle)]
extern "C" fn xav_plat_wait(addr: *const u32, val: u32) {
    unsafe { WaitOnAddress(addr.cast(), (&raw const val).cast(), 4, u32::MAX) };
}

#[unsafe(no_mangle)]
extern "C" fn xav_plat_wake(addr: *const u32) {
    unsafe { WakeByAddressSingle(addr.cast()) };
}

#[unsafe(no_mangle)]
extern "C" fn xav_plat_park(addr: *const u32) {
    let want = u32::MAX;
    unsafe { WaitOnAddress(addr.cast(), (&raw const want).cast(), 4, 512) };
}
