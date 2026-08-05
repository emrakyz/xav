%include "dav1d_x86inc.asm"

%define D_INTER 0
%define D_IMP   384
%define D_THR   768
%define D_BACK  1152
%define D_FWD   1536
%define D_HEAD  1920
%define D_LEN   1928
%define D_OFF   1936
%define D_NPIX  1944
%define D_ITHR  1952
%define DSL     32

SECTION_RODATA 8
pd_bias: dq 0x3FD3333333333334

SECTION .text align=64
INIT_ZMM avx512

%macro MV 1
    vmovupd zmm16, [stq+%1]
    vmovupd zmm17, [stq+%1+64]
    vmovupd [stq+%1+DSL*8], zmm16
    vmovupd [stq+%1+DSL*8+64], zmm17
%endmacro

%macro COSTS 0
    vxorpd  xmm3, xmm3, xmm3
    vcvtsi2sd xmm0, xmm3, ieq
    vcvtsi2sd xmm1, xmm3, iaq
    vcvtsi2sd xmm2, xmm3, ipq
    vmovsd  xmm3, [stq+D_NPIX]
    vdivsd  xmm0, xmm0, xmm3
    vdivsd  xmm1, xmm1, xmm3
    vdivsd  xmm2, xmm2, xmm3
    vmulsd  xmm1, xmm1, [pd_bias]
%endmacro

ALIGN 64
cglobal scd_fill, 5, 9, 8, st, ia, ie, ip, ifno, hd, t0, ln, of
    mov     hdq, [stq+D_HEAD]
    mov     lnq, [stq+D_LEN]
    mov     ofq, [stq+D_OFF]
    COSTS
    cmp     ofq, lnq
    mov     iaq, ofq
    cmova   iaq, lnq
    mov     eax, -1
    bzhi    eax, eax, iad
    kmovb   k1, eax
    dec     eax
    kmovb   k2, eax
    vbroadcastsd zmm4, xmm0
    vxorpd  xmm6, xmm6, xmm6
    vmovupd zmm5 {k1}{z}, [stq+hdq*8+D_INTER]
    vsubpd  zmm7, zmm5, zmm4
    vminpd  zmm7 {k2}, zmm7, [stq+hdq*8+D_FWD]
    vmaxpd  zmm7, zmm7, zmm6
    vmovupd [stq+hdq*8+D_FWD] {k1}, zmm7
    vextractf64x4 ymm3, zmm5, 1
    vmaxpd  ymm3, ymm5, ymm3
    vextractf128 xmm4, ymm3, 1
    vmaxpd  xmm3, xmm3, xmm4
    vshufpd xmm4, xmm3, xmm3, 1
    vmaxsd  xmm3, xmm3, xmm4
    vsubsd  xmm3, xmm0, xmm3
    vmaxsd  xmm3, xmm3, xmm6
    xor     eax, eax
    cmp     ifnoq, 1
    setne   al
    cmp     ofq, 1
    sbb     ifnod, ifnod
    not     ifnod
    and     eax, ifnod
    kmovb   k3, eax
    vmovsd  xmm3 {k3}{z}, xmm3, xmm3
    test    hdq, hdq
    jz      .fcompact
.fafter:
    dec     hdq
    mov     [stq+D_HEAD], hdq
    vmovsd  [stq+hdq*8+D_INTER], xmm0
    vmovsd  [stq+hdq*8+D_IMP], xmm2
    vmovsd  [stq+hdq*8+D_THR], xmm1
    vmovsd  [stq+hdq*8+D_BACK], xmm3
    mov     qword [stq+hdq*8+D_FWD], 0
    inc     lnq
    mov     [stq+D_LEN], lnq
    RET
.fcompact:
    MV D_INTER
    MV D_IMP
    MV D_THR
    MV D_BACK
    MV D_FWD
    mov     hdq, DSL
    jmp     .fafter

ALIGN 64
cglobal scd_pred, 1, 7, 5, st, hd, t0, ln, of, t1, t2
    mov     hdq, [stq+D_HEAD]
    mov     lnq, [stq+D_LEN]
    mov     ofq, [stq+D_OFF]
    vpbroadcastq zmm0, [stq+D_ITHR]
    vmovupd zmm1, [stq+hdq*8+D_THR]
    vmovupd ymm2, [stq+hdq*8+D_THR+64]
    mov     t0d, -1
    bzhi    t1d, t0d, lnd
    bzhi    t2d, t0d, ofd
    lea     t0d, [t2q*2+1]
    kmovw   k3, t0d
    andn    t0d, t2d, t1d
    kmovw   k1, t0d
    blsr    t0d, t0d
    kmovw   k2, t0d
    lea     t1d, [t2q+1]
    kshiftrw k4, k1, 8
    vcmppd  k1 {k1}, zmm0, [stq+hdq*8+D_IMP], 0x12
    vcmppd  k5 {k4}, ymm2, [stq+hdq*8+D_BACK+64], 0x12
    vcmppd  k4 {k4}, ymm0, [stq+hdq*8+D_IMP+64], 0x12
    vcmppd  k2 {k2}, zmm1, [stq+hdq*8+D_BACK], 0x12
    vcmppd  k3 {k3}, zmm1, [stq+hdq*8+D_FWD], 0x12
    korw    k2, k2, k5
    kmovw   t2d, k3
    kmovw   t0d, k2
    sub     t2d, t1d
    neg     t0d
    adc     t2d, t2d
    xor     t0d, t0d
    cmp     t2d, 3
    sbb     t2d, t2d
    kortestb k1, k4
    cmovne  t0d, t2d
    and     t0d, 1
    lea     t1q, [lnq-1]
    cmp     lnq, 10
    cmova   lnq, t1q
    mov     [stq+D_LEN], lnq
    lea     t1q, [hdq+ofq]
    vmovsd  xmm3, [stq+t1q*8+D_INTER]
    vmovsd  xmm4, [stq+t1q*8+D_THR]
    vcvtsd2ss xmm3, xmm3, xmm3
    vcvtsd2ss xmm4, xmm4, xmm4
    vdivss  xmm3, xmm3, xmm4
    vmovd   eax, xmm3
    shl     rax, 32
    or      rax, t0q
    RET

ALIGN 64
cglobal scd_frame, 5, 9, 16, st, ia, ie, ip, ifno, hd, t0, ln, of
    mov     hdq, [stq+D_HEAD]
    mov     lnq, [stq+D_LEN]
    mov     ofq, [stq+D_OFF]
    vmovupd zmm8,  [stq+hdq*8+D_IMP]
    vmovupd zmm9,  [stq+hdq*8+D_IMP+64]
    vmovupd zmm10, [stq+hdq*8+D_BACK]
    vmovupd zmm11, [stq+hdq*8+D_BACK+64]
    vmovupd zmm12, [stq+hdq*8+D_THR]
    vmovupd zmm13, [stq+hdq*8+D_THR+64]
    COSTS
    vbroadcastsd zmm4, xmm0
    vbroadcastsd zmm18, xmm2
    vbroadcastsd zmm19, xmm1
    vpbroadcastq zmm3, [stq+D_ITHR]
    mov     eax, -1
    bzhi    eax, eax, ofd
    kmovb   k1, eax
    dec     eax
    kmovb   k2, eax
    vxorpd  xmm6, xmm6, xmm6
    vmovupd zmm7 {k1}{z}, [stq+hdq*8+D_INTER]
    vsubpd  zmm5, zmm7, zmm4
    vminpd  zmm5 {k2}, zmm5, [stq+hdq*8+D_FWD]
    vmaxpd  zmm5, zmm5, zmm6
    valignq zmm5,  zmm5, zmm6, 7
    valignq zmm14, zmm8, zmm18, 7
    valignq zmm9,  zmm9, zmm8, 7
    valignq zmm8,  zmm12, zmm19, 7
    test    hdq, hdq
    jz      .compact
.after:
    dec     hdq
    mov     [stq+D_HEAD], hdq
    vmovsd  [stq+hdq*8+D_INTER], xmm0
    vmovsd  [stq+hdq*8+D_IMP], xmm2
    vmovsd  [stq+hdq*8+D_THR], xmm1
    lea     eax, [ofq+1]
    mov     ecx, -1
    bzhi    ecx, ecx, eax
    kmovb   k6, ecx
    vmovupd [stq+hdq*8+D_FWD] {k6}, zmm5
    vextractf64x4 ymm4, zmm7, 1
    vmaxpd  ymm4, ymm7, ymm4
    vextractf128 xmm15, ymm4, 1
    vmaxpd  xmm4, xmm4, xmm15
    vshufpd xmm15, xmm4, xmm4, 1
    vmaxsd  xmm4, xmm4, xmm15
    vsubsd  xmm4, xmm0, xmm4
    vmaxsd  xmm4, xmm4, xmm6
    xor     eax, eax
    cmp     ifnoq, 1
    setne   al
    cmp     ofq, 1
    sbb     ecx, ecx
    not     ecx
    and     eax, ecx
    kmovb   k7, eax
    vmovsd  xmm4 {k7}{z}, xmm4, xmm4
    vmovsd  [stq+hdq*8+D_BACK], xmm4
    inc     lnq
    mov     eax, -1
    bzhi    esi, eax, lnd
    bzhi    edx, eax, ofd
    lea     eax, [rdx*2+1]
    kmovw   k3, eax
    andn    eax, edx, esi
    kmovw   k1, eax
    blsr    eax, eax
    shr     eax, 1
    kmovw   k2, eax
    lea     ecx, [rdx+1]
    kshiftrw k4, k1, 8
    kshiftrw k5, k2, 8
    vcmppd  k5 {k5}, zmm13, zmm11, 0x12
    vcmppd  k4 {k4}, zmm3, zmm9, 0x12
    vcmppd  k1 {k1}, zmm3, zmm14, 0x12
    vcmppd  k2 {k2}, zmm12, zmm10, 0x12
    vcmppd  k3 {k3}, zmm8, zmm5, 0x12
    korw    k2, k2, k5
    kmovw   edx, k3
    kmovw   esi, k2
    sub     edx, ecx
    neg     esi
    adc     edx, edx
    xor     ecx, ecx
    cmp     edx, 3
    sbb     edx, edx
    kortestb k1, k4
    cmovne  ecx, edx
    and     ecx, 1
    lea     t0q, [lnq-1]
    cmp     lnq, 10
    cmova   lnq, t0q
    mov     [stq+D_LEN], lnq
    lea     t0q, [hdq+ofq]
    vmovsd  xmm3, [stq+t0q*8+D_INTER]
    vmovsd  xmm4, [stq+t0q*8+D_THR]
    vcvtsd2ss xmm3, xmm3, xmm3
    vcvtsd2ss xmm4, xmm4, xmm4
    vdivss  xmm3, xmm3, xmm4
    vmovd   eax, xmm3
    shl     rax, 32
    or      rax, rcx
    RET
.compact:
    MV D_INTER
    MV D_IMP
    MV D_THR
    MV D_BACK
    MV D_FWD
    mov     hdq, DSL
    jmp     .after
