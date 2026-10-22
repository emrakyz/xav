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
global xav_q2_0_13_12
align 64
xav_q2_0_13_12:
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
M2p_a578
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 352]
M2p_a6c
M2p_a70
M2p_a3f0
M2p_a57a
M2p_a6a3
M2p_a73
M2p_a77
M2p_a3f1
M2p_a57b
M2p_a6a5
M2p_a7d
M2p_a84
M2p_a3f2
M2p_a57e
M2p_a6a6
M2p_a87
M2p_a8b
M2p_a3f5
M2p_a57f
M2p_a6a8
M2p_a8f
M2p_a96
M2p_a3f6
M2p_a582
M2p_a6a9
M2p_a97
M2p_a9e
M2p_a3f8
M2p_a583
M2p_a6aa
M2p_aa1
M2p_aa5
M2p_a3f9
M2p_a587
M2p_a6ad
M2p_aa7
M2p_aab
M2p_a3fa
M2p_a588
M2p_a6ae
M2p_aae
M2p_ab2
M2p_a3fb
M2p_a58d
M2p_a6b1
M2p_a47e
M2p_a480
M2p_a483
M2p_a58e
M2p_a6b3
M2p_a565
M2p_a533
M2p_a535
M2p_a593
M2p_a6b5
M2p_a675
M2p_a6b6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 384]
M2p_a6b9
M2p_a6c3
    vmulps ymm5, ymm0, [rcx + 416]
M2p_a6c4
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2p_a6cf
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2p_a6d8
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2p_a6e2
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2p_a6eb
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2p_a6f6
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2p_a6ff
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [rax + 32]
M2p_a598
M2p_a599
    vmovdqu ymm3, [rdx + 608]
M2p_a707
    vfmadd231ps ymm5, ymm0, [rcx + 672]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [rax + 36]
M2p_a59f
M2p_a5a0
    vmovdqu ymm3, [rdx + 608]
M2p_a70d
    vfmadd231ps ymm5, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [rax + 40]
M2p_a5a8
M2p_a5a9
    vmovdqu ymm3, [rdx + 608]
M2p_a710
    vfmadd231ps ymm5, ymm0, [rcx + 736]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [rax + 44]
M2p_a5b1
M2p_a5b2
    vmovdqu ymm3, [rdx + 608]
M2p_a716
    vfmadd231ps ymm5, ymm0, [rcx + 768]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [rax + 48]
M2p_a5b6
M2p_a5b7
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [rax + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a71c
    vpermps ymm1, ymm3, [rax + 400]
M2p_a658
M2p_a5d8
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 352]
M2p_a106
M2p_a10a
M2p_a43a
M2p_a5db
M2p_a71e
M2p_a10d
M2p_a113
M2p_a43b
M2p_a5dc
M2p_a71f
M2p_a117
M2p_a120
M2p_a43c
M2p_a5e0
M2p_a721
M2p_a124
M2p_a128
M2p_a440
M2p_a5e2
M2p_a723
M2p_a12c
M2p_a135
M2p_a441
M2p_a5e5
M2p_a724
M2p_a13a
M2p_a149
M2p_a442
M2p_a5e7
M2p_a725
M2p_a14d
M2p_a151
M2p_a446
M2p_a5ec
M2p_a727
M2p_a156
M2p_a15d
M2p_a447
M2p_a5ee
M2p_a729
M2p_a161
M2p_a167
M2p_a448
M2p_a5f1
M2p_a72a
M2p_a4d8
M2p_a4db
M2p_a4e0
M2p_a5f4
M2p_a72b
M2p_a570
M2p_a553
M2p_a556
M2p_a5f9
M2p_a72d
M2p_a65a
M2p_a65d
M2p_a661
M2p_a68c
M2p_a72f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 384]
    lea rax, [r9 + r14]
M2p_a6ba
M2p_a6cc
M2p_a6dd
M2p_a6f0
M2p_a700
M2p_a70b
M2p_a5ae
M2p_a712
M2p_a5bb
M2p_a71a
M2p_af5
M2p_a16b
M2p_a176
M2p_a450
M2p_a69c
M2p_a731
M2p_a179
M2p_a17d
M2p_a452
M2p_a603
M2p_a735
M2p_a180
M2p_a186
M2p_a454
M2p_a604
M2p_a737
M2p_a18a
M2p_a193
M2p_a457
M2p_a607
M2p_a739
M2p_a196
M2p_a19c
M2p_a458
M2p_a609
M2p_a73b
M2p_a1a0
M2p_a1ac
M2p_a45b
M2p_a60c
M2p_a73d
M2p_a1b1
M2p_a1b9
M2p_a45c
M2p_a60e
M2p_a73f
M2p_a1bd
M2p_a1c3
M2p_a45f
M2p_a612
M2p_a741
M2p_a1c7
M2p_a1cd
M2p_a461
M2p_a614
M2p_a743
M2p_a1d3
M2p_a1d7
M2p_a462
M2p_a617
M2p_a744
M2p_a4ed
M2p_a4f2
M2p_a4f9
M2p_a619
M2p_a745
M2p_a61f
M2p_a748
M2p_a664
M2p_a667
M2p_a66c
    vmovdqu ymm3, [rdx + 256]
M2p_a693
M2p_a74b
    vfmadd231ps ymm4, ymm0, [rcx + 384]
    lea rax, [r15 + r14]
M2p_a6ba
M2p_a6cc
M2p_a6dd
M2p_a6f0
M2p_a700
M2p_a70b
M2p_a5ae
M2p_a712
M2p_a5bb
M2p_a71a
M2p_a1da
M2p_a66
M2p_a3ed
M2p_a478
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a6a2
    vpermps ymm1, ymm3, [r8 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a57b
M2p_a6a4
M2p_a3f5
M2p_a57f
M2p_a6a7
M2p_a3f8
M2p_a583
M2p_a6ab
M2p_a3fa
M2p_a588
M2p_a6af
M2p_a483
M2p_a58e
M2p_a6b2
M2p_a648
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 336]
M2p_a676
M2p_a6b8
M2p_a6c9
M2p_a6dc
M2p_a6ef
M2p_a6fe
M2p_a708
M2p_a5aa
M2p_a711
M2p_a5b9
M2p_a719
M2p_a659
M2p_a1e9
M2p_aff
M2p_a435
M2p_a502
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a71d
    vpermps ymm1, ymm3, [r9 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a5dc
M2p_a720
M2p_a440
M2p_a5e2
M2p_a722
M2p_a442
M2p_a5e7
M2p_a726
M2p_a447
M2p_a5ee
M2p_a728
M2p_a4e0
M2p_a5f4
M2p_a72c
M2p_a661
M2p_a68c
M2p_a72e
M2p_a6c8
M2p_a6db
M2p_a6ee
M2p_a6fd
M2p_a59d
M2p_a709
M2p_a5ac
M2p_a714
M2p_a5bc
M2p_a71b
M2p_af6
M2p_a1f1
M2p_a178
M2p_a573
M2p_a600
M2p_a733
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 264]
M2p_a672
    vmovdqu ymm3, [rdx + 288]
M2p_a736
M2p_a458
M2p_a609
M2p_a73a
M2p_a45c
M2p_a60e
M2p_a73e
M2p_a461
M2p_a614
M2p_a742
M2p_a4f9
M2p_a619
M2p_a746
M2p_a66c
M2p_a749
M2p_a6c6
M2p_a6da
M2p_a6ec
M2p_a6fc
M2p_a59a
M2p_a709
M2p_a5ac
M2p_a714
M2p_a5bc
M2p_a71b
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
M2p_a574
M2p_a69e
M2p_a241
M2p_a245
M2p_a24a
M2p_a24f
M2p_a254
M2p_a25b
M2p_a268
M2p_a271
M2p_af
M2p_a27b
M2p_a281
M2p_a1b
M2p_a288
    vfmadd231ps ymm0, ymm1, ymm14
M2p_a28c
M2p_a29d
M2p_a298
    vbroadcastsd ymm4, [d_mone]
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
M2p_a673
M2p_a386
M2p_a6a0
M2p_a38f
M2p_a394
M2p_a399
M2p_a39e
M2p_a3a7
M2p_a3ae
M2p_a3b4
M2p_a3bb
M2p_a3c2
M2p_a3c8
M2p_a3ce
M2p_a3d5
M2p_a3db
M2p_a3e1
    vmovapd ymm1, ymm7
M2p_a6a1
    ud2
section .note.GNU-stack noalloc noexec nowrite progbits
