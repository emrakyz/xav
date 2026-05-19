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

const MAX_TAU2: f32 = 9.0;

#[inline]
pub fn lerp(x: &[f32], y: &[f32], xi: f32) -> f32 {
    let t = (xi - x[0]) / (x[1] - x[0]);
    t.mul_add(y[1] - y[0], y[0])
}

pub fn pchip(x: &[f32], y: &[f32], xi: f32) -> f32 {
    let n = x.len();
    let k = (0..n - 1)
        .find(|&i| xi >= x[i] && xi <= x[i + 1])
        .unwrap_or(0);

    let s: Vec<f32> = (0..n - 1)
        .map(|i| (y[i + 1] - y[i]) / (x[i + 1] - x[i]))
        .collect();

    let mut d = vec![0.0; n];
    d[0] = s[0];
    d[n - 1] = s[n - 2];

    for i in 1..n - 1 {
        let s_prev = s[i - 1];
        let s_next = s[i];
        if s_prev * s_next <= 0.0 {
            d[i] = 0.0;
        } else {
            let h_prev = x[i] - x[i - 1];
            let h_next = x[i + 1] - x[i];
            let w1 = 2.0f32.mul_add(h_next, h_prev);
            let w2 = 2.0f32.mul_add(h_prev, h_next);
            d[i] = (w1 + w2) / (w1 / s_prev + w2 / s_next);
        }
    }

    for i in 0..n - 1 {
        if s[i] == 0.0 {
            d[i] = 0.0;
            d[i + 1] = 0.0;
        } else {
            let alpha = d[i] / s[i];
            let beta = d[i + 1] / s[i];
            let tau = alpha.mul_add(alpha, beta * beta);

            if tau > MAX_TAU2 {
                let scale = 3.0 / tau.sqrt();
                d[i] = scale * alpha * s[i];
                d[i + 1] = scale * beta * s[i];
            }
        }
    }

    let h = x[k + 1] - x[k];
    let t = (xi - x[k]) / h;
    let t2 = t * t;
    let t3 = t2 * t;

    let h00 = 2.0f32.mul_add(t3, -3.0 * t2) + 1.0;
    let h10 = 2.0f32.mul_add(-t2, t3) + t;
    let h01 = (-2.0f32).mul_add(t3, 3.0 * t2);
    let h11 = t3 - t2;

    h00.mul_add(
        y[k],
        (h10 * h).mul_add(d[k], (h11 * h).mul_add(d[k + 1], h01 * y[k + 1])),
    )
}

pub fn fritsch_carlson(x: &[f32], y: &[f32], xi: f32) -> f32 {
    let k = usize::from(xi >= x[1] && xi <= x[2]);

    let d0 = (y[1] - y[0]) / (x[1] - x[0]);
    let d1 = (y[2] - y[1]) / (x[2] - x[1]);

    let mut m = [0.0; 3];

    m[0] = d0;
    m[2] = d1;

    if d0 * d1 <= 0.0 {
        m[1] = 0.0;
    } else {
        let h0 = x[1] - x[0];
        let h1 = x[2] - x[1];
        let w1 = 2.0f32.mul_add(h1, h0);
        let w2 = 2.0f32.mul_add(h0, h1);
        m[1] = (w1 + w2) / (w1 / d0 + w2 / d1);
    }

    let h = x[k + 1] - x[k];
    let t = (xi - x[k]) / h;
    let t2 = t * t;
    let t3 = t2 * t;

    let h00 = 2.0f32.mul_add(t3, 3.0f32.mul_add(-t2, 1.0));
    let h10 = 2.0f32.mul_add(-t2, t3.mul_add(1.0, t));
    let h01 = (-2.0f32).mul_add(t3, 3.0 * t2);
    let h11 = t3 - t2;

    (h11 * h).mul_add(
        m[k + 1],
        h00.mul_add(y[k], h10.mul_add(h * m[k], h01 * y[k + 1])),
    )
}

fn round_crf(crf: f32) -> f32 {
    (crf * 4.0).round() / 4.0
}

pub fn binary_search(min: f32, max: f32) -> f32 {
    round_crf(f32::midpoint(min, max))
}
