%include "p5nm.inc"
default rel
%include "gpo.inc"
%include "gpimg.inc"
M5p_a0
M5p_a1
M5p_a2
M5p_a3
M5p_a4
global xav_p5_0_3_2
align 64
xav_p5_0_3_2:
M5p_a5
M5p_a6
M5p_ac
M5p_a9
M5p_a271
M5p_ae
M5p_a12
M5p_a14
M5p_a15
M5p_a16
M5p_a18
M5p_a22
M5p_a21
M5p_a26
M5p_a1e
M5p_a24
M5p_a28
M5p_a29
M5p_a1b
M5p_a1f
M5p_a25
M5p_a2a
M5p_a2b
M5p_a1c
M5p_a20
M5p_a272
M5p_a25
M5p_a2e
M5p_a31
M5p_a28d
M5p_a4c
M5p_a4d8
    vmovups zmm15, [rcx + 0]
    vmovups zmm10, [rdx + 128]
    vmovups zmm11, [rdx + 192]
    kmovw k2, [rsi + 6]
    vmovups zmm24, [rcx + 64]
    vmovups zmm12, [rdx + 256]
    vmovups zmm13, [rdx + 320]
    kmovw k3, [rsi + 10]
M5p_a4d2
M5p_a53
    mov rbp, rbx
M5p_a4d9
    vpermi2ps zmm17, zmm22, zmm23
    vmovaps zmm16{k1}, zmm17
    vmulps zmm0, zmm16, zmm15
M5p_a4dd
    vmovaps zmm16{k2}, zmm17
    vfmadd231ps zmm0, zmm16, zmm24
M5p_a4de
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, zmm25
    vmovups zmm18, [r8 + r14 + 0]
    vmovups zmm19, [r8 + r14 + 64]
    vmovups zmm22, [r8 + r14 + 128]
    vmovups zmm23, [r8 + r14 + 192]
M5p_a4dc
    vmovaps zmm16{k1}, zmm17
    vmulps zmm1, zmm16, zmm15
M5p_a4dd
    vmovaps zmm16{k2}, zmm17
    vfmadd231ps zmm1, zmm16, zmm24
M5p_a4de
    vmovaps zmm16{k3}, zmm17
M5p_a4d4
    vmovaps zmm1, zmm16
    vmovups zmm18, [r9 + 0]
    vmovups zmm19, [r9 + 64]
    vmovups zmm22, [r9 + 128]
    vmovups zmm23, [r9 + 192]
M5p_a4dc
    vmovaps zmm16{k1}, zmm17
    vmulps zmm2, zmm16, zmm15
M5p_a4dd
    vmovaps zmm16{k2}, zmm17
    vfmadd231ps zmm2, zmm16, zmm24
M5p_a4de
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, zmm25
    vmovups zmm18, [r9 + r14 + 0]
    vmovups zmm19, [r9 + r14 + 64]
    vmovups zmm22, [r9 + r14 + 128]
    vmovups zmm23, [r9 + r14 + 192]
M5p_a4dc
    vmovaps zmm16{k1}, zmm17
    vmulps zmm3, zmm16, zmm15
M5p_a4dd
    vmovaps zmm16{k2}, zmm17
    vfmadd231ps zmm3, zmm16, zmm24
M5p_a4de
    vmovaps zmm16{k3}, zmm17
M5p_a4d5
    vmovaps zmm3, zmm16
    vmovups zmm18, [r15 + 0]
    vmovups zmm19, [r15 + 64]
    vmovups zmm22, [r15 + 128]
    vmovups zmm23, [r15 + 192]
M5p_a4dc
    vmovaps zmm16{k1}, zmm17
    vmulps zmm4, zmm16, zmm15
M5p_a4dd
    vmovaps zmm16{k2}, zmm17
    vfmadd231ps zmm4, zmm16, zmm24
M5p_a4de
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, zmm25
    vmovups zmm18, [r15 + r14 + 0]
    vmovups zmm19, [r15 + r14 + 64]
    vmovups zmm22, [r15 + r14 + 128]
    vmovups zmm23, [r15 + r14 + 192]
M5p_a4dc
    vmovaps zmm16{k1}, zmm17
    vmulps zmm5, zmm16, zmm15
M5p_a4dd
    vmovaps zmm16{k2}, zmm17
    vfmadd231ps zmm5, zmm16, zmm24
M5p_a4de
    vmovaps zmm16{k3}, zmm17
M5p_a4d7
M5p_a10c
    lea r15, [r15 + r14*2]
M5p_a4da
M5p_a4de
M5p_a4e1
M5p_a4e5
M5p_a106
M5p_a283
M5p_a113
M5p_a121
M5p_a12c
M5p_a139
M5p_a143
M5p_a148
M5p_a117
M5p_a11b
M5p_a4c6
M5p_a125
M5p_a4d1
M5p_a12f
M5p_a133
M5p_a287
M5p_a151
M5p_a155
M5p_a15a
M5p_a15e
M5p_a3d
M5p_a162
M5p_a37
M5p_a47
M5p_a163
M5p_a329
M5p_a16a
M5p_a171
M5p_a179
M5p_a17c
M5p_a180
M5p_a188
M5p_a197
M5p_a1a2
M5p_a1a6
M5p_a1a9
M5p_a1ac
M5p_a1b0
M5p_a1b9
M5p_a1b5
M5p_a1bf
M5p_a1c5
M5p_a1bf
M5p_a1c8
M5p_a1cc
M5p_a192
M5p_a1cf
M5p_a400
M5p_a1d3
M5p_a1d6
M5p_a1da
M5p_a1dd
M5p_a1e0
M5p_a1e4
M5p_a1e7
M5p_a1ea
M5p_a1ed
M5p_a1fa
M5p_a206
M5p_a210
M5p_a21a
M5p_a1f5
M5p_a1ff
M5p_a221
M5p_a223
M5p_a214
M5p_a227
M5p_a229
M5p_a1f9
M5p_a22d
M5p_a22f
M5p_a214
M5p_a233
M5p_a235
M5p_a238
M5p_a23a
M5p_a23c
M5p_a241
M5p_a244
M5p_a247
M5p_a24a
M5p_a24d
M5p_a251
M5p_a254
M5p_a257
M5p_a25a
M5p_a25d
M5p_a260
M5p_a263
M5p_a266
M5p_a269
M5p_a26c
M5p_a26f
    ret
section .note.GNU-stack noalloc noexec nowrite progbits
