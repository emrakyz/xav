%include "p5nm.inc"
default rel
%include "gpo.inc"
%include "gpimg.inc"
M5p_a0
M5p_a1
M5p_a2
M5p_a3
M5p_a4
global xav_p5_0_11_6
align 64
xav_p5_0_11_6:
M5p_a5
M5p_a6
M5p_ac
M5p_a9
M5p_a271
M5p_ae
M5p_a12
M5p_a14
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
M5p_a272
M5p_a25
M5p_a2e
M5p_a31
    kunpckdq k2, k3, k2
    kmovq r13, k2
M5p_a40
M5p_a4e
M5p_a28e
M5p_a5c
M5p_a291
    kmovw k3, [rsi + 10]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm0, zmm16, [rcx + 0]
M5p_a293
M5p_a29b
    kmovw k3, [rsi + 22]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 64]
M5p_a29e
M5p_a2a8
    kmovw k3, [rsi + 34]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 128]
M5p_a2ac
M5p_a2ae
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 192]
M5p_a2b1
M5p_a2b6
    kmovw k3, [rsi + 58]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 256]
M5p_a87
M5p_a2b9
    vpermi2ps zmm17, zmm28, zmm29
M5p_a2ca
M5p_a2d2
    vmovups zmm17, [rdx + 4096]
M5p_a2da
    vpermi2ps zmm17, zmm9, zmm10
    kmovw k3, [rsi + 130]
M5p_a276
M5p_ab2
    vmovups zmm9, [r8 + r14 + 640]
    vmovups zmm10, [r8 + r14 + 704]
M5p_a5c
M5p_a291
    kmovw k3, [rsi + 10]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm1, zmm16, [rcx + 0]
M5p_a293
M5p_a29b
    kmovw k3, [rsi + 22]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 64]
M5p_a29e
M5p_a2a8
    kmovw k3, [rsi + 34]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 128]
M5p_a2ac
M5p_a2ae
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 192]
M5p_a2b1
M5p_a2b6
    kmovw k3, [rsi + 58]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 256]
M5p_a87
M5p_a2b8
    kmovw k3, [rsi + 70]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 320]
M5p_a2bc
M5p_a2be
    kmovw k3, [rsi + 82]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 384]
M5p_a2bf
M5p_a2c5
    kmovw k3, [rsi + 94]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 448]
M5p_a2c6
M5p_a2cd
    kmovw k3, [rsi + 106]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 512]
M5p_a2ce
M5p_a2d0
    kmovw k3, [rsi + 118]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 576]
M5p_a2d3
M5p_a2db
    kmovw k3, [rsi + 130]
M5p_a278
    vmovups zmm9, [r9 + 640]
    vmovups zmm10, [r9 + 704]
M5p_a5c
M5p_a291
    kmovw k3, [rsi + 10]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm2, zmm16, [rcx + 0]
M5p_a293
M5p_a29b
    kmovw k3, [rsi + 22]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 64]
M5p_a29e
M5p_a2a8
    kmovw k3, [rsi + 34]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 128]
M5p_a2ac
M5p_a2ae
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 192]
M5p_a2b1
M5p_a2b6
    kmovw k3, [rsi + 58]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 256]
M5p_a87
M5p_a2b8
    kmovw k3, [rsi + 70]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 320]
M5p_a2bc
M5p_a2be
    kmovw k3, [rsi + 82]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 384]
M5p_a2bf
M5p_a2c5
    kmovw k3, [rsi + 94]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 448]
M5p_a2c6
M5p_a2cd
    kmovw k3, [rsi + 106]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 512]
M5p_a2ce
M5p_a2d0
    kmovw k3, [rsi + 118]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 576]
M5p_a2d3
M5p_a2db
    kmovw k3, [rsi + 130]
M5p_a27a
M5p_ad2
    vmovups zmm9, [r9 + r14 + 640]
    vmovups zmm10, [r9 + r14 + 704]
M5p_a5c
M5p_a291
    kmovw k3, [rsi + 10]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm3, zmm16, [rcx + 0]
M5p_a293
M5p_a29b
    kmovw k3, [rsi + 22]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 64]
M5p_a29e
M5p_a2a8
    kmovw k3, [rsi + 34]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 128]
M5p_a2ac
M5p_a2ae
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 192]
M5p_a2b1
M5p_a2b6
    kmovw k3, [rsi + 58]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 256]
M5p_a87
M5p_a2b8
    kmovw k3, [rsi + 70]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 320]
M5p_a2bc
M5p_a2be
    kmovw k3, [rsi + 82]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 384]
M5p_a2bf
M5p_a2c5
    kmovw k3, [rsi + 94]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 448]
M5p_a2c6
M5p_a2cd
    kmovw k3, [rsi + 106]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 512]
M5p_a2ce
M5p_a2d0
    kmovw k3, [rsi + 118]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 576]
M5p_a2d3
M5p_a2db
    kmovw k3, [rsi + 130]
M5p_a27c
    vmovups zmm9, [r15 + 640]
    vmovups zmm10, [r15 + 704]
M5p_a5c
M5p_a291
    kmovw k3, [rsi + 10]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm4, zmm16, [rcx + 0]
M5p_a293
M5p_a29b
    kmovw k3, [rsi + 22]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 64]
M5p_a29e
M5p_a2a8
    kmovw k3, [rsi + 34]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 128]
M5p_a2ac
M5p_a2ae
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 192]
M5p_a2b1
M5p_a2b6
    kmovw k3, [rsi + 58]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 256]
M5p_a87
M5p_a2b8
    kmovw k3, [rsi + 70]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 320]
M5p_a2bc
M5p_a2be
    kmovw k3, [rsi + 82]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 384]
M5p_a2bf
M5p_a2c5
    kmovw k3, [rsi + 94]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 448]
M5p_a2c6
M5p_a2cd
    kmovw k3, [rsi + 106]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 512]
M5p_a2ce
M5p_a2d0
    kmovw k3, [rsi + 118]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 576]
M5p_a2d3
M5p_a2db
    kmovw k3, [rsi + 130]
M5p_a27e
M5p_af6
    vmovups zmm9, [r15 + r14 + 640]
    vmovups zmm10, [r15 + r14 + 704]
M5p_a5c
M5p_a291
    kmovw k3, [rsi + 10]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm5, zmm16, [rcx + 0]
M5p_a293
M5p_a29b
    kmovw k3, [rsi + 22]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 64]
M5p_a29e
M5p_a2a8
    kmovw k3, [rsi + 34]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 128]
M5p_a2ac
M5p_a2ae
    kmovw k3, [rsi + 46]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 192]
M5p_a2b1
M5p_a2b6
    kmovw k3, [rsi + 58]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 256]
M5p_a87
M5p_a2b8
    kmovw k3, [rsi + 70]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 320]
M5p_a2bc
M5p_a2be
    kmovw k3, [rsi + 82]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 384]
M5p_a2bf
M5p_a2c5
    kmovw k3, [rsi + 94]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 448]
M5p_a2c6
M5p_a2cd
    kmovw k3, [rsi + 106]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 512]
M5p_a2ce
M5p_a2d0
    kmovw k3, [rsi + 118]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 576]
M5p_a2d3
M5p_a2db
    kmovw k3, [rsi + 130]
M5p_a280
M5p_a290
M5p_a2a9
M5p_a8e
    vpermi2ps zmm17, zmm30, zmm31
M5p_a2b9
M5p_a2c9
M5p_ab2
M5p_a2dd
M5p_a2a8
M5p_a2e0
M5p_a31f
    vpermi2ps zmm17, zmm9, zmm10
M5p_a2e4
M5p_a2cc
    vpermi2ps zmm17, zmm9, zmm10
M5p_a2e8
M5p_a2eb
M5p_a2aa
M5p_a2ee
M5p_a2b8
M5p_a2f1
M5p_a2cc
    vpermi2ps zmm17, zmm9, zmm10
M5p_a2f5
M5p_a5d
M5p_a60
    vpermi2ps zmm17, zmm30, zmm31
M5p_a291
M5p_a2f8
M5p_a2ad
    vpermi2ps zmm17, zmm9, zmm10
M5p_a2fc
M5p_a2bd
    vpermi2ps zmm17, zmm9, zmm10
M5p_a300
M5p_a2cf
    vpermi2ps zmm17, zmm9, zmm10
M5p_a304
M5p_a306
M5p_a2af
M5p_a30a
M5p_a2be
M5p_a30e
M5p_a2cf
    vpermi2ps zmm17, zmm9, zmm10
M5p_a311
M5p_a297
    vpermi2ps zmm17, zmm9, zmm10
M5p_a313
M5p_a2b5
    vpermi2ps zmm17, zmm9, zmm10
M5p_a318
M5p_a2c4
    vpermi2ps zmm17, zmm9, zmm10
M5p_a31c
M5p_a2da
    vpermi2ps zmm17, zmm9, zmm10
M5p_a31e
M5p_a10f
M5p_a114
M5p_a122
M5p_a12d
M5p_a13a
M5p_a144
M5p_a149
M5p_a118
M5p_a11c
M5p_a284
M5p_a126
    add r9, 576
    dec r11
M5p_a14c
M5p_a132
M5p_a136
M5p_a286
M5p_a150
M5p_a154
M5p_a159
M5p_a15d
M5p_a3c
M5p_a161
M5p_a35
M5p_a46
    vpaddd zmm0, zmm0, [c_iota]
M5p_a163
    cmovb r8, rcx
M5p_a288
M5p_a16b
M5p_a16d
M5p_a172
M5p_a175
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
M5p_a28a
M5p_a1ba
    vfmadd213pd zmm7, zmm6, [d_p1m2]{1to8}
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
M5p_a28b
M5p_a198
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
