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
global xav_q2_0_6_4
align 64
xav_q2_0_6_4:
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
M2p_a998
    vpermps ymm1, ymm9, [r8 + 76]
M2p_a99d
M2p_a9b3
M2p_a9c2
    vpermps ymm0, ymm8, [r8 + 20]
    vpermps ymm1, ymm8, [r8 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r8 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r8 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 160]
M2p_a99e
    vmulps ymm5, ymm0, [rcx + 192]
M2p_a9a0
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [rax + 100]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 224]
M2p_a9a1
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [rax + 104]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2p_a9a2
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [rax + 108]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2p_a9c6
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [rax + 112]
    vblendvps ymm0, ymm0, ymm1, ymm13
M2p_a9f0
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2p_af5
M2p_a951
M2p_a9b1
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r9 + 72]
M2p_a9a6
M2p_a9a8
M2p_a9bc
M2p_a9ca
    vpermps ymm0, ymm8, [r9 + 20]
    vpermps ymm1, ymm8, [r9 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r9 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r9 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 160]
M2p_a9a9
M2p_a9ee
M2p_a9f0
M2p_a9f1
M2p_a955
M2p_a970
M2p_a9ac
M2p_a9ae
M2p_a9cb
    vpermps ymm1, ymm10, [r15 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 128]
    vpermps ymm0, ymm8, [r15 + 20]
    vpermps ymm1, ymm8, [r15 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r15 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r15 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 160]
M2p_a9b0
M2p_a9ee
M2p_a9f0
M2p_a9f1
M2p_a1e4
M2p_a97a
M2p_a99a
M2p_a99c
M2p_a99d
M2p_a9b3
M2p_a9c2
M2p_a9ed
M2p_a9ef
M2p_a9f0
M2p_a9f1
M2p_a91f
M2p_a97e
M2p_a9a4
M2p_a9a7
M2p_a9c9
    vpermps ymm1, ymm10, [r9 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 128]
M2p_a9f2
M2p_a9ef
M2p_a9f0
M2p_a9f1
M2p_a920
M2p_a970
M2p_a9ac
M2p_a9ae
M2p_a9cb
M2p_a9f3
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
    shl ecx, 3
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
