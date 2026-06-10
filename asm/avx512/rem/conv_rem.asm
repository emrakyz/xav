%include "dav1d_x86inc.asm"

SECTION .text

INIT_ZMM avx512
cglobal conv_10b_rem, 3, 4, 8, src, dst, n, tmp
    xor           eax, eax
    cmp           nq, 256
    jb            .blocks
.chunk:
%assign g 0
%rep 8
    vpmovzxbw     m %+ g, [srcq + rax + g*32]
%assign g g+1
%endrep
%assign g 0
%rep 8
    vpsllw        m %+ g, m %+ g, 2
%assign g g+1
%endrep
%assign g 0
%rep 8
    vmovdqu64     [dstq + rax*2 + g*64], m %+ g
%assign g g+1
%endrep
    add           rax, 256
    sub           nq, 256
    cmp           nq, 256
    jae           .chunk
.blocks:
    cmp           nq, 32
    jb            .tail
    vpmovzxbw     m0, [srcq + rax]
    vpsllw        m0, m0, 2
    vmovdqu64     [dstq + rax*2], m0
    add           rax, 32
    sub           nq, 32
    jmp           .blocks
.tail:
    test          nq, nq
    jz            .done
    mov           tmpd, -1
    bzhi          tmpd, tmpd, nd
    kmovd         k1, tmpd
    vpmovzxbw     m0 {k1}{z}, [srcq + rax]
    vpsllw        m0, m0, 2
    vmovdqu16     [dstq + rax*2] {k1}, m0
.done:
    RET
