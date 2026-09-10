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

%if WIN64
    %define SHD 48
%else
    %define SHD 0
%endif

%define S_BUF   (SHD + 0)
%define S_PB    (SHD + 64)
%define S_BEST  (SHD + 120)
%define S_DC    (SHD + 136)
%define S_W     (SHD + 144)
%define S_H     (SHD + 152)
%define S_10B   (SHD + 160)
%define S_LINE  (SHD + 168)
%define S_OUT   (SHD + 176)
%define S_N     (SHD + 184)

cglobal crop_detect, 7, 12, 0, SHD + 192, dc, frames, w, h, is10b, line, out, a, b, i, t, k
    mov       [rsp + S_DC], dcq
    mov       [rsp + S_W], wq
    mov       [rsp + S_H], hq
    mov       [rsp + S_10B], is10bq
    mov       [rsp + S_LINE], lineq
    mov       [rsp + S_OUT], outq
    mov       tq, -1
    mov       [rsp + S_BEST], tq
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
    mov       dcd, framesd
    lea       framesq, [rsp + S_BUF]
    call      calc_samp_frames
.init:
    lea       dcq, [rsp + S_PB]
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
    mov       wq, rax
    mov       dcq, [tq + D_FMT]
    mov       framesd, [tq + D_SIDX]
    mov       hd, 1
    call      av_seek_frame
    mov       tq, [rsp + S_DC]
    mov       dcq, [tq + D_CODEC]
    call      avcodec_flush_buffers
    mov       tq, [rsp + S_DC]
    mov       byte [tq + D_EOF], 0
    mov       dcq, tq
    call      dec_next
    mov       tq, [rsp + S_DC]
    mov       kq, [tq + D_FRAME]
    mov       dcq, [kq + F_DATA]
    mov       framesq, [rsp + S_W]
    mov       wq, [rsp + S_H]
    movsxd    hq, dword [kq + F_LINESZ]
%if WIN64
    lea       tq, [rsp + S_BEST]
    mov       [rsp + 32], tq
%else
    lea       is10bq, [rsp + S_BEST]
%endif
    cmp       qword [rsp + S_10B], 0
    jne       .hi
    call      crop_frame_u8
    jmp       .after
.hi:
    call      crop_frame_u16
.after:
    test      eax, eax
    jz        .prog
    mov       iq, [rsp + S_N]
    dec       iq
.prog:
    lea       dcq, [rsp + S_PB]
    lea       framesq, [iq + 1]
    mov       wq, [rsp + S_N]
    mov       hq, [rsp + S_LINE]
%if WIN64
    lea       tq, [rel lbl]
    mov       [rsp + 32], tq
    mov       qword [rsp + 40], 4
%else
    lea       is10bq, [rel lbl]
    mov       lined, 4
%endif
    call      pb_frames
    inc       iq
    jmp       .loop
.fin:
    mov       aq, [rsp + S_OUT]
    mov       kq, [rsp + S_BEST]
    cmp       kd, -1
    je        .nocrop
    mov       tq, 0xFFFFFFFEFFFFFFFE
    and       kq, tq
    mov       [aq], kq
    RET
.nocrop:
    xor       kq, kq
    mov       [aq], kq
    RET
