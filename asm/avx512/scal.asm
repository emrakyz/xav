W   equ 64*M
CST equ W + 64
CB0 equ 72*W*M + 64
CB  equ CB0 + 65536*((2*W*4320 + 64 - CB0 + 65535)/65536)
CPL equ (18*M + 4)*CST
CRD equ CPL + 65536*((2164*CST - CPL + 65535)/65536)
FC  equ (M - 1)/2
NC  equ M/2

extern xav_fp
extern xav_op
extern xav_kw4
extern xav_kev
extern xav_kmu
extern xav_kmk
extern xav_kpm

section .text align=64

%macro YL 2
%if F == 1
    vmovdqu64 %1, %2
%elif F == 3
    vpsrlw %1, %2, 6
%else
    vpmovzxbw %1, %2
    vpsllw %1, %1, 2
%endif
%endmacro

%macro YM 3
%if F == 1
    vmovdqu16 %1{%3}{z}, %2
%elif F == 3
    vpsrlw %1{%3}{z}, %2, 6
%else
    vpmovzxbw %1{%3}{z}, %2
    vpsllw %1, %1, 2
%endif
%endmacro

%macro YCOL 1
%if V == 2
    YL zmm0, [r8 + rax*YS + (%1)*32*YS]
    vmovdqu64 [rdx + rax*4 + (NB + (%1))*128], zmm0
    YL zmm0, [r8 + rax*YS + (%1)*32*YS + 16*YS]
    vmovdqu64 [rdx + rax*4 + (NB + (%1))*128 + 64], zmm0
%else
%if F == 1
    vmovdqu64 zmm0, [r8 + rax*4 + (%1)*128]
    vmovdqu64 zmm1, [r8 + rax*4 + (%1)*128 + 64]
%elif F == 3
    vpsrlw zmm0, [r8 + rax*4 + (%1)*128], 6
    vpsrlw zmm1, [r8 + rax*4 + (%1)*128 + 64], 6
%else
    vpmovzxbw zmm0, [r8 + rax*2 + (%1)*64]
    vpmovzxbw zmm1, [r8 + rax*2 + (%1)*64 + 32]
    vpsllw zmm0, zmm0, 2
    vpsllw zmm1, zmm1, 2
%endif
    vmovdqu64 [rdx + rax*4 + (NB + (%1))*128], zmm0
    vmovdqu64 [rdx + rax*4 + (NB + (%1))*128 + 64], zmm1
%endif
%endmacro

%macro YBND 0
%if V == 0
    YM zmm0, [r8], k1
    vpermw zmm1, zmm29, zmm0
    vpermw zmm0, zmm30, zmm0
    vmovdqu64 [rdx + NB*128], zmm1
    vmovdqu64 [rdx + NB*128 + 64], zmm0
%else
    YL zmm0, [r8]
    YM zmm1, [r8 + 16*YS], k1
    vpermw zmm1, zmm29, zmm1
    vmovdqu64 [rdx + NB*128], zmm0
    vmovdqu64 [rdx + NB*128 + 64], zmm1
%endif
%endmacro

%macro PCOL 3
%if F == 1
    vmovdqu64 zmm4, [%1 + rax*2 + (%3)*64]
%else
    vpmovzxbw zmm4, [%1 + rax + (%3)*32]
    vpsllw zmm4, zmm4, 2
%endif
    vmovdqu64 [%2 + rax*2 + (%3)*64], zmm4
%endmacro

%macro PBND 2
    YM zmm4, [%1], k2
    vpermw zmm4, zmm31, zmm4
    vmovdqu64 [%2], zmm4
%endmacro

%macro PLANE 3
%%r:
    mov rax, -(NB - RR)*32
%assign c 0
%rep RR
    PCOL %1, %2, c - RR
%assign c c + 1
%endrep
%%c:
    PCOL %1, %2, 0
    PCOL %1, %2, 1
    PCOL %1, %2, 2
    PCOL %1, %2, 3
    sub rax, -128
    jnz %%c
%if V < 2
    PBND %1, %2
%endif
    add %1, r11
    add %2, CST
    dec %3
    jnz %%r
%endmacro

%macro UCOL 1
%if F == 2
    vmovdqu64 zmm6, [r9 + rax*2 + (%1)*64]
    vpmaddubsw zmm4, zmm6, zmm28
    vpmaddubsw zmm5, zmm6, zmm27
%else
    vpsrlw zmm4, [r9 + rax*4 + (%1)*128], 6
    vpsrlw zmm6, [r9 + rax*4 + (%1)*128 + 64], 6
    vmovdqa64 zmm5, zmm4
    vpermt2w zmm4, zmm26, zmm6
    vpermt2w zmm5, zmm25, zmm6
%endif
    vmovdqu64 [rdi + rax*2 + (%1)*64], zmm4
    vmovdqu64 [rdi + rax*2 + (%1)*64 + CRD], zmm5
%endmacro

%macro UBND 0
%if F == 2
    vmovdqu16 zmm6{k2}{z}, [r9]
    vpermw zmm6, zmm31, zmm6
    vpmaddubsw zmm4, zmm6, zmm28
    vpmaddubsw zmm5, zmm6, zmm27
%elif V == 0
    vpsrlw zmm6{k2}{z}, [r9], 6
    vpermw zmm4, zmm24, zmm6
    vpermw zmm5, zmm23, zmm6
%else
    vpsrlw zmm4, [r9], 6
    vpsrlw zmm6{k3}{z}, [r9 + 64], 6
    vmovdqa64 zmm5, zmm4
    vpermt2w zmm4, zmm24, zmm6
    vpermt2w zmm5, zmm23, zmm6
%endif
    vmovdqu64 [rdi], zmm4
    vmovdqu64 [rdi + CRD], zmm5
%endmacro

%macro FCON 0
%if V < 2
    kmovd k1, [rel xav_fp + 36]
    vpmovzxbw zmm29, [rel xav_fp + 64]
%if V == 0
    vpbroadcastw zmm30, [rel xav_fp + 48]
%endif
%if F == 3
%if V == 0
    kmovd k2, [rel xav_fp + 40]
%else
    kmovd k3, [rel xav_fp + 44]
%endif
    vpmovzxbw zmm24, [rel xav_fp + 96]
    vpmovzxbw zmm23, [rel xav_fp + 128]
%else
    kmovd k2, [rel xav_fp + 40]
    vpmovzxbw zmm31, [rel xav_fp + 96]
%endif
%endif
%if F == 2
    vpbroadcastw zmm28, [rel xav_kw4]
    vpsllw zmm27, zmm28, 8
%elif F == 3
    vpmovzxbw zmm26, [rel xav_kev]
    vpmovzxbw zmm25, [rel xav_kev + 32]
%endif
%endmacro

%macro FPAR 2
%assign F %1
%assign V %2
%if V == 2
%assign NB M
%assign RY M % 2
%else
%assign NB M - 1
%endif
%assign RR NB % 4
%if F == 1 || F == 3
%assign YS 4
%else
%assign YS 2
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
    mov ecx, [rel xav_fp + 52]
    lea rdi, [rdx + CB + NB*64]
%if F < 2
    lea rsi, [rdx + CB + CRD + NB*64]
%endif
    FCON
.y:
%if V == 2
    mov rax, -(NB - RY)*32
%if RY
    YCOL -1
%endif
.v:
    YCOL 0
    YCOL 1
    add rax, 64
%else
    mov rax, -(NB - RR)*32
%assign c 0
%rep RR
    YCOL c - RR
%assign c c + 1
%endrep
.v:
    YCOL 0
    YCOL 1
    YCOL 2
    YCOL 3
    sub rax, -128
%endif
    jnz .v
%if V < 2
    YBND
%endif
    add r8, r11
    add rdx, 2*W
    dec ecx
    jnz .y
    mov r11, [rel xav_fp + 24]
    mov ecx, [rel xav_fp + 32]
%if F < 2
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
%assign c 0
%rep RR
    UCOL c - RR
%assign c c + 1
%endrep
.w:
    UCOL 0
    UCOL 1
    UCOL 2
    UCOL 3
    sub rax, -128
    jnz .w
%if V < 2
    UBND
%endif
    add r9, r11
    add rdi, CST
    dec ecx
    jnz .u
%endif
    ret
%endmacro

%assign F 0
%rep 4
%assign V 0
%rep 3
    FILL F, V
%assign V V + 1
%endrep
%assign F F + 1
%endrep

%macro PK 3
    vpmaddwd zmm0, zmm28, %1
    vpsrlq zmm1, zmm0, 12
    vpternlogq zmm0, zmm1, zmm29, 0xe4
    vpermb zmm0, zmm30, zmm0
    vmovdqu8 %2{%3}, zmm0
%endmacro

%macro PKT 4
    vmovdqu8 zmm0{%2}{z}, %1
    vpmaddwd zmm0, zmm28, zmm0
    vpsrlq zmm1, zmm0, 12
    vpternlogq zmm0, zmm1, zmm29, 0xe4
    vpermb zmm0, zmm30, zmm0
    vmovdqu8 %3{%4}, zmm0
%endmacro

%macro PKR 5
%assign NN (%5)
%assign RR NN % 4
    mov rax, -(NN - RR)*16
    mov r11, -(NN - RR)*5
%assign c 0
%rep RR
    PK [%1 + rax*4 + (c - RR)*64], [%2 + r11*8 + (c - RR)*40], k5
%ifnidn %3, 0
    PK [%3 + rax*4 + (c - RR)*64], [%4 + r11*8 + (c - RR)*40], k5
%endif
%assign c c + 1
%endrep
%%l:
%assign c 0
%rep 4
    PK [%1 + rax*4 + c*64], [%2 + r11*8 + c*40], k5
%ifnidn %3, 0
    PK [%3 + rax*4 + c*64], [%4 + r11*8 + c*40], k5
%endif
%assign c c + 1
%endrep
    add r11, 20
    add rax, 64
    jnz %%l
%endmacro

%macro CPR 5
%assign NN (%5)
%assign RR NN % 4
    mov rax, -(NN - RR)*16
%assign c 0
%rep RR
    vmovdqu64 zmm0, [%1 + rax*4 + (c - RR)*64]
    vmovdqu64 [%2 + rax*4 + (c - RR)*64], zmm0
%ifnidn %3, 0
    vmovdqu64 zmm1, [%3 + rax*4 + (c - RR)*64]
    vmovdqu64 [%4 + rax*4 + (c - RR)*64], zmm1
%endif
%assign c c + 1
%endrep
%%l:
%assign c 0
%rep 4
    vmovdqu64 zmm0, [%1 + rax*4 + c*64]
    vmovdqu64 [%2 + rax*4 + c*64], zmm0
%ifnidn %3, 0
    vmovdqu64 zmm1, [%3 + rax*4 + c*64]
    vmovdqu64 [%4 + rax*4 + c*64], zmm1
%endif
%assign c c + 1
%endrep
    add rax, 64
    jnz %%l
%endmacro

%macro PKC 0
    vpbroadcastd zmm28, [rel xav_kmu]
    vpbroadcastq zmm29, [rel xav_kmk]
    vmovdqu64 zmm30, [rel xav_kpm]
    kmovq k5, [rel xav_op + 88]
%endmacro

%macro CPTR 2
    lea rsi, [r15 + %1]
    lea r8, [r15 + %1]
    lea rdi, [r13 + %2]
    lea r9, [r13 + %2]
    add rsi, [rel xav_op + 24]
    add r8, [rel xav_op + 32]
    add rdi, [rel xav_op + 40]
    add r9, [rel xav_op + 48]
    mov ecx, [rel xav_op + 4]
%endmacro

align 64
global xav_oc %+ M
xav_oc %+ M:
    lea rsi, [r15 + (M - 1)*64]
    lea rdi, [r13 + (M - 1)*64]
    mov ecx, [rel xav_op]
    mov rdx, [rel xav_op + 8]
    kmovq k1, [rel xav_op + 56]
.y:
    CPR rsi, rdi, 0, 0, M - 1
    vmovdqu64 zmm0, [rsi]
    vmovdqu8 [rdi]{k1}, zmm0
    add rsi, W
    add rdi, rdx
    dec ecx
    jnz .y
    CPTR FC*64, FC*64
    mov rdx, [rel xav_op + 16]
    kmovq k2, [rel xav_op + 64]
.c:
    CPR rsi, rdi, r8, r9, FC
    vmovdqu64 zmm0, [rsi]
    vmovdqu64 zmm1, [r8]
    vmovdqu8 [rdi]{k2}, zmm0
    vmovdqu8 [r9]{k2}, zmm1
    add rsi, W/2
    add r8, W/2
    add rdi, rdx
    add r9, rdx
    dec ecx
    jnz .c
    ret

align 64
global xav_o3 %+ M
xav_o3 %+ M:
    PKC
    lea rsi, [r15 + M*64]
    lea rdi, [r13 + M*40]
    mov ecx, [rel xav_op]
.y:
    PKR rsi, rdi, 0, 0, M
    add rsi, M*64
    add rdi, M*40
    dec ecx
    jnz .y
    CPTR NC*64, NC*40
%if M % 2
    kmovq k4, [rel xav_op + 80]
%endif
.c:
    PKR rsi, rdi, r8, r9, NC
%if M % 2
    PK [rsi], [rdi], k4
    PK [r8], [r9], k4
%endif
    add rsi, M*32
    add r8, M*32
    add rdi, M*20
    add r9, M*20
    dec ecx
    jnz .c
    ret

align 64
global xav_o4 %+ M
xav_o4 %+ M:
    PKC
    kmovq k1, [rel xav_op + 56]
    kmovq k3, [rel xav_op + 72]
    lea rsi, [r15 + (M - 1)*64]
    lea rdi, [r13 + (M - 1)*40]
    mov ecx, [rel xav_op]
    mov rdx, [rel xav_op + 8]
.y:
    PKR rsi, rdi, 0, 0, M - 1
    PKT [rsi], k1, [rdi], k3
    add rsi, W
    add rdi, rdx
    dec ecx
    jnz .y
    CPTR FC*64, FC*40
    kmovq k2, [rel xav_op + 64]
    kmovq k4, [rel xav_op + 80]
    mov rdx, [rel xav_op + 16]
.c:
    PKR rsi, rdi, r8, r9, FC
    PKT [rsi], k2, [rdi], k4
    PKT [r8], k2, [r9], k4
    add rsi, W/2
    add r8, W/2
    add rdi, rdx
    add r9, rdx
    dec ecx
    jnz .c
    ret
