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
global xav_q2_0_3_3
align 64
xav_q2_0_3_3:
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
    cmp dword [r15 + Pc_sg], 798915
M2p_a921
M2p_a95b
    vaddps ymm3, ymm3, [r8 + 480]
    vmovups ymm4, [r8 + 576]
    vmovups ymm5, [r8 + 608]
    vmovups ymm6, [r8 + 640]
    vmovups ymm7, [r8 + 672]
M2p_a95c
M2p_a925
    vmovups ymm8, [r8 + 1152]
    vmovups ymm9, [r8 + 1184]
    vmovups ymm10, [r8 + 1216]
    vmovups ymm11, [r8 + 1248]
    vaddps ymm8, ymm8, [r8 + 1344]
    vaddps ymm9, ymm9, [r8 + 1376]
    vaddps ymm10, ymm10, [r8 + 1408]
    vaddps ymm11, ymm11, [r8 + 1440]
M2p_a95d
    vaddps ymm4, ymm8, [rbx + 0]
    vaddps ymm4, ymm4, [r9]
    vmovups [r13], ymm4
    vaddps ymm5, ymm9, [rbx + 32]
    vaddps ymm5, ymm5, [r9 + r10]
    vmovups [r13 + r10], ymm5
    vaddps ymm6, ymm10, [rbx + 64]
    vaddps ymm6, ymm6, [r9 + r10*2]
    vmovups [r13 + r10*2], ymm6
    vaddps ymm7, ymm11, [rbx + 96]
    vaddps ymm7, ymm7, [r9 + r11]
    vmovups [r13 + r11], ymm7
    vmovups ymm0, [r8 + 1728]
    vmovups ymm1, [r8 + 1760]
    vmovups ymm2, [r8 + 1792]
    vmovups ymm3, [r8 + 1824]
    vaddps ymm0, ymm0, [r8 + 1920]
    vaddps ymm1, ymm1, [r8 + 1952]
    vaddps ymm2, ymm2, [r8 + 1984]
    vaddps ymm3, ymm3, [r8 + 2016]
    vaddps ymm0, ymm0, [r8 + 2112]
    vaddps ymm1, ymm1, [r8 + 2144]
    vaddps ymm2, ymm2, [r8 + 2176]
    vaddps ymm3, ymm3, [r8 + 2208]
M2p_a36
M2p_a38
M2p_a926
M2p_a33
M2p_a39
M2p_a47
M2p_a4e
M2p_a95e
    vmovups ymm12, [rcx + 0]
    vmovups ymm13, [rcx + 32]
    vmovups ymm6, [rcx + 64]
    vmovups ymm7, [rcx + 96]
    vmovups ymm3, [rcx + 128]
M2p_a5d
M2p_a5e
M2p_a5f
M2p_a92b
M2p_a961
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm5, ymm0, [rcx + 160]
M2p_af5
M2p_a951
M2p_a96b
    lea rax, [r9 + r14]
M2p_a966
M2p_a96a
M2p_a526
    vpermps ymm0, ymm8, [r15 + 0]
M2p_a971
    vfmadd231ps ymm4, ymm0, ymm6
    lea rax, [r15 + r14]
M2p_a966
M2p_a96a
M2p_a1e1
    vmovaps ymm15, ymm4
    vpermps ymm0, ymm8, [r8 + 0]
    vpermps ymm1, ymm8, [r8 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm8
M2p_a961
M2p_a96a
M2p_a56c
    vpermps ymm0, ymm8, [r9 + 0]
    vpermps ymm1, ymm8, [r9 + 32]
M2p_a96c
M2p_a969
M2p_a941
M2p_a974
M2p_a96a
M2p_a62f
M2p_a1f8
    vdivps ymm5, ymm1, ymm2
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
M2p_a516
M2p_a52f
M2p_a325
M2p_a32b
M2p_a32f
M2p_a334
M2p_a338
M2p_a33c
M2p_a630
M2p_a344
M2p_a349
M2p_a34d
M2p_a35d
M2p_a369
M2p_a356
M2p_a35e
M2p_a371
M2p_a36f
M2p_a377
M2p_a35e
M2p_a379
M2p_a36f
M2p_a37f
M2p_a642
M2p_a2d1
M2p_a673
M2p_a386
M2p_a6a0
M2p_a38f
M2p_a394
M2p_a399
M2p_a39e
M2p_a3a7
M2p_a3ae
M2p_a3b4
M2p_a3bb
M2p_a3c2
M2p_a3c8
M2p_a3ce
M2p_a3d5
M2p_a3db
M2p_a3e1
M2p_a75d
M2p_a3ea