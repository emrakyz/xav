pub const SHIFT_CHUNK: usize = 160;
pub const PACK_CHUNK: usize = 192;
pub const UNPACK_CHUNK: usize = 120;

unsafe extern "C" {
    fn xav_pack_10b(src: *const u8, dst: *mut u8, n: usize);
    fn xav_unpack_10b(src: *const u8, dst: *mut u8, n: usize);
    fn xav_conv_10b(src: *const u8, dst: *mut u8, n: usize);
    fn xav_deint_p010(src: *const u8, ud: *mut u8, vd: *mut u8, n: usize);
    fn xav_deint_nv12(src: *const u8, ud: *mut u8, vd: *mut u8, n: usize);
    fn xav_deint_nv12_10b(src: *const u8, ud: *mut u8, vd: *mut u8, n: usize);
    fn xav_shift_p010(src: *const u8, dst: *mut u8, n: usize);
    fn xav_conv_10b_rem(src: *const u8, dst: *mut u8, n: usize);
    fn xav_shift_p010_rem(src: *const u8, dst: *mut u8, n: usize);
    fn xav_deint_p010_rem(src: *const u8, ud: *mut u8, vd: *mut u8, n: usize);
    fn xav_deint_nv12_rem(src: *const u8, ud: *mut u8, vd: *mut u8, n: usize);
    fn xav_deint_nv12_10b_rem(src: *const u8, ud: *mut u8, vd: *mut u8, n: usize);
    fn xav_pack_10b_rem(src: *const u8, stride: usize, w: usize, h: usize, dst: *mut u8);
    fn xav_unpack_10b_rem(src: *const u8, dst: *mut u8, w: usize, h: usize);
}

#[inline(always)]
pub fn pack_10b(inp: &[u8], out: &mut [u8]) {
    let iters = inp.len() / 192;
    let src = inp.as_ptr();
    let dst = out.as_mut_ptr();
    unsafe {
        xav_pack_10b(src, dst, iters);
    }
}

#[inline(always)]
pub fn unpack_10b(inp: &[u8], out: &mut [u8]) {
    let iters = inp.len() / 120;
    let src = inp.as_ptr();
    let dst = out.as_mut_ptr();
    unsafe {
        xav_unpack_10b(src, dst, iters);
    }
}

#[inline(always)]
pub fn conv_10b(inp: &[u8], out: &mut [u8]) {
    let iters = inp.len() / 160;
    let src = inp.as_ptr();
    let dst = out.as_mut_ptr();
    unsafe {
        xav_conv_10b(src, dst, iters);
    }
}

#[inline(always)]
pub fn deint_p010(src: &[u16], u_dst: &mut [u16], v_dst: &mut [u16]) {
    let iters = u_dst.len() / 160;
    let sb = src.as_ptr().cast::<u8>();
    let ub = u_dst.as_mut_ptr().cast::<u8>();
    let vb = v_dst.as_mut_ptr().cast::<u8>();
    unsafe {
        xav_deint_p010(sb, ub, vb, iters);
    }
}

#[inline(always)]
pub fn deint_nv12(src: &[u8], u_dst: &mut [u8], v_dst: &mut [u8]) {
    let iters = u_dst.len() / 320;
    let sb = src.as_ptr();
    let ub = u_dst.as_mut_ptr();
    let vb = v_dst.as_mut_ptr();
    unsafe {
        xav_deint_nv12(sb, ub, vb, iters);
    }
}

#[inline(always)]
pub fn deint_nv12_10b(src: &[u8], u_dst: &mut [u16], v_dst: &mut [u16]) {
    let iters = u_dst.len() / 320;
    let sb = src.as_ptr();
    let ub = u_dst.as_mut_ptr().cast::<u8>();
    let vb = v_dst.as_mut_ptr().cast::<u8>();
    unsafe {
        xav_deint_nv12_10b(sb, ub, vb, iters);
    }
}

#[inline(always)]
pub fn shift_p010(src: &[u16], dst: &mut [u16]) {
    let iters = dst.len() / 160;
    let sb = src.as_ptr().cast::<u8>();
    let db = dst.as_mut_ptr().cast::<u8>();
    unsafe {
        xav_shift_p010(sb, db, iters);
    }
}

#[inline(always)]
pub fn shift_p010_rem(src: &[u16], dst: &mut [u16]) {
    unsafe {
        xav_shift_p010_rem(src.as_ptr().cast::<u8>(), dst.as_mut_ptr().cast::<u8>(), dst.len());
    }
}

#[inline(always)]
pub fn conv_10b_rem(inp: &[u8], out: &mut [u8]) {
    unsafe {
        xav_conv_10b_rem(inp.as_ptr(), out.as_mut_ptr(), inp.len());
    }
}

#[inline(always)]
pub fn deint_p010_rem(src: &[u16], u_dst: &mut [u16], v_dst: &mut [u16]) {
    unsafe {
        xav_deint_p010_rem(
            src.as_ptr().cast::<u8>(),
            u_dst.as_mut_ptr().cast::<u8>(),
            v_dst.as_mut_ptr().cast::<u8>(),
            u_dst.len(),
        );
    }
}

#[inline(always)]
pub fn deint_nv12_rem(src: &[u8], u_dst: &mut [u8], v_dst: &mut [u8]) {
    unsafe {
        xav_deint_nv12_rem(src.as_ptr(), u_dst.as_mut_ptr(), v_dst.as_mut_ptr(), u_dst.len());
    }
}

#[inline(always)]
pub fn deint_nv12_10b_rem(src: &[u8], u_dst: &mut [u16], v_dst: &mut [u16]) {
    unsafe {
        xav_deint_nv12_10b_rem(
            src.as_ptr(),
            u_dst.as_mut_ptr().cast::<u8>(),
            v_dst.as_mut_ptr().cast::<u8>(),
            u_dst.len(),
        );
    }
}

#[inline(always)]
pub fn pack_10b_rem(inp: &[u8], out: &mut [u8], w: usize, h: usize) {
    unsafe {
        xav_pack_10b_rem(inp.as_ptr(), w * 2, w, h, out.as_mut_ptr());
    }
}

#[inline(always)]
pub fn pack_stride_rem(src: *const u8, stride: usize, w: usize, h: usize, out: *mut u8) {
    unsafe {
        xav_pack_10b_rem(src, stride, w, h, out);
    }
}

#[inline(always)]
pub fn unpack_10b_rem(inp: &[u8], out: &mut [u8], w: usize, h: usize) {
    unsafe {
        xav_unpack_10b_rem(inp.as_ptr(), out.as_mut_ptr(), w, h);
    }
}
