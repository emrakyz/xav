%include "g5nm.inc"
default rel
%include "g5o.inc"
%include "g5img.inc"
M5s_a0
M5s_a1
M5s_a2
c_i1023: dd 1023
c_m1: dd -1
c_pft: dq xav_g5_0_12_6.pf1, xav_g5_0_12_6.pf2, xav_g5_0_12_6.pf3, xav_g5_0_12_6.pf4, xav_g5_0_12_6.pf5, xav_g5_0_12_6.pf6, xav_g5_0_12_6.pf7, xav_g5_0_12_6.pf8, xav_g5_0_12_6.pf9, xav_g5_0_12_6.pf10, xav_g5_0_12_6.pf11, xav_g5_0_12_6.pf12, xav_g5_0_12_6.pf13, xav_g5_0_12_6.pf14, xav_g5_0_12_6.pf15, xav_g5_0_12_6.pf16, xav_g5_0_12_6.pf17, xav_g5_0_12_6.pf18, xav_g5_0_12_6.pf19, xav_g5_0_12_6.pf20, xav_g5_0_12_6.pf21, xav_g5_0_12_6.pf22, xav_g5_0_12_6.pf23, xav_g5_0_12_6.pf24, xav_g5_0_12_6.pf25, xav_g5_0_12_6.pf26, xav_g5_0_12_6.pf27, xav_g5_0_12_6.pf28, xav_g5_0_12_6.pf29, xav_g5_0_12_6.pf30, xav_g5_0_12_6.pf31, xav_g5_0_12_6.pf32
M5s_a3
M5s_a4
c_qtr: dd 0x3e800000
section .text
global xav_g5_0_12_6
align 64
xav_g5_0_12_6:
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
    vpmaxud zmm22, zmm12, zmm16
M5s_a466
M5s_a2d
M5s_a5a
M5s_a4b7
M5s_a44
M5s_a54
M5s_a5c
M5s_ab6
M5s_a58
M5s_a78
M5s_a64
    vpmaxud zmm22, zmm12, zmm16
M5s_ab1
M5s_ab8
M5s_a4b8
    vmovups [r8 + rdi*2], zmm18
M5s_a484
M5s_a4b9
M5s_a2a
M5s_a3f
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
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
    vaddps zmm22, zmm22, [r8 + rbx]
M5s_acc
M5s_acf
M5s_a3f
M5s_a4f
M5s_a4bb
M5s_a49
M5s_a59
M5s_ad7
M5s_a5e
M5s_a32
M5s_a5f
M5s_ad3
M5s_a46e
    vmulps zmm10, zmm12, [r15 + Pc_w + 8]{1to16}
M5s_a46f
M5s_a39
M5s_ae3
M5s_a47
M5s_a57
M5s_aec
M5s_a57
M5s_a77
M5s_a63
M5s_a6c
M5s_ae7
M5s_af1
M5s_ae5
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
    vfmadd231ps zmm9, zmm3, [r14 + rdx*4+64]
M5s_a47d
M5s_aa0
M5s_a139
M5s_aa8
    vmulps zmm20, zmm20, [r15 + Pc_w + 4]{1to16}
M5s_a4b5
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
M5s_a13a
M5s_a480
M5s_afe
M5s_a105
M5s_a4a
M5s_a5a
M5s_a13d
M5s_a104
M5s_a46
M5s_a56
M5s_a469
M5s_a141
M5s_a5a
M5s_a76
M5s_a62
M5s_a69
M5s_ab2
M5s_ab4
M5s_a142
M5s_a483
M5s_aff
M5s_a148
M5s_a54
M5s_a5c
M5s_a4bf
M5s_a45b
    vpmaxud zmm22, zmm12, zmm16
M5s_abe
M5s_a4c0
M5s_a14
    mov [rsp + 112], rbp
M5s_a486
M5s_a47c
M5s_a54
M5s_a5c
M5s_a4c1
M5s_a50
    vmulps zmm19, zmm19, zmm21
M5s_a14f
M5s_a38
M5s_a5f
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
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
M5s_a48c
M5s_a58
M5s_a78
M5s_a64
    vpmaxud zmm22, zmm12, zmm16
M5s_ae5
M5s_a48d
M5s_a6c
M5s_ae7
M5s_af6
M5s_a166
M5s_a175
M5s_a16e
M5s_a182
M5s_a189
M5s_a4c4
M5s_a4d0
M5s_a4ec
M5s_a501
M5s_a520
M5s_a531
    vfmadd231ps zmm4, zmm0, [rcx + 640]
M5s_a589
M5s_a58d
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm4, zmm0, [rcx + 704]
M5s_a1ff
M5s_a568
M5s_a4e2
M5s_a537
M5s_a4fc
M5s_a53c
M5s_a51c
M5s_a541
M5s_a52a
    vfmadd231ps zmm5, zmm0, [rcx + 640]
M5s_a589
M5s_a58d
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 704]
M5s_a210
    vmovups zmm18, [r9 + 512]
    vmovups zmm19, [r9 + 576]
M5s_a545
M5s_a4e7
M5s_a54a
M5s_a56c
    vmovups zmm1, [rdx + 2240]
M5s_a54f
M5s_a51b
    vmovups zmm1, [rdx + 3392]
M5s_a554
M5s_a52a
    vfmadd231ps zmm6, zmm0, [rcx + 640]
M5s_a589
M5s_a58d
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 704]
M5s_a224
    vmovups zmm18, [r9 + r14 + 512]
    vmovups zmm19, [r9 + r14 + 576]
M5s_a558
M5s_a4e7
M5s_a55c
M5s_a56c
    vmovups zmm1, [rdx + 2240]
M5s_a561
M5s_a51b
    vmovups zmm1, [rdx + 3392]
M5s_a566
M5s_a52a
    vfmadd231ps zmm7, zmm0, [rcx + 640]
M5s_a589
M5s_a58d
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 704]
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
    vmovaps zmm0{k3}, zmm1
M5s_a587
M5s_a4d6
M5s_a534
M5s_a4f7
M5s_a539
M5s_a50c
    vmovups zmm1, [rdx + 3008]
M5s_a53f
M5s_a52e
    vmovups zmm1, [rdx + 4160]
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
M5s_a58e
M5s_a4d6
M5s_a548
M5s_a4f7
M5s_a54d
M5s_a50c
    vmovups zmm1, [rdx + 3008]
M5s_a553
M5s_a52e
    vmovups zmm1, [rdx + 4160]
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
M5s_a592
M5s_a4d6
M5s_a55a
M5s_a4f7
M5s_a55e
M5s_a50c
M5s_a572
M5s_a52c
M5s_a596
M5s_a254
M5s_a263
M5s_a195
M5s_a4ca
M5s_a4e5
M5s_a1da
M5s_a4fe
M5s_a517
M5s_a528
M5s_a52d
M5s_a588
M5s_a4d7
M5s_a535
M5s_a4f8
M5s_a53a
M5s_a50d
M5s_a53f
M5s_a52e
M5s_a59b
M5s_a4d2
M5s_a4d9
M5s_a549
M5s_a4f8
M5s_a54e
M5s_a50d
M5s_a553
M5s_a52e
M5s_a59f
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
M5s_a598
M5s_a242
M5s_a4a4
M5s_a4c8
M5s_a4e3
M5s_a1d9
M5s_a4fb
M5s_a516
M5s_a527
M5s_a52c
M5s_a587
M5s_a4d6
M5s_a534
M5s_a4f7
M5s_a539
M5s_a50c
M5s_a59a
M5s_a52c
M5s_a58e
M5s_a4d6
M5s_a548
M5s_a4f7
M5s_a54d
M5s_a50c
M5s_a59d
M5s_a52c
M5s_a592
M5s_a4d6
M5s_a55a
M5s_a4f7
M5s_a55e
M5s_a50c
M5s_a572
M5s_a52c
M5s_a596
M5s_a254
M5s_a264
M5s_a26d
M5s_a272
M5s_a4aa
M5s_a28b
M5s_a294
M5s_a29a
M5s_a279
M5s_a276
M5s_a27b
M5s_a29e
M5s_a285
M5s_a289
M5s_a2a2
M5s_a2a6
M5s_a2aa
M5s_a2b3
M5s_a2b7
M5s_a2c2
M5s_a2ba
M5s_a2c0
M5s_a577
M5s_a2cb
M5s_a2cf
M5s_a16b
M5s_a17f
    vpaddd zmm0, zmm0, [c_iota]
M5s_a2d1
M5s_a578
M5s_a2d8
M5s_a2dc
M5s_a2e1
M5s_a2ef
M5s_a2f3
M5s_a2f9
M5s_a305
    vpmovq2m k3, zmm0
M5s_a30a
M5s_a2eb
M5s_a2fe
M5s_a302
M5s_a30d
M5s_a316
M5s_a323
M5s_a32e
M5s_a2e7
M5s_a2f3
M5s_a331
M5s_a337
M5s_a33c
    cmovne edx, esi
M5s_a4ad
M5s_a344
M5s_a34a
M5s_a57a
M5s_a311
M5s_a34f
M5s_a320
    xor edx, edx
    div r9
M5s_a351
    mov rcx, [r15 + 768]
M5s_a4b0
M5s_a357
M5s_a361
M5s_a366
M5s_a35b
M5s_a36a
M5s_a36e
M5s_a372
M5s_a376
M5s_a37a
M5s_a37e
M5s_a383
M5s_a392
M5s_a39e
M5s_a3a9
M5s_a3b5
M5s_a38d
M5s_a3b8
M5s_a39a
M5s_a3be
M5s_a3c0
M5s_a3b2
M5s_a3c6
M5s_a38d
M5s_a3c8
M5s_a39a
M5s_a3ce
M5s_a3d0
M5s_a3b2
M5s_a3d6
M5s_a3da
M5s_a3de
M5s_a3e4
M5s_a3e8
M5s_a3ed
M5s_a3f1
M5s_a3f6
M5s_a3fb
M5s_a3ff
M5s_a404
M5s_a408
M5s_a40d
M5s_a411
M5s_a415
M5s_a3e1
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
