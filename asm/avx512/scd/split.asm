%include "dav1d_x86inc.asm"

SECTION_RODATA 64
ramp1:  dd 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
ps_1:   dd 1.0
ps_10k: dd 10000.0
ps_cap: dd 1.8446744e19
ps_z:   dd 0.0
pd_16:  dd 16

SECTION .text align=64
INIT_ZMM avx512

%macro STEP 1
%if %1
    vpcmpd       k1, zmm6, zmm10, 1
    vmovups      zmm7 {k1}{z}, [wq+iq*4]
    vcmpps       k2 {k1}, zmm7, [ps_z]{1to16}, 0x15
%else
    vmovups      zmm7, [wq+iq*4]
    vcmpps       k2, zmm7, [ps_z]{1to16}, 0x15
%endif
    vpsubd       zmm8, zmm4, zmm6
    vpabsd       zmm8, zmm8
    vcvtdq2ps    zmm8, zmm8
    vmulps       zmm8, zmm8, zmm2
    vsubps       zmm8, zmm5, zmm8
    vmulps       zmm7, zmm7, zmm8
    vmulps       zmm7, zmm7, [ps_10k]{1to16}
    vmaxps       zmm7, zmm7, [ps_z]{1to16}
    vrndscaleps  zmm8, zmm7, 0x08
    vminps       zmm8 {k2}{z}, zmm8, [ps_cap]{1to16}
    vmovdqa32    zmm9 {k2}{z}, zmm6
    vpunpckldq   zmm7, zmm9, zmm8
    vpunpckhdq   zmm9, zmm9, zmm8
    vpmaxuq      zmm13, zmm13, zmm7
    vpmaxuq      zmm14, zmm14, zmm9
%endmacro

ALIGN 64
cglobal split, 4, 6, 16, w, n, m, range, i, t
    vcvtsi2ss    xmm2, xmm2, ranged
    vmovss       xmm3, [ps_1]
    vdivss       xmm2, xmm3, xmm2
    vbroadcastss zmm2, xmm2
    vmovdqu32    zmm6, [ramp1]
    inc          md
    vpbroadcastd zmm4, md
    vbroadcastss zmm5, [ps_1]
    vpxord       zmm13, zmm13, zmm13
    vpxord       zmm14, zmm14, zmm14
    lea          td, [nd+1]
    vpbroadcastd zmm10, td
    vpbroadcastd zmm11, [pd_16]
    xor          iq, iq
    mov          tq, nq
    and          tq, -16
    jz           .tail
.main:
    STEP 0
    vpaddd       zmm6, zmm6, zmm11
    add          iq, 16
    cmp          iq, tq
    jb           .main
.tail:
    cmp          iq, nq
    jae          .done
    STEP 1
.done:
    vpmaxuq      zmm13, zmm13, zmm14
    vshufi64x2   zmm7, zmm13, zmm13, 0x4e
    vpmaxuq      zmm13, zmm13, zmm7
    vshufi64x2   zmm7, zmm13, zmm13, 0xb1
    vpmaxuq      zmm13, zmm13, zmm7
    vpshufd      zmm7, zmm13, 0x4e
    vpmaxuq      zmm13, zmm13, zmm7
    vmovd        eax, xmm13
    test         eax, eax
    jz           .none
    dec          eax
    RET
.none:
    mov          eax, nd
    RET
