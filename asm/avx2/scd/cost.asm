%include "dav1d_x86inc.asm"

SECTION_RODATA 32
pw_1:   times 8 dd 0x00010001
pd_2:   times 8 dd 2
pd_32:  times 8 dd 32
pw_8c:  times 16 dw 1024
pw_8cA: times 16 dw 4096
lmask:  dd 0,0,0,0,0,0,0,0
        dd -1,-1,-1,-1,0,0,0,0
        dd -1,-1,-1,-1,-1,-1,-1,-1

SECTION .text align=64
INIT_YMM avx2

%macro HAD8A 4
    %assign D0 %1+0
    %assign D1 %1+1
    %assign D2 %1+2
    %assign D3 %1+3
    %assign D4 %1+4
    %assign D5 %1+5
    %assign D6 %1+6
    %assign D7 %1+7
    %assign T0 %2+0
    %assign T1 %2+1
    %assign T2 %2+2
    %assign T3 %2+3
    %assign T4 %2+4
    %assign T5 %2+5
    %assign T6 %2+6
    %assign T7 %2+7
    vpaddw ymm %+ T0, ymm %+ D0, ymm %+ D1
    vpsubw ymm %+ T1, ymm %+ D0, ymm %+ D1
    vpaddw ymm %+ T2, ymm %+ D2, ymm %+ D3
    vpsubw ymm %+ T3, ymm %+ D2, ymm %+ D3
    vpaddw ymm %+ T4, ymm %+ D4, ymm %+ D5
    vpsubw ymm %+ T5, ymm %+ D4, ymm %+ D5
    vpaddw ymm %+ T6, ymm %+ D6, ymm %+ D7
    vpsubw ymm %+ T7, ymm %+ D6, ymm %+ D7
    vpaddw ymm %+ D0, ymm %+ T0, ymm %+ T2
    vpsubw ymm %+ D2, ymm %+ T0, ymm %+ T2
    vpaddw ymm %+ D1, ymm %+ T1, ymm %+ T3
    vpsubw ymm %+ D3, ymm %+ T1, ymm %+ T3
    vpaddw ymm %+ D4, ymm %+ T4, ymm %+ T6
    vpsubw ymm %+ D6, ymm %+ T4, ymm %+ T6
    vpaddw ymm %+ D5, ymm %+ T5, ymm %+ T7
    vpsubw ymm %+ D7, ymm %+ T5, ymm %+ T7
    vpaddw ymm %+ T0, ymm %+ D0, ymm %+ D4
    vpsubw ymm %+ T4, ymm %+ D0, ymm %+ D4
    vpaddw ymm %+ T1, ymm %+ D1, ymm %+ D5
    vpsubw ymm %+ T5, ymm %+ D1, ymm %+ D5
    vpaddw ymm %+ T2, ymm %+ D2, ymm %+ D6
    vpsubw ymm %+ T6, ymm %+ D2, ymm %+ D6
    vpaddw ymm %+ T3, ymm %+ D3, ymm %+ D7
    vpsubw ymm %+ T7, ymm %+ D3, ymm %+ D7
%if %3
    vpsubw ymm %+ T0, ymm %+ T0, [%4]
%endif
    vpunpcklwd ymm %+ D0, ymm %+ T0, ymm %+ T1
    vpunpckhwd ymm %+ D1, ymm %+ T0, ymm %+ T1
    vpunpcklwd ymm %+ D2, ymm %+ T2, ymm %+ T3
    vpunpckhwd ymm %+ D3, ymm %+ T2, ymm %+ T3
    vpunpcklwd ymm %+ D4, ymm %+ T4, ymm %+ T5
    vpunpckhwd ymm %+ D5, ymm %+ T4, ymm %+ T5
    vpunpcklwd ymm %+ D6, ymm %+ T6, ymm %+ T7
    vpunpckhwd ymm %+ D7, ymm %+ T6, ymm %+ T7
    vpunpckldq ymm %+ T0, ymm %+ D0, ymm %+ D2
    vpunpckhdq ymm %+ T1, ymm %+ D0, ymm %+ D2
    vpunpckldq ymm %+ T2, ymm %+ D1, ymm %+ D3
    vpunpckhdq ymm %+ T3, ymm %+ D1, ymm %+ D3
    vpunpckldq ymm %+ T4, ymm %+ D4, ymm %+ D6
    vpunpckhdq ymm %+ T5, ymm %+ D4, ymm %+ D6
    vpunpckldq ymm %+ T6, ymm %+ D5, ymm %+ D7
    vpunpckhdq ymm %+ T7, ymm %+ D5, ymm %+ D7
    vpunpcklqdq ymm %+ D0, ymm %+ T0, ymm %+ T4
    vpunpckhqdq ymm %+ D1, ymm %+ T0, ymm %+ T4
    vpunpcklqdq ymm %+ D2, ymm %+ T1, ymm %+ T5
    vpunpckhqdq ymm %+ D3, ymm %+ T1, ymm %+ T5
    vpunpcklqdq ymm %+ D4, ymm %+ T2, ymm %+ T6
    vpunpckhqdq ymm %+ D5, ymm %+ T2, ymm %+ T6
    vpunpcklqdq ymm %+ D6, ymm %+ T3, ymm %+ T7
    vpunpckhqdq ymm %+ D7, ymm %+ T3, ymm %+ T7
    vpaddw ymm %+ T0, ymm %+ D0, ymm %+ D1
    vpsubw ymm %+ T1, ymm %+ D0, ymm %+ D1
    vpaddw ymm %+ T2, ymm %+ D2, ymm %+ D3
    vpsubw ymm %+ T3, ymm %+ D2, ymm %+ D3
    vpaddw ymm %+ T4, ymm %+ D4, ymm %+ D5
    vpsubw ymm %+ T5, ymm %+ D4, ymm %+ D5
    vpaddw ymm %+ T6, ymm %+ D6, ymm %+ D7
    vpsubw ymm %+ T7, ymm %+ D6, ymm %+ D7
    vpaddw ymm %+ D0, ymm %+ T0, ymm %+ T2
    vpsubw ymm %+ D2, ymm %+ T0, ymm %+ T2
    vpaddw ymm %+ D1, ymm %+ T1, ymm %+ T3
    vpsubw ymm %+ D3, ymm %+ T1, ymm %+ T3
    vpaddw ymm %+ D4, ymm %+ T4, ymm %+ T6
    vpsubw ymm %+ D6, ymm %+ T4, ymm %+ T6
    vpaddw ymm %+ D5, ymm %+ T5, ymm %+ T7
    vpsubw ymm %+ D7, ymm %+ T5, ymm %+ T7
    vpabsw ymm %+ T0, ymm %+ D0
    vpabsw ymm %+ T1, ymm %+ D4
    vpmaxsw ymm %+ T0, ymm %+ T0, ymm %+ T1
    vpabsw ymm %+ T1, ymm %+ D1
    vpabsw ymm %+ T2, ymm %+ D5
    vpmaxsw ymm %+ T1, ymm %+ T1, ymm %+ T2
    vpabsw ymm %+ T2, ymm %+ D2
    vpabsw ymm %+ T3, ymm %+ D6
    vpmaxsw ymm %+ T2, ymm %+ T2, ymm %+ T3
    vpabsw ymm %+ T3, ymm %+ D3
    vpabsw ymm %+ T4, ymm %+ D7
    vpmaxsw ymm %+ T3, ymm %+ T3, ymm %+ T4
    vpaddw ymm %+ T0, ymm %+ T0, ymm %+ T1
    vpaddw ymm %+ T2, ymm %+ T2, ymm %+ T3
    vpaddw ymm %+ T0, ymm %+ T0, ymm %+ T2
%endmacro

%macro LSUMA 4
    vpshufd  ymm%2, ymm%1, 0xb1
    vpaddd   ymm%1, ymm%1, ymm%2
    vpshufd  ymm%2, ymm%1, 0x4e
    vpaddd   ymm%1, ymm%1, ymm%2
    vpaddd   ymm%1, ymm%1, [%3]
    vpsrld   ymm%1, ymm%1, %4
%endmacro

%macro HSUMA 1
    vextracti128 xmm15, ymm%1, 1
    vpaddd  xmm%1, xmm%1, xmm15
    vpshufd xmm15, xmm%1, 0x4e
    vpaddd  xmm%1, xmm%1, xmm15
    vpshufd xmm15, xmm%1, 0xb1
    vpaddd  xmm%1, xmm%1, xmm15
    vmovd   eax, xmm%1
%endmacro

%macro LDA 2
%if MODE == 0
    vpmovzxbw ymm%1, %2
%elif MODE == 1
    vmovdqu   ymm%1, %2
%else
    vmovdqu   ymm%1, %2
    vpsrlw    ymm%1, ymm%1, 6
%endif
%endmacro

%macro CSBODYA 2
    sub     rsp, 224
    xor     iad, iad
    xor     ied, ied
    vpxor   ymm0, ymm0, ymm0
    vmovdqu [rsp+64], ymm0
    lea     s3q, [strideq*3]
    mov     byq, hbq
.row:
    vpxor   ymm0, ymm0, ymm0
    vmovdqu [rsp], ymm0
    vmovdqu [rsp+32], ymm0
    mov     [rsp+192], curq
    mov     [rsp+200], rfq
    vmovdqu ymm0, [lmask+64]
    vmovdqu [rsp+160], ymm0
    mov     t1q, wbq
    shr     t1q, 1
    mov     bxq, wbq
    and     bxq, 1
    test    t1q, t1q
    jz      .dotail
.grp:
    lea     c4q, [curq+strideq*4]
    LDA 0, [curq]
    LDA 1, [curq+strideq]
    LDA 2, [curq+strideq*2]
    LDA 3, [curq+s3q]
    LDA 4, [c4q]
    LDA 5, [c4q+strideq]
    LDA 6, [c4q+strideq*2]
    LDA 7, [c4q+s3q]
    vpaddw  ymm8, ymm0, ymm1
    vpaddw  ymm9, ymm2, ymm3
    vpaddw  ymm10, ymm4, ymm5
    vpaddw  ymm11, ymm6, ymm7
    vpaddw  ymm8, ymm8, ymm9
    vpaddw  ymm10, ymm10, ymm11
    vpaddw  ymm8, ymm8, ymm10
    vmovdqu [rsp+96], ymm8
    HAD8A 0, 8, 1, %2
    vpmaddwd ymm8, ymm8, [pw_1]
    LSUMA 8, 0, pd_2, 2
    vpand   ymm8, ymm8, [rsp+160]
    vpaddd  ymm8, ymm8, [rsp]
    vmovdqu [rsp], ymm8
    lea     p4q, [rfq+strideq*4]
    LDA 0, [rfq]
    LDA 1, [rfq+strideq]
    LDA 2, [rfq+strideq*2]
    LDA 3, [rfq+s3q]
    LDA 4, [p4q]
    LDA 5, [p4q+strideq]
    LDA 6, [p4q+strideq*2]
    LDA 7, [p4q+s3q]
    vpaddw  ymm8, ymm0, ymm1
    vpaddw  ymm9, ymm2, ymm3
    vpaddw  ymm10, ymm4, ymm5
    vpaddw  ymm11, ymm6, ymm7
    vpaddw  ymm8, ymm8, ymm9
    vpaddw  ymm10, ymm10, ymm11
    vpaddw  ymm8, ymm8, ymm10
    vmovdqu ymm9, [rsp+96]
    vpmaddwd ymm9, ymm9, [pw_1]
    LSUMA 9, 12, pd_32, 6
    vpmaddwd ymm8, ymm8, [pw_1]
    LSUMA 8, 12, pd_32, 6
    vpsubd  ymm9, ymm9, ymm8
    vpabsd  ymm9, ymm9
    vpand   ymm9, ymm9, [rsp+160]
    vpaddd  ymm9, ymm9, [rsp+64]
    vmovdqu [rsp+64], ymm9
    LDA 8,  [curq]
    LDA 9,  [curq+strideq]
    LDA 10, [curq+strideq*2]
    LDA 11, [curq+s3q]
    LDA 12, [c4q]
    LDA 13, [c4q+strideq]
    LDA 14, [c4q+strideq*2]
    LDA 15, [c4q+s3q]
    vpsubw  ymm0, ymm8, ymm0
    vpsubw  ymm1, ymm9, ymm1
    vpsubw  ymm2, ymm10, ymm2
    vpsubw  ymm3, ymm11, ymm3
    vpsubw  ymm4, ymm12, ymm4
    vpsubw  ymm5, ymm13, ymm5
    vpsubw  ymm6, ymm14, ymm6
    vpsubw  ymm7, ymm15, ymm7
    HAD8A 0, 8, 0, %2
    vpmaddwd ymm8, ymm8, [pw_1]
    LSUMA 8, 0, pd_2, 2
    vpand   ymm8, ymm8, [rsp+160]
    vpaddd  ymm8, ymm8, [rsp+32]
    vmovdqu [rsp+32], ymm8
    add     curq, %1
    add     rfq, %1
    dec     t1q
    jnz     .grp
.dotail:
    test    bxq, bxq
    jz      .rowend
    vmovdqu ymm0, [lmask+32]
    vmovdqu [rsp+160], ymm0
    mov     t1q, 1
    xor     bxq, bxq
    jmp     .grp
.rowend:
    mov     curq, [rsp+192]
    mov     rfq, [rsp+200]
    vmovdqu ymm12, [rsp]
    vmovdqu ymm13, [rsp+32]
    HSUMA 12
    shr     eax, 2
    add     iaq, rax
    HSUMA 13
    shr     eax, 2
    add     ieq, rax
    lea     curq, [curq+strideq*8]
    lea     rfq, [rfq+strideq*8]
    dec     byq
    jnz     .row
    vmovdqu ymm14, [rsp+64]
    HSUMA 14
    shr     eax, 2
    mov     [outq], iaq
    mov     [outq+8], ieq
    mov     [outq+16], rax
    add     rsp, 224
    RET
%endmacro

ALIGN 64
cglobal cost_sums, 6, 14, 16, cur, rf, stride, wb, hb, out, t1, c4, p4, s3, bx, by, ia, ie
    %assign MODE 0
    CSBODYA 16, pw_8c

ALIGN 64
cglobal cost_sums16, 6, 14, 16, cur, rf, stride, wb, hb, out, t1, c4, p4, s3, bx, by, ia, ie
    %assign MODE 1
    CSBODYA 32, pw_8cA

ALIGN 64
cglobal cost_sums16_s, 6, 14, 16, cur, rf, stride, wb, hb, out, t1, c4, p4, s3, bx, by, ia, ie
    %assign MODE 2
    CSBODYA 32, pw_8cA
