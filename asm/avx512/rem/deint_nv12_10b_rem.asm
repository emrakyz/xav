%include "dav1d_x86inc.asm"

SECTION_RODATA 64
nt_mask: dw 0x03fc

SECTION .text

INIT_ZMM avx512
cglobal deint_nv12_10b_rem, 4, 4, 3, src, ud, vd, n
    vpbroadcastw  m0, [nt_mask]
.loop:
    cmp           nq, 32
    jb            .tail
    vpsllw        m1, [srcq], 2
    vpandq        m1, m1, m0
    vpsrlw        m2, [srcq], 6
    vpandq        m2, m2, m0
    vmovdqu64     [udq], m1
    vmovdqu64     [vdq], m2
    add           srcq, 64
    add           udq, 64
    add           vdq, 64
    sub           nq, 32
    jmp           .loop
.tail:
    test          nq, nq
    jz            .done
    mov           eax, -1
    bzhi          eax, eax, nd
    kmovd         k1, eax
    vpsllw        m1 {k1}{z}, [srcq], 2
    vpandq        m1, m1, m0
    vpsrlw        m2 {k1}{z}, [srcq], 6
    vpandq        m2, m2, m0
    vmovdqu16     [udq] {k1}, m1
    vmovdqu16     [vdq] {k1}, m2
.done:
    RET
