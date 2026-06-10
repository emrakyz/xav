#[derive(Clone, Copy)]
pub struct ByteRange {
    pub offset: usize,
    pub len: usize,
}

impl ByteRange {
    #[inline]
    #[must_use]
    pub fn slice(self, src: &[u8]) -> &[u8] {
        // every ByteRange is parsed from its source, [offset, offset+len) always in bounds
        unsafe { src.get_unchecked(self.offset..self.offset + self.len) }
    }
}
