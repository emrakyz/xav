%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_15_14_pft: dq xav_g2_0_15_14.pf1, xav_g2_0_15_14.pf2, xav_g2_0_15_14.pf3, xav_g2_0_15_14.pf4, xav_g2_0_15_14.pf5, xav_g2_0_15_14.pf6, xav_g2_0_15_14.pf7, xav_g2_0_15_14.pf8, xav_g2_0_15_14.pf9, xav_g2_0_15_14.pf10, xav_g2_0_15_14.pf11, xav_g2_0_15_14.pf12, xav_g2_0_15_14.pf13, xav_g2_0_15_14.pf14, xav_g2_0_15_14.pf15, xav_g2_0_15_14.pf16, xav_g2_0_15_14.pf17, xav_g2_0_15_14.pf18, xav_g2_0_15_14.pf19, xav_g2_0_15_14.pf20, xav_g2_0_15_14.pf21, xav_g2_0_15_14.pf22, xav_g2_0_15_14.pf23, xav_g2_0_15_14.pf24, xav_g2_0_15_14.pf25, xav_g2_0_15_14.pf26, xav_g2_0_15_14.pf27, xav_g2_0_15_14.pf28, xav_g2_0_15_14.pf29, xav_g2_0_15_14.pf30, xav_g2_0_15_14.pf31, xav_g2_0_15_14.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_15_14
align 64
xav_g2_0_15_14:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_15_14_pft]
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
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 416]
M2s_a2b
M2s_a2f
M2s_a3f0
M2s_a544
M2s_a60e
M2s_a6e2
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 420]
M2s_a31
M2s_a36
M2s_a3f1
M2s_a546
M2s_a610
M2s_a6e3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 424]
M2s_a3b
M2s_a42
M2s_a3f2
M2s_a548
M2s_a611
M2s_a6e6
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 428]
M2s_a45
M2s_a4c
M2s_a3f5
M2s_a549
M2s_a612
M2s_a6e8
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 432]
M2s_a50
M2s_a5c
M2s_a3f6
M2s_a54c
M2s_a616
M2s_a6ea
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 436]
M2s_a5e
M2s_a66
M2s_a3f8
M2s_a54d
M2s_a618
M2s_a6eb
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 440]
M2s_a6b
M2s_a70
M2s_a3f9
M2s_a551
M2s_a61b
M2s_a6ed
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 444]
M2s_a75
M2s_a7a
M2s_a3fa
M2s_a553
M2s_a61c
M2s_a6ef
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 448]
M2s_a80
M2s_a84
M2s_a3fb
M2s_a557
M2s_a620
M2s_a6f1
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 452]
M2s_a471
M2s_a474
M2s_a47b
M2s_a558
M2s_a622
M2s_a6f2
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 456]
M2s_a531
M2s_a50e
M2s_a511
M2s_a55f
M2s_a625
M2s_a6f4
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 460]
M2s_a5e7
M2s_a5c9
M2s_a5cd
M2s_a5f0
M2s_a627
M2s_a6f7
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 464]
M2s_a6a1
M2s_a6c6
M2s_a6f8
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 468]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a7a4
M2s_a783
M2s_a7c7
M2s_a7cb
M2s_a7d1
M2s_a7d7
M2s_a7dd
    vpermps ymm1, ymm3, [r13 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
M2s_a7e2
M2s_a7e4
    vfmadd231ps ymm5, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_a6fc
M2s_a7e6
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 448]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_a705
M2s_a7e9
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 452]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_a70b
M2s_a7eb
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 456]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 800]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_a713
M2s_a7ee
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 460]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 832]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 48]
M2s_a719
M2s_a7f0
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 464]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 864]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 52]
M2s_a720
M2s_a7f3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 468]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 896]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 56]
M2s_a726
M2s_a7f5
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 472]
M2s_a78e
M2s_a58b
M2s_a675
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 416]
M2s_acd
M2s_ad3
M2s_a434
M2s_a58e
M2s_a677
M2s_a747
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 420]
M2s_ad8
M2s_ade
M2s_a436
M2s_a590
M2s_a67a
M2s_a74a
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 424]
M2s_ae2
M2s_aec
M2s_a438
M2s_a593
M2s_a67d
M2s_a74c
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 428]
M2s_aef
M2s_af7
M2s_a43a
M2s_a594
M2s_a67f
M2s_a74e
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 432]
M2s_afc
M2s_a106
M2s_a43d
M2s_a598
M2s_a682
M2s_a751
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 436]
M2s_a10d
M2s_a117
M2s_a43e
M2s_a59a
M2s_a683
M2s_a753
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 440]
M2s_a11c
M2s_a122
M2s_a440
M2s_a59e
M2s_a686
M2s_a755
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 444]
M2s_a128
M2s_a12e
M2s_a441
M2s_a5a0
M2s_a688
M2s_a758
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 448]
M2s_a134
M2s_a137
M2s_a443
M2s_a5a3
M2s_a68b
M2s_a75a
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 452]
M2s_a4cc
M2s_a4d0
M2s_a4d7
M2s_a5a5
M2s_a68c
M2s_a75d
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 456]
M2s_a538
M2s_a523
M2s_a525
M2s_a5ab
M2s_a68f
M2s_a75e
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 460]
M2s_a5fe
M2s_a691
M2s_a760
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 464]
M2s_a6be
M2s_a764
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 468]
M2s_a793
M2s_a798
M2s_a7bf
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 472]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 448]
    lea r13, [r9 + r14]
M2s_a7c8
M2s_a7c9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 480]
M2s_a7ca
M2s_a7cd
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_a7cf
M2s_a7d0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_a7d2
M2s_a7d4
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_a7d6
M2s_a7d8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_a7d9
M2s_a7db
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_a7de
M2s_a7df
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_a7e0
M2s_a7e3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_a7e5
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 384]
M2s_a7e6
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 448]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_a7e8
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 388]
M2s_a7e9
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 452]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_a7ea
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 392]
M2s_a7eb
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 456]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 800]
M2s_a7ed
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 396]
M2s_a7ee
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 460]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 832]
M2s_a7ef
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 400]
M2s_a7f0
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 464]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 864]
M2s_a7f2
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 404]
M2s_a7f3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 468]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 896]
M2s_a7f4
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 408]
M2s_a7f5
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 472]
M2s_a7a1
M2s_a1d
M2s_a449
M2s_a467
M2s_a542
M2s_a76f
M2s_a7c0
M2s_a38
    vmovdqu ymm3, [rdx + 192]
M2s_a771
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a7c1
M2s_a4f
M2s_a3f5
M2s_a549
M2s_a612
M2s_a6e8
M2s_a7c2
M2s_a69
M2s_a3f8
M2s_a54d
M2s_a618
M2s_a6eb
M2s_a7c3
M2s_a7f
M2s_a3fa
M2s_a553
M2s_a61c
M2s_a6ef
M2s_a7c4
M2s_a477
M2s_a558
M2s_a622
M2s_a6f2
M2s_a7c5
M2s_a5cb
M2s_a5f0
M2s_a627
M2s_a6f7
M2s_a7c6
M2s_a780
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a7c7
M2s_a7cb
M2s_a7d1
M2s_a7d7
M2s_a7dd
M2s_a7e1
M2s_a7e7
M2s_a70e
M2s_a710
M2s_a804
M2s_a7ec
M2s_a71b
M2s_a71d
M2s_a806
M2s_a7f1
M2s_a728
M2s_a72b
M2s_a808
M2s_a78e
M2s_a58b
M2s_a675
M2s_a7f7
M2s_ae0
M2s_a6d4
M2s_a67b
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a7f8
M2s_afb
M2s_a43a
M2s_a594
M2s_a67f
M2s_a74e
M2s_a7f9
M2s_a119
M2s_a43e
M2s_a59a
M2s_a683
M2s_a753
M2s_a7fa
M2s_a131
M2s_a441
M2s_a5a0
M2s_a688
M2s_a758
M2s_a7fb
M2s_a4d3
M2s_a5a5
M2s_a68c
M2s_a75d
M2s_a7fc
M2s_a5db
M2s_a6d7
M2s_a760
M2s_a7fd
M2s_a795
M2s_a7bf
M2s_a7fe
M2s_a7cc
M2s_a7ce
M2s_a7ff
M2s_a7d3
M2s_a7d5
M2s_a800
M2s_a7da
M2s_a7dc
M2s_a801
M2s_a7e2
M2s_a7e4
M2s_a802
M2s_a707
M2s_a708
M2s_a803
M2s_a714
M2s_a717
M2s_a805
M2s_a722
M2s_a724
M2s_a807
M2s_a72a
M2s_a72d
M2s_a7f6
M2s_a809
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
M2s_a69c
M2s_a2cd
M2s_a2d2
M2s_a2c2
M2s_a45e
M2s_a2dc
M2s_a2e0
M2s_a6c2
M2s_a286
M2s_a2e5
M2s_a2e8
    vmovups ymm8, [c_q8e0]
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
