%include "dav1d_x86inc.asm"

SECTION .text
INIT_YMM avx2
cglobal crop_row_stats_u8, 6, 6, 16, src, n, clamp, sum_p, min_p, max_p
    vmovd         xmm0, clampd
    vpbroadcastb  ymm0, xmm0
    vpxor         xmm1, xmm1, xmm1
    vpcmpeqb      ymm2, ymm2, ymm2
    vpcmpeqb      ymm5, ymm5, ymm5
    vpxor         xmm3, xmm3, xmm3
    vpxor         xmm6, xmm6, xmm6
    vpxor         xmm4, xmm4, xmm4
    vpxor         xmm7, xmm7, xmm7
    shl           nq, 5
    add           nq, srcq
ALIGN 16
.loop:
    vpmaxub  ymm8,  ymm0, [srcq]
    vpmaxub  ymm9,  ymm0, [srcq + 32]
    vpmaxub  ymm12, ymm0, [srcq + 128]
    vpmaxub  ymm10, ymm0, [srcq + 64]
    vpmaxub  ymm11, ymm0, [srcq + 96]
    vpmaxub  ymm13, ymm0, [srcq + 160]
    add      srcq, 192
    vpsadbw  ymm14, ymm8,  ymm1
    vpsadbw  ymm15, ymm12, ymm1
    vpminub  ymm2,  ymm8,  ymm2
    vpmaxub  ymm3,  ymm8,  ymm3
    vpmaxub  ymm8,  ymm10, ymm12
    vpminub  ymm5,  ymm9,  ymm5
    vpmaxub  ymm6,  ymm9,  ymm6
    vpmaxub  ymm3,  ymm8,  ymm3
    vpmaxub  ymm8,  ymm11, ymm13
    vpmaxub  ymm6,  ymm8,  ymm6
    vpaddq   ymm4,  ymm14, ymm4
    vpsadbw  ymm14, ymm9,  ymm1
    vpaddq   ymm7,  ymm14, ymm7
    vpsadbw  ymm14, ymm10, ymm1
    vpaddq   ymm14, ymm14, ymm15
    vpsadbw  ymm15, ymm11, ymm1
    vpaddq   ymm4,  ymm14, ymm4
    vpsadbw  ymm14, ymm13, ymm1
    vpaddq   ymm14, ymm15, ymm14
    vpminub  ymm15, ymm11, ymm13
    vpaddq   ymm7,  ymm14, ymm7
    vpminub  ymm14, ymm10, ymm12
    vpminub  ymm5,  ymm15, ymm5
    vpminub  ymm2,  ymm14, ymm2
    cmp      srcq, nq
    jb       .loop
    vpaddq   ymm4, ymm4, ymm7
    vextracti128  xmm8, ymm4, 1
    vpaddq   xmm4, xmm4, xmm8
    vpshufd  xmm8, xmm4, 0xee
    vpaddq   xmm4, xmm4, xmm8
    vmovd    [sum_pq], xmm4
    vpminub  ymm2, ymm2, ymm5
    vextracti128  xmm8, ymm2, 1
    vpminub  xmm2, xmm2, xmm8
    vpsrlw   xmm8, xmm2, 8
    vpminub  xmm2, xmm2, xmm8
    vphminposuw  xmm2, xmm2
    vmovd    eax, xmm2
    mov      [min_pq], al
    vpmaxub  ymm3, ymm3, ymm6
    vextracti128  xmm8, ymm3, 1
    vpmaxub  xmm3, xmm3, xmm8
    vpcmpeqb xmm8, xmm8, xmm8
    vpxor    xmm3, xmm3, xmm8
    vpsrlw   xmm8, xmm3, 8
    vpminub  xmm3, xmm3, xmm8
    vphminposuw  xmm3, xmm3
    vmovd    eax, xmm3
    not      al
    mov      [max_pq], al
    RET
