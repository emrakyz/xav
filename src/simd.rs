#[cfg(target_feature = "avx512bw")]
const Z: i8 = 0x80u8 as i8;
#[cfg(target_feature = "avx512bw")]
const PACK_MASK: u64 = 0xFF_FFFF_FFFF;

#[cfg(target_feature = "avx512bw")]
macro_rules! pack_10b_avx512_asm {
    ($($s0:literal, $s1:literal, $d0:literal, $d1:literal);+ @ $src:expr, $dst:expr, $end:expr, $wmask:expr, $mult:expr, $mask20:expr, $perm:expr) => {
        core::arch::asm!(
            "kmovq {k}, {wmask}",
            "2:",
            $(
                concat!("vpmaddwd {a}, {mult}, [{s} + ", $s0, "]"),
                concat!("vpmaddwd {c}, {mult}, [{s} + ", $s1, "]"),
                "vpsrlq {b}, {a}, 12",
                "vpsrlq {e}, {c}, 12",
                "vpternlogq {a}, {b}, {mask20}, 0xE4",
                "vpternlogq {c}, {e}, {mask20}, 0xE4",
                "vpermb {a}, {perm}, {a}",
                "vpermb {c}, {perm}, {c}",
                concat!("vmovdqu8 [{d} + ", $d0, "]{{{k}}}, {a}"),
                concat!("vmovdqu8 [{d} + ", $d1, "]{{{k}}}, {c}"),
            )+
            "add {s}, 384",
            "add {d}, 240",
            "cmp {s}, {end}",
            "jne 2b",
            s = inout(reg) $src => _,
            d = inout(reg) $dst => _,
            end = in(reg) $end,
            wmask = in(reg) $wmask,
            mult = in(zmm_reg) $mult,
            mask20 = in(zmm_reg) $mask20,
            perm = in(zmm_reg) $perm,
            a = out(zmm_reg) _,
            b = out(zmm_reg) _,
            c = out(zmm_reg) _,
            e = out(zmm_reg) _,
            k = out(kreg) _,
            options(nostack),
        )
    };
}

#[cfg(target_feature = "avx512bw")]
#[inline]
pub unsafe fn pack_10b_avx512(src: *const u8, dst: *mut u8, len: usize) {
    use std::arch::x86_64::{_mm512_set_epi8, _mm512_set1_epi32, _mm512_set1_epi64};
    let iters = len / 384;
    if iters == 0 {
        return;
    }
    unsafe {
        let mult = _mm512_set1_epi32(0x0400_0001u32 as i32);
        let mask20 = _mm512_set1_epi64(0xFFFFF);
        let perm = _mm512_set_epi8(
            Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, 60, 59, 58, 57,
            56, 52, 51, 50, 49, 48, 44, 43, 42, 41, 40, 36, 35, 34, 33, 32, 28, 27, 26, 25, 24, 20,
            19, 18, 17, 16, 12, 11, 10, 9, 8, 4, 3, 2, 1, 0,
        );
        let wmask = PACK_MASK;
        let end = src.add(iters * 384);
        pack_10b_avx512_asm!(
            0, 64, 0, 40;
            128, 192, 80, 120;
            256, 320, 160, 200
            @ src, dst, end, wmask, mult, mask20, perm
        );
    }
}

#[cfg(target_feature = "avx512bw")]
macro_rules! unpack_10b_avx512_asm {
    ($($si:literal, $di:literal);+ @ $src:expr, $dst:expr, $end:expr, $perm:expr, $shifts:expr, $mask:expr) => {
        core::arch::asm!(
            "2:",
            $(
                concat!("vpermb {a}, {perm}, [{s} + ", $si, "]"),
                "vpsrlvw {a}, {a}, {shifts}",
                "vpandq {a}, {a}, {mask}",
                concat!("vmovdqu64 [{d} + ", $di, "], {a}"),
            )+
            "add {s}, 600",
            "add {d}, 960",
            "cmp {s}, {end}",
            "jne 2b",
            s = inout(reg) $src => _,
            d = inout(reg) $dst => _,
            end = in(reg) $end,
            perm = in(zmm_reg) $perm,
            shifts = in(zmm_reg) $shifts,
            mask = in(zmm_reg) $mask,
            a = out(zmm_reg) _,
            options(nostack),
        )
    };
}

#[cfg(target_feature = "avx512bw")]
#[inline]
pub unsafe fn unpack_10b_avx512(src: *const u8, dst: *mut u8, len: usize) {
    use std::arch::x86_64::{_mm512_set_epi8, _mm512_set_epi16, _mm512_set1_epi16};
    let iters = len / 600;
    if iters == 0 {
        return;
    }
    unsafe {
        let perm = _mm512_set_epi8(
            39, 38, 38, 37, 37, 36, 36, 35, 34, 33, 33, 32, 32, 31, 31, 30, 29, 28, 28, 27, 27, 26,
            26, 25, 24, 23, 23, 22, 22, 21, 21, 20, 19, 18, 18, 17, 17, 16, 16, 15, 14, 13, 13, 12,
            12, 11, 11, 10, 9, 8, 8, 7, 7, 6, 6, 5, 4, 3, 3, 2, 2, 1, 1, 0,
        );
        let shifts = _mm512_set_epi16(
            6, 4, 2, 0, 6, 4, 2, 0, 6, 4, 2, 0, 6, 4, 2, 0, 6, 4, 2, 0, 6, 4, 2, 0, 6, 4, 2, 0, 6,
            4, 2, 0,
        );
        let m = _mm512_set1_epi16(0x03FF);
        let end = src.add(iters * 600);
        unpack_10b_avx512_asm!(
            0, 0; 40, 64; 80, 128; 120, 192; 160, 256;
            200, 320; 240, 384; 280, 448; 320, 512; 360, 576;
            400, 640; 440, 704; 480, 768; 520, 832; 560, 896
            @ src, dst, end, perm, shifts, m
        );
    }
}

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
macro_rules! pack_10b_avx2_asm {
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

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
#[inline]
pub unsafe fn pack_10b_avx2(src: *const u8, dst: *mut u8, len: usize) {
    use std::arch::x86_64::{_mm256_set_epi8, _mm256_set1_epi32, _mm256_set1_epi64x};
    let iters = len / 192;
    if iters == 0 {
        return;
    }
    unsafe {
        let mult = _mm256_set1_epi32(0x0400_0001u32 as i32);
        let mask20 = _mm256_set1_epi64x(0xFFFFF);
        let shuf = _mm256_set_epi8(
            -1, -1, -1, -1, -1, -1, 12, 11, 10, 9, 8, 4, 3, 2, 1, 0, -1, -1, -1, -1, -1, -1, 12,
            11, 10, 9, 8, 4, 3, 2, 1, 0,
        );
        let end = src.add(iters * 192);
        pack_10b_avx2_asm!(
            0, 32, 0, 20;
            64, 96, 40, 60;
            128, 160, 80, 100
            @ src, dst, end, mult, mask20, shuf
        );
    }
}

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
macro_rules! unpack_10b_avx2_asm {
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

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
#[inline]
pub unsafe fn unpack_10b_avx2(src: *const u8, dst: *mut u8, len: usize) {
    use std::arch::x86_64::{_mm256_set_epi8, _mm256_set1_epi64x};
    let iters = len / 120;
    if iters == 0 {
        return;
    }
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
        unpack_10b_avx2_asm!(
            0, 20, 0, 32;
            40, 60, 64, 96;
            80, 100, 128, 160
            @ src, dst, end, shuf, m0, m1, m2, m3
        );
    }
}

#[cfg(target_feature = "avx512bw")]
macro_rules! conv_10b_asm {
    ($($s:literal, $d:literal);+ @ $src:expr, $dst:expr, $stride:literal, $end:expr) => {
        core::arch::asm!(
            "xor {o:e}, {o:e}",
            "2:",
            $(
                concat!("vpmovzxbw {a}, [{s} + {o} + ", $s, "]"),
                "vpsllw {a}, {a}, 2",
                concat!("vmovdqu64 [{d} + {o}*2 + ", $d, "], {a}"),
            )+
            concat!("add {o}, ", $stride),
            "cmp {o}, {end}",
            "jne 2b",
            s = in(reg) $src,
            d = in(reg) $dst,
            end = in(reg) $end,
            o = out(reg) _,
            a = out(zmm_reg) _,
            options(nostack),
        )
    };
}

#[cfg(target_feature = "avx512bw")]
#[inline]
pub unsafe fn conv_to_10b_avx512(input: &[u8], output: &mut [u8]) {
    let iters = input.len() / 320;
    if iters == 0 {
        return;
    }
    let src = input.as_ptr();
    let dst = output.as_mut_ptr();
    let end = iters * 320;
    unsafe {
        conv_10b_asm!(
            0, 0; 32, 64; 64, 128; 96, 192; 128, 256;
            160, 320; 192, 384; 224, 448; 256, 512; 288, 576
            @ src, dst, 320, end
        );
    }
}

#[cfg(target_feature = "avx512bw")]
macro_rules! deint_p010_avx512_asm {
    ($($si:literal, $do:literal);+ @ $src:expr, $ud:expr, $vd:expr, $ui:expr, $vi:expr, $stride:literal, $end:expr) => {
        core::arch::asm!(
            "xor {o:e}, {o:e}",
            "2:",
            $(
                concat!("vpsrlw {a}, [{s} + {o}*2 + ", $si, "], 6"),
                concat!("vpsrlw {b}, [{s} + {o}*2 + ", $si, " + 64], 6"),
                "vmovdqa64 {t}, {a}",
                "vpermt2w {a}, {ui}, {b}",
                "vpermt2w {t}, {vi}, {b}",
                concat!("vmovdqu64 [{ud} + {o} + ", $do, "], {a}"),
                concat!("vmovdqu64 [{vd} + {o} + ", $do, "], {t}"),
            )+
            concat!("add {o}, ", $stride),
            "cmp {o}, {end}",
            "jne 2b",
            s = in(reg) $src,
            ud = in(reg) $ud,
            vd = in(reg) $vd,
            end = in(reg) $end,
            o = out(reg) _,
            ui = in(zmm_reg) $ui,
            vi = in(zmm_reg) $vi,
            a = out(zmm_reg) _,
            b = out(zmm_reg) _,
            t = out(zmm_reg) _,
            options(nostack),
        )
    };
}

#[cfg(target_feature = "avx512bw")]
#[inline]
pub unsafe fn deint_p010_avx512(src: *const u16, u_dst: *mut u16, v_dst: *mut u16, pairs: usize) {
    use std::arch::x86_64::_mm512_set_epi16;
    let iters = pairs / 320;
    if iters == 0 {
        return;
    }
    let sb = src.cast::<u8>();
    let ub = u_dst.cast::<u8>();
    let vb = v_dst.cast::<u8>();
    let end = iters * 640;
    unsafe {
        let ui = _mm512_set_epi16(
            62, 60, 58, 56, 54, 52, 50, 48, 46, 44, 42, 40, 38, 36, 34, 32, 30, 28, 26, 24, 22, 20,
            18, 16, 14, 12, 10, 8, 6, 4, 2, 0,
        );
        let vi = _mm512_set_epi16(
            63, 61, 59, 57, 55, 53, 51, 49, 47, 45, 43, 41, 39, 37, 35, 33, 31, 29, 27, 25, 23, 21,
            19, 17, 15, 13, 11, 9, 7, 5, 3, 1,
        );
        deint_p010_avx512_asm!(
            0, 0; 128, 64; 256, 128; 384, 192; 512, 256;
            640, 320; 768, 384; 896, 448; 1024, 512; 1152, 576
            @ sb, ub, vb, ui, vi, 640, end
        );
    }
}

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
macro_rules! deint_p010_avx2_asm {
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

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
#[inline]
pub unsafe fn deint_p010_avx2(src: *const u16, u_dst: *mut u16, v_dst: *mut u16, pairs: usize) {
    use std::arch::x86_64::_mm256_set_epi8;
    let iters = pairs / 160;
    if iters == 0 {
        return;
    }
    let sb = src.cast::<u8>();
    let ub = u_dst.cast::<u8>();
    let vb = v_dst.cast::<u8>();
    let end = iters * 320;
    unsafe {
        let shuf = _mm256_set_epi8(
            15, 14, 11, 10, 7, 6, 3, 2, 13, 12, 9, 8, 5, 4, 1, 0, 15, 14, 11, 10, 7, 6, 3, 2, 13,
            12, 9, 8, 5, 4, 1, 0,
        );
        deint_p010_avx2_asm!(
            0, 0; 64, 32; 128, 64; 192, 96; 256, 128;
            320, 160; 384, 192; 448, 224; 512, 256; 576, 288
            @ sb, ub, vb, shuf, 320, end
        );
    }
}

#[cfg(target_feature = "avx512bw")]
macro_rules! nv12_deint_asm {
    ($($s:literal, $d:literal);+ @ $src:expr, $ud:expr, $vd:expr, $ui:expr, $vi:expr, $stride:literal, $end:expr) => {
        core::arch::asm!(
            "xor {o:e}, {o:e}",
            "2:",
            $(
                concat!("vmovdqu64 {a}, [{s} + {o}*2 + ", $s, "]"),
                "vmovdqa64 {t}, {a}",
                concat!("vpermt2b {t}, {ui}, [{s} + {o}*2 + ", $s, " + 64]"),
                concat!("vpermt2b {a}, {vi}, [{s} + {o}*2 + ", $s, " + 64]"),
                concat!("vmovdqu64 [{ud} + {o} + ", $d, "], {t}"),
                concat!("vmovdqu64 [{vd} + {o} + ", $d, "], {a}"),
            )+
            concat!("add {o}, ", $stride),
            "cmp {o}, {end}",
            "jne 2b",
            s = in(reg) $src,
            ud = in(reg) $ud,
            vd = in(reg) $vd,
            end = in(reg) $end,
            o = out(reg) _,
            ui = in(zmm_reg) $ui,
            vi = in(zmm_reg) $vi,
            a = out(zmm_reg) _,
            t = out(zmm_reg) _,
            options(nostack),
        )
    };
}

#[cfg(target_feature = "avx512bw")]
#[inline]
pub unsafe fn deint_nv12_avx512(src: *const u8, u_dst: *mut u8, v_dst: *mut u8, pairs: usize) {
    use std::arch::x86_64::_mm512_set_epi8;
    let iters = pairs / 640;
    if iters == 0 {
        return;
    }
    let end = iters * 640;
    unsafe {
        let ui = _mm512_set_epi8(
            126, 124, 122, 120, 118, 116, 114, 112, 110, 108, 106, 104, 102, 100, 98, 96, 94, 92,
            90, 88, 86, 84, 82, 80, 78, 76, 74, 72, 70, 68, 66, 64, 62, 60, 58, 56, 54, 52, 50, 48,
            46, 44, 42, 40, 38, 36, 34, 32, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2,
            0,
        );
        let vi = _mm512_set_epi8(
            127, 125, 123, 121, 119, 117, 115, 113, 111, 109, 107, 105, 103, 101, 99, 97, 95, 93,
            91, 89, 87, 85, 83, 81, 79, 77, 75, 73, 71, 69, 67, 65, 63, 61, 59, 57, 55, 53, 51, 49,
            47, 45, 43, 41, 39, 37, 35, 33, 31, 29, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3,
            1,
        );
        nv12_deint_asm!(
            0, 0; 128, 64; 256, 128; 384, 192; 512, 256;
            640, 320; 768, 384; 896, 448; 1024, 512; 1152, 576
            @ src, u_dst, v_dst, ui, vi, 640, end
        );
    }
}

#[cfg(target_feature = "avx512bw")]
macro_rules! nv12_10b_asm {
    ($($off:literal),+; $src:expr, $ud:expr, $vd:expr, $mask:expr, $stride:literal, $end:expr) => {
        core::arch::asm!(
            "xor {o:e}, {o:e}",
            "2:",
            $(
                concat!("vpsllw {u}, [{s} + {o} + ", $off, "], 2"),
                "vpandq {u}, {u}, {m}",
                concat!("vpsrlw {v}, [{s} + {o} + ", $off, "], 6"),
                "vpandq {v}, {v}, {m}",
                concat!("vmovdqu64 [{ud} + {o} + ", $off, "], {u}"),
                concat!("vmovdqu64 [{vd} + {o} + ", $off, "], {v}"),
            )+
            concat!("add {o}, ", $stride),
            "cmp {o}, {end}",
            "jne 2b",
            s = in(reg) $src,
            ud = in(reg) $ud,
            vd = in(reg) $vd,
            end = in(reg) $end,
            o = out(reg) _,
            m = in(zmm_reg) $mask,
            u = out(zmm_reg) _,
            v = out(zmm_reg) _,
            options(nostack),
        )
    };
}

#[cfg(target_feature = "avx512bw")]
#[inline]
pub unsafe fn deint_nv12_to_10b_avx512(
    src: *const u8,
    u_dst: *mut u16,
    v_dst: *mut u16,
    pairs: usize,
) {
    use std::arch::x86_64::_mm512_set1_epi16;
    let iters = pairs / 640;
    if iters == 0 {
        return;
    }
    let end = iters * 1280;
    unsafe {
        let mask = _mm512_set1_epi16(0x03FC);
        let ub = u_dst.cast::<u8>();
        let vb = v_dst.cast::<u8>();
        nv12_10b_asm!(
            0, 64, 128, 192, 256, 320, 384, 448, 512, 576,
            640, 704, 768, 832, 896, 960, 1024, 1088, 1152, 1216;
            src, ub, vb, mask, 1280, end
        );
    }
}

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
macro_rules! nv12_deint_avx2_asm {
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

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
#[inline]
pub unsafe fn deint_nv12_avx2(src: *const u8, u_dst: *mut u8, v_dst: *mut u8, pairs: usize) {
    use std::arch::x86_64::_mm256_set1_epi16;
    let iters = pairs / 320;
    if iters == 0 {
        return;
    }
    let end = iters * 320;
    unsafe {
        let mask = _mm256_set1_epi16(0x00FF);
        nv12_deint_avx2_asm!(
            0, 0; 64, 32; 128, 64; 192, 96; 256, 128;
            320, 160; 384, 192; 448, 224; 512, 256; 576, 288
            @ src, u_dst, v_dst, mask, 320, end
        );
    }
}

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
macro_rules! nv12_10b_avx2_asm {
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

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
#[inline]
pub unsafe fn deint_nv12_to_10b_avx2(
    src: *const u8,
    u_dst: *mut u16,
    v_dst: *mut u16,
    pairs: usize,
) {
    use std::arch::x86_64::_mm256_set1_epi16;
    let iters = pairs / 320;
    if iters == 0 {
        return;
    }
    let end = iters * 640;
    unsafe {
        let mask = _mm256_set1_epi16(0x00FF);
        let ub = u_dst.cast::<u8>();
        let vb = v_dst.cast::<u8>();
        nv12_10b_avx2_asm!(
            0, 0; 64, 64; 128, 128; 192, 192; 256, 256;
            320, 320; 384, 384; 448, 448; 512, 512; 576, 576
            @ src, ub, vb, mask, 640, end
        );
    }
}

#[cfg(target_feature = "avx512bw")]
macro_rules! shift_p010_avx512_asm {
    ($($off:literal);+ @ $src:expr, $dst:expr, $stride:literal, $end:expr) => {
        core::arch::asm!(
            "xor {o:e}, {o:e}",
            "2:",
            $(
                concat!("vpsrlw {a}, [{s} + {o} + ", $off, "], 6"),
                concat!("vmovdqu64 [{d} + {o} + ", $off, "], {a}"),
            )+
            concat!("add {o}, ", $stride),
            "cmp {o}, {end}",
            "jne 2b",
            s = in(reg) $src,
            d = in(reg) $dst,
            end = in(reg) $end,
            o = out(reg) _,
            a = out(zmm_reg) _,
            options(nostack),
        )
    };
}

#[cfg(target_feature = "avx512bw")]
#[inline]
pub unsafe fn shift_p010_avx512(src: *const u16, dst: *mut u16, len: usize) {
    let iters = len / 320;
    if iters == 0 {
        return;
    }
    let sb = src.cast::<u8>();
    let db = dst.cast::<u8>();
    let end = iters * 640;
    unsafe {
        shift_p010_avx512_asm!(
            0; 64; 128; 192; 256; 320; 384; 448; 512; 576
            @ sb, db, 640, end
        );
    }
}

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
macro_rules! shift_p010_avx2_asm {
    ($($off:literal);+ @ $src:expr, $dst:expr, $stride:literal, $end:expr) => {
        core::arch::asm!(
            "xor {o:e}, {o:e}",
            "2:",
            $(
                concat!("vpsrlw {a}, [{s} + {o} + ", $off, "], 6"),
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

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
#[inline]
pub unsafe fn shift_p010_avx2(src: *const u16, dst: *mut u16, len: usize) {
    let iters = len / 160;
    if iters == 0 {
        return;
    }
    let sb = src.cast::<u8>();
    let db = dst.cast::<u8>();
    let end = iters * 320;
    unsafe {
        shift_p010_avx2_asm!(
            0; 32; 64; 96; 128; 160; 192; 224; 256; 288
            @ sb, db, 320, end
        );
    }
}

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
macro_rules! conv_10b_avx2_asm {
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

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
#[inline]
pub unsafe fn conv_to_10b_avx2(input: &[u8], output: &mut [u8]) {
    let iters = input.len() / 160;
    if iters == 0 {
        return;
    }
    let src = input.as_ptr();
    let dst = output.as_mut_ptr();
    let end = iters * 160;
    unsafe {
        conv_10b_avx2_asm!(
            0, 0; 16, 32; 32, 64; 48, 96; 64, 128;
            80, 160; 96, 192; 112, 224; 128, 256; 144, 288
            @ src, dst, 160, end
        );
    }
}
