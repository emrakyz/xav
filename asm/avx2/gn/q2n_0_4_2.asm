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
global xav_q2_0_4_2
align 64
xav_q2_0_4_2:
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
M2p_a56
M2p_a5a
M2p_a913
    vmovups ymm13, [rcx + 96]
    vmovups ymm6, [rcx + 128]
    vmovups ymm7, [rcx + 160]
    vmovups ymm3, [rcx + 192]
M2p_a5d
M2p_a5e
M2p_a5f
M2p_a92a
M2p_a94a
    vfmadd231ps ymm4, ymm0, ymm12
    vpermps ymm0, ymm8, [r8 + 12]
    vpermps ymm1, ymm8, [r8 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm13
M2p_a92f
    vmulps ymm5, ymm0, ymm6
    vpermps ymm0, ymm9, [rax + 4]
    vpermps ymm1, ymm9, [rax + 36]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm5, ymm0, ymm7
    vpermps ymm0, ymm9, [rax + 8]
    vpermps ymm1, ymm9, [rax + 40]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm5, ymm0, ymm3
    vpermps ymm0, ymm9, [rax + 12]
    vpermps ymm1, ymm9, [rax + 44]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm5, ymm0, [rcx + 224]
M2p_af5
M2p_a950
M2p_a959
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm12
    vpermps ymm0, ymm8, [r9 + 12]
    vpermps ymm1, ymm8, [r9 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm13
M2p_a934
M2p_a982
M2p_a954
M2p_a95a
    vpermps ymm1, ymm8, [r15 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm12
    vpermps ymm0, ymm8, [r15 + 12]
    vpermps ymm1, ymm8, [r15 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm13
M2p_a93b
M2p_a982
M2p_a1e4
M2p_a92c
M2p_a94c
M2p_a981
M2p_a985
M2p_a91f
M2p_a931
M2p_a958
    vpermps ymm1, ymm8, [r9 + 40]
M2p_a988
M2p_a983
M2p_af6
M2p_a940
M2p_a957
M2p_a989
M2p_a984
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
    xor edx, edx
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