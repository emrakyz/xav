%include "p5nm.inc"
default rel
%include "gpo.inc"
%include "gpimg.inc"
M5p_a0
M5p_a1
M5p_a2
M5p_a3
M5p_a4
global xav_p5_0_13_7
align 64
xav_p5_0_13_7:
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
M5p_a59
M5p_a361
M5p_a5c
M5p_a291
M5p_a364
    kmovw k3, [rsi + 12]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm0, zmm16, [rcx + 0]
M5p_a367
M5p_a368
    kmovw k3, [rsi + 26]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 64]
M5p_a36a
M5p_a36e
    kmovw k3, [rsi + 40]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 128]
M5p_a36f
M5p_a373
    kmovw k3, [rsi + 54]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 192]
M5p_a375
M5p_a379
    kmovw k3, [rsi + 68]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 256]
M5p_a93
M5p_a37b
    kmovw k3, [rsi + 82]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 320]
M5p_a2bf
M5p_a2c5
M5p_a37c
    kmovw k3, [rsi + 96]
    vmovaps zmm16{k3}, zmm17
M5p_a37e
M5p_a38d
M5p_a39b
    kmovw k3, [rsi + 180]
M5p_a355
M5p_ab2
    vmovups zmm9, [r8 + r14 + 640]
    vmovups zmm10, [r8 + r14 + 704]
    vmovups zmm11, [r8 + r14 + 768]
    vmovups zmm12, [r8 + r14 + 832]
M5p_a5c
M5p_a291
M5p_a364
    kmovw k3, [rsi + 12]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm1, zmm16, [rcx + 0]
M5p_a367
M5p_a368
    kmovw k3, [rsi + 26]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 64]
M5p_a36a
M5p_a36e
    kmovw k3, [rsi + 40]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 128]
M5p_a36f
M5p_a373
    kmovw k3, [rsi + 54]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 192]
M5p_a375
M5p_a379
    kmovw k3, [rsi + 68]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 256]
M5p_a93
M5p_a37b
    kmovw k3, [rsi + 82]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 320]
M5p_a2bf
M5p_a2c5
M5p_a37c
    kmovw k3, [rsi + 96]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 384]
M5p_a37f
M5p_a382
    kmovw k3, [rsi + 110]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 448]
M5p_a383
M5p_a387
    kmovw k3, [rsi + 124]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 512]
M5p_a38a
M5p_a390
    kmovw k3, [rsi + 138]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 576]
M5p_a392
M5p_a395
    kmovw k3, [rsi + 152]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 640]
M5p_a396
M5p_a399
    kmovw k3, [rsi + 166]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 704]
M5p_a39d
M5p_a3a5
    kmovw k3, [rsi + 180]
M5p_a357
M5p_a3b9
M5p_a5c
M5p_a291
M5p_a364
    kmovw k3, [rsi + 12]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm2, zmm16, [rcx + 0]
M5p_a367
M5p_a368
    kmovw k3, [rsi + 26]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 64]
M5p_a36a
M5p_a36e
    kmovw k3, [rsi + 40]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 128]
M5p_a36f
M5p_a373
    kmovw k3, [rsi + 54]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 192]
M5p_a375
M5p_a379
    kmovw k3, [rsi + 68]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 256]
M5p_a93
M5p_a37b
    kmovw k3, [rsi + 82]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 320]
M5p_a2bf
M5p_a2c5
M5p_a37c
    kmovw k3, [rsi + 96]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 384]
M5p_a37f
M5p_a382
    kmovw k3, [rsi + 110]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 448]
M5p_a383
M5p_a387
    kmovw k3, [rsi + 124]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 512]
M5p_a38a
M5p_a390
    kmovw k3, [rsi + 138]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 576]
M5p_a392
M5p_a395
    kmovw k3, [rsi + 152]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 640]
M5p_a396
M5p_a399
    kmovw k3, [rsi + 166]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 704]
M5p_a39d
M5p_a3a5
    kmovw k3, [rsi + 180]
M5p_a359
M5p_ad2
M5p_a3c9
M5p_a5c
M5p_a291
M5p_a364
    kmovw k3, [rsi + 12]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm3, zmm16, [rcx + 0]
M5p_a367
M5p_a368
    kmovw k3, [rsi + 26]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 64]
M5p_a36a
M5p_a36e
    kmovw k3, [rsi + 40]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 128]
M5p_a36f
M5p_a373
    kmovw k3, [rsi + 54]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 192]
M5p_a375
M5p_a379
    kmovw k3, [rsi + 68]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 256]
M5p_a93
M5p_a37b
    kmovw k3, [rsi + 82]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 320]
M5p_a2bf
M5p_a2c5
M5p_a37c
    kmovw k3, [rsi + 96]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 384]
M5p_a37f
M5p_a382
    kmovw k3, [rsi + 110]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 448]
M5p_a383
M5p_a387
    kmovw k3, [rsi + 124]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 512]
M5p_a38a
M5p_a390
    kmovw k3, [rsi + 138]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 576]
M5p_a392
M5p_a395
    kmovw k3, [rsi + 152]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 640]
M5p_a396
M5p_a399
    kmovw k3, [rsi + 166]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 704]
M5p_a39d
M5p_a3a5
    kmovw k3, [rsi + 180]
M5p_a35b
M5p_a3d7
M5p_a5c
M5p_a291
M5p_a364
    kmovw k3, [rsi + 12]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm4, zmm16, [rcx + 0]
M5p_a367
M5p_a368
    kmovw k3, [rsi + 26]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 64]
M5p_a36a
M5p_a36e
    kmovw k3, [rsi + 40]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 128]
M5p_a36f
M5p_a373
    kmovw k3, [rsi + 54]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 192]
M5p_a375
M5p_a379
    kmovw k3, [rsi + 68]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 256]
M5p_a93
M5p_a37b
    kmovw k3, [rsi + 82]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 320]
M5p_a2bf
M5p_a2c5
M5p_a37c
    kmovw k3, [rsi + 96]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 384]
M5p_a37f
M5p_a382
    kmovw k3, [rsi + 110]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 448]
M5p_a383
M5p_a387
    kmovw k3, [rsi + 124]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 512]
M5p_a38a
M5p_a390
    kmovw k3, [rsi + 138]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 576]
M5p_a392
M5p_a395
    kmovw k3, [rsi + 152]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 640]
M5p_a396
M5p_a399
    kmovw k3, [rsi + 166]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 704]
M5p_a39d
M5p_a3a5
    kmovw k3, [rsi + 180]
M5p_a35d
M5p_af6
M5p_a3e6
M5p_a5c
M5p_a291
M5p_a364
    kmovw k3, [rsi + 12]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm5, zmm16, [rcx + 0]
M5p_a367
M5p_a368
    kmovw k3, [rsi + 26]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 64]
M5p_a36a
M5p_a36e
    kmovw k3, [rsi + 40]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 128]
M5p_a36f
M5p_a373
    kmovw k3, [rsi + 54]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 192]
M5p_a375
M5p_a379
    kmovw k3, [rsi + 68]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 256]
M5p_a93
M5p_a37b
    kmovw k3, [rsi + 82]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 320]
M5p_a2bf
M5p_a2c5
M5p_a37c
    kmovw k3, [rsi + 96]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 384]
M5p_a37f
M5p_a382
    kmovw k3, [rsi + 110]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 448]
M5p_a383
M5p_a387
    kmovw k3, [rsi + 124]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 512]
M5p_a38a
M5p_a390
    kmovw k3, [rsi + 138]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 576]
M5p_a392
M5p_a395
    kmovw k3, [rsi + 152]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 640]
M5p_a396
M5p_a399
    kmovw k3, [rsi + 166]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 704]
M5p_a39d
M5p_a3a5
    kmovw k3, [rsi + 180]
M5p_a35f
M5p_a362
M5p_a36b
M5p_a378
M5p_a37e
M5p_a38d
M5p_a39a
M5p_a323
    vpermi2ps zmm17, zmm9, zmm10
M5p_a364
M5p_a3aa
M5p_a370
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3ad
M5p_a2c1
M5p_a2c4
    vpermi2ps zmm17, zmm9, zmm10
M5p_a37c
M5p_a3b0
M5p_a38c
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3b4
M5p_a3a0
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3b8
M5p_a368
M5p_a3bc
M5p_a376
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3bf
M5p_a381
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3c2
M5p_a393
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3c6
    vmovups zmm29, [r9 + r14 + 448]
M5p_a33f
M5p_a3ca
M5p_a36d
M5p_a3cd
M5p_a96
    vpermi2ps zmm17, zmm30, zmm31
M5p_a37b
M5p_a3cf
M5p_a386
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3d2
M5p_a397
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3d6
M5p_a291
M5p_a364
M5p_a3d9
M5p_a370
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3dc
M5p_a2c1
M5p_a2c4
M5p_a3fa
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3df
M5p_a38c
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3e2
M5p_a3a0
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3e5
M5p_a369
M5p_a3ea
M5p_a376
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3ee
M5p_a381
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3f1
M5p_a393
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3f5
M5p_a39e
M5p_a3a6
M5p_a360
M5p_a282
M5p_a112
M5p_a120
M5p_a12b
M5p_a138
M5p_a142
M5p_a147
M5p_a116
M5p_a11a
M5p_a14b
M5p_a128
M5p_a14c
M5p_a132
M5p_a136
M5p_a286
M5p_a150
M5p_a154
M5p_a159
M5p_a15d
M5p_a3c
M5p_a161
M5p_a35
M5p_a46
M5p_a328
    cmp rcx, r8
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
    vcvtss2sd xmm1, xmm1, xmm1
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
