const SATD_BATCH: usize = 1;
const IMP_BATCH: usize = 1;

impl Pixel for u8 {
    #[inline(always)]
    unsafe fn satd_dc<const S: bool>(src: *const Self, stride: usize) -> u32 {
        satd8x8_dc_blk::<Self, S>(src, stride, 128)
    }
    #[inline(always)]
    unsafe fn satd<const S: bool>(cur: *const Self, rf: *const Self, stride: usize) -> u32 {
        satd8x8_blk::<Self, S>(cur, stride, rf, stride)
    }
    #[inline(always)]
    unsafe fn imp<const S: bool>(cur: *const Self, rf: *const Self, stride: usize) -> u32 {
        let cs = sum8x8_blk::<Self, S>(cur, stride);
        let rs = sum8x8_blk::<Self, S>(rf, stride);
        (((cs + 32) >> 6) - ((rs + 32) >> 6)).unsigned_abs()
    }
}

impl Pixel for u16 {
    #[inline(always)]
    unsafe fn satd_dc<const S: bool>(src: *const Self, stride: usize) -> u32 {
        satd8x8_dc_blk::<Self, S>(src, stride, 512)
    }
    #[inline(always)]
    unsafe fn satd<const S: bool>(cur: *const Self, rf: *const Self, stride: usize) -> u32 {
        satd8x8_blk::<Self, S>(cur, stride, rf, stride)
    }
    #[inline(always)]
    unsafe fn imp<const S: bool>(cur: *const Self, rf: *const Self, stride: usize) -> u32 {
        let cs = sum8x8_blk::<Self, S>(cur, stride);
        let rs = sum8x8_blk::<Self, S>(rf, stride);
        (((cs + 32) >> 6) - ((rs + 32) >> 6)).unsigned_abs()
    }
}
