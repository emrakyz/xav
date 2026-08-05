unsafe extern "C" {
    fn xav_scd_feed(dc: *mut VidDecoder, rg: *const u8, tt: usize, ln: usize, pb: *mut u8);
    fn xav_scd_feed_hw(dc: *mut VidDecoder, rg: *const u8, tt: usize, ln: usize, pb: *mut u8);
    fn xav_scd_run(rg: *const u8, dm: u64, tt: usize, kf: *mut usize, wt: *mut f32,
                   ot: *mut u8) -> usize;
    fn xav_scd_run16(rg: *const u8, dm: u64, tt: usize, kf: *mut usize, wt: *mut f32,
                     ot: *mut u8) -> usize;
    fn xav_scd_run16s(rg: *const u8, dm: u64, tt: usize, kf: *mut usize, wt: *mut f32,
                      ot: *mut u8) -> usize;
}
