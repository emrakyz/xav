%include "dav1d_x86inc.asm"

SECTION_RODATA 32
pw_1:  times 16 dw 1
pd_32: times 8 dd 32

%macro IMP16_SETUP 0
    lea     os3q, [osq*3]
    lea     rs3q, [rsq*3]
    lea     org4q, [orgq+osq*8]
    lea     ref4q, [refq+rsq*8]
    vmovdqa ymm4, [pw_1]
%endmacro

%macro IMP16_TAIL 0
    vpmaddwd ymm0, ymm0, ymm4
    vpmaddwd ymm1, ymm1, ymm4
    vpmaddwd ymm2, ymm2, ymm4
    vpmaddwd ymm3, ymm3, ymm4
    vphaddd ymm0, ymm0, ymm2
    vphaddd ymm1, ymm1, ymm3
    vphaddd ymm0, ymm0, ymm1
    vpaddd  ymm0, ymm0, [pd_32]
    vpsrld  ymm0, ymm0, 6
    vphsubd ymm0, ymm0, ymm0
    vpabsd  ymm0, ymm0
    vextracti128 xmm1, ymm0, 1
    vpaddd  xmm0, xmm0, xmm1
    vphaddd xmm0, xmm0, xmm0
    vmovd   eax, xmm0
%endmacro

SECTION .text align=64
INIT_YMM avx2

ALIGN 64
cglobal importance16_x4, 4, 8, 8, org, os, ref, rs, org4, ref4, os3, rs3
    IMP16_SETUP
    vmovdqu ymm0, [orgq]
    vmovdqu ymm1, [orgq+32]
    vmovdqu ymm2, [refq]
    vmovdqu ymm3, [refq+32]
    vpaddw  ymm0, ymm0, [orgq+osq*2]
    vpaddw  ymm1, ymm1, [orgq+osq*2+32]
    vpaddw  ymm2, ymm2, [refq+rsq*2]
    vpaddw  ymm3, ymm3, [refq+rsq*2+32]
    vpaddw  ymm0, ymm0, [orgq+osq*4]
    vpaddw  ymm1, ymm1, [orgq+osq*4+32]
    vpaddw  ymm2, ymm2, [refq+rsq*4]
    vpaddw  ymm3, ymm3, [refq+rsq*4+32]
    vpaddw  ymm0, ymm0, [orgq+os3q*2]
    vpaddw  ymm1, ymm1, [orgq+os3q*2+32]
    vpaddw  ymm2, ymm2, [refq+rs3q*2]
    vpaddw  ymm3, ymm3, [refq+rs3q*2+32]
    vpaddw  ymm0, ymm0, [org4q]
    vpaddw  ymm1, ymm1, [org4q+32]
    vpaddw  ymm2, ymm2, [ref4q]
    vpaddw  ymm3, ymm3, [ref4q+32]
    vpaddw  ymm0, ymm0, [org4q+osq*2]
    vpaddw  ymm1, ymm1, [org4q+osq*2+32]
    vpaddw  ymm2, ymm2, [ref4q+rsq*2]
    vpaddw  ymm3, ymm3, [ref4q+rsq*2+32]
    vpaddw  ymm0, ymm0, [org4q+osq*4]
    vpaddw  ymm1, ymm1, [org4q+osq*4+32]
    vpaddw  ymm2, ymm2, [ref4q+rsq*4]
    vpaddw  ymm3, ymm3, [ref4q+rsq*4+32]
    vpaddw  ymm0, ymm0, [org4q+os3q*2]
    vpaddw  ymm1, ymm1, [org4q+os3q*2+32]
    vpaddw  ymm2, ymm2, [ref4q+rs3q*2]
    vpaddw  ymm3, ymm3, [ref4q+rs3q*2+32]
    IMP16_TAIL
    RET

ALIGN 64
cglobal importance16_s_x4, 4, 8, 8, org, os, ref, rs, org4, ref4, os3, rs3
    IMP16_SETUP
    vmovdqu ymm0, [orgq]
    vpsrlw ymm0, ymm0, 6
    vmovdqu ymm1, [orgq+32]
    vpsrlw ymm1, ymm1, 6
    vmovdqu ymm2, [refq]
    vpsrlw ymm2, ymm2, 6
    vmovdqu ymm3, [refq+32]
    vpsrlw ymm3, ymm3, 6
    vmovdqu ymm5, [orgq+osq*2]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm0, ymm0, ymm5
    vmovdqu ymm5, [orgq+osq*2+32]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm1, ymm1, ymm5
    vmovdqu ymm5, [refq+rsq*2]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm2, ymm2, ymm5
    vmovdqu ymm5, [refq+rsq*2+32]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm3, ymm3, ymm5
    vmovdqu ymm5, [orgq+osq*4]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm0, ymm0, ymm5
    vmovdqu ymm5, [orgq+osq*4+32]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm1, ymm1, ymm5
    vmovdqu ymm5, [refq+rsq*4]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm2, ymm2, ymm5
    vmovdqu ymm5, [refq+rsq*4+32]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm3, ymm3, ymm5
    vmovdqu ymm5, [orgq+os3q*2]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm0, ymm0, ymm5
    vmovdqu ymm5, [orgq+os3q*2+32]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm1, ymm1, ymm5
    vmovdqu ymm5, [refq+rs3q*2]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm2, ymm2, ymm5
    vmovdqu ymm5, [refq+rs3q*2+32]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm3, ymm3, ymm5
    vmovdqu ymm5, [org4q]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm0, ymm0, ymm5
    vmovdqu ymm5, [org4q+32]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm1, ymm1, ymm5
    vmovdqu ymm5, [ref4q]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm2, ymm2, ymm5
    vmovdqu ymm5, [ref4q+32]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm3, ymm3, ymm5
    vmovdqu ymm5, [org4q+osq*2]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm0, ymm0, ymm5
    vmovdqu ymm5, [org4q+osq*2+32]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm1, ymm1, ymm5
    vmovdqu ymm5, [ref4q+rsq*2]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm2, ymm2, ymm5
    vmovdqu ymm5, [ref4q+rsq*2+32]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm3, ymm3, ymm5
    vmovdqu ymm5, [org4q+osq*4]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm0, ymm0, ymm5
    vmovdqu ymm5, [org4q+osq*4+32]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm1, ymm1, ymm5
    vmovdqu ymm5, [ref4q+rsq*4]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm2, ymm2, ymm5
    vmovdqu ymm5, [ref4q+rsq*4+32]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm3, ymm3, ymm5
    vmovdqu ymm5, [org4q+os3q*2]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm0, ymm0, ymm5
    vmovdqu ymm5, [org4q+os3q*2+32]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm1, ymm1, ymm5
    vmovdqu ymm5, [ref4q+rs3q*2]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm2, ymm2, ymm5
    vmovdqu ymm5, [ref4q+rs3q*2+32]
    vpsrlw ymm5, ymm5, 6
    vpaddw  ymm3, ymm3, ymm5
    IMP16_TAIL
    RET
