pub const CRC_ID: u8 = 0xBF;
pub const CRC_ELEMENT_LEN: usize = 6;
const CRC_SIZE_VINT: u8 = 0x84;

const INIT: u32 = 0xFFFF_FFFF;
const FINAL_XOR: u32 = 0xFFFF_FFFF;

#[cfg(target_feature = "avx512bw")]
include!("avx512.rs");
#[cfg(all(not(target_feature = "avx512bw"), target_feature = "vpclmulqdq"))]
include!("avx2_vpclmul.rs");
#[cfg(all(
    not(target_feature = "avx512bw"),
    not(target_feature = "vpclmulqdq"),
    target_feature = "pclmulqdq",
    target_feature = "avx2"
))]
include!("avx2_pclmul.rs");
#[cfg(all(
    not(target_feature = "avx512bw"),
    not(target_feature = "vpclmulqdq"),
    not(all(target_feature = "pclmulqdq", target_feature = "avx2"))
))]
include!("scalar.rs");

#[inline]
#[must_use]
pub fn write_crc_placeholder(out: &mut [u8]) -> usize {
    unsafe {
        *out.get_unchecked_mut(0) = CRC_ID;
        *out.get_unchecked_mut(1) = CRC_SIZE_VINT;
        out.get_unchecked_mut(2..6).fill(0);
    }
    CRC_ELEMENT_LEN
}

#[inline]
pub fn patch_crc(out: &mut [u8], crc_value_offset: usize, value: u32) {
    unsafe {
        out.get_unchecked_mut(crc_value_offset..crc_value_offset + 4)
            .copy_from_slice(&value.to_le_bytes());
    }
}

#[inline]
#[must_use]
pub fn crc32_combine(crc1: u32, crc2: u32, len2: u64) -> u32 {
    combine(crc1, crc2, len2)
}

#[derive(Clone, Copy)]
pub struct Crc32 {
    state: u32,
}

impl Crc32 {
    #[inline]
    #[must_use]
    pub const fn new() -> Self {
        Self { state: INIT }
    }

    #[inline]
    pub fn update(&mut self, data: &[u8]) {
        self.state = update(self.state, data);
    }

    #[inline]
    pub unsafe fn copy_nt(&mut self, src: *const u8, dst: *mut u8, len: usize) {
        self.state = unsafe { copy_nt(self.state, src, dst, len) };
    }

    #[inline]
    #[must_use]
    pub const fn finalize(self) -> u32 {
        self.state ^ FINAL_XOR
    }
}

impl Default for Crc32 {
    #[inline]
    fn default() -> Self {
        Self::new()
    }
}
