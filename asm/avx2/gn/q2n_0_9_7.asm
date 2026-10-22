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
global xav_q2_0_9_7
align 64
xav_q2_0_9_7:
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
M2p_a61
M2p_a6b
M2p_a6e
M2p_a72
M2p_a73
M2p_a78
M2p_aa4a
M2p_a97
M2p_a9d
M2p_aa86
M2p_aa4
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 220]
M2p_aa7
M2p_aaa
    vpermps ymm1, ymm3, [r8 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 256]
M2p_aa4d
M2p_ae9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 288]
M2p_aa4f
M2p_af0
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2p_aa51
M2p_aa52
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2p_aa54
M2p_aa56
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2p_aa57
M2p_aa58
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2p_aa5a
M2p_aa5b
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2p_aa5d
M2p_aa61
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2p_aa8f
M2p_aa93
    vfmadd231ps ymm5, ymm0, [rcx + 512]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [rax + 32]
M2p_aa09
M2p_aa0a
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [rax + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [rax + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2p_af4
M2p_afc
    vpermps ymm1, ymm3, [r9 + 192]
M2p_a106
M2p_a10b
M2p_aa71
M2p_a12c
M2p_a136
M2p_aa67
M2p_a147
M2p_aa9a
M2p_a150
M2p_a157
M2p_a15e
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 256]
M2p_aa69
M2p_ae9
M2p_aaa4
M2p_aaa7
M2p_aa8f
M2p_aa93
M2p_aaaa
M2p_aaac
M2p_a527
M2p_a171
M2p_a17b
M2p_a17f
M2p_a180
M2p_a185
M2p_aa6b
M2p_a1b1
M2p_a1b8
M2p_aa97
M2p_a1c2
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r15 + 220]
M2p_a1c7
M2p_a1ce
    vpermps ymm1, ymm3, [r15 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 256]
M2p_aa6f
M2p_ae9
M2p_aaa4
M2p_aaa7
M2p_aa8f
M2p_aa93
M2p_aaaa
M2p_aaac
M2p_a1e0
M2p_a69
M2p_a6c
M2p_a71
M2p_aa70
M2p_a8f
M2p_a95
M2p_aa4b
M2p_a9c
    vmovdqu ymm3, [rdx + 160]
M2p_aa86
M2p_aa4
M2p_aaa3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [rax + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_aaa5
M2p_aa5a
M2p_aa5b
M2p_aaa8
M2p_af5
M2p_a1eb
M2p_a101
M2p_aaaf
M2p_a124
M2p_a129
M2p_aa66
M2p_a145
M2p_a14b
M2p_a14e
M2p_a153
M2p_a156
M2p_a15c
    vpermps ymm1, ymm3, [r9 + 224]
M2p_aab0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_aaa6
M2p_aa5d
M2p_aa61
M2p_aaa9
M2p_aa0a
M2p_aaab
M2p_af6
M2p_a1f1
M2p_a177
M2p_a179
M2p_a17e
M2p_aa6a
M2p_a1a0
M2p_a1ad
M2p_aa6e
M2p_a1b7
M2p_aa96
M2p_a1c1
M2p_a1c8
M2p_a1cf
M2p_aab1
M2p_aab2
M2p_aaa8
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
