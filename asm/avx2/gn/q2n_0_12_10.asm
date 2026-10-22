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
global xav_q2_0_12_10
align 64
xav_q2_0_12_10:
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
    vpermps ymm1, ymm3, [r8 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a47c
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 44]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a533
M2p_a535
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2p_a486
M2p_a489
M2p_a48c
    vpermps ymm1, ymm3, [rax + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 384]
M2p_a48e
M2p_a491
M2p_a494
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2p_a495
M2p_a498
M2p_a49a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2p_a49b
M2p_a49f
M2p_a4a2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2p_a4a4
M2p_a4a9
M2p_a4ad
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2p_a4af
M2p_a4b2
M2p_a4b4
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2p_a4b5
M2p_a4b8
M2p_a4ba
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2p_a4bb
M2p_a4bf
M2p_a4c2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2p_a4c3
M2p_a401
M2p_a4e5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2p_a4c5
M2p_a407
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [rax + 260]
M2p_a4c7
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [rax + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2p_a4c9
M2p_a410
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [rax + 264]
M2p_a4cb
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [rax + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [rax + 44]
M2p_a414
M2p_a418
M2p_a547
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [rax + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2p_af4
M2p_afc
M2p_a105
M2p_a437
M2p_a4d1
M2p_a11b
M2p_a123
M2p_a505
    vpermps ymm1, ymm3, [r9 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a4d4
M2p_a159
M2p_a15f
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 256]
M2p_a447
M2p_a4d6
M2p_a551
M2p_a555
M2p_a557
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2p_a4e3
M2p_a489
M2p_a48c
M2p_a537
M2p_a49c
M2p_a4a0
M2p_a4a3
M2p_a539
M2p_a4b6
M2p_a4b9
    vpermps ymm1, ymm3, [rax + 312]
M2p_a53c
M2p_a404
M2p_a409
M2p_a4c7
M2p_a541
M2p_af5
M2p_a16b
M2p_a176
M2p_a450
M2p_a4e6
M2p_a18d
M2p_a195
M2p_a510
    vpermps ymm1, ymm3, [r15 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a4e9
M2p_a1ca
M2p_a1d0
    vmovdqu ymm3, [rdx + 192]
M2p_a529
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a4eb
M2p_a55f
M2p_a562
M2p_a564
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2p_a4fc
M2p_a489
M2p_a48c
M2p_a537
M2p_a49c
M2p_a4a0
M2p_a4a3
M2p_a539
M2p_a4b6
M2p_a4b9
M2p_a559
M2p_a4c6
M2p_a408
M2p_a53f
M2p_a549
M2p_a1e2
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
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 320]
M2p_a532
M2p_a48f
M2p_a492
    vpermps ymm1, ymm3, [rax + 292]
M2p_a538
M2p_a4a6
M2p_a4ab
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [rax + 304]
M2p_a53a
M2p_a4bc
M2p_a4c0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [rax + 316]
M2p_a53d
M2p_a40c
M2p_a412
M2p_a4cb
M2p_a545
M2p_a54a
    vmovaps ymm4, ymm2
M2p_a1e9
M2p_aff
M2p_a435
M2p_a503
M2p_a118
M2p_a122
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 268]
M2p_a506
M2p_a13c
M2p_a14a
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 280]
M2p_a509
M2p_a162
M2p_a168
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 292]
M2p_a50c
    vpermps ymm1, ymm3, [r9 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 320]
M2p_a552
M2p_a48f
M2p_a492
M2p_a568
M2p_a4a5
M2p_a4aa
M2p_a4ae
M2p_a53b
M2p_a4bd
M2p_a4c1
M2p_a569
M2p_a4ca
M2p_a411
M2p_a543
M2p_a548
M2p_af6
M2p_a1f1
M2p_a178
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a4e6
M2p_a18d
M2p_a195
M2p_a510
M2p_a55a
M2p_a1c7
M2p_a1cd
M2p_a461
M2p_a4eb
M2p_a55e
M2p_a48f
M2p_a492
M2p_a568
M2p_a4a5
M2p_a4aa
M2p_a4ae
M2p_a53b
M2p_a4bd
M2p_a4c1
M2p_a569
M2p_a4ca
M2p_a411
M2p_a543
M2p_a548
M2p_a1df
M2p_a1e6
M2p_a1f4
M2p_a1fd
M2p_a205
M2p_a214
M2p_a21e
M2p_a228
M2p_a22d
M2p_a231
M2p_a209
M2p_a20d
M2p_a471
M2p_a218
M2p_a221
M2p_a52d
M2p_a236
M2p_a23a
    vextracti128 xmm4, ymm11, 1
M2p_a23d
M2p_a23f
M2p_a242
M2p_a246
M2p_a24b
M2p_a250
M2p_a255
M2p_a25d
M2p_a269
M2p_a272
M2p_a279
M2p_a25
M2p_a282
M2p_a1c
M2p_a27f
M2p_a2a
M2p_a24
M2p_a28a
M2p_a290
    vbroadcastsd ymm2, [rdi + G_erg]
M2p_a2a1
M2p_a295
    vblendvpd ymm2, ymm4, ymm2, ymm3
M2p_a2a6
M2p_a2ac
M2p_a2b2
M2p_a2ba
M2p_a2c9
M2p_a2d8
M2p_a2e2
M2p_a2eb
M2p_a2f1
M2p_a2fb
M2p_a318
M2p_a302
M2p_a310
M2p_a314
M2p_a31c
M2p_a2ff
M2p_a30a
M2p_a31e
M2p_a2be
M2p_a474
M2p_a322
M2p_a326
M2p_a32c
M2p_a330
M2p_a335
M2p_a339
M2p_a33d
M2p_a341
M2p_a345
M2p_a34a
M2p_a34e
M2p_a360
M2p_a36a
M2p_a357
M2p_a35f
M2p_a372
M2p_a374
M2p_a35a
M2p_a37a
M2p_a37c
M2p_a380
M2p_a382
M2p_a384
M2p_a38a
M2p_a38e
M2p_a393
M2p_a398
M2p_a39d
M2p_a3a6
M2p_a517
M2p_a3b2
M2p_a3b9
M2p_a3c0
M2p_a3c6
M2p_a3cc
M2p_a3d3
M2p_a3d9
M2p_a3df
M2p_a3a3
M2p_a3e5
M2p_a3e8
    ud2
section .note.GNU-stack noalloc noexec nowrite progbits
