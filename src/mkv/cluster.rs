use super::{
    crc32::{CRC_ELEMENT_LEN, write_crc_placeholder},
    ebml::{vint_encode, vint_size},
    element::{uint_size, write_id, write_uint, write_uint_width},
};

const CLUSTER_ID: u32 = 0x1F43_B675;
const TIMESTAMP_ID: u32 = 0xE7;
const POSITION_ID: u32 = 0xA7;
const PREV_SIZE_ID: u32 = 0xAB;

pub struct ClusterHeader {
    pub len: usize,
    pub crc_offset: usize,
    pub timestamp_start: usize,
}

// pos_width: uniform position value width (= uint_size(file size)); prev_size: predecessor cluster
// octets, 0 on the first cluster -> PrevSize omitted
#[inline]
const fn cluster_content_size(ts: u64, bg_total: usize, pos_width: usize, prev_size: u64) -> usize {
    let prev = if prev_size > 0 {
        2 + uint_size(prev_size)
    } else {
        0
    };
    CRC_ELEMENT_LEN + 2 + uint_size(ts) + 2 + pos_width + prev + bg_total
}

#[inline]
#[must_use]
pub const fn cluster_size(ts: u64, bg_total: usize, pos_width: usize, prev_size: u64) -> usize {
    let content = cluster_content_size(ts, bg_total, pos_width, prev_size);
    4 + vint_size(content as u64) + content
}

#[must_use]
pub fn build_cluster_header(
    out: &mut [u8; 48],
    ts: u64,
    bg_total: usize,
    position: u64,
    pos_width: usize,
    prev_size: u64,
) -> ClusterHeader {
    let content = cluster_content_size(ts, bg_total, pos_width, prev_size);
    let mut n = write_id(CLUSTER_ID, out);
    let crc_offset;
    let timestamp_start;
    unsafe {
        n += vint_encode(content as u64, out.get_unchecked_mut(n..));
        crc_offset = n + 2;
        n += write_crc_placeholder(out.get_unchecked_mut(n..));
        timestamp_start = n;
        n += write_uint(TIMESTAMP_ID, ts, out.get_unchecked_mut(n..));
        n += write_uint_width(POSITION_ID, position, pos_width, out.get_unchecked_mut(n..));
        if prev_size > 0 {
            n += write_uint(PREV_SIZE_ID, prev_size, out.get_unchecked_mut(n..));
        }
    }
    ClusterHeader {
        len: n,
        crc_offset,
        timestamp_start,
    }
}
