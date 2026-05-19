%include "dav1d_x86inc.asm"

SECTION_RODATA 64

ALIGN 64
d_ui: dw  0, 2, 4, 6, 8,10,12,14,16,18,20,22,24,26,28,30
      dw 32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62
d_vi: dw  1, 3, 5, 7, 9,11,13,15,17,19,21,23,25,27,29,31
      dw 33,35,37,39,41,43,45,47,49,51,53,55,57,59,61,63

SECTION .text

INIT_ZMM avx512
cglobal deint_p010, 4, 4, 5, src, ud, vd, n
    vmovdqa64     zmm0, [d_ui]
    vmovdqa64     zmm1, [d_vi]
    xor           eax, eax
.loop:
%assign g 0
%rep 10
    vpsrlw        zmm2, [srcq + rax*2 + g*128], 6
    vpsrlw        zmm3, [srcq + rax*2 + g*128 + 64], 6
    vmovdqa64     zmm4, zmm2
    vpermt2w      zmm2, zmm0, zmm3
    vpermt2w      zmm4, zmm1, zmm3
    vmovdqu64     [udq + rax + g*64], zmm2
    vmovdqu64     [vdq + rax + g*64], zmm4
%assign g g+1
%endrep
    add           rax, 640
    dec           nq
    jg            .loop
    vzeroupper
    ret
