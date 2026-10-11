W   equ 64*M
CST equ W + 64
CB0 equ 72*W*M + 64
CB  equ CB0 + 65536*((2*W*4320 + 64 - CB0 + 65535)/65536)
CPL equ (18*M + 4)*CST
CRD equ CPL + 65536*((2164*CST - CPL + 65535)/65536)
FC  equ (M - 1)/2

extern xav_fp
extern xav_op
extern xav_kw4
extern xav_kc7
extern xav_khw
extern xav_ksh
extern xav_kmu
extern xav_kmk
extern xav_kpk

section .text align=64

%macro YL 2
%if F == 1
    vmovdqu %1, %2
%elif F == 3
    vmovdqu %1, %2
    vpsrlw %1, %1, 6
%else
    vpmovzxbw %1, %2
    vpsllw %1, %1, 2
%endif
%endmacro

%macro YP 2
%if F == 1
    vpmaskmovd ymm0, ymm13, %2
%elif F == 3
    vpmaskmovd ymm0, ymm13, %2
    vpsrlw ymm0, ymm0, 6
%else
    vpmaskmovd xmm0, xmm13, %2
    vpmovzxbw ymm0, xmm0
    vpsllw ymm0, ymm0, 2
%endif
    vpermd ymm0, ymm12, ymm0
    vpshufb ymm0, ymm0, ymm11
    vmovdqu %1, ymm0
%endmacro

%macro UVD 0
    vpsrlw ymm3, ymm3, 6
    vpsrlw ymm4, ymm4, 6
    vpshufb ymm3, ymm3, ymm6
    vpshufb ymm4, ymm4, ymm6
    vpunpcklqdq ymm2, ymm3, ymm4
    vpunpckhqdq ymm3, ymm3, ymm4
    vpermq ymm2, ymm2, 0xd8
    vpermq ymm3, ymm3, 0xd8
%endmacro

%macro YROW 1
%assign k 0
%rep 4
%if F == 1
    vmovdqu ymm0, [r8 + rax*YS + (%1)*32*YS + k*8*YS]
%elif F == 3
    vmovdqu ymm0, [r8 + rax*YS + (%1)*32*YS + k*8*YS]
    vpsrlw ymm0, ymm0, 6
%else
    vpmovzxbw ymm0, [r8 + rax*YS + (%1)*32*YS + k*8*YS]
    vpsllw ymm0, ymm0, 2
%endif
    vmovdqu [rdx + rax*4 + (NB + (%1))*128 + k*32], ymm0
%assign k k + 1
%endrep
%endmacro

%macro YBND 0
%assign k 0
%rep V
    YL ymm0, [r8 + k*8*YS]
    vmovdqu [rdx + NB*128 + k*32], ymm0
%assign k k + 1
%endrep
    YP [rdx + NB*128 + V*32], [r8 + V*8*YS]
%if V < 3
    vpermd ymm1, ymm15, ymm0
    vpshufb ymm1, ymm1, ymm14
%assign k V + 1
%rep 3 - V
    vmovdqu [rdx + NB*128 + k*32], ymm1
%assign k k + 1
%endrep
%endif
%endmacro

%macro CREP 1
    vpermd %1, ymm8, %1
    vpshufb %1, %1, ymm7
%endmacro

%macro CEDG 1
    vpermd %1, ymm15, %1
    vpshufb %1, %1, ymm14
%endmacro

%macro PCOL 3
%assign k 0
%rep 2
%if F == 1
    vmovdqu ymm0, [%1 + rax*2 + (%3)*64 + k*32]
%else
    vpmovzxbw ymm0, [%1 + rax + (%3)*32 + k*16]
    vpsllw ymm0, ymm0, 2
%endif
    vmovdqu [%2 + rax*2 + (%3)*64 + k*32], ymm0
%assign k k + 1
%endrep
%endmacro

%macro PBND 2
%if V >= 2
%if F == 1
    vmovdqu ymm2, [%1]
%else
    vpmovzxbw ymm2, [%1]
    vpsllw ymm2, ymm2, 2
%endif
    vmovdqu [%2], ymm2
%assign B 1
%else
%assign B 0
%endif
%if F == 1
    vpmaskmovd ymm2, ymm10, [%1 + B*32]
%else
    vpmovzxbw ymm2, [%1 + r8]
    vpsllw ymm2, ymm2, 2
%endif
    CREP ymm2
    vmovdqu [%2 + B*32], ymm2
%if B == 0
    CEDG ymm2
    vmovdqu [%2 + 32], ymm2
%endif
%endmacro

%macro PLANE 3
%%r:
    mov rax, -(NB - RR)*32
%if RR
    PCOL %1, %2, -1
%endif
%%c:
    PCOL %1, %2, 0
    PCOL %1, %2, 1
    add rax, 64
    jnz %%c
%if V < 4
    PBND %1, %2
%endif
    add %1, r11
    add %2, CST
    dec %3
    jnz %%r
%endmacro

%macro UCOL 1
%assign k 0
%rep 2
%if F == 2
    vmovdqu ymm4, [r9 + rax*2 + (%1)*64 + k*32]
    vpmaddubsw ymm2, ymm4, ymm6
    vpmaddubsw ymm3, ymm4, ymm5
%else
    vmovdqu ymm3, [r9 + rax*4 + (%1)*128 + k*64]
    vmovdqu ymm4, [r9 + rax*4 + (%1)*128 + k*64 + 32]
    UVD
%endif
    vmovdqu [rdi + rax*2 + (%1)*64 + k*32], ymm2
    vmovdqu [rdi + rax*2 + (%1)*64 + k*32 + CRD], ymm3
%assign k k + 1
%endrep
%endmacro

%macro CST2 1
    vmovdqu [rdi + %1], ymm2
    vmovdqu [rdi + %1 + CRD], ymm3
%endmacro

%macro UBND 0
%if V >= 2
%if F == 2
    vmovdqu ymm4, [r9]
    vpmaddubsw ymm2, ymm4, ymm6
    vpmaddubsw ymm3, ymm4, ymm5
%else
    vmovdqu ymm3, [r9]
    vmovdqu ymm4, [r9 + 32]
    UVD
%endif
    CST2 0
%assign B 1
%else
%assign B 0
%endif
%if F == 2
    vpmaskmovd ymm4, ymm10, [r9 + B*32]
    CREP ymm4
    vpmaddubsw ymm2, ymm4, ymm6
    vpmaddubsw ymm3, ymm4, ymm5
%else
    vpmaskmovd ymm3, ymm10, [r9 + B*64]
    vpmaskmovd ymm4, ymm9, [r9 + B*64 + 32]
    UVD
    CREP ymm2
    CREP ymm3
%endif
    CST2 B*32
%if B == 0
%if F == 2
    CEDG ymm4
    vpmaddubsw ymm2, ymm4, ymm6
    vpmaddubsw ymm3, ymm4, ymm5
%else
    CEDG ymm2
    CEDG ymm3
%endif
    CST2 32
%endif
%endmacro

%macro FPAR 2
%assign F %1
%assign V %2
%if V == 4
%assign NB M
%else
%assign NB M - 1
%endif
%assign RR NB % 2
%if F == 1 || F == 3
%assign YS 4
%else
%assign YS 2
%endif
%endmacro

%macro FCON 0
%if V < 4
    vpbroadcastd ymm15, [rel xav_kc7]
    vbroadcasti128 ymm14, [rel xav_khw]
%if F == 1 || F == 3
    vpmovsxbd ymm13, [rel xav_fp + 48]
%else
    vpmovsxbd xmm13, [rel xav_fp + 48]
%endif
    vpmovzxbd ymm12, [rel xav_fp + 80]
    vmovdqu ymm11, [rel xav_fp + 96]
%if F == 3
    vpmovsxbd ymm10, [rel xav_fp + 64]
    vpmovsxbd ymm9, [rel xav_fp + 72]
%elif F > 0
    vpmovsxbd ymm10, [rel xav_fp + 56]
%endif
    vpmovzxbd ymm8, [rel xav_fp + 88]
    vmovdqu ymm7, [rel xav_fp + 128]
%endif
%if F == 2
    vpbroadcastw ymm6, [rel xav_kw4]
    vpsllw ymm5, ymm6, 8
%elif F == 3
    vbroadcasti128 ymm6, [rel xav_ksh]
%endif
%endmacro

%macro FILL 2
    FPAR %1, %2
align 64
global xav_fl %+ M %+ _ %+ F %+ V
xav_fl %+ M %+ _ %+ F %+ V:
    mov rdx, [rax]
    mov r8, [r15]
    add r8, [rel xav_fp]
    mov r11, [rel xav_fp + 16]
    mov ecx, [rel xav_fp + 36]
    lea rdi, [rdx + CB + NB*64]
%if F < 2
    lea rsi, [rdx + CB + CRD + NB*64]
%endif
    FCON
.y:
    mov rax, -NB*32
.v:
    YROW 0
    add rax, 32
    jnz .v
%if V < 4
    YBND
%endif
    add r8, r11
    add rdx, 2*W
    dec ecx
    jnz .y
    mov r11, [rel xav_fp + 24]
    mov ecx, [rel xav_fp + 32]
%if F < 2
%if F == 0 && V < 4
    mov r8, [rel xav_fp + 40]
%endif
    mov r9, [rel xav_fp + 8]
    mov r10, r9
    add r9, [r15 + 8]
    add r10, [r15 + 16]
    mov edx, ecx
    PLANE r9, rdi, ecx
    PLANE r10, rsi, edx
%else
    mov r9, [r15 + 8]
    add r9, [rel xav_fp + 8]
.u:
    mov rax, -(NB - RR)*32
%if RR
    UCOL -1
%endif
.w:
    UCOL 0
    UCOL 1
    add rax, 64
    jnz .w
%if V < 4
    UBND
%endif
    add r9, r11
    add rdi, CST
    dec ecx
    jnz .u
%endif
    vzeroupper
    ret
%endmacro

%assign F 0
%rep 4
%assign V 0
%rep 5
    FILL F, V
%assign V V + 1
%endrep
%assign F F + 1
%endrep

%macro PK 2
    vpmaddwd ymm1, ymm13, %1
    vpsrlq ymm2, ymm1, 12
    vpand ymm1, ymm1, ymm14
    vpandn ymm2, ymm14, ymm2
    vpor ymm1, ymm1, ymm2
    vpshufb ymm1, ymm1, ymm15
    vmovdqu [%2], xmm1
    vextracti128 [%2 + 10], ymm1, 1
%endmacro

%macro PKC 0
    vpbroadcastd ymm13, [rel xav_kmu]
    vpbroadcastq ymm14, [rel xav_kmk]
    vbroadcasti128 ymm15, [rel xav_kpk]
%endmacro

%macro PKR 3
%assign NN (%3)
%assign RR NN % 4
%assign NL NN - RR
    mov rax, -NL*8
    mov r11, -(NL*5/2)
%assign c 0
%rep RR
    PK [%1 + rax*4 + (c - RR)*32], %2 + r11*8 + (c - RR)*20
%assign c c + 1
%endrep
%%l:
%assign c 0
%rep 4
    PK [%1 + rax*4 + c*32], %2 + r11*8 + c*20
%assign c c + 1
%endrep
    add r11, 10
    add rax, 32
    jnz %%l
%endmacro

%macro PKT 2
    vpand ymm3, ymm11, [%1]
    vpand ymm4, ymm12, [%1 + 32]
    PK ymm3, %2
    PK ymm4, %2 + 20
%endmacro

%macro CPR 3
%assign NN (%3)
%assign RR NN % 4
%assign NL NN - RR
    mov rax, -NL*8
%assign c 0
%rep RR
    vmovdqu ymm0, [%1 + rax*4 + (c - RR)*32]
    vmovdqu [%2 + rax*4 + (c - RR)*32], ymm0
%assign c c + 1
%endrep
%%l:
%assign c 0
%rep 4
    vmovdqu ymm0, [%1 + rax*4 + c*32]
    vmovdqu [%2 + rax*4 + c*32], ymm0
%assign c c + 1
%endrep
    add rax, 32
    jnz %%l
%endmacro

%macro CPY2 2
    vmovdqu ymm0, [%1 + r10]
    vmovdqu ymm1, [%1 + r10 + 32]
    vmovdqu [%2 + r10], ymm0
    vmovdqu [%2 + r10 + 32], ymm1
%endmacro

%macro PLN 2
    lea rsi, [r15 + %1]
    lea rdi, [r13 + %2]
%endmacro

align 64
global xav_oc %+ M
xav_oc %+ M:
    PLN (M - 1)*64, (M - 1)*64
    mov ecx, [rel xav_op]
    mov rdx, [rel xav_op + 8]
    mov r10, [rel xav_op + 56]
.y:
    CPR rsi, rdi, 2*(M - 1)
    CPY2 rsi, rdi
    add rsi, W
    add rdi, rdx
    dec ecx
    jnz .y
    PLN FC*64, FC*64
    mov r8, rsi
    mov r9, rdi
    add rsi, [rel xav_op + 24]
    add r8, [rel xav_op + 32]
    add rdi, [rel xav_op + 40]
    add r9, [rel xav_op + 48]
    mov ecx, [rel xav_op + 4]
    mov rdx, [rel xav_op + 16]
    mov r10, [rel xav_op + 64]
.c:
    CPR rsi, rdi, 2*FC
    CPY2 rsi, rdi
    CPR r8, r9, 2*FC
    CPY2 r8, r9
    add rsi, W/2
    add r8, W/2
    add rdi, rdx
    add r9, rdx
    dec ecx
    jnz .c
    vzeroupper
    ret

align 64
global xav_o3 %+ M
xav_o3 %+ M:
    PKC
    PLN 2*M*32, 2*M*20
    mov ecx, [rel xav_op]
.y:
    PKR rsi, rdi, 2*M
    add rsi, M*64
    add rdi, M*40
    dec ecx
    jnz .y
    PLN M*32, M*20
    add rsi, [rel xav_op + 24]
    add rdi, [rel xav_op + 40]
    mov ecx, [rel xav_op + 4]
.b:
    PKR rsi, rdi, M
    add rsi, M*32
    add rdi, M*20
    dec ecx
    jnz .b
    PLN M*32, M*20
    add rsi, [rel xav_op + 32]
    add rdi, [rel xav_op + 48]
    mov ecx, [rel xav_op + 4]
    dec ecx
.r:
    PKR rsi, rdi, M
    add rsi, M*32
    add rdi, M*20
    dec ecx
    jnz .r
    lea rdx, [rdi - M*20]
    sub rsp, M*20 + 32
    lea rdi, [rsp + M*20]
    PKR rsi, rdi, M
    mov rsi, rsp
    mov rdi, rdx
    mov ecx, M*20
    rep movsb
    add rsp, M*20 + 32
    vzeroupper
    ret

align 64
global xav_o4 %+ M
xav_o4 %+ M:
    PKC
    vpmovsxbw ymm11, [rel xav_op + 56]
    vpmovsxbw ymm12, [rel xav_op + 72]
    PLN (M - 1)*64, (M - 1)*40
    mov ecx, [rel xav_op]
    mov rdx, [rel xav_op + 8]
.y:
    PKR rsi, rdi, 2*(M - 1)
    PKT rsi, rdi
    add rsi, W
    add rdi, rdx
    dec ecx
    jnz .y
    vpmovsxbw ymm11, [rel xav_op + 88]
    vpmovsxbw ymm12, [rel xav_op + 104]
    mov rdx, [rel xav_op + 16]
    PLN FC*64, FC*40
    add rsi, [rel xav_op + 24]
    add rdi, [rel xav_op + 40]
    mov ecx, [rel xav_op + 4]
.b:
    PKR rsi, rdi, 2*FC
    PKT rsi, rdi
    add rsi, W/2
    add rdi, rdx
    dec ecx
    jnz .b
    PLN FC*64, FC*40
    add rsi, [rel xav_op + 32]
    add rdi, [rel xav_op + 48]
    mov ecx, [rel xav_op + 4]
    dec ecx
.r:
    PKR rsi, rdi, 2*FC
    PKT rsi, rdi
    add rsi, W/2
    add rdi, rdx
    dec ecx
    jnz .r
    lea r8, [rdi - FC*40]
    sub rsp, FC*40 + 64
    lea rdi, [rsp + FC*40]
    PKR rsi, rdi, 2*FC
    PKT rsi, rdi
    mov rsi, rsp
    mov rdi, r8
    mov rcx, rdx
    rep movsb
    add rsp, FC*40 + 64
    vzeroupper
    ret
