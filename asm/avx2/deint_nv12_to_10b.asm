%include "dav1d_x86inc.asm"

SECTION_RODATA 32
c_mask:  dw 0x00ff

SECTION .text

INIT_YMM avx2
cglobal deint_nv12_to_10b, 4, 4, 5, src, ud, vd, n
    vpbroadcastw  m0, [c_mask]
    xor           eax, eax
.loop:
%assign g 0
%rep 10
    vmovdqu       m1, [srcq + rax + g*64]
    vmovdqu       m2, [srcq + rax + g*64 + 32]
    vpand         m3, m1, m0
    vpsrlw        m1, m1, 8
    vpand         m4, m2, m0
    vpsrlw        m2, m2, 8
    vpsllw        m3, m3, 2
    vpsllw        m1, m1, 2
    vpsllw        m4, m4, 2
    vpsllw        m2, m2, 2
    vmovdqu       [udq + rax + g*64], m3
    vmovdqu       [udq + rax + g*64 + 32], m4
    vmovdqu       [vdq + rax + g*64], m1
    vmovdqu       [vdq + rax + g*64 + 32], m2
%assign g g+1
%endrep
    add           rax, 640
    dec           nq
    jg            .loop
    RET
