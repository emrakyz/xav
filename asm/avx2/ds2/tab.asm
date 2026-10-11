%assign m 11
%rep 110
%assign f 0
%rep 4
%assign v 0
%rep 5
extern xav_fl %+ m %+ _ %+ f %+ v
%assign v v + 1
%endrep
%assign f f + 1
%endrep
extern xav_oc %+ m
extern xav_o3 %+ m
extern xav_o4 %+ m
%assign m m + 1
%endrep
extern xav_op

global xav_flt
global xav_kpk
global xav_ksh
global xav_khw
global xav_kmu
global xav_kmk
global xav_kc7
global xav_kw4
global xav_o2

section .rodata align=64

xav_kpk: db 0, 1, 2, 3, 4, 8, 9, 10, 11, 12, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
xav_ksh: db 0, 1, 4, 5, 8, 9, 12, 13, 2, 3, 6, 7, 10, 11, 14, 15
xav_khw: db 2, 3, 2, 3, 6, 7, 6, 7, 10, 11, 10, 11, 14, 15, 14, 15
xav_kmk: dq 0xfffff
xav_kmu: dd 0x04000001
xav_kc7: dd 7
xav_kw4: dw 4
align 8
xav_flt:
%assign m 11
%rep 110
%assign f 0
%rep 4
%assign v 0
%rep 5
         dq xav_fl %+ m %+ _ %+ f %+ v
%assign v v + 1
%endrep
%assign f f + 1
%endrep
         dq xav_oc %+ m
         dq xav_o3 %+ m
         dq xav_o4 %+ m
%assign m m + 1
%endrep

section .text align=64

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

xav_o2:
    vpbroadcastd ymm13, [rel xav_kmu]
    vpbroadcastq ymm14, [rel xav_kmk]
    vbroadcasti128 ymm15, [rel xav_kpk]
    mov rsi, r15
    mov rdi, r13
    mov ecx, [rel xav_op + 96]
    dec ecx
.l:
%assign c 0
%rep 6
    PK [rsi + c*32], rdi + c*20
%assign c c + 1
%endrep
    add rsi, 192
    add rdi, 120
    dec ecx
    jnz .l
    mov rdx, rdi
    sub rsp, 136
    mov rdi, rsp
%assign c 0
%rep 6
    PK [rsi + c*32], rdi + c*20
%assign c c + 1
%endrep
    mov rsi, rsp
    mov rdi, rdx
    mov ecx, 120
    rep movsb
    add rsp, 136
    vzeroupper
    ret
