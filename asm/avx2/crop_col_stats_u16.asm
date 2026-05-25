%include "dav1d_x86inc.asm"

SECTION .text
INIT_YMM avx2

%macro FLUSH 0
    vpmovzxwd     ymm13, xmm9
    vmovdqu       ymm14, [sum_pq + 0]
    vpaddd        ymm13, ymm13, ymm14
    vmovdqu       [sum_pq + 0], ymm13
    vextracti128  xmm15, ymm9, 1
    vpmovzxwd     ymm13, xmm15
    vmovdqu       ymm14, [sum_pq + 32]
    vpaddd        ymm13, ymm13, ymm14
    vmovdqu       [sum_pq + 32], ymm13
    vpmovzxwd     ymm13, xmm10
    vmovdqu       ymm14, [sum_pq + 64]
    vpaddd        ymm13, ymm13, ymm14
    vmovdqu       [sum_pq + 64], ymm13
    vextracti128  xmm15, ymm10, 1
    vpmovzxwd     ymm13, xmm15
    vmovdqu       ymm14, [sum_pq + 96]
    vpaddd        ymm13, ymm13, ymm14
    vmovdqu       [sum_pq + 96], ymm13
    vpmovzxwd     ymm13, xmm11
    vmovdqu       ymm14, [sum_pq + 128]
    vpaddd        ymm13, ymm13, ymm14
    vmovdqu       [sum_pq + 128], ymm13
    vextracti128  xmm15, ymm11, 1
    vpmovzxwd     ymm13, xmm15
    vmovdqu       ymm14, [sum_pq + 160]
    vpaddd        ymm13, ymm13, ymm14
    vmovdqu       [sum_pq + 160], ymm13
    vpmovzxwd     ymm13, xmm12
    vmovdqu       ymm14, [sum_pq + 192]
    vpaddd        ymm13, ymm13, ymm14
    vmovdqu       [sum_pq + 192], ymm13
    vextracti128  xmm15, ymm12, 1
    vpmovzxwd     ymm13, xmm15
    vmovdqu       ymm14, [sum_pq + 224]
    vpaddd        ymm13, ymm13, ymm14
    vmovdqu       [sum_pq + 224], ymm13
    vpxor         xmm9,  xmm9,  xmm9
    vpxor         xmm10, xmm10, xmm10
    vpxor         xmm11, xmm11, xmm11
    vpxor         xmm12, xmm12, xmm12
%endmacro

cglobal crop_col_stats_u16, 7, 8, 16, plane, stride, n, clamp, sum_p, min_p, max_p, ctr
    vmovd         xmm0, clampd
    vpbroadcastw  ymm0, xmm0
    vpcmpeqb      ymm1, ymm1, ymm1
    vpcmpeqb      ymm2, ymm2, ymm2
    vpcmpeqb      ymm3, ymm3, ymm3
    vpcmpeqb      ymm4, ymm4, ymm4
    vpxor         xmm5, xmm5, xmm5
    vpxor         xmm6, xmm6, xmm6
    vpxor         xmm7, xmm7, xmm7
    vpxor         xmm8, xmm8, xmm8
    vpxor         xmm9,  xmm9,  xmm9
    vpxor         xmm10, xmm10, xmm10
    vpxor         xmm11, xmm11, xmm11
    vpxor         xmm12, xmm12, xmm12
    vpxor         xmm13, xmm13, xmm13
    vmovdqu       [sum_pq + 0],   ymm13
    vmovdqu       [sum_pq + 32],  ymm13
    vmovdqu       [sum_pq + 64],  ymm13
    vmovdqu       [sum_pq + 96],  ymm13
    vmovdqu       [sum_pq + 128], ymm13
    vmovdqu       [sum_pq + 160], ymm13
    vmovdqu       [sum_pq + 192], ymm13
    vmovdqu       [sum_pq + 224], ymm13
    mov           ctrd, 16
ALIGN 16
.loop:
%rep 2
    vpmaxuw       ymm14, ymm0, [planeq + 32]
    vpmaxuw       ymm15, ymm0, [planeq + 64]
    vpmaxuw       ymm13, ymm0, [planeq]
    vpaddw        ymm10, ymm10, ymm14
    vpminuw       ymm2,  ymm2,  ymm14
    vpmaxuw       ymm6,  ymm6,  ymm14
    vpmaxuw       ymm14, ymm0, [planeq + 96]
    vpaddw        ymm11, ymm11, ymm15
    vpminuw       ymm3,  ymm3,  ymm15
    vpmaxuw       ymm7,  ymm7,  ymm15
    vpmaxuw       ymm15, ymm0, [planeq + strideq]
    vpaddw        ymm9,  ymm9,  ymm13
    vpminuw       ymm1,  ymm1,  ymm13
    vpmaxuw       ymm5,  ymm5,  ymm13
    vpaddw        ymm12, ymm12, ymm14
    vpminuw       ymm4,  ymm4,  ymm14
    vpmaxuw       ymm8,  ymm8,  ymm14
    vpmaxuw       ymm14, ymm0, [planeq + strideq + 32]
    vpaddw        ymm9,  ymm9,  ymm15
    vpminuw       ymm1,  ymm1,  ymm15
    vpmaxuw       ymm5,  ymm5,  ymm15
    vpmaxuw       ymm15, ymm0, [planeq + strideq + 64]
    vpaddw        ymm10, ymm10, ymm14
    vpminuw       ymm2,  ymm2,  ymm14
    vpmaxuw       ymm6,  ymm6,  ymm14
    vpmaxuw       ymm14, ymm0, [planeq + strideq + 96]
    vpaddw        ymm11, ymm11, ymm15
    vpminuw       ymm3,  ymm3,  ymm15
    vpmaxuw       ymm7,  ymm7,  ymm15
    vpaddw        ymm12, ymm12, ymm14
    vpminuw       ymm4,  ymm4,  ymm14
    vpmaxuw       ymm8,  ymm8,  ymm14
    lea           planeq, [planeq + strideq*2]
%endrep
    sub           nq, 4
    dec           ctrd
    jnz           .check_end
    FLUSH
    mov           ctrd, 16
.check_end:
    test          nq, nq
    jnz           .loop
    FLUSH
    vmovdqu       [min_pq + 0],   ymm1
    vmovdqu       [min_pq + 32],  ymm2
    vmovdqu       [min_pq + 64],  ymm3
    vmovdqu       [min_pq + 96],  ymm4
    vmovdqu       [max_pq + 0],   ymm5
    vmovdqu       [max_pq + 32],  ymm6
    vmovdqu       [max_pq + 64],  ymm7
    vmovdqu       [max_pq + 96],  ymm8
    RET
