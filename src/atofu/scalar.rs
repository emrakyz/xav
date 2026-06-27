const WIDTH: usize = 1;

#[inline(always)]
unsafe fn atou_batch(base: *const u8, off: *const u16, n: usize, out: *mut u64) {
    for i in 0..n {
        let p = unsafe { base.add(*off.add(i) as usize) };
        let mut j = 0;
        let mut m = 0u64;
        loop {
            let d = unsafe { *p.add(j) }.wrapping_sub(b'0');
            if d > 9 {
                break;
            }
            m = m * 10 + d as u64;
            j += 1;
        }
        unsafe { out.add(i).write(m) };
    }
}

#[inline(always)]
unsafe fn atof4_batch(base: *const u8, off: *const u16, n: usize, out: *mut f32) {
    for i in 0..n {
        let p = unsafe { base.add(*off.add(i) as usize) };
        let neg = unsafe { *p } == b'-';
        let mut j = neg as usize;
        let mut m = 0u32;
        loop {
            let c = unsafe { *p.add(j) };
            if c == b'.' {
                j += 1;
                continue;
            }
            let d = c.wrapping_sub(b'0');
            if d > 9 {
                break;
            }
            m = m * 10 + d as u32;
            j += 1;
        }
        let v = m as f32 * 1e-4;
        unsafe { out.add(i).write(if neg { -v } else { v }) };
    }
}

#[inline(always)]
unsafe fn atof2_batch(base: *const u8, off: *const u16, n: usize, out: *mut f32) {
    for i in 0..n {
        let p = unsafe { base.add(*off.add(i) as usize) };
        let mut j = 0;
        let mut m = 0u32;
        loop {
            let c = unsafe { *p.add(j) };
            if c == b'.' {
                j += 1;
                continue;
            }
            let d = c.wrapping_sub(b'0');
            if d > 9 {
                break;
            }
            m = m * 10 + d as u32;
            j += 1;
        }
        unsafe { out.add(i).write(m as f32 * 1e-2) };
    }
}

#[inline(always)]
unsafe fn scan(base: *const u8, len: usize, out_num: *mut u16, out_nl: *mut u16) -> u64 {
    let mut nc = 0usize;
    let mut nl = 0usize;
    let mut i = 1usize;
    while i < len {
        let c = unsafe { *base.add(i) };
        let p = unsafe { *base.add(i - 1) };
        if (c.wrapping_sub(b'0') <= 9 || c == b'-') && (p == b':' || p == b'[' || p == b',') {
            unsafe { *out_num.add(nc) = i as u16 };
            nc += 1;
        }
        if c == b'\n' {
            unsafe { *out_nl.add(nl) = i as u16 };
            nl += 1;
        }
        i += 1;
    }
    ((nl as u64) << 32) | nc as u64
}
