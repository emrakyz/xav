%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_14_13_pft: dq xav_g2_0_14_13.pf1, xav_g2_0_14_13.pf2, xav_g2_0_14_13.pf3, xav_g2_0_14_13.pf4, xav_g2_0_14_13.pf5, xav_g2_0_14_13.pf6, xav_g2_0_14_13.pf7, xav_g2_0_14_13.pf8, xav_g2_0_14_13.pf9, xav_g2_0_14_13.pf10, xav_g2_0_14_13.pf11, xav_g2_0_14_13.pf12, xav_g2_0_14_13.pf13, xav_g2_0_14_13.pf14, xav_g2_0_14_13.pf15, xav_g2_0_14_13.pf16, xav_g2_0_14_13.pf17, xav_g2_0_14_13.pf18, xav_g2_0_14_13.pf19, xav_g2_0_14_13.pf20, xav_g2_0_14_13.pf21, xav_g2_0_14_13.pf22, xav_g2_0_14_13.pf23, xav_g2_0_14_13.pf24, xav_g2_0_14_13.pf25, xav_g2_0_14_13.pf26, xav_g2_0_14_13.pf27, xav_g2_0_14_13.pf28, xav_g2_0_14_13.pf29, xav_g2_0_14_13.pf30, xav_g2_0_14_13.pf31, xav_g2_0_14_13.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_14_13
align 64
xav_g2_0_14_13:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_14_13_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a19
M2s_a466
M2s_a540
M2s_a60b
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 384]
M2s_a2b
M2s_a2f
M2s_a3f0
M2s_a544
M2s_a60e
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 388]
M2s_a31
M2s_a36
M2s_a3f1
M2s_a546
M2s_a610
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 392]
M2s_a3b
M2s_a42
M2s_a3f2
M2s_a548
M2s_a611
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 396]
M2s_a45
M2s_a4c
M2s_a3f5
M2s_a549
M2s_a612
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 400]
M2s_a50
M2s_a5c
M2s_a3f6
M2s_a54c
M2s_a616
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 404]
M2s_a5e
M2s_a66
M2s_a3f8
M2s_a54d
M2s_a618
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 408]
M2s_a6b
M2s_a70
M2s_a3f9
M2s_a551
M2s_a61b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 412]
M2s_a75
M2s_a7a
M2s_a3fa
M2s_a553
M2s_a61c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 416]
M2s_a80
M2s_a84
M2s_a3fb
M2s_a557
M2s_a620
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 420]
M2s_a471
M2s_a474
M2s_a47b
M2s_a558
M2s_a622
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 424]
M2s_a531
M2s_a50e
M2s_a511
M2s_a55f
M2s_a625
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 428]
M2s_a5e7
M2s_a5c9
M2s_a5cd
M2s_a5f0
M2s_a627
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 432]
M2s_a6a1
M2s_a6c6
M2s_a6f8
    vfmadd231ps ymm4, ymm0, [rcx + 416]
M2s_a6fa
M2s_a702
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 448]
M2s_a704
M2s_a708
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_a709
M2s_a711
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a712
M2s_a717
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_a718
M2s_a71e
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_a71f
M2s_a724
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_a725
M2s_a72c
    vpermps ymm1, ymm3, [r13 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_a72e
M2s_a731
    vpermps ymm1, ymm3, [r13 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_a62c
M2s_a62e
M2s_a631
M2s_a733
    vfmadd231ps ymm5, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_a635
M2s_a636
M2s_a63a
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a737
    vpermps ymm1, ymm3, [r13 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_a63d
M2s_a63f
M2s_a643
M2s_a73a
    vfmadd231ps ymm5, ymm0, [rcx + 768]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_a645
M2s_a647
M2s_a64a
M2s_a73d
    vfmadd231ps ymm5, ymm0, [rcx + 800]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 48]
M2s_a64c
M2s_a64e
M2s_a651
M2s_a740
    vfmadd231ps ymm5, ymm0, [rcx + 832]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 52]
M2s_a653
M2s_a655
M2s_a657
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a745
    vpermps ymm1, ymm3, [r13 + 436]
M2s_a6ae
M2s_a58b
M2s_a675
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 384]
M2s_acd
M2s_ad3
M2s_a434
M2s_a58e
M2s_a677
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 388]
M2s_ad8
M2s_ade
M2s_a436
M2s_a590
M2s_a67a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 392]
M2s_ae2
M2s_aec
M2s_a438
M2s_a593
M2s_a67d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 396]
M2s_aef
M2s_af7
M2s_a43a
M2s_a594
M2s_a67f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 400]
M2s_afc
M2s_a106
M2s_a43d
M2s_a598
M2s_a682
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 404]
M2s_a10d
M2s_a117
M2s_a43e
M2s_a59a
M2s_a683
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 408]
M2s_a11c
M2s_a122
M2s_a440
M2s_a59e
M2s_a686
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 412]
M2s_a128
M2s_a12e
M2s_a441
M2s_a5a0
M2s_a688
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 416]
M2s_a134
M2s_a137
M2s_a443
M2s_a5a3
M2s_a68b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 420]
M2s_a4cc
M2s_a4d0
M2s_a4d7
M2s_a5a5
M2s_a68c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 424]
M2s_a538
M2s_a523
M2s_a525
M2s_a5ab
M2s_a68f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 428]
M2s_a5fe
M2s_a691
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 432]
M2s_a6be
M2s_a764
    vfmadd231ps ymm6, ymm0, [rcx + 416]
    lea r13, [r9 + r14]
M2s_a6fb
M2s_a703
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 448]
M2s_a704
M2s_a708
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_a709
M2s_a711
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_a712
M2s_a717
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_a718
M2s_a71e
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_a71f
M2s_a724
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_a725
M2s_a72c
    vpermps ymm1, ymm3, [r13 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_a72e
M2s_a731
    vpermps ymm1, ymm3, [r13 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_a732
M2s_a735
    vpermps ymm1, ymm3, [r13 + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_a736
M2s_a737
    vpermps ymm1, ymm3, [r13 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_a738
M2s_a73b
    vpermps ymm1, ymm3, [r13 + 424]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_a73c
M2s_a73e
    vpermps ymm1, ymm3, [r13 + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 800]
M2s_a73f
M2s_a741
    vpermps ymm1, ymm3, [r13 + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 832]
M2s_a743
M2s_a745
    vpermps ymm1, ymm3, [r13 + 436]
M2s_a6bf
M2s_a144
M2s_a25
M2s_a2a
M2s_a449
M2s_a467
M2s_a542
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6e1
    vpermps ymm1, ymm3, [r8 + 232]
M2s_a3f1
M2s_a546
M2s_a610
M2s_a6e4
M2s_a6c4
M2s_a54b
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 368]
M2s_a6e7
M2s_a4e5
M2s_a54f
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 376]
M2s_a6ec
M2s_a509
M2s_a555
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 384]
M2s_a6ee
M2s_a478
M2s_a55b
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 392]
M2s_a6f3
M2s_a5cc
M2s_a5f2
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 400]
M2s_a6f5
M2s_a6fe
M2s_a70a
M2s_a716
M2s_a721
M2s_a72f
M2s_a632
M2s_a734
M2s_a63e
M2s_a642
    vmovdqu ymm3, [rdx + 672]
M2s_a739
M2s_a64d
M2s_a742
M2s_acb
M2s_a4bf
M2s_a58b
M2s_a675
M2s_a746
    vpermps ymm1, ymm3, [r9 + 232]
M2s_a436
M2s_a590
M2s_a67a
M2s_a749
M2s_a534
M2s_a596
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 368]
M2s_a74f
M2s_a4e8
M2s_a59d
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 376]
M2s_a754
M2s_a51f
M2s_a5a1
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 384]
M2s_a757
M2s_a4d4
M2s_a5a9
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 392]
M2s_a75c
M2s_a5dc
M2s_a600
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 400]
M2s_a761
M2s_a6ff
    vmovdqu ymm3, [rdx + 736]
M2s_a767
M2s_a70d
M2s_a768
M2s_a71c
M2s_a71e
M2s_a769
M2s_a727
M2s_a76a
M2s_a630
M2s_a735
M2s_a76b
M2s_a640
M2s_a73a
M2s_a76c
M2s_a650
M2s_a741
M2s_a76d
    vmovdqu ymm3, [rdx + 672]
M2s_a744
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
