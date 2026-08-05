%include "dav1d_x86inc.asm"

SECTION_RODATA 32
pd_ramp1: dd 1, 2, 3, 4, 5, 6, 7, 8
ps_1_8:   times 8 dd 1.0
ps_10k_8: times 8 dd 10000.0
ps_cap_8: times 8 dd 1.8446744e19
ps_z_8:   times 8 dd 0.0
pd_8_8:   times 8 dd 8
pd_m1_8:  times 8 dd -1
ps_n1_8:  times 8 dd -1.0

SECTION .text align=64
INIT_YMM avx2

%macro STEP 1
%if %1
    vpcmpgtd  ymm11, ymm10, ymm3
    vmaskmovps ymm6, ymm11, [wq+iq*4]
    vcmpps    ymm7, ymm6, [ps_z_8], 0x15
    vandps    ymm7, ymm7, ymm11
%else
    vmovups   ymm6, [wq+iq*4]
    vcmpps    ymm7, ymm6, [ps_z_8], 0x15
%endif
    vpsubd    ymm8, ymm4, ymm3
    vpabsd    ymm8, ymm8
    vcvtdq2ps ymm8, ymm8
    vmulps    ymm8, ymm8, ymm2
    vsubps    ymm8, ymm5, ymm8
    vmulps    ymm6, ymm6, ymm8
    vmulps    ymm6, ymm6, [ps_10k_8]
    vmaxps    ymm6, ymm6, [ps_z_8]
    vroundps  ymm8, ymm6, 0x08
    vminps    ymm8, ymm8, [ps_cap_8]
    vblendvps ymm8, ymm12, ymm8, ymm7
    vcmpps    ymm9, ymm8, ymm0, 0x1d
    vblendvps ymm0, ymm0, ymm8, ymm9
    vblendvps ymm1, ymm1, ymm3, ymm9
%endmacro

ALIGN 64
cglobal split, 4, 6, 13, w, n, m, range, i, t
    vcvtsi2ss    xmm2, xmm2, ranged
    vmovss       xmm3, [ps_1_8]
    vdivss       xmm2, xmm3, xmm2
    vbroadcastss ymm2, xmm2
    vmovdqu      ymm3, [pd_ramp1]
    vpaddd       ymm3, ymm3, [pd_m1_8]
    vmovd        xmm4, md
    vpbroadcastd ymm4, xmm4
    vmovaps      ymm5, [ps_1_8]
    vmovaps      ymm12, [ps_n1_8]
    vmovaps      ymm0, ymm12
    vmovdqa      ymm1, [pd_m1_8]
    vmovd        xmm10, nd
    vpbroadcastd ymm10, xmm10
    xor          iq, iq
    mov          tq, nq
    and          tq, -8
    jz           .tail
.main:
    STEP 0
    vpaddd       ymm3, ymm3, [pd_8_8]
    add          iq, 8
    cmp          iq, tq
    jb           .main
.tail:
    cmp          iq, nq
    jae          .done
    STEP 1
.done:
    vextractf128 xmm2, ymm0, 1
    vmaxps    xmm2, xmm0, xmm2
    vshufpd   xmm3, xmm2, xmm2, 1
    vmaxps    xmm2, xmm2, xmm3
    vmovshdup xmm3, xmm2
    vmaxss    xmm2, xmm2, xmm3
    vxorps    xmm3, xmm3, xmm3
    vucomiss  xmm3, xmm2
    ja        .none
    vbroadcastss ymm2, xmm2
    vcmpps    ymm2, ymm0, ymm2, 0x00
    vmovdqa   ymm3, [pd_m1_8]
    vblendvps ymm3, ymm3, ymm1, ymm2
    vextracti128 xmm4, ymm3, 1
    vpmaxsd   xmm3, xmm3, xmm4
    vpshufd   xmm4, xmm3, 0xee
    vpmaxsd   xmm3, xmm3, xmm4
    vpshufd   xmm4, xmm3, 0x55
    vpmaxsd   xmm3, xmm3, xmm4
    vmovd     eax, xmm3
    RET
.none:
    mov       eax, nd
    RET
