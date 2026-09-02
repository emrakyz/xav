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

SECTION_RODATA 32
ALIGN 32
masktab:
%assign mi 0
%rep 9
  %assign mj 0
  %rep 8
    %if mj < mi
      dq -1
    %else
      dq 0
    %endif
    %assign mj mj+1
  %endrep
  %assign mi mi+1
%endrep
pd_bias: dq 0x3FD3333333333334

SECTION .text align=64
INIT_YMM avx2

%macro MV2 1
    vmovupd m8,  [stq+%1]
    vmovupd m9,  [stq+%1+32]
    vmovupd m10, [stq+%1+64]
    vmovupd [stq+%1+DSL*8], m8
    vmovupd [stq+%1+DSL*8+32], m9
    vmovupd [stq+%1+DSL*8+64], m10
%endmacro

%macro COSTS 0
    vxorpd  xm3, xm3, xm3
    vcvtsi2sd xm0, xm3, ieq
    vcvtsi2sd xm1, xm3, iaq
    vcvtsi2sd xm2, xm3, ipq
    vmovsd  xm3, [stq+D_NPIX]
    vdivsd  xm0, xm0, xm3
    vdivsd  xm1, xm1, xm3
    vdivsd  xm2, xm2, xm3
    vmulsd  xm1, xm1, [pd_bias]
%endmacro

ALIGN 64
cglobal scd_fill, 5, 9, 8+3*WIN64, st, ia, ie, ip, ifno, hd, t0, ln, of
    mov     hdq, [stq+D_HEAD]
    mov     lnq, [stq+D_LEN]
    mov     ofq, [stq+D_OFF]
    COSTS
    cmp     ofq, lnq
    mov     t0q, ofq
    cmova   t0q, lnq
    shl     t0q, 6
    vbroadcastsd m4, xm0
    vmovupd m6, [masktab+t0q]
    vmovupd m7, [masktab+t0q+32]
    vmaskmovpd m5, m6, [stq+hdq*8+D_INTER]
    vmaskmovpd m3, m7, [stq+hdq*8+D_INTER+32]
    vmaxpd  m8, m5, m3
    vsubpd  m5, m5, m4
    vsubpd  m3, m3, m4
    vminpd  m9, m5, [stq+hdq*8+D_FWD]
    vblendpd m5, m9, m5, 1
    vminpd  m3, m3, [stq+hdq*8+D_FWD+32]
    vxorpd  xm9, xm9, xm9
    vmaxpd  m5, m5, m9
    vmaxpd  m3, m3, m9
    vmaskmovpd [stq+hdq*8+D_FWD], m6, m5
    vmaskmovpd [stq+hdq*8+D_FWD+32], m7, m3
    vextractf128 xm4, m8, 1
    vmaxpd  xm8, xm8, xm4
    vshufpd xm4, xm8, xm8, 1
    vmaxsd  xm8, xm8, xm4
    vsubsd  xm8, xm0, xm8
    vmaxsd  xm8, xm8, xm9
    xor     t0d, t0d
    cmp     ifnoq, 1
    setne   t0b
    cmp     ofq, 1
    sbb     ifnod, ifnod
    not     ifnod
    and     t0d, ifnod
    neg     t0q
    vmovq   xm4, t0q
    vandpd  xm8, xm8, xm4
    test    hdq, hdq
    jz      .fcompact
.fafter:
    dec     hdq
    mov     [stq+D_HEAD], hdq
    vmovsd  [stq+hdq*8+D_INTER], xm0
    vmovsd  [stq+hdq*8+D_IMP], xm2
    vmovsd  [stq+hdq*8+D_THR], xm1
    vmovsd  [stq+hdq*8+D_BACK], xm8
    mov     qword [stq+hdq*8+D_FWD], 0
    inc     lnq
    mov     [stq+D_LEN], lnq
    RET
.fcompact:
    MV2 D_INTER
    MV2 D_IMP
    MV2 D_THR
    MV2 D_BACK
    MV2 D_FWD
    mov     hdq, DSL
    jmp     .fafter

ALIGN 64
cglobal scd_pred, 1, 9, 8, st, hd, t0, ln, of, t1, t2, t3, t4
    mov     hdq, [stq+D_HEAD]
    mov     lnq, [stq+D_LEN]
    mov     ofq, [stq+D_OFF]
    vbroadcastsd m0, [stq+D_ITHR]
    vmovupd m1, [stq+hdq*8+D_THR]
    vmovupd m2, [stq+hdq*8+D_THR+32]
    vmovupd m3, [stq+hdq*8+D_THR+64]
    vcmppd  m4, m0, [stq+hdq*8+D_IMP], 0x12
    vcmppd  m5, m0, [stq+hdq*8+D_IMP+32], 0x12
    vcmppd  m6, m0, [stq+hdq*8+D_IMP+64], 0x12
    vmovmskpd t1d, m4
    vmovmskpd t0d, m5
    shl     t0d, 4
    or      t1d, t0d
    vmovmskpd t0d, m6
    shl     t0d, 8
    or      t1d, t0d
    vcmppd  m4, m1, [stq+hdq*8+D_BACK], 0x12
    vcmppd  m5, m2, [stq+hdq*8+D_BACK+32], 0x12
    vcmppd  m6, m3, [stq+hdq*8+D_BACK+64], 0x12
    vmovmskpd t3d, m4
    vmovmskpd t0d, m5
    shl     t0d, 4
    or      t3d, t0d
    vmovmskpd t0d, m6
    shl     t0d, 8
    or      t3d, t0d
    vcmppd  m4, m1, [stq+hdq*8+D_FWD], 0x12
    vcmppd  m5, m2, [stq+hdq*8+D_FWD+32], 0x12
    vmovmskpd t4d, m4
    vmovmskpd t0d, m5
    shl     t0d, 4
    or      t4d, t0d
    mov     t2d, -1
    bzhi    t0d, t2d, lnd
    bzhi    t2d, t2d, ofd
    andn    t0d, t2d, t0d
    and     t1d, t0d
    blsr    t0d, t0d
    and     t3d, t0d
    lea     t0d, [t2q*2+1]
    and     t4d, t0d
    lea     t2d, [t2q+1]
    sub     t4d, t2d
    neg     t3d
    adc     t4d, t4d
    xor     t0d, t0d
    cmp     t4d, 3
    sbb     t4d, t4d
    test    t1d, t1d
    cmovne  t0d, t4d
    and     t0d, 1
    lea     t2q, [lnq-1]
    cmp     lnq, 10
    cmova   lnq, t2q
    mov     [stq+D_LEN], lnq
    lea     t2q, [hdq+ofq]
    vmovsd  xm3, [stq+t2q*8+D_INTER]
    vmovsd  xm4, [stq+t2q*8+D_THR]
    vcvtsd2ss xm3, xm3, xm3
    vcvtsd2ss xm4, xm4, xm4
    vdivss  xm3, xm3, xm4
    vmovd   eax, xm3
    shl     rax, 32
    or      rax, t0q
    RET

ALIGN 64
cglobal scd_frame, 5, 12, 16, st, ia, ie, ip, ifno, hd, t0, ln, of, t1, t2, t3
    mov     hdq, [stq+D_HEAD]
    mov     lnq, [stq+D_LEN]
    mov     ofq, [stq+D_OFF]
    COSTS
    vbroadcastsd m0, xm0
    vmovsd  xm4, [stq+D_ITHR]
    vcomisd xm2, xm4
    setae   t1b
    movzx   t1d, t1b
    vxorpd  xm5, xm5, xm5
    vcomisd xm5, xm1
    setae   t2b
    movzx   t2d, t2b
    xor     t3d, t3d
    cmp     ifnoq, 1
    setne   t3b
    cmp     ofq, 1
    sbb     t0d, t0d
    not     t0d
    and     t3d, t0d
    neg     t3q
    vmovq   xm15, t3q
    test    hdq, hdq
    jz      .compact
.after:
    lea     ifnoq, [hdq-1]
    mov     [stq+D_HEAD], ifnoq
    vmovsd  [stq+ifnoq*8+D_INTER], xm0
    vmovsd  [stq+ifnoq*8+D_IMP], xm2
    vmovsd  [stq+ifnoq*8+D_THR], xm1
    mov     qword [stq+ifnoq*8+D_FWD], 0
    vbroadcastsd m3, xm4
    vmovupd m1, [stq+hdq*8+D_THR]
    vmovupd m2, [stq+hdq*8+D_THR+32]
    vmovupd m7, [stq+hdq*8+D_THR+64]
    vcmppd  m8,  m3, [stq+hdq*8+D_IMP], 0x12
    vcmppd  m9,  m3, [stq+hdq*8+D_IMP+32], 0x12
    vcmppd  m10, m3, [stq+hdq*8+D_IMP+64], 0x12
    vmovmskpd ied, m8
    vmovmskpd eax, m9
    shl     eax, 4
    or      ied, eax
    vmovmskpd eax, m10
    shl     eax, 8
    or      ied, eax
    lea     ied, [t1q+ieq*2]
    vcmppd  m8,  m1, [stq+hdq*8+D_BACK], 0x12
    vcmppd  m9,  m2, [stq+hdq*8+D_BACK+32], 0x12
    vcmppd  m10, m7, [stq+hdq*8+D_BACK+64], 0x12
    vmovmskpd ipd, m8
    vmovmskpd eax, m9
    shl     eax, 4
    or      ipd, eax
    vmovmskpd eax, m10
    shl     eax, 8
    or      ipd, eax
    lea     eax, [ofq*8]
    vmovupd m11, [masktab+rax*8]
    vmovupd m12, [masktab+rax*8+32]
    vmaskmovpd m4, m11, [stq+hdq*8+D_INTER]
    vmaskmovpd m5, m12, [stq+hdq*8+D_INTER+32]
    vmaxpd  m13, m4, m5
    vsubpd  m6, m4, m0
    vsubpd  m3, m5, m0
    vxorpd  xm9, xm9, xm9
    vminpd  m8, m6, [stq+hdq*8+D_FWD]
    vblendpd m6, m8, m6, 1
    vminpd  m3, m3, [stq+hdq*8+D_FWD+32]
    vmaxpd  m6, m6, m9
    vmaxpd  m3, m3, m9
    vmaskmovpd [stq+hdq*8+D_FWD], m11, m6
    vmaskmovpd [stq+hdq*8+D_FWD+32], m12, m3
    vcmppd  m8,  m1, m6, 0x12
    vcmppd  m10, m2, m3, 0x12
    vmovmskpd iad, m8
    vmovmskpd eax, m10
    shl     eax, 4
    or      iad, eax
    lea     iad, [t2q+iaq*2]
    vextractf128 xm14, m13, 1
    vmaxpd  xm13, xm13, xm14
    vshufpd xm14, xm13, xm13, 1
    vmaxsd  xm13, xm13, xm14
    vsubsd  xm13, xm0, xm13
    vmaxsd  xm13, xm13, xm9
    vandpd  xm13, xm13, xm15
    vmovsd  [stq+ifnoq*8+D_BACK], xm13
    inc     lnq
    mov     eax, -1
    bzhi    t2d, eax, lnd
    bzhi    t3d, eax, ofd
    andn    t1d, t3d, t2d
    and     ied, t1d
    blsr    t1d, t1d
    shr     t1d, 1
    and     ipd, t1d
    lea     eax, [t3q*2+1]
    and     iad, eax
    lea     t3d, [t3q+1]
    sub     iad, t3d
    neg     ipd
    adc     iad, iad
    xor     eax, eax
    cmp     iad, 3
    sbb     iad, iad
    test    ied, ied
    cmovne  eax, iad
    and     eax, 1
    lea     t1q, [lnq-1]
    cmp     lnq, 10
    cmova   lnq, t1q
    mov     [stq+D_LEN], lnq
    lea     t1q, [ifnoq+ofq]
    vmovsd  xm3, [stq+t1q*8+D_INTER]
    vmovsd  xm4, [stq+t1q*8+D_THR]
    vcvtsd2ss xm3, xm3, xm3
    vcvtsd2ss xm4, xm4, xm4
    vdivss  xm3, xm3, xm4
    vmovd   t1d, xm3
    shl     t1q, 32
    or      rax, t1q
    RET
.compact:
    MV2 D_INTER
    MV2 D_IMP
    MV2 D_THR
    MV2 D_BACK
    MV2 D_FWD
    mov     hdq, DSL
    jmp     .after
