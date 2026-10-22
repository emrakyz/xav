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
global xav_q2_0_6_6
align 64
xav_q2_0_6_6:
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
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 164]
M2p_a73
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 168]
M2p_a7d
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 172]
M2p_a87
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 176]
M2p_a8f
M2p_aa05
M2p_aa07
    vpermps ymm1, ymm3, [rax + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, ymm6
M2p_aa0b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, ymm7
M2p_aa0c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2p_aa0d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2p_aa14
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2p_aa16
M2p_a9fe
M2p_afb
M2p_a106
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 164]
M2p_a10d
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 168]
M2p_a117
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 172]
M2p_a124
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 176]
M2p_a12c
M2p_aa22
    lea rax, [r9 + r14]
M2p_aa08
M2p_aa12
M2p_aa1a
M2p_a16b
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r15 + 160]
M2p_a179
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r15 + 164]
M2p_a180
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r15 + 168]
M2p_a18a
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r15 + 172]
M2p_a196
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r15 + 176]
M2p_a1a0
M2p_aa28
    lea rax, [r15 + r14]
M2p_aa08
M2p_aa12
M2p_aa19
M2p_aa1d
M2p_a1da
M2p_a65
M2p_a6e
M2p_aa04
M2p_a92
M2p_aa06
M2p_aa10
M2p_aa18
M2p_af5
M2p_a1eb
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 160]
M2p_a106
M2p_aa1e
M2p_a130
M2p_aa21
M2p_aa0f
M2p_aa17
M2p_a9f1
M2p_a1ef
M2p_a172
M2p_a17b
M2p_aa26
M2p_a1a7
M2p_aa29
M2p_aa10
M2p_aa18
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
    mov [r10 + r11*4 + 262144], eax
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
