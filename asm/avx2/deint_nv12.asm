%include "dav1d_x86inc.asm"

SECTION_RODATA 32
c_mask:  dw 0x00ff

SECTION .text

INIT_YMM avx2
cglobal deint_nv12, 4, 4, 13, src, ud, vd, n
    vpbroadcastw  m0, [c_mask]
    xor           eax, eax
.loop:
%assign g 0
%rep 10
    %assign ai 1  + (g % 3)
    %assign bi 4  + (g % 3)
    %assign ci 7  + (g % 3)
    %assign di 10 + (g % 3)
    vmovdqu       m %+ ai, [srcq + rax*2 + g*64]
    vmovdqu       m %+ bi, [srcq + rax*2 + g*64 + 32]
    vpand         m %+ ci, m %+ ai, m0
    vpsrlw        m %+ ai, m %+ ai, 8
    vpand         m %+ di, m %+ bi, m0
    vpsrlw        m %+ bi, m %+ bi, 8
    vpackuswb     m %+ ci, m %+ ci, m %+ di
    vpackuswb     m %+ ai, m %+ ai, m %+ bi
    vpermq        m %+ ci, m %+ ci, 0xd8
    vpermq        m %+ ai, m %+ ai, 0xd8
    vmovdqu       [udq + rax + g*32], m %+ ci
    vmovdqu       [vdq + rax + g*32], m %+ ai
    %assign g g+1
%endrep
    add           rax, 320
    dec           nq
    jg            .loop
    RET
