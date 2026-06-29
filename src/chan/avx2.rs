unsafe extern "C" {
    fn xav_spsc_send(r: *const SpscRing, x: u64);
    fn xav_spsc_recv(r: *const SpscRing) -> u64;
    fn xav_spsc_close(r: *const SpscRing);
    fn xav_spmc_send(r: *const SeqRing, x: u64);
    fn xav_spmc_recv(r: *const SeqRing) -> u64;
    fn xav_spmc_close(r: *const SeqRing);
    #[cfg(feature = "vship")]
    fn xav_mpmc_send(r: *const SeqRing, x: u64);
    #[cfg(feature = "vship")]
    fn xav_mpmc_recv(r: *const SeqRing) -> u64;
    #[cfg(feature = "vship")]
    fn xav_mpmc_close(r: *const SeqRing);
    #[cfg(feature = "vship")]
    fn xav_mpsc_send(r: *const SeqRing, x: u64);
    #[cfg(feature = "vship")]
    fn xav_mpsc_recv(r: *const SeqRing) -> u64;
    fn xav_sem_acq(s: *const Semaphore);
    fn xav_sem_release(s: *const Semaphore);
}

#[inline(always)]
pub unsafe fn spsc_send(r: *const SpscRing, x: u64) {
    unsafe { xav_spsc_send(r, x) };
}
#[inline(always)]
pub unsafe fn spsc_recv(r: *const SpscRing) -> u64 {
    unsafe { xav_spsc_recv(r) }
}
#[cold]
#[inline(never)]
pub unsafe fn spsc_close(r: *const SpscRing) {
    unsafe { xav_spsc_close(r) };
}

#[inline(always)]
pub unsafe fn spmc_send(r: *const SeqRing, x: u64) {
    unsafe { xav_spmc_send(r, x) };
}
#[inline(always)]
pub unsafe fn spmc_recv(r: *const SeqRing) -> u64 {
    unsafe { xav_spmc_recv(r) }
}
#[cold]
#[inline(never)]
pub unsafe fn spmc_close(r: *const SeqRing) {
    unsafe { xav_spmc_close(r) };
}

#[cfg(feature = "vship")]
#[inline(always)]
pub unsafe fn mpmc_send(r: *const SeqRing, x: u64) {
    unsafe { xav_mpmc_send(r, x) };
}
#[cfg(feature = "vship")]
#[inline(always)]
pub unsafe fn mpmc_recv(r: *const SeqRing) -> u64 {
    unsafe { xav_mpmc_recv(r) }
}
#[cfg(feature = "vship")]
#[cold]
#[inline(never)]
pub unsafe fn mpmc_close(r: *const SeqRing) {
    unsafe { xav_mpmc_close(r) };
}

#[cfg(feature = "vship")]
#[inline(always)]
pub unsafe fn mpsc_send(r: *const SeqRing, x: u64) {
    unsafe { xav_mpsc_send(r, x) };
}
#[cfg(feature = "vship")]
#[inline(always)]
pub unsafe fn mpsc_recv(r: *const SeqRing) -> u64 {
    unsafe { xav_mpsc_recv(r) }
}

#[inline(always)]
pub fn sem_acq(s: &Semaphore) {
    unsafe { xav_sem_acq(s) };
}
#[inline(always)]
pub fn sem_release(s: &Semaphore) {
    unsafe { xav_sem_release(s) };
}
