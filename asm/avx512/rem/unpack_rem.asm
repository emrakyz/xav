%include "dav1d_x86inc.asm"

SECTION_RODATA 64
ALIGN 64
u_perm:   db  0, 1, 1, 2, 2, 3, 3, 4, 5, 6, 6, 7, 7, 8, 8, 9
          db 10,11,11,12,12,13,13,14,15,16,16,17,17,18,18,19
          db 20,21,21,22,22,23,23,24,25,26,26,27,27,28,28,29
          db 30,31,31,32,32,33,33,34,35,36,36,37,37,38,38,39
u_shifts: times 8 dw 0, 2, 4, 6
u_mask:   dw 0x03ff

SECTION .text

INIT_ZMM avx512
cglobal unpack_10b_rem, 4, 15, 8, src, dst, w, h, sb, db, pw, ph, prow, urow, full, tail, tpk, row, cc
    vmovdqa64     m0, [u_perm]
    vmovdqa64     m1, [u_shifts]
    vpbroadcastw  m2, [u_mask]
    mov           ccq, 0x000000ffffffffff
    kmovq         k5, ccq

    mov           sbq, srcq
    mov           dbq, dstq
    mov           pwq, wq
    mov           phq, hq
    call          .plane
    mov           ccq, wq
    add           ccq, 3
    shr           ccq, 2
    lea           ccq, [ccq + ccq*4]
    imul          ccq, hq
    add           srcq, ccq
    mov           ccq, wq
    imul          ccq, hq
    add           dstq, ccq
    add           dstq, ccq

    mov           pwq, wq
    shr           pwq, 1
    mov           phq, hq
    shr           phq, 1
    mov           sbq, srcq
    mov           dbq, dstq
    call          .plane
    mov           ccq, pwq
    add           ccq, 3
    shr           ccq, 2
    lea           ccq, [ccq + ccq*4]
    imul          ccq, phq
    add           srcq, ccq
    mov           ccq, wq
    imul          ccq, hq
    shr           ccq, 1
    add           dstq, ccq

    mov           pwq, wq
    shr           pwq, 1
    mov           phq, hq
    shr           phq, 1
    mov           sbq, srcq
    mov           dbq, dstq
    call          .plane
    RET

.plane:
    lea           urowq, [pwq*2]
    lea           prowq, [pwq + 3]
    shr           prowq, 2
    lea           prowq, [prowq + prowq*4]
    mov           fullq, pwq
    shr           fullq, 5
    mov           tailq, urowq
    and           tailq, 63
    mov           ccq, fullq
    lea           ccq, [ccq + ccq*4]
    shl           ccq, 3
    mov           tpkq, prowq
    sub           tpkq, ccq
    xor           rowq, rowq
.pl_row:
    cmp           rowq, phq
    jae           .pl_done
    test          fullq, fullq
    jz            .pl_tail
    mov           ccq, fullq
    dec           ccq
.pl_u4:
    cmp           ccq, 4
    jb            .pl_u1
    vpermb        m3, m0, [sbq + 0]
    vpermb        m4, m0, [sbq + 40]
    vpermb        m5, m0, [sbq + 80]
    vpermb        m6, m0, [sbq + 120]
    vpsrlvw       m3, m3, m1
    vpsrlvw       m4, m4, m1
    vpsrlvw       m5, m5, m1
    vpsrlvw       m6, m6, m1
    vpandq        m3, m3, m2
    vpandq        m4, m4, m2
    vpandq        m5, m5, m2
    vpandq        m6, m6, m2
    vmovdqu64     [dbq + 0],   m3
    vmovdqu64     [dbq + 64],  m4
    vmovdqu64     [dbq + 128], m5
    vmovdqu64     [dbq + 192], m6
    add           sbq, 160
    add           dbq, 256
    sub           ccq, 4
    jmp           .pl_u4
.pl_u1:
    test          ccq, ccq
    jz            .pl_lastfull
    vpermb        m3, m0, [sbq]
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dbq], m3
    add           sbq, 40
    add           dbq, 64
    dec           ccq
    jmp           .pl_u1
.pl_lastfull:
    vmovdqu8      m3 {k5}{z}, [sbq]
    vpermb        m3, m0, m3
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    vmovdqu64     [dbq], m3
    add           sbq, 40
    add           dbq, 64
.pl_tail:
    test          tailq, tailq
    jz            .pl_next
    mov           ccq, -1
    bzhi          ccq, ccq, tpkq
    kmovq         k1, ccq
    vmovdqu8      m3 {k1}{z}, [sbq]
    vpermb        m3, m0, m3
    vpsrlvw       m3, m3, m1
    vpandq        m3, m3, m2
    mov           ccq, -1
    bzhi          ccq, ccq, tailq
    kmovq         k1, ccq
    vmovdqu8      [dbq] {k1}, m3
    add           sbq, tpkq
    add           dbq, tailq
.pl_next:
    inc           rowq
    jmp           .pl_row
.pl_done:
    RET
