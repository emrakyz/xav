%include "dav1d_x86inc.asm"

SECTION_RODATA 64
d100: db "00010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899"
dg:   db 19,19,19,19,18,18,18,17,17,17,16,16,16,16,15,15
      db 15,14,14,14,13,13,13,13,12,12,12,11,11,11,10,10
      db 10,10,9,9,9,8,8,8,7,7,7,7,6,6,6,5
      db 5,5,4,4,4,4,3,3,3,2,2,2,1,1,1,1
p10:  dq 1,10,100,1000,10000,100000,1000000,10000000,100000000,1000000000
      dq 10000000000,100000000000,1000000000000,10000000000000,100000000000000
      dq 1000000000000000,10000000000000000,100000000000000000
      dq 1000000000000000000,10000000000000000000

SECTION .text align=64
INIT_XMM avx2

cextern split

%define MAXD 300
%define M300 0xda740da740da740e
%define M100 1374389535
%define BIG  100000000

%macro ITOA 1
    mov          axq, %1
    or           axq, 1
    lzcnt        t0q, axq
    movzx        t1d, byte [dg+t0q]
    cmp          %1, [p10+t1q*8]
    sbb          t1q, -1
    mov          axq, %1
    add          opq, t1q
    mov          byte [opq], 10
    mov          t2q, opq
    inc          opq
    cmp          axq, BIG
    jae          %%big
%%p:
    cmp          axq, 100
    jb           %%tail
    imul         t0q, axq, M100
    shr          t0q, 37
    imul         t1q, t0q, 100
    sub          axq, t1q
    movzx        t1d, word [d100+axq*2]
    mov          [t2q-2], t1w
    sub          t2q, 2
    mov          axq, t0q
    jmp          %%p
%%big:
    xor          totd, totd
    mov          t0d, 100
    div          t0q
    movzx        t1d, word [d100+totq*2]
    mov          [t2q-2], t1w
    sub          t2q, 2
    cmp          axq, BIG
    jae          %%big
    jmp          %%p
%%tail:
    cmp          axq, 10
    jb           %%one
    movzx        t1d, word [d100+axq*2]
    mov          [t2q-2], t1w
    jmp          %%d
%%one:
    or           al, '0'
    mov          [t2q-1], al
%%d:
%endmacro

%macro SPLIT 3
%%l:
    mov          t2q, %2
    sub          t2q, %1
    mov          axq, M300
    mul          t2q
    shr          totq, 8
    lea          t0q, [totq+1]
    mov          axq, t2q
    xor          totd, totd
    div          t0q
    mov          midq, axq
    shr          axd, 1
    mov          t1d, MAXD
    sub          t1d, axd
    cmp          t1d, midd
    cmova        t1d, midd
    lea          t2d, [t1d+1]
    mov          [rsp+8], t2d
    mov          t0q, [rsp+0]
    lea          scq, [%1+axq]
    lea          scq, [t0q+scq*4]
    mov          nd, t2d
    mov          totd, midd
    sub          totd, axd
    mov          scrd, t1d
    call         xav_split
    mov          t0d, midd
    shr          t0d, 1
    add          t0d, eax
    cmp          eax, [rsp+8]
    cmove        t0d, midd
    add          %1, t0q
    ITOA         %1
    lea          t2q, [%1+MAXD]
    cmp          %2, t2q
    ja           %%l
    jmp          %3
%endmacro

cglobal refine, 5, 15, 0, sc, n, tot, scr, out, t0, ax, t1, t2, op, cs, e, mid, ix, sl
    sub          rsp, 40
    mov          [rsp+0], scrq
    mov          [rsp+24], outq
    mov          opq, outq
    mov          word [opq], 0x0A30
    add          opq, 2
    test         nq, nq
    jnz          .go
    test         totq, totq
    cmovz        opq, outq
    jmp          .fin
.go:
    mov          [rsp+16], totq
    lea          slq, [scq+nq*8-8]
    mov          ixq, scq
    sub          ixq, slq
    mov          eq, [scq]
    jz           .last
    test         ixq, 8
    jz           .scene
    lea          t2q, [eq+MAXD]
    mov          csq, [slq+ixq+8]
    cmp          csq, t2q
    ja           .splitO
.endO:
    ITOA         csq
    mov          eq, csq
    add          ixq, 8
    jz           .last
.scene:
    lea          t2q, [eq+MAXD]
    mov          csq, [slq+ixq+8]
    cmp          csq, t2q
    ja           .splitA
.endA:
    ITOA         csq
    lea          t2q, [csq+MAXD]
    mov          eq, [slq+ixq+16]
    cmp          eq, t2q
    ja           .splitB
.endB:
    ITOA         eq
    add          ixq, 16
    jnz          .scene
.last:
    lea          t2q, [eq+MAXD]
    mov          csq, [rsp+16]
    cmp          csq, t2q
    ja           .splitL
.endL:
.fin:
    mov          axq, opq
    sub          axq, [rsp+24]
    add          rsp, 40
    RET
.splitO:
    SPLIT eq, csq, .endO
.splitA:
    SPLIT eq, csq, .endA
.splitB:
    SPLIT csq, eq, .endB
.splitL:
    SPLIT eq, csq, .endL
