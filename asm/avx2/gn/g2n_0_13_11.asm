%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_13_11_pft: dq xav_g2_0_13_11.pf1, xav_g2_0_13_11.pf2, xav_g2_0_13_11.pf3, xav_g2_0_13_11.pf4, xav_g2_0_13_11.pf5, xav_g2_0_13_11.pf6, xav_g2_0_13_11.pf7, xav_g2_0_13_11.pf8, xav_g2_0_13_11.pf9, xav_g2_0_13_11.pf10, xav_g2_0_13_11.pf11, xav_g2_0_13_11.pf12, xav_g2_0_13_11.pf13, xav_g2_0_13_11.pf14, xav_g2_0_13_11.pf15, xav_g2_0_13_11.pf16, xav_g2_0_13_11.pf17, xav_g2_0_13_11.pf18, xav_g2_0_13_11.pf19, xav_g2_0_13_11.pf20, xav_g2_0_13_11.pf21, xav_g2_0_13_11.pf22, xav_g2_0_13_11.pf23, xav_g2_0_13_11.pf24, xav_g2_0_13_11.pf25, xav_g2_0_13_11.pf26, xav_g2_0_13_11.pf27, xav_g2_0_13_11.pf28, xav_g2_0_13_11.pf29, xav_g2_0_13_11.pf30, xav_g2_0_13_11.pf31, xav_g2_0_13_11.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_13_11
align 64
xav_g2_0_13_11:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_13_11_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a19
M2s_a466
M2s_a541
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a545
    vpermps ymm1, ymm3, [r8 + 272]
M2s_a5b5
    vmovdqu ymm3, [rdx + 224]
M2s_a5b6
M2s_a3fa
M2s_a552
M2s_a47d
M2s_a55c
M2s_a560
M2s_a5e7
M2s_a5c9
M2s_a5cd
M2s_a5f0
    vpermps ymm1, ymm3, [r8 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 384]
M2s_a562
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 416]
M2s_a569
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_a56e
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_a574
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a577
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_a57d
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_a580
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_a584
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_a585
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_a587
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_a588
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_a58a
    vfmadd231ps ymm5, ymm0, [rcx + 768]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 48]
M2s_a49e
M2s_a4a1
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 368]
M2s_a5d6
M2s_a58c
M2s_a51b
M2s_a592
M2s_a595
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a59b
    vpermps ymm1, ymm3, [r9 + 288]
M2s_a521
M2s_a5a2
M2s_a5a7
M2s_a5ab
    vpermps ymm1, ymm3, [r9 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 352]
M2s_a5d7
M2s_a5da
M2s_a5df
M2s_a600
    vfmadd231ps ymm6, ymm0, [rcx + 384]
M2s_a5ae
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 416]
M2s_a569
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_a56e
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_a574
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_a577
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_a57d
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_a580
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_a584
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_a585
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_a587
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_a588
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_a58a
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_a5f9
M2s_a5e6
M2s_a1f
M2s_a44a
M2s_a468
M2s_a543
M2s_a547
M2s_a5b5
M2s_a5ed
M2s_a50b
M2s_a556
M2s_a559
M2s_a55f
    vpermps ymm1, ymm3, [r8 + 364]
M2s_a5e7
M2s_a5c9
M2s_a5cd
M2s_a5ef
M2s_a56c
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a5f3
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a5f4
    vpermps ymm1, ymm3, [r13 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a5f5
    vpermps ymm1, ymm3, [r13 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a5f6
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a5f7
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a5f8
M2s_a58c
M2s_a51b
M2s_a592
M2s_a595
M2s_a5fb
    vmovdqu ymm3, [rdx + 224]
M2s_a5fc
M2s_a4d7
M2s_a5a6
M2s_a526
M2s_a5ad
M2s_a5d7
M2s_a5da
M2s_a5df
M2s_a601
M2s_a56d
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a603
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a604
    vpermps ymm1, ymm3, [r13 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a605
    vpermps ymm1, ymm3, [r13 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a606
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a607
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a608
M2s_a5e5
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
M2s_a5e9
M2s_a2f8
M2s_a2fb
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
