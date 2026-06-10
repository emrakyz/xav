%include "dav1d_x86inc.asm"

SECTION_RODATA 64
ALIGN 64
k_main:    dq 0x11542778a, 0x1322d1430
k_r192:    dq 0x1821d8bc0, 0x12e958ac4
k_r128:    dq 0x1e88ef372, 0x14a7fe880
k_r64:     dq 0x154442bd4, 0x1c6e41596
k_r32:     dq 0x0f1da05aa, 0x15a546366
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
    vbroadcasti32x4 zmm5,  [rel k_r192]
    vbroadcasti32x4 zmm6,  [rel k_r128]
    vbroadcasti32x4 zmm7,  [rel k_r64]
    vbroadcasti32x4 ymm24, [rel k_r32]
    vmovdqa         xmm25, [rel k_r16]
    vmovdqa         xmm26, [rel mask32]
    vmovdqa         xmm27, [rel barrett]
%endmacro

%macro CRC32_BYTES 2
    cmp             %2, 4
    jb              %%tail
%%slice4_loop:
    mov             R11D, [%1]
    xor             R11D, eax
    movzx           edi, R11B
    mov             eax, [R10 + 3072 + rdi*4]
    shr             R11D, 8
    movzx           edi, R11B
    xor             eax, [R10 + 2048 + rdi*4]
    shr             R11D, 8
    movzx           edi, R11B
    xor             eax, [R10 + 1024 + rdi*4]
    shr             R11D, 8
    movzx           edi, R11B
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
    test            R8, R8
    jz              %%done
    cmp             R8, 16
    jb              %%bytes
    cmp             R8, 256
    jb              %%xmm_init

    vmovdqu64       zmm0, [rcx +   0]
    vmovdqu64       zmm1, [rcx +  64]
    vmovdqu64       zmm2, [rcx + 128]
    vmovdqu64       zmm3, [rcx + 192]
    vmovd           xmm14, eax
    vpxorq          zmm0, zmm0, zmm14
    add             rcx, 256
    sub             R8, 256
    cmp             R8, 256
    jb              %%zmm_reduce

    vbroadcasti32x4 zmm4, [rel k_main]

ALIGN 32
%%zmm_loop:
    vpclmulqdq      zmm16, zmm0, zmm4, 0x00
    vpclmulqdq      zmm17, zmm1, zmm4, 0x00
    vpclmulqdq      zmm18, zmm2, zmm4, 0x00
    vpclmulqdq      zmm19, zmm3, zmm4, 0x00
    vpclmulqdq      zmm0, zmm0, zmm4, 0x11
    vpclmulqdq      zmm1, zmm1, zmm4, 0x11
    vpclmulqdq      zmm2, zmm2, zmm4, 0x11
    vpclmulqdq      zmm3, zmm3, zmm4, 0x11
    vpternlogq      zmm0, zmm16, [rcx +   0], 0x96
    vpternlogq      zmm1, zmm17, [rcx +  64], 0x96
    vpternlogq      zmm2, zmm18, [rcx + 128], 0x96
    vpternlogq      zmm3, zmm19, [rcx + 192], 0x96
    add             rcx, 256
    sub             R8, 256
    cmp             R8, 256
    jae             %%zmm_loop

%%zmm_reduce:
    vpclmulqdq      zmm8,  zmm0, zmm5, 0x00
    vpclmulqdq      zmm9,  zmm0, zmm5, 0x11
    vpclmulqdq      zmm10, zmm1, zmm6, 0x00
    vpclmulqdq      zmm11, zmm1, zmm6, 0x11
    vpclmulqdq      zmm12, zmm2, zmm7, 0x00
    vpclmulqdq      zmm13, zmm2, zmm7, 0x11
    vpternlogq      zmm8,  zmm9,  zmm10, 0x96
    vpternlogq      zmm11, zmm12, zmm13, 0x96
    vpternlogq      zmm3,  zmm8,  zmm11, 0x96

    vextracti64x4   ymm0, zmm3, 1
    vpclmulqdq      ymm8, ymm3, ymm24, 0x00
    vpclmulqdq      ymm3, ymm3, ymm24, 0x11
    vpternlogq      ymm0, ymm3, ymm8, 0x96

    vextracti128    xmm3, ymm0, 1
    vpclmulqdq      xmm8, xmm0, xmm25, 0x00
    vpclmulqdq      xmm0, xmm0, xmm25, 0x11
    vpternlogq      xmm0, xmm8, xmm3, 0x96

    cmp             R8, 16
    jb              %%xmm_reduce

ALIGN 16
%%xmm_continue:
    vpclmulqdq      xmm8, xmm0, xmm25, 0x00
    vpclmulqdq      xmm0, xmm0, xmm25, 0x11
    vpternlogq      xmm0, xmm8, [rcx], 0x96
    add             rcx, 16
    sub             R8, 16
    cmp             R8, 16
    jae             %%xmm_continue
    jmp             %%xmm_reduce

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
    vpclmulqdq      xmm8, xmm0, xmm25, 0x00
    vpclmulqdq      xmm0, xmm0, xmm25, 0x11
    vpternlogq      xmm0, xmm8, [rcx], 0x96
    add             rcx, 16
    sub             R8, 16
    cmp             R8, 16
    jae             %%xmm_loop

%%xmm_reduce:
    vpclmulqdq      xmm8, xmm0, xmm25, 0x10
    vpsrldq         xmm0, xmm0, 8
    vpxor           xmm0, xmm0, xmm8
    vpand           xmm8, xmm0, xmm26
    vpclmulqdq      xmm8, xmm8, [rel k_5], 0x00
    vpsrldq         xmm0, xmm0, 4
    vpxor           xmm0, xmm0, xmm8
    vpand           xmm8, xmm0, xmm26
    vpclmulqdq      xmm8, xmm8, xmm27, 0x10
    vpand           xmm9, xmm8, xmm26
    vpclmulqdq      xmm9, xmm9, xmm27, 0x00
    vpxor           xmm0, xmm0, xmm9
    vpextrd         eax, xmm0, 1
    test            R8, R8
    jz              %%done

%%bytes:
    CRC32_BYTES     rcx, R8

%%done:
%endmacro

SECTION .text
INIT_ZMM avx512

%if WIN64
cglobal crc32_update, 3, 8, 32, state, src, len
%else
cglobal crc32_update, 3, 3, 32, state, src, len
%endif
    mov             eax, stated
    mov             rcx, srcq
    mov             R8, lenq
    lea             R10, [rel crc_table]
    PRELOAD_CONSTS
    CRC32_FRAME
    RET

%macro CRC32_COPY_BYTES 3
    cmp             %2, 4
    jb              %%tail
%%slice4_loop:
    mov             R11D, [%1]
    mov             [%3], R11D
    xor             R11D, eax
    movzx           edi, R11B
    mov             eax, [R10 + 3072 + rdi*4]
    shr             R11D, 8
    movzx           edi, R11B
    xor             eax, [R10 + 2048 + rdi*4]
    shr             R11D, 8
    movzx           edi, R11B
    xor             eax, [R10 + 1024 + rdi*4]
    shr             R11D, 8
    movzx           edi, R11B
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

%if WIN64
cglobal crc32_copy_nt, 4, 8, 32, state, src, dst, len
    mov             eax, stated
    mov             rcx, srcq
    mov             rdx, dstq
    mov             R8, lenq
%else
cglobal crc32_copy_nt, 4, 4, 32, state, src, dst, len
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
    and             R9, 63
    jz              .bulk
    cmp             R9, R8
    cmova           R9, R8
    sub             R8, R9
    CRC32_COPY_BYTES rcx, R9, rdx
.bulk:
    test            R8, R8
    jz              .done
    cmp             R8, 16
    jb              .bytes
    cmp             R8, 256
    jb              .xmm_init

    vmovdqu64       zmm0, [rcx +   0]
    vmovdqu64       zmm1, [rcx +  64]
    vmovdqu64       zmm2, [rcx + 128]
    vmovdqu64       zmm3, [rcx + 192]
    vmovntdq        [rdx +   0], zmm0
    vmovntdq        [rdx +  64], zmm1
    vmovntdq        [rdx + 128], zmm2
    vmovntdq        [rdx + 192], zmm3
    vmovd           xmm14, eax
    vpxorq          zmm0, zmm0, zmm14
    add             rcx, 256
    add             rdx, 256
    sub             R8, 256
    cmp             R8, 256
    jb              .zmm_reduce

    vbroadcasti32x4 zmm4, [rel k_main]
ALIGN 32
.zmm_loop:
    vmovdqu64       zmm20, [rcx +   0]
    vmovdqu64       zmm21, [rcx +  64]
    vmovdqu64       zmm22, [rcx + 128]
    vmovdqu64       zmm23, [rcx + 192]
    vmovntdq        [rdx +   0], zmm20
    vmovntdq        [rdx +  64], zmm21
    vmovntdq        [rdx + 128], zmm22
    vmovntdq        [rdx + 192], zmm23
    vpclmulqdq      zmm16, zmm0, zmm4, 0x00
    vpclmulqdq      zmm17, zmm1, zmm4, 0x00
    vpclmulqdq      zmm18, zmm2, zmm4, 0x00
    vpclmulqdq      zmm19, zmm3, zmm4, 0x00
    vpclmulqdq      zmm0,  zmm0, zmm4, 0x11
    vpclmulqdq      zmm1,  zmm1, zmm4, 0x11
    vpclmulqdq      zmm2,  zmm2, zmm4, 0x11
    vpclmulqdq      zmm3,  zmm3, zmm4, 0x11
    vpternlogq      zmm0, zmm16, zmm20, 0x96
    vpternlogq      zmm1, zmm17, zmm21, 0x96
    vpternlogq      zmm2, zmm18, zmm22, 0x96
    vpternlogq      zmm3, zmm19, zmm23, 0x96
    add             rcx, 256
    add             rdx, 256
    sub             R8, 256
    cmp             R8, 256
    jae             .zmm_loop

.zmm_reduce:
    vpclmulqdq      zmm8,  zmm0, zmm5, 0x00
    vpclmulqdq      zmm9,  zmm0, zmm5, 0x11
    vpclmulqdq      zmm10, zmm1, zmm6, 0x00
    vpclmulqdq      zmm11, zmm1, zmm6, 0x11
    vpclmulqdq      zmm12, zmm2, zmm7, 0x00
    vpclmulqdq      zmm13, zmm2, zmm7, 0x11
    vpternlogq      zmm8,  zmm9,  zmm10, 0x96
    vpternlogq      zmm11, zmm12, zmm13, 0x96
    vpternlogq      zmm3,  zmm8,  zmm11, 0x96
    vextracti64x4   ymm0, zmm3, 1
    vpclmulqdq      ymm8, ymm3, ymm24, 0x00
    vpclmulqdq      ymm3, ymm3, ymm24, 0x11
    vpternlogq      ymm0, ymm3, ymm8, 0x96
    vextracti128    xmm3, ymm0, 1
    vpclmulqdq      xmm8, xmm0, xmm25, 0x00
    vpclmulqdq      xmm0, xmm0, xmm25, 0x11
    vpternlogq      xmm0, xmm8, xmm3, 0x96
    cmp             R8, 16
    jb              .xmm_reduce
ALIGN 16
.xmm_continue:
    vmovdqu         xmm20, [rcx]
    vmovntdq        [rdx], xmm20
    vpclmulqdq      xmm8, xmm0, xmm25, 0x00
    vpclmulqdq      xmm0, xmm0, xmm25, 0x11
    vpternlogq      xmm0, xmm8, xmm20, 0x96
    add             rcx, 16
    add             rdx, 16
    sub             R8, 16
    cmp             R8, 16
    jae             .xmm_continue
    jmp             .xmm_reduce

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
    vmovdqu         xmm20, [rcx]
    vmovntdq        [rdx], xmm20
    vpclmulqdq      xmm8, xmm0, xmm25, 0x00
    vpclmulqdq      xmm0, xmm0, xmm25, 0x11
    vpternlogq      xmm0, xmm8, xmm20, 0x96
    add             rcx, 16
    add             rdx, 16
    sub             R8, 16
    cmp             R8, 16
    jae             .xmm_loop

.xmm_reduce:
    vpclmulqdq      xmm8, xmm0, xmm25, 0x10
    vpsrldq         xmm0, xmm0, 8
    vpxor           xmm0, xmm0, xmm8
    vpand           xmm8, xmm0, xmm26
    vpclmulqdq      xmm8, xmm8, [rel k_5], 0x00
    vpsrldq         xmm0, xmm0, 4
    vpxor           xmm0, xmm0, xmm8
    vpand           xmm8, xmm0, xmm26
    vpclmulqdq      xmm8, xmm8, xmm27, 0x10
    vpand           xmm9, xmm8, xmm26
    vpclmulqdq      xmm9, xmm9, xmm27, 0x00
    vpxor           xmm0, xmm0, xmm9
    vpextrd         eax, xmm0, 1
    test            R8, R8
    jz              .done
.bytes:
    CRC32_COPY_BYTES rcx, R8, rdx
.done:
    RET
