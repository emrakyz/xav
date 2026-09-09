%include "dav1d_x86inc.asm"

SECTION_RODATA 64
ALIGN 64
init: dd 0.07142857142857142, 0.14285714285714285, 0.21428571428571427, 0.2857142857142857
      dd 0.35714285714285715, 0.42857142857142855, 0.5, 0.5714285714285714
      dd 0.6428571428571429, 0.7142857142857143, 0.7857142857142857, 0.8571428571428571
      dd 0.9285714285714286, 1.0, 1.0714285714285714, 1.1428571428571428

SECTION .text
INIT_ZMM avx512
cglobal calc_samp_frames, 2, 2, 1, tot, out
    vcvtusi2ss   xmm0, xmm0, totd
    vbroadcastss zmm0, xmm0
    vmulps       zmm0, zmm0, [rel init]
    vcvtps2udq   zmm0, zmm0
    vmovdqu32    [outq], zmm0
    RET
