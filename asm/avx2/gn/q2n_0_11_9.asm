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
global xav_q2_0_11_9
align 64
xav_q2_0_11_9:
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
M2p_a3ec
M2p_a80
M2p_a86
M2p_a3f4
M2p_a9a
M2p_a3f7
M2p_ab1
M2p_a467
M2p_a47e
M2p_a480
M2p_a483
    vfmadd231ps ymm4, ymm0, [rcx + 320]
M2p_a3fd
M2p_a400
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [rax + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 352]
M2p_a403
M2p_a405
    vpermps ymm1, ymm3, [rax + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2p_a40a
M2p_a40f
    vpermps ymm1, ymm3, [rax + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2p_a413
M2p_a416
    vpermps ymm1, ymm3, [rax + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2p_a41a
M2p_a41e
    vpermps ymm1, ymm3, [rax + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2p_a422
M2p_a425
    vpermps ymm1, ymm3, [rax + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2p_a426
M2p_a428
    vpermps ymm1, ymm3, [rax + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2p_a42a
M2p_a42c
    vpermps ymm1, ymm3, [rax + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2p_a42d
M2p_abd
M2p_a430
    vpermps ymm1, ymm3, [rax + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2p_a431
M2p_ac4
M2p_a434
    vpermps ymm1, ymm3, [rax + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [rax + 40]
M2p_ac6
    vpermps ymm1, ymm3, [rax + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a523
    vpermps ymm1, ymm3, [rax + 296]
M2p_a4cf
M2p_a439
M2p_a11e
M2p_a43e
M2p_a141
M2p_a443
M2p_a164
M2p_a46b
M2p_a4d8
M2p_a4db
M2p_a4e0
    vfmadd231ps ymm4, ymm0, [rcx + 320]
M2p_a44b
M2p_a400
M2p_a519
M2p_a415
M2p_a419
M2p_a51b
M2p_a427
M2p_a51d
M2p_ac1
M2p_ac4
M2p_a434
M2p_a520
    vmovaps ymm4, ymm2
M2p_a44e
M2p_a183
M2p_a455
M2p_a1a6
M2p_a45a
M2p_a1cb
    vpermps ymm1, ymm3, [r15 + 256]
M2p_a460
M2p_a4ef
M2p_a4f4
    vpermps ymm1, ymm3, [r15 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 320]
M2p_a464
M2p_a400
M2p_a519
M2p_a415
M2p_a419
M2p_a51b
M2p_a427
M2p_a51d
M2p_ac1
M2p_ac4
M2p_a434
M2p_a520
M2p_a1e0
M2p_a6a
M2p_a3ef
M2p_a81
M2p_a3f3
M2p_a99
M2p_a466
M2p_ab0
M2p_a501
    vpermps ymm1, ymm3, [r8 + 292]
M2p_a47e
M2p_a480
M2p_a483
M2p_a518
M2p_a40d
M2p_a51a
M2p_a423
    vmovdqu ymm3, [rdx + 480]
M2p_a51c
M2p_ab8
M2p_abc
M2p_a42f
    vmovdqu ymm3, [rdx + 480]
M2p_a51e
M2p_ac6
M2p_a522
M2p_a4d0
M2p_a1e9
M2p_aff
M2p_a436
M2p_a11c
M2p_a504
M2p_a43f
M2p_a143
M2p_a444
M2p_a165
M2p_a448
M2p_a4d9
M2p_a4dc
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2p_a525
M2p_a40d
M2p_a51a
M2p_a423
M2p_a52b
M2p_ab7
M2p_abb
M2p_a42e
M2p_a51f
M2p_ac7
M2p_a524
M2p_af6
M2p_a1f1
M2p_a178
M2p_a451
M2p_a190
M2p_a456
M2p_a1b4
M2p_a46d
M2p_a1d5
M2p_a514
    vpermps ymm1, ymm3, [r15 + 292]
M2p_a4ed
M2p_a4f2
M2p_a4f9
M2p_a52a
M2p_a40d
M2p_a51a
M2p_a423
M2p_a52b
M2p_ab7
M2p_abb
M2p_a42e
M2p_a51f
M2p_ac7
M2p_a524
M2p_a1df
M2p_a1e6
M2p_a1f4
M2p_a1fd
M2p_a205
M2p_a214
M2p_a21e
M2p_a228
M2p_a22d
M2p_a231
M2p_a209
M2p_a20d
M2p_a471
M2p_a218
M2p_a221
    add r9, 288
    dec r11
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
    cmovb rcx, rbx
M2p_a322
M2p_a326
M2p_a32c
M2p_a330
M2p_a335
M2p_a339
M2p_a33d
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
