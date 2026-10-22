%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_11_9_pft: dq xav_g2_0_11_9.pf1, xav_g2_0_11_9.pf2, xav_g2_0_11_9.pf3, xav_g2_0_11_9.pf4, xav_g2_0_11_9.pf5, xav_g2_0_11_9.pf6, xav_g2_0_11_9.pf7, xav_g2_0_11_9.pf8, xav_g2_0_11_9.pf9, xav_g2_0_11_9.pf10, xav_g2_0_11_9.pf11, xav_g2_0_11_9.pf12, xav_g2_0_11_9.pf13, xav_g2_0_11_9.pf14, xav_g2_0_11_9.pf15, xav_g2_0_11_9.pf16, xav_g2_0_11_9.pf17, xav_g2_0_11_9.pf18, xav_g2_0_11_9.pf19, xav_g2_0_11_9.pf20, xav_g2_0_11_9.pf21, xav_g2_0_11_9.pf22, xav_g2_0_11_9.pf23, xav_g2_0_11_9.pf24, xav_g2_0_11_9.pf25, xav_g2_0_11_9.pf26, xav_g2_0_11_9.pf27, xav_g2_0_11_9.pf28, xav_g2_0_11_9.pf29, xav_g2_0_11_9.pf30, xav_g2_0_11_9.pf31, xav_g2_0_11_9.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_11_9
align 64
xav_g2_0_11_9:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_11_9_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a19
M2s_a3ef
M2s_a3f
M2s_a3f3
M2s_a61
M2s_a44c
M2s_a82
M2s_a4e7
    vpermps ymm1, ymm3, [r8 + 292]
M2s_a471
M2s_a474
M2s_a47b
    vfmadd231ps ymm4, ymm0, [rcx + 320]
M2s_a3fd
M2s_a400
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 352]
M2s_a404
M2s_a408
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_a40e
M2s_a412
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_a415
M2s_a417
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_a41a
M2s_a41f
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_a422
M2s_a424
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a425
M2s_a426
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_a428
M2s_a42b
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_a42c
M2s_a8e
M2s_a42e
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_a42f
M2s_a94
M2s_a432
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_a96
    vpermps ymm1, ymm3, [r13 + 232]
M2s_a4fc
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 296]
M2s_a4bb
M2s_ac4
M2s_acc
M2s_a433
M2s_ae8
M2s_a439
M2s_a111
M2s_a4e9
M2s_a11c
M2s_a122
M2s_a43f
M2s_a135
M2s_a138
M2s_a4ec
    vpermps ymm1, ymm3, [r9 + 292]
M2s_a4cc
M2s_a4d0
M2s_a4d7
    vfmadd231ps ymm6, ymm0, [rcx + 320]
M2s_a444
M2s_a400
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 352]
M2s_a404
M2s_a408
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_a40e
M2s_a412
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_a415
M2s_a417
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_a41a
M2s_a41f
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_a422
M2s_a424
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_a425
M2s_a426
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_a428
M2s_a42b
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_a42c
M2s_a8e
M2s_a42e
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_a42f
M2s_a94
M2s_a432
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_a4fb
M2s_a9a
M2s_a4fd
    vpermps ymm1, ymm3, [r13 + 296]
M2s_a4e2
M2s_a1d
M2s_a448
M2s_a3e
M2s_a44
M2s_a3f4
M2s_a62
M2s_a3f7
M2s_a83
M2s_a44e
M2s_a471
M2s_a474
M2s_a47b
M2s_a4f7
M2s_a411
M2s_a4f8
M2s_a423
    vmovdqu ymm3, [rdx + 480]
M2s_a4f9
M2s_a89
M2s_a8d
M2s_a42d
    vmovdqu ymm3, [rdx + 480]
M2s_a4fa
M2s_ac1
    vmovdqu ymm3, [rdx + 192]
M2s_a4bd
M2s_acd
M2s_ad3
M2s_a435
M2s_af3
    vpermps ymm1, ymm3, [r9 + 240]
M2s_a43b
M2s_a120
    vpermps ymm1, ymm3, [r9 + 252]
M2s_a43f
M2s_a135
M2s_a138
M2s_a4ec
M2s_a4fe
M2s_a407
M2s_a40d
M2s_a500
M2s_a41d
M2s_a501
M2s_a42a
M2s_a502
M2s_a97
M2s_a99
M2s_a4fc
    vmovdqu ymm3, [rdx + 480]
M2s_a503
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
    vmovups ymm13, [c_q8o3]
M2s_a4f1
    vpslld ymm0, ymm2, 23
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
