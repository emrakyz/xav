%include "dav1d_x86inc.asm"

SECTION_RODATA 64
ALIGN 64
init: dd 73, 146, 219, 292, 365, 438, 511, 584
      dd 657, 730, 803, 876, 949, 1022, 1095, 1168

SECTION .text
INIT_ZMM avx512
cglobal calc_samp_frames, 2, 2, 1, tot, out
    vpbroadcastd zmm0, totd
    vpmulld      zmm0, zmm0, [rel init]
    vpsrld       zmm0, zmm0, 10
    vmovdqu32    [outq], zmm0
    RET
