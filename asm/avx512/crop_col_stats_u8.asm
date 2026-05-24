%include "dav1d_x86inc.asm"

SECTION .text
INIT_ZMM avx512
cglobal crop_col_stats_u8, 7, 8, 14, plane, stride, n, clamp, sum_p, min_p, max_p
    vpbroadcastb  zmm0, clampd
    vpternlogd    zmm3, zmm3, zmm3, 0xFF
    vpxor         xmm4, xmm4, xmm4
    vpxor         xmm5, xmm5, xmm5
    vpxor         xmm6, xmm6, xmm6
ALIGN 16
.loop:
%rep 8
    vpmaxub       zmm7, zmm0, [planeq]
    vpmaxub       zmm8, zmm0, [planeq + strideq]
    lea           planeq, [planeq + strideq*2]
    vextracti64x4 ymm9, zmm7, 1
    vpmovzxbw     zmm10, ymm7
    vpaddw        zmm5, zmm5, zmm10
    vpmovzxbw     zmm10, ymm9
    vpaddw        zmm6, zmm6, zmm10
    vpminub       zmm3, zmm3, zmm7
    vpmaxub       zmm4, zmm4, zmm7
    vextracti64x4 ymm9, zmm8, 1
    vpmovzxbw     zmm10, ymm8
    vpaddw        zmm5, zmm5, zmm10
    vpmovzxbw     zmm10, ymm9
    vpaddw        zmm6, zmm6, zmm10
    vpminub       zmm3, zmm3, zmm8
    vpmaxub       zmm4, zmm4, zmm8
%endrep
    sub           nq, 16
    jnz           .loop
    vextracti64x4 ymm7, zmm5, 1
    vpmovzxwd     zmm8, ymm5
    vpmovzxwd     zmm9, ymm7
    vmovdqu64     [sum_pq], zmm8
    vmovdqu64     [sum_pq + 64], zmm9
    vextracti64x4 ymm7, zmm6, 1
    vpmovzxwd     zmm8, ymm6
    vpmovzxwd     zmm9, ymm7
    vmovdqu64     [sum_pq + 128], zmm8
    vmovdqu64     [sum_pq + 192], zmm9
    vmovdqu64     [min_pq], zmm3
    vmovdqu64     [max_pq], zmm4
    RET
