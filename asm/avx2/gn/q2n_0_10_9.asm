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
global xav_q2_0_10_9
align 64
xav_q2_0_10_9:
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
    vpermps ymm1, ymm3, [r8 + 256]
M2p_a6c
M2p_a70
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 260]
M2p_a73
M2p_a77
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 264]
M2p_a7d
M2p_a84
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 268]
M2p_a87
M2p_a8b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 272]
M2p_a8f
M2p_a96
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 276]
M2p_a97
M2p_a9e
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 280]
M2p_aa1
M2p_aa5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 284]
M2p_aa7
M2p_aab
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 288]
M2p_aae
M2p_ab2
M2p_a3fc
M2p_a40b
M2p_a41d
    vpermps ymm1, ymm3, [rax + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2p_a42a
M2p_a42c
    vpermps ymm1, ymm3, [rax + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [rax + 32]
M2p_ab6
M2p_a42e
    vfmadd231ps ymm5, ymm0, [rcx + 576]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [rax + 36]
M2p_abf
    vpermps ymm1, ymm3, [rax + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a434
    vpermps ymm1, ymm3, [rax + 292]
M2p_af1
M2p_afb
M2p_a104
    vmovdqu ymm3, [rdx + 192]
M2p_a435
M2p_a106
M2p_a10a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 260]
M2p_a10d
M2p_a113
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 264]
M2p_a117
M2p_a120
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 268]
M2p_a124
M2p_a128
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 272]
M2p_a12c
M2p_a135
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 276]
M2p_a13a
M2p_a149
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 280]
M2p_a14d
M2p_a151
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 284]
M2p_a156
M2p_a15d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 288]
M2p_a161
M2p_a167
M2p_a448
    vfmadd231ps ymm4, ymm0, [rcx + 288]
    lea rax, [r9 + r14]
M2p_a3fe
M2p_a40e
M2p_a41f
M2p_a42b
M2p_ac2
    vmovdqu ymm3, [rdx + 416]
M2p_a432
M2p_af3
    vaddps ymm0, ymm4, ymm5
M2p_a16b
M2p_a176
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 256]
M2p_a179
M2p_a17d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 260]
M2p_a180
M2p_a186
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 264]
M2p_a18a
M2p_a193
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 268]
M2p_a196
M2p_a19c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 272]
M2p_a1a0
M2p_a1ac
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 276]
M2p_a1b1
M2p_a1b9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 280]
M2p_a1bd
M2p_a1c3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 284]
M2p_a1c7
M2p_a1cd
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r15 + 288]
M2p_a1d3
M2p_a1d7
M2p_a462
    vfmadd231ps ymm4, ymm0, [rcx + 288]
    lea rax, [r15 + r14]
M2p_a3fe
M2p_a40e
M2p_a41f
M2p_a42b
M2p_ac2
M2p_a44c
M2p_af2
M2p_a1e0
M2p_a6a
M2p_a3ef
M2p_a81
M2p_a3f3
M2p_a99
    vpermps ymm1, ymm3, [r8 + 248]
M2p_a3f7
M2p_ab1
    vpermps ymm1, ymm3, [r8 + 260]
M2p_a3fc
M2p_a40b
M2p_a41d
M2p_a429
M2p_ac0
M2p_ac3
M2p_a433
M2p_af5
M2p_a1eb
M2p_a100
M2p_a438
M2p_a11d
    vpermps ymm1, ymm3, [r9 + 236]
M2p_a43d
M2p_a140
    vpermps ymm1, ymm3, [r9 + 248]
M2p_a443
M2p_a164
    vpermps ymm1, ymm3, [r9 + 260]
M2p_a449
M2p_a40b
M2p_a41d
M2p_a429
M2p_ac0
M2p_ac3
M2p_a433
M2p_af5
M2p_a1f0
M2p_a176
M2p_a44f
M2p_a18f
    vpermps ymm1, ymm3, [r15 + 236]
M2p_a456
M2p_a1b4
    vpermps ymm1, ymm3, [r15 + 248]
M2p_a45d
M2p_a1d6
    vpermps ymm1, ymm3, [r15 + 260]
M2p_a463
M2p_a40b
M2p_a41d
M2p_a429
M2p_ac0
M2p_ac3
M2p_a433
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
    vmovups [r9 + 192], ymm11
    add r9, 288
    dec r11
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
    vaddps ymm6, ymm6, [r9 + r10*2]
M2p_a26a
M2p_a26d
M2p_a278
M2p_a280
M2p_a285
M2p_a26
M2p_a28b
M2p_a28f
M2p_a291
M2p_a2a0
M2p_a2a2
M2p_a296
M2p_a2a6
M2p_a2ac
M2p_a2b2
M2p_a2ba
M2p_a2c9
M2p_a2d8
M2p_a2e2
M2p_a2eb
M2p_a2f1
M2p_a2fb
M2p_a318
M2p_a302
M2p_a310
M2p_a314
M2p_a31c
M2p_a2ff
M2p_a30a
M2p_a31e
M2p_a2be
    mov [rbp + 5920], rax
M2p_a321
M2p_a323
M2p_a327
M2p_a32d
M2p_a331
M2p_a336
M2p_a33a
M2p_a33e
M2p_a342
M2p_a346
M2p_a34b
M2p_a34f
M2p_a361
M2p_a36c
M2p_a358
M2p_a362
M2p_a373
M2p_a375
M2p_a35b
M2p_a37b
M2p_a37d
M2p_a2c3
M2p_a381
M2p_a2d2
    add rdx, rcx
M2p_a383
M2p_a388
M2p_a389
M2p_a38d
M2p_a392
M2p_a397
M2p_a39c
M2p_a3a1
M2p_a3aa
M2p_a3b1
M2p_a3b7
M2p_a3be
M2p_a3c5
M2p_a3cb
M2p_a3d1
M2p_a3d8
M2p_a3de
M2p_a3e4
M2p_a3e9
