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
global xav_q2_0_11_10
align 64
xav_q2_0_11_10:
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
M2p_a3eb
M2p_a477
M2p_a6c
M2p_a70
M2p_a3f0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 292]
M2p_a73
M2p_a77
M2p_a3f1
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 296]
M2p_a7d
M2p_a84
M2p_a3f2
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 300]
M2p_a87
M2p_a8b
M2p_a3f5
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 304]
M2p_a8f
M2p_a96
M2p_a3f6
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 308]
M2p_a97
M2p_a9e
M2p_a3f8
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 312]
M2p_aa1
M2p_aa5
M2p_a3f9
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 316]
M2p_aa7
M2p_aab
M2p_a3fa
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 320]
M2p_aae
M2p_ab2
M2p_a3fb
M2p_a47d
M2p_a48d
M2p_a49d
M2p_a4b1
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [rax + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 188]
M2p_a4bf
M2p_a4c2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [rax + 32]
M2p_a3ff
M2p_a402
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [rax + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [rax + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [rax + 36]
M2p_a404
M2p_a409
M2p_a4c7
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [rax + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [rax + 40]
M2p_a40c
M2p_a412
M2p_a4cb
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [rax + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2p_af4
M2p_afc
M2p_a105
M2p_a437
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 288]
M2p_a106
M2p_a10a
M2p_a43a
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 292]
M2p_a10d
M2p_a113
M2p_a43b
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 296]
M2p_a117
M2p_a120
M2p_a43c
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 300]
M2p_a124
M2p_a128
M2p_a440
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 304]
M2p_a12c
M2p_a135
M2p_a441
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 308]
M2p_a13a
M2p_a149
M2p_a442
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 312]
M2p_a14d
M2p_a151
M2p_a446
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 316]
M2p_a156
M2p_a15d
M2p_a447
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 320]
M2p_a161
M2p_a167
M2p_a448
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 324]
M2p_a4d8
M2p_a4db
M2p_a4e0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 320]
    lea rax, [r9 + r14]
M2p_a487
M2p_a496
M2p_a4a8
M2p_a4b7
M2p_a401
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [rax + 256]
M2p_a4c4
M2p_a4ce
M2p_a16b
M2p_a176
M2p_a450
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r15 + 288]
M2p_a179
M2p_a17d
M2p_a452
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r15 + 292]
M2p_a180
M2p_a186
M2p_a454
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r15 + 296]
M2p_a18a
M2p_a193
M2p_a457
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r15 + 300]
M2p_a196
M2p_a19c
M2p_a458
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r15 + 304]
M2p_a1a0
M2p_a1ac
M2p_a45b
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r15 + 308]
M2p_a1b1
M2p_a1b9
M2p_a45c
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r15 + 312]
M2p_a1bd
M2p_a1c3
M2p_a45f
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r15 + 316]
M2p_a1c7
M2p_a1cd
M2p_a461
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r15 + 320]
M2p_a1d3
M2p_a1d7
M2p_a462
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r15 + 324]
M2p_a4ed
M2p_a4f2
M2p_a4f9
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r15 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 320]
    lea rax, [r15 + r14]
M2p_a487
M2p_a496
M2p_a4a8
M2p_a4b7
M2p_a401
M2p_a4e4
M2p_a4cc
M2p_a1e0
M2p_a6a
    vmovdqu ymm3, [rdx + 224]
M2p_a476
M2p_a7d
M2p_a84
M2p_a3f2
M2p_a47a
M2p_a98
M2p_a9f
    vmovdqu ymm3, [rdx + 192]
M2p_a465
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a47b
M2p_aaf
M2p_ab3
    vmovdqu ymm3, [rdx + 192]
M2p_a467
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a47d
M2p_a48d
M2p_a49d
M2p_a4b1
M2p_a4be
M2p_a406
M2p_a4c8
M2p_a4cd
M2p_a1e9
M2p_aff
M2p_a435
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a4d1
M2p_a11b
M2p_a123
    vmovdqu ymm3, [rdx + 192]
M2p_a469
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a4d3
M2p_a13d
M2p_a14b
    vmovdqu ymm3, [rdx + 192]
M2p_a46a
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a4d5
M2p_a163
M2p_a169
    vmovdqu ymm3, [rdx + 192]
M2p_a46b
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a4d7
M2p_a48d
M2p_a49d
M2p_a4b1
M2p_a4be
M2p_a406
M2p_a4c8
M2p_a4cd
M2p_a1ef
M2p_a173
    vpermps ymm1, ymm3, [r15 + 224]
M2p_a450
M2p_a4e6
M2p_a18d
M2p_a195
    vmovdqu ymm3, [rdx + 192]
M2p_a46c
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a4e8
M2p_a1b3
M2p_a1ba
    vmovdqu ymm3, [rdx + 192]
M2p_a46e
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a4ea
M2p_a1d4
M2p_a1d8
    vmovdqu ymm3, [rdx + 192]
M2p_a46f
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a4ec
M2p_a48d
M2p_a49d
M2p_a4b1
M2p_a4be
M2p_a406
M2p_a4c8
M2p_a4cd
M2p_a1f2
M2p_a1f9
M2p_a1fb
M2p_a203
M2p_a212
M2p_a21c
M2p_a226
M2p_a22b
M2p_a22f
M2p_a207
M2p_a20b
M2p_a20f
M2p_a232
M2p_a21a
M2p_a223
M2p_a233
M2p_a238
M2p_a23c
M2p_a23e
M2p_a45
M2p_a49
M2p_a240
M2p_a51
M2p_a41
M2p_a243
M2p_a248
M2p_a24c
M2p_a251
M2p_a256
M2p_a25e
M2p_a473
M2p_a26c
M2p_a277
M2p_a289
M2p_a1d
M2p_a26
M2p_a283
M2p_a286
M2p_a1c
M2p_a28d
M2p_a29e
M2p_a29a
M2p_a2a3
M2p_a2a7
M2p_a2ad
M2p_a2b3
M2p_a2c0
M2p_a2cd
M2p_a2dc
M2p_a2e3
M2p_a2ec
M2p_a2f3
M2p_a304
M2p_a2f6
M2p_a30b
M2p_a31b
M2p_a2fe
M2p_a309
M2p_a31d
M2p_a2bd
    div r11
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
    vaddpd ymm6, ymm4, ymm5
M2p_a3e6
M2p_a3ad
M2p_a3b3
M2p_a3ba
M2p_a3c1
M2p_a3c7
M2p_a3cd
M2p_a3d4
M2p_a3da
M2p_a3e0
M2p_a3ac
M2p_a3e7
section .note.GNU-stack noalloc noexec nowrite progbits
