%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_7_7_pft: dq xav_g2_0_7_7.pf1, xav_g2_0_7_7.pf2, xav_g2_0_7_7.pf3, xav_g2_0_7_7.pf4, xav_g2_0_7_7.pf5, xav_g2_0_7_7.pf6, xav_g2_0_7_7.pf7, xav_g2_0_7_7.pf8, xav_g2_0_7_7.pf9, xav_g2_0_7_7.pf10, xav_g2_0_7_7.pf11, xav_g2_0_7_7.pf12, xav_g2_0_7_7.pf13, xav_g2_0_7_7.pf14, xav_g2_0_7_7.pf15, xav_g2_0_7_7.pf16, xav_g2_0_7_7.pf17, xav_g2_0_7_7.pf18, xav_g2_0_7_7.pf19, xav_g2_0_7_7.pf20, xav_g2_0_7_7.pf21, xav_g2_0_7_7.pf22, xav_g2_0_7_7.pf23, xav_g2_0_7_7.pf24, xav_g2_0_7_7.pf25, xav_g2_0_7_7.pf26, xav_g2_0_7_7.pf27, xav_g2_0_7_7.pf28, xav_g2_0_7_7.pf29, xav_g2_0_7_7.pf30, xav_g2_0_7_7.pf31, xav_g2_0_7_7.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_7_7
align 64
xav_g2_0_7_7:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_7_7_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a1a
M2s_a23
M2s_a29
M2s_a2b
M2s_a2e
    vpermps ymm1, ymm3, [r8 + 196]
M2s_a31
M2s_a35
    vpermps ymm1, ymm3, [r8 + 200]
M2s_a3b
M2s_a41
    vpermps ymm1, ymm3, [r8 + 204]
M2s_a45
M2s_a4b
    vpermps ymm1, ymm3, [r8 + 208]
M2s_a50
M2s_a5b
    vpermps ymm1, ymm3, [r8 + 212]
M2s_a5e
M2s_a67
    vpermps ymm1, ymm3, [r8 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 192]
    lea r13, [r8 + r14]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [r13 + 0]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_ab0
M2s_ab2
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 224]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_ab8
M2s_aba
    vmovdqu ymm3, [rdx + 352]
M2s_a8ef
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2s_a8f7
M2s_a8f8
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_a8f9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 216]
M2s_a8d9
M2s_ac4
M2s_acd
M2s_ad4
    vpermps ymm1, ymm3, [r9 + 196]
M2s_ad8
M2s_adf
    vpermps ymm1, ymm3, [r9 + 200]
M2s_ae2
M2s_aed
    vpermps ymm1, ymm3, [r9 + 204]
M2s_aef
M2s_af8
    vpermps ymm1, ymm3, [r9 + 208]
M2s_afc
M2s_a105
    vpermps ymm1, ymm3, [r9 + 212]
M2s_a10d
M2s_a116
    vpermps ymm1, ymm3, [r9 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 192]
    lea r13, [r9 + r14]
M2s_a8ed
M2s_ab4
    vmulps ymm7, ymm0, [rcx + 224]
M2s_a8ee
M2s_abb
    vfmadd231ps ymm7, ymm0, [rcx + 256]
M2s_a8f0
M2s_a8f1
    vfmadd231ps ymm7, ymm0, [rcx + 288]
M2s_a8f2
M2s_a8f3
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_a8f4
M2s_a8f5
    vfmadd231ps ymm7, ymm0, [rcx + 352]
M2s_a8f7
M2s_a8f8
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_a8f9
M2s_a8fb
M2s_a8de
M2s_a20
M2s_a27
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 192]
M2s_a2b
M2s_a2e
M2s_a8e7
M2s_a50
M2s_a5b
M2s_a8ea
M2s_a8ef
M2s_a8f6
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 192]
M2s_acd
M2s_ad4
M2s_a8fc
M2s_afc
M2s_a105
M2s_a8ff
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a902
M2s_a8f7
M2s_a8f8
M2s_a903
M2s_a8fa
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
