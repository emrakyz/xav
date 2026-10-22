%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_14_12_pft: dq xav_g2_0_14_12.pf1, xav_g2_0_14_12.pf2, xav_g2_0_14_12.pf3, xav_g2_0_14_12.pf4, xav_g2_0_14_12.pf5, xav_g2_0_14_12.pf6, xav_g2_0_14_12.pf7, xav_g2_0_14_12.pf8, xav_g2_0_14_12.pf9, xav_g2_0_14_12.pf10, xav_g2_0_14_12.pf11, xav_g2_0_14_12.pf12, xav_g2_0_14_12.pf13, xav_g2_0_14_12.pf14, xav_g2_0_14_12.pf15, xav_g2_0_14_12.pf16, xav_g2_0_14_12.pf17, xav_g2_0_14_12.pf18, xav_g2_0_14_12.pf19, xav_g2_0_14_12.pf20, xav_g2_0_14_12.pf21, xav_g2_0_14_12.pf22, xav_g2_0_14_12.pf23, xav_g2_0_14_12.pf24, xav_g2_0_14_12.pf25, xav_g2_0_14_12.pf26, xav_g2_0_14_12.pf27, xav_g2_0_14_12.pf28, xav_g2_0_14_12.pf29, xav_g2_0_14_12.pf30, xav_g2_0_14_12.pf31, xav_g2_0_14_12.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_14_12
align 64
xav_g2_0_14_12:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_14_12_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a19
M2s_a466
M2s_a540
M2s_a60c
    vmovdqu ymm3, [rdx + 224]
M2s_a69b
M2s_a4e
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 240]
M2s_a3f5
M2s_a549
M2s_a613
M2s_a3f8
M2s_a54d
M2s_a617
M2s_a3fa
M2s_a553
M2s_a61d
M2s_a47b
M2s_a558
M2s_a621
M2s_a5cd
M2s_a5f0
M2s_a627
M2s_a6a1
M2s_a6c6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 416]
M2s_a62a
M2s_a633
    vmulps ymm5, ymm0, [rcx + 448]
M2s_a634
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_a63c
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a644
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_a64b
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_a652
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_a658
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_a65f
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_a664
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_a668
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_a66a
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2s_a66e
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2s_a670
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 832]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 52]
M2s_a57e
M2s_a57f
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 404]
M2s_a6ae
M2s_a58b
M2s_a674
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 264]
M2s_a51b
    vmovdqu ymm3, [rdx + 288]
M2s_a679
M2s_a43a
M2s_a594
M2s_a67e
M2s_a43e
M2s_a59a
M2s_a684
M2s_a441
M2s_a5a0
M2s_a687
M2s_a4d7
M2s_a5a5
M2s_a68d
M2s_a5dd
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 336]
M2s_a600
M2s_a692
M2s_a6af
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 416]
M2s_a693
M2s_a633
    vmulps ymm7, ymm0, [rcx + 448]
M2s_a634
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_a63c
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_a644
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_a64b
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_a652
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_a658
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_a65f
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_a664
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_a668
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_a66a
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_a66e
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 800]
M2s_a670
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 832]
M2s_a6d0
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 404]
M2s_a6bf
M2s_a144
M2s_a25
M2s_a2a
M2s_a449
M2s_a467
M2s_a542
M2s_a60d
M2s_a69b
M2s_a4e
M2s_a6c5
M2s_a64
M2s_a4e5
M2s_a54f
M2s_a61a
M2s_a69f
M2s_a61f
M2s_a47d
M2s_a55b
M2s_a624
M2s_a5cf
M2s_a5f2
M2s_a629
M2s_a6a3
M2s_a6c8
M2s_a638
M2s_a63b
M2s_a6ca
M2s_a649
M2s_a6cb
M2s_a656
M2s_a6cc
M2s_a662
M2s_a6cd
M2s_a669
M2s_a6ce
M2s_a66f
M2s_a6cf
M2s_a6d1
M2s_ad6
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 228]
M2s_a434
M2s_a58e
M2s_a676
M2s_a438
M2s_a593
M2s_a67c
M2s_a43d
M2s_a598
M2s_a681
M2s_a440
M2s_a59e
M2s_a685
M2s_a443
M2s_a5a3
M2s_a68a
M2s_a525
M2s_a5ab
M2s_a690
M2s_a6d5
M2s_a62d
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6d9
M2s_a641
M2s_a6da
M2s_a650
M2s_a6db
M2s_a65c
M2s_a6dc
M2s_a665
M2s_a6dd
M2s_a66b
M2s_a6de
M2s_a671
M2s_a6df
M2s_a6d2
M2s_a6bc
M2s_a14c
M2s_a155
M2s_a15b
M2s_a16d
M2s_a451
M2s_a18b
M2s_a199
M2s_a1b7
M2s_a4ee
M2s_a1d0
M2s_a6c0
M2s_a1e0
M2s_a1e9
M2s_a1f4
M2s_a162
M2s_a167
M2s_a200
M2s_a17e
M2s_a20b
M2s_a192
M2s_a213
M2s_a1a8
M2s_a1b6
M2s_a218
M2s_a1a2
M2s_a1cb
M2s_a1ce
M2s_a1cf
M2s_a21b
M2s_a1a2
M2s_a1db
M2s_a1de
M2s_a1df
M2s_a21f
M2s_a224
M2s_a22d
M2s_a236
M2s_a23c
M2s_a458
M2s_a245
M2s_a24d
M2s_a254
M2s_a25e
M2s_a265
M2s_a272
M2s_a288
M2s_a27d
M2s_a283
M2s_a292
M2s_a29a
M2s_a2ab
M2s_a29f
M2s_a2b8
M2s_a2ac
M2s_a2b2
M2s_a45c
M2s_a2bc
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
