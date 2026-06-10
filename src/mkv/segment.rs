use super::{
    ebml::{vint_encode, vint_size},
    element::write_id,
};

const SEGMENT_ID: u32 = 0x1853_8067;

#[inline]
#[must_use]
pub const fn segment_size(content_size: usize) -> usize {
    4 + vint_size(content_size as u64) + content_size
}

#[must_use]
pub fn write_segment_header(out: &mut [u8], content_size: usize) -> usize {
    let n = write_id(SEGMENT_ID, out);
    n + vint_encode(content_size as u64, unsafe { out.get_unchecked_mut(n..) })
}
