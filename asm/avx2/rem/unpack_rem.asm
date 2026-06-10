%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
u_spread: db 0,1, 1,2, 2,3, 3,4, 5,6, 6,7, 7,8, 8,9
u_mults:  dq 0x0400100040000000
u_mask:   dw 0x03ff

SECTION .text

INIT_YMM avx2
cglobal unpack_10b_rem, 4, 15, 15, src, dst, w, h, sb, db, pw, ph, prow, urow, full, cnt, tmp, acc, cc
    vbroadcasti128 m0, [u_spread]
    vpbroadcastq   m1, [u_mults]
    vpbroadcastw   m2, [u_mask]

    mov           sbq, srcq
    mov           dbq, dstq
    mov           pwq, wq
    mov           phq, hq
    call          .plane
    lea           ccq, [wq + 3]
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
    mov           ccq, wq
    shr           ccq, 1
    lea           ccq, [ccq + 3]
    shr           ccq, 2
    lea           ccq, [ccq + ccq*4]
    mov           tmpq, hq
    shr           tmpq, 1
    imul          ccq, tmpq
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
    push          srcq
    push          dstq
    push          wq
    push          hq
    lea           urowq, [pwq*2]
    lea           prowq, [pwq + 3]
    shr           prowq, 2
    lea           prowq, [prowq + prowq*4]
    mov           fullq, urowq
    shr           fullq, 5
    cmp           prowq, 26
    jb            .pl_have_full
    mov           tmpq, prowq
    sub           tmpq, 6
    mov           ccq, 3435973837
    imul          tmpq, ccq
    shr           tmpq, 36
    cmp           tmpq, fullq
    cmovb         fullq, tmpq
    jmp           .pl_consts
.pl_have_full:
    xor           fullq, fullq
.pl_consts:
    mov           wq, pwq
    mov           ccq, fullq
    shl           ccq, 4
    sub           wq, ccq
    mov           hq, wq
    and           hq, 3
    shr           wq, 2

.pl_row:
    test          phq, phq
    jz            .pl_done
    mov           srcq, sbq
    mov           dstq, dbq
    mov           cntq, fullq
.pl_simd6:
    cmp           cntq, 6
    jb            .pl_simd1
    vmovdqu       xm3,  [srcq +   0]
    vinserti128   m3,  m3,  [srcq +  10], 1
    vmovdqu       xm5,  [srcq +  20]
    vinserti128   m5,  m5,  [srcq +  30], 1
    vmovdqu       xm7,  [srcq +  40]
    vinserti128   m7,  m7,  [srcq +  50], 1
    vmovdqu       xm9,  [srcq +  60]
    vinserti128   m9,  m9,  [srcq +  70], 1
    vmovdqu       xm11, [srcq +  80]
    vinserti128   m11, m11, [srcq +  90], 1
    vmovdqu       xm13, [srcq + 100]
    vinserti128   m13, m13, [srcq + 110], 1
    vpshufb       m3,  m3,  m0
    vpshufb       m5,  m5,  m0
    vpshufb       m7,  m7,  m0
    vpshufb       m9,  m9,  m0
    vpshufb       m11, m11, m0
    vpshufb       m13, m13, m0
    vpmulhuw      m4,  m3,  m1
    vpmulhuw      m6,  m5,  m1
    vpmulhuw      m8,  m7,  m1
    vpmulhuw      m10, m9,  m1
    vpmulhuw      m12, m11, m1
    vpmulhuw      m14, m13, m1
    vpblendw      m4,  m4,  m3,  0x11
    vpblendw      m6,  m6,  m5,  0x11
    vpblendw      m8,  m8,  m7,  0x11
    vpblendw      m10, m10, m9,  0x11
    vpblendw      m12, m12, m11, 0x11
    vpblendw      m14, m14, m13, 0x11
    vpand         m4,  m4,  m2
    vpand         m6,  m6,  m2
    vpand         m8,  m8,  m2
    vpand         m10, m10, m2
    vpand         m12, m12, m2
    vpand         m14, m14, m2
    vmovdqu       [dstq +   0], m4
    vmovdqu       [dstq +  32], m6
    vmovdqu       [dstq +  64], m8
    vmovdqu       [dstq +  96], m10
    vmovdqu       [dstq + 128], m12
    vmovdqu       [dstq + 160], m14
    add           srcq, 120
    add           dstq, 192
    sub           cntq, 6
    jmp           .pl_simd6
.pl_simd1:
    test          cntq, cntq
    jz            .pl_tail
    vmovdqu       xm3, [srcq]
    vinserti128   m3, m3, [srcq + 10], 1
    vpshufb       m3, m3, m0
    vpmulhuw      m4, m3, m1
    vpblendw      m4, m4, m3, 0x11
    vpand         m4, m4, m2
    vmovdqu       [dstq], m4
    add           srcq, 20
    add           dstq, 32
    dec           cntq
    jmp           .pl_simd1

.pl_tail:
    mov           cntq, wq
.pl_tg:
    test          cntq, cntq
    jz            .pl_rem
    mov           eax, [srcq]
    movzx         tmpd, byte [srcq + 4]
    shl           tmpq, 32
    or            rax, tmpq
    mov           accq, rax
    and           accq, 0x3ff
    mov           tmpq, rax
    shr           tmpq, 10
    and           tmpq, 0x3ff
    shl           tmpq, 16
    or            accq, tmpq
    mov           tmpq, rax
    shr           tmpq, 20
    and           tmpq, 0x3ff
    shl           tmpq, 32
    or            accq, tmpq
    shr           rax, 30
    shl           rax, 48
    or            accq, rax
    mov           [dstq], accq
    add           srcq, 5
    add           dstq, 8
    dec           cntq
    jmp           .pl_tg
.pl_rem:
    test          hq, hq
    jz            .pl_next
    lea           tmpq, [sbq + prowq]
    mov           eax, [tmpq - 5]
    movzx         tmpd, byte [tmpq - 1]
    shl           tmpq, 32
    or            rax, tmpq
    mov           accq, rax
    and           accq, 0x3ff
    mov           tmpq, rax
    shr           tmpq, 10
    and           tmpq, 0x3ff
    shl           tmpq, 16
    or            accq, tmpq
    mov           tmpq, rax
    shr           tmpq, 20
    and           tmpq, 0x3ff
    shl           tmpq, 32
    or            accq, tmpq
    shr           rax, 30
    shl           rax, 48
    or            accq, rax
    lea           tmpq, [dbq + urowq]
    cmp           hq, 2
    ja            .pl_rem3
    je            .pl_rem2
    mov           [tmpq - 2], accw
    jmp           .pl_next
.pl_rem2:
    mov           [tmpq - 4], accd
    jmp           .pl_next
.pl_rem3:
    mov           [tmpq - 6], accd
    shr           accq, 32
    mov           [tmpq - 2], accw
.pl_next:
    add           sbq, prowq
    add           dbq, urowq
    dec           phq
    jmp           .pl_row
.pl_done:
    pop           hq
    pop           wq
    pop           dstq
    pop           srcq
    ret
