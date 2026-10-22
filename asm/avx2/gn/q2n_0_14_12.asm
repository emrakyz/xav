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
global xav_q2_0_14_12
align 64
xav_q2_0_14_12:
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
M2p_a6a2
M2p_a74f
M2p_a8c
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 240]
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
M2p_a751
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a75f
M2p_a78d
    vfmadd231ps ymm4, ymm0, [rcx + 416]
M2p_a6b9
M2p_a6c3
    vmulps ymm5, ymm0, [rcx + 448]
M2p_a6c4
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2p_a6cf
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2p_a6d8
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2p_a6e2
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2p_a6eb
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2p_a6f6
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2p_a6ff
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2p_a706
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2p_a70c
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2p_a70f
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2p_a715
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2p_a718
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 832]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [rax + 52]
M2p_a5c0
M2p_a5c1
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [rax + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [rax + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 404]
M2p_a771
M2p_a5d8
M2p_a71d
M2p_a757
M2p_a12a
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 240]
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
M2p_a72f
M2p_a774
M2p_a7aa
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 416]
M2p_a730
M2p_a6c3
M2p_a790
M2p_a6d5
M2p_a793
M2p_a6e9
M2p_a796
M2p_a6fa
M2p_a799
M2p_a707
M2p_a79c
M2p_a710
M2p_a79f
M2p_a719
M2p_a7a2
M2p_a7a6
M2p_a44d
M2p_a173
M2p_a50e
    vmovdqu ymm3, [rdx + 288]
M2p_a732
M2p_a454
M2p_a604
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
M2p_a74a
M2p_a783
M2p_a7af
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 416]
M2p_a74c
M2p_a6c3
M2p_a790
M2p_a6d5
M2p_a793
M2p_a6e9
M2p_a796
M2p_a6fa
M2p_a799
M2p_a707
M2p_a79c
M2p_a710
M2p_a79f
M2p_a719
M2p_a7a2
M2p_a7a6
M2p_a1e2
M2p_a6b
M2p_a3eb
M2p_a477
M2p_a578
M2p_a6a2
M2p_a74f
M2p_a8c
M2p_a78a
M2p_a9b
M2p_a4ff
M2p_a585
M2p_a6ac
M2p_a531
M2p_a58b
M2p_a6b0
M2p_a484
M2p_a591
M2p_a6b4
M2p_a649
M2p_a676
M2p_a6b7
M2p_a760
M2p_a78f
M2p_a6ca
M2p_a6ce
M2p_a792
M2p_a6e0
M2p_a795
M2p_a6f3
M2p_a798
M2p_a704
M2p_a79b
M2p_a70d
M2p_a79e
M2p_a716
M2p_a7a1
M2p_a7a4
M2p_a773
M2p_a1e9
M2p_aff
M2p_a435
M2p_a502
M2p_a752
M2p_a671
    vmovdqu ymm3, [rdx + 288]
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
M2p_a72f
M2p_a774
M2p_a7a9
M2p_a6c7
M2p_a6cd
M2p_a791
M2p_a6df
M2p_a794
M2p_a6f2
M2p_a797
M2p_a703
M2p_a79a
M2p_a5a5
M2p_a70e
M2p_a79d
M2p_a5b3
M2p_a717
M2p_a7a0
M2p_a5c3
M2p_a7a5
M2p_af6
M2p_a1f1
M2p_a178
M2p_a573
M2p_a600
M2p_a733
M2p_a758
M2p_a19e
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 272]
M2p_a62c
    vmovdqu ymm3, [rdx + 288]
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
M2p_a74a
M2p_a783
M2p_a7ae
M2p_a6c7
M2p_a6cd
M2p_a791
M2p_a6df
M2p_a794
M2p_a6f2
M2p_a797
M2p_a703
M2p_a79a
M2p_a5a5
M2p_a70e
M2p_a79d
M2p_a5b3
M2p_a717
M2p_a7a0
M2p_a5c3
M2p_a7a5
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
M2p_a75c
M2p_a29b
M2p_a297
M2p_a2a5
M2p_a2a9
M2p_a2af
M2p_a2b5
M2p_a2c2
M2p_a2cf
M2p_a2de
M2p_a2e5
M2p_a2ee
M2p_a2f5
M2p_a306
M2p_a2f8
M2p_a30d
M2p_a311
M2p_a319
M2p_a2fc
M2p_a307
M2p_a313
M2p_a31f
M2p_a2bf
M2p_a321
M2p_a323
M2p_a327
M2p_a32d
M2p_a331
M2p_a336
M2p_a33a
M2p_a33e
M2p_a342
M2p_a346
M2p_a34b
M2p_a34f
M2p_a361
M2p_a36c
M2p_a358
M2p_a362
M2p_a373
M2p_a375
M2p_a35b
M2p_a37b
M2p_a37d
M2p_a2c3
M2p_a381
M2p_a2d2
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
