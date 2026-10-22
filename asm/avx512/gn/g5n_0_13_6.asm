%include "g5nm.inc"
default rel
%include "g5o.inc"
%include "g5img.inc"
M5s_a0
M5s_a1
M5s_a2
c_i1023: dd 1023
c_m1: dd -1
c_pft: dq xav_g5_0_13_6.pf1, xav_g5_0_13_6.pf2, xav_g5_0_13_6.pf3, xav_g5_0_13_6.pf4, xav_g5_0_13_6.pf5, xav_g5_0_13_6.pf6, xav_g5_0_13_6.pf7, xav_g5_0_13_6.pf8, xav_g5_0_13_6.pf9, xav_g5_0_13_6.pf10, xav_g5_0_13_6.pf11, xav_g5_0_13_6.pf12, xav_g5_0_13_6.pf13, xav_g5_0_13_6.pf14, xav_g5_0_13_6.pf15, xav_g5_0_13_6.pf16, xav_g5_0_13_6.pf17, xav_g5_0_13_6.pf18, xav_g5_0_13_6.pf19, xav_g5_0_13_6.pf20, xav_g5_0_13_6.pf21, xav_g5_0_13_6.pf22, xav_g5_0_13_6.pf23, xav_g5_0_13_6.pf24, xav_g5_0_13_6.pf25, xav_g5_0_13_6.pf26, xav_g5_0_13_6.pf27, xav_g5_0_13_6.pf28, xav_g5_0_13_6.pf29, xav_g5_0_13_6.pf30, xav_g5_0_13_6.pf31, xav_g5_0_13_6.pf32
M5s_a3
M5s_a4
c_qtr: dd 0x3e800000
section .text
global xav_g5_0_13_6
align 64
xav_g5_0_13_6:
M5s_a5
M5s_a7
M5s_aa
M5s_ab
M5s_ae
M5s_a10
M5s_a31
M5s_a5d
M5s_a53
M5s_a5b
M5s_a45a
M5s_a45e
M5s_a6b
M5s_a7a
M5s_a18
M5s_a3c
M5s_a2c
M5s_a46
M5s_a56
M5s_a4b2
M5s_a50
M5s_a7f
M5s_a36
M5s_a45b
M5s_a45f
M5s_a85
M5s_a28
M5s_a3d
M5s_a4d
M5s_a5e
M5s_a87
M5s_a53
M5s_a5b
M5s_a8c
M5s_a35
M5s_a45e
M5s_a6c
M5s_a8a
M5s_a8d
M5s_a8e
M5s_a3f
M5s_a4f
M5s_a462
M5s_a49
M5s_a59
M5s_a95
M5s_a5e
M5s_a32
M5s_a5f
M5s_a90
M5s_a4b4
M5s_a93
M5s_a99
M5s_a41
M5s_a50
M5s_a465
M5s_a46
M5s_a56
M5s_a469
M5s_aa4
M5s_a5a
M5s_a76
M5s_a62
M5s_a69
M5s_aa6
M5s_a67
M5s_a57b
M5s_a2b
M5s_a59
M5s_ab0
M5s_a47
M5s_a57
M5s_ab5
M5s_a57
M5s_a77
M5s_a63
M5s_a6c
M5s_ab3
M5s_aa1
M5s_aba
M5s_ab8
M5s_a468
M5s_a2c
M5s_a41
M5s_a50
M5s_abc
M5s_a56
M5s_a469
M5s_ac2
M5s_a60
M5s_abf
M5s_ac3
M5s_a16
M5s_a485
M5s_a25
M5s_a4f
M5s_a4ba
M5s_a51
M5s_acb
M5s_a38
M5s_a5f
M5s_ac6
M5s_a57e
M5s_ace
M5s_a3e
M5s_a4e
    vmulps zmm15, zmm15, zmm17
M5s_a4bb
M5s_a49
M5s_a59
M5s_ad7
M5s_a5e
M5s_a32
M5s_a5f
M5s_ad3
M5s_a46e
M5s_a57f
M5s_a37
M5s_a471
M5s_a46
M5s_a56
M5s_a469
M5s_aee
M5s_a5a
M5s_a76
M5s_a62
M5s_a69
M5s_ae6
M5s_aef
M5s_a586
    vfmadd231ps zmm10, zmm12, [r15 + Pc_w + 8]{1to16}
M5s_a472
M5s_af9
M5s_a2a
M5s_a107
M5s_a66
M5s_a70
M5s_a10b
M5s_a65
M5s_a6f
M5s_a10f
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a6a
M5s_a112
M5s_a2a
M5s_a108
M5s_a4c
M5s_a5c
M5s_a115
M5s_a50
M5s_a473
M5s_a36
M5s_a45b
M5s_a460
M5s_a4bc
M5s_a11a
M5s_a105
M5s_a4a
M5s_a5a
M5s_a11d
M5s_a4e
M5s_a469
M5s_a121
M5s_a4b3
M5s_a69
M5s_a89
M5s_a122
M5s_a126
M5s_a29
M5s_a106
M5s_a4b
M5s_a5b
M5s_a129
M5s_a47
M5s_a57
M5s_a477
M5s_a5b
M5s_a77
M5s_a63
M5s_a6c
M5s_a92
M5s_a12f
M5s_a47b
M5s_a29
M5s_a106
M5s_a4b
M5s_a5b
M5s_a133
M5s_a580
M5s_a9f
M5s_a138
    vmovups [r8 + rdi*4], zmm12
M5s_aa8
M5s_a582
    vmovups [r8 + rdi], zmm14
    vmulps zmm16, zmm16, [r15 + Pc_w + 4]{1to16}
M5s_a4b6
    vmovups [r8 + rcx], zmm11
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
M5s_a13b
M5s_a2a
M5s_a108
M5s_a4c
M5s_a5c
M5s_a13e
M5s_a47c
M5s_a54
M5s_a5c
M5s_a481
M5s_a58
M5s_a78
M5s_a64
M5s_a57c
M5s_a484
    vmovups [r8 + rcx], zmm11
M5s_a482
M5s_a57d
M5s_a144
M5s_a29
M5s_a106
M5s_a4b
M5s_a5b
M5s_a147
M5s_a53
M5s_a5b
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
M5s_a4bf
M5s_a45b
M5s_a583
M5s_a14d
M5s_a42
    vfmadd231ps zmm5, zmm8, [c_xgcb]{1to16}
    vmovaps zmm6, zmm7
M5s_a100
M5s_a2a
M5s_a47c
M5s_a54
M5s_a5c
M5s_a4c1
M5s_a50
M5s_a584
M5s_a36
M5s_a45b
    vpmaxud zmm22, zmm12, zmm16
M5s_ac6
M5s_a487
M5s_a152
M5s_a29
M5s_a106
M5s_a4b
M5s_a5b
M5s_a155
M5s_a47
M5s_a57
M5s_a4c2
M5s_a5b
M5s_a77
M5s_a63
M5s_a6c
M5s_a46c
M5s_a15a
M5s_a48b
M5s_a29
M5s_a106
M5s_a4b
M5s_a5b
M5s_a15e
M5s_a581
M5s_a53
M5s_a5b
M5s_a585
M5s_a57
M5s_a77
M5s_a63
M5s_a6c
M5s_ae7
M5s_af2
M5s_a164
M5s_af7
M5s_a491
M5s_a173
M5s_a16b
M5s_a17e
M5s_a188
M5s_a18b
M5s_a4c5
M5s_a4d4
M5s_a4ed
M5s_a504
M5s_a521
    vpermi2ps zmm1, zmm20, zmm21
M5s_a599
M5s_a58b
    vfmadd231ps zmm4, zmm0, [rcx + 704]
M5s_a5ac
M5s_a5ae
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm4, zmm0, [rcx + 768]
M5s_a1ff
M5s_a568
M5s_a4e2
M5s_a537
M5s_a4fc
M5s_a53c
M5s_a51c
M5s_a541
M5s_a52a
M5s_a58f
M5s_a58c
    vmovups zmm1, [rdx + 4544]
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 704]
M5s_a5ac
M5s_a5ae
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 768]
M5s_a210
M5s_a591
M5s_a4e2
M5s_a54b
M5s_a4fc
M5s_a550
M5s_a51c
M5s_a554
M5s_a52a
M5s_a593
M5s_a58c
    vmovups zmm1, [rdx + 4544]
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 704]
M5s_a5ac
M5s_a5ae
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 768]
M5s_a224
M5s_a594
M5s_a4e2
M5s_a55d
M5s_a4fc
M5s_a562
M5s_a51c
M5s_a566
M5s_a52a
M5s_a597
M5s_a58c
    vmovups zmm1, [rdx + 4544]
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 704]
M5s_a5ac
M5s_a5ae
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 768]
M5s_a23a
M5s_a24a
M5s_a194
M5s_a4c6
M5s_a4e1
M5s_a1d8
M5s_a4fa
M5s_a515
M5s_a526
M5s_a52b
M5s_a599
M5s_a58b
M5s_a5ab
M5s_a4d6
M5s_a534
M5s_a4f7
M5s_a539
M5s_a50c
M5s_a59a
M5s_a52c
M5s_a58f
M5s_a58c
M5s_a5b1
M5s_a4d2
M5s_a4d9
M5s_a549
M5s_a4f8
M5s_a54e
M5s_a50d
M5s_a553
M5s_a52e
M5s_a59e
M5s_a58a
M5s_a5b5
M5s_a4d3
M5s_a570
M5s_a4f5
M5s_a560
M5s_a50e
M5s_a564
M5s_a52f
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
M5s_a597
M5s_a58c
M5s_a5b7
M5s_a250
M5s_a4cb
M5s_a4e6
M5s_a1db
M5s_a56c
M5s_a4ff
M5s_a519
M5s_a529
M5s_a52f
M5s_a5aa
M5s_a199
M5s_a19e
M5s_a56d
    vmovups zmm1, [rdx + 320]
M5s_a533
M5s_a4ea
    vmovups zmm1, [rdx + 1472]
M5s_a538
M5s_a503
    vmovups zmm1, [rdx + 2624]
M5s_a53e
M5s_a523
    vmovups zmm1, [rdx + 3776]
M5s_a544
M5s_a52b
M5s_a59c
M5s_a58b
M5s_a5b2
M5s_a4d6
M5s_a548
M5s_a4f7
M5s_a54d
M5s_a50c
M5s_a59d
M5s_a52c
M5s_a593
M5s_a58c
M5s_a5b4
M5s_a4d2
M5s_a4d9
M5s_a55b
M5s_a4f8
M5s_a55f
M5s_a50d
M5s_a563
M5s_a52e
M5s_a573
M5s_a589
M5s_a58d
M5s_a5b8
M5s_a243
M5s_a4a6
M5s_a4ca
M5s_a4e5
M5s_a1da
M5s_a4fe
M5s_a517
M5s_a528
M5s_a52d
M5s_a589
M5s_a58d
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
M5s_a5ab
M5s_a4d6
M5s_a534
M5s_a4f7
M5s_a539
M5s_a50c
M5s_a59a
M5s_a52c
M5s_a58f
M5s_a58c
M5s_a5b1
M5s_a4d2
M5s_a4d9
M5s_a549
M5s_a4f8
M5s_a54e
M5s_a50d
M5s_a553
M5s_a52e
M5s_a59e
M5s_a58a
M5s_a5b5
M5s_a4d3
M5s_a570
M5s_a4f5
M5s_a560
M5s_a50e
M5s_a564
M5s_a52f
M5s_a5ba
M5s_a259
M5s_a576
M5s_a26c
M5s_a271
M5s_a277
M5s_a281
M5s_a28e
M5s_a297
M5s_a29d
    vmovaps zmm21, zmm19
    vmovaps zmm6, zmm4
M5s_a27a
M5s_a27c
M5s_a29f
M5s_a286
M5s_a28a
M5s_a2a3
M5s_a2a7
M5s_a2ab
M5s_a2b4
M5s_a2b8
M5s_a2c3
M5s_a2bb
M5s_a2c1
M5s_a2c4
M5s_a2c8
M5s_a2cc
M5s_a177
M5s_a4ab
M5s_a183
M5s_a2d1
M5s_a578
M5s_a2d8
M5s_a2dc
M5s_a2e1
M5s_a2ef
M5s_a2f3
M5s_a2f9
M5s_a305
M5s_a5a1
M5s_a2ea
M5s_a2f6
M5s_a301
    vpmovq2m k3, zmm0
M5s_a30d
M5s_a316
M5s_a323
M5s_a32e
M5s_a2e7
M5s_a2f3
M5s_a331
M5s_a337
M5s_a33c
M5s_a5a2
M5s_a343
M5s_a349
    vaddpd xmm9, xmm9, xmm11
M5s_a57a
M5s_a311
M5s_a34f
M5s_a320
M5s_a5a3
M5s_a32b
M5s_a4b1
M5s_a358
M5s_a362
M5s_a367
M5s_a35c
M5s_a36b
M5s_a36f
M5s_a373
M5s_a377
M5s_a37b
M5s_a37f
M5s_a384
M5s_a393
M5s_a39f
M5s_a3aa
M5s_a3b6
M5s_a38e
M5s_a3b9
M5s_a39b
M5s_a3bf
M5s_a3c1
M5s_a3b3
M5s_a3c7
M5s_a38e
M5s_a3c9
M5s_a39b
M5s_a3cf
M5s_a3d1
M5s_a3b3
M5s_a3d7
M5s_a3db
M5s_a3df
M5s_a3e5
M5s_a3e9
M5s_a3ee
M5s_a3f2
M5s_a3f7
M5s_a3fc
M5s_a400
M5s_a405
M5s_a409
M5s_a40e
M5s_a412
M5s_a416
    vaddpd zmm10, zmm11, zmm3
    vsubpd zmm4, zmm10, zmm11
    vsubpd zmm4, zmm3, zmm4
M5s_a419
M5s_a41d
M5s_a421
M5s_a425
M5s_a429
M5s_a42d
M5s_a431
M5s_a435
M5s_a439
M5s_a43f
M5s_a445
M5s_a43e
M5s_a44a
M5s_a44e
M5s_a457
M5s_a458
