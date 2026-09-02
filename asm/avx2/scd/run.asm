%include "dav1d_x86inc.asm"

SECTION_RODATA 64
pd_i8:  dq 7.0
pd_i10: dq 8.75

SECTION .text align=64
INIT_XMM avx2

cextern spsc_recv
cextern refine
cextern scd_step
cextern scd_step16
cextern scd_step16s
cextern_naked av_frame_free

%define D_HEAD 1920
%define D_LEN  1928
%define D_OFF  1936
%define D_NPIX 1944
%define D_ITHR 1952
%define D_WB   1960
%define D_HB   1968
%define D_SZ   1976
%define W_AV   0
%define W_DATA 64
%define W_STR  128
%define W_HEAD 192
%define W_LEN  200
%define SLACK  32
%define LOOK   5
%define WNEG   0xBF800000
%if WIN64
%define SHD 48
%else
%define SHD 0
%endif
%define FRM (2312+SHD)

%macro POPF 0
    mov          t1q, [wnpq+W_HEAD]
    lea          rgq, [wnpq+W_AV+t1q*8]
    call         av_frame_free
    mov          t1q, [wnpq+W_HEAD]
    inc          t1q
    and          t1q, 7
    mov          [wnpq+W_HEAD], t1q
    dec          qword [wnpq+W_LEN]
%endmacro

%macro RUN 4
cglobal %1, 6, 15, 2, rg, dm, tt, kf, wt, ot, ax, t1, t2, dqp, wnp, fno, nin, kfp, t3
    sub          rsp, FRM
    mov          [rsp+SHD+0], rgq
    mov          [rsp+SHD+8], ttq
    mov          [rsp+SHD+16], wtq
    mov          [rsp+SHD+40], kfq
    mov          [rsp+SHD+56], otq
    mov          kfpq, kfq
    mov          qword [kfpq], 0
    add          kfpq, 8
    mov          t1q, dmq
    shr          t1q, 16
    movzx        t1d, t1w
    mov          [rsp+SHD+24], t1q
    movzx        t1d, dmw
    imul         t1q, t1q, %3
    mov          [rsp+SHD+32], t1q
    mov          rdi, wtq
    mov          rcx, ttq
    mov          eax, WNEG
    rep stosd
    lea          dqpq, [rsp+SHD+127]
    and          dqpq, -64
    lea          wnpq, [dqpq+D_SZ]
    mov          rdi, dqpq
    xor          eax, eax
    mov          ecx, D_SZ/8
    rep stosq
    mov          t1q, dmq
    shr          t1q, 51
    mov          [dqpq+D_WB], t1q
    mov          t2q, dmq
    shr          t2q, 32
    movzx        t2d, t2w
    shr          t2d, 3
    mov          [dqpq+D_HB], t2q
    imul         t1q, t2q
    vcvtsi2sd    xmm0, xmm0, t1q
    vmovsd       [dqpq+D_NPIX], xmm0
    vmovsd       xmm1, [%4]
    vmovsd       [dqpq+D_ITHR], xmm1
    mov          qword [dqpq+D_HEAD], SLACK
    mov          qword [dqpq+D_OFF], LOOK
    mov          qword [wnpq+W_HEAD], 0
    mov          qword [wnpq+W_LEN], 0
    xor          fnod, fnod
    xor          nind, nind
.loop:
    lea          t1q, [fnoq+LOOK+1]
    mov          t2q, [rsp+SHD+8]
    cmp          t1q, t2q
    cmova        t1q, t2q
    mov          [rsp+SHD+48], t1q
.recv:
    cmp          ninq, [rsp+SHD+48]
    jae          .rdone
    mov          rgq, [rsp+SHD+0]
    call         xav_spsc_recv
    test         axq, axq
    jz           .rdone
    mov          t1q, [wnpq+W_HEAD]
    add          t1q, [wnpq+W_LEN]
    and          t1q, 7
    movsxd       t2q, dword [axq+64]
    mov          [wnpq+W_AV+t1q*8], axq
    mov          [wnpq+W_STR+t1q*8], t2q
    mov          t3q, [rsp+SHD+24]
    imul         t3q, t2q
    add          t3q, [rsp+SHD+32]
    add          t3q, [axq]
    mov          [wnpq+W_DATA+t1q*8], t3q
    inc          qword [wnpq+W_LEN]
    inc          ninq
    jmp          .recv
.rdone:
    mov          t1q, [wnpq+W_LEN]
    mov          t2d, LOOK+2
    cmp          t1q, t2q
    cmova        t1q, t2q
    cmp          t1q, 2
    jb           .done
    test         fnoq, fnoq
    jz           .next
    mov          rgq, dqpq
    mov          dmq, wnpq
    mov          ttq, t1q
    mov          kfq, fnoq
    mov          wtq, [rsp+SHD+16]
%if WIN64
    mov          [rsp+32], wtq
%endif
    call         %2
    test         axq, axq
    jz           .nocut
    mov          [kfpq], fnoq
    add          kfpq, 8
.nocut:
    POPF
.next:
    inc          fnoq
    jmp          .loop
.done:
    cmp          qword [wnpq+W_LEN], 0
    je           .fin
    POPF
    jmp          .done
.fin:
    mov          axq, kfpq
    sub          axq, [rsp+SHD+40]
    shr          axq, 3
    mov          rgq, [rsp+SHD+40]
    mov          dmq, axq
    mov          ttq, [rsp+SHD+8]
    mov          kfq, [rsp+SHD+16]
    mov          wtq, [rsp+SHD+56]
%if WIN64
    mov          [rsp+32], wtq
%endif
    call         xav_refine
    add          rsp, FRM
    RET
%endmacro

RUN scd_run,    xav_scd_step,    1, pd_i8
RUN scd_run16,  xav_scd_step16,  2, pd_i10
RUN scd_run16s, xav_scd_step16s, 2, pd_i10
