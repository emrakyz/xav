use super::{
    crc32::{CRC_ELEMENT_LEN, Crc32, patch_crc, write_crc_placeholder},
    ebml::vint_encode,
    element::{bytes_elem_size, master_size, write_bytes, write_id, write_uint},
};

const INFO_ID: u32 = 0x1549_A966;
const TITLE_ID: u32 = 0x7BA9;
const APP: &[u8] = concat!("xav ", env!("CARGO_PKG_VERSION")).as_bytes();
const FIXED_CONTENT_SIZE: usize = 7 + 19 + 11 + 11 + 2 * (3 + APP.len());

#[inline]
#[must_use]
pub const fn info_size(title_len: usize) -> usize {
    let content = CRC_ELEMENT_LEN + FIXED_CONTENT_SIZE + bytes_elem_size(TITLE_ID, title_len);
    master_size(INFO_ID, content)
}

#[must_use]
pub fn write_info(
    out: &mut [u8],
    segment_uid: &[u8; 16],
    date_utc_ns: i64,
    duration_ms: f64,
    title: &str,
) -> usize {
    let content_size =
        CRC_ELEMENT_LEN + FIXED_CONTENT_SIZE + bytes_elem_size(TITLE_ID, title.len());

    let mut n = write_id(INFO_ID, out);
    let crc_offset;
    let children_start;
    unsafe {
        n += vint_encode(content_size as u64, out.get_unchecked_mut(n..));
        crc_offset = n + 2;
        n += write_crc_placeholder(out.get_unchecked_mut(n..));
        children_start = n;
        n += write_uint(0x002A_D7B1, 1_000_000, out.get_unchecked_mut(n..)); // TimestampScale
        n += write_bytes(0x73A4, segment_uid, out.get_unchecked_mut(n..)); // SegmentUID
        n += write_bytes(
            0x4461,
            &date_utc_ns.to_be_bytes(),
            out.get_unchecked_mut(n..),
        ); // DateUTC
        n += write_bytes(
            0x4489,
            &duration_ms.to_be_bytes(),
            out.get_unchecked_mut(n..),
        ); // Duration
        n += write_bytes(TITLE_ID, title.as_bytes(), out.get_unchecked_mut(n..)); // Title
        n += write_bytes(0x4D80, APP, out.get_unchecked_mut(n..)); // MuxingApp
        n += write_bytes(0x5741, APP, out.get_unchecked_mut(n..)); // WritingApp

        let mut crc = Crc32::new();
        crc.update(out.get_unchecked(children_start..n));
        patch_crc(out, crc_offset, crc.finalize());
    }
    n
}
