%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
u_spread: db 0,1, 1,2, 2,3, 3,4, 5,6, 6,7, 7,8, 8,9
u_mults:  dq 0x0400100040000000
u_mask:   dw 0x03ff

SECTION .text

INIT_YMM avx2
cglobal unpack_10b, 3, 3, 15, src, dst, n
    vbroadcasti128 m0, [u_spread]
    vpbroadcastq   m1, [u_mults]
    vpbroadcastw   m2, [u_mask]
.loop:
    vmovdqu       xm3,  [srcq +   0]
    vinserti128   m3,  m3,  [srcq +  10], 1
    vmovdqu       xm5,  [srcq +  20]
    vinserti128   m5,  m5,  [srcq +  30], 1
    vmovdqu       xm7,  [srcq +  40]
    vinserti128   m7,  m7,  [srcq +  50], 1
    vmovdqu       xm9,  [srcq +  60]
    vinserti128   m9,  m9,  [srcq +  70], 1
    vmovdqu       xm11, [srcq +  80]
    vinserti128   m11, m11, [srcq +  90], 1
    vmovdqu       xm13, [srcq + 100]
    vinserti128   m13, m13, [srcq + 110], 1
    vpshufb       m3,  m3,  m0
    vpshufb       m5,  m5,  m0
    vpshufb       m7,  m7,  m0
    vpshufb       m9,  m9,  m0
    vpshufb       m11, m11, m0
    vpshufb       m13, m13, m0
    vpmulhuw      m4,  m3,  m1
    vpmulhuw      m6,  m5,  m1
    vpmulhuw      m8,  m7,  m1
    vpmulhuw      m10, m9,  m1
    vpmulhuw      m12, m11, m1
    vpmulhuw      m14, m13, m1
    vpblendw      m4,  m4,  m3,  0x11
    vpblendw      m6,  m6,  m5,  0x11
    vpblendw      m8,  m8,  m7,  0x11
    vpblendw      m10, m10, m9,  0x11
    vpblendw      m12, m12, m11, 0x11
    vpblendw      m14, m14, m13, 0x11
    vpand         m4,  m4,  m2
    vpand         m6,  m6,  m2
    vpand         m8,  m8,  m2
    vpand         m10, m10, m2
    vpand         m12, m12, m2
    vpand         m14, m14, m2
    vmovdqu       [dstq +   0], m4
    vmovdqu       [dstq +  32], m6
    vmovdqu       [dstq +  64], m8
    vmovdqu       [dstq +  96], m10
    vmovdqu       [dstq + 128], m12
    vmovdqu       [dstq + 160], m14
    add           srcq, 120
    add           dstq, 192
    dec           nq
    jg            .loop
    RET
