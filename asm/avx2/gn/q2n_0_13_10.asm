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
global xav_q2_0_13_10
align 64
xav_q2_0_13_10:
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
M2p_a3eb
M2p_a476
M2p_a7d
M2p_a84
M2p_a3f2
M2p_a47a
M2p_a98
M2p_a9f
M2p_a4fe
M2p_a530
M2p_a566
M2p_a644
M2p_a645
M2p_a649
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 384]
M2p_a486
M2p_a489
M2p_a48c
    vpermps ymm1, ymm3, [rax + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 416]
M2p_a48e
M2p_a491
M2p_a494
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2p_a495
M2p_a498
M2p_a49a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2p_a49b
M2p_a49f
M2p_a4a2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2p_a4a4
M2p_a4a9
M2p_a4ad
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2p_a4af
M2p_a4b2
M2p_a4b4
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2p_a4b5
M2p_a4b8
M2p_a4ba
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2p_a4bb
M2p_a4bf
M2p_a4c2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2p_a4c3
M2p_a401
M2p_a4e5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2p_a4c5
M2p_a407
M2p_a53e
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2p_a4c9
M2p_a410
M2p_a542
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2p_a546
M2p_a417
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [rax + 268]
M2p_a547
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [rax + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [rax + 48]
M2p_a41b
M2p_a420
M2p_a655
M2p_af4
M2p_afc
M2p_a105
M2p_a437
M2p_a4d1
M2p_a11b
M2p_a123
M2p_a505
M2p_a54d
M2p_a156
M2p_a15d
M2p_a447
M2p_a4d6
M2p_a551
M2p_a555
M2p_a557
M2p_a65a
M2p_a65d
M2p_a661
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 384]
M2p_a4e3
M2p_a489
M2p_a48c
M2p_a64a
M2p_a49c
M2p_a4a0
M2p_a4a3
M2p_a64c
M2p_a4b6
M2p_a4b9
    vpermps ymm1, ymm3, [rax + 312]
M2p_a64f
M2p_a404
M2p_a409
M2p_a4c7
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [rax + 324]
M2p_a651
M2p_a41b
M2p_a420
M2p_a655
M2p_af5
M2p_a16b
M2p_a176
M2p_a450
M2p_a4e6
M2p_a18d
M2p_a195
M2p_a510
M2p_a55a
M2p_a1c7
M2p_a1cd
M2p_a461
M2p_a4eb
M2p_a55f
M2p_a562
M2p_a564
M2p_a664
M2p_a667
M2p_a66c
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r15 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 384]
M2p_a4fc
M2p_a489
M2p_a48c
M2p_a64a
M2p_a49c
M2p_a4a0
M2p_a4a3
M2p_a64c
M2p_a4b6
M2p_a4b9
M2p_a663
M2p_a4c6
M2p_a408
M2p_a540
M2p_a652
M2p_a41c
M2p_a421
M2p_a656
M2p_a1de
M2p_a68
M2p_a3ee
M2p_a479
M2p_a7f
M2p_a85
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 236]
M2p_a3f2
M2p_a47a
M2p_a98
M2p_a9f
M2p_a4fe
M2p_a530
M2p_a566
M2p_a643
M2p_a48f
M2p_a492
    vpermps ymm1, ymm3, [rax + 292]
M2p_a64b
M2p_a4a6
M2p_a4ab
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [rax + 304]
M2p_a64d
M2p_a4bc
M2p_a4c0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [rax + 316]
M2p_a650
M2p_a40c
M2p_a412
M2p_a4cb
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [rax + 328]
M2p_a653
M2p_a56a
M2p_a10f
M2p_a115
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 232]
M2p_a43b
M2p_a4d2
M2p_a12e
M2p_a138
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 244]
M2p_a441
M2p_a4d4
M2p_a159
M2p_a15f
M2p_a550
M2p_a4e2
M2p_a571
M2p_a65b
M2p_a48f
M2p_a492
M2p_a66e
M2p_a4a5
M2p_a4aa
M2p_a4ae
M2p_a64e
M2p_a4bd
M2p_a4c1
M2p_a66f
M2p_a4ca
M2p_a411
M2p_a544
M2p_a654
M2p_a1ef
M2p_a173
M2p_a50d
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a4e7
M2p_a1a2
M2p_a1ae
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r15 + 244]
M2p_a45b
M2p_a4e9
M2p_a1ca
M2p_a1d0
M2p_a55c
M2p_a4fa
M2p_a620
M2p_a561
M2p_a666
M2p_a48f
M2p_a492
M2p_a66e
M2p_a4a5
M2p_a4aa
M2p_a4ae
M2p_a64e
M2p_a4bd
M2p_a4c1
M2p_a66f
M2p_a4ca
M2p_a411
M2p_a544
M2p_a654
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
M2p_a642
M2p_a2d1
    test rcx, rcx
    cmovs rcx, rbx
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
