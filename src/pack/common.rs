unsafe extern "C" {
    pub fn xav_pack_10b(src: *const u8, dst: *mut u8, n: usize);
    pub fn xav_unpack_10b(src: *const u8, dst: *mut u8, n: usize);
    pub fn xav_conv_10b(src: *const u8, dst: *mut u8, n: usize);
    pub fn xav_deint_p010(src: *const u8, ud: *mut u8, vd: *mut u8, n: usize);
    pub fn xav_deint_nv12(src: *const u8, ud: *mut u8, vd: *mut u8, n: usize);
    pub fn xav_deint_nv12_10b(src: *const u8, ud: *mut u8, vd: *mut u8, n: usize);
    pub fn xav_shift_p010(src: *const u8, dst: *mut u8, n: usize);
    pub fn xav_conv_10b_rem(src: *const u8, dst: *mut u8, n: usize);
    pub fn xav_shift_p010_rem(src: *const u8, dst: *mut u8, n: usize);
    pub fn xav_deint_p010_rem(src: *const u8, ud: *mut u8, vd: *mut u8, n: usize);
    pub fn xav_deint_nv12_rem(src: *const u8, ud: *mut u8, vd: *mut u8, n: usize);
    pub fn xav_deint_nv12_10b_rem(src: *const u8, ud: *mut u8, vd: *mut u8, n: usize);
    pub fn xav_pack_10b_rem(src: *const u8, stride: usize, w: usize, h: usize, dst: *mut u8);
    pub fn xav_unpack_10b_rem(src: *const u8, dst: *mut u8, w: usize, h: usize);
}

#[inline]
pub const fn packed_row_sz(w: usize) -> usize {
    (w * 2 * 5).div_ceil(8).next_multiple_of(5)
}

#[inline]
pub const fn calc_8b_sz(w: u32, h: u32) -> usize {
    (w * h * 3 / 2) as usize
}

#[inline]
pub const fn calc_packed_sz(w: u32, h: u32) -> usize {
    let y_row = packed_row_sz(w as usize);
    let uv_row = packed_row_sz(w as usize / 2);
    y_row * h as usize + uv_row * h as usize
}

#[inline]
pub fn pack_stride(
    src: *const u8,
    stride: usize,
    rows: usize,
    iters: usize,
    pack_row: usize,
    out: *mut u8,
) {
    unsafe {
        let (mut s, mut d) = (src, out);

        for _ in 0..rows {
            xav_pack_10b(s, d, iters);
            s = s.add(stride);
            d = d.add(pack_row);
        }
    }
}
