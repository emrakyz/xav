%include "q2nm.inc"
default rel
%use smartalign
alignmode p6, 32
%include "gq2o.inc"
%include "gqimg.inc"
M2p_a0
M2p_a1
M2p_a2
M2p_a3
M2p_a4
M2p_a5
global xav_q2_0_9_8
align 64
xav_q2_0_9_8:
M2p_a6
M2p_a8
M2p_aa
M2p_ab
M2p_ac
M2p_a20
M2p_a2c
M2p_a22
M2p_a18
M2p_a13
M2p_a23
M2p_a2b
M2p_a2d
M2p_a2e
M2p_a32
M2p_a35
M2p_a3e
M2p_a4b
M2p_a46
M2p_a55
M2p_a60
M2p_a79
M2p_a94
M2p_aa8
M2p_aac
M2p_ab4
M2p_ab9
    vmulps ymm5, ymm0, [rcx + 288]
M2p_abe
M2p_ac2
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2p_ac5
M2p_aca
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2p_acc
M2p_ad3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2p_ad6
M2p_ad7
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2p_ad8
M2p_adb
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2p_add
M2p_adf
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2p_ae0
M2p_ae3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2p_ae5
M2p_aec
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 256]
M2p_aaad
M2p_afa
M2p_a11a
M2p_a137
M2p_a15a
M2p_a16a
M2p_ab9
M2p_aab3
M2p_ad2
M2p_aab5
M2p_ade
M2p_aab7
M2p_ae7
M2p_aaae
M2p_a44d
M2p_a174
M2p_a18e
M2p_a1b0
M2p_a1cc
    vpermps ymm1, ymm3, [r15 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 256]
M2p_a1d9
M2p_ab9
M2p_aab3
M2p_ad2
M2p_aab5
M2p_ade
M2p_aab7
M2p_ae7
M2p_aaae
M2p_a1e3
M2p_a75
M2p_a8d
M2p_aa3
M2p_aac
M2p_ab4
M2p_ab9
M2p_aab3
M2p_ad2
M2p_aab5
M2p_ade
M2p_aab7
M2p_ae7
M2p_aaae
M2p_a1ea
M2p_a111
M2p_a12f
M2p_a155
M2p_a15b
    vpermps ymm1, ymm3, [r9 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 256]
M2p_a16a
M2p_ab9
M2p_aab3
M2p_ad2
M2p_aab5
M2p_ade
M2p_aab7
M2p_ae7
M2p_aaae
M2p_a1ee
M2p_a184
M2p_a1a4
M2p_a1c6
M2p_a1cc
M2p_aab9
M2p_ac8
M2p_aab4
M2p_ada
M2p_aab6
M2p_aea
M2p_aab8
M2p_a1db
M2p_a1f3
M2p_a1fa
M2p_a1fc
M2p_a204
M2p_a213
M2p_a21d
M2p_a227
M2p_a22c
M2p_a230
M2p_a208
M2p_a20c
M2p_a470
M2p_a217
M2p_a220
M2p_a69d
M2p_a235
M2p_a239
M2p_a912
M2p_a9f4
M2p_aa2c
M2p_a244
M2p_a249
M2p_a24e
M2p_a253
M2p_a25a
M2p_a265
M2p_a270
M2p_ae
M2p_a27a
M2p_aa72
M2p_a1a
M2p_a287
M2p_aaa2
M2p_a299
M2p_a296
M2p_a2a4
M2p_a2a8
M2p_a2ae
M2p_a2b4
M2p_a2c1
M2p_a2ce
M2p_a2dd
M2p_a2e4
M2p_a2ed
M2p_a2f4
M2p_a305
M2p_a2f7
M2p_a30c
M2p_a31c
M2p_a2ff
M2p_a30a
M2p_a31e
M2p_a2be
M2p_a474
M2p_a322
M2p_a326
M2p_a32c
M2p_a330
M2p_a335
M2p_a339
M2p_a33d
M2p_a341
M2p_a345
M2p_a34a
M2p_a34e
M2p_a360
M2p_a36a
M2p_a357
M2p_a35f
M2p_a372
M2p_a374
M2p_a35a
M2p_a37a
M2p_a37c
M2p_a380
M2p_a382
M2p_a384
M2p_a38a
M2p_a38e
M2p_a393
M2p_a398
M2p_a39d
M2p_a3a6
M2p_a517
M2p_a3b2
M2p_a3b9
M2p_a3c0
M2p_a3c6
M2p_a3cc
M2p_a3d3
M2p_a3d9
M2p_a3df
M2p_a3a3
M2p_a3e5
M2p_a3e8
    ud2
section .note.GNU-stack noalloc noexec nowrite progbits
