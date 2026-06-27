const WIDTH: usize = 2;

unsafe extern "C" {
    fn xav_atou(base: *const u8, off: *const u16, n: usize, out: *mut u64);
    fn xav_atof(base: *const u8, off: *const u16, n: usize, out: *mut f32);
    fn xav_atof2(base: *const u8, off: *const u16, n: usize, out: *mut f32);
    fn xav_scan(base: *const u8, len: usize, out_num: *mut u16, out_nl: *mut u16) -> u64;
}

#[inline(always)]
unsafe fn atou_batch(base: *const u8, off: *const u16, n: usize, out: *mut u64) {
    unsafe { xav_atou(base, off, n, out) };
}

#[inline(always)]
unsafe fn atof4_batch(base: *const u8, off: *const u16, n: usize, out: *mut f32) {
    unsafe { xav_atof(base, off, n, out) };
}

#[inline(always)]
unsafe fn atof2_batch(base: *const u8, off: *const u16, n: usize, out: *mut f32) {
    unsafe { xav_atof2(base, off, n, out) };
}

#[inline(always)]
unsafe fn scan(base: *const u8, len: usize, out_num: *mut u16, out_nl: *mut u16) -> u64 {
    unsafe { xav_scan(base, len, out_num, out_nl) }
}
