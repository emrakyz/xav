%include "dav1d_x86inc.asm"

SECTION_RODATA 32
ALIGN 32
c16:   times 32 db 16
maskz: times 32 db 0
       times 32 db -1

SECTION .text
INIT_YMM avx2
cglobal crop_frame_u8, 5, 15, 14, p, w, h, stride, best, hh, mask, magic, s3, cur, cnt, t, k, lim, step
    mov      hhq, hq
    lea      s3q, [strideq + strideq*2]
    lea      stepq, [strideq*4]
    vmovdqa  ymm0, [rel c16]
    vpxor    xmm1, xmm1, xmm1
    mov      td, [bestq]
    test     tq, tq
    jz       .cols
    mov      kq, 4
    cmp      tq, kq
    cmovb    tq, kq
    cmp      tq, hhq
    cmova    tq, hhq
    mov      limq, tq
%if WIN64
    mov      kq, wq
    mov      rax, 0x10000000000
    add      rax, kq
    dec      rax
    xor      edx, edx
    div      kq
    mov      wq, kq
%else
    mov      rax, 0x10000000000
    add      rax, wq
    dec      rax
    xor      edx, edx
    div      wq
%endif
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
    lea      s3q, [strideq + strideq*2]
    xor      cntq, cntq
.pl:
    lea      tq, [cntq + 32]
    cmp      tq, limq
    ja       .pp
    lea      curq, [pq + cntq]
    call     .colchunk
    tzcnt    eax, eax
    mov      stepq, rax
    mov      curq, wq
    sub      curq, 32
    sub      curq, cntq
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
    lea      curq, [pq + limq - 32]
    call     .colchunk
    mov      tq, -1
    shlx     td, td, cntd
    and      eax, td
    tzcnt    eax, eax
    mov      stepq, rax
    mov      curq, wq
    sub      curq, limq
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
    vpxor    xmm2, xmm2, xmm2
    vpxor    xmm3, xmm3, xmm3
    vpxor    xmm4, xmm4, xmm4
    vpxor    xmm5, xmm5, xmm5
    vpxor    xmm6, xmm6, xmm6
    vpxor    xmm7, xmm7, xmm7
    vpxor    xmm8, xmm8, xmm8
    vpxor    xmm9, xmm9, xmm9
    mov      tq, curq
    lea      kq, [curq + strideq*2]
    mov      hd, wd
    shr      hq, 5
    jz       .rg_tail
.rg_loop:
    vpmaxub  ymm10, ymm0, [tq]
    vpsadbw  ymm12, ymm10, ymm1
    vpaddq   ymm2, ymm2, ymm12
    vpmaxub  ymm6, ymm6, ymm10
    vpmaxub  ymm11, ymm0, [tq + strideq]
    vpsadbw  ymm12, ymm11, ymm1
    vpaddq   ymm3, ymm3, ymm12
    vpmaxub  ymm7, ymm7, ymm11
    vpmaxub  ymm10, ymm0, [kq]
    vpsadbw  ymm12, ymm10, ymm1
    vpaddq   ymm4, ymm4, ymm12
    vpmaxub  ymm8, ymm8, ymm10
    vpmaxub  ymm11, ymm0, [kq + strideq]
    vpsadbw  ymm12, ymm11, ymm1
    vpaddq   ymm5, ymm5, ymm12
    vpmaxub  ymm9, ymm9, ymm11
    add      tq, 32
    add      kq, 32
    dec      hq
    jnz      .rg_loop
.rg_tail:
    mov      hd, wd
    and      hq, 31
    jz       .rg_red
    lea      kq, [rel maskz]
    vmovdqu  ymm13, [kq + hq]
    lea      tq, [curq + wq - 32]
    lea      kq, [tq + strideq*2]
    vmovdqu  ymm10, [tq]
    vpmaxub  ymm10, ymm0, ymm10
    vpmaxub  ymm6, ymm6, ymm10
    vpand    ymm10, ymm10, ymm13
    vpsadbw  ymm12, ymm10, ymm1
    vpaddq   ymm2, ymm2, ymm12
    vmovdqu  ymm11, [tq + strideq]
    vpmaxub  ymm11, ymm0, ymm11
    vpmaxub  ymm7, ymm7, ymm11
    vpand    ymm11, ymm11, ymm13
    vpsadbw  ymm12, ymm11, ymm1
    vpaddq   ymm3, ymm3, ymm12
    vmovdqu  ymm10, [kq]
    vpmaxub  ymm10, ymm0, ymm10
    vpmaxub  ymm8, ymm8, ymm10
    vpand    ymm10, ymm10, ymm13
    vpsadbw  ymm12, ymm10, ymm1
    vpaddq   ymm4, ymm4, ymm12
    vmovdqu  ymm11, [kq + strideq]
    vpmaxub  ymm11, ymm0, ymm11
    vpmaxub  ymm9, ymm9, ymm11
    vpand    ymm11, ymm11, ymm13
    vpsadbw  ymm12, ymm11, ymm1
    vpaddq   ymm5, ymm5, ymm12
.rg_red:
    xor      eax, eax
    vextracti128 xmm12, ymm2, 1
    vpaddq       xmm2, xmm2, xmm12
    vpshufd      xmm12, xmm2, 0xee
    vpaddq       xmm2, xmm2, xmm12
    vmovd        td, xmm2
    imul         tq, magicq
    shr          tq, 40
    lea          kd, [tq + 16]
    vmovd        xmm12, kd
    vpbroadcastb ymm12, xmm12
    vpmaxub      ymm13, ymm6, ymm12
    vpcmpeqb     ymm13, ymm13, ymm12
    vpmovmskb    kd, ymm13
    cmp          kd, -1
    setne        kb
    cmp          td, 32
    setae        tb
    or           tb, kb
    movzx        tq, tb
    lea          eax, [rax + rax]
    or           eax, td
    vextracti128 xmm12, ymm3, 1
    vpaddq       xmm3, xmm3, xmm12
    vpshufd      xmm12, xmm3, 0xee
    vpaddq       xmm3, xmm3, xmm12
    vmovd        td, xmm3
    imul         tq, magicq
    shr          tq, 40
    lea          kd, [tq + 16]
    vmovd        xmm12, kd
    vpbroadcastb ymm12, xmm12
    vpmaxub      ymm13, ymm7, ymm12
    vpcmpeqb     ymm13, ymm13, ymm12
    vpmovmskb    kd, ymm13
    cmp          kd, -1
    setne        kb
    cmp          td, 32
    setae        tb
    or           tb, kb
    movzx        tq, tb
    lea          eax, [rax + rax]
    or           eax, td
    vextracti128 xmm12, ymm4, 1
    vpaddq       xmm4, xmm4, xmm12
    vpshufd      xmm12, xmm4, 0xee
    vpaddq       xmm4, xmm4, xmm12
    vmovd        td, xmm4
    imul         tq, magicq
    shr          tq, 40
    lea          kd, [tq + 16]
    vmovd        xmm12, kd
    vpbroadcastb ymm12, xmm12
    vpmaxub      ymm13, ymm8, ymm12
    vpcmpeqb     ymm13, ymm13, ymm12
    vpmovmskb    kd, ymm13
    cmp          kd, -1
    setne        kb
    cmp          td, 32
    setae        tb
    or           tb, kb
    movzx        tq, tb
    lea          eax, [rax + rax]
    or           eax, td
    vextracti128 xmm12, ymm5, 1
    vpaddq       xmm5, xmm5, xmm12
    vpshufd      xmm12, xmm5, 0xee
    vpaddq       xmm5, xmm5, xmm12
    vmovd        td, xmm5
    imul         tq, magicq
    shr          tq, 40
    lea          kd, [tq + 16]
    vmovd        xmm12, kd
    vpbroadcastb ymm12, xmm12
    vpmaxub      ymm13, ymm9, ymm12
    vpcmpeqb     ymm13, ymm13, ymm12
    vpmovmskb    kd, ymm13
    cmp          kd, -1
    setne        kb
    cmp          td, 32
    setae        tb
    or           tb, kb
    movzx        tq, tb
    lea          eax, [rax + rax]
    or           eax, td
    ret

.colchunk:
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
    mov        kq, 256
    cmp        hq, kq
    cmovb      kq, hq
    sub        hq, kq
    mov        magicq, kq
    shr        magicq, 2
    jz         .cc_tail
.cc_blk4:
    vpmaxub    ymm9, ymm0, [tq]
    vpmaxub    ymm8, ymm8, ymm9
    vpunpcklbw ymm10, ymm9, ymm1
    vpaddw     ymm2, ymm2, ymm10
    vpunpckhbw ymm10, ymm9, ymm1
    vpaddw     ymm3, ymm3, ymm10
    vpmaxub    ymm9, ymm0, [tq + strideq]
    vpmaxub    ymm8, ymm8, ymm9
    vpunpcklbw ymm10, ymm9, ymm1
    vpaddw     ymm2, ymm2, ymm10
    vpunpckhbw ymm10, ymm9, ymm1
    vpaddw     ymm3, ymm3, ymm10
    vpmaxub    ymm9, ymm0, [tq + strideq*2]
    vpmaxub    ymm8, ymm8, ymm9
    vpunpcklbw ymm10, ymm9, ymm1
    vpaddw     ymm2, ymm2, ymm10
    vpunpckhbw ymm10, ymm9, ymm1
    vpaddw     ymm3, ymm3, ymm10
    vpmaxub    ymm9, ymm0, [tq + s3q]
    vpmaxub    ymm8, ymm8, ymm9
    vpunpcklbw ymm10, ymm9, ymm1
    vpaddw     ymm2, ymm2, ymm10
    vpunpckhbw ymm10, ymm9, ymm1
    vpaddw     ymm3, ymm3, ymm10
    lea        tq, [tq + strideq*4]
    dec        magicq
    jnz        .cc_blk4
.cc_tail:
    and        kq, 3
    jz         .cc_flush
.cc_blk1:
    vpmaxub    ymm9, ymm0, [tq]
    vpmaxub    ymm8, ymm8, ymm9
    vpunpcklbw ymm10, ymm9, ymm1
    vpaddw     ymm2, ymm2, ymm10
    vpunpckhbw ymm10, ymm9, ymm1
    vpaddw     ymm3, ymm3, ymm10
    add        tq, strideq
    dec        kq
    jnz        .cc_blk1
.cc_flush:
    vpmovzxwd  ymm10, xmm2
    vpaddd     ymm4, ymm4, ymm10
    vextracti128 xmm9, ymm2, 1
    vpmovzxwd  ymm10, xmm9
    vpaddd     ymm5, ymm5, ymm10
    vpmovzxwd  ymm10, xmm3
    vpaddd     ymm6, ymm6, ymm10
    vextracti128 xmm9, ymm3, 1
    vpmovzxwd  ymm10, xmm9
    vpaddd     ymm7, ymm7, ymm10
    vpxor      xmm2, xmm2, xmm2
    vpxor      xmm3, xmm3, xmm3
    test       hq, hq
    jnz        .cc_outer
    vpsubusb   ymm8, ymm8, ymm0
    vmovd      xmm9, hhd
    vpbroadcastd ymm11, xmm9
    mov        td, hhd
    shl        td, 5
    dec        td
    vmovd      xmm9, td
    vpbroadcastd ymm12, xmm9
    xor        eax, eax
    vmovdqa    xmm9, xmm8
    vpmovzxbd  ymm9, xmm9
    vpmulld    ymm9, ymm9, ymm11
    vpcmpgtd   ymm9, ymm9, ymm4
    vpcmpgtd   ymm13, ymm4, ymm12
    vpor       ymm9, ymm9, ymm13
    vmovmskps  td, ymm9
    or         eax, td
    vpsrldq    xmm9, xmm8, 8
    vpmovzxbd  ymm9, xmm9
    vpmulld    ymm9, ymm9, ymm11
    vpcmpgtd   ymm9, ymm9, ymm6
    vpcmpgtd   ymm13, ymm6, ymm12
    vpor       ymm9, ymm9, ymm13
    vmovmskps  td, ymm9
    shl        td, 8
    or         eax, td
    vextracti128 xmm9, ymm8, 1
    vpmovzxbd  ymm9, xmm9
    vpmulld    ymm9, ymm9, ymm11
    vpcmpgtd   ymm9, ymm9, ymm5
    vpcmpgtd   ymm13, ymm5, ymm12
    vpor       ymm9, ymm9, ymm13
    vmovmskps  td, ymm9
    shl        td, 16
    or         eax, td
    vextracti128 xmm9, ymm8, 1
    vpsrldq    xmm9, xmm9, 8
    vpmovzxbd  ymm9, xmm9
    vpmulld    ymm9, ymm9, ymm11
    vpcmpgtd   ymm9, ymm9, ymm7
    vpcmpgtd   ymm13, ymm7, ymm12
    vpor       ymm9, ymm9, ymm13
    vmovmskps  td, ymm9
    shl        td, 24
    or         eax, td
    ret

