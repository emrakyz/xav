%include "g5nm.inc"
default rel
%include "g5o.inc"
%include "g5img.inc"
M5s_a0
M5s_a1
M5s_a2
c_i1023: dd 1023
c_m1: dd -1
c_pft: dq xav_g5_0_11_6.pf1, xav_g5_0_11_6.pf2, xav_g5_0_11_6.pf3, xav_g5_0_11_6.pf4, xav_g5_0_11_6.pf5, xav_g5_0_11_6.pf6, xav_g5_0_11_6.pf7, xav_g5_0_11_6.pf8, xav_g5_0_11_6.pf9, xav_g5_0_11_6.pf10, xav_g5_0_11_6.pf11, xav_g5_0_11_6.pf12, xav_g5_0_11_6.pf13, xav_g5_0_11_6.pf14, xav_g5_0_11_6.pf15, xav_g5_0_11_6.pf16, xav_g5_0_11_6.pf17, xav_g5_0_11_6.pf18, xav_g5_0_11_6.pf19, xav_g5_0_11_6.pf20, xav_g5_0_11_6.pf21, xav_g5_0_11_6.pf22, xav_g5_0_11_6.pf23, xav_g5_0_11_6.pf24, xav_g5_0_11_6.pf25, xav_g5_0_11_6.pf26, xav_g5_0_11_6.pf27, xav_g5_0_11_6.pf28, xav_g5_0_11_6.pf29, xav_g5_0_11_6.pf30, xav_g5_0_11_6.pf31, xav_g5_0_11_6.pf32
M5s_a3
M5s_a4
c_qtr: dd 0x3e800000
section .text
global xav_g5_0_11_6
align 64
xav_g5_0_11_6:
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
    vmulps zmm15, zmm15, zmm17
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
M5s_a45c
M5s_a52
M5s_a5a
M5s_a469
M5s_a80
    vfmadd231ps zmm5, zmm8, [c_xgcb]{1to16}
M5s_a45d
M5s_a61
M5s_a68
    vpmaxud zmm22, zmm22, zmm20
M5s_a83
M5s_a26
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
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
M5s_a96
    vmovups [r8 + rcx], zmm11
M5s_a463
M5s_a3e
M5s_a4e
    vmulps zmm15, zmm15, zmm17
M5s_a464
M5s_a45
M5s_a55
M5s_a5e
M5s_aa3
M5s_a59
M5s_a32
M5s_a5f
M5s_a47f
    vmovups [r8 + rcx*2], zmm20
M5s_aa9
    vmovups [r8 + r12], zmm16
M5s_aae
M5s_a27
M5s_a3e
M5s_a4e
    vmulps zmm15, zmm15, zmm17
M5s_a467
M5s_a45
M5s_a55
M5s_a5e
M5s_ab7
M5s_a59
M5s_a32
M5s_a5f
M5s_ab1
M5s_ab8
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
M5s_ab9
M5s_a484
    vmovups [r8 + rcx], zmm11
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
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
M5s_ac5
M5s_a52
M5s_a5a
M5s_a46a
M5s_a33
M5s_a4b3
M5s_a69
M5s_ac7
M5s_acc
M5s_acf
M5s_a3f
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
M5s_a46b
M5s_a4a
M5s_a5a
M5s_a469
M5s_ad8
M5s_a76
M5s_a62
M5s_a69
M5s_ad4
M5s_ad9
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
    vmovups [r8 + rdi*2], zmm20
M5s_a474
M5s_a11b
M5s_a106
M5s_a4b
M5s_a5b
M5s_a11e
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
M5s_a475
M5s_a36
M5s_a45b
    vpmaxud zmm22, zmm12, zmm16
M5s_a88
M5s_a476
M5s_a125
M5s_a28
M5s_a105
M5s_a4a
M5s_a5a
M5s_a128
M5s_a46
M5s_a56
M5s_a469
M5s_a12d
M5s_a76
M5s_a62
M5s_a69
M5s_a91
M5s_a12e
M5s_a47a
M5s_a28
M5s_a105
M5s_a4a
M5s_a5a
M5s_a132
M5s_a104
M5s_a46
M5s_a56
M5s_a469
M5s_a137
M5s_a5a
M5s_a76
M5s_a62
M5s_a69
M5s_aa5
M5s_aaa
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
    vmulps zmm19, zmm19, zmm21
M5s_a149
M5s_a5f
M5s_abe
    vmovups [r8 + rcx*2], zmm20
M5s_a14b
M5s_a16
M5s_a486
M5s_a47c
M5s_a54
M5s_a5c
    vmulps zmm19, zmm19, zmm21
M5s_a14e
M5s_a51
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
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
M5s_a488
M5s_a5c
M5s_a78
M5s_a64
    vpmaxud zmm22, zmm12, zmm16
M5s_ad3
M5s_a46d
M5s_adb
M5s_a489
M5s_ae2
M5s_a15c
M5s_a103
M5s_a49
M5s_a59
M5s_a160
M5s_a45
M5s_a55
M5s_a5e
M5s_a161
M5s_a59
M5s_a32
M5s_a5f
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
    mov rcx, [rdi + G_hv]
    mov r15, [rdi + G_hk]
    vmovups zmm22, [rcx + 0]
    vmovups zmm23, [rcx + 64]
    vmovups zmm24, [rcx + 128]
    vmovups zmm25, [rcx + 192]
    vmovups zmm31, [rcx + 256]
M5s_a18c
M5s_a18f
M5s_a194
M5s_a4c7
    vmovups zmm21, [r8 + 704]
M5s_a197
M5s_a4cc
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vmulps zmm4, zmm0, zmm22
M5s_a4cf
M5s_a4d8
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm4, zmm0, zmm23
M5s_a4db
M5s_a4e7
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm4, zmm0, zmm24
M5s_a4e8
M5s_a4eb
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm4, zmm0, zmm25
M5s_a4ef
M5s_a4f7
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm4, zmm0, zmm31
M5s_a1d5
M5s_a4fa
M5s_a515
M5s_a526
M5s_a52b
M5s_a495
M5s_a200
    vmovups zmm20, [r8 + r14 + 640]
    vmovups zmm21, [r8 + r14 + 704]
M5s_a197
M5s_a4cc
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vmulps zmm5, zmm0, zmm22
M5s_a4cf
M5s_a4d8
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, zmm23
M5s_a4db
M5s_a4e7
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, zmm24
M5s_a4e8
M5s_a4eb
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, zmm25
M5s_a4ef
M5s_a4f7
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, zmm31
M5s_a1d5
M5s_a4f9
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 320]
M5s_a500
M5s_a505
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 384]
M5s_a506
M5s_a50d
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 448]
M5s_a50f
M5s_a51c
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 512]
M5s_a51f
M5s_a524
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 576]
M5s_a529
M5s_a52f
    vpermi2ps zmm1, zmm20, zmm21
M5s_a498
M5s_a214
    vmovups zmm20, [r9 + 640]
    vmovups zmm21, [r9 + 704]
M5s_a197
M5s_a4cc
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vmulps zmm6, zmm0, zmm22
M5s_a4cf
M5s_a4d8
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, zmm23
M5s_a4db
M5s_a4e7
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, zmm24
M5s_a4e8
M5s_a4eb
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, zmm25
M5s_a4ef
M5s_a4f7
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, zmm31
M5s_a1d5
M5s_a4f9
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 320]
M5s_a500
M5s_a505
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 384]
M5s_a506
M5s_a50d
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 448]
M5s_a50f
M5s_a51c
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 512]
M5s_a51f
M5s_a524
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 576]
M5s_a529
M5s_a52f
    vpermi2ps zmm1, zmm20, zmm21
M5s_a49b
M5s_a228
    vmovups zmm20, [r9 + r14 + 640]
    vmovups zmm21, [r9 + r14 + 704]
M5s_a197
M5s_a4cc
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vmulps zmm7, zmm0, zmm22
M5s_a4cf
M5s_a4d8
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, zmm23
M5s_a4db
M5s_a4e7
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, zmm24
M5s_a4e8
M5s_a4eb
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, zmm25
M5s_a4ef
M5s_a4f7
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, zmm31
M5s_a1d5
M5s_a4f9
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 320]
M5s_a500
M5s_a505
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 384]
M5s_a506
M5s_a50d
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 448]
M5s_a50f
M5s_a51c
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 512]
M5s_a51f
M5s_a524
    vpermi2ps zmm1, zmm20, zmm21
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 576]
M5s_a529
M5s_a52f
    vpermi2ps zmm1, zmm20, zmm21
M5s_a49e
M5s_a4ca
M5s_a4e5
M5s_a1da
M5s_a4fe
M5s_a518
    vmovups zmm18, [r8 + r14 + 512]
    vmovups zmm19, [r8 + r14 + 576]
M5s_a532
M5s_a4e7
M5s_a536
    vmovups zmm1, [rdx + 2176]
M5s_a4f9
M5s_a53b
M5s_a51b
    vmovups zmm1, [rdx + 3392]
M5s_a540
M5s_a199
M5s_a19e
    vmovups zmm1, [rdx + 256]
M5s_a4cc
M5s_a546
M5s_a4ea
    vmovups zmm1, [rdx + 1472]
M5s_a54c
M5s_a503
    vmovups zmm1, [rdx + 2624]
M5s_a551
M5s_a523
    vmovups zmm1, [rdx + 3776]
M5s_a555
M5s_a4d3
    vmovups zmm1, [rdx + 704]
M5s_a559
M5s_a4f6
    vmovups zmm1, [rdx + 1856]
M5s_a55e
M5s_a50c
    vmovups zmm1, [rdx + 3008]
M5s_a563
M5s_a52e
    vmovups zmm1, [rdx + 4160]
M5s_a567
M5s_a250
M5s_a4cb
M5s_a4e6
M5s_a1db
M5s_a56c
M5s_a4ff
M5s_a51a
M5s_a56a
M5s_a4e4
    vmovups zmm1, [rdx + 1088]
M5s_a536
M5s_a56b
M5s_a514
M5s_a51e
M5s_a543
M5s_a19b
M5s_a1a0
M5s_a4cd
M5s_a547
M5s_a4eb
M5s_a54c
M5s_a503
M5s_a56f
M5s_a522
M5s_a557
M5s_a4d6
M5s_a55a
M5s_a4f7
M5s_a55e
M5s_a50c
M5s_a572
M5s_a52c
M5s_a49f
M5s_a245
M5s_a4a8
M5s_a4cb
M5s_a4e6
M5s_a1db
M5s_a56c
M5s_a4ff
M5s_a51a
M5s_a56a
M5s_a4e4
M5s_a574
M5s_a1dd
M5s_a4fd
M5s_a53d
M5s_a51d
M5s_a542
M5s_a19a
M5s_a19f
M5s_a4cc
M5s_a546
M5s_a4ea
M5s_a56e
M5s_a502
M5s_a552
M5s_a525
M5s_a556
M5s_a4d5
M5s_a559
M5s_a4f6
M5s_a571
M5s_a50b
M5s_a565
M5s_a530
M5s_a49d
M5s_a251
    vmovups [r12], zmm16
    add r12, 256
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
    vpaddd zmm10, zmm10, zmm3
M5s_a2c4
M5s_a2c8
M5s_a2cc
M5s_a177
M5s_a4ab
M5s_a183
M5s_a2d1
    cmovb r8, rcx
    xor r9d, r9d
M5s_a2d5
M5s_a2da
M5s_a2de
M5s_a2e3
M5s_a2f1
M5s_a2f5
M5s_a2fb
M5s_a307
M5s_a30b
M5s_a2ec
M5s_a2ff
M5s_a303
M5s_a30e
M5s_a317
M5s_a324
M5s_a32f
M5s_a2e8
M5s_a2f4
M5s_a332
M5s_a338
M5s_a33d
M5s_a4ad
M5s_a344
M5s_a34a
    vshufpd xmm11, xmm9, xmm9, 1
M5s_a34c
M5s_a312
M5s_a4ae
M5s_a350
M5s_a32a
M5s_a32c
M5s_a353
M5s_a359
M5s_a363
M5s_a368
M5s_a35d
M5s_a36c
M5s_a370
M5s_a374
M5s_a378
M5s_a37c
M5s_a380
M5s_a385
M5s_a394
M5s_a3a0
M5s_a3ac
M5s_a3b7
M5s_a38f
M5s_a3ba
M5s_a3bc
M5s_a3a6
M5s_a3c2
M5s_a3c4
M5s_a38b
M5s_a3ca
M5s_a3cc
M5s_a3a6
M5s_a3d2
M5s_a3d4
M5s_a3d8
M5s_a3dc
M5s_a3e2
M5s_a3e6
M5s_a3eb
M5s_a3ef
M5s_a3f4
M5s_a3f9
M5s_a3fd
M5s_a402
M5s_a406
M5s_a40b
M5s_a40f
M5s_a413
M5s_a417
M5s_a41a
M5s_a41e
M5s_a422
M5s_a426
M5s_a42a
M5s_a42e
M5s_a432
M5s_a436
M5s_a43a
M5s_a442
M5s_a446
M5s_a440
M5s_a448
M5s_a44c
M5s_a452
M5s_a454
    ret
section .note.GNU-stack noalloc noexec nowrite progbits
