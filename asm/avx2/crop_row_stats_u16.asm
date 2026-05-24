%include "dav1d_x86inc.asm"

SECTION .text
INIT_YMM avx2
cglobal crop_row_stats_u16, 6, 6, 16, src, n, clamp, sum_p, min_p, max_p
    vmovd         xmm0, clampd
    vpbroadcastw  ymm0, xmm0
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
    vpmaxuw  ymm8,  ymm0, [srcq]
    vpmaxuw  ymm9,  ymm0, [srcq + 32]
    vpmaxuw  ymm12, ymm0, [srcq + 128]
    vpmaxuw  ymm10, ymm0, [srcq + 64]
    vpmaxuw  ymm11, ymm0, [srcq + 96]
    vpmaxuw  ymm13, ymm0, [srcq + 160]
    add      srcq, 192
    vpaddw   ymm4,  ymm8,  ymm4
    vpaddw   ymm14, ymm10, ymm12
    vpaddw   ymm4,  ymm4,  ymm14
    vpaddw   ymm7,  ymm9,  ymm7
    vpaddw   ymm14, ymm11, ymm13
    vpaddw   ymm7,  ymm7,  ymm14
    vpminuw  ymm2,  ymm8,  ymm2
    vpminuw  ymm14, ymm10, ymm12
    vpminuw  ymm2,  ymm2,  ymm14
    vpminuw  ymm5,  ymm9,  ymm5
    vpminuw  ymm14, ymm11, ymm13
    vpminuw  ymm5,  ymm5,  ymm14
    vpmaxuw  ymm3,  ymm8,  ymm3
    vpmaxuw  ymm14, ymm10, ymm12
    vpmaxuw  ymm3,  ymm3,  ymm14
    vpmaxuw  ymm6,  ymm9,  ymm6
    vpmaxuw  ymm14, ymm11, ymm13
    vpmaxuw  ymm6,  ymm6,  ymm14
    cmp      srcq, nq
    jb       .loop
    vextracti128  xmm8, ymm4, 1
    vpmovzxwd     ymm4, xmm4
    vpmovzxwd     ymm8, xmm8
    vpaddd        ymm4, ymm4, ymm8
    vextracti128  xmm8, ymm7, 1
    vpmovzxwd     ymm7, xmm7
    vpmovzxwd     ymm8, xmm8
    vpaddd        ymm7, ymm7, ymm8
    vpaddd        ymm4, ymm4, ymm7
    vextracti128  xmm8, ymm4, 1
    vpaddd        xmm4, xmm4, xmm8
    vpshufd       xmm8, xmm4, 0xee
    vpaddd        xmm4, xmm4, xmm8
    vpshufd       xmm8, xmm4, 0x55
    vpaddd        xmm4, xmm4, xmm8
    vmovd         [sum_pq], xmm4
    vpminuw       ymm2, ymm2, ymm5
    vextracti128  xmm8, ymm2, 1
    vpminuw       xmm2, xmm2, xmm8
    vphminposuw   xmm2, xmm2
    vmovd         eax, xmm2
    mov           [min_pq], ax
    vpmaxuw       ymm3, ymm3, ymm6
    vextracti128  xmm8, ymm3, 1
    vpmaxuw       xmm3, xmm3, xmm8
    vpcmpeqb      xmm8, xmm8, xmm8
    vpxor         xmm3, xmm3, xmm8
    vphminposuw   xmm3, xmm3
    vmovd         eax, xmm3
    not           ax
    mov           [max_pq], ax
    RET
