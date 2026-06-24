%include "dav1d_x86inc.asm"

SECTION_RODATA 64
idx0: dd 0, 4, 8, 12, 16, 20, 24, 28, 0, 0, 0, 0, 0, 0, 0, 0
idx1: dd 1, 5, 9, 13, 17, 21, 25, 29, 0, 0, 0, 0, 0, 0, 0, 0
idx2: dd 2, 6, 10, 14, 18, 22, 26, 30, 0, 0, 0, 0, 0, 0, 0, 0
idx3: dd 3, 7, 11, 15, 19, 23, 27, 31, 0, 0, 0, 0, 0, 0, 0, 0
pw_1: times 16 dd 0x00010001
pd_2: dd 2
pw_8c: times 32 dw 1024

SECTION .text align=64
INIT_ZMM avx512
ALIGN 64
cglobal satd8x8_dc, 2, 4, 16, src, ss, src4, ss3
    lea     ss3q, [ssq*3]
    lea     src4q, [srcq+ssq*4]
    vpmovzxbw zmm0, [srcq]
    vpmovzxbw zmm1, [srcq+ssq]
    vpmovzxbw zmm2, [srcq+ssq*2]
    vpmovzxbw zmm3, [srcq+ss3q]
    vpmovzxbw zmm4, [src4q]
    vpmovzxbw zmm5, [src4q+ssq]
    vpmovzxbw zmm6, [src4q+ssq*2]
    vpmovzxbw zmm7, [src4q+ss3q]
    vpmovzxbw zmm16, [srcq+32]
    vpmovzxbw zmm17, [srcq+ssq+32]
    vpmovzxbw zmm18, [srcq+ssq*2+32]
    vpmovzxbw zmm19, [srcq+ss3q+32]
    vpmovzxbw zmm20, [src4q+32]
    vpmovzxbw zmm21, [src4q+ssq+32]
    vpmovzxbw zmm22, [src4q+ssq*2+32]
    vpmovzxbw zmm23, [src4q+ss3q+32]
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
    vpsubw  zmm8,  zmm8, [pw_8c]
    vpsubw  zmm24, zmm24, [pw_8c]
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
    vpaddw  zmm8,  zmm8, zmm9
    vpaddw  zmm10, zmm10, zmm11
    vpaddw  zmm8,  zmm8, zmm10
    vpaddw  zmm24, zmm24, zmm25
    vpaddw  zmm26, zmm26, zmm27
    vpaddw  zmm24, zmm24, zmm26
    vpmaddwd zmm8,  zmm8,  [pw_1]
    vpmaddwd zmm24, zmm24, [pw_1]
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
    RET
