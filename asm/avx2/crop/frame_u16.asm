%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
c64:   times 16 dw 64
maskz: times 16 dw 0
       times 16 dw -1

SECTION .text
INIT_YMM avx2
cglobal crop_frame_u16, 5, 15, 16, p, w, h, stride, best, hh, mask, magic, s3, cur, cnt, t, k, lim, step
    mov      hhq, hq
    lea      s3q, [strideq + strideq*2]
    lea      stepq, [strideq*4]
    vmovdqa  ymm0, [rel c64]
    mov      td, [bestq]
    test     tq, tq
    jz       .cols
    mov      kq, 4
    cmp      tq, kq
    cmovb    tq, kq
    cmp      tq, hhq
    cmova    tq, hhq
    mov      limq, tq
    mov      rax, 0x10000000000
    add      rax, wq
    dec      rax
    xor      edx, edx
    div      wq
    mov      magicq, rax
    mov      curq, pq
    xor      cntq, cntq
.tl:
    lea      tq, [cntq + 4]
    cmp      tq, limq
    ja       .tp
    call     .rowgrp
    test     eax, eax
    jnz      .th
    add      curq, stepq
    add      cntq, 4
    jmp      .tl
.th:
    lzcnt    eax, eax
    lea      cntq, [cntq + rax - 28]
    jmp      .ht
.tp:
    cmp      cntq, limq
    jae      .topnone
    mov      curq, limq
    sub      curq, 4
    imul     curq, strideq
    add      curq, pq
    mov      tq, limq
    sub      tq, cntq
    mov      cntq, 1
    shlx     cntq, cntq, tq
    dec      cntq
    call     .rowgrp
    and      eax, cntd
    jz       .topnone
    lzcnt    eax, eax
    lea      cntq, [limq + rax - 32]
.ht:
    test     cntq, cntq
    jnz      .htnz
    mov      [bestq], cntd
    jmp      .cols
.htnz:
    mov      td, [bestq]
    cmp      td, cntd
    cmova    td, cntd
    mov      [bestq], td
    mov      kq, 4
    cmp      tq, kq
    cmovb    tq, kq
    cmp      tq, hhq
    cmova    tq, hhq
    mov      limq, tq
.dobot:
    mov      curq, hhq
    sub      curq, 4
    imul     curq, strideq
    add      curq, pq
    xor      cntq, cntq
.bl:
    lea      tq, [cntq + 4]
    cmp      tq, limq
    ja       .bp
    call     .rowgrp
    test     eax, eax
    jnz      .bh
    sub      curq, stepq
    add      cntq, 4
    jmp      .bl
.bh:
    tzcnt    eax, eax
    add      cntq, rax
    jmp      .hb
.bp:
    cmp      cntq, limq
    jae      .cols
    mov      curq, hhq
    sub      curq, limq
    imul     curq, strideq
    add      curq, pq
    mov      tq, 4
    add      tq, cntq
    sub      tq, limq
    mov      cntq, 15
    shlx     cntq, cntq, tq
    and      cntd, 15
    call     .rowgrp
    and      eax, cntd
    jz       .cols
    tzcnt    eax, eax
    lea      cntq, [limq + rax - 4]
.hb:
    mov      td, [bestq]
    cmp      td, cntd
    cmova    td, cntd
    mov      [bestq], td
.cols:
    mov      td, [bestq + 4]
    test     tq, tq
    jz       .collapse
    mov      kq, 32
    cmp      tq, kq
    cmovb    tq, kq
    cmp      tq, wq
    cmova    tq, wq
    mov      limq, tq
    xor      cntq, cntq
.pl:
    lea      tq, [cntq + 32]
    cmp      tq, limq
    ja       .pp
    lea      curq, [pq + cntq*2]
    call     .colchunk
    tzcnt    eax, eax
    mov      stepq, rax
    mov      curq, wq
    sub      curq, 32
    sub      curq, cntq
    add      curq, curq
    add      curq, pq
    call     .colchunk
    lzcnt    eax, eax
    cmp      stepq, rax
    cmovb    rax, stepq
    cmp      rax, 32
    jb       .ph
    add      cntq, 32
    jmp      .pl
.ph:
    add      cntq, rax
    jmp      .hp
.pp:
    cmp      cntq, limq
    jae      .collapse
    lea      tq, [cntq + 32]
    sub      tq, limq
    mov      cntq, tq
    lea      curq, [pq + limq*2 - 64]
    call     .colchunk
    mov      tq, -1
    shlx     td, td, cntd
    and      eax, td
    tzcnt    eax, eax
    mov      stepq, rax
    mov      curq, wq
    sub      curq, limq
    add      curq, curq
    add      curq, pq
    call     .colchunk
    mov      tq, -1
    shrx     td, td, cntd
    and      eax, td
    lzcnt    eax, eax
    cmp      stepq, rax
    cmovb    rax, stepq
    cmp      rax, 32
    jae      .collapse
    lea      cntq, [limq + rax - 32]
.hp:
    mov      td, [bestq + 4]
    cmp      td, cntd
    cmova    td, cntd
    mov      [bestq + 4], td
    jmp      .collapse
.collapse:
    mov      td, [bestq]
    mov      kd, [bestq + 4]
    cmp      tq, kq
    cmovb    tq, kq
    cmp      tq, 2
    setb     al
    movzx    eax, al
    RET
.topnone:
    cmp      limq, hhq
    jb       .dobot
    xor      eax, eax
    RET


.rowgrp:
    vpxor    xmm1, xmm1, xmm1
    vpxor    xmm2, xmm2, xmm2
    vpxor    xmm3, xmm3, xmm3
    vpxor    xmm4, xmm4, xmm4
    vpxor    xmm5, xmm5, xmm5
    vpxor    xmm6, xmm6, xmm6
    vpxor    xmm7, xmm7, xmm7
    vpxor    xmm8, xmm8, xmm8
    vpxor    xmm9, xmm9, xmm9
    vpxor    xmm10, xmm10, xmm10
    vpxor    xmm11, xmm11, xmm11
    vpxor    xmm12, xmm12, xmm12
    mov      tq, curq
    mov      hd, wd
    shr      hq, 4
    jz       .rg_tail
.rg_outer:
    mov      kq, 64
    cmp      hq, kq
    cmovb    kq, hq
    sub      hq, kq
.rg_inner:
    vpmaxuw  ymm13, ymm0, [tq]
    vpaddw   ymm1, ymm1, ymm13
    vpmaxuw  ymm9, ymm9, ymm13
    vpmaxuw  ymm13, ymm0, [tq + strideq]
    vpaddw   ymm2, ymm2, ymm13
    vpmaxuw  ymm10, ymm10, ymm13
    vpmaxuw  ymm13, ymm0, [tq + strideq*2]
    vpaddw   ymm3, ymm3, ymm13
    vpmaxuw  ymm11, ymm11, ymm13
    vpmaxuw  ymm13, ymm0, [tq + s3q]
    vpaddw   ymm4, ymm4, ymm13
    vpmaxuw  ymm12, ymm12, ymm13
    add      tq, 32
    dec      kq
    jnz      .rg_inner
    vpmovzxwd ymm14, xmm1
    vpaddd    ymm5, ymm5, ymm14
    vextracti128 xmm14, ymm1, 1
    vpmovzxwd ymm14, xmm14
    vpaddd    ymm5, ymm5, ymm14
    vpxor     xmm1, xmm1, xmm1
    vpmovzxwd ymm14, xmm2
    vpaddd    ymm6, ymm6, ymm14
    vextracti128 xmm14, ymm2, 1
    vpmovzxwd ymm14, xmm14
    vpaddd    ymm6, ymm6, ymm14
    vpxor     xmm2, xmm2, xmm2
    vpmovzxwd ymm14, xmm3
    vpaddd    ymm7, ymm7, ymm14
    vextracti128 xmm14, ymm3, 1
    vpmovzxwd ymm14, xmm14
    vpaddd    ymm7, ymm7, ymm14
    vpxor     xmm3, xmm3, xmm3
    vpmovzxwd ymm14, xmm4
    vpaddd    ymm8, ymm8, ymm14
    vextracti128 xmm14, ymm4, 1
    vpmovzxwd ymm14, xmm14
    vpaddd    ymm8, ymm8, ymm14
    vpxor     xmm4, xmm4, xmm4
    test     hq, hq
    jnz      .rg_outer
.rg_tail:
    mov      hd, wd
    and      hq, 15
    jz       .rg_red
    lea      kq, [rel maskz]
    vmovdqu  ymm15, [kq + hq*2]
    lea      tq, [curq + wq*2 - 32]
    vmovdqu  ymm13, [tq]
    vpmaxuw  ymm13, ymm0, ymm13
    vpmaxuw  ymm9, ymm9, ymm13
    vpand    ymm13, ymm13, ymm15
    vpaddw   ymm1, ymm1, ymm13
    vmovdqu  ymm13, [tq + strideq]
    vpmaxuw  ymm13, ymm0, ymm13
    vpmaxuw  ymm10, ymm10, ymm13
    vpand    ymm13, ymm13, ymm15
    vpaddw   ymm2, ymm2, ymm13
    vmovdqu  ymm13, [tq + strideq*2]
    vpmaxuw  ymm13, ymm0, ymm13
    vpmaxuw  ymm11, ymm11, ymm13
    vpand    ymm13, ymm13, ymm15
    vpaddw   ymm3, ymm3, ymm13
    vmovdqu  ymm13, [tq + s3q]
    vpmaxuw  ymm13, ymm0, ymm13
    vpmaxuw  ymm12, ymm12, ymm13
    vpand    ymm13, ymm13, ymm15
    vpaddw   ymm4, ymm4, ymm13
    vpmovzxwd ymm14, xmm1
    vpaddd    ymm5, ymm5, ymm14
    vextracti128 xmm14, ymm1, 1
    vpmovzxwd ymm14, xmm14
    vpaddd    ymm5, ymm5, ymm14
    vpxor     xmm1, xmm1, xmm1
    vpmovzxwd ymm14, xmm2
    vpaddd    ymm6, ymm6, ymm14
    vextracti128 xmm14, ymm2, 1
    vpmovzxwd ymm14, xmm14
    vpaddd    ymm6, ymm6, ymm14
    vpxor     xmm2, xmm2, xmm2
    vpmovzxwd ymm14, xmm3
    vpaddd    ymm7, ymm7, ymm14
    vextracti128 xmm14, ymm3, 1
    vpmovzxwd ymm14, xmm14
    vpaddd    ymm7, ymm7, ymm14
    vpxor     xmm3, xmm3, xmm3
    vpmovzxwd ymm14, xmm4
    vpaddd    ymm8, ymm8, ymm14
    vextracti128 xmm14, ymm4, 1
    vpmovzxwd ymm14, xmm14
    vpaddd    ymm8, ymm8, ymm14
    vpxor     xmm4, xmm4, xmm4
.rg_red:
    xor      eax, eax
    vextracti128 xmm14, ymm5, 1
    vpaddd       xmm5, xmm5, xmm14
    vpshufd      xmm14, xmm5, 0xee
    vpaddd       xmm5, xmm5, xmm14
    vpshufd      xmm14, xmm5, 0x55
    vpaddd       xmm5, xmm5, xmm14
    vmovd        td, xmm5
    imul         tq, magicq
    shr          tq, 40
    lea          kd, [tq + 64]
    vmovd        xmm14, kd
    vpbroadcastw ymm14, xmm14
    vpmaxuw      ymm15, ymm9, ymm14
    vpcmpeqw     ymm15, ymm15, ymm14
    vpmovmskb    kd, ymm15
    cmp          kd, -1
    setne        kb
    cmp          td, 128
    setae        tb
    or           tb, kb
    movzx        tq, tb
    lea          eax, [rax + rax]
    or           eax, td
    vextracti128 xmm14, ymm6, 1
    vpaddd       xmm6, xmm6, xmm14
    vpshufd      xmm14, xmm6, 0xee
    vpaddd       xmm6, xmm6, xmm14
    vpshufd      xmm14, xmm6, 0x55
    vpaddd       xmm6, xmm6, xmm14
    vmovd        td, xmm6
    imul         tq, magicq
    shr          tq, 40
    lea          kd, [tq + 64]
    vmovd        xmm14, kd
    vpbroadcastw ymm14, xmm14
    vpmaxuw      ymm15, ymm10, ymm14
    vpcmpeqw     ymm15, ymm15, ymm14
    vpmovmskb    kd, ymm15
    cmp          kd, -1
    setne        kb
    cmp          td, 128
    setae        tb
    or           tb, kb
    movzx        tq, tb
    lea          eax, [rax + rax]
    or           eax, td
    vextracti128 xmm14, ymm7, 1
    vpaddd       xmm7, xmm7, xmm14
    vpshufd      xmm14, xmm7, 0xee
    vpaddd       xmm7, xmm7, xmm14
    vpshufd      xmm14, xmm7, 0x55
    vpaddd       xmm7, xmm7, xmm14
    vmovd        td, xmm7
    imul         tq, magicq
    shr          tq, 40
    lea          kd, [tq + 64]
    vmovd        xmm14, kd
    vpbroadcastw ymm14, xmm14
    vpmaxuw      ymm15, ymm11, ymm14
    vpcmpeqw     ymm15, ymm15, ymm14
    vpmovmskb    kd, ymm15
    cmp          kd, -1
    setne        kb
    cmp          td, 128
    setae        tb
    or           tb, kb
    movzx        tq, tb
    lea          eax, [rax + rax]
    or           eax, td
    vextracti128 xmm14, ymm8, 1
    vpaddd       xmm8, xmm8, xmm14
    vpshufd      xmm14, xmm8, 0xee
    vpaddd       xmm8, xmm8, xmm14
    vpshufd      xmm14, xmm8, 0x55
    vpaddd       xmm8, xmm8, xmm14
    vmovd        td, xmm8
    imul         tq, magicq
    shr          tq, 40
    lea          kd, [tq + 64]
    vmovd        xmm14, kd
    vpbroadcastw ymm14, xmm14
    vpmaxuw      ymm15, ymm12, ymm14
    vpcmpeqw     ymm15, ymm15, ymm14
    vpmovmskb    kd, ymm15
    cmp          kd, -1
    setne        kb
    cmp          td, 128
    setae        tb
    or           tb, kb
    movzx        tq, tb
    lea          eax, [rax + rax]
    or           eax, td
    ret

.colchunk:
    vpxor      xmm1, xmm1, xmm1
    vpxor      xmm2, xmm2, xmm2
    vpxor      xmm3, xmm3, xmm3
    vpxor      xmm4, xmm4, xmm4
    vpxor      xmm5, xmm5, xmm5
    vpxor      xmm6, xmm6, xmm6
    vpxor      xmm7, xmm7, xmm7
    vpxor      xmm8, xmm8, xmm8
    mov        tq, curq
    mov        hq, hhq
.cc_outer:
    mov        kq, 64
    cmp        hq, kq
    cmovb      kq, hq
    sub        hq, kq
    mov        magicq, kq
    shr        magicq, 2
    jz         .cc_tail
.cc_blk4:
    vpmaxuw    ymm9, ymm0, [tq]
    vpmaxuw    ymm7, ymm7, ymm9
    vpaddw     ymm1, ymm1, ymm9
    vpmaxuw    ymm10, ymm0, [tq + 32]
    vpmaxuw    ymm8, ymm8, ymm10
    vpaddw     ymm2, ymm2, ymm10
    vpmaxuw    ymm9, ymm0, [tq + strideq]
    vpmaxuw    ymm7, ymm7, ymm9
    vpaddw     ymm1, ymm1, ymm9
    vpmaxuw    ymm10, ymm0, [tq + strideq + 32]
    vpmaxuw    ymm8, ymm8, ymm10
    vpaddw     ymm2, ymm2, ymm10
    vpmaxuw    ymm9, ymm0, [tq + strideq*2]
    vpmaxuw    ymm7, ymm7, ymm9
    vpaddw     ymm1, ymm1, ymm9
    vpmaxuw    ymm10, ymm0, [tq + strideq*2 + 32]
    vpmaxuw    ymm8, ymm8, ymm10
    vpaddw     ymm2, ymm2, ymm10
    vpmaxuw    ymm9, ymm0, [tq + s3q]
    vpmaxuw    ymm7, ymm7, ymm9
    vpaddw     ymm1, ymm1, ymm9
    vpmaxuw    ymm10, ymm0, [tq + s3q + 32]
    vpmaxuw    ymm8, ymm8, ymm10
    vpaddw     ymm2, ymm2, ymm10
    lea        tq, [tq + strideq*4]
    dec        magicq
    jnz        .cc_blk4
.cc_tail:
    and        kq, 3
    jz         .cc_flush
.cc_blk1:
    vpmaxuw    ymm9, ymm0, [tq]
    vpmaxuw    ymm7, ymm7, ymm9
    vpaddw     ymm1, ymm1, ymm9
    vpmaxuw    ymm10, ymm0, [tq + 32]
    vpmaxuw    ymm8, ymm8, ymm10
    vpaddw     ymm2, ymm2, ymm10
    add        tq, strideq
    dec        kq
    jnz        .cc_blk1
.cc_flush:
    vpmovzxwd  ymm9, xmm1
    vpaddd     ymm3, ymm3, ymm9
    vextracti128 xmm10, ymm1, 1
    vpmovzxwd  ymm9, xmm10
    vpaddd     ymm4, ymm4, ymm9
    vpmovzxwd  ymm9, xmm2
    vpaddd     ymm5, ymm5, ymm9
    vextracti128 xmm10, ymm2, 1
    vpmovzxwd  ymm9, xmm10
    vpaddd     ymm6, ymm6, ymm9
    vpxor      xmm1, xmm1, xmm1
    vpxor      xmm2, xmm2, xmm2
    test       hq, hq
    jnz        .cc_outer
    vpsubusw   ymm7, ymm7, ymm0
    vpsubusw   ymm8, ymm8, ymm0
    vmovd      xmm9, hhd
    vpbroadcastd ymm11, xmm9
    mov        td, hhd
    shl        td, 7
    dec        td
    vmovd      xmm9, td
    vpbroadcastd ymm12, xmm9
    xor        eax, eax
    vmovdqa    xmm9, xmm7
    vpmovzxwd  ymm9, xmm9
    vpmulld    ymm9, ymm9, ymm11
    vpcmpgtd   ymm9, ymm9, ymm3
    vpcmpgtd   ymm13, ymm3, ymm12
    vpor       ymm9, ymm9, ymm13
    vmovmskps  td, ymm9
    or         eax, td
    vextracti128 xmm9, ymm7, 1
    vpmovzxwd  ymm9, xmm9
    vpmulld    ymm9, ymm9, ymm11
    vpcmpgtd   ymm9, ymm9, ymm4
    vpcmpgtd   ymm13, ymm4, ymm12
    vpor       ymm9, ymm9, ymm13
    vmovmskps  td, ymm9
    shl        td, 8
    or         eax, td
    vmovdqa    xmm9, xmm8
    vpmovzxwd  ymm9, xmm9
    vpmulld    ymm9, ymm9, ymm11
    vpcmpgtd   ymm9, ymm9, ymm5
    vpcmpgtd   ymm13, ymm5, ymm12
    vpor       ymm9, ymm9, ymm13
    vmovmskps  td, ymm9
    shl        td, 16
    or         eax, td
    vextracti128 xmm9, ymm8, 1
    vpmovzxwd  ymm9, xmm9
    vpmulld    ymm9, ymm9, ymm11
    vpcmpgtd   ymm9, ymm9, ymm6
    vpcmpgtd   ymm13, ymm6, ymm12
    vpor       ymm9, ymm9, ymm13
    vmovmskps  td, ymm9
    shl        td, 24
    or         eax, td
    ret

