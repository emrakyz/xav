%include "dav1d_x86inc.asm"

SECTION .text

INIT_ZMM avx512
cglobal deint_nv12, 4, 4, 16, src, ud, vd, n
    xor           eax, eax
.loop:
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
%assign j 0
%rep 8
    vmovdqu64     m %+ j, [srcq + rax*2 + 512 + j*64]
%assign j j+1
%endrep
%assign j 0
%rep 8
    vpmovwb       [udq + rax + 256 + j*32], m %+ j
%assign j j+1
%endrep
%assign j 0
%rep 8
    vpsrlw        m %+ j, m %+ j, 8
%assign j j+1
%endrep
%assign j 0
%rep 8
    vpmovwb       [vdq + rax + 256 + j*32], m %+ j
%assign j j+1
%endrep
%assign j 0
%rep 4
    vmovdqu64     m %+ j, [srcq + rax*2 + 1024 + j*64]
%assign j j+1
%endrep
%assign j 0
%rep 4
    vpmovwb       [udq + rax + 512 + j*32], m %+ j
%assign j j+1
%endrep
%assign j 0
%rep 4
    vpsrlw        m %+ j, m %+ j, 8
%assign j j+1
%endrep
%assign j 0
%rep 4
    vpmovwb       [vdq + rax + 512 + j*32], m %+ j
%assign j j+1
%endrep
    add           rax, 640
    dec           nq
    jg            .loop
    RET
