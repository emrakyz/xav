#[inline]
pub const fn vint_size(v: u64) -> usize {
    let bits = 64 - (v + 1).leading_zeros() as usize;
    bits.div_ceil(7)
}

// `out` is pre-sized for the element
#[inline]
pub fn vint_encode(v: u64, out: &mut [u8]) -> usize {
    let n = vint_size(v);
    let be = ((1u64 << (7 * n)) | v).to_be_bytes();
    unsafe {
        out.get_unchecked_mut(..n)
            .copy_from_slice(be.get_unchecked(8 - n..));
    };
    n
}
