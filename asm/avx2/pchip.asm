%include "dav1d_x86inc.asm"

SECTION_RODATA 16
f2:    dd 0x40000000    ; 2.0f
f1:    dd 0x3f800000    ; 1.0f
f3:    dd 0x40400000    ; 3.0f
fm3:   dd 0xc0400000    ; -3.0f
fm2:   dd 0xc0000000    ; -2.0f
f9:    dd 0x41100000    ; 9.0f
fsgn:  dd 0x80000000

SECTION .text

INIT_XMM avx2
cglobal pchip, 5, 9, 0, x, y, n, s, d
    xor           r5d, r5d
    xor           eax, eax
    mov           r7, nq
    dec           r7
.find:
    cmp           rax, r7
    jae           .find_done
    vmovss        xmm1, [xq + rax*4]
    vmovss        xmm2, [xq + rax*4 + 4]
    vucomiss      xmm0, xmm1
    jb            .find_next
    vucomiss      xmm2, xmm0
    jb            .find_next
    mov           r5, rax
    jmp           .find_done
.find_next:
    inc           rax
    jmp           .find
.find_done:

    xor           eax, eax
.s4:
    lea           r8, [rax + 4]
    cmp           r8, r7
    ja            .s1
    vmovups       xmm1, [yq + rax*4 + 4]
    vmovups       xmm2, [yq + rax*4]
    vsubps        xmm1, xmm1, xmm2
    vmovups       xmm2, [xq + rax*4 + 4]
    vmovups       xmm3, [xq + rax*4]
    vsubps        xmm2, xmm2, xmm3
    vrcpps        xmm3, xmm2
    vmulps        xmm1, xmm1, xmm3
    vmovups       [sq + rax*4], xmm1
    add           rax, 4
    jmp           .s4
.s1:
    cmp           rax, r7
    jae           .s_done
    vmovss        xmm1, [yq + rax*4 + 4]
    vmovss        xmm2, [yq + rax*4]
    vsubss        xmm1, xmm1, xmm2
    vmovss        xmm2, [xq + rax*4 + 4]
    vmovss        xmm3, [xq + rax*4]
    vsubss        xmm2, xmm2, xmm3
    vrcpss        xmm3, xmm2, xmm2
    vmulss        xmm1, xmm1, xmm3
    vmovss        [sq + rax*4], xmm1
    inc           rax
    jmp           .s1
.s_done:

    vmovss        xmm1, [sq]
    vmovss        [dq], xmm1
    vmovss        xmm1, [sq + r7*4 - 4]
    vmovss        [dq + r7*4], xmm1

    mov           rax, 1
.d1:
    cmp           rax, r7
    jae           .d1_done
    vmovss        xmm2, [sq + rax*4 - 4]
    vmovss        xmm3, [sq + rax*4]
    vmulss        xmm4, xmm2, xmm3
    vxorps        xmm5, xmm5, xmm5
    vucomiss      xmm5, xmm4
    jae           .d1_zero
    vmovss        xmm6, [xq + rax*4]
    vmovss        xmm7, [xq + rax*4 - 4]
    vsubss        xmm10, xmm6, xmm7
    vmovss        xmm6, [xq + rax*4 + 4]
    vmovss        xmm7, [xq + rax*4]
    vsubss        xmm11, xmm6, xmm7
    vmovss        xmm8, [f2]
    vmovss        xmm6, xmm10, xmm10
    vfmadd231ss   xmm6, xmm8, xmm11
    vmovss        xmm9, xmm11, xmm11
    vfmadd231ss   xmm9, xmm8, xmm10
    vaddss        xmm12, xmm6, xmm9
    vrcpss        xmm7, xmm2, xmm2
    vmulss        xmm7, xmm6, xmm7
    vrcpss        xmm8, xmm3, xmm3
    vmulss        xmm8, xmm9, xmm8
    vaddss        xmm7, xmm7, xmm8
    vrcpss        xmm7, xmm7, xmm7
    vmulss        xmm12, xmm12, xmm7
    vmovss        [dq + rax*4], xmm12
    inc           rax
    jmp           .d1
.d1_zero:
    vxorps        xmm5, xmm5, xmm5
    vmovss        [dq + rax*4], xmm5
    inc           rax
    jmp           .d1
.d1_done:

    xor           eax, eax
.d2:
    cmp           rax, r7
    jae           .d2_done
    vmovss        xmm4, [sq + rax*4]
    vxorps        xmm5, xmm5, xmm5
    vucomiss      xmm4, xmm5
    jne           .d2_e
    jnp           .d2_zero
.d2_e:
    vmovss        xmm5, [dq + rax*4]
    vmovss        xmm6, [dq + rax*4 + 4]
    vrcpss        xmm7, xmm4, xmm4
    vmulss        xmm5, xmm5, xmm7
    vmulss        xmm6, xmm6, xmm7
    vmulss        xmm8, xmm5, xmm5
    vfmadd231ss   xmm8, xmm6, xmm6
    vmovss        xmm9, [f9]
    vucomiss      xmm8, xmm9
    jbe           .d2_next
    vrsqrtss      xmm8, xmm8, xmm8
    vmovss        xmm9, [f3]
    vmulss        xmm9, xmm9, xmm8
    vmulss        xmm5, xmm5, xmm9
    vmulss        xmm5, xmm5, xmm4
    vmulss        xmm6, xmm6, xmm9
    vmulss        xmm6, xmm6, xmm4
    vmovss        [dq + rax*4], xmm5
    vmovss        [dq + rax*4 + 4], xmm6
.d2_next:
    inc           rax
    jmp           .d2
.d2_zero:
    vxorps        xmm5, xmm5, xmm5
    vmovss        [dq + rax*4], xmm5
    vmovss        [dq + rax*4 + 4], xmm5
    inc           rax
    jmp           .d2
.d2_done:

    vmovss        xmm5, [xq + r5*4]
    vmovss        xmm6, [xq + r5*4 + 4]
    vsubss        xmm1, xmm6, xmm5
    vsubss        xmm2, xmm0, xmm5
    vrcpss        xmm3, xmm1, xmm1
    vmulss        xmm2, xmm2, xmm3
    vmulss        xmm3, xmm2, xmm2
    vmulss        xmm4, xmm3, xmm2
    vmovss        xmm8, [f2]
    vmovss        xmm5, [fm3]
    vmulss        xmm5, xmm5, xmm3
    vfmadd231ss   xmm5, xmm8, xmm4
    vaddss        xmm5, xmm5, [f1]
    vmovss        xmm6, xmm3, xmm3
    vxorps        xmm6, xmm6, [fsgn]
    vmovss        xmm9, xmm4, xmm4
    vfmadd231ss   xmm9, xmm8, xmm6
    vaddss        xmm9, xmm9, xmm2
    vmovss        xmm10, [f3]
    vmulss        xmm10, xmm10, xmm3
    vmovss        xmm6, [fm2]
    vfmadd231ss   xmm10, xmm6, xmm4
    vsubss        xmm11, xmm4, xmm3
    vmovss        xmm12, [yq + r5*4]
    vmovss        xmm13, [yq + r5*4 + 4]
    vmovss        xmm14, [dq + r5*4]
    vmovss        xmm15, [dq + r5*4 + 4]
    vmulss        xmm10, xmm10, xmm13
    vmulss        xmm11, xmm11, xmm1
    vfmadd231ss   xmm10, xmm11, xmm15
    vmulss        xmm9, xmm9, xmm1
    vfmadd231ss   xmm10, xmm9, xmm14
    vfmadd231ss   xmm10, xmm5, xmm12
    vmovaps       xmm0, xmm10
    RET
