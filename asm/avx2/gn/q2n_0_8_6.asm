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
global xav_q2_0_8_6
align 64
xav_q2_0_8_6:
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
M2p_a6c
M2p_aa03
M2p_a91
M2p_aa05
M2p_a98
M2p_aa1
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm7
M2p_aa07
    vpermps ymm1, ymm3, [rax + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 256]
M2p_aa0b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2p_aa0c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2p_aa0d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2p_aa14
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2p_aa16
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2p_aa3c
M2p_aa78
M2p_aa7d
M2p_af4
M2p_afd
M2p_aa2b
M2p_a126
M2p_aa20
M2p_a134
M2p_a13a
M2p_aa47
M2p_a14f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm7
M2p_aa23
M2p_aa74
M2p_aa15
    vpermps ymm1, ymm3, [rax + 176]
M2p_aa77
M2p_aa3f
M2p_aa78
M2p_aa7c
M2p_a16b
M2p_aa24
M2p_a199
M2p_aa27
M2p_a1ab
M2p_a1b1
M2p_aa49
M2p_a1bf
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm7
M2p_aa2a
M2p_aa74
M2p_aa15
M2p_aa83
M2p_aa3e
    vpermps ymm1, ymm3, [rax + 184]
M2p_aa78
M2p_aa7d
M2p_a1da
M2p_a65
M2p_a6e
M2p_aa04
M2p_a92
    vpermps ymm1, ymm3, [r8 + 180]
M2p_a97
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 184]
M2p_aa1
M2p_aa73
M2p_aa0e
M2p_aa13
M2p_aa76
M2p_aa7b
M2p_aa81
M2p_a1e9
M2p_afe
M2p_a107
M2p_aa1f
M2p_a132
    vpermps ymm1, ymm3, [r9 + 180]
M2p_a13a
M2p_aa47
M2p_a14f
M2p_aa82
M2p_aa11
    vpermps ymm1, ymm3, [rax + 172]
M2p_aa75
M2p_aa7a
M2p_aa80
M2p_a9ec
M2p_a170
M2p_a179
M2p_aa25
M2p_a1a5
M2p_aa28
M2p_a1b3
M2p_a1bd
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r15 + 188]
M2p_aa84
M2p_aa11
M2p_aa85
M2p_aa79
M2p_aa7e
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
