%include "dav1d_x86inc.asm"

SECTION_RODATA 32
pw_1: dd 0x00010001
pd_2: dd 2

%macro SATD16_SETUP 0
    lea     ss3q, [ssq*3]
    lea     ds3q, [dsq*3]
    lea     src4q, [srcq+ssq*4]
    lea     dst4q, [dstq+dsq*4]
%endmacro

%macro SATD16_WHT 0
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
    vpbroadcastd ymm12, [pw_1]
    vpmaddwd ymm8,  ymm8,  ymm12
    vpmaddwd ymm9,  ymm9,  ymm12
    vpmaddwd ymm10, ymm10, ymm12
    vpmaddwd ymm11, ymm11, ymm12
    vpaddd  ymm8,  ymm8,  ymm9
    vpaddd  ymm10, ymm10, ymm11
    vpaddd  ymm8,  ymm8,  ymm10
    vpshufd ymm9,  ymm8,  0x4e
    vpaddd  ymm8,  ymm8,  ymm9
    vpshufd ymm9,  ymm8,  0xb1
    vpaddd  ymm8,  ymm8,  ymm9
    vpbroadcastd ymm9, [pd_2]
    vpaddd  ymm0,  ymm8,  ymm9
    vpsrld  ymm0,  ymm0,  2
    vextracti128 xmm1, ymm0, 1
    vpaddd  xmm0, xmm0, xmm1
    vmovd   eax, xmm0
%endmacro

SECTION .text
INIT_YMM avx2

cglobal satd16_x2, 4, 8, 16, src, ss, dst, ds, src4, dst4, ss3, ds3
    SATD16_SETUP
    vmovdqu ymm0, [srcq]
    vpsubw  ymm0, ymm0, [dstq]
    vmovdqu ymm1, [srcq+ssq]
    vpsubw  ymm1, ymm1, [dstq+dsq]
    vmovdqu ymm2, [srcq+ssq*2]
    vpsubw  ymm2, ymm2, [dstq+dsq*2]
    vmovdqu ymm3, [srcq+ss3q]
    vpsubw  ymm3, ymm3, [dstq+ds3q]
    vmovdqu ymm4, [src4q]
    vpsubw  ymm4, ymm4, [dst4q]
    vmovdqu ymm5, [src4q+ssq]
    vpsubw  ymm5, ymm5, [dst4q+dsq]
    vmovdqu ymm6, [src4q+ssq*2]
    vpsubw  ymm6, ymm6, [dst4q+dsq*2]
    vmovdqu ymm7, [src4q+ss3q]
    vpsubw  ymm7, ymm7, [dst4q+ds3q]
    SATD16_WHT
    RET

cglobal satd16_s_x2, 4, 8, 16, src, ss, dst, ds, src4, dst4, ss3, ds3
    SATD16_SETUP
    vmovdqu ymm0, [srcq]
    vpsrlw ymm0, ymm0, 6
    vmovdqu ymm8, [dstq]
    vpsrlw ymm8, ymm8, 6
    vpsubw ymm0, ymm0, ymm8
    vmovdqu ymm1, [srcq+ssq]
    vpsrlw ymm1, ymm1, 6
    vmovdqu ymm8, [dstq+dsq]
    vpsrlw ymm8, ymm8, 6
    vpsubw ymm1, ymm1, ymm8
    vmovdqu ymm2, [srcq+ssq*2]
    vpsrlw ymm2, ymm2, 6
    vmovdqu ymm8, [dstq+dsq*2]
    vpsrlw ymm8, ymm8, 6
    vpsubw ymm2, ymm2, ymm8
    vmovdqu ymm3, [srcq+ss3q]
    vpsrlw ymm3, ymm3, 6
    vmovdqu ymm8, [dstq+ds3q]
    vpsrlw ymm8, ymm8, 6
    vpsubw ymm3, ymm3, ymm8
    vmovdqu ymm4, [src4q]
    vpsrlw ymm4, ymm4, 6
    vmovdqu ymm8, [dst4q]
    vpsrlw ymm8, ymm8, 6
    vpsubw ymm4, ymm4, ymm8
    vmovdqu ymm5, [src4q+ssq]
    vpsrlw ymm5, ymm5, 6
    vmovdqu ymm8, [dst4q+dsq]
    vpsrlw ymm8, ymm8, 6
    vpsubw ymm5, ymm5, ymm8
    vmovdqu ymm6, [src4q+ssq*2]
    vpsrlw ymm6, ymm6, 6
    vmovdqu ymm8, [dst4q+dsq*2]
    vpsrlw ymm8, ymm8, 6
    vpsubw ymm6, ymm6, ymm8
    vmovdqu ymm7, [src4q+ss3q]
    vpsrlw ymm7, ymm7, 6
    vmovdqu ymm8, [dst4q+ds3q]
    vpsrlw ymm8, ymm8, 6
    vpsubw ymm7, ymm7, ymm8
    SATD16_WHT
    RET
