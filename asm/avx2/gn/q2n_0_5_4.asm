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
global xav_q2_0_5_4
align 64
xav_q2_0_5_4:
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
    cmp dword [r15 + Pc_sg], 832203
M2p_a921
M2p_a95b
    vaddps ymm3, ymm3, [r8 + 480]
    vbroadcastss ymm12, [r15 + Pc_w + 0]
    vbroadcastss ymm13, [r15 + Pc_w + 0 + 4]
    vmovups ymm15, [r8 + 576]
    vfmadd231ps ymm0, ymm15, ymm12
    vmulps ymm4, ymm15, ymm13
    vmovups ymm15, [r8 + 608]
    vfmadd231ps ymm1, ymm15, ymm12
    vmulps ymm5, ymm15, ymm13
    vmovups ymm15, [r8 + 640]
    vfmadd231ps ymm2, ymm15, ymm12
    vmulps ymm6, ymm15, ymm13
    vmovups ymm15, [r8 + 672]
    vfmadd231ps ymm3, ymm15, ymm12
    vmulps ymm7, ymm15, ymm13
M2p_a95c
    vaddps ymm4, ymm4, [r8 + 1152]
    vaddps ymm5, ymm5, [r8 + 1184]
    vaddps ymm6, ymm6, [r8 + 1216]
    vaddps ymm7, ymm7, [r8 + 1248]
    vbroadcastss ymm12, [r15 + Pc_w + 12]
    vbroadcastss ymm13, [r15 + Pc_w + 12 + 4]
    vmovups ymm15, [r8 + 1344]
M2p_a944
    vmovups ymm15, [r8 + 1376]
M2p_a945
    vmovups ymm15, [r8 + 1408]
M2p_a946
    vmovups ymm15, [r8 + 1440]
M2p_a947
M2p_a95d
    vaddps ymm8, ymm8, [r8 + 1728]
    vaddps ymm9, ymm9, [r8 + 1760]
    vaddps ymm10, ymm10, [r8 + 1792]
    vaddps ymm11, ymm11, [r8 + 1824]
    vaddps ymm8, ymm8, [r8 + 1920]
    vaddps ymm9, ymm9, [r8 + 1952]
    vaddps ymm10, ymm10, [r8 + 1984]
    vaddps ymm11, ymm11, [r8 + 2016]
    vbroadcastss ymm12, [r15 + Pc_w + 24]
    vbroadcastss ymm13, [r15 + Pc_w + 24 + 4]
    vmovups ymm15, [r8 + 2112]
M2p_a260
    vmulps ymm0, ymm15, ymm13
    vmovups ymm15, [r8 + 2144]
M2p_a262
    vmulps ymm1, ymm15, ymm13
    vmovups ymm15, [r8 + 2176]
M2p_a264
    vmulps ymm2, ymm15, ymm13
    vmovups ymm15, [r8 + 2208]
M2p_a267
    vmulps ymm3, ymm15, ymm13
    vaddps ymm0, ymm0, [r8 + 2304]
    vaddps ymm1, ymm1, [r8 + 2336]
    vaddps ymm2, ymm2, [r8 + 2368]
    vaddps ymm3, ymm3, [r8 + 2400]
    vaddps ymm0, ymm0, [r8 + 2496]
    vaddps ymm1, ymm1, [r8 + 2528]
    vaddps ymm2, ymm2, [r8 + 2560]
    vaddps ymm3, ymm3, [r8 + 2592]
    vaddps ymm0, ymm0, [r8 + 2688]
    vaddps ymm1, ymm1, [r8 + 2720]
    vaddps ymm2, ymm2, [r8 + 2752]
    vaddps ymm3, ymm3, [r8 + 2784]
M2p_a36
M2p_a38
M2p_a926
M2p_a33
M2p_a39
M2p_a47
M2p_a4e
M2p_a95e
M2p_a999
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 96]
M2p_a9b3
M2p_a9c2
M2p_a99e
    vmulps ymm5, ymm0, [rcx + 160]
M2p_a9a0
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [rax + 100]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 192]
M2p_a9a1
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [rax + 104]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 224]
M2p_a9a2
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [rax + 108]
    vblendvps ymm0, ymm0, ymm1, ymm13
M2p_a9c5
M2p_a9ba
M2p_a97e
M2p_a9a4
M2p_a9a7
    vpermps ymm1, ymm10, [r9 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 96]
M2p_a9bc
M2p_a9ca
M2p_a9a9
M2p_a9c3
M2p_a9b9
M2p_a955
M2p_a970
M2p_a9ac
M2p_a9ae
    vpermps ymm1, ymm10, [r15 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 96]
M2p_a9be
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r15 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 128]
M2p_a9b0
M2p_a9c3
M2p_a9b9
M2p_a1e4
M2p_a97a
M2p_a99a
M2p_a99c
M2p_a99d
M2p_a9b3
M2p_a9c1
M2p_a9a3
M2p_a9c5
M2p_a9b9
M2p_a91f
M2p_a97e
M2p_a9a4
M2p_a9a7
M2p_a9c8
M2p_a9c4
M2p_a9c7
M2p_a93f
M2p_a9ab
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r15 + 72]
M2p_a9ad
M2p_a9af
M2p_a9be
M2p_a9cc
M2p_a9a3
M2p_a9c5
M2p_a9b9
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