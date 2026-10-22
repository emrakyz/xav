%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_4_4_pft: dq xav_g2_0_4_4.pf1, xav_g2_0_4_4.pf2, xav_g2_0_4_4.pf3, xav_g2_0_4_4.pf4, xav_g2_0_4_4.pf5, xav_g2_0_4_4.pf6, xav_g2_0_4_4.pf7, xav_g2_0_4_4.pf8, xav_g2_0_4_4.pf9, xav_g2_0_4_4.pf10, xav_g2_0_4_4.pf11, xav_g2_0_4_4.pf12, xav_g2_0_4_4.pf13, xav_g2_0_4_4.pf14, xav_g2_0_4_4.pf15, xav_g2_0_4_4.pf16, xav_g2_0_4_4.pf17, xav_g2_0_4_4.pf18, xav_g2_0_4_4.pf19, xav_g2_0_4_4.pf20, xav_g2_0_4_4.pf21, xav_g2_0_4_4.pf22, xav_g2_0_4_4.pf23, xav_g2_0_4_4.pf24, xav_g2_0_4_4.pf25, xav_g2_0_4_4.pf26, xav_g2_0_4_4.pf27, xav_g2_0_4_4.pf28, xav_g2_0_4_4.pf29, xav_g2_0_4_4.pf30, xav_g2_0_4_4.pf31, xav_g2_0_4_4.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_4_4
align 64
xav_g2_0_4_4:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_4_4_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a14
M2s_a15
M2s_a846
    vmovdqu ymm12, [rdx + 128]
    vmovdqu ymm13, [rdx + 160]
    vmovups ymm3, [rcx + 0]
M2s_a16
M2s_a17
M2s_a828
M2s_a849
    vpermps ymm1, ymm10, [r8 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm10
M2s_a832
    vpermps ymm1, ymm9, [r8 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r8 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 32]
M2s_a84d
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r8 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 64]
M2s_a861
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r8 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 96]
M2s_a86b
    vmulps ymm5, ymm0, [rcx + 128]
M2s_a86d
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 160]
M2s_a86e
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 192]
M2s_a86f
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm13
M2s_a85d
M2s_a854
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm10
M2s_a835
    vpermps ymm1, ymm9, [r9 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r9 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm6, ymm0, [rcx + 32]
M2s_a857
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r9 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm6, ymm0, [rcx + 64]
M2s_a864
M2s_a877
    lea r13, [r9 + r14]
M2s_a86c
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vmulps ymm7, ymm0, [rcx + 128]
M2s_a86d
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm7, ymm0, [rcx + 160]
M2s_a86e
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm7, ymm0, [rcx + 192]
M2s_a86f
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm13
M2s_a85e
M2s_a147
M2s_a838
M2s_a849
M2s_a869
M2s_a856
M2s_a872
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
    vpermps ymm10, ymm9, [c_w8o]
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