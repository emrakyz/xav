%include "p5nm.inc"
default rel
%include "gpo.inc"
%include "gpimg.inc"
M5p_a0
M5p_a1
M5p_a2
M5p_a3
M5p_a4
global xav_p5_0_3_1
align 64
xav_p5_0_3_1:
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
M5p_a4c
M5p_a4c7
    vmovups zmm29, [rdx + 128]
    vmovups zmm25, [rcx + 128]
M5p_a52
M5p_a54
M5p_a4c8
    vfmadd231ps zmm0, zmm16, zmm26
    vmovaps zmm16, zmm29
    vpermi2ps zmm16, zmm18, zmm19
    vfmadd231ps zmm0, zmm16, zmm25
M5p_a4cb
    vmovaps zmm16, zmm29
    vpermi2ps zmm16, zmm18, zmm19
    vfmadd231ps zmm1, zmm16, zmm25
M5p_ac0
M5p_a4cc
    vmovaps zmm16, zmm29
    vpermi2ps zmm16, zmm18, zmm19
    vfmadd231ps zmm2, zmm16, zmm25
M5p_a4cd
    vmovaps zmm16, zmm29
    vpermi2ps zmm16, zmm18, zmm19
    vfmadd231ps zmm3, zmm16, zmm25
M5p_ae1
M5p_a4cf
    vmovaps zmm16, zmm29
    vpermi2ps zmm16, zmm18, zmm19
    vfmadd231ps zmm4, zmm16, zmm25
M5p_a4d0
    vmovaps zmm16, zmm29
    vpermi2ps zmm16, zmm18, zmm19
    vfmadd231ps zmm5, zmm16, zmm25
M5p_a104
M5p_a10d
M5p_a4c9
M5p_a4d3
M5p_a4d6
M5p_a110
M5p_a115
M5p_a123
M5p_a12e
M5p_a13b
M5p_a145
M5p_a13f
M5p_a140
M5p_a146
M5p_a14a
M5p_a11d
M5p_a285
M5p_a127
M5p_a327
M5p_a131
M5p_a135
M5p_a14e
M5p_a153
M5p_a157
M5p_a15c
M5p_a3b
M5p_a160
M5p_a45
M5p_a4d
M5p_a165
M5p_a167
M5p_a16c
M5p_a16e
M5p_a173
M5p_a176
M5p_a289
M5p_a17d
M5p_a181
M5p_a18b
M5p_a19a
M5p_a1a3
M5p_a1aa
M5p_a1ad
M5p_a1b2
M5p_a1bd
M5p_a1b7
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
