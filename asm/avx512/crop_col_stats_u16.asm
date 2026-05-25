%include "dav1d_x86inc.asm"

SECTION .text
INIT_ZMM avx512

%macro FLUSH 0
    vextracti64x4 ymm17, zmm7, 1
    vpmovzxwd     zmm9,  ymm7
    vpaddd        zmm13, zmm13, zmm9
    vpmovzxwd     zmm9,  ymm17
    vpaddd        zmm14, zmm14, zmm9
    vextracti64x4 ymm17, zmm8, 1
    vpmovzxwd     zmm9,  ymm8
    vpaddd        zmm15, zmm15, zmm9
    vpmovzxwd     zmm9,  ymm17
    vpaddd        zmm16, zmm16, zmm9
    vpxor         xmm7,  xmm7,  xmm7
    vpxor         xmm8,  xmm8,  xmm8
%endmacro

cglobal crop_col_stats_u16, 7, 8, 18, plane, stride, n, clamp, sum_p, min_p, max_p, ctr
    vpbroadcastw  zmm0, clampd
    vpternlogd    zmm3, zmm3, zmm3, 0xFF
    vpternlogd    zmm4, zmm4, zmm4, 0xFF
    vpxor         xmm5,  xmm5,  xmm5
    vpxor         xmm6,  xmm6,  xmm6
    vpxor         xmm7,  xmm7,  xmm7
    vpxor         xmm8,  xmm8,  xmm8
    vpxor         xmm13, xmm13, xmm13
    vpxor         xmm14, xmm14, xmm14
    vpxor         xmm15, xmm15, xmm15
    vpxor         xmm16, xmm16, xmm16
    mov           ctrd, 4
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
    dec           ctrd
    jnz           .check_end
    FLUSH
    mov           ctrd, 4
.check_end:
    test          nq, nq
    jnz           .loop
    FLUSH
    vmovdqu64     [sum_pq + 0],   zmm13
    vmovdqu64     [sum_pq + 64],  zmm14
    vmovdqu64     [sum_pq + 128], zmm15
    vmovdqu64     [sum_pq + 192], zmm16
    vmovdqu64     [min_pq + 0],  zmm3
    vmovdqu64     [min_pq + 64], zmm4
    vmovdqu64     [max_pq + 0],  zmm5
    vmovdqu64     [max_pq + 64], zmm6
    RET
