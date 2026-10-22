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
global xav_q2_0_14_13
align 64
xav_q2_0_14_13:
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
M2p_a7b5
    vpermps ymm1, ymm3, [r8 + 384]
M2p_a6c
M2p_a70
M2p_a3f0
M2p_a57a
M2p_a6a3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 388]
M2p_a73
M2p_a77
M2p_a3f1
M2p_a57b
M2p_a6a5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 392]
M2p_a7d
M2p_a84
M2p_a3f2
M2p_a57e
M2p_a6a6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 396]
M2p_a87
M2p_a8b
M2p_a3f5
M2p_a57f
M2p_a6a8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 400]
M2p_a8f
M2p_a96
M2p_a3f6
M2p_a582
M2p_a6a9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 404]
M2p_a97
M2p_a9e
M2p_a3f8
M2p_a583
M2p_a6aa
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 408]
M2p_aa1
M2p_aa5
M2p_a3f9
M2p_a587
M2p_a6ad
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 412]
M2p_aa7
M2p_aab
M2p_a3fa
M2p_a588
M2p_a6ae
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 416]
M2p_aae
M2p_ab2
M2p_a3fb
M2p_a58d
M2p_a6b1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 420]
M2p_a47e
M2p_a480
M2p_a483
M2p_a58e
M2p_a6b3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 424]
M2p_a565
M2p_a533
M2p_a535
M2p_a593
M2p_a6b5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 428]
M2p_a675
M2p_a6b6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 432]
M2p_a78c
    vpermps ymm1, ymm3, [r8 + 372]
M2p_a78d
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 416]
M2p_a7cb
M2p_a7d4
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [rax + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 448]
M2p_a7d7
M2p_a7dd
    vpermps ymm1, ymm3, [rax + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2p_a7df
M2p_a7e8
    vpermps ymm1, ymm3, [rax + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2p_a7ea
M2p_a7f0
    vpermps ymm1, ymm3, [rax + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2p_a7f2
M2p_a7f9
M2p_a7fb
M2p_a807
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2p_a80d
M2p_a810
    vpermps ymm1, ymm3, [rax + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [rax + 32]
M2p_a6bb
M2p_a6bd
M2p_a6c1
M2p_a812
    vfmadd231ps ymm5, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [rax + 36]
M2p_a6c5
M2p_a6c7
M2p_a6cd
    vpermps ymm1, ymm3, [rax + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a818
    vpermps ymm1, ymm3, [rax + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [rax + 40]
M2p_a6d0
M2p_a6d2
M2p_a6d7
M2p_a81b
    vfmadd231ps ymm5, ymm0, [rcx + 768]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [rax + 44]
M2p_a6d9
M2p_a6de
M2p_a6e1
M2p_a81e
    vfmadd231ps ymm5, ymm0, [rcx + 800]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [rax + 48]
M2p_a6e3
M2p_a6e6
M2p_a6ea
M2p_a821
    vfmadd231ps ymm5, ymm0, [rcx + 832]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [rax + 52]
M2p_a6ed
M2p_a6f1
M2p_a6f5
    vpermps ymm1, ymm3, [rax + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a829
    vpermps ymm1, ymm3, [rax + 436]
M2p_a771
M2p_a5d8
M2p_a82b
    vpermps ymm1, ymm3, [r9 + 384]
M2p_a106
M2p_a10a
M2p_a43a
M2p_a5db
M2p_a71e
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 388]
M2p_a10d
M2p_a113
M2p_a43b
M2p_a5dc
M2p_a71f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 392]
M2p_a117
M2p_a120
M2p_a43c
M2p_a5e0
M2p_a721
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 396]
M2p_a124
M2p_a128
M2p_a440
M2p_a5e2
M2p_a723
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 400]
M2p_a12c
M2p_a135
M2p_a441
M2p_a5e5
M2p_a724
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 404]
M2p_a13a
M2p_a149
M2p_a442
M2p_a5e7
M2p_a725
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 408]
M2p_a14d
M2p_a151
M2p_a446
M2p_a5ec
M2p_a727
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 412]
M2p_a156
M2p_a15d
M2p_a447
M2p_a5ee
M2p_a729
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 416]
M2p_a161
M2p_a167
M2p_a448
M2p_a5f1
M2p_a72a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 420]
M2p_a4d8
M2p_a4db
M2p_a4e0
M2p_a5f4
M2p_a72b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 424]
M2p_a570
M2p_a553
M2p_a556
M2p_a5f9
M2p_a72d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 428]
M2p_a65a
M2p_a65d
M2p_a661
M2p_a68c
M2p_a72f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 432]
M2p_a774
M2p_a7aa
M2p_a841
    vfmadd231ps ymm4, ymm0, [rcx + 416]
    lea rax, [r9 + r14]
M2p_a7cc
M2p_a7db
M2p_a7ec
M2p_a7fb
M2p_a808
M2p_a6bc
M2p_a6c0
M2p_a815
M2p_a6d2
M2p_a6d7
M2p_a81a
M2p_a6e5
M2p_a825
M2p_a6f4
    vmovdqu ymm3, [rdx + 672]
M2p_a827
M2p_a773
M2p_a44d
M2p_a173
M2p_a50e
M2p_a7ad
    vpermps ymm1, ymm3, [r15 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 384]
M2p_a179
M2p_a17d
M2p_a452
M2p_a603
M2p_a735
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 388]
M2p_a180
M2p_a186
M2p_a454
M2p_a604
M2p_a737
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 392]
M2p_a18a
M2p_a193
M2p_a457
M2p_a607
M2p_a739
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 396]
M2p_a196
M2p_a19c
M2p_a458
M2p_a609
M2p_a73b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 400]
M2p_a1a0
M2p_a1ac
M2p_a45b
M2p_a60c
M2p_a73d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 404]
M2p_a1b1
M2p_a1b9
M2p_a45c
M2p_a60e
M2p_a73f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 408]
M2p_a1bd
M2p_a1c3
M2p_a45f
M2p_a612
M2p_a741
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 412]
M2p_a1c7
M2p_a1cd
M2p_a461
M2p_a614
M2p_a743
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 416]
M2p_a1d3
M2p_a1d7
M2p_a462
M2p_a617
M2p_a744
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 420]
M2p_a4ed
M2p_a4f2
M2p_a4f9
M2p_a619
M2p_a745
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 424]
M2p_a61f
M2p_a748
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 428]
M2p_a664
M2p_a667
M2p_a66c
M2p_a74a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 432]
M2p_a783
M2p_a7af
M2p_a860
    vfmadd231ps ymm4, ymm0, [rcx + 416]
    lea rax, [r15 + r14]
M2p_a7cc
M2p_a7db
M2p_a7ec
M2p_a7fb
M2p_a808
M2p_a6bc
M2p_a6c0
M2p_a815
M2p_a6d2
M2p_a6d7
M2p_a81a
M2p_a6e5
M2p_a825
M2p_a6f4
M2p_a844
M2p_a772
M2p_a1e0
M2p_a6a
M2p_a4fd
M2p_a788
M2p_a74e
M2p_a7b7
    vpermps ymm1, ymm3, [r8 + 232]
M2p_a3f1
M2p_a57b
M2p_a6a5
M2p_a7b9
M2p_a78b
M2p_a581
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 368]
M2p_a7bc
M2p_a4ff
M2p_a585
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 376]
M2p_a7bf
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 256]
M2p_a3fa
M2p_a588
M2p_a6ae
M2p_a7c3
M2p_a482
M2p_a591
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 392]
M2p_a7c5
M2p_a647
M2p_a676
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 400]
M2p_a7c9
M2p_a7d0
M2p_a7e1
M2p_a7ef
M2p_a7fe
M2p_a80e
M2p_a6c2
M2p_a814
M2p_a6d1
M2p_a6d6
    vmovdqu ymm3, [rdx + 672]
M2p_a81a
M2p_a6e5
M2p_a825
M2p_a6f4
M2p_a844
M2p_a772
M2p_a56b
M2p_a628
M2p_a82a
M2p_a116
M2p_a43b
M2p_a5dc
M2p_a71f
M2p_a82f
M2p_a7a7
M2p_a5e4
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 368]
M2p_a832
M2p_a508
M2p_a5ea
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 376]
M2p_a836
M2p_a54f
M2p_a5f0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 384]
M2p_a839
M2p_a4df
M2p_a5f7
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 392]
M2p_a83c
M2p_a660
M2p_a68e
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 400]
M2p_a83e
M2p_a7d0
M2p_a7e1
M2p_a7ef
M2p_a7fe
M2p_a80e
M2p_a6c2
M2p_a814
M2p_a6d1
M2p_a6d6
M2p_a866
M2p_a6e4
M2p_a823
M2p_a6f3
M2p_a828
M2p_af6
M2p_a1f1
M2p_a178
M2p_a573
M2p_a600
M2p_a734
M2p_a848
    vpermps ymm1, ymm3, [r15 + 232]
M2p_a454
M2p_a604
M2p_a737
M2p_a84a
    vmovdqu ymm3, [rdx + 192]
M2p_a641
M2p_a62c
M2p_a7b2
    vpermps ymm1, ymm3, [r15 + 368]
M2p_a84f
M2p_a512
M2p_a60f
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r15 + 376]
M2p_a852
M2p_a55b
M2p_a616
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r15 + 384]
M2p_a856
M2p_a4f7
M2p_a61b
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r15 + 392]
M2p_a85a
M2p_a66a
M2p_a695
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r15 + 400]
M2p_a85e
M2p_a7d0
M2p_a7e1
M2p_a7ef
M2p_a7fe
M2p_a80e
M2p_a6c2
M2p_a814
M2p_a6d1
M2p_a6d6
M2p_a866
M2p_a6e4
M2p_a823
M2p_a6f3
M2p_a828
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
