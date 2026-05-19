%include "dav1d_x86inc.asm"

SECTION .text

INIT_XMM avx2
cglobal lerp, 2, 2, 0, x, y
    vmovss        xmm1, [xq]
    vmovss        xmm2, [xq + 4]
    vsubss        xmm0, xmm0, xmm1
    vsubss        xmm1, xmm2, xmm1
    vrcpss        xmm3, xmm1, xmm1
    vmulss        xmm1, xmm0, xmm3
    vmovss        xmm2, [yq]
    vmovss        xmm0, [yq + 4]
    vsubss        xmm0, xmm0, xmm2
    vfmadd213ss   xmm0, xmm1, xmm2
    RET
