%include "dav1d_x86inc.asm"

SECTION_RODATA 64

c_pidx:    dd 3, 7, 11, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
c_shuf5:   db 0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80, 0, 1, 3, 4
c_shuf4:   db 0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80, 0, 2, 3
c_m10_16:  db 10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1
c_m100_16: dw 100,1,100,1,100,1,100,1
c_one:     db 1
c_dotb:    db '.'
c_n30b:    db 0xD0
c_1e2d:    dd 0x3C23_D70A

SECTION .text

INIT_ZMM avx512
cglobal atof2, 4, 9, 13
    vmovdqa32       m4, [c_pidx]
    vbroadcasti32x4 m5, [c_shuf5]
    vbroadcasti32x4 m6, [c_shuf4]
    vpbroadcastb    m7, [c_one]
    vpbroadcastb    m8, [c_dotb]
    vpbroadcastb    m9, [c_n30b]
    vbroadcasti32x4 m10, [c_m10_16]
    vbroadcasti32x4 m11, [c_m100_16]
    vpbroadcastd    m12, [c_1e2d]
    lea             r2, [r1+r2*2]
.loop:
    movzx           r4d, word [r1+0]
    movzx           r5d, word [r1+2]
    movzx           r7d, word [r1+4]
    movzx           r8d, word [r1+6]
    vmovdqu         xm0, [r0+r4]
    vinserti32x4    m0, m0, [r0+r5], 1
    vinserti32x4    m0, m0, [r0+r7], 2
    vinserti32x4    m0, m0, [r0+r8], 3
    vpshufb         m1, m0, m7
    vpcmpeqb        k4, m1, m8
    vpaddb          m0, m0, m9
    vpblendmb       m1{k4}, m5, m6
    vpshufb         m0, m0, m1
    vpmaddubsw      m0, m0, m10
    vpmaddwd        m0, m0, m11
    vpermd          m0, m4, m0
    vcvtdq2ps       m0, m0
    vmulps          m0, m0, m12
    vmovdqu         [r3], xm0
    add             r3, 16
    add             r1, 8
    cmp             r1, r2
    jb              .loop
    RET
