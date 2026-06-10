%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
c_mask:  times 16 dw 0x00ff

SECTION .text

INIT_YMM avx2
cglobal deint_nv12_rem, 4, 6, 16, src, ud, vd, n, idx, lim
    vmovdqa       m0, [c_mask]
    xor           idxq, idxq
    mov           limq, nq
    and           limq, -128
    jz            .blocks
.chunk:
%assign k 0
%rep 4
    %assign a 1+k*3
    %assign b 2+k*3
    vmovdqu       m %+ a, [srcq + idxq*2 + k*64]
    vmovdqu       m %+ b, [srcq + idxq*2 + k*64 + 32]
%assign k k+1
%endrep
%assign k 0
%rep 4
    %assign a 1+k*3
    %assign b 2+k*3
    %assign c 3+k*3
    vpand         m %+ c, m %+ a, m0
    vpand         m13, m %+ b, m0
    vpackuswb     m %+ c, m %+ c, m13
    vpermq        m %+ c, m %+ c, 0xd8
    vmovdqu       [udq + idxq + k*32], m %+ c
    vpsrlw        m %+ a, m %+ a, 8
    vpsrlw        m %+ b, m %+ b, 8
    vpackuswb     m %+ a, m %+ a, m %+ b
    vpermq        m %+ a, m %+ a, 0xd8
    vmovdqu       [vdq + idxq + k*32], m %+ a
%assign k k+1
%endrep
    add           idxq, 128
    cmp           idxq, limq
    jb            .chunk
.blocks:
    lea           rax, [idxq + 32]
    cmp           rax, nq
    ja            .tail
    vmovdqu       m1, [srcq + idxq*2]
    vmovdqu       m2, [srcq + idxq*2 + 32]
    vpand         m3, m1, m0
    vpand         m4, m2, m0
    vpackuswb     m3, m3, m4
    vpermq        m3, m3, 0xd8
    vmovdqu       [udq + idxq], m3
    vpsrlw        m1, m1, 8
    vpsrlw        m2, m2, 8
    vpackuswb     m1, m1, m2
    vpermq        m1, m1, 0xd8
    vmovdqu       [vdq + idxq], m1
    add           idxq, 32
    jmp           .blocks
.tail:
    cmp           idxq, nq
    jae           .done
.tloop:
    movzx         eax, byte [srcq + idxq*2]
    mov           [udq + idxq], al
    movzx         eax, byte [srcq + idxq*2 + 1]
    mov           [vdq + idxq], al
    add           idxq, 1
    cmp           idxq, nq
    jb            .tloop
.done:
    RET
