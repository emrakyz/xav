pub fn find_start_code(raw: &[u8], from: usize) -> Option<usize> {
    let len = raw.len();
    if from + 3 > len {
        return None;
    }
    let end = len - 2;
    let mut i = from;
    while i < end {
        if unsafe {
            *raw.get_unchecked(i) == 0
                && *raw.get_unchecked(i + 1) == 0
                && *raw.get_unchecked(i + 2) == 1
        } {
            return Some(i);
        }
        i += 1;
    }
    None
}
