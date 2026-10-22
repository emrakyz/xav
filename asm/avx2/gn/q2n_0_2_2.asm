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
global xav_q2_0_2_2
align 64
xav_q2_0_2_2:
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
    cmp dword [r15 + Pc_sg], 299081
M2p_a921
    vmovups ymm3, [r8 + 96]
M2p_a923
    vaddps ymm6, ymm6, [r8 + 448]
    vaddps ymm7, ymm7, [r8 + 480]
M2p_a925
    vmovups ymm8, [r8 + 576]
    vmovups ymm9, [r8 + 608]
    vmovups ymm10, [r8 + 640]
    vmovups ymm11, [r8 + 672]
    vbroadcastss ymm12, [r15 + Pc_w + 24]
    vbroadcastss ymm13, [r15 + Pc_w + 24 + 4]
    vmovups ymm15, [r8 + 768]
M2p_a260
    vmulps ymm0, ymm15, ymm13
    vmovups ymm15, [r8 + 800]
M2p_a262
    vmulps ymm1, ymm15, ymm13
    vmovups ymm15, [r8 + 832]
M2p_a264
    vmulps ymm2, ymm15, ymm13
    vmovups ymm15, [r8 + 864]
M2p_a267
    vmulps ymm3, ymm15, ymm13
    vaddps ymm0, ymm0, [r8 + 960]
    vaddps ymm1, ymm1, [r8 + 992]
    vaddps ymm2, ymm2, [r8 + 1024]
    vaddps ymm3, ymm3, [r8 + 1056]
M2p_a36
M2p_a38
    jmp .be3
.bg0:
M2p_a30
M2p_a34
M2p_a3a
M2p_a48
M2p_a50
    vmovss xmm0, [rsi + rdx*4 + 0]
    vmovss [r10 + r11*4 + 0], xmm0
M2p_a54
M2p_a59
M2p_a5c
M2p_a915
M2p_a929
    vpermps ymm1, ymm8, [r8 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vmulps ymm4, ymm0, ymm10
M2p_a92e
M2p_a92f
    vmulps ymm5, ymm0, ymm12
    vpermps ymm0, ymm9, [rax + 4]
    vpermps ymm1, ymm9, [rax + 36]
    vblendvps ymm0, ymm0, ymm1, ymm9
M2p_a91a
M2p_a931
    vpermps ymm1, ymm8, [r9 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm11
    lea rax, [r9 + r14]
M2p_a930
M2p_af5
M2p_a936
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm11
    lea rax, [r15 + r14]
M2p_a930
M2p_a1dc
M2p_a91e
M2p_a92d
M2p_af5
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r10 + 128], ymm0
    vpermps ymm0, ymm8, [r9 + 0]
M2p_a932
M2p_af5
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r11 + 128], ymm0
M2p_a938
M2p_a91b
M2p_a1f2
M2p_a1f9
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