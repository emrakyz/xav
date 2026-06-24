%include "dav1d_x86inc.asm"

SECTION_RODATA 32
pw_1: times 8 dd 0x00010001
pd_2: times 8 dd 2
pw_8c: times 16 dw 1024

SECTION .text align=64
INIT_YMM avx2
ALIGN 64
cglobal satd8x8_dc, 2, 4, 16, src, ss, src4, ss3
    lea     ss3q, [ssq*3]
    lea     src4q, [srcq+ssq*4]
    vpmovzxbw ymm0, [srcq]
    vpmovzxbw ymm1, [srcq+ssq]
    vpmovzxbw ymm2, [srcq+ssq*2]
    vpmovzxbw ymm3, [srcq+ss3q]
    vpmovzxbw ymm4, [src4q]
    vpmovzxbw ymm5, [src4q+ssq]
    vpmovzxbw ymm6, [src4q+ssq*2]
    vpmovzxbw ymm7, [src4q+ss3q]
    vpaddw  ymm8,  ymm0, ymm1
    vpsubw  ymm9,  ymm0, ymm1
    vpaddw  ymm10, ymm2, ymm3
    vpsubw  ymm11, ymm2, ymm3
    vpaddw  ymm12, ymm4, ymm5
    vpsubw  ymm13, ymm4, ymm5
    vpaddw  ymm14, ymm6, ymm7
    vpsubw  ymm15, ymm6, ymm7
    vpaddw  ymm0, ymm8,  ymm10
    vpsubw  ymm2, ymm8,  ymm10
    vpaddw  ymm1, ymm9,  ymm11
    vpsubw  ymm3, ymm9,  ymm11
    vpaddw  ymm4, ymm12, ymm14
    vpsubw  ymm6, ymm12, ymm14
    vpaddw  ymm5, ymm13, ymm15
    vpsubw  ymm7, ymm13, ymm15
    vpaddw  ymm8,  ymm0, ymm4
    vpsubw  ymm12, ymm0, ymm4
    vpaddw  ymm9,  ymm1, ymm5
    vpsubw  ymm13, ymm1, ymm5
    vpaddw  ymm10, ymm2, ymm6
    vpsubw  ymm14, ymm2, ymm6
    vpaddw  ymm11, ymm3, ymm7
    vpsubw  ymm15, ymm3, ymm7
    vpsubw  ymm8,  ymm8, [pw_8c]
    vpunpcklwd ymm0, ymm8,  ymm9
    vpunpckhwd ymm1, ymm8,  ymm9
    vpunpcklwd ymm2, ymm10, ymm11
    vpunpckhwd ymm3, ymm10, ymm11
    vpunpcklwd ymm4, ymm12, ymm13
    vpunpckhwd ymm5, ymm12, ymm13
    vpunpcklwd ymm6, ymm14, ymm15
    vpunpckhwd ymm7, ymm14, ymm15
    vpunpckldq ymm8,  ymm0, ymm2
    vpunpckhdq ymm9,  ymm0, ymm2
    vpunpckldq ymm10, ymm1, ymm3
    vpunpckhdq ymm11, ymm1, ymm3
    vpunpckldq ymm12, ymm4, ymm6
    vpunpckhdq ymm13, ymm4, ymm6
    vpunpckldq ymm14, ymm5, ymm7
    vpunpckhdq ymm15, ymm5, ymm7
    vpunpcklqdq ymm0, ymm8,  ymm12
    vpunpckhqdq ymm1, ymm8,  ymm12
    vpunpcklqdq ymm2, ymm9,  ymm13
    vpunpckhqdq ymm3, ymm9,  ymm13
    vpunpcklqdq ymm4, ymm10, ymm14
    vpunpckhqdq ymm5, ymm10, ymm14
    vpunpcklqdq ymm6, ymm11, ymm15
    vpunpckhqdq ymm7, ymm11, ymm15
    vpaddw  ymm8,  ymm0, ymm1
    vpsubw  ymm9,  ymm0, ymm1
    vpaddw  ymm10, ymm2, ymm3
    vpsubw  ymm11, ymm2, ymm3
    vpaddw  ymm12, ymm4, ymm5
    vpsubw  ymm13, ymm4, ymm5
    vpaddw  ymm14, ymm6, ymm7
    vpsubw  ymm15, ymm6, ymm7
    vpaddw  ymm0, ymm8,  ymm10
    vpsubw  ymm2, ymm8,  ymm10
    vpaddw  ymm1, ymm9,  ymm11
    vpsubw  ymm3, ymm9,  ymm11
    vpaddw  ymm4, ymm12, ymm14
    vpsubw  ymm6, ymm12, ymm14
    vpaddw  ymm5, ymm13, ymm15
    vpsubw  ymm7, ymm13, ymm15
    vpabsw  ymm8,  ymm0
    vpabsw  ymm9,  ymm4
    vpmaxsw ymm8,  ymm8, ymm9
    vpabsw  ymm9,  ymm1
    vpabsw  ymm10, ymm5
    vpmaxsw ymm9,  ymm9, ymm10
    vpabsw  ymm10, ymm2
    vpabsw  ymm11, ymm6
    vpmaxsw ymm10, ymm10, ymm11
    vpabsw  ymm11, ymm3
    vpabsw  ymm12, ymm7
    vpmaxsw ymm11, ymm11, ymm12
    vpaddw  ymm8,  ymm8, ymm9
    vpaddw  ymm10, ymm10, ymm11
    vpaddw  ymm8,  ymm8, ymm10
    vpmaddwd ymm8, ymm8, [pw_1]
    vpshufd  ymm9, ymm8, 0x4e
    vpaddd   ymm8, ymm8, ymm9
    vpshufd  ymm9, ymm8, 0xb1
    vpaddd   ymm8, ymm8, ymm9
    vpaddd   ymm0, ymm8, [pd_2]
    vpsrld   ymm0, ymm0, 2
    vextracti128 xmm1, ymm0, 1
    vpaddd   xmm0, xmm0, xmm1
    vmovd    eax, xmm0
    RET
