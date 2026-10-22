%include "p5nm.inc"
default rel
%include "gpo.inc"
%include "gpimg.inc"
M5p_a0
M5p_a1
M5p_a2
M5p_a3
M5p_a4
global xav_p5_0_15_8
align 64
xav_p5_0_15_8:
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
    vmovups zmm13, [r8 + 896]
    vmovups zmm7, [r8 + 960]
M5p_a5c
M5p_a291
M5p_a364
M5p_a42e
    kmovw k3, [rsi + 14]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm0, zmm16, [rcx + 0]
M5p_a430
M5p_a437
M5p_a438
    kmovw k3, [rsi + 30]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 64]
M5p_a43b
M5p_a43f
M5p_a440
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 128]
M5p_a2b1
M5p_a2b6
M5p_a441
    kmovw k3, [rsi + 62]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 192]
M5p_a444
M5p_a448
M5p_a44a
    kmovw k3, [rsi + 78]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 256]
M5p_a9a
M5p_a44c
M5p_a44e
    kmovw k3, [rsi + 94]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 320]
M5p_a2c6
M5p_a2cd
M5p_a450
    kmovw k3, [rsi + 110]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 384]
M5p_a383
M5p_a387
M5p_a452
    kmovw k3, [rsi + 126]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 448]
M5p_a454
M5p_a455
M5p_a457
    kmovw k3, [rsi + 142]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 512]
M5p_a351
M5p_a353
M5p_a458
    kmovw k3, [rsi + 158]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 576]
M5p_a45a
M5p_a45b
M5p_a45c
M5p_a46a
    kmovw k3, [rsi + 238]
M5p_a422
    vmovups zmm13, [r8 + r14 + 896]
    vmovups zmm7, [r8 + r14 + 960]
M5p_a5c
M5p_a291
M5p_a364
M5p_a42e
    kmovw k3, [rsi + 14]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm1, zmm16, [rcx + 0]
M5p_a430
M5p_a437
M5p_a438
    kmovw k3, [rsi + 30]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 64]
M5p_a43b
M5p_a43f
M5p_a440
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 128]
M5p_a2b1
M5p_a2b6
M5p_a441
    kmovw k3, [rsi + 62]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 192]
M5p_a444
M5p_a448
M5p_a44a
    kmovw k3, [rsi + 78]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 256]
M5p_a9a
M5p_a44c
M5p_a44e
    kmovw k3, [rsi + 94]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 320]
M5p_a2c6
M5p_a2cd
M5p_a450
    kmovw k3, [rsi + 110]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 384]
M5p_a383
M5p_a387
M5p_a452
    kmovw k3, [rsi + 126]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 448]
M5p_a454
M5p_a455
M5p_a457
    kmovw k3, [rsi + 142]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 512]
M5p_a351
M5p_a353
M5p_a458
    kmovw k3, [rsi + 158]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 576]
M5p_a45a
M5p_a45b
M5p_a45d
    kmovw k3, [rsi + 174]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 640]
M5p_a45e
M5p_a460
M5p_a462
    kmovw k3, [rsi + 190]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 704]
M5p_a464
M5p_a466
M5p_a468
    kmovw k3, [rsi + 206]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 768]
M5p_a46b
M5p_a46d
M5p_a46f
    kmovw k3, [rsi + 222]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 832]
M5p_a471
M5p_a472
M5p_a473
    kmovw k3, [rsi + 238]
M5p_a424
M5p_a3b9
    vmovups zmm13, [r9 + 896]
    vmovups zmm7, [r9 + 960]
M5p_a5c
M5p_a291
M5p_a364
M5p_a42e
    kmovw k3, [rsi + 14]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm2, zmm16, [rcx + 0]
M5p_a430
M5p_a437
M5p_a438
    kmovw k3, [rsi + 30]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 64]
M5p_a43b
M5p_a43f
M5p_a440
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 128]
M5p_a2b1
M5p_a2b6
M5p_a441
    kmovw k3, [rsi + 62]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 192]
M5p_a444
M5p_a448
M5p_a44a
    kmovw k3, [rsi + 78]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 256]
M5p_a9a
M5p_a44c
M5p_a44e
    kmovw k3, [rsi + 94]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 320]
M5p_a2c6
M5p_a2cd
M5p_a450
    kmovw k3, [rsi + 110]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 384]
M5p_a383
M5p_a387
M5p_a452
    kmovw k3, [rsi + 126]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 448]
M5p_a454
M5p_a455
M5p_a457
    kmovw k3, [rsi + 142]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 512]
M5p_a351
M5p_a353
M5p_a458
    kmovw k3, [rsi + 158]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 576]
M5p_a45a
M5p_a45b
M5p_a45d
    kmovw k3, [rsi + 174]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 640]
M5p_a45e
M5p_a460
M5p_a462
    kmovw k3, [rsi + 190]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 704]
M5p_a464
M5p_a466
M5p_a468
    kmovw k3, [rsi + 206]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 768]
M5p_a46b
M5p_a46d
M5p_a46f
    kmovw k3, [rsi + 222]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 832]
M5p_a471
M5p_a472
M5p_a473
    kmovw k3, [rsi + 238]
M5p_a426
    vmovups zmm13, [r9 + r14 + 896]
    vmovups zmm7, [r9 + r14 + 960]
M5p_a5c
M5p_a291
M5p_a364
M5p_a42e
    kmovw k3, [rsi + 14]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm3, zmm16, [rcx + 0]
M5p_a430
M5p_a437
M5p_a438
    kmovw k3, [rsi + 30]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 64]
M5p_a43b
M5p_a43f
M5p_a440
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 128]
M5p_a2b1
M5p_a2b6
M5p_a441
    kmovw k3, [rsi + 62]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 192]
M5p_a444
M5p_a448
M5p_a44a
    kmovw k3, [rsi + 78]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 256]
M5p_a9a
M5p_a44c
M5p_a44e
    kmovw k3, [rsi + 94]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 320]
M5p_a2c6
M5p_a2cd
M5p_a450
    kmovw k3, [rsi + 110]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 384]
M5p_a383
M5p_a387
M5p_a452
    kmovw k3, [rsi + 126]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 448]
M5p_a454
M5p_a455
M5p_a457
    kmovw k3, [rsi + 142]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 512]
M5p_a351
M5p_a353
M5p_a458
    kmovw k3, [rsi + 158]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 576]
M5p_a45a
M5p_a45b
M5p_a45d
    kmovw k3, [rsi + 174]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 640]
M5p_a45e
M5p_a460
M5p_a462
    kmovw k3, [rsi + 190]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 704]
M5p_a464
M5p_a466
M5p_a468
    kmovw k3, [rsi + 206]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 768]
M5p_a46b
M5p_a46d
M5p_a46f
    kmovw k3, [rsi + 222]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 832]
M5p_a471
M5p_a472
M5p_a473
    kmovw k3, [rsi + 238]
M5p_a428
M5p_a3d7
    vmovups zmm13, [r15 + 896]
    vmovups zmm7, [r15 + 960]
M5p_a5c
M5p_a291
M5p_a364
M5p_a42e
    kmovw k3, [rsi + 14]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm4, zmm16, [rcx + 0]
M5p_a430
M5p_a437
M5p_a438
    kmovw k3, [rsi + 30]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 64]
M5p_a43b
M5p_a43f
M5p_a440
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 128]
M5p_a2b1
M5p_a2b6
M5p_a441
    kmovw k3, [rsi + 62]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 192]
M5p_a444
M5p_a448
M5p_a44a
    kmovw k3, [rsi + 78]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 256]
M5p_a9a
M5p_a44c
M5p_a44e
    kmovw k3, [rsi + 94]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 320]
M5p_a2c6
M5p_a2cd
M5p_a450
    kmovw k3, [rsi + 110]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 384]
M5p_a383
M5p_a387
M5p_a452
    kmovw k3, [rsi + 126]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 448]
M5p_a454
M5p_a455
M5p_a457
    kmovw k3, [rsi + 142]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 512]
M5p_a351
M5p_a353
M5p_a458
    kmovw k3, [rsi + 158]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 576]
M5p_a45a
M5p_a45b
M5p_a45d
    kmovw k3, [rsi + 174]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 640]
M5p_a45e
M5p_a460
M5p_a462
    kmovw k3, [rsi + 190]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 704]
M5p_a464
M5p_a466
M5p_a468
    kmovw k3, [rsi + 206]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 768]
M5p_a46b
M5p_a46d
M5p_a46f
    kmovw k3, [rsi + 222]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 832]
M5p_a471
M5p_a472
M5p_a473
    kmovw k3, [rsi + 238]
M5p_a42a
    vmovups zmm13, [r15 + r14 + 896]
    vmovups zmm7, [r15 + r14 + 960]
M5p_a5c
M5p_a291
M5p_a364
M5p_a42e
    kmovw k3, [rsi + 14]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm5, zmm16, [rcx + 0]
M5p_a430
M5p_a437
M5p_a438
    kmovw k3, [rsi + 30]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 64]
M5p_a43b
M5p_a43f
M5p_a440
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 128]
M5p_a2b1
M5p_a2b6
M5p_a441
    kmovw k3, [rsi + 62]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 192]
M5p_a444
M5p_a448
M5p_a44a
    kmovw k3, [rsi + 78]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 256]
M5p_a9a
M5p_a44c
M5p_a44e
    kmovw k3, [rsi + 94]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 320]
M5p_a2c6
M5p_a2cd
M5p_a450
    kmovw k3, [rsi + 110]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 384]
M5p_a383
M5p_a387
M5p_a452
    kmovw k3, [rsi + 126]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 448]
M5p_a454
M5p_a455
M5p_a457
    kmovw k3, [rsi + 142]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 512]
M5p_a351
M5p_a353
M5p_a458
    kmovw k3, [rsi + 158]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 576]
M5p_a45a
M5p_a45b
M5p_a45d
    kmovw k3, [rsi + 174]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 640]
M5p_a45e
M5p_a460
M5p_a462
    kmovw k3, [rsi + 190]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 704]
M5p_a464
M5p_a466
M5p_a468
    kmovw k3, [rsi + 206]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 768]
M5p_a46b
M5p_a46d
M5p_a46f
    kmovw k3, [rsi + 222]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 832]
M5p_a471
M5p_a472
M5p_a473
    kmovw k3, [rsi + 238]
M5p_a42c
M5p_a361
M5p_a42d
M5p_a439
M5p_a446
M5p_a2c7
M5p_a451
M5p_a456
M5p_a45c
M5p_a46a
M5p_a474
M5p_a436
M5p_a477
M5p_a445
M5p_a449
M5p_a44b
M5p_a47a
M5p_a383
M5p_a387
M5p_a452
M5p_a47d
M5p_a480
M5p_a465
M5p_a467
M5p_a469
M5p_a483
M5p_abe
M5p_ac4
M5p_a33a
    vmovups zmm11, [r9 + 768]
    vmovups zmm12, [r9 + 832]
M5p_a485
M5p_a43b
M5p_a43f
M5p_a440
M5p_a488
M5p_a48b
M5p_a384
M5p_a388
M5p_a453
M5p_a48e
M5p_a45a
M5p_a45b
M5p_a45d
M5p_a491
M5p_a494
M5p_ad0
    vmovups zmm31, [r9 + r14 + 576]
M5p_a3c9
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
M5p_a4a0
M5p_ae2
M5p_ae6
    vmovups zmm31, [r15 + 576]
M5p_a3d7
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
M5p_a4ac
M5p_af4
    vmovups zmm31, [r15 + r14 + 576]
M5p_a3e6
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
M5p_a4ba
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
