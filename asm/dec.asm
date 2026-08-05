%include "dav1d_x86inc.asm"

SECTION .text align=64
INIT_XMM avx2

cextern_naked avcodec_receive_frame
cextern_naked avcodec_send_packet
cextern_naked av_read_frame
cextern_naked av_packet_unref
cextern_naked av_hwframe_transfer_data

%define D_FMT   0
%define D_CODEC 8
%define D_PKT   16
%define D_FRAME 24
%define D_SW    32
%define D_SIDX  48
%define D_NEXT  56
%define D_EOF   64
%define P_SIDX  36
%define E_EOF   -541478725
%define E_AGAIN -11

%macro DECN 2
cglobal %1, 1, 15, 0, dc, a1, a2, a3, a4, a5, ax, t1, t2, cc, fr, pk, fm, si, sv
    sub          rsp, 8
    mov          [rsp], dcq
    mov          ccq, [dcq+D_CODEC]
    mov          frq, [dcq+D_FRAME]
    mov          pkq, [dcq+D_PKT]
    mov          fmq, [dcq+D_FMT]
    mov          sid, [dcq+D_SIDX]
.outer:
    mov          dcq, ccq
    mov          a1q, frq
    call         avcodec_receive_frame
    test         eax, eax
    jz           .got
    cmp          eax, E_EOF
    je           .iseof
.read:
    mov          dcq, fmq
    mov          a1q, pkq
    call         av_read_frame
    test         eax, eax
    js           .flush
    cmp          sid, [pkq+P_SIDX]
    jne          .drop
    mov          dcq, ccq
    mov          a1q, pkq
    call         avcodec_send_packet
    mov          svd, eax
    mov          dcq, pkq
    call         av_packet_unref
    cmp          svd, E_AGAIN
    jne          .outer
    mov          dcq, ccq
    mov          a1q, frq
    call         avcodec_receive_frame
    test         eax, eax
    jnz          .read
.got:
    mov          t1q, [rsp]
    inc          qword [t1q+D_NEXT]
%if %2
    mov          dcq, [t1q+D_SW]
    mov          a1q, frq
    xor          a2d, a2d
    call         av_hwframe_transfer_data
    mov          t1q, [rsp]
    mov          axq, [t1q+D_SW]
%else
    mov          axq, frq
%endif
    add          rsp, 8
    RET
.drop:
    mov          dcq, pkq
    call         av_packet_unref
    jmp          .read
.flush:
    mov          dcq, ccq
    xor          a1d, a1d
    call         avcodec_send_packet
    jmp          .outer
.iseof:
    mov          t1q, [rsp]
    mov          byte [t1q+D_EOF], 1
    mov          axq, frq
    add          rsp, 8
    RET
%endmacro

DECN dec_next,    0
DECN dec_next_hw, 1
