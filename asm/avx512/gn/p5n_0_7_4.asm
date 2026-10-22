%include "p5nm.inc"
default rel
%include "gpo.inc"
%include "gpimg.inc"
M5p_a0
M5p_a1
M5p_a2
M5p_a3
M5p_a4
global xav_p5_0_7_4
align 64
xav_p5_0_7_4:
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
M5p_a4a
    vmovups zmm28, [r8 + 384]
    vmovups zmm29, [r8 + 448]
M5p_a5b
M5p_a5e
    kmovw k3, [rsi + 6]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm0, zmm16, [rcx + 0]
M5p_a527
M5p_a528
    kmovw k3, [rsi + 14]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 64]
M5p_a431
M5p_a434
    kmovw k3, [rsi + 22]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 128]
M5p_a29f
M5p_a2a5
    kmovw k3, [rsi + 30]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 192]
M5p_a43a
M5p_a43d
    kmovw k3, [rsi + 38]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 256]
M5p_a78
M5p_a7b
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 320]
M5p_a2b0
M5p_a2b4
    kmovw k3, [rsi + 54]
M5p_a51a
    vmovups zmm28, [r8 + r14 + 384]
    vmovups zmm29, [r8 + r14 + 448]
M5p_a5b
M5p_a5e
    kmovw k3, [rsi + 6]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm1, zmm16, [rcx + 0]
M5p_a527
M5p_a528
    kmovw k3, [rsi + 14]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 64]
M5p_a431
M5p_a434
    kmovw k3, [rsi + 22]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 128]
M5p_a29f
M5p_a2a5
    kmovw k3, [rsi + 30]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 192]
M5p_a43a
M5p_a43d
    kmovw k3, [rsi + 38]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 256]
M5p_a78
M5p_a7b
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 320]
M5p_a2b0
M5p_a2b4
    kmovw k3, [rsi + 54]
M5p_a51c
M5p_ac3
    vmovups zmm28, [r9 + 384]
    vmovups zmm29, [r9 + 448]
M5p_a5b
M5p_a5e
    kmovw k3, [rsi + 6]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm2, zmm16, [rcx + 0]
M5p_a527
M5p_a528
    kmovw k3, [rsi + 14]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 64]
M5p_a431
M5p_a434
    kmovw k3, [rsi + 22]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 128]
M5p_a29f
M5p_a2a5
    kmovw k3, [rsi + 30]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 192]
M5p_a43a
M5p_a43d
    kmovw k3, [rsi + 38]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 256]
M5p_a78
M5p_a7b
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 320]
M5p_a2b0
M5p_a2b4
    kmovw k3, [rsi + 54]
M5p_a51e
    vmovups zmm28, [r9 + r14 + 384]
    vmovups zmm29, [r9 + r14 + 448]
M5p_a5b
M5p_a5e
    kmovw k3, [rsi + 6]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm3, zmm16, [rcx + 0]
M5p_a527
M5p_a528
    kmovw k3, [rsi + 14]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 64]
M5p_a431
M5p_a434
    kmovw k3, [rsi + 22]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 128]
M5p_a29f
M5p_a2a5
    kmovw k3, [rsi + 30]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 192]
M5p_a43a
M5p_a43d
    kmovw k3, [rsi + 38]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 256]
M5p_a78
M5p_a7b
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 320]
M5p_a2b0
M5p_a2b4
    kmovw k3, [rsi + 54]
M5p_a520
M5p_ae3
    vmovups zmm28, [r15 + 384]
    vmovups zmm29, [r15 + 448]
M5p_a5b
M5p_a5e
    kmovw k3, [rsi + 6]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm4, zmm16, [rcx + 0]
M5p_a527
M5p_a528
    kmovw k3, [rsi + 14]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 64]
M5p_a431
M5p_a434
    kmovw k3, [rsi + 22]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 128]
M5p_a29f
M5p_a2a5
    kmovw k3, [rsi + 30]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 192]
M5p_a43a
M5p_a43d
    kmovw k3, [rsi + 38]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 256]
M5p_a78
M5p_a7b
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 320]
M5p_a2b0
M5p_a2b4
    kmovw k3, [rsi + 54]
M5p_a522
    vmovups zmm28, [r15 + r14 + 384]
    vmovups zmm29, [r15 + r14 + 448]
M5p_a5b
M5p_a5e
    kmovw k3, [rsi + 6]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm5, zmm16, [rcx + 0]
M5p_a527
M5p_a528
    kmovw k3, [rsi + 14]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 64]
M5p_a431
M5p_a434
    kmovw k3, [rsi + 22]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 128]
M5p_a29f
M5p_a2a5
    kmovw k3, [rsi + 30]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 192]
M5p_a43a
M5p_a43d
    kmovw k3, [rsi + 38]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 256]
M5p_a78
M5p_a7b
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 320]
M5p_a2b0
M5p_a2b4
    kmovw k3, [rsi + 54]
M5p_a524
M5p_a10a
M5p_a56
M5p_a525
M5p_a43c
M5p_a43e
M5p_a52a
M5p_a529
M5p_a52e
M5p_a2b3
    vpermi2ps zmm17, zmm28, zmm29
M5p_a533
M5p_a2a3
M5p_a537
M5p_a5e
M5p_a53a
M5p_a79
M5p_a7c
M5p_a53d
M5p_a432
M5p_a541
M5p_af5
M5p_a546
M5p_a43c
M5p_a43e
M5p_a54a
M5p_a107
M5p_a10f
M5p_a114
M5p_a122
M5p_a12d
M5p_a13a
M5p_a144
M5p_a149
M5p_a118
M5p_a11c
M5p_a284
M5p_a126
M5p_a326
M5p_a130
M5p_a134
M5p_a14d
M5p_a152
M5p_a156
M5p_a15b
M5p_a3a
M5p_a15f
M5p_a44
M5p_a49
M5p_a164
M5p_a288
M5p_a16b
M5p_a16d
M5p_a172
M5p_a175
M5p_a17a
M5p_a17e
M5p_a183
M5p_a18c
M5p_a19b
M5p_a1a4
M5p_a1ae
M5p_a1b1
M5p_a1bb
M5p_a1b6
M5p_a28a
M5p_a1ba
M5p_a32a
M5p_a1c9
M5p_a18f
M5p_a194
M5p_a1d0
M5p_a1d1
M5p_a1d4
M5p_a1d7
M5p_a1db
M5p_a1de
M5p_a1e1
M5p_a1e5
M5p_a1e8
M5p_a1eb
M5p_a1ee
M5p_a1fc
M5p_a207
M5p_a211
M5p_a21c
M5p_a1f6
M5p_a200
M5p_a222
M5p_a224
M5p_a215
M5p_a228
M5p_a22a
M5p_a1fb
M5p_a22e
M5p_a230
M5p_a215
M5p_a234
M5p_a236
M5p_a189
M5p_a239
M5p_a199
M5p_a28c
M5p_a23e
M5p_a242
M5p_a245
M5p_a248
M5p_a24b
M5p_a24e
M5p_a252
M5p_a255
M5p_a258
M5p_a25b
M5p_a25e
M5p_a261
M5p_a264
M5p_a267
M5p_a26a
M5p_a26d
M5p_a270
section .note.GNU-stack noalloc noexec nowrite progbits
