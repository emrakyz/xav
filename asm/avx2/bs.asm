%include "dav1d_x86inc.asm"

SECTION_RODATA 16
chalf:    dd 0x3f000000
cfour:    dd 0x40800000
cquarter: dd 0x3e800000
csign:    dd 0x80000000, 0x80000000, 0x80000000, 0x80000000

SECTION .text

INIT_XMM avx2
cglobal bisect, 0, 0, 0
    vaddss        xmm0, xmm0, xmm1
    vmulss        xmm0, xmm0, [chalf]
    vmulss        xmm0, xmm0, [cfour]
    vmovss        xmm2, [chalf]
    vandps        xmm1, xmm0, [csign]
    vorps         xmm1, xmm1, xmm2
    vaddss        xmm0, xmm0, xmm1
    vroundss      xmm0, xmm0, xmm0, 0xb
    vmulss        xmm0, xmm0, [cquarter]
    RET
