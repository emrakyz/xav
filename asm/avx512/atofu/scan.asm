%include "dav1d_x86inc.asm"

SECTION_RODATA 64

c_didx:
%assign j 0
%rep 64
  db j
  %assign j j+1
%endrep
c_zero:  times 64 db '0'
c_ten:   times 64 db 10
c_minus: times 64 db '-'
c_colon: times 64 db ':'
c_lbrk:  times 64 db '['
c_comma: times 64 db ','

SECTION .text

INIT_ZMM avx512
cglobal scan, 4, 15, 15
    vmovdqa32       m14, [c_didx]
    vmovdqa32       m7, [c_zero]
    vmovdqa32       m8, [c_ten]
    vmovdqa32       m9, [c_minus]
    vmovdqa32       m10, [c_colon]
    vmovdqa32       m11, [c_lbrk]
    vmovdqa32       m12, [c_comma]
    mov             r4, -1
    xor             r6d, r6d
    xor             r7d, r7d
    xor             r8d, r8d
    xor             r9d, r9d
    sub             r1, 64
    js              .tail
.loop:
    vmovdqu64       m0, [r0+r9]
    vpsubb          m1, m0, m7
    vpbroadcastw    m2, r9d
    vpcmpub         k1, m1, m8, 1
    vpcmpeqb        k2, m0, m9
    korq            k1, k1, k2
    vpcmpeqb        k2, m0, m10
    vpcmpeqb        k3, m0, m11
    korq            k2, k2, k3
    vpcmpeqb        k3, m0, m12
    korq            k2, k2, k3
    vpcmpeqb        k4, m0, m8
    kmovq           r10, k2
    kmovq           r11, k1
    lea             r12, [r8+r10*2]
    shr             r10, 63
    mov             r8, r10
    and             r12, r11
    kmovq           k5, r12
    vpcompressb     m13{k5}, m14
    vpmovzxbw       m13, ym13
    vpaddw          m13, m13, m2
    popcnt          r13, r12
    bzhi            r14, r4, r13
    kmovd           k6, r14d
    vmovdqu16       [r2+r6*2]{k6}, m13
    add             r6, r13
    kortestq        k4, k4
    jz              .nonl
    kmovq           r10, k4
.nll:
    tzcnt           r13, r10
    add             r13, r9
    mov             [r3+r7*2], r13w
    inc             r7
    blsr            r10, r10
    jnz             .nll
.nonl:
    add             r9, 64
    cmp             r9, r1
    jbe             .loop
.tail:
    add             r1, 64
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
