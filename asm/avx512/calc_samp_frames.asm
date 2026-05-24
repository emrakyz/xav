%include "dav1d_x86inc.asm"

SECTION_RODATA 64
ALIGN 64
init_i1: dd 1.0,  2.0,  3.0,  4.0,  5.0,  6.0,  7.0,  8.0
         dd 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0
init_i2: dd 17.0, 18.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0
         dd 25.0, 26.0, 27.0, 28.0, 29.0, 30.0, 31.0, 32.0
init_i3: dd 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0
         dd 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0
adv48:   times 16 dd 48.0
adv16:   times 16 dd 16.0

SECTION .text
INIT_ZMM avx512
cglobal calc_samp_frames, 3, 3, 9, tot, cnt, out
    vbroadcastss   zmm1, xmm0
    vmovaps        zmm2, [adv48]
    vmovaps        zmm3, [init_i1]
    vmovaps        zmm4, [init_i2]
    vmovaps        zmm5, [init_i3]
    add            cntq, 15
    shr            cntq, 4
    cmp            cntq, 3
    jb             .tail_setup
ALIGN 16
.main:
    vmulps         zmm6, zmm3, zmm1
    vmulps         zmm7, zmm4, zmm1
    vmulps         zmm8, zmm5, zmm1
    vcvtps2udq     zmm6, zmm6
    vcvtps2udq     zmm7, zmm7
    vcvtps2udq     zmm8, zmm8
    vmovdqu32      [outq], zmm6
    vmovdqu32      [outq + 64], zmm7
    vmovdqu32      [outq + 128], zmm8
    vaddps         zmm3, zmm3, zmm2
    vaddps         zmm4, zmm4, zmm2
    vaddps         zmm5, zmm5, zmm2
    add            outq, 192
    sub            cntq, 3
    cmp            cntq, 3
    jae            .main
.tail_setup:
    test           cntq, cntq
    jz             .done
    vmovaps        zmm2, [adv16]
.tail:
    vmulps         zmm6, zmm3, zmm1
    vcvtps2udq     zmm6, zmm6
    vmovdqu32      [outq], zmm6
    vaddps         zmm3, zmm3, zmm2
    add            outq, 64
    sub            cntq, 1
    jnz            .tail
.done:
    RET
