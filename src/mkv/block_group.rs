use super::{
    crc32::{CRC_ELEMENT_LEN, write_crc_placeholder},
    ebml::{vint_encode, vint_size},
    element::{sint_size, uint_size, write_sint, write_uint},
};

const BLOCK_GROUP_ID: u8 = 0xA0;
const BLOCK_ID: u8 = 0xA1;
const BLOCK_FLAGS: u8 = 0x00;

pub struct BlockGroupParts {
    pub before_frame_len: usize,
    pub after_frame_len: usize,
    pub crc_offset: usize,
}

#[inline]
#[must_use]
pub const fn block_group_size(
    track: u64,
    frame_size: usize,
    is_keyframe: bool,
    relative_ts: i16,
    duration: u64,
) -> usize {
    let block_content = vint_size(track) + 3 + frame_size;
    let block_total = 1 + vint_size(block_content as u64) + block_content;
    let dur_total = 2 + uint_size(duration);
    let ref_block_total = if is_keyframe {
        0
    } else {
        2 + sint_size(-(relative_ts as i64))
    };
    let bg_content = CRC_ELEMENT_LEN + block_total + dur_total + ref_block_total;
    1 + vint_size(bg_content as u64) + bg_content
}

#[inline]
#[must_use]
pub fn build_block_group(
    out: &mut [u8],
    track: u64,
    frame_len: usize,
    relative_ts: i16,
    is_keyframe: bool,
    duration: u64,
) -> BlockGroupParts {
    let block_content = vint_size(track) + 3 + frame_len;
    let bh_n = 1 + vint_size(block_content as u64) + vint_size(track) + 3;
    let dur_total = 2 + uint_size(duration);
    let ref_block_total = if is_keyframe {
        0
    } else {
        2 + sint_size(-i64::from(relative_ts))
    };
    let after_frame_len = dur_total + ref_block_total;
    let bg_content = CRC_ELEMENT_LEN + bh_n + frame_len + after_frame_len;

    let mut n = 0;
    let crc_offset;
    let before_frame_len;
    unsafe {
        *out.get_unchecked_mut(n) = BLOCK_GROUP_ID;
        n += 1;
        n += vint_encode(bg_content as u64, out.get_unchecked_mut(n..));
        crc_offset = n + 2;
        n += write_crc_placeholder(out.get_unchecked_mut(n..));
        *out.get_unchecked_mut(n) = BLOCK_ID;
        n += 1;
        n += vint_encode(block_content as u64, out.get_unchecked_mut(n..));
        n += vint_encode(track, out.get_unchecked_mut(n..));
        out.get_unchecked_mut(n..n + 2)
            .copy_from_slice(&relative_ts.to_be_bytes());
        *out.get_unchecked_mut(n + 2) = BLOCK_FLAGS;
        n += 3;
        before_frame_len = n;

        // frame -> BlockDuration -> ReferenceBlock (pframes)
        let mut a = before_frame_len + frame_len;
        a += write_uint(0x9B, duration, out.get_unchecked_mut(a..));
        if !is_keyframe {
            _ = write_sint(0xFB, -i64::from(relative_ts), out.get_unchecked_mut(a..));
        }
    }

    BlockGroupParts {
        before_frame_len,
        after_frame_len,
        crc_offset,
    }
}
