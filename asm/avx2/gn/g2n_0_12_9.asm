%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_12_9_pft: dq xav_g2_0_12_9.pf1, xav_g2_0_12_9.pf2, xav_g2_0_12_9.pf3, xav_g2_0_12_9.pf4, xav_g2_0_12_9.pf5, xav_g2_0_12_9.pf6, xav_g2_0_12_9.pf7, xav_g2_0_12_9.pf8, xav_g2_0_12_9.pf9, xav_g2_0_12_9.pf10, xav_g2_0_12_9.pf11, xav_g2_0_12_9.pf12, xav_g2_0_12_9.pf13, xav_g2_0_12_9.pf14, xav_g2_0_12_9.pf15, xav_g2_0_12_9.pf16, xav_g2_0_12_9.pf17, xav_g2_0_12_9.pf18, xav_g2_0_12_9.pf19, xav_g2_0_12_9.pf20, xav_g2_0_12_9.pf21, xav_g2_0_12_9.pf22, xav_g2_0_12_9.pf23, xav_g2_0_12_9.pf24, xav_g2_0_12_9.pf25, xav_g2_0_12_9.pf26, xav_g2_0_12_9.pf27, xav_g2_0_12_9.pf28, xav_g2_0_12_9.pf29, xav_g2_0_12_9.pf30, xav_g2_0_12_9.pf31, xav_g2_0_12_9.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_12_9
align 64
xav_g2_0_12_9:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_12_9_pft]
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
M2s_a4f6
M2s_a473
M2s_a47a
M2s_a531
M2s_a50e
M2s_a511
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2s_a3fd
M2s_a400
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 384]
M2s_a404
M2s_a408
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_a40e
M2s_a412
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_a415
M2s_a417
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_a41a
M2s_a41f
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a422
M2s_a424
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_a425
M2s_a426
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_a428
M2s_a42b
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_a42c
M2s_a8e
M2s_a42e
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_a42f
M2s_a94
M2s_a432
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_a4fb
M2s_a9a
M2s_a4fd
    vpermps ymm1, ymm3, [r13 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_a9c
    vpermps ymm1, ymm3, [r13 + 236]
M2s_a5be
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 300]
M2s_a519
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
M2s_a4ff
M2s_a4cf
M2s_a4d5
M2s_a538
M2s_a523
M2s_a525
    vfmadd231ps ymm6, ymm0, [rcx + 352]
M2s_a444
M2s_a400
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 384]
M2s_a404
M2s_a408
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_a40e
M2s_a412
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_a415
M2s_a417
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_a41a
M2s_a41f
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_a422
M2s_a424
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_a425
M2s_a426
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_a428
M2s_a42b
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_a42c
M2s_a8e
M2s_a42e
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_a42f
M2s_a94
M2s_a432
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_a4fb
M2s_a9a
M2s_a4fd
    vpermps ymm1, ymm3, [r13 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_a5bc
M2s_aa2
M2s_a5bf
    vpermps ymm1, ymm3, [r13 + 300]
M2s_a52d
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
M2s_a532
M2s_a50f
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a5b8
M2s_a411
M2s_a5b9
M2s_a423
    vmovdqu ymm3, [rdx + 480]
M2s_a5ba
M2s_a89
M2s_a8d
M2s_a42d
    vmovdqu ymm3, [rdx + 480]
M2s_a5bb
M2s_a9e
M2s_aa1
M2s_a5bd
M2s_ada
M2s_ae0
M2s_a437
M2s_a100
M2s_a43c
M2s_a12a
M2s_a44f
M2s_a4cd
M2s_a4d1
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 296]
M2s_a538
M2s_a523
M2s_a525
M2s_a5c0
M2s_a411
M2s_a5c1
M2s_a423
    vmovdqu ymm3, [rdx + 480]
M2s_a5c2
M2s_a89
M2s_a8d
M2s_a42d
    vmovdqu ymm3, [rdx + 480]
M2s_a5c3
M2s_a9e
M2s_aa1
M2s_a5be
    vmovdqu ymm3, [rdx + 480]
M2s_a5c4
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
    vmovups ymm13, [c_q8o3]
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
    vpsrld ymm8, ymm6, 23
    vpsrld ymm9, ymm6, 20
    vpmaddwd ymm10, ymm8, ymm13
M2s_a2f7
M2s_a300
M2s_a2fa
    vpaddd ymm4, ymm10, ymm9
M2s_a302
M2s_a307
M2s_a315
M2s_a319
M2s_a322
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
M2s_a462
M2s_a364
M2s_a36a
M2s_a36d
M2s_a347
M2s_a4f4
M2s_a352
M2s_a371
M2s_a377
M2s_a382
M2s_a389
M2s_a37b
M2s_a37e
M2s_a385
M2s_a38d
M2s_a391
M2s_a395
M2s_a399
M2s_a39d
M2s_a3a1
M2s_a3aa
M2s_a3bb
M2s_a3a6
M2s_a3af
M2s_a3c5
M2s_a3c0
M2s_a3cb
M2s_a3b3
M2s_a3cd
M2s_a3c0
M2s_a3d3
M2s_a3d7
M2s_a3db
M2s_a3df
M2s_a3e3
M2s_a3e7
M2s_a3ed
    ret
section .note.GNU-stack noalloc noexec nowrite progbits
