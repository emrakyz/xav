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
global xav_q2_0_15_14
align 64
xav_q2_0_15_14:
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
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 416]
M2p_a6c
M2p_a70
M2p_a3f0
M2p_a57a
M2p_a6a3
M2p_a7b8
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 420]
M2p_a73
M2p_a77
M2p_a3f1
M2p_a57b
M2p_a6a5
M2p_a7ba
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 424]
M2p_a7d
M2p_a84
M2p_a3f2
M2p_a57e
M2p_a6a6
M2p_a7bb
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 428]
M2p_a87
M2p_a8b
M2p_a3f5
M2p_a57f
M2p_a6a8
M2p_a7bd
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 432]
M2p_a8f
M2p_a96
M2p_a3f6
M2p_a582
M2p_a6a9
M2p_a7be
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 436]
M2p_a97
M2p_a9e
M2p_a3f8
M2p_a583
M2p_a6aa
M2p_a7c0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 440]
M2p_aa1
M2p_aa5
M2p_a3f9
M2p_a587
M2p_a6ad
M2p_a7c1
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 444]
M2p_aa7
M2p_aab
M2p_a3fa
M2p_a588
M2p_a6ae
M2p_a7c2
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 448]
M2p_aae
M2p_ab2
M2p_a3fb
M2p_a58d
M2p_a6b1
M2p_a7c4
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 452]
M2p_a47e
M2p_a480
M2p_a483
M2p_a58e
M2p_a6b3
M2p_a7c6
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 456]
M2p_a565
M2p_a533
M2p_a535
M2p_a593
M2p_a6b5
M2p_a7c7
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 460]
M2p_a675
M2p_a6b6
M2p_a7c8
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 464]
M2p_a78c
M2p_a7ca
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 468]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a89f
M2p_a878
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a8c9
M2p_a8cc
M2p_a8cf
M2p_a8d2
M2p_a8d5
    vpermps ymm1, ymm3, [rax + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [rax + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [rax + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [rax + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [rax + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [rax + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [rax + 444]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [rax + 32]
M2p_a7cd
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [rax + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [rax + 448]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [rax + 36]
M2p_a7d8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [rax + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [rax + 452]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [rax + 40]
M2p_a7e0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [rax + 424]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [rax + 456]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 800]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [rax + 44]
M2p_a7eb
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [rax + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [rax + 460]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 832]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [rax + 48]
M2p_a7f3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [rax + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [rax + 464]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 864]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [rax + 52]
M2p_a7fd
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [rax + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [rax + 468]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 896]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [rax + 56]
M2p_a804
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [rax + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [rax + 472]
M2p_a888
M2p_a5d8
M2p_a82b
    vpermps ymm1, ymm3, [r9 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 416]
M2p_a106
M2p_a10a
M2p_a43a
M2p_a5db
M2p_a71e
M2p_a82d
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 420]
M2p_a10d
M2p_a113
M2p_a43b
M2p_a5dc
M2p_a71f
M2p_a82e
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 424]
M2p_a117
M2p_a120
M2p_a43c
M2p_a5e0
M2p_a721
M2p_a831
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 428]
M2p_a124
M2p_a128
M2p_a440
M2p_a5e2
M2p_a723
M2p_a833
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 432]
M2p_a12c
M2p_a135
M2p_a441
M2p_a5e5
M2p_a724
M2p_a834
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 436]
M2p_a13a
M2p_a149
M2p_a442
M2p_a5e7
M2p_a725
M2p_a835
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 440]
M2p_a14d
M2p_a151
M2p_a446
M2p_a5ec
M2p_a727
M2p_a837
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 444]
M2p_a156
M2p_a15d
M2p_a447
M2p_a5ee
M2p_a729
M2p_a838
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 448]
M2p_a161
M2p_a167
M2p_a448
M2p_a5f1
M2p_a72a
M2p_a83a
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 452]
M2p_a4d8
M2p_a4db
M2p_a4e0
M2p_a5f4
M2p_a72b
M2p_a83b
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 456]
M2p_a570
M2p_a553
M2p_a556
M2p_a5f9
M2p_a72d
M2p_a83d
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 460]
M2p_a65a
M2p_a65d
M2p_a661
M2p_a68c
M2p_a72f
M2p_a840
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 464]
M2p_a774
M2p_a7aa
M2p_a841
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 468]
M2p_a88b
M2p_a890
M2p_a8eb
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 472]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 448]
    lea rax, [r9 + r14]
M2p_a8ca
M2p_a8cd
M2p_a8d0
M2p_a8d3
M2p_a8d6
M2p_a8d9
M2p_a7d9
M2p_a7dc
M2p_a7de
M2p_a8dc
M2p_a7ed
M2p_a7f1
M2p_a8de
M2p_a7ff
M2p_a802
M2p_a8e0
M2p_a80a
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [rax + 408]
M2p_a8e1
M2p_af5
M2p_a16b
M2p_a176
M2p_a450
M2p_a69c
M2p_a731
M2p_a847
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r15 + 416]
M2p_a179
M2p_a17d
M2p_a452
M2p_a603
M2p_a735
M2p_a849
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r15 + 420]
M2p_a180
M2p_a186
M2p_a454
M2p_a604
M2p_a737
M2p_a84b
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r15 + 424]
M2p_a18a
M2p_a193
M2p_a457
M2p_a607
M2p_a739
M2p_a84d
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r15 + 428]
M2p_a196
M2p_a19c
M2p_a458
M2p_a609
M2p_a73b
M2p_a84e
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r15 + 432]
M2p_a1a0
M2p_a1ac
M2p_a45b
M2p_a60c
M2p_a73d
M2p_a851
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r15 + 436]
M2p_a1b1
M2p_a1b9
M2p_a45c
M2p_a60e
M2p_a73f
M2p_a853
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r15 + 440]
M2p_a1bd
M2p_a1c3
M2p_a45f
M2p_a612
M2p_a741
M2p_a855
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r15 + 444]
M2p_a1c7
M2p_a1cd
M2p_a461
M2p_a614
M2p_a743
M2p_a857
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r15 + 448]
M2p_a1d3
M2p_a1d7
M2p_a462
M2p_a617
M2p_a744
M2p_a858
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r15 + 452]
M2p_a4ed
M2p_a4f2
M2p_a4f9
M2p_a619
M2p_a745
M2p_a859
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r15 + 456]
M2p_a61f
M2p_a748
M2p_a85c
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r15 + 460]
M2p_a664
M2p_a667
M2p_a66c
M2p_a74a
M2p_a85d
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r15 + 464]
M2p_a783
M2p_a7af
M2p_a860
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r15 + 468]
M2p_a894
M2p_a899
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r15 + 472]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 448]
    lea rax, [r15 + r14]
M2p_a8ca
M2p_a8cd
M2p_a8d0
M2p_a8d3
M2p_a8d6
M2p_a8d9
M2p_a7d9
M2p_a7dc
M2p_a7de
M2p_a8dc
M2p_a7ed
M2p_a7f1
M2p_a8de
M2p_a7ff
M2p_a802
M2p_a8e0
M2p_a80a
M2p_a8ec
M2p_a889
M2p_a1e0
M2p_a6a
M2p_a4fd
M2p_a788
M2p_a74e
    vmovdqu ymm3, [rdx + 352]
M2p_a8c2
M2p_a7a
    vmovdqu ymm3, [rdx + 192]
M2p_a862
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a8c3
M2p_a8e
M2p_a3f5
M2p_a57f
M2p_a6a8
M2p_a7bd
M2p_a8c4
M2p_aa0
M2p_a3f8
M2p_a583
M2p_a6aa
M2p_a7c0
M2p_a8c5
M2p_aad
M2p_a3fa
M2p_a588
M2p_a6ae
M2p_a7c2
M2p_a8c6
M2p_a481
M2p_a58e
M2p_a6b3
M2p_a7c6
M2p_a8c7
M2p_a646
M2p_a751
M2p_a7c8
M2p_a8c8
M2p_a875
M2p_a8a0
M2p_a8c9
M2p_a8cc
M2p_a8cf
M2p_a8d2
M2p_a8d5
M2p_a8d8
M2p_a8db
M2p_a7e6
M2p_a7e9
M2p_a8dd
M2p_a7f4
M2p_a7fa
M2p_a8df
M2p_a805
M2p_a80c
M2p_a8e2
M2p_af6
M2p_a1ed
M2p_a102
M2p_a8c0
M2p_a755
    vmovdqu ymm3, [rdx + 352]
M2p_a8e3
M2p_a115
M2p_a670
M2p_a5df
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 360]
M2p_a82e
M2p_a8e4
M2p_a12b
M2p_a440
M2p_a5e2
M2p_a723
M2p_a833
M2p_a8e5
M2p_a14c
M2p_a442
M2p_a5e7
M2p_a725
M2p_a835
M2p_a8e6
M2p_a160
M2p_a447
M2p_a5ee
M2p_a729
M2p_a838
M2p_a8e7
M2p_a4de
M2p_a5f4
M2p_a72b
M2p_a83b
M2p_a8e8
M2p_a65f
M2p_a68c
M2p_a72f
M2p_a840
M2p_a8e9
M2p_a88f
M2p_a8ea
M2p_a8cb
M2p_a8ce
M2p_a8d1
M2p_a8d4
M2p_a8d7
M2p_a8da
M2p_a7e3
M2p_a8dd
M2p_a7f4
M2p_a7fa
M2p_a8df
M2p_a805
M2p_a80c
M2p_a8e2
M2p_af6
M2p_a1f1
M2p_a178
M2p_a573
M2p_a600
M2p_a734
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a8ed
M2p_a188
M2p_a454
M2p_a604
M2p_a737
M2p_a84b
M2p_a8ee
M2p_a19f
M2p_a458
M2p_a609
M2p_a73b
M2p_a84e
M2p_a8ef
M2p_a1bb
M2p_a45c
M2p_a60e
M2p_a73f
M2p_a853
M2p_a8f0
M2p_a1d1
M2p_a461
M2p_a614
M2p_a743
M2p_a857
M2p_a8f1
M2p_a4f5
M2p_a619
M2p_a745
M2p_a859
M2p_a8f2
M2p_a669
M2p_a74a
M2p_a85d
M2p_a8f3
M2p_a898
M2p_a8f4
M2p_a8cb
M2p_a8ce
M2p_a8d1
M2p_a8d4
M2p_a8d7
M2p_a8da
M2p_a7e3
M2p_a8dd
M2p_a7f4
M2p_a7fa
M2p_a8df
M2p_a805
M2p_a80c
M2p_a8e2
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
