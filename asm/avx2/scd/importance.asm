%include "dav1d_x86inc.asm"

SECTION_RODATA 32
pq_32: times 4 dq 32
shuf:  db 0, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
       db 0, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1

SECTION .text align=64
INIT_YMM avx2
ALIGN 64
cglobal importance_x4, 4, 8, 10, org, os, ref, rs, org4, ref4, os3, rs3
    lea     os3q, [osq*3]
    lea     rs3q, [rsq*3]
    lea     org4q, [orgq+osq*4]
    lea     ref4q, [refq+rsq*4]
    vpxor   xmm0, xmm0, xmm0
    vpsadbw ymm1, ymm0, [orgq]
    vpsadbw ymm2, ymm0, [orgq+osq]
    vpsadbw ymm3, ymm0, [orgq+osq*2]
    vpsadbw ymm4, ymm0, [orgq+os3q]
    vpsadbw ymm5, ymm0, [org4q]
    vpsadbw ymm6, ymm0, [org4q+osq]
    vpsadbw ymm7, ymm0, [org4q+osq*2]
    vpsadbw ymm8, ymm0, [org4q+os3q]
    vpaddq  ymm1, ymm1, ymm2
    vpaddq  ymm3, ymm3, ymm4
    vpaddq  ymm5, ymm5, ymm6
    vpaddq  ymm7, ymm7, ymm8
    vpaddq  ymm1, ymm1, ymm3
    vpaddq  ymm5, ymm5, ymm7
    vpaddq  ymm1, ymm1, ymm5
    vpsadbw ymm2, ymm0, [refq]
    vpsadbw ymm3, ymm0, [refq+rsq]
    vpsadbw ymm4, ymm0, [refq+rsq*2]
    vpsadbw ymm5, ymm0, [refq+rs3q]
    vpsadbw ymm6, ymm0, [ref4q]
    vpsadbw ymm7, ymm0, [ref4q+rsq]
    vpsadbw ymm8, ymm0, [ref4q+rsq*2]
    vpsadbw ymm9, ymm0, [ref4q+rs3q]
    vpaddq  ymm2, ymm2, ymm3
    vpaddq  ymm4, ymm4, ymm5
    vpaddq  ymm6, ymm6, ymm7
    vpaddq  ymm8, ymm8, ymm9
    vpaddq  ymm2, ymm2, ymm4
    vpaddq  ymm6, ymm6, ymm8
    vpaddq  ymm2, ymm2, ymm6
    vpaddq  ymm1, ymm1, [pq_32]
    vpaddq  ymm2, ymm2, [pq_32]
    vpsrlq  ymm1, ymm1, 6
    vpsrlq  ymm2, ymm2, 6
    vpshufb ymm1, ymm1, [shuf]
    vpshufb ymm2, ymm2, [shuf]
    vpsadbw ymm1, ymm1, ymm2
    vextracti128 xmm2, ymm1, 1
    vpaddd  xmm1, xmm1, xmm2
    vmovd   eax, xmm1
    ret
