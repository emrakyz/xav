%include "dav1d_x86inc.asm"

SECTION_RODATA 64

%define POLY 0xEDB88320

%macro MULTMODP_GEN 2
    %assign __mmp_m (1 << 31)
    %assign __mmp_p 0
    %assign __mmp_b %2
    %assign __mmp_done 0
    %rep 33
        %if __mmp_done == 0
            %if ((%1) & __mmp_m) != 0
                %assign __mmp_p (__mmp_p ^ __mmp_b)
                %if ((%1) & (__mmp_m - 1)) == 0
                    %assign __mmp_done 1
                %endif
            %endif
            %if __mmp_done == 0
                %assign __mmp_m (__mmp_m >> 1)
                %if (__mmp_b & 1) != 0
                    %assign __mmp_b ((__mmp_b >> 1) ^ POLY)
                %else
                    %assign __mmp_b (__mmp_b >> 1)
                %endif
            %endif
        %endif
    %endrep
    %xdefine __mmp_result __mmp_p
%endmacro

ALIGN 64
x2n_table:
%assign __p 0x40000000
%rep 32
    dd __p
    MULTMODP_GEN __p, __p
    %assign __p __mmp_result
%endrep

ALIGN 16
barrett:
    dq 0x1DB710641
    dq 0x1F7011641
mask32:
    dq 0xFFFFFFFF
    dq 0
shift_const_vec:
    dd 0
    dd 0xDB710641
    dd 0
    dd 0

%macro MULTMODP 1
    vmovd       xmm1, %1
    vpclmulqdq  xmm0, xmm0, xmm1, 0x00
    vpand       xmm2, xmm0, xmm11
    vpclmulqdq  xmm2, xmm2, xmm10, 0x10
    vpand       xmm2, xmm2, xmm11
    vpclmulqdq  xmm2, xmm2, xmm10, 0x00
    vpxor       xmm0, xmm0, xmm2
    vpsrad      xmm3, xmm0, 31
    vpand       xmm3, xmm3, xmm12
    vpaddd      xmm0, xmm0, xmm0
    vpxor       xmm0, xmm0, xmm3
    vpsrlq      xmm0, xmm0, 32
%endmacro

%macro COMBINE_BODY 0
    test            len2q, len2q
    jz              %%return_crc1

    vmovdqa         xmm10, [rel barrett]
    vmovdqa         xmm11, [rel mask32]
    vmovdqa         xmm12, [rel shift_const_vec]

%if WIN64
    mov             R9d, crc1d
%else
    mov             R8d, crc1d
%endif
    mov             eax, 0x80000000
    vmovd           xmm0, eax
    mov             R11d, 3
    lea             R10, [rel x2n_table]

ALIGN 16
%%loop:
    test            len2q, 1
    jz              %%skip
    mov             ecx, R11d
    and             ecx, 31
    MULTMODP        [R10 + rcx*4]
%%skip:
    inc             R11d
    shr             len2q, 1
    jnz             %%loop

%if WIN64
    MULTMODP        R9d
%else
    MULTMODP        R8d
%endif
    vmovd           eax, xmm0
    xor             eax, crc2d
    RET

%%return_crc1:
    mov             eax, crc1d
    RET
%endmacro

SECTION .text
INIT_XMM avx2

cglobal crc32_avx2_combine, 3, 6, 16, crc1, crc2, len2
    COMBINE_BODY

cglobal crc32_pclmul_combine, 3, 6, 16, crc1, crc2, len2
    COMBINE_BODY
