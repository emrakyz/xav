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
global xav_q2_0_12_11
align 64
xav_q2_0_12_11:
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
M2p_a2e
M2p_a32
M2p_a35
M2p_a3e
M2p_a4b
M2p_a46
M2p_a55
M2p_a61
M2p_a6b
M2p_a3eb
M2p_a477
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 320]
M2p_a6c
M2p_a70
M2p_a3f0
M2p_a57a
    vpermps ymm1, ymm3, [r8 + 324]
M2p_a73
M2p_a77
M2p_a3f1
M2p_a57b
    vpermps ymm1, ymm3, [r8 + 328]
M2p_a7d
M2p_a84
M2p_a3f2
M2p_a57e
    vpermps ymm1, ymm3, [r8 + 332]
M2p_a87
M2p_a8b
M2p_a3f5
M2p_a57f
    vpermps ymm1, ymm3, [r8 + 336]
M2p_a8f
M2p_a96
M2p_a3f6
M2p_a582
    vpermps ymm1, ymm3, [r8 + 340]
M2p_a97
M2p_a9e
M2p_a3f8
M2p_a583
    vpermps ymm1, ymm3, [r8 + 344]
M2p_aa1
M2p_aa5
M2p_a3f9
M2p_a587
    vpermps ymm1, ymm3, [r8 + 348]
M2p_aa7
M2p_aab
M2p_a3fa
M2p_a588
    vpermps ymm1, ymm3, [r8 + 352]
M2p_aae
M2p_ab2
M2p_a3fb
M2p_a58d
    vpermps ymm1, ymm3, [r8 + 356]
M2p_a47e
M2p_a480
M2p_a483
M2p_a58e
    vpermps ymm1, ymm3, [r8 + 360]
M2p_a565
M2p_a533
M2p_a535
M2p_a593
    vpermps ymm1, ymm3, [r8 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2p_a596
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 384]
M2p_a59e
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2p_a5a7
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2p_a5b0
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2p_a5b5
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2p_a5bf
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2p_a5c4
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2p_a5ca
    vfmadd231ps ymm5, ymm0, [rcx + 608]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [rax + 32]
M2p_a488
M2p_a48b
    vmovdqu ymm3, [rdx + 576]
M2p_a5ce
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [rax + 36]
M2p_a490
M2p_a493
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [rax + 324]
M2p_a5d2
    vfmadd231ps ymm5, ymm0, [rcx + 672]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [rax + 40]
M2p_a497
M2p_a499
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [rax + 328]
M2p_a5d5
    vfmadd231ps ymm5, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [rax + 44]
M2p_a49e
M2p_a4a1
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [rax + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [rax + 364]
M2p_a54b
    vpermps ymm1, ymm3, [r9 + 256]
M2p_a502
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 320]
M2p_a106
M2p_a10a
M2p_a43a
M2p_a5db
    vpermps ymm1, ymm3, [r9 + 324]
M2p_a10d
M2p_a113
M2p_a43b
M2p_a5dc
    vpermps ymm1, ymm3, [r9 + 328]
M2p_a117
M2p_a120
M2p_a43c
M2p_a5e0
    vpermps ymm1, ymm3, [r9 + 332]
M2p_a124
M2p_a128
M2p_a440
M2p_a5e2
    vpermps ymm1, ymm3, [r9 + 336]
M2p_a12c
M2p_a135
M2p_a441
M2p_a5e5
    vpermps ymm1, ymm3, [r9 + 340]
M2p_a13a
M2p_a149
M2p_a442
M2p_a5e7
    vpermps ymm1, ymm3, [r9 + 344]
M2p_a14d
M2p_a151
M2p_a446
M2p_a5ec
    vpermps ymm1, ymm3, [r9 + 348]
M2p_a156
M2p_a15d
M2p_a447
M2p_a5ee
    vpermps ymm1, ymm3, [r9 + 352]
M2p_a161
M2p_a167
M2p_a448
M2p_a5f1
    vpermps ymm1, ymm3, [r9 + 356]
M2p_a4d8
M2p_a4db
M2p_a4e0
M2p_a5f4
    vpermps ymm1, ymm3, [r9 + 360]
M2p_a570
M2p_a553
M2p_a556
M2p_a5f9
    vpermps ymm1, ymm3, [r9 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 352]
    lea rax, [r9 + r14]
M2p_a597
M2p_a5a6
M2p_a5b4
M2p_a5c2
M2p_a5cb
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [rax + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a5d1
    vpermps ymm1, ymm3, [rax + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a5d7
M2p_af6
M2p_a16c
M2p_a178
M2p_a573
M2p_a600
M2p_a179
M2p_a17d
M2p_a452
M2p_a603
    vpermps ymm1, ymm3, [r15 + 324]
M2p_a180
M2p_a186
M2p_a454
M2p_a604
    vpermps ymm1, ymm3, [r15 + 328]
M2p_a18a
M2p_a193
M2p_a457
M2p_a607
    vpermps ymm1, ymm3, [r15 + 332]
M2p_a196
M2p_a19c
M2p_a458
M2p_a609
    vpermps ymm1, ymm3, [r15 + 336]
M2p_a1a0
M2p_a1ac
M2p_a45b
M2p_a60c
    vpermps ymm1, ymm3, [r15 + 340]
M2p_a1b1
M2p_a1b9
M2p_a45c
M2p_a60e
    vpermps ymm1, ymm3, [r15 + 344]
M2p_a1bd
M2p_a1c3
M2p_a45f
M2p_a612
    vpermps ymm1, ymm3, [r15 + 348]
M2p_a1c7
M2p_a1cd
M2p_a461
M2p_a614
    vpermps ymm1, ymm3, [r15 + 352]
M2p_a1d3
M2p_a1d7
M2p_a462
M2p_a617
    vpermps ymm1, ymm3, [r15 + 356]
M2p_a4ed
M2p_a4f2
M2p_a4f9
M2p_a619
    vpermps ymm1, ymm3, [r15 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 320]
M2p_a55f
M2p_a562
M2p_a564
M2p_a621
    vfmadd231ps ymm4, ymm0, [rcx + 352]
    lea rax, [r15 + r14]
M2p_a597
M2p_a5a6
M2p_a5b4
M2p_a5c2
M2p_a5cb
M2p_a5fd
M2p_a4a2
M2p_a5ff
M2p_a1da
M2p_a66
M2p_a3ed
M2p_a478
M2p_a579
M2p_a57d
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a580
    vpermps ymm1, ymm3, [r8 + 280]
M2p_a500
M2p_a586
M2p_a58a
M2p_a485
M2p_a592
M2p_a59c
M2p_a5ad
M2p_a5ba
M2p_a5c7
M2p_a48b
M2p_a5cd
    vpermps ymm1, ymm3, [rax + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a5d4
M2p_a5ff
M2p_af5
M2p_a1eb
M2p_a100
M2p_a437
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a5da
M2p_a5de
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a5e3
M2p_a56f
M2p_a5eb
M2p_a5ef
M2p_a4e2
M2p_a5f6
M2p_a59b
M2p_a5ab
M2p_a5b8
M2p_a5c6
M2p_a48a
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a5cd
M2p_a625
    vmovdqu ymm3, [rdx + 544]
M2p_a5fe
M2p_a54c
M2p_a1ef
M2p_a173
M2p_a50e
M2p_a602
M2p_a605
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a60a
    vpermps ymm1, ymm3, [r15 + 280]
M2p_a513
M2p_a610
M2p_a615
M2p_a4fb
M2p_a61e
M2p_a59c
M2p_a5ad
M2p_a5ba
M2p_a5c7
M2p_a48b
M2p_a5cd
M2p_a625
M2p_a62b
M2p_a54a
    vmovaps ymm4, ymm2
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
    mov ecx, 1023
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
