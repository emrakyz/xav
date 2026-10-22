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
global xav_q2_0_7_5
align 64
xav_q2_0_7_5:
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
M2p_a62
M2p_a64
M2p_a9cd
M2p_a7e
M2p_a82
M2p_a9eb
M2p_a9f5
M2p_a97
    vfmadd231ps ymm4, ymm0, ymm6
M2p_a9cf
M2p_a9d1
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [rax + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, ymm7
M2p_a9d2
M2p_a9d3
    vpermps ymm1, ymm3, [rax + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2p_a9d5
M2p_a9d6
    vpermps ymm1, ymm3, [rax + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2p_a9d7
M2p_a9d8
    vpermps ymm1, ymm3, [rax + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2p_a9d9
M2p_a9df
    vpermps ymm1, ymm3, [rax + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2p_a9fb
M2p_a9fc
M2p_aa31
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2p_af4
M2p_afd
M2p_a108
M2p_a109
M2p_aa01
M2p_a13e
M2p_a144
    vpermps ymm1, ymm3, [r9 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm6
M2p_a9e4
M2p_a9d1
M2p_aa2e
M2p_a9fb
M2p_a9fc
M2p_aa31
M2p_aa33
M2p_a527
M2p_a9e6
M2p_a18b
M2p_a191
M2p_aa02
M2p_a1b1
    vfmadd231ps ymm4, ymm0, ymm6
M2p_a9e9
M2p_a9d1
M2p_aa2e
M2p_a9fb
M2p_a9fc
M2p_aa31
M2p_aa33
M2p_a1e1
M2p_a1e8
M2p_a63
    vmovdqu ymm3, [rdx + 96]
M2p_a9cd
M2p_a7e
M2p_a82
M2p_a9eb
M2p_a9f5
M2p_a97
M2p_aa2d
M2p_a9dc
M2p_a9e0
M2p_aa30
M2p_af6
M2p_a1ec
M2p_af9
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 128]
M2p_a106
M2p_a10e
M2p_a110
M2p_a9e2
M2p_a12c
M2p_a13b
M2p_a142
    vmovdqu ymm3, [rdx + 96]
M2p_aa35
M2p_a9d9
M2p_a9df
M2p_aa2f
M2p_aa34
M2p_a1ef
M2p_a179
M2p_a181
M2p_a182
M2p_a9e7
M2p_a1a0
M2p_a1b2
M2p_a1b5
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r15 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_aa36
M2p_a9dc
M2p_a9e0
M2p_aa30
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
