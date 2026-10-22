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
global xav_q2_0_15_13
align 64
xav_q2_0_15_13:
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
    vmovdqu ymm3, [rdx + 288]
M2p_a7ca
    vfmadd231ps ymm4, ymm0, [rcx + 416]
M2p_a873
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 408]
M2p_a8a0
    vfmadd231ps ymm4, ymm0, [rcx + 448]
M2p_a7cb
M2p_a7d4
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [rax + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 480]
M2p_a7d7
M2p_a7dd
    vpermps ymm1, ymm3, [rax + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2p_a7df
M2p_a7e8
    vpermps ymm1, ymm3, [rax + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2p_a7ea
M2p_a7f0
    vpermps ymm1, ymm3, [rax + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2p_a7f2
M2p_a7f9
    vpermps ymm1, ymm3, [rax + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2p_a7fc
M2p_a801
    vpermps ymm1, ymm3, [rax + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2p_a803
M2p_a80b
    vpermps ymm1, ymm3, [rax + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2p_a80d
M2p_a810
    vpermps ymm1, ymm3, [rax + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2p_a811
M2p_a816
    vpermps ymm1, ymm3, [rax + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2p_a817
M2p_a818
    vpermps ymm1, ymm3, [rax + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2p_a819
M2p_a81c
    vpermps ymm1, ymm3, [rax + 424]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2p_a81d
M2p_a81f
    vpermps ymm1, ymm3, [rax + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 832]
M2p_a820
M2p_a824
    vpermps ymm1, ymm3, [rax + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 864]
M2p_a826
M2p_a829
    vpermps ymm1, ymm3, [rax + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 896]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [rax + 56]
M2p_a6f7
M2p_a6f8
M2p_a6fb
    vpermps ymm1, ymm3, [rax + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a8b9
    vpermps ymm1, ymm3, [rax + 440]
M2p_a888
M2p_a5d8
M2p_a82a
M2p_a116
M2p_a43b
M2p_a5dc
M2p_a71f
M2p_a82f
M2p_a7a7
M2p_a5e4
M2p_a868
M2p_a14c
M2p_a442
M2p_a5e7
M2p_a725
M2p_a836
M2p_a54f
M2p_a5f0
M2p_a86a
M2p_a4de
M2p_a5f4
M2p_a72b
M2p_a83c
M2p_a660
M2p_a68e
M2p_a86c
M2p_a776
    vmovdqu ymm3, [rdx + 288]
M2p_a7aa
M2p_a841
M2p_a88d
M2p_a891
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 448]
M2p_a843
M2p_a7d4
M2p_a8a1
M2p_a7e2
M2p_a8a5
M2p_a7f6
M2p_a7f8
    vmovdqu ymm3, [rdx + 736]
M2p_a8a7
M2p_a807
M2p_a8ac
M2p_a6c0
M2p_a816
M2p_a8ae
M2p_a6d4
M2p_a81b
M2p_a8b2
M2p_a6e9
M2p_a824
M2p_a8b4
M2p_a6f9
M2p_a8b8
M2p_a88a
M2p_a44d
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
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r15 + 368]
M2p_a74b
M2p_a85f
M2p_a786
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r15 + 404]
M2p_a860
M2p_a896
M2p_a89a
M2p_a8bf
M2p_a861
M2p_a7d4
M2p_a8a1
M2p_a7e2
M2p_a8a5
M2p_a7f6
M2p_a7f8
M2p_a8bc
M2p_a806
M2p_a8ab
M2p_a6bf
M2p_a813
    vmovdqu ymm3, [rdx + 736]
M2p_a8ae
M2p_a6d4
M2p_a81b
M2p_a8b2
M2p_a6e9
M2p_a824
M2p_a8b4
M2p_a6f9
M2p_a8b8
M2p_a88a
M2p_a1e2
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
M2p_a89e
M2p_a7ce
M2p_a7d3
M2p_a8a2
M2p_a7e5
M2p_a7e8
M2p_a8a4
M2p_a7f5
M2p_a8a8
M2p_a809
M2p_a80b
M2p_a8aa
M2p_a6be
M2p_a812
M2p_a8af
M2p_a6d5
M2p_a81c
M2p_a8b1
M2p_a6e7
M2p_a821
M2p_a8b5
M2p_a6fa
M2p_a8ba
M2p_af6
M2p_a1ed
M2p_a102
    vmovdqu ymm3, [rdx + 224]
M2p_a5d8
M2p_a82a
M2p_a116
M2p_a43b
M2p_a5dc
M2p_a71f
M2p_a82f
M2p_a7a7
M2p_a5e4
M2p_a868
M2p_a14c
M2p_a442
M2p_a5e7
M2p_a725
M2p_a836
M2p_a54f
M2p_a5f0
M2p_a86a
M2p_a4de
M2p_a5f4
M2p_a72b
M2p_a83c
M2p_a660
M2p_a68e
M2p_a86c
M2p_a776
M2p_a8bb
M2p_a7ce
M2p_a7d3
M2p_a8a2
M2p_a7e5
M2p_a7e8
M2p_a8a4
M2p_a7f5
M2p_a8a8
M2p_a809
M2p_a80b
M2p_a8aa
M2p_a6be
M2p_a812
M2p_a8af
M2p_a6d5
M2p_a81c
M2p_a8b1
M2p_a6e7
M2p_a821
M2p_a8b5
M2p_a6fa
M2p_a8ba
M2p_af6
M2p_a1f1
M2p_a178
M2p_a573
M2p_a600
M2p_a734
M2p_a848
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
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 288]
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
M2p_a8be
M2p_a7da
M2p_a8a3
M2p_a7ee
M2p_a8a6
M2p_a800
M2p_a801
M2p_a8a9
M2p_a80f
M2p_a8ad
M2p_a6cb
M2p_a818
M2p_a8b0
M2p_a6df
M2p_a81e
M2p_a8b3
M2p_a6f3
M2p_a829
M2p_a8b6
    vmovdqu ymm3, [rdx + 672]
M2p_a8b8
M2p_a88a
M2p_a1f2
M2p_a1f9
M2p_a1fb
M2p_a203
M2p_a212
M2p_a21c
M2p_a226
M2p_a22b
M2p_a22f
M2p_a207
M2p_a20b
M2p_a20f
M2p_a232
M2p_a21a
M2p_a223
M2p_a233
M2p_a238
M2p_a23c
M2p_a23e
M2p_a45
M2p_a49
M2p_a240
M2p_a51
M2p_a41
M2p_a243
M2p_a248
M2p_a24c
M2p_a251
M2p_a256
M2p_a25e
M2p_a473
M2p_a26c
M2p_a277
M2p_a289
M2p_a1d
M2p_a26
M2p_a283
M2p_a286
M2p_a1c
M2p_a28d
M2p_a29e
M2p_a29a
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
M2p_a75d
M2p_a3ea