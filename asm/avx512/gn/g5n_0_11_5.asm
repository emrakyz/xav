%include "g5nm.inc"
default rel
%include "g5o.inc"
%include "g5img.inc"
M5s_a0
M5s_a1
M5s_a2
c_i1023: dd 1023
c_m1: dd -1
c_pft: dq xav_g5_0_11_5.pf1, xav_g5_0_11_5.pf2, xav_g5_0_11_5.pf3, xav_g5_0_11_5.pf4, xav_g5_0_11_5.pf5, xav_g5_0_11_5.pf6, xav_g5_0_11_5.pf7, xav_g5_0_11_5.pf8, xav_g5_0_11_5.pf9, xav_g5_0_11_5.pf10, xav_g5_0_11_5.pf11, xav_g5_0_11_5.pf12, xav_g5_0_11_5.pf13, xav_g5_0_11_5.pf14, xav_g5_0_11_5.pf15, xav_g5_0_11_5.pf16, xav_g5_0_11_5.pf17, xav_g5_0_11_5.pf18, xav_g5_0_11_5.pf19, xav_g5_0_11_5.pf20, xav_g5_0_11_5.pf21, xav_g5_0_11_5.pf22, xav_g5_0_11_5.pf23, xav_g5_0_11_5.pf24, xav_g5_0_11_5.pf25, xav_g5_0_11_5.pf26, xav_g5_0_11_5.pf27, xav_g5_0_11_5.pf28, xav_g5_0_11_5.pf29, xav_g5_0_11_5.pf30, xav_g5_0_11_5.pf31, xav_g5_0_11_5.pf32
M5s_a3
M5s_a4
c_qtr: dd 0x3e800000
section .text
global xav_g5_0_11_5
align 64
xav_g5_0_11_5:
M5s_a5
M5s_a7
M5s_aa
M5s_ab
M5s_ae
M5s_a10
M5s_a31
M5s_a5d
M5s_a53
M5s_a5b
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
M5s_a74
    vfmadd231ps zmm6, zmm8, [c_xbcb]{1to16}
M5s_a5f
M5s_a6e
M5s_a79
M5s_a15
M5s_a3a
M5s_a29
M5s_a44
M5s_a54
M5s_a5c
    vmulps zmm19, zmm19, zmm21
M5s_a7c
M5s_a53
M5s_a5b
M5s_a7e
M5s_a35
    vmovaps zmm6, zmm7
M5s_a45b
    vpmaxud zmm22, zmm12, zmm16
    vpmaxud zmm22, zmm22, zmm20
M5s_a81
M5s_a86
M5s_a2a
M5s_a3f
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
M5s_a87
M5s_a53
M5s_a5b
M5s_a8c
M5s_a35
M5s_a45e
M5s_a6c
M5s_a8a
M5s_a8d
M5s_a8e
M5s_a3f
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
M5s_a8f
M5s_a4b
M5s_a5b
M5s_a94
M5s_a5b
M5s_a77
M5s_a63
M5s_a6c
M5s_a92
M5s_a97
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
M5s_a98
M5s_a3f
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
M5s_a9a
M5s_a47
M5s_a57
M5s_aa2
M5s_a57
M5s_a77
M5s_a63
M5s_a6c
M5s_aa7
M5s_a68
    vpmaxud zmm22, zmm22, zmm20
M5s_aac
M5s_a2e
M5s_a5b
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
M5s_ab0
M5s_a47
M5s_a57
M5s_ab5
M5s_a57
M5s_a77
M5s_a63
M5s_a6c
M5s_ab3
M5s_aa1
M5s_aba
M5s_ab8
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
M5s_abb
M5s_a3d
M5s_a4d
M5s_a5e
M5s_abd
M5s_a57
M5s_ac1
M5s_a45e
M5s_a6c
M5s_ac0
M5s_ac4
M5s_a17
M5s_a21
M5s_a4c
M5s_a5c
M5s_ac5
M5s_a52
M5s_a5a
    vmulps zmm15, zmm15, zmm17
M5s_aca
M5s_a35
M5s_a45e
M5s_a6c
M5s_ac8
M5s_acd
M5s_ad0
M5s_a41
M5s_a50
    vmulps zmm19, zmm19, zmm21
M5s_ad1
M5s_a4b
M5s_a5b
M5s_ad5
M5s_a5b
M5s_a77
M5s_a63
M5s_a6c
    vmulps zmm10, zmm12, [r15 + Pc_w + 8]{1to16}
    vmovups [r8 + rdi*4], zmm10
    vmulps zmm12, zmm12, [r15 + Pc_w + 12]{1to16}
M5s_ad9
    vmovups [r8 + rdi*4], zmm10
    vmulps zmm12, zmm12, [r15 + Pc_w + 12]{1to16}
M5s_ade
M5s_a3b
M5s_a43
M5s_a53
M5s_a5b
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
M5s_ae3
M5s_a47
M5s_a57
M5s_aec
M5s_a57
M5s_a77
M5s_a63
M5s_a6c
M5s_ae7
M5s_af1
M5s_ae5
    vmovups [r8 + rdi*4], zmm10
M5s_af5
M5s_afa
M5s_a101
M5s_a64
M5s_a6d
    vmovups [r8 + rdi], zmm16
M5s_a10a
M5s_a64
M5s_a6d
    vmovups [r8 + rdi], zmm16
M5s_a10e
M5s_a111
M5s_a19
M5s_a20
M5s_afc
M5s_a4b
M5s_a5b
M5s_a114
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
M5s_a117
M5s_a38
M5s_a5f
M5s_a461
    vaddps zmm22, zmm22, [rbp + rdx*8-320]
M5s_a119
M5s_a11c
M5s_a108
M5s_a4c
M5s_a5c
M5s_a11f
M5s_a50
    vmulps zmm19, zmm19, zmm21
M5s_a120
M5s_a38
M5s_a5f
M5s_a88
    vaddps zmm22, zmm22, [r8 + rcx]
M5s_a122
M5s_a126
M5s_a29
M5s_a106
M5s_a4b
M5s_a5b
M5s_a129
M5s_a47
M5s_a57
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
M5s_a12c
M5s_a5e
M5s_a32
M5s_a5f
M5s_a90
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
M5s_a12e
    vmovups [r8 + rcx], zmm11
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
M5s_a130
M5s_a2a
M5s_a108
M5s_a4c
M5s_a5c
M5s_a134
    inc r10
M5s_a45
M5s_a55
M5s_a5e
M5s_a136
M5s_a59
M5s_a32
M5s_a5f
    vpmaxud zmm22, zmm22, zmm20
M5s_aa5
M5s_aaa
M5s_a13a
    vmulps zmm20, zmm20, [r15 + Pc_w + 4]{1to16}
    vmovups [r8 + rcx*2], zmm20
M5s_aaf
M5s_a13b
M5s_a2a
M5s_a108
M5s_a4c
M5s_a5c
M5s_a13e
M5s_a47c
M5s_a54
M5s_a5c
    vmulps zmm19, zmm19, zmm21
M5s_a140
M5s_a59
M5s_a32
M5s_a5f
M5s_ab1
M5s_ab8
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
M5s_a142
    vmulps zmm20, zmm20, [r15 + Pc_w + 4]{1to16}
M5s_ab8
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
M5s_a143
M5s_a28
M5s_a105
M5s_a4a
M5s_a5a
M5s_a146
M5s_a52
M5s_a5a
M5s_a469
M5s_a14a
M5s_a60
M5s_abf
M5s_a14b
M5s_a16
    mov r8, [rsp + 88]
M5s_a22
M5s_a145
M5s_a49
M5s_a59
M5s_a14e
M5s_a51
M5s_a14f
M5s_a38
M5s_a5f
M5s_ac6
    vaddps zmm22, zmm22, [r8 + rbx]
M5s_a150
M5s_a153
M5s_a2a
M5s_a108
M5s_a4c
M5s_a5c
M5s_a156
M5s_a48
M5s_a58
    vmulps zmm19, zmm19, zmm21
M5s_a157
M5s_a5e
M5s_a32
M5s_a5f
M5s_ad3
M5s_a46d
M5s_adb
    vmulps zmm22, zmm22, [r15 + Pc_w + 12]{1to16}
M5s_a159
    vmovups [r8 + rbx], zmm11
    vmulps zmm22, zmm22, [r15 + Pc_w + 12]{1to16}
M5s_a15b
M5s_a2a
M5s_a108
M5s_a4c
M5s_a5c
M5s_a15f
M5s_a47c
M5s_a54
M5s_a5c
    vmulps zmm19, zmm19, zmm21
M5s_a161
M5s_a59
M5s_a32
M5s_a5f
M5s_ae5
    vmovups [r8 + rdi*4], zmm10
M5s_af0
M5s_a163
    vmulps zmm20, zmm20, [r15 + Pc_w + 12]{1to16}
M5s_af7
    vmulps zmm22, zmm22, [r15 + Pc_w + 12]{1to16}
M5s_a165
M5s_a174
M5s_a16d
M5s_a181
M5s_a18e
M5s_a1ab
M5s_a1d2
M5s_a1f5
M5s_a1fa
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm4, zmm0, [rcx + 576]
M5s_a494
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm4, zmm0, [rcx + 640]
M5s_a1fe
M5s_a205
M5s_a1d7
M5s_a1dc
M5s_a20b
M5s_a1ef
M5s_a20d
    vmovups zmm1, [rdx + 3136]
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 576]
M5s_a494
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 640]
M5s_a20f
M5s_a218
M5s_a1d7
M5s_a1dc
M5s_a21f
M5s_a1ef
M5s_a222
    vmovups zmm1, [rdx + 3136]
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 576]
M5s_a494
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 640]
M5s_a225
M5s_a22c
M5s_a1d7
M5s_a1dc
M5s_a233
M5s_a1ef
M5s_a236
M5s_a24c
M5s_a494
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 640]
M5s_a238
M5s_a1a6
M5s_a1c8
M5s_a1ed
M5s_a1f8
M5s_a1fc
M5s_a493
    vmovups zmm1, [rdx + 576]
M5s_a203
M5s_a1ca
M5s_a1ce
M5s_a208
M5s_a1f5
M5s_a1fa
M5s_a496
M5s_a1a3
M5s_a217
M5s_a1cb
M5s_a1cf
M5s_a21e
M5s_a1f6
M5s_a1fb
M5s_a49a
M5s_a1a5
M5s_a22b
M5s_a1cc
M5s_a1d0
M5s_a232
M5s_a1f8
M5s_a1fc
    vfmadd231ps zmm7, zmm0, [rcx + 576]
M5s_a494
M5s_a49c
M5s_a24e
M5s_a1a4
M5s_a1c7
M5s_a1ec
M5s_a1f6
M5s_a1fb
M5s_a492
M5s_a1a5
M5s_a204
M5s_a1cc
M5s_a1d0
M5s_a209
M5s_a1f8
M5s_a1fc
M5s_a497
    vmovups zmm1, [rdx + 576]
M5s_a216
M5s_a1ca
M5s_a1ce
M5s_a21d
M5s_a1f5
M5s_a1fa
M5s_a499
M5s_a1a3
M5s_a22a
M5s_a1cb
M5s_a1cf
M5s_a231
M5s_a1f6
M5s_a1fb
    vmovaps zmm0{k3}, zmm1
M5s_a4a2
    vmovups zmm1, [rdx + 3456]
M5s_a49c
M5s_a242
    vmovups [r11 + r12*2 + 0], zmm3
    vaddps zmm8, zmm0, zmm2
    vaddps zmm9, zmm4, zmm6
M5s_a24b
M5s_a1ad
M5s_a1d4
M5s_a1f8
M5s_a1fc
M5s_a493
M5s_a4a0
M5s_a1c9
M5s_a1cd
    vmovups zmm1, [rdx + 1856]
M5s_a208
M5s_a1f5
M5s_a1fa
M5s_a496
M5s_a1a3
M5s_a217
M5s_a1cb
M5s_a1cf
M5s_a21e
M5s_a1f6
M5s_a1fb
M5s_a49a
M5s_a1a5
M5s_a22b
M5s_a1cc
M5s_a1d0
M5s_a232
M5s_a1f8
M5s_a1fc
M5s_a4a1
M5s_a257
M5s_a25b
M5s_a264
M5s_a26d
M5s_a272
    vmovaps zmm12, zmm14
M5s_a27e
M5s_a28c
M5s_a295
M5s_a29b
M5s_a26a
M5s_a27a
M5s_a27c
M5s_a29f
M5s_a286
M5s_a28a
M5s_a2a3
M5s_a2a7
M5s_a2ab
M5s_a2b4
M5s_a2b8
M5s_a2c3
M5s_a2bb
M5s_a2c1
M5s_a2c4
M5s_a2c8
M5s_a2cc
M5s_a177
    vptestmw k3, zmm1, zmm1
    kunpckdq k2, k3, k2
M5s_a2d0
M5s_a185
M5s_a2d3
M5s_a2d5
M5s_a2da
M5s_a2de
M5s_a2e3
M5s_a2f1
M5s_a2f5
M5s_a2fb
M5s_a307
M5s_a30b
M5s_a2ec
M5s_a2ff
M5s_a303
M5s_a30e
M5s_a317
M5s_a324
M5s_a32f
M5s_a2e8
M5s_a2f4
M5s_a332
M5s_a338
M5s_a33d
    mov eax, edx
M5s_a33f
M5s_a345
M5s_a34b
M5s_a34c
M5s_a312
    mov rdx, [rsp + 8 + 1224]
    mov rax, [rsp + 8 + 1232]
M5s_a34e
M5s_a31f
M5s_a352
    vfmadd231ss xmm0, xmm1, [rax + rcx*4 + 64]
    vcvtss2sd xmm0, xmm0, xmm0
M5s_a353
M5s_a359
M5s_a363
M5s_a368
M5s_a35d
M5s_a36c
M5s_a370
M5s_a374
M5s_a378
M5s_a37c
M5s_a380
M5s_a385
M5s_a394
M5s_a3a0
M5s_a3ac
M5s_a3b7
M5s_a38f
M5s_a3ba
M5s_a3bc
M5s_a3a6
M5s_a3c2
M5s_a3c4
M5s_a38b
M5s_a3ca
M5s_a3cc
M5s_a3a6
M5s_a3d2
M5s_a3d4
M5s_a3d8
M5s_a3dc
M5s_a3e2
M5s_a3e6
M5s_a3eb
M5s_a3ef
M5s_a3f4
M5s_a3f9
M5s_a3fd
M5s_a402
M5s_a406
M5s_a40b
M5s_a40f
M5s_a413
M5s_a417
M5s_a41a
M5s_a41e
M5s_a422
M5s_a426
M5s_a42a
M5s_a42e
M5s_a432
M5s_a436
M5s_a43a
M5s_a442
M5s_a446
M5s_a440
M5s_a448
M5s_a44c
M5s_a452
M5s_a454
    ret
section .note.GNU-stack noalloc noexec nowrite progbits
