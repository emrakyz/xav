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
global xav_q2_0_16_13
align 64
xav_q2_0_16_13:
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
M2p_a7b4
M2p_a7b
M2p_a3f1
M2p_a57b
M2p_a6a5
M2p_a7b9
M2p_a78b
M2p_a581
M2p_a863
M2p_aa0
M2p_a3f8
M2p_a583
M2p_a6aa
M2p_a7bf
M2p_a864
M2p_a47f
M2p_a483
M2p_a58e
M2p_a6b3
M2p_a7c5
M2p_a647
M2p_a676
M2p_a865
M2p_a761
M2p_a89d
M2p_a876
M2p_a877
M2p_a8a0
    vfmadd231ps ymm4, ymm0, [rcx + 448]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 60]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 444]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 480]
M2p_a7cb
M2p_a7d4
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [rax + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 512]
M2p_a7d7
M2p_a7dd
    vpermps ymm1, ymm3, [rax + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2p_a7df
M2p_a7e8
    vpermps ymm1, ymm3, [rax + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2p_a7ea
M2p_a7f0
    vpermps ymm1, ymm3, [rax + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2p_a7f2
M2p_a7f9
    vpermps ymm1, ymm3, [rax + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2p_a7fc
M2p_a801
    vpermps ymm1, ymm3, [rax + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2p_a803
M2p_a80b
    vpermps ymm1, ymm3, [rax + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2p_a80d
M2p_a810
    vpermps ymm1, ymm3, [rax + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2p_a811
M2p_a816
    vpermps ymm1, ymm3, [rax + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2p_a817
M2p_a818
    vpermps ymm1, ymm3, [rax + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2p_a819
M2p_a81c
    vpermps ymm1, ymm3, [rax + 424]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 832]
M2p_a81d
M2p_a81f
    vpermps ymm1, ymm3, [rax + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 864]
M2p_a820
M2p_a824
    vpermps ymm1, ymm3, [rax + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 896]
M2p_a826
M2p_a829
    vpermps ymm1, ymm3, [rax + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 928]
M2p_a8b7
M2p_a8b9
    vpermps ymm1, ymm3, [rax + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 960]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [rax + 60]
M2p_a701
M2p_a702
M2p_a705
M2p_a90b
    vfmadd231ps ymm5, ymm0, [rcx + 992]
M2p_af4
M2p_afc
M2p_a105
M2p_a437
M2p_a626
M2p_a753
M2p_a82c
M2p_a670
M2p_a5df
M2p_a8f5
M2p_a830
M2p_a440
M2p_a5e2
M2p_a723
M2p_a832
M2p_a508
M2p_a5ea
M2p_a869
M2p_a160
M2p_a447
M2p_a5ee
M2p_a729
M2p_a839
M2p_a4df
M2p_a5f7
M2p_a86b
M2p_a65f
M2p_a68c
M2p_a72f
M2p_a83f
M2p_a777
M2p_a7ab
M2p_a842
M2p_a88e
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 408]
M2p_a8eb
    vfmadd231ps ymm4, ymm0, [rcx + 448]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 60]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 444]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 480]
M2p_a843
M2p_a7d4
M2p_a8f7
M2p_a7e2
M2p_a8fb
M2p_a7f6
M2p_a7f8
    vmovdqu ymm3, [rdx + 736]
M2p_a8fd
M2p_a807
M2p_a901
M2p_a6c0
M2p_a816
M2p_a902
M2p_a6d4
M2p_a81b
M2p_a906
M2p_a6e9
M2p_a824
M2p_a907
M2p_a6f9
M2p_a8b8
M2p_a90a
M2p_a90c
M2p_af5
M2p_a16b
M2p_a176
M2p_a450
M2p_a69c
M2p_a731
M2p_a846
    vmovdqu ymm3, [rdx + 192]
M2p_a86d
M2p_a19a
M2p_a7b1
M2p_a73c
M2p_a850
M2p_a46e
M2p_a513
M2p_a893
M2p_a870
M2p_a1d2
M2p_a8c1
M2p_a4f0
M2p_a4fb
    vmovdqu ymm3, [rdx + 288]
M2p_a745
M2p_a85a
M2p_a66a
M2p_a695
M2p_a872
M2p_a785
    vmovdqu ymm3, [rdx + 288]
M2p_a7af
M2p_a860
M2p_a896
M2p_a89a
M2p_a8bf
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r15 + 60]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r15 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r15 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r15 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r15 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r15 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r15 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r15 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r15 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r15 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r15 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r15 + 444]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 480]
M2p_a861
M2p_a7d4
M2p_a8f7
M2p_a7e2
M2p_a8fb
M2p_a7f6
M2p_a7f8
M2p_a90f
M2p_a806
M2p_a900
M2p_a6bf
M2p_a813
    vmovdqu ymm3, [rdx + 736]
M2p_a902
M2p_a6d4
M2p_a81b
M2p_a906
M2p_a6e9
M2p_a824
M2p_a907
M2p_a6f9
M2p_a8b8
M2p_a90a
M2p_a90c
M2p_a1da
M2p_a66
M2p_a3ed
M2p_a478
M2p_a74d
M2p_a7b6
M2p_a7c
    vmovdqu ymm3, [rdx + 224]
M2p_a750
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 360]
M2p_a7b9
M2p_a78b
M2p_a581
M2p_a863
M2p_aa0
M2p_a3f8
M2p_a583
M2p_a6aa
M2p_a7bf
M2p_a864
M2p_a47f
M2p_a483
M2p_a58e
M2p_a6b3
M2p_a7c5
M2p_a647
M2p_a676
M2p_a865
M2p_a761
M2p_a89d
M2p_a876
M2p_a877
M2p_a8a0
M2p_a8f6
M2p_a7d1
M2p_a7d4
M2p_a8f7
M2p_a7e2
M2p_a8fb
M2p_a7f6
M2p_a7f8
M2p_a90f
M2p_a806
M2p_a900
M2p_a6bf
M2p_a813
M2p_a911
M2p_a6d3
M2p_a867
M2p_a905
M2p_a6e8
M2p_a822
    vmovdqu ymm3, [rdx + 736]
M2p_a907
M2p_a6f9
M2p_a8b8
M2p_a90a
M2p_a90c
M2p_af5
M2p_a1eb
M2p_a100
M2p_a437
M2p_a626
M2p_a753
M2p_a82c
M2p_a670
M2p_a5df
M2p_a8f5
M2p_a830
M2p_a440
M2p_a5e2
M2p_a723
M2p_a832
M2p_a508
M2p_a5ea
M2p_a869
M2p_a160
M2p_a447
M2p_a5ee
M2p_a729
M2p_a839
M2p_a4df
M2p_a5f7
M2p_a86b
M2p_a65f
M2p_a68c
M2p_a72f
M2p_a83f
M2p_a777
M2p_a7ab
M2p_a842
M2p_a88e
M2p_a90e
M2p_a7cf
M2p_a7d6
M2p_a8f9
M2p_a7e4
M2p_a7e7
    vmovdqu ymm3, [rdx + 736]
M2p_a8fa
M2p_a7f5
M2p_a8fe
M2p_a809
M2p_a80b
M2p_a8ff
M2p_a6be
M2p_a812
M2p_a903
M2p_a6d5
M2p_a81c
M2p_a904
M2p_a6e7
M2p_a821
M2p_a908
M2p_a6fa
M2p_a8b9
M2p_a909
    vmovdqu ymm3, [rdx + 672]
M2p_a90b
M2p_a90d
M2p_a1ef
M2p_a173
M2p_a50e
M2p_a7ad
M2p_a845
M2p_a189
M2p_a759
M2p_a738
M2p_a84c
M2p_a641
M2p_a62c
M2p_a7b2
M2p_a86f
M2p_a1bc
M2p_a781
M2p_a740
M2p_a854
M2p_a529
M2p_a55d
M2p_a89c
M2p_a871
M2p_a4f6
M2p_a61a
M2p_a747
M2p_a85b
M2p_a66b
M2p_a8bd
M2p_a897
M2p_a89a
M2p_a8bf
M2p_a910
M2p_a7d2
M2p_a7d5
M2p_a8f8
M2p_a7e3
M2p_a8fc
M2p_a7f7
M2p_a7f9
M2p_a8fd
M2p_a807
M2p_a901
M2p_a6c0
M2p_a816
M2p_a902
M2p_a6d4
M2p_a81b
M2p_a906
M2p_a6e9
M2p_a824
M2p_a907
M2p_a6f9
M2p_a8b8
M2p_a90a
M2p_a90c
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
M2p_a69d
M2p_a235
M2p_a239
    vpackusdw xmm9, xmm9, xmm4
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
