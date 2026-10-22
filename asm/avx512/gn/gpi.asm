default rel
%include "gpo.inc"
%include "gpimg.inc"
extern xav_gr
extern xav_gpl
extern xav_amap
global xav_gpi

%if G_ao != 320 || G_lxl != G_lta + 4 || G_ys != 64 || G_cs != 72 || G_sq != 104 || G_sg != 112 || G_cl != 120 || G_cr != 128 || G_cc != 136 || G_oc != 144 || G_sb2 != 152 || G_nx != 160 || G_ab != 168 || G_hx != 280 || G_ax != G_hx + 24 || G_ae != G_hk + 24 || G_ao != G_hv + 24 || G_lm != G_ao + 8 || G_lrg != G_lm + 4 || G_lxl != 344 || G_lom != 348 || G_lmx != 360 || G_crg != 372 || G_com != 388 || G_cmx != 400 || G_drg != 424 || G_dhi != G_dlo + 8 || G_ehi != G_elo + 8 || G_dnl != 504 || G_dnc != 520 || G_lt1 != 576 || G_ct1 != 704 || G_ms != 832
%error layout
%endif

%define S(x) ((x) - 64)
%define V_W -128
%define V_t -64
%define V_ns -60
%define V_nw -56
%define V_mk -52
%define V_q -48
%define V_s -44
%define V_cm -36
%define V_stop -16
%define V_io -32
%define V_osp -24
%define V_sz 896
%define GDS (G_ms + 384)

section .rodata align=64
%include "gpic.inc"
i_io: db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
i_rx: db -1, 0, 1, 2, 0, 0, 0, 0, -1, 0, 1, 2, 0, 0, 0, 0
i_ri: db 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0
i_re: db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0
i_kd: dd 15, 16, 31
i_kw: dw 0x0f0f
i_kb: db 0xe0, 0x3f
%include "gpkt.inc"

section .text
align 64
xav_gpi:
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15
    mov rax, rsp
    and rsp, -64
    sub rsp, V_sz
    lea rbx, [rsp + 128]
    mov [rbx + V_osp], rax
    shl ecx, 6
%assign i 0
%rep GPL / 64
    vmovdqa64 zmm0, [abs xav_gpl + rcx*8 + i]
    vmovdqa64 [xav_gr + i], zmm0
%assign i i + 64
%endrep
%assign i 0
%rep 3
    vmovdqa64 zmm0, [abs i_rt + rcx*4 + i]
    vmovdqa64 [rbx + S(G_ao) + i], zmm0
%assign i i + 64
%endrep
    mov r12d, edi
    mov r13d, esi
    mov r14d, edx
    mov [rbx + V_t], r8d
    mov [rbx + V_io], r9
    vmovdqu xmm0, [r9 + 32]
    vmovdqa [rbx + S(G_ys)], xmm0
    vpxor xmm1, xmm1, xmm1
    vmovdqa64 [rbx + S(256)], zmm1
    mov eax, esi
    imul eax, edx
    add eax, edi
    lea ecx, [rdi + rdi]
    xor edx, edx
    div ecx
    lea r15d, [rax + rax]
    mov [rbx + S(G_ho)], r15
    lea eax, [r12*8]
    xor edx, edx
    div r14d
    mov r11d, eax
    mov [rbx + S(G_gp)], rax
    mov [rbx + S(G_wi)], r12
    mov [rbx + S(G_hi)], r13
    mov [rbx + S(G_wo)], r14
    shr edi, 1
    mov [rbx + S(G_wc)], rdi
    lea r10d, [r11 + r11]
    mov rcx, [abs kp - 144 + r10*8]
    mov [r9], rcx
    mov [r9 + 24], r15
    movzx edi, byte [abs kp - 144 + r10*8 + 12]
    mov [rbx + S(G_su)], rdi
    lea eax, [r14 + 7]
    shr eax, 3
    lea eax, [rax + rdi - 1]
    xor edx, edx
    div edi
    mov [rbx + S(G_nst)], rax
    movzx edi, word [abs kp - 144 + r10*8 + 8]
    mov [rbx + S(G_sp)], rdi
    imul eax, edi
    mov edx, eax
    shr edx, 4
    mov [rbx + V_mk], edx
    lea edx, [r12 + 31]
    and edx, -32
    cmp eax, edx
    cmovb eax, edx
    mov [rbx + S(G_wp)], rax
    movzx eax, word [abs kp - 144 + r10*8 + 10]
    mov [rbx + S(G_spp)], rax
    movzx eax, byte [abs kp - 144 + r10*8 + 13]
    mov [rbx + V_ns], eax
    movzx eax, byte [abs kp - 144 + r10*8 + 14]
    mov [rbx + V_nw], eax
    mov rax, r14
    imul rax, r15
    mov rdx, r12
    imul rdx, r13
    lzcnt rsi, rax
    lzcnt rdi, rdx
    sub esi, edi
    shlx rdi, rax, rsi
    cmp rdi, rdx
    adc esi, 0
    mov r12d, esi
    shlx rax, rax, rsi
    shl rdx, 4
    vcvtsi2sd xmm1, xmm1, rax
    vbroadcastsd zmm1, xmm1
    vcvtsi2sd xmm2, xmm2, rdx
    vbroadcastsd zmm10, xmm2
    vpmovzxbd zmm3, [i_io + 1]
    vcvtdq2pd zmm4, ymm3
    vextracti32x8 ymm5, zmm3, 1
    vcvtdq2pd zmm5, ymm5
    vmulpd zmm4, zmm4, zmm1
    vmulpd zmm5, zmm5, zmm1
    vdivpd zmm6, zmm4, zmm10
    vdivpd zmm7, zmm5, zmm10
    vcvtpd2ps ymm6, zmm6
    vcvtpd2ps ymm7, zmm7
    vinsertf32x8 zmm8, zmm6, ymm7, 1
    vmovaps [rbx + V_W], zmm8
    vcvtps2pd zmm6, ymm6
    vcvtps2pd zmm7, ymm7
    vfmsub213pd zmm6, zmm10, zmm4
    vfmsub213pd zmm7, zmm10, zmm5
    vptestmq k1, zmm6, zmm6
    vptestmq k2, zmm7, zmm7
    kunpckbw k1, k2, k1
    lea ecx, [r11 - 1]
    andn ecx, r11d, ecx
    and ecx, 15
    vpbroadcastd zmm9, ecx
    mov ecx, -1
    bzhi ecx, ecx, r11d
    kmovw k3, ecx
    vptestnmd k3{k3}, zmm3, zmm9
    xor r9d, r9d
    ktestw k1, k3
    setnz r9b
    vmovapd ymm5, [i_dn]
    vdivpd zmm6, zmm5, zmm10
    vfnmadd231pd zmm5, zmm10, zmm6
    vdivpd zmm5, zmm5, zmm10
    vmovapd [rbx + S(G_dnl + 8)], zmm5
    vmovhpd [rbx + S(G_dnc)], xmm6
    vmovsd [rbx + S(G_dnl)], xmm6
    lea r14d, [r15 + r15]
    mov eax, r13d
    xor edx, edx
    div r14d
    mov [rbx + V_q], eax
    mov [rbx + V_s], edx
    lea esi, [rdx*4]
    lea edi, [rax*4]
    cmp edx, 1
    sbb edi, -1
    cmp r14d, esi
    adc edi, 0
    lea ecx, [rdx + rdx]
    cmp r14d, ecx
    adc edi, 0
    lea ecx, [r14 + r14*2]
    cmp ecx, esi
    adc edi, 0
    imul edi, edi, 384
    mov [rbx + S(G_abs)], rdi
    tzcnt ecx, r14d
    shrx r8d, r14d, ecx
    tzcnt r10d, r13d
    cmp ecx, r10d
    cmova ecx, r10d
    mov r10d, r8d
    mov r11d, r13d
.g0:
    tzcnt esi, r11d
    shrx r11d, r11d, esi
    mov esi, r11d
    sub esi, r10d
    cmovb r10d, r11d
    mov r11d, esi
    neg r11d
    cmovs r11d, esi
    jnz .g0
    xor esi, esi
    cmp r10d, r8d
    setne sil
    shlx ebp, r10d, ecx
    mov ecx, 3
    lea edi, [rsi + 2]
    lea r8d, [rbp + rbp*2]
    cmp edx, r8d
    cmovbe ecx, edi
    lea r8d, [rbp + rbp]
    xor edi, edi
    cmp r8d, r14d
    adc edi, 1
    cmp edx, ebp
    cmove ecx, edi
    test edx, edx
    cmovz ecx, edx
    add ecx, esi
    add ecx, r9d
    add ecx, [rbx + V_ns]
    lea eax, [rax + rcx + 3]
    lea ecx, [rax - 2]
    vcvtsi2sd xmm0, xmm0, ecx
    vcvtsi2sd xmm1, xmm1, eax
    vunpcklpd xmm0, xmm0, xmm1
    vmulpd xmm0, xmm0, [i_hulp]{1to2}
    vmovddup xmm3, [i_one]
    vsubpd xmm3, xmm3, xmm0
    vdivpd xmm0, xmm0, xmm3
    vmovddup xmm6, [i_one6]
    vmulpd xmm0, xmm0, xmm6
    vaddpd xmm0, xmm0, [xav_gr + P_RHOP]{1to2}
    vmulpd xmm2, xmm0, xmm6
    vmovsd [rbx + S(G_drg)], xmm2
    vmovhpd [rbx + S(G_erg)], xmm2
    vmovddup xmm8, [i_marg]
    vaddpd xmm3, xmm2, xmm2
    vmulpd xmm3, xmm3, xmm8
    mov rcx, r12
    neg rcx
    vmovups zmm16, [abs i_t1q + rcx*4]
    vmovups zmm17, [abs i_t1q + rcx*4 + 64]
    vmovups zmm18, [abs i_t1q + rcx*4 + 120]
    vmovups zmm19, [abs i_t1q + rcx*4 + 56]
    vmovaps [rbx + S(G_lt1)], zmm16
    vmovaps [rbx + S(G_lt1 + 64)], zmm17
    vmovaps [rbx + S(G_ct1)], zmm18
    vmovaps [rbx + S(G_ct1 + 64)], zmm19
    shl rcx, 52
    vpbroadcastq xmm4, rcx
    vpaddq xmm4, xmm4, [i_kv]
    vmovsd [rbx + S(G_dkv)], xmm4
    vmovhpd [rbx + S(G_ekv)], xmm4
    vmulpd xmm3, xmm3, xmm4
    vmovsd [rbx + S(G_dan)], xmm3
    vmovhpd [rbx + S(G_ean)], xmm3
    vmulpd xmm0, xmm0, xmm8
    vcvtpd2ps xmm2, xmm0
    vmovss [rbx + S(G_lrg)], xmm2
    vextractps [rbx + S(G_crg)], xmm2, 1
    vaddpd xmm0, xmm0, xmm0
    vmulpd xmm0, xmm0, xmm8
    vcvtpd2ps xmm0, xmm0
    vmovss [rbx + S(G_lan)], xmm0
    vextractps [rbx + S(G_can)], xmm0, 1
    lea ecx, [r12 + 191]
    shl ecx, 23
    vpbroadcastd xmm0, ecx
    vmulps xmm0, xmm0, [i_tx]
    vmovq [rbx + S(G_lta)], xmm0
    vextractps [rbx + S(G_cta)], xmm0, 2
    vextractps [rbx + S(G_cxl)], xmm0, 3
    mov r15d, r14d
    shl r15d, 5
    lea eax, [r14 + r13]
    shl eax, 5
    mov [rbx + S(G_bm)], rax
    mov ecx, [rbx + V_mk]
    lea eax, [rax + rcx*2 + 63]
    and eax, -64
    mov ecx, [rbx + V_ns]
    shl ecx, 6
    mov edx, ecx
    imul edx, [rbx + V_nw]
    mov esi, edx
    shr esi, 5
    add esi, 63
    and esi, -64
    xor r12d, r12d
    cmp dword [rbx + S(G_gp)], 16
    cmovb esi, ecx
    mov edi, 24
    cmovb r12d, edi
    mov [rbx + r12 + S(G_hx)], rax
    add eax, edx
    mov [rbx + r12 + S(G_hk)], rax
    add eax, esi
    mov [rbx + r12 + S(G_hv)], rax
    lea esi, [rax + rcx]
    call xav_amap
    mov r11, rax
    mov [rbx + S(G_pd)], rax
    add r15, rax
    mov [rbx + S(G_rd)], r15
    add [rbx + S(G_bm)], rax
    add [rbx + r12 + S(G_hx)], rax
    add [rbx + r12 + S(G_hk)], rax
    add [rbx + r12 + S(G_hv)], rax
    mov dword [r11 + Pc_ci], 4
    vcvtsi2sd xmm15, xmm15, r14
    vmovsd xmm14, [i_one]
    vdivsd xmm14, xmm14, xmm15
    mov ecx, r14d
    cmp dword [rbx + S(G_gp)], 16
    cmovb ecx, r13d
    sub ecx, ebp
    lea rdx, [r15 + rcx*8]
    lea r10, [rbp*8]
    mov eax, ebp
    jmp .tb
.ta:
    vcvtsi2sd xmm1, xmm15, rax
    vmulsd xmm1, xmm1, xmm14
    vcvtsd2ss xmm1, xmm1, xmm1
    vmovss [r15 + rax*8 + 4], xmm1
    vmovss [rdx], xmm1
    sub rdx, r10
    add eax, ebp
.tb:
    cmp eax, ecx
    jbe .ta
    cmp eax, r13d
    je .lo
    mov r9d, [rbx + V_s]
    mov r12d, [rbx + V_q]
    mov r10d, r14d
    sub r10d, r9d
    shr r13d, 1
    dec r13d
    xor eax, eax
    xor r8d, r8d
    xor r14d, r14d
    mov edi, 1
    mov rbp, r15
.c:
%assign kk 0
%rep 4
    lea rdx, [rax + r10]
    mov ecx, r12d
    sub rax, r9
    cmovb rax, rdx
    setnz dl
    adc ecx, 0
    movzx edx, dl
    add r8d, ecx
    sub ecx, edx
    mov [r11 + Pc_n + 8 * kk], ecx
    mov [r11 + Pc_n + 8 * kk + 4], edx
%if kk == 2
    mov esi, r8d
    sub esi, edx
    shr esi, 1
%endif
    mov rcx, [r15 + rax*8]
    mov [r11 + Pc_w + 12 * kk], rcx
%assign kk kk + 1
%endrep
    mov ecx, r8d
    sub ecx, [r11 + Pc_y0]
    mov [r11 + Pc_nr], ecx
    mov [r11 + 128 + Pc_y0], r8d
    mov [r11 + Pc_co], edx
    mov [r11 + 128 + Pc_ci], edx
    mov ecx, r8d
    shr ecx, 1
    inc ecx
    cmp ecx, r13d
    cmova ecx, r13d
    mov [r11 + Pc_ch], ecx
    sub ecx, edi
    cmp ecx, r14d
    cmova r14d, ecx
    mov edi, esi
    sub r11, -128
    test eax, eax
    jz .cz
.cn:
    cmp r11, rbp
    jb .c
    cmp rbp, r15
    jne .ce
    lea eax, [r14 + 1]
    jmp .km
.cz:
    test r8b, 1
    jnz .cn
    mov rbp, r11
    jmp .cn
.ce:
    mov rcx, [rbx + S(G_pd)]
    mov ecx, [rcx + Pc_ch]
    mov edx, r8d
    shr edx, 1
    add ecx, edx
    sub ecx, edi
    cmp ecx, r14d
    cmova r14d, ecx
    lea eax, [r14 + 1]
    jmp .rp
.rz:
    lea ecx, [r12 - 4]
    cmp r9d, ecx
    jne .rn
    test r8b, 1
    jnz .rn
    mov [rbx + V_stop], r11
    jmp .rn
.lo:
    vcvtsi2sd xmm1, xmm15, rax
    vmulsd xmm1, xmm1, xmm14
    vcvtsd2ss xmm2, xmm1, xmm1
    vmovss [r15], xmm2
    vmovss [r15 + 4], xmm2
    mov ebp, r13d
    shr ebp, 1
    dec ebp
    mov dword [rbx + V_cm], 0
    mov [rbx + V_stop], r15
    sub r14d, r13d
    xor eax, eax
    xor r8d, r8d
    xor r9d, r9d
    xor r10d, r10d
    mov r12d, 4
.r:
    mov edx, r9d
    and edx, 3
    vmovss xmm0, [r15 + r10*8]
    add r10, r14
    mov rcx, r10
    sub rcx, r13
    cmovae r10, rcx
    sbb rsi, rsi
    lea r9, [r9 + rsi + 2]
    cmp r10, 1
    sbb esi, -2
    mov [r11 + Pc_n + rdx*8 + 4], esi
    lea edx, [rdx + rdx*2]
    lea rdi, [r11 + rdx*4]
    vmovss [rdi + Pc_w], xmm0
    vmovss [rdi + Pc_w + 4], xmm2
    vmovss xmm0, [r15 + r10*8 + 4]
    vmovss [rdi + rsi*4 + Pc_w], xmm0
    inc r8d
    cmp r9d, r12d
    jb .r
    mov edx, r8d
    sub edx, [r11 + Pc_y0]
    mov [r11 + Pc_nr], edx
    mov [r11 + 128 + Pc_y0], r8d
    mov esi, [r11 + Pc_n + 20]
    shr esi, 1
    mov edi, [r11 + Pc_n + 28]
    lea edx, [rdi + rdi - 1]
    test edi, edi
    cmovnz esi, edx
    mov [r11 + Pc_co], esi
    mov [r11 + 128 + Pc_ci], esi
    mov edx, r8d
    shr edx, 1
    inc edx
    cmp edx, ebp
    cmova edx, ebp
    mov [r11 + Pc_ch], edx
    sub edx, eax
    cmp edx, [rbx + V_cm]
    jbe .r1
    mov [rbx + V_cm], edx
.r1:
    lea edx, [r13 + r10]
    lea ecx, [rdx + r13]
    cmp r9d, r12d
    cmovne edx, ecx
    lea ecx, [r13 + r14]
    cmp ecx, edx
    mov eax, r8d
    sbb eax, 1
    shr eax, 1
    sub eax, 1
    adc eax, 0
    add r12d, 4
    sub r11, -128
    test r10, r10
    jz .rz
.rn:
    cmp r11, [rbx + V_stop]
    jb .r
    mov eax, [rbx + V_cm]
    cmp r11, r15
    je .km
.rp:
    mov rsi, [rbx + S(G_pd)]
    mov edx, [r11 + Pc_ci]
    mov ecx, r8d
    shr ecx, 1
    vmovd xmm9, r8d
    vpinsrd xmm9, xmm9, ecx, 1
    vpaddd zmm0, zmm9, [rsi]
    vmovdqa64 zmm1, [rsi + 64]
    vmovdqa64 [r11], zmm0
    vmovdqa64 [r11 + 64], zmm1
    mov [r11 + Pc_ci], edx
    sub rsi, r11
    sub r11, -128
    cmp rsi, -1024
    jle .pl
    vpaddd zmm0, zmm9, [r11 + rsi]
    vmovdqa64 zmm1, [r11 + rsi + 64]
    vmovdqa64 [r11], zmm0
    vmovdqa64 [r11 + 64], zmm1
%assign j 1
%rep 8
%assign a 2 * j + 14
%assign b a + 1
    vpaddd zmm %+ a, zmm9, [r11 + rsi + j * 128]
    vmovdqa64 zmm %+ b, [r11 + rsi + j * 128 + 64]
    vmovdqa64 [r11 + j * 128], zmm %+ a
    vmovdqa64 [r11 + j * 128 + 64], zmm %+ b
%assign j j + 1
%endrep
    add r11, 1152
    mov ecx, esi
    neg ecx
    lzcnt edx, ecx
    sub edx, 21
    vmovd xmm8, edx
    vpslld zmm9, zmm9, xmm8
    shlx rsi, rsi, rdx
    cmp rsi, -1024
    je .pr
.pm:
    lea rdx, [r15 + rsi]
    sub r11, r15
.pq:
    vpaddd zmm0, zmm9, [rdx + r11]
    vmovdqa64 zmm1, [rdx + r11 + 64]
    vpaddd zmm2, zmm9, [rdx + r11 + 128]
    vmovdqa64 zmm3, [rdx + r11 + 192]
    vmovdqa64 [r15 + r11], zmm0
    vmovdqa64 [r15 + r11 + 64], zmm1
    vmovdqa64 [r15 + r11 + 128], zmm2
    vmovdqa64 [r15 + r11 + 192], zmm3
    add r11, 256
    js .pq
    jmp .pf
.pl:
    jne .pm
%assign i 0
%rep 16
%assign a i + 16
    vmovdqa64 zmm %+ a, [r11 - 1024 + i * 64]
%assign i i + 1
%endrep
.pr:
    mov rcx, r15
    sub rcx, r11
    and rcx, -2048
    add r11, rcx
    neg rcx
.pv:
    vpaddd zmm16, zmm16, zmm9
    vmovdqa64 [r11 + rcx + 0], zmm16
    vmovdqa64 [r11 + rcx + 64], zmm17
    vpaddd zmm18, zmm18, zmm9
    vmovdqa64 [r11 + rcx + 128], zmm18
    vmovdqa64 [r11 + rcx + 192], zmm19
    vpaddd zmm20, zmm20, zmm9
    vmovdqa64 [r11 + rcx + 256], zmm20
    vmovdqa64 [r11 + rcx + 320], zmm21
    vpaddd zmm22, zmm22, zmm9
    vmovdqa64 [r11 + rcx + 384], zmm22
    vmovdqa64 [r11 + rcx + 448], zmm23
    vpaddd zmm24, zmm24, zmm9
    vmovdqa64 [r11 + rcx + 512], zmm24
    vmovdqa64 [r11 + rcx + 576], zmm25
    vpaddd zmm26, zmm26, zmm9
    vmovdqa64 [r11 + rcx + 640], zmm26
    vmovdqa64 [r11 + rcx + 704], zmm27
    vpaddd zmm28, zmm28, zmm9
    vmovdqa64 [r11 + rcx + 768], zmm28
    vmovdqa64 [r11 + rcx + 832], zmm29
    vpaddd zmm30, zmm30, zmm9
    vmovdqa64 [r11 + rcx + 896], zmm30
    vmovdqa64 [r11 + rcx + 960], zmm31
    vpaddd zmm16, zmm16, zmm9
    vmovdqa64 [r11 + rcx + 1024 + 0], zmm16
    vmovdqa64 [r11 + rcx + 1024 + 64], zmm17
    vpaddd zmm18, zmm18, zmm9
    vmovdqa64 [r11 + rcx + 1024 + 128], zmm18
    vmovdqa64 [r11 + rcx + 1024 + 192], zmm19
    vpaddd zmm20, zmm20, zmm9
    vmovdqa64 [r11 + rcx + 1024 + 256], zmm20
    vmovdqa64 [r11 + rcx + 1024 + 320], zmm21
    vpaddd zmm22, zmm22, zmm9
    vmovdqa64 [r11 + rcx + 1024 + 384], zmm22
    vmovdqa64 [r11 + rcx + 1024 + 448], zmm23
    vpaddd zmm24, zmm24, zmm9
    vmovdqa64 [r11 + rcx + 1024 + 512], zmm24
    vmovdqa64 [r11 + rcx + 1024 + 576], zmm25
    vpaddd zmm26, zmm26, zmm9
    vmovdqa64 [r11 + rcx + 1024 + 640], zmm26
    vmovdqa64 [r11 + rcx + 1024 + 704], zmm27
    vpaddd zmm28, zmm28, zmm9
    vmovdqa64 [r11 + rcx + 1024 + 768], zmm28
    vmovdqa64 [r11 + rcx + 1024 + 832], zmm29
    vpaddd zmm30, zmm30, zmm9
    vmovdqa64 [r11 + rcx + 1024 + 896], zmm30
    vmovdqa64 [r11 + rcx + 1024 + 960], zmm31
    add rcx, 2048
    jnz .pv
.pw:
    mov rcx, r15
    sub rcx, r11
    cmp rcx, 1024
    jb .pn
    vpaddd zmm16, zmm16, zmm9
    vmovdqa64 [r11 + 0], zmm16
    vmovdqa64 [r11 + 64], zmm17
    vpaddd zmm18, zmm18, zmm9
    vmovdqa64 [r11 + 128], zmm18
    vmovdqa64 [r11 + 192], zmm19
    vpaddd zmm20, zmm20, zmm9
    vmovdqa64 [r11 + 256], zmm20
    vmovdqa64 [r11 + 320], zmm21
    vpaddd zmm22, zmm22, zmm9
    vmovdqa64 [r11 + 384], zmm22
    vmovdqa64 [r11 + 448], zmm23
    vpaddd zmm24, zmm24, zmm9
    vmovdqa64 [r11 + 512], zmm24
    vmovdqa64 [r11 + 576], zmm25
    vpaddd zmm26, zmm26, zmm9
    vmovdqa64 [r11 + 640], zmm26
    vmovdqa64 [r11 + 704], zmm27
    vpaddd zmm28, zmm28, zmm9
    vmovdqa64 [r11 + 768], zmm28
    vmovdqa64 [r11 + 832], zmm29
    vpaddd zmm30, zmm30, zmm9
    vmovdqa64 [r11 + 896], zmm30
    vmovdqa64 [r11 + 960], zmm31
    add r11, 1024
.pn:
    cmp r11, r15
    je .pf
    vpaddd zmm16, zmm16, zmm9
    vmovdqa64 [r11 + 0], zmm16
    vmovdqa64 [r11 + 64], zmm17
    vpaddd zmm18, zmm18, zmm9
    vmovdqa64 [r11 + 128], zmm18
    vmovdqa64 [r11 + 192], zmm19
    vpaddd zmm20, zmm20, zmm9
    vmovdqa64 [r11 + 256], zmm20
    vmovdqa64 [r11 + 320], zmm21
    vpaddd zmm22, zmm22, zmm9
    vmovdqa64 [r11 + 384], zmm22
    vmovdqa64 [r11 + 448], zmm23
    vpaddd zmm24, zmm24, zmm9
    vmovdqa64 [r11 + 512], zmm24
    vmovdqa64 [r11 + 576], zmm25
    vpaddd zmm26, zmm26, zmm9
    vmovdqa64 [r11 + 640], zmm26
    vmovdqa64 [r11 + 704], zmm27
    vpaddd zmm28, zmm28, zmm9
    vmovdqa64 [r11 + 768], zmm28
    vmovdqa64 [r11 + 832], zmm29
    vpaddd zmm30, zmm30, zmm9
    vmovdqa64 [r11 + 896], zmm30
    vmovdqa64 [r11 + 960], zmm31
.pf:
    mov ecx, [rbx + S(G_hi)]
    shr ecx, 1
    dec ecx
    mov [r15 - 128 + Pc_ch], ecx
    mov edx, [r15 - 256 + Pc_ch]
    cmp edx, ecx
    cmova edx, ecx
    mov [r15 - 256 + Pc_ch], edx
.km:
    lzcnt eax, eax
    mov edx, -1
    shrx edx, edx, eax
    mov [rbx + S(G_km)], rdx
    mov eax, [rbx + S(G_wp)]
    add eax, eax
    kmovw k1, [i_kw]
    vpbroadcastd zmm1{k1}{z}, eax
    popcnt ecx, edx
    vmovd xmm0, ecx
    vpslld zmm12, zmm1, xmm0
    vpsubd zmm12, zmm1, zmm12
    vpbroadcastd zmm2, edx
    mov eax, [rbx + S(G_hi)]
    shr eax, 1
    lea ecx, [rax - 1]
    vpbroadcastd zmm3, ecx
    vpmovsxbd zmm4, [i_rx]
    vpmovzxbd zmm5, [i_ri]
    vpmovzxbd zmm7, [i_re]
    vpxor xmm6, xmm6, xmm6
    vpmaxsd zmm0, zmm4, zmm6
    vpandd zmm0, zmm0, zmm2
    vpmulld zmm0, zmm0, zmm1
    vpord zmm0, zmm0, zmm7
    vmovdqa64 [r15], zmm0
    vpaddd zmm4, zmm4, zmm5
    vpandd zmm16, zmm4, zmm2
    vpmulld zmm16, zmm16, zmm1
    vpord zmm16, zmm16, zmm7
    lea rdi, [r15 + 64]
    lea esi, [rax - 3]
    imul r8d, eax, 64
    lea r8, [r15 + r8 - 128]
    cmp edx, 15
    ja .rl
%assign i 17
%rep 15
%assign j i - 1
    vpaddd zmm0, zmm %+ j, zmm1
    vpaddd zmm %+ i, zmm %+ j, zmm12
    vpminud zmm %+ i, zmm %+ i, zmm0
%assign i i + 1
%endrep
    mov ecx, esi
    and ecx, -32
    shl ecx, 6
    add rdi, rcx
    neg rcx
.rb:
%assign i 0
%rep 32
%assign a (i & 15) + 16
    vmovdqa64 [rdi + rcx + i * 64], zmm %+ a
%assign i i + 1
%endrep
    add rcx, 2048
    jnz .rb
    test esi, 16
    jz .rt0
%assign i 0
%rep 16
%assign a i + 16
    vmovdqa64 [rdi + i * 64], zmm %+ a
%assign i i + 1
%endrep
    add rdi, 1024
.rt0:
    sub rdi, r8
.rt:
    vmovdqa64 zmm0, [r8 + rdi - 1024]
    vmovdqa64 zmm8, [r8 + rdi - 960]
    vmovdqa64 [r8 + rdi], zmm0
    vmovdqa64 [r8 + rdi + 64], zmm8
    sub rdi, -128
    js .rt
    jmp .re
.rl:
    lea ecx, [rdx + 1]
    shl ecx, 6
    add rdi, rcx
    neg rcx
.rk:
    vmovdqa64 [rdi + rcx], zmm16
    vpaddd zmm0, zmm16, zmm1
    vpaddd zmm16, zmm16, zmm12
    vpminud zmm16, zmm16, zmm0
    add rcx, 64
    jnz .rk
    inc edx
    shl edx, 6
    neg rdx
    add rdx, r8
    sub rdi, r8
.rc2:
    vmovdqa64 zmm0, [rdx + rdi]
    vmovdqa64 zmm8, [rdx + rdi + 64]
    vmovdqa64 [r8 + rdi], zmm0
    vmovdqa64 [r8 + rdi + 64], zmm8
    sub rdi, -128
    js .rc2
.re:
    lea ecx, [rax - 2]
    vpbroadcastd zmm0, ecx
    vpmulld zmm0, zmm0, zmm5
    vpmovsxbd zmm4, [i_rx]
    vpaddd zmm4, zmm4, zmm0
    vpminsd zmm0, zmm4, zmm3
    vpandd zmm0, zmm0, zmm2
    vpmulld zmm0, zmm0, zmm1
    vpord zmm0, zmm0, zmm7
    vmovdqa64 [r8], zmm0
    vpaddd zmm4, zmm4, zmm5
    vpminsd zmm0, zmm4, zmm3
    vpandd zmm0, zmm0, zmm2
    vpmulld zmm0, zmm0, zmm1
    vpord zmm0, zmm0, zmm7
    vmovdqa64 [r8 + 64], zmm0
    lea rdi, [r8 + 128]
    mov ecx, [rbx + S(G_wi)]
    vpternlogd zmm0, zmm0, zmm0, 0xff
    mov eax, ecx
    shr ecx, 3
    and ecx, -64
    add rcx, rdi
.m0:
    vmovdqa64 [rdi], zmm0
    vmovdqa64 [rdi + 64], zmm0
    vmovdqa64 [rdi + 128], zmm0
    vmovdqa64 [rdi + 192], zmm0
    add rdi, 256
    cmp rdi, rcx
    jb .m0
    and eax, 511
    vpbroadcastw zmm1, eax
    vmovdqa64 zmm2, [i_c16]
    vpsubusw zmm1, zmm2, zmm1
    vpsrlvw zmm1, zmm0, zmm1
    vmovdqa64 [rcx], zmm1
    vmovdqa64 [rcx + 64], zmm6
    vmovdqa64 [rcx + 128], zmm6
    vmovaps zmm8, [rbx + V_W]
    mov eax, [rbx + S(G_gp)]
    vpbroadcastd zmm20, eax
    vpmovzxbd zmm21, [i_io]
    vpternlogd zmm29, zmm29, zmm29, 0xff
    mov edx, [rbx + V_ns]
    cmp eax, 16
    jb .h2
    vpmulld zmm22, zmm21, zmm20
    vpsrld zmm23, zmm22, 4
    vpaddd zmm24, zmm22, zmm20
    vpaddd zmm24, zmm24, zmm29
    vpsrld zmm25, zmm24, 4
    vpbroadcastd zmm28, [i_kd]
    vpandnd zmm26, zmm22, zmm28
    vpandnd zmm27, zmm28, zmm22
    vpsubd zmm27, zmm24, zmm27
    mov r8, [rbx + S(G_hx)]
    mov r9, [rbx + S(G_hk)]
    mov r10, [rbx + S(G_hv)]
    vpermps zmm0, zmm26, zmm8
    vmovaps [r10], zmm0
    mov esi, [rbx + V_nw]
    cmp esi, 1
    jne .hm
    vmovdqu32 [r9], ymm29
    vmovdqa32 [r8], zmm23
    vpsubd zmm23, zmm23, zmm29
    vpminud zmm11, zmm23, zmm25
    vmovdqa32 [r8 + 64], zmm11
    vpsubd zmm27, zmm27, [i_kd + 4]{1to16}
    vpminsd zmm0, zmm27, zmm28
    vpermi2ps zmm0, zmm8, zmm6
    vmovaps [r10 + 64], zmm0
    cmp edx, 2
    je .hz
    vpsubd zmm23, zmm23, zmm29
    vpminud zmm11, zmm23, zmm25
    vmovdqa32 [r8 + 128], zmm11
    vpsubd zmm27, zmm27, [i_kd + 4]{1to16}
    vpminsd zmm0, zmm27, zmm28
    vpermi2ps zmm0, zmm8, zmm6
    vmovaps [r10 + 128], zmm0
    jmp .hz
.hm:
    lea ecx, [rdx - 1]
.hv:
    add r10, 64
    vpsubd zmm27, zmm27, [i_kd + 4]{1to16}
    vpminsd zmm0, zmm27, zmm28
    vpermi2ps zmm0, zmm8, zmm6
    vmovaps [r10], zmm0
    dec ecx
    jnz .hv
    vpbroadcastd zmm30, [i_kd + 8]
.h0:
    vpminud zmm11, zmm23, zmm25
    vpsrld zmm12, zmm11, 5
    vpandd zmm13, zmm11, zmm30
    vpxor xmm14, xmm14, xmm14
    mov ecx, esi
.h3:
    vpcmpeqd k1, zmm12, zmm14
    vmovdqu32 [r8]{k1}, zmm13
    kmovw [r9], k1
    vpsubd zmm14, zmm14, zmm29
    add r8, 64
    add r9, 2
    dec ecx
    jnz .h3
    vpsubd zmm23, zmm23, zmm29
    dec edx
    jnz .h0
    jmp .hz
.h2:
    add eax, eax
    vpbroadcastd zmm22, eax
    vpmulld zmm22, zmm21, zmm22
    vpaddd zmm23, zmm22, zmm20
    vpaddd zmm9, zmm23, zmm29
    vpaddd zmm24, zmm9, zmm20
    vpsrld zmm25, zmm22, 4
    vpsrld zmm26, zmm24, 4
    vpslld zmm27, zmm25, 4
    vpaddd zmm1, zmm27, [i_kd]{1to16}
    mov r8, [rbx + S(G_ax)]
    mov r9, [rbx + S(G_ae)]
    mov r10, [rbx + S(G_ao)]
    vmovdqa32 [r8], zmm25
    vpminsd zmm2, zmm9, zmm1
    vpsubd zmm2, zmm2, zmm22
    vpminsd zmm4, zmm24, zmm1
    vpsubd zmm4, zmm4, zmm23
    vpcmpgtd k2, zmm4, zmm29
    vpermps zmm2, zmm2, zmm8
    vpermps zmm4{k2}{z}, zmm4, zmm8
    vmovaps [r9], zmm2
    vmovaps [r10], zmm4
    vpsubd zmm25, zmm25, zmm29
    vpaddd zmm27, zmm27, [i_kd + 4]{1to16}
    vpaddd zmm1, zmm1, [i_kd + 4]{1to16}
    vpminsd zmm0, zmm25, zmm26
    vmovdqa32 [r8 + 64], zmm0
    vpsubd zmm2, zmm9, zmm27
    vpminsd zmm4, zmm24, zmm1
    vpmaxsd zmm5, zmm23, zmm27
    vpsubd zmm4, zmm4, zmm5
    vpcmpgtd k1, zmm2, zmm29
    vpcmpgtd k2, zmm4, zmm29
    vpermps zmm2{k1}{z}, zmm2, zmm8
    vpermps zmm4{k2}{z}, zmm4, zmm8
    vmovaps [r9 + 64], zmm2
    vmovaps [r10 + 64], zmm4
    cmp edx, 2
    je .hz
    vpsubd zmm25, zmm25, zmm29
    vpminsd zmm0, zmm25, zmm26
    vmovdqa32 [r8 + 128], zmm0
    vmovaps [r9 + 128], zmm6
    vpaddd zmm27, zmm27, [i_kd + 4]{1to16}
    vpsubd zmm4, zmm24, zmm27
    vpcmpgtd k2, zmm4, zmm29
    vpermps zmm4{k2}{z}, zmm4, zmm8
    vmovaps [r10 + 128], zmm4
.hz:
    mov eax, [rbx + S(G_km)]
    inc eax
    imul rax, [rbx + S(G_wp)]
    lea rax, [rax*8 + GDS + 63]
    and rax, -64
    mov [rbx + S(G_nx)], rax
    mov qword [rbx + S(G_cr)], GDS
    imul rcx, [rbx + S(G_wp)], 48
    lea rax, [rax + rcx + 63]
    and rax, -64
    mov [rbx + S(G_ab)], rax
    mov rcx, [rbx + S(G_abs)]
    lea rax, [rax + rcx*2]
    add rax, rcx
    mov [rbx + S(G_sb2)], rax
    imul rcx, [rbx + S(G_spp)], 48
    lea rax, [rax + rcx + 63]
    and rax, -64
    mov [rbx + S(G_cl)], rax
    mov rcx, [rbx + S(G_su)]
    shl rcx, 6
    lea rax, [rax + rcx*4]
    mov [rbx + S(G_cc)], rax
    add rax, rcx
    mov [rbx + S(G_oc)], rax
    add rax, 256
    mov [rbx + S(G_sq)], rax
    lea rax, [rax + rcx*8]
    add rax, rcx
    mov [rbx + S(G_sg)], rax
    lea r12, [rax + 507904]
    mov r13d, [rbx + V_t]
    mov rsi, r12
    imul rsi, r13
    call xav_amap
    mov r9, [rbx + V_io]
    mov [r9 + 8], rax
    mov [r9 + 16], r12
%assign i 0
%rep 12
    vmovdqa64 zmm %+ i, [rbx + i * 64]
%assign i i + 1
%endrep
    vpbroadcastq zmm12, rax
    vpbroadcastq zmm13, r12
    kmovb k5, [i_kb]
    kmovb k6, [i_kb + 1]
    vpaddq zmm0{k5}, zmm0, zmm12
    vpaddq zmm1{k6}, zmm1, zmm12
    dec r13d
    jz .w1
.w:
%assign i 0
%rep 12
    vmovdqa64 [rax + 64 + i * 64], zmm %+ i
%assign i i + 1
%endrep
    vpaddq zmm0{k5}, zmm0, zmm13
    vpaddq zmm1{k6}, zmm1, zmm13
    add rax, r12
    dec r13d
    jnz .w
.w1:
%assign i 0
%rep 12
    vmovdqa64 [rax + 64 + i * 64], zmm %+ i
%assign i i + 1
%endrep
    mov rsp, [rbx + V_osp]
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    ret
