%include "dav1d_x86inc.asm"

SECTION_RODATA 16
c2x:  dd 0x40000000, 0x40000000, 0x40000000, 0x40000000   ; [2.0f x4]
c1:   dd 0x3f800000           ; 1.0f
c2:   dd 0x40000000           ; 2.0f
c3:   dd 0x40400000           ; 3.0f
cm2:  dd 0xc0000000           ; -2.0f

SECTION .text

INIT_XMM avx2
cglobal fc_spline, 2, 3, 0, x, y
    vmovaps       xmm1, xmm0
    vmovsd        xmm0, [yq + 4]
    vmovsd        xmm4, [xq + 4]
    vxorps        xmm3, xmm3, xmm3
    vmovsd        xmm2, [yq]
    vsubps        xmm0, xmm0, xmm2
    vmovsd        xmm5, [xq]
    vsubps        xmm5, xmm4, xmm5
    vrcpps        xmm6, xmm5
    vmulps        xmm2, xmm0, xmm6
    vshufps       xmm0, xmm2, xmm2, 1
    vmulss        xmm6, xmm2, xmm0
    vucomiss      xmm3, xmm6
    jae           .skip
    vshufps       xmm3, xmm5, xmm5, 1
    vfmadd231ps   xmm3, xmm5, [c2x]
    vrcpps        xmm6, xmm0
    vmulps        xmm5, xmm3, xmm6
    vshufps       xmm6, xmm3, xmm3, 1
    vaddss        xmm3, xmm6, xmm3
    vshufps       xmm6, xmm5, xmm5, 1
    vaddss        xmm5, xmm6, xmm5
    vrcpss        xmm6, xmm5, xmm5
    vmulss        xmm3, xmm3, xmm6
.skip:
    vcmpss        xmm5, xmm4, xmm1, 2
    vshufps       xmm4, xmm4, xmm4, 1
    vcmpss        xmm4, xmm1, xmm4, 2
    vandps        xmm4, xmm5, xmm4
    vmovd         eax, xmm4
    mov           ecx, eax
    and           eax, 1
    shl           eax, 2
    vmovss        xmm4, [xq + rax]
    vmovss        xmm5, [xq + rax + 4]
    test          cl, 1
    jne           .k1a
    vmovaps       xmm0, xmm3
.k1a:
    vsubss        xmm5, xmm5, xmm4
    jne           .k1b
    vmovaps       xmm3, xmm2
.k1b:
    vsubss        xmm1, xmm1, xmm4
    vmovss        xmm9, [c3]
    vmulss        xmm2, xmm5, xmm3
    vmovss        xmm8, [cm2]
    vrcpss        xmm6, xmm5, xmm5
    vmulss        xmm1, xmm1, xmm6
    vmulss        xmm3, xmm1, xmm1
    vmulss        xmm4, xmm1, xmm3
    vmulss        xmm7, xmm9, xmm3
    vfnmadd213ss  xmm9, xmm3, [c1]
    vaddss        xmm1, xmm1, xmm4
    vsubss        xmm6, xmm4, xmm3
    vfmadd231ss   xmm7, xmm4, xmm8
    vfmadd231ss   xmm9, xmm4, [c2]
    vfmadd231ss   xmm1, xmm3, xmm8
    vmulss        xmm3, xmm7, [yq + rax + 4]
    vmulss        xmm5, xmm5, xmm6
    vfmadd231ss   xmm3, xmm2, xmm1
    vfmadd231ss   xmm3, xmm9, [yq + rax]
    vfmadd213ss   xmm0, xmm5, xmm3
    RET
