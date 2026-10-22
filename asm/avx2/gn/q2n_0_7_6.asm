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
global xav_q2_0_7_6
align 64
xav_q2_0_7_6:
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
M2p_a6c
M2p_aa03
M2p_a91
M2p_aa05
M2p_a98
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm6
M2p_aa07
    vpermps ymm1, ymm3, [rax + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, ymm7
M2p_aa0b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2p_aa0c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2p_aa0d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2p_aa14
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2p_aa16
M2p_aa3b
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [rax + 184]
M2p_aa32
M2p_afb
M2p_a106
M2p_aa1e
M2p_a130
M2p_aa22
M2p_a13d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm6
M2p_aa23
M2p_aa38
M2p_aa15
    vpermps ymm1, ymm3, [rax + 176]
M2p_aa3a
M2p_aa40
M2p_a527
M2p_a170
M2p_a179
M2p_aa25
M2p_a1a5
M2p_aa28
M2p_a1b3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm6
M2p_aa2a
M2p_aa38
M2p_aa15
M2p_aa44
M2p_aa3d
M2p_a1de
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 160]
M2p_a6c
M2p_aa03
M2p_a91
M2p_aa05
M2p_a98
M2p_aa37
M2p_aa11
    vpermps ymm1, ymm3, [rax + 172]
M2p_aa39
M2p_aa1c
M2p_aa3b
M2p_aa42
M2p_a1eb
M2p_aa2b
M2p_a126
M2p_aa20
M2p_a134
M2p_a13a
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 184]
M2p_aa43
M2p_aa11
M2p_aa46
M2p_aa1b
    vpermps ymm1, ymm3, [rax + 180]
M2p_aa3b
M2p_aa42
M2p_a1f0
M2p_aa24
M2p_a199
M2p_aa27
M2p_a1ab
M2p_a1b1
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r15 + 184]
M2p_aa45
M2p_aa11
M2p_aa46
M2p_aa1b
M2p_aa48
M2p_aa41
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