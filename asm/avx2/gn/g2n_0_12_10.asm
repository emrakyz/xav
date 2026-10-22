%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_12_10_pft: dq xav_g2_0_12_10.pf1, xav_g2_0_12_10.pf2, xav_g2_0_12_10.pf3, xav_g2_0_12_10.pf4, xav_g2_0_12_10.pf5, xav_g2_0_12_10.pf6, xav_g2_0_12_10.pf7, xav_g2_0_12_10.pf8, xav_g2_0_12_10.pf9, xav_g2_0_12_10.pf10, xav_g2_0_12_10.pf11, xav_g2_0_12_10.pf12, xav_g2_0_12_10.pf13, xav_g2_0_12_10.pf14, xav_g2_0_12_10.pf15, xav_g2_0_12_10.pf16, xav_g2_0_12_10.pf17, xav_g2_0_12_10.pf18, xav_g2_0_12_10.pf19, xav_g2_0_12_10.pf20, xav_g2_0_12_10.pf21, xav_g2_0_12_10.pf22, xav_g2_0_12_10.pf23, xav_g2_0_12_10.pf24, xav_g2_0_12_10.pf25, xav_g2_0_12_10.pf26, xav_g2_0_12_10.pf27, xav_g2_0_12_10.pf28, xav_g2_0_12_10.pf29, xav_g2_0_12_10.pf30, xav_g2_0_12_10.pf31, xav_g2_0_12_10.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_12_10
align 64
xav_g2_0_12_10:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_12_10_pft]
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
    vpermps ymm1, ymm3, [r8 + 244]
M2s_a3f6
M2s_a46c
M2s_a78
M2s_a7e
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 256]
M2s_a3fa
M2s_a46f
M2s_a50d
M2s_a510
M2s_a512
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2s_a47f
M2s_a482
M2s_a485
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 384]
M2s_a488
M2s_a48b
M2s_a48e
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_a48f
M2s_a491
M2s_a493
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_a494
M2s_a498
M2s_a49b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_a49c
M2s_a49f
M2s_a4a2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a4a3
M2s_a4a6
M2s_a4a8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_a4a9
M2s_a4ab
M2s_a4ad
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_a4ae
M2s_a4b1
M2s_a4b3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_a4b4
M2s_a402
M2s_a4de
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_a4b6
M2s_a40a
M2s_a4df
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_a4b9
M2s_a413
M2s_a4e1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_a416
M2s_a419
M2s_a518
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_abe
M2s_aca
M2s_a4be
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a4c3
M2s_afe
M2s_a108
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 244]
M2s_a43d
M2s_a4c7
M2s_a129
M2s_a130
    vmovdqu ymm3, [rdx + 192]
M2s_a450
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a4ca
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 44]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a523
M2s_a525
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 352]
M2s_a4da
M2s_a482
M2s_a485
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 384]
M2s_a488
M2s_a48b
M2s_a48e
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_a48f
M2s_a491
M2s_a493
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_a494
M2s_a498
M2s_a49b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_a49c
M2s_a49f
M2s_a4a2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_a4a3
M2s_a4a6
M2s_a4a8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_a4a9
M2s_a4ab
M2s_a4ad
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_a4ae
M2s_a4b1
M2s_a4b3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_a4b4
M2s_a402
M2s_a4de
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_a4b6
M2s_a40a
M2s_a4df
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_a4b9
M2s_a413
M2s_a4e1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_a517
M2s_a418
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 268]
M2s_a518
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_a140
M2s_a21
M2s_a44b
M2s_a469
M2s_a3d
M2s_a43
M2s_a4e4
    vpermps ymm1, ymm3, [r8 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a46c
M2s_a78
M2s_a7e
M2s_a50a
M2s_a47d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 320]
M2s_a50c
M2s_a489
M2s_a48c
    vpermps ymm1, ymm3, [r13 + 292]
M2s_a513
M2s_a49d
M2s_a4a0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 304]
M2s_a514
M2s_a4af
M2s_a4b2
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 316]
M2s_a515
M2s_a410
M2s_a414
M2s_a4ba
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 328]
M2s_a516
M2s_ace
M2s_ad5
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a4c2
M2s_af1
M2s_afa
    vmovdqu ymm3, [rdx + 192]
M2s_a504
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a4c6
M2s_a11e
M2s_a125
    vmovdqu ymm3, [rdx + 192]
M2s_a505
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a4c9
M2s_a4ce
M2s_a4d2
M2s_a4d9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 320]
M2s_a522
M2s_a489
M2s_a48c
    vpermps ymm1, ymm3, [r13 + 292]
M2s_a527
M2s_a49d
M2s_a4a0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 304]
M2s_a528
M2s_a4af
M2s_a4b2
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 316]
M2s_a529
M2s_a410
M2s_a414
M2s_a4ba
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 328]
M2s_a52a
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
    add r9, 576
M2s_a454
M2s_a1a0
M2s_a4f0
M2s_a506
    vpermps ymm11, ymm9, [c_rxo]
M2s_a507
    vmovups ymm12, [c_q8o2]
M2s_a220
M2s_a228
    push rdi
    mov rcx, r10
    lea rsi, [rbp + 384]
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
    vmulps ymm2, ymm2, ymm1
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
