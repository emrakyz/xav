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
global xav_q2_2_2_2
align 64
xav_q2_2_2_2:
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
M2p_a2f
    lea r13, [r9 + r10*8]
    cmp dword [r15 + Pc_sg], 33288
    jne .bg0
    vbroadcastss ymm12, [r15 + Pc_w + 0]
    vbroadcastss ymm13, [r15 + Pc_w + 0 + 4]
    vmovups ymm15, [r8 + 0]
    vmulps ymm0, ymm15, ymm12
    vmulps ymm4, ymm15, ymm13
    vmovups ymm15, [r8 + 32]
    vmulps ymm1, ymm15, ymm12
    vmulps ymm5, ymm15, ymm13
    vmovups ymm15, [r8 + 64]
    vmulps ymm2, ymm15, ymm12
    vmulps ymm6, ymm15, ymm13
    vmovups ymm15, [r8 + 96]
    vmulps ymm3, ymm15, ymm12
    vmulps ymm7, ymm15, ymm13
    vbroadcastss ymm12, [r15 + Pc_w + 12]
    vbroadcastss ymm13, [r15 + Pc_w + 12 + 4]
    vmovups ymm15, [r8 + 192]
M2p_a944
    vmovups ymm15, [r8 + 224]
M2p_a945
    vmovups ymm15, [r8 + 256]
M2p_a946
    vmovups ymm15, [r8 + 288]
M2p_a947
    vbroadcastss ymm12, [r15 + Pc_w + 24]
    vbroadcastss ymm13, [r15 + Pc_w + 24 + 4]
    vmovups ymm15, [r8 + 384]
M2p_a260
    vmulps ymm0, ymm15, ymm13
    vmovups ymm15, [r8 + 416]
M2p_a262
    vmulps ymm1, ymm15, ymm13
    vmovups ymm15, [r8 + 448]
M2p_a264
    vmulps ymm2, ymm15, ymm13
    vmovups ymm15, [r8 + 480]
M2p_a267
    vmulps ymm3, ymm15, ymm13
M2p_a36
M2p_a38
M2p_a926
M2p_a33
M2p_a39
M2p_a47
M2p_a4f
M2p_a44
M2p_a54
M2p_a59
    mov rdx, [rdi + G_hx]
M2p_aaba
M2p_a929
    vpermps ymm1, ymm8, [r8 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vmulps ymm4, ymm0, ymm9
    vmulps ymm5, ymm0, ymm10
M2p_a92e
M2p_aabd
    vpermps ymm1, ymm8, [r9 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vmulps ymm4, ymm0, ymm9
    vmulps ymm5, ymm0, ymm10
M2p_a933
M2p_aabf
    vpermps ymm1, ymm8, [r15 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vmulps ymm4, ymm0, ymm9
    vmulps ymm5, ymm0, ymm10
M2p_a93a
M2p_aac1
M2p_aacb
M2p_aac2
M2p_aace
M2p_aac3
M2p_aad0
M2p_aac4
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
