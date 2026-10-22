%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_16_13_pft: dq xav_g2_0_16_13.pf1, xav_g2_0_16_13.pf2, xav_g2_0_16_13.pf3, xav_g2_0_16_13.pf4, xav_g2_0_16_13.pf5, xav_g2_0_16_13.pf6, xav_g2_0_16_13.pf7, xav_g2_0_16_13.pf8, xav_g2_0_16_13.pf9, xav_g2_0_16_13.pf10, xav_g2_0_16_13.pf11, xav_g2_0_16_13.pf12, xav_g2_0_16_13.pf13, xav_g2_0_16_13.pf14, xav_g2_0_16_13.pf15, xav_g2_0_16_13.pf16, xav_g2_0_16_13.pf17, xav_g2_0_16_13.pf18, xav_g2_0_16_13.pf19, xav_g2_0_16_13.pf20, xav_g2_0_16_13.pf21, xav_g2_0_16_13.pf22, xav_g2_0_16_13.pf23, xav_g2_0_16_13.pf24, xav_g2_0_16_13.pf25, xav_g2_0_16_13.pf26, xav_g2_0_16_13.pf27, xav_g2_0_16_13.pf28, xav_g2_0_16_13.pf29, xav_g2_0_16_13.pf30, xav_g2_0_16_13.pf31, xav_g2_0_16_13.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_16_13
align 64
xav_g2_0_16_13:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_16_13_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a13
M2s_a19
M2s_a466
M2s_a540
M2s_a60b
M2s_a6e1
M2s_a772
M2s_a48
M2s_a69d
M2s_a615
M2s_a6e9
M2s_a44d
M2s_a4e6
M2s_a7a6
M2s_a7c
M2s_a77d
M2s_a61e
M2s_a6f0
M2s_a479
    vmovdqu ymm3, [rdx + 288]
M2s_a622
M2s_a6f3
M2s_a5cc
M2s_a5f2
M2s_a777
M2s_a6a4
M2s_a7a8
M2s_a781
M2s_a782
M2s_a80b
    vfmadd231ps ymm4, ymm0, [rcx + 448]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 60]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 444]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 480]
M2s_a6fa
M2s_a702
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 512]
M2s_a704
M2s_a708
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_a709
M2s_a711
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_a712
M2s_a717
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_a718
M2s_a71e
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_a71f
M2s_a724
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_a725
M2s_a72c
    vpermps ymm1, ymm3, [r13 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_a72e
M2s_a731
    vpermps ymm1, ymm3, [r13 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_a732
M2s_a735
    vpermps ymm1, ymm3, [r13 + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2s_a736
M2s_a737
    vpermps ymm1, ymm3, [r13 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2s_a738
M2s_a73b
    vpermps ymm1, ymm3, [r13 + 424]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 832]
M2s_a73c
M2s_a73e
    vpermps ymm1, ymm3, [r13 + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 864]
M2s_a73f
M2s_a741
    vpermps ymm1, ymm3, [r13 + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 896]
M2s_a743
M2s_a745
    vpermps ymm1, ymm3, [r13 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 928]
M2s_a7b0
M2s_a7b2
    vpermps ymm1, ymm3, [r13 + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 960]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 60]
M2s_a660
M2s_a661
M2s_a663
    vpermps ymm1, ymm3, [r13 + 380]
M2s_a817
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 444]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 992]
M2s_abe
M2s_aca
M2s_a4bc
M2s_a78f
    vpermps ymm1, ymm3, [r9 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a746
M2s_a778
M2s_af4
M2s_a790
M2s_a680
M2s_a750
M2s_a4ea
M2s_a7b4
M2s_a12f
M2s_a609
M2s_a689
M2s_a759
M2s_a4d6
    vmovdqu ymm3, [rdx + 288]
M2s_a68c
M2s_a75c
M2s_a5dc
M2s_a600
M2s_a77b
M2s_a6b3
M2s_a7b5
M2s_a796
M2s_a798
M2s_a7bf
    vfmadd231ps ymm6, ymm0, [rcx + 448]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 60]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 444]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 480]
M2s_a766
M2s_a702
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 512]
M2s_a704
M2s_a708
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_a709
M2s_a711
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_a712
M2s_a717
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_a718
M2s_a71e
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_a71f
M2s_a724
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_a725
M2s_a72c
    vpermps ymm1, ymm3, [r13 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_a72e
M2s_a731
    vpermps ymm1, ymm3, [r13 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_a732
M2s_a735
    vpermps ymm1, ymm3, [r13 + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_a736
M2s_a737
    vpermps ymm1, ymm3, [r13 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 800]
M2s_a738
M2s_a73b
    vpermps ymm1, ymm3, [r13 + 424]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 832]
M2s_a73c
M2s_a73e
    vpermps ymm1, ymm3, [r13 + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 864]
M2s_a73f
M2s_a741
    vpermps ymm1, ymm3, [r13 + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 896]
M2s_a743
M2s_a745
    vpermps ymm1, ymm3, [r13 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 928]
M2s_a7b0
M2s_a7b2
    vpermps ymm1, ymm3, [r13 + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 960]
M2s_a816
M2s_a818
    vpermps ymm1, ymm3, [r13 + 444]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 992]
M2s_a140
M2s_a21
M2s_a44b
M2s_a6bd
M2s_a7a3
M2s_a770
M2s_a80a
M2s_a6e5
M2s_a3f5
M2s_a549
M2s_a612
M2s_a6e7
M2s_a4e5
M2s_a54f
M2s_a774
M2s_a7f
M2s_a3fa
M2s_a553
M2s_a61c
M2s_a6ee
M2s_a478
M2s_a55b
M2s_a776
M2s_a5cb
M2s_a5f0
M2s_a627
M2s_a6f6
M2s_a6a5
M2s_a6c7
M2s_a6f9
M2s_a77e
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 408]
M2s_a80b
M2s_a80d
M2s_a700
M2s_a702
M2s_a80e
M2s_a70c
M2s_a80f
M2s_a71b
M2s_a71d
    vmovdqu ymm3, [rdx + 736]
M2s_a810
M2s_a727
M2s_a811
M2s_a630
M2s_a735
M2s_a812
M2s_a640
M2s_a73a
M2s_a813
M2s_a650
M2s_a741
M2s_a814
M2s_a65b
M2s_a7b1
M2s_a815
M2s_a4bc
M2s_a78f
M2s_a819
M2s_ae1
M2s_a6d4
M2s_a67b
M2s_a74b
M2s_a504
M2s_a535
M2s_a791
M2s_a779
M2s_a11a
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 280]
M2s_a5fa
M2s_a7b4
M2s_a12f
M2s_a609
M2s_a689
M2s_a759
M2s_a4d6
M2s_a81a
M2s_a5d9
M2s_a5de
M2s_a6d8
M2s_a762
M2s_a6b4
M2s_a765
M2s_a7be
M2s_a797
    vpermps ymm1, ymm3, [r9 + 408]
M2s_a7bf
M2s_a81b
M2s_a700
M2s_a702
M2s_a81c
M2s_a70c
M2s_a81d
M2s_a71b
M2s_a71d
    vmovdqu ymm3, [rdx + 736]
M2s_a81e
M2s_a727
M2s_a81f
M2s_a630
M2s_a735
M2s_a820
M2s_a640
M2s_a73a
M2s_a821
M2s_a650
M2s_a741
M2s_a822
M2s_a65b
M2s_a7b1
M2s_a823
M2s_a817
    vmovdqu ymm3, [rdx + 736]
M2s_a824
M2s_a14e
M2s_a157
M2s_a15d
M2s_a16f
M2s_a181
M2s_a18e
M2s_a19b
M2s_a1b9
M2s_a1c8
M2s_a1d2
M2s_a1d8
M2s_a1e2
M2s_a1ec
M2s_a1f6
M2s_a164
M2s_a169
M2s_a1ff
M2s_a17d
M2s_a209
M2s_a191
M2s_a212
M2s_a1a7
M2s_a1b4
M2s_a454
M2s_a1a0
M2s_a4f0
M2s_a506
M2s_a53c
M2s_a5c5
M2s_a226
M2s_a22f
M2s_a237
M2s_a240
M2s_a248
M2s_a24f
M2s_a256
M2s_a260
M2s_a267
M2s_a275
M2s_a28a
M2s_a27f
M2s_a285
M2s_a295
M2s_a29c
M2s_a2ae
M2s_a45a
M2s_a2a8
M2s_a2b0
M2s_a2c7
M2s_a2be
M2s_a69c
M2s_a2cd
M2s_a2d2
M2s_a2c2
M2s_a45e
M2s_a2dc
M2s_a2e0
M2s_a6c2
M2s_a286
M2s_a2e5
M2s_a2e8
M2s_a80c
M2s_a2ef
M2s_a2ba
M2s_a2f7
M2s_a300
M2s_a2fa
M2s_a5c7
M2s_a306
M2s_a313
M2s_a318
M2s_a321
M2s_a461
M2s_a32e
M2s_a332
M2s_a30e
M2s_a322
M2s_a336
M2s_a339
M2s_a342
M2s_a34c
M2s_a357
M2s_a312
M2s_a326
M2s_a35b
M2s_a4f3
M2s_a363
M2s_a369
M2s_a36c
M2s_a346
    xor edx, edx
M2s_a4f4
M2s_a352
M2s_a371
M2s_a377
M2s_a382
M2s_a389
M2s_a37b
M2s_a37e
M2s_a385
M2s_a38d
M2s_a391
M2s_a395
M2s_a399
M2s_a39d
M2s_a3a1
M2s_a3aa
M2s_a3bb
M2s_a3a6
M2s_a3af
M2s_a3c5
M2s_a3c0
M2s_a3cb
M2s_a3b3
M2s_a3cd
M2s_a3c0
M2s_a3d3
M2s_a3d7
M2s_a3db
M2s_a3df
M2s_a3e3
M2s_a3e7
M2s_a3ed
    ret
section .note.GNU-stack noalloc noexec nowrite progbits
