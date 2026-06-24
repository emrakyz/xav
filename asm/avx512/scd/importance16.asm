%include "dav1d_x86inc.asm"

SECTION_RODATA 64
pw_1:  times 32 dw 1
pd_32: times 16 dd 32
idxw:  dw 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30
       dw 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62

%macro IMP16_SETUP 0
    lea     os3q, [osq*3]
    lea     rs3q, [rsq*3]
    lea     org4q, [orgq+osq*8]
    lea     ref4q, [refq+rsq*8]
    vmovdqa32 zmm3, [pw_1]
%endmacro

%macro IMP16_WHT 0
    vpmaddwd zmm0,  zmm0,  zmm3
    vpmaddwd zmm16, zmm16, zmm3
    vpmaddwd zmm1,  zmm1,  zmm3
    vpmaddwd zmm17, zmm17, zmm3
    vmovdqa32 zmm2, [idxw]
    vpermt2w zmm0, zmm2, zmm16
    vpermt2w zmm1, zmm2, zmm17
    vpmaddwd zmm0, zmm0, zmm3
    vpmaddwd zmm1, zmm1, zmm3
    vpermt2w zmm0, zmm2, zmm1
    vpmaddwd zmm0, zmm0, zmm3
    vpaddd  zmm0, zmm0, [pd_32]
    vpsrld  zmm0, zmm0, 6
    vextracti64x4 ymm1, zmm0, 1
    vpsubd  ymm0, ymm0, ymm1
    vpabsd  ymm0, ymm0
    vextracti128 xmm1, ymm0, 1
    vpaddd  xmm0, xmm0, xmm1
    vpshufd xmm1, xmm0, 0x4e
    vpaddd  xmm0, xmm0, xmm1
    vpshufd xmm1, xmm0, 0xb1
    vpaddd  xmm0, xmm0, xmm1
    vmovd   eax, xmm0
%endmacro

SECTION .text align=64
INIT_ZMM avx512

ALIGN 64
cglobal importance16_x8, 4, 8, 16, org, os, ref, rs, org4, ref4, os3, rs3
    IMP16_SETUP
    vmovdqu64 zmm0, [orgq]
    vmovdqu64 zmm16, [orgq+64]
    vpaddw  zmm0,  zmm0,  [orgq+osq*2]
    vpaddw  zmm16, zmm16, [orgq+osq*2+64]
    vpaddw  zmm0,  zmm0,  [orgq+osq*4]
    vpaddw  zmm16, zmm16, [orgq+osq*4+64]
    vpaddw  zmm0,  zmm0,  [orgq+os3q*2]
    vpaddw  zmm16, zmm16, [orgq+os3q*2+64]
    vpaddw  zmm0,  zmm0,  [org4q]
    vpaddw  zmm16, zmm16, [org4q+64]
    vpaddw  zmm0,  zmm0,  [org4q+osq*2]
    vpaddw  zmm16, zmm16, [org4q+osq*2+64]
    vpaddw  zmm0,  zmm0,  [org4q+osq*4]
    vpaddw  zmm16, zmm16, [org4q+osq*4+64]
    vpaddw  zmm0,  zmm0,  [org4q+os3q*2]
    vpaddw  zmm16, zmm16, [org4q+os3q*2+64]
    vmovdqu64 zmm1, [refq]
    vmovdqu64 zmm17, [refq+64]
    vpaddw  zmm1,  zmm1,  [refq+rsq*2]
    vpaddw  zmm17, zmm17, [refq+rsq*2+64]
    vpaddw  zmm1,  zmm1,  [refq+rsq*4]
    vpaddw  zmm17, zmm17, [refq+rsq*4+64]
    vpaddw  zmm1,  zmm1,  [refq+rs3q*2]
    vpaddw  zmm17, zmm17, [refq+rs3q*2+64]
    vpaddw  zmm1,  zmm1,  [ref4q]
    vpaddw  zmm17, zmm17, [ref4q+64]
    vpaddw  zmm1,  zmm1,  [ref4q+rsq*2]
    vpaddw  zmm17, zmm17, [ref4q+rsq*2+64]
    vpaddw  zmm1,  zmm1,  [ref4q+rsq*4]
    vpaddw  zmm17, zmm17, [ref4q+rsq*4+64]
    vpaddw  zmm1,  zmm1,  [ref4q+rs3q*2]
    vpaddw  zmm17, zmm17, [ref4q+rs3q*2+64]
    IMP16_WHT
    RET

ALIGN 64
cglobal importance16_s_x8, 4, 8, 16, org, os, ref, rs, org4, ref4, os3, rs3
    IMP16_SETUP
    vpsrlw  zmm0, [orgq], 6
    vpsrlw  zmm16, [orgq+64], 6
    vpsrlw  zmm4, [orgq+osq*2], 6
    vpaddw  zmm0, zmm0, zmm4
    vpsrlw  zmm5, [orgq+osq*2+64], 6
    vpaddw  zmm16, zmm16, zmm5
    vpsrlw  zmm4, [orgq+osq*4], 6
    vpaddw  zmm0, zmm0, zmm4
    vpsrlw  zmm5, [orgq+osq*4+64], 6
    vpaddw  zmm16, zmm16, zmm5
    vpsrlw  zmm4, [orgq+os3q*2], 6
    vpaddw  zmm0, zmm0, zmm4
    vpsrlw  zmm5, [orgq+os3q*2+64], 6
    vpaddw  zmm16, zmm16, zmm5
    vpsrlw  zmm4, [org4q], 6
    vpaddw  zmm0, zmm0, zmm4
    vpsrlw  zmm5, [org4q+64], 6
    vpaddw  zmm16, zmm16, zmm5
    vpsrlw  zmm4, [org4q+osq*2], 6
    vpaddw  zmm0, zmm0, zmm4
    vpsrlw  zmm5, [org4q+osq*2+64], 6
    vpaddw  zmm16, zmm16, zmm5
    vpsrlw  zmm4, [org4q+osq*4], 6
    vpaddw  zmm0, zmm0, zmm4
    vpsrlw  zmm5, [org4q+osq*4+64], 6
    vpaddw  zmm16, zmm16, zmm5
    vpsrlw  zmm4, [org4q+os3q*2], 6
    vpaddw  zmm0, zmm0, zmm4
    vpsrlw  zmm5, [org4q+os3q*2+64], 6
    vpaddw  zmm16, zmm16, zmm5
    vpsrlw  zmm1, [refq], 6
    vpsrlw  zmm17, [refq+64], 6
    vpsrlw  zmm4, [refq+rsq*2], 6
    vpaddw  zmm1, zmm1, zmm4
    vpsrlw  zmm5, [refq+rsq*2+64], 6
    vpaddw  zmm17, zmm17, zmm5
    vpsrlw  zmm4, [refq+rsq*4], 6
    vpaddw  zmm1, zmm1, zmm4
    vpsrlw  zmm5, [refq+rsq*4+64], 6
    vpaddw  zmm17, zmm17, zmm5
    vpsrlw  zmm4, [refq+rs3q*2], 6
    vpaddw  zmm1, zmm1, zmm4
    vpsrlw  zmm5, [refq+rs3q*2+64], 6
    vpaddw  zmm17, zmm17, zmm5
    vpsrlw  zmm4, [ref4q], 6
    vpaddw  zmm1, zmm1, zmm4
    vpsrlw  zmm5, [ref4q+64], 6
    vpaddw  zmm17, zmm17, zmm5
    vpsrlw  zmm4, [ref4q+rsq*2], 6
    vpaddw  zmm1, zmm1, zmm4
    vpsrlw  zmm5, [ref4q+rsq*2+64], 6
    vpaddw  zmm17, zmm17, zmm5
    vpsrlw  zmm4, [ref4q+rsq*4], 6
    vpaddw  zmm1, zmm1, zmm4
    vpsrlw  zmm5, [ref4q+rsq*4+64], 6
    vpaddw  zmm17, zmm17, zmm5
    vpsrlw  zmm4, [ref4q+rs3q*2], 6
    vpaddw  zmm1, zmm1, zmm4
    vpsrlw  zmm5, [ref4q+rs3q*2+64], 6
    vpaddw  zmm17, zmm17, zmm5
    IMP16_WHT
    RET
