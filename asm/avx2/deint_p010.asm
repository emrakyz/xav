%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
c_shuf:  db 0,1,4,5,8,9,12,13,2,3,6,7,10,11,14,15
         db 0,1,4,5,8,9,12,13,2,3,6,7,10,11,14,15

SECTION .text

INIT_YMM avx2
cglobal deint_p010, 4, 4, 16, src, ud, vd, n
    vmovdqa       m0, [c_shuf]
    xor           eax, eax
.loop:
%assign g 0
%rep 10
    %assign ai 1 + (g % 5)
    %assign bi 6 + (g % 5)
    %assign ui 11 + (g % 5)
    vmovdqu       m %+ ai, [srcq + rax*2 + g*64]
    vmovdqu       m %+ bi, [srcq + rax*2 + g*64 + 32]
    vpsrlw        m %+ ai, m %+ ai, 6
    vpsrlw        m %+ bi, m %+ bi, 6
    vpshufb       m %+ ai, m %+ ai, m0
    vpshufb       m %+ bi, m %+ bi, m0
    vpunpcklqdq   m %+ ui, m %+ ai, m %+ bi
    vpunpckhqdq   m %+ ai, m %+ ai, m %+ bi
    vpermq        m %+ ui, m %+ ui, 0xd8
    vpermq        m %+ ai, m %+ ai, 0xd8
    vmovdqu       [udq + rax + g*32], m %+ ui
    vmovdqu       [vdq + rax + g*32], m %+ ai
    %assign g g+1
%endrep
    add           rax, 320
    dec           nq
    jg            .loop
    RET
