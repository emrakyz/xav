%include "dav1d_x86inc.asm"

SECTION_RODATA 64

c_n30:   times 64 db 0xD0
c_comma: times 64 db ','
c_minus: times 64 db '-'
c_m10:   times 32 db 10, 1
c_m100:  times 16 dw 100, 1
c_m1e4:  times 16 dw 10000, 1
c_1e_4:  times 16 dd 0x38D1_B717
c_pidx:  dd 1, 5, 9, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
c_sbits: dq 0x0001_0001_0001_0001
shuf3:
%assign L 0
%rep 33
  %assign j 0
  %rep 16
    %if L >= 5 && j + L >= 17
      %assign mbyte (j - 17 + L)
      %if mbyte < L - 5
        db mbyte
      %else
        db (mbyte + 1)
      %endif
    %else
      db 0x80
    %endif
    %assign j j+1
  %endrep
  %assign L L+1
%endrep

SECTION .text

INIT_ZMM avx512
cglobal atof, 4, 9, 5
    vpxorq          m2, m2, m2
    vmovdqa32       m4, [c_pidx]
    lea             r2, [r1+r2*2]
.loop:
    movzx           r4d, word [r1+0]
    movzx           r5d, word [r1+2]
    movzx           r7d, word [r1+4]
    movzx           r8d, word [r1+6]
    vmovdqu         xm0, [r0+r4]
    vinserti32x4    m0, m0, [r0+r5], 1
    vinserti32x4    m0, m0, [r0+r7], 2
    vinserti32x4    m0, m0, [r0+r8], 3
    vpcmpeqb        k1, m0, [c_comma]
    vpcmpeqb        k3, m0, [c_minus]
    kmovq           r6, k3
    pext            r6, r6, [c_sbits]
    kmovw           k4, r6d
    vpaddb          m0, m0, [c_n30]
    vmovdqu8        m0{k3}, m2
    kmovq           r6, k1
    tzcnt           r4, r6
    rorx            r5, r6, 16
    tzcnt           r5, r5
    rorx            r7, r6, 32
    tzcnt           r7, r7
    rorx            r8, r6, 48
    tzcnt           r8, r8
    shl             r4, 4
    shl             r5, 4
    shl             r7, 4
    shl             r8, 4
    vmovdqu         xm1, [shuf3+r4]
    vinserti32x4    m1, m1, [shuf3+r5], 1
    vinserti32x4    m1, m1, [shuf3+r7], 2
    vinserti32x4    m1, m1, [shuf3+r8], 3
    vpshufb         m0, m0, m1
    vpmaddubsw      m0, m0, [c_m10]
    vpmaddwd        m0, m0, [c_m100]
    vpackssdw       m0, m0, m2
    vpmaddwd        m0, m0, [c_m1e4]
    vpermd          m0, m4, m0
    vpsubd          m0{k4}, m2, m0
    vcvtdq2ps       m0, m0
    vmulps          m0, m0, [c_1e_4]
    vmovdqu         [r3], xm0
    add             r3, 16
    add             r1, 8
    cmp             r1, r2
    jb              .loop
    RET
