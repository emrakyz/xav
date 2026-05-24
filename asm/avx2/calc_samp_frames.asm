%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
init_i1: dd 1.0,  2.0,  3.0,  4.0,  5.0,  6.0,  7.0,  8.0
init_i2: dd 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0
init_i3: dd 17.0, 18.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0
init_i4: dd 25.0, 26.0, 27.0, 28.0, 29.0, 30.0, 31.0, 32.0
init_i5: dd 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0
adv40:   times 8 dd 40.0
adv8:    times 8 dd 8.0

SECTION .text
INIT_YMM avx2
cglobal calc_samp_frames, 3, 3, 12, tot, cnt, out
    vbroadcastss   ymm0, xmm0
    vbroadcastss   ymm1, [rel adv40]
    vmovaps        ymm2, [init_i1]
    vmovaps        ymm3, [init_i2]
    vmovaps        ymm4, [init_i3]
    vmovaps        ymm5, [init_i4]
    vmovaps        ymm6, [init_i5]
    add            cntq, 7
    shr            cntq, 3
    cmp            cntq, 5
    jb             .tail_setup
ALIGN 32
.main:
    vmulps         ymm7,  ymm2, ymm0
    vmulps         ymm8,  ymm3, ymm0
    vmulps         ymm9,  ymm4, ymm0
    vmulps         ymm10, ymm5, ymm0
    vmulps         ymm11, ymm6, ymm0
    vaddps         ymm2, ymm2, ymm1
    vaddps         ymm3, ymm3, ymm1
    vaddps         ymm4, ymm4, ymm1
    vaddps         ymm5, ymm5, ymm1
    vaddps         ymm6, ymm6, ymm1
    sub            cntq, 5
    vcvtps2dq      ymm7,  ymm7
    vcvtps2dq      ymm8,  ymm8
    vcvtps2dq      ymm9,  ymm9
    vcvtps2dq      ymm10, ymm10
    vcvtps2dq      ymm11, ymm11
    vmovdqu        [outq],       ymm7
    vmovdqu        [outq + 32],  ymm8
    vmovdqu        [outq + 64],  ymm9
    vmovdqu        [outq + 96],  ymm10
    vmovdqu        [outq + 128], ymm11
    add            outq, 160
    cmp            cntq, 4
    ja             .main
.tail_setup:
    test           cntq, cntq
    jz             .done
    vbroadcastss   ymm1, [rel adv8]
.tail:
    vmulps         ymm7, ymm2, ymm0
    vcvtps2dq      ymm7, ymm7
    vmovdqu        [outq], ymm7
    vaddps         ymm2, ymm2, ymm1
    add            outq, 32
    sub            cntq, 1
    jnz            .tail
.done:
    RET
