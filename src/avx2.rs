pub const SHIFT_CHUNK: usize = 160;
pub const PACK_CHUNK: usize = 192;
pub const UNPACK_CHUNK: usize = 120;

macro_rules! pack_10b_asm {
    ($($s0:literal, $s1:literal, $d0:literal, $d1:literal);+ @ $src:expr, $dst:expr, $end:expr, $mult:expr, $mask20:expr, $shuf:expr) => {
        core::arch::asm!(
            "2:",
            $(
                concat!("vpmaddwd {a}, {mult}, [{s} + ", $s0, "]"),
                concat!("vpmaddwd {c}, {mult}, [{s} + ", $s1, "]"),
                "vpsrlq {b}, {a}, 12",
                "vpsrlq {e}, {c}, 12",
                "vpand {a}, {a}, {mask20}",
                "vpand {c}, {c}, {mask20}",
                "vpandn {b}, {mask20}, {b}",
                "vpandn {e}, {mask20}, {e}",
                "vpor {a}, {a}, {b}",
                "vpor {c}, {c}, {e}",
                "vpshufb {a}, {a}, {shuf}",
                "vpshufb {c}, {c}, {shuf}",
                concat!("vmovq [{d} + ", $d0, "], {a:x}"),
                concat!("vpextrw [{d} + ", $d0, " + 8], {a:x}, 4"),
                "vextracti128 {b:x}, {a}, 1",
                concat!("vmovq [{d} + ", $d0, " + 10], {b:x}"),
                concat!("vpextrw [{d} + ", $d0, " + 18], {b:x}, 4"),
                concat!("vmovq [{d} + ", $d1, "], {c:x}"),
                concat!("vpextrw [{d} + ", $d1, " + 8], {c:x}, 4"),
                "vextracti128 {e:x}, {c}, 1",
                concat!("vmovq [{d} + ", $d1, " + 10], {e:x}"),
                concat!("vpextrw [{d} + ", $d1, " + 18], {e:x}, 4"),
            )+
            "add {s}, 192",
            "add {d}, 120",
            "cmp {s}, {end}",
            "jne 2b",
            s = inout(reg) $src => _,
            d = inout(reg) $dst => _,
            end = in(reg) $end,
            mult = in(ymm_reg) $mult,
            mask20 = in(ymm_reg) $mask20,
            shuf = in(ymm_reg) $shuf,
            a = out(ymm_reg) _,
            b = out(ymm_reg) _,
            c = out(ymm_reg) _,
            e = out(ymm_reg) _,
            options(nostack),
        )
    };
}

#[inline]
pub fn pack_10b(input: &[u8], output: &mut [u8]) {
    use std::arch::x86_64::{_mm256_set_epi8, _mm256_set1_epi32, _mm256_set1_epi64x};
    let iters = input.len() / 192;
    let src = input.as_ptr();
    let dst = output.as_mut_ptr();
    unsafe {
        let mult = _mm256_set1_epi32(0x0400_0001u32 as i32);
        let mask20 = _mm256_set1_epi64x(0xFFFFF);
        let shuf = _mm256_set_epi8(
            -1, -1, -1, -1, -1, -1, 12, 11, 10, 9, 8, 4, 3, 2, 1, 0, -1, -1, -1, -1, -1, -1, 12,
            11, 10, 9, 8, 4, 3, 2, 1, 0,
        );
        let end = src.add(iters * 192);
        pack_10b_asm!(
            0, 32, 0, 20;
            64, 96, 40, 60;
            128, 160, 80, 100
            @ src, dst, end, mult, mask20, shuf
        );
    }
}

macro_rules! unpack_10b_asm {
    ($($s0:literal, $s1:literal, $d0:literal, $d1:literal);+ @ $src:expr, $dst:expr, $end:expr, $shuf:expr, $m0:expr, $m1:expr, $m2:expr, $m3:expr) => {
        core::arch::asm!(
            "2:",
            $(
                concat!("vmovdqu {a:x}, [{s} + ", $s0, "]"),
                concat!("vmovdqu {f:x}, [{s} + ", $s1, "]"),
                concat!("vinserti128 {a}, {a}, [{s} + ", $s0, " + 10], 1"),
                concat!("vinserti128 {f}, {f}, [{s} + ", $s1, " + 10], 1"),
                "vpshufb {a}, {a}, {shuf}",
                "vpshufb {f}, {f}, {shuf}",
                "vpsllq {b}, {a}, 6",
                "vpsllq {c}, {a}, 12",
                "vpsllq {e}, {a}, 18",
                "vpand {a}, {a}, {m0}",
                "vpand {b}, {b}, {m1}",
                "vpand {c}, {c}, {m2}",
                "vpand {e}, {e}, {m3}",
                "vpor {a}, {a}, {b}",
                "vpor {c}, {c}, {e}",
                "vpor {a}, {a}, {c}",
                concat!("vmovdqu [{d} + ", $d0, "], {a}"),
                "vpsllq {b}, {f}, 6",
                "vpsllq {c}, {f}, 12",
                "vpsllq {e}, {f}, 18",
                "vpand {f}, {f}, {m0}",
                "vpand {b}, {b}, {m1}",
                "vpand {c}, {c}, {m2}",
                "vpand {e}, {e}, {m3}",
                "vpor {f}, {f}, {b}",
                "vpor {c}, {c}, {e}",
                "vpor {f}, {f}, {c}",
                concat!("vmovdqu [{d} + ", $d1, "], {f}"),
            )+
            "add {s}, 120",
            "add {d}, 192",
            "cmp {s}, {end}",
            "jne 2b",
            s = inout(reg) $src => _,
            d = inout(reg) $dst => _,
            end = in(reg) $end,
            shuf = in(ymm_reg) $shuf,
            m0 = in(ymm_reg) $m0,
            m1 = in(ymm_reg) $m1,
            m2 = in(ymm_reg) $m2,
            m3 = in(ymm_reg) $m3,
            a = out(ymm_reg) _,
            b = out(ymm_reg) _,
            c = out(ymm_reg) _,
            e = out(ymm_reg) _,
            f = out(ymm_reg) _,
            options(nostack),
        )
    };
}

#[inline]
pub fn unpack_10b(input: &[u8], output: &mut [u8]) {
    use std::arch::x86_64::{_mm256_set_epi8, _mm256_set1_epi64x};
    let iters = input.len() / 120;
    let src = input.as_ptr();
    let dst = output.as_mut_ptr();
    unsafe {
        let shuf = _mm256_set_epi8(
            -1, -1, -1, 9, 8, 7, 6, 5, -1, -1, -1, 4, 3, 2, 1, 0, -1, -1, -1, 9, 8, 7, 6, 5, -1,
            -1, -1, 4, 3, 2, 1, 0,
        );
        let m0 = _mm256_set1_epi64x(0x3FF);
        let m1 = _mm256_set1_epi64x(0x3FF << 16);
        let m2 = _mm256_set1_epi64x(0x3FFi64 << 32);
        let m3 = _mm256_set1_epi64x(0x3FFi64 << 48);
        let end = src.add(iters * 120);
        unpack_10b_asm!(
            0, 20, 0, 32;
            40, 60, 64, 96;
            80, 100, 128, 160
            @ src, dst, end, shuf, m0, m1, m2, m3
        );
    }
}

macro_rules! conv_10b_asm {
    ($($s:literal, $d:literal);+ @ $src:expr, $dst:expr, $stride:literal, $end:expr) => {
        core::arch::asm!(
            "xor {o:e}, {o:e}",
            "2:",
            $(
                concat!("vpmovzxbw {a}, [{s} + {o} + ", $s, "]"),
                "vpsllw {a}, {a}, 2",
                concat!("vmovdqu [{d} + {o}*2 + ", $d, "], {a}"),
            )+
            concat!("add {o}, ", $stride),
            "cmp {o}, {end}",
            "jne 2b",
            s = in(reg) $src,
            d = in(reg) $dst,
            end = in(reg) $end,
            o = out(reg) _,
            a = out(ymm_reg) _,
            options(nostack),
        )
    };
}

#[inline]
pub fn conv_to_10b(input: &[u8], output: &mut [u8]) {
    let iters = input.len() / 160;
    let src = input.as_ptr();
    let dst = output.as_mut_ptr();
    let end = iters * 160;
    unsafe {
        conv_10b_asm!(
            0, 0; 16, 32; 32, 64; 48, 96; 64, 128;
            80, 160; 96, 192; 112, 224; 128, 256; 144, 288
            @ src, dst, 160, end
        );
    }
}

macro_rules! deint_p010_asm {
    ($($si:literal, $do:literal);+ @ $src:expr, $ud:expr, $vd:expr, $shuf:expr, $stride:literal, $end:expr) => {
        core::arch::asm!(
            "xor {o:e}, {o:e}",
            "2:",
            $(
                concat!("vmovdqu {a}, [{s} + {o}*2 + ", $si, "]"),
                concat!("vmovdqu {b}, [{s} + {o}*2 + ", $si, " + 32]"),
                "vpsrlw {a}, {a}, 6",
                "vpsrlw {b}, {b}, 6",
                "vpshufb {a}, {a}, {shuf}",
                "vpshufb {b}, {b}, {shuf}",
                "vpunpcklqdq {u}, {a}, {b}",
                "vpunpckhqdq {a}, {a}, {b}",
                concat!("vpermq {u}, {u}, 0xD8"),
                concat!("vpermq {a}, {a}, 0xD8"),
                concat!("vmovdqu [{ud} + {o} + ", $do, "], {u}"),
                concat!("vmovdqu [{vd} + {o} + ", $do, "], {a}"),
            )+
            concat!("add {o}, ", $stride),
            "cmp {o}, {end}",
            "jne 2b",
            s = in(reg) $src,
            ud = in(reg) $ud,
            vd = in(reg) $vd,
            end = in(reg) $end,
            o = out(reg) _,
            shuf = in(ymm_reg) $shuf,
            a = out(ymm_reg) _,
            b = out(ymm_reg) _,
            u = out(ymm_reg) _,
            options(nostack),
        )
    };
}

#[inline]
pub fn deint_p010(src: &[u16], u_dst: &mut [u16], v_dst: &mut [u16]) {
    use std::arch::x86_64::_mm256_set_epi8;
    let iters = u_dst.len() / 160;
    let sb = src.as_ptr().cast::<u8>();
    let ub = u_dst.as_mut_ptr().cast::<u8>();
    let vb = v_dst.as_mut_ptr().cast::<u8>();
    let end = iters * 320;
    unsafe {
        let shuf = _mm256_set_epi8(
            15, 14, 11, 10, 7, 6, 3, 2, 13, 12, 9, 8, 5, 4, 1, 0, 15, 14, 11, 10, 7, 6, 3, 2, 13,
            12, 9, 8, 5, 4, 1, 0,
        );
        deint_p010_asm!(
            0, 0; 64, 32; 128, 64; 192, 96; 256, 128;
            320, 160; 384, 192; 448, 224; 512, 256; 576, 288
            @ sb, ub, vb, shuf, 320, end
        );
    }
}

macro_rules! deint_nv12_asm {
    ($($s:literal, $d:literal);+ @ $src:expr, $ud:expr, $vd:expr, $mask:expr, $stride:literal, $end:expr) => {
        core::arch::asm!(
            "xor {o:e}, {o:e}",
            "2:",
            $(
                concat!("vmovdqu {a}, [{s} + {o}*2 + ", $s, "]"),
                concat!("vmovdqu {b}, [{s} + {o}*2 + ", $s, " + 32]"),
                "vpand {au}, {a}, {m}",
                "vpsrlw {a}, {a}, 8",
                "vpand {bu}, {b}, {m}",
                "vpsrlw {b}, {b}, 8",
                "vpackuswb {au}, {au}, {bu}",
                "vpackuswb {a}, {a}, {b}",
                concat!("vpermq {au}, {au}, 0xD8"),
                concat!("vpermq {a}, {a}, 0xD8"),
                concat!("vmovdqu [{ud} + {o} + ", $d, "], {au}"),
                concat!("vmovdqu [{vd} + {o} + ", $d, "], {a}"),
            )+
            concat!("add {o}, ", $stride),
            "cmp {o}, {end}",
            "jne 2b",
            s = in(reg) $src,
            ud = in(reg) $ud,
            vd = in(reg) $vd,
            end = in(reg) $end,
            o = out(reg) _,
            m = in(ymm_reg) $mask,
            a = out(ymm_reg) _,
            b = out(ymm_reg) _,
            au = out(ymm_reg) _,
            bu = out(ymm_reg) _,
            options(nostack),
        )
    };
}

#[inline]
pub fn deint_nv12(src: &[u8], u_dst: &mut [u8], v_dst: &mut [u8]) {
    use std::arch::x86_64::_mm256_set1_epi16;
    let iters = u_dst.len() / 320;
    let end = iters * 320;
    unsafe {
        let mask = _mm256_set1_epi16(0x00FF);
        deint_nv12_asm!(
            0, 0; 64, 32; 128, 64; 192, 96; 256, 128;
            320, 160; 384, 192; 448, 224; 512, 256; 576, 288
            @ src.as_ptr(), u_dst.as_mut_ptr(), v_dst.as_mut_ptr(), mask, 320, end
        );
    }
}

macro_rules! deint_nv12_to_10b_asm {
    ($($s:literal, $d:literal);+ @ $src:expr, $ud:expr, $vd:expr, $mask:expr, $stride:literal, $end:expr) => {
        core::arch::asm!(
            "xor {o:e}, {o:e}",
            "2:",
            $(
                concat!("vmovdqu {a}, [{s} + {o} + ", $s, "]"),
                concat!("vmovdqu {b}, [{s} + {o} + ", $s, " + 32]"),
                "vpand {au}, {a}, {m}",
                "vpsrlw {a}, {a}, 8",
                "vpand {bu}, {b}, {m}",
                "vpsrlw {b}, {b}, 8",
                "vpsllw {au}, {au}, 2",
                "vpsllw {a}, {a}, 2",
                "vpsllw {bu}, {bu}, 2",
                "vpsllw {b}, {b}, 2",
                concat!("vmovdqu [{ud} + {o} + ", $d, "], {au}"),
                concat!("vmovdqu [{ud} + {o} + ", $d, " + 32], {bu}"),
                concat!("vmovdqu [{vd} + {o} + ", $d, "], {a}"),
                concat!("vmovdqu [{vd} + {o} + ", $d, " + 32], {b}"),
            )+
            concat!("add {o}, ", $stride),
            "cmp {o}, {end}",
            "jne 2b",
            s = in(reg) $src,
            ud = in(reg) $ud,
            vd = in(reg) $vd,
            end = in(reg) $end,
            o = out(reg) _,
            m = in(ymm_reg) $mask,
            a = out(ymm_reg) _,
            b = out(ymm_reg) _,
            au = out(ymm_reg) _,
            bu = out(ymm_reg) _,
            options(nostack),
        )
    };
}

#[inline]
pub fn deint_nv12_to_10b(src: &[u8], u_dst: &mut [u16], v_dst: &mut [u16]) {
    use std::arch::x86_64::_mm256_set1_epi16;
    let iters = u_dst.len() / 320;
    let end = iters * 640;
    unsafe {
        let mask = _mm256_set1_epi16(0x00FF);
        let ub = u_dst.as_mut_ptr().cast::<u8>();
        let vb = v_dst.as_mut_ptr().cast::<u8>();
        deint_nv12_to_10b_asm!(
            0, 0; 64, 64; 128, 128; 192, 192; 256, 256;
            320, 320; 384, 384; 448, 448; 512, 512; 576, 576
            @ src.as_ptr(), ub, vb, mask, 640, end
        );
    }
}

macro_rules! shift_p010_asm {
    ($($off:literal);+ @ $src:expr, $dst:expr, $stride:literal, $end:expr) => {
        core::arch::asm!(
            "xor {o:e}, {o:e}",
            "2:",
            $(
                concat!("vmovdqu {a}, [{s} + {o} + ", $off, "]"),
                "vpsrlw {a}, {a}, 6",
                concat!("vmovdqu [{d} + {o} + ", $off, "], {a}"),
            )+
            concat!("add {o}, ", $stride),
            "cmp {o}, {end}",
            "jne 2b",
            s = in(reg) $src,
            d = in(reg) $dst,
            end = in(reg) $end,
            o = out(reg) _,
            a = out(ymm_reg) _,
            options(nostack),
        )
    };
}

#[inline]
pub fn shift_p010(src: &[u16], dst: &mut [u16]) {
    let iters = dst.len() / 160;
    let sb = src.as_ptr().cast::<u8>();
    let db = dst.as_mut_ptr().cast::<u8>();
    let end = iters * 320;
    unsafe {
        shift_p010_asm!(
            0; 32; 64; 96; 128; 160; 192; 224; 256; 288
            @ sb, db, 320, end
        );
    }
}

#[inline]
pub fn shift_p010_rem(src: &[u16], dst: &mut [u16]) {
    let len = dst.len();
    let iters = len / 160;
    if iters > 0 {
        let sb = src.as_ptr().cast::<u8>();
        let db = dst.as_mut_ptr().cast::<u8>();
        let end = iters * 320;
        unsafe {
            shift_p010_asm!(
                0; 32; 64; 96; 128; 160; 192; 224; 256; 288
                @ sb, db, 320, end
            );
        }
    }
    shift_p010_tail(src, dst, iters * 160);
}

#[cold]
#[inline(never)]
fn shift_p010_tail(src: &[u16], dst: &mut [u16], start: usize) {
    unsafe {
        for i in start..dst.len() {
            *dst.get_unchecked_mut(i) = *src.get_unchecked(i) >> 6;
        }
    }
}
