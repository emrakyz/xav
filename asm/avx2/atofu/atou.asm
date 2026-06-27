%include "dav1d_x86inc.asm"

SECTION_RODATA 32

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

INIT_YMM avx2
cglobal atou, 4, 7, 11
    vpbroadcastb    m4, [c_n30b]
    vpbroadcastb    m5, [c_9b]
    vbroadcasti128  m6, [c_m10]
    vbroadcasti128  m7, [c_m100]
    vbroadcasti128  m8, [c_m1e4]
    vpbroadcastq    m9, [c_1e8q]
    vpxor           m10, m10, m10
    lea             r2, [r1+r2*2]
.loop:
    movzx           r4d, word [r1+0]
    movzx           r5d, word [r1+2]
    vmovdqu         xm0, [r0+r4]
    vinserti128     m0, m0, [r0+r5], 1
    vpaddb          m0, m0, m4
    vpsubusb        m1, m0, m5
    vpcmpeqb        m1, m1, m10
    vpmovmskb       eax, m1
    not             eax
    mov             r4d, eax
    shr             r4d, 16
    tzcnt           eax, eax
    tzcnt           r4d, r4d
    shl             eax, 4
    shl             r4d, 4
    vmovdqu         xm1, [c_shuf+rax]
    vinserti128     m1, m1, [c_shuf+r4], 1
    vpshufb         m0, m0, m1
    vpmaddubsw      m0, m0, m6
    vpmaddwd        m0, m0, m7
    vpackssdw       m0, m0, m10
    vpmaddwd        m0, m0, m8
    vpmuludq        m1, m0, m9
    vpsrlq          m0, m0, 32
    vpaddq          m1, m1, m0
    vpermq          m1, m1, 0x08
    vmovdqu         [r3], xm1
    add             r3, 16
    add             r1, 4
    cmp             r1, r2
    jb              .loop
    RET
