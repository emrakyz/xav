%include "dav1d_x86inc.asm"

SECTION_RODATA 32

c_nl:    times 32 db 10
c_zero:  times 32 db '0'
c_nine:  times 32 db 9
c_minus: times 32 db '-'
c_colon: times 32 db ':'
c_lbrk:  times 32 db '['
c_comma: times 32 db ','

SECTION .text

INIT_YMM avx2
cglobal scan, 4, 15, 12
    vmovdqa         m5, [c_nl]
    vmovdqa         m6, [c_zero]
    vmovdqa         m7, [c_nine]
    vmovdqa         m8, [c_minus]
    vmovdqa         m9, [c_colon]
    vmovdqa         m10, [c_lbrk]
    vmovdqa         m11, [c_comma]
    xor             r6d, r6d
    xor             r7d, r7d
    xor             r8d, r8d
    xor             r9d, r9d
    sub             r1, 32
    js              .tail
.loop:
    vmovdqu         m0, [r0+r9]
    vpsubb          m1, m0, m6
    vpminub         m2, m1, m7
    vpcmpeqb        m2, m2, m1
    vpcmpeqb        m3, m0, m8
    vpor            m2, m2, m3
    vpmovmskb       r10d, m2
    vpcmpeqb        m2, m0, m9
    vpcmpeqb        m3, m0, m10
    vpor            m2, m2, m3
    vpcmpeqb        m3, m0, m11
    vpor            m2, m2, m3
    vpmovmskb       r11d, m2
    vpcmpeqb        m2, m0, m5
    vpmovmskb       r12d, m2
    lea             r13, [r8+r11*2]
    mov             r8, r11
    shr             r8, 31
    and             r13d, r10d
    jz              .nonum
.numl:
    tzcnt           r14d, r13d
    add             r14d, r9d
    mov             [r2+r6*2], r14w
    inc             r6
    blsr            r13d, r13d
    jnz             .numl
.nonum:
    test            r12d, r12d
    jz              .nonl
.nll:
    tzcnt           r14d, r12d
    add             r14d, r9d
    mov             [r3+r7*2], r14w
    inc             r7
    blsr            r12d, r12d
    jnz             .nll
.nonl:
    add             r9, 32
    cmp             r9, r1
    jbe             .loop
.tail:
    add             r1, 32
    xor             r10d, r10d
    test            r9, r9
    jz              .tl
    movzx           r10d, byte [r0+r9-1]
.tl:
    cmp             r9, r1
    jae             .done
    movzx           r11d, byte [r0+r9]
    lea             r12d, [r11-0x30]
    cmp             r12b, 10
    jb              .td
    cmp             r11b, '-'
    jne             .tn
.td:
    cmp             r10b, ':'
    je              .tnm
    cmp             r10b, '['
    je              .tnm
    cmp             r10b, ','
    jne             .tn
.tnm:
    mov             [r2+r6*2], r9w
    inc             r6
.tn:
    cmp             r11b, 10
    jne             .ta
    mov             [r3+r7*2], r9w
    inc             r7
.ta:
    mov             r10d, r11d
    inc             r9
    jmp             .tl
.done:
    shl             r7, 32
    or              rax, r7
    RET
