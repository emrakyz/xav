%include "p5nm.inc"
default rel
%include "gpo.inc"
%include "gpimg.inc"
M5p_a0
M5p_a1
M5p_a2
M5p_a3
M5p_a4
global xav_p5_0_14_7
align 64
xav_p5_0_14_7:
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
M5p_a28d
M5p_a4a
M5p_a59
M5p_a362
M5p_a36b
M5p_a378
M5p_a37e
M5p_a38d
M5p_a39b
M5p_a401
M5p_a405
M5p_a409
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 832]
M5p_ab0
M5p_a337
M5p_a3a9
M5p_a36d
M5p_a3ac
M5p_a96
M5p_a3fc
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3af
M5p_a386
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3b2
M5p_a397
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3b6
M5p_a3a3
M5p_a3a7
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 768]
M5p_a404
M5p_a408
    kmovw k3, [rsi + 194]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 832]
M5p_abe
M5p_ac4
M5p_a33a
M5p_a3ba
M5p_a36d
M5p_a3bd
M5p_a96
M5p_a3fc
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3c0
M5p_a386
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3c3
M5p_a397
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3c7
M5p_a3a3
M5p_a3a7
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 768]
M5p_a404
M5p_a408
    kmovw k3, [rsi + 194]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 832]
M5p_acd
M5p_a33f
M5p_a3ca
M5p_a36d
M5p_a3cd
M5p_a96
M5p_a3fd
M5p_a3d1
M5p_a394
M5p_a3d5
M5p_a39e
M5p_a3a6
    vfmadd231ps zmm3, zmm16, [rcx + 768]
M5p_a404
M5p_a408
    kmovw k3, [rsi + 194]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 832]
M5p_ae0
M5p_ae5
M5p_a342
M5p_a3d8
M5p_a36d
M5p_a3db
M5p_a96
M5p_a3fc
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3de
M5p_a386
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3e0
M5p_a397
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3e3
M5p_a3a3
M5p_a3a7
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 768]
M5p_a404
M5p_a408
    kmovw k3, [rsi + 194]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 832]
M5p_af3
M5p_a346
M5p_a3e7
M5p_a36d
M5p_a3eb
M5p_a96
M5p_a3fc
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3ef
M5p_a386
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3f2
M5p_a397
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3f6
M5p_a3a3
M5p_a3a7
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 768]
M5p_a404
M5p_a408
    kmovw k3, [rsi + 194]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 832]
M5p_a104
M5p_a10e
M5p_a57
M5p_a28e
M5p_a363
M5p_a36c
M5p_a37a
M5p_a380
M5p_a38f
M5p_a39c
M5p_a402
M5p_a366
M5p_a3ab
M5p_a372
M5p_a3ae
M5p_a2c2
M5p_a2c5
M5p_a37c
M5p_a3b0
M5p_a38c
M5p_a3fb
M5p_a39f
M5p_a3a8
M5p_a40e
M5p_a292
M5p_a366
M5p_a3bb
M5p_a372
M5p_a3be
M5p_a2c2
M5p_a2c5
M5p_a37c
M5p_a3c1
M5p_a38c
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3c5
M5p_a3a0
    vpermi2ps zmm17, zmm11, zmm12
    kmovw k3, [rsi + 180]
M5p_a411
M5p_a365
M5p_a3cc
M5p_a371
M5p_a3ce
M5p_a2c1
M5p_a2c4
M5p_a3fa
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3d0
M5p_a38c
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3d3
M5p_a3a0
    vpermi2ps zmm17, zmm11, zmm12
    kmovw k3, [rsi + 180]
    vmovaps zmm16{k3}, zmm17
M5p_a414
M5p_a292
M5p_a366
M5p_a3da
M5p_a372
M5p_a3dd
M5p_a2c2
M5p_a2c5
M5p_a37c
M5p_a3df
M5p_a38c
M5p_a3fe
M5p_a39f
M5p_a3a8
M5p_a416
M5p_a366
M5p_a3e9
M5p_a372
M5p_a3ed
M5p_a2c2
M5p_a2c5
M5p_a37c
M5p_a3f0
M5p_a38c
    vpermi2ps zmm17, zmm11, zmm12
M5p_a3f4
M5p_a3a0
    vpermi2ps zmm17, zmm11, zmm12
    kmovw k3, [rsi + 180]
M5p_a419
M5p_a282
M5p_a112
M5p_a120
M5p_a12b
M5p_a138
M5p_a142
M5p_a147
M5p_a116
M5p_a11a
M5p_a14b
M5p_a128
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
M5p_a328
M5p_a3ff
M5p_a169
M5p_a170
M5p_a178
M5p_a17b
M5p_a17f
M5p_a187
M5p_a196
M5p_a1a1
M5p_a1a5
M5p_a1a8
M5p_a1ab
M5p_a1af
M5p_a1b8
M5p_a1b4
M5p_a1be
M5p_a1c4
M5p_a1be
M5p_a1c7
M5p_a1cb
M5p_a191
M5p_a1ce
    vcvtss2sd xmm0, xmm0, xmm0
M5p_a400
M5p_a1d3
M5p_a1d6
M5p_a1da
M5p_a1dd
M5p_a1e0
M5p_a1e4
M5p_a1e7
M5p_a1ea
M5p_a1ed
M5p_a1fa
M5p_a206
M5p_a210
M5p_a21a
M5p_a1f5
M5p_a1ff
M5p_a221
M5p_a223
M5p_a214
M5p_a227
M5p_a229
M5p_a1f9
M5p_a22d
M5p_a22f
M5p_a214
M5p_a233
M5p_a235
M5p_a238
M5p_a23a
M5p_a23c
M5p_a241
M5p_a244
M5p_a247
M5p_a24a
M5p_a24d
M5p_a251
M5p_a254
M5p_a257
M5p_a25a
M5p_a25d
M5p_a260
M5p_a263
M5p_a266
M5p_a269
M5p_a26c
M5p_a26f
    ret
section .note.GNU-stack noalloc noexec nowrite progbits
