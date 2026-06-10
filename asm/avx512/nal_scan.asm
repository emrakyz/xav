%include "dav1d_x86inc.asm"

SECTION .text

INIT_ZMM avx512
cglobal find_start_code, 3, 8, 2, raw, len, from, i, end, zz, tmp, one
    lea           tmpq, [fromq + 3]
    cmp           tmpq, lenq
    ja            .ret_len
    mov           eax, 1
    vpbroadcastb  m1, eax
    mov           oneq, 1
    mov           iq, fromq
    cmp           lenq, 64
    jb            .tail
    mov           endq, lenq
    sub           endq, 64
    cmp           iq, endq
    ja            .tail
.loop:
    vmovdqu64     m0, [rawq + iq]
    vptestnmb     k1, m0, m0
    kmovq         tmpq, k1
    shrx          zzq, tmpq, oneq
    and           zzq, tmpq
    jnz           .check
.advance:
    add           iq, 62
    cmp           iq, endq
    jbe           .loop
.tail:
    mov           endq, lenq
    sub           endq, 2
.tloop:
    cmp           iq, endq
    jae           .ret_len
    cmp           byte [rawq + iq], 0
    jne           .tnext
    cmp           byte [rawq + iq + 1], 0
    jne           .tnext
    cmp           byte [rawq + iq + 2], 1
    je            .ret_i
.tnext:
    inc           iq
    jmp           .tloop
.check:
    vpcmpeqb      k2, m0, m1
    kmovq         tmpq, k2
    shr           tmpq, 2
    and           zzq, tmpq
    jz            .advance
    tzcnt         zzq, zzq
    lea           rax, [iq + zzq]
    RET
.ret_i:
    mov           rax, iq
    RET
.ret_len:
    mov           rax, lenq
    RET
