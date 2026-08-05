%include "dav1d_x86inc.asm"

SECTION_RODATA 64
d100: db "00010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899"
dg:   db 19,19,19,19,18,18,18,17,17,17,16,16,16,16,15,15
      db 15,14,14,14,13,13,13,13,12,12,12,11,11,11,10,10
      db 10,10,9,9,9,8,8,8,7,7,7,7,6,6,6,5
      db 5,5,4,4,4,4,3,3,3,2,2,2,1,1,1,1
ps_48k: dd 48000.0
ps_ten: dd 10.0
ps_hun: dd 100.0
ps_nsr: dd 1.0e-9
ps_mil: dd 0.001
ps_eig: dd 8.0
ps_1k:  dd 1000.0
ps_1e6: dd 1000000.0
ps_1e9: dd 1000000000.0
p10:  dq 1,10,100,1000,10000,100000,1000000,10000000,100000000,1000000000
      dq 10000000000,100000000000,1000000000000,10000000000000,100000000000000
      dq 1000000000000000,10000000000000000,100000000000000000
      dq 1000000000000000000,10000000000000000000

cpy_lab: db "Source AU/Subs Read: "

SECTION .text align=64
INIT_XMM avx2

cextern pb_fire
cextern pb_init
%if WIN64
extern xav_plat_now
extern xav_plat_write
extern xav_plat_wait
extern xav_plat_wake
extern xav_plat_park
%else
extern xav_vdso_cgt
extern xav_vdso_done
extern xav_vdso_init
%endif

%macro PNOW 1
%if WIN64
    mov          ecx, 1
    lea          rdx, [rsp+%1]
    sub          rsp, 32
    call         xav_plat_now
    add          rsp, 32
%else
    mov          edi, 1
    lea          rsi, [rsp+%1]
    call         [rel xav_vdso_cgt]
%endif
%endmacro

%macro PINIT 0
%if WIN64 == 0
    cmp          byte [rel xav_vdso_done], 0
    jne          %%have
    call         xav_vdso_init
%%have:
%endif
%endmacro

%macro PWRITE 0
%if WIN64
    mov          rcx, rsi
    sub          rsp, 32
    call         xav_plat_write
    add          rsp, 32
%else
    mov          edi, 1
    mov          eax, 1
    syscall
%endif
%endmacro

%macro PWAIT 1
%if WIN64
    lea          rcx, %1
    mov          edx, 2
    sub          rsp, 32
    call         xav_plat_wait
    add          rsp, 32
%else
    mov          eax, 202
    lea          rdi, %1
    mov          esi, FX_W
    mov          edx, 2
    xor          t1d, t1d
    syscall
%endif
%endmacro

%macro PWAKE 1
%if WIN64
    lea          rcx, %1
    sub          rsp, 32
    call         xav_plat_wake
    add          rsp, 32
%else
    mov          eax, 202
    lea          rdi, %1
    mov          esi, FX_K
    mov          edx, 1
    syscall
%endif
%endmacro

%macro PPARK 0
%ifdef NOPARK
%elif WIN64
    mov          rcx, s5q
    sub          rsp, 32
    call         xav_plat_park
    add          rsp, 32
%else
    mov          eax, 202
    mov          rdi, s5q
    mov          esi, FX_W
    mov          edx, PARKED
    lea          t1q, [rsp+M_TS]
    syscall
%endif
%endmacro

%define P_NEXT   16
%define P_CNT    40
%define P_STRIDE 44
%define P_CHECKS 48
%define BW       20
%define CD0      0x3b315b1b
%define CG       0x6d32393b
%define CR       0x6d31393b
%define CP       0x6d35393b
%define CY       0x6d33393b
%define CC       0x6d36393b
%define CW       0x6d37393b
%define CN       0x6d305b1b
%define QHASH    0x236d32393b315b1b
%define QDASH    0x2d6d31393b315b1b
%define QBHASH   0x236d34393b315b1b
%define QYDASH   0x2d6d33393b315b1b
%define M100     1374389535
%define BIG      100000000
%define B_LINE   512
%define B_LAB    520
%define B_LLEN   528
%define FRSZ     568

%macro COL 1
    mov          dword [opq], CD0
    mov          dword [opq+3], %1
    add          opq, 7
%endmacro

%macro D4 0
    cmp          rax, 10000
    jae          %%slow
    imul         t1q, rax, M100
    shr          t1q, 37
    imul         t3q, t1q, 100
    sub          rax, t3q
    movzx        t2d, word [d100+t1q*2]
    movzx        t3d, word [d100+rax*2]
    shl          t3d, 16
    or           t2d, t3d
    mov          [opq], t2d
    add          opq, 4
    jmp          %%done
%%slow:
    PAD          4, '0'
%%done:
%endmacro

%macro U3 0
    cmp          rax, 1000
    jb           %%short
    cmp          rax, 1000000
    jae          %%slow
    imul         t1q, rax, 274877907
    shr          t1q, 38
    imul         t3q, t1q, 1000
    sub          rax, t3q
    mov          t2d, [u3+t1q*4]
    mov          [opq], t2d
    shr          t2d, 24
    add          opq, t2q
    mov          eax, [z3+rax*4]
    mov          [opq], eax
    add          opq, 3
    jmp          %%done
%%short:
    mov          eax, [u3+rax*4]
    mov          [opq], eax
    shr          eax, 24
    add          opq, rax
    jmp          %%done
%%slow:
    call         .itoa
%%done:
%endmacro

%macro PAD3T 0
    cmp          rax, 1000
    jae          %%slow
    mov          eax, [sp3+rax*4]
    mov          [opq], eax
    add          opq, 3
    jmp          %%done
%%slow:
    PAD          3, ' '
%%done:
%endmacro

%macro PERC3 1
    mov          eax, [rsp+%1]
    mov          eax, [perctab+rax*4]
    mov          [opq], eax
    add          opq, 3
%endmacro

%macro DCOL 1
    db 0x1b, 0x5b, 0x31, 0x3b, ((%1)>>8)&0xff, ((%1)>>16)&0xff, 0x6d
%endmacro

SECTION_RODATA 64
bar_gr: times BW dq QHASH
        times BW dq QDASH
bar_by: times BW dq QBHASH
        times BW dq QYDASH
lit_b1: DCOL CC
        db ']',' '
        DCOL CP
        db '['
lit_b2: DCOL CC
        db ']',' ','['
        db 0,0,0,0,0,0
lit_c1: DCOL CP
        db ']',' '
        DCOL CW
lit_c2: DCOL CC
        db ']',' '
        DCOL CW
lit_d:  db '%'
        DCOL CC
        db ',',' '
        DCOL CY
lit_e:  DCOL CC
        db ',',' '
        DCOL CG
lit_f:  DCOL CC
        db '/'
        DCOL CR
        db 0
lit_h:  DCOL CC
        db '['
        DCOL CW
        db 0
lit_i:  DCOL CC
        db ']',' '
        DCOL CW
        db 0
lit_j:  db ':',' '
        DCOL CC
        db '['
        db 0,0,0,0,0
lit_g:  db ' ','F','P','S'
        DCOL CC
        db ',',' '
        DCOL CW
        db '-'
        db 0,0,0
%assign qv 0
sp3:
%rep 1000
        db (qv<100 ? ' ' : '0'+qv/100), (qv<10 ? ' ' : '0'+(qv/10) % 10), '0'+qv % 10, 0
%assign qv qv+1
%endrep
%assign uv 0
u3:
%rep 1000
%if uv < 10
        db '0'+uv, 0, 0, 1
%elif uv < 100
        db '0'+uv/10, '0'+uv % 10, 0, 2
%else
        db '0'+uv/100, '0'+(uv/10) % 10, '0'+uv % 10, 3
%endif
%assign uv uv+1
%endrep
%assign zv 0
z3:
%rep 1000
        db '0'+zv/100, '0'+(zv/10) % 10, '0'+zv % 10, 0
%assign zv zv+1
%endrep
%assign pv 0
perctab:
%rep 101
        db (pv<100 ? ' ' : '0'+pv/100), (pv<10 ? ' ' : '0'+(pv/10) % 10), '0'+pv % 10, 0
%assign pv pv+1
%endrep
SECTION .text align=64

%macro VZU 0
    vzeroupper
%endmacro

%macro PERC 1
    mov          rax, [rsp+%1]
%endmacro

%macro BAR 4
    mov          t3d, 1
    mov          t2q, %2
    test         t2q, t2q
    cmovz        t2q, t3q
    mov          rax, %1
    imul         rax, rax, 100
    xor          edx, edx
    div          t2q
    mov          t3d, 100
    cmp          rax, t3q
    cmova        rax, t3q
    mov          [rsp+%4], rax
    imul         eax, eax, 205
    shr          eax, 10
    mov          t3d, BW
    sub          t3q, rax
    lea          t1q, [%3+t3q*8]
%assign %%i 0
%rep 5
    vmovdqu      ymm0, [t1q+%%i]
    vmovdqu      [opq+%%i], ymm0
%assign %%i %%i+32
%endrep
    add          opq, BW*8
%endmacro

%define B_TMP    536
%define B_TMP2   544

%macro D2 0
    mov          t3d, 99
    cmp          rax, t3q
    cmova        rax, t3q
    movzx        eax, word [d100+rax*2]
    mov          [opq], ax
    add          opq, 2
%endmacro

%macro DIVC 1
    mov          t1q, ((1<<43)/(%1))+1
    imul         t1q, rax
    shr          t1q, 43
    imul         t3q, t1q, %1
    sub          rax, t3q
    mov          rdx, rax
    mov          rax, t1q
%endmacro

%macro ITOAP 0
.itoa:
    mov          t1q, rax
    or           t1q, 1
    lzcnt        t1q, t1q
    movzx        t3d, byte [dg+t1q]
    cmp          rax, [p10+t3q*8]
    sbb          t3q, -1
%endmacro

%macro ITOAC 0
.itoa2:
    add          opq, t3q
    mov          t2q, opq
.p:
    cmp          rax, 100
    jb           .tail
    cmp          rax, BIG
    jae          .slowd
    imul         t1q, rax, M100
    shr          t1q, 37
    mov          t3q, t1q
    imul         t3q, t3q, 100
    sub          rax, t3q
    movzx        t3d, word [d100+rax*2]
    mov          [t2q-2], t3w
    sub          t2q, 2
    mov          rax, t1q
    jmp          .p
.slowd:
    xor          edx, edx
    mov          t3d, 100
    div          t3q
    movzx        t3d, word [d100+rdx*2]
    mov          [t2q-2], t3w
    sub          t2q, 2
    jmp          .p
.tail:
    cmp          rax, 10
    jb           .one
    movzx        t3d, word [d100+rax*2]
    mov          [t2q-2], t3w
    ret
.one:
    or           al, '0'
    mov          [t2q-1], al
    ret
%endmacro

%macro ITOASUB 0
    ITOAP
    ITOAC
%endmacro

%macro PADSUB 0
.padw:
    mov          t1q, rax
    or           t1q, 1
    lzcnt        t1q, t1q
    movzx        t3d, byte [dg+t1q]
    cmp          rax, [p10+t3q*8]
    sbb          t3q, -1
    sub          a5q, t3q
    jle          .itoa2
    mov          [opq], t2q
    add          opq, a5q
    jmp          .itoa2
%endmacro

%macro GBODY 1
    cmp          cvq, tvq
    jae          .force
    sub          dword [pgq+P_CNT], 1
    jle          %1
    ret
.force:
    mov          qword [pgq+P_NEXT], 0
    jmp          %1
%endmacro

cglobal pb_frames, 6, 7, 0, pg, cv, tv, ln, lb, ll, t0
    GBODY        xav_pb_fmt

cglobal pb_fmt, 6, 15, 0, pg, cv, tv, ln, lb, ll, ax, t1, t2, op, cvs, tvs, el, pgs, t3
    sub          rsp, FRSZ
    mov          [rsp+B_LINE], lnq
    mov          [rsp+B_LAB], lbq
    mov          [rsp+B_LLEN], llq
    mov          pgsq, pgq
    mov          cvsq, cvq
    mov          tvsq, tvq
    rdtsc
    shl          rdx, 32
    or           rax, rdx
    inc          dword [pgsq+P_CHECKS]
    cmp          rax, [pgsq+P_NEXT]
    jae          .fire
    mov          eax, [pgsq+P_STRIDE]
    mov          [pgsq+P_CNT], eax
    add          rsp, FRSZ
    RET
.fire:
    mov          pgq, pgsq
    mov          cvq, rax
%ifdef NOFIRE
    mov          elq, 3725
%else
    call         xav_pb_fire
    mov          elq, rax
%endif
    lea          opq, [rsp]
    mov          t2q, [rsp+B_LINE]
    test         t2q, t2q
    jz           .noline
    mov          word [opq], 0x5b1b
    add          opq, 2
    mov          rax, t2q
    U3
    mov          dword [opq], 0x0048313b
    add          opq, 3
    jmp          .clr
.noline:
    mov          byte [opq], 0x0d
    inc          opq
.clr:
    mov          dword [opq], 0x4b325b1b
    add          opq, 4
    mov          rax, elq
    DIVC         3600
    mov          [rsp+B_TMP], rdx
    COL          CW
    D2
    COL          CP
    mov          byte [opq], ':'
    inc          opq
    COL          CW
    mov          rax, [rsp+B_TMP]
    DIVC         60
    D2
    mov          byte [opq], ' '
    inc          opq
    COL          CW
    mov          t1q, [rsp+B_LAB]
    mov          t2q, [rsp+B_LLEN]
    test         t2q, t2q
    jz           .ldone
.lcp:
    mov          al, [t1q]
    mov          [opq], al
    inc          t1q
    inc          opq
    dec          t2q
    jnz          .lcp
.ldone:
    mov          word [opq], 0x203a
    add          opq, 2
    COL          CC
    mov          byte [opq], '['
    inc          opq
    BAR          cvsq, tvsq, bar_gr, B_TMP2
    movups       xmm0, [lit_c2]
    movups       [opq], xmm0
    add          opq, 16
    PERC         B_TMP2
    U3
    movups       xmm0, [lit_d]
    movups       [opq], xmm0
    mov          byte [opq+16], 0x6d
    add          opq, 17
    mov          t3d, 1
    mov          t2q, elq
    test         t2q, t2q
    cmovz        t2q, t3q
    mov          rax, cvsq
    xor          edx, edx
    div          t2q
    U3
    movups       xmm0, [lit_g]
    movups       [opq], xmm0
    mov          t1q, [lit_g+16]
    mov          [opq+16], t1q
    add          opq, 21
    mov          rax, tvsq
    sub          rax, cvsq
    jnc          .rok
    xor          eax, eax
.rok:
    imul         rax, elq
    mov          t3d, 1
    mov          t2q, cvsq
    test         t2q, t2q
    cmovz        t2q, t3q
    xor          edx, edx
    div          t2q
    DIVC         3600
    mov          [rsp+B_TMP], rdx
    D2
    COL          CP
    mov          byte [opq], ':'
    inc          opq
    COL          CW
    mov          rax, [rsp+B_TMP]
    DIVC         60
    D2
    COL          CC
    mov          word [opq], 0x202c
    add          opq, 2
    COL          CG
    mov          rax, cvsq
    U3
    COL          CC
    mov          byte [opq], '/'
    inc          opq
    COL          CR
    mov          rax, tvsq
    U3
    mov          dword [opq], CN
    add          opq, 4
%ifndef NOWRITE
    mov          rdx, opq
    sub          rdx, rsp
    mov          rsi, rsp
    PWRITE
%endif
    VZU
    add          rsp, FRSZ
    RET
    ITOASUB

cglobal pb_copy, 3, 7, 0, pg, cv, tv, t0, t1, t2, t3
    GBODY        xav_pb_cfmt

cglobal pb_cfmt, 3, 15, 0, pg, cv, tv, a3, a4, a5, ax, t1, t2, op, cvs, tvs, el, pgs, t3
    sub          rsp, FRSZ
    mov          pgsq, pgq
    mov          cvsq, cvq
    mov          tvsq, tvq
    rdtsc
    shl          rdx, 32
    or           rax, rdx
    inc          dword [pgsq+P_CHECKS]
    cmp          rax, [pgsq+P_NEXT]
    jae          .fire
    mov          eax, [pgsq+P_STRIDE]
    mov          [pgsq+P_CNT], eax
    add          rsp, FRSZ
    RET
.fire:
    mov          pgq, pgsq
    mov          cvq, rax
%ifndef NOFIRE
    call         xav_pb_fire
%endif
    lea          opq, [rsp]
    mov          byte [opq], 0x0d
    mov          dword [opq+1], 0x4b325b1b
    add          opq, 5
    COL          CW
    lea          t1q, [cpy_lab]
    mov          rax, [t1q]
    mov          [opq], rax
    mov          rax, [t1q+8]
    mov          [opq+8], rax
    mov          rax, [t1q+13]
    mov          [opq+13], rax
    add          opq, 21
    COL          CC
    mov          byte [opq], '['
    inc          opq
    BAR          cvsq, tvsq, bar_gr, B_TMP2
    movups       xmm0, [lit_c2]
    movups       [opq], xmm0
    add          opq, 16
    PERC         B_TMP2
    U3
    mov          t1q, '%'|(CN<<8)
    mov          [opq], t1q
    add          opq, 5
%ifndef NOWRITE
    mov          rdx, opq
    sub          rdx, rsp
    mov          rsi, rsp
    PWRITE
%endif
    VZU
    add          rsp, FRSZ
    RET
    ITOASUB

cglobal pb_au, 6, 7, 0, pg, cv, tv, ln, ps, ti, t0
    GBODY        xav_pb_afmt

cglobal pb_au_f, 6, 7, 0, pg, cv, tv, ln, ps, ti, t0
    mov          qword [pgq+P_NEXT], 0
    jmp          xav_pb_afmt

cglobal pb_afmt, 6, 15, 0, pg, cv, tv, ln, ps, ti, ax, t1, t2, op, cvs, tvs, el, pgs, t3
    sub          rsp, FRSZ
    mov          [rsp+B_LINE], lnq
    mov          [rsp+B_LAB], psq
    mov          [rsp+B_LLEN], tiq
    mov          pgsq, pgq
    mov          cvsq, cvq
    mov          tvsq, tvq
    rdtsc
    shl          rdx, 32
    or           rax, rdx
    inc          dword [pgsq+P_CHECKS]
    cmp          rax, [pgsq+P_NEXT]
    jae          .fire
    mov          eax, [pgsq+P_STRIDE]
    mov          [pgsq+P_CNT], eax
    add          rsp, FRSZ
    RET
.fire:
    mov          pgq, pgsq
    mov          cvq, rax
%ifdef NOFIRE
    mov          elq, 3725
%else
    call         xav_pb_fire
    mov          elq, rax
%endif
    lea          opq, [rsp]
    mov          t2q, [rsp+B_LINE]
    test         t2q, t2q
    jz           .noline
    mov          word [opq], 0x5b1b
    add          opq, 2
    mov          rax, t2q
    U3
    mov          dword [opq], 0x0048313b
    add          opq, 3
    jmp          .clr
.noline:
    mov          byte [opq], 0x0d
    inc          opq
.clr:
    mov          dword [opq], 0x4b325b1b
    add          opq, 4
    movups       xmm0, [lit_h]
    movups       [opq], xmm0
    add          opq, 15
    mov          rax, [rsp+B_LLEN]
    D2
    movups       xmm0, [lit_i]
    movups       [opq], xmm0
    mov          dword [opq+16], 0x50205541
    add          opq, 20
    mov          rax, [rsp+B_LAB]
    U3
    movups       xmm0, [lit_j]
    movups       [opq], xmm0
    add          opq, 10
    BAR          cvsq, tvsq, bar_gr, B_TMP2
    movups       xmm0, [lit_c2]
    movups       [opq], xmm0
    add          opq, 16
    PERC         B_TMP2
    U3
    movups       xmm0, [lit_d]
    movups       [opq], xmm0
    mov          byte [opq+16], 0x6d
    add          opq, 17
    mov          t3d, 1
    mov          t2q, elq
    test         t2q, t2q
    cmovz        t2q, t3q
    cvtsi2ss     xmm0, cvsq
    cvtsi2ss     xmm1, t2q
    divss        xmm0, xmm1
    divss        xmm0, [ps_48k]
    mulss        xmm0, [ps_ten]
    cvtss2si     rax, xmm0
    xor          edx, edx
    mov          t3d, 10
    div          t3q
    mov          [rsp+B_TMP], rdx
    U3
    mov          byte [opq], '.'
    inc          opq
    mov          rax, [rsp+B_TMP]
    or           al, '0'
    mov          [opq], al
    mov          byte [opq+1], 'x'
    add          opq, 2
    COL          CC
    mov          word [opq], 0x202c
    add          opq, 2
    mov          rax, tvsq
    xor          edx, edx
    mov          t3d, 48000
    div          t3q
    mov          t2q, rax
    COL          CG
    mov          rax, t2q
    DIVC         3600
    mov          [rsp+B_TMP], rdx
    D2
    COL          CP
    mov          byte [opq], ':'
    inc          opq
    COL          CG
    mov          rax, [rsp+B_TMP]
    DIVC         60
    D2
    COL          CP
    mov          byte [opq], ':'
    inc          opq
    COL          CG
    mov          rax, t2q
    DIVC         60
    mov          rax, rdx
    D2
    mov          dword [opq], CN
    add          opq, 4
%ifndef NOWRITE
    mov          rdx, opq
    sub          rdx, rsp
    mov          rsi, rsp
    PWRITE
%endif
    VZU
    add          rsp, FRSZ
    RET
    ITOASUB

%define M_VAL   8
%define M_LEN   520
%define FX_W    128
%define FX_K    129
%define SPINS   100

%define PAT(c) ((c)*0x0101010101010101)

%macro PAD 2
    mov          a5d, %1
    mov          t2q, PAT(%2)
    call         .padw
%endmacro

%macro F2 1
    mulss        xmm0, [ps_hun]
    cvtss2si     rax, xmm0
    imul         t1q, rax, M100
    shr          t1q, 37
    imul         t3q, t1q, 100
    sub          rax, t3q
%if %1 == 6
    cmp          t1q, 1000
%else
    cmp          t1q, 100
%endif
    jae          %%slow
    movzx        t3d, word [d100+rax*2]
%if %1 == 6
    mov          t2d, [sp3+t1q*4]
    or           t2d, '.'<<24
    shl          t3q, 32
%else
    mov          t2d, [sp3+t1q*4+1]
    and          t2d, 0xffff
    or           t2d, '.'<<16
    shl          t3q, 24
%endif
    or           t2q, t3q
    mov          [opq], t2q
    add          opq, %1
    jmp          %%done
%%slow:
    movzx        edx, word [d100+rax*2]
    mov          rax, t1q
    PAD          (%1-3), ' '
    mov          byte [opq], '.'
    mov          [opq+1], dx
    add          opq, 3
%%done:
%endmacro

%define S_TAG   0
%define S_CNT   4
%define S_ENC   8
%define S_FLU   16
%define S_TOT   24
%define S_IDX   32
%define S_FL    40
%define S_STA   48
%define S_C     56
%define S_S     60
%define S_LK    64
%define S_BUF   72
%define S_LEN   584
%define SLOTSZ  640

cglobal pb_fin, 2, 4, 0, sl, pc, t1, t2
    cmp          dword [slq+S_CNT], 0
    je           .z
    mov          t1q, [slq+S_ENC]
    mov          t2q, t1q
    xchg         [slq+S_FLU], t2q
    sub          t1q, t2q
    db           0xf0
    add          [pcq], t1q
.z:
    mov          dword [slq+S_TAG], 0
    ret

%macro FMTSLOT 7
    mov          rax, [rsp+A_NOW]
    sub          rax, [bp1q+S_STA]
    cvtsi2ss     xmm0, rax
    mulss        xmm0, [ps_nsr]
    maxss        xmm0, [ps_mil]
    cvtsi2ss     xmm3, qword [bp1q+S_ENC]
    divss        xmm3, xmm0
    movss        xmm1, [bp1q+S_C]
    movss        xmm2, [bp1q+S_S]
    COL          CC
    mov          byte [opq], '['
    inc          opq
    mov          rax, [bp1q+S_IDX]
    D4
    cmp          qword [bp1q+S_FL], 0
    je           %%tagend
    mov          dword [opq], 0x46202f20
    mov          byte [opq+4], ' '
    add          opq, 5
    movaps       xmm0, xmm1
    F2           5
    mov          dword [opq], 0x00202f20
    add          opq, 3
    test         byte [bp1q+S_FL], 2
    jz           %%noscore
    movaps       xmm0, xmm2
    F2           5
    jmp          %%tagend
%%noscore:
    mov          dword [opq], 0x20202020
    mov          byte [opq+4], ' '
    add          opq, 5
%%tagend:
    movups       xmm0, [%6]
    movups       [opq], xmm0
%if %1
    mov          byte [opq+16], '['
    add          opq, 17
%else
    add          opq, 10
%endif
    BAR          [bp1q+S_ENC], [bp1q+S_TOT], %5, A_TMP2
    movups       xmm0, [%7]
    movups       [opq], xmm0
    add          opq, 16
    PERC3        A_TMP2
    movups       xmm0, [lit_d]
    movups       [opq], xmm0
    mov          byte [opq+16], 0x6d
    add          opq, 17
    movaps       xmm0, xmm3
    F2           6
    movups       xmm0, [lit_e]
    movups       [opq], xmm0
    add          opq, 16
    mov          rax, [bp1q+S_ENC]
    PAD3T
    movups       xmm0, [lit_f]
    movups       [opq], xmm0
    add          opq, 15
    mov          rax, [bp1q+S_TOT]
    PAD3T
%endmacro

%define M_PB    0
%define M_TS    56
%define MONSZ   72
%define NOTIF   1
%define PARKED  -1
%define IVAL_NS 512000000

cglobal pb_mon, 6, 15, 0, dn, st, pk, tv, ln, pi, ax, t1, t2, s0, s1, s2, s3, s4, s5
    sub          rsp, MONSZ
    mov          s0q, dnq
    mov          s1q, stq
    mov          s2q, tvq
    mov          s3q, lnq
    mov          s4q, piq
    mov          s5q, pkq
    lea          dnq, [rsp+M_PB]
    call         xav_pb_init
    mov          qword [rsp+M_TS], 0
    mov          qword [rsp+M_TS+8], IVAL_NS
    jmp          .tick
.loop:
    mov          eax, -1
    lock xadd    [s5q], eax
    cmp          eax, NOTIF
    je           .tick
    PPARK
    xor          eax, eax
    xchg         [s5q], eax
.tick:
    cmp          byte [s1q], 0
    jne          .fin
    mov          rax, [s0q]
    cmp          rax, s2q
    cmova        rax, s2q
    mov          stq, rax
.emit:
    lea          dnq, [rsp+M_PB]
    mov          pkq, s2q
    mov          tvq, s3q
    movzx        lnq, s4b
    mov          piq, s4q
    shr          piq, 8
    call         xav_pb_au_f
    jmp          .loop
.fin:
    mov          stq, s2q
    lea          dnq, [rsp+M_PB]
    mov          pkq, s2q
    mov          tvq, s3q
    movzx        lnq, s4b
    mov          piq, s4q
    shr          piq, 8
    call         xav_pb_au_f
    add          rsp, MONSZ
    RET

%define D_BRD   0
%define D_NB    8
%define D_BUF   16
%define D_CMP   24
%define D_CFR   32
%define D_TSZ   40
%define D_PRC   48
%define D_PRI   56
%define D_STA   64
%define D_TCH   72
%define D_TFR   80
%define D_IFR   88
%define D_FN    96
%define D_FD    100
%define CB      0x6d34393b
%define A_TS    0
%define A_NOW   16
%define A_CFR   24
%define A_TSZ   32
%define A_FDN   40
%define A_ELS   48
%define A_TMP   56
%define A_TMP2  64
%define AFRSZ   72

%macro F2N 0
    mulss        xmm0, [ps_hun]
    cvtss2si     rax, xmm0
    imul         t1q, rax, M100
    shr          t1q, 37
    imul         t3q, t1q, 100
    sub          rax, t3q
    movzx        edx, word [d100+rax*2]
    mov          rax, t1q
    mov          [rsp+A_TMP], rdx
    U3
    mov          rdx, [rsp+A_TMP]
    mov          byte [opq], '.'
    mov          [opq+1], dx
    add          opq, 3
%endmacro

%macro F1N 0
    mulss        xmm0, [ps_ten]
    cvtss2si     rax, xmm0
    xor          edx, edx
    mov          t3d, 10
    div          t3q
    mov          [rsp+A_TMP], rdx
    U3
    mov          rax, [rsp+A_TMP]
    or           al, '0'
    mov          byte [opq], '.'
    mov          [opq+1], al
    add          opq, 2
%endmacro

cglobal pb_draw, 1, 15, 6, dw, a1, a2, a3, a4, a5, ax, t1, t2, op, bp1, bp2, dws, t4, t3
    sub          rsp, AFRSZ
    mov          dwsq, dwq
    PINIT
    PNOW         A_TS
    mov          rax, [rsp+A_TS]
    imul         rax, rax, 1000000000
    add          rax, [rsp+A_TS+8]
    mov          [rsp+A_NOW], rax
    mov          opq, [dwsq+D_BUF]
    mov          dword [opq], 0x00755b1b
    add          opq, 3
    mov          bp1q, [dwsq+D_BRD]
    mov          bp2q, [dwsq+D_NB]
    mov          t4q, 0x4b325b1b0d0a
    mov          dword [opq], 0x325b1b0d
    mov          byte [opq+4], 'K'
    add          opq, 5
    test         bp2q, bp2q
    jz           .bdone
.bloop:
    mov          eax, [bp1q+S_TAG]
    cmp          eax, 1
    je           .slib
    cmp          eax, 2
    je           .smet
    cmp          eax, 3
    je           .stxt
.bnext:
    mov          [opq], t4q
    add          opq, 6
    add          bp1q, SLOTSZ
    dec          bp2q
    jnz          .bloop
.bdone:
    mov          t4q, 0x4b325b1b0d0a
    mov          [opq], t4q
    add          opq, 6

    mov          rax, [rsp+A_NOW]
    sub          rax, [dwsq+D_STA]
    xor          edx, edx
    mov          t1d, 1000000000
    div          t1q
    mov          t1q, [dwsq+D_PRI]
    add          rax, [t1q]
    mov          [rsp+A_ELS], rax

    mov          t1q, [dwsq+D_CFR]
    mov          t2q, [t1q]
    mov          [rsp+A_CFR], t2q
    mov          t1q, [dwsq+D_TSZ]
    mov          t1q, [t1q]
    mov          [rsp+A_TSZ], t1q
    mov          t1q, [dwsq+D_PRC]
    mov          rax, [t1q]
    add          rax, [dwsq+D_IFR]
    cmp          rax, t2q
    cmovb        rax, t2q
    mov          [rsp+A_FDN], rax

    COL          CW
    mov          rax, [rsp+A_ELS]
    DIVC         3600
    mov          t4q, rdx
    D2
    COL          CP
    mov          byte [opq], ':'
    inc          opq
    COL          CW
    mov          rax, t4q
    DIVC         60
    D2
    mov          byte [opq], ' '
    inc          opq
    COL          CC
    mov          byte [opq], '['
    inc          opq
    COL          CG
    mov          t1q, [dwsq+D_CMP]
    mov          rax, [t1q]
    U3
    COL          CC
    mov          byte [opq], '/'
    inc          opq
    COL          CR
    mov          rax, [dwsq+D_TCH]
    U3
    COL          CC
    mov          dword [opq], 0x5b205d
    add          opq, 3

    mov          t3d, 1
    mov          t2q, [dwsq+D_TFR]
    test         t2q, t2q
    cmovz        t2q, t3q
    mov          rax, [rsp+A_FDN]
    imul         rax, rax, BW
    xor          edx, edx
    div          t2q
    mov          t3d, BW
    cmp          rax, t3q
    cmova        rax, t3q
    mov          t2q, rax
    sub          t3q, rax
    mov          t1q, QHASH
    test         t2q, t2q
    jz           .dashes
.hloop:
    mov          [opq], t1q
    add          opq, 8
    dec          t2q
    jnz          .hloop
.dashes:
    mov          t1q, QDASH
    test         t3q, t3q
    jz           .bardone
.dloop:
    mov          [opq], t1q
    add          opq, 8
    dec          t3q
    jnz          .dloop
.bardone:
    COL          CC
    mov          word [opq], 0x205d
    add          opq, 2
    COL          CW
    mov          t3d, 1
    mov          t2q, [dwsq+D_TFR]
    test         t2q, t2q
    cmovz        t2q, t3q
    mov          rax, [rsp+A_FDN]
    imul         rax, rax, 100
    xor          edx, edx
    div          t2q
    mov          t3d, 100
    cmp          rax, t3q
    cmova        rax, t3q
    U3
    mov          word [opq], 0x2025
    add          opq, 2
    COL          CG
    mov          rax, [rsp+A_FDN]
    U3
    COL          CC
    mov          byte [opq], '/'
    inc          opq
    COL          CR
    mov          rax, [dwsq+D_TFR]
    U3
    mov          byte [opq], ' '
    inc          opq
    COL          CC
    mov          byte [opq], '('
    inc          opq
    COL          CY
    mov          t3d, 1
    mov          t2q, [rsp+A_ELS]
    test         t2q, t2q
    cmovz        t2q, t3q
    cvtsi2ss     xmm0, qword [rsp+A_FDN]
    cvtsi2ss     xmm1, t2q
    divss        xmm0, xmm1
    F2N

    mov          rax, [dwsq+D_TFR]
    sub          rax, [rsp+A_FDN]
    jnc          .rok
    xor          eax, eax
.rok:
    imul         rax, [rsp+A_ELS]
    mov          t3d, 1
    mov          t2q, [rsp+A_FDN]
    test         t2q, t2q
    cmovz        t2q, t3q
    xor          edx, edx
    div          t2q
    COL          CC
    mov          word [opq], 0x202c
    add          opq, 2
    COL          CW
    mov          byte [opq], '-'
    inc          opq
    cmp          rax, 356400
    jae          .etamax
    DIVC         3600
    mov          t4q, rdx
    D2
    COL          CP
    mov          byte [opq], ':'
    inc          opq
    COL          CW
    mov          rax, t4q
    DIVC         60
    D2
    jmp          .etadone
.etamax:
    mov          dword [opq], 0x393a3939
    mov          byte [opq+4], '9'
    add          opq, 5
.etadone:
    COL          CC
    mov          word [opq], 0x202c
    add          opq, 2
    COL          CB
    cmp          qword [rsp+A_CFR], 0
    je           .nosz
    cvtsi2ss     xmm1, dword [dwsq+D_FD]
    cvtsi2ss     xmm2, dword [dwsq+D_FN]
    cvtsi2ss     xmm0, qword [rsp+A_CFR]
    mulss        xmm0, xmm1
    divss        xmm0, xmm2
    cvtsi2ss     xmm3, qword [rsp+A_TSZ]
    mulss        xmm3, [ps_eig]
    divss        xmm3, xmm0
    divss        xmm3, [ps_1k]
    cvtsi2ss     xmm4, qword [dwsq+D_TFR]
    mulss        xmm4, xmm1
    divss        xmm4, xmm2
    mulss        xmm4, xmm3
    mulss        xmm4, [ps_1k]
    divss        xmm4, [ps_eig]
    cvtss2si     rax, xmm3
    U3
    mov          byte [opq], 'k'
    inc          opq
    COL          CC
    mov          word [opq], 0x202c
    add          opq, 2
    COL          CR
    movaps       xmm0, xmm4
    comiss       xmm4, [ps_1e9]
    jbe          .meg
    divss        xmm0, [ps_1e9]
    F1N
    mov          byte [opq], 'g'
    inc          opq
    jmp          .fin
.meg:
    divss        xmm0, [ps_1e6]
    F1N
    mov          byte [opq], 'm'
    inc          opq
    jmp          .fin
.nosz:
    mov          word [opq], 0x6b30
    add          opq, 2
    COL          CC
    mov          word [opq], 0x202c
    add          opq, 2
    COL          CR
    mov          word [opq], 0x6d30
    add          opq, 2
.fin:
    COL          CC
    mov          dword [opq], CN
    mov          word [opq+4], 0x0a29
    add          opq, 6
    mov          rsi, [dwsq+D_BUF]
    mov          rdx, opq
    sub          rdx, rsi
    PWRITE
    VZU
    add          rsp, AFRSZ
    RET
.slib:
    cmp          dword [bp1q+S_CNT], 0
    je           .slibf
    mov          t1q, [bp1q+S_ENC]
    mov          t2q, t1q
    xchg         [bp1q+S_FLU], t2q
    sub          t1q, t2q
    mov          t3q, [dwsq+D_PRC]
    db           0xf0
    add          [t3q], t1q
.slibf:
    FMTSLOT      CP, QBHASH, QYDASH, CP, bar_by, lit_b1, lit_c1
    jmp          .bnext
.smet:
    FMTSLOT      0, QHASH, QDASH, CC, bar_gr, lit_b2, lit_c2
    jmp          .bnext
.stxt:
    xor          eax, eax
    mov          ecx, 1
    lock cmpxchg dword [bp1q+S_LK], ecx
    jnz          .tslow
.thave:
    mov          t1q, [bp1q+S_LEN]
    test         t1q, t1q
    jz           .tempty
    lea          t2q, [bp1q+S_BUF]
    lea          t3q, [opq+t1q]
.tcp:
    vmovdqu      ymm0, [t2q]
    vmovdqu      [opq], ymm0
    add          t2q, 32
    add          opq, 32
    sub          t1q, 32
    jg           .tcp
    mov          opq, t3q
.tempty:
    xor          eax, eax
    xchg         [bp1q+S_LK], eax
    cmp          eax, 2
    je           .twake
    jmp          .bnext
.twake:
    PWAKE        [bp1q+S_LK]
    jmp          .bnext
.tslow:
    mov          eax, SPINS
.tspin:
    pause
    cmp          dword [bp1q+S_LK], 1
    jne          .ttry
    dec          eax
    jnz          .tspin
.ttry:
    xor          eax, eax
    mov          ecx, 1
    lock cmpxchg dword [bp1q+S_LK], ecx
    jz           .thave
.twloop:
    mov          eax, 2
    xchg         [bp1q+S_LK], eax
    test         eax, eax
    jz           .thave
    PWAIT        [bp1q+S_LK]
    jmp          .twloop
    PADSUB
    ITOASUB
