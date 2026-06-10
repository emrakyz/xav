unsafe extern "C" {
    fn xav_find_start_code(raw: *const u8, len: usize, from: usize) -> usize;
}

pub fn find_start_code(raw: &[u8], from: usize) -> Option<usize> {
    let len = raw.len();
    let r = unsafe { xav_find_start_code(raw.as_ptr(), len, from) };
    (r < len).then_some(r)
}
