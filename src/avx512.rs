const Z: i8 = 0x80u8 as i8;
const PACK_MASK: u64 = 0xFF_FFFF_FFFF;

pub const SHIFT_CHUNK: usize = 320;
pub const PACK_CHUNK: usize = 384;
pub const UNPACK_CHUNK: usize = 600;

macro_rules! pack_10b_asm {
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

#[inline(always)]
pub fn pack_10b(input: &[u8], output: &mut [u8]) {
    use std::arch::x86_64::{_mm512_set_epi8, _mm512_set1_epi32, _mm512_set1_epi64};
    let iters = input.len() / 384;
    let src = input.as_ptr();
    let dst = output.as_mut_ptr();
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
        pack_10b_asm!(
            0, 64, 0, 40;
            128, 192, 80, 120;
            256, 320, 160, 200
            @ src, dst, end, wmask, mult, mask20, perm
        );
    }
}

macro_rules! unpack_10b_asm {
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

#[inline(always)]
pub fn unpack_10b(input: &[u8], output: &mut [u8]) {
    use std::arch::x86_64::{_mm512_set_epi8, _mm512_set_epi16, _mm512_set1_epi16};
    let iters = input.len() / 600;
    let src = input.as_ptr();
    let dst = output.as_mut_ptr();
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
        unpack_10b_asm!(
            0, 0; 40, 64; 80, 128; 120, 192; 160, 256;
            200, 320; 240, 384; 280, 448; 320, 512; 360, 576;
            400, 640; 440, 704; 480, 768; 520, 832; 560, 896
            @ src, dst, end, perm, shifts, m
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

#[inline(always)]
pub fn conv_to_10b(input: &[u8], output: &mut [u8]) {
    let iters = input.len() / 320;
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

macro_rules! deint_p010_asm {
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

#[inline(always)]
pub fn deint_p010(src: &[u16], u_dst: &mut [u16], v_dst: &mut [u16]) {
    use std::arch::x86_64::_mm512_set_epi16;
    let iters = u_dst.len() / 320;
    let sb = src.as_ptr().cast::<u8>();
    let ub = u_dst.as_mut_ptr().cast::<u8>();
    let vb = v_dst.as_mut_ptr().cast::<u8>();
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
        deint_p010_asm!(
            0, 0; 128, 64; 256, 128; 384, 192; 512, 256;
            640, 320; 768, 384; 896, 448; 1024, 512; 1152, 576
            @ sb, ub, vb, ui, vi, 640, end
        );
    }
}

macro_rules! deint_nv12_asm {
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

#[inline(always)]
pub fn deint_nv12(src: &[u8], u_dst: &mut [u8], v_dst: &mut [u8]) {
    use std::arch::x86_64::_mm512_set_epi8;
    let iters = u_dst.len() / 640;
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
        deint_nv12_asm!(
            0, 0; 128, 64; 256, 128; 384, 192; 512, 256;
            640, 320; 768, 384; 896, 448; 1024, 512; 1152, 576
            @ src.as_ptr(), u_dst.as_mut_ptr(), v_dst.as_mut_ptr(), ui, vi, 640, end
        );
    }
}

macro_rules! deint_nv12_to_10b_asm {
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

#[inline(always)]
pub fn deint_nv12_to_10b(src: &[u8], u_dst: &mut [u16], v_dst: &mut [u16]) {
    use std::arch::x86_64::_mm512_set1_epi16;
    let iters = u_dst.len() / 640;
    let end = iters * 1280;
    unsafe {
        let mask = _mm512_set1_epi16(0x03FC);
        let ub = u_dst.as_mut_ptr().cast::<u8>();
        let vb = v_dst.as_mut_ptr().cast::<u8>();
        deint_nv12_to_10b_asm!(
            0, 64, 128, 192, 256, 320, 384, 448, 512, 576,
            640, 704, 768, 832, 896, 960, 1024, 1088, 1152, 1216;
            src.as_ptr(), ub, vb, mask, 1280, end
        );
    }
}

macro_rules! shift_p010_asm {
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

#[inline(always)]
pub fn shift_p010(src: &[u16], dst: &mut [u16]) {
    let iters = dst.len() / 320;
    let sb = src.as_ptr().cast::<u8>();
    let db = dst.as_mut_ptr().cast::<u8>();
    let end = iters * 640;
    unsafe {
        shift_p010_asm!(
            0; 64; 128; 192; 256; 320; 384; 448; 512; 576
            @ sb, db, 640, end
        );
    }
}

#[inline(always)]
pub fn shift_p010_rem(src: &[u16], dst: &mut [u16]) {
    let len = dst.len();
    let iters = len / 320;
    if iters > 0 {
        let sb = src.as_ptr().cast::<u8>();
        let db = dst.as_mut_ptr().cast::<u8>();
        let end = iters * 640;
        unsafe {
            shift_p010_asm!(
                0; 64; 128; 192; 256; 320; 384; 448; 512; 576
                @ sb, db, 640, end
            );
        }
    }
    shift_p010_tail(src, dst, iters * 320);
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
