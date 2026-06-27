%include "dav1d_x86inc.asm"

SECTION_RODATA 64

c_n30b: db 0xD0
c_9b:   db 9
c_m10:  times 8  db 10, 1
c_m100: times 4  dw 100, 1
c_m1e4: times 4  dw 10000, 1
c_1e8q: dq 0x0000_0000_05F5_E100
c_shuf:
%assign L 0
%rep 33
  %assign j 0
  %rep 16
    %if j + L >= 16
      db (j + L - 16)
    %else
      db 0x80
    %endif
    %assign j j+1
  %endrep
  %assign L L+1
%endrep

SECTION .text

INIT_ZMM avx512
cglobal atou, 4, 9, 14
    vpbroadcastb    m8, [c_n30b]
    vpbroadcastb    m9, [c_9b]
    vbroadcasti32x4 m10, [c_m10]
    vbroadcasti32x4 m11, [c_m100]
    vbroadcasti32x4 m12, [c_m1e4]
    vpbroadcastq    m13, [c_1e8q]
    vpxorq          m7, m7, m7
    mov             eax, 0x55
    kmovb           k2, eax
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
    vpaddb          m0, m0, m8
    vpcmpub         k1, m0, m9, 6
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
    vmovdqu         xm1, [c_shuf+r4]
    vinserti32x4    m1, m1, [c_shuf+r5], 1
    vinserti32x4    m1, m1, [c_shuf+r7], 2
    vinserti32x4    m1, m1, [c_shuf+r8], 3
    vpshufb         m0, m0, m1
    vpmaddubsw      m0, m0, m10
    vpmaddwd        m0, m0, m11
    vpackssdw       m0, m0, m7
    vpmaddwd        m0, m0, m12
    vpmuludq        m2, m0, m13
    vpsrlq          m0, m0, 32
    vpaddq          m2, m2, m0
    vpcompressq     m3{k2}, m2
    vmovdqu         [r3], ym3
    add             r3, 32
    add             r1, 8
    cmp             r1, r2
    jb              .loop
    RET
