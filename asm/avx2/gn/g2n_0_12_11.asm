%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_12_11_pft: dq xav_g2_0_12_11.pf1, xav_g2_0_12_11.pf2, xav_g2_0_12_11.pf3, xav_g2_0_12_11.pf4, xav_g2_0_12_11.pf5, xav_g2_0_12_11.pf6, xav_g2_0_12_11.pf7, xav_g2_0_12_11.pf8, xav_g2_0_12_11.pf9, xav_g2_0_12_11.pf10, xav_g2_0_12_11.pf11, xav_g2_0_12_11.pf12, xav_g2_0_12_11.pf13, xav_g2_0_12_11.pf14, xav_g2_0_12_11.pf15, xav_g2_0_12_11.pf16, xav_g2_0_12_11.pf17, xav_g2_0_12_11.pf18, xav_g2_0_12_11.pf19, xav_g2_0_12_11.pf20, xav_g2_0_12_11.pf21, xav_g2_0_12_11.pf22, xav_g2_0_12_11.pf23, xav_g2_0_12_11.pf24, xav_g2_0_12_11.pf25, xav_g2_0_12_11.pf26, xav_g2_0_12_11.pf27, xav_g2_0_12_11.pf28, xav_g2_0_12_11.pf29, xav_g2_0_12_11.pf30, xav_g2_0_12_11.pf31, xav_g2_0_12_11.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_12_11
align 64
xav_g2_0_12_11:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_12_11_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a19
M2s_a466
M2s_a540
M2s_a2b
M2s_a2f
M2s_a3f0
M2s_a544
    vpermps ymm1, ymm3, [r8 + 324]
M2s_a31
M2s_a36
M2s_a3f1
M2s_a546
    vpermps ymm1, ymm3, [r8 + 328]
M2s_a3b
M2s_a42
M2s_a3f2
M2s_a548
    vpermps ymm1, ymm3, [r8 + 332]
M2s_a45
M2s_a4c
M2s_a3f5
M2s_a549
    vpermps ymm1, ymm3, [r8 + 336]
M2s_a50
M2s_a5c
M2s_a3f6
M2s_a54c
    vpermps ymm1, ymm3, [r8 + 340]
M2s_a5e
M2s_a66
M2s_a3f8
M2s_a54d
    vpermps ymm1, ymm3, [r8 + 344]
M2s_a6b
M2s_a70
M2s_a3f9
M2s_a551
    vpermps ymm1, ymm3, [r8 + 348]
M2s_a75
M2s_a7a
M2s_a3fa
M2s_a553
    vpermps ymm1, ymm3, [r8 + 352]
M2s_a80
M2s_a84
M2s_a3fb
M2s_a557
    vpermps ymm1, ymm3, [r8 + 356]
M2s_a471
M2s_a474
M2s_a47b
M2s_a558
    vpermps ymm1, ymm3, [r8 + 360]
M2s_a531
M2s_a50e
M2s_a511
M2s_a55f
    vpermps ymm1, ymm3, [r8 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2s_a562
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 384]
M2s_a569
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_a56e
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_a574
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_a577
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a57d
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_a580
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_a584
    vfmadd231ps ymm5, ymm0, [rcx + 608]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_a481
M2s_a484
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_a48a
M2s_a48d
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_a490
M2s_a492
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_a497
M2s_a49a
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 364]
M2s_a51a
M2s_a58b
M2s_acd
M2s_ad3
M2s_a434
M2s_a58e
    vpermps ymm1, ymm3, [r9 + 324]
M2s_ad8
M2s_ade
M2s_a436
M2s_a590
    vpermps ymm1, ymm3, [r9 + 328]
M2s_ae2
M2s_aec
M2s_a438
M2s_a593
    vpermps ymm1, ymm3, [r9 + 332]
M2s_aef
M2s_af7
M2s_a43a
M2s_a594
    vpermps ymm1, ymm3, [r9 + 336]
M2s_afc
M2s_a106
M2s_a43d
M2s_a598
    vpermps ymm1, ymm3, [r9 + 340]
M2s_a10d
M2s_a117
M2s_a43e
M2s_a59a
    vpermps ymm1, ymm3, [r9 + 344]
M2s_a11c
M2s_a122
M2s_a440
M2s_a59e
    vpermps ymm1, ymm3, [r9 + 348]
M2s_a128
M2s_a12e
M2s_a441
M2s_a5a0
    vpermps ymm1, ymm3, [r9 + 352]
M2s_a134
M2s_a137
M2s_a443
M2s_a5a3
    vpermps ymm1, ymm3, [r9 + 356]
M2s_a4cc
M2s_a4d0
M2s_a4d7
M2s_a5a5
    vpermps ymm1, ymm3, [r9 + 360]
M2s_a538
M2s_a523
M2s_a525
M2s_a5ab
    vpermps ymm1, ymm3, [r9 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 352]
    lea r13, [r9 + r14]
M2s_a563
    vmulps ymm7, ymm0, [rcx + 384]
M2s_a569
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_a56e
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_a574
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_a577
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_a57d
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_a580
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_a584
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_a585
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_a587
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_a588
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_a58a
M2s_a52e
M2s_a1f
M2s_a44a
M2s_a468
M2s_a543
M2s_a547
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a54a
    vpermps ymm1, ymm3, [r8 + 280]
M2s_a4e6
M2s_a550
M2s_a554
M2s_a47e
M2s_a55d
M2s_a567
M2s_a571
M2s_a57a
M2s_a582
M2s_a484
M2s_a586
    vpermps ymm1, ymm3, [r13 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a589
M2s_a4bc
M2s_a58d
M2s_a591
M2s_a535
M2s_a597
M2s_a59c
M2s_a521
M2s_a5a2
M2s_a5a8
M2s_a566
M2s_a5af
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a5b0
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a5b1
    vpermps ymm1, ymm3, [r13 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a5b2
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a5b3
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a5b4
M2s_a52c
M2s_a4ed
M2s_a154
M2s_a16c
M2s_a17f
M2s_a161
M2s_a18f
M2s_a19c
M2s_a16a
M2s_a1bb
M2s_a1a1
M2s_a457
M2s_a1cd
M2s_a1d6
M2s_a1dd
M2s_a1e6
M2s_a1f1
M2s_a1fa
M2s_a176
M2s_a201
M2s_a185
M2s_a20c
M2s_a195
M2s_a214
M2s_a1b1
M2s_a16a
M2s_a217
M2s_a1a1
M2s_a456
M2s_a4f1
M2s_a507
M2s_a53d
M2s_a227
M2s_a1ef
M2s_a231
M2s_a239
M2s_a242
M2s_a24a
M2s_a251
M2s_a258
M2s_a262
M2s_a25d
M2s_a26a
M2s_a278
M2s_a28c
M2s_a281
M2s_a53f
M2s_a299
M2s_a2a9
M2s_a29d
M2s_a2b7
M2s_a2aa
M2s_a2b1
M2s_a45b
M2s_a2bb
    vfmadd213ps ymm4, ymm1, [c_q8e0]
M2s_a2c8
M2s_a2cf
M2s_a2d4
M2s_a2c4
M2s_a2da
M2s_a2de
M2s_a2e2
M2s_a271
M2s_a277
M2s_a2e4
M2s_a28d
M2s_a291
M2s_a2e7
M2s_a2ea
M2s_a2a1
M2s_a2a3
M2s_a2ec
M2s_a2f4
M2s_a2fe
M2s_a460
M2s_a304
M2s_a4f2
M2s_a31b
M2s_a31f
M2s_a327
M2s_a32a
M2s_a330
M2s_a334
M2s_a310
M2s_a324
M2s_a338
M2s_a33b
M2s_a344
M2s_a34f
M2s_a359
M2s_a317
M2s_a328
M2s_a35d
M2s_a361
M2s_a365
M2s_a368
M2s_a36b
M2s_a36e
M2s_a348
M2s_a463
M2s_a353
M2s_a4f5
M2s_a374
M2s_a37f
M2s_a386
M2s_a378
M2s_a38e
M2s_a392
M2s_a396
M2s_a39a
M2s_a39e
M2s_a3a2
M2s_a3ab
M2s_a3bc
M2s_a3a7
M2s_a3b0
M2s_a3c6
M2s_a3c8
M2s_a3b0
M2s_a3ce
M2s_a3d0
M2s_a3d4
M2s_a3d8
M2s_a3dc
M2s_a3e0
M2s_a3e4
M2s_a3ea
section .note.GNU-stack noalloc noexec nowrite progbits
