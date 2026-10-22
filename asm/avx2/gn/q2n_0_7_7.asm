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
global xav_q2_0_7_7
align 64
xav_q2_0_7_7:
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
    vpermps ymm1, ymm3, [r8 + 200]
M2p_a7d
M2p_a83
    vpermps ymm1, ymm3, [r8 + 204]
M2p_a87
M2p_a8a
    vpermps ymm1, ymm3, [r8 + 208]
M2p_a8f
M2p_a95
    vpermps ymm1, ymm3, [r8 + 212]
M2p_a97
M2p_a9d
    vpermps ymm1, ymm3, [r8 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm6
    lea rax, [r8 + r14]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [rax + 0]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [rax + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_ae6
M2p_ae8
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [rax + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, ymm7
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [rax + 4]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [rax + 36]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_aed
M2p_aef
    vmovdqu ymm3, [rdx + 352]
M2p_aa50
M2p_aa59
M2p_aa5f
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [rax + 216]
M2p_aa32
M2p_afb
M2p_a104
M2p_a107
M2p_a10c
M2p_a10d
M2p_a112
    vpermps ymm1, ymm3, [r9 + 200]
M2p_a117
M2p_a121
    vpermps ymm1, ymm3, [r9 + 204]
M2p_a124
M2p_a129
    vpermps ymm1, ymm3, [r9 + 208]
M2p_a12c
M2p_a136
    vpermps ymm1, ymm3, [r9 + 212]
M2p_a13a
M2p_a148
    vpermps ymm1, ymm3, [r9 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm6
    lea rax, [r9 + r14]
M2p_aa4e
M2p_aa55
M2p_aa5e
M2p_aa64
M2p_a16c
M2p_a177
M2p_a179
M2p_a17e
    vpermps ymm1, ymm3, [r15 + 196]
M2p_a180
M2p_a185
    vpermps ymm1, ymm3, [r15 + 200]
M2p_a18a
M2p_a192
    vpermps ymm1, ymm3, [r15 + 204]
M2p_a196
M2p_a19d
    vpermps ymm1, ymm3, [r15 + 208]
M2p_a1a0
M2p_a1ad
    vpermps ymm1, ymm3, [r15 + 212]
M2p_a1b1
M2p_a1b8
    vpermps ymm1, ymm3, [r15 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm6
    lea rax, [r15 + r14]
M2p_aa4e
M2p_aa55
M2p_aa5e
M2p_aa63
M2p_a1de
M2p_a67
    vpermps ymm1, ymm3, [r8 + 192]
M2p_a6c
M2p_a71
    vpermps ymm1, ymm3, [r8 + 196]
M2p_a73
M2p_a78
M2p_aa4a
M2p_a97
M2p_a9d
M2p_aa4c
M2p_aa53
M2p_aa5c
M2p_aa60
M2p_af6
M2p_a1ed
M2p_a103
M2p_a106
M2p_a10b
    vpermps ymm1, ymm3, [r9 + 196]
M2p_a10d
M2p_a112
M2p_aa65
M2p_a13a
M2p_a148
M2p_aa68
M2p_aa53
M2p_aa5c
M2p_aa60
M2p_af6
M2p_a1f1
M2p_a177
M2p_a179
M2p_a17e
M2p_aa6a
M2p_a1a0
M2p_a1ad
M2p_aa6d
M2p_aa50
M2p_aa59
M2p_aa5f
M2p_aa62
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
    lea rdx, [rdx + r11*2]
M2p_a281
M2p_a1b
M2p_a288
M2p_a75c
M2p_a29b
M2p_a297
M2p_a2a5
M2p_a2a9
M2p_a2af
M2p_a2b5
M2p_a2c2
M2p_a2cf
M2p_a2de
M2p_a2e5
M2p_a2ee
M2p_a2f5
M2p_a306
M2p_a2f8
M2p_a30d
M2p_a311
M2p_a319
M2p_a2fc
M2p_a307
M2p_a313
M2p_a31f
M2p_a2bf
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
M2p_a475
M2p_a387
M2p_a38c
M2p_a391
M2p_a396
M2p_a39b
M2p_a3a0
M2p_a3a9
M2p_a3b0
M2p_a3b6
M2p_a3bd
M2p_a3c4
M2p_a3ca
M2p_a3d0
M2p_a3d7
M2p_a3dd
M2p_a3e3
M2p_a3e7
section .note.GNU-stack noalloc noexec nowrite progbits
