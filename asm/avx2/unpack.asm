%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
c_shuf:  db 0,1,2,3,4,0xff,0xff,0xff,5,6,7,8,9,0xff,0xff,0xff
         db 0,1,2,3,4,0xff,0xff,0xff,5,6,7,8,9,0xff,0xff,0xff
c_m0:    dq 0x00000000000003ff
c_m1:    dq 0x0000000003ff0000
c_m2:    dq 0x000003ff00000000
c_m3:    dq 0x03ff000000000000

SECTION .text

INIT_YMM avx2
cglobal unpack_10b, 3, 3, 10, src, dst, n
    vmovdqa       m0, [c_shuf]
    vpbroadcastq  m1, [c_m0]
    vpbroadcastq  m2, [c_m1]
    vpbroadcastq  m3, [c_m2]
    vpbroadcastq  m4, [c_m3]
.loop:
%assign g 0
%rep 3
    vmovdqu       xm5, [srcq + g*40]
    vmovdqu       xm9, [srcq + g*40 + 20]
    vinserti128   m5, m5, [srcq + g*40 + 10], 1
    vinserti128   m9, m9, [srcq + g*40 + 30], 1
    vpshufb       m5, m5, m0
    vpshufb       m9, m9, m0
    vpsllq        m6, m5, 6
    vpsllq        m7, m5, 12
    vpsllq        m8, m5, 18
    vpand         m5, m5, m1
    vpand         m6, m6, m2
    vpand         m7, m7, m3
    vpand         m8, m8, m4
    vpor          m5, m5, m6
    vpor          m7, m7, m8
    vpor          m5, m5, m7
    vmovdqu       [dstq + g*64], m5
    vpsllq        m6, m9, 6
    vpsllq        m7, m9, 12
    vpsllq        m8, m9, 18
    vpand         m9, m9, m1
    vpand         m6, m6, m2
    vpand         m7, m7, m3
    vpand         m8, m8, m4
    vpor          m9, m9, m6
    vpor          m7, m7, m8
    vpor          m9, m9, m7
    vmovdqu       [dstq + g*64 + 32], m9
%assign g g+1
%endrep
    add           srcq, 120
    add           dstq, 192
    dec           nq
    jg            .loop
    RET
