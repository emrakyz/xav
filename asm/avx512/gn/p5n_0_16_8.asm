%include "p5nm.inc"
default rel
%include "gpo.inc"
%include "gpimg.inc"
M5p_a0
M5p_a1
M5p_a2
M5p_a3
M5p_a4
global xav_p5_0_16_8
align 64
xav_p5_0_16_8:
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
M5p_a42d
M5p_a439
M5p_a446
M5p_a2c7
M5p_a451
M5p_a456
M5p_a45c
M5p_a46a
    kmovw k3, [rsi + 238]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 896]
M5p_a4be
M5p_a4bf
M5p_a4c0
    kmovw k3, [rsi + 254]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 960]
M5p_ab0
M5p_a337
    vmovups zmm11, [r8 + r14 + 768]
    vmovups zmm12, [r8 + r14 + 832]
M5p_a475
M5p_a43b
M5p_a43f
M5p_a440
M5p_a478
M5p_a47b
M5p_a384
M5p_a388
M5p_a453
M5p_a47e
M5p_a45a
M5p_a45b
M5p_a45d
M5p_a481
M5p_a484
M5p_a471
M5p_a472
M5p_a473
    kmovw k3, [rsi + 238]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 896]
M5p_a4be
M5p_a4bf
M5p_a4c0
    kmovw k3, [rsi + 254]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 960]
M5p_abe
M5p_ac4
M5p_a33a
M5p_a4bc
M5p_a487
M5p_a444
M5p_a448
M5p_a44a
M5p_a48a
M5p_a48d
M5p_a352
M5p_a354
M5p_a459
M5p_a490
M5p_a464
M5p_a466
M5p_a468
M5p_a493
    vfmadd231ps zmm2, zmm16, [rcx + 896]
M5p_a4be
M5p_a4bf
M5p_a4c0
    kmovw k3, [rsi + 254]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 960]
M5p_acd
M5p_a33f
    vmovups zmm11, [r9 + r14 + 768]
    vmovups zmm12, [r9 + r14 + 832]
M5p_a495
M5p_a43b
M5p_a43f
M5p_a440
M5p_a497
M5p_a499
M5p_a384
M5p_a388
M5p_a453
M5p_a49b
M5p_a45a
M5p_a45b
M5p_a45d
M5p_a49d
M5p_a49f
M5p_a471
M5p_a472
M5p_a473
    kmovw k3, [rsi + 238]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 896]
M5p_a4be
M5p_a4bf
M5p_a4c0
    kmovw k3, [rsi + 254]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 960]
M5p_ae0
M5p_ae5
M5p_a342
    vmovups zmm11, [r15 + 768]
    vmovups zmm12, [r15 + 832]
M5p_a4a2
M5p_a43b
M5p_a43f
M5p_a440
M5p_a4a4
M5p_a4a6
M5p_a384
M5p_a388
M5p_a453
M5p_a4a8
M5p_a45a
M5p_a45b
M5p_a45d
M5p_a4aa
M5p_a4ad
M5p_a471
M5p_a472
M5p_a473
    kmovw k3, [rsi + 238]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 896]
M5p_a4be
M5p_a4bf
M5p_a4c0
    kmovw k3, [rsi + 254]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 960]
M5p_af3
M5p_a346
    vmovups zmm11, [r15 + r14 + 768]
    vmovups zmm12, [r15 + r14 + 832]
M5p_a4af
M5p_a43b
M5p_a43f
M5p_a440
M5p_a4b1
M5p_a4b3
M5p_a384
M5p_a388
M5p_a453
M5p_a4b5
M5p_a45a
M5p_a45b
M5p_a45d
M5p_a4b7
M5p_a4b9
M5p_a471
M5p_a472
M5p_a473
    kmovw k3, [rsi + 238]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 896]
M5p_a4be
M5p_a4bf
M5p_a4c0
    kmovw k3, [rsi + 254]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 960]
M5p_a104
M5p_a10e
M5p_a57
M5p_a28e
    vmovups zmm11, [r8 + 768]
    vmovups zmm12, [r8 + 832]
M5p_a42d
M5p_a439
M5p_a446
M5p_a2c7
M5p_a451
M5p_a456
M5p_a45c
M5p_a46a
M5p_a4bd
M5p_a62
M5p_a292
M5p_a366
M5p_a42f
M5p_a476
M5p_a2b2
M5p_a2b7
M5p_a442
M5p_a479
M5p_a2c6
M5p_a2cd
M5p_a450
M5p_a47c
M5p_a47f
M5p_a45f
M5p_a461
M5p_a463
M5p_a482
M5p_a471
M5p_a472
M5p_a473
M5p_a4c1
M5p_a5f
M5p_a292
M5p_a366
M5p_a42f
M5p_a486
M5p_a2b2
M5p_a2b7
M5p_a442
M5p_a489
M5p_a2c6
M5p_a2cd
M5p_a450
M5p_a48c
M5p_a48f
M5p_a45f
M5p_a461
M5p_a463
M5p_a492
M5p_a471
M5p_a472
M5p_a473
    kmovw k3, [rsi + 238]
    vmovaps zmm16{k3}, zmm17
M5p_a4c2
M5p_a291
M5p_a364
M5p_a42e
M5p_a496
M5p_a498
M5p_a9b
M5p_a44d
M5p_a44f
M5p_a49a
M5p_a454
M5p_a455
M5p_a457
M5p_a49c
M5p_a49e
M5p_a46c
M5p_a46e
M5p_a470
M5p_a4a1
M5p_a4c3
M5p_a61
M5p_a291
M5p_a364
M5p_a42e
M5p_a4a3
M5p_a4a5
M5p_a9b
M5p_a44d
M5p_a44f
M5p_a4a7
M5p_a454
M5p_a455
M5p_a457
M5p_a4a9
M5p_a4ab
M5p_a46c
M5p_a46e
M5p_a470
M5p_a4ae
M5p_a4c4
M5p_a291
M5p_a364
M5p_a42e
M5p_a4b0
M5p_a4b2
M5p_a9b
M5p_a44d
M5p_a44f
M5p_a4b4
M5p_a454
M5p_a455
M5p_a457
M5p_a4b6
M5p_a4b8
M5p_a46c
M5p_a46e
M5p_a470
M5p_a4bb
M5p_a4c5
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
    add r8, 256
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
