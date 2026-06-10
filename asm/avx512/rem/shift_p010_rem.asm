%include "dav1d_x86inc.asm"

SECTION .text

INIT_ZMM avx512
cglobal shift_p010_rem, 3, 4, 8, src, dst, n, tmp
    xor           eax, eax
    cmp           nq, 256
    jb            .blocks
.chunk:
%assign g 0
%rep 8
    vpsrlw        m %+ g, [srcq + rax + g*64], 6
%assign g g+1
%endrep
%assign g 0
%rep 8
    vmovdqu64     [dstq + rax + g*64], m %+ g
%assign g g+1
%endrep
    add           rax, 512
    sub           nq, 256
    cmp           nq, 256
    jae           .chunk
.blocks:
    cmp           nq, 32
    jb            .tail
    vpsrlw        m0, [srcq + rax], 6
    vmovdqu64     [dstq + rax], m0
    add           rax, 64
    sub           nq, 32
    jmp           .blocks
.tail:
    test          nq, nq
    jz            .done
    mov           tmpd, -1
    bzhi          tmpd, tmpd, nd
    kmovd         k1, tmpd
    vpsrlw        m0 {k1}{z}, [srcq + rax], 6
    vmovdqu16     [dstq + rax] {k1}, m0
.done:
    RET
