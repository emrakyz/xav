%include "dav1d_x86inc.asm"

SECTION .text align=64
INIT_XMM avx2

cextern cost_sums
cextern cost_sums16
cextern cost_sums16_s
cextern scd_fill
cextern scd_frame
cextern scd_pred

%define D_LEN  1928
%define D_OFF  1936
%define D_WB   1960
%define D_HB   1968
%define W_DATA 64
%define W_STR  128
%define W_HEAD 192
%define LOOK   5

%macro STEP 2
cglobal %1, 5, 15, 0, dq, wn, sl, fn, wt, t0, ax, t1, t2, dqb, wnb, xi, cn, fnb, wtb
    sub          rsp, 56
    cmp          slq, LOOK
    jbe          .zero
    mov          dqbq, dqq
    mov          wnbq, wnq
    mov          fnbq, fnq
    mov          wtbq, wtq
    mov          [rsp+24], slq
    cmp          qword [dqbq+D_LEN], 0
    jne          .step
    mov          t1q, [dqbq+D_OFF]
    test         t1q, t1q
    jz           .all
    lea          t2q, [t1q+1]
    cmp          slq, t2q
    jbe          .all
    mov          cnq, t1q
    jmp          .fill
.all:
    lea          cnq, [slq-1]
    lea          t1q, [slq-2]
    mov          [dqbq+D_OFF], t1q
.fill:
    xor          xid, xid
.floop:
    mov          t0q, xiq
    call         .cost
    mov          dqq, dqbq
    mov          wnq, [rsp+0]
    mov          slq, [rsp+8]
    mov          fnq, [rsp+16]
    lea          wtq, [fnbq+xiq]
    call         xav_scd_fill
    inc          xiq
    cmp          xiq, cnq
    jb           .floop
.step:
    mov          t1q, [dqbq+D_OFF]
    mov          slq, [rsp+24]
    lea          t2q, [t1q+1]
    cmp          slq, t2q
    jbe          .pred
    mov          [rsp+32], t1q
    mov          t0q, t1q
    call         .cost
    mov          dqq, dqbq
    mov          wnq, [rsp+0]
    mov          slq, [rsp+8]
    mov          fnq, [rsp+16]
    mov          wtq, [rsp+32]
    add          wtq, fnbq
    call         xav_scd_frame
    jmp          .out
.pred:
    dec          t1q
    mov          [dqbq+D_OFF], t1q
    mov          dqq, dqbq
    call         xav_scd_pred
.out:
    mov          t1q, axq
    shr          t1q, 32
    mov          [wtbq+fnbq*4], t1d
    and          axq, 1
    add          rsp, 56
    RET
.zero:
    xor          eax, eax
    add          rsp, 56
    RET
.cost:
    mov          t1q, [wnbq+W_HEAD]
    add          t1q, t0q
    and          t1q, 7
    lea          t2q, [t1q+1]
    and          t2q, 7
    mov          dqq, [wnbq+W_DATA+t2q*8]
    mov          wnq, [wnbq+W_DATA+t1q*8]
    mov          slq, [wnbq+W_STR+t2q*8]
    mov          fnq, [dqbq+D_WB]
    mov          wtq, [dqbq+D_HB]
    lea          t0q, [rsp+8]
    jmp          %2
%endmacro

STEP scd_step,    xav_cost_sums
STEP scd_step16,  xav_cost_sums16
STEP scd_step16s, xav_cost_sums16_s
