%include "dav1d_x86inc.asm"

SECTION .text

INIT_ZMM avx512
cglobal deint_p010_rem, 4, 5, 16, src, ud, vd, n, tmp
    xor           eax, eax
    cmp           nq, 128
    jb            .blocks
.chunk:
%assign k 0
%rep 8
    vpsrlw        m %+ k, [srcq + rax*4 + k*64], 6
%assign k k+1
%endrep
%assign k 0
%rep 8
    vpmovdw       [udq + rax*2 + k*32], m %+ k
%assign k k+1
%endrep
%assign k 0
%rep 8
    vpsrld        m %+ k, m %+ k, 16
%assign k k+1
%endrep
%assign k 0
%rep 8
    vpmovdw       [vdq + rax*2 + k*32], m %+ k
%assign k k+1
%endrep
    add           rax, 128
    sub           nq, 128
    cmp           nq, 128
    jae           .chunk
.blocks:
    cmp           nq, 16
    jb            .tail
    vpsrlw        m0, [srcq + rax*4], 6
    vpmovdw       [udq + rax*2], m0
    vpsrld        m0, m0, 16
    vpmovdw       [vdq + rax*2], m0
    add           rax, 16
    sub           nq, 16
    jmp           .blocks
.tail:
    test          nq, nq
    jz            .done
    mov           tmpd, -1
    bzhi          tmpd, tmpd, nd
    kmovd         k1, tmpd
    add           nd, nd
    mov           tmpd, -1
    bzhi          tmpd, tmpd, nd
    kmovd         k2, tmpd
    vpsrlw        m0 {k2}{z}, [srcq + rax*4], 6
    vpmovdw       [udq + rax*2] {k1}, m0
    vpsrld        m0, m0, 16
    vpmovdw       [vdq + rax*2] {k1}, m0
.done:
    RET
