%include "q2nm.inc"
default rel
%use smartalign
alignmode p6, 32
%include "gq2o.inc"
%include "gqimg.inc"
M2p_a0
M2p_a1
M2p_a2
M2p_a3
M2p_a4
M2p_a5
global xav_q2_0_12_9
align 64
xav_q2_0_12_9:
M2p_a6
M2p_a8
M2p_aa
M2p_ab
M2p_ac
M2p_a20
M2p_a2c
M2p_a22
M2p_a18
M2p_a13
M2p_a23
M2p_a2b
M2p_a2d
M2p_a2e
M2p_a32
M2p_a35
M2p_a3e
M2p_a4b
M2p_a46
M2p_a55
M2p_a61
M2p_a6b
M2p_a3ec
M2p_a80
M2p_a86
M2p_a3f4
M2p_a9a
M2p_a3f7
M2p_ab1
M2p_a467
M2p_a47e
M2p_a480
M2p_a483
M2p_a567
M2p_a534
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2p_a3fd
M2p_a400
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [rax + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 384]
M2p_a403
M2p_a405
    vpermps ymm1, ymm3, [rax + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2p_a40a
M2p_a40f
    vpermps ymm1, ymm3, [rax + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2p_a413
M2p_a416
    vpermps ymm1, ymm3, [rax + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2p_a41a
M2p_a41e
    vpermps ymm1, ymm3, [rax + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2p_a422
M2p_a425
    vpermps ymm1, ymm3, [rax + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2p_a426
M2p_a428
    vpermps ymm1, ymm3, [rax + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2p_a42a
M2p_a42c
    vpermps ymm1, ymm3, [rax + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2p_a42d
M2p_abd
M2p_a430
    vpermps ymm1, ymm3, [rax + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2p_a431
M2p_ac4
M2p_a434
    vpermps ymm1, ymm3, [rax + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2p_a521
M2p_acb
M2p_a523
    vpermps ymm1, ymm3, [rax + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [rax + 44]
M2p_acd
    vpermps ymm1, ymm3, [rax + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [rax + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [rax + 300]
M2p_a54b
M2p_a439
M2p_a11e
M2p_a43e
M2p_a141
M2p_a443
M2p_a164
M2p_a46b
M2p_a4d8
M2p_a4db
M2p_a4e0
M2p_a572
M2p_a554
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2p_a44b
M2p_a400
M2p_a632
M2p_a415
M2p_a419
M2p_a635
M2p_a427
M2p_a637
M2p_ac1
M2p_ac4
M2p_a434
M2p_a63a
M2p_acd
M2p_a63b
M2p_a54c
M2p_a44e
M2p_a183
M2p_a455
M2p_a1a6
M2p_a45a
M2p_a1cb
M2p_a528
M2p_a4ee
M2p_a4f3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 296]
M2p_a620
M2p_a560
M2p_a563
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2p_a464
M2p_a400
M2p_a632
M2p_a415
M2p_a419
M2p_a635
M2p_a427
M2p_a637
M2p_ac1
M2p_ac4
M2p_a434
M2p_a63a
M2p_acd
M2p_a63b
M2p_a54c
M2p_a1e2
M2p_a6b
M2p_a3ec
M2p_a80
M2p_a86
M2p_a3f4
M2p_a9a
M2p_a3f7
M2p_ab1
M2p_a467
M2p_a47e
M2p_a480
M2p_a483
M2p_a567
M2p_a534
M2p_a631
M2p_a40c
M2p_a412
M2p_a634
M2p_a424
M2p_a636
M2p_ab8
M2p_abc
M2p_a42f
    vmovdqu ymm3, [rdx + 480]
M2p_a638
M2p_ad0
M2p_ad5
M2p_a63c
M2p_af5
M2p_a1eb
M2p_a100
M2p_a438
M2p_a11d
M2p_a468
M2p_a13f
M2p_a507
M2p_a445
M2p_a166
M2p_a44a
M2p_a4da
M2p_a4dd
    vpermps ymm1, ymm3, [r9 + 296]
M2p_a570
M2p_a553
M2p_a556
M2p_a63d
M2p_a40d
M2p_a633
M2p_a423
    vmovdqu ymm3, [rdx + 480]
M2p_a636
M2p_ab8
M2p_abc
M2p_a42f
M2p_a63f
M2p_acf
M2p_ad4
M2p_a63b
M2p_a54c
M2p_a1ef
M2p_a173
M2p_a50f
M2p_a179
M2p_a17d
M2p_a453
M2p_a198
    vpermps ymm1, ymm3, [r15 + 240]
M2p_a459
M2p_a1c0
    vpermps ymm1, ymm3, [r15 + 252]
M2p_a45e
M2p_a1d4
M2p_a1d8
M2p_a514
M2p_a52c
M2p_a4f1
M2p_a4f8
M2p_a620
M2p_a560
M2p_a563
M2p_a63e
M2p_a40d
M2p_a633
M2p_a423
M2p_a640
M2p_ab7
M2p_abb
M2p_a42e
M2p_a639
M2p_ad1
    vmovdqu ymm3, [rdx + 416]
M2p_a63b
M2p_a54c
M2p_a1f2
M2p_a1f9
M2p_a1fb
M2p_a203
M2p_a212
M2p_a21c
M2p_a226
M2p_a22b
M2p_a22f
M2p_a207
M2p_a20b
M2p_a20f
M2p_a232
M2p_a21a
M2p_a223
M2p_a233
M2p_a238
M2p_a23c
M2p_a23e
M2p_a45
M2p_a49
M2p_a240
M2p_a51
M2p_a41
M2p_a243
M2p_a248
M2p_a24c
M2p_a251
M2p_a256
M2p_a25e
M2p_a473
M2p_a26c
M2p_a277
M2p_a289
M2p_a1d
M2p_a26
M2p_a283
M2p_a286
M2p_a1c
M2p_a28d
M2p_a29e
M2p_a29a
M2p_a2a3
M2p_a2a7
M2p_a2ad
M2p_a2b3
M2p_a2c0
M2p_a2cd
M2p_a2dc
M2p_a2e3
M2p_a2ec
M2p_a2f3
M2p_a304
M2p_a2f6
M2p_a30b
M2p_a31b
M2p_a2fe
M2p_a309
M2p_a31d
M2p_a2bd
M2p_a516
M2p_a52f
M2p_a325
M2p_a32b
M2p_a32f
M2p_a334
M2p_a338
M2p_a33c
M2p_a630
M2p_a344
M2p_a349
M2p_a34d
M2p_a35d
M2p_a369
M2p_a356
M2p_a35e
M2p_a371
M2p_a36f
M2p_a377
M2p_a35e
M2p_a379
M2p_a36f
M2p_a37f
    imul rcx, r11
    cmp rcx, [rbp + 5880]
M2p_a381
M2p_a2d2
M2p_a475
M2p_a387
M2p_a38c
M2p_a391
M2p_a396
M2p_a39b
M2p_a3a0
M2p_a3a9
M2p_a3b0
M2p_a3b6
M2p_a3bd
M2p_a3c4
M2p_a3ca
M2p_a3d0
M2p_a3d7
M2p_a3dd
M2p_a3e3
M2p_a3e7
section .note.GNU-stack noalloc noexec nowrite progbits
