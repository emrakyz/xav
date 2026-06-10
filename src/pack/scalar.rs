pub const SHIFT_CHUNK: usize = 1;
pub const PACK_CHUNK: usize = 8;
pub const UNPACK_CHUNK: usize = 5;

pub fn conv_10b(inp: &[u8], out: &mut [u8]) {
    inp
        .iter()
        .zip(out.chunks_exact_mut(2))
        .for_each(|(&pix, out_chnk)| {
            let pix_10b = (u16::from(pix) << 2).to_le_bytes();
            out_chnk.copy_from_slice(&pix_10b);
        });
}

pub fn pack_10b(inp: &[u8], out: &mut [u8]) {
    inp
        .chunks_exact(8)
        .zip(out.chunks_exact_mut(5))
        .for_each(|(i_chnk, o_chnk)| {
            let i_arr: &[u8; 8] = unsafe { i_chnk.try_into().unwrap_unchecked() };
            let o_arr: &mut [u8; 5] = unsafe { o_chnk.try_into().unwrap_unchecked() };
            pack_4_pix_10b(*i_arr, o_arr);
        });
}

pub fn unpack_10b(inp: &[u8], out: &mut [u8]) {
    inp
        .chunks_exact(5)
        .zip(out.chunks_exact_mut(8))
        .for_each(|(i_chnk, o_chnk)| {
            let i_arr: &[u8; 5] = unsafe { i_chnk.try_into().unwrap_unchecked() };
            let o_arr: &mut [u8; 8] = unsafe { o_chnk.try_into().unwrap_unchecked() };
            unpack_4_pix_10b(*i_arr, o_arr);
        });
}

pub fn deint_nv12(src: &[u8], u_dst: &mut [u8], v_dst: &mut [u8]) {
    src.chunks_exact(2)
        .zip(u_dst.iter_mut().zip(v_dst.iter_mut()))
        .for_each(|(uv, (u, v))| unsafe {
            *u = *uv.get_unchecked(0);
            *v = *uv.get_unchecked(1);
        });
}

pub fn deint_p010(src: &[u16], u_dst: &mut [u16], v_dst: &mut [u16]) {
    src.chunks_exact(2)
        .zip(u_dst.iter_mut().zip(v_dst.iter_mut()))
        .for_each(|(uv, (u, v))| unsafe {
            *u = *uv.get_unchecked(0) >> 6;
            *v = *uv.get_unchecked(1) >> 6;
        });
}

pub fn deint_nv12_10b(src: &[u8], u_dst: &mut [u16], v_dst: &mut [u16]) {
    src.chunks_exact(2)
        .zip(u_dst.iter_mut().zip(v_dst.iter_mut()))
        .for_each(|(uv, (u, v))| unsafe {
            *u = u16::from(*uv.get_unchecked(0)) << 2;
            *v = u16::from(*uv.get_unchecked(1)) << 2;
        });
}

pub fn shift_p010(src: &[u16], dst: &mut [u16]) {
    src.iter()
        .zip(dst.iter_mut())
        .for_each(|(&s, d)| *d = s >> 6);
}

pub fn shift_p010_rem(src: &[u16], dst: &mut [u16]) {
    shift_p010(src, dst);
}

pub fn conv_10b_rem(inp: &[u8], out: &mut [u8]) {
    conv_10b(inp, out);
}

pub fn deint_p010_rem(src: &[u16], u_dst: &mut [u16], v_dst: &mut [u16]) {
    deint_p010(src, u_dst, v_dst);
}

pub fn deint_nv12_rem(src: &[u8], u_dst: &mut [u8], v_dst: &mut [u8]) {
    deint_nv12(src, u_dst, v_dst);
}

pub fn deint_nv12_10b_rem(src: &[u8], u_dst: &mut [u16], v_dst: &mut [u16]) {
    deint_nv12_10b(src, u_dst, v_dst);
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

    for row in 0..h {
        let src = &inp[row * packed_row..][..packed_row];
        let dst = &mut out[row * unpacked_row..][..unpacked_row];

        unpack_10b(&src[..full_packed], &mut dst[..full_unpacked]);

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
pub fn pack_stride_rem(src: *const u8, stride: usize, w: usize, h: usize, out: *mut u8) {
    let w_bytes = w * 2;
    let y_row = packed_row_sz(w);
    let aligned = w_bytes & !7;
    let pack_aligned = (aligned * 5) / 8;

    unsafe {
        for row in 0..h {
            let src_row = from_raw_parts(src.add(row * stride), w_bytes);
            let dst_row = from_raw_parts_mut(out.add(row * y_row), y_row);

            pack_10b(&src_row[..aligned], &mut dst_row[..pack_aligned]);

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
    let aligned = unpacked_row & !7;
    let pack_aligned = (aligned * 5) / 8;

    for row in 0..h {
        let src = &inp[row * unpacked_row..][..unpacked_row];
        let dst = &mut out[row * y_row..][..y_row];

        pack_10b(&src[..aligned], &mut dst[..pack_aligned]);

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
