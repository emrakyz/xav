const SATD_BATCH: usize = 8;
const IMP_BATCH: usize = 8;

unsafe extern "C" {
    fn xav_satd8x8_x8(src: *const u8, ss: usize, dst: *const u8, ds: usize) -> u32;
    fn xav_satd8x8_dc(src: *const u8, ss: usize) -> u32;
    fn xav_importance_x8(org: *const u8, os: usize, rf: *const u8, rs: usize) -> u32;
    fn xav_satd16_x8(src: *const u16, ss: usize, dst: *const u16, ds: usize) -> u32;
    fn xav_satd16_dc(src: *const u16, ss: usize) -> u32;
    fn xav_importance16_x8(org: *const u16, os: usize, rf: *const u16, rs: usize) -> u32;
    fn xav_satd16_s_x8(src: *const u16, ss: usize, dst: *const u16, ds: usize) -> u32;
    fn xav_satd16_dc_s(src: *const u16, ss: usize) -> u32;
    fn xav_importance16_s_x8(org: *const u16, os: usize, rf: *const u16, rs: usize) -> u32;
}

impl Pixel for u8 {
    #[inline(always)]
    unsafe fn satd_dc<const S: bool>(src: *const Self, stride: usize) -> u32 {
        unsafe { xav_satd8x8_dc(src, stride) }
    }
    #[inline(always)]
    unsafe fn satd<const S: bool>(cur: *const Self, rf: *const Self, stride: usize) -> u32 {
        unsafe { xav_satd8x8_x8(cur, stride, rf, stride) }
    }
    #[inline(always)]
    unsafe fn imp<const S: bool>(cur: *const Self, rf: *const Self, stride: usize) -> u32 {
        unsafe { xav_importance_x8(cur, stride, rf, stride) }
    }
}

impl Pixel for u16 {
    #[inline(always)]
    unsafe fn satd_dc<const S: bool>(src: *const Self, stride: usize) -> u32 {
        unsafe {
            if S {
                xav_satd16_dc_s(src, stride * 2)
            } else {
                xav_satd16_dc(src, stride * 2)
            }
        }
    }
    #[inline(always)]
    unsafe fn satd<const S: bool>(cur: *const Self, rf: *const Self, stride: usize) -> u32 {
        unsafe {
            if S {
                xav_satd16_s_x8(cur, stride * 2, rf, stride * 2)
            } else {
                xav_satd16_x8(cur, stride * 2, rf, stride * 2)
            }
        }
    }
    #[inline(always)]
    unsafe fn imp<const S: bool>(cur: *const Self, rf: *const Self, stride: usize) -> u32 {
        unsafe {
            if S {
                xav_importance16_s_x8(cur, stride, rf, stride)
            } else {
                xav_importance16_x8(cur, stride, rf, stride)
            }
        }
    }
}
