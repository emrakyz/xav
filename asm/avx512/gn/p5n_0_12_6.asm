%include "p5nm.inc"
default rel
%include "gpo.inc"
%include "gpimg.inc"
M5p_a0
M5p_a1
M5p_a2
M5p_a3
M5p_a4
global xav_p5_0_12_6
align 64
xav_p5_0_12_6:
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
M5p_a290
M5p_a2a9
M5p_a8e
M5p_a320
M5p_a2c8
M5p_a2d1
M5p_a2d7
M5p_a32b
M5p_a331
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 704]
M5p_ab0
    vmovups zmm30, [r8 + r14 + 512]
    vmovups zmm31, [r8 + r14 + 576]
M5p_a2dd
M5p_a2a8
M5p_a2e0
M5p_a31f
M5p_a321
M5p_a2cb
M5p_a2e9
M5p_a2d6
M5p_a2db
    kmovw k3, [rsi + 130]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 640]
M5p_a32e
M5p_a335
    kmovw k3, [rsi + 142]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 704]
M5p_abe
M5p_ac4
    vmovups zmm30, [r9 + 512]
    vmovups zmm31, [r9 + 576]
M5p_a2ea
M5p_a2a8
M5p_a2ed
M5p_a31f
    vpermi2ps zmm17, zmm9, zmm10
M5p_a2f1
M5p_a2cc
M5p_a322
M5p_a2d4
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 640]
M5p_a32e
M5p_a335
    kmovw k3, [rsi + 142]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 704]
M5p_acd
    vmovups zmm30, [r9 + r14 + 512]
    vmovups zmm31, [r9 + r14 + 576]
M5p_a2f7
M5p_a2a8
M5p_a2fa
M5p_a31f
    vpermi2ps zmm17, zmm9, zmm10
M5p_a2fe
M5p_a2cc
    vpermi2ps zmm17, zmm9, zmm10
M5p_a303
M5p_a2d5
    vfmadd231ps zmm3, zmm16, [rcx + 640]
M5p_a32e
M5p_a335
    kmovw k3, [rsi + 142]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 704]
M5p_ae0
M5p_ae5
    vmovups zmm30, [r15 + 512]
    vmovups zmm31, [r15 + 576]
M5p_a305
M5p_a2a8
M5p_a308
M5p_a31f
    vpermi2ps zmm17, zmm9, zmm10
M5p_a30c
M5p_a2cc
    vpermi2ps zmm17, zmm9, zmm10
M5p_a310
M5p_a2d5
    vfmadd231ps zmm4, zmm16, [rcx + 640]
M5p_a32e
M5p_a335
    kmovw k3, [rsi + 142]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 704]
M5p_af3
    vmovups zmm30, [r15 + r14 + 512]
    vmovups zmm31, [r15 + r14 + 576]
M5p_a312
M5p_a2a8
M5p_a316
M5p_a31f
    vpermi2ps zmm17, zmm9, zmm10
M5p_a31a
M5p_a2cc
    vpermi2ps zmm17, zmm9, zmm10
M5p_a31d
M5p_a2d5
    vfmadd231ps zmm5, zmm16, [rcx + 640]
M5p_a32e
M5p_a335
    kmovw k3, [rsi + 142]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 704]
M5p_a104
M5p_a10e
M5p_a57
M5p_a28f
M5p_a2a7
M5p_a8c
M5p_a2bb
M5p_a2ca
M5p_a2d2
M5p_a2d9
M5p_a32c
M5p_a299
M5p_a2de
M5p_a2b6
M5p_a2e2
M5p_a2c4
    vpermi2ps zmm17, zmm9, zmm10
M5p_a2e6
M5p_a2da
    vpermi2ps zmm17, zmm9, zmm10
M5p_a338
M5p_a2ec
M5p_a2af
M5p_a2f0
M5p_a2be
M5p_a2f3
M5p_a2cf
    vpermi2ps zmm17, zmm9, zmm10
M5p_a2f6
M5p_a2d8
M5p_a33c
M5p_a298
M5p_a2f9
M5p_a2b5
    vpermi2ps zmm17, zmm9, zmm10
M5p_a2fd
M5p_a2c4
    vpermi2ps zmm17, zmm9, zmm10
M5p_a301
M5p_a2da
    vpermi2ps zmm17, zmm9, zmm10
    kmovw k3, [rsi + 130]
    vmovaps zmm16{k3}, zmm17
M5p_a340
M5p_a295
M5p_a29c
M5p_a307
M5p_a2b6
M5p_a30b
M5p_a2c4
    vpermi2ps zmm17, zmm9, zmm10
M5p_a30f
M5p_a2da
    vpermi2ps zmm17, zmm9, zmm10
    kmovw k3, [rsi + 130]
    vmovaps zmm16{k3}, zmm17
M5p_a344
M5p_a299
M5p_a314
M5p_a2b6
M5p_a318
M5p_a2c4
M5p_a324
M5p_a2d9
M5p_a348
M5p_a334
    vpermi2ps zmm17, zmm9, zmm10
M5p_a349
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
