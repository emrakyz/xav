use std::{
    ptr::copy_nonoverlapping,
    slice::{from_raw_parts, from_raw_parts_mut},
};

#[cfg(target_feature = "avx512bw")]
include!("avx512.rs");
#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
include!("avx2.rs");
#[cfg(not(any(target_feature = "avx2", target_feature = "avx512bw")))]
include!("scalar.rs");

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
pub fn cpy_with_stride(src: *const u8, stride: usize, width: usize, height: usize, dst: *mut u8) {
    unsafe {
        for row in 0..height {
            copy_nonoverlapping(src.add(row * stride), dst.add(row * width), width);
        }
    }
}

#[inline(always)]
pub fn pack_4_pix_10b(inp: [u8; 8], out: &mut [u8; 5]) {
    let raw = u64::from_le_bytes(inp);
    let p0 = u64::from(raw as u16);
    let p1 = u64::from((raw >> 16) as u16);
    let p2 = u64::from((raw >> 32) as u16);
    let p3 = raw >> 48;
    let packed = p0 | (p1 << 10) | (p2 << 20) | (p3 << 30);
    out.copy_from_slice(&packed.to_le_bytes()[..5]);
}

#[inline(always)]
pub const fn unpack_4_pix_10b(inp: [u8; 5], out: &mut [u8; 8]) {
    let packed = u64::from_le_bytes([inp[0], inp[1], inp[2], inp[3], inp[4], 0, 0, 0]);
    let result = (packed & 0x3FF)
        | (((packed >> 10) & 0x3FF) << 16)
        | (((packed >> 20) & 0x3FF) << 32)
        | (((packed >> 30) & 0x3FF) << 48);
    *out = result.to_le_bytes();
}

#[inline]
fn unpack_plane_rem(inp: &[u8], out: &mut [u8], w: usize, h: usize) {
    let unpacked_row = w * 2;
    let packed_row = packed_row_sz(w);
    let full_packed = (unpacked_row / 8) * 5;
    let full_unpacked = (unpacked_row / 8) * 8;
    let simd_in = full_packed / UNPACK_CHUNK * UNPACK_CHUNK;
    let simd_out = simd_in * 8 / 5;

    for row in 0..h {
        let src = &inp[row * packed_row..][..packed_row];
        let dst = &mut out[row * unpacked_row..][..unpacked_row];

        if simd_in > 0 {
            unpack_10b(&src[..simd_in], &mut dst[..simd_out]);
        }

        src[simd_in..full_packed]
            .chunks_exact(5)
            .zip(dst[simd_out..full_unpacked].chunks_exact_mut(8))
            .for_each(|(i, o)| {
                unpack_4_pix_10b(unsafe { i.try_into().unwrap_unchecked() }, unsafe {
                    o.try_into().unwrap_unchecked()
                });
            });

        let rem = unpacked_row % 8;
        if rem > 0 {
            let mut tmp = [0u8; 8];
            unpack_4_pix_10b(
                unsafe { (&src[packed_row - 5..]).try_into().unwrap_unchecked() },
                &mut tmp,
            );
            dst[unpacked_row - rem..].copy_from_slice(&tmp[..rem]);
        }
    }
}

#[inline]
pub fn unpack_10b_rem(inp: &[u8], out: &mut [u8], w: usize, h: usize) {
    let y_packed = packed_row_sz(w) * h;
    let uv_packed = packed_row_sz(w / 2) * (h / 2);

    unpack_plane_rem(&inp[..y_packed], &mut out[..w * h * 2], w, h);
    unpack_plane_rem(
        &inp[y_packed..y_packed + uv_packed],
        &mut out[w * h * 2..w * h * 2 + w * h / 2],
        w / 2,
        h / 2,
    );
    unpack_plane_rem(
        &inp[y_packed + uv_packed..],
        &mut out[w * h * 2 + w * h / 2..],
        w / 2,
        h / 2,
    );
}

#[inline]
pub fn pack_stride(src: *const u8, stride: usize, w: usize, h: usize, out: *mut u8) {
    unsafe {
        let w_bytes = w * 2;
        let pack_row = (w_bytes * 5) / 8;
        let mut pos = 0;

        for row in 0..h {
            let src_row = from_raw_parts(src.add(row * stride), w_bytes);
            let dst_row = from_raw_parts_mut(out.add(pos), pack_row);
            pack_10b(src_row, dst_row);
            pos += pack_row;
        }
    }
}

#[inline]
pub fn pack_stride_rem(src: *const u8, stride: usize, w: usize, h: usize, out: *mut u8) {
    let w_bytes = w * 2;
    let y_row = packed_row_sz(w);
    let simd_in = w_bytes / PACK_CHUNK * PACK_CHUNK;
    let simd_out = (simd_in * 5) / 8;
    let aligned = w_bytes & !7;
    let pack_aligned = (aligned * 5) / 8;

    unsafe {
        for row in 0..h {
            let src_row = from_raw_parts(src.add(row * stride), w_bytes);
            let dst_row = from_raw_parts_mut(out.add(row * y_row), y_row);
            if simd_in > 0 {
                pack_10b(&src_row[..simd_in], &mut dst_row[..simd_out]);
            }

            src_row[simd_in..aligned]
                .chunks_exact(8)
                .zip(dst_row[simd_out..pack_aligned].chunks_exact_mut(5))
                .for_each(|(i, o)| {
                    pack_4_pix_10b(
                        i.try_into().unwrap_unchecked(),
                        o.try_into().unwrap_unchecked(),
                    );
                });

            let rem = w_bytes % 8;
            if rem > 0 {
                let mut tmp = [0u8; 8];
                tmp[..rem].copy_from_slice(&src_row[w_bytes - rem..]);
                pack_4_pix_10b(
                    tmp,
                    (&mut dst_row[y_row - 5..]).try_into().unwrap_unchecked(),
                );
            }
        }
    }
}

#[inline]
pub fn pack_10b_rem(inp: &[u8], out: &mut [u8], w: usize, h: usize) {
    let unpacked_row = w * 2;
    let y_row = packed_row_sz(w);
    let simd_in = unpacked_row / PACK_CHUNK * PACK_CHUNK;
    let simd_out = (simd_in * 5) / 8;
    let aligned = unpacked_row & !7;
    let pack_aligned = (aligned * 5) / 8;

    for row in 0..h {
        let src = &inp[row * unpacked_row..][..unpacked_row];
        let dst = &mut out[row * y_row..][..y_row];

        if simd_in > 0 {
            pack_10b(&src[..simd_in], &mut dst[..simd_out]);
        }

        src[simd_in..aligned]
            .chunks_exact(8)
            .zip(dst[simd_out..pack_aligned].chunks_exact_mut(5))
            .for_each(|(i, o)| unsafe {
                pack_4_pix_10b(
                    i.try_into().unwrap_unchecked(),
                    o.try_into().unwrap_unchecked(),
                );
            });

        let rem = unpacked_row % 8;
        if rem > 0 {
            let mut tmp = [0u8; 8];
            tmp[..rem].copy_from_slice(&src[unpacked_row - rem..]);
            pack_4_pix_10b(tmp, unsafe {
                (&mut dst[y_row - 5..]).try_into().unwrap_unchecked()
            });
        }
    }
}
