%include "dav1d_x86inc.asm"

SECTION .text

INIT_ZMM avx512
cglobal deint_p010, 4, 4, 16, src, ud, vd, n
    xor           eax, eax
.loop:
%assign j 0
%rep 8
    vpsrlw        m %+ j, [srcq + rax*4 + j*64], 6
%assign j j+1
%endrep
%assign j 0
%rep 8
    vpmovdw       [udq + rax*2 + j*32], m %+ j
%assign j j+1
%endrep
%assign j 0
%rep 8
    vpsrld        m %+ j, m %+ j, 16
%assign j j+1
%endrep
%assign j 0
%rep 8
    vpmovdw       [vdq + rax*2 + j*32], m %+ j
%assign j j+1
%endrep
%assign j 0
%rep 8
    vpsrlw        m %+ j, [srcq + rax*4 + 512 + j*64], 6
%assign j j+1
%endrep
%assign j 0
%rep 8
    vpmovdw       [udq + rax*2 + 256 + j*32], m %+ j
%assign j j+1
%endrep
%assign j 0
%rep 8
    vpsrld        m %+ j, m %+ j, 16
%assign j j+1
%endrep
%assign j 0
%rep 8
    vpmovdw       [vdq + rax*2 + 256 + j*32], m %+ j
%assign j j+1
%endrep
%assign j 0
%rep 4
    vpsrlw        m %+ j, [srcq + rax*4 + 1024 + j*64], 6
%assign j j+1
%endrep
%assign j 0
%rep 4
    vpmovdw       [udq + rax*2 + 512 + j*32], m %+ j
%assign j j+1
%endrep
%assign j 0
%rep 4
    vpsrld        m %+ j, m %+ j, 16
%assign j j+1
%endrep
%assign j 0
%rep 4
    vpmovdw       [vdq + rax*2 + 512 + j*32], m %+ j
%assign j j+1
%endrep
    add           rax, 320
    dec           nq
    jg            .loop
    RET
