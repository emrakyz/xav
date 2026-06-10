%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
c_shuf:  db 0,1,4,5,8,9,12,13,2,3,6,7,10,11,14,15
         db 0,1,4,5,8,9,12,13,2,3,6,7,10,11,14,15

SECTION .text

INIT_YMM avx2
cglobal deint_p010_rem, 4, 6, 16, src, ud, vd, n, idx, lim
    vmovdqa       m0, [c_shuf]
    xor           idxq, idxq
    mov           limq, nq
    and           limq, -64
    jz            .blocks
.chunk:
%assign k 0
%rep 4
    %assign a 1+k*3
    %assign b 2+k*3
    vpsrlw        m %+ a, [srcq + idxq*4 + k*64], 6
    vpsrlw        m %+ b, [srcq + idxq*4 + k*64 + 32], 6
%assign k k+1
%endrep
%assign k 0
%rep 4
    %assign a 1+k*3
    %assign b 2+k*3
    vpshufb       m %+ a, m %+ a, m0
    vpshufb       m %+ b, m %+ b, m0
%assign k k+1
%endrep
%assign k 0
%rep 4
    %assign a 1+k*3
    %assign b 2+k*3
    %assign c 3+k*3
    vpunpcklqdq   m %+ c, m %+ a, m %+ b
    vpunpckhqdq   m %+ a, m %+ a, m %+ b
    vpermq        m %+ c, m %+ c, 0xd8
    vpermq        m %+ a, m %+ a, 0xd8
    vmovdqu       [udq + idxq*2 + k*32], m %+ c
    vmovdqu       [vdq + idxq*2 + k*32], m %+ a
%assign k k+1
%endrep
    add           idxq, 64
    cmp           idxq, limq
    jb            .chunk
.blocks:
    lea           rax, [idxq + 16]
    cmp           rax, nq
    ja            .tail
    vpsrlw        m1, [srcq + idxq*4], 6
    vpsrlw        m2, [srcq + idxq*4 + 32], 6
    vpshufb       m1, m1, m0
    vpshufb       m2, m2, m0
    vpunpcklqdq   m3, m1, m2
    vpunpckhqdq   m1, m1, m2
    vpermq        m3, m3, 0xd8
    vpermq        m1, m1, 0xd8
    vmovdqu       [udq + idxq*2], m3
    vmovdqu       [vdq + idxq*2], m1
    add           idxq, 16
    jmp           .blocks
.tail:
    cmp           idxq, nq
    jae           .done
.tloop:
    movzx         eax, word [srcq + idxq*4]
    shr           eax, 6
    mov           [udq + idxq*2], ax
    movzx         eax, word [srcq + idxq*4 + 2]
    shr           eax, 6
    mov           [vdq + idxq*2], ax
    add           idxq, 1
    cmp           idxq, nq
    jb            .tloop
.done:
    RET
