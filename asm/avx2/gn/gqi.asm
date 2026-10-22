default rel
%include "gq2o.inc"
%include "gqimg.inc"
extern xav_gr
extern xav_gql
extern xav_amap
global xav_gqi

%if G_cmx != 496 || G_dnl != 600 || G_ys != 64 || G_cs != 72 || G_su != 96 || G_sq != 104 || G_sg != 112 || G_cl != 120 || G_cr != 128 || G_cc != 136 || G_oc != 144 || G_sb2 != 152 || G_nx != 160 || G_ab != 168 || G_ct != 176 || G_wp != 184 || G_ri != 320 || G_ltl != 352 || G_lmx != 452 || G_crg != 464 || G_cmx != 496 || G_drg != 520 || G_dhi != G_dlo + 8 || G_dnl != 600 || G_dnc != 616 || G_ms != 640
%error layout
%endif

%define S(x) ((x) - 64)
%define V_W -128
%define V_osp -64
%define V_io -56
%define V_t -48
%define V_ns -44
%define V_mk -36
%define V_q -32
%define V_s -28
%define V_cm -24
%define V_nx -20
%define V_stop -16
%define V_A 576
%define V_B 592
%define V_dl 608
%define V_sz 768
%define GDS (G_ms + 192)

%macro LK 3
    vpermps %1, %2, ymm14
    vpermps %3, %2, ymm15
    vpslld %2, %2, 28
    vblendvps %1, %1, %3, %2
%endmacro

section .rodata align=64
%include "gqic.inc"
i_io: db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
i_rq: db -1, 0, 1, 2
i_um: dw 0xffff, 0xaaaa, 0x8888, 0x8080, 0x8000
align 32
i_m87: times 8 dd 0x80000007
i_m17: times 8 dd -17
i_m16: times 8 dd -16
i_m8: times 8 dd -8
i_m07: dq 0x0707070707070707
i_mf8: dq 0xf8f8f8f8f8f8f8f8
%include "gqkt.inc"

section .text
align 64
xav_gqi:
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
    imul ecx, ecx, GQL / 4
%assign i 0
%rep GQL / 32
    vmovdqa ymm0, [abs xav_gql + rcx*4 + i]
    vmovdqa [xav_gr + i], ymm0
%assign i i + 32
%endrep
    mov r12d, edi
    mov r13d, esi
    mov r14d, edx
    mov [rbx + V_t], r8d
    mov [rbx + V_io], r9
    vmovdqu xmm0, [r9 + 32]
    vmovdqa [rbx + S(G_ys)], xmm0
%assign i 0
%rep (G_ms - G_ltl) / 32
    vmovdqa ymm0, [abs i_tpl + rcx*2 + i]
    vmovdqa [rbx + S(G_ltl) + i], ymm0
%assign i i + 32
%endrep
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
    lea r10d, [r11 + r11]
    mov rcx, [abs kp - 144 + r10*8]
    mov [r9], rcx
    mov [r9 + 24], r15
    mov [rbx + S(G_gp)], rax
    mov [rbx + S(G_wi)], r12
    mov [rbx + S(G_hi)], r13
    mov [rbx + S(G_wo)], r14
    shr edi, 1
    mov [rbx + S(G_wc)], rdi
    lea eax, [rdi + 7]
    shr eax, 3
    mov [rbx + S(G_nbc)], rax
    dec edi
    and edi, 7
    vmovd xmm0, edi
    vpbroadcastd ymm0, xmm0
    vpmovzxbd ymm1, [i_io]
    vpminsd ymm0, ymm0, ymm1
    vmovdqa [rbx + S(G_ri)], ymm0
    mov r9d, 16
    or r9d, r11d
    tzcnt r9d, r9d
    movzx r8d, byte [abs kp - 144 + r10*8 + 12]
    mov [rbx + S(G_su)], r8
    lea eax, [r14 + 7]
    shr eax, 3
    lea eax, [rax + r8 - 1]
    xor edx, edx
    div r8d
    mov [rbx + S(G_nst)], rax
    movzx r8d, word [abs kp - 144 + r10*8 + 8]
    mov [rbx + S(G_sp)], r8
    imul eax, r8d
    mov edx, eax
    shr edx, 3
    mov [rbx + V_mk], edx
    lea edx, [r12 + 15]
    and edx, -16
    cmp eax, edx
    cmovb eax, edx
    mov [rbx + S(G_wp)], rax
    movzx eax, word [abs kp - 144 + r10*8 + 10]
    mov [rbx + S(G_spp)], rax
    movzx ebp, byte [abs kp - 144 + r10*8 + 13]
    mov [rbx + V_ns], ebp
    movzx eax, byte [abs kp - 144 + r10*8 + 14]
    mov [rbx + V_nx], eax
    movzx eax, byte [abs kp - 144 + r10*8 + 15]
    mov [rbx + S(G_hb)], rax
    mov rax, r14
    imul rax, r15
    shl rax, 2
    mov rdx, r12
    imul rdx, r13
    shl rdx, 4
    vcvtsi2sd xmm0, xmm0, rdx
    vbroadcastsd ymm10, xmm0
    vmovapd ymm5, [i_dn]
    vdivpd ymm6, ymm5, ymm10
    vfnmadd231pd ymm5, ymm10, ymm6
    vdivpd ymm5, ymm5, ymm10
    vmovapd [rbx + S(G_dnl + 8)], ymm5
    vmovhpd [rbx + S(G_dnc)], xmm6
    vmovsd [rbx + S(G_dnl)], xmm6
    vcvtsi2sd xmm1, xmm1, rax
    vbroadcastsd ymm1, xmm1
    vpmovzxbd ymm3, [i_io + 1]
    vpmovzxbd ymm4, [i_io + 9]
    vcvtdq2pd ymm5, xmm3
    vextracti128 xmm6, ymm3, 1
    vcvtdq2pd ymm6, xmm6
    vcvtdq2pd ymm7, xmm4
    vextracti128 xmm8, ymm4, 1
    vcvtdq2pd ymm8, xmm8
    vmulpd ymm5, ymm5, ymm1
    vmulpd ymm6, ymm6, ymm1
    vmulpd ymm7, ymm7, ymm1
    vmulpd ymm8, ymm8, ymm1
    vdivpd ymm11, ymm5, ymm10
    vdivpd ymm12, ymm6, ymm10
    vdivpd ymm13, ymm7, ymm10
    vdivpd ymm14, ymm8, ymm10
    vcvtpd2ps xmm11, ymm11
    vcvtpd2ps xmm12, ymm12
    vcvtpd2ps xmm13, ymm13
    vcvtpd2ps xmm14, ymm14
    vinsertf128 ymm0, ymm11, xmm12, 1
    vmovaps [rbx + V_W], ymm0
    vinsertf128 ymm0, ymm13, xmm14, 1
    vmovaps [rbx + V_W + 32], ymm0
    vcvtps2pd ymm11, xmm11
    vcvtps2pd ymm12, xmm12
    vcvtps2pd ymm13, xmm13
    vcvtps2pd ymm14, xmm14
    vfmsub213pd ymm11, ymm10, ymm5
    vfmsub213pd ymm12, ymm10, ymm6
    vfmsub213pd ymm13, ymm10, ymm7
    vfmsub213pd ymm14, ymm10, ymm8
    vxorpd xmm0, xmm0, xmm0
    vcmpneqpd ymm11, ymm11, ymm0
    vcmpneqpd ymm12, ymm12, ymm0
    vcmpneqpd ymm13, ymm13, ymm0
    vcmpneqpd ymm14, ymm14, ymm0
    vmovmskpd eax, ymm11
    vmovmskpd ecx, ymm12
    vmovmskpd edx, ymm13
    vmovmskpd esi, ymm14
    shl ecx, 4
    shl edx, 8
    shl esi, 12
    or eax, ecx
    or eax, edx
    or eax, esi
    movzx ecx, word [abs i_um + r9*2]
    and eax, ecx
    mov ecx, -1
    bzhi ecx, ecx, r11d
    xor r9d, r9d
    test eax, ecx
    setnz r9b
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
    imul edi, edi, 192
    mov [rbx + S(G_az)], rdi
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
    shlx r12d, r10d, ecx
    mov ecx, 3
    lea edi, [rsi + 2]
    lea r8d, [r12 + r12*2]
    cmp edx, r8d
    cmovbe ecx, edi
    lea r8d, [r12 + r12]
    xor edi, edi
    cmp r8d, r14d
    adc edi, 1
    cmp edx, r12d
    cmove ecx, edi
    test edx, edx
    cmovz ecx, edx
    add ecx, esi
    add ecx, r9d
    add ecx, ebp
    lea eax, [rax + rcx + 3]
    lea ecx, [rax - 2]
    vcvtsi2sd xmm0, xmm0, ecx
    vcvtsi2sd xmm1, xmm1, eax
    vunpcklpd xmm0, xmm0, xmm1
    vmovddup xmm2, [i_hulp]
    vmulpd xmm0, xmm0, xmm2
    vmovddup xmm3, [i_one]
    vsubpd xmm3, xmm3, xmm0
    vdivpd xmm0, xmm0, xmm3
    vmovddup xmm6, [i_one6]
    vmulpd xmm0, xmm0, xmm6
    vmovddup xmm7, [xav_gr + P_RHOP]
    vaddpd xmm0, xmm7, xmm0
    vmulpd xmm2, xmm0, xmm6
    vmovsd [rbx + S(G_drg)], xmm2
    vmovhpd [rbx + S(G_erg)], xmm2
    vmovddup xmm8, [i_marg]
    vaddpd xmm3, xmm2, xmm2
    vmulpd xmm3, xmm3, xmm8
    vmulpd xmm3, xmm3, [i_kr]
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
    mov r15d, r14d
    shl r15d, 5
    lea eax, [r14 + r13]
    shl eax, 5
    mov [rbx + S(G_bm)], rax
    mov ecx, [rbx + V_mk]
    lea eax, [rax + rcx*4 + 63]
    and eax, -64
    mov [rbx + S(G_hx)], rax
    mov ecx, [rbx + V_nx]
    shl ecx, 5
    xor edx, edx
    cmp dword [rbx + S(G_gp)], 16
    setae dl
    shlx ecx, ecx, edx
    add ecx, 63
    and ecx, -64
    add eax, ecx
    mov [rbx + S(G_hv)], rax
    shl ebp, 6
    lea esi, [rax + rbp]
    call xav_amap
    mov r11, rax
    mov [rbx + S(G_pd)], rax
    add r15, rax
    mov [rbx + S(G_rd)], r15
    add [rbx + S(G_bm)], rax
    add [rbx + S(G_hx)], rax
    add [rbx + S(G_hv)], rax
    mov dword [r11 + Pc_ci], 4
    vcvtsi2sd xmm15, xmm15, r14
    vmovsd xmm14, [i_one]
    vdivsd xmm14, xmm14, xmm15
    mov ecx, r14d
    cmp dword [rbx + S(G_gp)], 16
    cmovb ecx, r13d
    sub ecx, r12d
    lea rdx, [r15 + rcx*8]
    lea r10, [r12*8]
    mov eax, r12d
    jmp .tb
.ta:
    vcvtsi2sd xmm1, xmm15, rax
    vmulsd xmm1, xmm1, xmm14
    vcvtsd2ss xmm1, xmm1, xmm1
    vmovss [r15 + rax*8 + 4], xmm1
    vmovss [rdx], xmm1
    sub rdx, r10
    add eax, r12d
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
    mov [rbx + V_stop], r15
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
    mov ecx, [r11 + Pc_ci]
    lea ebp, [rcx + rdx*8]
    shl ebp, 24
    vmovdqu ymm0, [r11 + Pc_n]
    vextracti128 xmm1, ymm0, 1
    vpackusdw xmm0, xmm0, xmm1
    vpackuswb xmm0, xmm0, xmm0
    vmovq rcx, xmm0
    test [i_mf8], rcx
    pext rcx, rcx, [i_m07]
    mov edx, -1
    cmovnz ecx, edx
    or ecx, ebp
    mov [r11 + Pc_sg], ecx
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
    cmp r11, [rbx + V_stop]
    jb .c
    cmp r11, r15
    jne .ce
    lea eax, [r14 + 1]
    jmp .km
.cz:
    test r8b, 1
    jnz .cn
    mov [rbx + V_stop], r11
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
    vmovdqu ymm0, [r11 + Pc_n]
    vextracti128 xmm1, ymm0, 1
    vpackusdw xmm0, xmm0, xmm1
    vpackuswb xmm0, xmm0, xmm0
    vmovq rcx, xmm0
    pext rcx, rcx, [i_m07]
    mov edx, [r11 + Pc_ci]
    lea edx, [rdx + rsi*8]
    shl edx, 24
    or ecx, edx
    mov [r11 + Pc_sg], ecx
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
    vpaddd ymm0, ymm9, [rsi]
    vmovdqa ymm1, [rsi + 32]
    vmovdqa ymm2, [rsi + 64]
    vmovdqa ymm3, [rsi + 96]
    vmovdqa [r11], ymm0
    vmovdqa [r11 + 32], ymm1
    vmovdqa [r11 + 64], ymm2
    vmovdqa [r11 + 96], ymm3
    mov [r11 + Pc_ci], edx
    mov ecx, [r11 + Pc_sg]
    lea edi, [rdx - 4]
    shl edi, 24
    add edi, ecx
    cmp ecx, -1
    cmove edi, ecx
    mov [r11 + Pc_sg], edi
    sub rsi, r11
    sub r11, -128
    cmp rsi, -512
    jle .pl
    mov ecx, esi
    neg ecx
    lzcnt edx, ecx
    sub edx, 22
    vmovd xmm8, edx
    vpslld ymm8, ymm9, xmm8
    vmovdqa [rbx + V_dl], ymm8
    vpaddd ymm0, ymm9, [r11 + rsi + 0]
    vmovdqa ymm1, [r11 + rsi + 32]
    vmovdqa ymm2, [r11 + rsi + 64]
    vmovdqa ymm3, [r11 + rsi + 96]
    vmovdqa [r11 + 0], ymm0
    vmovdqa [r11 + 32], ymm1
    vmovdqa [r11 + 64], ymm2
    vmovdqa [r11 + 96], ymm3
    vpaddd ymm4, ymm9, [r11 + rsi + 128]
    vmovdqa ymm5, [r11 + rsi + 160]
    vmovdqa ymm6, [r11 + rsi + 192]
    vmovdqa ymm7, [r11 + rsi + 224]
    vmovdqa [r11 + 128], ymm4
    vmovdqa [r11 + 160], ymm5
    vmovdqa [r11 + 192], ymm6
    vmovdqa [r11 + 224], ymm7
    vpaddd ymm8, ymm9, [r11 + rsi + 256]
    vmovdqa [r11 + 256], ymm8
    vpaddd ymm12, ymm9, [r11 + rsi + 384]
    vmovdqa [r11 + 384], ymm12
    vmovdqa ymm9, [r11 + rsi + 288]
    vmovdqa ymm10, [r11 + rsi + 320]
    vmovdqa ymm11, [r11 + rsi + 352]
    vmovdqa [r11 + 288], ymm9
    vmovdqa [r11 + 320], ymm10
    vmovdqa [r11 + 352], ymm11
    vmovdqa ymm13, [r11 + rsi + 416]
    vmovdqa ymm14, [r11 + rsi + 448]
    vmovdqa ymm15, [r11 + rsi + 480]
    vmovdqa [r11 + 416], ymm13
    vmovdqa [r11 + 448], ymm14
    vmovdqa [r11 + 480], ymm15
    add r11, 512
    shlx rsi, rsi, rdx
    cmp rsi, -512
    je .pr
    vmovdqa ymm9, [rbx + V_dl]
.pm:
    lea rdx, [r15 + rsi]
    sub r11, r15
.pq:
    vpaddd ymm0, ymm9, [rdx + r11]
    vmovdqa ymm1, [rdx + r11 + 32]
    vmovdqa ymm2, [rdx + r11 + 64]
    vmovdqa ymm3, [rdx + r11 + 96]
    vpaddd ymm4, ymm9, [rdx + r11 + 128]
    vmovdqa ymm5, [rdx + r11 + 160]
    vmovdqa ymm6, [rdx + r11 + 192]
    vmovdqa ymm7, [rdx + r11 + 224]
    vmovdqa [r15 + r11], ymm0
    vmovdqa [r15 + r11 + 32], ymm1
    vmovdqa [r15 + r11 + 64], ymm2
    vmovdqa [r15 + r11 + 96], ymm3
    vmovdqa [r15 + r11 + 128], ymm4
    vmovdqa [r15 + r11 + 160], ymm5
    vmovdqa [r15 + r11 + 192], ymm6
    vmovdqa [r15 + r11 + 224], ymm7
    add r11, 256
    js .pq
    jmp .pf
.pl:
    jne .pm
    vmovdqa [rbx + V_dl], ymm9
%assign i 0
%rep 16
    vmovdqa ymm %+ i, [r11 - 512 + i * 32]
%assign i i + 1
%endrep
.pr:
    mov rcx, r15
    sub rcx, r11
    and rcx, -1024
    add r11, rcx
    neg rcx
.pv:
    vpaddd ymm0, ymm0, [rbx + V_dl]
    vmovdqa [r11 + rcx + 0], ymm0
    vmovdqa [r11 + rcx + 32], ymm1
    vmovdqa [r11 + rcx + 64], ymm2
    vmovdqa [r11 + rcx + 96], ymm3
    vpaddd ymm4, ymm4, [rbx + V_dl]
    vmovdqa [r11 + rcx + 128], ymm4
    vmovdqa [r11 + rcx + 160], ymm5
    vmovdqa [r11 + rcx + 192], ymm6
    vmovdqa [r11 + rcx + 224], ymm7
    vpaddd ymm8, ymm8, [rbx + V_dl]
    vmovdqa [r11 + rcx + 256], ymm8
    vmovdqa [r11 + rcx + 288], ymm9
    vmovdqa [r11 + rcx + 320], ymm10
    vmovdqa [r11 + rcx + 352], ymm11
    vpaddd ymm12, ymm12, [rbx + V_dl]
    vmovdqa [r11 + rcx + 384], ymm12
    vmovdqa [r11 + rcx + 416], ymm13
    vmovdqa [r11 + rcx + 448], ymm14
    vmovdqa [r11 + rcx + 480], ymm15
    vpaddd ymm0, ymm0, [rbx + V_dl]
    vmovdqa [r11 + rcx + 512 + 0], ymm0
    vmovdqa [r11 + rcx + 512 + 32], ymm1
    vmovdqa [r11 + rcx + 512 + 64], ymm2
    vmovdqa [r11 + rcx + 512 + 96], ymm3
    vpaddd ymm4, ymm4, [rbx + V_dl]
    vmovdqa [r11 + rcx + 512 + 128], ymm4
    vmovdqa [r11 + rcx + 512 + 160], ymm5
    vmovdqa [r11 + rcx + 512 + 192], ymm6
    vmovdqa [r11 + rcx + 512 + 224], ymm7
    vpaddd ymm8, ymm8, [rbx + V_dl]
    vmovdqa [r11 + rcx + 512 + 256], ymm8
    vmovdqa [r11 + rcx + 512 + 288], ymm9
    vmovdqa [r11 + rcx + 512 + 320], ymm10
    vmovdqa [r11 + rcx + 512 + 352], ymm11
    vpaddd ymm12, ymm12, [rbx + V_dl]
    vmovdqa [r11 + rcx + 512 + 384], ymm12
    vmovdqa [r11 + rcx + 512 + 416], ymm13
    vmovdqa [r11 + rcx + 512 + 448], ymm14
    vmovdqa [r11 + rcx + 512 + 480], ymm15
    add rcx, 1024
    jnz .pv
.pw:
    mov rcx, r15
    sub rcx, r11
    cmp rcx, 512
    jb .pn
    vpaddd ymm0, ymm0, [rbx + V_dl]
    vmovdqa [r11 + 0], ymm0
    vmovdqa [r11 + 32], ymm1
    vmovdqa [r11 + 64], ymm2
    vmovdqa [r11 + 96], ymm3
    vpaddd ymm4, ymm4, [rbx + V_dl]
    vmovdqa [r11 + 128], ymm4
    vmovdqa [r11 + 160], ymm5
    vmovdqa [r11 + 192], ymm6
    vmovdqa [r11 + 224], ymm7
    vpaddd ymm8, ymm8, [rbx + V_dl]
    vmovdqa [r11 + 256], ymm8
    vmovdqa [r11 + 288], ymm9
    vmovdqa [r11 + 320], ymm10
    vmovdqa [r11 + 352], ymm11
    vpaddd ymm12, ymm12, [rbx + V_dl]
    vmovdqa [r11 + 384], ymm12
    vmovdqa [r11 + 416], ymm13
    vmovdqa [r11 + 448], ymm14
    vmovdqa [r11 + 480], ymm15
    add r11, 512
.pn:
    cmp r11, r15
    je .pf
    vpaddd ymm0, ymm0, [rbx + V_dl]
    vmovdqa [r11 + 0], ymm0
    vmovdqa [r11 + 32], ymm1
    vmovdqa [r11 + 64], ymm2
    vmovdqa [r11 + 96], ymm3
    vpaddd ymm4, ymm4, [rbx + V_dl]
    vmovdqa [r11 + 128], ymm4
    vmovdqa [r11 + 160], ymm5
    vmovdqa [r11 + 192], ymm6
    vmovdqa [r11 + 224], ymm7
    vpaddd ymm8, ymm8, [rbx + V_dl]
    vmovdqa [r11 + 256], ymm8
    vmovdqa [r11 + 288], ymm9
    vmovdqa [r11 + 320], ymm10
    vmovdqa [r11 + 352], ymm11
    vpaddd ymm12, ymm12, [rbx + V_dl]
    vmovdqa [r11 + 384], ymm12
    vmovdqa [r11 + 416], ymm13
    vmovdqa [r11 + 448], ymm14
    vmovdqa [r11 + 480], ymm15
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
    vmovd xmm1, eax
    vpbroadcastd xmm1, xmm1
    popcnt ecx, edx
    vmovd xmm0, ecx
    vpslld xmm2, xmm1, xmm0
    vpsubd xmm2, xmm1, xmm2
    vmovdqa [rbx + V_A], xmm1
    vmovdqa [rbx + V_B], xmm2
    vmovd xmm3, edx
    vpbroadcastd xmm3, xmm3
    mov eax, [rbx + S(G_hi)]
    shr eax, 1
    vpmovsxbd xmm5, [i_rq]
    vpxor xmm6, xmm6, xmm6
    vpmaxsd xmm0, xmm5, xmm6
    vpand xmm0, xmm0, xmm3
    vpmulld xmm0, xmm0, xmm1
    vmovdqa [r15], ymm0
    vpaddd ymm0, ymm0, [i_e4]
    vmovdqa [r15 + 32], ymm0
    vpmovzxbd xmm0, [i_io]
    vpand xmm0, xmm0, xmm3
    vpmulld xmm0, xmm0, xmm1
    lea rdi, [r15 + 64]
    lea esi, [rax - 3]
    imul r8d, eax, 64
    lea r8, [r15 + r8 - 128]
    cmp edx, 7
    ja .rl
%assign i 1
%rep 7
%assign j i - 1
    vpaddd xmm8, xmm %+ j, [rbx + V_A]
    vpaddd xmm %+ i, xmm %+ j, [rbx + V_B]
    vpminud xmm %+ i, xmm %+ i, xmm8
%assign i i + 1
%endrep
%assign i 0
%rep 8
%assign j i + 8
    vpaddd ymm %+ j, ymm %+ i, [i_e4]
%assign i i + 1
%endrep
    mov ecx, esi
    and ecx, -16
    shl ecx, 6
    add rdi, rcx
    neg rcx
.rb:
%assign i 0
%rep 16
%assign a i & 7
%assign j a + 8
    vmovdqa [rdi + rcx + i * 64], ymm %+ a
    vmovdqa [rdi + rcx + i * 64 + 32], ymm %+ j
%assign i i + 1
%endrep
    add rcx, 1024
    jnz .rb
    test esi, 8
    jz .rt0
%assign i 0
%rep 8
%assign j i + 8
    vmovdqa [rdi + i * 64], ymm %+ i
    vmovdqa [rdi + i * 64 + 32], ymm %+ j
%assign i i + 1
%endrep
    add rdi, 512
.rt0:
    sub rdi, r8
.rt:
    vmovdqa ymm0, [r8 + rdi - 512]
    vmovdqa ymm8, [r8 + rdi - 480]
    vmovdqa [r8 + rdi], ymm0
    vmovdqa [r8 + rdi + 32], ymm8
    add rdi, 64
    js .rt
    jmp .re
.rl:
    lea ecx, [rdx + 1]
    shl ecx, 6
    add rdi, rcx
    neg rcx
.rk:
    vmovdqa [rdi + rcx], ymm0
    vpaddd ymm8, ymm0, [i_e4]
    vmovdqa [rdi + rcx + 32], ymm8
    vpaddd xmm8, xmm0, xmm1
    vpaddd xmm0, xmm0, xmm2
    vpminud xmm0, xmm0, xmm8
    add rcx, 64
    jnz .rk
    inc edx
    shl edx, 6
    neg rdx
    add rdx, r8
    sub rdi, r8
.rc2:
    vmovdqa ymm0, [rdx + rdi]
    vmovdqa ymm8, [rdx + rdi + 32]
    vmovdqa ymm9, [rdx + rdi + 64]
    vmovdqa ymm10, [rdx + rdi + 96]
    vmovdqa [r8 + rdi], ymm0
    vmovdqa [r8 + rdi + 32], ymm8
    vmovdqa [r8 + rdi + 64], ymm9
    vmovdqa [r8 + rdi + 96], ymm10
    sub rdi, -128
    js .rc2
.re:
    vmovdqa xmm1, [rbx + V_A]
    vpbroadcastd xmm3, [rbx + S(G_km)]
    lea ecx, [rax - 1]
    vmovd xmm4, ecx
    vpbroadcastd xmm4, xmm4
    vpcmpeqd xmm6, xmm6, xmm6
    vpaddd xmm0, xmm4, xmm6
    vpmovsxbd xmm5, [i_rq]
    vpaddd xmm5, xmm5, xmm0
    vpminsd xmm0, xmm5, xmm4
    vpand xmm0, xmm0, xmm3
    vpmulld xmm0, xmm0, xmm1
    vmovdqa [r8], ymm0
    vpaddd ymm0, ymm0, [i_e4]
    vmovdqa [r8 + 32], ymm0
    vpsubd xmm5, xmm5, xmm6
    vpminsd xmm0, xmm5, xmm4
    vpand xmm0, xmm0, xmm3
    vpmulld xmm0, xmm0, xmm1
    vmovdqa [r8 + 64], ymm0
    vpaddd ymm0, ymm0, [i_e4]
    vmovdqa [r8 + 96], ymm0
    lea rdi, [r8 + 128]
    mov ecx, [rbx + S(G_wi)]
    vpcmpeqd ymm0, ymm0, ymm0
    mov edx, ecx
    shr edx, 6
    shl edx, 5
    lea rsi, [rdi + rdx - 256]
    sub rdi, rsi
.m0:
%assign i 0
%rep 8
    vmovdqa [rsi + rdi + i * 32], ymm0
%assign i i + 1
%endrep
    add rdi, 256
    js .m0
%assign i 0
%rep 8
    vmovdqa [rsi + i * 32], ymm0
%assign i i + 1
%endrep
    and ecx, 62
    shr ecx, 1
    neg rcx
    vmovdqu ymm1, [abs i_pm + 32 + rcx]
    vmovdqa [rsi + 256], ymm1
    vmovaps ymm14, [rbx + V_W]
    vmovaps ymm15, [rbx + V_W + 32]
    mov eax, [rbx + S(G_gp)]
    vmovd xmm13, eax
    vpbroadcastd ymm13, xmm13
    vpcmpeqd ymm11, ymm11, ymm11
    vpsrld ymm10, ymm11, 28
    mov r8, [rbx + S(G_hx)]
    mov r10, [rbx + S(G_hv)]
    mov ebp, [rbx + V_ns]
    cmp eax, 16
    jb .h2
    vpmovzxbd ymm0, [i_io]
    vpmulld ymm0, ymm0, ymm13
    vpslld ymm1, ymm13, 3
    vpaddd ymm1, ymm1, ymm0
    vpsrld ymm2, ymm0, 4
    vpsrld ymm3, ymm1, 4
    vpbroadcastd ymm4, xmm3
    vpsubd ymm3, ymm3, ymm4
    vpslld ymm4, ymm11, 3
    vpxor ymm2, ymm2, ymm4
    vpxor ymm3, ymm3, ymm4
    mov edx, [rbx + V_nx]
    shl edx, 5
    lea r9, [r8 + rdx]
    lea r11, [r9 + rdx]
    neg rdx
.hu:
    vpsubd ymm2, ymm2, ymm4
    vpand ymm5, ymm2, [i_m87]
    vmovdqa [r9 + rdx], ymm5
    vpsubd ymm3, ymm3, ymm4
    vpand ymm5, ymm3, [i_m87]
    vmovdqa [r11 + rdx], ymm5
    add rdx, 32
    jnz .hu
    vpandn ymm5, ymm0, ymm10
    vpermps ymm6, ymm5, ymm14
    vpermps ymm7, ymm5, ymm15
    vpslld ymm5, ymm5, 28
    vpslld ymm9, ymm13, 31
    vblendvps ymm8, ymm6, ymm7, ymm5
    vxorps ymm5, ymm5, ymm9
    vblendvps ymm12, ymm6, ymm7, ymm5
    mov eax, ebp
    shl eax, 5
    lea r9, [r10 + rax]
    vmovaps [r10], ymm8
    vmovaps [r9], ymm12
    vpaddd ymm4, ymm13, [i_m17]
    vpand ymm2, ymm0, ymm10
    vpaddd ymm2, ymm2, ymm4
    vpand ymm3, ymm1, ymm10
    vpaddd ymm3, ymm3, ymm4
    vpand ymm5, ymm2, ymm10
    vpermps ymm6, ymm5, ymm14
    vpermps ymm7, ymm5, ymm15
    vpslld ymm5, ymm5, 28
    vblendvps ymm0, ymm6, ymm7, ymm5
    vxorps ymm5, ymm5, ymm9
    vblendvps ymm1, ymm6, ymm7, ymm5
    vbroadcastss ymm8, [rbx + V_W + 60]
    vpxor xmm12, xmm12, xmm12
    lea r11, [r9 + rax]
    mov rcx, 32
    sub rcx, rax
.ht:
    vpaddd ymm2, ymm2, [i_m16]
    vblendvps ymm5, ymm8, ymm0, ymm2
    vblendvps ymm0, ymm0, ymm12, ymm2
    vmovaps [r9 + rcx], ymm5
    vpaddd ymm3, ymm3, [i_m16]
    vblendvps ymm5, ymm8, ymm1, ymm3
    vblendvps ymm1, ymm1, ymm12, ymm3
    vmovaps [r11 + rcx], ymm5
    add rcx, 32
    jnz .ht
    jmp .hz
.h2:
    vpmovzxbd ymm0, [i_io]
    vpaddd ymm1, ymm13, ymm13
    vpmulld ymm0, ymm0, ymm1
    vpaddd ymm1, ymm0, ymm13
    vpaddd ymm3, ymm1, ymm11
    vpaddd ymm2, ymm3, ymm13
    vpsrld ymm4, ymm0, 4
    vpaddd ymm5, ymm4, [i_m8]
    vpxor ymm5, ymm5, [i_m8]
    vpand ymm5, ymm5, [i_m87]
    vmovdqa [r8], ymm5
    vpslld ymm4, ymm4, 4
    vpaddd ymm6, ymm4, ymm10
    vpxor xmm12, xmm12, xmm12
    vpminsd ymm7, ymm3, ymm6
    vpsubd ymm7, ymm7, ymm0
    vpermps ymm8, ymm7, ymm14
    vpermps ymm9, ymm7, ymm15
    vpslld ymm5, ymm7, 28
    vblendvps ymm8, ymm8, ymm9, ymm5
    vmovaps [r10], ymm8
    vpminsd ymm7, ymm2, ymm6
    vpsubd ymm7, ymm7, ymm1
    vpermps ymm8, ymm7, ymm14
    vpermps ymm9, ymm7, ymm15
    vpslld ymm5, ymm7, 28
    vblendvps ymm8, ymm8, ymm9, ymm5
    vblendvps ymm8, ymm8, ymm12, ymm7
    vmovaps [r10 + 32], ymm8
    vpsubd ymm4, ymm4, [i_m16]
    vpsubd ymm6, ymm6, [i_m16]
    vpsubd ymm7, ymm3, ymm4
    vpermps ymm8, ymm7, ymm14
    vpermps ymm9, ymm7, ymm15
    vpslld ymm5, ymm7, 28
    vblendvps ymm8, ymm8, ymm9, ymm5
    vblendvps ymm8, ymm8, ymm12, ymm7
    vmovaps [r10 + 64], ymm8
    vpminsd ymm7, ymm2, ymm6
    vpmaxsd ymm8, ymm1, ymm4
    vpsubd ymm7, ymm7, ymm8
    vpermps ymm8, ymm7, ymm14
    vpermps ymm9, ymm7, ymm15
    vpslld ymm5, ymm7, 28
    vblendvps ymm8, ymm8, ymm9, ymm5
    vblendvps ymm8, ymm8, ymm12, ymm7
    vmovaps [r10 + 96], ymm8
    cmp ebp, 2
    je .hz
    vmovaps [r10 + 128], ymm12
    vpsubd ymm4, ymm4, [i_m16]
    vpsubd ymm7, ymm2, ymm4
    vpermps ymm8, ymm7, ymm14
    vpermps ymm9, ymm7, ymm15
    vpslld ymm5, ymm7, 28
    vblendvps ymm8, ymm8, ymm9, ymm5
    vblendvps ymm8, ymm8, ymm12, ymm7
    vmovaps [r10 + 160], ymm8
.hz:
    mov eax, [rbx + S(G_km)]
    inc eax
    imul rax, [rbx + S(G_wp)]
    lea rax, [rax*8 + GDS + 63]
    and rax, -64
    mov [rbx + S(G_ct)], rax
    mov qword [rbx + S(G_cr)], GDS
    mov ecx, [rbx + S(G_wi)]
    lea rax, [rax + rcx*4 + 256 + 63]
    and rax, -64
    mov [rbx + S(G_nx)], rax
    imul rcx, [rbx + S(G_wp)], 48
    lea rax, [rax + rcx + 63]
    and rax, -64
    mov [rbx + S(G_ab)], rax
    mov rcx, [rbx + S(G_az)]
    lea rax, [rax + rcx*2]
    add rax, rcx
    mov [rbx + S(G_sb2)], rax
    imul rcx, [rbx + S(G_spp)], 48
    add rax, rcx
    mov [rbx + S(G_cl)], rax
    mov rcx, [rbx + S(G_su)]
    shl rcx, 6
    lea rax, [rax + rcx*4]
    mov [rbx + S(G_cc)], rax
    add rax, rcx
    mov [rbx + S(G_oc)], rax
    sub rax, -128
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
    vmovq xmm12, rax
    vpbroadcastq ymm12, xmm12
    vmovq xmm13, r12
    vpbroadcastq ymm14, xmm13
    vpxor xmm0, xmm0, xmm0
    vpblendd ymm13, ymm14, ymm0, 0x03
    vpblendd ymm15, ymm14, ymm0, 0xc0
    vmovdqa [rbx + V_W], ymm13
    vmovdqa [rbx + V_W + 32], ymm14
    vmovdqa [rbx + V_A], ymm15
    vpblendd ymm1, ymm12, ymm0, 0x03
    vpaddq ymm1, ymm1, [rbx + 32]
    vpaddq ymm2, ymm12, [rbx + 64]
    vpblendd ymm3, ymm12, ymm0, 0xc0
    vpaddq ymm3, ymm3, [rbx + 96]
    vmovdqa ymm0, [rbx]
%assign i 4
%rep 11
    vmovdqa ymm %+ i, [rbx + i * 32]
%assign i i + 1
%endrep
    dec r13d
    jz .w1
.w:
%assign i 0
%rep 15
    vmovdqa [rax + 64 + i * 32], ymm %+ i
%assign i i + 1
%endrep
%assign i 15
%rep 3
    vmovdqa ymm15, [rbx + i * 32]
    vmovdqa [rax + 64 + i * 32], ymm15
%assign i i + 1
%endrep
    vpaddq ymm1, ymm1, [rbx + V_W]
    vpaddq ymm2, ymm2, [rbx + V_W + 32]
    vpaddq ymm3, ymm3, [rbx + V_A]
    add rax, r12
    dec r13d
    jnz .w
.w1:
%assign i 0
%rep 15
    vmovdqa [rax + 64 + i * 32], ymm %+ i
%assign i i + 1
%endrep
%assign i 15
%rep 3
    vmovdqa ymm15, [rbx + i * 32]
    vmovdqa [rax + 64 + i * 32], ymm15
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
