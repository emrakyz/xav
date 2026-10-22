%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_7_5_pft: dq xav_g2_0_7_5.pf1, xav_g2_0_7_5.pf2, xav_g2_0_7_5.pf3, xav_g2_0_7_5.pf4, xav_g2_0_7_5.pf5, xav_g2_0_7_5.pf6, xav_g2_0_7_5.pf7, xav_g2_0_7_5.pf8, xav_g2_0_7_5.pf9, xav_g2_0_7_5.pf10, xav_g2_0_7_5.pf11, xav_g2_0_7_5.pf12, xav_g2_0_7_5.pf13, xav_g2_0_7_5.pf14, xav_g2_0_7_5.pf15, xav_g2_0_7_5.pf16, xav_g2_0_7_5.pf17, xav_g2_0_7_5.pf18, xav_g2_0_7_5.pf19, xav_g2_0_7_5.pf20, xav_g2_0_7_5.pf21, xav_g2_0_7_5.pf22, xav_g2_0_7_5.pf23, xav_g2_0_7_5.pf24, xav_g2_0_7_5.pf25, xav_g2_0_7_5.pf26, xav_g2_0_7_5.pf27, xav_g2_0_7_5.pf28, xav_g2_0_7_5.pf29, xav_g2_0_7_5.pf30, xav_g2_0_7_5.pf31, xav_g2_0_7_5.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_7_5
align 64
xav_g2_0_7_5:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_7_5_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a1a
M2s_a24
M2s_a88d
M2s_a53
M2s_a57
    vpermps ymm1, ymm3, [r8 + 148]
M2s_a5e
    vfmadd231ps ymm4, ymm0, [rcx + 192]
M2s_a890
M2s_a892
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 224]
M2s_a894
M2s_a895
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2s_a897
M2s_a898
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2s_a899
M2s_a89a
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_a89b
M2s_a89d
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2s_a8af
M2s_a8b0
    vpermps ymm1, ymm3, [r13 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_a8d5
M2s_a8d7
    vpermps ymm1, ymm3, [r13 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_abe
M2s_acd
M2s_ad9
M2s_adc
M2s_a8a0
M2s_afc
M2s_a10e
M2s_a112
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 192]
M2s_a8a2
M2s_a892
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 224]
M2s_a894
M2s_a895
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 256]
M2s_a897
M2s_a898
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 288]
M2s_a899
M2s_a89a
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_a89b
M2s_a89d
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 352]
M2s_a8af
M2s_a8b0
    vpermps ymm1, ymm3, [r13 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_a8d5
M2s_a8d7
    vpermps ymm1, ymm3, [r13 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_a140
M2s_a22
M2s_a2c
M2s_a2d
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 132]
M2s_a31
M2s_a3c
M2s_a40
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 140]
M2s_a45
M2s_a51
M2s_a56
    vmovdqu ymm3, [rdx + 96]
M2s_a8d3
M2s_a899
M2s_a89a
M2s_a8d4
M2s_acd
M2s_ad9
M2s_adc
M2s_a8a0
M2s_afc
M2s_a10e
M2s_a112
M2s_a8da
M2s_a8db
M2s_a8d6
M2s_a8d8
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
