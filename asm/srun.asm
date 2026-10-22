%define CAP    128
%define TAIL   (CAP*12)
%define RSZ    1600

%define D_CSZ  80

%define C_DEC  0
%define C_RING 8
%define C_TAB  16
%define C_BUF  24
%define C_PB   32
%define C_PN   40

%define E_CH   0
%define E_CNT  8
%define E_N    16
%define E_PKG  24
%define E_SZ   32

%define J_SLOT 0
%define J_DST  8
%define J_FILL 16
%define J_FSZ  24
%define J_ENT  32

%define V_FRM  24
%define V_SW   32
%define V_EOF  64

%define P_HDR  4090

%if PC == 384
%define ST     3
%define RO     7360
%define LS     3264
%define LQ     7208
%define GN     xav_g5i
%define GP     xav_gpi
%define GR     512
%else
%define ST     5
%define RO     10432
%define LS     6336
%define LQ     9888
%define GN     xav_g2i
%define GP     xav_gqi
%define GR     1024
%endif

extern xav_ds2
extern xav_rol
extern xav_rof
extern xav_ro8
extern xav_pq2
extern xav_pql
extern xav_pqf
extern xav_flt
extern xav_o2
extern xav_dec_next
extern xav_dec_next_hw
extern xav_spmc_send
extern xav_spmc_recv
extern xav_spmc_close
extern xav_mpsc_send
extern xav_mpsc_recv
extern xav_mpmc_send
extern xav_ds2k
%ifdef VSHIP
extern xav_ds2kq
%endif
extern xav_ds2c
extern xav_ds2g
extern xav_ds2s
extern pthread_create
extern pthread_join
extern __xav_txl
extern xav_pack_10b_rem
extern GN
extern GP

global xav_dp
global xav_ro
global xav_fp
global xav_op
global xav_ds2f
global xav_rs
global xav_ds2i
global xav_ds2w
global xav_ds2r
%ifdef VSHIP
global xav_ds2q
%endif
global xav_gr
global xav_gwo
global xav_amap
global xav_sarg
global xav_sgk
global xav_dsxi
global xav_dsgw
global xav_dsgr
%ifdef VSHIP
global xav_dsgq
%endif

SECTION .txa align=2097152

txa:

SECTION .bss align=4096

xav_dp:  resb 128
xav_ro:  resb RO
xav_fp:  resb 192
xav_op:  resb 128
sj:      resb RSZ
sf:      resb RSZ
rec:     resb 64*(ST + 2)
fill:    resq 1
fsz:     resq 1
pfrm:    resq 3
tid:     resq ST
pring:   resq 1
cbuf:    resq 1
ppb:     resq 1
ppn:     resq 1
kern:    resq 1
ost:     resq 1
osz:     resq 1
ssz:     resq 1
ssiz:    resq 1
pbuf:    resq 1
psz:     resq 1
plen:    resq 1
yp:      resq 1
gm:      resq 1
gwc:     resq 1
ghc:     resq 1
sci:     resq 1
dli:     resq 1
xav_ds2f: resb 1
xav_rs:  resb 1

SECTION .rodata align=64

%if PC == 384
rfree: dd 1, 2, 3, 4, 5, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
rrec:  dq rec, rec + 64, rec + 128, rec + 192, rec + 256
%else
rrec:  dq rec, rec + 64, rec + 128, rec + 192, rec + 256, rec + 320, rec + 384
align 32
rfree: dd 1, 2, 3, 4, 5, 6, 7, 7
%endif
ws:    dq w0, w1, w2, w3, w4
tn:    dq s0n, sxn, d0n, d1n, d2n
%ifdef VSHIP
tq:    dq s0q, sxq, d0q, d1q, d2q
%endif
align 32
kio:   db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
       db 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
%if PC == 384
align 64
riota: dd 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
%else
kid:   dd 0, 1, 2, 3, 4, 5, 6, 7
kii:   db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
       db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
kih:   db 2, 3, 2, 3, 6, 7, 6, 7, 10, 11, 10, 11, 14, 15, 14, 15
       db 2, 3, 2, 3, 6, 7, 6, 7, 10, 11, 10, 11, 14, 15, 14, 15
riota: dd 0, 1, 2, 3, 4, 5, 6, 7, 8
%endif

SECTION .rofr progbits alloc noexec nowrite align=16

rimg:  dq xav_ds2 - 88
       dd xav_rol, LS
       dq xav_pq2 - 88
       dd xav_pql, LQ
       dq xav_ds2 - 88
       dd xav_rof, LS
       dq xav_pq2 - 88
       dd xav_pqf, LQ
       dq xav_ds2 - 88
       dd xav_ro8, LS

SECTION .text align=64

%macro IDX2 4
    vmovd        xmm0, %4
    vpbroadcastb xmm1, xmm0
    vpminub      xmm1, xmm1, [rel kio]
    vmovd        xmm2, %3
    vpbroadcastb xmm2, xmm2
    vpaddb       xmm1, xmm1, xmm2
    vmovq        [rel xav_fp + %1], xmm1
    vpbroadcastd ymm0, xmm0
    vmovdqu      ymm2, [rel kid]
    vpcmpgtd     ymm2, ymm2, ymm0
    vmovdqu      ymm1, [rel kii]
    vpblendvb    ymm1, ymm1, [rel kih], ymm2
    vmovdqu      [rel xav_fp + %2], ymm1
%endmacro

%macro IDX 2
    vmovd        xmm0, %2
    vpbroadcastb ymm0, xmm0
    vpminub      ymm0, ymm0, [rel kio]
%ifidn %1, 2
    vpaddb       ymm0, ymm0, ymm0
    vpcmpeqb     ymm1, ymm1, ymm1
    vpsubb       ymm1, ymm0, ymm1
    vmovdqu      [rel xav_fp + 96], ymm0
    vmovdqu      [rel xav_fp + 128], ymm1
%else
    vmovdqu      [rel xav_fp + %1], ymm0
%endif
%endmacro

%macro SINP 0
    push         rbx
    push         rbp
    push         r12
    mov          r10d, r8d
    and          r10d, 1
    mov          r12d, r8d
    and          r12d, 3
    mov          [rel xav_ds2f], r12b
    mov          r11d, r8d
    shr          r11d, 1
    and          r11d, 3
    add          r11d, 2
    mov          [rel dli], r11
    test         r8b, 4
    jz           .a
    mov          r9d, edi
    shlx         r9, r9, r10
    mov          eax, edi
    shr          eax, 1
    shlx         eax, eax, r10d
    jmp          .b
.a:
    mov          rax, [rsp + 32]
.b:
    mov          [rel xav_fp + 16], r9
    mov          [rel xav_fp + 24], rax
    mov          r11d, esi
    imul         r11, r9
    mov          [rel yp], r11
    mov          r11d, edx
    shr          r11d, 1
    imul         r11, rax
    mov          eax, ecx
    test         r8b, 2
    jnz          .c
    shr          eax, 1
.c:
    shlx         eax, eax, r10d
    add          r11, rax
    mov          eax, edx
    imul         rax, r9
    shlx         ebx, ecx, r10d
    add          rax, rbx
    lea          ebx, [rcx + rcx]
    sub          edi, ebx
    lea          ebx, [rdx + rdx]
    sub          esi, ebx
    mov          [rel gwc], rdi
    mov          [rel ghc], rsi
    mov          ebx, esi
    shr          ebx, 1
    mov          [rel xav_fp + 32], ebx
%if PC == 384
    mov          [rel xav_fp + 52], esi
%else
    mov          [rel xav_fp + 36], esi
%endif
    lea          ecx, [rdi + 63]
    shr          ecx, 6
    mov          [rel gm], rcx
    mov          edx, ecx
    shl          edx, 6
    lea          ebp, [rdi + 64]
    sub          ebp, edx
    mov          ebx, ecx
    cmp          ebp, 64
    je           .n
    dec          ebx
.n:
    shl          ebx, 5
    lea          r9, [rbx + rbx]
    shlx         r9, r9, r10
    add          rax, r9
    mov          [rel xav_fp], rax
    mov          eax, r8d
    shr          eax, 1
    and          eax, 1
    add          eax, r10d
    shlx         rbx, rbx, rax
    add          r11, rbx
    mov          [rel xav_fp + 8], r11
%if PC == 384
    lea          eax, [rcx - 11]
    imul         eax, eax, 15
    lea          eax, [rax + r12*2]
    add          eax, r12d
    cmp          ebp, 64
    je           .v2
    cmp          ebp, 32
    ja           .v1
    mov          ebx, -1
    bzhi         ebx, ebx, ebp
    mov          [rel xav_fp + 36], ebx
    lea          ebx, [rbp - 1]
    mov          [rel xav_fp + 48], bx
    IDX          64, ebx
    jmp          .h
.v1:
    inc          eax
    lea          r9d, [rbp - 32]
    mov          ebx, -1
    bzhi         ebx, ebx, r9d
    mov          [rel xav_fp + 36], ebx
    dec          r9d
    IDX          64, r9d
.h:
    shr          ebp, 1
    cmp          r12d, 3
    je           .w
    mov          ebx, -1
    bzhi         ebx, ebx, ebp
    mov          [rel xav_fp + 40], ebx
    dec          ebp
    IDX          96, ebp
    jmp          .f
.w:
    lea          r9d, [rbp + rbp]
    mov          ebx, -1
    bzhi         ebx, ebx, r9d
    mov          [rel xav_fp + 40], ebx
    sub          r9d, 32
    mov          ebx, -1
    bzhi         ebx, ebx, r9d
    mov          [rel xav_fp + 44], ebx
    dec          ebp
    IDX          2, ebp
    jmp          .f
.v2:
    add          eax, 2
%else
    lea          eax, [rcx - 11]
    imul         eax, eax, 23
    lea          r9d, [r12 + r12*4]
    add          eax, r9d
    cmp          ebp, 64
    je           .v4
    lea          r9d, [rbp - 1]
    shr          r9d, 4
    add          eax, r9d
    shl          r9d, 4
    mov          r10d, ebp
    sub          r10d, r9d
    lea          r11d, [r10*4]
    test         r12b, 1
    jnz          .m
    shr          r11d, 1
.m:
    mov          r8, -1
    bzhi         r8, r8, r11
    mov          [rel xav_fp + 48], r8
    lea          r11d, [r10 - 2]
    shr          r11d, 1
    xor          r9d, r9d
    IDX2         80, 96, r9d, r11d
    shr          ebp, 1
    mov          r10d, ebp
    cmp          ebp, 16
    jbe          .c0
    sub          r10d, 16
.c0:
    lea          r11d, [r10 - 2]
    shr          r11d, 1
    xor          r9d, r9d
    cmp          r12d, 3
    je           .w
    test         r12d, r12d
    jnz          .k
    lea          r8d, [rbp - 16]
    movsxd       r8, r8d
    mov          [rel xav_fp + 40], r8
    mov          r9d, 16
    sub          r9d, r10d
    shr          r9d, 1
    jmp          .i
.k:
    lea          r8d, [r10*4]
    mov          rbx, -1
    bzhi         rbx, rbx, r8
    mov          [rel xav_fp + 56], rbx
    jmp          .i
.w:
    mov          r8d, 8
    cmp          r10d, 8
    cmovb        r8d, r10d
    shl          r8d, 3
    mov          rbx, -1
    bzhi         rbx, rbx, r8
    mov          [rel xav_fp + 64], rbx
    xor          r8d, r8d
    lea          ebx, [r10 - 8]
    test         ebx, ebx
    cmovg        r8d, ebx
    shl          r8d, 3
    mov          rbx, -1
    bzhi         rbx, rbx, r8
    mov          [rel xav_fp + 72], rbx
.i:
    IDX2         88, 128, r9d, r11d
    jmp          .f
.v4:
    add          eax, 4
%endif
.f:
    mov          rax, [xav_flt + rax*8]
    mov          [rel fill], rax
    lea          r9, [rdx + 64]
    mov          rax, rdx
    imul         rax, rcx
    imul         rax, rax, 72
    add          rax, 64
    imul         r11, rdx, 8640
    add          r11, 64 + 0xffff
    sub          r11, rax
    and          r11, -0x10000
    add          rax, r11
    imul         r11, rcx, 18
    add          r11, 4
    imul         r11, r9
    imul         r8, r9, 2164
    add          r8, 0xffff
    sub          r8, r11
    and          r8, -0x10000
    add          r8, r11
    add          r8, rax
    mov          r11d, esi
    shr          r11d, 1
    mov          r10, r11
    imul         r10, r9
%endmacro

xav_ds2i:
    SINP
    add          rax, rdx
    add          rax, r10
    mov          [rel xav_dp + 8], rax
    lea          rax, [r8 + r10]
    lea          rax, [rax + r9*4]
    mov          [rel ssz], rax
    mov          rax, r11
    imul         rax, rdx
    mov          [rel xav_dp + 16], rax
    mov          eax, esi
    shr          eax, 2
    imul         rax, rdx
    lea          r10d, [r11 - 1]
    shl          r10, 32
    or           r10, rax
    mov          [rel xav_dp], r10
    shr          rax, 1
    mov          [rel xav_dp + D_CSZ], rax
    mov          eax, edx
    shr          edi, 1
    shl          r11, 32
    lea          rdx, [rdi + r11]
    vzeroupper
    jmp          rocp

SECTION .text.xav_ds2i progbits alloc exec nowrite align=1

rocp:
    movzx        esi, byte [rel xav_rs]
    mov          r8, [rsi + rimg]
    mov          r8, [r8 + rcx*8]
    mov          [rel kern], r8
    mov          ecx, [rsi + rimg + 12]
    mov          esi, [rsi + rimg + 8]
    mov          edi, xav_ro
    rep          movsb
    pop          r12
    pop          rbp
    pop          rbx
    ret

SECTION .text

xav_ds2w:
    mov          rcx, [rel gm]
    mov          r8d, ecx
    shl          r8d, 6
    mov          eax, [rel gwc]
    shr          eax, 1
    mov          edx, [rel ghc]
    shr          edx, 1
    mov          r9d, edx
    shr          r9d, 1
    mov          [rel xav_op], edx
    mov          [rel xav_op + 4], r9d
    mov          r10, rdx
    imul         r10, r8
    mov          [rel xav_op + 24], r10
    mov          r11, r9
    imul         r11, r8
    shr          r11, 1
    lea          rsi, [r10 + r11*2 + 64]
    mov          [rel osz], rsi
    add          r11, r10
    mov          [rel xav_op + 32], r11
    mov          qword [rel sci], 1
    lea          esi, [rcx - 11]
%if PC == 384
    imul         esi, esi, 15
%define OI 96
%else
    imul         esi, esi, 23
%define OI 160
%endif
    jmp          [ws + rdi*8]
w0:
    mov          qword [rel sci], 0
w1x:
    imul         rax, rdx
    lea          rax, [rax + rax*2]
    mov          [rel fsz], rax
    ret
w1:
    mov          rsi, [xav_flt + rsi*8 + OI]
    mov          [rel ost], rsi
    lea          r10, [rax + rax]
    mov          [rel xav_op + 8], r10
    mov          [rel xav_op + 16], rax
    imul         r10, rdx
    mov          [rel xav_op + 40], r10
    mov          r11, r9
    imul         r11, rax
    add          r11, r10
    mov          [rel xav_op + 48], r11
    lea          r10d, [rcx - 1]
    shl          r10d, 6
    lea          r11d, [rax + rax]
    sub          r11d, r10d
%if PC == 384
    mov          r10, -1
    bzhi         r10, r10, r11
%else
    lea          r10, [r11 - 64]
%endif
    mov          [rel xav_op + 56], r10
    lea          r10d, [rcx - 1]
    shr          r10d, 1
    shl          r10d, 6
    mov          r11d, eax
    sub          r11d, r10d
%if PC == 384
    mov          r10, -1
    bzhi         r10, r10, r11
%else
    lea          r10, [r11 - 64]
%endif
    mov          [rel xav_op + 64], r10
    jmp          w1x
%if PC != 384
%macro TM 2
    vmovd        xmm0, %2
    vpbroadcastb xmm0, xmm0
    vpcmpgtb     xmm1, xmm0, [rel kio]
    vpcmpgtb     xmm2, xmm0, [rel kio + 16]
    vmovdqu      [rel xav_op + %1], xmm1
    vmovdqu      [rel xav_op + %1 + 16], xmm2
%endmacro
%endif
%macro PRS 2
    lea          %1, [%2 + 3]
    shr          %1, 2
    lea          %1, [%1 + %1*4]
%endmacro
wpk:
%if PC == 384
    mov          r10, 0xffffffffff
    mov          [rel xav_op + 88], r10
%endif
    PRS          r10d, eax
    mov          r11d, eax
    shr          r11d, 1
    PRS          r11d, r11d
    mov          rsi, r10
    imul         rsi, rdx
    mov          [rel xav_op + 40], rsi
    mov          rdi, r11
    imul         rdi, r9
    add          rdi, rsi
    mov          [rel xav_op + 48], rdi
    lea          rsi, [r10 + r11]
    imul         rsi, rdx
    mov          [rel fsz], rsi
    ret
w2:
    mov          esi, xav_o2
    mov          [rel ost], rsi
    mov          esi, eax
    imul         esi, edx
%if PC == 384
    shr          esi, 7
%else
    shr          esi, 6
%endif
    mov          [rel xav_op + 96], esi
    call         wpk
    mov          rax, [rel fsz]
    ret
w3:
    mov          rsi, [xav_flt + rsi*8 + OI + 8]
    mov          [rel ost], rsi
%if PC == 384
    mov          qword [rel xav_op + 80], 0xfffff
%endif
    call         wpk
    mov          rax, [rel fsz]
    ret
w4:
    mov          rsi, [xav_flt + rsi*8 + OI + 16]
    mov          [rel ost], rsi
    call         wpk
    mov          [rel xav_op + 8], r10
    mov          [rel xav_op + 16], r11
%if PC == 384
    lea          r10d, [rcx - 1]
    shl          r10d, 5
    mov          r11d, eax
    sub          r11d, r10d
    lea          r10d, [r11 + r11]
    mov          rsi, -1
    bzhi         rsi, rsi, r10
    mov          [rel xav_op + 56], rsi
    PRS          r10d, r11d
    mov          rsi, -1
    bzhi         rsi, rsi, r10
    mov          [rel xav_op + 72], rsi
    lea          r10d, [rcx - 1]
    shr          r10d, 1
    shl          r10d, 5
    mov          r11d, eax
    shr          r11d, 1
    sub          r11d, r10d
    lea          r10d, [r11 + r11]
    mov          rsi, -1
    bzhi         rsi, rsi, r10
    mov          [rel xav_op + 64], rsi
    PRS          r10d, r11d
    mov          rsi, -1
    bzhi         rsi, rsi, r10
    mov          [rel xav_op + 80], rsi
%else
    lea          r10d, [rcx - 1]
    shl          r10d, 5
    mov          r11d, eax
    sub          r11d, r10d
    TM           56, r11d
    lea          r10d, [rcx - 1]
    shr          r10d, 1
    shl          r10d, 5
    mov          r11d, eax
    shr          r11d, 1
    sub          r11d, r10d
    TM           88, r11d
%endif
    mov          rax, [rel fsz]
    ret

xav_amap:
amap:
    xor          edi, edi
    mov          edx, 3
    mov          r10d, 0x22
    or           r8, -1
    xor          r9d, r9d
    mov          eax, 9
    syscall
    mov          rdi, rax
    mov          edx, 14
    mov          eax, 28
    syscall
    mov          rax, rdi
    ret

%ifdef VSHIP
xav_ds2q:
    lea          rax, [rel tq]
    jmp          run
%endif
xav_ds2r:
    lea          rax, [rel tn]
run:
    push         rbx
    push         rbp
    push         r12
    push         r13
    push         r14
    push         r15
    sub          rsp, 8
    mov          r15, rax
    mov          rbx, rdi
    mov          qword [rsp], -1
    xor          edi, edi
    mov          rsi, rsp
    xor          edx, edx
    mov          r10d, 8
    mov          eax, 14
    syscall
    mov          edi, txa
    mov          esi, __xav_txl
    mov          edx, 25
    mov          eax, 28
    syscall
    mov          rax, [rbx + C_RING]
    mov          [rel pring], rax
    mov          rax, [rbx + C_BUF]
    mov          [rel cbuf], rax
    mov          rax, [rbx + C_PB]
    mov          [rel ppb], rax
    mov          rax, [rbx + C_PN]
    mov          [rel ppn], rax
    mov          r13, [rel ssz]
%if PC == 384
    lea          rsi, [r13 + r13*4 + 64]
%else
    imul         rsi, r13, 7
    add          rsi, 64
%endif
    mov          [rel ssiz], rsi
    call         amap
    vbroadcasti128 ymm2, [rel fill]
    vmovq        xmm0, rax
    vpblendd     ymm0, ymm2, ymm0, 3
    vmovq        xmm1, r13
%assign i 0
%rep ST + 2
    vmovdqu      [rel rec + i*64], ymm0
%if i < ST + 1
    vpaddq       ymm0, ymm0, ymm1
%endif
%assign i i + 1
%endrep
%if PC == 384
    vmovdqu32    zmm0, [rel riota]
    vpbroadcastd zmm1, [rel riota + 64]
    vmovdqu32    zmm2, [rel rfree]
    vmovdqu32    [rel sf], zmm2
%assign i 0
%rep 8
    vmovdqu32    [rel sj + i*64], zmm0
%if i
    vmovdqu32    [rel sf + i*64], zmm0
%endif
%if i < 7
    vpaddd       zmm0, zmm0, zmm1
%endif
%assign i i + 1
%endrep
    vmovdqu64    zmm0, [rel rrec]
    vmovdqu64    [rel sf + CAP*4], zmm0
%else
    vmovdqu      ymm0, [rel riota]
    vpbroadcastd ymm1, [rel riota + 32]
    vmovdqu      ymm2, [rel rfree]
    vmovdqu      [rel sf], ymm2
%assign i 0
%rep 16
    vmovdqu      [rel sj + i*32], ymm0
%if i
    vmovdqu      [rel sf + i*32], ymm0
%endif
%if i < 15
    vpaddd       ymm0, ymm0, ymm1
%endif
%assign i i + 1
%endrep
    vmovdqu      ymm0, [rel rrec]
    vmovdqu      [rel sf + CAP*4], ymm0
    vmovdqu      ymm0, [rel rrec + 32]
    vmovdqu      [rel sf + CAP*4 + 32], ymm0
%endif
    vzeroupper
    mov          dword [rel sf + TAIL], ST + 2
    mov          rax, [rel sci]
    mov          rbp, [r15 + rax*8]
%assign i 0
%rep ST
    mov          edi, tid + i*8
    xor          esi, esi
    mov          rdx, rbp
    xor          ecx, ecx
    call         pthread_create
%assign i i + 1
%endrep
    mov          rax, [rel dli]
    mov          r12, [rbx + C_DEC]
    mov          rbx, [rbx + C_TAB]
    jmp          [r15 + rax*8]

fcore:
    sub          rsp, 8
    mov          edi, sj
    call         xav_spmc_close
%assign i 0
%rep ST
    mov          rdi, [rel tid + i*8]
    xor          esi, esi
    call         pthread_join
%assign i i + 1
%endrep
    mov          rdi, [rel rec + J_SLOT]
    mov          rsi, [rel ssiz]
    mov          eax, 11
    syscall
    add          rsp, 8
    ret
fin:
    call         fcore
    jmp          epi
pcut:
    call         fcore
    mov          rdi, [rel cbuf]
    mov          rsi, [rbx + E_PKG]
    call         xav_ds2g
    jmp          pend
pfin:
    call         fcore
pend:
    mov          rdi, [rel pbuf]
    mov          rsi, [rel psz]
    mov          eax, 11
    syscall
epi:
    add          rsp, 8
    pop          r15
    pop          r14
    pop          r13
    pop          r12
    pop          rbp
    pop          rbx
    ret

prd0:
    mov          rsi, [rel ppb]
    mov          rcx, [rel ppn]
    mov          rdx, [rel plen]
    sub          rdx, rcx
    mov          rdi, r12
    rep movsb
    mov          rsi, rdi
    jmp          prdr
prd:
    mov          rsi, r12
    mov          rdx, [rel plen]
prdr:
    xor          edi, edi
.r:
    xor          eax, eax
    syscall
    test         rax, rax
    jle          .x
    add          rsi, rax
    sub          rdx, rax
    jnz          .r
.x:
    ret

%macro SC0 2
s0%2:
    push         rbx
    push         rbp
    push         r12
    push         r13
    sub          rsp, 8
    mov          rax, [rel xav_dp + D_CSZ]
    wrgsbase     rax
    mov          r12, [rel kern]
    mov          rbp, [rel pring]
%%l:
    mov          edi, sj
    call         xav_spmc_recv
    test         rax, rax
    jz           %%x
    mov          rbx, rax
    mov          rdi, [rax + J_SLOT]
    mov          rsi, [rax + J_DST]
    mov          r13, [rax + J_ENT]
    call         r12
    mov          edi, sf
    mov          rsi, rbx
    call         xav_mpsc_send
    lock dec     qword [r13 + E_CNT]
    jnz          %%l
    mov          rdi, rbp
    mov          rsi, [r13 + E_PKG]
    call         %1
    jmp          %%l
%%x:
    add          rsp, 8
    pop          r13
    pop          r12
    pop          rbp
    pop          rbx
    ret
%endmacro

%macro SCX 2
sx%2:
    push         rbx
    push         rbp
    push         r12
    push         r13
    push         r14
    push         r15
    sub          rsp, 8
    mov          rax, [rel xav_dp + D_CSZ]
    wrgsbase     rax
    mov          r12, [rel kern]
    mov          rbp, [rel ost]
    mov          rsi, [rel osz]
    call         amap
    mov          r15, rax
%%l:
    mov          edi, sj
    call         xav_spmc_recv
    test         rax, rax
    jz           %%x
    mov          rbx, rax
    mov          rdi, [rax + J_SLOT]
    mov          r13, [rax + J_DST]
    mov          r14, [rax + J_ENT]
    mov          rsi, r15
    call         r12
    mov          edi, sf
    mov          rsi, rbx
    call         xav_mpsc_send
    call         rbp
    lock dec     qword [r14 + E_CNT]
    jnz          %%l
    mov          rdi, [rel pring]
    mov          rsi, [r14 + E_PKG]
    call         %1
    jmp          %%l
%%x:
    mov          rdi, r15
    mov          rsi, [rel osz]
    mov          eax, 11
    syscall
    add          rsp, 8
    pop          r15
    pop          r14
    pop          r13
    pop          r12
    pop          rbp
    pop          rbx
    ret
%endmacro

%macro JOB 0
    mov          edi, sf
    call         xav_mpsc_recv
    mov          r14, rax
    call         [rax + J_FILL]
    mov          [r14 + J_DST], rbp
    mov          [r14 + J_ENT], rbx
    mov          edi, sj
    mov          rsi, r14
    call         xav_spmc_send
    add          rbp, [r14 + J_FSZ]
    dec          r13
%endmacro

%macro PKG 1
    mov          rdi, [rel cbuf]
    mov          rsi, rbx
    call         %1
    mov          rbp, rax
%endmacro

%macro DLF 5
d%5:
    mov          r15, [r12 + %2]
    jmp          %%t
%%c:
    PKG          %4
%%f:
    mov          rdi, r12
    call         %1
    cmp          byte [r12 + V_EOF], 0
    jne          %%e
    JOB
    jnz          %%f
%%n:
    add          rbx, E_SZ
%%t:
    mov          r13, [rbx + E_CNT]
    test         r13, r13
    jnz          %%c
%%s:
    cmp          qword [rbx + E_CH], 0
    je           fin
    mov          rdi, r12
    mov          rsi, rbx
    call         xav_ds2s
    jmp          %%n
%%e:
    mov          rdi, rbx
    mov          rsi, r13
    mov          rdx, [rel fsz]
    call         xav_ds2c
    mov          rax, r13
    neg          rax
    lock xadd    [rbx + E_CNT], rax
    cmp          rax, r13
    jne          %%y
    mov          rdi, [rel pring]
    mov          rsi, [rbx + E_PKG]
    call         %3
%%y:
    add          rbx, E_SZ
    mov          r13, [rbx + E_CNT]
    test         r13, r13
    jz           %%s
    mov          rdi, r12
    mov          rsi, rbx
    call         xav_ds2s
    jmp          %%c
%endmacro

%macro DLP 2
d%2:
    mov          rax, [rel yp]
    lea          rcx, [rax + rax*2]
    shr          rcx, 1
    lea          rdx, [rcx + 6]
    mov          [rel plen], rdx
    lea          rsi, [rcx + 4096 + 64]
    mov          [rel psz], rsi
    call         amap
    mov          [rel pbuf], rax
    lea          r12, [rax + P_HDR]
    add          rax, 4096
    mov          [rel pfrm], rax
    mov          rcx, [rel yp]
    add          rax, rcx
    mov          [rel pfrm + 8], rax
    shr          rcx, 2
    add          rax, rcx
    mov          [rel pfrm + 16], rax
    mov          r15d, pfrm
    mov          r13, [rbx + E_CNT]
    test         r13, r13
    jz           %%p
    PKG          %1
    call         prd0
    test         rax, rax
    jle          pcut
    jmp          %%g
%%c:
    PKG          %1
%%f:
    mov          rsi, r12
    mov          rdx, [rel plen]
    xor          edi, edi
%%r:
    xor          eax, eax
    syscall
    test         rax, rax
    jle          pcut
    add          rsi, rax
    sub          rdx, rax
    jnz          %%r
%%g:
    JOB
    jnz          %%f
%%n:
    add          rbx, E_SZ
    mov          r13, [rbx + E_CNT]
    test         r13, r13
    jnz          %%c
    mov          r13, [rbx + E_N]
    test         r13, r13
    jz           %%z
%%d:
    call         prd
    dec          r13
    jnz          %%d
%%z:
    cmp          qword [rbx + E_CH], 0
    jne          %%n
    jmp          pfin
%%p:
    mov          r13, [rbx + E_N]
    test         r13, r13
    jz           %%z
    call         prd0
    dec          r13
    jnz          %%d
    jmp          %%z
%endmacro

SC0 xav_mpmc_send, n
SCX xav_mpmc_send, n
DLF xav_dec_next, V_FRM, xav_mpmc_send, xav_ds2k, 0n
DLF xav_dec_next_hw, V_SW, xav_mpmc_send, xav_ds2k, 1n
DLP xav_ds2k, 2n
%ifdef VSHIP
SC0 xav_mpsc_send, q
SCX xav_mpsc_send, q
DLF xav_dec_next, V_FRM, xav_mpsc_send, xav_ds2kq, 0q
DLF xav_dec_next_hw, V_SW, xav_mpsc_send, xav_ds2kq, 1q
DLP xav_ds2kq, 2q
%endif

SECTION .bss

alignb 64
xav_gr:  resb GR
gof:     resq 8
gi:      resq 6
gtc:     resq 1
gpq:     resq 2
xav_gwo: resd 1
np:      resd 1
scd:     resb 1

SECTION .rog progbits alloc noexec nowrite align=8

tgn:   dq g0n, gxn, d0n, d1n, d2n
%ifdef VSHIP
tgq:   dq g0q, gxq, d0q, d1q, d2q
%endif

SECTION .txg progbits alloc exec nowrite align=64

%macro GI 2
    SINP
    mov          [rel gof + 8], rax
    mov          [rel gof + 16], r8
    lea          r10, [r8 + r10]
    lea          r10, [r10 + r9*4]
    mov          [rel ssz], r10
    mov          [rel gi + 32], rdx
    shr          r9d, 1
    mov          [rel gi + 40], r9
    mov          r12d, [rel xav_gwo]
    mov          edx, r12d
    mov          r8d, ST
    mov          r9d, gi
    movzx        ecx, byte [rel xav_rs]
    test         cl, 16
    jnz          .pq
    shr          ecx, 5
    call         %1
.gd:
    mov          eax, [rel gi + 24]
    mov          ecx, r12d
    imul         ecx, eax
    lea          edx, [rcx + rcx]
    mov          [rel gof + 40], rdx
    lea          ecx, [rcx + rcx*4]
    shr          ecx, 1
    mov          [rel gof + 48], rcx
    shl          rax, 32
    lea          rdx, [rax + r12]
    lea          eax, [r12 + r12]
    vzeroupper
    pop          r12
    pop          rbp
    pop          rbx
    ret
.pq:
    shr          ecx, 5
    call         %2
    jmp          .gd
%endmacro

xav_sarg:
    xor          eax, eax
    xor          ecx, ecx
    xor          r10d, r10d
    test         rsi, rsi
    jz           .z
.i:
    movzx        edx, byte [rdi + rcx]
    sub          edx, 48
    cmp          edx, 9
    ja           .d
    imul         eax, eax, 10
    add          eax, edx
    cmp          eax, 4320
    ja           .z
    inc          rcx
    cmp          rcx, rsi
    jb           .i
    jmp          .k
.d:
    cmp          edx, -2
    jne          .z
    test         rcx, rcx
    jz           .z
    lea          r8, [rcx + 1]
    mov          r9, rsi
    sub          r9, r8
    dec          r9
    cmp          r9, 2
    ja           .z
    mov          r11d, 3
.f:
    imul         r10d, r10d, 10
    cmp          r8, rsi
    jae          .p
    movzx        edx, byte [rdi + r8]
    sub          edx, 48
    cmp          edx, 9
    ja           .z
    add          r10d, edx
    inc          r8
.p:
    dec          r11d
    jnz          .f
    imul         rdx, r10, 0x10624dd3
    shr          rdx, 35
    imul         ecx, edx, 125
    cmp          ecx, r10d
    jne          .z
    mov          r10d, edx
.k:
    cmp          eax, 30
    ja           .n
    lea          eax, [r10 + rax*8]
    lea          ecx, [rax - 9]
    cmp          ecx, 231
    ja           .z
    mov          ecx, 2
    cmp          eax, 16
    cmove        eax, ecx
    mov          [rel scd], al
    mov          eax, 1
    ret
.n:
    test         r10d, r10d
    jnz          .z
    mov          [rel np], eax
    mov          byte [rel scd], 255
    mov          eax, 1
    ret
.z:
    xor          eax, eax
    ret

xav_sgk:
    movzx        r8d, byte [rel scd]
    cmp          r8d, 2
    je           .o
    cmp          r8d, 255
    jne          .f
    mov          r9d, [rel np]
    lea          eax, [rdi + rdi*8]
    mov          r10d, esi
    shl          r10d, 4
    lea          r11d, [r9 + r9]
    lea          ecx, [rsi*8]
    cmp          eax, r10d
    cmovb        eax, ecx
    cmovb        r11d, r9d
    xor          edx, edx
    div          r11d
    test         edx, edx
    jnz          .e
    lea          ecx, [rax - 9]
    cmp          ecx, 231
    ja           .e
    cmp          eax, 16
    je           .o
    mov          r8d, eax
.f:
    tzcnt        ecx, r8d
    mov          eax, 3
    cmp          ecx, eax
    cmova        ecx, eax
    shrx         r9d, r8d, ecx
    mov          eax, edi
    xor          edx, edx
    div          r9d
    test         edx, edx
    jnz          .e
    mov          edx, 8
    shrx         edx, edx, ecx
    imul         eax, edx
    test         al, 1
    jnz          .e
    cmp          eax, 256
    jb           .e
    mov          edx, esi
    imul         edx, eax
    imul         ecx, edi, 143
    cmp          edx, ecx
    jb           .e
    mov          [rel xav_gwo], eax
.o:
    mov          eax, 1
    ret
.e:
    xor          eax, eax
    ret

xav_dsxi:
    cmp          dword [rel xav_gwo], 0
    je           xav_ds2i
xav_dsgi:
    GI           GN, GP

xav_dsgw:
    mov          eax, [rel xav_gwo]
    mov          edx, [rel gi + 24]
    mov          ecx, eax
    imul         ecx, edx
    lea          r8d, [rcx + rcx*2]
    cmp          edi, 2
    jb           .w0
    mov          [rel osz], r8
    mov          qword [rel sci], 1
    je           .w2
    mov          qword [rel ost], gp3
    lea          r9d, [rax + rax]
    mov          [rel gpq], r9d
    shr          eax, 1
    mov          [rel gpq + 4], eax
    lea          r9d, [rax + 1]
    shr          r9d, 1
    lea          r9d, [r9 + r9*4]
    imul         r9d, edx
    mov          [rel gpq + 8], r9
    PRS          r10d, eax
    imul         r10d, edx
    lea          eax, [r9 + r10]
    mov          [rel fsz], rax
    ret
.w2:
    mov          qword [rel ost], xav_o2
    imul         eax, ecx, 15
    shr          eax, 3
    mov          [rel fsz], rax
%if PC == 384
    shr          ecx, 7
    mov          [rel xav_op + 96], ecx
    mov          rdx, 0xffffffffff
    mov          [rel xav_op + 88], rdx
%else
    shr          ecx, 6
    mov          [rel xav_op + 96], ecx
%endif
    ret
.w0:
    mov          [rel fsz], r8
    mov          eax, r8d
    ret

gp3:
    sub          rsp, 8
    mov          rdi, r15
    mov          esi, [rel gpq]
    mov          edx, [rel xav_gwo]
    mov          ecx, [rel gi + 24]
    mov          r8, r13
    call         xav_pack_10b_rem
    mov          rdi, [rel gof + 40]
    add          rdi, r15
    mov          esi, [rel xav_gwo]
    mov          edx, [rel gpq + 4]
    mov          ecx, [rel gi + 24]
    mov          r8, [rel gpq + 8]
    add          r8, r13
    add          rsp, 8
    jmp          xav_pack_10b_rem

%macro SG0 2
g0%2:
    push         rbx
    push         r12
    push         r13
    push         r14
    sub          rsp, 8
    mov          eax, 1
    lock xadd    [rel gtc], rax
    imul         rax, [rel gi + 16]
    add          rax, [rel gi + 8]
    mov          r12, rax
    mov          r14, [rel gi]
%%l:
    mov          edi, sj
    call         xav_spmc_recv
    test         rax, rax
    jz           %%x
    mov          rbx, rax
%if PC == 384
    vpbroadcastq ymm0, [rax + J_SLOT]
    vpbroadcastq ymm1, [rax + J_DST]
    vinserti64x4 zmm0, zmm0, ymm1, 1
    vpaddq       zmm0, zmm0, [rel gof]
    vmovdqu64    [r12], zmm0
%else
    vpbroadcastq ymm0, [rax + J_SLOT]
    vpaddq       ymm0, ymm0, [rel gof]
    vmovdqu      [r12], ymm0
    vpbroadcastq ymm1, [rax + J_DST]
    vpaddq       ymm1, ymm1, [rel gof + 32]
    vmovdqu      [r12 + 32], ymm1
%endif
    mov          r13, [rax + J_ENT]
    mov          rdi, r12
    call         r14
    mov          edi, sf
    mov          rsi, rbx
    call         xav_mpsc_send
    lock dec     qword [r13 + E_CNT]
    jnz          %%l
    mov          rdi, [rel pring]
    mov          rsi, [r13 + E_PKG]
    call         %1
    jmp          %%l
%%x:
    add          rsp, 8
    pop          r14
    pop          r13
    pop          r12
    pop          rbx
    ret
%endmacro

%macro SGX 2
gx%2:
    push         rbx
    push         rbp
    push         r12
    push         r13
    push         r14
    push         r15
    sub          rsp, 8
    mov          eax, 1
    lock xadd    [rel gtc], rax
    imul         rax, [rel gi + 16]
    add          rax, [rel gi + 8]
    mov          r12, rax
    mov          rbp, [rel ost]
    mov          rsi, [rel osz]
    call         amap
    mov          r15, rax
%if PC == 384
    vpbroadcastq ymm1, rax
%else
    vmovq        xmm1, rax
    vpbroadcastq ymm1, xmm1
%endif
    vpaddq       ymm1, ymm1, [rel gof + 32]
    vmovdqu      [r12 + 32], ymm1
%%l:
    mov          edi, sj
    call         xav_spmc_recv
    test         rax, rax
    jz           %%x
    mov          rbx, rax
    vpbroadcastq ymm0, [rax + J_SLOT]
    vpaddq       ymm0, ymm0, [rel gof]
    vmovdqu      [r12], ymm0
    mov          r13, [rax + J_DST]
    mov          r14, [rax + J_ENT]
    mov          rdi, r12
    call         [rel gi]
    mov          edi, sf
    mov          rsi, rbx
    call         xav_mpsc_send
    call         rbp
    lock dec     qword [r14 + E_CNT]
    jnz          %%l
    mov          rdi, [rel pring]
    mov          rsi, [r14 + E_PKG]
    call         %1
    jmp          %%l
%%x:
    mov          rdi, r15
    mov          rsi, [rel osz]
    mov          eax, 11
    syscall
    add          rsp, 8
    pop          r15
    pop          r14
    pop          r13
    pop          r12
    pop          rbp
    pop          rbx
    ret
%endmacro

SG0 xav_mpmc_send, n
SGX xav_mpmc_send, n
%ifdef VSHIP
SG0 xav_mpsc_send, q
SGX xav_mpsc_send, q
xav_dsgq:
    lea          rax, [rel tgq]
    jmp          run
%endif
xav_dsgr:
    lea          rax, [rel tgn]
    jmp          run
