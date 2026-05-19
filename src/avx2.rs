pub const SHIFT_CHUNK: usize = 160;
pub const PACK_CHUNK: usize = 192;
pub const UNPACK_CHUNK: usize = 120;

unsafe extern "C" {
    fn xav_pack_10b(src: *const u8, dst: *mut u8, n: usize);
    fn xav_unpack_10b(src: *const u8, dst: *mut u8, n: usize);
    fn xav_conv_to_10b(src: *const u8, dst: *mut u8, n: usize);
    fn xav_deint_p010(src: *const u8, ud: *mut u8, vd: *mut u8, n: usize);
    fn xav_deint_nv12(src: *const u8, ud: *mut u8, vd: *mut u8, n: usize);
    fn xav_deint_nv12_to_10b(src: *const u8, ud: *mut u8, vd: *mut u8, n: usize);
    fn xav_shift_p010(src: *const u8, dst: *mut u8, n: usize);
    fn xav_pchip(x: *const f32, y: *const f32, n: usize, xi: f32, s: *mut f32, d: *mut f32) -> f32;
    fn xav_fritsch_carlson(x: *const f32, y: *const f32, xi: f32) -> f32;
    fn xav_lerp(x: *const f32, y: *const f32, xi: f32) -> f32;
    fn xav_binary_search(min: f32, max: f32) -> f32;
}

#[inline(always)]
pub fn lerp(x: &[f32], y: &[f32], xi: f32) -> f32 {
    unsafe { xav_lerp(x.as_ptr(), y.as_ptr(), xi) }
}

#[inline(always)]
pub fn fritsch_carlson(x: &[f32], y: &[f32], xi: f32) -> f32 {
    unsafe { xav_fritsch_carlson(x.as_ptr(), y.as_ptr(), xi) }
}

#[inline(always)]
pub fn pchip(x: &[f32], y: &[f32], xi: f32) -> f32 {
    let n = x.len();
    let mut s = [0.0f32; 64];
    let mut d = [0.0f32; 64];
    unsafe {
        xav_pchip(
            x.as_ptr(),
            y.as_ptr(),
            n,
            xi,
            s.as_mut_ptr(),
            d.as_mut_ptr(),
        )
    }
}

#[inline(always)]
pub fn binary_search(min: f32, max: f32) -> f32 {
    unsafe { xav_binary_search(min, max) }
}

#[inline(always)]
pub fn pack_10b(input: &[u8], output: &mut [u8]) {
    let iters = input.len() / 192;
    let src = input.as_ptr();
    let dst = output.as_mut_ptr();
    unsafe {
        xav_pack_10b(src, dst, iters);
    }
}

#[inline(always)]
pub fn unpack_10b(input: &[u8], output: &mut [u8]) {
    let iters = input.len() / 120;
    let src = input.as_ptr();
    let dst = output.as_mut_ptr();
    unsafe {
        xav_unpack_10b(src, dst, iters);
    }
}

#[inline(always)]
pub fn conv_to_10b(input: &[u8], output: &mut [u8]) {
    let iters = input.len() / 160;
    let src = input.as_ptr();
    let dst = output.as_mut_ptr();
    unsafe {
        xav_conv_to_10b(src, dst, iters);
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
pub fn deint_nv12_to_10b(src: &[u8], u_dst: &mut [u16], v_dst: &mut [u16]) {
    let iters = u_dst.len() / 320;
    let sb = src.as_ptr();
    let ub = u_dst.as_mut_ptr().cast::<u8>();
    let vb = v_dst.as_mut_ptr().cast::<u8>();
    unsafe {
        xav_deint_nv12_to_10b(sb, ub, vb, iters);
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
    let len = dst.len();
    let iters = len / 160;
    if iters > 0 {
        let sb = src.as_ptr().cast::<u8>();
        let db = dst.as_mut_ptr().cast::<u8>();
        unsafe {
            xav_shift_p010(sb, db, iters);
        }
    }
    shift_p010_tail(src, dst, iters * 160);
}

#[cold]
#[inline(never)]
fn shift_p010_tail(src: &[u16], dst: &mut [u16], start: usize) {
    unsafe {
        for i in start..dst.len() {
            *dst.get_unchecked_mut(i) = *src.get_unchecked(i) >> 6;
        }
    }
}
