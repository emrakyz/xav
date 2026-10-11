%assign m 11
%rep 110
%assign f 0
%rep 4
extern xav_fl %+ m %+ _ %+ f %+ 0
extern xav_fl %+ m %+ _ %+ f %+ 1
extern xav_fl %+ m %+ _ %+ f %+ 2
%assign f f + 1
%endrep
extern xav_oc %+ m
extern xav_o3 %+ m
extern xav_o4 %+ m
%assign m m + 1
%endrep
extern xav_op

global xav_flt
global xav_kpm
global xav_kev
global xav_kmu
global xav_kmk
global xav_kw4
global xav_o2

section .rodata align=64

xav_kpm: db 0, 1, 2, 3, 4, 8, 9, 10, 11, 12, 16, 17, 18, 19, 20, 24
         db 25, 26, 27, 28, 32, 33, 34, 35, 36, 40, 41, 42, 43, 44, 48, 49
         db 50, 51, 52, 56, 57, 58, 59, 60
         times 24 db 0x80
xav_kev:
%assign i 0
%rep 32
         db 2*i
%assign i i + 1
%endrep
%assign i 0
%rep 32
         db 2*i + 1
%assign i i + 1
%endrep
xav_kmk: dq 0xfffff
xav_kmu: dd 0x04000001
xav_kw4: dw 4
align 8
xav_flt:
%assign m 11
%rep 110
%assign f 0
%rep 4
         dq xav_fl %+ m %+ _ %+ f %+ 0
         dq xav_fl %+ m %+ _ %+ f %+ 1
         dq xav_fl %+ m %+ _ %+ f %+ 2
%assign f f + 1
%endrep
         dq xav_oc %+ m
         dq xav_o3 %+ m
         dq xav_o4 %+ m
%assign m m + 1
%endrep

section .text align=64

xav_o2:
    vpbroadcastd zmm28, [rel xav_kmu]
    vpbroadcastq zmm29, [rel xav_kmk]
    vmovdqu64 zmm30, [rel xav_kpm]
    kmovq k5, [rel xav_op + 88]
    mov rsi, r15
    mov rdi, r13
    mov ecx, [rel xav_op + 96]
.l:
%assign c 0
%rep 6
    vpmaddwd zmm0, zmm28, [rsi + c*64]
    vpsrlq zmm1, zmm0, 12
    vpternlogq zmm0, zmm1, zmm29, 0xe4
    vpermb zmm0, zmm30, zmm0
    vmovdqu8 [rdi + c*40]{k5}, zmm0
%assign c c + 1
%endrep
    add rsi, 384
    add rdi, 240
    dec ecx
    jnz .l
    ret
