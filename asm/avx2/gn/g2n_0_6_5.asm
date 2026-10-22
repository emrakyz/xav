%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_6_5_pft: dq xav_g2_0_6_5.pf1, xav_g2_0_6_5.pf2, xav_g2_0_6_5.pf3, xav_g2_0_6_5.pf4, xav_g2_0_6_5.pf5, xav_g2_0_6_5.pf6, xav_g2_0_6_5.pf7, xav_g2_0_6_5.pf8, xav_g2_0_6_5.pf9, xav_g2_0_6_5.pf10, xav_g2_0_6_5.pf11, xav_g2_0_6_5.pf12, xav_g2_0_6_5.pf13, xav_g2_0_6_5.pf14, xav_g2_0_6_5.pf15, xav_g2_0_6_5.pf16, xav_g2_0_6_5.pf17, xav_g2_0_6_5.pf18, xav_g2_0_6_5.pf19, xav_g2_0_6_5.pf20, xav_g2_0_6_5.pf21, xav_g2_0_6_5.pf22, xav_g2_0_6_5.pf23, xav_g2_0_6_5.pf24, xav_g2_0_6_5.pf25, xav_g2_0_6_5.pf26, xav_g2_0_6_5.pf27, xav_g2_0_6_5.pf28, xav_g2_0_6_5.pf29, xav_g2_0_6_5.pf30, xav_g2_0_6_5.pf31, xav_g2_0_6_5.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_6_5
align 64
xav_g2_0_6_5:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_6_5_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a1a
M2s_a24
M2s_a88d
M2s_a53
M2s_a57
    vpermps ymm1, ymm3, [r8 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm13
M2s_a890
M2s_a892
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 192]
M2s_a894
M2s_a895
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 224]
M2s_a897
M2s_a898
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2s_a899
M2s_a89a
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2s_a89b
M2s_a89d
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_a8af
M2s_a8b0
    vpermps ymm1, ymm3, [r13 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a8a7
M2s_ac0
M2s_ac3
M2s_a89f
M2s_ae4
M2s_ae9
M2s_a8a3
    vpermps ymm1, ymm3, [r9 + 144]
M2s_afc
    vfmadd231ps ymm6, ymm0, ymm13
M2s_a8a2
M2s_a892
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 192]
M2s_a894
M2s_a895
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 224]
M2s_a897
M2s_a898
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 256]
M2s_a899
M2s_a89a
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 288]
M2s_a89b
M2s_a89d
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_a8af
M2s_a8b0
    vpermps ymm1, ymm3, [r13 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a8ac
M2s_a148
M2s_a20
M2s_a2b
M2s_a32
M2s_a34
M2s_a88f
M2s_a50
M2s_a8ad
M2s_a89c
M2s_a89e
M2s_a8ae
M2s_ae5
M2s_aea
M2s_a8a4
M2s_afc
M2s_a8b2
M2s_a89c
M2s_a89e
M2s_a8b3
M2s_a141
M2s_a14d
M2s_a156
M2s_a15c
M2s_a16e
M2s_a180
M2s_a18c
M2s_a19a
M2s_a1b8
M2s_a453
M2s_a1d1
M2s_a4ef
M2s_a1e1
M2s_a1eb
M2s_a1f5
M2s_a163
M2s_a168
M2s_a1fd
M2s_a17c
M2s_a208
M2s_a190
M2s_a210
M2s_a1a5
M2s_a1b2
M2s_a53b
M2s_a19f
M2s_a6c1
M2s_a85a
M2s_a879
M2s_a85b
M2s_a221
M2s_a229
M2s_a53e
M2s_a238
M2s_a241
M2s_a249
M2s_a250
M2s_a257
M2s_a261
M2s_a269
M2s_a276
M2s_a28b
M2s_a280
M2s_a294
M2s_a29b
M2s_a2ad
M2s_a459
M2s_a2a7
M2s_a2af
M2s_a2c6
M2s_a2bd
M2s_a2c9
M2s_a2d0
M2s_a2d5
M2s_a45d
M2s_a2db
M2s_a2df
    mov r8, [rbp + 336]
M2s_a6c2
M2s_a286
M2s_a2e5
M2s_a2e8
M2s_a80c
M2s_a2ef
M2s_a2ba
M2s_a2f7
M2s_a300
M2s_a2fa
M2s_a5c7
M2s_a306
M2s_a313
M2s_a318
M2s_a321
M2s_a461
M2s_a32e
M2s_a332
M2s_a30e
M2s_a322
M2s_a336
M2s_a339
M2s_a342
M2s_a34c
M2s_a357
M2s_a312
M2s_a326
M2s_a35b
M2s_a4f3
M2s_a363
M2s_a369
M2s_a36c
M2s_a346
M2s_a825
M2s_a351
M2s_a370
M2s_a376
M2s_a381
M2s_a388
M2s_a37a
M2s_a37d
M2s_a384
M2s_a38c
M2s_a390
M2s_a394
M2s_a398
M2s_a39c
M2s_a3a0
M2s_a3a9
M2s_a3ba
M2s_a3a5
M2s_a3ae
M2s_a3c4
M2s_a3bf
M2s_a3ca
M2s_a3b2
M2s_a3cc
M2s_a3bf
M2s_a3d2
M2s_a3d6
M2s_a3da
M2s_a3de
M2s_a3e2
M2s_a3e6
M2s_a3ec
M2s_a3ee