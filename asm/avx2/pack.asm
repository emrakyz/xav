%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
c_shuf:  db 0,1,2,3,4,8,9,10,11,12,0xff,0xff,0xff,0xff,0xff,0xff
         db 0,1,2,3,4,8,9,10,11,12,0xff,0xff,0xff,0xff,0xff,0xff
c_mult:  dd 0x04000001
c_mask:  dq 0x00000000000fffff

SECTION .text

INIT_YMM avx2
cglobal pack_10b, 3, 3, 7, src, dst, n
    vpbroadcastd  m0, [c_mult]
    vpbroadcastq  m1, [c_mask]
    vmovdqa       m2, [c_shuf]
.loop:
%assign g 0
%rep 3
    vpmaddwd      m3, m0, [srcq + g*64]
    vpmaddwd      m5, m0, [srcq + g*64 + 32]
    vpsrlq        m4, m3, 12
    vpsrlq        m6, m5, 12
    vpand         m3, m3, m1
    vpand         m5, m5, m1
    vpandn        m4, m1, m4
    vpandn        m6, m1, m6
    vpor          m3, m3, m4
    vpor          m5, m5, m6
    vpshufb       m3, m3, m2
    vpshufb       m5, m5, m2
    vmovq         [dstq + g*40], xm3
    vpextrw       [dstq + g*40 + 8], xm3, 4
    vextracti128  xm4, m3, 1
    vmovq         [dstq + g*40 + 10], xm4
    vpextrw       [dstq + g*40 + 18], xm4, 4
    vmovq         [dstq + g*40 + 20], xm5
    vpextrw       [dstq + g*40 + 28], xm5, 4
    vextracti128  xm6, m5, 1
    vmovq         [dstq + g*40 + 30], xm6
    vpextrw       [dstq + g*40 + 38], xm6, 4
%assign g g+1
%endrep
    add           srcq, 192
    add           dstq, 120
    dec           nq
    jg            .loop
    RET
