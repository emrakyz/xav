%include "dav1d_x86inc.asm"

SECTION .text

INIT_YMM avx2
cglobal shift_p010, 3, 3, 1, src, dst, n
    xor           eax, eax
.loop:
%assign g 0
%rep 10
    vmovdqu       m0, [srcq + rax + g*32]
    vpsrlw        m0, m0, 6
    vmovdqu       [dstq + rax + g*32], m0
%assign g g+1
%endrep
    add           rax, 320
    dec           nq
    jg            .loop
    RET
