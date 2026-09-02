%include "dav1d_x86inc.asm"

SECTION_RODATA 16
lab_scd: db "SCD"

SECTION .text align=64
INIT_XMM avx2

cextern dec_next
cextern dec_next_hw
cextern spsc_send
cextern spsc_close
cextern pb_fmt
cextern pb_frames
cextern_naked av_frame_alloc
cextern_naked av_frame_move_ref

%define D_EOF 64
%define P_CNT 40
%if WIN64
%define SHD 48
%else
%define SHD 0
%endif
%define FRM (24+SHD)

%macro FEED 2
cglobal %1, 5, 15, 0, dc, rg, tt, ln, pb, a5, ax, t1, t2, dcb, rgb, ttb, lnb, pbb, ib
    sub          rsp, FRM
    mov          dcbq, dcq
    mov          rgbq, rgq
    mov          ttbq, ttq
    mov          lnbq, lnq
    mov          pbbq, pbq
    xor          ibd, ibd
.loop:
    cmp          ibq, ttbq
    jae          .fin
    mov          dcq, dcbq
    call         %2
    cmp          byte [dcbq+D_EOF], 0
    jne          .fin
    mov          [rsp+SHD], axq
    call         av_frame_alloc
    mov          [rsp+SHD+8], axq
    mov          dcq, axq
    mov          rgq, [rsp+SHD]
    call         av_frame_move_ref
    mov          dcq, rgbq
    mov          rgq, [rsp+SHD+8]
    call         xav_spsc_send
    inc          ibq
    sub          dword [pbbq+P_CNT], 1
    jg           .loop
    mov          dcq, pbbq
    mov          rgq, ibq
    mov          ttq, ttbq
    mov          lnq, lnbq
    lea          pbq, [lab_scd]
    mov          a5d, 3
%if WIN64
    mov          [rsp+32], pbq
    mov          [rsp+40], a5q
%endif
    call         xav_pb_fmt
    jmp          .loop
.fin:
    mov          dcq, rgbq
    call         xav_spsc_close
    mov          dcq, pbbq
    mov          rgq, ttbq
    mov          ttq, ttbq
    mov          lnq, lnbq
    lea          pbq, [lab_scd]
    mov          a5d, 3
%if WIN64
    mov          [rsp+32], pbq
    mov          [rsp+40], a5q
%endif
    call         xav_pb_frames
    add          rsp, FRM
    RET
%endmacro

FEED scd_feed,    xav_dec_next
FEED scd_feed_hw, xav_dec_next_hw
