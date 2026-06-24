%include "dav1d_x86inc.asm"

SECTION_RODATA 64
pq_32: dq 32

SECTION .text align=64
INIT_ZMM avx512
ALIGN 64
cglobal importance_x8, 4, 8, 16, org, os, ref, rs, org4, ref4, os3, rs3
    lea     os3q, [osq*3]
    lea     rs3q, [rsq*3]
    lea     org4q, [orgq+osq*4]
    lea     ref4q, [refq+rsq*4]
    vpxor   xmm0, xmm0, xmm0
    vpsadbw zmm1, zmm0, [orgq]
    vpsadbw zmm2, zmm0, [orgq+osq]
    vpsadbw zmm3, zmm0, [orgq+osq*2]
    vpsadbw zmm4, zmm0, [orgq+os3q]
    vpsadbw zmm5, zmm0, [org4q]
    vpsadbw zmm6, zmm0, [org4q+osq]
    vpsadbw zmm7, zmm0, [org4q+osq*2]
    vpsadbw zmm8, zmm0, [org4q+os3q]
    vpaddq  zmm1, zmm1, zmm2
    vpaddq  zmm3, zmm3, zmm4
    vpaddq  zmm5, zmm5, zmm6
    vpaddq  zmm7, zmm7, zmm8
    vpaddq  zmm1, zmm1, zmm3
    vpaddq  zmm5, zmm5, zmm7
    vpaddq  zmm1, zmm1, zmm5
    vpsadbw zmm2, zmm0, [refq]
    vpsadbw zmm3, zmm0, [refq+rsq]
    vpsadbw zmm4, zmm0, [refq+rsq*2]
    vpsadbw zmm5, zmm0, [refq+rs3q]
    vpsadbw zmm6, zmm0, [ref4q]
    vpsadbw zmm7, zmm0, [ref4q+rsq]
    vpsadbw zmm8, zmm0, [ref4q+rsq*2]
    vpsadbw zmm9, zmm0, [ref4q+rs3q]
    vpaddq  zmm2, zmm2, zmm3
    vpaddq  zmm4, zmm4, zmm5
    vpaddq  zmm6, zmm6, zmm7
    vpaddq  zmm8, zmm8, zmm9
    vpaddq  zmm2, zmm2, zmm4
    vpaddq  zmm6, zmm6, zmm8
    vpaddq  zmm2, zmm2, zmm6
    vpaddq  zmm1, zmm1, [pq_32]{1to8}
    vpaddq  zmm2, zmm2, [pq_32]{1to8}
    vpsrlq  zmm1, zmm1, 6
    vpsrlq  zmm2, zmm2, 6
    vpmovqb xmm1, zmm1
    vpmovqb xmm2, zmm2
    vpsadbw xmm1, xmm1, xmm2
    vmovd   eax, xmm1
    RET
