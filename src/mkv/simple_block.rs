use super::ebml::{vint_encode, vint_size};

const SIMPLE_BLOCK_ID: u8 = 0xA3;
const KEYFRAME: u8 = 0x80;

#[inline]
#[must_use]
pub const fn simple_block_size(track: u64, data_len: usize) -> usize {
    let content = vint_size(track) + 3 + data_len; // track VINT + i16 ts + flags + data
    1 + vint_size(content as u64) + content
}

#[inline]
#[must_use]
pub fn build_simple_block(out: &mut [u8], track: u64, relative_ts: i16, data_len: usize) -> usize {
    let content = vint_size(track) + 3 + data_len;
    let mut n = 0;
    unsafe {
        *out.get_unchecked_mut(n) = SIMPLE_BLOCK_ID;
        n += 1;
        n += vint_encode(content as u64, out.get_unchecked_mut(n..));
        n += vint_encode(track, out.get_unchecked_mut(n..));
        out.get_unchecked_mut(n..n + 2)
            .copy_from_slice(&relative_ts.to_be_bytes());
        *out.get_unchecked_mut(n + 2) = KEYFRAME; // audio packets are all keyframes
    }
    n + 3
}
