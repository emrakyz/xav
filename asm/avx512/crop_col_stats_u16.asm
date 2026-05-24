%include "dav1d_x86inc.asm"

SECTION .text
INIT_ZMM avx512
cglobal crop_col_stats_u16, 7, 8, 13, plane, stride, n, clamp, sum_p, min_p, max_p
    vpbroadcastw  zmm0, clampd
    vpternlogd    zmm3, zmm3, zmm3, 0xFF
    vpternlogd    zmm4, zmm4, zmm4, 0xFF
    vpxor         xmm5, xmm5, xmm5
    vpxor         xmm6, xmm6, xmm6
    vpxor         xmm7, xmm7, xmm7
    vpxor         xmm8, xmm8, xmm8
ALIGN 16
.loop:
%rep 8
    vpmaxuw       zmm9,  zmm0, [planeq]
    vpmaxuw       zmm10, zmm0, [planeq + 64]
    vpmaxuw       zmm11, zmm0, [planeq + strideq]
    vpmaxuw       zmm12, zmm0, [planeq + strideq + 64]
    lea           planeq, [planeq + strideq*2]
    vpaddw        zmm7, zmm7, zmm9
    vpaddw        zmm8, zmm8, zmm10
    vpminuw       zmm3, zmm3, zmm9
    vpminuw       zmm4, zmm4, zmm10
    vpmaxuw       zmm5, zmm5, zmm9
    vpmaxuw       zmm6, zmm6, zmm10
    vpaddw        zmm7, zmm7, zmm11
    vpaddw        zmm8, zmm8, zmm12
    vpminuw       zmm3, zmm3, zmm11
    vpminuw       zmm4, zmm4, zmm12
    vpmaxuw       zmm5, zmm5, zmm11
    vpmaxuw       zmm6, zmm6, zmm12
%endrep
    sub           nq, 16
    jnz           .loop
    vextracti64x4 ymm9, zmm7, 1
    vpmovzxwd     zmm10, ymm7
    vpmovzxwd     zmm11, ymm9
    vmovdqu64     [sum_pq], zmm10
    vmovdqu64     [sum_pq + 64], zmm11
    vextracti64x4 ymm9, zmm8, 1
    vpmovzxwd     zmm10, ymm8
    vpmovzxwd     zmm11, ymm9
    vmovdqu64     [sum_pq + 128], zmm10
    vmovdqu64     [sum_pq + 192], zmm11
    vmovdqu64     [min_pq], zmm3
    vmovdqu64     [min_pq + 64], zmm4
    vmovdqu64     [max_pq], zmm5
    vmovdqu64     [max_pq + 64], zmm6
    RET
