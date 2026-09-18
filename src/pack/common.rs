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
pub fn pack_stride(src: *const u8, stride: usize, w: usize, h: usize, out: *mut u8) {
    unsafe {
        let w_bytes = w * 2;
        let pack_row = (w_bytes * 5) / 8;
        let iters = w_bytes / PACK_CHUNK;
        let (mut s, mut d) = (src, out);

        for _ in 0..h {
            xav_pack_10b(s, d, iters);
            s = s.add(stride);
            d = d.add(pack_row);
        }
    }
}
