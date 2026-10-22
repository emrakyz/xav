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
global xav_q2_0_4_4
align 64
xav_q2_0_4_4:
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
M2p_a56
M2p_a5a
M2p_a914
    vmovdqu ymm9, [rdx + 32]
    vmovdqu ymm10, [rdx + 64]
    vmovdqu ymm11, [rdx + 96]
    vmovdqu ymm12, [rdx + 128]
    vmovdqu ymm13, [rdx + 160]
    vmovups ymm6, [rcx + 0]
    vmovups ymm7, [rcx + 32]
    vmovups ymm3, [rcx + 64]
M2p_a5d
M2p_a5e
M2p_a5f
M2p_a92b
    vpermps ymm1, ymm9, [r8 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r8 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vmulps ymm4, ymm0, ymm6
M2p_a962
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r8 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, ymm7
M2p_a964
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r8 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, ymm3
M2p_a98d
M2p_a99d
M2p_a99e
    vmulps ymm5, ymm0, [rcx + 128]
M2p_a9a0
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [rax + 100]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 160]
M2p_a9a1
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [rax + 104]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 192]
M2p_a9a2
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [rax + 108]
    vblendvps ymm0, ymm0, ymm1, ymm13
M2p_a986
M2p_a97e
    vpermps ymm1, ymm10, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vmulps ymm4, ymm0, ymm6
M2p_a96d
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r9 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, ymm7
M2p_a96e
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r9 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, ymm3
M2p_a994
M2p_a9a8
    lea rax, [r9 + r14]
M2p_a99f
M2p_af5
M2p_a935
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r15 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r15 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vmulps ymm4, ymm0, ymm6
M2p_a975
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r15 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, ymm7
M2p_a977
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r15 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, ymm3
M2p_a997
M2p_a9af
    lea rax, [r15 + r14]
M2p_a99f
M2p_a1dc
M2p_a91e
M2p_a97c
M2p_a99b
M2p_a93c
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r9 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm9
M2p_a9a5
M2p_a93f
M2p_a9aa
M2p_a1df
M2p_a1e6
M2p_a1f4
M2p_a1fd
M2p_a205
M2p_a214
M2p_a21e
M2p_a228
M2p_a22d
M2p_a231
M2p_a209
M2p_a20d
M2p_a471
M2p_a218
M2p_a221
M2p_a52d
M2p_a236
M2p_a23a
M2p_a574
M2p_a69e
M2p_a241
M2p_a245
M2p_a24a
M2p_a24f
M2p_a254
M2p_a25b
M2p_a268
M2p_a271
M2p_af
M2p_a27b
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
