%include "dav1d_x86inc.asm"

SECTION .text

INIT_ZMM avx512
cglobal conv_10b, 3, 3, 1, src, dst, n
    xor           eax, eax
.loop:
%assign g 0
%rep 10
    vpmovzxbw     m0, [srcq + rax + g*32]
    vpsllw        m0, m0, 2
    vmovdqu64     [dstq + rax*2 + g*64], m0
%assign g g+1
%endrep
    add           rax, 320
    dec           nq
    jg            .loop
    RET
