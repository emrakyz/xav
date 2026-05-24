%include "dav1d_x86inc.asm"

SECTION .text
INIT_ZMM avx512
cglobal crop_row_stats_u16, 6, 6, 9, src, n, clamp, sum_p, min_p, max_p
    vpbroadcastw  zmm0, clampd
    vpternlogd    zmm1, zmm1, zmm1, 0xFF
    vpxor         xmm2, xmm2, xmm2
    vpxor         xmm3, xmm3, xmm3
    vpternlogd    zmm4, zmm4, zmm4, 0xFF
    vpxor         xmm5, xmm5, xmm5
    vpxor         xmm6, xmm6, xmm6
    shl           nq, 6
    add           nq, srcq
ALIGN 16
.loop:
    vpmaxuw       zmm7, zmm0, [srcq]
    vpmaxuw       zmm8, zmm0, [srcq + 64]
    add           srcq, 128
    vpaddw        zmm2, zmm7, zmm2
    vpaddw        zmm3, zmm8, zmm3
    vpminuw       zmm1, zmm1, zmm7
    vpminuw       zmm4, zmm4, zmm8
    vpmaxuw       zmm5, zmm5, zmm7
    vpmaxuw       zmm6, zmm6, zmm8
    cmp           srcq, nq
    jb            .loop
    vpaddw        zmm2, zmm2, zmm3
    vpminuw       zmm1, zmm1, zmm4
    vpmaxuw       zmm5, zmm5, zmm6
    vextracti64x4 ymm3, zmm2, 1
    vpmovzxwd     zmm2, ymm2
    vpmovzxwd     zmm3, ymm3
    vpaddd        zmm2, zmm2, zmm3
    vextracti64x4 ymm3, zmm2, 1
    vpaddd        ymm2, ymm2, ymm3
    vextracti128  xmm3, ymm2, 1
    vpaddd        xmm2, xmm2, xmm3
    vpshufd       xmm3, xmm2, 0xee
    vpaddd        xmm2, xmm2, xmm3
    vpshufd       xmm3, xmm2, 0x55
    vpaddd        xmm2, xmm2, xmm3
    vmovd         [sum_pq], xmm2
    vextracti64x4 ymm3, zmm1, 1
    vpminuw       ymm1, ymm1, ymm3
    vextracti128  xmm3, ymm1, 1
    vpminuw       xmm1, xmm1, xmm3
    vphminposuw   xmm1, xmm1
    vpextrw       [min_pq], xmm1, 0
    vextracti64x4 ymm3, zmm5, 1
    vpmaxuw       ymm5, ymm5, ymm3
    vextracti128  xmm3, ymm5, 1
    vpmaxuw       xmm5, xmm5, xmm3
    vpternlogq    xmm5, xmm5, xmm5, 0x0F
    vphminposuw   xmm5, xmm5
    vmovd         eax, xmm5
    not           eax
    mov           [max_pq], ax
    RET

