%include "dav1d_x86inc.asm"

SECTION_RODATA 64
fm32:   dd 0x007FFFFF, 0, 0, 0
s2f32:  dd 0x003504F3, 0, 0, 0
b23:    dd 0x00800000, 0, 0, 0
h32:    dd 0x3F000000, 0, 0, 0
i127:   dd 127, 0, 0, 0
one32:  dd 0x3F800000, 0, 0, 0
c5th:   dd 0x3E4CCCCD
c3rd:   dd 0x3EAAAAAB
l2e32:  dd 0x3FB8AA3B
ln232:  dd 0x3F317218
e5:     dd 0x3C088889
e4:     dd 0x3D2AAAAB
e3:     dd 0x3E2AAAAB
fmask:  dq 0x000FFFFFFFFFFFFF, 0
s2frac: dq 0x0006A09E667F3BCD, 0
bit52:  dq 0x0010000000000000, 0
magic:  dq 0x4330000000000000, 0
m1023:  dq 0x43300000000003FF
half:   dq 0x3FE0000000000000
one:    dq 0x3FF0000000000000
p5:     dq 0x3FC999999999999A
p3:     dq 0x3FD5555555555555
l2e:    dq 0x3FF71547652B82FE
l102:   dq 0x3FD34413509F79FF

SECTION .text

INIT_XMM avx2
cglobal powf32, 0, 0, 6
    vpand        xmm3, xmm0, [fm32]
    vpsrld       xmm2, xmm0, 23
    vpor         xmm4, xmm3, [h32]
    vpcmpgtd     xmm0, xmm3, [s2f32]
    vpandn       xmm3, xmm0, [b23]
    vpsubd       xmm2, xmm2, [i127]
    vpor         xmm4, xmm4, xmm3
    vcvtdq2ps    xmm2, xmm2
    vmovss       xmm3, [one32]
    vandps       xmm0, xmm0, xmm3
    vaddss       xmm2, xmm2, xmm0
    vsubss       xmm5, xmm4, xmm3
    vaddss       xmm4, xmm4, xmm3
    vdivss       xmm5, xmm5, xmm4
    vmulss       xmm4, xmm5, xmm5
    vmovss       xmm0, [c5th]
    vfmadd213ss  xmm0, xmm4, [c3rd]
    vfmadd213ss  xmm0, xmm4, xmm3
    vaddss       xmm5, xmm5, xmm5
    vmulss       xmm5, xmm5, xmm0
    vfmadd132ss  xmm5, xmm2, [l2e32]
    vmulss       xmm5, xmm5, xmm1
    vroundss     xmm3, xmm5, xmm5, 8
    vcvtps2dq    xmm2, xmm3
    vsubss       xmm5, xmm5, xmm3
    vpslld       xmm2, xmm2, 23
    vpaddd       xmm2, xmm2, [one32]
    vmulss       xmm5, xmm5, [ln232]
    vmulss       xmm4, xmm5, xmm5
    vmovss       xmm0, [e5]
    vfmadd213ss  xmm0, xmm5, [e4]
    vmovss       xmm3, [e3]
    vfmadd213ss  xmm3, xmm5, [h32]
    vfmadd213ss  xmm0, xmm4, xmm3
    vaddss       xmm5, xmm5, [one32]
    vfmadd213ss  xmm0, xmm4, xmm5
    vmulss       xmm0, xmm0, xmm2
    RET

cglobal log10, 0, 0, 6
    vpand        xmm1, xmm0, [fmask]
    vpsrlq       xmm2, xmm0, 52
    vpor         xmm3, xmm1, [half]
    vpcmpgtq     xmm1, xmm1, [s2frac]
    vpandn       xmm4, xmm1, [bit52]
    vpor         xmm3, xmm3, xmm4
    vpor         xmm2, xmm2, [magic]
    vsubsd       xmm2, xmm2, [m1023]
    vmovsd       xmm4, [one]
    vandpd       xmm1, xmm1, xmm4
    vaddsd       xmm2, xmm2, xmm1
    vsubsd       xmm5, xmm3, xmm4
    vaddsd       xmm3, xmm3, xmm4
    vdivsd       xmm5, xmm5, xmm3
    vmulsd       xmm3, xmm5, xmm5
    vmovsd       xmm0, [p5]
    vfmadd213sd  xmm0, xmm3, [p3]
    vfmadd213sd  xmm0, xmm3, xmm4
    vaddsd       xmm5, xmm5, xmm5
    vmulsd       xmm5, xmm5, xmm0
    vfmadd132sd  xmm5, xmm2, [l2e]
    vmulsd       xmm0, xmm5, [l102]
    RET
