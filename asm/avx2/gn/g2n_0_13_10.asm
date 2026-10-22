%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_13_10_pft: dq xav_g2_0_13_10.pf1, xav_g2_0_13_10.pf2, xav_g2_0_13_10.pf3, xav_g2_0_13_10.pf4, xav_g2_0_13_10.pf5, xav_g2_0_13_10.pf6, xav_g2_0_13_10.pf7, xav_g2_0_13_10.pf8, xav_g2_0_13_10.pf9, xav_g2_0_13_10.pf10, xav_g2_0_13_10.pf11, xav_g2_0_13_10.pf12, xav_g2_0_13_10.pf13, xav_g2_0_13_10.pf14, xav_g2_0_13_10.pf15, xav_g2_0_13_10.pf16, xav_g2_0_13_10.pf17, xav_g2_0_13_10.pf18, xav_g2_0_13_10.pf19, xav_g2_0_13_10.pf20, xav_g2_0_13_10.pf21, xav_g2_0_13_10.pf22, xav_g2_0_13_10.pf23, xav_g2_0_13_10.pf24, xav_g2_0_13_10.pf25, xav_g2_0_13_10.pf26, xav_g2_0_13_10.pf27, xav_g2_0_13_10.pf28, xav_g2_0_13_10.pf29, xav_g2_0_13_10.pf30, xav_g2_0_13_10.pf31, xav_g2_0_13_10.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_13_10
align 64
xav_g2_0_13_10:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_13_10_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a19
M2s_a465
M2s_a46a
M2s_a54
M2s_a5d
M2s_a508
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a46e
M2s_a472
M2s_a476
M2s_a47d
M2s_a530
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 48]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a5c9
M2s_a5cd
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 384]
M2s_a47f
M2s_a482
M2s_a485
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 416]
M2s_a488
M2s_a48b
M2s_a48e
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_a48f
M2s_a491
M2s_a493
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_a494
M2s_a498
M2s_a49b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a49c
M2s_a49f
M2s_a4a2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_a4a3
M2s_a4a6
M2s_a4a8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_a4a9
M2s_a4ab
M2s_a4ad
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_a4ae
M2s_a4b1
M2s_a4b3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_a4b4
M2s_a402
M2s_a4de
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_a4b6
M2s_a40a
M2s_a4df
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_a4b9
M2s_a413
M2s_a4e1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_a517
M2s_a418
M2s_a52b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 48]
M2s_a41b
M2s_a421
M2s_a5d5
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2s_abe
M2s_aca
M2s_a4be
M2s_a51c
M2s_afd
M2s_a107
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a4c7
M2s_a129
M2s_a130
M2s_a520
M2s_a4d9
M2s_a539
M2s_a5d7
M2s_a5da
M2s_a5df
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 384]
M2s_a4da
M2s_a482
M2s_a485
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 416]
M2s_a488
M2s_a48b
M2s_a48e
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_a48f
M2s_a491
M2s_a493
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_a494
M2s_a498
M2s_a49b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_a49c
M2s_a49f
M2s_a4a2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_a4a3
M2s_a4a6
M2s_a4a8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_a4a9
M2s_a4ab
M2s_a4ad
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_a4ae
M2s_a4b1
M2s_a4b3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_a4b4
M2s_a402
M2s_a4de
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_a4b6
M2s_a40a
M2s_a4df
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_a4b9
M2s_a413
M2s_a4e1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_a517
M2s_a418
M2s_a52b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_a5d4
M2s_a420
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 272]
M2s_a5d5
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 800]
M2s_a140
M2s_a21
M2s_a44b
M2s_a469
M2s_a3d
M2s_a43
M2s_a4e4
M2s_a52f
M2s_a75
M2s_a7a
M2s_a3fa
M2s_a46f
M2s_a50d
M2s_a510
M2s_a512
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2s_a5c8
M2s_a489
M2s_a48c
    vpermps ymm1, ymm3, [r13 + 292]
M2s_a5d0
M2s_a49d
M2s_a4a0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 304]
M2s_a5d1
M2s_a4af
M2s_a4b2
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 316]
M2s_a5d2
M2s_a410
M2s_a414
M2s_a4ba
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 328]
M2s_a5d3
M2s_abf
M2s_acb
M2s_a4c0
M2s_a4c4
M2s_aff
M2s_a109
M2s_a51e
M2s_a537
M2s_a4cd
M2s_a4d1
M2s_a4d8
    vpermps ymm1, ymm3, [r9 + 328]
M2s_a539
M2s_a5d8
M2s_a489
M2s_a48c
    vpermps ymm1, ymm3, [r13 + 292]
M2s_a5e0
M2s_a49d
M2s_a4a0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 304]
M2s_a5e1
M2s_a4af
M2s_a4b2
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 316]
M2s_a5e2
M2s_a410
M2s_a414
M2s_a4ba
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 328]
M2s_a5e3
M2s_a4ed
M2s_a154
M2s_a16c
M2s_a17f
M2s_a161
M2s_a18f
M2s_a19c
M2s_a16a
M2s_a1bb
M2s_a1a1
M2s_a457
M2s_a1cd
M2s_a1d6
M2s_a1dd
M2s_a1e6
M2s_a1f1
M2s_a1fa
M2s_a176
M2s_a201
M2s_a185
M2s_a20c
M2s_a195
M2s_a214
M2s_a1b1
M2s_a16a
M2s_a217
M2s_a1a1
M2s_a456
M2s_a4f1
M2s_a507
M2s_a53d
M2s_a227
M2s_a1ef
M2s_a231
M2s_a239
M2s_a242
M2s_a24a
M2s_a251
M2s_a258
M2s_a262
M2s_a25d
M2s_a26a
M2s_a278
M2s_a28c
M2s_a281
M2s_a53f
M2s_a299
M2s_a2a9
M2s_a29d
M2s_a2b7
M2s_a2aa
M2s_a2b1
M2s_a45b
M2s_a2bb
M2s_a5b7
M2s_a2ce
M2s_a2d3
M2s_a2c3
M2s_a45f
M2s_a2dd
M2s_a2e1
M2s_a2e3
M2s_a287
M2s_a2e6
M2s_a2e9
M2s_a2eb
M2s_a2f1
M2s_a5c6
    vmulps ymm4, ymm10, ymm0
M2s_a2ff
M2s_a2f9
M2s_a2fc
M2s_a303
M2s_a308
M2s_a316
M2s_a31a
M2s_a323
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
