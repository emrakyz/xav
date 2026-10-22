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
global xav_q2_0_5_3
align 64
xav_q2_0_5_3:
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
M2p_a914
M2p_a95f
M2p_a5f
M2p_a92b
M2p_a960
M2p_a963
M2p_a98b
    vfmadd231ps ymm4, ymm0, ymm7
M2p_a9b3
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm4, ymm0, ymm3
M2p_a965
    vpermps ymm1, ymm11, [rax + 64]
    vblendvps ymm0, ymm0, ymm1, ymm11
    vmulps ymm5, ymm0, [rcx + 160]
M2p_a967
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm5, ymm0, [rcx + 192]
M2p_a968
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm5, ymm0, [rcx + 224]
M2p_a98f
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm5, ymm0, [rcx + 256]
    vpermps ymm0, ymm10, [rax + 16]
    vpermps ymm1, ymm10, [rax + 48]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vpermps ymm1, ymm11, [rax + 80]
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2p_af5
M2p_a951
M2p_a96b
M2p_a994
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm4, ymm0, ymm7
M2p_a9bc
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm4, ymm0, ymm3
M2p_a96f
M2p_a9b4
M2p_a937
M2p_a973
M2p_a976
    vpermps ymm1, ymm9, [r15 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm9
M2p_a995
    vpermps ymm1, ymm9, [r15 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm4, ymm0, ymm7
M2p_a9be
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm4, ymm0, ymm3
M2p_a978
M2p_a9b5
M2p_a991
M2p_a9b7
M2p_a1dd
    add r15, rbx
M2p_a979
M2p_a98b
M2p_a9b2
M2p_a9b8
M2p_a56c
M2p_a97d
    vblendvps ymm0, ymm0, ymm1, ymm9
M2p_a993
    vpermps ymm1, ymm9, [r9 + 76]
M2p_a9bb
M2p_a9b7
M2p_af6
M2p_a941
M2p_a973
M2p_a976
M2p_a9bd
M2p_a9b6
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
    mov rcx, rax
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