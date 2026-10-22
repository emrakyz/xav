%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_15_13_pft: dq xav_g2_0_15_13.pf1, xav_g2_0_15_13.pf2, xav_g2_0_15_13.pf3, xav_g2_0_15_13.pf4, xav_g2_0_15_13.pf5, xav_g2_0_15_13.pf6, xav_g2_0_15_13.pf7, xav_g2_0_15_13.pf8, xav_g2_0_15_13.pf9, xav_g2_0_15_13.pf10, xav_g2_0_15_13.pf11, xav_g2_0_15_13.pf12, xav_g2_0_15_13.pf13, xav_g2_0_15_13.pf14, xav_g2_0_15_13.pf15, xav_g2_0_15_13.pf16, xav_g2_0_15_13.pf17, xav_g2_0_15_13.pf18, xav_g2_0_15_13.pf19, xav_g2_0_15_13.pf20, xav_g2_0_15_13.pf21, xav_g2_0_15_13.pf22, xav_g2_0_15_13.pf23, xav_g2_0_15_13.pf24, xav_g2_0_15_13.pf25, xav_g2_0_15_13.pf26, xav_g2_0_15_13.pf27, xav_g2_0_15_13.pf28, xav_g2_0_15_13.pf29, xav_g2_0_15_13.pf30, xav_g2_0_15_13.pf31, xav_g2_0_15_13.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_15_13
align 64
xav_g2_0_15_13:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_15_13_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a19
M2s_a466
M2s_a540
M2s_a60b
M2s_a6e1
M2s_a772
M2s_a48
M2s_a69d
M2s_a615
M2s_a6e9
M2s_a44d
M2s_a4e6
    vmovdqu ymm3, [rdx + 288]
M2s_a618
M2s_a6ec
M2s_a509
M2s_a555
M2s_a775
M2s_a477
M2s_a558
M2s_a622
M2s_a6f3
M2s_a5cc
M2s_a5f2
M2s_a777
M2s_a6a4
    vmovdqu ymm3, [rdx + 288]
M2s_a6c6
M2s_a6f8
M2s_a7a4
M2s_a783
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 448]
M2s_a6fa
M2s_a702
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 480]
M2s_a704
M2s_a708
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a709
M2s_a711
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_a712
M2s_a717
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_a718
M2s_a71e
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_a71f
M2s_a724
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_a725
M2s_a72c
    vpermps ymm1, ymm3, [r13 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_a72e
M2s_a731
    vpermps ymm1, ymm3, [r13 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_a732
M2s_a735
    vpermps ymm1, ymm3, [r13 + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_a736
M2s_a737
    vpermps ymm1, ymm3, [r13 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2s_a738
M2s_a73b
    vpermps ymm1, ymm3, [r13 + 424]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2s_a73c
M2s_a73e
    vpermps ymm1, ymm3, [r13 + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 832]
M2s_a73f
M2s_a741
    vpermps ymm1, ymm3, [r13 + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 864]
M2s_a743
M2s_a745
    vpermps ymm1, ymm3, [r13 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 896]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 56]
M2s_a659
M2s_a65a
M2s_a65d
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a7b2
    vpermps ymm1, ymm3, [r13 + 440]
M2s_a78e
M2s_a58b
M2s_a675
M2s_a746
M2s_a778
M2s_af4
M2s_a790
M2s_a680
M2s_a750
M2s_a4ea
    vmovdqu ymm3, [rdx + 288]
M2s_a683
M2s_a754
M2s_a51f
M2s_a5a1
M2s_a77a
M2s_a4d3
M2s_a5a5
M2s_a68c
M2s_a75c
M2s_a5dc
M2s_a600
M2s_a77b
M2s_a6b3
    vmovdqu ymm3, [rdx + 288]
M2s_a764
M2s_a794
M2s_a799
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 448]
M2s_a766
M2s_a702
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 480]
M2s_a704
M2s_a708
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_a709
M2s_a711
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_a712
M2s_a717
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_a718
M2s_a71e
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_a71f
M2s_a724
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_a725
M2s_a72c
    vpermps ymm1, ymm3, [r13 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_a72e
M2s_a731
    vpermps ymm1, ymm3, [r13 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_a732
M2s_a735
    vpermps ymm1, ymm3, [r13 + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_a736
M2s_a737
    vpermps ymm1, ymm3, [r13 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_a738
M2s_a73b
    vpermps ymm1, ymm3, [r13 + 424]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 800]
M2s_a73c
M2s_a73e
    vpermps ymm1, ymm3, [r13 + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 832]
M2s_a73f
M2s_a741
    vpermps ymm1, ymm3, [r13 + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 864]
M2s_a743
M2s_a745
    vpermps ymm1, ymm3, [r13 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 896]
M2s_a7b0
M2s_a7b2
    vpermps ymm1, ymm3, [r13 + 440]
M2s_a7a1
M2s_a1d
M2s_a449
M2s_a467
M2s_a542
M2s_a76e
M2s_a39
M2s_a3f1
M2s_a546
M2s_a610
M2s_a6e4
M2s_a6c4
M2s_a54b
M2s_a773
M2s_a69
M2s_a3f8
M2s_a54d
M2s_a618
M2s_a6ec
M2s_a509
M2s_a555
M2s_a775
M2s_a477
M2s_a558
M2s_a622
M2s_a6f3
M2s_a5cc
M2s_a5f2
M2s_a777
M2s_a6a4
M2s_a7a7
M2s_a6fd
M2s_a701
M2s_a7a9
M2s_a70f
M2s_a711
M2s_a7aa
M2s_a71a
M2s_a7ab
M2s_a729
M2s_a72c
M2s_a7ac
M2s_a62f
M2s_a733
M2s_a7ad
M2s_a641
M2s_a73b
M2s_a7ae
M2s_a64f
M2s_a740
M2s_a7af
M2s_a65c
M2s_a7b3
M2s_ad5
M2s_a533
M2s_a58f
M2s_a678
M2s_a748
M2s_a7a5
    vmovdqu ymm3, [rdx + 288]
M2s_a67d
M2s_a74d
M2s_a51d
M2s_a599
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 372]
M2s_a752
M2s_a536
M2s_a59f
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 380]
M2s_a756
M2s_a4eb
M2s_a5a4
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 388]
M2s_a75b
M2s_a524
M2s_a5ac
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 396]
M2s_a75f
M2s_a6b1
M2s_a6b4
M2s_a765
    vpermps ymm1, ymm3, [r9 + 436]
M2s_a793
M2s_a798
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a7b6
M2s_a706
M2s_a7b7
M2s_a715
M2s_a7b8
M2s_a723
M2s_a724
M2s_a7b9
M2s_a730
M2s_a7ba
M2s_a639
M2s_a737
M2s_a7bb
M2s_a648
M2s_a73d
M2s_a7bc
M2s_a656
M2s_a745
M2s_a7bd
    vmovdqu ymm3, [rdx + 672]
M2s_a7b1
M2s_a7a2
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
