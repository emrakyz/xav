%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_11_10_pft: dq xav_g2_0_11_10.pf1, xav_g2_0_11_10.pf2, xav_g2_0_11_10.pf3, xav_g2_0_11_10.pf4, xav_g2_0_11_10.pf5, xav_g2_0_11_10.pf6, xav_g2_0_11_10.pf7, xav_g2_0_11_10.pf8, xav_g2_0_11_10.pf9, xav_g2_0_11_10.pf10, xav_g2_0_11_10.pf11, xav_g2_0_11_10.pf12, xav_g2_0_11_10.pf13, xav_g2_0_11_10.pf14, xav_g2_0_11_10.pf15, xav_g2_0_11_10.pf16, xav_g2_0_11_10.pf17, xav_g2_0_11_10.pf18, xav_g2_0_11_10.pf19, xav_g2_0_11_10.pf20, xav_g2_0_11_10.pf21, xav_g2_0_11_10.pf22, xav_g2_0_11_10.pf23, xav_g2_0_11_10.pf24, xav_g2_0_11_10.pf25, xav_g2_0_11_10.pf26, xav_g2_0_11_10.pf27, xav_g2_0_11_10.pf28, xav_g2_0_11_10.pf29, xav_g2_0_11_10.pf30, xav_g2_0_11_10.pf31, xav_g2_0_11_10.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_11_10
align 64
xav_g2_0_11_10:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_11_10_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a19
M2s_a466
    vpermps ymm1, ymm3, [r8 + 288]
M2s_a2b
M2s_a2f
M2s_a3f0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 292]
M2s_a31
M2s_a36
M2s_a3f1
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 296]
M2s_a3b
M2s_a42
M2s_a3f2
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 300]
M2s_a45
M2s_a4c
M2s_a3f5
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 304]
M2s_a50
M2s_a5c
M2s_a3f6
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 308]
M2s_a5e
M2s_a66
M2s_a3f8
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 312]
M2s_a6b
M2s_a70
M2s_a3f9
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 316]
M2s_a75
M2s_a7a
M2s_a3fa
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 320]
M2s_a80
M2s_a84
M2s_a3fb
M2s_a470
M2s_a487
M2s_a496
M2s_a4a5
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 188]
M2s_a4b1
M2s_a4b3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_a3ff
M2s_a403
M2s_a4b5
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_a406
M2s_a40c
M2s_a4b7
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_a410
M2s_a414
M2s_a4ba
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_abe
M2s_aca
M2s_a4bd
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 288]
M2s_acd
M2s_ad3
M2s_a434
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 292]
M2s_ad8
M2s_ade
M2s_a436
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 296]
M2s_ae2
M2s_aec
M2s_a438
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 300]
M2s_aef
M2s_af7
M2s_a43a
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 304]
M2s_afc
M2s_a106
M2s_a43d
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 308]
M2s_a10d
M2s_a117
M2s_a43e
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 312]
M2s_a11c
M2s_a122
M2s_a440
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 316]
M2s_a128
M2s_a12e
M2s_a441
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 320]
M2s_a134
M2s_a137
M2s_a443
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 324]
M2s_a4cc
M2s_a4d0
M2s_a4d7
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 320]
    lea r13, [r9 + r14]
M2s_a480
M2s_a483
M2s_a486
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 352]
M2s_a488
M2s_a48b
M2s_a48e
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_a48f
M2s_a491
M2s_a493
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_a494
M2s_a498
M2s_a49b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_a49c
M2s_a49f
M2s_a4a2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_a4a3
M2s_a4a6
M2s_a4a8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_a4a9
M2s_a4ab
M2s_a4ad
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_a4ae
M2s_a4b1
M2s_a4b3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_a4b4
M2s_a402
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 256]
M2s_a4b5
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_a4b6
M2s_a40a
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 260]
M2s_a4b7
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_a4b9
M2s_a413
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 264]
M2s_a4ba
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_a140
M2s_a21
M2s_a44b
M2s_a469
M2s_a3d
M2s_a43
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 236]
M2s_a3f2
M2s_a46b
M2s_a60
M2s_a68
    vmovdqu ymm3, [rdx + 192]
M2s_a44d
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a46d
M2s_a81
M2s_a85
    vmovdqu ymm3, [rdx + 192]
M2s_a44e
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a470
M2s_a487
M2s_a496
M2s_a4a5
M2s_a4b0
M2s_a409
M2s_a4b8
M2s_a4c1
M2s_ae2
M2s_aec
M2s_a438
M2s_a4c5
M2s_a110
M2s_a118
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 248]
M2s_a43e
M2s_a4c8
M2s_a135
M2s_a138
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 260]
M2s_a443
M2s_a4cb
M2s_a4db
M2s_a495
M2s_a499
    vpermps ymm1, ymm3, [r13 + 300]
M2s_a4dc
M2s_a4aa
M2s_a4ac
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 312]
M2s_a4dd
M2s_a406
M2s_a40c
M2s_a4b7
M2s_a4e0
M2s_a4e3
    vmovaps ymm6, ymm2
M2s_a14c
M2s_a155
M2s_a15b
M2s_a16d
M2s_a451
M2s_a18b
M2s_a199
M2s_a1b7
    vmovups ymm13, [c_q8o3]
M2s_a453
M2s_a1d1
    vmovups ymm12, [c_q8o2]
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
    vpermps ymm11, ymm9, [c_rxo]
M2s_a456
    vmovups ymm12, [c_q8o2]
M2s_a21c
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
    vmovups ymm8, [c_q8e0]
M2s_a309
M2s_a31c
M2s_a320
M2s_a328
M2s_a32b
M2s_a331
M2s_a335
M2s_a311
M2s_a325
    vxorpd ymm11, ymm9, [u_mzero]
M2s_a336
M2s_a339
M2s_a342
M2s_a34c
M2s_a357
M2s_a312
M2s_a326
M2s_a35b
    cmovne edx, esi
M2s_a462
M2s_a364
M2s_a36a
M2s_a36d
M2s_a347
    div r9
M2s_a463
M2s_a353
    inc rsi
M2s_a464
M2s_a375
M2s_a380
M2s_a387
M2s_a379
M2s_a37c
M2s_a383
M2s_a38b
M2s_a38f
M2s_a393
M2s_a397
M2s_a39b
M2s_a39f
M2s_a3a8
M2s_a3b9
M2s_a3a4
M2s_a3ad
M2s_a3b4
M2s_a3c7
M2s_a3c9
M2s_a3b1
M2s_a3cf
M2s_a3d1
M2s_a3d5
M2s_a3d9
M2s_a3dd
M2s_a3e1
M2s_a3e5
M2s_a3eb
    vxorpd ymm14, ymm14, [r12 + 320]
M2s_a3ee