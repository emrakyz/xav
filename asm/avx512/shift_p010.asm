%include "dav1d_x86inc.asm"

SECTION .text

INIT_ZMM avx512
cglobal shift_p010, 3, 3, 1, src, dst, n
    xor           eax, eax
.loop:
%assign g 0
%rep 10
    vpsrlw        m0, [srcq + rax + g*64], 6
    vmovdqu64     [dstq + rax + g*64], m0
%assign g g+1
%endrep
    add           rax, 640
    dec           nq
    jg            .loop
    RET
