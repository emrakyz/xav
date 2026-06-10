%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
k_r128:    dq 0x1e88ef372, 0x14a7fe880
ALIGN 16
k_r64:     dq 0x154442bd4, 0x1c6e41596
k_r16:     dq 0x1751997d0, 0x0ccaa009e
k_5:       dq 0x163cd6124, 0
barrett:   dq 0x1DB710641, 0x1F7011641
mask32:    dq 0xFFFFFFFF, 0

%macro CRC32_T0_OF 1
    %assign __t0 %1
    %rep 8
        %if __t0 & 1
            %assign __t0 (__t0 >> 1) ^ 0xEDB88320
        %else
            %assign __t0 (__t0 >> 1)
        %endif
    %endrep
%endmacro

ALIGN 64
crc_table:
%assign i 0
%rep 256
    CRC32_T0_OF i
    dd __t0
    %assign i i + 1
%endrep
%assign i 0
%rep 256
    CRC32_T0_OF i
    %assign __c __t0
    CRC32_T0_OF (__c & 0xFF)
    dd ((__c >> 8) ^ __t0)
    %assign i i + 1
%endrep
%assign i 0
%rep 256
    CRC32_T0_OF i
    %assign __c __t0
    CRC32_T0_OF (__c & 0xFF)
    %assign __t1 ((__c >> 8) ^ __t0)
    CRC32_T0_OF (__t1 & 0xFF)
    dd ((__t1 >> 8) ^ __t0)
    %assign i i + 1
%endrep
%assign i 0
%rep 256
    CRC32_T0_OF i
    %assign __c __t0
    CRC32_T0_OF (__c & 0xFF)
    %assign __t1 ((__c >> 8) ^ __t0)
    CRC32_T0_OF (__t1 & 0xFF)
    %assign __t2 ((__t1 >> 8) ^ __t0)
    CRC32_T0_OF (__t2 & 0xFF)
    dd ((__t2 >> 8) ^ __t0)
    %assign i i + 1
%endrep

%macro PRELOAD_CONSTS 0
    vmovdqa         xmm10, [rel k_r16]
    vmovdqa         xmm11, [rel mask32]
    vmovdqa         xmm12, [rel barrett]
%endmacro

%macro CRC32_BYTES 2
    cmp             %2, 4
    jb              %%tail
%%slice4_loop:
    mov             ebx, [%1]
    xor             ebx, eax
    movzx           edi, bl
    mov             eax, [R10 + 3072 + rdi*4]
    movzx           edi, bh
    xor             eax, [R10 + 2048 + rdi*4]
    shr             ebx, 16
    movzx           edi, bl
    xor             eax, [R10 + 1024 + rdi*4]
    movzx           edi, bh
    xor             eax, [R10 + rdi*4]
    add             %1, 4
    sub             %2, 4
    cmp             %2, 4
    jae             %%slice4_loop
%%tail:
    test            %2, %2
    jz              %%done
%%byte_loop:
    movzx           edi, byte [%1]
    xor             dil, al
    movzx           edi, dil
    shr             eax, 8
    xor             eax, [R10 + rdi*4]
    inc             %1
    dec             %2
    jnz             %%byte_loop
%%done:
%endmacro

%macro CRC32_FRAME 0
    cmp             R8, 128
    jb              %%cold_dispatch

    vmovdqu         ymm0, [rcx]
    vmovdqu         ymm1, [rcx + 32]
    vmovdqu         ymm2, [rcx + 64]
    vmovdqu         ymm3, [rcx + 96]
    vmovd           xmm14, eax
    vpxor           ymm0, ymm0, ymm14
    add             rcx, 128
    sub             R8, 128
    cmp             R8, 128
    jb              %%reduce_4to2

    vbroadcasti128  ymm9, [rel k_r128]

ALIGN 32
%%ymm_loop_128:
    vpclmulqdq      ymm4, ymm0, ymm9, 0x00
    vpclmulqdq      ymm5, ymm1, ymm9, 0x00
    vpclmulqdq      ymm6, ymm2, ymm9, 0x00
    vpclmulqdq      ymm7, ymm3, ymm9, 0x00
    vpclmulqdq      ymm0, ymm0, ymm9, 0x11
    vpclmulqdq      ymm1, ymm1, ymm9, 0x11
    vpclmulqdq      ymm2, ymm2, ymm9, 0x11
    vpclmulqdq      ymm3, ymm3, ymm9, 0x11
    vpxor           ymm4, ymm4, [rcx + 0]
    vpxor           ymm5, ymm5, [rcx + 32]
    vpxor           ymm6, ymm6, [rcx + 64]
    vpxor           ymm7, ymm7, [rcx + 96]
    vpxor           ymm0, ymm0, ymm4
    vpxor           ymm1, ymm1, ymm5
    vpxor           ymm2, ymm2, ymm6
    vpxor           ymm3, ymm3, ymm7
    add             rcx, 128
    sub             R8, 128
    cmp             R8, 128
    jae             %%ymm_loop_128

%%reduce_4to2:
    vbroadcasti128  ymm9, [rel k_r64]
    vpclmulqdq      ymm4, ymm0, ymm9, 0x00
    vpclmulqdq      ymm5, ymm1, ymm9, 0x00
    vpclmulqdq      ymm0, ymm0, ymm9, 0x11
    vpclmulqdq      ymm1, ymm1, ymm9, 0x11
    vpxor           ymm0, ymm0, ymm4
    vpxor           ymm1, ymm1, ymm5
    vpxor           ymm0, ymm0, ymm2
    vpxor           ymm1, ymm1, ymm3

%%ymm_64_check:
    cmp             R8, 64
    jb              %%ymm_reduce

ALIGN 32
%%ymm_loop_64:
    vpclmulqdq      ymm4, ymm0, ymm9, 0x00
    vpclmulqdq      ymm5, ymm1, ymm9, 0x00
    vpclmulqdq      ymm0, ymm0, ymm9, 0x11
    vpclmulqdq      ymm1, ymm1, ymm9, 0x11
    vpxor           ymm4, ymm4, [rcx + 0]
    vpxor           ymm5, ymm5, [rcx + 32]
    vpxor           ymm0, ymm0, ymm4
    vpxor           ymm1, ymm1, ymm5
    add             rcx, 64
    sub             R8, 64
    cmp             R8, 64
    jae             %%ymm_loop_64

%%ymm_reduce:
    vextracti128    xmm4, ymm0, 0
    vextracti128    xmm5, ymm0, 1
    vextracti128    xmm6, ymm1, 0
    vextracti128    xmm7, ymm1, 1

    vpclmulqdq      xmm2, xmm4, xmm10, 0x00
    vpclmulqdq      xmm3, xmm4, xmm10, 0x11
    vpxor           xmm2, xmm2, xmm3
    vpxor           xmm0, xmm2, xmm5

    vpclmulqdq      xmm2, xmm0, xmm10, 0x00
    vpclmulqdq      xmm3, xmm0, xmm10, 0x11
    vpxor           xmm2, xmm2, xmm3
    vpxor           xmm0, xmm2, xmm6

    vpclmulqdq      xmm2, xmm0, xmm10, 0x00
    vpclmulqdq      xmm3, xmm0, xmm10, 0x11
    vpxor           xmm2, xmm2, xmm3
    vpxor           xmm0, xmm2, xmm7

    cmp             R8, 16
    jb              %%xmm_reduce

ALIGN 16
%%xmm_continue:
    vpclmulqdq      xmm2, xmm0, xmm10, 0x00
    vpclmulqdq      xmm3, xmm0, xmm10, 0x11
    vpxor           xmm2, xmm2, xmm3
    vpxor           xmm0, xmm2, [rcx]
    add             rcx, 16
    sub             R8, 16
    cmp             R8, 16
    jae             %%xmm_continue

%%xmm_reduce:
    vpclmulqdq      xmm2, xmm0, xmm10, 0x10
    vpsrldq         xmm0, xmm0, 8
    vpxor           xmm0, xmm0, xmm2

    vpand           xmm2, xmm0, xmm11
    vpclmulqdq      xmm2, xmm2, [rel k_5], 0x00
    vpsrldq         xmm0, xmm0, 4
    vpxor           xmm0, xmm0, xmm2

    vpand           xmm2, xmm0, xmm11
    vpclmulqdq      xmm2, xmm2, xmm12, 0x10
    vpand           xmm3, xmm2, xmm11
    vpclmulqdq      xmm3, xmm3, xmm12, 0x00
    vpxor           xmm0, xmm0, xmm3
    vpextrd         eax, xmm0, 1
    test            R8, R8
    jz              %%done

%%bytes:
    CRC32_BYTES     rcx, R8

%%done:
    jmp             %%end_frame

%%cold_dispatch:
    test            R8, R8
    jz              %%end_frame
    cmp             R8, 16
    jb              %%cold_bytes
    cmp             R8, 64
    jb              %%xmm_init

    vmovdqu         ymm0, [rcx]
    vmovdqu         ymm1, [rcx + 32]
    vmovd           xmm14, eax
    vpxor           ymm0, ymm0, ymm14
    add             rcx, 64
    sub             R8, 64
    vbroadcasti128  ymm9, [rel k_r64]
    jmp             %%ymm_64_check

%%xmm_init:
    vmovdqu         xmm0, [rcx]
    vmovd           xmm14, eax
    vpxor           xmm0, xmm0, xmm14
    add             rcx, 16
    sub             R8, 16
    cmp             R8, 16
    jb              %%xmm_reduce
ALIGN 16
%%xmm_loop:
    vpclmulqdq      xmm2, xmm0, xmm10, 0x00
    vpclmulqdq      xmm3, xmm0, xmm10, 0x11
    vpxor           xmm2, xmm2, xmm3
    vpxor           xmm0, xmm2, [rcx]
    add             rcx, 16
    sub             R8, 16
    cmp             R8, 16
    jae             %%xmm_loop
    jmp             %%xmm_reduce

%%cold_bytes:
    jmp             %%bytes

%%end_frame:
%endmacro

SECTION .text
INIT_YMM avx2

cglobal crc32_avx2_update, 3, 10, 16, state, src, len
    mov             eax, stated
    mov             rcx, srcq
    mov             R8, lenq
    lea             R10, [rel crc_table]
    PRELOAD_CONSTS
    CRC32_FRAME
    vzeroupper
    RET

%macro CRC32_COPY_BYTES 3
    cmp             %2, 4
    jb              %%tail
%%slice4_loop:
    mov             ebx, [%1]
    mov             [%3], ebx
    xor             ebx, eax
    movzx           edi, bl
    mov             eax, [R10 + 3072 + rdi*4]
    movzx           edi, bh
    xor             eax, [R10 + 2048 + rdi*4]
    shr             ebx, 16
    movzx           edi, bl
    xor             eax, [R10 + 1024 + rdi*4]
    movzx           edi, bh
    xor             eax, [R10 + rdi*4]
    add             %1, 4
    add             %3, 4
    sub             %2, 4
    cmp             %2, 4
    jae             %%slice4_loop
%%tail:
    test            %2, %2
    jz              %%done
%%byte_loop:
    movzx           edi, byte [%1]
    mov             [%3], dil
    xor             dil, al
    movzx           edi, dil
    shr             eax, 8
    xor             eax, [R10 + rdi*4]
    inc             %1
    inc             %3
    dec             %2
    jnz             %%byte_loop
%%done:
%endmacro

cglobal crc32_avx2_copy_nt, 4, 10, 16, state, src, dst, len
%if WIN64
    mov             eax, stated
    mov             rcx, srcq
    mov             rdx, dstq
    mov             R8, lenq
%else
    mov             eax, stated
    mov             R8, lenq
    mov             rcx, srcq
%endif
    lea             R10, [rel crc_table]
    PRELOAD_CONSTS
    test            R8, R8
    jz              .done
    mov             R9, rdx
    neg             R9
    and             R9, 31
    jz              .frame
    cmp             R9, R8
    cmova           R9, R8
    sub             R8, R9
    CRC32_COPY_BYTES rcx, R9, rdx
.frame:
    test            R8, R8
    jz              .done
    cmp             R8, 128
    jb              .cold_dispatch

    vmovdqu         ymm0, [rcx]
    vmovdqu         ymm1, [rcx + 32]
    vmovdqu         ymm2, [rcx + 64]
    vmovdqu         ymm3, [rcx + 96]
    vmovntdq        [rdx],      ymm0
    vmovntdq        [rdx + 32], ymm1
    vmovntdq        [rdx + 64], ymm2
    vmovntdq        [rdx + 96], ymm3
    vmovd           xmm14, eax
    vpxor           ymm0, ymm0, ymm14
    add             rcx, 128
    add             rdx, 128
    sub             R8, 128
    cmp             R8, 128
    jb              .reduce_4to2

    vbroadcasti128  ymm9, [rel k_r128]
ALIGN 32
.ymm_loop_128:
    vmovdqu         ymm8,  [rcx + 0]
    vmovdqu         ymm13, [rcx + 32]
    vmovdqu         ymm14, [rcx + 64]
    vmovdqu         ymm15, [rcx + 96]
    vmovntdq        [rdx + 0],  ymm8
    vmovntdq        [rdx + 32], ymm13
    vmovntdq        [rdx + 64], ymm14
    vmovntdq        [rdx + 96], ymm15
    vpclmulqdq      ymm4, ymm0, ymm9, 0x00
    vpclmulqdq      ymm5, ymm1, ymm9, 0x00
    vpclmulqdq      ymm6, ymm2, ymm9, 0x00
    vpclmulqdq      ymm7, ymm3, ymm9, 0x00
    vpclmulqdq      ymm0, ymm0, ymm9, 0x11
    vpclmulqdq      ymm1, ymm1, ymm9, 0x11
    vpclmulqdq      ymm2, ymm2, ymm9, 0x11
    vpclmulqdq      ymm3, ymm3, ymm9, 0x11
    vpxor           ymm4, ymm4, ymm8
    vpxor           ymm5, ymm5, ymm13
    vpxor           ymm6, ymm6, ymm14
    vpxor           ymm7, ymm7, ymm15
    vpxor           ymm0, ymm0, ymm4
    vpxor           ymm1, ymm1, ymm5
    vpxor           ymm2, ymm2, ymm6
    vpxor           ymm3, ymm3, ymm7
    add             rcx, 128
    add             rdx, 128
    sub             R8, 128
    cmp             R8, 128
    jae             .ymm_loop_128

.reduce_4to2:
    vbroadcasti128  ymm9, [rel k_r64]
    vpclmulqdq      ymm4, ymm0, ymm9, 0x00
    vpclmulqdq      ymm5, ymm1, ymm9, 0x00
    vpclmulqdq      ymm0, ymm0, ymm9, 0x11
    vpclmulqdq      ymm1, ymm1, ymm9, 0x11
    vpxor           ymm0, ymm0, ymm4
    vpxor           ymm1, ymm1, ymm5
    vpxor           ymm0, ymm0, ymm2
    vpxor           ymm1, ymm1, ymm3

.ymm_64_check:
    cmp             R8, 64
    jb              .ymm_reduce
ALIGN 32
.ymm_loop_64:
    vmovdqu         ymm8,  [rcx + 0]
    vmovdqu         ymm13, [rcx + 32]
    vmovntdq        [rdx + 0],  ymm8
    vmovntdq        [rdx + 32], ymm13
    vpclmulqdq      ymm4, ymm0, ymm9, 0x00
    vpclmulqdq      ymm5, ymm1, ymm9, 0x00
    vpclmulqdq      ymm0, ymm0, ymm9, 0x11
    vpclmulqdq      ymm1, ymm1, ymm9, 0x11
    vpxor           ymm4, ymm4, ymm8
    vpxor           ymm5, ymm5, ymm13
    vpxor           ymm0, ymm0, ymm4
    vpxor           ymm1, ymm1, ymm5
    add             rcx, 64
    add             rdx, 64
    sub             R8, 64
    cmp             R8, 64
    jae             .ymm_loop_64

.ymm_reduce:
    vextracti128    xmm4, ymm0, 0
    vextracti128    xmm5, ymm0, 1
    vextracti128    xmm6, ymm1, 0
    vextracti128    xmm7, ymm1, 1
    vpclmulqdq      xmm2, xmm4, xmm10, 0x00
    vpclmulqdq      xmm3, xmm4, xmm10, 0x11
    vpxor           xmm2, xmm2, xmm3
    vpxor           xmm0, xmm2, xmm5
    vpclmulqdq      xmm2, xmm0, xmm10, 0x00
    vpclmulqdq      xmm3, xmm0, xmm10, 0x11
    vpxor           xmm2, xmm2, xmm3
    vpxor           xmm0, xmm2, xmm6
    vpclmulqdq      xmm2, xmm0, xmm10, 0x00
    vpclmulqdq      xmm3, xmm0, xmm10, 0x11
    vpxor           xmm2, xmm2, xmm3
    vpxor           xmm0, xmm2, xmm7
    cmp             R8, 16
    jb              .xmm_reduce
ALIGN 16
.xmm_continue:
    vmovdqu         xmm8, [rcx]
    vmovntdq        [rdx], xmm8
    vpclmulqdq      xmm2, xmm0, xmm10, 0x00
    vpclmulqdq      xmm3, xmm0, xmm10, 0x11
    vpxor           xmm2, xmm2, xmm3
    vpxor           xmm0, xmm2, xmm8
    add             rcx, 16
    add             rdx, 16
    sub             R8, 16
    cmp             R8, 16
    jae             .xmm_continue

.xmm_reduce:
    vpclmulqdq      xmm2, xmm0, xmm10, 0x10
    vpsrldq         xmm0, xmm0, 8
    vpxor           xmm0, xmm0, xmm2
    vpand           xmm2, xmm0, xmm11
    vpclmulqdq      xmm2, xmm2, [rel k_5], 0x00
    vpsrldq         xmm0, xmm0, 4
    vpxor           xmm0, xmm0, xmm2
    vpand           xmm2, xmm0, xmm11
    vpclmulqdq      xmm2, xmm2, xmm12, 0x10
    vpand           xmm3, xmm2, xmm11
    vpclmulqdq      xmm3, xmm3, xmm12, 0x00
    vpxor           xmm0, xmm0, xmm3
    vpextrd         eax, xmm0, 1
    test            R8, R8
    jz              .done
.bytes:
    CRC32_COPY_BYTES rcx, R8, rdx
.done:
    vzeroupper
    RET

.cold_dispatch:
    test            R8, R8
    jz              .done
    cmp             R8, 16
    jb              .bytes
    cmp             R8, 64
    jb              .xmm_init
    vmovdqu         ymm0, [rcx]
    vmovdqu         ymm1, [rcx + 32]
    vmovntdq        [rdx],      ymm0
    vmovntdq        [rdx + 32], ymm1
    vmovd           xmm14, eax
    vpxor           ymm0, ymm0, ymm14
    add             rcx, 64
    add             rdx, 64
    sub             R8, 64
    vbroadcasti128  ymm9, [rel k_r64]
    jmp             .ymm_64_check
.xmm_init:
    vmovdqu         xmm0, [rcx]
    vmovntdq        [rdx], xmm0
    vmovd           xmm14, eax
    vpxor           xmm0, xmm0, xmm14
    add             rcx, 16
    add             rdx, 16
    sub             R8, 16
    cmp             R8, 16
    jb              .xmm_reduce
ALIGN 16
.xmm_loop:
    vmovdqu         xmm8, [rcx]
    vmovntdq        [rdx], xmm8
    vpclmulqdq      xmm2, xmm0, xmm10, 0x00
    vpclmulqdq      xmm3, xmm0, xmm10, 0x11
    vpxor           xmm2, xmm2, xmm3
    vpxor           xmm0, xmm2, xmm8
    add             rcx, 16
    add             rdx, 16
    sub             R8, 16
    cmp             R8, 16
    jae             .xmm_loop
    jmp             .xmm_reduce
