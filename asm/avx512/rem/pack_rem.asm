%include "dav1d_x86inc.asm"

SECTION_RODATA 64
ALIGN 64
c_perm:   db  0, 1, 2, 3, 4, 8, 9,10,11,12,16,17,18,19,20,24
          db 25,26,27,28,32,33,34,35,36,40,41,42,43,44,48,49
          db 50,51,52,56,57,58,59,60
          times 24 db 0x80
c_mult:   dd 0x04000001
c_mask20: dq 0x00000000000fffff

SECTION .text

INIT_ZMM avx512
cglobal pack_10b_rem, 5, 13, 16, src, stride, w, h, dst, full, tb, tg, yrow, sb, db, cnt, tmp
    vpbroadcastd  m0, [c_mult]
    vpbroadcastq  m1, [c_mask20]
    vmovdqa64     m2, [c_perm]

    lea           wq, [wq*2]
    mov           fullq, wq
    shr           fullq, 6
    mov           tbq, wq
    and           tbq, 63
    lea           tgq, [tbq + 7]
    shr           tgq, 3

    mov           tmpq, fullq
    shl           tmpq, 3
    add           tmpq, tgq
    lea           yrowq, [tmpq + tmpq*4]

    mov           tmpq, 0x000000ffffffffff
    kmovq         k2, tmpq
    mov           tmpq, -1
    bzhi          tmpq, tmpq, tbq
    kmovq         k4, tmpq
    lea           tmpq, [tgq + tgq*4]
    mov           cntq, tmpq
    mov           tmpq, -1
    bzhi          tmpq, tmpq, cntq
    kmovq         k3, tmpq

.row_loop:
    test          hq, hq
    jz            .done
    mov           sbq, srcq
    mov           dbq, dstq
    mov           cntq, fullq
.unroll4:
    cmp           cntq, 4
    jb            .one
    vpmaddwd      m3,  m0, [sbq +   0]
    vpmaddwd      m6,  m0, [sbq +  64]
    vpmaddwd      m9,  m0, [sbq + 128]
    vpmaddwd      m12, m0, [sbq + 192]
    vpsrlq        m4,  m3,  12
    vpsrlq        m7,  m6,  12
    vpsrlq        m10, m9,  12
    vpsrlq        m13, m12, 12
    vpternlogq    m3,  m4,  m1, 0xe4
    vpternlogq    m6,  m7,  m1, 0xe4
    vpternlogq    m9,  m10, m1, 0xe4
    vpternlogq    m12, m13, m1, 0xe4
    vpermb        m3,  m2, m3
    vpermb        m6,  m2, m6
    vpermb        m9,  m2, m9
    vpermb        m12, m2, m12
    vmovdqu8      [dbq +   0] {k2}, m3
    vmovdqu8      [dbq +  40] {k2}, m6
    vmovdqu8      [dbq +  80] {k2}, m9
    vmovdqu8      [dbq + 120] {k2}, m12
    add           sbq, 256
    add           dbq, 160
    sub           cntq, 4
    jmp           .unroll4
.one:
    test          cntq, cntq
    jz            .tail
    vpmaddwd      m3, m0, [sbq]
    vpsrlq        m4, m3, 12
    vpternlogq    m3, m4, m1, 0xe4
    vpermb        m3, m2, m3
    vmovdqu8      [dbq] {k2}, m3
    add           sbq, 64
    add           dbq, 40
    dec           cntq
    jmp           .one
.tail:
    test          tbq, tbq
    jz            .next
    vmovdqu8      m3 {k4}{z}, [sbq]
    vpmaddwd      m3, m0, m3
    vpsrlq        m4, m3, 12
    vpternlogq    m3, m4, m1, 0xe4
    vpermb        m3, m2, m3
    vmovdqu8      [dbq] {k3}, m3
.next:
    add           srcq, strideq
    add           dstq, yrowq
    dec           hq
    jmp           .row_loop
.done:
    RET
