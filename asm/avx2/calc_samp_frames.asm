%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
init: dd 1.0,  2.0,  3.0,  4.0,  5.0,  6.0,  7.0,  8.0
      dd 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0

SECTION .text
INIT_YMM avx2
cglobal calc_samp_frames, 4, 4, 3, step, tot, cnt, out
    vmovd          xmm0, stepd
    vbroadcastss   ymm0, xmm0
    vmulps         ymm1, ymm0, [init]
    vmulps         ymm2, ymm0, [init + 32]
    vcvtps2dq      ymm1, ymm1
    vcvtps2dq      ymm2, ymm2
    vmovdqu        [outq],      ymm1
    vmovdqu        [outq + 32], ymm2
    RET
