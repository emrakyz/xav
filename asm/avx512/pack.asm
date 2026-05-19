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
cglobal pack_10b, 3, 3, 19, src, dst, n
    vpbroadcastd  m0, [c_mult]
    vpbroadcastq  m1, [c_mask20]
    vmovdqa64     m2, [c_perm]
.loop:
    vpmaddwd      m3,  m0, [srcq+0]
    vpmaddwd      m4,  m0, [srcq+64]
    vpmaddwd      m5,  m0, [srcq+128]
    vpmaddwd      m6,  m0, [srcq+192]
    vpmaddwd      m7,  m0, [srcq+256]
    vpmaddwd      m8,  m0, [srcq+320]
    vpmaddwd      m9,  m0, [srcq+384]
    vpmaddwd      m10, m0, [srcq+448]
    vpsrlq        m11, m3,  12
    vpsrlq        m12, m4,  12
    vpsrlq        m13, m5,  12
    vpsrlq        m14, m6,  12
    vpsrlq        m15, m7,  12
    vpsrlq        m16, m8,  12
    vpsrlq        m17, m9,  12
    vpsrlq        m18, m10, 12
    vpternlogq    m3,  m11, m1, 0xe4
    vpternlogq    m4,  m12, m1, 0xe4
    vpternlogq    m5,  m13, m1, 0xe4
    vpternlogq    m6,  m14, m1, 0xe4
    vpternlogq    m7,  m15, m1, 0xe4
    vpternlogq    m8,  m16, m1, 0xe4
    vpternlogq    m9,  m17, m1, 0xe4
    vpternlogq    m10, m18, m1, 0xe4
    vpermb        m3,  m2,  m3
    vpermb        m4,  m2,  m4
    vpermb        m5,  m2,  m5
    vpermb        m6,  m2,  m6
    vpermb        m7,  m2,  m7
    vpermb        m8,  m2,  m8
    vpermb        m9,  m2,  m9
    vpermb        m10, m2,  m10
    vmovdqu64     [dstq+0],   m3
    vmovdqu64     [dstq+40],  m4
    vmovdqu64     [dstq+80],  m5
    vmovdqu64     [dstq+120], m6
    vmovdqu64     [dstq+160], m7
    vmovdqu64     [dstq+200], m8
    vmovdqu64     [dstq+240], m9
    vmovdqu64     [dstq+280], m10
    add           srcq, 512
    add           dstq, 320
    dec           nq
    jg            .loop
    RET
