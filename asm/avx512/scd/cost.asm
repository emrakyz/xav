%include "dav1d_x86inc.asm"

SECTION_RODATA 64
pw_1:   times 16 dd 0x00010001
pd_2:   times 16 dd 2
pd_32:  times 16 dd 32
pw_8c:  times 32 dw 1024
pw_8cA: times 32 dw 4096

SECTION .text align=64
INIT_ZMM avx512

%macro HAD8X 5
    %assign D0a %1+0
    %assign D1a %1+1
    %assign D2a %1+2
    %assign D3a %1+3
    %assign D4a %1+4
    %assign D5a %1+5
    %assign D6a %1+6
    %assign D7a %1+7
    %assign T0a %2+0
    %assign T1a %2+1
    %assign T2a %2+2
    %assign T3a %2+3
    %assign T4a %2+4
    %assign T5a %2+5
    %assign T6a %2+6
    %assign T7a %2+7
    %assign D0b %3+0
    %assign D1b %3+1
    %assign D2b %3+2
    %assign D3b %3+3
    %assign D4b %3+4
    %assign D5b %3+5
    %assign D6b %3+6
    %assign D7b %3+7
    %assign T0b %4+0
    %assign T1b %4+1
    %assign T2b %4+2
    %assign T3b %4+3
    %assign T4b %4+4
    %assign T5b %4+5
    %assign T6b %4+6
    %assign T7b %4+7
    vpaddw zmm %+ T0a, zmm %+ D0a, zmm %+ D1a
    vpaddw zmm %+ T0b, zmm %+ D0b, zmm %+ D1b
    vpsubw zmm %+ T1a, zmm %+ D0a, zmm %+ D1a
    vpsubw zmm %+ T1b, zmm %+ D0b, zmm %+ D1b
    vpaddw zmm %+ T2a, zmm %+ D2a, zmm %+ D3a
    vpaddw zmm %+ T2b, zmm %+ D2b, zmm %+ D3b
    vpsubw zmm %+ T3a, zmm %+ D2a, zmm %+ D3a
    vpsubw zmm %+ T3b, zmm %+ D2b, zmm %+ D3b
    vpaddw zmm %+ T4a, zmm %+ D4a, zmm %+ D5a
    vpaddw zmm %+ T4b, zmm %+ D4b, zmm %+ D5b
    vpsubw zmm %+ T5a, zmm %+ D4a, zmm %+ D5a
    vpsubw zmm %+ T5b, zmm %+ D4b, zmm %+ D5b
    vpaddw zmm %+ T6a, zmm %+ D6a, zmm %+ D7a
    vpaddw zmm %+ T6b, zmm %+ D6b, zmm %+ D7b
    vpsubw zmm %+ T7a, zmm %+ D6a, zmm %+ D7a
    vpsubw zmm %+ T7b, zmm %+ D6b, zmm %+ D7b
    vpaddw zmm %+ D0a, zmm %+ T0a, zmm %+ T2a
    vpaddw zmm %+ D0b, zmm %+ T0b, zmm %+ T2b
    vpsubw zmm %+ D2a, zmm %+ T0a, zmm %+ T2a
    vpsubw zmm %+ D2b, zmm %+ T0b, zmm %+ T2b
    vpaddw zmm %+ D1a, zmm %+ T1a, zmm %+ T3a
    vpaddw zmm %+ D1b, zmm %+ T1b, zmm %+ T3b
    vpsubw zmm %+ D3a, zmm %+ T1a, zmm %+ T3a
    vpsubw zmm %+ D3b, zmm %+ T1b, zmm %+ T3b
    vpaddw zmm %+ D4a, zmm %+ T4a, zmm %+ T6a
    vpaddw zmm %+ D4b, zmm %+ T4b, zmm %+ T6b
    vpsubw zmm %+ D6a, zmm %+ T4a, zmm %+ T6a
    vpsubw zmm %+ D6b, zmm %+ T4b, zmm %+ T6b
    vpaddw zmm %+ D5a, zmm %+ T5a, zmm %+ T7a
    vpaddw zmm %+ D5b, zmm %+ T5b, zmm %+ T7b
    vpsubw zmm %+ D7a, zmm %+ T5a, zmm %+ T7a
    vpsubw zmm %+ D7b, zmm %+ T5b, zmm %+ T7b
    vpaddw zmm %+ T0a, zmm %+ D0a, zmm %+ D4a
    vpaddw zmm %+ T0b, zmm %+ D0b, zmm %+ D4b
    vpsubw zmm %+ T4a, zmm %+ D0a, zmm %+ D4a
    vpsubw zmm %+ T4b, zmm %+ D0b, zmm %+ D4b
    vpaddw zmm %+ T1a, zmm %+ D1a, zmm %+ D5a
    vpaddw zmm %+ T1b, zmm %+ D1b, zmm %+ D5b
    vpsubw zmm %+ T5a, zmm %+ D1a, zmm %+ D5a
    vpsubw zmm %+ T5b, zmm %+ D1b, zmm %+ D5b
    vpaddw zmm %+ T2a, zmm %+ D2a, zmm %+ D6a
    vpaddw zmm %+ T2b, zmm %+ D2b, zmm %+ D6b
    vpsubw zmm %+ T6a, zmm %+ D2a, zmm %+ D6a
    vpsubw zmm %+ T6b, zmm %+ D2b, zmm %+ D6b
    vpaddw zmm %+ T3a, zmm %+ D3a, zmm %+ D7a
    vpaddw zmm %+ T3b, zmm %+ D3b, zmm %+ D7b
    vpsubw zmm %+ T7a, zmm %+ D3a, zmm %+ D7a
    vpsubw zmm %+ T7b, zmm %+ D3b, zmm %+ D7b
    vpsubw zmm %+ T0a, zmm %+ T0a, [%5]
    vpunpcklwd zmm %+ D0a, zmm %+ T0a, zmm %+ T1a
    vpunpcklwd zmm %+ D0b, zmm %+ T0b, zmm %+ T1b
    vpunpckhwd zmm %+ D1a, zmm %+ T0a, zmm %+ T1a
    vpunpckhwd zmm %+ D1b, zmm %+ T0b, zmm %+ T1b
    vpunpcklwd zmm %+ D2a, zmm %+ T2a, zmm %+ T3a
    vpunpcklwd zmm %+ D2b, zmm %+ T2b, zmm %+ T3b
    vpunpckhwd zmm %+ D3a, zmm %+ T2a, zmm %+ T3a
    vpunpckhwd zmm %+ D3b, zmm %+ T2b, zmm %+ T3b
    vpunpcklwd zmm %+ D4a, zmm %+ T4a, zmm %+ T5a
    vpunpcklwd zmm %+ D4b, zmm %+ T4b, zmm %+ T5b
    vpunpckhwd zmm %+ D5a, zmm %+ T4a, zmm %+ T5a
    vpunpckhwd zmm %+ D5b, zmm %+ T4b, zmm %+ T5b
    vpunpcklwd zmm %+ D6a, zmm %+ T6a, zmm %+ T7a
    vpunpcklwd zmm %+ D6b, zmm %+ T6b, zmm %+ T7b
    vpunpckhwd zmm %+ D7a, zmm %+ T6a, zmm %+ T7a
    vpunpckhwd zmm %+ D7b, zmm %+ T6b, zmm %+ T7b
    vpunpckldq zmm %+ T0a, zmm %+ D0a, zmm %+ D2a
    vpunpckldq zmm %+ T0b, zmm %+ D0b, zmm %+ D2b
    vpunpckhdq zmm %+ T1a, zmm %+ D0a, zmm %+ D2a
    vpunpckhdq zmm %+ T1b, zmm %+ D0b, zmm %+ D2b
    vpunpckldq zmm %+ T2a, zmm %+ D1a, zmm %+ D3a
    vpunpckldq zmm %+ T2b, zmm %+ D1b, zmm %+ D3b
    vpunpckhdq zmm %+ T3a, zmm %+ D1a, zmm %+ D3a
    vpunpckhdq zmm %+ T3b, zmm %+ D1b, zmm %+ D3b
    vpunpckldq zmm %+ T4a, zmm %+ D4a, zmm %+ D6a
    vpunpckldq zmm %+ T4b, zmm %+ D4b, zmm %+ D6b
    vpunpckhdq zmm %+ T5a, zmm %+ D4a, zmm %+ D6a
    vpunpckhdq zmm %+ T5b, zmm %+ D4b, zmm %+ D6b
    vpunpckldq zmm %+ T6a, zmm %+ D5a, zmm %+ D7a
    vpunpckldq zmm %+ T6b, zmm %+ D5b, zmm %+ D7b
    vpunpckhdq zmm %+ T7a, zmm %+ D5a, zmm %+ D7a
    vpunpckhdq zmm %+ T7b, zmm %+ D5b, zmm %+ D7b
    vpunpcklqdq zmm %+ D0a, zmm %+ T0a, zmm %+ T4a
    vpunpcklqdq zmm %+ D0b, zmm %+ T0b, zmm %+ T4b
    vpunpckhqdq zmm %+ D1a, zmm %+ T0a, zmm %+ T4a
    vpunpckhqdq zmm %+ D1b, zmm %+ T0b, zmm %+ T4b
    vpunpcklqdq zmm %+ D2a, zmm %+ T1a, zmm %+ T5a
    vpunpcklqdq zmm %+ D2b, zmm %+ T1b, zmm %+ T5b
    vpunpckhqdq zmm %+ D3a, zmm %+ T1a, zmm %+ T5a
    vpunpckhqdq zmm %+ D3b, zmm %+ T1b, zmm %+ T5b
    vpunpcklqdq zmm %+ D4a, zmm %+ T2a, zmm %+ T6a
    vpunpcklqdq zmm %+ D4b, zmm %+ T2b, zmm %+ T6b
    vpunpckhqdq zmm %+ D5a, zmm %+ T2a, zmm %+ T6a
    vpunpckhqdq zmm %+ D5b, zmm %+ T2b, zmm %+ T6b
    vpunpcklqdq zmm %+ D6a, zmm %+ T3a, zmm %+ T7a
    vpunpcklqdq zmm %+ D6b, zmm %+ T3b, zmm %+ T7b
    vpunpckhqdq zmm %+ D7a, zmm %+ T3a, zmm %+ T7a
    vpunpckhqdq zmm %+ D7b, zmm %+ T3b, zmm %+ T7b
    vpaddw zmm %+ T0a, zmm %+ D0a, zmm %+ D1a
    vpaddw zmm %+ T0b, zmm %+ D0b, zmm %+ D1b
    vpsubw zmm %+ T1a, zmm %+ D0a, zmm %+ D1a
    vpsubw zmm %+ T1b, zmm %+ D0b, zmm %+ D1b
    vpaddw zmm %+ T2a, zmm %+ D2a, zmm %+ D3a
    vpaddw zmm %+ T2b, zmm %+ D2b, zmm %+ D3b
    vpsubw zmm %+ T3a, zmm %+ D2a, zmm %+ D3a
    vpsubw zmm %+ T3b, zmm %+ D2b, zmm %+ D3b
    vpaddw zmm %+ T4a, zmm %+ D4a, zmm %+ D5a
    vpaddw zmm %+ T4b, zmm %+ D4b, zmm %+ D5b
    vpsubw zmm %+ T5a, zmm %+ D4a, zmm %+ D5a
    vpsubw zmm %+ T5b, zmm %+ D4b, zmm %+ D5b
    vpaddw zmm %+ T6a, zmm %+ D6a, zmm %+ D7a
    vpaddw zmm %+ T6b, zmm %+ D6b, zmm %+ D7b
    vpsubw zmm %+ T7a, zmm %+ D6a, zmm %+ D7a
    vpsubw zmm %+ T7b, zmm %+ D6b, zmm %+ D7b
    vpaddw zmm %+ D0a, zmm %+ T0a, zmm %+ T2a
    vpaddw zmm %+ D0b, zmm %+ T0b, zmm %+ T2b
    vpsubw zmm %+ D2a, zmm %+ T0a, zmm %+ T2a
    vpsubw zmm %+ D2b, zmm %+ T0b, zmm %+ T2b
    vpaddw zmm %+ D1a, zmm %+ T1a, zmm %+ T3a
    vpaddw zmm %+ D1b, zmm %+ T1b, zmm %+ T3b
    vpsubw zmm %+ D3a, zmm %+ T1a, zmm %+ T3a
    vpsubw zmm %+ D3b, zmm %+ T1b, zmm %+ T3b
    vpaddw zmm %+ D4a, zmm %+ T4a, zmm %+ T6a
    vpaddw zmm %+ D4b, zmm %+ T4b, zmm %+ T6b
    vpsubw zmm %+ D6a, zmm %+ T4a, zmm %+ T6a
    vpsubw zmm %+ D6b, zmm %+ T4b, zmm %+ T6b
    vpaddw zmm %+ D5a, zmm %+ T5a, zmm %+ T7a
    vpaddw zmm %+ D5b, zmm %+ T5b, zmm %+ T7b
    vpsubw zmm %+ D7a, zmm %+ T5a, zmm %+ T7a
    vpsubw zmm %+ D7b, zmm %+ T5b, zmm %+ T7b
    vpabsw zmm %+ T0a, zmm %+ D0a
    vpabsw zmm %+ T0b, zmm %+ D0b
    vpabsw zmm %+ T1a, zmm %+ D4a
    vpabsw zmm %+ T1b, zmm %+ D4b
    vpmaxsw zmm %+ T0a, zmm %+ T0a, zmm %+ T1a
    vpmaxsw zmm %+ T0b, zmm %+ T0b, zmm %+ T1b
    vpabsw zmm %+ T1a, zmm %+ D1a
    vpabsw zmm %+ T1b, zmm %+ D1b
    vpabsw zmm %+ T2a, zmm %+ D5a
    vpabsw zmm %+ T2b, zmm %+ D5b
    vpmaxsw zmm %+ T1a, zmm %+ T1a, zmm %+ T2a
    vpmaxsw zmm %+ T1b, zmm %+ T1b, zmm %+ T2b
    vpabsw zmm %+ T2a, zmm %+ D2a
    vpabsw zmm %+ T2b, zmm %+ D2b
    vpabsw zmm %+ T3a, zmm %+ D6a
    vpabsw zmm %+ T3b, zmm %+ D6b
    vpmaxsw zmm %+ T2a, zmm %+ T2a, zmm %+ T3a
    vpmaxsw zmm %+ T2b, zmm %+ T2b, zmm %+ T3b
    vpabsw zmm %+ T3a, zmm %+ D3a
    vpabsw zmm %+ T3b, zmm %+ D3b
    vpabsw zmm %+ T4a, zmm %+ D7a
    vpabsw zmm %+ T4b, zmm %+ D7b
    vpmaxsw zmm %+ T3a, zmm %+ T3a, zmm %+ T4a
    vpmaxsw zmm %+ T3b, zmm %+ T3b, zmm %+ T4b
    vpaddw zmm %+ T0a, zmm %+ T0a, zmm %+ T1a
    vpaddw zmm %+ T0b, zmm %+ T0b, zmm %+ T1b
    vpaddw zmm %+ T2a, zmm %+ T2a, zmm %+ T3a
    vpaddw zmm %+ T2b, zmm %+ T2b, zmm %+ T3b
    vpaddw zmm %+ T0a, zmm %+ T0a, zmm %+ T2a
    vpaddw zmm %+ T0b, zmm %+ T0b, zmm %+ T2b
%endmacro

%macro LSUM 4
    vpshufd  zmm%2, zmm%1, 0xb1
    vpaddd   zmm%1, zmm%1, zmm%2
    vpshufd  zmm%2, zmm%1, 0x4e
    vpaddd   zmm%1, zmm%1, zmm%2
    vpaddd   zmm%1, zmm%1, [%3]
    vpsrld   zmm%1, zmm%1, %4
%endmacro

%macro HSUM 1
    vextracti64x4 ymm31, zmm%1, 1
    vpaddd  ymm%1, ymm%1, ymm31
    vextracti128 xmm31, ymm%1, 1
    vpaddd  xmm%1, xmm%1, xmm31
    vpshufd xmm31, xmm%1, 0x4e
    vpaddd  xmm%1, xmm%1, xmm31
    vpshufd xmm31, xmm%1, 0xb1
    vpaddd  xmm%1, xmm%1, xmm31
    vmovd   eax, xmm%1
%endmacro

%macro LD 2
%if MODE == 0
    vpmovzxbw zmm%1, %2
%elif MODE == 1
    vmovdqu64 zmm%1, %2
%else
    vpsrlw    zmm%1, %2, 6
%endif
%endmacro

%macro CSBODY 2
    sub     rsp, 208
    xor     iad, iad
    xor     ied, ied
    vpxord  zmm0, zmm0, zmm0
    vmovdqu64 [rsp+128], zmm0
    lea     s3q, [strideq*3]
    mov     byq, hbq
.row:
    vpxord  zmm0, zmm0, zmm0
    vmovdqu64 [rsp], zmm0
    vmovdqu64 [rsp+64], zmm0
    mov     [rsp+192], curq
    mov     [rsp+200], rfq
    mov     t1q, wbq
    shr     t1q, 2
    mov     bxq, wbq
    and     bxq, 3
    mov     p4d, -1
    kmovd   k1, p4d
    kmovw   k2, p4d
    test    t1q, t1q
    jz      .dotail
.grp:
    lea     c4q, [curq+strideq*4]
    lea     p4q, [rfq+strideq*4]
    LD 0,  [curq]
    LD 16, [rfq]
    LD 1,  [curq+strideq]
    LD 17, [rfq+strideq]
    LD 2,  [curq+strideq*2]
    LD 18, [rfq+strideq*2]
    vpaddw  zmm24, zmm0, zmm1
    vpaddw  zmm25, zmm16, zmm17
    LD 3,  [curq+s3q]
    LD 19, [rfq+s3q]
    LD 4,  [c4q]
    LD 20, [p4q]
    vpaddw  zmm29, zmm2, zmm3
    vpaddw  zmm30, zmm18, zmm19
    LD 5,  [c4q+strideq]
    LD 21, [p4q+strideq]
    LD 6,  [c4q+strideq*2]
    LD 22, [p4q+strideq*2]
    vpaddw  zmm24, zmm24, zmm29
    vpaddw  zmm25, zmm25, zmm30
    LD 7,  [c4q+s3q]
    LD 23, [p4q+s3q]
    vpaddw  zmm29, zmm4, zmm5
    vpaddw  zmm30, zmm20, zmm21
    vpaddw  zmm31, zmm6, zmm7
    vpsubw  zmm16, zmm0, zmm16
    vpaddw  zmm29, zmm29, zmm31
    vpsubw  zmm17, zmm1, zmm17
    vpaddw  zmm31, zmm22, zmm23
    vpsubw  zmm18, zmm2, zmm18
    vpaddw  zmm30, zmm30, zmm31
    vpsubw  zmm19, zmm3, zmm19
    vpaddw  zmm24, zmm24, zmm29
    vpsubw  zmm20, zmm4, zmm20
    vpaddw  zmm25, zmm25, zmm30
    vpsubw  zmm21, zmm5, zmm21
    vpsubw  zmm22, zmm6, zmm22
    vpsubw  zmm23, zmm7, zmm23
    vpmaddwd zmm24, zmm24, [pw_1]
    LSUM 24, 30, pd_32, 6
    vpmaddwd zmm25, zmm25, [pw_1]
    LSUM 25, 30, pd_32, 6
    vpsubd  zmm24, zmm24, zmm25
    vpabsd  zmm24, zmm24
    vpaddd  zmm24, zmm24, [rsp+128]
    vmovdqu32 [rsp+128] {k2}, zmm24
    HAD8X 0, 8, 16, 24, %2
    vpmaddwd zmm8, zmm8, [pw_1]
    LSUM 8, 0, pd_2, 2
    vpaddd  zmm8, zmm8, [rsp]
    vmovdqu32 [rsp] {k2}, zmm8
    vpmaddwd zmm24, zmm24, [pw_1]
    LSUM 24, 16, pd_2, 2
    vpaddd  zmm24, zmm24, [rsp+64]
    vmovdqu32 [rsp+64] {k2}, zmm24
    add     curq, %1
    add     rfq, %1
    dec     t1q
    jnz     .grp
.dotail:
    test    bxq, bxq
    jz      .rowend
    mov     p4d, -1
    lea     c4d, [bxq*8]
    bzhi    c4d, p4d, c4d
    kmovd   k1, c4d
    lea     c4d, [bxq*4]
    bzhi    c4d, p4d, c4d
    kmovw   k2, c4d
    mov     t1q, 1
    xor     bxq, bxq
    jmp     .grp
.rowend:
    mov     curq, [rsp+192]
    mov     rfq, [rsp+200]
    vmovdqu64 zmm26, [rsp]
    vmovdqu64 zmm27, [rsp+64]
    HSUM 26
    shr     eax, 2
    add     iaq, rax
    HSUM 27
    shr     eax, 2
    add     ieq, rax
    lea     curq, [curq+strideq*8]
    lea     rfq, [rfq+strideq*8]
    dec     byq
    jnz     .row
    vmovdqu64 zmm28, [rsp+128]
    HSUM 28
    shr     eax, 2
    mov     [outq], iaq
    mov     [outq+8], ieq
    mov     [outq+16], rax
    add     rsp, 208
    RET
%endmacro

ALIGN 64
cglobal cost_sums, 6, 14, 32, cur, rf, stride, wb, hb, out, t1, c4, p4, s3, bx, by, ia, ie
    %assign MODE 0
    CSBODY 32, pw_8c

ALIGN 64
cglobal cost_sums16, 6, 14, 32, cur, rf, stride, wb, hb, out, t1, c4, p4, s3, bx, by, ia, ie
    %assign MODE 1
    CSBODY 64, pw_8cA

ALIGN 64
cglobal cost_sums16_s, 6, 14, 32, cur, rf, stride, wb, hb, out, t1, c4, p4, s3, bx, by, ia, ie
    %assign MODE 2
    CSBODY 64, pw_8cA
