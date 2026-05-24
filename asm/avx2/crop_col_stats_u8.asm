%include "dav1d_x86inc.asm"

SECTION .text
INIT_YMM avx2
cglobal crop_col_stats_u8, 7, 8, 16, plane, stride, n, clamp, sum_p, min_p, max_p
    vmovd         xmm0, clampd
    vpbroadcastb  ymm0, xmm0
    vpxor         xmm14, xmm14, xmm14
    vpcmpeqb      ymm1, ymm1, ymm1
    vpcmpeqb      ymm2, ymm2, ymm2
    vpxor         xmm3, xmm3, xmm3
    vpxor         xmm4, xmm4, xmm4
    vpxor         xmm5, xmm5, xmm5
    vpxor         xmm6, xmm6, xmm6
    vpxor         xmm7, xmm7, xmm7
    vpxor         xmm8, xmm8, xmm8
ALIGN 16
.loop:
%rep 8
    vpmaxub       ymm9,  ymm0, [planeq]
    vpmaxub       ymm10, ymm0, [planeq + 32]
    vpmaxub       ymm11, ymm0, [planeq + strideq]
    vpmaxub       ymm12, ymm0, [planeq + strideq + 32]
    lea           planeq, [planeq + strideq*2]
    vpminub       ymm1, ymm1, ymm9
    vpminub       ymm2, ymm2, ymm10
    vpmaxub       ymm3, ymm3, ymm9
    vpmaxub       ymm4, ymm4, ymm10
    vpminub       ymm1, ymm1, ymm11
    vpminub       ymm2, ymm2, ymm12
    vpmaxub       ymm3, ymm3, ymm11
    vpmaxub       ymm4, ymm4, ymm12
    vpunpcklbw    ymm13, ymm9,  ymm14
    vpaddw        ymm5,  ymm5,  ymm13
    vpunpckhbw    ymm13, ymm9,  ymm14
    vpaddw        ymm6,  ymm6,  ymm13
    vpunpcklbw    ymm13, ymm10, ymm14
    vpaddw        ymm7,  ymm7,  ymm13
    vpunpckhbw    ymm13, ymm10, ymm14
    vpaddw        ymm8,  ymm8,  ymm13
    vpunpcklbw    ymm13, ymm11, ymm14
    vpaddw        ymm5,  ymm5,  ymm13
    vpunpckhbw    ymm13, ymm11, ymm14
    vpaddw        ymm6,  ymm6,  ymm13
    vpunpcklbw    ymm13, ymm12, ymm14
    vpaddw        ymm7,  ymm7,  ymm13
    vpunpckhbw    ymm13, ymm12, ymm14
    vpaddw        ymm8,  ymm8,  ymm13
%endrep
    sub           nq, 16
    jnz           .loop
    vpmovzxwd     ymm9,  xmm5
    vmovdqu       [sum_pq],       ymm9
    vextracti128  xmm5,  ymm5, 1
    vpmovzxwd     ymm9,  xmm5
    vmovdqu       [sum_pq + 64],  ymm9
    vpmovzxwd     ymm9,  xmm6
    vmovdqu       [sum_pq + 32],  ymm9
    vextracti128  xmm6,  ymm6, 1
    vpmovzxwd     ymm9,  xmm6
    vmovdqu       [sum_pq + 96],  ymm9
    vpmovzxwd     ymm9,  xmm7
    vmovdqu       [sum_pq + 128], ymm9
    vextracti128  xmm7,  ymm7, 1
    vpmovzxwd     ymm9,  xmm7
    vmovdqu       [sum_pq + 192], ymm9
    vpmovzxwd     ymm9,  xmm8
    vmovdqu       [sum_pq + 160], ymm9
    vextracti128  xmm8,  ymm8, 1
    vpmovzxwd     ymm9,  xmm8
    vmovdqu       [sum_pq + 224], ymm9
    vmovdqu       [min_pq],       ymm1
    vmovdqu       [min_pq + 32],  ymm2
    vmovdqu       [max_pq],       ymm3
    vmovdqu       [max_pq + 32],  ymm4
    RET
