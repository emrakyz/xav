%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
c_shuf:  db 0,1,2,3,4,8,9,10,11,12,0xff,0xff,0xff,0xff,0xff,0xff
         db 0,1,2,3,4,8,9,10,11,12,0xff,0xff,0xff,0xff,0xff,0xff
c_mult:  dd 0x04000001
c_mask:  dq 0x00000000000fffff

SECTION .text

INIT_YMM avx2
cglobal pack_10b_rem, 5, 13, 15, src, stride, w, h, dst, full, rem, yrow, sb, db, cnt, tmp, acc
    vpbroadcastd  m0, [c_mult]
    vpbroadcastq  m1, [c_mask]
    vmovdqa       m2, [c_shuf]

    mov           fullq, wq
    shr           fullq, 4
    mov           remq, wq
    and           remq, 15
    lea           tmpq, [remq + 3]
    shr           tmpq, 2
    lea           tmpq, [tmpq + tmpq*4]
    lea           yrowq, [fullq + fullq*4]
    shl           yrowq, 2
    add           yrowq, tmpq

.row_loop:
    test          hq, hq
    jz            .done
    mov           sbq, srcq
    mov           dbq, dstq
    mov           cntq, fullq
    test          cntq, cntq
    jz            .tail
    dec           cntq

.ov6:
    cmp           cntq, 6
    jb            .ov1
    vpmaddwd      m3,  m0, [sbq +   0]
    vpmaddwd      m5,  m0, [sbq +  32]
    vpmaddwd      m7,  m0, [sbq +  64]
    vpmaddwd      m9,  m0, [sbq +  96]
    vpmaddwd      m11, m0, [sbq + 128]
    vpmaddwd      m13, m0, [sbq + 160]
    vpsrlq        m4,  m3,  12
    vpsrlq        m6,  m5,  12
    vpsrlq        m8,  m7,  12
    vpsrlq        m10, m9,  12
    vpsrlq        m12, m11, 12
    vpsrlq        m14, m13, 12
    vpand         m3,  m3,  m1
    vpand         m5,  m5,  m1
    vpand         m7,  m7,  m1
    vpand         m9,  m9,  m1
    vpand         m11, m11, m1
    vpand         m13, m13, m1
    vpandn        m4,  m1, m4
    vpandn        m6,  m1, m6
    vpandn        m8,  m1, m8
    vpandn        m10, m1, m10
    vpandn        m12, m1, m12
    vpandn        m14, m1, m14
    vpor          m3,  m3,  m4
    vpor          m5,  m5,  m6
    vpor          m7,  m7,  m8
    vpor          m9,  m9,  m10
    vpor          m11, m11, m12
    vpor          m13, m13, m14
    vpshufb       m3,  m3,  m2
    vpshufb       m5,  m5,  m2
    vpshufb       m7,  m7,  m2
    vpshufb       m9,  m9,  m2
    vpshufb       m11, m11, m2
    vpshufb       m13, m13, m2
    vmovdqu       [dbq +   0], xm3
    vextracti128  [dbq +  10], m3, 1
    vmovdqu       [dbq +  20], xm5
    vextracti128  [dbq +  30], m5, 1
    vmovdqu       [dbq +  40], xm7
    vextracti128  [dbq +  50], m7, 1
    vmovdqu       [dbq +  60], xm9
    vextracti128  [dbq +  70], m9, 1
    vmovdqu       [dbq +  80], xm11
    vextracti128  [dbq +  90], m11, 1
    vmovdqu       [dbq + 100], xm13
    vextracti128  [dbq + 110], m13, 1
    add           sbq, 192
    add           dbq, 120
    sub           cntq, 6
    jmp           .ov6

.ov1:
    test          cntq, cntq
    jz            .lastfull
.ov1_loop:
    vpmaddwd      m3, m0, [sbq]
    vpsrlq        m4, m3, 12
    vpand         m3, m3, m1
    vpandn        m4, m1, m4
    vpor          m3, m3, m4
    vpshufb       m3, m3, m2
    vmovdqu       [dbq], xm3
    vextracti128  [dbq + 10], m3, 1
    add           sbq, 32
    add           dbq, 20
    dec           cntq
    jnz           .ov1_loop

.lastfull:
    vpmaddwd      m3, m0, [sbq]
    vpsrlq        m4, m3, 12
    vpand         m3, m3, m1
    vpandn        m4, m1, m4
    vpor          m3, m3, m4
    vpshufb       m3, m3, m2
    vextracti128  xm4, m3, 1
    vmovq         [dbq +  0], xm3
    vpextrw       [dbq +  8], xm3, 4
    vmovq         [dbq + 10], xm4
    vpextrw       [dbq + 18], xm4, 4
    add           sbq, 32
    add           dbq, 20

.tail:
    test          remq, remq
    jz            .next
    mov           cntq, remq
.tgrp:
    movzx         accd, word [sbq +  0]
    cmp           cntq, 1
    jbe           .tflush
    movzx         tmpd, word [sbq + 2]
    shl           tmpd, 10
    or            accd, tmpd
    cmp           cntq, 2
    jbe           .tflush
    movzx         tmpd, word [sbq + 4]
    shl           tmpd, 20
    or            accd, tmpd
    cmp           cntq, 3
    jbe           .tflush
    movzx         tmpq, word [sbq + 6]
    shl           tmpq, 30
    or            accq, tmpq
.tflush:
    mov           [dbq + 0], accd
    shr           accq, 32
    mov           [dbq + 4], accb
    add           sbq, 8
    add           dbq, 5
    sub           cntq, 4
    jg            .tgrp

.next:
    add           srcq, strideq
    add           dstq, yrowq
    dec           hq
    jmp           .row_loop
.done:
    RET
