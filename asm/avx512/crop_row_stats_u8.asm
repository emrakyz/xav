%include "dav1d_x86inc.asm"

SECTION_RODATA 64
ALIGN 64
ones: times 64 db 1

SECTION .text
INIT_ZMM avx512
cglobal crop_row_stats_u8, 6, 6, 12, src, n, clamp, sum_p, min_p, max_p
    vpbroadcastb  zmm1, clampd
    vpxorq        zmm2, zmm2, zmm2
    vpternlogd    zmm3, zmm3, zmm3, 0xFF
    vpxorq        zmm4, zmm4, zmm4
    vmovdqa64     zmm7, [rel ones]
    vpxorq        zmm8, zmm8, zmm8
    vpternlogd    zmm9, zmm9, zmm9, 0xFF
    vpxorq        zmm10, zmm10, zmm10
    shl           nq, 6
    add           nq, srcq
ALIGN 16
.loop:
%rep 3
    vpmaxub       zmm0, zmm1, [srcq]
    vpmaxub       zmm11, zmm1, [srcq + 64]
    add           srcq, 128
    vpdpbusd      zmm2, zmm0, zmm7
    vpdpbusd      zmm8, zmm11, zmm7
    vpminub       zmm3, zmm3, zmm0
    vpminub       zmm9, zmm9, zmm11
    vpmaxub       zmm4, zmm4, zmm0
    vpmaxub       zmm10, zmm10, zmm11
%endrep
    cmp           srcq, nq
    jb            .loop
    vpaddd        zmm2, zmm2, zmm8
    vpminub       zmm3, zmm3, zmm9
    vpmaxub       zmm4, zmm4, zmm10
    vextracti64x4 ymm6, zmm2, 1
    vpaddd        ymm2, ymm2, ymm6
    vextracti128  xmm6, ymm2, 1
    vpaddd        xmm2, xmm2, xmm6
    vpshufd       xmm6, xmm2, 0xee
    vpaddd        xmm2, xmm2, xmm6
    vpshufd       xmm6, xmm2, 0x55
    vpaddd        xmm2, xmm2, xmm6
    vmovd         eax, xmm2
    mov           [sum_pq], eax
    vextracti64x4 ymm6, zmm3, 1
    vpminub       ymm3, ymm3, ymm6
    vextracti128  xmm6, ymm3, 1
    vpminub       xmm3, xmm3, xmm6
    vpsrlw        xmm6, xmm3, 8
    vpminub       xmm3, xmm3, xmm6
    vphminposuw   xmm3, xmm3
    vmovd         eax, xmm3
    mov           [min_pq], al
    vextracti64x4 ymm6, zmm4, 1
    vpmaxub       ymm4, ymm4, ymm6
    vextracti128  xmm6, ymm4, 1
    vpmaxub       xmm4, xmm4, xmm6
    vpternlogq    xmm4, xmm4, xmm4, 0x0F
    vpsrlw        xmm6, xmm4, 8
    vpminub       xmm4, xmm4, xmm6
    vphminposuw   xmm4, xmm4
    vmovd         eax, xmm4
    not           al
    mov           [max_pq], al
    RET
