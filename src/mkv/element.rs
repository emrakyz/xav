use super::ebml::{vint_encode, vint_size};

// element ID width, 1..=4
#[inline]
pub const fn id_size(id: u32) -> usize {
    (32 - id.leading_zeros()).div_ceil(8) as usize
}

// [id][len][value]; vint_size(uint_size(v)) == 1 since uint_size(v) <= 8
#[inline]
pub const fn uint_elem_size(id: u32, v: u64) -> usize {
    id_size(id) + 1 + uint_size(v)
}

// [id][vint(len)][bytes]
#[inline]
pub const fn bytes_elem_size(id: u32, len: usize) -> usize {
    id_size(id) + vint_size(len as u64) + len
}

// [id][vint(content)][content]
#[inline]
pub const fn master_size(id: u32, content: usize) -> usize {
    id_size(id) + vint_size(content as u64) + content
}

// `out` is pre-sized by the caller; stores unchecked
#[inline]
#[must_use]
pub fn write_id(id: u32, out: &mut [u8]) -> usize {
    let n = id_size(id);
    let be = id.to_be_bytes();
    unsafe {
        out.get_unchecked_mut(..n)
            .copy_from_slice(be.get_unchecked(4 - n..));
    };
    n
}

#[inline]
pub const fn uint_size(v: u64) -> usize {
    // a 0-valued uint occupies one byte (0x00), never a 0-length element
    if v == 0 {
        return 1;
    }
    let bits = 64 - v.leading_zeros() as usize;
    bits.div_ceil(8)
}

#[inline]
#[must_use]
pub fn write_bytes(id: u32, bytes: &[u8], out: &mut [u8]) -> usize {
    let mut n = write_id(id, out);
    n += vint_encode(bytes.len() as u64, unsafe { out.get_unchecked_mut(n..) });
    unsafe {
        out.get_unchecked_mut(n..n + bytes.len())
            .copy_from_slice(bytes);
    };
    n + bytes.len()
}

#[inline]
#[must_use]
pub fn write_uint(id: u32, value: u64, out: &mut [u8]) -> usize {
    let n = uint_size(value);
    let be = value.to_be_bytes();
    write_bytes(id, unsafe { be.get_unchecked(8 - n..) }, out)
}

// fixed-w uint (zero padded); for elements width is pinned across file
#[inline]
#[must_use]
pub fn write_uint_width(id: u32, value: u64, width: usize, out: &mut [u8]) -> usize {
    let be = value.to_be_bytes();
    write_bytes(id, unsafe { be.get_unchecked(8 - width..) }, out)
}

#[inline]
pub const fn sint_size(v: i64) -> usize {
    if v == 0 {
        return 0;
    }
    let magnitude = if v >= 0 { v as u64 } else { !(v as u64) };
    let bits = 64 - magnitude.leading_zeros() as usize;
    (bits + 1).div_ceil(8)
}

#[inline]
#[must_use]
pub fn write_sint(id: u32, value: i64, out: &mut [u8]) -> usize {
    let n = sint_size(value);
    let be = value.to_be_bytes();
    write_bytes(id, unsafe { be.get_unchecked(8 - n..) }, out)
}
