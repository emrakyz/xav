%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_13_12_pft: dq xav_g2_0_13_12.pf1, xav_g2_0_13_12.pf2, xav_g2_0_13_12.pf3, xav_g2_0_13_12.pf4, xav_g2_0_13_12.pf5, xav_g2_0_13_12.pf6, xav_g2_0_13_12.pf7, xav_g2_0_13_12.pf8, xav_g2_0_13_12.pf9, xav_g2_0_13_12.pf10, xav_g2_0_13_12.pf11, xav_g2_0_13_12.pf12, xav_g2_0_13_12.pf13, xav_g2_0_13_12.pf14, xav_g2_0_13_12.pf15, xav_g2_0_13_12.pf16, xav_g2_0_13_12.pf17, xav_g2_0_13_12.pf18, xav_g2_0_13_12.pf19, xav_g2_0_13_12.pf20, xav_g2_0_13_12.pf21, xav_g2_0_13_12.pf22, xav_g2_0_13_12.pf23, xav_g2_0_13_12.pf24, xav_g2_0_13_12.pf25, xav_g2_0_13_12.pf26, xav_g2_0_13_12.pf27, xav_g2_0_13_12.pf28, xav_g2_0_13_12.pf29, xav_g2_0_13_12.pf30, xav_g2_0_13_12.pf31, xav_g2_0_13_12.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_13_12
align 64
xav_g2_0_13_12:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_13_12_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a19
M2s_a466
M2s_a540
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 352]
M2s_a2b
M2s_a2f
M2s_a3f0
M2s_a544
M2s_a60e
M2s_a31
M2s_a36
M2s_a3f1
M2s_a546
M2s_a610
M2s_a3b
M2s_a42
M2s_a3f2
M2s_a548
M2s_a611
M2s_a45
M2s_a4c
M2s_a3f5
M2s_a549
M2s_a612
M2s_a50
M2s_a5c
M2s_a3f6
M2s_a54c
M2s_a616
M2s_a5e
M2s_a66
M2s_a3f8
M2s_a54d
M2s_a618
M2s_a6b
M2s_a70
M2s_a3f9
M2s_a551
M2s_a61b
M2s_a75
M2s_a7a
M2s_a3fa
M2s_a553
M2s_a61c
M2s_a80
M2s_a84
M2s_a3fb
M2s_a557
M2s_a620
M2s_a471
M2s_a474
M2s_a47b
M2s_a558
M2s_a622
M2s_a531
M2s_a50e
M2s_a511
M2s_a55f
M2s_a625
M2s_a5e7
M2s_a5c9
M2s_a5cd
M2s_a5f0
M2s_a626
M2s_a637
M2s_a646
M2s_a654
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_a65f
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_a564
M2s_a565
    vmovdqu ymm3, [rdx + 608]
M2s_a665
    vfmadd231ps ymm5, ymm0, [rcx + 672]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_a56a
M2s_a56b
    vmovdqu ymm3, [rdx + 608]
M2s_a669
    vfmadd231ps ymm5, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_a56f
M2s_a570
    vmovdqu ymm3, [rdx + 608]
M2s_a66b
    vfmadd231ps ymm5, ymm0, [rcx + 736]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_a575
M2s_a576
    vmovdqu ymm3, [rdx + 608]
M2s_a66f
    vfmadd231ps ymm5, ymm0, [rcx + 768]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 48]
M2s_a578
M2s_a579
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a673
    vpermps ymm1, ymm3, [r13 + 400]
M2s_a5d6
M2s_a58b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 352]
M2s_acd
M2s_ad3
M2s_a434
M2s_a58e
M2s_a677
M2s_ad8
M2s_ade
M2s_a436
M2s_a590
M2s_a67a
M2s_ae2
M2s_aec
M2s_a438
M2s_a593
M2s_a67d
M2s_aef
M2s_af7
M2s_a43a
M2s_a594
M2s_a67f
M2s_afc
M2s_a106
M2s_a43d
M2s_a598
M2s_a682
M2s_a10d
M2s_a117
M2s_a43e
M2s_a59a
M2s_a683
M2s_a11c
M2s_a122
M2s_a440
M2s_a59e
M2s_a686
M2s_a128
M2s_a12e
M2s_a441
M2s_a5a0
M2s_a688
M2s_a134
M2s_a137
M2s_a443
M2s_a5a3
M2s_a68b
M2s_a4cc
M2s_a4d0
M2s_a4d7
M2s_a5a5
M2s_a68c
M2s_a538
M2s_a523
M2s_a525
M2s_a5ab
M2s_a68f
M2s_a5fe
M2s_a691
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 384]
    lea r13, [r9 + r14]
M2s_a62b
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 416]
M2s_a634
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_a63c
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_a644
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_a64b
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_a652
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_a658
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_a65f
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_a664
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_a668
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_a66a
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_a66e
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_a670
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 400]
M2s_a5e4
M2s_a1d
M2s_a449
M2s_a467
M2s_a542
M2s_a60d
    vpermps ymm1, ymm3, [r8 + 264]
M2s_a5eb
    vmovdqu ymm3, [rdx + 288]
M2s_a60f
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
M2s_a626
M2s_a637
M2s_a646
M2s_a654
M2s_a65e
M2s_a568
M2s_a667
M2s_a572
M2s_a66d
M2s_a57b
M2s_a672
M2s_ad7
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
M2s_a68e
M2s_a62e
M2s_a631
M2s_a694
M2s_a640
M2s_a695
M2s_a64f
M2s_a696
M2s_a65b
M2s_a697
M2s_a568
M2s_a666
M2s_a698
M2s_a573
M2s_a66c
M2s_a699
M2s_a57c
M2s_a673
M2s_a69a
M2s_a14e
M2s_a157
M2s_a15d
M2s_a16f
M2s_a181
M2s_a18e
M2s_a19b
M2s_a1b9
M2s_a1c8
M2s_a1d2
M2s_a1d8
M2s_a1e2
M2s_a1ec
M2s_a1f6
M2s_a164
M2s_a169
M2s_a1ff
M2s_a17d
M2s_a209
M2s_a191
M2s_a212
M2s_a1a7
M2s_a1b4
M2s_a454
M2s_a1a0
M2s_a4f0
M2s_a506
M2s_a53c
M2s_a5c5
M2s_a226
M2s_a22f
M2s_a237
M2s_a240
M2s_a248
M2s_a24f
M2s_a256
M2s_a260
M2s_a267
M2s_a275
M2s_a28a
M2s_a27f
M2s_a285
M2s_a295
M2s_a29c
M2s_a2ae
M2s_a45a
M2s_a2a8
M2s_a2b0
M2s_a2c7
M2s_a2be
    vfmadd213ps ymm6, ymm8, ymm12
M2s_a5b7
M2s_a2ce
M2s_a2d3
M2s_a2c3
M2s_a45f
M2s_a2dd
M2s_a2e1
M2s_a2e3
M2s_a287
M2s_a2e6
M2s_a2e9
M2s_a2eb
M2s_a2f1
M2s_a5c6
M2s_a5e9
M2s_a2f8
M2s_a2fb
M2s_a302
M2s_a307
M2s_a315
M2s_a319
M2s_a322
M2s_a329
M2s_a32f
M2s_a333
M2s_a30f
M2s_a323
M2s_a337
M2s_a33a
M2s_a343
M2s_a34e
M2s_a358
M2s_a314
M2s_a327
M2s_a35c
M2s_a462
M2s_a364
M2s_a36a
M2s_a36d
M2s_a347
M2s_a4f4
M2s_a352
M2s_a371
M2s_a377
M2s_a382
M2s_a389
M2s_a37b
M2s_a37e
M2s_a385
M2s_a38d
M2s_a391
M2s_a395
M2s_a399
M2s_a39d
M2s_a3a1
M2s_a3aa
M2s_a3bb
M2s_a3a6
M2s_a3af
M2s_a3c5
M2s_a3c0
M2s_a3cb
M2s_a3b3
M2s_a3cd
M2s_a3c0
M2s_a3d3
M2s_a3d7
M2s_a3db
M2s_a3df
M2s_a3e3
M2s_a3e7
M2s_a3ed
    ret
section .note.GNU-stack noalloc noexec nowrite progbits
