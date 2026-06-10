unsafe extern "C" {
    fn xav_crc32_update(state: u32, data: *const u8, len: usize) -> u32;
    fn xav_crc32_combine(crc1: u32, crc2: u32, len2: u64) -> u32;
    fn xav_crc32_copy_nt(state: u32, src: *const u8, dst: *mut u8, len: usize) -> u32;
}

#[inline]
pub fn update(crc: u32, data: &[u8]) -> u32 {
    unsafe { xav_crc32_update(crc, data.as_ptr(), data.len()) }
}

#[inline]
pub fn combine(crc1: u32, crc2: u32, len2: u64) -> u32 {
    unsafe { xav_crc32_combine(crc1, crc2, len2) }
}

#[inline]
pub unsafe fn copy_nt(crc: u32, src: *const u8, dst: *mut u8, len: usize) -> u32 {
    unsafe { xav_crc32_copy_nt(crc, src, dst, len) }
}
