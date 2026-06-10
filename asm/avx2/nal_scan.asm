%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
c_one: db 1

SECTION .text

INIT_YMM avx2
cglobal find_start_code, 3, 8, 4, raw, len, from, i, end, zz, tmp, one
    lea           tmpq, [fromq + 3]
    cmp           tmpq, lenq
    ja            .ret_len
    vpbroadcastb  m1, [c_one]
    vpxor         m2, m2, m2
    mov           oned, 1
    mov           iq, fromq
    cmp           lenq, 242
    jb            .single_setup
    mov           endq, lenq
    sub           endq, 242
    cmp           iq, endq
    ja            .single_setup
.loop8:
%assign k 0
%rep 8
.c %+ k:
    vmovdqu       m0, [rawq + iq + k*30]
    vpcmpeqb      m3, m0, m2
    vpmovmskb     tmpd, m3
    shrx          zzd, tmpd, oned
    and           zzd, tmpd
    jnz           .check %+ k
 %assign k k+1
%endrep
.c8:
    add           iq, 240
    cmp           iq, endq
    jbe           .loop8
.single_setup:
    mov           endq, lenq
    sub           endq, 32
    cmp           lenq, 32
    jb            .tail
    cmp           iq, endq
    ja            .tail
.single:
    vmovdqu       m0, [rawq + iq]
    vpcmpeqb      m3, m0, m2
    vpmovmskb     tmpd, m3
    shrx          zzd, tmpd, oned
    and           zzd, tmpd
    jnz           .checks
.snext:
    add           iq, 30
    cmp           iq, endq
    jbe           .single
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
.ret_i:
    mov           rax, iq
    RET
.ret_len:
    mov           rax, lenq
    RET
%assign k 0
%rep 8
 %assign kp1 k+1
.check %+ k:
    vpcmpeqb      m3, m0, m1
    vpmovmskb     tmpd, m3
    shr           tmpd, 2
    and           zzd, tmpd
    jz            .c %+ kp1
    tzcnt         zzd, zzd
    lea           rax, [iq + zzq + k*30]
    RET
 %assign k k+1
%endrep
.checks:
    vpcmpeqb      m3, m0, m1
    vpmovmskb     tmpd, m3
    shr           tmpd, 2
    and           zzd, tmpd
    jz            .snext
    tzcnt         zzd, zzd
    lea           rax, [iq + zzq]
    RET
