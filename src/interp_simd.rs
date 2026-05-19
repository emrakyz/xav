unsafe extern "C" {
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
