%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_5_5_pft: dq xav_g2_0_5_5.pf1, xav_g2_0_5_5.pf2, xav_g2_0_5_5.pf3, xav_g2_0_5_5.pf4, xav_g2_0_5_5.pf5, xav_g2_0_5_5.pf6, xav_g2_0_5_5.pf7, xav_g2_0_5_5.pf8, xav_g2_0_5_5.pf9, xav_g2_0_5_5.pf10, xav_g2_0_5_5.pf11, xav_g2_0_5_5.pf12, xav_g2_0_5_5.pf13, xav_g2_0_5_5.pf14, xav_g2_0_5_5.pf15, xav_g2_0_5_5.pf16, xav_g2_0_5_5.pf17, xav_g2_0_5_5.pf18, xav_g2_0_5_5.pf19, xav_g2_0_5_5.pf20, xav_g2_0_5_5.pf21, xav_g2_0_5_5.pf22, xav_g2_0_5_5.pf23, xav_g2_0_5_5.pf24, xav_g2_0_5_5.pf25, xav_g2_0_5_5.pf26, xav_g2_0_5_5.pf27, xav_g2_0_5_5.pf28, xav_g2_0_5_5.pf29, xav_g2_0_5_5.pf30, xav_g2_0_5_5.pf31, xav_g2_0_5_5.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_5_5
align 64
xav_g2_0_5_5:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_5_5_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a1a
M2s_a24
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 128]
M2s_a2b
M2s_a32
M2s_a34
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 136]
M2s_a3b
M2s_a46
M2s_a49
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm12
M2s_a890
M2s_a892
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, ymm13
M2s_a894
M2s_a895
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 192]
M2s_a897
M2s_a898
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 224]
M2s_a899
M2s_a89a
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2s_a89b
M2s_a89d
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a87e
M2s_ac0
M2s_ac3
    vpermps ymm1, ymm3, [r9 + 128]
M2s_acd
M2s_ad9
M2s_adc
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 136]
M2s_ae2
M2s_af0
M2s_af5
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, ymm12
    lea r13, [r9 + r14]
M2s_a891
M2s_a893
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, ymm13
M2s_a894
M2s_a895
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 192]
M2s_a897
M2s_a898
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 224]
M2s_a899
M2s_a89a
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 256]
M2s_a89b
M2s_a89d
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a883
M2s_a148
M2s_a20
M2s_a2b
M2s_a32
M2s_a34
M2s_a88e
M2s_a896
M2s_acf
M2s_ad1
    vpermps ymm1, ymm3, [r9 + 132]
M2s_ad8
M2s_ae4
M2s_ae9
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 140]
M2s_aef
M2s_a8a1
M2s_a89c
M2s_a89e
M2s_a885
M2s_a14c
M2s_a155
M2s_a15b
M2s_a16d
M2s_a451
M2s_a18b
M2s_a199
M2s_a1b7
M2s_a4ee
M2s_a1d0
M2s_a6c0
M2s_a1e0
M2s_a1e9
M2s_a1f4
M2s_a162
M2s_a167
M2s_a200
M2s_a17e
M2s_a20b
M2s_a192
M2s_a213
M2s_a1a8
M2s_a1b6
M2s_a218
M2s_a1a2
M2s_a1cb
M2s_a1ce
M2s_a1cf
M2s_a21b
M2s_a1a2
M2s_a1db
M2s_a1de
M2s_a1df
M2s_a21f
M2s_a224
M2s_a22d
M2s_a236
M2s_a23c
M2s_a458
M2s_a245
M2s_a24d
M2s_a254
M2s_a25e
M2s_a265
M2s_a272
M2s_a288
M2s_a27d
M2s_a283
M2s_a292
M2s_a29a
M2s_a2ab
M2s_a29f
M2s_a2b8
M2s_a2ac
M2s_a2b2
M2s_a45c
M2s_a2bc
M2s_a2c8
M2s_a2cf
M2s_a2d4
M2s_a2c4
M2s_a2da
M2s_a2de
M2s_a2e2
M2s_a271
M2s_a277
M2s_a2e4
M2s_a28d
M2s_a291
M2s_a2e7
M2s_a2ea
M2s_a2a1
M2s_a2a3
M2s_a2ec
M2s_a2f4
M2s_a2fe
M2s_a460
M2s_a304
M2s_a4f2
M2s_a31b
M2s_a31f
M2s_a327
M2s_a32a
M2s_a330
M2s_a334
M2s_a310
M2s_a324
M2s_a338
M2s_a33b
M2s_a344
M2s_a34f
M2s_a359
M2s_a317
M2s_a328
M2s_a35d
M2s_a361
M2s_a365
M2s_a368
M2s_a36b
M2s_a36e
M2s_a348
M2s_a463
M2s_a353
M2s_a4f5
M2s_a374
M2s_a37f
M2s_a386
M2s_a378
M2s_a38e
M2s_a392
M2s_a396
M2s_a39a
M2s_a39e
M2s_a3a2
M2s_a3ab
M2s_a3bc
M2s_a3a7
M2s_a3b0
M2s_a3c6
M2s_a3c8
M2s_a3b0
M2s_a3ce
M2s_a3d0
M2s_a3d4
M2s_a3d8
M2s_a3dc
M2s_a3e0
M2s_a3e4
M2s_a3ea
section .note.GNU-stack noalloc noexec nowrite progbits
