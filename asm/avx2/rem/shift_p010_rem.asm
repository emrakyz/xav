%include "dav1d_x86inc.asm"

SECTION .text

INIT_YMM avx2
cglobal shift_p010_rem, 3, 5, 16, src, dst, n, idx, lim
    lea           limq, [nq*2]
    xor           idxq, idxq
    mov           rax, limq
    and           rax, -512
    jz            .blocks
.chunk:
%assign g 0
%rep 16
    vmovdqu       m %+ g, [srcq + idxq + g*32]
    vpsrlw        m %+ g, m %+ g, 6
%assign g g+1
%endrep
%assign g 0
%rep 16
    vmovdqu       [dstq + idxq + g*32], m %+ g
%assign g g+1
%endrep
    add           idxq, 512
    cmp           idxq, rax
    jb            .chunk
.blocks:
    lea           rax, [idxq + 32]
    cmp           rax, limq
    ja            .tail
    vmovdqu       m0, [srcq + idxq]
    vpsrlw        m0, m0, 6
    vmovdqu       [dstq + idxq], m0
    add           idxq, 32
    jmp           .blocks
.tail:
    cmp           idxq, limq
    jae           .done
.tloop:
    movzx         eax, word [srcq + idxq]
    shr           eax, 6
    mov           [dstq + idxq], ax
    add           idxq, 2
    cmp           idxq, limq
    jb            .tloop
.done:
    RET
