%include "dav1d_x86inc.asm"

SECTION_RODATA 64
nt_mask: dw 0x03fc

SECTION .text

INIT_ZMM avx512
cglobal deint_nv12_10b, 4, 4, 3, src, ud, vd, n
    vpbroadcastw  m0, [nt_mask]
    xor           eax, eax
.loop:
%assign g 0
%rep 20
    vpsllw        m1, [srcq + rax + g*64], 2
    vpandq        m1, m1, m0
    vpsrlw        m2, [srcq + rax + g*64], 6
    vpandq        m2, m2, m0
    vmovdqu64     [udq + rax + g*64], m1
    vmovdqu64     [vdq + rax + g*64], m2
%assign g g+1
%endrep
    add           rax, 1280
    dec           nq
    jg            .loop
    RET
