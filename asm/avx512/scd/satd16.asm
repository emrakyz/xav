%include "dav1d_x86inc.asm"

SECTION_RODATA 64
idx0: dd 0, 4, 8, 12, 16, 20, 24, 28, 0, 0, 0, 0, 0, 0, 0, 0
idx1: dd 1, 5, 9, 13, 17, 21, 25, 29, 0, 0, 0, 0, 0, 0, 0, 0
idx2: dd 2, 6, 10, 14, 18, 22, 26, 30, 0, 0, 0, 0, 0, 0, 0, 0
idx3: dd 3, 7, 11, 15, 19, 23, 27, 31, 0, 0, 0, 0, 0, 0, 0, 0
pw_1: dd 0x00010001
pd_2: dd 2

%macro SATD16_SETUP 0
    lea     ss3q, [ssq*3]
    lea     ds3q, [dsq*3]
    lea     src4q, [srcq+ssq*4]
    lea     dst4q, [dstq+dsq*4]
%endmacro

%macro SATD16_WHT 0
    vpaddw  zmm8,  zmm0, zmm1
    vpsubw  zmm9,  zmm0, zmm1
    vpaddw  zmm10, zmm2, zmm3
    vpsubw  zmm11, zmm2, zmm3
    vpaddw  zmm12, zmm4, zmm5
    vpsubw  zmm13, zmm4, zmm5
    vpaddw  zmm14, zmm6, zmm7
    vpsubw  zmm15, zmm6, zmm7
    vpaddw  zmm24, zmm16, zmm17
    vpsubw  zmm25, zmm16, zmm17
    vpaddw  zmm26, zmm18, zmm19
    vpsubw  zmm27, zmm18, zmm19
    vpaddw  zmm28, zmm20, zmm21
    vpsubw  zmm29, zmm20, zmm21
    vpaddw  zmm30, zmm22, zmm23
    vpsubw  zmm31, zmm22, zmm23
    vpaddw  zmm0, zmm8,  zmm10
    vpsubw  zmm2, zmm8,  zmm10
    vpaddw  zmm1, zmm9,  zmm11
    vpsubw  zmm3, zmm9,  zmm11
    vpaddw  zmm4, zmm12, zmm14
    vpsubw  zmm6, zmm12, zmm14
    vpaddw  zmm5, zmm13, zmm15
    vpsubw  zmm7, zmm13, zmm15
    vpaddw  zmm16, zmm24, zmm26
    vpsubw  zmm18, zmm24, zmm26
    vpaddw  zmm17, zmm25, zmm27
    vpsubw  zmm19, zmm25, zmm27
    vpaddw  zmm20, zmm28, zmm30
    vpsubw  zmm22, zmm28, zmm30
    vpaddw  zmm21, zmm29, zmm31
    vpsubw  zmm23, zmm29, zmm31
    vpaddw  zmm8,  zmm0, zmm4
    vpsubw  zmm12, zmm0, zmm4
    vpaddw  zmm9,  zmm1, zmm5
    vpsubw  zmm13, zmm1, zmm5
    vpaddw  zmm10, zmm2, zmm6
    vpsubw  zmm14, zmm2, zmm6
    vpaddw  zmm11, zmm3, zmm7
    vpsubw  zmm15, zmm3, zmm7
    vpaddw  zmm24, zmm16, zmm20
    vpsubw  zmm28, zmm16, zmm20
    vpaddw  zmm25, zmm17, zmm21
    vpsubw  zmm29, zmm17, zmm21
    vpaddw  zmm26, zmm18, zmm22
    vpsubw  zmm30, zmm18, zmm22
    vpaddw  zmm27, zmm19, zmm23
    vpsubw  zmm31, zmm19, zmm23
    vpunpcklwd zmm0, zmm8,  zmm9
    vpunpckhwd zmm1, zmm8,  zmm9
    vpunpcklwd zmm2, zmm10, zmm11
    vpunpckhwd zmm3, zmm10, zmm11
    vpunpcklwd zmm4, zmm12, zmm13
    vpunpckhwd zmm5, zmm12, zmm13
    vpunpcklwd zmm6, zmm14, zmm15
    vpunpckhwd zmm7, zmm14, zmm15
    vpunpcklwd zmm16, zmm24, zmm25
    vpunpckhwd zmm17, zmm24, zmm25
    vpunpcklwd zmm18, zmm26, zmm27
    vpunpckhwd zmm19, zmm26, zmm27
    vpunpcklwd zmm20, zmm28, zmm29
    vpunpckhwd zmm21, zmm28, zmm29
    vpunpcklwd zmm22, zmm30, zmm31
    vpunpckhwd zmm23, zmm30, zmm31
    vpunpckldq zmm8,  zmm0, zmm2
    vpunpckhdq zmm9,  zmm0, zmm2
    vpunpckldq zmm10, zmm1, zmm3
    vpunpckhdq zmm11, zmm1, zmm3
    vpunpckldq zmm12, zmm4, zmm6
    vpunpckhdq zmm13, zmm4, zmm6
    vpunpckldq zmm14, zmm5, zmm7
    vpunpckhdq zmm15, zmm5, zmm7
    vpunpckldq zmm24, zmm16, zmm18
    vpunpckhdq zmm25, zmm16, zmm18
    vpunpckldq zmm26, zmm17, zmm19
    vpunpckhdq zmm27, zmm17, zmm19
    vpunpckldq zmm28, zmm20, zmm22
    vpunpckhdq zmm29, zmm20, zmm22
    vpunpckldq zmm30, zmm21, zmm23
    vpunpckhdq zmm31, zmm21, zmm23
    vpunpcklqdq zmm0, zmm8,  zmm12
    vpunpckhqdq zmm1, zmm8,  zmm12
    vpunpcklqdq zmm2, zmm9,  zmm13
    vpunpckhqdq zmm3, zmm9,  zmm13
    vpunpcklqdq zmm4, zmm10, zmm14
    vpunpckhqdq zmm5, zmm10, zmm14
    vpunpcklqdq zmm6, zmm11, zmm15
    vpunpckhqdq zmm7, zmm11, zmm15
    vpunpcklqdq zmm16, zmm24, zmm28
    vpunpckhqdq zmm17, zmm24, zmm28
    vpunpcklqdq zmm18, zmm25, zmm29
    vpunpckhqdq zmm19, zmm25, zmm29
    vpunpcklqdq zmm20, zmm26, zmm30
    vpunpckhqdq zmm21, zmm26, zmm30
    vpunpcklqdq zmm22, zmm27, zmm31
    vpunpckhqdq zmm23, zmm27, zmm31
    vpaddw  zmm8,  zmm0, zmm1
    vpsubw  zmm9,  zmm0, zmm1
    vpaddw  zmm10, zmm2, zmm3
    vpsubw  zmm11, zmm2, zmm3
    vpaddw  zmm12, zmm4, zmm5
    vpsubw  zmm13, zmm4, zmm5
    vpaddw  zmm14, zmm6, zmm7
    vpsubw  zmm15, zmm6, zmm7
    vpaddw  zmm24, zmm16, zmm17
    vpsubw  zmm25, zmm16, zmm17
    vpaddw  zmm26, zmm18, zmm19
    vpsubw  zmm27, zmm18, zmm19
    vpaddw  zmm28, zmm20, zmm21
    vpsubw  zmm29, zmm20, zmm21
    vpaddw  zmm30, zmm22, zmm23
    vpsubw  zmm31, zmm22, zmm23
    vpaddw  zmm0, zmm8,  zmm10
    vpsubw  zmm2, zmm8,  zmm10
    vpaddw  zmm1, zmm9,  zmm11
    vpsubw  zmm3, zmm9,  zmm11
    vpaddw  zmm4, zmm12, zmm14
    vpsubw  zmm6, zmm12, zmm14
    vpaddw  zmm5, zmm13, zmm15
    vpsubw  zmm7, zmm13, zmm15
    vpaddw  zmm16, zmm24, zmm26
    vpsubw  zmm18, zmm24, zmm26
    vpaddw  zmm17, zmm25, zmm27
    vpsubw  zmm19, zmm25, zmm27
    vpaddw  zmm20, zmm28, zmm30
    vpsubw  zmm22, zmm28, zmm30
    vpaddw  zmm21, zmm29, zmm31
    vpsubw  zmm23, zmm29, zmm31
    vpabsw  zmm8,  zmm0
    vpabsw  zmm9,  zmm4
    vpmaxsw zmm8,  zmm8, zmm9
    vpabsw  zmm9,  zmm1
    vpabsw  zmm10, zmm5
    vpmaxsw zmm9,  zmm9, zmm10
    vpabsw  zmm10, zmm2
    vpabsw  zmm11, zmm6
    vpmaxsw zmm10, zmm10, zmm11
    vpabsw  zmm11, zmm3
    vpabsw  zmm12, zmm7
    vpmaxsw zmm11, zmm11, zmm12
    vpabsw  zmm24, zmm16
    vpabsw  zmm25, zmm20
    vpmaxsw zmm24, zmm24, zmm25
    vpabsw  zmm25, zmm17
    vpabsw  zmm26, zmm21
    vpmaxsw zmm25, zmm25, zmm26
    vpabsw  zmm26, zmm18
    vpabsw  zmm27, zmm22
    vpmaxsw zmm26, zmm26, zmm27
    vpabsw  zmm27, zmm19
    vpabsw  zmm28, zmm23
    vpmaxsw zmm27, zmm27, zmm28
    vpbroadcastd zmm0, [pw_1]
    vpmaddwd zmm8,  zmm8,  zmm0
    vpdpwssd zmm8,  zmm9,  zmm0
    vpdpwssd zmm8,  zmm10, zmm0
    vpdpwssd zmm8,  zmm11, zmm0
    vpmaddwd zmm24, zmm24, zmm0
    vpdpwssd zmm24, zmm25, zmm0
    vpdpwssd zmm24, zmm26, zmm0
    vpdpwssd zmm24, zmm27, zmm0
    vmovdqu32 zmm1, [idx0]
    vpermi2d  zmm1, zmm8, zmm24
    vmovdqu32 zmm2, [idx1]
    vpermi2d  zmm2, zmm8, zmm24
    vmovdqu32 zmm3, [idx2]
    vpermi2d  zmm3, zmm8, zmm24
    vmovdqu32 zmm4, [idx3]
    vpermi2d  zmm4, zmm8, zmm24
    vpaddd   zmm1, zmm1, zmm2
    vpaddd   zmm3, zmm3, zmm4
    vpaddd   zmm1, zmm1, zmm3
    vpaddd   zmm1, zmm1, [pd_2]{1to16}
    vpsrld   zmm0, zmm1, 2
    vextracti128 xmm1, ymm0, 1
    vpaddd  xmm0, xmm0, xmm1
    vpshufd xmm1, xmm0, 0x4e
    vpaddd  xmm0, xmm0, xmm1
    vpshufd xmm1, xmm0, 0xb1
    vpaddd  xmm0, xmm0, xmm1
    vmovd   eax, xmm0
%endmacro

SECTION .text
INIT_ZMM avx512

cglobal satd16_x8, 4, 8, 16, src, ss, dst, ds, src4, dst4, ss3, ds3
    SATD16_SETUP
    vmovdqu64 zmm0, [srcq]
    vpsubw    zmm0, zmm0, [dstq]
    vmovdqu64 zmm1, [srcq+ssq]
    vpsubw    zmm1, zmm1, [dstq+dsq]
    vmovdqu64 zmm2, [srcq+ssq*2]
    vpsubw    zmm2, zmm2, [dstq+dsq*2]
    vmovdqu64 zmm3, [srcq+ss3q]
    vpsubw    zmm3, zmm3, [dstq+ds3q]
    vmovdqu64 zmm4, [src4q]
    vpsubw    zmm4, zmm4, [dst4q]
    vmovdqu64 zmm5, [src4q+ssq]
    vpsubw    zmm5, zmm5, [dst4q+dsq]
    vmovdqu64 zmm6, [src4q+ssq*2]
    vpsubw    zmm6, zmm6, [dst4q+dsq*2]
    vmovdqu64 zmm7, [src4q+ss3q]
    vpsubw    zmm7, zmm7, [dst4q+ds3q]
    vmovdqu64 zmm16, [srcq+64]
    vpsubw    zmm16, zmm16, [dstq+64]
    vmovdqu64 zmm17, [srcq+ssq+64]
    vpsubw    zmm17, zmm17, [dstq+dsq+64]
    vmovdqu64 zmm18, [srcq+ssq*2+64]
    vpsubw    zmm18, zmm18, [dstq+dsq*2+64]
    vmovdqu64 zmm19, [srcq+ss3q+64]
    vpsubw    zmm19, zmm19, [dstq+ds3q+64]
    vmovdqu64 zmm20, [src4q+64]
    vpsubw    zmm20, zmm20, [dst4q+64]
    vmovdqu64 zmm21, [src4q+ssq+64]
    vpsubw    zmm21, zmm21, [dst4q+dsq+64]
    vmovdqu64 zmm22, [src4q+ssq*2+64]
    vpsubw    zmm22, zmm22, [dst4q+dsq*2+64]
    vmovdqu64 zmm23, [src4q+ss3q+64]
    vpsubw    zmm23, zmm23, [dst4q+ds3q+64]
    SATD16_WHT
    RET

cglobal satd16_s_x8, 4, 8, 16, src, ss, dst, ds, src4, dst4, ss3, ds3
    SATD16_SETUP
    vpsrlw    zmm0, [srcq], 6
    vpsrlw    zmm8, [dstq], 6
    vpsubw    zmm0, zmm0, zmm8
    vpsrlw    zmm1, [srcq+ssq], 6
    vpsrlw    zmm8, [dstq+dsq], 6
    vpsubw    zmm1, zmm1, zmm8
    vpsrlw    zmm2, [srcq+ssq*2], 6
    vpsrlw    zmm8, [dstq+dsq*2], 6
    vpsubw    zmm2, zmm2, zmm8
    vpsrlw    zmm3, [srcq+ss3q], 6
    vpsrlw    zmm8, [dstq+ds3q], 6
    vpsubw    zmm3, zmm3, zmm8
    vpsrlw    zmm4, [src4q], 6
    vpsrlw    zmm8, [dst4q], 6
    vpsubw    zmm4, zmm4, zmm8
    vpsrlw    zmm5, [src4q+ssq], 6
    vpsrlw    zmm8, [dst4q+dsq], 6
    vpsubw    zmm5, zmm5, zmm8
    vpsrlw    zmm6, [src4q+ssq*2], 6
    vpsrlw    zmm8, [dst4q+dsq*2], 6
    vpsubw    zmm6, zmm6, zmm8
    vpsrlw    zmm7, [src4q+ss3q], 6
    vpsrlw    zmm8, [dst4q+ds3q], 6
    vpsubw    zmm7, zmm7, zmm8
    vpsrlw    zmm16, [srcq+64], 6
    vpsrlw    zmm8, [dstq+64], 6
    vpsubw    zmm16, zmm16, zmm8
    vpsrlw    zmm17, [srcq+ssq+64], 6
    vpsrlw    zmm8, [dstq+dsq+64], 6
    vpsubw    zmm17, zmm17, zmm8
    vpsrlw    zmm18, [srcq+ssq*2+64], 6
    vpsrlw    zmm8, [dstq+dsq*2+64], 6
    vpsubw    zmm18, zmm18, zmm8
    vpsrlw    zmm19, [srcq+ss3q+64], 6
    vpsrlw    zmm8, [dstq+ds3q+64], 6
    vpsubw    zmm19, zmm19, zmm8
    vpsrlw    zmm20, [src4q+64], 6
    vpsrlw    zmm8, [dst4q+64], 6
    vpsubw    zmm20, zmm20, zmm8
    vpsrlw    zmm21, [src4q+ssq+64], 6
    vpsrlw    zmm8, [dst4q+dsq+64], 6
    vpsubw    zmm21, zmm21, zmm8
    vpsrlw    zmm22, [src4q+ssq*2+64], 6
    vpsrlw    zmm8, [dst4q+dsq*2+64], 6
    vpsubw    zmm22, zmm22, zmm8
    vpsrlw    zmm23, [src4q+ss3q+64], 6
    vpsrlw    zmm8, [dst4q+ds3q+64], 6
    vpsubw    zmm23, zmm23, zmm8
    SATD16_WHT
    RET
