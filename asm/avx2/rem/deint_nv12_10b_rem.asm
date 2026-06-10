%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
c_mask:  times 16 dw 0x03fc

SECTION .text

INIT_YMM avx2
cglobal deint_nv12_10b_rem, 4, 6, 8, src, ud, vd, n, idx, lim
    vmovdqa       m0, [c_mask]
    xor           idxq, idxq
    mov           limq, nq
    and           limq, -128
    jz            .blocks
.chunk:
%assign k 0
%rep 8
    vmovdqu       m1, [srcq + idxq*2 + k*32]
    vpsllw        m2, m1, 2
    vpand         m2, m2, m0
    vpsrlw        m3, m1, 6
    vpand         m3, m3, m0
    vmovdqu       [udq + idxq*2 + k*32], m2
    vmovdqu       [vdq + idxq*2 + k*32], m3
%assign k k+1
%endrep
    add           idxq, 128
    cmp           idxq, limq
    jb            .chunk
.blocks:
    lea           rax, [idxq + 16]
    cmp           rax, nq
    ja            .tail
    vmovdqu       m1, [srcq + idxq*2]
    vpsllw        m2, m1, 2
    vpand         m2, m2, m0
    vpsrlw        m3, m1, 6
    vpand         m3, m3, m0
    vmovdqu       [udq + idxq*2], m2
    vmovdqu       [vdq + idxq*2], m3
    add           idxq, 16
    jmp           .blocks
.tail:
    cmp           idxq, nq
    jae           .done
.tloop:
    movzx         eax, byte [srcq + idxq*2]
    shl           eax, 2
    mov           [udq + idxq*2], ax
    movzx         eax, byte [srcq + idxq*2 + 1]
    shl           eax, 2
    mov           [vdq + idxq*2], ax
    add           idxq, 1
    cmp           idxq, nq
    jb            .tloop
.done:
    RET
