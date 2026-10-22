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
global xav_q2_0_8_8
align 64
xav_q2_0_8_8:
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
M2p_ab4
M2p_ab9
    vmulps ymm5, ymm0, [rcx + 256]
M2p_abe
M2p_ac2
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2p_ac5
M2p_aca
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2p_acc
M2p_ad3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2p_ad6
M2p_ad7
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2p_ad8
M2p_adb
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2p_add
M2p_adf
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2p_ae0
M2p_ae3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [rax + 252]
M2p_aa7f
M2p_afa
M2p_a11a
M2p_a139
M2p_a14f
M2p_a154
M2p_a16a
M2p_ab9
M2p_aa9b
M2p_ad2
M2p_aa9d
M2p_ade
M2p_aa9f
M2p_ae2
M2p_aa81
M2p_a44d
M2p_a174
M2p_a18e
M2p_a1af
M2p_a1c0
    vpermps ymm1, ymm3, [r15 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm7
M2p_a1d9
M2p_ab9
M2p_aa9b
M2p_ad2
M2p_aa9d
M2p_ade
M2p_aa9f
M2p_ae2
M2p_aa81
M2p_a1e3
M2p_a75
M2p_a8d
M2p_aa2
M2p_ab4
M2p_ab9
M2p_aa9b
M2p_ad2
M2p_aa9d
M2p_ade
M2p_aa9f
M2p_ae2
M2p_aa81
M2p_a1ea
M2p_a111
M2p_a12f
    vpermps ymm1, ymm3, [r9 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm7
M2p_a16a
M2p_ab9
M2p_aa9b
M2p_ad2
M2p_aa9d
M2p_ade
M2p_aa9f
M2p_ae2
M2p_aa81
M2p_a1ee
M2p_a184
M2p_a1a4
M2p_aaa1
M2p_ac8
M2p_aa9c
M2p_ada
M2p_aa9e
M2p_ae1
M2p_aaa0
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
    vfmadd231ps ymm0, ymm1, ymm13
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
