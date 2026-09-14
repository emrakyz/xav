%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
init: dd 73, 146, 219, 292, 365, 438, 511, 584
      dd 657, 730, 803, 876, 949, 1022, 1095, 1168

SECTION .text
INIT_YMM avx2
cglobal calc_samp_frames, 2, 2, 3, tot, out
    vmovd        xmm0, totd
    vpbroadcastd ymm0, xmm0
    vpmulld      ymm1, ymm0, [rel init]
    vpmulld      ymm2, ymm0, [rel init + 32]
    vpsrld       ymm1, ymm1, 10
    vpsrld       ymm2, ymm2, 10
    vmovdqu      [outq],      ymm1
    vmovdqu      [outq + 32], ymm2
    RET
