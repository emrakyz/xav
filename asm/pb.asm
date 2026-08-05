%include "dav1d_x86inc.asm"

SECTION .text align=64
INIT_XMM avx2

%if WIN64
extern xav_plat_now
extern xav_plat_write
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

%define P_START  0
%define P_LAST   8
%define P_NEXT   16
%define P_TSCL   24
%define P_IVAL   32
%define P_CNT    40
%define P_STRIDE 44
%define P_CHECKS 48
%define IVAL_NS  512000000
%define NS_MS    1000000
%define NS_S     1000000000
%define CAL_HI   2000000000
%define KSH      4

cglobal pb_fire, 2, 11, 0, p, tk, a2, a3, a4, a5, ax, t1, t2, pp, tt
    sub          rsp, 24
    mov          ppq, pq
    mov          ttq, tkq
    PNOW         0
    mov          t1q, [rsp]
    imul         t1q, t1q, NS_S
    add          t1q, [rsp+8]
    mov          a3q, t1q
    sub          a3q, [ppq+P_LAST]
    cmp          a3q, NS_MS
    jb           .arm
    cmp          a3q, CAL_HI
    ja           .arm
    mov          axq, ttq
    sub          axq, [ppq+P_TSCL]
    imul         axq, axq, IVAL_NS
    xor          edx, edx
    div          a3q
    test         axq, axq
    cmovz        axq, [ppq+P_IVAL]
    mov          [ppq+P_IVAL], axq
.arm:
    mov          axq, [ppq+P_IVAL]
    add          axq, ttq
    mov          [ppq+P_NEXT], axq
    mov          [ppq+P_LAST], t1q
    mov          [ppq+P_TSCL], ttq
    mov          eax, [ppq+P_CHECKS]
    mov          t2d, [ppq+P_STRIDE]
    imul         axq, t2q
    shr          axq, KSH
    mov          t2d, 1
    test         eax, eax
    cmovz        eax, t2d
    mov          [ppq+P_STRIDE], eax
    mov          [ppq+P_CNT], eax
    mov          dword [ppq+P_CHECKS], 0
    mov          axq, t1q
    sub          axq, [ppq+P_START]
    xor          edx, edx
    mov          a3d, NS_S
    div          a3q
    add          rsp, 24
    RET

cglobal pb_init, 1, 11, 0, p, a1, a2, a3, a4, a5, ax, t1, t2, pp, tt
    sub          rsp, 24
    mov          ppq, pq
    rdtsc
    shl          rdx, 32
    or           rax, rdx
    mov          ttq, rax
    PINIT
    PNOW         0
    mov          axq, [rsp]
    imul         axq, axq, NS_S
    add          axq, [rsp+8]
    mov          [ppq+P_START], axq
    mov          [ppq+P_LAST], axq
    mov          [ppq+P_NEXT], ttq
    mov          [ppq+P_TSCL], ttq
    mov          qword [ppq+P_IVAL], IVAL_NS
    mov          dword [ppq+P_CNT], 1
    mov          dword [ppq+P_STRIDE], 1
    mov          dword [ppq+P_CHECKS], 0
    add          rsp, 24
    RET
