%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_6_6_pft: dq xav_g2_0_6_6.pf1, xav_g2_0_6_6.pf2, xav_g2_0_6_6.pf3, xav_g2_0_6_6.pf4, xav_g2_0_6_6.pf5, xav_g2_0_6_6.pf6, xav_g2_0_6_6.pf7, xav_g2_0_6_6.pf8, xav_g2_0_6_6.pf9, xav_g2_0_6_6.pf10, xav_g2_0_6_6.pf11, xav_g2_0_6_6.pf12, xav_g2_0_6_6.pf13, xav_g2_0_6_6.pf14, xav_g2_0_6_6.pf15, xav_g2_0_6_6.pf16, xav_g2_0_6_6.pf17, xav_g2_0_6_6.pf18, xav_g2_0_6_6.pf19, xav_g2_0_6_6.pf20, xav_g2_0_6_6.pf21, xav_g2_0_6_6.pf22, xav_g2_0_6_6.pf23, xav_g2_0_6_6.pf24, xav_g2_0_6_6.pf25, xav_g2_0_6_6.pf26, xav_g2_0_6_6.pf27, xav_g2_0_6_6.pf28, xav_g2_0_6_6.pf29, xav_g2_0_6_6.pf30, xav_g2_0_6_6.pf31, xav_g2_0_6_6.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_6_6
align 64
xav_g2_0_6_6:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_6_6_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a1a
M2s_a23
    vpermps ymm1, ymm3, [r8 + 160]
M2s_a2b
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 164]
M2s_a31
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 168]
M2s_a3b
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 172]
M2s_a45
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 176]
M2s_a50
M2s_a8b9
M2s_a8c3
M2s_a8c6
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2s_a8c7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_a8c8
M2s_a8b1
M2s_ac6
    vpermps ymm1, ymm3, [r9 + 160]
M2s_acd
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 164]
M2s_ad8
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 168]
M2s_ae2
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 172]
M2s_aef
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 176]
M2s_afc
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, ymm13
    lea r13, [r9 + r14]
M2s_a8bb
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 192]
M2s_a8be
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 224]
M2s_a8bf
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 256]
M2s_a8c1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 288]
M2s_a8c7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_a8c8
M2s_a8b4
M2s_a1e
M2s_a26
M2s_a2b
M2s_a8b6
M2s_a55
M2s_a8b9
M2s_a8c2
M2s_ac8
M2s_acd
M2s_a8cc
M2s_a101
M2s_a8d0
M2s_a8c3
M2s_a8c6
M2s_a8d2
M2s_a8ca
M2s_a8ab
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
