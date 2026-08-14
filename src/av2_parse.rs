#[cfg(target_os = "linux")]
use alloc::vec::Vec;
use core::hint::cold_path;

use crate::{byte_range::ByteRange, obu_parse::read_leb128};

const OBU_TEMPORAL_DELIMITER: u8 = 2;

const VCL: u32 = 0x0028_7CF0;

const TD_LEN: usize = 2;

pub fn parse(buf: &[u8], blocks: &mut Vec<ByteRange>) {
    let len = buf.len();
    let mut block_start = TD_LEN.min(len);
    let mut pos = block_start;

    while pos < len {
        let obu_start = pos;
        let Some((size, n)) = read_leb128(unsafe { buf.get_unchecked(pos..) }) else {
            cold_path();
            break;
        };
        let header = obu_start + n;
        // one compare rejects truncated OBU & obu_size < 1; would leave the
        // header byte oob; `read_leb128` succeeded, `header <= len`
        if size.wrapping_sub(1) >= len - header {
            cold_path();
            break;
        }
        pos = header + size;
        // obu_extension_flag(1) | obu_type(5) | obu_tlayer_id(2)
        if (unsafe { *buf.get_unchecked(header) } >> 2) & 0x1F == OBU_TEMPORAL_DELIMITER {
            blocks.push(ByteRange {
                offset: block_start,
                len: obu_start - block_start,
            });
            block_start = pos;
        }
    }

    blocks.push(ByteRange {
        offset: block_start,
        len: pos - block_start,
    });
}

// AV2 has no codec-private: decoder config is the sequence header
// every chunk carries the same prefix; muxer reads this off the first one
#[cold]
#[inline(never)]
pub fn config(buf: &[u8], end: usize) -> Option<ByteRange> {
    let mut pos = TD_LEN;
    while pos < end {
        let (size, n) = unsafe { read_leb128(buf.get_unchecked(pos..end)).unwrap_unchecked() };
        let header = pos + n;
        if (VCL >> ((unsafe { *buf.get_unchecked(header) } >> 2) & 0x1F)) & 1 != 0 {
            return Some(ByteRange {
                offset: TD_LEN,
                len: pos - TD_LEN,
            });
        }
        pos = header + size;
    }
    None
}
