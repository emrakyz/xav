%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_9_8_pft: dq xav_g2_0_9_8.pf1, xav_g2_0_9_8.pf2, xav_g2_0_9_8.pf3, xav_g2_0_9_8.pf4, xav_g2_0_9_8.pf5, xav_g2_0_9_8.pf6, xav_g2_0_9_8.pf7, xav_g2_0_9_8.pf8, xav_g2_0_9_8.pf9, xav_g2_0_9_8.pf10, xav_g2_0_9_8.pf11, xav_g2_0_9_8.pf12, xav_g2_0_9_8.pf13, xav_g2_0_9_8.pf14, xav_g2_0_9_8.pf15, xav_g2_0_9_8.pf16, xav_g2_0_9_8.pf17, xav_g2_0_9_8.pf18, xav_g2_0_9_8.pf19, xav_g2_0_9_8.pf20, xav_g2_0_9_8.pf21, xav_g2_0_9_8.pf22, xav_g2_0_9_8.pf23, xav_g2_0_9_8.pf24, xav_g2_0_9_8.pf25, xav_g2_0_9_8.pf26, xav_g2_0_9_8.pf27, xav_g2_0_9_8.pf28, xav_g2_0_9_8.pf29, xav_g2_0_9_8.pf30, xav_g2_0_9_8.pf31, xav_g2_0_9_8.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_9_8
align 64
xav_g2_0_9_8:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_9_8_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a18
M2s_a33
M2s_a52
M2s_a72
    vfmadd231ps ymm4, ymm0, [rcx + 256]
M2s_a86
M2s_a8b
    vmulps ymm5, ymm0, [rcx + 288]
M2s_a8f
M2s_a92
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_a95
M2s_a98
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2s_a9b
M2s_aa0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_aa3
M2s_aa5
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_aa6
M2s_aa7
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_aa9
M2s_aab
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_aac
M2s_aae
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_aaf
M2s_ab6
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 256]
M2s_a92a
M2s_ac5
M2s_ae6
M2s_a10a
M2s_a12b
M2s_a132
    vfmadd231ps ymm6, ymm0, [rcx + 256]
M2s_a139
M2s_a8b
    vmulps ymm7, ymm0, [rcx + 288]
M2s_a8f
M2s_a92
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_a95
M2s_a98
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 352]
M2s_a9b
M2s_aa0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_aa3
M2s_aa5
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_aa6
M2s_aa7
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_aa9
M2s_aab
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_aac
M2s_aae
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_aaf
M2s_ab6
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 256]
M2s_a92f
M2s_a143
M2s_a30
M2s_a4a
M2s_a6d
M2s_a79
M2s_a86
M2s_a8b
M2s_a930
M2s_a9f
M2s_a931
M2s_aaa
M2s_a932
M2s_ac7
M2s_ae7
M2s_a10c
M2s_a12c
M2s_a133
M2s_a139
M2s_a8b
M2s_a933
M2s_a9f
M2s_a934
M2s_aaa
M2s_a935
M2s_ab1
M2s_a92e
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
M2s_a6c0
M2s_a1e0
M2s_a1e9
M2s_a1f4
M2s_a162
M2s_a167
M2s_a200
M2s_a17e
M2s_a20b
M2s_a192
M2s_a213
M2s_a1a8
M2s_a1b6
M2s_a218
M2s_a1a2
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
