use crate::byte_range::ByteRange;

const OBU_SEQUENCE_HEADER: u8 = 1;
const OBU_FRAME_HEADER: u8 = 3;
const OBU_FRAME: u8 = 6;

// appends the chunk display-block ByteRanges (offsets into `buf`); returns the seq-header range
pub fn parse(buf: &[u8], blocks: &mut Vec<ByteRange>) -> Option<ByteRange> {
    let mut seq_header: Option<ByteRange> = None;
    let mut block_start = 0;
    let mut pos = 0;
    let len = buf.len();

    while pos < len {
        let obu_start = pos;
        let header = unsafe { *buf.get_unchecked(pos) };
        pos += 1;
        let obu_type = (header >> 3) & 0x0F;

        let Some((size, n)) = read_leb128(unsafe { buf.get_unchecked(pos..) }) else {
            break;
        };
        pos += n;
        let payload = pos;
        let next = pos.saturating_add(size);
        if next > len {
            break;
        }
        pos = next;

        match obu_type {
            // type-3 only show_existing; coded frames are type-6
            OBU_FRAME | OBU_FRAME_HEADER => {
                // a frame OBU carries >= 1 payload byte, `payload < next <= len`
                let b0 = unsafe { *buf.get_unchecked(payload) };
                // b0 bit7 = `show_existing_frame`, bit4 = `show_frame` (bit7=0 case);
                // display output (block boundary) if either set == `& 0x90`
                if b0 & 0x90 != 0 {
                    blocks.push(ByteRange {
                        offset: block_start,
                        len: pos - block_start,
                    });
                    block_start = pos;
                }
            }
            OBU_SEQUENCE_HEADER if seq_header.is_none() => {
                seq_header = Some(ByteRange {
                    offset: obu_start,
                    len: pos - obu_start,
                });
            }
            _ => {}
        }
    }

    seq_header
}

#[inline]
fn read_leb128(buf: &[u8]) -> Option<(usize, usize)> {
    let b0 = *buf.first()?;
    if b0 & 0x80 == 0 {
        return Some(((b0 & 0x7F) as usize, 1));
    }
    let mut result = u64::from(b0 & 0x7F);
    let mut i = 1;
    let max = buf.len().min(8);
    while i < max {
        let byte = unsafe { *buf.get_unchecked(i) };
        result |= u64::from(byte & 0x7F) << (i * 7);
        i += 1;
        if byte & 0x80 == 0 {
            return Some((result as usize, i));
        }
    }
    None
}
