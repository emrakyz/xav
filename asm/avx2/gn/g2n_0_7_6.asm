%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_7_6_pft: dq xav_g2_0_7_6.pf1, xav_g2_0_7_6.pf2, xav_g2_0_7_6.pf3, xav_g2_0_7_6.pf4, xav_g2_0_7_6.pf5, xav_g2_0_7_6.pf6, xav_g2_0_7_6.pf7, xav_g2_0_7_6.pf8, xav_g2_0_7_6.pf9, xav_g2_0_7_6.pf10, xav_g2_0_7_6.pf11, xav_g2_0_7_6.pf12, xav_g2_0_7_6.pf13, xav_g2_0_7_6.pf14, xav_g2_0_7_6.pf15, xav_g2_0_7_6.pf16, xav_g2_0_7_6.pf17, xav_g2_0_7_6.pf18, xav_g2_0_7_6.pf19, xav_g2_0_7_6.pf20, xav_g2_0_7_6.pf21, xav_g2_0_7_6.pf22, xav_g2_0_7_6.pf23, xav_g2_0_7_6.pf24, xav_g2_0_7_6.pf25, xav_g2_0_7_6.pf26, xav_g2_0_7_6.pf27, xav_g2_0_7_6.pf28, xav_g2_0_7_6.pf29, xav_g2_0_7_6.pf30, xav_g2_0_7_6.pf31, xav_g2_0_7_6.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_7_6
align 64
xav_g2_0_7_6:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_7_6_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a1a
M2s_a23
M2s_a8b5
M2s_a47
M2s_a8b7
M2s_a5a
M2s_a5f
    vpermps ymm1, ymm3, [r8 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 192]
M2s_a8ba
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 224]
M2s_a8be
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2s_a8bf
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2s_a8c1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_a8c7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2s_a8c8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_a8e1
M2s_a8d9
M2s_ac6
M2s_a8cb
M2s_af6
M2s_a8cf
M2s_a104
M2s_a10f
    vpermps ymm1, ymm3, [r9 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 192]
M2s_a8d1
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 224]
M2s_a8be
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 256]
M2s_a8bf
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 288]
M2s_a8c1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_a8c7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 352]
M2s_a8c8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_a8e1
M2s_a8dd
M2s_a1e
M2s_a26
M2s_a2b
M2s_a8b6
M2s_a55
M2s_a8b8
M2s_a60
M2s_a8df
M2s_a8c5
    vpermps ymm1, ymm3, [r13 + 172]
M2s_a8e0
M2s_ac2
M2s_ac9
M2s_ace
M2s_a8cd
M2s_a102
    vpermps ymm1, ymm3, [r9 + 180]
M2s_a10d
    vmovdqu ymm3, [rdx + 128]
M2s_a8e3
M2s_a8c4
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 172]
M2s_a8e4
M2s_a8c9
M2s_a8e5
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 184]
M2s_a8dc
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
