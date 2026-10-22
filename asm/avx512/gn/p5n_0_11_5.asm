%include "p5nm.inc"
default rel
%include "gpo.inc"
%include "gpimg.inc"
M5p_a0
M5p_a1
M5p_a2
M5p_a3
M5p_a4
global xav_p5_0_11_5
align 64
xav_p5_0_11_5:
M5p_a5
M5p_a6
M5p_ac
M5p_a9
    vpermt2ps zmm2, zmm5, zmm1
    vmovups [r12 + r15], zmm3
    vmovups [r12 + r15 + 64], zmm2
M5p_ad
M5p_af
M5p_a13
    add rdx, r11
M5p_a15
M5p_a16
M5p_a18
M5p_a22
M5p_a21
M5p_a26
M5p_a1e
M5p_a24
M5p_a28
M5p_a29
M5p_a1b
M5p_a1f
M5p_a25
M5p_a2a
M5p_a2b
M5p_a1c
M5p_a20
    vpmaxud zmm19, zmm16, zmm17
M5p_a2c
    vpmaxud zmm19, zmm16, zmm17
M5p_a2d
M5p_a30
M5p_a33
M5p_a40
M5p_a4e
M5p_a5a
M5p_a74
M5p_a8f
M5p_a273
    kmovw k3, [rsi + 108]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 640]
M5p_aaf
M5p_ab5
M5p_a88
M5p_a90
M5p_ab9
M5p_aa0
M5p_abd
    vpermi2ps zmm17, zmm30, zmm31
    kmovw k3, [rsi + 98]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 576]
M5p_a273
    kmovw k3, [rsi + 108]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 640]
M5p_abf
M5p_a6c
M5p_ac6
M5p_a88
M5p_a90
M5p_aca
M5p_aa0
M5p_acc
    vpermi2ps zmm17, zmm30, zmm31
    kmovw k3, [rsi + 98]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 576]
M5p_a273
    kmovw k3, [rsi + 108]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 640]
M5p_ace
M5p_ad5
M5p_a88
M5p_a90
M5p_ada
M5p_aa0
M5p_ade
    vpermi2ps zmm17, zmm30, zmm31
    kmovw k3, [rsi + 98]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 576]
M5p_a273
    kmovw k3, [rsi + 108]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 640]
M5p_adf
M5p_a6c
M5p_ae9
M5p_a88
M5p_a90
M5p_aed
M5p_aa0
M5p_af0
    vpermi2ps zmm17, zmm30, zmm31
    kmovw k3, [rsi + 98]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 576]
M5p_a273
    kmovw k3, [rsi + 108]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 640]
M5p_af1
M5p_afa
M5p_a88
M5p_a90
M5p_aff
M5p_aa0
M5p_a102
    vpermi2ps zmm17, zmm30, zmm31
    kmovw k3, [rsi + 98]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 576]
M5p_a273
    kmovw k3, [rsi + 108]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 640]
M5p_a105
M5p_a68
M5p_a7f
M5p_a9f
M5p_aa9
M5p_aae
M5p_a274
M5p_ab4
M5p_a80
M5p_a83
M5p_ab8
M5p_aa6
M5p_aab
M5p_a277
M5p_a64
M5p_ac5
M5p_a81
M5p_a84
M5p_ac8
M5p_aa7
M5p_aac
M5p_a279
M5p_a67
M5p_ad4
M5p_a82
M5p_a85
M5p_ad9
M5p_aa8
M5p_aad
M5p_a27b
M5p_a65
    vpermi2ps zmm17, zmm30, zmm31
M5p_ae8
M5p_a80
M5p_a83
M5p_aec
M5p_aa6
M5p_aab
M5p_a27d
M5p_a66
M5p_af9
M5p_a81
M5p_a84
M5p_afe
M5p_aa7
M5p_aac
M5p_a27f
M5p_a275
M5p_a281
    vmovaps zmm5, zmm16
    vaddps zmm0, zmm0, zmm1
M5p_a10f
M5p_a114
M5p_a122
M5p_a12d
M5p_a13a
M5p_a144
M5p_a149
M5p_a118
M5p_a11c
    add r9, 576
    dec r11
M5p_a14b
M5p_a128
M5p_a14c
M5p_a132
M5p_a136
    add r8, 256
    add r9, 576
M5p_a14d
M5p_a152
M5p_a156
M5p_a15b
M5p_a3a
M5p_a15f
M5p_a44
M5p_a49
M5p_a164
    xor r9d, r9d
M5p_a167
M5p_a16c
M5p_a16e
M5p_a173
M5p_a176
    vpmaxsq zmm2, zmm2, zmm3
    vpternlogq zmm4, zmm4, zmm4, 0xff
    vpminsq zmm4{k1}, zmm2, [d_q1023]{1to8}
M5p_a17a
M5p_a17e
M5p_a183
M5p_a18c
M5p_a19b
M5p_a1a4
M5p_a1ae
M5p_a1b1
M5p_a1bb
M5p_a1b6
    vfmadd213pd zmm7, zmm6, [d_p1m2]{1to8}
M5p_a1c3
M5p_a1bc
M5p_a1c6
M5p_a1ca
M5p_a190
M5p_a1cd
M5p_a1a0
M5p_a1d2
M5p_a1d5
M5p_a1d8
M5p_a1dc
M5p_a1df
M5p_a1e2
M5p_a1e6
M5p_a1e9
M5p_a1ec
M5p_a1ef
M5p_a1fe
M5p_a208
M5p_a212
M5p_a21d
M5p_a1f7
M5p_a220
M5p_a20a
M5p_a225
M5p_a226
M5p_a21f
M5p_a22b
M5p_a1fd
M5p_a22c
M5p_a20a
M5p_a231
M5p_a232
M5p_a21f
M5p_a237
    mov rcx, rax
    imul rcx, r11
    cmp rcx, [r15 + 664]
M5p_a239
M5p_a199
    add rdx, rcx
M5p_a23b
M5p_a23f
M5p_a240
M5p_a243
M5p_a246
M5p_a249
M5p_a24c
M5p_a24f
M5p_a253
M5p_a256
M5p_a259
M5p_a25c
M5p_a25f
M5p_a262
M5p_a265
M5p_a268
M5p_a26b
M5p_a26e
