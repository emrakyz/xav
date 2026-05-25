%include "dav1d_x86inc.asm"

SECTION_RODATA 64
ALIGN 64
init: dd 1.0,  2.0,  3.0,  4.0,  5.0,  6.0,  7.0,  8.0
      dd 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0

SECTION .text
INIT_ZMM avx512
cglobal calc_samp_frames, 4, 4, 2, step, tot, cnt, out
    vpbroadcastd   zmm1, stepd
    vmulps         zmm0, zmm1, [init]
    vcvtps2udq     zmm0, zmm0
    vmovdqu32      [outq], zmm0
    RET
