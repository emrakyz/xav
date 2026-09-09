%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
init: dd 0.07142857142857142, 0.14285714285714285, 0.21428571428571427, 0.2857142857142857
      dd 0.35714285714285715, 0.42857142857142855, 0.5, 0.5714285714285714
      dd 0.6428571428571429, 0.7142857142857143, 0.7857142857142857, 0.8571428571428571
      dd 0.9285714285714286, 1.0, 1.0714285714285714, 1.1428571428571428

SECTION .text
INIT_YMM avx2
cglobal calc_samp_frames, 2, 2, 3, tot, out
    vcvtsi2ss    xmm0, xmm0, totd
    vbroadcastss ymm0, xmm0
    vmulps       ymm1, ymm0, [rel init]
    vmulps       ymm2, ymm0, [rel init + 32]
    vcvtps2dq    ymm1, ymm1
    vcvtps2dq    ymm2, ymm2
    vmovdqu      [outq],      ymm1
    vmovdqu      [outq + 32], ymm2
    RET
