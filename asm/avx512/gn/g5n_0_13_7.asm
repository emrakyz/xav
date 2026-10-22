%include "g5nm.inc"
default rel
%include "g5o.inc"
%include "g5img.inc"
M5s_a0
M5s_a1
M5s_a2
c_i1023: dd 1023
c_m1: dd -1
c_pft: dq xav_g5_0_13_7.pf1, xav_g5_0_13_7.pf2, xav_g5_0_13_7.pf3, xav_g5_0_13_7.pf4, xav_g5_0_13_7.pf5, xav_g5_0_13_7.pf6, xav_g5_0_13_7.pf7, xav_g5_0_13_7.pf8, xav_g5_0_13_7.pf9, xav_g5_0_13_7.pf10, xav_g5_0_13_7.pf11, xav_g5_0_13_7.pf12, xav_g5_0_13_7.pf13, xav_g5_0_13_7.pf14, xav_g5_0_13_7.pf15, xav_g5_0_13_7.pf16, xav_g5_0_13_7.pf17, xav_g5_0_13_7.pf18, xav_g5_0_13_7.pf19, xav_g5_0_13_7.pf20, xav_g5_0_13_7.pf21, xav_g5_0_13_7.pf22, xav_g5_0_13_7.pf23, xav_g5_0_13_7.pf24, xav_g5_0_13_7.pf25, xav_g5_0_13_7.pf26, xav_g5_0_13_7.pf27, xav_g5_0_13_7.pf28, xav_g5_0_13_7.pf29, xav_g5_0_13_7.pf30, xav_g5_0_13_7.pf31, xav_g5_0_13_7.pf32
M5s_a3
M5s_a4
c_qtr: dd 0x3e800000
section .text
global xav_g5_0_13_7
align 64
xav_g5_0_13_7:
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
M5s_a45a
M5s_a45e
M5s_a6b
M5s_a7a
M5s_a18
M5s_a3c
M5s_a2c
M5s_a46
M5s_a56
M5s_a4b2
M5s_a50
M5s_a7f
M5s_a36
M5s_a45b
M5s_a45f
M5s_a85
M5s_a28
M5s_a3d
M5s_a4d
M5s_a5e
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
M5s_a462
M5s_a49
M5s_a59
M5s_a95
M5s_a5e
M5s_a32
M5s_a5f
M5s_a90
M5s_a4b4
M5s_a93
M5s_a99
M5s_a41
M5s_a50
M5s_a465
M5s_a46
M5s_a56
M5s_a469
M5s_aa4
M5s_a5a
M5s_a76
M5s_a62
M5s_a69
M5s_aa6
M5s_a67
M5s_a57b
M5s_a2b
M5s_a59
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
M5s_a468
M5s_a2c
M5s_a41
M5s_a50
M5s_abc
M5s_a56
M5s_a469
M5s_ac2
M5s_a60
M5s_abf
M5s_ac3
M5s_a16
M5s_a485
M5s_a25
M5s_a4f
M5s_a4ba
M5s_a51
M5s_acb
M5s_a38
M5s_a5f
M5s_ac6
M5s_a57e
M5s_ace
M5s_a3e
M5s_a4e
M5s_a5a5
M5s_a48
M5s_a58
M5s_ad6
M5s_a5c
M5s_a78
M5s_a64
M5s_a4c3
M5s_add
M5s_ae1
M5s_a2a
M5s_a3f
M5s_a4f
M5s_a470
M5s_a45
M5s_a55
M5s_a5e
M5s_aed
M5s_a59
M5s_a32
M5s_a5f
M5s_ae5
M5s_a48e
    vmulps zmm22, zmm22, [r15 + Pc_w + 12]{1to16}
M5s_af3
M5s_a490
    vmovups [r8 + rbx], zmm11
    vmulps zmm22, zmm22, [r15 + Pc_w + 12]{1to16}
M5s_af8
M5s_a1b
M5s_a145
M5s_a49
M5s_a59
M5s_a109
M5s_a55
M5s_a5e
M5s_a10c
M5s_a5f
M5s_a6e
    vmovups [r8 + rdi*2], zmm20
M5s_a110
M5s_a17
M5s_a1f
M5s_afb
M5s_a4a
M5s_a5a
M5s_a113
M5s_a4e
M5s_a469
M5s_a118
M5s_a4b3
M5s_a69
M5s_a82
M5s_a119
M5s_a11c
M5s_a108
M5s_a4c
M5s_a5c
M5s_a11f
M5s_a50
M5s_a475
M5s_a36
M5s_a45b
M5s_a4be
M5s_a8b
M5s_a124
M5s_afd
M5s_a103
M5s_a49
M5s_a59
M5s_a12b
M5s_a49
M5s_a59
M5s_a12c
M5s_a5e
M5s_a32
M5s_a5f
M5s_a90
M5s_a479
M5s_a93
M5s_a131
M5s_a103
M5s_a49
M5s_a59
M5s_a135
M5s_a45
M5s_a55
M5s_a5e
M5s_a136
M5s_a59
M5s_a32
M5s_a5f
M5s_a47e
M5s_a66
M5s_aad
M5s_aa1
M5s_a13c
M5s_a103
M5s_a49
M5s_a59
M5s_a13f
M5s_a45
M5s_a55
M5s_a5e
M5s_a140
M5s_a59
M5s_a32
M5s_a5f
M5s_ab1
M5s_ab8
M5s_a482
M5s_a57d
M5s_a144
M5s_a29
M5s_a106
M5s_a4b
M5s_a5b
M5s_a147
M5s_a53
M5s_a5b
M5s_a5a8
M5s_a45e
M5s_a6c
M5s_ac0
M5s_a14c
M5s_a17
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
M5s_a487
M5s_a152
M5s_a29
M5s_a106
M5s_a4b
M5s_a5b
M5s_a155
M5s_a47
M5s_a57
M5s_a4c2
M5s_a5b
M5s_a77
M5s_a63
M5s_a6c
M5s_a46c
M5s_a15a
M5s_a48b
M5s_a29
M5s_a106
M5s_a4b
M5s_a5b
M5s_a15e
M5s_a581
M5s_a53
M5s_a5b
M5s_a585
M5s_a57
M5s_a77
M5s_a63
M5s_a6c
M5s_ae7
M5s_af2
M5s_a164
M5s_af7
M5s_a491
M5s_a173
M5s_a16b
M5s_a17e
M5s_a188
M5s_a18b
    vmovups zmm24, [rcx + 0]
    vmovups zmm25, [rcx + 64]
    vmovups zmm31, [rcx + 128]
M5s_a18c
M5s_a18f
M5s_a194
M5s_a4c7
    vmovups zmm21, [r8 + 704]
    vmovups zmm22, [r8 + 768]
    vmovups zmm23, [r8 + 832]
M5s_a197
M5s_a4cc
M5s_a5c4
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
M5s_a5c7
M5s_a5d5
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm4, zmm0, [rcx + 192]
M5s_a5da
M5s_a5df
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm4, zmm0, [rcx + 256]
M5s_a1de
M5s_a5e1
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm4, zmm0, [rcx + 320]
M5s_a506
M5s_a50d
M5s_a5e3
    vpermi2ps zmm1, zmm22, zmm23
M5s_a5e6
M5s_a5fa
M5s_a60c
    vmovups zmm1, [rdx + 5760]
    vpermi2ps zmm1, zmm22, zmm23
M5s_a5b0
M5s_a200
    vmovups zmm20, [r8 + r14 + 640]
    vmovups zmm21, [r8 + r14 + 704]
    vmovups zmm22, [r8 + r14 + 768]
    vmovups zmm23, [r8 + r14 + 832]
M5s_a197
M5s_a4cc
M5s_a5c4
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vmulps zmm5, zmm0, zmm24
M5s_a5c8
M5s_a5c9
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, zmm25
M5s_a5cb
M5s_a5d0
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, zmm31
M5s_a5d1
M5s_a5d7
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 192]
M5s_a5da
M5s_a5df
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 256]
M5s_a1de
M5s_a5e1
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 320]
M5s_a506
M5s_a50d
M5s_a5e3
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 384]
M5s_a5e8
M5s_a5ec
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 448]
M5s_a5ee
M5s_a5f3
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 512]
M5s_a5f6
M5s_a5ff
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 576]
M5s_a602
M5s_a607
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 640]
M5s_a608
M5s_a60b
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 704]
M5s_a611
M5s_a619
    vpermi2ps zmm1, zmm22, zmm23
M5s_a5b3
M5s_a214
M5s_a632
M5s_a197
M5s_a4cc
M5s_a5c4
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vmulps zmm6, zmm0, zmm24
M5s_a5c8
M5s_a5c9
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, zmm25
M5s_a5cb
M5s_a5d0
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, zmm31
M5s_a5d1
M5s_a5d7
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 192]
M5s_a5da
M5s_a5df
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 256]
M5s_a1de
M5s_a5e1
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 320]
M5s_a506
M5s_a50d
M5s_a5e3
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 384]
M5s_a5e8
M5s_a5ec
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 448]
M5s_a5ee
M5s_a5f3
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 512]
M5s_a5f6
M5s_a5ff
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 576]
M5s_a602
M5s_a607
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 640]
M5s_a608
M5s_a60b
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 704]
M5s_a611
M5s_a619
    vpermi2ps zmm1, zmm22, zmm23
M5s_a5b6
M5s_a228
M5s_a64c
M5s_a197
M5s_a4cc
M5s_a5c4
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vmulps zmm7, zmm0, zmm24
M5s_a5c8
M5s_a5c9
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, zmm25
M5s_a5cb
M5s_a5d0
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, zmm31
M5s_a5d1
M5s_a5d7
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 192]
M5s_a5da
M5s_a5df
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 256]
M5s_a1de
M5s_a5e1
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 320]
M5s_a506
M5s_a50d
M5s_a5e3
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 384]
M5s_a5e8
M5s_a5ec
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 448]
M5s_a5ee
M5s_a5f3
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 512]
M5s_a5f6
M5s_a5ff
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 576]
M5s_a602
M5s_a607
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 640]
M5s_a608
M5s_a60b
    vpermi2ps zmm1, zmm22, zmm23
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 704]
M5s_a611
M5s_a619
    vpermi2ps zmm1, zmm22, zmm23
M5s_a5b9
    vmovups zmm19, [r8 + 576]
    vmovups zmm20, [r8 + 640]
M5s_a5c3
M5s_a5ce
M5s_a5e0
M5s_a5e9
M5s_a5fe
M5s_a60f
M5s_a4cc
M5s_a5c4
M5s_a61f
M5s_a5d3
    vmovups zmm1, [rdx + 1728]
M5s_a623
M5s_a508
M5s_a50c
    vmovups zmm1, [rdx + 3008]
M5s_a5e3
M5s_a627
M5s_a5f9
    vmovups zmm1, [rdx + 4416]
M5s_a62c
M5s_a614
    vmovups zmm1, [rdx + 5760]
M5s_a631
M5s_a5ca
M5s_a637
M5s_a5db
    vmovups zmm1, [rdx + 2176]
M5s_a63c
M5s_a5eb
    vmovups zmm1, [rdx + 3520]
M5s_a641
M5s_a603
    vmovups zmm1, [rdx + 4864]
M5s_a648
    vmovups zmm15, [r9 + r14 + 448]
M5s_a595
M5s_a64d
M5s_a5cf
M5s_a651
M5s_a1e2
    vmovups zmm1, [rdx + 2496]
M5s_a5e1
M5s_a654
M5s_a5f2
    vmovups zmm1, [rdx + 3968]
M5s_a657
M5s_a609
    vmovups zmm1, [rdx + 5312]
M5s_a65c
M5s_a23d
M5s_a251
M5s_a25e
M5s_a194
M5s_a4c7
M5s_a5c3
M5s_a5ce
M5s_a5e0
M5s_a5e9
M5s_a5fe
M5s_a60f
M5s_a4cc
M5s_a5c4
M5s_a61f
M5s_a5d3
M5s_a661
M5s_a507
M5s_a5e5
M5s_a629
M5s_a5fd
M5s_a62d
M5s_a615
M5s_a631
M5s_a5ca
M5s_a637
M5s_a5db
M5s_a666
M5s_a5ea
M5s_a5ed
M5s_a642
M5s_a605
M5s_a649
M5s_a595
M5s_a64d
M5s_a5cf
M5s_a651
M5s_a1e2
M5s_a669
M5s_a656
M5s_a604
M5s_a65a
M5s_a245
M5s_a4a8
M5s_a660
M5s_a5cd
M5s_a5de
M5s_a5e7
M5s_a5fc
M5s_a60e
M5s_a56d
    vmovups zmm1, [rdx + 320]
M5s_a5c4
M5s_a61f
M5s_a5d3
M5s_a661
M5s_a507
M5s_a5e5
M5s_a629
M5s_a5fd
M5s_a62d
M5s_a615
M5s_a631
M5s_a5ca
M5s_a637
M5s_a5db
M5s_a666
M5s_a5ea
M5s_a5ed
M5s_a642
M5s_a605
M5s_a649
M5s_a595
M5s_a64d
M5s_a5cf
M5s_a651
M5s_a1e2
M5s_a669
M5s_a656
M5s_a604
M5s_a65a
M5s_a253
M5s_a576
M5s_a26c
M5s_a271
M5s_a277
M5s_a281
M5s_a28e
M5s_a297
M5s_a29d
M5s_a5bb
M5s_a2a1
M5s_a284
M5s_a287
M5s_a288
M5s_a292
M5s_a2a5
M5s_a2a9
M5s_a2b0
M5s_a2b6
M5s_a2bf
    bzhi ecx, ecx, eax
M5s_a2c7
    vpmaxsd zmm8, zmm10, zmm12
M5s_a2c8
M5s_a2cc
M5s_a177
M5s_a4ab
M5s_a183
M5s_a2d1
M5s_a578
M5s_a2d8
M5s_a2dc
M5s_a2e1
M5s_a2ef
M5s_a2f3
M5s_a2f9
M5s_a305
M5s_a5a1
M5s_a2ea
M5s_a2f6
M5s_a301
M5s_a5bc
M5s_a315
M5s_a322
M5s_a32d
M5s_a2e6
M5s_a2f2
M5s_a334
M5s_a33a
    cmp rax, rcx
M5s_a5a2
M5s_a343
M5s_a349
M5s_a5bd
M5s_a310
M5s_a34e
M5s_a31f
M5s_a352
M5s_a4b0
M5s_a357
M5s_a361
M5s_a366
M5s_a35b
M5s_a36a
M5s_a36e
M5s_a372
M5s_a376
M5s_a37a
M5s_a37e
M5s_a383
M5s_a392
M5s_a39e
M5s_a3a9
M5s_a3b5
M5s_a38d
M5s_a3b8
M5s_a39a
M5s_a3be
M5s_a3c0
M5s_a3b2
M5s_a3c6
M5s_a38d
M5s_a3c8
M5s_a39a
M5s_a3ce
M5s_a3d0
M5s_a3b2
M5s_a3d6
M5s_a3da
M5s_a3de
M5s_a3e4
M5s_a3e8
M5s_a3ed
M5s_a3f1
M5s_a3f6
M5s_a3fb
M5s_a3ff
M5s_a404
M5s_a408
M5s_a40d
M5s_a411
M5s_a415
M5s_a3e1
M5s_a419
M5s_a41d
M5s_a421
M5s_a425
M5s_a429
M5s_a42d
M5s_a431
M5s_a435
M5s_a439
M5s_a43f
M5s_a445
M5s_a43e
M5s_a44a
M5s_a44e
M5s_a457
M5s_a458
