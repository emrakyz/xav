use crate::pack::{pack_4_pix_10b, unpack_4_pix_10b};

pub const SHIFT_CHUNK: usize = 1;
pub const PACK_CHUNK: usize = 8;
pub const UNPACK_CHUNK: usize = 5;

pub fn conv_to_10b(input: &[u8], output: &mut [u8]) {
    input
        .iter()
        .zip(output.chunks_exact_mut(2))
        .for_each(|(&pixel, out_chunk)| {
            let pixel_10b = (u16::from(pixel) << 2).to_le_bytes();
            out_chunk.copy_from_slice(&pixel_10b);
        });
}

pub fn pack_10b(input: &[u8], output: &mut [u8]) {
    input
        .chunks_exact(8)
        .zip(output.chunks_exact_mut(5))
        .for_each(|(i_chunk, o_chunk)| {
            let i_arr: &[u8; 8] = unsafe { i_chunk.try_into().unwrap_unchecked() };
            let o_arr: &mut [u8; 5] = unsafe { o_chunk.try_into().unwrap_unchecked() };
            pack_4_pix_10b(*i_arr, o_arr);
        });
}

pub fn unpack_10b(input: &[u8], output: &mut [u8]) {
    input
        .chunks_exact(5)
        .zip(output.chunks_exact_mut(8))
        .for_each(|(i_chunk, o_chunk)| {
            let i_arr: &[u8; 5] = unsafe { i_chunk.try_into().unwrap_unchecked() };
            let o_arr: &mut [u8; 8] = unsafe { o_chunk.try_into().unwrap_unchecked() };
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

pub fn deint_nv12_to_10b(src: &[u8], u_dst: &mut [u16], v_dst: &mut [u16]) {
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
