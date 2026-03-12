#[cfg(target_feature = "avx512bw")]
const Z: i8 = 0x80u8 as i8;
#[cfg(target_feature = "avx512bw")]
const PACK_MASK: u64 = 0xFF_FFFF_FFFF;

#[cfg(target_feature = "avx512bw")]
#[target_feature(enable = "avx512f,avx512bw,avx512vbmi")]
pub unsafe fn pack_10bit_avx512(src: *const u8, dst: *mut u8, len: usize) {
    use std::arch::x86_64::{
        __mmask64, _mm512_loadu_si512, _mm512_madd_epi16, _mm512_mask_storeu_epi8,
        _mm512_permutexvar_epi8, _mm512_set_epi8, _mm512_set1_epi32, _mm512_set1_epi64,
        _mm512_srli_epi64, _mm512_ternarylogic_epi64,
    };
    unsafe {
        let mult = _mm512_set1_epi32(0x0400_0001u32 as i32);
        let mask20 = _mm512_set1_epi64(0xFFFFF);
        let perm = _mm512_set_epi8(
            Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, Z, 60, 59, 58, 57,
            56, 52, 51, 50, 49, 48, 44, 43, 42, 41, 40, 36, 35, 34, 33, 32, 28, 27, 26, 25, 24, 20,
            19, 18, 17, 16, 12, 11, 10, 9, 8, 4, 3, 2, 1, 0,
        );
        let wmask = PACK_MASK as __mmask64;
        let mut si = 0usize;
        let mut di = 0usize;
        while si + 64 <= len {
            let v = _mm512_loadu_si512(src.add(si).cast());
            let pairs = _mm512_madd_epi16(v, mult);
            let hi = _mm512_srli_epi64(pairs, 12);
            let packed = _mm512_ternarylogic_epi64(pairs, hi, mask20, 0xE4);
            _mm512_mask_storeu_epi8(
                dst.add(di).cast(),
                wmask,
                _mm512_permutexvar_epi8(perm, packed),
            );
            si += 64;
            di += 40;
        }
    }
}

#[cfg(target_feature = "avx512bw")]
#[target_feature(enable = "avx512f,avx512bw,avx512vbmi")]
pub unsafe fn unpack_10bit_avx512(src: *const u8, dst: *mut u8, len: usize) {
    use std::arch::x86_64::{
        _mm512_and_si512, _mm512_loadu_si512, _mm512_multishift_epi64_epi8,
        _mm512_permutexvar_epi8, _mm512_set_epi8, _mm512_set1_epi16, _mm512_set1_epi64,
        _mm512_storeu_si512,
    };
    unsafe {
        let expand = _mm512_set_epi8(
            Z, Z, Z, 39, 38, 37, 36, 35, Z, Z, Z, 34, 33, 32, 31, 30, Z, Z, Z, 29, 28, 27, 26, 25,
            Z, Z, Z, 24, 23, 22, 21, 20, Z, Z, Z, 19, 18, 17, 16, 15, Z, Z, Z, 14, 13, 12, 11, 10,
            Z, Z, Z, 9, 8, 7, 6, 5, Z, Z, Z, 4, 3, 2, 1, 0,
        );
        let ctrl = _mm512_set1_epi64(0x261E_1C14_120A_0800u64 as i64);
        let m = _mm512_set1_epi16(0x03FF);
        let mut si = 0usize;
        let mut di = 0usize;
        while si + 40 <= len {
            let s = _mm512_permutexvar_epi8(expand, _mm512_loadu_si512(src.add(si).cast()));
            let extracted = _mm512_multishift_epi64_epi8(ctrl, s);
            _mm512_storeu_si512(dst.add(di).cast(), _mm512_and_si512(extracted, m));
            si += 40;
            di += 64;
        }
    }
}

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
#[target_feature(enable = "avx2")]
pub unsafe fn pack_10bit_avx2(src: *const u8, dst: *mut u8, len: usize) {
    use std::{
        arch::x86_64::{
            _mm256_and_si256, _mm256_andnot_si256, _mm256_castsi256_si128,
            _mm256_extracti128_si256, _mm256_loadu_si256, _mm256_madd_epi16, _mm256_or_si256,
            _mm256_set_epi8, _mm256_set1_epi32, _mm256_set1_epi64x, _mm256_shuffle_epi8,
            _mm256_srli_epi64,
        },
        ptr::copy_nonoverlapping,
    };
    unsafe {
        let mult = _mm256_set1_epi32(0x0400_0001u32 as i32);
        let mask20 = _mm256_set1_epi64x(0xFFFFF);
        let shuf = _mm256_set_epi8(
            -1, -1, -1, -1, -1, -1, 12, 11, 10, 9, 8, 4, 3, 2, 1, 0, -1, -1, -1, -1, -1, -1, 12,
            11, 10, 9, 8, 4, 3, 2, 1, 0,
        );
        let mut si = 0usize;
        let mut di = 0usize;
        while si + 32 <= len {
            let v = _mm256_loadu_si256(src.add(si).cast());
            let pairs = _mm256_madd_epi16(v, mult);
            let hi = _mm256_srli_epi64(pairs, 12);
            let lo_part = _mm256_and_si256(pairs, mask20);
            let hi_part = _mm256_andnot_si256(mask20, hi);
            let packed = _mm256_or_si256(lo_part, hi_part);
            let compacted = _mm256_shuffle_epi8(packed, shuf);
            let lower = _mm256_castsi256_si128(compacted);
            let upper = _mm256_extracti128_si256(compacted, 1);
            copy_nonoverlapping(&lower as *const _ as *const u8, dst.add(di), 10);
            copy_nonoverlapping(&upper as *const _ as *const u8, dst.add(di + 10), 10);
            si += 32;
            di += 20;
        }
    }
}

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
#[target_feature(enable = "avx2")]
pub unsafe fn unpack_10bit_avx2(src: *const u8, dst: *mut u8, len: usize) {
    use std::arch::x86_64::{
        _mm_loadu_si128, _mm_set_epi8, _mm_shuffle_epi8, _mm256_and_si256, _mm256_or_si256,
        _mm256_set_m128i, _mm256_set1_epi64x, _mm256_slli_epi64, _mm256_srli_epi64,
        _mm256_storeu_si256,
    };
    unsafe {
        let shuf = _mm_set_epi8(-1, -1, -1, 9, 8, 7, 6, 5, -1, -1, -1, 4, 3, 2, 1, 0);
        let m = _mm256_set1_epi64x(0x3FF);
        let mut si = 0usize;
        let mut di = 0usize;
        while si + 20 <= len {
            let lo = _mm_shuffle_epi8(_mm_loadu_si128(src.add(si).cast()), shuf);
            let hi = _mm_shuffle_epi8(_mm_loadu_si128(src.add(si + 10).cast()), shuf);
            let s = _mm256_set_m128i(hi, lo);
            let w0 = _mm256_and_si256(s, m);
            let w1 = _mm256_slli_epi64(_mm256_and_si256(_mm256_srli_epi64(s, 10), m), 16);
            let w2 = _mm256_slli_epi64(_mm256_and_si256(_mm256_srli_epi64(s, 20), m), 32);
            let w3 = _mm256_slli_epi64(_mm256_srli_epi64(s, 30), 48);
            _mm256_storeu_si256(
                dst.add(di).cast(),
                _mm256_or_si256(_mm256_or_si256(w0, w1), _mm256_or_si256(w2, w3)),
            );
            si += 20;
            di += 32;
        }
    }
}

#[cfg(target_feature = "avx512bw")]
#[target_feature(enable = "avx512bw")]
pub unsafe fn conv_to_10bit_avx512(input: &[u8], output: &mut [u8]) {
    use std::arch::x86_64::{
        __m256i, __m512i, _mm256_loadu_si256, _mm512_cvtepu8_epi16, _mm512_slli_epi16,
        _mm512_storeu_si512,
    };
    let len = input.len();
    let mut i = 0;
    let in_ptr = input.as_ptr();
    let out_ptr = output.as_mut_ptr().cast::<u16>();
    unsafe {
        while i + 64 <= len {
            let lo = _mm256_loadu_si256(in_ptr.add(i).cast::<__m256i>());
            let hi = _mm256_loadu_si256(in_ptr.add(i + 32).cast::<__m256i>());
            _mm512_storeu_si512(
                out_ptr.add(i).cast::<__m512i>(),
                _mm512_slli_epi16(_mm512_cvtepu8_epi16(lo), 2),
            );
            _mm512_storeu_si512(
                out_ptr.add(i + 32).cast::<__m512i>(),
                _mm512_slli_epi16(_mm512_cvtepu8_epi16(hi), 2),
            );
            i += 64;
        }
        while i < len {
            *out_ptr.add(i) = (u16::from(*in_ptr.add(i))) << 2;
            i += 1;
        }
    }
}

#[cfg(target_feature = "avx512bw")]
#[target_feature(enable = "avx512f,avx512bw")]
pub unsafe fn deinterleave_p010_avx512(
    src: *const u16,
    u_dst: *mut u16,
    v_dst: *mut u16,
    pairs: usize,
) {
    use std::arch::x86_64::{
        _mm512_loadu_si512, _mm512_permutex2var_epi16, _mm512_set_epi16, _mm512_srli_epi16,
        _mm512_storeu_si512,
    };
    unsafe {
        let ui = _mm512_set_epi16(
            62, 60, 58, 56, 54, 52, 50, 48, 46, 44, 42, 40, 38, 36, 34, 32, 30, 28, 26, 24, 22, 20,
            18, 16, 14, 12, 10, 8, 6, 4, 2, 0,
        );
        let vi = _mm512_set_epi16(
            63, 61, 59, 57, 55, 53, 51, 49, 47, 45, 43, 41, 39, 37, 35, 33, 31, 29, 27, 25, 23, 21,
            19, 17, 15, 13, 11, 9, 7, 5, 3, 1,
        );
        let mut i = 0;
        while i + 32 <= pairs {
            let a = _mm512_srli_epi16(_mm512_loadu_si512(src.add(i * 2).cast()), 6);
            let b = _mm512_srli_epi16(_mm512_loadu_si512(src.add(i * 2 + 32).cast()), 6);
            _mm512_storeu_si512(u_dst.add(i).cast(), _mm512_permutex2var_epi16(a, ui, b));
            _mm512_storeu_si512(v_dst.add(i).cast(), _mm512_permutex2var_epi16(a, vi, b));
            i += 32;
        }
        while i < pairs {
            *u_dst.add(i) = *src.add(i * 2) >> 6;
            *v_dst.add(i) = *src.add(i * 2 + 1) >> 6;
            i += 1;
        }
    }
}

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
#[target_feature(enable = "avx2")]
pub unsafe fn deinterleave_p010_avx2(
    src: *const u16,
    u_dst: *mut u16,
    v_dst: *mut u16,
    pairs: usize,
) {
    use std::arch::x86_64::{
        _mm_storeu_si128, _mm256_castsi256_si128, _mm256_loadu_si256, _mm256_permute4x64_epi64,
        _mm256_set_epi8, _mm256_shuffle_epi8, _mm256_srli_epi16,
    };
    unsafe {
        let shuf = _mm256_set_epi8(
            15, 14, 11, 10, 7, 6, 3, 2, 13, 12, 9, 8, 5, 4, 1, 0, 15, 14, 11, 10, 7, 6, 3, 2, 13,
            12, 9, 8, 5, 4, 1, 0,
        );
        let mut i = 0;
        while i + 8 <= pairs {
            let v = _mm256_srli_epi16(_mm256_loadu_si256(src.add(i * 2).cast()), 6);
            let d = _mm256_shuffle_epi8(v, shuf);
            _mm_storeu_si128(
                u_dst.add(i).cast(),
                _mm256_castsi256_si128(_mm256_permute4x64_epi64(d, 0x08)),
            );
            _mm_storeu_si128(
                v_dst.add(i).cast(),
                _mm256_castsi256_si128(_mm256_permute4x64_epi64(d, 0x0D)),
            );
            i += 8;
        }
        while i < pairs {
            *u_dst.add(i) = *src.add(i * 2) >> 6;
            *v_dst.add(i) = *src.add(i * 2 + 1) >> 6;
            i += 1;
        }
    }
}

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
#[target_feature(enable = "avx2")]
pub unsafe fn conv_to_10bit_avx2(input: &[u8], output: &mut [u8]) {
    use std::arch::x86_64::{
        __m128i, __m256i, _mm_loadu_si128, _mm256_cvtepu8_epi16, _mm256_slli_epi16,
        _mm256_storeu_si256,
    };
    let len = input.len();
    let mut i = 0;
    let in_ptr = input.as_ptr();
    let out_ptr = output.as_mut_ptr().cast::<u16>();
    unsafe {
        while i + 32 <= len {
            let lo = _mm_loadu_si128(in_ptr.add(i).cast::<__m128i>());
            let hi = _mm_loadu_si128(in_ptr.add(i + 16).cast::<__m128i>());
            _mm256_storeu_si256(
                out_ptr.add(i).cast::<__m256i>(),
                _mm256_slli_epi16(_mm256_cvtepu8_epi16(lo), 2),
            );
            _mm256_storeu_si256(
                out_ptr.add(i + 16).cast::<__m256i>(),
                _mm256_slli_epi16(_mm256_cvtepu8_epi16(hi), 2),
            );
            i += 32;
        }
        while i < len {
            *out_ptr.add(i) = (u16::from(*in_ptr.add(i))) << 2;
            i += 1;
        }
    }
}
