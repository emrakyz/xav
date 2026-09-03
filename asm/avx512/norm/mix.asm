%include "dav1d_x86inc.asm"

SECTION_RODATA 64
ia1: dq 0, 3, 6, 9, 12, 15, 0, 0
ia2: dq 0, 1, 2, 3, 4, 5, 10, 13
ib1: dq 2, 5, 8, 11, 14, 0, 0, 0
ib2: dq 0, 1, 2, 3, 4, 9, 12, 15
ic1: dd 2, 2, 8, 8, 14, 14, 20, 20, 26, 26, 0, 0, 0, 0, 0, 0
ic2: dd 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 16, 16, 22, 22, 28, 28
i1a7: dd 0,1,7,8,14,15,21,22,28,29,0,0,0,0,0,0
i2a7: dd 0,1,2,3,4,5,6,7,8,9,19,20,26,27,14,15
i3a7: dd 0,1,2,3,4,5,6,7,8,9,10,11,12,13,17,18
i1c7: dd 4,4,11,11,18,18,25,25,0,0,0,0,0,0,0,0
i2c7: dd 0,1,2,3,4,5,6,7,16,16,23,23,30,30,14,15
i3c7: dd 0,1,2,3,4,5,6,7,8,9,10,11,12,13,21,21
i1s7: dd 5,6,12,13,19,20,26,27,0,0,0,0,0,0,0,0
i2s7: dd 0,1,2,3,4,5,6,7,17,18,24,25,31,13,14,15
i3s7: dd 0,1,2,3,4,5,6,7,8,9,10,11,12,16,22,23
i1f7: dd 2,2,9,9,16,16,23,23,30,30,0,0,0,0,0,0
i2f7: dd 0,1,2,3,4,5,6,7,8,9,21,21,28,28,14,15
i3f7: dd 0,1,2,3,4,5,6,7,8,9,10,11,12,13,19,19
ka8: dq 0,4,8,12,0,4,8,12
kb8: dq 2,6,10,14,2,6,10,14
kr8: dq 3,7,11,15,3,7,11,15
kf8: dd 2,2,10,10,18,18,26,26,2,2,10,10,18,18,26,26
c707: dd 0.707
c05: dd 0.5

SECTION .text
INIT_ZMM avx512
%if WIN64
WIN64_MMMAP 6, 22, 15
%endif

%macro DM 2
    vmovups       zmm0, [srcq + %1]
    vmovups       zmm1, [srcq + %1 + 0x40]
    vmovups       zmm2, [srcq + %1 + 0x80]
    vmovapd       zmm3, zmm0
    vpermt2pd     zmm3, zmm16, zmm1
    vpermt2pd     zmm3, zmm17, zmm2
    vmovapd       zmm4, zmm0
    vpermt2pd     zmm4, zmm18, zmm1
    vpermt2pd     zmm4, zmm19, zmm2
    vpermt2ps     zmm0, zmm20, zmm1
    vpermt2ps     zmm0, zmm21, zmm2
    vfmadd231ps   zmm3, zmm22, zmm4
    vfmadd231ps   zmm3, zmm22, zmm0
    vmovups       [dstq + rax*8 + %2], zmm3
%endmacro

cglobal mix6, 3, 5, 5, src, dst, n
    vmovdqa64     zmm16, [ia1]
    vmovdqa64     zmm17, [ia2]
    vmovdqa64     zmm18, [ib1]
    vmovdqa64     zmm19, [ib2]
    vmovdqa32     zmm20, [ic1]
    vmovdqa32     zmm21, [ic2]
    vbroadcastss  zmm22, [c707]
    xor           eax, eax
    mov           r3, nq
    and           r3, -32
    jz            .tail
.loop:
    DM            0x000, 0x00
    DM            0x0c0, 0x40
    DM            0x180, 0x80
    DM            0x240, 0xc0
    add           srcq, 0x300
    add           rax, 0x20
    cmp           rax, r3
    jb            .loop
.tail:
    cmp           rax, nq
    jae           .done
.tloop:
    vmovss        xmm0, [srcq]
    vfmadd231ss   xmm0, xmm22, [srcq + 0x10]
    vfmadd231ss   xmm0, xmm22, [srcq + 0x8]
    vmovss        [dstq + rax*8], xmm0
    vmovss        xmm1, [srcq + 0x4]
    vfmadd231ss   xmm1, xmm22, [srcq + 0x14]
    vfmadd231ss   xmm1, xmm22, [srcq + 0x8]
    vmovss        [dstq + rax*8 + 0x4], xmm1
    add           srcq, 0x18
    inc           rax
    cmp           rax, nq
    jb            .tloop
.done:
    RET

%macro P7 4
    vmovaps       %1, zmm0
    vpermt2ps     %1, %2, zmm1
    vpermt2ps     %1, %3, zmm2
    vpermt2ps     %1, %4, zmm3
%endmacro

%macro G7 2
    vmovups       zmm0, [srcq + %1]
    vmovups       zmm1, [srcq + %1 + 0x40]
    vmovups       zmm2, [srcq + %1 + 0x80]
    vmovups       ymm3, [srcq + %1 + 0xc0]
    P7            zmm4, zmm8,  zmm9,  zmm10
    P7            zmm5, zmm11, zmm12, zmm13
    P7            zmm6, zmm14, zmm15, zmm16
    vpermt2ps     zmm0, zmm17, zmm1
    vpermt2ps     zmm0, zmm18, zmm2
    vpermt2ps     zmm0, zmm19, zmm3
    vfmadd231ps   zmm4, zmm21, zmm5
    vfmadd231ps   zmm4, zmm20, zmm6
    vfmadd231ps   zmm4, zmm20, zmm0
    vmovups       [dstq + rax*8 + %2], zmm4
%endmacro

cglobal mix7, 3, 5, 8, src, dst, n
    vmovdqa32     zmm8,  [i1a7]
    vmovdqa32     zmm9,  [i2a7]
    vmovdqa32     zmm10, [i3a7]
    vmovdqa32     zmm11, [i1c7]
    vmovdqa32     zmm12, [i2c7]
    vmovdqa32     zmm13, [i3c7]
    vmovdqa32     zmm14, [i1s7]
    vmovdqa32     zmm15, [i2s7]
    vmovdqa32     zmm16, [i3s7]
    vmovdqa32     zmm17, [i1f7]
    vmovdqa32     zmm18, [i2f7]
    vmovdqa32     zmm19, [i3f7]
    vbroadcastss  zmm20, [c707]
    vbroadcastss  zmm21, [c05]
    xor           eax, eax
    mov           r3, nq
    and           r3, -32
    jz            .tail
.loop:
    G7            0x000, 0x00
    G7            0x0e0, 0x40
    G7            0x1c0, 0x80
    G7            0x2a0, 0xc0
    add           srcq, 0x380
    add           rax, 32
    cmp           rax, r3
    jb            .loop
.tail:
    cmp           rax, nq
    jae           .done
.tloop:
    vmovss        xmm0, [srcq]
    vfmadd231ss   xmm0, xmm21, [srcq + 0x10]
    vfmadd231ss   xmm0, xmm20, [srcq + 0x14]
    vfmadd231ss   xmm0, xmm20, [srcq + 0x8]
    vmovss        [dstq + rax*8], xmm0
    vmovss        xmm1, [srcq + 0x4]
    vfmadd231ss   xmm1, xmm21, [srcq + 0x10]
    vfmadd231ss   xmm1, xmm20, [srcq + 0x18]
    vfmadd231ss   xmm1, xmm20, [srcq + 0x8]
    vmovss        [dstq + rax*8 + 0x4], xmm1
    add           srcq, 0x1c
    inc           rax
    cmp           rax, nq
    jb            .tloop
.done:
    RET

%macro V8 2
    vmovapd       zmm8, zmm0
    vpermt2pd     zmm8, %1, zmm1
    vmovapd       zmm9, zmm2
    vpermt2pd     zmm9, %1, zmm3
    vshuff64x2    %2, zmm8, zmm9, 0xe4
%endmacro

%macro G8 2
    vmovups       zmm0, [srcq + %1]
    vmovups       zmm1, [srcq + %1 + 0x40]
    vmovups       zmm2, [srcq + %1 + 0x80]
    vmovups       zmm3, [srcq + %1 + 0xc0]
    V8            zmm10, zmm4
    V8            zmm11, zmm5
    V8            zmm12, zmm6
    vpermt2ps     zmm0, zmm13, zmm1
    vpermt2ps     zmm2, zmm13, zmm3
    vshuff64x2    zmm7, zmm0, zmm2, 0xe4
    vmulps        zmm6, zmm6, zmm14
    vfmadd231ps   zmm4, zmm15, zmm5
    vfmadd231ps   zmm4, zmm14, zmm6
    vfmadd231ps   zmm4, zmm14, zmm7
    vmovups       [dstq + rax*8 + %2], zmm4
%endmacro

cglobal mix8, 3, 5, 8, src, dst, n
    vmovdqa64     zmm10, [ka8]
    vmovdqa64     zmm11, [kb8]
    vmovdqa64     zmm12, [kr8]
    vmovdqa32     zmm13, [kf8]
    vbroadcastss  zmm14, [c707]
    vbroadcastss  zmm15, [c05]
    xor           eax, eax
    mov           r3, nq
    and           r3, -32
    jz            .tail
.loop:
    G8            0x000, 0x00
    G8            0x100, 0x40
    G8            0x200, 0x80
    G8            0x300, 0xc0
    add           srcq, 0x400
    add           rax, 32
    cmp           rax, r3
    jb            .loop
.tail:
    cmp           rax, nq
    jae           .done
.tloop:
    vmulss        xmm2, xmm14, [srcq + 0x18]
    vmovss        xmm0, [srcq]
    vfmadd231ss   xmm0, xmm15, [srcq + 0x10]
    vfmadd231ss   xmm0, xmm14, xmm2
    vfmadd231ss   xmm0, xmm14, [srcq + 0x8]
    vmovss        [dstq + rax*8], xmm0
    vmulss        xmm2, xmm14, [srcq + 0x1c]
    vmovss        xmm1, [srcq + 0x4]
    vfmadd231ss   xmm1, xmm15, [srcq + 0x14]
    vfmadd231ss   xmm1, xmm14, xmm2
    vfmadd231ss   xmm1, xmm14, [srcq + 0x8]
    vmovss        [dstq + rax*8 + 0x4], xmm1
    add           srcq, 0x20
    inc           rax
    cmp           rax, nq
    jb            .tloop
.done:
    RET
