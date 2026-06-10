%include "dav1d_x86inc.asm"

SECTION .text

INIT_YMM avx2
cglobal conv_10b_rem, 3, 4, 4, src, dst, n, tmp
    xor           eax, eax
    cmp           nq, 256
    jb            .blocks
.chunk:
%assign g 0
%rep 16
    %assign r (g % 4)
    vpmovzxbw     m %+ r, [srcq + rax + g*16]
    vpsllw        m %+ r, m %+ r, 2
    vmovdqu       [dstq + rax*2 + g*32], m %+ r
%assign g g+1
%endrep
    add           rax, 256
    sub           nq, 256
    cmp           nq, 256
    jae           .chunk
.blocks:
    cmp           nq, 16
    jb            .tail
    vpmovzxbw     m0, [srcq + rax]
    vpsllw        m0, m0, 2
    vmovdqu       [dstq + rax*2], m0
    add           rax, 16
    sub           nq, 16
    jmp           .blocks
.tail:
    test          nq, nq
    jz            .done
.tloop:
    movzx         tmpd, byte [srcq + rax]
    shl           tmpd, 2
    mov           [dstq + rax*2], tmpw
    add           rax, 1
    sub           nq, 1
    jnz           .tloop
.done:
    RET
