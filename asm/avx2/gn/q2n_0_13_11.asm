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
global xav_q2_0_13_11
align 64
xav_q2_0_13_11:
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
M2p_a477
M2p_a577
M2p_a57c
    vpermps ymm1, ymm3, [r8 + 272]
M2p_a623
    vmovdqu ymm3, [rdx + 224]
M2p_a624
M2p_a3fa
M2p_a589
M2p_a484
M2p_a590
M2p_a594
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2p_a644
M2p_a645
M2p_a649
M2p_a676
    vfmadd231ps ymm4, ymm0, [rcx + 384]
M2p_a596
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 416]
M2p_a59e
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2p_a5a7
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2p_a5b0
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2p_a5b5
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2p_a5bf
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2p_a5c4
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2p_a5ca
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2p_a5cc
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2p_a5d0
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2p_a5d3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2p_a5d6
    vfmadd231ps ymm5, ymm0, [rcx + 768]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [rax + 48]
M2p_a4a7
M2p_a4ac
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [rax + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [rax + 368]
M2p_a658
M2p_a5d9
M2p_a43b
M2p_a5dd
    vpermps ymm1, ymm3, [r9 + 272]
M2p_a62a
M2p_a56e
M2p_a5e9
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a5ef
M2p_a4e2
M2p_a5f8
M2p_a5fa
M2p_a65a
M2p_a65d
M2p_a661
M2p_a68c
    vpermps ymm1, ymm3, [r9 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 384]
M2p_a5fc
M2p_a678
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [rax + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a67a
    vpermps ymm1, ymm3, [rax + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a67c
    vpermps ymm1, ymm3, [rax + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a67e
    vpermps ymm1, ymm3, [rax + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a680
    vpermps ymm1, ymm3, [rax + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a682
M2p_a689
M2p_a16c
M2p_a178
M2p_a573
M2p_a601
M2p_a672
M2p_a606
M2p_a60b
M2p_a513
M2p_a610
M2p_a615
M2p_a4fb
M2p_a61d
M2p_a621
M2p_a665
M2p_a668
M2p_a66d
M2p_a693
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 384]
M2p_a622
M2p_a678
M2p_a68f
M2p_a5bd
M2p_a690
    vmovdqu ymm3, [rdx + 608]
M2p_a691
M2p_a5cf
M2p_a680
M2p_a692
M2p_a685
M2p_a1e2
M2p_a6b
M2p_a3eb
M2p_a477
M2p_a577
M2p_a57c
M2p_a674
M2p_a3f8
M2p_a584
M2p_a531
M2p_a58c
M2p_a58f
M2p_a536
M2p_a595
M2p_a644
M2p_a645
M2p_a649
M2p_a677
M2p_a5a4
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [rax + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a679
    vpermps ymm1, ymm3, [rax + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a67b
    vpermps ymm1, ymm3, [rax + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a67d
    vpermps ymm1, ymm3, [rax + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a67f
    vpermps ymm1, ymm3, [rax + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a681
    vpermps ymm1, ymm3, [rax + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a683
M2p_a657
M2p_a56b
M2p_a629
M2p_a5dd
M2p_a68a
M2p_a442
M2p_a5e8
    vpermps ymm1, ymm3, [r9 + 288]
M2p_a68b
M2p_a4e1
M2p_a5f5
M2p_a5f9
    vpermps ymm1, ymm3, [r9 + 364]
M2p_a65a
M2p_a65d
M2p_a661
M2p_a68d
M2p_a5a2
M2p_a696
    vmovdqu ymm3, [rdx + 608]
M2p_a697
M2p_a5c3
M2p_a67d
M2p_a698
M2p_a5d2
M2p_a681
M2p_a699
M2p_a687
M2p_a1f0
M2p_a176
M2p_a450
    vmovdqu ymm3, [rdx + 256]
M2p_a601
M2p_a672
M2p_a606
M2p_a60b
M2p_a513
M2p_a610
M2p_a615
M2p_a4fb
M2p_a61d
M2p_a621
M2p_a665
M2p_a668
M2p_a66d
M2p_a694
M2p_a5a3
M2p_a679
M2p_a697
M2p_a5c3
M2p_a67d
M2p_a698
M2p_a5d2
M2p_a681
M2p_a699
M2p_a688
M2p_a1db
M2p_a1f3
M2p_a1fa
M2p_a1fc
M2p_a204
M2p_a213
M2p_a21d
M2p_a227
M2p_a22c
M2p_a230
M2p_a208
M2p_a20c
M2p_a470
M2p_a217
M2p_a220
    add r8, 128
M2p_a52d
M2p_a236
M2p_a23a
M2p_a574
    add ecx, r12d
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
M2p_a575
M2p_a294
    vbroadcastsd ymm4, [d_mone]
M2p_a576
M2p_a2ab
M2p_a2b1
M2p_a2b9
M2p_a2c8
M2p_a2d7
M2p_a2e1
M2p_a2ea
M2p_a2f0
M2p_a2fa
M2p_a317
M2p_a301
M2p_a30f
M2p_a313
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
M2p_a673
M2p_a386
    cmp rcx, [rbp + 7000]
M2p_a38b
M2p_a390
M2p_a395
M2p_a39a
M2p_a39f
M2p_a3a8
M2p_a3af
M2p_a3b5
M2p_a3bc
M2p_a3c3
M2p_a3c9
M2p_a3cf
M2p_a3d6
M2p_a3dc
M2p_a3e2
    call .dexp
M2p_a3e7
section .note.GNU-stack noalloc noexec nowrite progbits
