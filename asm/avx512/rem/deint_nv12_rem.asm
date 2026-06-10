%include "dav1d_x86inc.asm"

SECTION .text

INIT_ZMM avx512
cglobal deint_nv12_rem, 4, 5, 16, src, ud, vd, n, tmp
    xor           eax, eax
    cmp           nq, 256
    jb            .blocks
.chunk:
%assign j 0
%rep 8
    vmovdqu64     m %+ j, [srcq + rax*2 + j*64]
%assign j j+1
%endrep
%assign j 0
%rep 8
    vpmovwb       [udq + rax + j*32], m %+ j
%assign j j+1
%endrep
%assign j 0
%rep 8
    vpsrlw        m %+ j, m %+ j, 8
%assign j j+1
%endrep
%assign j 0
%rep 8
    vpmovwb       [vdq + rax + j*32], m %+ j
%assign j j+1
%endrep
    add           rax, 256
    sub           nq, 256
    cmp           nq, 256
    jae           .chunk
.blocks:
    cmp           nq, 32
    jb            .tail
    vmovdqu64     m0, [srcq + rax*2]
    vpmovwb       [udq + rax], m0
    vpsrlw        m0, m0, 8
    vpmovwb       [vdq + rax], m0
    add           rax, 32
    sub           nq, 32
    jmp           .blocks
.tail:
    test          nq, nq
    jz            .done
    mov           tmpd, -1
    bzhi          tmpd, tmpd, nd
    kmovd         k1, tmpd
    add           nq, nq
    mov           tmpq, -1
    bzhi          tmpq, tmpq, nq
    kmovq         k2, tmpq
    vmovdqu8      m0 {k2}{z}, [srcq + rax*2]
    vpmovwb       [udq + rax] {k1}, m0
    vpsrlw        m0, m0, 8
    vpmovwb       [vdq + rax] {k1}, m0
.done:
    RET
