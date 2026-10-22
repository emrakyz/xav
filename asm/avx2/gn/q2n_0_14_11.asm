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
global xav_q2_0_14_11
align 64
xav_q2_0_14_11:
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
M2p_a676
M2p_a75f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 416]
M2p_a596
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 448]
M2p_a59e
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2p_a5a7
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2p_a5b0
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2p_a5b5
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2p_a5bf
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2p_a5c4
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2p_a5ca
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2p_a5cc
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2p_a5d0
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2p_a5d3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2p_a5d6
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2p_a684
    vfmadd231ps ymm5, ymm0, [rcx + 832]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [rax + 52]
M2p_a4b0
M2p_a4b3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [rax + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [rax + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 864]
M2p_af4
M2p_afc
M2p_a105
M2p_a437
M2p_a627
M2p_a756
M2p_a118
M2p_a122
M2p_a56d
M2p_a5e1
M2p_a54e
M2p_a5e6
M2p_a5ed
M2p_a50b
M2p_a5f2
M2p_a5fa
M2p_a65a
M2p_a65d
M2p_a661
M2p_a68c
    vpermps ymm1, ymm3, [r9 + 368]
M2p_a774
    vpermps ymm1, ymm3, [r9 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 416]
M2p_a5fc
M2p_a762
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [rax + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a764
    vpermps ymm1, ymm3, [rax + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a766
    vpermps ymm1, ymm3, [rax + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a768
    vpermps ymm1, ymm3, [rax + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a76a
    vpermps ymm1, ymm3, [rax + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a76c
    vpermps ymm1, ymm3, [rax + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a76e
M2p_a772
M2p_a527
M2p_a171
    vmovdqu ymm3, [rdx + 192]
M2p_a50e
M2p_a602
M2p_a605
M2p_a62d
    vmovdqu ymm3, [rdx + 224]
M2p_a62e
M2p_a461
M2p_a613
M2p_a4fa
M2p_a61c
    vpermps ymm1, ymm3, [r15 + 332]
M2p_a621
M2p_a665
M2p_a668
M2p_a66d
M2p_a693
M2p_a783
    vpermps ymm1, ymm3, [r15 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 416]
M2p_a622
M2p_a762
M2p_a778
M2p_a5bd
M2p_a77b
    vmovdqu ymm3, [rdx + 608]
M2p_a77c
M2p_a5cf
M2p_a76a
M2p_a77f
M2p_a686
M2p_a76e
M2p_a772
M2p_a1e0
M2p_a6a
M2p_a4fd
    vpermps ymm1, ymm3, [r8 + 288]
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
M2p_a676
M2p_a75e
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [rax + 320]
M2p_a762
M2p_a778
M2p_a5bd
M2p_a77b
M2p_a787
M2p_a5ce
M2p_a77e
    vmovdqu ymm3, [rdx + 608]
M2p_a77f
M2p_a686
M2p_a76e
M2p_a772
M2p_a56b
M2p_a629
M2p_a5dd
M2p_a68a
M2p_a442
M2p_a5e8
M2p_a69a
M2p_a4e0
M2p_a5f3
M2p_a558
M2p_a5fb
M2p_a65c
M2p_a65e
M2p_a662
M2p_a68e
M2p_a775
M2p_a789
M2p_a5ae
M2p_a779
    vmovdqu ymm3, [rdx + 608]
M2p_a77a
M2p_a5c9
M2p_a768
M2p_a77d
M2p_a5d5
M2p_a76c
M2p_a780
M2p_a76f
M2p_a1f0
M2p_a176
M2p_a450
M2p_a69b
M2p_a75a
M2p_a18c
M2p_a194
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 268]
M2p_a511
M2p_a608
M2p_a60d
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a611
    vpermps ymm1, ymm3, [r15 + 292]
M2p_a515
M2p_a618
M2p_a782
M2p_a784
M2p_a5a1
    vpermps ymm1, ymm3, [rax + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a763
    vpermps ymm1, ymm3, [rax + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a765
    vpermps ymm1, ymm3, [rax + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a767
    vpermps ymm1, ymm3, [rax + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a769
    vpermps ymm1, ymm3, [rax + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a76b
    vpermps ymm1, ymm3, [rax + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a76d
M2p_a770
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
