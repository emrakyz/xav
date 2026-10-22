%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_5_3_pft: dq xav_g2_0_5_3.pf1, xav_g2_0_5_3.pf2, xav_g2_0_5_3.pf3, xav_g2_0_5_3.pf4, xav_g2_0_5_3.pf5, xav_g2_0_5_3.pf6, xav_g2_0_5_3.pf7, xav_g2_0_5_3.pf8, xav_g2_0_5_3.pf9, xav_g2_0_5_3.pf10, xav_g2_0_5_3.pf11, xav_g2_0_5_3.pf12, xav_g2_0_5_3.pf13, xav_g2_0_5_3.pf14, xav_g2_0_5_3.pf15, xav_g2_0_5_3.pf16, xav_g2_0_5_3.pf17, xav_g2_0_5_3.pf18, xav_g2_0_5_3.pf19, xav_g2_0_5_3.pf20, xav_g2_0_5_3.pf21, xav_g2_0_5_3.pf22, xav_g2_0_5_3.pf23, xav_g2_0_5_3.pf24, xav_g2_0_5_3.pf25, xav_g2_0_5_3.pf26, xav_g2_0_5_3.pf27, xav_g2_0_5_3.pf28, xav_g2_0_5_3.pf29, xav_g2_0_5_3.pf30, xav_g2_0_5_3.pf31, xav_g2_0_5_3.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_5_3
align 64
xav_g2_0_5_3:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_5_3_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a14
M2s_a15
M2s_a845
M2s_a85f
M2s_a84e
M2s_a861
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_a87b
    vpermps ymm1, ymm9, [r8 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm4, ymm0, [rcx + 128]
M2s_a84f
    vpermps ymm1, ymm11, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm11
    vmulps ymm5, ymm0, [rcx + 160]
M2s_a851
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm5, ymm0, [rcx + 192]
M2s_a852
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm5, ymm0, [rcx + 224]
M2s_a862
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2s_a87c
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2s_a82b
M2s_a855
M2s_a863
    vpermps ymm1, ymm9, [r9 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_a880
    vpermps ymm1, ymm9, [r9 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm6, ymm0, [rcx + 128]
M2s_a858
    vpermps ymm1, ymm11, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm11
    vmulps ymm7, ymm0, [rcx + 160]
M2s_a851
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm7, ymm0, [rcx + 192]
M2s_a852
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm7, ymm0, [rcx + 224]
M2s_a862
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm7, ymm0, [rcx + 256]
M2s_a87c
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm7, ymm0, [rcx + 288]
M2s_a13f
M2s_a149
M2s_a839
M2s_a84a
M2s_a861
M2s_a87a
M2s_a87f
M2s_a882
M2s_a142
M2s_a14e
M2s_a157
M2s_a15d
M2s_a16f
M2s_a181
M2s_a18e
M2s_a19b
M2s_a1b9
M2s_a1c8
M2s_a1d2
M2s_a1d8
M2s_a1e2
M2s_a1ec
M2s_a1f6
M2s_a164
M2s_a169
M2s_a1ff
M2s_a17d
M2s_a209
M2s_a191
M2s_a212
M2s_a1a7
M2s_a1b4
M2s_a454
M2s_a1a0
M2s_a4f0
M2s_a506
M2s_a53c
M2s_a5c5
M2s_a226
M2s_a22f
M2s_a237
M2s_a240
M2s_a248
M2s_a24f
M2s_a256
M2s_a260
M2s_a267
M2s_a275
M2s_a28a
M2s_a27f
M2s_a285
M2s_a295
M2s_a29c
M2s_a2ae
M2s_a45a
M2s_a2a8
M2s_a2b0
M2s_a2c7
M2s_a2be
M2s_a69c
M2s_a2cd
M2s_a2d2
M2s_a2c2
M2s_a45e
M2s_a2dc
M2s_a2e0
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