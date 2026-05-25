%include "dav1d_x86inc.asm"

SECTION .text
INIT_ZMM avx512

%macro FLUSH 0
    vextracti64x4 ymm9, zmm5, 1
    vpmovzxwd     zmm15, ymm5
    vpaddd        zmm11, zmm11, zmm15
    vpmovzxwd     zmm15, ymm9
    vpaddd        zmm12, zmm12, zmm15
    vextracti64x4 ymm9, zmm6, 1
    vpmovzxwd     zmm15, ymm6
    vpaddd        zmm13, zmm13, zmm15
    vpmovzxwd     zmm15, ymm9
    vpaddd        zmm14, zmm14, zmm15
    vpxor         xmm5,  xmm5,  xmm5
    vpxor         xmm6,  xmm6,  xmm6
%endmacro

cglobal crop_col_stats_u8, 7, 8, 16, plane, stride, n, clamp, sum_p, min_p, max_p, ctr
    vpbroadcastb  zmm0, clampd
    vpternlogd    zmm3, zmm3, zmm3, 0xFF
    vpxor         xmm4,  xmm4,  xmm4
    vpxor         xmm5,  xmm5,  xmm5
    vpxor         xmm6,  xmm6,  xmm6
    vpxor         xmm11, xmm11, xmm11
    vpxor         xmm12, xmm12, xmm12
    vpxor         xmm13, xmm13, xmm13
    vpxor         xmm14, xmm14, xmm14
    mov           ctrd, 16
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
    dec           ctrd
    jnz           .check_end
    FLUSH
    mov           ctrd, 16
.check_end:
    test          nq, nq
    jnz           .loop
    FLUSH
    vmovdqu64     [sum_pq + 0],   zmm11
    vmovdqu64     [sum_pq + 64],  zmm12
    vmovdqu64     [sum_pq + 128], zmm13
    vmovdqu64     [sum_pq + 192], zmm14
    vmovdqu64     [min_pq], zmm3
    vmovdqu64     [max_pq], zmm4
    RET
