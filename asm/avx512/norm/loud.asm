%include "dav1d_x86inc.asm"

SECTION_RODATA 8
ra1: dq -1.99004745483397971206
ra2: dq 0.990072250366209938299
pa1: dq -1.69065929318241026102
pa2: dq 0.732480774215850116704
pb0: dq 1.53512485958697020294
pb1: dq -2.69169618940638066817
pb2: dq 1.19839281085285009887

SECTION .text
INIT_ZMM avx512
%if WIN64
WIN64_MMMAP 6, 23, 13
%endif
cglobal loud, 5, 13, 16, src, n, stride, st, out
    vbroadcastsd  zmm16, [ra1]
    vbroadcastsd  zmm17, [ra2]
    vbroadcastsd  zmm18, [pa1]
    vbroadcastsd  zmm19, [pa2]
    vbroadcastsd  zmm20, [pb0]
    vbroadcastsd  zmm21, [pb1]
    vbroadcastsd  zmm22, [pb2]
    vmovups       zmm8, [stq]
    vmovups       zmm9, [stq + 0x40]
    vmovups       zmm10, [stq + 0x80]
    vmovups       zmm11, [stq + 0xc0]
    vpxorq        zmm12, zmm12, zmm12
    vpxorq        zmm13, zmm13, zmm13
    mov           r12, outq
    lea           r11, [strideq*8]
    lea           r8, [srcq + r11]
    lea           r9, [srcq + r11*2]
    lea           r10, [r9 + r11]
    mov           r11, nq
    and           r11, -2
    xor           eax, eax
    cmp           rax, r11
    jae           .tail
.loop:
    vcvtps2pd     xmm0, [srcq + rax*8]
    vcvtps2pd     xmm1, [r8 + rax*8]
    vcvtps2pd     xmm2, [r9 + rax*8]
    vcvtps2pd     xmm3, [r10 + rax*8]
    vinsertf64x2  zmm0, zmm0, xmm1, 1
    vinsertf64x2  zmm0, zmm0, xmm2, 2
    vinsertf64x2  zmm0, zmm0, xmm3, 3
    vcvtps2pd     xmm4, [srcq + rax*8 + 8]
    vcvtps2pd     xmm5, [r8 + rax*8 + 8]
    vcvtps2pd     xmm6, [r9 + rax*8 + 8]
    vcvtps2pd     xmm7, [r10 + rax*8 + 8]
    vinsertf64x2  zmm4, zmm4, xmm5, 1
    vinsertf64x2  zmm4, zmm4, xmm6, 2
    vinsertf64x2  zmm4, zmm4, xmm7, 3
    vfnmadd231pd  zmm0, zmm17, zmm9
    vfnmadd231pd  zmm0, zmm16, zmm8
    vsubpd        zmm1, zmm0, zmm8
    vsubpd        zmm2, zmm8, zmm9
    vsubpd        zmm1, zmm1, zmm2
    vfnmadd231pd  zmm1, zmm19, zmm11
    vfnmadd231pd  zmm1, zmm18, zmm10
    vmulpd        zmm2, zmm22, zmm11
    vfmadd231pd   zmm2, zmm21, zmm10
    vfmadd231pd   zmm2, zmm20, zmm1
    vfmadd231pd   zmm12, zmm2, zmm2
    vfnmadd231pd  zmm4, zmm17, zmm8
    vfnmadd231pd  zmm4, zmm16, zmm0
    vsubpd        zmm5, zmm4, zmm0
    vsubpd        zmm6, zmm0, zmm8
    vsubpd        zmm5, zmm5, zmm6
    vfnmadd231pd  zmm5, zmm19, zmm10
    vfnmadd231pd  zmm5, zmm18, zmm1
    vmulpd        zmm6, zmm22, zmm10
    vfmadd231pd   zmm6, zmm21, zmm1
    vfmadd231pd   zmm6, zmm20, zmm5
    vfmadd231pd   zmm13, zmm6, zmm6
    vmovapd       zmm8, zmm4
    vmovapd       zmm9, zmm0
    vmovapd       zmm10, zmm5
    vmovapd       zmm11, zmm1
    add           rax, 2
    cmp           rax, r11
    jb            .loop
.tail:
    cmp           rax, nq
    jae           .done
    vcvtps2pd     xmm0, [srcq + rax*8]
    vcvtps2pd     xmm1, [r8 + rax*8]
    vcvtps2pd     xmm2, [r9 + rax*8]
    vcvtps2pd     xmm3, [r10 + rax*8]
    vinsertf64x2  zmm0, zmm0, xmm1, 1
    vinsertf64x2  zmm0, zmm0, xmm2, 2
    vinsertf64x2  zmm0, zmm0, xmm3, 3
    vfnmadd231pd  zmm0, zmm17, zmm9
    vfnmadd231pd  zmm0, zmm16, zmm8
    vsubpd        zmm1, zmm0, zmm8
    vsubpd        zmm2, zmm8, zmm9
    vsubpd        zmm1, zmm1, zmm2
    vfnmadd231pd  zmm1, zmm19, zmm11
    vfnmadd231pd  zmm1, zmm18, zmm10
    vmulpd        zmm2, zmm22, zmm11
    vfmadd231pd   zmm2, zmm21, zmm10
    vfmadd231pd   zmm2, zmm20, zmm1
    vfmadd231pd   zmm12, zmm2, zmm2
    vmovapd       zmm9, zmm8
    vmovapd       zmm8, zmm0
    vmovapd       zmm11, zmm10
    vmovapd       zmm10, zmm1
    inc           rax
    jmp           .tail
.done:
    vmovups       [stq], zmm8
    vmovups       [stq + 0x40], zmm9
    vmovups       [stq + 0x80], zmm10
    vmovups       [stq + 0xc0], zmm11
%if WIN64                             ; vhaddpd VEX only; land the reduction low
    vaddpd        zmm0, zmm12, zmm13
    vextractf64x4 ymm1, zmm0, 1
    vhaddpd       ymm0, ymm0, ymm1
%else
    vaddpd        zmm12, zmm12, zmm13
    vextractf64x4 ymm1, zmm12, 1
    vhaddpd       ymm0, ymm12, ymm1
%endif
    vpermpd       ymm0, ymm0, 0xd8
    vmovupd       [r12], ymm0
    RET
