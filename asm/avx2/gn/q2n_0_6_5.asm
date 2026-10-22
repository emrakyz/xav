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
global xav_q2_0_6_5
align 64
xav_q2_0_6_5:
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
M2p_a62
M2p_a64
M2p_a9cd
M2p_a7e
M2p_a82
M2p_a9eb
    vpermps ymm1, ymm3, [r8 + 144]
M2p_a8f
    vfmadd231ps ymm4, ymm0, ymm13
M2p_a9cf
M2p_a9d1
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [rax + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, ymm6
M2p_a9d2
M2p_a9d3
    vpermps ymm1, ymm3, [rax + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, ymm7
M2p_a9d5
M2p_a9d6
    vpermps ymm1, ymm3, [rax + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2p_a9d7
M2p_a9d8
    vpermps ymm1, ymm3, [rax + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2p_a9d9
M2p_a9df
M2p_a9f8
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a9f1
M2p_af7
M2p_a106
M2p_a10e
M2p_a110
M2p_a9e2
M2p_a12c
    vfmadd231ps ymm4, ymm0, ymm13
M2p_a9e4
M2p_a9d1
M2p_a9f7
M2p_a9fa
M2p_af6
M2p_a16d
M2p_a16f
M2p_a9e5
M2p_a1a3
M2p_a1a9
    vpermps ymm1, ymm3, [r15 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm13
M2p_a9e9
M2p_a9d1
M2p_a9f7
M2p_a9fa
M2p_a1de
M2p_a6d
M2p_a6f
M2p_a9ea
M2p_a87
M2p_a90
M2p_a93
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a9f6
M2p_a9dc
M2p_a9e0
M2p_a9f9
M2p_af5
M2p_a1eb
M2p_a108
M2p_a109
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 132]
M2p_a10d
M2p_a119
M2p_a11f
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 140]
M2p_a124
M2p_a12d
M2p_a131
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a9ff
M2p_a9dc
M2p_a9e0
M2p_a9f9
M2p_af5
M2p_a1f0
M2p_a17a
M2p_a17c
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r15 + 132]
M2p_a180
M2p_a18b
M2p_a191
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r15 + 140]
M2p_a196
M2p_a1a1
M2p_a1a8
    vmovdqu ymm3, [rdx + 96]
M2p_aa00
M2p_a9d9
M2p_a9df
M2p_a9f8
M2p_a9fd
M2p_a62f
M2p_a1f8
M2p_a980
M2p_a202
M2p_a211
M2p_a21b
M2p_a225
M2p_a22a
M2p_a22e
M2p_a206
M2p_a20a
M2p_a20e
M2p_a472
M2p_a219
M2p_a222
M2p_a52e
M2p_a237
M2p_a23b
M2p_a23d
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
M2p_a69f
M2p_a2aa
M2p_a2b0
M2p_a2b8
M2p_a2c7
M2p_a2d6
M2p_a2e0
M2p_a2e9
M2p_a2ef
M2p_a2f9
M2p_a316
M2p_a300
M2p_a30e
M2p_a312
M2p_a31a
M2p_a2fd
M2p_a308
M2p_a314
M2p_a320
M2p_a98a
M2p_a2cc
M2p_a324
M2p_a328
M2p_a32e
M2p_a332
M2p_a337
M2p_a33b
M2p_a33f
M2p_a343
M2p_a347
M2p_a34c
M2p_a350
M2p_a363
M2p_a36e
M2p_a359
M2p_a370
M2p_a36d
M2p_a376
M2p_a35c
M2p_a378
M2p_a36d
M2p_a37e
M2p_a9c0
M2p_a2d0
M2p_a383
M2p_a388
M2p_a389
M2p_a38d
M2p_a392
M2p_a397
M2p_a39c
M2p_a3a1
M2p_a3aa
M2p_a3b1
M2p_a3b7
M2p_a3be
M2p_a3c5
M2p_a3cb
M2p_a3d1
M2p_a3d8
M2p_a3de
M2p_a3e4
M2p_a3e9
