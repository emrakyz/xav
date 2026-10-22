%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_14_11_pft: dq xav_g2_0_14_11.pf1, xav_g2_0_14_11.pf2, xav_g2_0_14_11.pf3, xav_g2_0_14_11.pf4, xav_g2_0_14_11.pf5, xav_g2_0_14_11.pf6, xav_g2_0_14_11.pf7, xav_g2_0_14_11.pf8, xav_g2_0_14_11.pf9, xav_g2_0_14_11.pf10, xav_g2_0_14_11.pf11, xav_g2_0_14_11.pf12, xav_g2_0_14_11.pf13, xav_g2_0_14_11.pf14, xav_g2_0_14_11.pf15, xav_g2_0_14_11.pf16, xav_g2_0_14_11.pf17, xav_g2_0_14_11.pf18, xav_g2_0_14_11.pf19, xav_g2_0_14_11.pf20, xav_g2_0_14_11.pf21, xav_g2_0_14_11.pf22, xav_g2_0_14_11.pf23, xav_g2_0_14_11.pf24, xav_g2_0_14_11.pf25, xav_g2_0_14_11.pf26, xav_g2_0_14_11.pf27, xav_g2_0_14_11.pf28, xav_g2_0_14_11.pf29, xav_g2_0_14_11.pf30, xav_g2_0_14_11.pf31, xav_g2_0_14_11.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_14_11
align 64
xav_g2_0_14_11:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_14_11_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a19
M2s_a466
M2s_a541
M2s_a5ea
    vmovdqu ymm3, [rdx + 224]
M2s_a5ec
M2s_a3f8
M2s_a54e
    vpermps ymm1, ymm3, [r8 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a552
M2s_a47d
M2s_a55c
M2s_a560
M2s_a5e7
M2s_a5c9
M2s_a5cd
M2s_a5f0
    vpermps ymm1, ymm3, [r8 + 368]
M2s_a6a1
    vpermps ymm1, ymm3, [r8 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 416]
M2s_a562
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 448]
M2s_a569
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_a56e
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a574
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_a577
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_a57d
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_a580
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_a584
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_a585
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_a587
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_a588
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2s_a58a
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2s_a5f9
    vfmadd231ps ymm5, ymm0, [rcx + 832]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 52]
M2s_a4a4
M2s_a4a7
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 864]
M2s_abe
M2s_aca
M2s_a4bc
M2s_a58d
M2s_a591
M2s_a535
M2s_a597
M2s_a59c
M2s_a521
M2s_a5a2
M2s_a5a7
M2s_a5ab
M2s_a5fd
M2s_a602
M2s_a6af
    vfmadd231ps ymm6, ymm0, [rcx + 416]
M2s_a5ae
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 448]
M2s_a569
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_a56e
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_a574
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_a577
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_a57d
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_a580
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_a584
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_a585
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_a587
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_a588
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_a58a
    vfmadd231ps ymm7, ymm0, [rcx + 800]
M2s_a5f9
    vfmadd231ps ymm7, ymm0, [rcx + 832]
M2s_a6ad
    vfmadd231ps ymm7, ymm0, [rcx + 864]
M2s_a140
M2s_a21
M2s_a44b
    vmovdqu ymm3, [rdx + 256]
M2s_a541
M2s_a5ea
M2s_a69e
M2s_a44d
M2s_a4e6
M2s_a550
M2s_a554
M2s_a47e
M2s_a55e
M2s_a561
M2s_a5e8
M2s_a5ca
M2s_a5ce
M2s_a5f1
M2s_a6a0
M2s_a568
M2s_a6a6
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6a7
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6a8
    vpermps ymm1, ymm3, [r13 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6a9
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6aa
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6ab
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6ac
M2s_a58c
M2s_a51b
M2s_a592
M2s_a595
M2s_a5fb
M2s_a60a
M2s_a4d6
M2s_a5aa
M2s_a5ac
M2s_a5ff
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 384]
M2s_a6b0
    vpermps ymm1, ymm3, [r13 + 320]
M2s_a6b5
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6b6
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6b7
    vpermps ymm1, ymm3, [r13 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6b8
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6b9
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6ba
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6bb
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6bc
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
    vmovups ymm13, [c_q8o3]
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
    vpermps ymm10, ymm9, [c_w8o]
M2s_a4f0
M2s_a506
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
    cmp r13, 16
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
