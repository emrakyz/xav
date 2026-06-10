const POLYNOMIAL: u32 = 0xEDB8_8320;

const TABLES: [[u32; 256]; 8] = {
    let mut tables = [[0u32; 256]; 8];
    let mut i: u32 = 0;
    while i < 256 {
        let mut crc = i;
        let mut j = 0;
        while j < 8 {
            crc = (crc >> 1) ^ (POLYNOMIAL & 0u32.wrapping_sub(crc & 1));
            j += 1;
        }
        tables[0][i as usize] = crc;
        i += 1;
    }
    let mut n = 1;
    while n < 8 {
        let mut k = 0usize;
        while k < 256 {
            let prev = tables[n - 1][k];
            tables[n][k] = (prev >> 8) ^ tables[0][(prev & 0xFF) as usize];
            k += 1;
        }
        n += 1;
    }
    tables
};

const fn multmodp(a: u32, b: u32) -> u32 {
    let mut m: u32 = 1 << 31;
    let mut p: u32 = 0;
    let mut b = b;
    loop {
        if a & m != 0 {
            p ^= b;
            if a & (m - 1) == 0 {
                break;
            }
        }
        m >>= 1;
        b = if b & 1 != 0 { (b >> 1) ^ POLYNOMIAL } else { b >> 1 };
    }
    p
}

const X2N_TABLE: [u32; 32] = {
    let mut t = [0u32; 32];
    let mut p: u32 = 0x4000_0000;
    let mut k = 0;
    while k < 32 {
        t[k] = p;
        p = multmodp(p, p);
        k += 1;
    }
    t
};

#[inline]
pub fn update(mut crc: u32, data: &[u8]) -> u32 {
    let mut chunks = data.chunks_exact(8);
    for chunk in &mut chunks {
        let bytes: [u8; 8] = unsafe { *chunk.as_ptr().cast::<[u8; 8]>() };
        let word = u64::from_le_bytes(bytes);
        let one = (word as u32) ^ crc;
        let two = (word >> 32) as u32;
        crc = TABLES[0][((two >> 24) & 0xFF) as usize]
            ^ TABLES[1][((two >> 16) & 0xFF) as usize]
            ^ TABLES[2][((two >> 8) & 0xFF) as usize]
            ^ TABLES[3][(two & 0xFF) as usize]
            ^ TABLES[4][((one >> 24) & 0xFF) as usize]
            ^ TABLES[5][((one >> 16) & 0xFF) as usize]
            ^ TABLES[6][((one >> 8) & 0xFF) as usize]
            ^ TABLES[7][(one & 0xFF) as usize];
    }
    for &b in chunks.remainder() {
        crc = (crc >> 8) ^ TABLES[0][((crc & 0xFF) ^ u32::from(b)) as usize];
    }
    crc
}

#[inline]
pub unsafe fn copy_nt(mut crc: u32, src: *const u8, dst: *mut u8, len: usize) -> u32 {
    unsafe {
        let chunks = len / 8;
        for i in 0..chunks {
            let bytes = *src.add(i * 8).cast::<[u8; 8]>();
            let word = u64::from_le_bytes(bytes);
            #[cfg(target_arch = "x86_64")]
            std::arch::x86_64::_mm_stream_si64(dst.add(i * 8).cast::<i64>(), word as i64);
            #[cfg(not(target_arch = "x86_64"))]
            {
                *dst.add(i * 8).cast::<[u8; 8]>() = bytes;
            }
            let one = (word as u32) ^ crc;
            let two = (word >> 32) as u32;
            crc = TABLES[0][((two >> 24) & 0xFF) as usize]
                ^ TABLES[1][((two >> 16) & 0xFF) as usize]
                ^ TABLES[2][((two >> 8) & 0xFF) as usize]
                ^ TABLES[3][(two & 0xFF) as usize]
                ^ TABLES[4][((one >> 24) & 0xFF) as usize]
                ^ TABLES[5][((one >> 16) & 0xFF) as usize]
                ^ TABLES[6][((one >> 8) & 0xFF) as usize]
                ^ TABLES[7][(one & 0xFF) as usize];
        }
        let mut i = chunks * 8;
        while i < len {
            let b = *src.add(i);
            *dst.add(i) = b;
            crc = (crc >> 8) ^ TABLES[0][((crc & 0xFF) ^ u32::from(b)) as usize];
            i += 1;
        }
        crc
    }
}

#[inline]
pub fn combine(crc1: u32, crc2: u32, len2: u64) -> u32 {
    if len2 == 0 {
        return crc1;
    }
    let mut p: u32 = 0x8000_0000;
    let mut n = len2;
    let mut k: u32 = 3;
    while n != 0 {
        if n & 1 != 0 {
            p = multmodp(X2N_TABLE[(k & 31) as usize], p);
        }
        n >>= 1;
        k = k.wrapping_add(1);
    }
    multmodp(p, crc1) ^ crc2
}
