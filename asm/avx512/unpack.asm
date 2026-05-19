%include "dav1d_x86inc.asm"

SECTION_RODATA 64

ALIGN 64
u_perm:   db  0, 1, 1, 2, 2, 3, 3, 4, 5, 6, 6, 7, 7, 8, 8, 9
          db 10,11,11,12,12,13,13,14,15,16,16,17,17,18,18,19
          db 20,21,21,22,22,23,23,24,25,26,26,27,27,28,28,29
          db 30,31,31,32,32,33,33,34,35,36,36,37,37,38,38,39
u_shifts: times 8 dw 0, 2, 4, 6
u_mask:   dw 0x03ff

SECTION .text

INIT_ZMM avx512
cglobal unpack_10b, 3, 3, 4, src, dst, n
    vmovdqa64     m0, [u_perm]
    vmovdqa64     m1, [u_shifts]
    vpbroadcastw  m2, [u_mask]
.loop:
    vpermb        m3, m0, [srcq+0]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dstq+0], m3
    vpermb        m3, m0, [srcq+40]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dstq+64], m3
    vpermb        m3, m0, [srcq+80]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dstq+128], m3
    vpermb        m3, m0, [srcq+120]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dstq+192], m3
    vpermb        m3, m0, [srcq+160]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dstq+256], m3
    vpermb        m3, m0, [srcq+200]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dstq+320], m3
    vpermb        m3, m0, [srcq+240]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dstq+384], m3
    vpermb        m3, m0, [srcq+280]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dstq+448], m3
    vpermb        m3, m0, [srcq+320]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dstq+512], m3
    vpermb        m3, m0, [srcq+360]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dstq+576], m3
    vpermb        m3, m0, [srcq+400]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dstq+640], m3
    vpermb        m3, m0, [srcq+440]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dstq+704], m3
    vpermb        m3, m0, [srcq+480]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dstq+768], m3
    vpermb        m3, m0, [srcq+520]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dstq+832], m3
    vpermb        m3, m0, [srcq+560]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dstq+896], m3
    add           srcq, 600
    add           dstq, 960
    dec           nq
    jg            .loop
    RET
