%include "dav1d_x86inc.asm"

SECTION_RODATA 16
lbl: db "CROP"

SECTION .text
INIT_XMM avx2

cextern_naked av_seek_frame
cextern_naked avcodec_flush_buffers
cextern dec_next
cextern pb_init
cextern pb_frames
cextern calc_samp_frames
cextern crop_frame_u8
cextern crop_frame_u16

%define D_FMT    0
%define D_CODEC  8
%define D_FRAME  24
%define D_SIDX   48
%define D_EOF    64
%define D_TSMUL  72
%define D_TSDIV  80
%define D_SPTS   88
%define F_DATA   0
%define F_LINESZ 64

%define S_BUF   0
%define S_PB    64
%define S_BEST  120
%define S_DC    136
%define S_W     144
%define S_H     152
%define S_10B   160
%define S_LINE  168
%define S_OUT   176
%define S_N     184

cglobal crop_detect, 7, 12, 8, 192, dc, frames, w, h, is10b, line, out, a, b, i, t, k
    mov       [rsp + S_DC], dcq
    mov       [rsp + S_W], wq
    mov       [rsp + S_H], hq
    mov       [rsp + S_10B], is10bq
    mov       [rsp + S_LINE], lineq
    mov       [rsp + S_OUT], outq
    mov       tq, -1
    mov       [rsp + S_BEST], tq
    mov       [rsp + S_BEST + 8], tq
    cmp       framesq, 13
    ja        .many
    mov       [rsp + S_N], framesq
    xor       iq, iq
.fill:
    cmp       iq, framesq
    jae       .init
    mov       [rsp + S_BUF + iq*4], id
    inc       iq
    jmp       .fill
.many:
    mov       qword [rsp + S_N], 13
    mov       edi, framesd
    lea       rsi, [rsp + S_BUF]
    call      calc_samp_frames
.init:
    lea       rdi, [rsp + S_PB]
    call      pb_init
    xor       iq, iq
.loop:
    cmp       iq, [rsp + S_N]
    jae       .fin
    mov       tq, [rsp + S_DC]
    mov       eax, [rsp + S_BUF + iq*4]
    imul      rax, [tq + D_TSMUL]
    cqo
    idiv      qword [tq + D_TSDIV]
    add       rax, [tq + D_SPTS]
    mov       rdx, rax
    mov       rdi, [tq + D_FMT]
    mov       esi, [tq + D_SIDX]
    mov       ecx, 1
    call      av_seek_frame
    mov       tq, [rsp + S_DC]
    mov       rdi, [tq + D_CODEC]
    call      avcodec_flush_buffers
    mov       tq, [rsp + S_DC]
    mov       byte [tq + D_EOF], 0
    mov       rdi, tq
    call      dec_next
    mov       tq, [rsp + S_DC]
    mov       kq, [tq + D_FRAME]
    mov       rdi, [kq + F_DATA]
    mov       rsi, [rsp + S_W]
    mov       rdx, [rsp + S_H]
    movsxd    rcx, dword [kq + F_LINESZ]
    lea       is10bq, [rsp + S_BEST]
    cmp       qword [rsp + S_10B], 0
    jne       .hi
    call      crop_frame_u8
    jmp       .after
.hi:
    call      crop_frame_u16
.after:
    test      eax, eax
    jnz       .fin
    lea       rdi, [rsp + S_PB]
    lea       rsi, [iq + 1]
    mov       rdx, [rsp + S_N]
    mov       rcx, [rsp + S_LINE]
    lea       is10bq, [rel lbl]
    mov       lined, 4
    call      pb_frames
    inc       iq
    jmp       .loop
.fin:
    mov       aq, [rsp + S_OUT]
    mov       ebx, [rsp + S_BEST]
    cmp       ebx, -1
    je        .nocrop
    vmovdqu   xmm0, [rsp + S_BEST]
    vpcmpeqd  xmm1, xmm1, xmm1
    vpslld    xmm1, xmm1, 1
    vpand     xmm0, xmm0, xmm1
    vmovdqu   [aq], xmm0
    RET
.nocrop:
    vpxor     xmm0, xmm0, xmm0
    vmovdqu   [aq], xmm0
    RET
