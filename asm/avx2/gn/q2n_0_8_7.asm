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
global xav_q2_0_8_7
align 64
xav_q2_0_8_7:
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
M2p_a6e
M2p_a72
M2p_a73
M2p_a78
M2p_aa4a
M2p_a97
M2p_a9d
    vpermps ymm1, ymm3, [r8 + 216]
M2p_aa1
M2p_aa6
    vpermps ymm1, ymm3, [r8 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm7
M2p_aa4d
M2p_ae9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 256]
M2p_aa4f
M2p_af0
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2p_aa51
M2p_aa52
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2p_aa54
M2p_aa56
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2p_aa57
M2p_aa58
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2p_aa5a
M2p_aa5b
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2p_aa5d
M2p_aa61
M2p_aa8e
    vpermps ymm1, ymm3, [rax + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [rax + 220]
M2p_aa7f
M2p_afb
M2p_a104
M2p_a107
M2p_a10c
M2p_a10d
M2p_a112
M2p_aa65
M2p_a13a
M2p_a148
    vpermps ymm1, ymm3, [r9 + 216]
M2p_a14d
M2p_a152
    vpermps ymm1, ymm3, [r9 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm7
M2p_aa69
M2p_ae9
M2p_aa88
M2p_aa8b
M2p_aa8f
M2p_aa92
M2p_a44d
M2p_a172
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r15 + 192]
M2p_a179
M2p_a17e
M2p_aa6a
M2p_a1a0
M2p_a1ad
M2p_aa6e
M2p_a1b7
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r15 + 216]
M2p_a1bd
M2p_a1c4
    vpermps ymm1, ymm3, [r15 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm7
M2p_aa6f
M2p_ae9
M2p_aa88
M2p_aa8b
M2p_aa8f
M2p_aa92
M2p_a1e2
M2p_a6b
M2p_a6e
M2p_a72
M2p_a73
M2p_a78
M2p_aa4a
M2p_a97
M2p_a9d
M2p_aa87
    vpermps ymm1, ymm3, [rax + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_aa89
M2p_aa5a
M2p_aa5b
M2p_aa8d
M2p_aa90
M2p_a1ed
M2p_a103
M2p_a106
M2p_a10b
M2p_aa71
M2p_a12c
M2p_a136
M2p_aa67
M2p_a147
    vmovdqu ymm3, [rdx + 160]
M2p_aa94
M2p_aa99
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_aa8c
M2p_af5
M2p_a1f0
M2p_a175
M2p_aa95
M2p_a196
M2p_a19d
M2p_aa6c
M2p_a1b6
M2p_a1ba
M2p_a1be
M2p_a1c5
M2p_aa98
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_aa8a
M2p_aa5d
M2p_aa61
M2p_aa8e
M2p_aa91
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
