%include "dav1d_x86inc.asm"

SECTION_RODATA 32

c_n30:   times 32 db 0xD0
c_comma: times 32 db ','
c_minus: times 32 db '-'
c_m10:   times 16 db 10, 1
c_m100:  times 8  dw 100, 1
c_m1e4:  times 8  dw 10000, 1
c_pidx:  dd 1, 5, 0, 0, 0, 0, 0, 0
c_sbits: dq 0x0000_0000_0001_0001
c_scaletab:
    dd 0x38D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717
    dd 0xB8D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717
    dd 0x38D1_B717, 0xB8D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717
    dd 0xB8D1_B717, 0xB8D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717, 0x38D1_B717
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

INIT_YMM avx2
cglobal atof, 4, 8, 7
    vpxor           m2, m2, m2
    vmovdqu         m4, [c_pidx]
    lea             r2, [r1+r2*2]
.loop:
    movzx           r4d, word [r1+0]
    movzx           r5d, word [r1+2]
    vmovdqu         xm0, [r0+r4]
    vinserti128     m0, m0, [r0+r5], 1
    vpcmpeqb        m5, m0, [c_comma]
    vpcmpeqb        m6, m0, [c_minus]
    vpmovmskb       r7d, m5
    vpmovmskb       r6d, m6
    vpaddb          m0, m0, [c_n30]
    vpandn          m0, m6, m0
    tzcnt           r4d, r7d
    shr             r7d, 16
    tzcnt           r5d, r7d
    shl             r4d, 4
    shl             r5d, 4
    pext            r6, r6, [c_sbits]
    shl             r6d, 5
    vmovdqu         xm1, [shuf3+r4]
    vinserti128     m1, m1, [shuf3+r5], 1
    vpshufb         m0, m0, m1
    vpmaddubsw      m0, m0, [c_m10]
    vpmaddwd        m0, m0, [c_m100]
    vpackssdw       m0, m0, m2
    vpmaddwd        m0, m0, [c_m1e4]
    vpermd          m0, m4, m0
    vcvtdq2ps       m0, m0
    vmulps          m0, m0, [c_scaletab+r6]
    vmovq           [r3], xm0
    add             r3, 8
    add             r1, 4
    cmp             r1, r2
    jb              .loop
    RET
