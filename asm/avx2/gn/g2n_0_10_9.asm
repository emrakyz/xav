%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_10_9_pft: dq xav_g2_0_10_9.pf1, xav_g2_0_10_9.pf2, xav_g2_0_10_9.pf3, xav_g2_0_10_9.pf4, xav_g2_0_10_9.pf5, xav_g2_0_10_9.pf6, xav_g2_0_10_9.pf7, xav_g2_0_10_9.pf8, xav_g2_0_10_9.pf9, xav_g2_0_10_9.pf10, xav_g2_0_10_9.pf11, xav_g2_0_10_9.pf12, xav_g2_0_10_9.pf13, xav_g2_0_10_9.pf14, xav_g2_0_10_9.pf15, xav_g2_0_10_9.pf16, xav_g2_0_10_9.pf17, xav_g2_0_10_9.pf18, xav_g2_0_10_9.pf19, xav_g2_0_10_9.pf20, xav_g2_0_10_9.pf21, xav_g2_0_10_9.pf22, xav_g2_0_10_9.pf23, xav_g2_0_10_9.pf24, xav_g2_0_10_9.pf25, xav_g2_0_10_9.pf26, xav_g2_0_10_9.pf27, xav_g2_0_10_9.pf28, xav_g2_0_10_9.pf29, xav_g2_0_10_9.pf30, xav_g2_0_10_9.pf31, xav_g2_0_10_9.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_10_9
align 64
xav_g2_0_10_9:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_10_9_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a19
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 256]
M2s_a2b
M2s_a2f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 260]
M2s_a31
M2s_a36
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 264]
M2s_a3b
M2s_a42
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 268]
M2s_a45
M2s_a4c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 272]
M2s_a50
M2s_a5c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 276]
M2s_a5e
M2s_a66
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 280]
M2s_a6b
M2s_a70
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 284]
M2s_a75
M2s_a7a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 288]
M2s_a80
M2s_a84
M2s_a3fc
M2s_a40f
M2s_a41e
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a428
M2s_a42b
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_a88
    vpermps ymm1, ymm3, [r13 + 224]
M2s_a42d
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_a90
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a432
    vpermps ymm1, ymm3, [r13 + 292]
M2s_abd
M2s_ac4
M2s_acc
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 256]
M2s_acd
M2s_ad3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 260]
M2s_ad8
M2s_ade
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 264]
M2s_ae2
M2s_aec
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 268]
M2s_aef
M2s_af7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 272]
M2s_afc
M2s_a106
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 276]
M2s_a10d
M2s_a117
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 280]
M2s_a11c
M2s_a122
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 284]
M2s_a128
M2s_a12e
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 288]
M2s_a134
M2s_a137
M2s_a443
    vfmadd231ps ymm6, ymm0, [rcx + 288]
    lea r13, [r9 + r14]
M2s_a3fe
M2s_a401
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 320]
M2s_a404
M2s_a408
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 352]
M2s_a40e
M2s_a412
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_a415
M2s_a417
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_a41a
M2s_a41f
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_a422
M2s_a424
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_a425
M2s_a426
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_a428
M2s_a42b
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_a42c
M2s_a8e
M2s_a42e
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_a42f
M2s_a94
M2s_a432
    vpermps ymm1, ymm3, [r13 + 292]
M2s_a13d
M2s_a1d
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a3ef
M2s_a3f
M2s_a3f3
M2s_a61
    vpermps ymm1, ymm3, [r8 + 248]
M2s_a3f7
M2s_a83
    vpermps ymm1, ymm3, [r8 + 260]
M2s_a3fc
M2s_a40f
M2s_a41e
M2s_a427
M2s_a91
M2s_a93
M2s_a431
M2s_ada
M2s_ae0
M2s_a437
M2s_a100
M2s_a43c
M2s_a12a
    vpermps ymm1, ymm3, [r9 + 256]
M2s_a442
M2s_a405
M2s_a40b
M2s_a445
M2s_a41c
    vmovdqu ymm3, [rdx + 480]
M2s_a446
M2s_a429
    vmovdqu ymm3, [rdx + 480]
M2s_a447
M2s_a90
M2s_a430
M2s_a13e
M2s_a14c
M2s_a155
M2s_a15b
M2s_a16d
    vfmadd213ps ymm4, ymm12, ymm11
M2s_a180
M2s_a18c
M2s_a19a
M2s_a1b8
    vmovups ymm12, [c_q8o2]
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
    sub rcx, 2
M2s_a217
M2s_a1a1
    vpslld ymm0, ymm2, 23
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
    add r9, rbx
M2s_a23f
M2s_a247
M2s_a24e
M2s_a255
M2s_a25f
M2s_a266
M2s_a273
M2s_a289
M2s_a27e
M2s_a284
M2s_a294
M2s_a29b
M2s_a2ad
    vmovups ymm13, [c_k5]
    vmovups ymm12, [c_mone]
M2s_a2b7
M2s_a2aa
M2s_a2b1
    vorps ymm10, ymm1, ymm6
    vpsrld ymm8, ymm4, 23
M2s_a2c6
M2s_a2bd
M2s_a2c9
M2s_a2d0
M2s_a2d5
    mov rax, [rbp + 160]
    imul rax, rax, 1
    add rcx, rax
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
    vmovaps ymm10, ymm8
    vfmadd213ps ymm10, ymm11, [c_q8e2]
M2s_a301
M2s_a305
M2s_a30a
M2s_a31d
M2s_a321
    vxorpd ymm11, ymm9, [u_mzero]
M2s_a329
M2s_a32f
M2s_a333
M2s_a30f
M2s_a323
M2s_a337
M2s_a33a
M2s_a343
M2s_a34e
M2s_a358
M2s_a314
M2s_a327
M2s_a35c
    mov eax, edx
M2s_a361
M2s_a365
M2s_a368
M2s_a36b
M2s_a36e
M2s_a348
    mov r14, rax
M2s_a36f
M2s_a354
    mov [r12 + 1288], rsi
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