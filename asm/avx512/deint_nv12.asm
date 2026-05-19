%include "dav1d_x86inc.asm"

SECTION_RODATA 64

ALIGN 64
nv_ui: db  0,  2,  4,  6,  8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30
       db 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62
       db 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94
       db 96, 98,100,102,104,106,108,110,112,114,116,118,120,122,124,126
nv_vi: db  1,  3,  5,  7,  9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31
       db 33, 35, 37, 39, 41, 43, 45, 47, 49, 51, 53, 55, 57, 59, 61, 63
       db 65, 67, 69, 71, 73, 75, 77, 79, 81, 83, 85, 87, 89, 91, 93, 95
       db 97, 99,101,103,105,107,109,111,113,115,117,119,121,123,125,127

SECTION .text

INIT_ZMM avx512
cglobal deint_nv12, 4, 4, 4, src, ud, vd, n
    vmovdqa64     zmm0, [nv_ui]
    vmovdqa64     zmm1, [nv_vi]
    xor           eax, eax
.loop:
%assign g 0
%rep 10
    vmovdqu64     zmm2, [srcq + rax*2 + g*128]
    vmovdqa64     zmm3, zmm2
    vpermt2b      zmm3, zmm0, [srcq + rax*2 + g*128 + 64]
    vpermt2b      zmm2, zmm1, [srcq + rax*2 + g*128 + 64]
    vmovdqu64     [udq + rax + g*64], zmm3
    vmovdqu64     [vdq + rax + g*64], zmm2
%assign g g+1
%endrep
    add           rax, 640
    dec           nq
    jg            .loop
    vzeroupper
    ret
