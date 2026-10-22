%macro M2s_a0 0
section .rodata align=64
align 32
c_c8: dd 0x3681ed35, 0x37ab706d, 0x00000000, 0x38e23720, 0x3a153f18, 0x00000000, 0x3b44ee90, 0x00000000
c_p8: dd -100663296, 0, 100663296, 201326592, 301989888, -402653184, -301989888, -201326592
c_w8e: dd 0x3f9488ae, 0x3fbfffaa, 0x3ff68ab1, 0x401ae8f8, 0x4039f643, 0x4063845e, 0x40841f2c, 0x409df647
c_rxe: dd 0x7ef09c9a, 0x7ed83501, 0x7ec2d0b8, 0x7eb12034, 0x7ea42488, 0x7e96e9a7, 0x7e8dca50, 0x7e839ebe
c_w8o: dd 0x3f83467d, 0x3f898b8c, 0x3f8f4de9, 0x3f9498d9, 0x3f99e756, 0x3f9f2c4e, 0x3fa3b9bb, 0x3fa8fd87
c_rxo: dd 0x7ef0effc, 0x7ed76a31, 0x7ec337ff, 0x7eb2f1e6, 0x7ea47e1d, 0x7e97b994, 0x7e8dcbd5, 0x7e836c99
c_to: dd 0x3fd6b0c1, 0x400f49e7, 0x403f4477, 0x407f4fb8, 0x40aa6661, 0x40e374e4, 0x4117cf1f, 0x414aa40b, 0x41873f1b, 0x41b4884d, 0x41f0fb5c, 0x4220d60b, 0x4256b0c1, 0x428f49e7, 0x42bf4477, 0x42ff4fb8, 0x3c873f1b, 0x3cb4884d, 0x3cf0fb5c, 0x3d20d60b, 0x3d56b0c1, 0x3d8f49e7, 0x3dbf4477, 0x3dff4fb8, 0x3e2a6661, 0x3e6374e4, 0x3e97cf1f, 0x3ecaa40b, 0x3f073f1b, 0x3f34884d, 0x3f70fb5c, 0x3fa0d60b
c_q8e0: dd 0x40199999, 0x40199999, 0x40199999, 0x40199999, 0x40199999, 0x40199999, 0x40199999, 0x40199999
c_q8e1: dd 0x3fd70a3f, 0x3fd70a3f, 0x3fd70a3f, 0x3fd70a3f, 0x3fd70a3f, 0x3fd70a3f, 0x3fd70a3f, 0x3fd70a3f
c_q8e2: dd 0x3e656e54, 0x3e656e54, 0x3e656e54, 0x3e656e54, 0x3e656e54, 0x3e656e54, 0x3e656e54, 0x3e656e54
c_q8e3: dd 0xbd09fd74, 0xbd09fd74, 0xbd09fd74, 0xbd09fd74, 0xbd09fd74, 0xbd09fd74, 0xbd09fd74, 0xbd09fd74
c_q8o0: dd 0x3ed5554f, 0x3ed5554f, 0x3ed5554f, 0x3ed5554f, 0x3ed5554f, 0x3ed5554f, 0x3ed5554f, 0x3ed5554f
c_q8o1: dd 0xbdf8e37b, 0xbdf8e37b, 0xbdf8e37b, 0xbdf8e37b, 0xbdf8e37b, 0xbdf8e37b, 0xbdf8e37b, 0xbdf8e37b
c_q8o2: dd 0x3d83ac9a, 0x3d83ac9a, 0x3d83ac9a, 0x3d83ac9a, 0x3d83ac9a, 0x3d83ac9a, 0x3d83ac9a, 0x3d83ac9a
c_q8o3: dd 0xbd2a296f, 0xbd2a296f, 0xbd2a296f, 0xbd2a296f, 0xbd2a296f, 0xbd2a296f, 0xbd2a296f, 0xbd2a296f
c_eq: dd 0x3ed57359, 0x3ed57359, 0x3ed57359, 0x3ed57359, 0x3ed57359, 0x3ed57359, 0x3ed57359, 0x3ed57359
c_ieq: dd 0x40198401, 0x40198401, 0x40198401, 0x40198401, 0x40198401, 0x40198401, 0x40198401, 0x40198401
c_epsf: dd 0x0da24260, 0x0da24260, 0x0da24260, 0x0da24260, 0x0da24260, 0x0da24260, 0x0da24260, 0x0da24260
c_h0625: dd 0x3d800000, 0x3d800000, 0x3d800000, 0x3d800000, 0x3d800000, 0x3d800000, 0x3d800000, 0x3d800000
c_h5625: dd 0x3f100000, 0x3f100000, 0x3f100000, 0x3f100000, 0x3f100000, 0x3f100000, 0x3f100000, 0x3f100000
c_half: dd 0x3f000000, 0x3f000000, 0x3f000000, 0x3f000000, 0x3f000000, 0x3f000000, 0x3f000000, 0x3f000000
c_mone: dd 0xbf800000, 0xbf800000, 0xbf800000, 0xbf800000, 0xbf800000, 0xbf800000, 0xbf800000, 0xbf800000
c_n512: dd -512, -512, -512, -512, -512, -512, -512, -512
c_absm: dd 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647, 2147483647
c_i512: dd 512, 512, 512, 512, 512, 512, 512, 512
c_i1023: dd 1023, 1023, 1023, 1023, 1023, 1023, 1023, 1023
c_k5: dd 26215, 26215, 26215, 26215, 26215, 26215, 26215, 26215
c_7: dd 7, 7, 7, 7, 7, 7, 7, 7
c_xflr: dd 897581056, 897581056, 897581056, 897581056, 897581056, 897581056, 897581056, 897581056
c_xlo: dd 939524096, 939524096, 939524096, 939524096, 939524096, 939524096, 939524096, 939524096
%endmacro
%macro M2s_a1 0
align 32
c_iota: dd 0, 1, 2, 3, 4, 5, 6, 7
c_m512f: times 8 dd -512.0
c_sgn: times 8 dd 0x80000000
%endmacro
%macro M2s_a2 0
align 32
align 32
u_rx: dq 0x3fef07c200000000, 0x3fed41d420000000, 0x3febacf920000000, 0x3fea41a420000000, 0x3fe8f9c180000000, 0x3fe7d05f40000000, 0x3fe6c16c20000000, 0x3fe5c98820000000, 0x3fe4e5e0a0000000, 0x3fe4141420000000, 0x3fe3521d00000000, 0x3fe29e4120000000, 0x3fe1f70480000000, 0x3fe15b1e60000000, 0x3fe0c97140000000, 0x3fe0410420000000
u_oa: dq 0x3ff0000000000000, 0x3ff55b8108f0ec5e, 0x3ffc823e074ec129, 0x400306fe0a31b715, 0x400965fea53d6e3d, 0x4010f38f92d97963, 0x4016a09e667f3bcd, 0x401e3437e7101344, 0x402428a2f98d728b, 0x402ae89f995ad3ad, 0x4031f59ac3c7d6c0, 0x4037f910d768cfb0, 0x4040000000000000, 0x40455b8108f0ec5e, 0x404c823e074ec129, 0x405306fe0a31b715
u_ob: dq 0x3ff55b8108f0ec5e, 0x3d0ae89f995ad3ad, 0x3d755b8108f0ec5e, 0x3de0f38f92d97963, 0x3e4ae89f995ad3ad, 0x3eb55b8108f0ec5e, 0x3f20f38f92d97963, 0x3f8ae89f995ad3ad
u_ow: dq 0x3ff034dae33d2513, 0x3ff09bd444ecbfc7, 0x3ff0ff6ccdf729fe, 0x3ff15fed75e356b9, 0x3ff1bd95a53cf85d, 0x3ff2189cd11a12f7, 0x3ff27133f24e1985, 0x3ff2c78674186ae1, 0x3ff31bbaed16c926, 0x3ff36df401e38c70, 0x3ff3be50ec4f2493, 0x3ff40cedcd83f513, 0x3ff459e41f1dd6e4, 0x3ff4a54b31dd20b6, 0x3ff4ef3841597f2a, 0x3ff537be9ed40652
u_tsl: dq 0x3dd51cb453b9536c, 0x3dfbdb8cdadbe120, 0x3e22611186bae675, 0x3e48406003b2ae5c, 0x3e70000000000000, 0x3e951cb453b9536c, 0x3ebbdb8cdadbe120, 0x3ee2611186bae675, 0x3f08406003b2ae5c, 0x3f30000000000000, 0x3f551cb453b9536c, 0x3f7bdb8cdadbe120, 0x3fa2611186bae675, 0x3fc8406003b2ae5c, 0x3ff0000000000000, 0x40151cb453b9536c
u_wsx: dq 0xbfa2884e4caaa8b5, 0xbfa557e5cc562f5c, 0xbfa8636e86025bc6, 0xbfabac41c03660b9, 0xbfaf33ad92170f1c, 0xbfb17d7a9ef3c7d0, 0xbfb381a9d5f0cf36, 0xbfb5a6fd9f98b664, 0xbfb7ee0a667b1b6e, 0xbfba576153447ca6, 0xbfbce39084da1457, 0xbfbf932227654437, 0xbfc1334e72239053, 0xbfc2af42d88adfc4, 0xbfc43daf1baf4812, 0xbfc5ded1f9a2855c
align 32
u_cs: dq 0x3ff0000000000000, 0x4000000000000000, 0x4008000000000000, 0x4010000000000000, 0x4014000000000000, 0x4018000000000000, 0x401c000000000000, 0x4020000000000000, 0x4022000000000000, 0x4024000000000000, 0x4026000000000000, 0x4028000000000000, 0x402a000000000000
align 32
u_epsn: times 4 dq 0x07e0e7c9eebc444a
u_one: times 4 dq 0x3ff0000000000000
u_eq0: times 4 dq 0x3fdaac5555555556
u_omg: times 4 dq 0x3ddb7cdfd9d7bdbb
u_zero: times 4 dq 0x0000000000000000
u_1023: times 4 dq 0x408ff80000000000
u_mone: times 4 dq 0xbff0000000000000
u_op0: times 4 dq 0x3fefffffffffc441
u_op1: times 4 dq 0x3fdaaaaaa242d844
u_op2: times 4 dq 0xbfbf1c716de3f83a
u_op3: times 4 dq 0x3fb06db0f52d1c57
u_op4: times 4 dq 0xbfa53afd84e96ced
u_psx0: times 4 dq 0xc03dbea9bbad8eee
u_psx1: times 4 dq 0xc051d8cc3d0ddf6c
u_psx2: times 4 dq 0xc048fc51264891a4
u_psx3: times 4 dq 0xc01aa71d26143139
u_tsk: times 4 dq 0x3d88406003b2ae5c
u_xflr: times 4 dq 0x3e00000000000000
u_rg2: times 4 dq 0x3dde3c8fd606ea4e
u_tab: times 4 dq 0x3bc79ca10c924223
u_clo: times 4 dq 0x407fffffffffbb48
%endmacro
%macro M2s_a3 0
u_chi: times 4 dq 0x408000000000225c
u_512: times 4 dq 0x4080000000000000
u_ln2: times 4 dq 0x3fe62e42fefa39ef
u_i1024: times 4 dq 0x3f50000000000000
u_half: times 4 dq 0x3fe0000000000000
u_mhalf: times 4 dq 0xbfe0000000000000
u_magic: times 4 dq 0x43380000000003ff
u_absm: times 4 dq 0x7fffffffffffffff
u_mzero: times 4 dq 0x8000000000000000
u_mant: times 4 dq 0x000fffffffffffff
u_oneb: times 4 dq 0x3ff0000000000000
u_i15: times 4 dq 15
u_i7: times 4 dq 7
u_i16: times 4 dq 16
u_ln2d: dq 0x3fe62e42fefa39ef, 0x3c7abc9e3b39803f
u_e125: dq 0x4003333333333333, 0x3c9999999999999a
%endmacro
%macro M2s_a4 0
u_e512: dq 0x3fdaaaaaaaaaaaab, 0xbc75555555555555
u_kr: dq 0x3fcb367a0f9096bc, 0xbc69ce075f6fd220
u_kg: dq 0x3fe6e2eb1c432ca5, 0x3c8e9e1b089a0275
u_kb: dq 0x3fb27bb2fec56d5d, 0xbc154c985f06f694
%endmacro
%macro M2s_a5 0
    push rbp
    push rbx
    push r12
    push r13
    push r14
    push r15
    mov rax, rsp
    and rsp, -64
    sub rsp, 1856
    mov rbp, rsp
    mov [rbp + 0], rax
    mov [rbp + 8], rdi
    mov r15, [rdi + G_pd]
    mov rax, [rdi + G_ho]
    shr rax, 1
    mov [rbp + 24], rax
%endmacro
%macro M2s_a6 0
    xor eax, eax
    mov [rbp + 16], rax
    mov [rbp + 32], rax
    mov [rbp + 272], rax
    mov [rbp + 280], rax
    mov rax, [rdi + G_sp]
    add rax, 31
    shr rax, 5
%endmacro
%macro M2s_a7 0
    mov rax, [rcx + rax*8 - 8]
    mov [rbp + 328], rax
.per:
    mov [rbp + 48], r15
.rg:
    mov ecx, [r15 + Pc_ch]
    cmp [rbp + 32], rcx
    ja .rgd
    mov rcx, [rbp + 32]
    mov rdi, [rbp + 8]
    mov r8, [rdi + G_wc]
    mov rax, rcx
    imul rax, [rdi + G_cs]
    add rax, rax
    mov rsi, [rdi + G_sb]
    add rsi, rax
    mov rdx, [rdi + G_sr]
    add rdx, rax
    mov r9, [rdi + G_ct]
    lea r10, [r9 + 32]
    lea r11, [r9 + r8*4 + 160]
    and rcx, [rdi + G_km]
    imul rcx, [rdi + G_wp]
    shl rcx, 3
    add rcx, [rdi + G_cr]
    mov r12, rcx
    mov r13, [rdi + G_nbc]
    vmovdqu ymm7, [c_n512]
    xor eax, eax
    lea r14, [r13 - 1]
    test r14, r14
    jz .cvt
.cv1:
M2s_a8
    vcvtdq2ps ymm0, ymm0
    vcvtdq2ps ymm1, ymm1
    vmovups [r10 + rax*4], ymm0
    vmovups [r11 + rax*4], ymm1
    add eax, 8
    dec r14
    jnz .cv1
.cvt:
    vmovdqu ymm6, [rdi + G_ri]
M2s_b0
    vcvtdq2ps ymm0, ymm0
    vcvtdq2ps ymm1, ymm1
    vpermps ymm0, ymm6, ymm0
    vpermps ymm1, ymm6, ymm1
    vmovups [r10 + rax*4], ymm0
    vmovups [r11 + rax*4], ymm1
    vmovdqu ymm6, [c_7]
    vpermps ymm0, ymm6, ymm0
    vpermps ymm1, ymm6, ymm1
    vmovups [r10 + rax*4 + 32], ymm0
    vmovups [r11 + rax*4 + 32], ymm1
    vbroadcastss ymm0, [r10]
    vbroadcastss ymm1, [r11]
    vmovups [r10 - 32], ymm0
%endmacro
%macro M2s_a8 0
M2s_b0
%endmacro
%macro M2s_a9 0
    vmovups [r11 - 32], ymm1
    vmovaps ymm6, [c_h0625]
    vmovaps ymm7, [c_h5625]
    xor eax, eax
.cv2:
    vmovups ymm0, [r10 + rax*4]
    vaddps ymm1, ymm0, [r10 + rax*4 + 4]
    vmovups ymm2, [r10 + rax*4 - 4]
    vaddps ymm2, ymm2, [r10 + rax*4 + 8]
M2s_aa
    vperm2f128 ymm5, ymm3, ymm4, 0x20
    vperm2f128 ymm3, ymm3, ymm4, 0x31
    vmovups [r12 + 0], ymm5
    vmovups [r12 + 64], ymm3
    vmovups ymm0, [r11 + rax*4]
    vaddps ymm1, ymm0, [r11 + rax*4 + 4]
    vmovups ymm2, [r11 + rax*4 - 4]
    vaddps ymm2, ymm2, [r11 + rax*4 + 8]
M2s_b1
    vperm2f128 ymm5, ymm3, ymm4, 0x20
    vperm2f128 ymm3, ymm3, ymm4, 0x31
    vmovups [r12 + 32], ymm5
    vmovups [r12 + 96], ymm3
    add r12, 128
    add eax, 8
    dec r13
    jnz .cv2
    mov r15, [rbp + 48]
    inc qword [rbp + 32]
    jmp .rg
.rgd:
    mov qword [rbp + 40], 0
.str:
    mov rdi, [rbp + 8]
    mov rax, [rbp + 40]
    imul rax, [rdi + G_sp]
    mov [rbp + 56], rax
    mov rcx, [rdi + G_wi]
    sub rcx, rax
    mov rdx, [rdi + G_sp]
    cmp rcx, rdx
    cmova rcx, rdx
    add rcx, 7
    shr rcx, 3
    mov [rbp + 64], rcx
    mov rax, [rdi + G_sb2]
    mov [rbp + 88], rax
    mov rcx, [rdi + G_spp]
    shl rcx, 2
    mov [rbp + 120], rcx
    lea rax, [rax + rcx*4]
    mov [rbp + 96], rax
    mov rax, [rbp + 56]
    shl rax, 2
    add rax, [rdi + G_nx]
    mov [rbp + 104], rax
    mov rax, [rdi + G_wp]
    shl rax, 2
%endmacro
%macro M2s_aa 0
M2s_b1
%endmacro
%macro M2s_ab 0
    mov [rbp + 128], rax
    mov rax, [rdi + G_zr]
    mov [rbp + 112], rax
    mov r15, [rbp + 48]
    mov eax, [r15 + Pc_y0]
    mov [rbp + 72], rax
    mov eax, [r15 + Pc_n]
    add eax, [r15 + Pc_n + 4]
    add eax, [r15 + Pc_n + 8]
    add eax, [r15 + Pc_n + 12]
    add rax, [rbp + 72]
    dec rax
    mov [rbp + 352], rax
    mov qword [rbp + 344], -1
    mov eax, [r15 + Pc_n]
    test eax, eax
    jz .r0e
    mov [rbp + 80], rax
M2s_ac
    mov rax, [rbp + 112]
    mov [rbp + 152], rax
    mov qword [rbp + 160], 0
M2s_ad
    cmovne rcx, [rbp + 128]
    mov [rbp + 152], rax
    mov [rbp + 160], rcx
.r0:
    mov rax, [rbp + 152]
    cmp rax, [rbp + 112]
    jne .r0ca
    call .rowz
    jmp .r0cb
.r0ca:
    call .rowa
.r0cb:
    mov r15, [rbp + 48]
M2s_b2
M2s_ae
    inc qword [rbp + 72]
    dec qword [rbp + 80]
    jnz .r0
.r0e:
    cmp dword [r15 + Pc_n + 4], 0
    je .s1e
M2s_b2
M2s_b3
%endmacro
%macro M2s_ac 0
M2s_b2
%endmacro
%macro M2s_ad 0
M2s_b4
%endmacro
%macro M2s_ae 0
M2s_b3
%endmacro
%macro M2s_af 0
    mov eax, [r15 + Pc_w + 0]
    mov [rbp + 168], eax
    cmp dword [r15 + Pc_n], 0
    jne .s1b
M2s_b4
    cmovne rcx, [rbp + 128]
    mov [rbp + 152], rax
    mov [rbp + 160], rcx
.s1b:
    mov rax, [rbp + 96]
    mov [rbp + 176], rax
    mov rax, [rbp + 120]
M2s_a10
    mov eax, [r15 + Pc_w + 4]
    mov [rbp + 208], eax
    call .rows
    mov r15, [rbp + 48]
    inc qword [rbp + 72]
.s1e:
    mov eax, [r15 + Pc_n + 8]
    test eax, eax
    jz .r1e
    mov [rbp + 80], rax
M2s_a11
    mov rax, [rbp + 112]
    xor ecx, ecx
    cmp dword [r15 + Pc_n + 4], 0
M2s_a12
.r1:
    mov rax, [rbp + 152]
    cmp rax, [rbp + 112]
    jne .r1ca
    call .rowz
    jmp .r1cb
.r1ca:
    call .rowa
.r1cb:
    mov r15, [rbp + 48]
M2s_b5
    inc qword [rbp + 72]
    dec qword [rbp + 80]
%endmacro
%macro M2s_a10 0
M2s_b6
%endmacro
%macro M2s_a11 0
M2s_b5
%endmacro
%macro M2s_a12 0
M2s_b7
%endmacro
%macro M2s_a13 0
M2s_a14
M2s_a15
    vmovups ymm8, [rcx + 0]
    vmovups ymm9, [rcx + 32]
    vmovups ymm10, [rcx + 64]
    vmovups ymm11, [rcx + 96]
    vmovups ymm12, [rcx + 128]
    vmovups ymm13, [rcx + 160]
M2s_a16
    add r11, r10
    mov r12, [rdi + G_cc]
%endmacro
%macro M2s_a14 0
    jnz .r1
.r1e:
    cmp dword [r15 + Pc_n + 12], 0
    je .s2e
M2s_b5
    mov eax, [r15 + Pc_w + 8]
    mov [rbp + 168], eax
    mov edx, [r15 + Pc_n + 4]
    or edx, [r15 + Pc_n + 8]
    mov rax, [rbp + 112]
    xor ecx, ecx
    test edx, edx
M2s_b7
    mov rax, [rbp + 104]
    mov [rbp + 176], rax
    mov rax, [rbp + 128]
M2s_b6
    mov eax, [r15 + Pc_w + 12]
    mov [rbp + 208], eax
%endmacro
%macro M2s_a15 0
    call .rows
    inc qword [rbp + 72]
.s2e:
    mov rdi, [rbp + 8]
    mov rdx, [rdi + G_hx]
    mov rcx, [rdi + G_hv]
    mov r14, [rdi + G_hb]
    shl r14, 2
%endmacro
%macro M2s_a16 0
M2s_b8
%endmacro
%macro M2s_a17 0
M2s_b9
%endmacro
%macro M2s_a18 0
M2s_a19
M2s_bb
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a2f
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a32
%endmacro
%macro M2s_a19 0
M2s_a1a
M2s_a23
M2s_a29
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a1a 0
M2s_ba
    shr rsi, 1
    mov [rbp + 224], rsi
    mov rbx, [rdi + G_gp]
    shl rbx, 2
.hu:
M2s_bc
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 64]
%endmacro
%macro M2s_a1b 0
M2s_bc
M2s_be
M2s_a2f
M2s_a31
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 168]
%endmacro
%macro M2s_a1c 0
M2s_be
M2s_a2f
M2s_a31
M2s_a35
    vpermps ymm1, ymm3, [r8 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a1d 0
M2s_a1e
M2s_a26
M2s_a2a
%endmacro
%macro M2s_a1e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_bf
%endmacro
%macro M2s_a1f 0
M2s_a20
M2s_a27
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a20 0
M2s_bf
    vpermps ymm1, ymm3, [r8 + 128]
%endmacro
%macro M2s_a21 0
M2s_a22
M2s_a28
    vpermps ymm1, ymm3, [r8 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 224]
%endmacro
%macro M2s_a22 0
    vpermps ymm1, ymm3, [r8 + 64]
M2s_b10
%endmacro
%macro M2s_a23 0
M2s_b10
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_a24 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a25 0
M2s_b11
M2s_a26
%endmacro
%macro M2s_a26 0
M2s_b12
%endmacro
%macro M2s_a27 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a28 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_a29 0
    vpermps ymm1, ymm3, [r8 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 192]
%endmacro
%macro M2s_a2a 0
M2s_b13
%endmacro
%macro M2s_a2b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_bb
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a2c 0
M2s_b14
%endmacro
%macro M2s_a2d 0
M2s_b15
%endmacro
%macro M2s_a2e 0
M2s_b16
%endmacro
%macro M2s_a2f 0
M2s_a2e
M2s_b17
%endmacro
%macro M2s_a30 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
M2s_b17
M2s_a31
M2s_a36
M2s_a3b
M2s_a42
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a46
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a31 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a32
M2s_b19
%endmacro
%macro M2s_a32 0
M2s_b1a
%endmacro
%macro M2s_a33 0
M2s_b19
M2s_a36
M2s_b1b
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a34 0
M2s_b1c
%endmacro
%macro M2s_a35 0
M2s_b1d
%endmacro
%macro M2s_a36 0
M2s_a35
M2s_a39
%endmacro
%macro M2s_a37 0
M2s_a38
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 232]
M2s_b1b
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a51
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a38 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a39 0
M2s_b1f
%endmacro
%macro M2s_a3a 0
M2s_b1e
M2s_a56
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_a3b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a3c
M2s_b20
%endmacro
%macro M2s_a3c 0
M2s_b22
%endmacro
%macro M2s_a3d 0
M2s_b23
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 76]
M2s_b20
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 172]
%endmacro
%macro M2s_a3e 0
M2s_b24
M2s_b20
M2s_a41
    vpermps ymm1, ymm3, [r8 + 204]
%endmacro
%macro M2s_a3f 0
M2s_b25
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a42
%endmacro
%macro M2s_a40 0
M2s_b26
%endmacro
%macro M2s_a41 0
M2s_b27
%endmacro
%macro M2s_a42 0
M2s_a41
M2s_b28
%endmacro
%macro M2s_a43 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a44 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a45 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a46
M2s_b29
%endmacro
%macro M2s_a46 0
M2s_b2a
%endmacro
%macro M2s_a47 0
M2s_b29
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_a48 0
M2s_a47
M2s_a4d
%endmacro
%macro M2s_a49 0
M2s_b2b
%endmacro
%macro M2s_a4a 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a4c
M2s_a50
M2s_a5c
M2s_a5e
M2s_a66
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 192]
%endmacro
%macro M2s_a4b 0
M2s_b2c
%endmacro
%macro M2s_a4c 0
M2s_a4b
M2s_a4f
%endmacro
%macro M2s_a4d 0
    vpermps ymm1, ymm3, [r8 + 176]
M2s_a4e
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a4e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a4f 0
M2s_b2d
%endmacro
%macro M2s_a50 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a51
M2s_b2e
%endmacro
%macro M2s_a51 0
M2s_b2f
%endmacro
%macro M2s_a52 0
M2s_a51
M2s_a56
    vmovdqu ymm3, [rdx + 96]
M2s_a59
M2s_a6a
    vpermps ymm1, ymm3, [r8 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_a53 0
M2s_b30
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a54 0
M2s_b31
    vmovdqu ymm3, [rdx + 32]
M2s_a55
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a55 0
    vpermps ymm1, ymm3, [r8 + 84]
M2s_b2e
%endmacro
%macro M2s_a56 0
M2s_b32
%endmacro
%macro M2s_a57 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_a58 0
M2s_a57
M2s_a59
M2s_a6a
M2s_a6e
M2s_a74
%endmacro
%macro M2s_a59 0
    vpermps ymm1, ymm3, [r8 + 148]
M2s_a5a
M2s_a5d
    vpermps ymm1, ymm3, [r8 + 244]
M2s_a5e
M2s_a67
    vpermps ymm1, ymm3, [r8 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5a 0
M2s_b33
%endmacro
%macro M2s_a5b 0
M2s_b34
%endmacro
%macro M2s_a5c 0
M2s_a5b
M2s_b35
%endmacro
%macro M2s_a5d 0
M2s_b36
%endmacro
%macro M2s_a5e 0
M2s_b38
%endmacro
%macro M2s_a5f 0
M2s_b39
M2s_b3e
M2s_b40
%endmacro
%macro M2s_a60 0
M2s_b3b
M2s_a63
%endmacro
%macro M2s_a61 0
    vmovdqu ymm3, [rdx + 32]
M2s_b41
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a62 0
M2s_b41
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 248]
%endmacro
%macro M2s_a63 0
M2s_b3f
M2s_b42
%endmacro
%macro M2s_a64 0
    vpermps ymm1, ymm3, [r8 + 152]
M2s_a65
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a65 0
M2s_b43
%endmacro
%macro M2s_a66 0
M2s_a67
M2s_a69
%endmacro
%macro M2s_a67 0
M2s_b44
%endmacro
%macro M2s_a68 0
M2s_b45
%endmacro
%macro M2s_a69 0
M2s_b46
%endmacro
%macro M2s_a6a 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 248]
M2s_b47
M2s_b4a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_a6b 0
M2s_b47
M2s_b4a
M2s_b4d
%endmacro
%macro M2s_a6c 0
M2s_b48
M2s_b4b
M2s_b4e
%endmacro
%macro M2s_a6d 0
M2s_b49
M2s_b4c
M2s_a6e
M2s_a74
M2s_b4f
%endmacro
%macro M2s_a6e 0
    vpermps ymm1, ymm3, [r8 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6f
    vpermps ymm1, ymm3, [r8 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6f 0
M2s_b50
%endmacro
%macro M2s_a70 0
M2s_a6f
M2s_b51
%endmacro
%macro M2s_a71 0
M2s_a73
M2s_b52
%endmacro
%macro M2s_a72 0
M2s_a71
M2s_a76
M2s_a7c
%endmacro
%macro M2s_a73 0
M2s_b53
%endmacro
%macro M2s_a74 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 224]
%endmacro
%macro M2s_a75 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 224]
M2s_b4f
M2s_b56
    vpermps ymm1, ymm3, [r8 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a76 0
M2s_b55
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b56
    vpermps ymm1, ymm3, [r8 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_a77 0
M2s_a78
M2s_a7e
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 256]
M2s_a80
M2s_a84
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 288]
M2s_a86
%endmacro
%macro M2s_a78 0
M2s_b4f
M2s_b56
M2s_b58
%endmacro
%macro M2s_a79 0
M2s_b56
    vpermps ymm1, ymm3, [r8 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a7a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 256]
%endmacro
%macro M2s_a7a 0
M2s_a7b
M2s_a7f
%endmacro
%macro M2s_a7b 0
M2s_b59
%endmacro
%macro M2s_a7c 0
M2s_a7d
M2s_b5a
%endmacro
%macro M2s_a7d 0
M2s_b5b
%endmacro
%macro M2s_a7e 0
M2s_b5c
%endmacro
%macro M2s_a7f 0
M2s_b5d
%endmacro
%macro M2s_a80 0
M2s_b5e
%endmacro
%macro M2s_a81 0
M2s_b62
M2s_b66
M2s_b67
%endmacro
%macro M2s_a82 0
M2s_b63
M2s_b67
M2s_a85
%endmacro
%macro M2s_a83 0
M2s_b64
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b68
%endmacro
%macro M2s_a84 0
M2s_b68
    vpermps ymm1, ymm3, [r8 + 260]
%endmacro
%macro M2s_a85 0
M2s_b69
%endmacro
%macro M2s_a86 0
    lea r13, [r8 + r14]
M2s_b6a
M2s_b6d
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a87 0
M2s_b6a
M2s_b6d
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 160]
%endmacro
%macro M2s_a88 0
M2s_b6c
    vpermps ymm1, ymm3, [r13 + 96]
M2s_a89
    vpermps ymm1, ymm3, [r13 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
%endmacro
%macro M2s_a89 0
M2s_b6e
M2s_b6f
%endmacro
%macro M2s_a8a 0
M2s_a8b
    vmulps ymm5, ymm0, [rcx + 320]
M2s_a8f
M2s_a92
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2s_a95
M2s_a98
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_b70
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 76]
%endmacro
%macro M2s_a8b 0
    vpermps ymm1, ymm3, [r13 + 160]
M2s_a8c
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8c 0
M2s_b71
%endmacro
%macro M2s_a8d 0
    vpermps ymm1, ymm3, [r13 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 224]
%endmacro
%macro M2s_a8e 0
M2s_b72
%endmacro
%macro M2s_a8f 0
M2s_b73
%endmacro
%macro M2s_a90 0
M2s_b74
    vpermps ymm1, ymm3, [r13 + 100]
M2s_a91
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
%endmacro
%macro M2s_a91 0
M2s_b76
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
%endmacro
%macro M2s_a92 0
M2s_b77
%endmacro
%macro M2s_a93 0
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 228]
%endmacro
%macro M2s_a94 0
M2s_b78
%endmacro
%macro M2s_a95 0
M2s_b79
%endmacro
%macro M2s_a96 0
M2s_b7a
    vpermps ymm1, ymm3, [r13 + 104]
M2s_a97
    vpermps ymm1, ymm3, [r13 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
%endmacro
%macro M2s_a97 0
M2s_b7c
M2s_b7d
%endmacro
%macro M2s_a98 0
M2s_b7e
%endmacro
%macro M2s_a99 0
    vpermps ymm1, ymm3, [r13 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 232]
%endmacro
%macro M2s_a9a 0
M2s_b7f
%endmacro
%macro M2s_a9b 0
M2s_b70
M2s_b80
M2s_b84
%endmacro
%macro M2s_a9c 0
M2s_b81
    vpermps ymm1, ymm3, [r13 + 108]
M2s_a9e
    vpermps ymm1, ymm3, [r13 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
%endmacro
%macro M2s_a9d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 108]
M2s_a9e
M2s_aa1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_aa3
M2s_b85
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_aa6
M2s_aa7
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a9e 0
M2s_b83
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
%endmacro
%macro M2s_a9f 0
    vpermps ymm1, ymm3, [r13 + 172]
M2s_aa0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_aa0 0
M2s_b86
%endmacro
%macro M2s_aa1 0
    vpermps ymm1, ymm3, [r13 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 236]
%endmacro
%macro M2s_aa2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_aa3 0
M2s_b88
%endmacro
%macro M2s_aa4 0
    vpermps ymm1, ymm3, [r13 + 176]
M2s_b85
%endmacro
%macro M2s_aa5 0
M2s_b8a
%endmacro
%macro M2s_aa6 0
M2s_b8b
%endmacro
%macro M2s_aa7 0
M2s_b8c
%endmacro
%macro M2s_aa8 0
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_aa9
M2s_b8d
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_aac
M2s_b8e
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_b8f
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_aa9 0
M2s_b91
%endmacro
%macro M2s_aaa 0
    vpermps ymm1, ymm3, [r13 + 184]
M2s_b8d
%endmacro
%macro M2s_aab 0
M2s_b93
%endmacro
%macro M2s_aac 0
M2s_b94
%endmacro
%macro M2s_aad 0
    vpermps ymm1, ymm3, [r13 + 188]
M2s_b8e
%endmacro
%macro M2s_aae 0
M2s_b97
%endmacro
%macro M2s_aaf 0
M2s_b8f
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_ab0 0
M2s_b98
%endmacro
%macro M2s_ab1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 128]
M2s_ab2
    vmovdqu ymm3, [rdx + 352]
M2s_b9a
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ab2 0
M2s_b9b
%endmacro
%macro M2s_ab3 0
M2s_b9c
%endmacro
%macro M2s_ab4 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ab5 0
M2s_b9a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_ab7
M2s_abc
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 260]
M2s_abd
M2s_ac4
M2s_acc
M2s_b9d
    vpermps ymm1, ymm3, [r9 + 36]
%endmacro
%macro M2s_ab6 0
M2s_b9f
%endmacro
%macro M2s_ab7 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_ab8
M2s_aba
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 196]
%endmacro
%macro M2s_ab8 0
M2s_ba0
%endmacro
%macro M2s_ab9 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 132]
M2s_aba
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 196]
M2s_abc
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_aba 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_abb 0
M2s_ba2
%endmacro
%macro M2s_abc 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_abd 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_ba3
M2s_ac0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_abe 0
M2s_ba4
M2s_ac3
    vpermps ymm1, ymm3, [r9 + 128]
%endmacro
%macro M2s_abf 0
    vmovaps ymm4, ymm2
M2s_ac0
M2s_ac3
    vpermps ymm1, ymm3, [r9 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_ac0 0
M2s_ba5
%endmacro
%macro M2s_ac1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_ac2
M2s_ba7
%endmacro
%macro M2s_ac2 0
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_ac3
    vpermps ymm1, ymm3, [r9 + 128]
%endmacro
%macro M2s_ac3 0
M2s_ba8
%endmacro
%macro M2s_ac4 0
M2s_ac6
M2s_ba9
%endmacro
%macro M2s_ac5 0
M2s_ac4
M2s_baa
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_ac6 0
M2s_bac
%endmacro
%macro M2s_ac7 0
M2s_ac8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 192]
M2s_baa
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 44]
%endmacro
%macro M2s_ac8 0
M2s_bad
%endmacro
%macro M2s_ac9 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_aca 0
M2s_ba7
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_acb 0
M2s_ba9
M2s_acc
%endmacro
%macro M2s_acc 0
M2s_bae
%endmacro
%macro M2s_acd 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_baf
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ace 0
M2s_baf
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_acf 0
M2s_b9e
M2s_bb0
%endmacro
%macro M2s_ad0 0
M2s_bb0
M2s_ad1
M2s_bb1
M2s_ade
M2s_ae2
M2s_aed
    vpermps ymm1, ymm3, [r9 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ad1 0
M2s_bb2
%endmacro
%macro M2s_ad2 0
M2s_bb1
M2s_ade
M2s_ae2
M2s_aec
M2s_bb3
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 48]
%endmacro
%macro M2s_ad3 0
M2s_ad4
M2s_ad7
%endmacro
%macro M2s_ad4 0
M2s_bb6
%endmacro
%macro M2s_ad5 0
    vpermps ymm1, ymm3, [r9 + 164]
M2s_ad6
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ad6 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ad7 0
M2s_bb7
%endmacro
%macro M2s_ad8 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_bb8
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ad9 0
M2s_bb9
%endmacro
%macro M2s_ada 0
M2s_bb8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_adb 0
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 72]
M2s_adc
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 136]
%endmacro
%macro M2s_adc 0
M2s_bbb
%endmacro
%macro M2s_add 0
M2s_bbc
%endmacro
%macro M2s_ade 0
M2s_adf
M2s_bbd
%endmacro
%macro M2s_adf 0
M2s_bbe
%endmacro
%macro M2s_ae0 0
    vpermps ymm1, ymm3, [r9 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 200]
M2s_ae1
%endmacro
%macro M2s_ae1 0
M2s_bbf
%endmacro
%macro M2s_ae2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_bc0
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ae3 0
M2s_bc0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_ae4 0
M2s_bab
M2s_bc1
%endmacro
%macro M2s_ae5 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 12]
    vmovdqu ymm3, [rdx + 0]
M2s_bc1
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ae6 0
    vpermps ymm1, ymm3, [r9 + 44]
M2s_bc2
%endmacro
%macro M2s_ae7 0
M2s_bc2
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ae8 0
    vpermps ymm1, ymm3, [r9 + 76]
M2s_ae9
    vmovdqu ymm3, [rdx + 96]
M2s_aeb
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 236]
%endmacro
%macro M2s_ae9 0
M2s_bc3
%endmacro
%macro M2s_aea 0
M2s_bc4
%endmacro
%macro M2s_aeb 0
    vpermps ymm1, ymm3, [r9 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_aed
    vpermps ymm1, ymm3, [r9 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_aec 0
M2s_aed
M2s_bc5
%endmacro
%macro M2s_aed 0
M2s_bc6
%endmacro
%macro M2s_aee 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 236]
M2s_aef
M2s_af7
M2s_afc
M2s_a106
M2s_bc7
%endmacro
%macro M2s_aef 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_af0
M2s_bc8
%endmacro
%macro M2s_af0 0
M2s_bb4
M2s_bc9
%endmacro
%macro M2s_af1 0
M2s_bb5
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_bca
%endmacro
%macro M2s_af2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_af3
    vpermps ymm1, ymm3, [r9 + 240]
M2s_afc
M2s_a106
M2s_a10d
M2s_a116
    vpermps ymm1, ymm3, [r9 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_af3 0
M2s_bca
M2s_afa
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_af4 0
M2s_af6
M2s_af9
%endmacro
%macro M2s_af5 0
M2s_bcb
%endmacro
%macro M2s_af6 0
M2s_bc8
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_af7 0
M2s_af8
M2s_afb
%endmacro
%macro M2s_af8 0
M2s_bcc
%endmacro
%macro M2s_af9 0
    vpermps ymm1, ymm3, [r9 + 176]
M2s_afa
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_afa 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_afb 0
M2s_bcd
%endmacro
%macro M2s_afc 0
M2s_bce
M2s_a101
%endmacro
%macro M2s_afd 0
M2s_bd0
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_afe 0
M2s_bd1
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_bd3
%endmacro
%macro M2s_aff 0
M2s_bd2
M2s_bd3
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a100 0
M2s_a101
M2s_a106
%endmacro
%macro M2s_a101 0
M2s_bd5
%endmacro
%macro M2s_a102 0
M2s_bd6
M2s_a103
%endmacro
%macro M2s_a103 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_a104 0
M2s_bd7
%endmacro
%macro M2s_a105 0
M2s_bd8
%endmacro
%macro M2s_a106 0
M2s_a105
M2s_bd9
%endmacro
%macro M2s_a107 0
    vpermps ymm1, ymm3, [r9 + 180]
M2s_a108
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a108 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a109 0
M2s_bda
%endmacro
%macro M2s_a10a 0
M2s_a10b
M2s_a11f
M2s_a126
M2s_bdc
M2s_be1
%endmacro
%macro M2s_a10b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_be2
M2s_be3
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_a10c 0
M2s_be2
M2s_a11c
M2s_a122
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_bdc
M2s_be1
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_a10d 0
M2s_bc7
    vpermps ymm1, ymm3, [r9 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a10e 0
M2s_be6
%endmacro
%macro M2s_a10f 0
M2s_a10e
M2s_bea
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_a110 0
M2s_be8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 88]
M2s_bea
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 184]
%endmacro
%macro M2s_a111 0
M2s_bec
    vpermps ymm1, ymm3, [r9 + 152]
M2s_a115
M2s_bed
%endmacro
%macro M2s_a112 0
M2s_bee
%endmacro
%macro M2s_a113 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_beb
    vpermps ymm1, ymm3, [r9 + 184]
%endmacro
%macro M2s_a114 0
    vpermps ymm1, ymm3, [r9 + 152]
M2s_a115
    vmovdqu ymm3, [rdx + 160]
M2s_a119
M2s_a11c
M2s_a122
M2s_a128
M2s_a12e
M2s_bf0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 68]
%endmacro
%macro M2s_a115 0
M2s_bf3
%endmacro
%macro M2s_a116 0
M2s_bf4
%endmacro
%macro M2s_a117 0
M2s_a116
M2s_a119
%endmacro
%macro M2s_a118 0
M2s_bf5
%endmacro
%macro M2s_a119 0
M2s_bf6
%endmacro
%macro M2s_a11a 0
M2s_bf7
%endmacro
%macro M2s_a11b 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 248]
M2s_be3
M2s_bf8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_a11c 0
M2s_be3
M2s_bf8
M2s_bfb
%endmacro
%macro M2s_a11d 0
M2s_be4
M2s_bf9
M2s_bfc
%endmacro
%macro M2s_a11e 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 28]
M2s_bf8
M2s_bfb
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 188]
%endmacro
%macro M2s_a11f 0
M2s_bf9
    vmovdqu ymm3, [rdx + 96]
M2s_bfe
%endmacro
%macro M2s_a120 0
M2s_bfa
    vpermps ymm1, ymm3, [r9 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
M2s_a121
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a121 0
M2s_bfe
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a122 0
M2s_a123
M2s_bff
%endmacro
%macro M2s_a123 0
M2s_b100
%endmacro
%macro M2s_a124 0
M2s_b101
%endmacro
%macro M2s_a125 0
M2s_b102
%endmacro
%macro M2s_a126 0
M2s_b103
%endmacro
%macro M2s_a127 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 224]
%endmacro
%macro M2s_a128 0
M2s_be5
M2s_be0
M2s_b104
%endmacro
%macro M2s_a129 0
M2s_bdd
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 128]
M2s_b104
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 192]
%endmacro
%macro M2s_a12a 0
M2s_bdf
    vpermps ymm1, ymm3, [r9 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a12b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a12b 0
    vmovdqu ymm3, [rdx + 96]
M2s_b106
%endmacro
%macro M2s_a12c 0
M2s_b106
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a12d 0
M2s_b107
%endmacro
%macro M2s_a12e 0
M2s_a12d
M2s_a131
%endmacro
%macro M2s_a12f 0
    vpermps ymm1, ymm3, [r9 + 192]
M2s_a130
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a130 0
M2s_b108
%endmacro
%macro M2s_a131 0
M2s_b109
%endmacro
%macro M2s_a132 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a133 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 256]
%endmacro
%macro M2s_a134 0
M2s_bf0
M2s_b10a
M2s_b10d
%endmacro
%macro M2s_a135 0
M2s_bf2
M2s_b10c
M2s_b10e
%endmacro
%macro M2s_a136 0
M2s_b10c
    vpermps ymm1, ymm3, [r9 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a137
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 288]
M2s_a139
    vpermps ymm1, ymm3, [r13 + 160]
M2s_b71
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 320]
M2s_b73
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 196]
%endmacro
%macro M2s_a137 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 196]
M2s_a138
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 260]
%endmacro
%macro M2s_a138 0
M2s_b10f
%endmacro
%macro M2s_a139 0
    lea r13, [r9 + r14]
M2s_b6a
M2s_b6d
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a13a 0
    vfmadd231ps ymm7, ymm0, [rcx + 352]
M2s_b79
M2s_b7e
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_b70
M2s_b80
M2s_b84
M2s_b86
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_b87
M2s_b89
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a13b 0
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_b8b
M2s_b8c
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_b91
M2s_b93
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_b95
M2s_b96
    vpermps ymm1, ymm3, [r13 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a13c 0
    vfmadd231ps ymm7, ymm0, [rcx + 544]
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_b98
M2s_b9b
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 192]
M2s_b9f
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_ba1
    vpermps ymm1, ymm3, [r13 + 100]
%endmacro
%macro M2s_a13d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a13e
M2s_b113
M2s_a14b
    vmovaps ymm15, ymm4
M2s_bc
%endmacro
%macro M2s_a13e 0
    vfmadd231ps ymm7, ymm0, [rcx + 608]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
    vmovaps ymm6, ymm2
%endmacro
%macro M2s_a13f 0
M2s_a141
M2s_b114
    vmovups [r11 + 0], ymm0
M2s_a145
    cmp qword [rbp + 40], 0
    jne .hf
    cmp rsi, [rbp + 224]
%endmacro
%macro M2s_a140 0
M2s_a13f
M2s_a149
    add r9, rbx
M2s_b116
    vpermps ymm1, ymm3, [r8 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_a141 0
M2s_b118
%endmacro
%macro M2s_a142 0
    vshufps ymm7, ymm6, ymm7, 0xdd
    vmovaps ymm6, ymm2
    vaddps ymm0, ymm4, ymm5
    vpermpd ymm0, ymm0, 0xd8
%endmacro
%macro M2s_a143 0
M2s_a144
M2s_b11
M2s_b12
M2s_b13
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b14
M2s_b15
M2s_b11a
    vpermps ymm1, ymm3, [r8 + 164]
%endmacro
%macro M2s_a144 0
    vmovaps ymm6, ymm2
M2s_b113
M2s_b115
M2s_bd
    vpermps ymm1, ymm3, [r8 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a145 0
M2s_b11c
%endmacro
%macro M2s_a146 0
M2s_b11d
%endmacro
%macro M2s_a147 0
M2s_b11e
M2s_a14a
%endmacro
%macro M2s_a148 0
M2s_a147
    add r8, rbx
M2s_b117
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a149 0
    jne .hf
    vbroadcastss ymm14, xmm4
.hf:
M2s_a14a
    add r8, rbx
%endmacro
%macro M2s_a14a 0
M2s_b121
%endmacro
%macro M2s_a14b 0
M2s_b122
%endmacro
%macro M2s_a14c 0
    vaddps ymm0, ymm4, ymm5
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r10 + 128], ymm0
    vaddps ymm0, ymm6, ymm7
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r11 + 128], ymm0
M2s_b11c
M2s_b121
M2s_a14f
M2s_a151
    vmovaps ymm15, [c_epsf]
    vmovaps ymm14, [rdi + G_lsn]
%endmacro
%macro M2s_a14d 0
M2s_b124
    vmovaps ymm14, [rdi + G_lsn]
    vmovaps ymm13, [rdi + G_lan]
%endmacro
%macro M2s_a14e 0
M2s_b125
    vmovaps ymm13, [rdi + G_lan]
    vmovaps ymm12, [rdi + G_lta]
%endmacro
%macro M2s_a14f 0
M2s_b126
M2s_b127
    mov [rbp + 232], rax
    mov rcx, [rdi + G_wo]
M2s_a150
    cmp rcx, rdx
    cmova rcx, rdx
%endmacro
%macro M2s_a150 0
M2s_b128
%endmacro
%macro M2s_a151 0
M2s_b129
M2s_a152
%endmacro
%macro M2s_a152 0
M2s_b12a
%endmacro
%macro M2s_a153 0
M2s_b12b
.itl:
    vsubps ymm0, ymm15, [rax + 96]
    vrsqrtps ymm1, ymm0
    vfmadd213ps ymm1, ymm14, ymm13
%endmacro
%macro M2s_a154 0
M2s_b12c
M2s_b12d
%endmacro
%macro M2s_a155 0
    vmovaps ymm13, [rdi + G_lan]
    vmovaps ymm12, [rdi + G_lta]
.itl:
M2s_b12d
    jz .i1l0e
%endmacro
%macro M2s_a156 0
M2s_b132
M2s_b12f
M2s_a16b
%endmacro
%macro M2s_a157 0
M2s_b133
    vmovups ymm10, [c_ieq]
.i1l0:
M2s_a15e
M2s_a16b
    vmovups ymm14, [c_xlo]
%endmacro
%macro M2s_a158 0
    vsubps ymm0, ymm15, [rax + 96]
    vrsqrtps ymm1, ymm0
    vfmadd213ps ymm1, ymm14, ymm13
M2s_b134
    dec rcx
%endmacro
%macro M2s_a159 0
    dec rcx
M2s_b12e
    vmovups ymm0, [rax]
%endmacro
%macro M2s_a15a 0
M2s_b135
%endmacro
%macro M2s_a15b 0
M2s_b136
%endmacro
%macro M2s_a15c 0
    vmovups ymm14, [c_xlo]
    vmovups ymm13, [rdi+(G_lrg+0)]
    vmovups ymm12, [c_eq]
    vmovups ymm11, [rdi+(G_lom+0)]
%endmacro
%macro M2s_a15d 0
    vmovups ymm13, [rdi+(G_lrg+0)]
    vmovups ymm12, [c_eq]
    vmovups ymm11, [rdi+(G_lom+0)]
    vmovups ymm10, [c_ieq]
%endmacro
%macro M2s_a15e 0
    vmovups ymm0, [rax]
    vmovups ymm1, [rdx+192]
    vmovups ymm2, [rax+128]
M2s_a15f
M2s_a162
    vfmadd213ps ymm4, ymm12, ymm11
M2s_a168
%endmacro
%macro M2s_a15f 0
M2s_b137
%endmacro
%macro M2s_a160 0
    vandps ymm4, ymm0, ymm15
    vfmadd231ps ymm1, ymm4, ymm13
M2s_a161
M2s_b13b
    vandnps ymm4, ymm0, ymm3
    vmulps ymm6, ymm1, ymm9
%endmacro
%macro M2s_a161 0
M2s_b13a
M2s_b13c
%endmacro
%macro M2s_a162 0
    vrcpps ymm9, ymm6
    vcmpps ymm0, ymm7, ymm14, 30
    vrcpps ymm2, ymm7
M2s_b13b
M2s_b140
    vfmadd213ps ymm5, ymm12, ymm11
%endmacro
%macro M2s_a163 0
M2s_b13e
M2s_a165
%endmacro
%macro M2s_a164 0
M2s_b13f
    vmovaps [r9+352], ymm0
    vandnps ymm4, ymm0, ymm3
    vmulps ymm6, ymm1, ymm9
M2s_a165
    vmovaps [r9+32], ymm5
%endmacro
%macro M2s_a165 0
M2s_b141
M2s_a166
%endmacro
%macro M2s_a166 0
M2s_b142
%endmacro
%macro M2s_a167 0
    vfmadd213ps ymm4, ymm12, ymm11
M2s_a168
    add r9, 576
    sub rcx, 2
    cmp rcx, 2
%endmacro
%macro M2s_a168 0
M2s_b143
%endmacro
%macro M2s_a169 0
    vmovaps [r9+320], ymm4
    add rax, 256
    add rdx, 448
    add r9, 576
%endmacro
%macro M2s_a16a 0
M2s_b144
%endmacro
%macro M2s_a16b 0
M2s_b130
.i1l0r:
    test rcx, rcx
    jz .i1l0e
    vmovups ymm15, [c_absm]
%endmacro
%macro M2s_a16c 0
    jz .i1l0e
M2s_b136
    vmovups ymm11, [rdi+(G_lom+0)]
    vmovups ymm10, [c_ieq]
.i1l0s:
M2s_a170
    add rdx, 224
M2s_a178
.i1l1:
    vmovups ymm0, [rax+32]
    vmovups ymm1, [rdx+192]
    vmovups ymm2, [rax+160]
M2s_b137
M2s_b14c
    vmulps ymm6, ymm1, ymm9
    vaddps ymm1, ymm5, ymm4
    vmovaps [r9+96], ymm7
%endmacro
%macro M2s_a16d 0
M2s_b146
    vsubps ymm7, ymm5, ymm3
    vcmpps ymm8, ymm6, ymm14, 30
M2s_a17b
%endmacro
%macro M2s_a16e 0
M2s_b147
    vcmpps ymm8, ymm6, ymm14, 30
M2s_a17b
    vfmadd213ps ymm4, ymm12, ymm11
%endmacro
%macro M2s_a16f 0
M2s_b148
M2s_a17b
    vfmadd213ps ymm4, ymm12, ymm11
    vmovaps [r9+128], ymm5
%endmacro
%macro M2s_a170 0
    vmovups ymm0, [rax]
M2s_a171
M2s_b152
    vaddps ymm7, ymm2, ymm6
M2s_a174
    vmovaps [r9+32], ymm9
    add rax, 128
%endmacro
%macro M2s_a171 0
M2s_b153
%endmacro
%macro M2s_a172 0
    vandps ymm2, ymm0, ymm15
    vfmadd231ps ymm1, ymm2, ymm13
    vsubps ymm3, ymm2, ymm1
M2s_b152
    vaddps ymm7, ymm2, ymm6
%endmacro
%macro M2s_a173 0
M2s_b154
    vmovaps [r9+64], ymm4
    vandnps ymm6, ymm4, ymm1
    vaddps ymm7, ymm2, ymm6
    vmulps ymm8, ymm1, ymm5
%endmacro
%macro M2s_a174 0
M2s_b155
%endmacro
%macro M2s_a175 0
    vmovaps [r9], ymm7
    vblendvps ymm9, ymm10, ymm8, ymm4
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+32], ymm9
%endmacro
%macro M2s_a176 0
    vblendvps ymm9, ymm10, ymm8, ymm4
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+32], ymm9
    add rax, 128
%endmacro
%macro M2s_a177 0
M2s_b156
%endmacro
%macro M2s_a178 0
    add r9, 288
    dec rcx
    jnz .i1l0s
.i1l0e:
M2s_b135
    cmp rcx, 2
    jb .i1l1r
M2s_a179
    vmovups ymm11, [rdi+(G_lom+32)]
    vmovups ymm10, [c_ieq]
%endmacro
%macro M2s_a179 0
M2s_b158
%endmacro
%macro M2s_a17a 0
M2s_b14a
    vsubps ymm6, ymm4, ymm1
    vsubps ymm7, ymm5, ymm3
    vcmpps ymm8, ymm6, ymm14, 30
M2s_a17b
M2s_b159
    add rdx, 448
%endmacro
%macro M2s_a17b 0
M2s_b14c
M2s_b15b
%endmacro
%macro M2s_a17c 0
M2s_b150
M2s_b15c
M2s_b142
M2s_b15a
%endmacro
%macro M2s_a17d 0
M2s_b151
M2s_b15d
    vblendvps ymm4, ymm10, ymm9, ymm0
    vfmadd213ps ymm5, ymm12, ymm11
M2s_b159
    add rdx, 448
    add r9, 576
%endmacro
%macro M2s_a17e 0
M2s_b15b
M2s_b159
M2s_b161
%endmacro
%macro M2s_a17f 0
M2s_b15e
M2s_b160
M2s_b144
M2s_a182
    vmovups ymm12, [c_eq]
M2s_a184
M2s_b153
M2s_a186
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+128], ymm9
M2s_b156
M2s_a187
M2s_b165
    vfmadd231ps ymm1, ymm4, ymm13
%endmacro
%macro M2s_a180 0
M2s_b15a
    add r9, 576
    sub rcx, 2
M2s_b162
M2s_b166
M2s_b13a
    vcmpps ymm8, ymm6, ymm14, 30
    vrcpps ymm9, ymm6
%endmacro
%macro M2s_a181 0
    vmovaps [r9+416], ymm4
M2s_b144
M2s_b162
M2s_b166
M2s_b13a
    vcmpps ymm8, ymm6, ymm14, 30
    vrcpps ymm9, ymm6
    vcmpps ymm0, ymm7, ymm14, 30
%endmacro
%macro M2s_a182 0
M2s_b167
%endmacro
%macro M2s_a183 0
M2s_b168
M2s_b158
%endmacro
%macro M2s_a184 0
M2s_b169
%endmacro
%macro M2s_a185 0
    vmovups ymm0, [rax+32]
M2s_b153
M2s_b163
%endmacro
%macro M2s_a186 0
M2s_b16b
%endmacro
%macro M2s_a187 0
    jnz .i1l1s
.i1l1e:
M2s_b135
    cmp rcx, 2
    jb .i1l2r
M2s_a188
M2s_b16d
%endmacro
%macro M2s_a188 0
M2s_b16e
%endmacro
%macro M2s_a189 0
    vmovups ymm0, [rax+64]
M2s_b165
M2s_b139
    vsubps ymm7, ymm5, ymm3
    vcmpps ymm8, ymm6, ymm14, 30
M2s_b170
    add rax, 256
    add rdx, 448
%endmacro
%macro M2s_a18a 0
M2s_b173
%endmacro
%macro M2s_a18b 0
M2s_b170
M2s_b144
M2s_a193
    vmovups ymm12, [c_eq]
M2s_a194
M2s_b153
M2s_a196
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+224], ymm9
M2s_b156
    jnz .i1l2s
.i1l2e:
M2s_b135
M2s_b181
%endmacro
%macro M2s_a18c 0
    vcmpps ymm0, ymm7, ymm14, 30
M2s_a18d
    vmovaps [r9+512], ymm4
M2s_b144
M2s_b17d
M2s_b135
M2s_b181
    vmovups ymm13, [c_q8o3]
%endmacro
%macro M2s_a18d 0
M2s_b175
M2s_b17b
M2s_b184
%endmacro
%macro M2s_a18e 0
M2s_b182
M2s_b156
M2s_b180
M2s_a198
%endmacro
%macro M2s_a18f 0
    vmovaps [r9+256], ymm8
    vandnps ymm6, ymm8, ymm1
M2s_a190
    add r9, 576
    sub rcx, 2
M2s_b17d
M2s_b135
M2s_b185
%endmacro
%macro M2s_a190 0
M2s_b178
M2s_b142
M2s_b172
%endmacro
%macro M2s_a191 0
M2s_b179
M2s_b184
M2s_b183
%endmacro
%macro M2s_a192 0
M2s_b17a
M2s_b171
M2s_b161
%endmacro
%macro M2s_a193 0
M2s_b186
%endmacro
%macro M2s_a194 0
M2s_b187
%endmacro
%macro M2s_a195 0
    vmovups ymm0, [rax+64]
M2s_b153
M2s_b17e
%endmacro
%macro M2s_a196 0
M2s_b189
%endmacro
%macro M2s_a197 0
M2s_b185
M2s_b18a
    vblendvps ymm2, ymm5, ymm6, ymm3
    vblendvps ymm5, ymm7, ymm8, ymm3
M2s_b18d
    vmulps ymm2, ymm1, ymm3
%endmacro
%macro M2s_a198 0
M2s_b192
%endmacro
%macro M2s_a199 0
    vmovups ymm13, [c_q8o3]
    vmovups ymm12, [c_q8o2]
.i2l2:
M2s_b18a
M2s_b195
    vmovaps [rdx+128], ymm9
M2s_b198
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+512]
%endmacro
%macro M2s_a19a 0
M2s_b193
M2s_b199
    vmulps ymm8, ymm4, [r9+512]
    vandps ymm6, ymm3, [r9+544]
%endmacro
%macro M2s_a19b 0
M2s_b194
M2s_b19a
    vandps ymm6, ymm3, [r9+544]
    vmovaps [rdx+352], ymm6
%endmacro
%macro M2s_a19c 0
M2s_b18a
M2s_b195
    vmovaps [rdx+128], ymm9
M2s_a1b1
%endmacro
%macro M2s_a19d 0
M2s_b19b
%endmacro
%macro M2s_a19e 0
M2s_b19c
M2s_b1a0
%endmacro
%macro M2s_a19f 0
M2s_b19d
M2s_b1a1
%endmacro
%macro M2s_a1a0 0
M2s_b19e
M2s_b1a2
%endmacro
%macro M2s_a1a1 0
M2s_b19f
M2s_b1a3
%endmacro
%macro M2s_a1a2 0
M2s_b1a0
M2s_a1a3
%endmacro
%macro M2s_a1a3 0
M2s_b1a4
%endmacro
%macro M2s_a1a4 0
M2s_b18d
M2s_b1a5
%endmacro
%macro M2s_a1a5 0
M2s_a1a6
M2s_a1ad
M2s_a1b0
M2s_b197
%endmacro
%macro M2s_a1a6 0
M2s_b18e
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm1, ymm13
M2s_b1a5
    vfmadd213ps ymm0, ymm1, [c_q8o0]
    vpermps ymm7, ymm4, [c_to+64]
%endmacro
%macro M2s_a1a7 0
M2s_b18f
    vfmadd231ps ymm0, ymm1, ymm13
    vmulps ymm2, ymm1, ymm3
M2s_a1a9
M2s_a1af
M2s_b196
    vfmadd213ps ymm5, ymm6, ymm14
    vmovaps [rdx+160], ymm11
%endmacro
%macro M2s_a1a8 0
M2s_b191
M2s_b1ab
    vmulps ymm4, ymm10, ymm2
    vmovaps ymm0, ymm12
%endmacro
%macro M2s_a1a9 0
M2s_b1a6
    vpslld ymm8, ymm5, 4
M2s_b1ac
%endmacro
%macro M2s_a1aa 0
M2s_b1a7
M2s_b1ac
    vorps ymm10, ymm11, ymm3
%endmacro
%macro M2s_a1ab 0
M2s_b1ad
%endmacro
%macro M2s_a1ac 0
M2s_b1ae
M2s_b1b0
%endmacro
%macro M2s_a1ad 0
M2s_b1af
M2s_b1b1
%endmacro
%macro M2s_a1ae 0
M2s_b1b2
%endmacro
%macro M2s_a1af 0
    vorps ymm10, ymm11, ymm3
    vmulps ymm11, ymm3, [r9+224]
    vblendvps ymm3, ymm7, ymm9, ymm6
    vmovups ymm7, [rax+192]
%endmacro
%macro M2s_a1b0 0
M2s_b1b3
%endmacro
%macro M2s_a1b1 0
M2s_b198
M2s_b1b4
    vmovaps [rdx+384], ymm8
%endmacro
%macro M2s_a1b2 0
M2s_b19a
M2s_b1b5
    add rdx, 448
%endmacro
%macro M2s_a1b3 0
M2s_b1b7
%endmacro
%macro M2s_a1b4 0
M2s_a1b3
M2s_b1b4
M2s_b1bb
%endmacro
%macro M2s_a1b5 0
M2s_b1b8
M2s_b1bc
%endmacro
%macro M2s_a1b6 0
M2s_b1b9
    vfmadd213ps ymm0, ymm5, [c_q8o0]
    vfmadd231ps ymm4, ymm9, ymm0
M2s_b1b4
M2s_b1bb
    sub rcx, 2
    cmp rcx, 2
%endmacro
%macro M2s_a1b7 0
M2s_b1b5
    add rdx, 448
    add r9, 576
    sub rcx, 2
M2s_a1ba
M2s_a1c2
    vandps ymm7, ymm6, [r9+256]
    vmovaps [rdx+128], ymm7
    vmovaps [rdx+160], ymm4
M2s_b156
    jnz .i2l2s
.i2l2e:
M2s_b135
M2s_b1c2
%endmacro
%macro M2s_a1b8 0
M2s_b1b6
M2s_b1be
    mov rcx, [rbp + 240]
M2s_b1c2
    vmovups ymm13, [c_q8o3]
%endmacro
%macro M2s_a1b9 0
M2s_b1bb
M2s_b1bf
M2s_b1c2
    vmovups ymm13, [c_q8o3]
    vmovups ymm12, [c_q8o2]
%endmacro
%macro M2s_a1ba 0
    cmp rcx, 2
    jae .i2l2
.i2l2r:
    test rcx, rcx
    jz .i2l2e
M2s_b192
    vmovups ymm11, [c_q8o1]
.i2l2s:
M2s_b19b
M2s_b1c4
M2s_b1c8
    vmulps ymm3, ymm8, ymm10
    vmovaps ymm0, ymm12
%endmacro
%macro M2s_a1bb 0
M2s_b1c0
    jb .i2l0r
M2s_b192
M2s_b1cc
    vpslld ymm3, ymm1, 5
%endmacro
%macro M2s_a1bc 0
M2s_b1c4
M2s_a1be
    vmulps ymm2, ymm1, ymm3
%endmacro
%macro M2s_a1bd 0
M2s_b1ce
%endmacro
%macro M2s_a1be 0
M2s_b1c8
M2s_b1cf
%endmacro
%macro M2s_a1bf 0
    vmulps ymm3, ymm8, ymm10
M2s_b1d0
%endmacro
%macro M2s_a1c0 0
M2s_b1d0
    vorps ymm6, ymm9, ymm3
%endmacro
%macro M2s_a1c1 0
M2s_b1d1
%endmacro
%macro M2s_a1c2 0
M2s_a1c1
M2s_b1d2
%endmacro
%macro M2s_a1c3 0
M2s_b1d3
%endmacro
%macro M2s_a1c4 0
M2s_b1d4
%endmacro
%macro M2s_a1c5 0
    vfmadd213ps ymm0, ymm1, ymm11
M2s_b1d2
    vandps ymm7, ymm6, [r9+256]
    vmovaps [rdx+128], ymm7
    vmovaps [rdx+160], ymm4
%endmacro
%macro M2s_a1c6 0
M2s_b1ca
    vmovups ymm12, [c_q8o2]
.i2l0:
M2s_a1ca
M2s_b1a3
    vpslld ymm0, ymm2, 23
    vmovups ymm9, [rax]
    vblendvps ymm2, ymm5, ymm6, ymm3
    vblendvps ymm5, ymm7, ymm8, ymm3
    vpsubd ymm6, ymm11, ymm0
    vmovups ymm7, [r9+288]
M2s_b18e
M2s_b1a9
%endmacro
%macro M2s_a1c7 0
M2s_b1d5
M2s_b1a8
    vpermps ymm10, ymm4, [c_to]
%endmacro
%macro M2s_a1c8 0
M2s_a1c7
M2s_b1ad
    vpslld ymm0, ymm4, 23
    vpermps ymm4, ymm10, [c_rxo]
    vorps ymm10, ymm11, ymm3
M2s_a1cc
    vpsubd ymm6, ymm4, ymm0
    vmovaps [rdx], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
    vfmadd213ps ymm5, ymm6, ymm14
    vmovaps [rdx+32], ymm11
M2s_b1b7
M2s_b1db
%endmacro
%macro M2s_a1c9 0
M2s_b1d6
    vpermps ymm11, ymm9, [c_rxo]
    vpslld ymm0, ymm2, 23
M2s_a1cb
M2s_a1ce
    vandps ymm6, ymm3, [r9+352]
    vmovaps [rdx+224], ymm6
    vmovaps [rdx+256], ymm8
%endmacro
%macro M2s_a1ca 0
M2s_b1cd
M2s_b19f
%endmacro
%macro M2s_a1cb 0
M2s_b1d8
M2s_b191
M2s_b1a6
    vpslld ymm8, ymm5, 4
    vpermps ymm10, ymm4, [c_to]
M2s_b1ad
M2s_b1df
    vblendvps ymm3, ymm7, ymm9, ymm6
    vmovups ymm7, [rax+128]
%endmacro
%macro M2s_a1cc 0
M2s_b1e1
%endmacro
%macro M2s_a1cd 0
    vmovups ymm7, [rax+128]
M2s_a1ce
M2s_a1cf
M2s_a1d3
M2s_b1d3
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
    vmulps ymm4, ymm3, [r9+32]
%endmacro
%macro M2s_a1ce 0
    vandps ymm9, ymm10, [r9+64]
M2s_b1da
M2s_b1ba
    vfmadd231ps ymm4, ymm9, ymm0
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+320]
%endmacro
%macro M2s_a1cf 0
    vandps ymm6, ymm3, [r9+352]
    vmovaps [rdx+224], ymm6
    vmovaps [rdx+256], ymm8
M2s_b144
    cmp rcx, 2
%endmacro
%macro M2s_a1d0 0
M2s_b1e2
M2s_a1d5
    jnz .i2l0s
.i2l0e:
M2s_b135
M2s_b1ea
%endmacro
%macro M2s_a1d1 0
M2s_b1e6
    add r9, 576
    sub rcx, 2
    cmp rcx, 2
M2s_b1e3
    vfmadd213ps ymm0, ymm1, [c_q8o0]
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
M2s_b1e8
M2s_b1ec
%endmacro
%macro M2s_a1d2 0
M2s_b1e7
M2s_b1eb
M2s_b1ea
    vmovups ymm13, [c_q8o3]
    vmovups ymm12, [c_q8o2]
%endmacro
%macro M2s_a1d3 0
    jae .i2l0
.i2l0r:
    test rcx, rcx
    jz .i2l0e
M2s_b192
    vmovups ymm11, [c_q8o1]
.i2l0s:
M2s_b1cd
M2s_b19f
M2s_b1ce
    vpslld ymm9, ymm2, 23
    vblendvps ymm2, ymm5, ymm6, ymm3
    vmovups ymm5, [rax]
M2s_b1c8
    vmulps ymm3, ymm8, ymm10
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm1, ymm13
%endmacro
%macro M2s_a1d4 0
M2s_b1ee
    vmovaps ymm0, ymm12
M2s_b1d1
    vfmadd213ps ymm0, ymm1, [c_q8o0]
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
%endmacro
%macro M2s_a1d5 0
    vmulps ymm4, ymm3, [r9+32]
    vandps ymm7, ymm6, [r9+64]
    vmovaps [rdx], ymm7
    vmovaps [rdx+32], ymm4
M2s_b156
%endmacro
%macro M2s_a1d6 0
M2s_b1f2
    add rdx, 224
    add r9, 288
    dec rcx
M2s_b1e9
    mov r9, r10
    mov rcx, [rbp + 240]
    cmp rcx, 2
M2s_a1d7
M2s_b1a7
M2s_b1de
M2s_b1b1
    vmulps ymm11, ymm3, [r9+128]
    vblendvps ymm3, ymm7, ymm9, ymm6
%endmacro
%macro M2s_a1d7 0
M2s_b1ec
    vmovups ymm12, [c_q8o2]
.i2l1:
M2s_a1d9
M2s_b1a3
    vpslld ymm0, ymm2, 23
    vmovups ymm9, [rax+32]
    vblendvps ymm2, ymm5, ymm6, ymm3
    vblendvps ymm5, ymm7, ymm8, ymm3
    vpsubd ymm6, ymm11, ymm0
    vmovups ymm7, [r9+384]
M2s_b18e
M2s_b1a9
%endmacro
%macro M2s_a1d8 0
M2s_b1f4
    vpermps ymm10, ymm9, [c_w8o]
M2s_b1f8
    vandps ymm6, ymm3, [r9+448]
    vmovaps [rdx+288], ymm6
%endmacro
%macro M2s_a1d9 0
    vmovups ymm0, [r9+96]
M2s_b19c
    vpermps ymm5, ymm2, [c_to]
    vpermps ymm6, ymm2, [c_to+32]
    vpermps ymm7, ymm2, [c_to+64]
%endmacro
%macro M2s_a1da 0
M2s_b1f5
M2s_b1f8
    vandps ymm6, ymm3, [r9+448]
    vmovaps [rdx+288], ymm6
    vmovaps [rdx+320], ymm8
%endmacro
%macro M2s_a1db 0
M2s_b1f7
M2s_b191
M2s_b1a6
M2s_b1dd
    vpermps ymm9, ymm4, [c_to+96]
M2s_b1b1
    vmulps ymm11, ymm3, [r9+128]
    vblendvps ymm3, ymm7, ymm9, ymm6
    vmovups ymm7, [rax+160]
%endmacro
%macro M2s_a1dc 0
M2s_b1fb
%endmacro
%macro M2s_a1dd 0
    vmovups ymm7, [rax+160]
M2s_a1de
M2s_a1df
M2s_a1e3
M2s_b1d3
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
    vmulps ymm4, ymm3, [r9+128]
%endmacro
%macro M2s_a1de 0
    vandps ymm9, ymm10, [r9+160]
    vpsubd ymm6, ymm4, ymm0
    vmovaps [rdx+64], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
    vfmadd213ps ymm5, ymm6, ymm14
    vmovaps [rdx+96], ymm11
M2s_b1b7
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+416]
%endmacro
%macro M2s_a1df 0
    vandps ymm6, ymm3, [r9+448]
    vmovaps [rdx+288], ymm6
    vmovaps [rdx+320], ymm8
M2s_b144
    cmp rcx, 2
%endmacro
%macro M2s_a1e0 0
M2s_b1fc
M2s_b202
%endmacro
%macro M2s_a1e1 0
M2s_b200
    add r9, 576
    sub rcx, 2
    cmp rcx, 2
M2s_b1fd
    vfmadd213ps ymm0, ymm1, [c_q8o0]
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
M2s_b202
    add rax, [rbp + 248]
%endmacro
%macro M2s_a1e2 0
M2s_b201
M2s_b204
    add rax, rax
    add rax, [rbp + 248]
    imul rax, [rdi + G_wo]
%endmacro
%macro M2s_a1e3 0
    jae .i2l1
.i2l1r:
    test rcx, rcx
    jz .i2l1e
M2s_b192
    vmovups ymm11, [c_q8o1]
.i2l1s:
M2s_b1f9
M2s_b1ce
    vpslld ymm9, ymm2, 23
    vblendvps ymm2, ymm5, ymm6, ymm3
    vmovups ymm5, [rax+32]
M2s_b1c8
    vmulps ymm3, ymm8, ymm10
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm1, ymm13
%endmacro
%macro M2s_a1e4 0
M2s_b206
M2s_b1f0
%endmacro
%macro M2s_a1e5 0
    vmulps ymm4, ymm3, [r9+128]
    vandps ymm7, ymm6, [r9+160]
    vmovaps [rdx+64], ymm7
    vmovaps [rdx+96], ymm4
M2s_b156
%endmacro
%macro M2s_a1e6 0
M2s_b209
    add rdx, 224
    add r9, 288
    dec rcx
M2s_b203
    mov r8, [rdi + G_eb]
M2s_a1e8
M2s_b20a
M2s_b20c
    vmovdqu [rbp + 384], xmm3
M2s_a1ef
    mov rdi, r9
%endmacro
%macro M2s_a1e7 0
M2s_b20d
%endmacro
%macro M2s_a1e8 0
M2s_b20e
%endmacro
%macro M2s_a1e9 0
    add rax, [rbp + 248]
M2s_a1ea
.ed:
M2s_b20b
    vfmadd231ps ymm1, ymm15, [r8 + 160]
    vfmadd231ps ymm1, ymm13, [r8 + 32]
    vfmadd231ps ymm1, ymm14, [r8 + 96]
M2s_b214
%endmacro
%macro M2s_a1ea 0
M2s_b20f
M2s_b211
    vmovaps ymm6, [c_half]
    vmovdqu ymm7, [c_i64]
    vmovdqu ymm8, [c_i1023]
    vpxor ymm9, ymm9, ymm9
%endmacro
%macro M2s_a1eb 0
M2s_b213
    inc qword [rbp + 248]
    cmp qword [rbp + 248], 2
%endmacro
%macro M2s_a1ec 0
M2s_b210
M2s_b212
M2s_b20a
M2s_b214
    cmp qword [rbp + 248], 2
    jb .et
%endmacro
%macro M2s_a1ed 0
M2s_b216
%endmacro
%macro M2s_a1ee 0
M2s_b20c
    vmovdqu [rbp + 384], xmm3
M2s_a1f0
M2s_b217
%endmacro
%macro M2s_a1ef 0
M2s_b218
%endmacro
%macro M2s_a1f0 0
M2s_a1ef
M2s_b219
%endmacro
%macro M2s_a1f1 0
    rep movsw
    pop rdi
    pop rsi
M2s_b217
    add r8, 224
M2s_a1f3
M2s_a1f7
M2s_b134
    dec rcx
M2s_a1f8
%endmacro
%macro M2s_a1f2 0
M2s_b21b
%endmacro
%macro M2s_a1f3 0
M2s_b215
    jnz .ed
    inc qword [rbp + 248]
    cmp qword [rbp + 248], 2
    jb .et
    mov rdi, [rbp + 8]
    mov rax, [rdi + G_su]
    shl rax, 2
    imul rax, [rbp + 40]
    mov [rbp + 232], rax
    mov rcx, [rdi + G_wo]
    shr rcx, 1
M2s_b128
    shr rdx, 1
M2s_b220
M2s_b12a
%endmacro
%macro M2s_a1f4 0
M2s_b21d
M2s_b221
    mov rdx, r8
    mov rax, rsi
M2s_b21a
    add rdx, 224
    dec rcx
M2s_a1f8
M2s_a1fb
    vmovups ymm10, [c_ieq]
.i1c0:
    vmovups ymm0, [rax]
    vmovups ymm1, [rdx+192]
    vmovups ymm2, [rax+128]
M2s_b137
%endmacro
%macro M2s_a1f5 0
M2s_b21e
M2s_b222
M2s_b223
M2s_b139
    vsubps ymm7, ymm5, ymm3
    vcmpps ymm8, ymm6, ymm14, 30
    vrcpps ymm9, ymm6
%endmacro
%macro M2s_a1f6 0
M2s_b21f
M2s_b12a
M2s_b21a
M2s_b224
    vcmpps ymm8, ymm6, ymm14, 30
    vrcpps ymm9, ymm6
    vcmpps ymm0, ymm7, ymm14, 30
%endmacro
%macro M2s_a1f7 0
    vmovaps ymm15, [c_epsf]
    vmovaps ymm14, [rdi + G_csn]
    vmovaps ymm13, [rdi + G_can]
    vmovaps ymm12, [rdi + G_cta]
.itc:
    vsubps ymm0, ymm15, [rax + 96]
    vrsqrtps ymm1, ymm0
    vfmadd213ps ymm1, ymm14, ymm13
%endmacro
%macro M2s_a1f8 0
    jnz .itc
M2s_b135
    cmp rcx, 2
    jb .i1c0r
    vmovups ymm15, [c_absm]
%endmacro
%macro M2s_a1f9 0
M2s_b227
%endmacro
%macro M2s_a1fa 0
M2s_b225
M2s_b139
    vsubps ymm7, ymm5, ymm3
M2s_b13c
M2s_b13b
M2s_b140
    vfmadd213ps ymm5, ymm12, ymm11
    vfmadd213ps ymm4, ymm12, ymm11
M2s_b143
    add r9, 576
M2s_a1fe
M2s_b22c
.i1c0s:
    vmovups ymm0, [rax]
M2s_b153
M2s_b152
    vaddps ymm7, ymm2, ymm6
    vmulps ymm8, ymm1, ymm5
    vmovaps [r9], ymm7
%endmacro
%macro M2s_a1fb 0
M2s_b22f
%endmacro
%macro M2s_a1fc 0
M2s_b22c
%endmacro
%macro M2s_a1fd 0
M2s_b22a
    vaddps ymm7, ymm2, ymm6
M2s_b155
    vmovaps [r9+32], ymm9
    add rax, 128
    add rdx, 224
M2s_a202
.i1c1:
M2s_b149
%endmacro
%macro M2s_a1fe 0
    sub rcx, 2
    cmp rcx, 2
M2s_b234
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xlo]
%endmacro
%macro M2s_a1ff 0
M2s_b22b
M2s_b155
M2s_b232
M2s_b14b
    vandnps ymm6, ymm8, ymm1
    vaddps ymm7, ymm4, ymm6
%endmacro
%macro M2s_a200 0
M2s_b234
M2s_b227
M2s_b22e
M2s_b152
M2s_b231
M2s_b13a
M2s_b13c
M2s_b14f
    vandnps ymm4, ymm0, ymm3
%endmacro
%macro M2s_a201 0
M2s_b233
M2s_b14e
M2s_b15d
M2s_b15f
    vmovaps [r9+416], ymm4
    add rax, 256
    add rdx, 448
M2s_b235
    vmovups ymm11, [rdi+(G_com+32)]
    vmovups ymm10, [c_ieq]
.i1c1s:
%endmacro
%macro M2s_a202 0
    add r9, 288
    dec rcx
    jnz .i1c0s
.i1c0e:
M2s_b135
    cmp rcx, 2
    jb .i1c1r
M2s_a204
    vmovups ymm11, [rdi+(G_com+32)]
    vmovups ymm10, [c_ieq]
%endmacro
%macro M2s_a203 0
M2s_b238
M2s_a204
    vmovups ymm11, [rdi+(G_com+32)]
    vmovups ymm10, [c_ieq]
.i1c1:
    vmovups ymm0, [rax+32]
%endmacro
%macro M2s_a204 0
M2s_b239
%endmacro
%macro M2s_a205 0
M2s_b236
%endmacro
%macro M2s_a206 0
M2s_b237
%endmacro
%macro M2s_a207 0
    add r9, 576
M2s_b23a
    test rcx, rcx
    jz .i1c1e
    vmovups ymm15, [c_absm]
%endmacro
%macro M2s_a208 0
M2s_b235
    vmovups ymm11, [rdi+(G_com+32)]
    vmovups ymm10, [c_ieq]
.i1c1s:
M2s_b16a
    vsubps ymm3, ymm2, ymm1
M2s_b16b
M2s_b164
M2s_a20d
.i1c2:
M2s_b16f
    vsubps ymm6, ymm4, ymm1
M2s_b228
    vrcpps ymm2, ymm7
    vmovaps [r9+256], ymm8
    vandnps ymm6, ymm8, ymm1
%endmacro
%macro M2s_a209 0
M2s_a20a
M2s_b237
M2s_b23d
M2s_b174
    vaddps ymm7, ymm4, ymm6
%endmacro
%macro M2s_a20a 0
M2s_b23a
    test rcx, rcx
    jz .i1c1e
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xlo]
%endmacro
%macro M2s_a20b 0
M2s_b23b
M2s_b239
M2s_b23c
M2s_b13c
M2s_b176
    vandnps ymm4, ymm0, ymm3
%endmacro
%macro M2s_a20c 0
    add rdx, 224
M2s_b23e
M2s_b177
M2s_b17c
    vfmadd213ps ymm5, ymm12, ymm11
M2s_b171
    add rdx, 448
M2s_b240
    vmovups ymm11, [rdi+(G_com+64)]
    vmovups ymm10, [c_ieq]
.i1c2s:
%endmacro
%macro M2s_a20d 0
    add r9, 288
    dec rcx
    jnz .i1c1s
.i1c1e:
M2s_b135
    cmp rcx, 2
    jb .i1c2r
M2s_a20e
    vmovups ymm11, [rdi+(G_com+64)]
    vmovups ymm10, [c_ieq]
%endmacro
%macro M2s_a20e 0
M2s_b244
%endmacro
%macro M2s_a20f 0
M2s_b242
%endmacro
%macro M2s_a210 0
M2s_b240
    vmovups ymm11, [rdi+(G_com+64)]
    vmovups ymm10, [c_ieq]
.i1c2s:
M2s_b188
    vsubps ymm3, ymm2, ymm1
M2s_b189
M2s_b17f
M2s_a215
M2s_b135
    cmp rcx, 2
    jb .i2c2r
M2s_b192
.i2c2:
M2s_b19b
M2s_b1a3
    vpslld ymm0, ymm2, 23
M2s_b18b
    vmovups ymm7, [r9+480]
%endmacro
%macro M2s_a211 0
    sub rcx, 2
    cmp rcx, 2
M2s_b24a
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xlo]
%endmacro
%macro M2s_a212 0
M2s_b241
M2s_b246
M2s_b19c
M2s_b1a0
M2s_b1a4
M2s_b18b
    vmovups ymm7, [r9+480]
    vblendvps ymm8, ymm2, ymm5, ymm4
%endmacro
%macro M2s_a213 0
M2s_b24a
M2s_b244
M2s_b245
M2s_b19b
M2s_b1a3
M2s_b249
M2s_b18c
    vmulps ymm3, ymm8, ymm10
%endmacro
%macro M2s_a214 0
    add rdx, 224
M2s_b247
    mov rcx, [rbp + 240]
    cmp rcx, 2
M2s_a216
M2s_b1a7
M2s_b1de
M2s_b1b1
M2s_b1b3
    vpsubd ymm6, ymm4, ymm0
    vmovaps [rdx+128], ymm9
%endmacro
%macro M2s_a215 0
M2s_b24b
%endmacro
%macro M2s_a216 0
M2s_b248
    vpermps ymm10, ymm9, [c_w8o]
    vpermps ymm11, ymm9, [c_rxo]
M2s_b249
M2s_b18d
    vmulps ymm2, ymm1, ymm3
    vpmaxud ymm5, ymm7, ymm15
%endmacro
%macro M2s_a217 0
    cmp rcx, 2
    jae .i2c2
.i2c2r:
    test rcx, rcx
    jz .i2c2e
M2s_b192
    vmovups ymm11, [c_q8o1]
.i2c2s:
M2s_b19b
M2s_b1ce
M2s_b1c6
M2s_b1f0
    vmulps ymm4, ymm3, [r9+224]
M2s_b1c1
    add rdx, 224
M2s_b250
M2s_b135
    cmp rcx, 2
    jb .i2c0r
M2s_b192
.i2c0:
M2s_b1cd
%endmacro
%macro M2s_a218 0
M2s_b24e
M2s_b1d3
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
M2s_b24f
M2s_b192
M2s_b254
    vpslld ymm3, ymm1, 5
    vpslld ymm4, ymm1, 4
%endmacro
%macro M2s_a219 0
M2s_b253
M2s_b19d
M2s_b1a1
    vpermps ymm10, ymm9, [c_w8o]
    vpermps ymm11, ymm9, [c_rxo]
M2s_b1d7
M2s_b190
    vmulps ymm2, ymm1, ymm3
    vpmaxud ymm5, ymm7, ymm15
%endmacro
%macro M2s_a21a 0
M2s_b258
    jz .i2c0e
M2s_b192
    vmovups ymm11, [c_q8o1]
.i2c0s:
M2s_b1cd
M2s_b19f
M2s_b1ce
M2s_b1ee
    vmovaps ymm0, ymm12
%endmacro
%macro M2s_a21b 0
M2s_b25a
M2s_b1a1
    vpermps ymm10, ymm9, [c_w8o]
    vpermps ymm0, ymm9, [c_rxo]
M2s_b1ee
M2s_b1f0
M2s_b1f1
    jnz .i2c0s
.i2c0e:
M2s_b135
    cmp rcx, 2
    jb .i2c1r
M2s_b192
.i2c1:
M2s_b1fa
    vpslld ymm4, ymm1, 4
%endmacro
%macro M2s_a21c 0
M2s_b25b
M2s_b1ef
M2s_b1d3
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
M2s_b1f1
M2s_b25e
M2s_b19e
M2s_b1a2
    vpermps ymm11, ymm9, [c_rxo]
    vpslld ymm0, ymm2, 23
%endmacro
%macro M2s_a21d 0
M2s_b260
M2s_b19d
M2s_b1a1
    vpermps ymm10, ymm9, [c_w8o]
    vpermps ymm11, ymm9, [c_rxo]
M2s_b1f6
M2s_b190
    vmulps ymm2, ymm1, ymm3
    vpmaxud ymm5, ymm7, ymm15
%endmacro
%macro M2s_a21e 0
M2s_b267
    jz .i2c1e
M2s_b192
    vmovups ymm11, [c_q8o1]
.i2c1s:
M2s_b1f9
M2s_b1ce
M2s_b206
    vmovaps ymm0, ymm12
%endmacro
%macro M2s_a21f 0
M2s_b269
M2s_b1a1
M2s_b25d
M2s_b207
M2s_b1d3
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
M2s_b208
M2s_b271
M2s_b273
M2s_b275
    mov rbx, [rbp + 240]
    vmovdqu ymm2, [c_absm]
%endmacro
%macro M2s_a220 0
M2s_b26b
M2s_b207
M2s_b1d3
M2s_b26e
    add r9, 288
    dec rcx
M2s_b271
M2s_a222
M2s_a225
    vmulps ymm0, ymm5, [r8]
    vmovaps ymm6, [rdi + G_cmx + 64]
%endmacro
%macro M2s_a221 0
M2s_b26c
M2s_b1c8
M2s_b1cf
M2s_b1d4
M2s_b270
M2s_b278
    vmovaps ymm6, [rdi + G_cmx + 64]
    vfmadd231ps ymm0, ymm6, [r8 + 64]
%endmacro
%macro M2s_a222 0
M2s_b273
M2s_b275
    mov rbx, [rbp + 240]
    vmovdqu ymm2, [c_absm]
    vmovaps ymm3, [c_half]
    vmovdqu ymm13, [c_i512]
%endmacro
%macro M2s_a223 0
    vmovdqu ymm2, [c_absm]
M2s_b27a
%endmacro
%macro M2s_a224 0
M2s_b27a
M2s_b27b
    vfmadd231ps ymm1, ymm5, [r8 + 160]
    vfmadd231ps ymm1, ymm6, [r8 + 96]
M2s_b27e
    jb .cbp
    vmovdqu [r9], xmm9
    jmp .cbq
.cbp:
    vmovdqu [rbp + 384], xmm9
M2s_b218
M2s_b219
%endmacro
%macro M2s_a225 0
M2s_b280
%endmacro
%macro M2s_a226 0
    vmulps ymm0, ymm5, [r8]
M2s_b27b
M2s_b281
    jmp .crq
.crp:
%endmacro
%macro M2s_a227 0
M2s_b27b
M2s_b281
    jmp .crq
.crp:
    vmovdqu [rbp + 384], xmm11
%endmacro
%macro M2s_a228 0
M2s_b27c
M2s_b282
.crp:
    vmovdqu [rbp + 384], xmm11
    push rsi
%endmacro
%macro M2s_a229 0
M2s_b27d
M2s_b283
    vmovdqu [rbp + 384], xmm11
    push rsi
    push rdi
%endmacro
%macro M2s_a22a 0
M2s_b284
%endmacro
%macro M2s_a22b 0
M2s_b285
%endmacro
%macro M2s_a22c 0
M2s_b27e
M2s_b27f
    lea rsi, [rbp + 384]
M2s_b219
.cbq:
    cmp r10, 8
    jb .crp
%endmacro
%macro M2s_a22d 0
.cbq:
    cmp r10, 8
    jb .crp
M2s_a22e
M2s_b288
M2s_b290
    movzx ebx, byte [rdi + G_ms + 0 + rcx]
M2s_b291
    vpmovzxbd ymm0, xmm0
%endmacro
%macro M2s_a22e 0
M2s_b292
M2s_b218
M2s_a230
%endmacro
%macro M2s_a22f 0
M2s_b293
    lea rsi, [rbp + 384]
M2s_a230
M2s_b288
M2s_b290
    movzx ebx, byte [rdi + G_ms + 0 + rcx]
M2s_b295
%endmacro
%macro M2s_a230 0
M2s_b296
%endmacro
%macro M2s_a231 0
M2s_b294
M2s_b28e
    blsr rax, rax
    movzx ebx, byte [rdi + G_ms + 0 + rcx]
M2s_a234
%endmacro
%macro M2s_a232 0
M2s_b28a
    movzx ebx, byte [rdi + G_ms + 0 + rcx]
M2s_a234
M2s_b297
.fbe0:
%endmacro
%macro M2s_a233 0
M2s_b299
%endmacro
%macro M2s_a234 0
M2s_b295
M2s_b29a
    vmovups [r8 + r9*4 + 196608], ymm1
%endmacro
%macro M2s_a235 0
M2s_b291
M2s_b29b
%endmacro
%macro M2s_a236 0
    mov rdx, rcx
    shl rdx, 7
    add rdx, rsi
    vpermps ymm1, ymm0, [rdx]
    vmovups [r8 + r9*4], ymm1
    vpermps ymm1, ymm0, [rdx + 32]
M2s_b29a
    vmovups [r8 + r9*4 + 196608], ymm1
M2s_b297
.fbe0:
    mov rsi, [rdi + G_cl]
    mov r10, [rdi + G_su]
    mov rax, r10
    shl rax, 7
    add rsi, rax
    shl r10, 3
    imul r10, [rbp + 40]
    or r10d, 0x10000
    mov r8, [rdi + G_fs]
    mov r9, [rbp + 272]
    vpcmpeqb ymm1, ymm7, [rdi + G_ms + 64]
    vpcmpeqb ymm2, ymm7, [rdi + G_ms + 96]
M2s_b299
    xor rax, -1
    jz .fbe1
.fs1:
    tzcnt rcx, rax
    blsr rax, rax
    movzx ebx, byte [rdi + G_ms + 64 + rcx]
M2s_b291
M2s_b29b
M2s_b29c
    lea edx, [r10 + rcx*8]
    vmovd xmm1, edx
    vpbroadcastd ymm1, xmm1
%endmacro
%macro M2s_a237 0
M2s_b29a
M2s_b2a0
M2s_b29b
M2s_b29c
M2s_b2a4
    test rax, rax
%endmacro
%macro M2s_a238 0
    vpermps ymm1, ymm0, [rdx + 96]
M2s_b2a0
M2s_b29b
M2s_b29c
M2s_b2a4
M2s_b2a8
%endmacro
%macro M2s_a239 0
M2s_b297
M2s_b2a1
M2s_b29e
    vmovups [r8 + r9*4 + 131072], ymm1
    vpermps ymm1, ymm0, [rdx + 96]
    vmovups [r8 + r9*4 + 196608], ymm1
M2s_b2a4
M2s_b2a8
    mov rsi, [rdi + G_cc]
    mov r10, [rdi + G_su]
%endmacro
%macro M2s_a23a 0
M2s_b2a3
%endmacro
%macro M2s_a23b 0
M2s_a23a
M2s_b2a7
%endmacro
%macro M2s_a23c 0
M2s_b2a6
%endmacro
%macro M2s_a23d 0
M2s_b298
M2s_b2a2
M2s_b29f
M2s_b2a9
M2s_b2aa
%endmacro
%macro M2s_a23e 0
M2s_b2a2
M2s_b29f
M2s_b2a9
M2s_b2aa
M2s_b2ab
%endmacro
%macro M2s_a23f 0
M2s_b2a8
    mov rsi, [rdi + G_cc]
    mov r10, [rdi + G_su]
M2s_b2aa
M2s_b2ab
    movzx ebx, byte [rdi + G_ms + 128 + rcx]
M2s_b291
M2s_b29b
    vpermps ymm1, ymm0, [rdx]
    vmovups [r8 + r9*4], ymm1
    vpermps ymm1, ymm0, [rdx + 32]
    vmovups [r8 + r9*4 + 16384], ymm1
    vpermps ymm1, ymm0, [rdx + 64]
    vmovups [r8 + r9*4 + 32768], ymm1
    vpermps ymm1, ymm0, [rdx + 96]
    vmovups [r8 + r9*4 + 49152], ymm1
M2s_b2a3
    vpermd ymm1, ymm0, ymm1
M2s_b2ae
M2s_b2b0
%endmacro
%macro M2s_a240 0
    jnz .fs1
    mov [rbp + 272], r9
.fbe1:
M2s_b2ac
M2s_b2a5
M2s_b2ae
M2s_b2b0
    mov rdi, [rbp + 288]
%endmacro
%macro M2s_a241 0
M2s_b2ac
M2s_b2a5
M2s_b2ae
M2s_b2b1
    je .ble
    mov qword [rbp + 288], 0
.bl:
M2s_a246
    lea r12, [rbp + 448]
%endmacro
%macro M2s_a242 0
M2s_b2aa
M2s_b2ab
M2s_b2ad
M2s_b2af
M2s_b2b2
M2s_b2b3
    vpackssdw xmm4, xmm4, xmm4
%endmacro
%macro M2s_a243 0
M2s_b2ab
M2s_b2ad
M2s_b2af
M2s_b2b2
M2s_b2b3
M2s_b2b5
    mov rdi, [rbp + 8]
%endmacro
%macro M2s_a244 0
M2s_b2ad
M2s_b2af
M2s_b2b2
M2s_b2b3
M2s_b2b5
M2s_b2b7
    shr ecx, 16
%endmacro
%macro M2s_a245 0
M2s_b2b4
M2s_b2b6
M2s_b2b8
M2s_b2b9
M2s_b2be
M2s_b2c1
    mov rax, [rbp + 288]
%endmacro
%macro M2s_a246 0
M2s_b2bc
%endmacro
%macro M2s_a247 0
    mov rdi, [rbp + 288]
    shl rdi, 2
    add rdi, [r15 + G_fs]
    lea r12, [rbp + 448]
    call .t1l
M2s_b2b5
M2s_b2b7
    shr ecx, 16
M2s_b2b9
M2s_b2be
M2s_b2c1
    mov rax, [rbp + 288]
    add rax, [rbp + 304]
%endmacro
%macro M2s_a248 0
M2s_b2c2
M2s_b2ba
M2s_b2bd
M2s_b2c0
M2s_b2c4
%endmacro
%macro M2s_a249 0
M2s_b2c3
M2s_b2bb
M2s_b2bf
    mov qword [rbp + 304], 0
M2s_b2c4
    jae .bcn
    mov rdi, [rbp + 8]
    mov rsi, [rdi + G_fs]
%endmacro
%macro M2s_a24a 0
M2s_b2b6
M2s_b2b8
M2s_b2b9
M2s_b2be
M2s_b2c1
M2s_b2c5
%endmacro
%macro M2s_a24b 0
M2s_b2b8
M2s_b2b9
M2s_b2be
M2s_b2c1
M2s_b2c5
M2s_b2c9
%endmacro
%macro M2s_a24c 0
M2s_b2b9
M2s_b2be
M2s_b2c1
M2s_b2c5
M2s_b2c9
M2s_b2ca
%endmacro
%macro M2s_a24d 0
M2s_b2c6
    mov rsi, [rdi + G_fs]
    mov ecx, [rsi + rax*4 + 393216]
    mov edx, ecx
M2s_b2c9
M2s_b2ca
M2s_b2cd
M2s_b2d0
M2s_b2d3
    vbroadcastss ymm15, [rax + Rc_k + 12]
%endmacro
%macro M2s_a24e 0
M2s_b2c7
M2s_b2cb
M2s_b2ce
M2s_b2d1
M2s_b2d4
%endmacro
%macro M2s_a24f 0
M2s_b2c8
M2s_b2cc
M2s_b2cf
M2s_b2d2
    vbroadcastss ymm14, [rax + Rc_k + 8]
    vbroadcastss ymm15, [rax + Rc_k + 12]
    mov r8d, [rax + Rc_co]
    mov r9d, [rax + Rc_co + 4]
%endmacro
%macro M2s_a250 0
M2s_b2cb
M2s_b2ce
M2s_b2d1
M2s_b2d4
M2s_b2d5
%endmacro
%macro M2s_a251 0
M2s_b2c9
M2s_b2ca
M2s_b2cd
M2s_b2d0
M2s_b2d3
    vbroadcastss ymm15, [rax + Rc_k + 12]
    mov r8d, [rax + Rc_co]
M2s_b2d5
    mov rsi, [rdi + G_cr]
    lea rsi, [rsi + rdx*8]
%endmacro
%macro M2s_a252 0
M2s_b2ca
M2s_b2cd
M2s_b2d0
M2s_b2d3
M2s_b2d6
M2s_b2d8
M2s_a259
%endmacro
%macro M2s_a253 0
M2s_b2cd
M2s_b2d0
M2s_b2d3
M2s_b2d6
M2s_b2d8
M2s_b2d9
    mov rbx, [rdi + G_xb]
%endmacro
%macro M2s_a254 0
M2s_b2d7
    mov rdx, [rbp + 56]
    mov rsi, [rdi + G_cr]
    lea rsi, [rsi + rdx*8]
M2s_b2d8
M2s_b2d9
M2s_b2dc
M2s_b2e0
    ret
.pf32:
    prefetcht0 [rax + 1984]
%endmacro
%macro M2s_a255 0
M2s_b2d5
M2s_b2db
M2s_b2df
M2s_b2e3
    prefetcht0 [rax + 1984]
.pf31:
%endmacro
%macro M2s_a256 0
    mov r10d, [rax + Rc_co + 8]
    mov r11d, [rax + Rc_co + 12]
M2s_b2da
M2s_b2de
M2s_b2e2
M2s_b2e4
%endmacro
%macro M2s_a257 0
M2s_b2db
M2s_b2df
M2s_b2e3
M2s_b2e5
    prefetcht0 [rax + 1856]
.pf29:
%endmacro
%macro M2s_a258 0
M2s_b2d8
M2s_b2d9
M2s_b2dc
M2s_b2e0
    ret
M2s_b2e4
M2s_b2e9
.pf28:
%endmacro
%macro M2s_a259 0
M2s_b2eb
%endmacro
%macro M2s_a25a 0
    imul rax, [rdi + G_ys], 2
    add rax, rcx
    call [rbp + 328]
M2s_b2dc
M2s_b2e0
M2s_b2e8
M2s_b2ec
    prefetcht0 [rax + 1536]
.pf24:
%endmacro
%macro M2s_a25b 0
M2s_b2ef
%endmacro
%macro M2s_a25c 0
M2s_a25d
M2s_b2dd
M2s_b2e1
M2s_b2e5
M2s_b2ea
M2s_b2ee
M2s_b2f0
%endmacro
%macro M2s_a25d 0
    mov eax, [rbp + 72]
    and eax, 1
    imul rax, [rdi + G_sp]
    imul rax, rax, 12
%endmacro
%macro M2s_a25e 0
M2s_b2e6
.pf29:
M2s_b2ec
    prefetcht0 [rax + 1536]
.pf24:
M2s_b2f0
M2s_b2f3
M2s_b2f6
M2s_b2f7
.rowa:
%endmacro
%macro M2s_a25f 0
M2s_b2e7
M2s_b2ec
M2s_b2f1
M2s_b2f4
M2s_b2f8
%endmacro
%macro M2s_a260 0
M2s_b2e9
M2s_b2ed
M2s_b2f2
M2s_b2f5
    ret
.rowa:
    mov rax, [rbp + 72]
    cmp rax, [rbp + 344]
%endmacro
%macro M2s_a261 0
M2s_b2ec
M2s_b2f1
M2s_b2f4
M2s_b2f8
M2s_b2f9
%endmacro
%macro M2s_a262 0
M2s_b2ee
M2s_b2f0
M2s_b2f3
M2s_b2f6
M2s_b2f7
.rowa:
    mov rax, [rbp + 72]
M2s_b2f9
    mov rdi, [rbp + 8]
    mov rbx, [rdi + G_xb]
%endmacro
%macro M2s_a263 0
M2s_b2f0
M2s_b2f3
M2s_b2f6
M2s_b2f7
M2s_b2fa
    call .fr
.rqa:
M2s_a268
    shl r13, 3
    mov r9, [rdi + G_sg]
%endmacro
%macro M2s_a264 0
M2s_b2f3
M2s_b2f6
M2s_b2f7
M2s_b2fa
M2s_b2fc
    cmp rcx, [rbp + 352]
    jae .fu
%endmacro
%macro M2s_a265 0
M2s_b2fb
M2s_b2fd
M2s_b2ff
    jb .fq0r
%endmacro
%macro M2s_a266 0
M2s_b2f9
M2s_b2fe
M2s_b300
    lea r15, [r13 - 16]
%endmacro
%macro M2s_a267 0
    je .rqa
M2s_b2fc
    cmp rcx, [rbp + 352]
M2s_b2ff
    jb .fq0r
    lea r15, [r13 - 16]
    vmovups ymm15, [rbp+1152]
%endmacro
%macro M2s_a268 0
    mov rdi, [rbp + 8]
M2s_b2ef
    imul rax, rax, 12
    add rbx, rax
    mov r13, [rbp + 64]
%endmacro
%macro M2s_a269 0
M2s_b2fe
M2s_b300
M2s_b303
    vmovups ymm12, [rbp+1248]
%endmacro
%macro M2s_a26a 0
    add rbx, rax
    mov r13, [rbp + 64]
M2s_a26b
M2s_b301
M2s_a270
    jb .fq0r
M2s_a271
    vmovups ymm8, [c_xbcb]
    vmovups ymm7, [c_n64]
    vmovups ymm6, [c_absm]
%endmacro
%macro M2s_a26b 0
M2s_b305
%endmacro
%macro M2s_a26c 0
    mov [rbp + 336], r9
    mov rcx, [rbp + 72]
M2s_b301
M2s_a270
    jb .fq0r
M2s_b306
    vmulps ymm1, ymm15, [r9+rdx*8]
%endmacro
%macro M2s_a26d 0
    inc rcx
    mov [rbp + 344], rcx
    mov rax, rcx
    shl rax, 5
    add rax, [rdi + G_rd]
    vbroadcastss ymm0, [rax + Rc_k + 0]
    vmovaps [rbp + 1152], ymm0
    vbroadcastss ymm0, [rax + Rc_k + 4]
    vmovaps [rbp + 1184], ymm0
    vbroadcastss ymm0, [rax + Rc_k + 8]
    vmovaps [rbp + 1216], ymm0
    vbroadcastss ymm0, [rax + Rc_k + 12]
    vmovaps [rbp + 1248], ymm0
    mov r9d, [rax + Rc_co]
    mov r10d, [rax + Rc_co + 4]
    mov r11d, [rax + Rc_co + 8]
    mov r12d, [rax + Rc_co + 12]
    mov rdx, [rbp + 56]
    mov rsi, [rdi + G_cr]
    lea rsi, [rsi + rdx*8]
    lea r9, [rsi + r9*4]
    lea r10, [rsi + r10*4]
    lea r11, [rsi + r11*4]
    lea r12, [rsi + r12*4]
M2s_b2eb
M2s_b30b
%endmacro
%macro M2s_a26e 0
M2s_b300
M2s_b306
M2s_b30c
    vfmadd231ps ymm2, ymm14, [r10+rdx*8+32]
%endmacro
%macro M2s_a26f 0
M2s_b30e
%endmacro
%macro M2s_a270 0
M2s_b30f
%endmacro
%macro M2s_a271 0
M2s_b303
M2s_b310
%endmacro
%macro M2s_a272 0
M2s_a271
M2s_b311
    vfmadd231ps ymm2, ymm13, [r11+rdx*8+96]
    vfmadd231ps ymm0, ymm12, [r12+rdx*8+64]
    vfmadd231ps ymm2, ymm12, [r12+rdx*8+96]
%endmacro
%macro M2s_a273 0
M2s_a274
    vmovups ymm7, [c_n64]
    vmovups ymm6, [c_absm]
    vmovups ymm5, [c_xflr]
M2s_b312
    vfmadd231ps ymm0, ymm12, [r12+rdx*8+64]
    vfmadd231ps ymm2, ymm12, [r12+rdx*8+96]
    vmovaps ymm3, ymm4
%endmacro
%macro M2s_a274 0
M2s_b304
M2s_b319
%endmacro
%macro M2s_a275 0
    vmovups ymm14, [rbp+1184]
    vmovups ymm13, [rbp+1216]
M2s_b310
M2s_b311
M2s_b31a
    vfmadd231ps ymm3, ymm2, ymm11
%endmacro
%macro M2s_a276 0
    vmovups ymm11, [c_xrcr]
    vmovups ymm10, [c_xgcr]
    vmovups ymm9, [c_xgcb]
M2s_b311
M2s_b31a
M2s_b31c
%endmacro
%macro M2s_a277 0
M2s_b31d
%endmacro
%macro M2s_a278 0
M2s_b318
M2s_b31a
M2s_b31c
M2s_b31e
    vandps ymm3, ymm1, ymm6
    vxorps ymm0, ymm1, ymm3
%endmacro
%macro M2s_a279 0
M2s_b313
    vfmadd231ps ymm2, ymm12, [r12+rdx*8+96]
    vmovaps ymm3, ymm4
M2s_b31c
M2s_b31e
M2s_b322
%endmacro
%macro M2s_a27a 0
    vpmovzxwd ymm0, [rcx+rdx*2]
M2s_b30c
    vfmadd231ps ymm2, ymm14, [r10+rdx*8+32]
M2s_b324
    vfmadd213ps ymm2, ymm10, ymm4
    vfmadd231ps ymm4, ymm1, ymm8
M2s_a27d
%endmacro
%macro M2s_a27b 0
M2s_b30d
M2s_b324
    vfmadd213ps ymm2, ymm10, ymm4
    vfmadd231ps ymm4, ymm1, ymm8
M2s_a27d
M2s_b314
M2s_b321
    vmovaps [rsi+rdx*4+32], ymm2
M2s_b322
    vpmaddwd ymm1, ymm2, [c_k5]
    vpslld ymm3, ymm2, 23
%endmacro
%macro M2s_a27c 0
M2s_b324
M2s_b325
M2s_b327
    vpermd ymm1, ymm1, [c_p8]
    vpermd ymm2, ymm2, [c_c8]
%endmacro
%macro M2s_a27d 0
M2s_b329
%endmacro
%macro M2s_a27e 0
M2s_b32b
M2s_b32f
    vpermd ymm2, ymm2, [c_c8]
    vpaddd ymm3, ymm3, ymm2
    vorps ymm2, ymm3, ymm1
    vpsrld ymm3, ymm4, 20
%endmacro
%macro M2s_a27f 0
M2s_b32c
M2s_b330
M2s_b332
%endmacro
%macro M2s_a280 0
M2s_b32e
    vpslld ymm0, ymm2, 23
    vpsrld ymm2, ymm3, 14
M2s_a281
    vmulps ymm2, ymm2, ymm1
    vpsubd ymm1, ymm3, ymm0
%endmacro
%macro M2s_a281 0
M2s_b331
M2s_a282
%endmacro
%macro M2s_a282 0
M2s_b333
%endmacro
%macro M2s_a283 0
M2s_b334
%endmacro
%macro M2s_a284 0
    vpermps ymm1, ymm3, [c_w8e]
    vpermps ymm3, ymm3, [c_rxe]
    vmulps ymm2, ymm2, ymm1
    vpsubd ymm1, ymm3, ymm0
%endmacro
%macro M2s_a285 0
M2s_b335
%endmacro
%macro M2s_a286 0
M2s_b31b
    vmovaps [rdi+rdx*4+32], ymm3
    vfmadd213ps ymm2, ymm10, ymm4
    vfmadd231ps ymm4, ymm0, ymm8
M2s_b31e
M2s_b337
    vmovaps [r8+288], ymm4
    add r8, 576
%endmacro
%macro M2s_a287 0
M2s_b320
M2s_b31f
M2s_b338
    add rdx, 16
%endmacro
%macro M2s_a288 0
M2s_b321
M2s_b326
M2s_a28d
M2s_a291
    jbe .fq0
.fq0r:
    cmp rdx, r13
    jae .fq0e
M2s_b304
M2s_b319
    vmovups ymm7, [c_n64]
    vmovups ymm6, [c_absm]
    vmovups ymm5, [c_xflr]
.fq0s:
M2s_b323
%endmacro
%macro M2s_a289 0
M2s_b31c
M2s_b31e
M2s_b337
M2s_b33a
    vfmadd231ps ymm4, ymm1, ymm8
    vfmadd231ps ymm2, ymm1, ymm9
%endmacro
%macro M2s_a28a 0
M2s_b336
    vxorps ymm0, ymm1, ymm3
    vpmaxud ymm4, ymm3, ymm5
M2s_b339
M2s_b33c
%endmacro
%macro M2s_a28b 0
M2s_b31e
M2s_b337
M2s_b33a
    vfmadd231ps ymm4, ymm1, ymm8
M2s_b32a
    vandps ymm0, ymm3, ymm6
%endmacro
%macro M2s_a28c 0
M2s_b33b
    vmovaps [rdi+rdx*4], ymm0
M2s_b33c
M2s_b32c
    vpsrld ymm2, ymm3, 14
%endmacro
%macro M2s_a28d 0
    vpsrld ymm2, ymm4, 23
M2s_b327
M2s_b33e
    vpsubd ymm0, ymm1, ymm3
    vfmadd213ps ymm4, ymm0, [c_mone]
    vmovaps [r8+320], ymm2
%endmacro
%macro M2s_a28e 0
M2s_b327
M2s_b33e
    vpsubd ymm0, ymm1, ymm3
    vfmadd213ps ymm4, ymm0, [c_mone]
    vmovaps [r8+320], ymm2
    vmovaps [r8+288], ymm4
%endmacro
%macro M2s_a28f 0
M2s_b328
M2s_b33f
    vmovaps [r8+320], ymm2
M2s_b33a
M2s_b33d
M2s_b32d
M2s_b331
%endmacro
%macro M2s_a290 0
M2s_b33f
M2s_b340
M2s_b33c
M2s_b32c
M2s_b330
M2s_b332
    vpermps ymm3, ymm3, [c_rxe]
%endmacro
%macro M2s_a291 0
    vmovaps [r8+288], ymm4
    add r8, 576
    add rdx, 16
    cmp rdx, r15
%endmacro
%macro M2s_a292 0
M2s_a293
M2s_b341
M2s_a298
    cmp rdx, r15
    jbe .fp0
%endmacro
%macro M2s_a293 0
M2s_b344
%endmacro
%macro M2s_a294 0
    vfmadd213ps ymm4, ymm1, [c_mone]
    vmovaps [r8+32], ymm2
    vmovaps [r8], ymm4
M2s_b341
M2s_a298
    cmp rdx, r15
    jbe .fp0
.fp0r:
%endmacro
%macro M2s_a295 0
M2s_b345
M2s_b343
    jbe .fp0
.fp0r:
    cmp rdx, r13
%endmacro
%macro M2s_a296 0
M2s_b346
%endmacro
%macro M2s_a297 0
M2s_b349
%endmacro
%macro M2s_a298 0
M2s_b34a
%endmacro
%macro M2s_a299 0
    jbe .fp0
M2s_b34b
M2s_b34e
    vxorps ymm6, ymm0, ymm5
%endmacro
%macro M2s_a29a 0
M2s_b34b
M2s_b34e
    vxorps ymm6, ymm0, ymm5
    vpmaxud ymm7, ymm5, ymm14
%endmacro
%macro M2s_a29b 0
M2s_b34c
M2s_b34f
    vpmaxud ymm7, ymm5, ymm14
    vfmadd231ps ymm3, ymm1, [c_q8e3]
%endmacro
%macro M2s_a29c 0
M2s_b34d
M2s_b350
    vmovups ymm4, [rsi+rdx*4+32]
M2s_b351
    vmulps ymm8, ymm1, ymm2
%endmacro
%macro M2s_a29d 0
M2s_b353
%endmacro
%macro M2s_a29e 0
M2s_a29d
M2s_b354
%endmacro
%macro M2s_a29f 0
M2s_b355
%endmacro
%macro M2s_a2a0 0
M2s_b356
%endmacro
%macro M2s_a2a1 0
    vmovups ymm0, [rbx+rdx*4]
M2s_a2a2
M2s_b357
    vpermd ymm5, ymm4, [c_c8]
    vpsubd ymm4, ymm1, ymm7
    vfmadd213ps ymm3, ymm4, ymm12
%endmacro
%macro M2s_a2a2 0
M2s_b358
%endmacro
%macro M2s_a2a3 0
M2s_b359
%endmacro
%macro M2s_a2a4 0
M2s_b35a
%endmacro
%macro M2s_a2a5 0
M2s_b35b
%endmacro
%macro M2s_a2a6 0
M2s_b35c
%endmacro
%macro M2s_a2a7 0
M2s_b351
M2s_b35d
M2s_b360
%endmacro
%macro M2s_a2a8 0
M2s_b352
M2s_b35e
    vpsrld ymm11, ymm0, 14
    vpsrld ymm0, ymm0, 17
    vpermd ymm0, ymm0, [c_p8]
    vpermd ymm11, ymm11, [c_c8]
%endmacro
%macro M2s_a2a9 0
M2s_a2aa
M2s_a2b1
    vorps ymm10, ymm1, ymm6
M2s_b361
M2s_b363
M2s_b365
.fp1r:
    cmp rdx, r13
    jae .fp1e
%endmacro
%macro M2s_a2aa 0
    vpmaxud ymm7, ymm5, ymm14
    vfmadd231ps ymm3, ymm1, [c_q8e3]
M2s_b35d
M2s_b360
    vpermd ymm11, ymm11, [c_c8]
    vfmadd213ps ymm3, ymm1, [c_q8e0]
%endmacro
%macro M2s_a2ab 0
M2s_a2ac
M2s_a2b2
M2s_b361
M2s_b363
M2s_b365
.fp1r:
    cmp rdx, r13
    jae .fp1e
    vmovups ymm15, [c_absm]
%endmacro
%macro M2s_a2ac 0
M2s_b367
M2s_b35f
    vpermd ymm0, ymm0, [c_p8]
    vpermd ymm11, ymm11, [c_c8]
    vfmadd213ps ymm3, ymm1, [c_q8e0]
    vpaddd ymm1, ymm0, ymm11
%endmacro
%macro M2s_a2ad 0
M2s_b35d
M2s_b360
M2s_a2af
M2s_b362
M2s_b364
M2s_b366
    cmp rdx, r13
    jae .fp1e
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xflr]
%endmacro
%macro M2s_a2ae 0
M2s_b35e
    vpsrld ymm11, ymm0, 14
    vpsrld ymm0, ymm0, 17
    vpermd ymm0, ymm0, [c_p8]
M2s_b368
    vmovups ymm14, [c_xflr]
    vmovups ymm13, [c_k5]
%endmacro
%macro M2s_a2af 0
    vpermd ymm11, ymm11, [c_c8]
M2s_b369
%endmacro
%macro M2s_a2b0 0
M2s_b369
    vpsrld ymm3, ymm4, 20
%endmacro
%macro M2s_a2b1 0
    vpaddd ymm1, ymm0, ymm11
    vpermps ymm0, ymm10, [c_w8e]
    vpermps ymm11, ymm10, [c_rxe]
    vfmadd231ps ymm2, ymm8, ymm3
%endmacro
%macro M2s_a2b2 0
    vpermps ymm0, ymm10, [c_w8e]
    vpermps ymm11, ymm10, [c_rxe]
    vfmadd231ps ymm2, ymm8, ymm3
    vorps ymm10, ymm1, ymm6
%endmacro
%macro M2s_a2b3 0
M2s_b36a
%endmacro
%macro M2s_a2b4 0
M2s_b36b
%endmacro
%macro M2s_a2b5 0
M2s_b36c
%endmacro
%macro M2s_a2b6 0
M2s_b36d
%endmacro
%macro M2s_a2b7 0
M2s_b36e
    vmovups ymm2, [r8+32]
M2s_a2b9
M2s_a2bf
M2s_b370
M2s_a2c0
    jb .fp1s
.fp1e:
M2s_a2c1
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .fp2r
M2s_b35b
    vmovups ymm12, [c_mone]
.fp2:
M2s_a2c5
    vmovups ymm4, [r14+rdx*4+32]
    vandps ymm5, ymm0, ymm15
    vxorps ymm6, ymm0, ymm5
%endmacro
%macro M2s_a2b8 0
M2s_b36f
    vpmaxud ymm7, ymm5, ymm14
%endmacro
%macro M2s_a2b9 0
M2s_b372
    vpmaxud ymm6, ymm3, ymm14
M2s_a2ba
M2s_b373
    vpsrld ymm9, ymm10, 14
    vpsrld ymm10, ymm10, 17
    vpsubd ymm8, ymm8, ymm0
%endmacro
%macro M2s_a2ba 0
M2s_b375
%endmacro
%macro M2s_a2bb 0
    vpermps ymm8, ymm9, [c_rxe]
M2s_b376
%endmacro
%macro M2s_a2bc 0
M2s_b376
    vfmadd213ps ymm4, ymm1, [c_q8e0]
%endmacro
%macro M2s_a2bd 0
    vpsrld ymm9, ymm10, 14
M2s_a2be
    vfmadd213ps ymm6, ymm8, ymm12
    vfmadd213ps ymm4, ymm1, [c_q8e0]
    vpaddd ymm9, ymm0, ymm10
%endmacro
%macro M2s_a2be 0
    vpsrld ymm10, ymm10, 17
    vpsubd ymm8, ymm8, ymm0
    vpermd ymm0, ymm10, [c_p8]
    vpermd ymm10, ymm9, [c_c8]
%endmacro
%macro M2s_a2bf 0
M2s_b377
%endmacro
%macro M2s_a2c0 0
M2s_b378
%endmacro
%macro M2s_a2c1 0
    mov rdi, [rbp + 136]
    mov rcx, [rbp + 152]
M2s_a2c2
    imul rax, rax, 1
    add rcx, rax
%endmacro
%macro M2s_a2c2 0
    mov rax, [rbp + 144]
    imul rax, rax, 1
    add rdi, rax
    mov rax, [rbp + 160]
%endmacro
%macro M2s_a2c3 0
    imul rax, rax, 1
    add rdi, rax
    mov rax, [rbp + 160]
    imul rax, rax, 1
%endmacro
%macro M2s_a2c4 0
M2s_b379
%endmacro
%macro M2s_a2c5 0
M2s_b37a
%endmacro
%macro M2s_a2c6 0
    vpsrld ymm3, ymm4, 20
    vmovups ymm1, [r8+384]
    vmulps ymm6, ymm10, ymm0
    vpsubd ymm10, ymm11, ymm5
    vmovaps [rsi+rdx*4], ymm2
    vaddps ymm0, ymm2, [rcx+rdx*4]
    vpmaddwd ymm11, ymm8, ymm13
    vmovups ymm5, [r8+416]
M2s_b36a
    vmovaps [rdi+rdx*4], ymm0
    vmovups ymm3, [c_q8e2]
    vmovaps [r8+224], ymm6
M2s_b36b
    vmovaps [r8+192], ymm7
M2s_b36c
    vorps ymm2, ymm8, ymm9
    vfmadd231ps ymm3, ymm1, [c_q8e3]
    vmulps ymm0, ymm2, ymm10
    vmovaps [r8+480], ymm4
    vmovaps [r8+512], ymm0
    vfmadd213ps ymm3, ymm1, [c_q8e1]
    vfmadd213ps ymm3, ymm1, [c_q8e0]
    vfmadd231ps ymm5, ymm7, ymm3
    vmovaps [rsi+rdx*4+32], ymm5
M2s_b36d
    cmp rdx, r15
    jbe .fp2
.fp2r:
    cmp rdx, r13
    jae .fp2e
M2s_b353
    vmovups ymm11, [c_q8e3]
.fp2s:
    vmovups ymm0, [r14+rdx*4]
    vmovups ymm1, [r8+96]
    vmovups ymm2, [r8+128]
M2s_b372
    vpmaxud ymm6, ymm3, ymm14
M2s_b375
M2s_b373
%endmacro
%macro M2s_a2c7 0
M2s_b37c
M2s_b36d
M2s_b37f
    vfmadd213ps ymm4, ymm11, [c_q8e2]
    vxorps ymm5, ymm0, ymm3
M2s_b381
    vfmadd213ps ymm4, ymm1, [c_q8e1]
    vpsrld ymm9, ymm10, 14
%endmacro
%macro M2s_a2c8 0
M2s_b382
M2s_b378
    jb .fp2s
.fp2e:
M2s_a2ca
    mov r11, [rbp + 136]
    mov r10, [rbp + 152]
    mov rax, [rbp + 144]
    imul rax, rax, 3
    add r11, rax
    mov rax, [rbp + 160]
    imul rax, rax, 3
    add r10, rax
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .fp3r
M2s_b35b
M2s_b356
M2s_b386
M2s_b388
%endmacro
%macro M2s_a2c9 0
M2s_b383
    vmovups ymm10, [c_q8e2]
    vmovups ymm9, [c_q8e1]
M2s_b386
M2s_b388
    vminps ymm1, ymm2, [rsi+rdx*4+32]
%endmacro
%macro M2s_a2ca 0
M2s_b38a
%endmacro
%macro M2s_a2cb 0
M2s_b38d
%endmacro
%macro M2s_a2cc 0
M2s_b38e
%endmacro
%macro M2s_a2cd 0
    vminps ymm5, ymm1, [u_zero]
    vfmadd213ps ymm0, ymm3, ymm9
    vminps ymm1, ymm2, [rsi+rdx*4+32]
    vminps ymm2, ymm6, ymm5
    vmulps ymm6, ymm3, ymm4
    vaddps ymm5, ymm2, [r10+rdx*4]
    vfmadd213ps ymm0, ymm3, ymm8
    vmovaps [r11+rdx*4], ymm5
    vfmadd231ps ymm4, ymm6, ymm0
    vaddps ymm2, ymm4, [rcx+rdx*4+32]
    vminps ymm3, ymm4, [u_zero]
    vmovaps [rdi+rdx*4+32], ymm2
    vminps ymm5, ymm1, ymm3
    vaddps ymm6, ymm5, [r10+rdx*4+32]
    vmovaps [r11+rdx*4+32], ymm6
    add r8, 576
    add rdx, 16
    cmp rdx, r15
    jbe .fp3
.fp3r:
    cmp rdx, r13
    jae .fp3e
M2s_b353
M2s_b354
    vmovups ymm7, [c_c8]
    vmovups ymm6, [c_p8]
    vmovups ymm5, [c_w8e]
M2s_b392
M2s_b395
%endmacro
%macro M2s_a2ce 0
M2s_b38f
M2s_b392
M2s_b395
    vmovdqu ymm13, [c_k5]
%endmacro
%macro M2s_a2cf 0
M2s_b390
M2s_b393
M2s_b396
.rqs:
M2s_b398
%endmacro
%macro M2s_a2d0 0
M2s_b391
M2s_b394
M2s_b397
M2s_b398
    vmovaps ymm11, [c_q8e3]
%endmacro
%macro M2s_a2d1 0
M2s_b399
%endmacro
%macro M2s_a2d2 0
    vmovdqu ymm13, [c_k5]
M2s_b39a
%endmacro
%macro M2s_a2d3 0
M2s_b39a
    mov rax, [rbp + 144]
%endmacro
%macro M2s_a2d4 0
M2s_b39b
M2s_b39d
M2s_b39f
    lea rsi, [rbx + r12]
M2s_b3a1
%endmacro
%macro M2s_a2d5 0
M2s_b39c
M2s_b39e
M2s_b3a0
M2s_b3a1
    add rdi, rax
%endmacro
%macro M2s_a2d6 0
M2s_a2d7
M2s_a2d8
    vorps ymm5, ymm5, ymm0
    vmovups [rsi + rdx*4], ymm5
M2s_a2d9
    vfmadd231ps ymm0, ymm5, ymm7
    vmovups [r8 + rdx*4], ymm0
%endmacro
%macro M2s_a2d7 0
M2s_b3a2
%endmacro
%macro M2s_a2d8 0
M2s_b3a3
%endmacro
%macro M2s_a2d9 0
M2s_b3a5
%endmacro
%macro M2s_a2da 0
    mov r8, [rbp + 176]
    mov r9, [rbp + 192]
    mov rax, [rbp + 184]
    imul rax, rax, 1
    add r8, rax
    mov rax, [rbp + 200]
    imul rax, rax, 1
    add r9, rax
    xor edx, edx
.ls1:
M2s_b3a2
M2s_b3a3
    vorps ymm5, ymm5, ymm0
    vmovups [rsi + rdx*4], ymm5
M2s_b3a5
    vfmadd231ps ymm0, ymm5, ymm7
    vmovups [r8 + rdx*4], ymm0
    add rdx, 8
    cmp rdx, r13
    jb .ls1
    lea rsi, [rbx + r12*2]
M2s_b38a
M2s_b3a9
    mov r10, [rbp + 136]
    mov r11, [rbp + 152]
%endmacro
%macro M2s_a2db 0
    add r9, rax
    mov r10, [rbp + 136]
    mov r11, [rbp + 152]
    mov rax, [rbp + 144]
    imul rax, rax, 3
    add r10, rax
    mov rax, [rbp + 160]
    imul rax, rax, 3
    add r11, rax
    mov r14, [rbp + 176]
    mov r15, [rbp + 192]
    mov rax, [rbp + 184]
    imul rax, rax, 3
    add r14, rax
    mov rax, [rbp + 200]
    imul rax, rax, 3
    add r15, rax
    lea rax, [rbx + r12]
    xor edx, edx
.ls2:
M2s_b3a2
M2s_b3a3
    vorps ymm5, ymm5, ymm0
M2s_b3a5
    vfmadd231ps ymm0, ymm5, ymm7
M2s_b3af
M2s_b3b1
    add rdx, 8
    cmp rdx, r13
%endmacro
%macro M2s_a2dc 0
M2s_b3ab
    vpermps ymm5, ymm4, [c_w8e]
    vpermps ymm4, ymm4, [c_rxe]
    vmulps ymm3, ymm3, ymm5
M2s_b3a3
M2s_b3ae
M2s_b3b3
    jb .ls2
%endmacro
%macro M2s_a2dd 0
M2s_b3ac
M2s_b3b4
M2s_b3af
M2s_b3b1
    add rdx, 8
    cmp rdx, r13
    jb .ls2
    ret
%endmacro
%macro M2s_a2de 0
M2s_b3ad
M2s_b3b5
M2s_b3b0
M2s_b3b2
    cmp rdx, r13
    jb .ls2
    ret
.rowz:
%endmacro
%macro M2s_a2df 0
    jb .ls2
    ret
.rowz:
    mov rax, [rbp + 72]
    cmp rax, [rbp + 344]
    je .rqz
    call .fr
.rqz:
M2s_b302
M2s_b305
    cmp rcx, [rbp + 352]
    jae .zu
M2s_b307
M2s_b30e
    mov rdi, rax
    xor edx, edx
%endmacro
%macro M2s_a2e0 0
M2s_b3b6
M2s_b308
    add rcx, [rdi + G_sy]
M2s_b30b
M2s_b30e
    mov rdi, rax
    xor edx, edx
    mov r8, [rbp + 336]
%endmacro
%macro M2s_a2e1 0
M2s_b3b7
M2s_b309
M2s_b30b
M2s_b30e
M2s_b30f
%endmacro
%macro M2s_a2e2 0
M2s_b3b8
M2s_b30a
    add rax, rcx
    call [rbp + 328]
    mov eax, [rbp + 344]
M2s_b30e
M2s_b30f
    jb .zq0r
%endmacro
%macro M2s_a2e3 0
    jb .zq0r
M2s_b303
M2s_b310
M2s_b31d
.zq0:
M2s_b323
M2s_b329
M2s_b334
M2s_b315
M2s_b317
    vfmadd231ps ymm2, ymm13, [r11+rdx*8+96]
    vfmadd231ps ymm0, ymm12, [r12+rdx*8+64]
%endmacro
%macro M2s_a2e4 0
M2s_b3ba
M2s_b333
    vmulps ymm2, ymm2, ymm1
M2s_b315
M2s_b317
M2s_b31a
M2s_b31c
M2s_b31e
    vandps ymm3, ymm1, ymm6
    vxorps ymm0, ymm1, ymm3
    vpmaxud ymm4, ymm3, ymm5
%endmacro
%macro M2s_a2e5 0
    add rdx, 16
    cmp rdx, r15
    jbe .zq0
.zq0r:
    cmp rdx, r13
    jae .zq0e
M2s_b304
M2s_b319
    vmovups ymm7, [c_n64]
    vmovups ymm6, [c_absm]
    vmovups ymm5, [c_xflr]
.zq0s:
M2s_b323
M2s_b329
M2s_b334
M2s_b344
M2s_b3bd
.zq0e:
    jmp .zw
%endmacro
%macro M2s_a2e6 0
M2s_b3bb
M2s_b33d
M2s_b32d
M2s_b331
M2s_b333
    vmulps ymm2, ymm2, ymm1
M2s_b344
M2s_b3bd
.zq0e:
    jmp .zw
.zu:
%endmacro
%macro M2s_a2e7 0
M2s_b3bc
M2s_b329
M2s_b334
M2s_b344
M2s_b3bd
.zq0e:
    jmp .zw
.zu:
    xor edx, edx
%endmacro
%macro M2s_a2e8 0
.zu:
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .zp0r
    lea r15, [r13 - 16]
    vmovups ymm15, [c_absm]
.zp0:
M2s_b346
M2s_b349
M2s_b34a
    cmp rdx, r15
    jbe .zp0
.zp0r:
    cmp rdx, r13
    jae .zp0e
M2s_b353
    vmovups ymm11, [c_q8e3]
    vmovups ymm10, [c_q8e2]
    vmovups ymm9, [c_q8e1]
%endmacro
%macro M2s_a2e9 0
M2s_b3bf
M2s_b347
    vpermd ymm0, ymm14, [c_p8]
    vpsubd ymm13, ymm8, ymm2
    vfmadd213ps ymm7, ymm13, [c_mone]
M2s_b349
M2s_b34a
M2s_b3c1
M2s_b356
    vmovups ymm8, [c_q8e0]
%endmacro
%macro M2s_a2ea 0
M2s_b3c0
M2s_b348
M2s_b3c3
M2s_b3c2
    vmovups ymm10, [c_q8e2]
    vmovups ymm9, [c_q8e1]
    vmovups ymm8, [c_q8e0]
.zp0s:
%endmacro
%macro M2s_a2eb 0
.zp0s:
    vmovups ymm0, [rbx+rdx*4]
M2s_b358
M2s_b357
    vpermd ymm5, ymm4, [c_c8]
    vpsubd ymm4, ymm1, ymm7
    vfmadd213ps ymm3, ymm4, ymm12
M2s_b359
    jb .zp0s
.zp0e:
.zw:
M2s_b35a
    lea r14, [rbx + r12*2]
    mov rdi, [rbp + 136]
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .zp1r
M2s_b35b
    vmovups ymm12, [c_mone]
    vmovups ymm11, [c_q8e3]
.zp1:
    vmovups ymm0, [rsi+rdx*4]
M2s_b358
M2s_a2ed
    vpermps ymm9, ymm5, [c_rxe]
    vmovups ymm10, [r8]
    vmovups ymm0, [r8+32]
M2s_a2ee
    vpsubd ymm4, ymm9, ymm7
    vfmadd213ps ymm3, ymm4, ymm12
    vmovups ymm1, [rsi+rdx*4+32]
%endmacro
%macro M2s_a2ec 0
M2s_b3c5
M2s_b3c7
M2s_b3c9
    vmovups ymm5, [r8+320]
    vfmadd231ps ymm0, ymm4, ymm7
    vpsrld ymm1, ymm6, 14
    vpsrld ymm4, ymm6, 17
%endmacro
%macro M2s_a2ed 0
M2s_b3cb
%endmacro
%macro M2s_a2ee 0
M2s_b3cc
%endmacro
%macro M2s_a2ef 0
M2s_b3c7
M2s_b3c9
    vmovups ymm5, [r8+320]
M2s_b3cd
    cmp rdx, r13
    jae .zp1e
M2s_b353
.zp1s:
M2s_b35c
M2s_b3d1
%endmacro
%macro M2s_a2f0 0
M2s_b3d2
%endmacro
%macro M2s_a2f1 0
M2s_b3c8
M2s_b3ca
M2s_b3cd
M2s_b3cf
    vmovups ymm1, [r8]
    vmovups ymm2, [r8+32]
    vmovups ymm3, [c_q8e2]
M2s_b3d1
    vmulps ymm7, ymm1, ymm2
%endmacro
%macro M2s_a2f2 0
M2s_b3d3
%endmacro
%macro M2s_a2f3 0
M2s_b3d4
%endmacro
%macro M2s_a2f4 0
M2s_b3d6
    vfmadd213ps ymm10, ymm11, [c_q8e2]
M2s_b3ce
M2s_b3d0
    vmovups ymm2, [r8+32]
    vmovups ymm3, [c_q8e2]
M2s_a2f6
M2s_b3d7
%endmacro
%macro M2s_a2f5 0
M2s_b3d9
%endmacro
%macro M2s_a2f6 0
M2s_b3d1
M2s_b375
M2s_a2f8
%endmacro
%macro M2s_a2f7 0
M2s_a2f8
M2s_b3d7
    jb .zp1s
.zp1e:
    mov rdi, [rbp + 136]
    mov rax, [rbp + 144]
    imul rax, rax, 1
    add rdi, rax
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .zp2r
M2s_b35b
    vmovups ymm12, [c_mone]
    vmovups ymm11, [c_q8e3]
.zp2:
    vmovups ymm0, [r14+rdx*4]
M2s_b358
M2s_b3cb
    vpermps ymm9, ymm5, [c_rxe]
    vmovups ymm10, [r8+96]
    vmovups ymm0, [r8+128]
M2s_b3cc
    vpsubd ymm4, ymm9, ymm7
    vfmadd213ps ymm3, ymm4, ymm12
    vmovups ymm1, [r14+rdx*4+32]
M2s_b3d2
    vorps ymm5, ymm9, ymm2
    vmovaps [r8+192], ymm3
%endmacro
%macro M2s_a2f8 0
M2s_b3dc
%endmacro
%macro M2s_a2f9 0
M2s_b3dd
    vpsrld ymm9, ymm10, 17
    vpermd ymm10, ymm9, [c_p8]
    vpermd ymm9, ymm8, [c_c8]
    vpsubd ymm8, ymm4, ymm11
%endmacro
%macro M2s_a2fa 0
M2s_b3de
M2s_b3df
%endmacro
%macro M2s_a2fb 0
M2s_b3e0
%endmacro
%macro M2s_a2fc 0
    vfmadd213ps ymm6, ymm8, ymm12
    vfmadd213ps ymm3, ymm1, [c_q8e0]
    vpaddd ymm4, ymm10, ymm9
    vorps ymm11, ymm4, ymm5
%endmacro
%macro M2s_a2fd 0
M2s_b3e1
%endmacro
%macro M2s_a2fe 0
M2s_b3da
    vpermd ymm6, ymm1, [c_c8]
M2s_b3db
    vmovaps [r8+192], ymm3
    vmulps ymm6, ymm5, ymm8
    vfmadd213ps ymm7, ymm10, [c_q8e1]
    vandps ymm9, ymm1, ymm15
    vmovaps [r8+224], ymm6
M2s_b3d3
    vfmadd213ps ymm7, ymm10, [c_q8e0]
    vmovups ymm8, [r8+384]
    vpsubd ymm10, ymm5, ymm1
    vmovups ymm5, [r8+416]
M2s_b3d5
    vpermd ymm7, ymm4, [c_p8]
    vpermd ymm6, ymm1, [c_c8]
%endmacro
%macro M2s_a2ff 0
    vorps ymm5, ymm9, ymm2
M2s_b3e3
M2s_b3e5
M2s_b3d6
    vfmadd213ps ymm10, ymm11, [c_q8e2]
    vmovaps [rsi+rdx*4], ymm0
    vmovaps [rdi+rdx*4], ymm0
    vpaddd ymm4, ymm7, ymm6
    vorps ymm1, ymm4, ymm2
    vmovaps [r8+480], ymm3
    vmulps ymm0, ymm8, ymm5
    vmulps ymm7, ymm1, ymm9
    vfmadd213ps ymm10, ymm8, [c_q8e1]
    vmovaps [r8+512], ymm7
    vfmadd213ps ymm10, ymm8, [c_q8e0]
    vfmadd231ps ymm5, ymm0, ymm10
    vmovaps [rsi+rdx*4+32], ymm5
M2s_b3d9
    jbe .zp2
.zp2r:
    cmp rdx, r13
    jae .zp2e
M2s_b353
.zp2s:
M2s_b37a
M2s_b3d1
M2s_b375
    vpslld ymm11, ymm8, 23
%endmacro
%macro M2s_a300 0
M2s_b3e4
M2s_b3d4
M2s_b3e8
    vfmadd231ps ymm3, ymm1, [c_q8e3]
M2s_b375
    vpslld ymm11, ymm8, 23
    vpermps ymm0, ymm9, [c_w8e]
    vpermps ymm4, ymm9, [c_rxe]
%endmacro
%macro M2s_a301 0
M2s_b3e8
M2s_b3ec
M2s_b3de
M2s_b3df
    vpaddd ymm4, ymm10, ymm9
    vorps ymm11, ymm4, ymm5
    vmovaps [r8+192], ymm6
    vmulps ymm8, ymm11, ymm0
    vfmadd231ps ymm2, ymm7, ymm3
    vmovaps [r8+224], ymm8
    vmovaps [rsi+rdx*4], ymm2
M2s_b3e1
M2s_b3f1
    imul rax, rax, 2
%endmacro
%macro M2s_a302 0
M2s_b3ef
    add rdx, 8
    cmp rdx, r13
M2s_b3f1
    imul rax, rax, 2
    add rdi, rax
    mov r11, [rbp + 136]
    mov rax, [rbp + 144]
    imul rax, rax, 3
    add r11, rax
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .zp3r
M2s_b35b
M2s_b356
    vmovups ymm8, [c_q8e0]
    vmovups ymm7, [c_c8]
.zp3:
M2s_b38d
M2s_b38e
M2s_b3f6
    add r8, 576
%endmacro
%macro M2s_a303 0
M2s_b3f0
M2s_b3f3
    vfmadd231ps ymm5, ymm0, ymm11
    vminps ymm6, ymm2, [rsi+rdx*4]
M2s_b38e
M2s_b3f6
    add r8, 576
    add rdx, 16
%endmacro
%macro M2s_a304 0
    mov rax, [rbp + 144]
M2s_b3f4
    vfmadd231ps ymm1, ymm2, ymm5
M2s_b3f6
    add r8, 576
    add rdx, 16
    cmp rdx, r15
    jbe .zp3
.zp3r:
    cmp rdx, r13
    jae .zp3e
M2s_b353
    vmovups ymm11, [c_q8e3]
    vmovups ymm10, [c_q8e2]
    vmovups ymm9, [c_q8e1]
%endmacro
%macro M2s_a305 0
M2s_b3f5
M2s_b3f6
M2s_b3f7
M2s_b355
M2s_b389
%endmacro
%macro M2s_a306 0
M2s_b3f7
M2s_b355
M2s_b389
    vmovups ymm6, [c_p8]
    vmovups ymm5, [c_w8e]
.zp3s:
M2s_b399
    vmulps ymm2, ymm0, ymm1
    vfmadd231ps ymm1, ymm2, ymm3
    vmovaps [rdi+rdx*4], ymm1
M2s_b3fb
    ret
.t1l:
    vcvtps2pd ymm0, [rdi + 196608]
M2s_a30b
M2s_b3fc
M2s_b3fd
M2s_b405
%endmacro
%macro M2s_a307 0
M2s_b3f8
    vmovups ymm13, [c_k5]
M2s_b356
    vmovups ymm8, [c_q8e0]
    vmovups ymm7, [c_c8]
M2s_b3fa
M2s_b3ff
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [rax + ymm8*8 + u_rx - u_rx], ymm9
    vandpd ymm11, ymm5, [u_mant]
%endmacro
%macro M2s_a308 0
M2s_b3f9
M2s_b356
M2s_b407
M2s_b3fd
M2s_b405
    vandpd ymm11, ymm5, [u_mant]
    vorpd ymm11, ymm11, [u_oneb]
%endmacro
%macro M2s_a309 0
M2s_b408
M2s_b3fe
M2s_b409
M2s_b411
M2s_b416
    vmulpd ymm6, ymm6, ymm8
    vmulpd ymm6, ymm6, ymm10
%endmacro
%macro M2s_a30a 0
M2s_b3fa
M2s_b3ff
M2s_b40c
    vmulpd ymm6, ymm6, ymm10
    vmulpd ymm12, ymm11, ymm11
%endmacro
%macro M2s_a30b 0
M2s_b418
%endmacro
%macro M2s_a30c 0
M2s_b419
%endmacro
%macro M2s_a30d 0
M2s_b401
M2s_b40e
M2s_b415
M2s_b41a
M2s_b422
%endmacro
%macro M2s_a30e 0
M2s_b405
M2s_b40e
M2s_b423
    vfmadd213pd ymm8, ymm7, [u_omg]
%endmacro
%macro M2s_a30f 0
M2s_b409
M2s_b411
M2s_b424
    vmovapd ymm9, ymm6
%endmacro
%macro M2s_a310 0
M2s_b40b
M2s_b412
M2s_b425
    vfnmadd231pd ymm9, ymm8, ymm6
%endmacro
%macro M2s_a311 0
M2s_b40d
M2s_b413
M2s_b426
    vandpd ymm9, ymm9, ymm4
%endmacro
%macro M2s_a312 0
M2s_b40e
M2s_b423
M2s_b427
    vfmadd213pd ymm8, ymm6, ymm6
%endmacro
%macro M2s_a313 0
M2s_a312
M2s_a326
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vfmadd231pd ymm13, ymm9, [r15 + G_dmx + 0]
    vfmadd231pd ymm14, ymm8, [r15 + G_dmx + 0]
    vcvtps2pd ymm0, [rdi + 65536]
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_drg + 32]
M2s_b401
M2s_b40e
    vgatherqpd ymm6, [rax + ymm7*8 + u_oa - u_rx], ymm9
    vpsrlq ymm7, ymm5, 56
    vpand ymm7, ymm7, [u_i7]
%endmacro
%macro M2s_a314 0
M2s_b40f
M2s_b424
M2s_b428
    vxorpd ymm10, ymm8, [u_mzero]
%endmacro
%macro M2s_a315 0
M2s_a314
M2s_a327
M2s_b42a
M2s_b40e
M2s_b415
%endmacro
%macro M2s_a316 0
M2s_a317
M2s_a328
M2s_b42b
M2s_b40f
M2s_b416
%endmacro
%macro M2s_a317 0
M2s_b410
M2s_b425
M2s_b42c
    vcmppd ymm11, ymm3, [u_zero], 0x1a
%endmacro
%macro M2s_a318 0
M2s_b417
M2s_b41d
M2s_b42e
%endmacro
%macro M2s_a319 0
M2s_b41a
M2s_b422
M2s_b42f
%endmacro
%macro M2s_a31a 0
M2s_b41b
    vfmadd213pd ymm9, ymm11, [u_op0]
    vfmadd213pd ymm8, ymm12, ymm9
M2s_b42e
    vfmadd213pd ymm8, ymm7, [u_omg]
    vmovapd ymm9, ymm6
%endmacro
%macro M2s_a31b 0
M2s_b41c
    vfmadd213pd ymm8, ymm12, ymm9
    vmulpd ymm6, ymm6, ymm8
M2s_a31e
M2s_b429
M2s_b40c
M2s_b41c
    vfmadd213pd ymm8, ymm12, ymm9
    vmulpd ymm6, ymm6, ymm8
    vdivpd ymm7, ymm2, ymm3
%endmacro
%macro M2s_a31c 0
M2s_b41d
M2s_b433
M2s_b41a
M2s_b422
    vdivpd ymm7, ymm2, ymm3
    vandpd ymm7, ymm7, ymm4
%endmacro
%macro M2s_a31d 0
M2s_b41e
M2s_b434
M2s_b41b
M2s_b430
    vandpd ymm7, ymm7, ymm4
    vmovapd ymm8, [u_eq0]
%endmacro
%macro M2s_a31e 0
M2s_b42f
M2s_b428
%endmacro
%macro M2s_a31f 0
    vandpd ymm7, ymm7, ymm4
    vmovapd ymm8, [u_eq0]
M2s_b427
    vfmadd213pd ymm8, ymm6, ymm6
    vxorpd ymm10, ymm8, [u_mzero]
%endmacro
%macro M2s_a320 0
M2s_b435
M2s_b42d
%endmacro
%macro M2s_a321 0
M2s_b427
M2s_a325
%endmacro
%macro M2s_a322 0
    vmovapd ymm9, ymm6
M2s_b436
%endmacro
%macro M2s_a323 0
M2s_b436
    vblendvpd ymm9, ymm9, ymm10, ymm0
%endmacro
%macro M2s_a324 0
    vandpd ymm9, ymm9, ymm4
M2s_a325
    vxorpd ymm11, ymm9, [u_mzero]
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
%endmacro
%macro M2s_a325 0
M2s_b437
%endmacro
%macro M2s_a326 0
M2s_b438
%endmacro
%macro M2s_a327 0
M2s_b439
%endmacro
%macro M2s_a328 0
M2s_b43a
%endmacro
%macro M2s_a329 0
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vfmadd231pd ymm13, ymm9, [r15 + G_dmx + 32]
    vfmadd231pd ymm14, ymm8, [r15 + G_dmx + 32]
    vcvtps2pd ymm0, [rdi + 131072]
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_drg + 64]
M2s_b401
M2s_b40e
M2s_b415
M2s_b41a
M2s_b422
M2s_b42f
M2s_b428
M2s_b438
M2s_b43e
M2s_b43f
%endmacro
%macro M2s_a32a 0
M2s_b43c
M2s_b41e
M2s_b42f
M2s_b428
M2s_b438
M2s_b43e
M2s_a32d
%endmacro
%macro M2s_a32b 0
M2s_b43d
M2s_b41f
M2s_b431
M2s_b42c
M2s_b439
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vfmadd231pd ymm13, ymm9, [r15 + G_dmx + 64]
    vfmadd231pd ymm14, ymm8, [r15 + G_dmx + 64]
M2s_a32d
    ret
%endmacro
%macro M2s_a32c 0
M2s_b440
%endmacro
%macro M2s_a32d 0
M2s_b43f
    vcvtpd2dq xmm4, ymm1
%endmacro
%macro M2s_a32e 0
    vblendvpd ymm1, ymm1, ymm13, ymm0
    vcvtpd2dq xmm4, ymm1
    ret
.t1c:
    vcvtps2pd ymm0, [rdi + 49152]
M2s_b418
    vdivpd ymm2, ymm3, ymm2
    vmovapd ymm15, [r15 + G_esn]
    vfmadd213pd ymm15, ymm2, [r15 + G_ean]
    vfmadd213pd ymm15, ymm1, [r15 + G_eta]
M2s_b419
    vfmadd231pd ymm2, ymm1, [r15 + G_erg + 0]
M2s_b401
M2s_b40e
M2s_b415
M2s_b41a
M2s_b422
M2s_b42f
M2s_b428
M2s_b438
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
%endmacro
%macro M2s_a32f 0
M2s_b441
M2s_b414
M2s_b41d
M2s_b42e
M2s_b427
M2s_b437
    vxorpd ymm11, ymm9, [u_mzero]
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vmovapd [r12 + 704], ymm9
%endmacro
%macro M2s_a330 0
M2s_b442
M2s_b415
M2s_b41a
M2s_b422
M2s_b42f
M2s_b428
M2s_b438
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vmovapd [r12 + 704], ymm9
    vmovapd [r12 + 736], ymm8
%endmacro
%macro M2s_a331 0
M2s_b443
M2s_b416
M2s_b41b
M2s_b431
M2s_b42c
M2s_b439
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vmovapd [r12 + 704], ymm9
    vmovapd [r12 + 736], ymm8
    vcvtps2pd ymm0, [rdi + 16384]
%endmacro
%macro M2s_a332 0
    vmovapd [r12 + 704], ymm9
    vmovapd [r12 + 736], ymm8
    vcvtps2pd ymm0, [rdi + 16384]
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_erg + 32]
M2s_b401
M2s_b40e
M2s_b415
M2s_b41a
M2s_b422
M2s_b42f
M2s_b428
M2s_b438
M2s_b447
    vfmadd231pd ymm2, ymm1, [r15 + G_erg + 64]
M2s_b402
%endmacro
%macro M2s_a333 0
M2s_b444
M2s_b420
M2s_b432
M2s_b435
M2s_b42d
M2s_b43a
M2s_b448
M2s_b403
%endmacro
%macro M2s_a334 0
M2s_b445
M2s_b421
M2s_b42e
M2s_b427
M2s_b437
    vxorpd ymm11, ymm9, [u_mzero]
M2s_b447
M2s_b449
    vblendvpd ymm5, ymm5, ymm1, ymm4
    vpsrlq ymm7, ymm5, 48
    vpand ymm8, ymm7, [u_i15]
%endmacro
%macro M2s_a335 0
M2s_b446
M2s_b422
M2s_b42f
M2s_b428
M2s_b438
M2s_b447
M2s_b449
M2s_b404
%endmacro
%macro M2s_a336 0
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vmovapd [r12 + 832], ymm9
    vmovapd [r12 + 864], ymm8
    vmovapd ymm13, [r15 + G_elo]
    vmovapd ymm2, [r12 + 800]
    vfnmadd231pd ymm13, ymm2, [r15 + G_emx + 64]
    vmovapd ymm2, [r12 + 736]
    vfnmadd231pd ymm13, ymm2, [r15 + G_emx + 32]
    vmovapd ymm2, [r12 + 832]
    vfmadd231pd ymm13, ymm2, [r15 + G_emx + 0]
    vmovapd ymm14, [r15 + G_ehi]
    vmovapd ymm2, [r12 + 768]
    vfnmadd231pd ymm14, ymm2, [r15 + G_emx + 64]
    vmovapd ymm2, [r12 + 704]
    vfnmadd231pd ymm14, ymm2, [r15 + G_emx + 32]
    vmovapd ymm2, [r12 + 864]
    vfmadd231pd ymm14, ymm2, [r15 + G_emx + 0]
M2s_b440
    vminpd ymm13, ymm13, [u_1023]
    vmovapd ymm1, [u_mone]
    vblendvpd ymm1, ymm1, ymm13, ymm0
    vcvtpd2dq xmm4, ymm1
    vmovapd ymm13, [r15 + G_elo + 32]
    vmovapd ymm2, [r12 + 864]
    vfnmadd231pd ymm13, ymm2, [r15 + G_emx + 160]
    vmovapd ymm2, [r12 + 800]
    vfnmadd231pd ymm13, ymm2, [r15 + G_emx + 128]
    vmovapd ymm2, [r12 + 704]
    vfmadd231pd ymm13, ymm2, [r15 + G_emx + 96]
    vmovapd ymm14, [r15 + G_ehi + 32]
    vmovapd ymm2, [r12 + 832]
    vfnmadd231pd ymm14, ymm2, [r15 + G_emx + 160]
    vmovapd ymm2, [r12 + 768]
    vfnmadd231pd ymm14, ymm2, [r15 + G_emx + 128]
    vmovapd ymm2, [r12 + 736]
    vfmadd231pd ymm14, ymm2, [r15 + G_emx + 96]
M2s_b440
    vminpd ymm13, ymm13, [u_1023]
    vmovapd ymm1, [u_mone]
    vblendvpd ymm1, ymm1, ymm13, ymm0
    vcvtpd2dq xmm5, ymm1
    vpcmpeqd xmm3, xmm3, xmm3
M2s_b44e
M2s_b450
    cmp qword [r12 + 1216], 0
    jne .fzc
    imul rcx, [rdi + G_wo]
%endmacro
%macro M2s_a337 0
M2s_b44a
M2s_b44c
M2s_b44e
M2s_b450
    cmp qword [r12 + 1216], 0
    jne .fzc
    imul rcx, [rdi + G_wo]
    add rcx, rdx
%endmacro
%macro M2s_a338 0
M2s_b44b
M2s_b44d
M2s_b44f
M2s_b451
    jne .fzc
    imul rcx, [rdi + G_wo]
    add rcx, rdx
    mov rsi, [rdi + G_dy]
%endmacro
%macro M2s_a339 0
    add rcx, rdx
M2s_b452
M2s_b454
    mov [r12 + 1296], rax
.t2y:
    mov rax, [r12 + 1296]
%endmacro
%macro M2s_a33a 0
M2s_b452
M2s_b454
    mov [r12 + 1296], rax
.t2y:
    mov rax, [r12 + 1296]
    mov rcx, rax
%endmacro
%macro M2s_a33b 0
M2s_b453
M2s_b455
.t2y:
    mov rax, [r12 + 1296]
    mov rcx, rax
    imul rcx, r11
%endmacro
%macro M2s_a33c 0
M2s_b456
%endmacro
%macro M2s_a33d 0
M2s_a33c
M2s_b457
%endmacro
%macro M2s_a33e 0
M2s_b458
%endmacro
%macro M2s_a33f 0
M2s_b459
%endmacro
%macro M2s_a340 0
M2s_b45a
%endmacro
%macro M2s_a341 0
M2s_b45b
%endmacro
%macro M2s_a342 0
    mov rcx, rax
M2s_b45c
M2s_b45e
    cmp qword [r12 + 1272], 0
    je .t2w
M2s_a34b
%endmacro
%macro M2s_a343 0
M2s_b45c
M2s_b45e
    cmp qword [r12 + 1272], 0
    je .t2w
M2s_a34b
.t2w:
%endmacro
%macro M2s_a344 0
M2s_b45d
M2s_b45f
    je .t2w
M2s_a34b
.t2w:
    imul rdx, [r12 + 1304]
%endmacro
%macro M2s_a345 0
M2s_b460
M2s_b463
    mov ecx, [rbx + Rc_co + 12]
M2s_b464
    add rcx, rcx
    add rcx, [rdi + G_sy]
    mov [r12 + 1328], rcx
%endmacro
%macro M2s_a346 0
M2s_b464
    add rcx, rcx
    add rcx, [rdi + G_sy]
    mov [r12 + 1328], rcx
    mov rax, [r12 + 1240]
%endmacro
%macro M2s_a347 0
M2s_b465
    add rcx, [rdi + G_sy]
    mov [r12 + 1328], rcx
    mov rax, [r12 + 1240]
    xor edx, edx
%endmacro
%macro M2s_a348 0
    mov [r12 + 1328], rcx
    mov rax, [r12 + 1240]
    xor edx, edx
    div r9
%endmacro
%macro M2s_a349 0
    mov rax, [r12 + 1240]
    xor edx, edx
    div r9
    mov r14, rax
%endmacro
%macro M2s_a34a 0
M2s_b466
%endmacro
%macro M2s_a34b 0
M2s_b467
%endmacro
%macro M2s_a34c 0
.t2w:
M2s_b468
    jmp .t2y
.t2f:
    mov rsi, [r12 + 1288]
%endmacro
%macro M2s_a34d 0
M2s_b46a
%endmacro
%macro M2s_a34e 0
M2s_b468
    jmp .t2y
.t2f:
    mov rsi, [r12 + 1288]
    test rsi, rsi
%endmacro
%macro M2s_a34f 0
M2s_b46b
M2s_b46f
M2s_b473
    mov rcx, [r12 + 1344]
    vmulss xmm0, xmm15, [rcx + rax + 32]
    vshufps xmm1, xmm15, xmm15, 85
M2s_b469
.t2f:
    mov rsi, [r12 + 1288]
    test rsi, rsi
    jz .t2e
%endmacro
%macro M2s_a350 0
M2s_b474
    vfmadd231ss xmm0, xmm1, [rcx + rax + 32]
    vshufps xmm1, xmm15, xmm15, 255
    mov rcx, [r12 + 1368]
    vfmadd231ss xmm0, xmm1, [rcx + rax + 32]
%endmacro
%macro M2s_a351 0
    vfmadd231ss xmm0, xmm1, [rcx + rax + 32]
M2s_b475
%endmacro
%macro M2s_a352 0
M2s_b475
    cmp rsi, 4
%endmacro
%macro M2s_a353 0
    mov rcx, [r12 + 1368]
    vfmadd231ss xmm0, xmm1, [rcx + rax + 32]
    vcvtss2sd xmm0, xmm0, xmm0
    vmovsd [r12 + 448 + rsi*8], xmm0
%endmacro
%macro M2s_a354 0
    vfmadd231ss xmm0, xmm1, [rcx + rax + 32]
    vcvtss2sd xmm0, xmm0, xmm0
    vmovsd [r12 + 448 + rsi*8], xmm0
    inc rsi
%endmacro
%macro M2s_a355 0
    vcvtss2sd xmm0, xmm0, xmm0
    vmovsd [r12 + 448 + rsi*8], xmm0
    inc rsi
    mov [r12 + 1288], rsi
%endmacro
%macro M2s_a356 0
M2s_b476
%endmacro
%macro M2s_a357 0
    test rsi, rsi
M2s_b477
M2s_b479
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [u_rg2]
M2s_b401
%endmacro
%macro M2s_a358 0
M2s_b477
M2s_b479
M2s_b47b
M2s_b405
    vandpd ymm11, ymm5, [u_mant]
%endmacro
%macro M2s_a359 0
M2s_b478
M2s_b47a
M2s_b47c
M2s_b40a
    vorpd ymm11, ymm11, [u_oneb]
%endmacro
%macro M2s_a35a 0
M2s_b47d
%endmacro
%macro M2s_a35b 0
    vblendvpd ymm9, ymm9, ymm10, ymm0
M2s_b47e
M2s_b480
%endmacro
%macro M2s_a35c 0
M2s_b47e
M2s_b480
    cmovne edx, esi
%endmacro
%macro M2s_a35d 0
M2s_b47f
M2s_b481
M2s_b483
    cmovg edx, esi
    mov esi, -1
    cmp rax, rcx
    cmovne edx, esi
    mov eax, edx
%endmacro
%macro M2s_a35e 0
    vfmadd231sd xmm2, xmm1, [r12 + 672 + 16]
M2s_a35f
M2s_a360
    cmp rax, rcx
    cmovne edx, esi
    mov eax, edx
%endmacro
%macro M2s_a35f 0
M2s_b482
%endmacro
%macro M2s_a360 0
M2s_b484
%endmacro
%macro M2s_a361 0
    mov r8d, eax
    vmovsd xmm0, [u_clo]
    vmovsd xmm1, [u_emc8]
    vfnmadd231sd xmm0, xmm1, [r12 + 672 + 16]
    vmovsd xmm1, [u_emc7]
    vfnmadd231sd xmm0, xmm1, [r12 + 672 + 8]
    vmovsd xmm1, [u_emc6]
    vfmadd231sd xmm0, xmm1, [r12 + 640]
    vmovsd xmm2, [u_chi]
    vmovsd xmm1, [u_emc8]
    vfnmadd231sd xmm2, xmm1, [r12 + 640 + 16]
    vmovsd xmm1, [u_emc7]
    vfnmadd231sd xmm2, xmm1, [r12 + 640 + 8]
    vmovsd xmm1, [u_emc6]
    vfmadd231sd xmm2, xmm1, [r12 + 672]
M2s_b482
M2s_b484
    cmp rax, rcx
    cmovne edx, esi
    mov eax, edx
    mov ecx, eax
M2s_b486
M2s_b488
M2s_b48b
    vgatherqpd ymm10, [rax + ymm9*8 + u_tsl - u_rx], ymm11
    vpand ymm9, ymm7, [u_i16]
    vpxor ymm11, ymm11, ymm11
    vpcmpeqq ymm9, ymm9, ymm11
    vmulpd ymm11, ymm10, [u_tsk]
%endmacro
%macro M2s_a362 0
M2s_b48a
M2s_b48d
%endmacro
%macro M2s_a363 0
M2s_b48e
    vgatherqpd ymm11, [rax + ymm8*8 + u_wsx - u_rx], ymm9
    vmulpd ymm10, ymm10, ymm11
    vpcmpeqq ymm9, ymm9, ymm9
M2s_a366
    vmulpd ymm12, ymm10, ymm9
    vmulpd ymm12, ymm12, ymm13
    vandpd ymm14, ymm4, [u_mzero]
M2s_a367
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r12 + 512]
    vmovsd [r12 + 512], xmm12
M2s_a368
    vaddsd xmm14, xmm14, [r12 + 544]
    vmovsd [r12 + 544], xmm14
    vandpd ymm6, ymm5, [u_absm]
M2s_b48a
M2s_b48d
M2s_b493
    vmulpd ymm12, ymm10, ymm9
    vmulpd ymm12, ymm12, ymm13
M2s_b496
    vpermilpd xmm11, xmm12, 1
    vaddsd xmm12, xmm12, xmm11
%endmacro
%macro M2s_a364 0
M2s_b48f
M2s_b491
M2s_b494
M2s_b496
    vpermilpd xmm11, xmm12, 1
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r12 + 520]
%endmacro
%macro M2s_a365 0
M2s_b490
M2s_b492
M2s_b495
M2s_b497
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r12 + 520]
    vmovsd [r12 + 520], xmm12
%endmacro
%macro M2s_a366 0
M2s_b493
%endmacro
%macro M2s_a367 0
M2s_b497
%endmacro
%macro M2s_a368 0
M2s_b498
%endmacro
%macro M2s_a369 0
    vaddsd xmm12, xmm12, [r12 + 520]
    vmovsd [r12 + 520], xmm12
M2s_b498
    vaddsd xmm14, xmm14, [r12 + 552]
    vmovsd [r12 + 552], xmm14
    vandpd ymm6, ymm3, [u_absm]
M2s_b48a
M2s_b48d
M2s_b493
    vmulpd ymm12, ymm10, ymm9
    vmulpd ymm12, ymm12, ymm13
    vandpd ymm14, ymm3, [u_mzero]
M2s_b497
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r12 + 528]
    vmovsd [r12 + 528], xmm12
M2s_b498
    vaddsd xmm14, xmm14, [r12 + 560]
    vmovsd [r12 + 560], xmm14
    ret
.t3:
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r12 + 1088], ymm0
    vmovapd [r12 + 1120], ymm0
M2s_b456
M2s_b457
    mov rax, [r12 + 1232]
    xor ebx, ebx
%endmacro
%macro M2s_a36a 0
M2s_b499
M2s_b49b
M2s_b49d
    add r9, r9
M2s_b457
    mov rax, [r12 + 1232]
    xor ebx, ebx
    test rcx, rcx
%endmacro
%macro M2s_a36b 0
M2s_b49a
    vhaddpd xmm12, xmm12, xmm11
    vpermilpd xmm11, xmm12, 1
M2s_b49c
    mov r9, [rdi + G_wo]
M2s_b49e
    jnz .t3c
M2s_b458
%endmacro
%macro M2s_a36c 0
    test rcx, rcx
M2s_b49f
    lea rsi, [rdx + 1]
    jmp .t3g
.t3c:
    lea r13, [rax*4 - 1]
    test rax, rax
    jnz .t3d
    xor r13d, r13d
    mov ebx, 1
.t3d:
    lea r14, [rax*4 + 3]
    lea r15, [rdx + rdx]
    lea rsi, [r15 + 2]
.t3g:
M2s_b459
M2s_b45a
    xor edx, edx
    div r11
    mov [r12 + 1296], rax
.t3y:
M2s_b45b
    jae .t3f
M2s_b460
M2s_b463
    mov ecx, [rbx + Rc_co + 12]
%endmacro
%macro M2s_a36d 0
M2s_b49f
M2s_b4a0
    cmp rcx, [r12 + 1264]
M2s_b4a2
M2s_b461
    mov [r12 + 1360], rcx
    mov ecx, [rbx + Rc_co + 12]
    lea rcx, [rsi + rcx*4]
%endmacro
%macro M2s_a36e 0
M2s_b4a1
M2s_b4a2
M2s_b462
%endmacro
%macro M2s_a36f 0
.t3j:
    mov rax, r14
    imul rax, r9
    cmp rax, [r12 + 1248]
    jae .t3n
M2s_b466
    sub rdx, rcx
    cmp qword [r12 + 1272], 0
    je .t3w
M2s_b467
.t3w:
M2s_b46a
M2s_b474
    vfmadd231ss xmm0, xmm1, [rcx + rax + 32]
    vshufps xmm1, xmm15, xmm15, 255
    mov rcx, [r12 + 1368]
%endmacro
%macro M2s_a370 0
    cmp rsi, 4
    jb .t3x
    push r14
    call .t3b
M2s_b476
    mov r9, [rdi + G_wo]
    add r9, r9
    mov r11, [rdi + G_ho]
.t3x:
    inc r14
    jmp .t3j
.t3n:
    inc qword [r12 + 1296]
    jmp .t3y
.t3f:
    mov rsi, [r12 + 1288]
    test rsi, rsi
    jz .t3e
    vxorpd xmm0, xmm0, xmm0
.t3z:
M2s_b47d
    inc rsi
    cmp rsi, 4
    jb .t3z
    call .t3b
M2s_b4a6
    vmulpd ymm6, ymm1, ymm2
    vfmadd231pd ymm6, ymm0, ymm3
M2s_b4a9
M2s_b4ac
%endmacro
%macro M2s_a371 0
M2s_b4a5
M2s_b4a8
M2s_b4a9
M2s_b4ac
    vmovsd xmm4, [r12 + 1168]
%endmacro
%macro M2s_a372 0
M2s_b4ad
%endmacro
%macro M2s_a373 0
M2s_b4ac
M2s_b4ae
M2s_b4b4
M2s_b4b7
M2s_a379
%endmacro
%macro M2s_a374 0
    vmovsd xmm2, [r12 + 1160]
    vmovsd xmm3, [r12 + 1192]
M2s_b4ae
M2s_b4b4
M2s_b4b7
M2s_a379
    vaddsd xmm10, xmm10, xmm13
    vaddsd xmm13, xmm8, xmm7
%endmacro
%macro M2s_a375 0
M2s_b4b9
M2s_b4b3
M2s_b4b6
    vsubsd xmm8, xmm9, xmm8
M2s_b4ba
%endmacro
%macro M2s_a376 0
M2s_b4ae
M2s_b4b4
M2s_b4b7
M2s_b4ba
    vsubsd xmm6, xmm13, xmm11
%endmacro
%macro M2s_a377 0
M2s_b4af
M2s_b4b5
M2s_b4b8
M2s_b4bb
    vsubsd xmm6, xmm8, xmm6
%endmacro
%macro M2s_a378 0
    vsubsd xmm8, xmm9, xmm8
M2s_a379
M2s_a37c
M2s_b4bd
%endmacro
%macro M2s_a379 0
    vmovsd xmm13, [u_kb]
M2s_b4be
M2s_b4c0
    vsubsd xmm10, xmm12, xmm13
    vsubsd xmm10, xmm14, xmm10
    vsubsd xmm13, xmm9, xmm13
%endmacro
%macro M2s_a37a 0
M2s_b4be
M2s_b4c0
    vsubsd xmm10, xmm12, xmm13
    vsubsd xmm10, xmm14, xmm10
    vsubsd xmm13, xmm9, xmm13
    vaddsd xmm10, xmm10, xmm13
%endmacro
%macro M2s_a37b 0
M2s_b4bf
M2s_b4c1
    vsubsd xmm10, xmm14, xmm10
    vsubsd xmm13, xmm9, xmm13
    vaddsd xmm10, xmm10, xmm13
    vaddsd xmm13, xmm8, xmm7
%endmacro
%macro M2s_a37c 0
M2s_b4bb
M2s_b4c2
%endmacro
%macro M2s_a37d 0
M2s_b4bc
    vsubsd xmm11, xmm7, xmm11
    vaddsd xmm6, xmm6, xmm11
    vaddsd xmm11, xmm10, xmm13
    vaddsd xmm13, xmm12, xmm11
%endmacro
%macro M2s_a37e 0
    vsubsd xmm11, xmm13, xmm8
    vsubsd xmm6, xmm13, xmm11
M2s_b4c2
    vaddsd xmm13, xmm12, xmm11
    vsubsd xmm10, xmm13, xmm12
%endmacro
%macro M2s_a37f 0
M2s_a37e
M2s_a385
    vsubsd xmm10, xmm11, xmm10
M2s_b4c4
M2s_b4c6
    vaddsd xmm3, xmm10, xmm6
    vsubsd xmm4, xmm3, xmm10
    vsubsd xmm4, xmm6, xmm4
%endmacro
%macro M2s_a380 0
M2s_b4c3
    vaddsd xmm11, xmm10, xmm13
M2s_b4bd
M2s_b4c4
M2s_b4c6
M2s_b4c9
%endmacro
%macro M2s_a381 0
M2s_b4c2
M2s_b4bd
M2s_b4c4
M2s_b4c6
M2s_b4c9
    vaddsd xmm9, xmm3, xmm6
%endmacro
%macro M2s_a382 0
    vsubsd xmm11, xmm7, xmm11
    vaddsd xmm6, xmm6, xmm11
M2s_b4c8
M2s_b4c5
M2s_b4c7
    vaddsd xmm6, xmm4, xmm9
    vaddsd xmm9, xmm3, xmm6
    vcmpsd xmm5, xmm9, [u_half], 0x1e
%endmacro
%macro M2s_a383 0
    vaddsd xmm13, xmm12, xmm11
    vsubsd xmm10, xmm13, xmm12
    vsubsd xmm10, xmm11, xmm10
    vaddsd xmm11, xmm10, xmm6
%endmacro
%macro M2s_a384 0
    vsubsd xmm10, xmm13, xmm12
    vsubsd xmm10, xmm11, xmm10
    vaddsd xmm11, xmm10, xmm6
    vaddsd xmm6, xmm13, xmm11
%endmacro
%macro M2s_a385 0
    vsubsd xmm10, xmm11, xmm10
    vaddsd xmm11, xmm10, xmm6
    vaddsd xmm6, xmm13, xmm11
    vsubsd xmm10, xmm6, xmm13
%endmacro
%macro M2s_a386 0
    vaddsd xmm6, xmm4, xmm9
    vaddsd xmm9, xmm3, xmm6
    vcmpsd xmm5, xmm9, [u_half], 0x1e
    vandpd xmm5, xmm5, [u_one]
    vcmpsd xmm1, xmm9, [u_mhalf], 0x11
    vandpd xmm1, xmm1, [u_one]
    vaddsd xmm0, xmm0, xmm5
    vsubsd xmm0, xmm0, xmm1
    vcvttsd2si eax, xmm0
M2s_a38a
    cmp eax, ecx
    cmovg eax, ecx
    ret
.t3h:
M2s_b4ac
M2s_b4ae
M2s_b4b4
    vaddsd xmm9, xmm8, xmm14
    vaddsd xmm14, xmm7, xmm9
    vsubsd xmm8, xmm14, xmm7
%endmacro
%macro M2s_a387 0
M2s_b4ca
M2s_b4b0
M2s_b4b3
M2s_b4b6
    vsubsd xmm8, xmm9, xmm8
%endmacro
%macro M2s_a388 0
M2s_b4cb
M2s_b4b1
M2s_b4b4
M2s_b4b7
    vmovsd xmm13, [u_kb]
%endmacro
%macro M2s_a389 0
M2s_b4cc
M2s_b4b2
M2s_b4b5
    vaddsd xmm14, xmm7, xmm9
    vsubsd xmm8, xmm14, xmm7
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm13, [u_kb]
    vmovsd xmm12, [u_kb + 8]
%endmacro
%macro M2s_a38a 0
M2s_b4cd
%endmacro
%macro M2s_a38b 0
    vaddsd xmm6, xmm13, xmm11
M2s_b4ce
M2s_b4d1
M2s_b4d4
M2s_b4d7
    vsubsd xmm11, xmm0, xmm11
    vsubsd xmm13, xmm3, xmm13
    vaddsd xmm11, xmm11, xmm13
%endmacro
%macro M2s_a38c 0
M2s_b4ce
M2s_b4d1
M2s_b4d4
M2s_b4d7
    vsubsd xmm11, xmm0, xmm11
    vsubsd xmm13, xmm3, xmm13
    vaddsd xmm11, xmm11, xmm13
    vaddsd xmm13, xmm1, xmm2
%endmacro
%macro M2s_a38d 0
M2s_b4cf
M2s_b4d2
M2s_b4d5
M2s_b4d8
    vsubsd xmm13, xmm3, xmm13
    vaddsd xmm11, xmm11, xmm13
    vaddsd xmm13, xmm1, xmm2
    vsubsd xmm10, xmm13, xmm1
%endmacro
%macro M2s_a38e 0
M2s_b4d0
M2s_b4d3
M2s_b4d6
M2s_b4d9
    vaddsd xmm11, xmm11, xmm13
    vaddsd xmm13, xmm1, xmm2
    vsubsd xmm10, xmm13, xmm1
    vsubsd xmm9, xmm13, xmm10
%endmacro
%macro M2s_a38f 0
    vaddsd xmm13, xmm1, xmm2
M2s_b4da
M2s_b4dd
M2s_b4e0
M2s_b4e3
    vsubsd xmm9, xmm6, xmm9
    vaddsd xmm15, xmm15, xmm9
    vaddsd xmm9, xmm3, xmm13
%endmacro
%macro M2s_a390 0
M2s_b4da
M2s_b4dd
M2s_b4e0
M2s_b4e3
    vsubsd xmm9, xmm6, xmm9
    vaddsd xmm15, xmm15, xmm9
    vaddsd xmm9, xmm3, xmm13
    vaddsd xmm13, xmm8, xmm9
%endmacro
%macro M2s_a391 0
M2s_b4db
M2s_b4de
M2s_b4e1
M2s_b4e4
    vaddsd xmm15, xmm15, xmm9
    vaddsd xmm9, xmm3, xmm13
    vaddsd xmm13, xmm8, xmm9
    vsubsd xmm3, xmm13, xmm8
%endmacro
%macro M2s_a392 0
M2s_b4dc
M2s_b4df
M2s_b4e2
M2s_b4e5
    vaddsd xmm9, xmm3, xmm13
    vaddsd xmm13, xmm8, xmm9
    vsubsd xmm3, xmm13, xmm8
    vsubsd xmm3, xmm9, xmm3
%endmacro
%macro M2s_a393 0
    vaddsd xmm13, xmm8, xmm9
    vsubsd xmm3, xmm13, xmm8
    vsubsd xmm3, xmm9, xmm3
    vaddsd xmm9, xmm3, xmm15
    vaddsd xmm15, xmm13, xmm9
    vcmpsd xmm6, xmm15, [u_half], 0x1e
    vandpd xmm6, xmm6, [u_one]
    vcmpsd xmm11, xmm15, [u_mhalf], 0x11
    vandpd xmm11, xmm11, [u_one]
    vaddsd xmm7, xmm7, xmm6
    vsubsd xmm7, xmm7, xmm11
    vcvttsd2si eax, xmm7
M2s_b4cd
    cmp eax, ecx
    cmovg eax, ecx
    mov [r12 + 1296], eax
    vmovsd xmm0, [r12 + 1280]
    vmovsd xmm1, [r12 + 1288]
    vroundsd xmm2, xmm0, xmm0, 8
    vsubsd xmm3, xmm0, xmm2
    vxorpd xmm4, xmm4, xmm4
    vaddsd xmm5, xmm3, xmm1
    vsubsd xmm6, xmm5, xmm3
    vsubsd xmm7, xmm5, xmm6
    vsubsd xmm7, xmm3, xmm7
    vsubsd xmm6, xmm1, xmm6
    vaddsd xmm7, xmm7, xmm6
    vaddsd xmm6, xmm4, xmm4
    vsubsd xmm8, xmm6, xmm4
    vsubsd xmm9, xmm6, xmm8
M2s_b4e9
M2s_b4cd
M2s_b4ec
    vmovapd ymm2, [r12 + 416]
    vmovapd ymm3, [r12 + 448]
    vbroadcastsd ymm4, [u_ysc]
%endmacro
%macro M2s_a394 0
M2s_b4e6
M2s_b4e9
M2s_b4cd
M2s_b4ec
M2s_b4ee
%endmacro
%macro M2s_a395 0
M2s_b4e7
M2s_b4ea
    test eax, eax
    cmovs eax, ecx
    mov ecx, 1023
M2s_b4ec
M2s_b4ee
    vmulpd ymm6, ymm1, ymm4
%endmacro
%macro M2s_a396 0
M2s_b4e8
M2s_b4eb
M2s_b4ef
M2s_b4ed
    vbroadcastsd ymm4, [u_ysc]
    vbroadcastsd ymm5, [u_ysc + 8]
    vmulpd ymm6, ymm1, ymm4
    vmovapd ymm7, ymm6
%endmacro
%macro M2s_a397 0
    vbroadcastsd ymm5, [u_ysc + 8]
M2s_b4f0
M2s_b4f3
M2s_b4f6
M2s_b4f9
    vsubpd ymm8, ymm4, ymm5
    vsubpd ymm8, ymm9, ymm8
    vmovapd [r12 + 704], ymm4
%endmacro
%macro M2s_a398 0
M2s_b4f0
M2s_b4f3
M2s_b4f6
M2s_b4f9
    vsubpd ymm8, ymm4, ymm5
    vsubpd ymm8, ymm9, ymm8
    vmovapd [r12 + 704], ymm4
    vmovapd [r12 + 736], ymm8
%endmacro
%macro M2s_a399 0
M2s_b4f1
M2s_b4f4
M2s_b4f7
M2s_b4fa
    vsubpd ymm8, ymm9, ymm8
    vmovapd [r12 + 704], ymm4
    vmovapd [r12 + 736], ymm8
    vbroadcastsd ymm8, [u_gcr]
%endmacro
%macro M2s_a39a 0
M2s_b4f2
M2s_b4f5
M2s_b4f8
M2s_b4fb
    vmovapd [r12 + 704], ymm4
    vmovapd [r12 + 736], ymm8
    vbroadcastsd ymm8, [u_gcr]
    vbroadcastsd ymm4, [u_gcr + 8]
%endmacro
%macro M2s_a39b 0
    vmovapd [r12 + 736], ymm8
M2s_b4fc
M2s_b4ff
M2s_b502
M2s_b505
    vsubpd ymm7, ymm12, ymm3
    vsubpd ymm7, ymm9, ymm7
    vmovapd [r12 + 768], ymm12
%endmacro
%macro M2s_a39c 0
M2s_b4fc
M2s_b4ff
M2s_b502
M2s_b505
    vsubpd ymm7, ymm12, ymm3
    vsubpd ymm7, ymm9, ymm7
    vmovapd [r12 + 768], ymm12
    vmovapd [r12 + 800], ymm7
%endmacro
%macro M2s_a39d 0
M2s_b4fd
M2s_b500
M2s_b503
M2s_b506
    vsubpd ymm7, ymm9, ymm7
    vmovapd [r12 + 768], ymm12
    vmovapd [r12 + 800], ymm7
    vbroadcastsd ymm7, [u_bcb]
%endmacro
%macro M2s_a39e 0
M2s_b4fe
M2s_b501
M2s_b504
M2s_b507
    vmovapd [r12 + 768], ymm12
    vmovapd [r12 + 800], ymm7
    vbroadcastsd ymm7, [u_bcb]
    vbroadcastsd ymm12, [u_bcb + 8]
%endmacro
%macro M2s_a39f 0
    vmovapd [r12 + 800], ymm7
M2s_b508
M2s_b50b
M2s_b50e
M2s_b515
    vaddsd xmm8, xmm6, xmm7
    vsubsd xmm9, xmm8, xmm6
    vsubsd xmm9, xmm7, xmm9
%endmacro
%macro M2s_a3a0 0
M2s_b508
M2s_b50b
M2s_b50e
M2s_b515
M2s_b519
%endmacro
%macro M2s_a3a1 0
M2s_b509
M2s_b50c
M2s_b50f
M2s_b516
M2s_b51a
%endmacro
%macro M2s_a3a2 0
M2s_b50a
M2s_b50d
M2s_b510
M2s_b517
M2s_b51b
%endmacro
%macro M2s_a3a3 0
M2s_b512
M2s_b519
M2s_b51c
%endmacro
%macro M2s_a3a4 0
M2s_b514
    vaddsd xmm5, xmm0, xmm8
M2s_b51c
    vaddsd xmm3, xmm3, xmm4
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm2, xmm4, xmm1
%endmacro
%macro M2s_a3a5 0
M2s_b515
M2s_b519
M2s_b51c
M2s_b51f
%endmacro
%macro M2s_a3a6 0
M2s_b516
M2s_b51a
    vsubsd xmm3, xmm5, xmm4
    vsubsd xmm3, xmm0, xmm3
    vsubsd xmm4, xmm8, xmm4
M2s_b51f
    vsubsd xmm7, xmm1, xmm7
%endmacro
%macro M2s_a3a7 0
M2s_b517
M2s_b51b
M2s_b521
    vsubsd xmm2, xmm4, xmm1
    vsubsd xmm7, xmm4, xmm2
    vsubsd xmm7, xmm1, xmm7
    vsubsd xmm2, xmm9, xmm2
%endmacro
%macro M2s_a3a8 0
M2s_b51d
M2s_b522
M2s_b526
    vaddsd xmm0, xmm9, xmm1
%endmacro
%macro M2s_a3a9 0
M2s_b51c
M2s_b523
M2s_b527
    vsubsd xmm2, xmm0, xmm9
%endmacro
%macro M2s_a3aa 0
    vsubsd xmm3, xmm5, xmm4
    vsubsd xmm3, xmm0, xmm3
M2s_b522
M2s_b526
    vaddsd xmm0, xmm9, xmm1
    vsubsd xmm2, xmm0, xmm9
    vsubsd xmm2, xmm1, xmm2
%endmacro
%macro M2s_a3ab 0
M2s_b528
M2s_b525
    vaddsd xmm1, xmm1, xmm0
M2s_b529
%endmacro
%macro M2s_a3ac 0
M2s_b51f
M2s_b52a
%endmacro
%macro M2s_a3ad 0
    vsubsd xmm7, xmm4, xmm2
M2s_b52a
    vaddsd xmm4, xmm5, xmm2
    vsubsd xmm3, xmm4, xmm5
    vsubsd xmm3, xmm2, xmm3
%endmacro
%macro M2s_a3ae 0
M2s_b52a
M2s_a3b2
%endmacro
%macro M2s_a3af 0
    vsubsd xmm2, xmm9, xmm2
M2s_b52c
%endmacro
%macro M2s_a3b0 0
M2s_b52c
    vsubsd xmm3, xmm7, xmm4
%endmacro
%macro M2s_a3b1 0
    vaddsd xmm2, xmm3, xmm4
M2s_b524
%endmacro
%macro M2s_a3b2 0
    vaddsd xmm4, xmm5, xmm2
    vsubsd xmm3, xmm4, xmm5
    vsubsd xmm3, xmm2, xmm3
    vaddsd xmm2, xmm3, xmm7
%endmacro
%macro M2s_a3b3 0
    vsubsd xmm3, xmm4, xmm5
    vsubsd xmm3, xmm2, xmm3
    vaddsd xmm2, xmm3, xmm7
    vaddsd xmm7, xmm4, xmm2
%endmacro
%macro M2s_a3b4 0
    vaddsd xmm2, xmm3, xmm7
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm2, xmm3
%endmacro
%macro M2s_a3b5 0
M2s_b52d
%endmacro
%macro M2s_a3b6 0
M2s_b52e
%endmacro
%macro M2s_a3b7 0
M2s_b52f
%endmacro
%macro M2s_a3b8 0
M2s_b526
M2s_b529
M2s_b530
%endmacro
%macro M2s_a3b9 0
    vsubsd xmm2, xmm0, xmm9
    vsubsd xmm2, xmm1, xmm2
    vaddsd xmm7, xmm4, xmm0
M2s_b530
M2s_b534
M2s_b537
    vxorpd xmm5, xmm5, xmm5
    vmulsd xmm6, xmm2, xmm4
%endmacro
%macro M2s_a3ba 0
M2s_b531
M2s_b535
M2s_b538
    vmovapd xmm7, xmm6
%endmacro
%macro M2s_a3bb 0
M2s_b533
M2s_b536
M2s_b511
    vfmsub231sd xmm7, xmm2, xmm4
%endmacro
%macro M2s_a3bc 0
M2s_b530
M2s_b534
M2s_b537
M2s_b513
    vmulsd xmm8, xmm3, xmm4
%endmacro
%macro M2s_a3bd 0
M2s_b539
%endmacro
%macro M2s_a3be 0
M2s_b53a
%endmacro
%macro M2s_a3bf 0
    vsubsd xmm5, xmm6, xmm5
    vaddsd xmm6, xmm5, xmm1
    vaddsd xmm1, xmm3, xmm6
    vsubsd xmm5, xmm1, xmm3
%endmacro
%macro M2s_a3c0 0
    vaddsd xmm6, xmm5, xmm1
    vaddsd xmm1, xmm3, xmm6
    vsubsd xmm5, xmm1, xmm3
    vsubsd xmm5, xmm6, xmm5
%endmacro
%macro M2s_a3c1 0
M2s_b53b
%endmacro
%macro M2s_a3c2 0
M2s_b53c
%endmacro
%macro M2s_a3c3 0
M2s_b53d
%endmacro
%macro M2s_a3c4 0
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm2, xmm3
    vmovsd xmm9, [r12 + 968]
    vmovsd xmm8, [r12 + 1000]
M2s_b52d
M2s_b52e
M2s_b52f
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [r12 + 976]
    vmovsd xmm5, [r12 + 1008]
M2s_b526
M2s_b529
M2s_b530
M2s_b539
    vaddsd xmm3, xmm7, xmm6
    vsubsd xmm5, xmm3, xmm7
%endmacro
%macro M2s_a3c5 0
M2s_b53e
M2s_b541
M2s_b532
    vsubsd xmm3, xmm0, xmm3
M2s_b539
    vaddsd xmm3, xmm7, xmm6
    vsubsd xmm5, xmm3, xmm7
    vsubsd xmm5, xmm6, xmm5
%endmacro
%macro M2s_a3c6 0
M2s_b53f
M2s_b542
M2s_b530
M2s_b539
M2s_b53a
%endmacro
%macro M2s_a3c7 0
M2s_b540
M2s_b543
    vsubsd xmm5, xmm7, xmm3
    vsubsd xmm5, xmm4, xmm5
M2s_b544
    vaddsd xmm6, xmm5, xmm3
M2s_b53a
    vaddsd xmm1, xmm3, xmm6
%endmacro
%macro M2s_a3c8 0
    vaddsd xmm1, xmm3, xmm6
    vsubsd xmm5, xmm1, xmm3
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [r12 + 984]
    vmovsd xmm0, [r12 + 1016]
M2s_b53b
M2s_b53c
M2s_b53d
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm0, xmm3, xmm8
    vsubsd xmm0, xmm2, xmm0
    vmovsd [r12 + 1096], xmm3
    vmovsd [r12 + 1128], xmm0
    vmovsd xmm0, [r12 + 1104]
    vmovsd xmm1, [r12 + 1136]
    vmovsd xmm2, [r12 + 1024]
    vmovsd xmm3, [r12 + 1056]
M2s_b512
M2s_b519
M2s_b51c
M2s_b51f
    vsubsd xmm7, xmm1, xmm7
    vsubsd xmm2, xmm9, xmm2
%endmacro
%macro M2s_a3c9 0
M2s_b547
M2s_b54a
M2s_b518
M2s_b51e
M2s_b52b
%endmacro
%macro M2s_a3ca 0
M2s_b548
M2s_b54b
M2s_b519
M2s_b51c
M2s_b51f
M2s_b52a
%endmacro
%macro M2s_a3cb 0
M2s_b549
M2s_b54c
M2s_b51a
M2s_b520
    vsubsd xmm2, xmm9, xmm2
    vaddsd xmm7, xmm7, xmm2
    vaddsd xmm2, xmm3, xmm4
    vaddsd xmm4, xmm5, xmm2
%endmacro
%macro M2s_a3cc 0
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm2, xmm3
    vmovsd xmm9, [r12 + 1032]
    vmovsd xmm8, [r12 + 1064]
M2s_b52d
M2s_b52e
M2s_b52f
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [r12 + 1040]
    vmovsd xmm5, [r12 + 1072]
M2s_b526
M2s_b529
M2s_b530
M2s_b539
    vaddsd xmm3, xmm7, xmm6
    vsubsd xmm5, xmm3, xmm7
%endmacro
%macro M2s_a3cd 0
M2s_b54d
M2s_b550
M2s_b532
M2s_b544
M2s_b546
%endmacro
%macro M2s_a3ce 0
M2s_b54e
M2s_b551
M2s_b530
M2s_b539
M2s_b53a
%endmacro
%macro M2s_a3cf 0
M2s_b54f
M2s_b552
M2s_b545
%endmacro
%macro M2s_a3d0 0
    vaddsd xmm1, xmm3, xmm6
    vsubsd xmm5, xmm1, xmm3
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [r12 + 1048]
    vmovsd xmm0, [r12 + 1080]
M2s_b53b
M2s_b53c
M2s_b53d
M2s_b556
    vfmadd231pd ymm6, ymm1, ymm0
M2s_b4ad
M2s_b55a
    vaddpd ymm1, ymm1, ymm6
    vaddpd ymm6, ymm15, ymm3
%endmacro
%macro M2s_a3d1 0
M2s_b553
M2s_b556
M2s_b559
M2s_b55b
    vsubpd ymm6, ymm2, ymm6
    vaddpd ymm1, ymm1, ymm6
    vaddpd ymm6, ymm15, ymm3
    vsubpd ymm5, ymm6, ymm15
%endmacro
%macro M2s_a3d2 0
M2s_b554
M2s_b557
M2s_b4ad
M2s_b55a
M2s_b55c
%endmacro
%macro M2s_a3d3 0
M2s_b555
M2s_b558
    vaddpd ymm6, ymm4, ymm5
    vsubpd ymm7, ymm6, ymm4
    vsubpd ymm7, ymm5, ymm7
M2s_b55a
M2s_b55c
    vsubpd ymm4, ymm15, ymm4
%endmacro
%macro M2s_a3d4 0
    vsubpd ymm5, ymm6, ymm15
M2s_b55d
M2s_b560
M2s_b563
M2s_b566
    vaddpd ymm1, ymm1, ymm2
    vaddpd ymm2, ymm5, ymm9
    vsubpd ymm10, ymm2, ymm5
%endmacro
%macro M2s_a3d5 0
M2s_b55d
M2s_b560
M2s_b563
M2s_b566
    vaddpd ymm1, ymm1, ymm2
    vaddpd ymm2, ymm5, ymm9
    vsubpd ymm10, ymm2, ymm5
    vsubpd ymm11, ymm2, ymm10
%endmacro
%macro M2s_a3d6 0
M2s_b55e
M2s_b561
M2s_b564
M2s_b567
    vaddpd ymm2, ymm5, ymm9
    vsubpd ymm10, ymm2, ymm5
    vsubpd ymm11, ymm2, ymm10
    vsubpd ymm11, ymm5, ymm11
%endmacro
%macro M2s_a3d7 0
M2s_b55f
M2s_b562
M2s_b565
M2s_b568
    vsubpd ymm10, ymm2, ymm5
    vsubpd ymm11, ymm2, ymm10
    vsubpd ymm11, ymm5, ymm11
    vsubpd ymm10, ymm9, ymm10
%endmacro
%macro M2s_a3d8 0
    vsubpd ymm11, ymm2, ymm10
M2s_b569
M2s_b56c
M2s_b56f
M2s_b572
    vaddpd ymm10, ymm2, ymm4
    vaddpd ymm4, ymm6, ymm10
    vsubpd ymm2, ymm4, ymm6
%endmacro
%macro M2s_a3d9 0
M2s_b569
M2s_b56c
M2s_b56f
M2s_b572
    vaddpd ymm10, ymm2, ymm4
    vaddpd ymm4, ymm6, ymm10
    vsubpd ymm2, ymm4, ymm6
    vsubpd ymm2, ymm10, ymm2
%endmacro
%macro M2s_a3da 0
M2s_b56a
M2s_b56d
M2s_b570
M2s_b573
    vaddpd ymm4, ymm6, ymm10
    vsubpd ymm2, ymm4, ymm6
    vsubpd ymm2, ymm10, ymm2
    vmovapd [r12 + 256], ymm4
%endmacro
%macro M2s_a3db 0
M2s_b56b
M2s_b56e
M2s_b571
M2s_b574
    vsubpd ymm2, ymm4, ymm6
    vsubpd ymm2, ymm10, ymm2
    vmovapd [r12 + 256], ymm4
    vmovapd [r12 + 256 + 32], ymm2
%endmacro
%macro M2s_a3dc 0
    vsubpd ymm2, ymm10, ymm2
M2s_b575
M2s_b578
M2s_b57b
M2s_b57e
    fstp qword [r12 + 0 + 0]
    fldln2
    fld qword [r12 + 0 + 8]
%endmacro
%macro M2s_a3dd 0
M2s_b575
M2s_b578
M2s_b57b
M2s_b57e
    fstp qword [r12 + 0 + 0]
    fldln2
    fld qword [r12 + 0 + 8]
    fyl2x
%endmacro
%macro M2s_a3de 0
M2s_b576
M2s_b579
M2s_b57c
M2s_b57f
    fldln2
    fld qword [r12 + 0 + 8]
    fyl2x
    fstp qword [r12 + 0 + 8]
%endmacro
%macro M2s_a3df 0
M2s_b577
M2s_b57a
M2s_b57d
M2s_b580
    fld qword [r12 + 0 + 8]
    fyl2x
    fstp qword [r12 + 0 + 8]
    fldln2
%endmacro
%macro M2s_a3e0 0
    fyl2x
M2s_b581
M2s_b584
M2s_b587
M2s_b58a
    vaddpd ymm8, ymm2, ymm1
    vaddpd ymm1, ymm5, ymm8
    vsubpd ymm2, ymm1, ymm5
%endmacro
%macro M2s_a3e1 0
M2s_b581
M2s_b584
M2s_b587
M2s_b58a
    vaddpd ymm8, ymm2, ymm1
    vaddpd ymm1, ymm5, ymm8
    vsubpd ymm2, ymm1, ymm5
    vsubpd ymm2, ymm8, ymm2
%endmacro
%macro M2s_a3e2 0
M2s_b582
M2s_b585
M2s_b588
M2s_b58b
    vaddpd ymm1, ymm5, ymm8
    vsubpd ymm2, ymm1, ymm5
    vsubpd ymm2, ymm8, ymm2
    vaddpd ymm8, ymm2, ymm3
%endmacro
%macro M2s_a3e3 0
M2s_b583
M2s_b586
M2s_b589
M2s_b58c
    vsubpd ymm2, ymm1, ymm5
    vsubpd ymm2, ymm8, ymm2
    vaddpd ymm8, ymm2, ymm3
    vaddpd ymm3, ymm1, ymm8
%endmacro
%macro M2s_a3e4 0
    vsubpd ymm2, ymm8, ymm2
M2s_b58d
M2s_b592
    vmovapd ymm14, ymm4
%endmacro
%macro M2s_a3e5 0
M2s_b58d
M2s_b592
    vmovapd ymm14, ymm4
    vmovapd ymm15, ymm5
%endmacro
%macro M2s_a3e6 0
M2s_b58e
M2s_b593
    vmovapd ymm15, ymm5
    call .dexp
%endmacro
%macro M2s_a3e7 0
M2s_b58f
M2s_b594
    vsubpd ymm5, ymm4, ymm2
    vsubpd ymm5, ymm3, ymm5
    vmovapd ymm14, ymm4
    vmovapd ymm15, ymm5
    call .dexp
    vmovapd ymm12, [r12 + 352]
%endmacro
%macro M2s_a3e8 0
M2s_b590
%endmacro
%macro M2s_a3e9 0
M2s_b591
    vsubpd ymm5, ymm3, ymm5
    vmovapd ymm14, ymm4
    vmovapd ymm15, ymm5
M2s_a3eb
    vxorpd ymm14, ymm14, [r12 + 320]
%endmacro
%macro M2s_a3ea 0
    vmovapd ymm15, ymm5
M2s_a3eb
    vxorpd ymm14, ymm14, [r12 + 320]
    vxorpd ymm15, ymm15, [r12 + 320]
    ret
%endmacro
%macro M2s_a3eb 0
    call .dexp
    vmovapd ymm12, [r12 + 352]
    vandnpd ymm14, ymm12, ymm14
    vandnpd ymm15, ymm12, ymm15
%endmacro
%macro M2s_a3ec 0
    vmovapd ymm12, [r12 + 352]
    vandnpd ymm14, ymm12, ymm14
    vandnpd ymm15, ymm12, ymm15
    vxorpd ymm14, ymm14, [r12 + 320]
%endmacro
%macro M2s_a3ed 0
    vandnpd ymm14, ymm12, ymm14
    vandnpd ymm15, ymm12, ymm15
    vxorpd ymm14, ymm14, [r12 + 320]
    vxorpd ymm15, ymm15, [r12 + 320]
%endmacro
%macro M2s_a3ee 0
    vxorpd ymm15, ymm15, [r12 + 320]
    ret
section .note.GNU-stack noalloc noexec nowrite progbits

%endmacro
%macro M2s_a3ef 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 256]
M2s_b119
M2s_b16
M2s_b17
M2s_a3f0
M2s_b1a
M2s_b1c
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b1d
M2s_b1f
M2s_a3f1
M2s_b21
    vpermps ymm1, ymm3, [r8 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_a3f0 0
M2s_b59a
%endmacro
%macro M2s_a3f1 0
M2s_b59b
%endmacro
%macro M2s_a3f2 0
M2s_b59c
%endmacro
%macro M2s_a3f3 0
M2s_a3f2
M2s_b2a
M2s_b2b
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b2c
M2s_b2d
M2s_a3f5
M2s_b2f
M2s_b32
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 148]
M2s_b33
M2s_b36
    vpermps ymm1, ymm3, [r8 + 244]
M2s_a3f6
M2s_b3a
    vpermps ymm1, ymm3, [r8 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a3f4 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b2a
M2s_b2b
M2s_b59e
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
M2s_b5a3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_a3f5 0
M2s_b5a6
%endmacro
%macro M2s_a3f6 0
M2s_b5a7
%endmacro
%macro M2s_a3f7 0
M2s_a3f8
M2s_b48
M2s_b4b
M2s_b4e
M2s_b53
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 252]
M2s_a3f9
M2s_b55
M2s_b57
M2s_b5b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 256]
M2s_a3fa
M2s_b61
    vpermps ymm1, ymm3, [r8 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a3f8 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a3f9 0
M2s_b5a8
%endmacro
%macro M2s_a3fa 0
M2s_b5a9
%endmacro
%macro M2s_a3fb 0
M2s_b5aa
%endmacro
%macro M2s_a3fc 0
M2s_a3fb
    vfmadd231ps ymm4, ymm0, [rcx + 288]
M2s_a3fd
M2s_a400
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 320]
M2s_a404
M2s_a408
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2s_b5ab
%endmacro
%macro M2s_a3fd 0
M2s_b5ac
%endmacro
%macro M2s_a3fe 0
M2s_b5ad
M2s_b5af
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 160]
%endmacro
%macro M2s_a3ff 0
M2s_b5ae
M2s_b5b0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
%endmacro
%macro M2s_a400 0
M2s_b5b1
M2s_a402
%endmacro
%macro M2s_a401 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 192]
M2s_a402
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_a402 0
M2s_b5b2
%endmacro
%macro M2s_a403 0
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 256]
%endmacro
%macro M2s_a404 0
M2s_b5b4
%endmacro
%macro M2s_a405 0
M2s_b5b5
M2s_b5b9
M2s_b5ba
%endmacro
%macro M2s_a406 0
M2s_b5b6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 164]
M2s_b5ba
    vmovdqu ymm3, [rdx + 448]
%endmacro
%macro M2s_a407 0
M2s_b5b7
M2s_b5bc
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 228]
%endmacro
%macro M2s_a408 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 196]
M2s_a40a
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_a409 0
    vpermps ymm1, ymm3, [r13 + 196]
M2s_a40a
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a40a 0
M2s_b5be
%endmacro
%macro M2s_a40b 0
M2s_b5bf
%endmacro
%macro M2s_a40c 0
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 260]
%endmacro
%macro M2s_a40d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a40e 0
M2s_b5ab
M2s_b5c0
M2s_b5c4
%endmacro
%macro M2s_a40f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a410
M2s_a414
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_a415
M2s_a417
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_b5c5
M2s_b5c9
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a410 0
M2s_b5c2
M2s_b5cb
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
%endmacro
%macro M2s_a411 0
M2s_b5c3
M2s_a412
%endmacro
%macro M2s_a412 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 200]
M2s_a413
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_a413 0
M2s_b5cd
%endmacro
%macro M2s_a414 0
M2s_b5ce
%endmacro
%macro M2s_a415 0
M2s_b5cf
%endmacro
%macro M2s_a416 0
M2s_b5d0
M2s_b5d1
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
%endmacro
%macro M2s_a417 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 204]
M2s_a418
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_a418 0
M2s_b5d3
%endmacro
%macro M2s_a419 0
M2s_b5d4
%endmacro
%macro M2s_a41a 0
M2s_b5c5
M2s_b5c9
M2s_b5d5
%endmacro
%macro M2s_a41b 0
M2s_b5c7
M2s_b5d6
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
%endmacro
%macro M2s_a41c 0
M2s_b5c8
    vmovdqu ymm3, [rdx + 352]
M2s_b5d5
M2s_b5d8
%endmacro
%macro M2s_a41d 0
M2s_b5ca
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b5d9
%endmacro
%macro M2s_a41e 0
M2s_b5d9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_a422
M2s_a424
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_a425
M2s_a426
%endmacro
%macro M2s_a41f 0
M2s_b5d8
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_a420 0
M2s_b5da
%endmacro
%macro M2s_a421 0
M2s_b5db
%endmacro
%macro M2s_a422 0
M2s_b5dd
%endmacro
%macro M2s_a423 0
M2s_b5de
    vpermps ymm1, ymm3, [r13 + 180]
M2s_b5df
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a424 0
M2s_b5df
M2s_b5e0
%endmacro
%macro M2s_a425 0
M2s_b5e1
%endmacro
%macro M2s_a426 0
M2s_b5e2
%endmacro
%macro M2s_a427 0
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a428
M2s_a42b
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_a42c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 224]
M2s_a42d
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_b74
    vpermps ymm1, ymm3, [r13 + 100]
%endmacro
%macro M2s_a428 0
M2s_b5e5
%endmacro
%macro M2s_a429 0
M2s_b5e7
    vpermps ymm1, ymm3, [r13 + 188]
M2s_b5e9
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a42a 0
M2s_b5e8
M2s_a42b
%endmacro
%macro M2s_a42b 0
M2s_b5e9
M2s_b5ea
%endmacro
%macro M2s_a42c 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_b6b
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b6f
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_a42d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a42e 0
M2s_b5ed
%endmacro
%macro M2s_a42f 0
M2s_b5e3
M2s_b75
M2s_b5ee
%endmacro
%macro M2s_a430 0
    vpermps ymm1, ymm3, [r13 + 228]
M2s_b5ef
%endmacro
%macro M2s_a431 0
M2s_b5ef
M2s_ba3
M2s_ba5
M2s_ba8
M2s_bad
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 192]
M2s_bae
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b9d
    vpermps ymm1, ymm3, [r9 + 36]
M2s_bb0
M2s_bb2
    vpermps ymm1, ymm3, [r9 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_bb6
M2s_bb7
M2s_a434
%endmacro
%macro M2s_a432 0
M2s_b5fa
%endmacro
%macro M2s_a433 0
M2s_b5f3
M2s_b5f7
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 228]
M2s_a434
M2s_bb9
M2s_bbb
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 136]
M2s_bbc
    vmovdqu ymm3, [rdx + 160]
M2s_bbd
M2s_a436
M2s_bab
    vpermps ymm1, ymm3, [r9 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_a434 0
M2s_b5ff
%endmacro
%macro M2s_a435 0
M2s_b5fb
    vpermps ymm1, ymm3, [r9 + 76]
M2s_bc3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_bc6
M2s_bc5
M2s_a438
M2s_bb4
    vpermps ymm1, ymm3, [r9 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a436 0
M2s_b607
%endmacro
%macro M2s_a437 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_bab
M2s_bc1
M2s_bc3
M2s_b602
M2s_bc9
M2s_bcb
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_bcc
M2s_bcd
M2s_a43a
M2s_bcf
    vpermps ymm1, ymm3, [r9 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_a438 0
M2s_b610
%endmacro
%macro M2s_a439 0
M2s_b606
    vmovdqu ymm3, [rdx + 0]
M2s_bc9
M2s_bcb
M2s_b60b
    vpermps ymm1, ymm3, [r9 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
M2s_bd5
M2s_bd8
M2s_bd9
M2s_a43d
M2s_be7
    vpermps ymm1, ymm3, [r9 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a43a 0
M2s_b619
%endmacro
%macro M2s_a43b 0
M2s_b60f
M2s_bd5
M2s_bd8
M2s_bd9
M2s_b618
M2s_be9
    vpermps ymm1, ymm3, [r9 + 88]
M2s_bee
M2s_beb
    vpermps ymm1, ymm3, [r9 + 184]
M2s_bf5
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 248]
M2s_a43e
M2s_be4
    vpermps ymm1, ymm3, [r9 + 60]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a43c 0
M2s_b618
M2s_be9
M2s_b61a
M2s_b61d
M2s_bf8
M2s_bfb
M2s_b100
M2s_bff
M2s_a440
M2s_bdb
    vpermps ymm1, ymm3, [r9 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a43d 0
M2s_b61f
%endmacro
%macro M2s_a43e 0
M2s_b620
%endmacro
%macro M2s_a43f 0
M2s_b61e
M2s_bde
M2s_b104
M2s_b107
M2s_b109
M2s_a441
    vfmadd231ps ymm6, ymm0, [rcx + 256]
%endmacro
%macro M2s_a440 0
M2s_b621
%endmacro
%macro M2s_a441 0
M2s_b622
%endmacro
%macro M2s_a442 0
M2s_a441
M2s_bf1
M2s_b10b
    vmovdqu ymm3, [rdx + 96]
M2s_b10e
M2s_b10f
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 260]
M2s_a443
    vfmadd231ps ymm6, ymm0, [rcx + 288]
M2s_a444
M2s_b5b1
M2s_b5b2
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 320]
M2s_b5b3
%endmacro
%macro M2s_a443 0
M2s_b624
%endmacro
%macro M2s_a444 0
    lea r13, [r9 + r14]
M2s_b5ad
M2s_b5af
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
%endmacro
%macro M2s_a445 0
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 352]
M2s_b5ab
M2s_b5c0
M2s_b5c4
M2s_b5cc
    vmovdqu ymm3, [rdx + 448]
M2s_b5ce
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_b5cf
M2s_b5d2
    vmovdqu ymm3, [rdx + 448]
M2s_b5d4
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_b5c6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 80]
%endmacro
%macro M2s_a446 0
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_b5dd
M2s_b5df
M2s_b5e0
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_b5e1
M2s_b5e2
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_b5e6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 92]
%endmacro
%macro M2s_a447 0
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b5eb
M2s_b72
M2s_b5ed
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 36]
%endmacro
%macro M2s_a448 0
M2s_a449
M2s_b595
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b16
M2s_b17
M2s_b59a
M2s_b1a
M2s_b1c
M2s_b597
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 232]
M2s_b59b
M2s_b21
%endmacro
%macro M2s_a449 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a44a 0
    vpermps ymm1, ymm3, [r8 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 256]
%endmacro
%macro M2s_a44b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a44c 0
M2s_a44d
M2s_b47
M2s_b4a
M2s_b4d
M2s_b50
M2s_b51
M2s_b5a8
M2s_b55
M2s_b57
M2s_b5b
M2s_b5a
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 288]
M2s_b5f
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 68]
%endmacro
%macro M2s_a44d 0
M2s_b62b
%endmacro
%macro M2s_a44e 0
M2s_b62c
%endmacro
%macro M2s_a44f 0
M2s_a450
M2s_bf0
M2s_b10a
M2s_b10d
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 196]
M2s_b10f
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 260]
M2s_b624
%endmacro
%macro M2s_a450 0
M2s_b62f
%endmacro
%macro M2s_a451 0
M2s_a452
M2s_b161
M2s_b168
M2s_b158
M2s_b169
M2s_b153
M2s_b16b
M2s_b164
    add r9, 288
    dec rcx
M2s_b16c
M2s_b16e
M2s_b16d
M2s_b165
M2s_b139
    vsubps ymm7, ymm5, ymm3
    vcmpps ymm8, ymm6, ymm14, 30
%endmacro
%macro M2s_a452 0
M2s_b159
%endmacro
%macro M2s_a453 0
    vmovups ymm12, [c_q8o2]
M2s_b1cc
M2s_b19e
M2s_b1a2
M2s_b257
M2s_b18f
M2s_b1aa
M2s_b1ad
M2s_b1df
    vblendvps ymm3, ymm7, ymm9, ymm6
    vmovups ymm7, [rax+128]
M2s_b1e4
    vandps ymm6, ymm3, [r9+352]
%endmacro
%macro M2s_a454 0
M2s_a455
M2s_b1f0
M2s_b24f
M2s_b192
M2s_b254
%endmacro
%macro M2s_a455 0
    sub rcx, 2
M2s_b24d
M2s_b1a0
    vpsrld ymm9, ymm1, 20
M2s_b25d
M2s_b1c7
    vfmadd213ps ymm1, ymm7, ymm14
    vmulps ymm3, ymm8, ymm10
%endmacro
%macro M2s_a456 0
M2s_a457
M2s_b633
    vmulps ymm8, ymm4, [r9+320]
M2s_b1e5
M2s_b259
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_mone]
    vmovups ymm13, [c_q8o3]
%endmacro
%macro M2s_a457 0
M2s_b1d7
M2s_b190
M2s_b1a5
M2s_b1ae
M2s_b1b0
M2s_b1e0
%endmacro
%macro M2s_a458 0
    add r9, rbx
M2s_b2a8
M2s_b2ac
M2s_b2a5
M2s_b2ae
M2s_b2b1
    je .ble
    mov qword [rbp + 288], 0
.bl:
%endmacro
%macro M2s_a459 0
    vmovups ymm13, [c_k5]
    vmovups ymm12, [c_mone]
M2s_b36e
    vmovups ymm2, [r8+32]
M2s_b372
M2s_b381
M2s_b374
M2s_b377
M2s_b370
M2s_b378
    jb .fp1s
.fp1e:
M2s_b3a1
M2s_b379
M2s_b371
    vmovups ymm12, [c_mone]
.fp2:
M2s_b37a
    vmovups ymm4, [r14+rdx*4+32]
%endmacro
%macro M2s_a45a 0
M2s_b636
    vaddps ymm0, ymm2, [rcx+rdx*4]
    vmovaps [rbx+rdx*4], ymm2
M2s_b378
M2s_b637
    vmovups ymm14, [c_xflr]
    vmovups ymm13, [c_k5]
M2s_b638
    vmovups ymm2, [r8+128]
    vmovups ymm3, [c_q8e2]
    vmovups ymm4, [r14+rdx*4+32]
    vandps ymm5, ymm0, ymm15
%endmacro
%macro M2s_a45b 0
    vorps ymm10, ymm1, ymm6
    vpsrld ymm8, ymm4, 23
M2s_b37b
M2s_b37e
M2s_b380
M2s_b375
    vpslld ymm0, ymm8, 23
    vpermps ymm3, ymm9, [c_w8e]
%endmacro
%macro M2s_a45c 0
M2s_b639
M2s_b37d
%endmacro
%macro M2s_a45d 0
    mov rax, [rbp + 160]
    imul rax, rax, 1
    add rcx, rax
M2s_b3a6
    vmulps ymm4, ymm4, ymm3
    vfmadd213ps ymm5, ymm4, ymm3
M2s_b3a7
M2s_b38c
M2s_b3a8
    add r8, rax
    mov rax, [rbp + 200]
    imul rax, rax, 2
%endmacro
%macro M2s_a45e 0
M2s_b63a
M2s_b3a4
M2s_b3a7
M2s_b38c
M2s_b3a9
%endmacro
%macro M2s_a45f 0
M2s_b63c
    vfmadd213ps ymm5, ymm4, ymm8
M2s_b63d
M2s_b38b
    imul rax, rax, 2
M2s_b63b
M2s_b3aa
    add r9, rax
    mov r10, [rbp + 136]
%endmacro
%macro M2s_a460 0
    vmovaps ymm10, ymm8
M2s_b3e7
    vpmaxud ymm6, ymm4, ymm14
M2s_b3ec
M2s_b3de
M2s_b3df
M2s_b3ed
    add r8, 288
M2s_b3f2
    mov rdi, [rbp + 136]
%endmacro
%macro M2s_a461 0
    vxorpd ymm11, ymm9, [u_mzero]
M2s_b43b
M2s_b41d
M2s_b42e
M2s_b427
M2s_b437
    vxorpd ymm11, ymm9, [u_mzero]
M2s_b43e
M2s_b440
    vminpd ymm13, ymm13, [u_1023]
    vmovapd ymm1, [u_mone]
%endmacro
%macro M2s_a462 0
    mov eax, edx
M2s_b485
M2s_b487
M2s_b489
M2s_b48c
    vpand ymm9, ymm7, [u_i16]
    vpxor ymm11, ymm11, ymm11
    vpcmpeqq ymm9, ymm9, ymm11
%endmacro
%macro M2s_a463 0
    mov r14, rax
M2s_b4a3
M2s_b46e
M2s_b472
    vshufps xmm1, xmm15, xmm15, 85
M2s_b474
    vfmadd231ss xmm0, xmm1, [rcx + rax + 32]
    vshufps xmm1, xmm15, xmm15, 255
%endmacro
%macro M2s_a464 0
    mov [r12 + 1288], rsi
M2s_b4a4
M2s_b4a7
    vfmadd231pd ymm6, ymm0, ymm3
M2s_b4ad
M2s_b4aa
    vmovsd xmm1, [r12 + 1184]
    vmovsd xmm2, [r12 + 1160]
%endmacro
%macro M2s_a465 0
M2s_a466
    vpermps ymm1, ymm3, [r8 + 288]
M2s_b119
M2s_b16
M2s_b17
M2s_b59a
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b1a
M2s_b1c
M2s_b597
M2s_b628
M2s_b645
%endmacro
%macro M2s_a466 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_a467 0
    vpermps ymm1, ymm3, [r8 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 288]
%endmacro
%macro M2s_a468 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a469 0
    vmovdqu ymm3, [rdx + 256]
M2s_b643
M2s_b1a
M2s_b1c
M2s_b597
M2s_b628
M2s_b645
    vpermps ymm1, ymm3, [r8 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm10
%endmacro
%macro M2s_a46a 0
    vpermps ymm1, ymm3, [r8 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b22
M2s_b26
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b27
M2s_b28
M2s_b59c
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 300]
M2s_b5a4
M2s_b2c
M2s_b2d
M2s_b5a6
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm12
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_a46b 0
M2s_b64a
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b2f
M2s_b32
M2s_b5a2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 244]
M2s_b5a7
M2s_b64f
%endmacro
%macro M2s_a46c 0
M2s_b64f
M2s_b3b
M2s_b3f
M2s_b42
M2s_b45
    vmovdqu ymm3, [rdx + 192]
M2s_b62b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 312]
M2s_b47
M2s_b4a
M2s_b4d
M2s_b50
M2s_b51
M2s_b5a8
M2s_b654
%endmacro
%macro M2s_a46d 0
M2s_b653
M2s_b54
M2s_b59
M2s_b5d
M2s_b5a9
M2s_b655
%endmacro
%macro M2s_a46e 0
M2s_b654
M2s_b4f
M2s_b56
M2s_b58
M2s_b5c
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 256]
M2s_b5a9
M2s_b655
M2s_b62
M2s_b66
M2s_b67
M2s_b69
    vmovdqu ymm3, [rdx + 192]
M2s_b62c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 288]
%endmacro
%macro M2s_a46f 0
M2s_b655
M2s_b62
M2s_b66
M2s_b67
M2s_b69
M2s_b659
M2s_b65a
    vpermps ymm1, ymm3, [r8 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 320]
%endmacro
%macro M2s_a470 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 324]
M2s_b65a
    vpermps ymm1, ymm3, [r8 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 320]
M2s_a47f
M2s_a482
M2s_a485
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a471 0
M2s_b65c
%endmacro
%macro M2s_a472 0
M2s_b65e
M2s_b661
M2s_b662
%endmacro
%macro M2s_a473 0
M2s_b663
%endmacro
%macro M2s_a474 0
M2s_b664
M2s_b667
%endmacro
%macro M2s_a475 0
M2s_b665
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a476 0
M2s_b666
M2s_b668
%endmacro
%macro M2s_a477 0
    vpermps ymm1, ymm3, [r8 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
M2s_a47a
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a478 0
    vmovdqu ymm3, [rdx + 192]
M2s_a47a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 328]
%endmacro
%macro M2s_a479 0
M2s_a47a
M2s_a47e
%endmacro
%macro M2s_a47a 0
    vpermps ymm1, ymm3, [r8 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 296]
%endmacro
%macro M2s_a47b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a47c 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_a47d 0
    vpermps ymm1, ymm3, [r8 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 328]
%endmacro
%macro M2s_a47e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a47f 0
M2s_b669
%endmacro
%macro M2s_a480 0
M2s_b66a
M2s_b66c
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 160]
%endmacro
%macro M2s_a481 0
M2s_b66b
M2s_b66d
%endmacro
%macro M2s_a482 0
M2s_b66e
M2s_b670
%endmacro
%macro M2s_a483 0
M2s_b66f
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_a484 0
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a485
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a485 0
M2s_b671
%endmacro
%macro M2s_a486 0
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 288]
%endmacro
%macro M2s_a487 0
    vmulps ymm5, ymm0, [rcx + 352]
M2s_a488
M2s_a48b
M2s_a48e
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_a48f
M2s_a491
M2s_a493
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 12]
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a488 0
M2s_b672
%endmacro
%macro M2s_a489 0
M2s_b673
M2s_b675
M2s_b676
%endmacro
%macro M2s_a48a 0
M2s_b674
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
M2s_b676
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_a48b 0
M2s_b678
%endmacro
%macro M2s_a48c 0
M2s_b679
M2s_b67a
%endmacro
%macro M2s_a48d 0
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
M2s_a48e
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a48e 0
M2s_b67b
%endmacro
%macro M2s_a48f 0
M2s_b67c
%endmacro
%macro M2s_a490 0
M2s_b67d
M2s_b67e
%endmacro
%macro M2s_a491 0
M2s_b67f
M2s_b680
%endmacro
%macro M2s_a492 0
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
M2s_a493
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a493 0
M2s_b681
%endmacro
%macro M2s_a494 0
M2s_b682
%endmacro
%macro M2s_a495 0
M2s_b683
M2s_b685
M2s_b686
%endmacro
%macro M2s_a496 0
M2s_a495
M2s_a499
    vpermps ymm1, ymm3, [r13 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_a49c
M2s_a49f
M2s_a4a2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_b687
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 84]
%endmacro
%macro M2s_a497 0
M2s_b684
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
M2s_b686
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_a498 0
M2s_b689
%endmacro
%macro M2s_a499 0
M2s_b68a
M2s_b68b
%endmacro
%macro M2s_a49a 0
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
M2s_a49b
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a49b 0
M2s_b68c
%endmacro
%macro M2s_a49c 0
M2s_b68d
%endmacro
%macro M2s_a49d 0
M2s_b68e
M2s_b690
M2s_b691
%endmacro
%macro M2s_a49e 0
M2s_b68f
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b691
    vpermps ymm1, ymm3, [r13 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_a49f 0
M2s_b693
%endmacro
%macro M2s_a4a0 0
M2s_b694
M2s_b696
%endmacro
%macro M2s_a4a1 0
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
M2s_a4a2
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a4a2 0
M2s_b697
%endmacro
%macro M2s_a4a3 0
M2s_b687
M2s_b698
M2s_b69b
%endmacro
%macro M2s_a4a4 0
M2s_b699
M2s_b69c
%endmacro
%macro M2s_a4a5 0
M2s_b69a
    vpermps ymm1, ymm3, [r13 + 180]
M2s_a4a6
M2s_a4a8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a4a9
M2s_a4ab
M2s_a4ad
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_b69e
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a4a6 0
M2s_b69d
M2s_b6a0
%endmacro
%macro M2s_a4a7 0
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
M2s_a4a8
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a4a8 0
M2s_b6a1
%endmacro
%macro M2s_a4a9 0
M2s_b6a2
%endmacro
%macro M2s_a4aa 0
M2s_b6a3
M2s_b6a4
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
%endmacro
%macro M2s_a4ab 0
M2s_b6a5
%endmacro
%macro M2s_a4ac 0
M2s_b6a6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a4ad 0
M2s_b6a7
%endmacro
%macro M2s_a4ae 0
M2s_b69e
M2s_b6a8
%endmacro
%macro M2s_a4af 0
M2s_b69f
M2s_b6a9
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
%endmacro
%macro M2s_a4b0 0
M2s_b6aa
    vpermps ymm1, ymm3, [r13 + 188]
M2s_a4b1
M2s_a4b3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_a4b4
M2s_b5b2
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 256]
M2s_a4b5
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_b5b6
M2s_b5bb
    vmovdqu ymm3, [rdx + 416]
%endmacro
%macro M2s_a4b1 0
M2s_b6ac
%endmacro
%macro M2s_a4b2 0
M2s_b6ad
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a4b3 0
M2s_b6ae
%endmacro
%macro M2s_a4b4 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_b5ae
M2s_b5b0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_a4b5 0
M2s_b6b0
%endmacro
%macro M2s_a4b6 0
M2s_b6ab
M2s_b5b8
M2s_b5bd
%endmacro
%macro M2s_a4b7 0
M2s_b6b1
%endmacro
%macro M2s_a4b8 0
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_a4b9
M2s_b5cd
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 264]
M2s_a4ba
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 328]
M2s_a4bb
M2s_bac
M2s_ba9
M2s_bae
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a4b9 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_b5c2
M2s_b5cb
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 200]
%endmacro
%macro M2s_a4ba 0
M2s_b6b3
%endmacro
%macro M2s_a4bb 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
    vshufps ymm2, ymm4, ymm5, 0x88
    vshufps ymm5, ymm4, ymm5, 0xdd
    vmovaps ymm4, ymm2
M2s_ba5
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a4bc 0
M2s_a4bd
M2s_b6b7
%endmacro
%macro M2s_a4bd 0
    vpermps ymm1, ymm3, [r9 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 256]
%endmacro
%macro M2s_a4be 0
M2s_a4bc
M2s_b9d
M2s_b5f6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 228]
M2s_b5ff
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_bb9
M2s_bbb
M2s_b5fc
M2s_bbf
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 264]
%endmacro
%macro M2s_a4bf 0
M2s_b6bd
%endmacro
%macro M2s_a4c0 0
M2s_a4bf
    vpermps ymm1, ymm3, [r9 + 288]
M2s_b5f4
M2s_bb6
M2s_bb7
M2s_b5ff
M2s_b6bb
M2s_b5fd
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 232]
M2s_b607
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_a4c1 0
    vpermps ymm1, ymm3, [r9 + 256]
M2s_b6b7
M2s_b9d
M2s_b5f6
M2s_b6b8
M2s_b6bf
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 296]
%endmacro
%macro M2s_a4c2 0
M2s_b6bb
M2s_b5fd
M2s_b6be
M2s_b6c1
M2s_b609
M2s_bc6
M2s_bc5
M2s_b610
M2s_b6c5
%endmacro
%macro M2s_a4c3 0
M2s_b6c3
M2s_bb3
M2s_b611
M2s_bcd
M2s_b619
M2s_b6c6
%endmacro
%macro M2s_a4c4 0
M2s_b6c4
M2s_bb4
M2s_bc9
M2s_bcb
M2s_b60a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 240]
M2s_b619
M2s_b6c6
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_a4c5 0
M2s_b6c5
M2s_bb5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 80]
M2s_bcb
M2s_b60a
M2s_b6c7
    vpermps ymm1, ymm3, [r9 + 304]
M2s_bce
M2s_bd5
M2s_bd8
M2s_bd9
M2s_b61f
M2s_b6cd
%endmacro
%macro M2s_a4c6 0
M2s_b6c6
M2s_bd1
M2s_b617
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 244]
M2s_b61f
M2s_b6cd
M2s_be8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
M2s_b61a
M2s_b620
M2s_b6d4
%endmacro
%macro M2s_a4c7 0
M2s_b6cd
M2s_be8
M2s_b6d2
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 248]
M2s_b620
M2s_b6d4
M2s_bfd
M2s_b102
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 252]
M2s_b621
M2s_b6da
%endmacro
%macro M2s_a4c8 0
M2s_b6d4
M2s_bfd
M2s_b102
M2s_b6d8
M2s_be5
M2s_be0
M2s_b104
M2s_b107
M2s_b109
M2s_b622
M2s_b6db
%endmacro
%macro M2s_a4c9 0
M2s_b6da
M2s_bdd
M2s_b105
M2s_b108
    vmovdqu ymm3, [rdx + 192]
M2s_b62f
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b6db
M2s_bf2
M2s_b10c
M2s_b10e
M2s_b10f
M2s_b62e
M2s_b6df
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 288]
%endmacro
%macro M2s_a4ca 0
M2s_b6db
M2s_bf2
M2s_b10c
M2s_b10e
M2s_b10f
M2s_b62e
M2s_b6df
M2s_b6e1
    vpermps ymm1, ymm3, [r9 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 320]
%endmacro
%macro M2s_a4cb 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 324]
M2s_b6e1
    vpermps ymm1, ymm3, [r9 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 320]
M2s_a4da
M2s_b66e
M2s_b670
M2s_b671
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a4cc 0
M2s_b6e2
%endmacro
%macro M2s_a4cd 0
M2s_b6e4
M2s_b6e7
M2s_b6e9
%endmacro
%macro M2s_a4ce 0
M2s_b6e5
M2s_b6e8
M2s_b6ea
%endmacro
%macro M2s_a4cf 0
M2s_b6eb
%endmacro
%macro M2s_a4d0 0
M2s_b6ec
M2s_b6ef
%endmacro
%macro M2s_a4d1 0
M2s_b6ed
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a4d2 0
M2s_b6ee
M2s_b6f0
%endmacro
%macro M2s_a4d3 0
    vpermps ymm1, ymm3, [r9 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
M2s_a4d5
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a4d4 0
    vmovdqu ymm3, [rdx + 192]
M2s_b6f1
%endmacro
%macro M2s_a4d5 0
M2s_b6f2
%endmacro
%macro M2s_a4d6 0
M2s_b6f1
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a4d7 0
M2s_b6f3
%endmacro
%macro M2s_a4d8 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_a4d9 0
    vpermps ymm1, ymm3, [r9 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 328]
%endmacro
%macro M2s_a4da 0
    lea r13, [r9 + r14]
M2s_b66a
M2s_b66c
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
%endmacro
%macro M2s_a4db 0
    vmulps ymm7, ymm0, [rcx + 352]
M2s_b672
M2s_b678
M2s_b67b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_b67c
M2s_b67f
M2s_b680
M2s_b681
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 12]
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a4dc 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_b68d
M2s_b693
M2s_b697
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_b687
M2s_b698
M2s_b69b
M2s_b69d
M2s_b6a0
M2s_b6a1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 24]
%endmacro
%macro M2s_a4dd 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b69e
M2s_b6a8
M2s_b6ac
M2s_b6ae
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_b6af
M2s_b5b2
M2s_a4de
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 36]
%endmacro
%macro M2s_a4de 0
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 256]
M2s_b6b0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 320]
%endmacro
%macro M2s_a4df 0
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 260]
M2s_b6b1
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 324]
%endmacro
%macro M2s_a4e0 0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_b6b2
M2s_b5cd
M2s_a4e1
%endmacro
%macro M2s_a4e1 0
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 264]
M2s_b6b3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 328]
%endmacro
%macro M2s_a4e2 0
M2s_a4e3
M2s_b11b
    vaddps ymm0, ymm6, ymm7
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r11 + 0], ymm0
M2s_b11c
M2s_b11d
M2s_b122
M2s_b116
    vpermps ymm1, ymm3, [r8 + 32]
%endmacro
%macro M2s_a4e3 0
M2s_b6fc
%endmacro
%macro M2s_a4e4 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 236]
M2s_b59c
M2s_b64a
M2s_b64b
M2s_b34
M2s_b35
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a4e5 0
M2s_b650
%endmacro
%macro M2s_a4e6 0
M2s_b652
%endmacro
%macro M2s_a4e7 0
M2s_b658
%endmacro
%macro M2s_a4e8 0
    vmovdqu ymm3, [rdx + 192]
M2s_b6fd
%endmacro
%macro M2s_a4e9 0
M2s_b6d5
%endmacro
%macro M2s_a4ea 0
M2s_b6fd
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a4eb 0
M2s_a4ec
M2s_b6df
%endmacro
%macro M2s_a4ec 0
M2s_b62e
%endmacro
%macro M2s_a4ed 0
    vmovaps ymm6, ymm2
M2s_b123
    vpermpd ymm4, ymm4, 0xd8
    vpermpd ymm5, ymm5, 0xd8
M2s_b121
M2s_b126
M2s_b127
    mov [rbp + 232], rax
    mov rcx, [rdi + G_wo]
M2s_b128
    cmp rcx, rdx
    cmova rcx, rdx
M2s_b129
M2s_b12a
    vmovaps ymm15, [c_epsf]
%endmacro
%macro M2s_a4ee 0
    vmovups ymm13, [c_q8o3]
M2s_b631
M2s_b1de
M2s_b1b1
M2s_b1e1
M2s_b1da
M2s_b1ba
    vfmadd231ps ymm4, ymm9, ymm0
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+320]
%endmacro
%macro M2s_a4ef 0
    vmovups ymm12, [c_q8o2]
.i2l1:
M2s_b1f9
M2s_b1a3
M2s_b1f6
M2s_b190
M2s_b1a5
M2s_b1ae
M2s_b1b0
    vpermps ymm4, ymm10, [c_rxo]
    vorps ymm10, ymm11, ymm3
M2s_b1fb
M2s_b1fe
M2s_b1ba
M2s_b701
%endmacro
%macro M2s_a4f0 0
M2s_b257
M2s_b18f
M2s_b1aa
M2s_b1ad
M2s_b1df
M2s_b632
M2s_b1db
M2s_b1e7
    sub rcx, 2
M2s_b258
    jz .i2c0e
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_mone]
%endmacro
%macro M2s_a4f1 0
    vmovups ymm12, [c_q8o2]
M2s_b25b
M2s_b1ef
M2s_b1d3
M2s_b263
    vpsrld ymm9, ymm1, 20
    vpermps ymm10, ymm9, [c_w8o]
    vpermps ymm11, ymm9, [c_rxo]
%endmacro
%macro M2s_a4f2 0
M2s_b406
M2s_b3fb
    ret
.t1l:
    vcvtps2pd ymm0, [rdi + 196608]
M2s_b418
M2s_b3fc
    vmovapd ymm13, [r15 + G_dlo]
    vmovapd ymm14, [r15 + G_dhi]
M2s_b419
M2s_b400
M2s_b40d
M2s_b413
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm8, [rax + ymm7*8 + u_ob - u_rx], ymm9
    vmulpd ymm6, ymm6, ymm8
%endmacro
%macro M2s_a4f3 0
    cmovne edx, esi
M2s_b63e
M2s_b486
M2s_b488
M2s_b48b
    vgatherqpd ymm10, [rax + ymm9*8 + u_tsl - u_rx], ymm11
    vpand ymm9, ymm7, [u_i16]
    vpxor ymm11, ymm11, ymm11
%endmacro
%macro M2s_a4f4 0
    div r9
M2s_b63f
M2s_b46d
M2s_b471
    vmulss xmm0, xmm15, [rcx + rax + 32]
M2s_b640
    mov rcx, [r12 + 1360]
    vfmadd231ss xmm0, xmm1, [rcx + rax + 32]
%endmacro
%macro M2s_a4f5 0
    inc rsi
M2s_b641
M2s_b4a6
    vmulpd ymm6, ymm1, ymm2
M2s_b642
M2s_b4ab
    vmovsd xmm0, [r12 + 1152]
    vmovsd xmm1, [r12 + 1184]
%endmacro
%macro M2s_a4f6 0
    vpermps ymm1, ymm3, [r8 + 292]
M2s_b65b
M2s_b65f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 168]
%endmacro
%macro M2s_a4f7 0
    vfmadd231ps ymm4, ymm0, [rcx + 320]
M2s_b5ac
M2s_b5b1
M2s_b5b2
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 352]
M2s_b5b4
M2s_b5ba
M2s_b5bf
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_b5ab
M2s_b5c1
%endmacro
%macro M2s_a4f8 0
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_b5cf
M2s_b5d2
M2s_b627
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_b5c5
M2s_b5c9
M2s_b5d5
M2s_b5d7
    vmovdqu ymm3, [rdx + 448]
M2s_b5db
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_b5dc
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 84]
%endmacro
%macro M2s_a4f9 0
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_b5e1
M2s_b5e2
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_b5e5
M2s_b5e9
M2s_b5ea
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_b5ec
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 96]
%endmacro
%macro M2s_a4fa 0
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_b5e3
M2s_b75
M2s_b5ee
M2s_b78
M2s_b5fa
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_a4fb
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 232]
M2s_a4fc
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 296]
M2s_b6b4
    vpermps ymm1, ymm3, [r9 + 32]
%endmacro
%macro M2s_a4fb 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_b7b
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b7d
    vpermps ymm1, ymm3, [r13 + 200]
%endmacro
%macro M2s_a4fc 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a4fd 0
M2s_b70a
%endmacro
%macro M2s_a4fe 0
M2s_a4ff
M2s_b6eb
M2s_b6f2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 320]
M2s_b625
M2s_b5b1
M2s_b5b2
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 352]
M2s_b5b3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a4ff 0
    vpermps ymm1, ymm3, [r9 + 292]
M2s_b6e3
M2s_b6e6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 168]
%endmacro
%macro M2s_a500 0
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_b5ab
M2s_b5c0
M2s_b5c4
M2s_b5cc
M2s_b626
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_b5cf
M2s_b5d2
M2s_b627
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_b5c5
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_a501 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_b5dd
M2s_b5df
M2s_b5e0
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_b5e1
M2s_b5e2
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b5e4
%endmacro
%macro M2s_a502 0
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_b5eb
M2s_b72
M2s_b5ed
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_b5e3
M2s_b75
M2s_b5ee
M2s_b78
M2s_b5fa
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_b709
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 104]
%endmacro
%macro M2s_a503 0
    vpermps ymm1, ymm3, [r13 + 296]
M2s_b6fc
    vmovaps ymm6, ymm2
    vaddps ymm0, ymm4, ymm5
    vpermpd ymm0, ymm0, 0xd8
%endmacro
%macro M2s_a504 0
M2s_b6ca
%endmacro
%macro M2s_a505 0
M2s_b6d9
%endmacro
%macro M2s_a506 0
    vmovups ymm13, [c_q8o3]
M2s_b704
M2s_b1f2
    add rdx, 224
    add r9, 288
    dec rcx
M2s_b25e
M2s_b19e
M2s_b1a2
%endmacro
%macro M2s_a507 0
M2s_b1f6
M2s_b190
M2s_b1a5
M2s_b1ae
M2s_b1b0
M2s_b700
M2s_b1bc
    vmulps ymm8, ymm4, [r9+416]
M2s_b1ff
M2s_b268
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_mone]
    vmovups ymm13, [c_q8o3]
%endmacro
%macro M2s_a508 0
M2s_b64e
M2s_b39
M2s_b3e
M2s_b40
    vpermps ymm1, ymm3, [r8 + 184]
M2s_b45
M2s_b651
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 284]
%endmacro
%macro M2s_a509 0
M2s_b656
%endmacro
%macro M2s_a50a 0
M2s_a509
M2s_b5e
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 196]
M2s_b69
M2s_b659
M2s_b65c
M2s_b664
M2s_b667
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a50b 0
M2s_b657
%endmacro
%macro M2s_a50c 0
M2s_a50d
M2s_a510
M2s_a512
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2s_b669
M2s_b66e
M2s_b670
M2s_b671
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 384]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a50d 0
M2s_b710
M2s_b712
    vpermps ymm1, ymm3, [r8 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 204]
%endmacro
%macro M2s_a50e 0
M2s_b713
%endmacro
%macro M2s_a50f 0
M2s_b714
M2s_b716
%endmacro
%macro M2s_a510 0
M2s_b715
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a511 0
M2s_b717
%endmacro
%macro M2s_a512 0
    vpermps ymm1, ymm3, [r8 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 332]
%endmacro
%macro M2s_a513 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_b67c
M2s_b67f
M2s_b680
M2s_b681
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_b682
M2s_b689
M2s_b68c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 16]
%endmacro
%macro M2s_a514 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_b687
M2s_b698
M2s_b69b
M2s_b69d
M2s_b6a0
M2s_b6a1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_b6a2
M2s_b6a5
M2s_b6a7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 28]
%endmacro
%macro M2s_a515 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_b6af
M2s_b5b2
M2s_b6f5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_b6ab
M2s_b5b8
M2s_b5bd
M2s_b5be
M2s_b6f6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 40]
%endmacro
%macro M2s_a516 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_a517
M2s_b5d3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 268]
M2s_a518
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 332]
M2s_a51a
    vpermps ymm1, ymm3, [r9 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a517 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_b5d0
M2s_b5d1
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 204]
%endmacro
%macro M2s_a518 0
M2s_b719
%endmacro
%macro M2s_a519 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_b6b5
M2s_b71c
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a51a 0
M2s_a519
M2s_bac
M2s_ba9
M2s_bae
M2s_b6bd
%endmacro
%macro M2s_a51b 0
M2s_b6c2
%endmacro
%macro M2s_a51c 0
M2s_a51b
M2s_bab
M2s_bc1
M2s_bc3
M2s_b601
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 236]
M2s_b610
M2s_b6c5
M2s_bb5
M2s_b6cb
M2s_b6c8
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a51d 0
M2s_b6cf
%endmacro
%macro M2s_a51e 0
M2s_b6d1
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b6d4
M2s_bfd
M2s_b102
M2s_b6d7
    vpermps ymm1, ymm3, [r9 + 284]
%endmacro
%macro M2s_a51f 0
M2s_b6dc
%endmacro
%macro M2s_a520 0
M2s_a51f
M2s_bf0
M2s_b10a
M2s_b10d
M2s_b62d
M2s_b624
M2s_b6e0
M2s_b6e5
M2s_b6e8
M2s_b6ea
M2s_b6ee
M2s_b6f0
%endmacro
%macro M2s_a521 0
M2s_b6de
%endmacro
%macro M2s_a522 0
M2s_b721
M2s_b723
    vpermps ymm1, ymm3, [r9 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a523
M2s_a525
M2s_b724
M2s_b6f4
M2s_b66e
M2s_b670
M2s_b671
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 384]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a523 0
M2s_b725
%endmacro
%macro M2s_a524 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 268]
M2s_a525
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 332]
%endmacro
%macro M2s_a525 0
M2s_b726
%endmacro
%macro M2s_a526 0
M2s_b727
%endmacro
%macro M2s_a527 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_b67c
M2s_b67f
M2s_b680
M2s_b681
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_b682
M2s_b689
M2s_b68c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 16]
%endmacro
%macro M2s_a528 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_b687
M2s_b698
M2s_b69b
M2s_b69d
M2s_b6a0
M2s_b6a1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b6a2
M2s_b6a5
M2s_b6a7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 28]
%endmacro
%macro M2s_a529 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_b6af
M2s_b5b2
M2s_b6f5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_b6ab
M2s_b5b8
M2s_b5bd
M2s_b5be
M2s_b6f6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 40]
%endmacro
%macro M2s_a52a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_b718
M2s_b5d3
M2s_a52b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
%endmacro
%macro M2s_a52b 0
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 268]
M2s_b719
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 332]
%endmacro
%macro M2s_a52c 0
M2s_b729
%endmacro
%macro M2s_a52d 0
M2s_a52c
M2s_b11b
M2s_b6f7
    vmovaps ymm14, ymm5
M2s_b11f
    vpermps ymm0, ymm3, [r8 + 0]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 32]
%endmacro
%macro M2s_a52e 0
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_b118
M2s_b114
M2s_b6fb
M2s_b117
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a52f 0
    vpermps ymm1, ymm3, [r8 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b64f
M2s_b3b
M2s_b3f
M2s_b42
M2s_b45
M2s_b651
M2s_b5a8
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 316]
%endmacro
%macro M2s_a530 0
M2s_a531
M2s_b713
M2s_b717
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 352]
%endmacro
%macro M2s_a531 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 320]
M2s_b710
M2s_b712
    vpermps ymm1, ymm3, [r8 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a532 0
M2s_b72d
M2s_b711
%endmacro
%macro M2s_a533 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_a534 0
M2s_b6c8
%endmacro
%macro M2s_a535 0
M2s_b72e
%endmacro
%macro M2s_a536 0
M2s_b6d8
%endmacro
%macro M2s_a537 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b6da
M2s_bdd
M2s_b105
M2s_b108
M2s_b6dd
M2s_b624
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a538 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 320]
M2s_b721
M2s_b723
    vpermps ymm1, ymm3, [r9 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a539 0
M2s_a538
M2s_b725
M2s_b726
M2s_b724
%endmacro
%macro M2s_a53a 0
    add r9, 576
M2s_b634
M2s_b19f
M2s_b1ce
M2s_b1c5
    vpsubd ymm7, ymm0, ymm9
    vblendvps ymm8, ymm2, ymm6, ymm4
    vfmadd213ps ymm1, ymm7, ymm14
%endmacro
%macro M2s_a53b 0
M2s_a53a
M2s_b1cf
M2s_b1d4
M2s_b255
M2s_b253
%endmacro
%macro M2s_a53c 0
M2s_b266
M2s_b18f
M2s_b1aa
M2s_b1ad
    vpslld ymm0, ymm4, 23
M2s_b700
M2s_b1bc
M2s_b70d
M2s_b267
    jz .i2c1e
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_mone]
%endmacro
%macro M2s_a53d 0
    vmovups ymm12, [c_q8o2]
M2s_b26b
M2s_b207
M2s_b1d3
M2s_b26d
M2s_b274
M2s_b276
    vmovaps ymm3, [c_half]
    vmovdqu ymm13, [c_i512]
M2s_b280
    vmulps ymm0, ymm5, [r8]
%endmacro
%macro M2s_a53e 0
    mov rcx, r10
    lea rsi, [rbp + 384]
M2s_b296
M2s_b287
M2s_b28b
M2s_b28d
    vpcmpeqb ymm1, ymm7, [rdi + G_ms + 0]
    vpcmpeqb ymm2, ymm7, [rdi + G_ms + 32]
M2s_b299
M2s_b28f
    pext rdx, r12, rdx
    vmovq xmm0, rdx
M2s_b29b
M2s_b29d
    vpermps ymm1, ymm0, [rdx + 64]
    vmovups [r8 + r9*4 + 131072], ymm1
%endmacro
%macro M2s_a53f 0
M2s_b3be
M2s_b342
    lea r15, [r13 - 16]
    vmovups ymm15, [c_absm]
.fp0:
M2s_b346
M2s_b349
M2s_b34a
    cmp rdx, r15
%endmacro
%macro M2s_a540 0
    vpermps ymm1, ymm3, [r8 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 320]
%endmacro
%macro M2s_a541 0
M2s_a540
M2s_b119
M2s_b16
M2s_b17
M2s_b59a
M2s_a544
    vpermps ymm1, ymm3, [r8 + 324]
M2s_b644
M2s_b1d
M2s_b1f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 264]
%endmacro
%macro M2s_a542 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a543 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 320]
M2s_b119
M2s_b16
M2s_b17
M2s_b59a
M2s_b736
M2s_b598
M2s_b629
    vpermps ymm1, ymm3, [r8 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_a544 0
M2s_b737
%endmacro
%macro M2s_a545 0
M2s_a546
    vpermps ymm1, ymm3, [r8 + 328]
M2s_b646
M2s_b27
M2s_b28
M2s_b59c
M2s_a548
    vpermps ymm1, ymm3, [r8 + 332]
M2s_b5a4
M2s_b2c
M2s_b2d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a546 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a547 0
    vpermps ymm1, ymm3, [r8 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
M2s_b738
M2s_b2a
M2s_b2b
M2s_b59d
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b73c
    vpermps ymm1, ymm3, [r8 + 272]
%endmacro
%macro M2s_a548 0
M2s_b73d
%endmacro
%macro M2s_a549 0
M2s_b73e
%endmacro
%macro M2s_a54a 0
M2s_a549
    vpermps ymm1, ymm3, [r8 + 336]
M2s_b64b
M2s_b34
M2s_b35
M2s_b5a7
M2s_a54c
    vpermps ymm1, ymm3, [r8 + 340]
M2s_b38
M2s_b44
M2s_b46
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a54b 0
M2s_b741
%endmacro
%macro M2s_a54c 0
M2s_b742
%endmacro
%macro M2s_a54d 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 312]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a54e 0
M2s_a54d
    vpermps ymm1, ymm3, [r8 + 344]
M2s_b47
M2s_b4a
M2s_b4d
M2s_b50
M2s_b51
M2s_b5a8
M2s_a551
    vpermps ymm1, ymm3, [r8 + 348]
M2s_b54
M2s_b59
M2s_b5d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a54f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a550 0
    vmovdqu ymm3, [rdx + 288]
M2s_b743
M2s_b55
M2s_b57
M2s_b5b
M2s_b5a
M2s_b746
%endmacro
%macro M2s_a551 0
M2s_b747
%endmacro
%macro M2s_a552 0
M2s_a553
    vpermps ymm1, ymm3, [r8 + 352]
M2s_b5e
M2s_b70f
M2s_b5aa
M2s_a557
    vpermps ymm1, ymm3, [r8 + 356]
M2s_b65c
M2s_b664
M2s_b667
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a553 0
M2s_b74a
%endmacro
%macro M2s_a554 0
    vpermps ymm1, ymm3, [r8 + 320]
M2s_a555
M2s_b60
M2s_b65
    vmovdqu ymm3, [rdx + 96]
M2s_b67
M2s_b69
M2s_b658
    vpermps ymm1, ymm3, [r8 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b749
M2s_b662
M2s_b666
M2s_b668
    vpermps ymm1, ymm3, [r8 + 296]
%endmacro
%macro M2s_a555 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a556 0
    vmovdqu ymm3, [rdx + 288]
M2s_b748
M2s_b65d
M2s_b660
    vmovdqu ymm3, [rdx + 96]
M2s_b662
M2s_b666
M2s_b668
    vpermps ymm1, ymm3, [r8 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_a557 0
M2s_b74e
%endmacro
%macro M2s_a558 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a559 0
M2s_a55a
M2s_b72c
M2s_b713
M2s_b717
%endmacro
%macro M2s_a55a 0
    vpermps ymm1, ymm3, [r8 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 360]
%endmacro
%macro M2s_a55b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a55c 0
M2s_a55b
M2s_b72d
M2s_b711
M2s_b714
M2s_b716
M2s_b74f
%endmacro
%macro M2s_a55d 0
M2s_a55e
M2s_a561
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2s_b750
    vpermps ymm1, ymm3, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a564
M2s_b752
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a55e 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 360]
M2s_b72c
M2s_b713
M2s_b717
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 332]
%endmacro
%macro M2s_a55f 0
M2s_b753
%endmacro
%macro M2s_a560 0
M2s_b754
%endmacro
%macro M2s_a561 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a562 0
M2s_b750
    vpermps ymm1, ymm3, [r13 + 32]
M2s_b755
    vpermps ymm1, ymm3, [r13 + 320]
%endmacro
%macro M2s_a563 0
M2s_b751
M2s_b755
    vpermps ymm1, ymm3, [r13 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a564 0
M2s_b756
%endmacro
%macro M2s_a565 0
M2s_b752
M2s_b758
%endmacro
%macro M2s_a566 0
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 288]
M2s_a568
%endmacro
%macro M2s_a567 0
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 288]
M2s_a568
    vmulps ymm5, ymm0, [rcx + 384]
M2s_a569
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_b759
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a56f
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_a568 0
M2s_b75a
%endmacro
%macro M2s_a569 0
M2s_b75b
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a56a
M2s_a56b
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a56a 0
M2s_b75c
%endmacro
%macro M2s_a56b 0
M2s_b75d
M2s_a56d
%endmacro
%macro M2s_a56c 0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 260]
M2s_a56d
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 324]
%endmacro
%macro M2s_a56d 0
M2s_b75e
%endmacro
%macro M2s_a56e 0
M2s_b759
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a56f
M2s_a570
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a56f 0
M2s_b75f
%endmacro
%macro M2s_a570 0
M2s_b760
%endmacro
%macro M2s_a571 0
M2s_a572
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_a574
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_b762
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a578
    vpermps ymm1, ymm3, [r13 + 240]
%endmacro
%macro M2s_a572 0
M2s_b761
M2s_a573
%endmacro
%macro M2s_a573 0
M2s_b763
%endmacro
%macro M2s_a574 0
M2s_b764
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a575
M2s_a576
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a575 0
M2s_b765
%endmacro
%macro M2s_a576 0
M2s_b766
%endmacro
%macro M2s_a577 0
M2s_b762
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a578
M2s_a579
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a578 0
M2s_b767
%endmacro
%macro M2s_a579 0
M2s_b768
%endmacro
%macro M2s_a57a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
M2s_a57b
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a57d
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_b76a
M2s_b76e
%endmacro
%macro M2s_a57b 0
M2s_b769
M2s_a57c
%endmacro
%macro M2s_a57c 0
M2s_b76f
%endmacro
%macro M2s_a57d 0
M2s_b770
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a57e
M2s_a57f
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a57e 0
M2s_b771
%endmacro
%macro M2s_a57f 0
M2s_b772
%endmacro
%macro M2s_a580 0
M2s_b76b
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a581
M2s_b773
%endmacro
%macro M2s_a581 0
M2s_b76c
M2s_b76d
M2s_b774
%endmacro
%macro M2s_a582 0
    vmovdqu ymm3, [rdx + 512]
M2s_b773
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_a584
    vfmadd231ps ymm5, ymm0, [rcx + 608]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_b66b
M2s_b66d
%endmacro
%macro M2s_a583 0
M2s_b776
%endmacro
%macro M2s_a584 0
M2s_b777
%endmacro
%macro M2s_a585 0
M2s_b775
M2s_b670
M2s_b671
M2s_b77c
%endmacro
%macro M2s_a586 0
M2s_b77d
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_a587
    vfmadd231ps ymm5, ymm0, [rcx + 672]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_b67d
M2s_b67e
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_a587 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_b674
M2s_b677
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b67a
M2s_b781
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a588 0
M2s_b77e
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b680
M2s_b681
M2s_b784
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a589 0
M2s_b785
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_a58a
M2s_b71b
M2s_ba6
M2s_ba8
M2s_bad
M2s_b5f0
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a58a 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_b684
M2s_b688
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b68b
M2s_b788
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a58b 0
M2s_b789
%endmacro
%macro M2s_a58c 0
M2s_a58b
M2s_b5f4
M2s_bb6
M2s_bb7
M2s_b5ff
M2s_a58e
    vpermps ymm1, ymm3, [r9 + 324]
M2s_b6bc
M2s_bbe
M2s_bbd
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 264]
%endmacro
%macro M2s_a58d 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 320]
M2s_b5f4
M2s_bb6
M2s_bb7
M2s_b5ff
M2s_b78a
M2s_b5fd
M2s_b6be
    vpermps ymm1, ymm3, [r9 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_a58e 0
M2s_b78b
%endmacro
%macro M2s_a58f 0
    vpermps ymm1, ymm3, [r9 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 324]
%endmacro
%macro M2s_a590 0
M2s_b78c
%endmacro
%macro M2s_a591 0
    vpermps ymm1, ymm3, [r9 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 328]
M2s_b609
M2s_bc6
M2s_bc5
M2s_b610
M2s_a593
    vpermps ymm1, ymm3, [r9 + 332]
M2s_bb3
M2s_b611
M2s_bcd
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 272]
%endmacro
%macro M2s_a592 0
M2s_b78d
M2s_bb3
M2s_b611
M2s_bcd
M2s_b619
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_a593 0
M2s_b78e
%endmacro
%macro M2s_a594 0
M2s_b78f
%endmacro
%macro M2s_a595 0
    vpermps ymm1, ymm3, [r9 + 304]
M2s_a596
M2s_bcf
M2s_b615
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b6ce
    vpermps ymm1, ymm3, [r9 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a598
    vpermps ymm1, ymm3, [r9 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_be6
M2s_bee
M2s_beb
M2s_b61c
M2s_bf7
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 280]
%endmacro
%macro M2s_a596 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a597 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 336]
M2s_bce
M2s_bd5
M2s_bd8
M2s_bd9
M2s_b61f
M2s_b791
    vpermps ymm1, ymm3, [r9 + 152]
M2s_bf3
M2s_bed
M2s_b6d5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_a598 0
M2s_b794
%endmacro
%macro M2s_a599 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a59a 0
M2s_b795
%endmacro
%macro M2s_a59b 0
M2s_a59a
    vpermps ymm1, ymm3, [r9 + 344]
M2s_be3
M2s_bf8
M2s_bfb
M2s_b100
M2s_bff
M2s_b621
M2s_a59e
    vpermps ymm1, ymm3, [r9 + 348]
M2s_be5
M2s_be0
M2s_b104
M2s_b107
M2s_b109
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a59c 0
    vpermps ymm1, ymm3, [r9 + 312]
M2s_a59d
M2s_be4
M2s_bf9
M2s_bfc
M2s_b101
M2s_b103
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b797
    vpermps ymm1, ymm3, [r9 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b107
M2s_b109
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 288]
%endmacro
%macro M2s_a59d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a59e 0
M2s_b79b
%endmacro
%macro M2s_a59f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5a0 0
M2s_b79c
%endmacro
%macro M2s_a5a1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5a2 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 352]
M2s_bf0
M2s_b10a
M2s_b10d
M2s_b62d
M2s_b624
M2s_a5a3
    vpermps ymm1, ymm3, [r9 + 356]
M2s_b6e2
M2s_b6ec
M2s_b6ef
M2s_b6f3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_a5a3 0
M2s_b79f
%endmacro
%macro M2s_a5a4 0
M2s_b7a0
%endmacro
%macro M2s_a5a5 0
M2s_b7a1
%endmacro
%macro M2s_a5a6 0
M2s_a5a5
    vpermps ymm1, ymm3, [r9 + 360]
M2s_b730
M2s_b725
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 300]
%endmacro
%macro M2s_a5a7 0
    vpermps ymm1, ymm3, [r9 + 328]
M2s_a5a9
M2s_b731
M2s_b722
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b725
M2s_b726
%endmacro
%macro M2s_a5a8 0
M2s_a5a7
M2s_a5ab
    vpermps ymm1, ymm3, [r9 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 352]
    lea r13, [r9 + r14]
M2s_b751
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b756
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_a5a9 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5aa 0
    vmovdqu ymm3, [rdx + 288]
M2s_b7a2
M2s_b7a4
    vpermps ymm1, ymm3, [r9 + 268]
M2s_b726
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 332]
%endmacro
%macro M2s_a5ab 0
M2s_b7a8
%endmacro
%macro M2s_a5ac 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5ad 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 352]
%endmacro
%macro M2s_a5ae 0
M2s_b7a5
M2s_b757
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
M2s_b752
M2s_b758
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 320]
%endmacro
%macro M2s_a5af 0
    vmulps ymm7, ymm0, [rcx + 384]
M2s_b75b
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b75c
M2s_b75d
M2s_b75e
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_b759
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b75f
M2s_b760
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a5b0 0
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_b764
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b765
M2s_b766
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_b762
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b767
M2s_b768
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a5b1 0
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_b770
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b771
M2s_b772
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b76a
M2s_b76e
    vmovdqu ymm3, [rdx + 512]
M2s_b776
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a5b2 0
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_b777
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_b775
M2s_b670
M2s_b671
M2s_b77b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a5b3 0
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_b77f
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_b77e
M2s_b782
    vpermps ymm1, ymm3, [r13 + 296]
M2s_b784
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a5b4 0
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_b787
M2s_b68a
M2s_b68b
M2s_b788
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 364]
%endmacro
%macro M2s_a5b5 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b73e
M2s_b73f
M2s_b33
M2s_b36
M2s_b64e
    vmovdqu ymm3, [rdx + 288]
M2s_b740
M2s_b43
    vmovdqu ymm3, [rdx + 160]
M2s_b46
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5b6 0
    vpermps ymm1, ymm3, [r8 + 280]
M2s_b652
M2s_b745
    vpermps ymm1, ymm3, [r8 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b50
M2s_b51
M2s_b5a8
M2s_b747
M2s_b744
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b59
M2s_b5d
%endmacro
%macro M2s_a5b7 0
    vfmadd213ps ymm4, ymm1, [c_q8e0]
M2s_b382
M2s_b378
    jb .fp2s
.fp2e:
M2s_b38a
M2s_b384
M2s_b356
    vmovups ymm8, [c_q8e0]
    vmovups ymm7, [c_c8]
.fp3:
M2s_b38d
M2s_b38e
M2s_b387
    vmovaps [rdi+rdx*4], ymm5
    vminps ymm5, ymm1, [u_zero]
%endmacro
%macro M2s_a5b8 0
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2s_b5ac
M2s_b5b1
M2s_b5b2
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 384]
M2s_b5b4
M2s_b5ba
M2s_b5bf
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_b5ab
M2s_b5c1
%endmacro
%macro M2s_a5b9 0
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_b5cf
M2s_b5d2
M2s_b627
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_b5c5
M2s_b5c9
M2s_b5d5
M2s_b5d7
M2s_b707
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_b5dc
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 84]
%endmacro
%macro M2s_a5ba 0
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_b5e1
M2s_b5e2
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_b5e5
M2s_b5e9
M2s_b5ea
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_b5ec
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 96]
%endmacro
%macro M2s_a5bb 0
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_b5e3
M2s_b75
M2s_b5ee
M2s_b78
M2s_b5fa
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_b708
M2s_b7f
M2s_b70a
    vpermps ymm1, ymm3, [r13 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_b81
    vpermps ymm1, ymm3, [r13 + 108]
%endmacro
%macro M2s_a5bc 0
M2s_b7b9
M2s_b82
    vpermps ymm1, ymm3, [r13 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 204]
%endmacro
%macro M2s_a5bd 0
M2s_a5be
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 300]
M2s_b71a
M2s_bac
M2s_ba9
M2s_bae
M2s_b5f3
M2s_b5f7
M2s_b6b9
    vpermps ymm1, ymm3, [r9 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5be 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5bf 0
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_a5c0 0
    vfmadd231ps ymm6, ymm0, [rcx + 352]
M2s_b625
M2s_b5b1
M2s_b5b2
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 384]
M2s_b5b4
M2s_b5ba
M2s_b5bf
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_b5ab
M2s_b5c1
%endmacro
%macro M2s_a5c1 0
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_b5cf
M2s_b5d2
M2s_b627
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_b5c5
M2s_b5c9
M2s_b5d5
M2s_b5d7
M2s_b707
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_b5dc
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 84]
%endmacro
%macro M2s_a5c2 0
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b5e1
M2s_b5e2
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_b5e5
M2s_b5e9
M2s_b5ea
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_b5ec
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 96]
%endmacro
%macro M2s_a5c3 0
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_b5e3
M2s_b75
M2s_b5ee
M2s_b78
M2s_b5fa
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_b708
M2s_b7f
M2s_b70a
    vpermps ymm1, ymm3, [r13 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_b7b9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 108]
%endmacro
%macro M2s_a5c4 0
    vpermps ymm1, ymm3, [r13 + 300]
M2s_b729
    vmovaps ymm6, ymm2
    vaddps ymm0, ymm4, ymm5
    vpermpd ymm0, ymm0, 0xd8
%endmacro
%macro M2s_a5c5 0
    vmovups ymm13, [c_q8o3]
M2s_b733
M2s_b209
    add rdx, 224
M2s_b277
M2s_b272
M2s_b734
.cd:
    vmovaps ymm5, [rdi + G_cmx + 32]
%endmacro
%macro M2s_a5c6 0
    vpsrld ymm8, ymm6, 23
    vpsrld ymm9, ymm6, 20
    vpmaddwd ymm10, ymm8, ymm13
M2s_b3dc
M2s_b3e0
M2s_b3d8
    vmovaps [r8+128], ymm8
    vmovaps [rbx+rdx*4], ymm2
M2s_b3e1
M2s_b3da
M2s_b3e2
    vpaddd ymm9, ymm5, ymm6
    vmovaps ymm7, ymm10
    vfmadd213ps ymm7, ymm11, [c_q8e2]
%endmacro
%macro M2s_a5c7 0
M2s_b3ee
M2s_b3f5
M2s_b3f6
%endmacro
%macro M2s_a5c8 0
M2s_b7ba
M2s_b7bc
    vpermps ymm1, ymm3, [r8 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a5c9
M2s_a5cd
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 384]
M2s_b669
M2s_b66e
M2s_b670
M2s_b671
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 416]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a5c9 0
M2s_b7bd
%endmacro
%macro M2s_a5ca 0
M2s_b7bf
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5cb 0
M2s_b7c0
M2s_a5cd
%endmacro
%macro M2s_a5cc 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 272]
M2s_a5cd
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 336]
%endmacro
%macro M2s_a5cd 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5ce 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_a5cf 0
    vpermps ymm1, ymm3, [r8 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 336]
%endmacro
%macro M2s_a5d0 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_b67c
M2s_b67f
M2s_b680
M2s_b681
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_b682
M2s_b689
M2s_b68c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 16]
%endmacro
%macro M2s_a5d1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_b687
M2s_b698
M2s_b69b
M2s_b69d
M2s_b6a0
M2s_b6a1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_b6a2
M2s_b6a5
M2s_b6a7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 28]
%endmacro
%macro M2s_a5d2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_b6af
M2s_b5b2
M2s_b6f5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_b6ab
M2s_b5b8
M2s_b5bd
M2s_b5be
M2s_b6f6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 40]
%endmacro
%macro M2s_a5d3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_b718
M2s_b5d3
M2s_b728
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2s_a5d4
M2s_b5da
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 272]
M2s_a5d5
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 336]
M2s_b7c1
%endmacro
%macro M2s_a5d4 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 48]
M2s_b5c7
M2s_b5d6
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 208]
%endmacro
%macro M2s_a5d5 0
M2s_b7c3
%endmacro
%macro M2s_a5d6 0
M2s_b7c1
M2s_b6b6
M2s_b71d
M2s_bac
M2s_ba9
M2s_bae
M2s_b6bd
%endmacro
%macro M2s_a5d7 0
M2s_b7c4
%endmacro
%macro M2s_a5d8 0
M2s_a5d7
M2s_a5da
M2s_a5df
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 384]
M2s_b6f4
M2s_b66e
M2s_b670
M2s_b671
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 416]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a5d9 0
M2s_b7c6
%endmacro
%macro M2s_a5da 0
M2s_b7c7
M2s_b7c9
%endmacro
%macro M2s_a5db 0
M2s_b7c8
M2s_a5dd
%endmacro
%macro M2s_a5dc 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 272]
M2s_a5dd
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 336]
%endmacro
%macro M2s_a5dd 0
M2s_b7ca
%endmacro
%macro M2s_a5de 0
M2s_b7cb
%endmacro
%macro M2s_a5df 0
M2s_b7cc
%endmacro
%macro M2s_a5e0 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_b67c
M2s_b67f
M2s_b680
M2s_b681
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_b682
M2s_b689
M2s_b68c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 16]
%endmacro
%macro M2s_a5e1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b687
M2s_b698
M2s_b69b
M2s_b69d
M2s_b6a0
M2s_b6a1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_b6a2
M2s_b6a5
M2s_b6a7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 28]
%endmacro
%macro M2s_a5e2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_b6af
M2s_b5b2
M2s_b6f5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_b6ab
M2s_b5b8
M2s_b5bd
M2s_b5be
M2s_b6f6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 40]
%endmacro
%macro M2s_a5e3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_b718
M2s_b5d3
M2s_b728
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_b7c2
M2s_b5da
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 272]
M2s_b7c3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 336]
M2s_a5e5
%endmacro
%macro M2s_a5e4 0
M2s_a5e5
M2s_b11b
M2s_b6f7
M2s_b72a
%endmacro
%macro M2s_a5e5 0
M2s_b7cd
%endmacro
%macro M2s_a5e6 0
    vfmadd231ps ymm7, ymm0, [rcx + 800]
M2s_b118
M2s_b114
M2s_b6fb
M2s_b117
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5e7 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2s_b7ba
M2s_b7bc
    vpermps ymm1, ymm3, [r8 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5e8 0
M2s_b7cf
M2s_b7bb
M2s_b7d0
%endmacro
%macro M2s_a5e9 0
    vmulps ymm4, ymm10, ymm0
M2s_b3e6
M2s_b3e9
    vmovups ymm13, [c_k5]
    vmovups ymm12, [c_mone]
M2s_b3ea
M2s_b3eb
    vpmaddwd ymm10, ymm8, ymm13
%endmacro
%macro M2s_a5ea 0
M2s_a5eb
M2s_b73b
M2s_b649
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
M2s_b739
M2s_b5a1
    vpermps ymm1, ymm3, [r8 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5eb 0
M2s_b7d2
%endmacro
%macro M2s_a5ec 0
    vpermps ymm1, ymm3, [r8 + 272]
M2s_b7b2
M2s_b72b
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b7b3
M2s_b42
M2s_b45
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 248]
%endmacro
%macro M2s_a5ed 0
M2s_a5ee
M2s_b47
M2s_b4a
M2s_b4d
M2s_b50
M2s_b51
M2s_b5a8
M2s_b747
M2s_b744
M2s_b7b6
%endmacro
%macro M2s_a5ee 0
    vmovdqu ymm3, [rdx + 224]
M2s_b7b5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 344]
%endmacro
%macro M2s_a5ef 0
M2s_a5f0
    vpermps ymm1, ymm3, [r8 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 384]
M2s_b750
    vpermps ymm1, ymm3, [r13 + 32]
M2s_b7a6
M2s_b7aa
M2s_b75a
    vmulps ymm5, ymm0, [rcx + 416]
M2s_b75b
M2s_b7ab
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5f0 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a5f1 0
    vpermps ymm1, ymm3, [r8 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 368]
%endmacro
%macro M2s_a5f2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5f3 0
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_b759
M2s_b7ac
    vmovdqu ymm3, [rdx + 512]
M2s_b760
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_b764
M2s_b7ad
    vmovdqu ymm3, [rdx + 512]
M2s_b766
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a5f4 0
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_b762
M2s_b7ae
    vmovdqu ymm3, [rdx + 512]
M2s_b768
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_b770
M2s_b7af
    vmovdqu ymm3, [rdx + 512]
M2s_b772
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a5f5 0
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_b76a
M2s_b76e
M2s_b7b0
M2s_b7da
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_b778
M2s_b779
M2s_b77a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a5f6 0
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_b775
M2s_b670
M2s_b671
M2s_b77c
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_b780
M2s_b679
M2s_b67a
M2s_b781
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a5f7 0
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_b77e
M2s_b783
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_b787
M2s_b68a
M2s_b68b
M2s_b788
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a5f8 0
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2s_a5f9
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2s_b6b5
M2s_b71c
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_bac
M2s_ba9
M2s_bae
M2s_b6bd
%endmacro
%macro M2s_a5f9 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 48]
M2s_b68f
M2s_b692
    vpermps ymm1, ymm3, [r13 + 240]
M2s_b696
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 304]
M2s_b7de
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5fa 0
M2s_b720
%endmacro
%macro M2s_a5fb 0
M2s_a5fa
    vmovdqu ymm3, [rdx + 288]
M2s_b796
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b100
M2s_bff
M2s_b621
M2s_b79b
M2s_b798
M2s_b79a
    vpermps ymm1, ymm3, [r9 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5fc 0
    vpermps ymm1, ymm3, [r9 + 288]
M2s_b6de
M2s_b79d
M2s_b10e
M2s_b10f
M2s_b62e
M2s_b6df
M2s_b7a0
M2s_b6e4
M2s_b6e7
M2s_b6e9
M2s_b6ed
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 264]
%endmacro
%macro M2s_a5fd 0
    vpermps ymm1, ymm3, [r9 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 352]
M2s_b7c4
M2s_b7c7
M2s_b7c9
M2s_b7cc
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a5fe 0
M2s_b7e1
    vmovdqu ymm3, [rdx + 128]
M2s_b7c6
M2s_b7cb
    vpermps ymm1, ymm3, [r9 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a5ff 0
M2s_b7e2
M2s_b7c6
M2s_b7cb
M2s_b7e6
%endmacro
%macro M2s_a600 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a601 0
M2s_a600
    vfmadd231ps ymm6, ymm0, [rcx + 384]
M2s_b7a5
M2s_b757
M2s_b7a9
    vpermps ymm1, ymm3, [r13 + 288]
M2s_b75a
    vmulps ymm7, ymm0, [rcx + 416]
M2s_b75b
M2s_b7ab
    vmovdqu ymm3, [rdx + 512]
M2s_b75d
%endmacro
%macro M2s_a602 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 384]
%endmacro
%macro M2s_a603 0
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_b759
M2s_b7ac
M2s_b7d6
M2s_b763
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_b764
M2s_b7ad
M2s_b7d7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a604 0
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_b762
M2s_b7ae
M2s_b7d8
M2s_b76f
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b770
M2s_b7af
M2s_b7d9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a605 0
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_b76a
M2s_b76e
M2s_b7b0
M2s_b7da
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_b778
M2s_b779
M2s_b77a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a606 0
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_b775
M2s_b670
M2s_b671
M2s_b77c
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_b780
M2s_b679
M2s_b67a
M2s_b781
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a607 0
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_b77e
M2s_b783
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_b787
M2s_b68a
M2s_b68b
M2s_b788
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a608 0
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_b7dd
M2s_b695
    vmovdqu ymm3, [rdx + 512]
M2s_b697
M2s_b7de
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 368]
%endmacro
%macro M2s_a609 0
    vmovdqu ymm3, [rdx + 224]
M2s_b7e0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 352]
%endmacro
%macro M2s_a60a 0
M2s_a609
M2s_bf0
M2s_b10a
M2s_b10d
M2s_b62d
M2s_b624
M2s_b79f
M2s_b79e
M2s_b6eb
%endmacro
%macro M2s_a60b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a60c 0
M2s_a60b
M2s_b14
M2s_b15
M2s_b11a
    vpermps ymm1, ymm3, [r8 + 164]
M2s_b18
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 228]
M2s_b59a
M2s_b737
M2s_a60e
M2s_b644
M2s_b1d
M2s_b1f
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a60d 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 352]
M2s_b119
M2s_b16
M2s_b17
M2s_b59a
M2s_b737
M2s_b7ea
M2s_b599
    vpermps ymm1, ymm3, [r8 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a60e 0
M2s_b7eb
%endmacro
%macro M2s_a60f 0
M2s_a610
M2s_b646
M2s_b27
M2s_b28
M2s_b59c
M2s_b73d
M2s_a611
M2s_b5a4
M2s_b2c
M2s_b2d
%endmacro
%macro M2s_a610 0
M2s_b7ec
%endmacro
%macro M2s_a611 0
M2s_b7ed
%endmacro
%macro M2s_a612 0
    vpermps ymm1, ymm3, [r8 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 368]
%endmacro
%macro M2s_a613 0
M2s_a612
M2s_b64b
M2s_b34
M2s_b35
M2s_b5a7
M2s_b742
M2s_a616
M2s_b38
M2s_b44
M2s_b46
%endmacro
%macro M2s_a614 0
M2s_a615
M2s_b2f
M2s_b32
M2s_b5a2
M2s_b64d
    vpermps ymm1, ymm3, [r8 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
M2s_b7ee
M2s_b43
M2s_b7b4
    vpermps ymm1, ymm3, [r8 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a615 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a616 0
M2s_b7ef
%endmacro
%macro M2s_a617 0
M2s_a618
M2s_b47
M2s_b4a
M2s_b4d
M2s_b50
M2s_b51
M2s_b5a8
M2s_b747
M2s_a61b
M2s_b54
M2s_b59
M2s_b5d
%endmacro
%macro M2s_a618 0
M2s_b7f1
%endmacro
%macro M2s_a619 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 376]
M2s_b47
M2s_b4a
M2s_b4d
M2s_b50
M2s_b51
M2s_b5a8
M2s_b747
M2s_b7f0
M2s_b7b6
    vpermps ymm1, ymm3, [r8 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a61a 0
M2s_b7f2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
M2s_b7f0
M2s_b7b6
    vpermps ymm1, ymm3, [r8 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a61b 0
M2s_b7f3
%endmacro
%macro M2s_a61c 0
    vpermps ymm1, ymm3, [r8 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 384]
%endmacro
%macro M2s_a61d 0
M2s_a61c
M2s_b5e
M2s_b70f
M2s_b5aa
M2s_b74e
M2s_a620
M2s_b65c
M2s_b664
M2s_b667
%endmacro
%macro M2s_a61e 0
M2s_b7f5
%endmacro
%macro M2s_a61f 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 384]
M2s_b5e
M2s_b70f
M2s_b5aa
M2s_b74e
M2s_b7f4
M2s_b663
    vpermps ymm1, ymm3, [r8 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a620 0
M2s_b7f6
%endmacro
%macro M2s_a621 0
M2s_a622
M2s_b72c
M2s_b713
M2s_b717
M2s_b753
M2s_a625
M2s_b7ce
M2s_b7bd
%endmacro
%macro M2s_a622 0
    vpermps ymm1, ymm3, [r8 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 392]
%endmacro
%macro M2s_a623 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 392]
M2s_b72c
M2s_b713
M2s_b717
M2s_b753
M2s_b7f7
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b7bd
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a624 0
M2s_b7f8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
M2s_b7f7
M2s_b7f9
    vpermps ymm1, ymm3, [r8 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a625 0
M2s_b7fa
%endmacro
%macro M2s_a626 0
M2s_a627
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 384]
M2s_a62a
M2s_a633
    vmulps ymm5, ymm0, [rcx + 416]
M2s_b7fb
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a635
%endmacro
%macro M2s_a627 0
    vpermps ymm1, ymm3, [r8 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 400]
%endmacro
%macro M2s_a628 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a629 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 384]
%endmacro
%macro M2s_a62a 0
M2s_b7fc
    vpermps ymm1, ymm3, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a62c
M2s_a62e
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 320]
%endmacro
%macro M2s_a62b 0
M2s_b7fe
    vpermps ymm1, ymm3, [r13 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a62c 0
M2s_b7ff
%endmacro
%macro M2s_a62d 0
M2s_b801
M2s_a62e
M2s_a631
%endmacro
%macro M2s_a62e 0
M2s_b802
%endmacro
%macro M2s_a62f 0
M2s_b803
M2s_a631
%endmacro
%macro M2s_a630 0
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a631
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a631 0
M2s_b804
%endmacro
%macro M2s_a632 0
    vpermps ymm1, ymm3, [r13 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 352]
%endmacro
%macro M2s_a633 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a634 0
M2s_b7fb
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a635
M2s_a636
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a635 0
M2s_b805
%endmacro
%macro M2s_a636 0
M2s_b806
%endmacro
%macro M2s_a637 0
M2s_a636
M2s_a63a
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_a63c
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_b809
M2s_b80b
    vpermps ymm1, ymm3, [r13 + 140]
%endmacro
%macro M2s_a638 0
M2s_b807
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 324]
%endmacro
%macro M2s_a639 0
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a63a
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a63a 0
M2s_b80c
%endmacro
%macro M2s_a63b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a63c 0
M2s_b80d
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a63d
M2s_a63f
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a63d 0
M2s_b80f
%endmacro
%macro M2s_a63e 0
M2s_b812
%endmacro
%macro M2s_a63f 0
M2s_b813
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a640 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 296]
M2s_a642
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_a641 0
    vpermps ymm1, ymm3, [r13 + 296]
M2s_a642
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a642 0
M2s_b814
%endmacro
%macro M2s_a643 0
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_a644 0
M2s_b808
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a645
M2s_a647
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a645 0
M2s_b80a
M2s_b815
%endmacro
%macro M2s_a646 0
M2s_b815
M2s_a647
M2s_a64a
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a64b
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_b816
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a647 0
M2s_b817
%endmacro
%macro M2s_a648 0
M2s_b819
M2s_a64a
%endmacro
%macro M2s_a649 0
    vpermps ymm1, ymm3, [r13 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a64a
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a64a 0
M2s_b81a
%endmacro
%macro M2s_a64b 0
M2s_b81b
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a64c
M2s_a64e
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a64c 0
M2s_b81c
%endmacro
%macro M2s_a64d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
M2s_a64e
M2s_a651
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a64e 0
M2s_b820
%endmacro
%macro M2s_a64f 0
M2s_b821
M2s_a651
%endmacro
%macro M2s_a650 0
    vpermps ymm1, ymm3, [r13 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a651
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a651 0
M2s_b822
%endmacro
%macro M2s_a652 0
M2s_b816
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a653
M2s_a655
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a653 0
M2s_b823
%endmacro
%macro M2s_a654 0
M2s_a653
M2s_a655
M2s_a657
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_a658
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_a655 0
M2s_b825
%endmacro
%macro M2s_a656 0
    vpermps ymm1, ymm3, [r13 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a657
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a657 0
M2s_b827
%endmacro
%macro M2s_a658 0
M2s_b828
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a659
M2s_a65a
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a659 0
M2s_b829
%endmacro
%macro M2s_a65a 0
M2s_b82b
%endmacro
%macro M2s_a65b 0
M2s_b82c
M2s_a65d
%endmacro
%macro M2s_a65c 0
    vpermps ymm1, ymm3, [r13 + 312]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a65d
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a65d 0
M2s_b82d
%endmacro
%macro M2s_a65e 0
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_a65f
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_b756
M2s_b752
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 288]
%endmacro
%macro M2s_a65f 0
M2s_b82f
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a660
M2s_a661
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a660 0
M2s_b830
%endmacro
%macro M2s_a661 0
M2s_b832
%endmacro
%macro M2s_a662 0
    vpermps ymm1, ymm3, [r13 + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a663
    vpermps ymm1, ymm3, [r13 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a663 0
M2s_b834
%endmacro
%macro M2s_a664 0
M2s_b82e
M2s_b7a9
M2s_b7e7
M2s_b835
%endmacro
%macro M2s_a665 0
    vpermps ymm1, ymm3, [r13 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a666
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a666 0
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_a667 0
M2s_a666
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_a668
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_b75f
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_a668 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_b75c
M2s_b75d
M2s_b75e
    vmovdqu ymm3, [rdx + 608]
M2s_b839
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a669 0
M2s_b839
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a66a 0
M2s_b836
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b7d6
M2s_b763
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a66b 0
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a66c
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a66c 0
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_a66d 0
M2s_a66c
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_a66e
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 48]
M2s_b767
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_a66e 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_b765
M2s_b766
    vmovdqu ymm3, [rdx + 608]
M2s_b83f
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a66f 0
M2s_b83f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a670 0
M2s_b83c
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b7d8
M2s_b76f
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a671 0
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a673
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a672 0
M2s_a673
    vpermps ymm1, ymm3, [r13 + 400]
M2s_b7c1
M2s_b6b6
M2s_b71d
M2s_bac
M2s_ba9
M2s_bae
M2s_b6bd
M2s_b789
M2s_a675
M2s_b9d
M2s_b5f5
    vmovdqu ymm3, [rdx + 96]
M2s_b5f8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_a673 0
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_a674 0
M2s_b842
M2s_bb6
M2s_bb7
M2s_b5ff
M2s_b78b
M2s_a677
M2s_b6bc
M2s_bbe
M2s_bbd
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a675 0
M2s_b845
%endmacro
%macro M2s_a676 0
M2s_b844
M2s_bbc
M2s_b5fe
M2s_b6bf
M2s_b6c2
    vmovdqu ymm3, [rdx + 288]
M2s_a67a
M2s_b609
M2s_bc6
M2s_bc5
%endmacro
%macro M2s_a677 0
M2s_b847
%endmacro
%macro M2s_a678 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a679 0
M2s_b846
M2s_b605
M2s_b71f
    vmovdqu ymm3, [rdx + 288]
M2s_a67d
M2s_bb3
M2s_b611
M2s_bcd
%endmacro
%macro M2s_a67a 0
M2s_b849
%endmacro
%macro M2s_a67b 0
M2s_b84a
%endmacro
%macro M2s_a67c 0
M2s_b848
M2s_b60d
M2s_b6c9
    vmovdqu ymm3, [rdx + 288]
M2s_a67f
M2s_bce
M2s_bd5
M2s_bd8
M2s_bd9
%endmacro
%macro M2s_a67d 0
M2s_b84c
%endmacro
%macro M2s_a67e 0
M2s_b84b
M2s_bd7
M2s_bda
M2s_b6d0
    vmovdqu ymm3, [rdx + 288]
M2s_a682
M2s_b793
M2s_bf4
M2s_bf6
%endmacro
%macro M2s_a67f 0
M2s_b84e
%endmacro
%macro M2s_a680 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a681 0
M2s_b84d
M2s_bf3
M2s_bed
M2s_b6d6
    vmovdqu ymm3, [rdx + 288]
M2s_a683
M2s_be3
M2s_bf8
M2s_bfb
M2s_b100
M2s_bff
%endmacro
%macro M2s_a682 0
M2s_b850
%endmacro
%macro M2s_a683 0
M2s_b851
%endmacro
%macro M2s_a684 0
M2s_b84f
M2s_b7df
    vmovdqu ymm3, [rdx + 288]
M2s_a686
M2s_be5
M2s_be0
M2s_b104
M2s_b107
M2s_b109
%endmacro
%macro M2s_a685 0
M2s_b852
M2s_b79a
M2s_b62f
M2s_b6de
    vmovdqu ymm3, [rdx + 288]
M2s_a688
M2s_bf0
M2s_b10a
M2s_b10d
M2s_b62d
%endmacro
%macro M2s_a686 0
M2s_b854
%endmacro
%macro M2s_a687 0
M2s_b853
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b62d
M2s_b624
M2s_b79f
M2s_a68b
M2s_b6e2
M2s_b6ec
M2s_b6ef
%endmacro
%macro M2s_a688 0
M2s_b856
%endmacro
%macro M2s_a689 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a68a 0
M2s_b855
M2s_b6eb
M2s_b6f2
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b7a1
M2s_a68c
M2s_b730
M2s_b725
%endmacro
%macro M2s_a68b 0
M2s_b858
%endmacro
%macro M2s_a68c 0
M2s_b859
%endmacro
%macro M2s_a68d 0
M2s_b857
M2s_b7a4
M2s_b7a7
M2s_b727
    vmovdqu ymm3, [rdx + 288]
M2s_a68f
M2s_b7e1
M2s_b7e5
%endmacro
%macro M2s_a68e 0
M2s_a690
M2s_b85b
M2s_a691
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 384]
    lea r13, [r9 + r14]
M2s_b7fd
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b7ff
%endmacro
%macro M2s_a68f 0
M2s_b85e
%endmacro
%macro M2s_a690 0
M2s_b85a
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b7e5
M2s_b7ca
%endmacro
%macro M2s_a691 0
M2s_b85f
%endmacro
%macro M2s_a692 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 384]
%endmacro
%macro M2s_a693 0
M2s_b85c
M2s_b800
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
M2s_b802
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 320]
%endmacro
%macro M2s_a694 0
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 416]
M2s_b7fb
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b805
M2s_b806
M2s_b80c
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_b80d
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b80f
M2s_b813
%endmacro
%macro M2s_a695 0
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_b809
M2s_b80b
    vpermps ymm1, ymm3, [r13 + 140]
M2s_b815
M2s_b817
M2s_b81a
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_b81b
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b81c
M2s_b81f
%endmacro
%macro M2s_a696 0
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b816
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b823
M2s_b825
M2s_b827
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_b828
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b829
M2s_b82a
%endmacro
%macro M2s_a697 0
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_b82f
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b830
M2s_b832
M2s_b834
    vpermps ymm1, ymm3, [r13 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_b82e
M2s_b7a9
    vpermps ymm1, ymm3, [r13 + 288]
%endmacro
%macro M2s_a698 0
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_b838
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_b836
M2s_b83b
    vpermps ymm1, ymm3, [r13 + 296]
%endmacro
%macro M2s_a699 0
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_b83e
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_b83c
M2s_b841
    vpermps ymm1, ymm3, [r13 + 304]
%endmacro
%macro M2s_a69a 0
    vpermps ymm1, ymm3, [r13 + 400]
M2s_b7cd
    vmovaps ymm6, ymm2
    vaddps ymm0, ymm4, ymm5
    vpermpd ymm0, ymm0, 0xd8
%endmacro
%macro M2s_a69b 0
    vpermps ymm1, ymm3, [r8 + 264]
M2s_b7d2
    vmovdqu ymm3, [rdx + 288]
M2s_b7ec
M2s_b646
M2s_b27
M2s_b28
M2s_b59c
M2s_b73d
M2s_b7ed
M2s_b5a4
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 176]
%endmacro
%macro M2s_a69c 0
    vfmadd213ps ymm6, ymm8, ymm12
M2s_b7b7
M2s_b385
M2s_b354
M2s_b7b8
    vmovups ymm2, [rbx+rdx*4+32]
    vaddps ymm5, ymm1, [rcx+rdx*4]
    vmovaps [rdi+rdx*4], ymm5
%endmacro
%macro M2s_a69d 0
    vmovdqu ymm3, [rdx + 224]
M2s_b7d3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 336]
%endmacro
%macro M2s_a69e 0
M2s_a69d
M2s_b64b
M2s_b34
M2s_b35
M2s_b5a7
M2s_b742
M2s_b740
M2s_b43
M2s_b7b4
%endmacro
%macro M2s_a69f 0
    vpermps ymm1, ymm3, [r8 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b74a
    vpermps ymm1, ymm3, [r8 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6a0 0
M2s_a6a1
    vpermps ymm1, ymm3, [r8 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 416]
M2s_b750
M2s_b7d5
M2s_b7a9
    vpermps ymm1, ymm3, [r13 + 288]
%endmacro
%macro M2s_a6a1 0
M2s_b86d
M2s_b870
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b873
%endmacro
%macro M2s_a6a2 0
M2s_b86e
M2s_b871
M2s_b873
    vpermps ymm1, ymm3, [r8 + 372]
%endmacro
%macro M2s_a6a3 0
M2s_b86f
M2s_b872
    vpermps ymm1, ymm3, [r8 + 308]
M2s_a6a4
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6a4 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6a5 0
M2s_b874
%endmacro
%macro M2s_a6a6 0
    vmulps ymm5, ymm0, [rcx + 448]
M2s_b75b
M2s_b7ab
M2s_b7e8
    vpermps ymm1, ymm3, [r13 + 260]
M2s_b75e
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_b759
M2s_b7ac
M2s_b7d6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6a7 0
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_b764
M2s_b7ad
M2s_b7d7
M2s_b877
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_b762
M2s_b7ae
M2s_b7d8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6a8 0
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_b770
M2s_b7af
M2s_b7d9
M2s_b878
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_b76a
M2s_b76e
M2s_b7b0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6a9 0
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_b777
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_b775
M2s_b670
M2s_b671
M2s_b77b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6aa 0
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_b77f
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_b77e
M2s_b782
M2s_b7b1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6ab 0
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2s_b786
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2s_b7dd
M2s_b695
M2s_b7e9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6ac 0
    vfmadd231ps ymm5, ymm0, [rcx + 832]
M2s_a6ad
    vfmadd231ps ymm5, ymm0, [rcx + 864]
M2s_b6b5
M2s_b71c
M2s_b7db
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_a6ad 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 52]
M2s_b699
M2s_b69c
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
M2s_b6a1
M2s_b87b
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6ae 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b879
M2s_bad
M2s_b5f1
    vpermps ymm1, ymm3, [r9 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_a6af 0
M2s_b87d
M2s_b880
M2s_a6b1
M2s_a6b4
%endmacro
%macro M2s_a6b0 0
M2s_a6af
    vfmadd231ps ymm6, ymm0, [rcx + 416]
M2s_b7a5
M2s_b757
M2s_b7a9
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6b1 0
M2s_b881
%endmacro
%macro M2s_a6b2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 308]
M2s_a6b3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a6b3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6b4 0
M2s_b884
%endmacro
%macro M2s_a6b5 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 448]
M2s_b75b
M2s_b7ab
M2s_b7e8
M2s_b876
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_b759
M2s_b7ac
M2s_b7d6
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6b6 0
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_b764
M2s_b7ad
M2s_b7d7
M2s_b877
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b762
M2s_b7ae
M2s_b7d8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6b7 0
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_b770
M2s_b7af
M2s_b7d9
M2s_b878
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_b76a
M2s_b76e
M2s_b7b0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6b8 0
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_b777
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_b775
M2s_b670
M2s_b671
M2s_b77b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6b9 0
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_b77f
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_b77e
M2s_b782
M2s_b7b1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6ba 0
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_b786
    vfmadd231ps ymm7, ymm0, [rcx + 800]
M2s_b7dd
M2s_b695
M2s_b7e9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6bb 0
    vfmadd231ps ymm7, ymm0, [rcx + 832]
M2s_b87a
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b6a0
M2s_b6a1
M2s_b87b
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 372]
%endmacro
%macro M2s_a6bc 0
    vfmadd231ps ymm7, ymm0, [rcx + 864]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
    vmovaps ymm6, ymm2
%endmacro
%macro M2s_a6bd 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a6be 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 384]
M2s_b87d
M2s_b880
M2s_b881
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a6bf 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 864]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
%endmacro
%macro M2s_a6c0 0
    vmovups ymm13, [c_q8o3]
M2s_b6ff
M2s_b1de
M2s_b1b1
M2s_b1fb
M2s_b1fe
M2s_b1ba
    vfmadd231ps ymm4, ymm9, ymm0
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+416]
%endmacro
%macro M2s_a6c1 0
M2s_b256
M2s_b1a7
M2s_b1de
M2s_b1b1
M2s_b1e1
M2s_b1d9
M2s_b1e6
    add r9, 576
M2s_b702
    test rcx, rcx
    jz .i2c0e
    vmovups ymm15, [c_xlo]
%endmacro
%macro M2s_a6c2 0
    cmp r13, 16
M2s_b3b9
M2s_b32c
M2s_b330
M2s_b332
M2s_b335
M2s_b316
    vfmadd231ps ymm2, ymm14, [r10+rdx*8+96]
    vfmadd231ps ymm0, ymm13, [r11+rdx*8+64]
    vfmadd231ps ymm2, ymm13, [r11+rdx*8+96]
%endmacro
%macro M2s_a6c3 0
M2s_b645
M2s_b73a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 360]
M2s_b646
M2s_b27
M2s_b28
M2s_b59c
M2s_b73d
M2s_b7ed
M2s_b5a4
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_a6c4 0
M2s_b73c
M2s_b7d3
%endmacro
%macro M2s_a6c5 0
M2s_a6c4
M2s_b741
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 368]
M2s_b64b
M2s_b34
M2s_b35
M2s_b5a7
M2s_b742
M2s_b7ef
M2s_b37
M2s_b3d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_a6c6 0
M2s_b888
%endmacro
%macro M2s_a6c7 0
M2s_b889
%endmacro
%macro M2s_a6c8 0
M2s_a6c9
M2s_b7fc
    vpermps ymm1, ymm3, [r13 + 32]
M2s_b85d
M2s_b862
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b804
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 448]
M2s_b7fb
M2s_b863
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6c9 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 416]
%endmacro
%macro M2s_a6ca 0
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_b80d
M2s_b864
M2s_b812
M2s_b814
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_b809
M2s_b80b
M2s_b866
    vmovdqu ymm3, [rdx + 544]
M2s_b818
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6cb 0
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_b81b
M2s_b867
    vmovdqu ymm3, [rdx + 544]
M2s_b820
M2s_b822
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_b816
M2s_b868
    vmovdqu ymm3, [rdx + 544]
M2s_b824
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6cc 0
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_b828
M2s_b869
    vmovdqu ymm3, [rdx + 544]
M2s_b82b
M2s_b82d
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_b82f
M2s_b86a
    vmovdqu ymm3, [rdx + 544]
M2s_b831
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6cd 0
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_b82e
M2s_b7a9
M2s_b7e7
M2s_b835
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_b837
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b7e8
M2s_b875
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6ce 0
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_b836
M2s_b83a
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2s_b83d
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b7d7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6cf 0
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2s_b83c
M2s_b840
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 832]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 52]
M2s_b771
M2s_b772
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6d0 0
M2s_b893
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b7d9
M2s_b878
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6d1 0
    vpermps ymm1, ymm3, [r13 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 372]
M2s_a6d2
M2s_b879
M2s_bad
M2s_b5f1
M2s_b6c0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 320]
M2s_b845
M2s_b9d
M2s_b5f5
M2s_b843
    vpermps ymm1, ymm3, [r9 + 164]
%endmacro
%macro M2s_a6d2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6d3 0
M2s_a6d4
M2s_b84a
M2s_bab
M2s_bc1
M2s_bc3
M2s_b601
M2s_b71e
    vpermps ymm1, ymm3, [r9 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
M2s_b84c
M2s_bb3
M2s_b613
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b60c
%endmacro
%macro M2s_a6d4 0
    vmovdqu ymm3, [rdx + 224]
M2s_b6c1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 328]
%endmacro
%macro M2s_a6d5 0
M2s_a6d6
M2s_b883
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 340]
M2s_b884
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 416]
M2s_b85c
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6d6 0
M2s_a6d7
M2s_b885
M2s_b87e
M2s_b899
%endmacro
%macro M2s_a6d7 0
M2s_b85b
M2s_b85f
%endmacro
%macro M2s_a6d8 0
M2s_b7e6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6d9 0
    vmulps ymm7, ymm0, [rcx + 448]
M2s_b7fb
M2s_b863
    vmovdqu ymm3, [rdx + 544]
M2s_b806
M2s_b80c
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_b80d
M2s_b864
M2s_b811
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6da 0
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_b809
M2s_b80b
M2s_b865
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b81a
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b81b
M2s_b867
M2s_b88e
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6db 0
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_b816
M2s_b868
M2s_b88f
M2s_b826
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b827
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_b828
M2s_b869
M2s_b891
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6dc 0
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_b82f
M2s_b86a
M2s_b892
M2s_b833
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b834
    vpermps ymm1, ymm3, [r13 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_b82e
M2s_b7a9
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6dd 0
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_b838
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_b836
M2s_b83b
    vpermps ymm1, ymm3, [r13 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6de 0
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_b83e
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 800]
M2s_b83c
M2s_b841
    vpermps ymm1, ymm3, [r13 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a6df 0
    vfmadd231ps ymm7, ymm0, [rcx + 832]
M2s_b893
M2s_b894
    vpermps ymm1, ymm3, [r13 + 308]
M2s_b878
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 372]
%endmacro
%macro M2s_a6e0 0
M2s_b6ba
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
M2s_b847
M2s_b6bc
M2s_bbe
M2s_bbd
M2s_b607
M2s_b78c
M2s_b849
M2s_b608
M2s_b600
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_a6e1 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 384]
M2s_b119
M2s_b16
M2s_b17
M2s_b59a
M2s_b737
M2s_b7eb
M2s_a6e2
M2s_b1a
M2s_b1c
M2s_b597
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a6e2 0
M2s_b8a2
%endmacro
%macro M2s_a6e3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6e4 0
M2s_a6e3
M2s_b22
M2s_b26
M2s_b648
    vpermps ymm1, ymm3, [r8 + 300]
M2s_b7d1
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 364]
M2s_a6e6
M2s_b2a
M2s_b2b
M2s_b59d
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6e5 0
    vpermps ymm1, ymm3, [r8 + 392]
M2s_b646
M2s_b27
M2s_b28
M2s_b59c
M2s_b73d
M2s_b7ed
M2s_b8a3
M2s_b2c
M2s_b2d
%endmacro
%macro M2s_a6e6 0
M2s_b8a4
%endmacro
%macro M2s_a6e7 0
M2s_a6e8
M2s_b2f
M2s_b32
M2s_b5a2
M2s_b64d
    vpermps ymm1, ymm3, [r8 + 308]
M2s_b7d4
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 372]
M2s_a6ea
M2s_b39
M2s_b3e
M2s_b40
M2s_b70e
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6e8 0
M2s_b8a7
%endmacro
%macro M2s_a6e9 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 400]
M2s_b64b
M2s_b34
M2s_b35
M2s_b5a7
M2s_b742
M2s_b7ef
M2s_b8a6
M2s_b44
    vpermps ymm1, ymm3, [r8 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a6ea 0
M2s_b8a8
%endmacro
%macro M2s_a6eb 0
M2s_b8a9
%endmacro
%macro M2s_a6ec 0
M2s_a6eb
M2s_b48
M2s_b4b
M2s_b4e
M2s_b53
M2s_b52
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b747
M2s_b7f3
M2s_a6ed
M2s_b55
M2s_b57
M2s_b5b
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6ed 0
M2s_b8ab
%endmacro
%macro M2s_a6ee 0
M2s_a6ef
M2s_b60
M2s_b65
M2s_b74b
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b659
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
M2s_b7f6
M2s_a6f1
M2s_b65d
M2s_b660
M2s_b74c
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6ef 0
M2s_b8af
%endmacro
%macro M2s_a6f0 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 416]
M2s_b5e
M2s_b70f
M2s_b5aa
M2s_b74e
M2s_b7f6
M2s_b8ae
M2s_b664
    vpermps ymm1, ymm3, [r8 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a6f1 0
M2s_b8b0
%endmacro
%macro M2s_a6f2 0
M2s_b8b1
%endmacro
%macro M2s_a6f3 0
M2s_a6f2
M2s_b72d
M2s_b711
M2s_b714
M2s_b716
M2s_b74f
M2s_b754
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 396]
M2s_a6f4
M2s_b7cf
M2s_b7bb
M2s_b7d0
M2s_b7bf
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6f4 0
M2s_b8b2
%endmacro
%macro M2s_a6f5 0
M2s_a6f6
M2s_b874
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 404]
M2s_a6f8
    vfmadd231ps ymm4, ymm0, [rcx + 416]
M2s_b8b4
M2s_b8bc
%endmacro
%macro M2s_a6f6 0
M2s_a6f7
M2s_b86e
M2s_b871
M2s_b8bd
%endmacro
%macro M2s_a6f7 0
M2s_b8be
%endmacro
%macro M2s_a6f8 0
M2s_b8bf
%endmacro
%macro M2s_a6f9 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 416]
%endmacro
%macro M2s_a6fa 0
M2s_b8b3
M2s_b8b8
    vmovdqu ymm3, [rdx + 480]
M2s_b8c0
%endmacro
%macro M2s_a6fb 0
M2s_b8b6
M2s_b8b9
M2s_b8c0
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6fc 0
M2s_b8b7
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6fd
M2s_b8c1
%endmacro
%macro M2s_a6fd 0
M2s_b8bb
M2s_b8c2
M2s_b8c6
%endmacro
%macro M2s_a6fe 0
M2s_a6ff
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 448]
M2s_a704
M2s_a708
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_b8c7
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a6ff 0
M2s_b8c4
M2s_a700
M2s_a702
%endmacro
%macro M2s_a700 0
M2s_b8c5
M2s_b8c8
%endmacro
%macro M2s_a701 0
M2s_b8c1
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a702 0
M2s_b8c9
%endmacro
%macro M2s_a703 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_a704 0
M2s_b8ca
M2s_b8ce
M2s_a707
%endmacro
%macro M2s_a705 0
M2s_b8cc
M2s_b8cd
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a706
    vpermps ymm1, ymm3, [r13 + 388]
%endmacro
%macro M2s_a706 0
M2s_b8d1
M2s_a707
M2s_a708
%endmacro
%macro M2s_a707 0
M2s_b8d2
%endmacro
%macro M2s_a708 0
M2s_b8d3
%endmacro
%macro M2s_a709 0
M2s_b8c7
M2s_b8d4
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a70e
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a70a 0
M2s_a70b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_b8d7
M2s_b8dc
M2s_b8df
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_a70b 0
M2s_b8d5
M2s_a70c
%endmacro
%macro M2s_a70c 0
    vpermps ymm1, ymm3, [r13 + 232]
M2s_b8e0
    vpermps ymm1, ymm3, [r13 + 392]
%endmacro
%macro M2s_a70d 0
M2s_b8e0
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a70e 0
M2s_b8e1
%endmacro
%macro M2s_a70f 0
M2s_b8e2
M2s_b8e3
%endmacro
%macro M2s_a710 0
M2s_b8e4
%endmacro
%macro M2s_a711 0
M2s_b8e5
%endmacro
%macro M2s_a712 0
M2s_b8d7
M2s_a714
%endmacro
%macro M2s_a713 0
M2s_b8d8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 172]
M2s_a714
M2s_a717
    vpermps ymm1, ymm3, [r13 + 396]
%endmacro
%macro M2s_a714 0
M2s_b8dc
M2s_b8df
M2s_b8e6
%endmacro
%macro M2s_a715 0
M2s_b8de
M2s_b8e7
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a716 0
M2s_b8e7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_a718
M2s_a71e
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_b8e8
%endmacro
%macro M2s_a717 0
M2s_b8eb
%endmacro
%macro M2s_a718 0
M2s_b8ec
M2s_b8ee
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a71b
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a719 0
M2s_b8ed
    vpermps ymm1, ymm3, [r13 + 240]
M2s_b8f0
    vpermps ymm1, ymm3, [r13 + 400]
%endmacro
%macro M2s_a71a 0
M2s_b8f0
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a71b 0
M2s_b8f1
%endmacro
%macro M2s_a71c 0
M2s_b8f2
M2s_b8f3
%endmacro
%macro M2s_a71d 0
M2s_b8f4
%endmacro
%macro M2s_a71e 0
M2s_b8f5
%endmacro
%macro M2s_a71f 0
M2s_b8e8
M2s_a722
%endmacro
%macro M2s_a720 0
M2s_b8e9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 180]
M2s_a722
M2s_a724
    vpermps ymm1, ymm3, [r13 + 404]
%endmacro
%macro M2s_a721 0
M2s_a722
M2s_a724
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_a725
M2s_a72c
    vpermps ymm1, ymm3, [r13 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 28]
%endmacro
%macro M2s_a722 0
M2s_b8f6
M2s_a723
%endmacro
%macro M2s_a723 0
M2s_b8f7
%endmacro
%macro M2s_a724 0
M2s_b8f8
%endmacro
%macro M2s_a725 0
M2s_b8f9
M2s_b8fb
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a728
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a726 0
M2s_b8fa
    vpermps ymm1, ymm3, [r13 + 248]
M2s_b8fd
    vpermps ymm1, ymm3, [r13 + 408]
%endmacro
%macro M2s_a727 0
M2s_b8fd
    vpermps ymm1, ymm3, [r13 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a728 0
M2s_b8fe
%endmacro
%macro M2s_a729 0
M2s_b8ff
M2s_b901
%endmacro
%macro M2s_a72a 0
M2s_b900
    vpermps ymm1, ymm3, [r13 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 376]
%endmacro
%macro M2s_a72b 0
M2s_b902
%endmacro
%macro M2s_a72c 0
M2s_b903
%endmacro
%macro M2s_a72d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a72e 0
M2s_b905
%endmacro
%macro M2s_a72f 0
M2s_b906
M2s_b908
M2s_a730
    vfmadd231ps ymm5, ymm0, [rcx + 672]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_b7ff
M2s_b802
    vmovdqu ymm3, [rdx + 640]
%endmacro
%macro M2s_a730 0
M2s_b909
    vpermps ymm1, ymm3, [r13 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a731
    vpermps ymm1, ymm3, [r13 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a731 0
M2s_b90b
%endmacro
%macro M2s_a732 0
M2s_b90a
M2s_b861
    vpermps ymm1, ymm3, [r13 + 288]
M2s_b88b
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a733 0
    vpermps ymm1, ymm3, [r13 + 352]
M2s_b90d
%endmacro
%macro M2s_a734 0
M2s_b90d
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_a736
M2s_a737
    vpermps ymm1, ymm3, [r13 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_b80e
M2s_b810
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a735 0
M2s_b90f
%endmacro
%macro M2s_a736 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_b805
M2s_b806
M2s_b80c
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a737 0
M2s_b912
%endmacro
%macro M2s_a738 0
M2s_b90e
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b812
M2s_b814
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a739 0
M2s_a73a
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2s_a73c
M2s_a73e
    vpermps ymm1, ymm3, [r13 + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 800]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 48]
M2s_b81d
M2s_b81e
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 208]
%endmacro
%macro M2s_a73a 0
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a73b
    vpermps ymm1, ymm3, [r13 + 424]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a73b 0
M2s_b917
%endmacro
%macro M2s_a73c 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_b80a
M2s_b815
M2s_b817
M2s_b81a
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a73d 0
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a73e
    vpermps ymm1, ymm3, [r13 + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a73e 0
M2s_b91a
%endmacro
%macro M2s_a73f 0
M2s_b916
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b88d
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b822
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a740 0
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a741
    vpermps ymm1, ymm3, [r13 + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a741 0
M2s_b91e
%endmacro
%macro M2s_a742 0
M2s_a741
    vpermps ymm1, ymm3, [r13 + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 832]
M2s_a743
M2s_a745
    vpermps ymm1, ymm3, [r13 + 436]
M2s_b87c
M2s_bac
%endmacro
%macro M2s_a743 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 52]
M2s_b823
M2s_b825
M2s_b827
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a744 0
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a745
    vpermps ymm1, ymm3, [r13 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a745 0
M2s_b921
%endmacro
%macro M2s_a746 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 384]
M2s_b5f4
M2s_bb6
M2s_bb7
M2s_b5ff
M2s_b78b
M2s_b847
M2s_a747
M2s_bb9
M2s_bbb
M2s_b5fc
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a747 0
M2s_b924
%endmacro
%macro M2s_a748 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 388]
M2s_b6bc
M2s_bbe
M2s_bbd
M2s_b607
M2s_b78c
M2s_b849
M2s_a74a
M2s_bab
M2s_bc1
M2s_bc3
M2s_b601
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a749 0
M2s_b925
M2s_bc6
M2s_bc5
M2s_b610
M2s_b78e
M2s_b84c
M2s_a74c
M2s_bb4
M2s_bc9
M2s_bcb
M2s_b60a
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a74a 0
M2s_b927
%endmacro
%macro M2s_a74b 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 392]
M2s_b609
M2s_bc6
M2s_bc5
M2s_b610
M2s_b78e
M2s_b84c
M2s_b926
M2s_bcc
    vpermps ymm1, ymm3, [r9 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a74c 0
M2s_b928
%endmacro
%macro M2s_a74d 0
M2s_b926
M2s_bcc
M2s_bcd
M2s_b619
M2s_b78f
M2s_b84e
M2s_a74e
M2s_bcf
M2s_b615
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a74e 0
M2s_b92a
%endmacro
%macro M2s_a74f 0
M2s_b929
M2s_bd8
M2s_bd9
M2s_b61f
M2s_b794
M2s_b850
M2s_a751
M2s_be6
M2s_bee
M2s_beb
M2s_b61c
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a750 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 400]
M2s_bce
M2s_bd5
M2s_bd8
M2s_bd9
M2s_b61f
M2s_b794
M2s_b850
M2s_b92b
M2s_bf4
    vpermps ymm1, ymm3, [r9 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a751 0
M2s_b92c
%endmacro
%macro M2s_a752 0
M2s_b92b
M2s_bf4
M2s_bf6
M2s_b620
M2s_b795
M2s_b851
M2s_a753
M2s_be4
M2s_bf9
M2s_bfc
M2s_b101
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a753 0
M2s_b92e
%endmacro
%macro M2s_a754 0
M2s_b92d
M2s_b100
M2s_bff
M2s_b621
M2s_b79b
M2s_b854
M2s_a755
M2s_bdc
M2s_be1
    vmovdqu ymm3, [rdx + 96]
M2s_b799
%endmacro
%macro M2s_a755 0
M2s_b931
%endmacro
%macro M2s_a756 0
M2s_b92f
M2s_b107
M2s_b109
M2s_b622
M2s_b79c
M2s_b856
M2s_a758
M2s_bf1
M2s_b10b
M2s_b623
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a757 0
M2s_b932
M2s_b62d
M2s_b624
M2s_b79f
M2s_b858
M2s_a75a
M2s_b6e4
M2s_b6e7
M2s_b6e9
M2s_b6ed
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a758 0
M2s_b934
%endmacro
%macro M2s_a759 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 416]
M2s_bf0
M2s_b10a
M2s_b10d
M2s_b62d
M2s_b624
M2s_b79f
M2s_b858
M2s_b933
M2s_b6ec
    vpermps ymm1, ymm3, [r9 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a75a 0
M2s_b935
%endmacro
%macro M2s_a75b 0
M2s_b933
M2s_b6ec
M2s_b6ef
M2s_b6f3
M2s_b7a1
M2s_b859
M2s_a75d
M2s_b731
M2s_b722
M2s_b7a3
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a75c 0
M2s_b936
M2s_b725
M2s_b726
M2s_b7a8
M2s_b85e
M2s_a75e
M2s_b7e2
M2s_b7c5
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a75d 0
M2s_b938
%endmacro
%macro M2s_a75e 0
M2s_b939
%endmacro
%macro M2s_a75f 0
M2s_b937
M2s_b7e3
M2s_b85f
M2s_a760
M2s_b887
M2s_b87f
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a760 0
M2s_b93b
%endmacro
%macro M2s_a761 0
M2s_b93a
M2s_b87e
M2s_b899
M2s_b883
M2s_b898
M2s_a764
    vfmadd231ps ymm6, ymm0, [rcx + 416]
    lea r13, [r9 + r14]
M2s_b8b5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_a762 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 432]
M2s_b885
M2s_b87e
M2s_b899
M2s_b883
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 340]
%endmacro
%macro M2s_a763 0
M2s_b93d
%endmacro
%macro M2s_a764 0
M2s_a763
M2s_b93e
%endmacro
%macro M2s_a765 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a766 0
M2s_b93c
M2s_b8bc
M2s_b8c3
M2s_b8c8
%endmacro
%macro M2s_a767 0
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 448]
M2s_b8ca
M2s_b8ce
M2s_b8d2
M2s_b8d3
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_b8c7
M2s_b8d4
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 232]
%endmacro
%macro M2s_a768 0
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_b8d7
M2s_b8dc
M2s_b8df
M2s_b8e6
M2s_b8eb
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b8ec
M2s_b8ee
M2s_b93f
%endmacro
%macro M2s_a769 0
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_b8e8
M2s_b8f6
M2s_b8f7
M2s_b8f8
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_b8f9
M2s_b8fb
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 248]
%endmacro
%macro M2s_a76a 0
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_b905
M2s_b90b
    vpermps ymm1, ymm3, [r13 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_b90a
M2s_b861
%endmacro
%macro M2s_a76b 0
    vpermps ymm1, ymm3, [r13 + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_b910
M2s_b912
    vpermps ymm1, ymm3, [r13 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_b90e
M2s_b913
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 264]
%endmacro
%macro M2s_a76c 0
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_b918
M2s_b91a
    vpermps ymm1, ymm3, [r13 + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 800]
M2s_b916
M2s_b91c
%endmacro
%macro M2s_a76d 0
    vpermps ymm1, ymm3, [r13 + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 832]
M2s_b91f
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b88f
M2s_b826
M2s_b89d
%endmacro
%macro M2s_a76e 0
M2s_a76f
M2s_b8a1
    vmovdqu ymm3, [rdx + 288]
M2s_b7eb
M2s_b8a2
M2s_b1a
M2s_b1c
M2s_b596
    vpermps ymm1, ymm3, [r8 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_a76f 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a770 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b8a0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b941
    vpermps ymm1, ymm3, [r8 + 72]
M2s_b1c
M2s_b597
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a771 0
M2s_b62a
M2s_b7d2
M2s_b86c
    vpermps ymm1, ymm3, [r8 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 392]
%endmacro
%macro M2s_a772 0
M2s_a771
M2s_b646
M2s_b27
M2s_b28
M2s_b59c
M2s_b73d
M2s_b7ed
M2s_b8a4
M2s_b2a
%endmacro
%macro M2s_a773 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 368]
M2s_b8a7
M2s_b2f
M2s_b32
M2s_b5a2
M2s_b64d
M2s_b8a5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 372]
M2s_b8a8
M2s_b39
M2s_b3e
M2s_b40
    vpermps ymm1, ymm3, [r8 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_a774 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 376]
M2s_b8a9
M2s_b48
M2s_b4b
M2s_b4e
M2s_b53
M2s_b52
M2s_b8aa
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 380]
M2s_b8ab
M2s_b55
M2s_b57
    vpermps ymm1, ymm3, [r8 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_a775 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 384]
M2s_b8af
M2s_b60
M2s_b65
M2s_b74b
M2s_b8ac
    vpermps ymm1, ymm3, [r8 + 324]
M2s_b8ad
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 388]
M2s_b8b0
M2s_b65d
M2s_b660
M2s_b74d
    vpermps ymm1, ymm3, [r8 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_a776 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 392]
M2s_b8b1
M2s_b72d
M2s_b711
M2s_b714
M2s_b716
M2s_b74f
M2s_b754
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 396]
M2s_b8b2
M2s_b7cf
M2s_b7bb
M2s_b7d0
    vpermps ymm1, ymm3, [r8 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_a777 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 400]
M2s_b8be
M2s_b86e
M2s_b871
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 308]
%endmacro
%macro M2s_a778 0
M2s_b6bf
M2s_b6c2
    vmovdqu ymm3, [rdx + 288]
M2s_b849
M2s_b927
M2s_bab
M2s_bc1
M2s_bc3
M2s_b601
M2s_b71e
M2s_b897
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 396]
M2s_bb3
M2s_b612
    vpermps ymm1, ymm3, [r9 + 80]
%endmacro
%macro M2s_a779 0
    vpermps ymm1, ymm3, [r9 + 368]
M2s_b92a
M2s_bcf
M2s_b615
M2s_b790
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b794
M2s_b850
M2s_b92c
M2s_be6
M2s_bee
M2s_beb
M2s_b61c
%endmacro
%macro M2s_a77a 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 384]
M2s_b934
M2s_bf1
M2s_b10b
M2s_b623
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b62e
M2s_b6df
M2s_b7a0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 388]
M2s_b935
M2s_b6e4
M2s_b6e7
M2s_b6e9
    vpermps ymm1, ymm3, [r9 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_a77b 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 400]
M2s_b93b
M2s_b887
M2s_b87f
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b882
    vpermps ymm1, ymm3, [r9 + 308]
%endmacro
%macro M2s_a77c 0
M2s_a77d
M2s_b7f5
M2s_b60
M2s_b65
M2s_b74b
M2s_b8ac
M2s_b943
M2s_b65d
M2s_b660
M2s_b74d
%endmacro
%macro M2s_a77d 0
M2s_b746
    vpermps ymm1, ymm3, [r8 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 352]
%endmacro
%macro M2s_a77e 0
M2s_b944
M2s_b946
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 280]
M2s_a781
    vpermps ymm1, ymm3, [r8 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a77f 0
M2s_a77e
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 448]
M2s_b7fc
M2s_b88a
M2s_b861
%endmacro
%macro M2s_a780 0
M2s_b947
M2s_a781
M2s_a782
%endmacro
%macro M2s_a781 0
M2s_b948
%endmacro
%macro M2s_a782 0
M2s_b949
%endmacro
%macro M2s_a783 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a784 0
    vmulps ymm5, ymm0, [rcx + 480]
M2s_b7fb
M2s_b863
M2s_b89a
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b80c
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_b80d
M2s_b864
M2s_b811
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a785 0
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_b809
M2s_b80b
M2s_b865
M2s_b89c
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_b81b
M2s_b867
M2s_b88e
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a786 0
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_b816
M2s_b868
M2s_b88f
M2s_b826
M2s_b89d
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_b828
M2s_b869
M2s_b891
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a787 0
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_b82f
M2s_b86a
M2s_b892
M2s_b833
M2s_b89e
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_b82e
M2s_b7a9
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a788 0
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_b838
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2s_b836
M2s_b83b
    vpermps ymm1, ymm3, [r13 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a789 0
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2s_b83e
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 832]
M2s_b83c
M2s_b841
    vpermps ymm1, ymm3, [r13 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a78a 0
    vfmadd231ps ymm5, ymm0, [rcx + 864]
M2s_b893
M2s_b895
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 896]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 56]
M2s_b76c
M2s_b76d
M2s_b774
M2s_b776
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a78b 0
M2s_b94b
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b7b0
M2s_b7da
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a78c 0
    vpermps ymm1, ymm3, [r13 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a78d 0
M2s_a78c
    vfmadd231ps ymm5, ymm0, [rcx + 928]
M2s_b6b5
M2s_b71c
M2s_b7db
M2s_b6b7
M2s_a78f
    vpermps ymm1, ymm3, [r9 + 352]
M2s_b5f4
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 164]
%endmacro
%macro M2s_a78e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b94d
M2s_bad
M2s_b5f1
    vpermps ymm1, ymm3, [r9 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_a78f 0
M2s_b896
%endmacro
%macro M2s_a790 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 272]
M2s_b72e
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 336]
%endmacro
%macro M2s_a791 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_a792 0
M2s_a793
M2s_a798
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 448]
M2s_b85c
M2s_b800
M2s_b860
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 256]
%endmacro
%macro M2s_a793 0
M2s_b94f
M2s_b951
M2s_a796
%endmacro
%macro M2s_a794 0
M2s_b950
M2s_b954
    vpermps ymm1, ymm3, [r9 + 376]
%endmacro
%macro M2s_a795 0
M2s_b955
M2s_a796
M2s_a798
%endmacro
%macro M2s_a796 0
M2s_b956
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a797 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_a798 0
    vpermps ymm1, ymm3, [r9 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 408]
%endmacro
%macro M2s_a799 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a79a 0
    vmulps ymm7, ymm0, [rcx + 480]
M2s_b7fb
M2s_b863
M2s_b89a
M2s_b94a
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_b80d
M2s_b864
M2s_b811
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a79b 0
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b809
M2s_b80b
M2s_b865
M2s_b89c
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_b81b
M2s_b867
M2s_b88e
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a79c 0
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_b816
M2s_b868
M2s_b88f
M2s_b826
M2s_b89d
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_b828
M2s_b869
M2s_b891
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a79d 0
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_b82f
M2s_b86a
M2s_b892
M2s_b833
M2s_b89e
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_b82e
M2s_b7a9
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a79e 0
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_b838
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_b836
M2s_b83b
    vpermps ymm1, ymm3, [r13 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a79f 0
    vfmadd231ps ymm7, ymm0, [rcx + 800]
M2s_b83e
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 832]
M2s_b83c
M2s_b841
    vpermps ymm1, ymm3, [r13 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a7a0 0
    vfmadd231ps ymm7, ymm0, [rcx + 864]
M2s_b893
M2s_b895
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 896]
M2s_b94b
M2s_b94c
    vpermps ymm1, ymm3, [r13 + 312]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a7a1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a7a2
M2s_b112
M2s_b6f9
M2s_b11f
    vpermps ymm0, ymm3, [r8 + 0]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 32]
%endmacro
%macro M2s_a7a2 0
M2s_b957
%endmacro
%macro M2s_a7a3 0
    vpermps ymm1, ymm3, [r8 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 352]
%endmacro
%macro M2s_a7a4 0
    vfmadd231ps ymm4, ymm0, [rcx + 416]
M2s_b944
M2s_b946
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 280]
M2s_b948
    vpermps ymm1, ymm3, [r8 + 376]
%endmacro
%macro M2s_a7a5 0
M2s_b71f
%endmacro
%macro M2s_a7a6 0
    vmovdqu ymm3, [rdx + 288]
M2s_b7f1
M2s_b8a9
M2s_b48
M2s_b4b
M2s_b4e
M2s_b53
M2s_b52
M2s_b8aa
M2s_b942
M2s_b56
    vpermps ymm1, ymm3, [r8 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_a7a7 0
M2s_a7a8
M2s_b948
M2s_b949
M2s_b959
    vfmadd231ps ymm4, ymm0, [rcx + 448]
M2s_b8b3
M2s_b8b8
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7a8 0
    vmovdqu ymm3, [rdx + 288]
M2s_b888
M2s_b8bf
M2s_b958
M2s_b945
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 280]
%endmacro
%macro M2s_a7a9 0
    vmulps ymm5, ymm0, [rcx + 480]
M2s_b8ca
M2s_b8ce
M2s_b8d2
M2s_b8d3
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_b8c7
M2s_b8d4
M2s_b95a
%endmacro
%macro M2s_a7aa 0
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_b8d7
M2s_b8dc
M2s_b8df
M2s_b8e6
M2s_b8eb
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_b8ec
M2s_b8ee
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 240]
%endmacro
%macro M2s_a7ab 0
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_b8e8
M2s_b8f6
M2s_b8f7
M2s_b8f8
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_b8f9
M2s_b8fb
M2s_b95b
%endmacro
%macro M2s_a7ac 0
    vpermps ymm1, ymm3, [r13 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_b905
M2s_b90b
    vpermps ymm1, ymm3, [r13 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_b90a
M2s_b860
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 256]
%endmacro
%macro M2s_a7ad 0
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_b910
M2s_b912
    vpermps ymm1, ymm3, [r13 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2s_b90e
M2s_b915
%endmacro
%macro M2s_a7ae 0
    vpermps ymm1, ymm3, [r13 + 424]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2s_b918
M2s_b91a
    vpermps ymm1, ymm3, [r13 + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 832]
M2s_b916
M2s_b91d
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 272]
%endmacro
%macro M2s_a7af 0
    vfmadd231ps ymm5, ymm0, [rcx + 864]
M2s_b920
M2s_b921
    vpermps ymm1, ymm3, [r13 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 896]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 56]
M2s_b829
M2s_b82a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a7b0 0
M2s_b95c
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b890
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b82d
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7b1 0
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a7b2
    vpermps ymm1, ymm3, [r13 + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7b2 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_a7b3 0
M2s_a7b2
    vpermps ymm1, ymm3, [r13 + 440]
M2s_b94e
M2s_b789
M2s_b845
M2s_b922
    vpermps ymm1, ymm3, [r9 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_a7b4 0
    vmovdqu ymm3, [rdx + 288]
M2s_b851
M2s_b92e
M2s_be4
M2s_bf9
M2s_bfc
M2s_b101
M2s_b103
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 284]
M2s_b72f
    vmovdqu ymm3, [rdx + 288]
M2s_b854
M2s_b931
M2s_bdc
M2s_be1
M2s_b930
%endmacro
%macro M2s_a7b5 0
    vmovdqu ymm3, [rdx + 288]
M2s_b93d
M2s_b93e
M2s_b950
M2s_b953
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 280]
%endmacro
%macro M2s_a7b6 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 448]
M2s_b93c
M2s_b8bc
M2s_b8c3
M2s_b8c8
M2s_b8c9
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 480]
M2s_b8ca
M2s_b8cf
%endmacro
%macro M2s_a7b7 0
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_b8c7
M2s_b8d4
M2s_b95a
M2s_b8e2
M2s_b8e3
M2s_b8e5
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b8d7
M2s_b8db
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 236]
%endmacro
%macro M2s_a7b8 0
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_b8ec
M2s_b8ee
M2s_b93f
M2s_b8f2
M2s_b8f3
M2s_b8f5
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_b8e8
M2s_b8f6
%endmacro
%macro M2s_a7b9 0
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_b8f9
M2s_b8fb
M2s_b95b
M2s_b8ff
M2s_b901
M2s_b903
    vpermps ymm1, ymm3, [r13 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_b904
M2s_b907
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 252]
%endmacro
%macro M2s_a7ba 0
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_b90a
M2s_b861
M2s_b90c
M2s_b90f
    vpermps ymm1, ymm3, [r13 + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_b911
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b89b
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a7bb 0
    vpermps ymm1, ymm3, [r13 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_b90e
M2s_b914
M2s_b917
    vpermps ymm1, ymm3, [r13 + 424]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 800]
M2s_b919
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b88c
    vpermps ymm1, ymm3, [r13 + 268]
%endmacro
%macro M2s_a7bc 0
    vfmadd231ps ymm7, ymm0, [rcx + 832]
M2s_b916
M2s_b91b
M2s_b91e
    vpermps ymm1, ymm3, [r13 + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 864]
M2s_b91f
M2s_b940
%endmacro
%macro M2s_a7bd 0
    vpermps ymm1, ymm3, [r13 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 896]
M2s_b95c
M2s_b95e
    vpermps ymm1, ymm3, [r13 + 312]
M2s_b95f
%endmacro
%macro M2s_a7be 0
    vpermps ymm1, ymm3, [r9 + 436]
M2s_b94f
M2s_b951
M2s_b956
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7bf 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7c0 0
    vpermps ymm1, ymm3, [r8 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 416]
M2s_b119
M2s_b16
M2s_b17
M2s_b59a
M2s_b737
M2s_b7eb
M2s_b8a2
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 420]
M2s_b644
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 168]
%endmacro
%macro M2s_a7c1 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 424]
M2s_b646
M2s_b27
M2s_b28
M2s_b59c
M2s_b73d
M2s_b7ed
M2s_b8a4
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 428]
M2s_b5a4
M2s_b2c
%endmacro
%macro M2s_a7c2 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 432]
M2s_b64b
M2s_b34
M2s_b35
M2s_b5a7
M2s_b742
M2s_b7ef
M2s_b8a8
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 436]
M2s_b38
M2s_b44
%endmacro
%macro M2s_a7c3 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 440]
M2s_b47
M2s_b4a
M2s_b4d
M2s_b50
M2s_b51
M2s_b5a8
M2s_b747
M2s_b7f3
M2s_b8ab
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 444]
M2s_b54
M2s_b59
%endmacro
%macro M2s_a7c4 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 448]
M2s_b5e
M2s_b70f
M2s_b5aa
M2s_b74e
M2s_b7f6
M2s_b8b0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 452]
M2s_b65c
M2s_b664
%endmacro
%macro M2s_a7c5 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 456]
M2s_b72c
M2s_b713
M2s_b717
M2s_b753
M2s_b7fa
M2s_b8b2
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 460]
M2s_b7ce
M2s_b7be
%endmacro
%macro M2s_a7c6 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 464]
M2s_b86d
M2s_b870
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b8bd
M2s_b874
M2s_b889
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 468]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b958
    vpermps ymm1, ymm3, [r8 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_a7c7 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r8 + 472]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 448]
    lea r13, [r8 + r14]
M2s_a7c8
M2s_a7c9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 480]
M2s_b960
M2s_b961
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7c8 0
M2s_b962
%endmacro
%macro M2s_a7c9 0
M2s_b963
%endmacro
%macro M2s_a7ca 0
M2s_b960
M2s_b961
M2s_b964
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b965
M2s_b966
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7cb 0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a7cc
M2s_a7ce
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a7cf
M2s_b967
%endmacro
%macro M2s_a7cc 0
M2s_b965
M2s_b966
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_a7cd 0
    vmovdqu ymm3, [rdx + 736]
M2s_b968
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 420]
%endmacro
%macro M2s_a7ce 0
M2s_b968
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7cf 0
M2s_b969
%endmacro
%macro M2s_a7d0 0
M2s_b967
M2s_b96a
%endmacro
%macro M2s_a7d1 0
M2s_b96a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_a7d2
M2s_a7d4
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_b96b
%endmacro
%macro M2s_a7d2 0
M2s_b96c
M2s_b96d
    vmovdqu ymm3, [rdx + 608]
M2s_b96e
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7d3 0
M2s_b96e
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b96f
    vpermps ymm1, ymm3, [r13 + 396]
%endmacro
%macro M2s_a7d4 0
M2s_b96f
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 428]
%endmacro
%macro M2s_a7d5 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7d6 0
M2s_b96b
M2s_b970
%endmacro
%macro M2s_a7d7 0
M2s_b970
M2s_a7d8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_a7d9
M2s_b971
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7d8 0
M2s_b972
%endmacro
%macro M2s_a7d9 0
M2s_b973
M2s_b974
    vmovdqu ymm3, [rdx + 608]
M2s_b975
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7da 0
M2s_b975
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b971
    vpermps ymm1, ymm3, [r13 + 404]
%endmacro
%macro M2s_a7db 0
M2s_b971
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 436]
%endmacro
%macro M2s_a7dc 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7dd 0
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_a7de
M2s_a7df
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_b976
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_a7de 0
M2s_b977
%endmacro
%macro M2s_a7df 0
M2s_b978
%endmacro
%macro M2s_a7e0 0
M2s_b976
M2s_b979
    vmovdqu ymm3, [rdx + 608]
M2s_b97a
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7e1 0
    vpermps ymm1, ymm3, [r13 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
M2s_a7e2
M2s_a7e4
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_a7e5
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 384]
M2s_a7e6
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 448]
%endmacro
%macro M2s_a7e2 0
M2s_b97a
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b97b
    vpermps ymm1, ymm3, [r13 + 412]
%endmacro
%macro M2s_a7e3 0
M2s_b97b
    vpermps ymm1, ymm3, [r13 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 444]
%endmacro
%macro M2s_a7e4 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 444]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7e5 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_b8b7
M2s_b8ba
    vmovdqu ymm3, [rdx + 544]
M2s_b8c2
M2s_b8c6
    vpermps ymm1, ymm3, [r13 + 320]
M2s_b8c9
%endmacro
%macro M2s_a7e6 0
M2s_b97d
%endmacro
%macro M2s_a7e7 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_a7e8
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 388]
M2s_a7e9
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 452]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_b8d5
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7e8 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_b8cb
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
M2s_b8d2
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7e9 0
M2s_b980
%endmacro
%macro M2s_a7ea 0
M2s_b97e
M2s_b8d6
M2s_b8e1
M2s_b8e4
%endmacro
%macro M2s_a7eb 0
M2s_b981
%endmacro
%macro M2s_a7ec 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2s_a7ed
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 396]
M2s_a7ee
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 460]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 832]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 48]
M2s_b8ed
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7ed 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_b8d9
M2s_b8dd
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7ee 0
M2s_b984
%endmacro
%macro M2s_a7ef 0
M2s_b982
M2s_b8ef
M2s_b8f1
M2s_b8f4
%endmacro
%macro M2s_a7f0 0
M2s_b985
%endmacro
%macro M2s_a7f1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 864]
M2s_a7f2
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 404]
M2s_a7f3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 468]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 896]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 56]
M2s_b8fa
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7f2 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 52]
M2s_b8e9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 180]
M2s_b8f6
M2s_b8f7
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7f3 0
M2s_b988
%endmacro
%macro M2s_a7f4 0
M2s_b986
M2s_b8fc
M2s_b8fe
M2s_b902
%endmacro
%macro M2s_a7f5 0
M2s_b989
%endmacro
%macro M2s_a7f6 0
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [r13 + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
%endmacro
%macro M2s_a7f7 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 416]
M2s_b5f4
M2s_bb6
M2s_bb7
M2s_b5ff
M2s_b78b
M2s_b847
M2s_b924
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 420]
M2s_b6bc
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_a7f8 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 424]
M2s_b609
M2s_bc6
M2s_bc5
M2s_b610
M2s_b78e
M2s_b84c
M2s_b928
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 428]
M2s_bb3
M2s_b611
%endmacro
%macro M2s_a7f9 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 432]
M2s_bce
M2s_bd5
M2s_bd8
M2s_bd9
M2s_b61f
M2s_b794
M2s_b850
M2s_b92c
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 436]
M2s_b793
M2s_bf4
%endmacro
%macro M2s_a7fa 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 440]
M2s_be3
M2s_bf8
M2s_bfb
M2s_b100
M2s_bff
M2s_b621
M2s_b79b
M2s_b854
M2s_b931
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 444]
M2s_be5
M2s_be0
M2s_b104
M2s_b107
%endmacro
%macro M2s_a7fb 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 448]
M2s_bf0
M2s_b10a
M2s_b10d
M2s_b62d
M2s_b624
M2s_b79f
M2s_b858
M2s_b935
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 452]
M2s_b6e2
M2s_b6ec
%endmacro
%macro M2s_a7fc 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 456]
M2s_b730
M2s_b725
M2s_b726
M2s_b7a8
M2s_b85e
M2s_b939
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 460]
M2s_b7e1
M2s_b7e4
%endmacro
%macro M2s_a7fd 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 464]
M2s_b886
M2s_b93d
M2s_b93e
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 468]
M2s_b94f
M2s_b952
%endmacro
%macro M2s_a7fe 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r9 + 472]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 448]
    lea r13, [r9 + r14]
M2s_b962
M2s_b963
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 480]
M2s_b960
M2s_b961
M2s_b964
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a7ff 0
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_b969
M2s_b967
M2s_b96a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b96c
M2s_b96d
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a800 0
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_b96b
M2s_b970
M2s_b972
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_b973
M2s_b974
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a801 0
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_b977
M2s_b978
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_b976
M2s_b979
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a802 0
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_b97c
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 384]
M2s_b97d
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 448]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_b97f
M2s_b8d0
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_a803 0
    vpermps ymm1, ymm3, [r13 + 388]
M2s_b980
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 452]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_b97e
M2s_b8d6
M2s_b8e1
M2s_b8e4
M2s_a804
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 800]
M2s_b983
M2s_b8da
    vpermps ymm1, ymm3, [r13 + 172]
%endmacro
%macro M2s_a804 0
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 392]
M2s_b981
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 456]
%endmacro
%macro M2s_a805 0
    vpermps ymm1, ymm3, [r13 + 396]
M2s_b984
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 460]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 832]
M2s_b982
M2s_b8ef
M2s_b8f1
M2s_b8f4
M2s_a806
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 864]
M2s_b987
M2s_b8ea
    vpermps ymm1, ymm3, [r13 + 180]
%endmacro
%macro M2s_a806 0
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 400]
M2s_b985
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 464]
%endmacro
%macro M2s_a807 0
    vpermps ymm1, ymm3, [r13 + 404]
M2s_b988
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 468]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 896]
M2s_b986
M2s_b8fc
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a808 0
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 408]
M2s_b989
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 472]
%endmacro
%macro M2s_a809 0
    vpermps ymm1, ymm3, [r13 + 472]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b957
    vaddps ymm0, ymm4, ymm5
    vpermpd ymm0, ymm0, 0xd8
%endmacro
%macro M2s_a80a 0
M2s_b629
M2s_b86b
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a80b 0
M2s_b959
%endmacro
%macro M2s_a80c 0
    vmovups ymm8, [c_q8e0]
M2s_b3c4
M2s_b3c6
    vpmaxud ymm3, ymm1, ymm14
    vpsrld ymm4, ymm3, 23
M2s_b3cb
    vpermps ymm9, ymm5, [c_rxe]
    vmovups ymm10, [r8]
    vmovups ymm0, [r8+32]
M2s_b3cc
    vpsubd ymm4, ymm9, ymm7
    vfmadd213ps ymm3, ymm4, ymm12
%endmacro
%macro M2s_a80d 0
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
M2s_b8b4
M2s_b8bc
M2s_b8c4
%endmacro
%macro M2s_a80e 0
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 512]
M2s_b8ca
M2s_b8ce
M2s_b8d2
M2s_b8d3
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_b8c7
M2s_b8d4
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_a80f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 576]
M2s_b8d7
M2s_b8dc
M2s_b8df
M2s_b8e6
M2s_b8eb
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 608]
M2s_b8ec
M2s_b8ee
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a810 0
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 640]
M2s_b8e8
M2s_b8f6
M2s_b8f7
M2s_b8f8
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_b8f9
M2s_b8fb
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 248]
%endmacro
%macro M2s_a811 0
    vfmadd231ps ymm5, ymm0, [rcx + 704]
M2s_b905
M2s_b90b
    vpermps ymm1, ymm3, [r13 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_b90a
M2s_b861
%endmacro
%macro M2s_a812 0
    vpermps ymm1, ymm3, [r13 + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 768]
M2s_b910
M2s_b912
    vpermps ymm1, ymm3, [r13 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 800]
M2s_b90e
M2s_b913
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 264]
%endmacro
%macro M2s_a813 0
    vfmadd231ps ymm5, ymm0, [rcx + 832]
M2s_b918
M2s_b91a
    vpermps ymm1, ymm3, [r13 + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 864]
M2s_b916
M2s_b91c
%endmacro
%macro M2s_a814 0
    vpermps ymm1, ymm3, [r13 + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 896]
M2s_b920
M2s_b921
    vpermps ymm1, ymm3, [r13 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 928]
M2s_b95c
M2s_b95d
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 280]
%endmacro
%macro M2s_a815 0
    vfmadd231ps ymm5, ymm0, [rcx + 960]
M2s_a816
M2s_a818
    vpermps ymm1, ymm3, [r13 + 444]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 992]
M2s_b6b5
M2s_b71c
M2s_b7dc
M2s_b5f2
%endmacro
%macro M2s_a816 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 60]
M2s_b830
M2s_b832
M2s_b834
    vpermps ymm1, ymm3, [r13 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a817 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a818 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_a819 0
    vpermps ymm1, ymm3, [r9 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b923
M2s_b89f
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 356]
M2s_b924
M2s_bb9
M2s_bbb
M2s_b5fc
%endmacro
%macro M2s_a81a 0
    vmovdqu ymm3, [rdx + 288]
M2s_b859
M2s_b938
M2s_b731
M2s_b722
M2s_b7a3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
M2s_b7a7
M2s_b727
    vmovdqu ymm3, [rdx + 288]
M2s_b85e
M2s_b939
M2s_b7e2
%endmacro
%macro M2s_a81b 0
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
M2s_b93c
M2s_b8bc
M2s_b8c4
%endmacro
%macro M2s_a81c 0
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 512]
M2s_b8ca
M2s_b8ce
M2s_b8d2
M2s_b8d3
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_b8c7
M2s_b8d4
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_a81d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_b8d7
M2s_b8dc
M2s_b8df
M2s_b8e6
M2s_b8eb
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 608]
M2s_b8ec
M2s_b8ee
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a81e 0
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 640]
M2s_b8e8
M2s_b8f6
M2s_b8f7
M2s_b8f8
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
M2s_b8f9
M2s_b8fb
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 248]
%endmacro
%macro M2s_a81f 0
    vfmadd231ps ymm7, ymm0, [rcx + 704]
M2s_b905
M2s_b90b
    vpermps ymm1, ymm3, [r13 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
M2s_b90a
M2s_b861
%endmacro
%macro M2s_a820 0
    vpermps ymm1, ymm3, [r13 + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 768]
M2s_b910
M2s_b912
    vpermps ymm1, ymm3, [r13 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 800]
M2s_b90e
M2s_b913
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 264]
%endmacro
%macro M2s_a821 0
    vfmadd231ps ymm7, ymm0, [rcx + 832]
M2s_b918
M2s_b91a
    vpermps ymm1, ymm3, [r13 + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 864]
M2s_b916
M2s_b91c
%endmacro
%macro M2s_a822 0
    vpermps ymm1, ymm3, [r13 + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 896]
M2s_b920
M2s_b921
    vpermps ymm1, ymm3, [r13 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 928]
M2s_b95c
M2s_b95d
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 280]
%endmacro
%macro M2s_a823 0
    vfmadd231ps ymm7, ymm0, [rcx + 960]
M2s_b98a
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b892
M2s_b833
M2s_b89e
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 380]
%endmacro
%macro M2s_a824 0
    vpermps ymm1, ymm3, [r13 + 444]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 992]
M2s_b118
    vpermpd ymm0, ymm0, 0xd8
%endmacro
%macro M2s_a825 0
    xor edx, edx
M2s_b705
M2s_b46c
M2s_b470
    mov rcx, [r12 + 1344]
M2s_b706
    vshufps xmm1, xmm15, xmm15, 170
    mov rcx, [r12 + 1360]
%endmacro
%macro M2s_a826 0
    vmovdqu ymm8, [rdx + 0]
    vmovdqu ymm9, [rdx + 32]
    vmovups ymm3, [rcx + 0]
    vmovups ymm10, [rcx + 32]
%endmacro
%macro M2s_a827 0
M2s_a826
    vmovups ymm11, [rcx + 64]
    vmovups ymm12, [rcx + 96]
M2s_b8
M2s_b9
    mov rbx, [rdi + G_gp]
    shl rbx, 2
%endmacro
%macro M2s_a828 0
M2s_b98b
%endmacro
%macro M2s_a829 0
    vpermps ymm0, ymm8, [r8 + 0]
    vmulps ymm4, ymm0, ymm3
    vpermps ymm0, ymm8, [r8 + 4]
    vfmadd231ps ymm4, ymm0, ymm10
    lea r13, [r8 + r14]
    vpermps ymm0, ymm9, [r13 + 0]
    vmulps ymm5, ymm0, ymm11
    vpermps ymm0, ymm9, [r13 + 4]
M2s_a82a
    vpermps ymm0, ymm8, [r9 + 0]
    vmulps ymm6, ymm0, ymm3
    vpermps ymm0, ymm8, [r9 + 4]
    vfmadd231ps ymm6, ymm0, ymm10
%endmacro
%macro M2s_a82a 0
M2s_b98c
%endmacro
%macro M2s_a82b 0
    vshufps ymm2, ymm4, ymm5, 0x88
    vshufps ymm5, ymm4, ymm5, 0xdd
    vmovaps ymm4, ymm2
    vpermps ymm0, ymm8, [r9 + 0]
%endmacro
%macro M2s_a82c 0
    lea r13, [r9 + r14]
    vpermps ymm0, ymm9, [r13 + 0]
    vmulps ymm7, ymm0, ymm11
    vpermps ymm0, ymm9, [r13 + 4]
M2s_b98d
%endmacro
%macro M2s_a82d 0
M2s_b98d
M2s_b112
M2s_b6f8
%endmacro
%macro M2s_a82e 0
M2s_b98e
%endmacro
%macro M2s_a82f 0
    vpermps ymm0, ymm8, [r8 + 0]
M2s_a830
    vpermps ymm1, ymm8, [r8 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm10
M2s_a833
    vmulps ymm5, ymm0, ymm11
    vpermps ymm0, ymm9, [r13 + 4]
    vpermps ymm1, ymm9, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_b98c
    vpermps ymm0, ymm8, [r9 + 0]
M2s_a834
    vpermps ymm1, ymm8, [r9 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm6, ymm0, ymm10
M2s_a836
%endmacro
%macro M2s_a830 0
    vpermps ymm1, ymm8, [r8 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vmulps ymm4, ymm0, ymm3
    vpermps ymm0, ymm8, [r8 + 4]
%endmacro
%macro M2s_a831 0
M2s_b98f
%endmacro
%macro M2s_a832 0
M2s_b990
%endmacro
%macro M2s_a833 0
M2s_b991
%endmacro
%macro M2s_a834 0
M2s_b992
%endmacro
%macro M2s_a835 0
M2s_b993
%endmacro
%macro M2s_a836 0
M2s_b994
%endmacro
%macro M2s_a837 0
    vmulps ymm7, ymm0, ymm11
    vpermps ymm0, ymm9, [r13 + 4]
    vpermps ymm1, ymm9, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_b98d
%endmacro
%macro M2s_a838 0
M2s_b995
%endmacro
%macro M2s_a839 0
    add r9, rbx
    vmovaps ymm15, ymm4
    vpermps ymm0, ymm8, [r8 + 0]
    vpermps ymm1, ymm8, [r8 + 32]
%endmacro
%macro M2s_a83a 0
M2s_a839
M2s_b98f
%endmacro
%macro M2s_a83b 0
    vmovaps ymm15, ymm4
    vpermps ymm0, ymm8, [r8 + 0]
    vpermps ymm1, ymm8, [r8 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm8
%endmacro
%macro M2s_a83c 0
    vmovups ymm11, [rcx + 64]
    vmovups ymm12, [rcx + 96]
    vmovups ymm13, [rcx + 128]
M2s_b8
M2s_b9
M2s_b98b
    vpermps ymm1, ymm8, [r8 + 32]
%endmacro
%macro M2s_a83d 0
M2s_a83e
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm11
M2s_b991
    vmulps ymm5, ymm0, ymm12
    vpermps ymm0, ymm9, [r13 + 4]
    vpermps ymm1, ymm9, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm5, ymm0, ymm13
    vpermps ymm0, ymm9, [r13 + 8]
    vpermps ymm1, ymm9, [r13 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_a840
    vpermps ymm0, ymm8, [r9 + 0]
M2s_b992
M2s_a841
    vpermps ymm1, ymm8, [r9 + 40]
%endmacro
%macro M2s_a83e 0
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm10
    vpermps ymm0, ymm8, [r8 + 8]
    vpermps ymm1, ymm8, [r8 + 40]
%endmacro
%macro M2s_a83f 0
M2s_b997
%endmacro
%macro M2s_a840 0
M2s_b998
%endmacro
%macro M2s_a841 0
M2s_b999
%endmacro
%macro M2s_a842 0
    vpermps ymm0, ymm8, [r9 + 8]
    vpermps ymm1, ymm8, [r9 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm6, ymm0, ymm11
%endmacro
%macro M2s_a843 0
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm6, ymm0, ymm11
M2s_b994
    vmulps ymm7, ymm0, ymm12
    vpermps ymm0, ymm9, [r13 + 4]
    vpermps ymm1, ymm9, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm7, ymm0, ymm13
    vpermps ymm0, ymm9, [r13 + 8]
    vpermps ymm1, ymm9, [r13 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm7, ymm0, [rcx + 160]
    vshufps ymm2, ymm6, ymm7, 0x88
%endmacro
%macro M2s_a844 0
    vfmadd231ps ymm7, ymm0, [rcx + 160]
M2s_b118
M2s_b114
M2s_b6fa
    vpermpd ymm5, ymm5, 0xd8
    cmp qword [rbp + 40], 0
    jne .hf
%endmacro
%macro M2s_a845 0
M2s_a846
    vmovups ymm3, [rcx + 0]
    vmovups ymm12, [rcx + 32]
    vmovups ymm13, [rcx + 64]
M2s_b8
M2s_b9
    mov rbx, [rdi + G_gp]
%endmacro
%macro M2s_a846 0
    vmovdqu ymm8, [rdx + 0]
    vmovdqu ymm9, [rdx + 32]
    vmovdqu ymm10, [rdx + 64]
    vmovdqu ymm11, [rdx + 96]
%endmacro
%macro M2s_a847 0
M2s_a849
M2s_b990
    vpermps ymm1, ymm9, [r8 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_a84c
    vpermps ymm1, ymm9, [r8 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm9
%endmacro
%macro M2s_a848 0
M2s_a847
    vfmadd231ps ymm4, ymm0, ymm13
M2s_a84f
    vpermps ymm1, ymm11, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm11
    vmulps ymm5, ymm0, [rcx + 96]
M2s_a851
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm5, ymm0, [rcx + 128]
M2s_a852
    vblendvps ymm0, ymm0, ymm1, ymm11
M2s_b998
M2s_a853
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm6, ymm0, ymm13
M2s_a858
    vpermps ymm1, ymm11, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm11
    vmulps ymm7, ymm0, [rcx + 96]
%endmacro
%macro M2s_a849 0
M2s_b99a
%endmacro
%macro M2s_a84a 0
    vblendvps ymm0, ymm0, ymm1, ymm8
M2s_a84b
M2s_a84c
    vpermps ymm1, ymm9, [r8 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm4, ymm0, ymm13
%endmacro
%macro M2s_a84b 0
    vpermps ymm1, ymm9, [r8 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_b990
    vpermps ymm1, ymm9, [r8 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm9
%endmacro
%macro M2s_a84c 0
    vfmadd231ps ymm4, ymm0, ymm12
    vpermps ymm0, ymm8, [r8 + 8]
    vpermps ymm1, ymm8, [r8 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm8
%endmacro
%macro M2s_a84d 0
M2s_b99c
%endmacro
%macro M2s_a84e 0
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r8 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm4, ymm0, ymm13
%endmacro
%macro M2s_a84f 0
M2s_b99d
%endmacro
%macro M2s_a850 0
    vpermps ymm0, ymm10, [r13 + 0]
    vpermps ymm1, ymm10, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vpermps ymm1, ymm11, [r13 + 64]
%endmacro
%macro M2s_a851 0
M2s_b99e
%endmacro
%macro M2s_a852 0
M2s_b99f
%endmacro
%macro M2s_a853 0
M2s_a854
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_b993
M2s_b9a1
%endmacro
%macro M2s_a854 0
M2s_b9a2
%endmacro
%macro M2s_a855 0
M2s_a856
M2s_b993
M2s_b9a1
    vblendvps ymm0, ymm0, ymm1, ymm9
%endmacro
%macro M2s_a856 0
    vpermps ymm1, ymm8, [r9 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r9 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm9
%endmacro
%macro M2s_a857 0
M2s_b9a3
%endmacro
%macro M2s_a858 0
M2s_b9a4
%endmacro
%macro M2s_a859 0
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm7, ymm0, [rcx + 128]
M2s_b99f
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm7, ymm0, [rcx + 160]
%endmacro
%macro M2s_a85a 0
M2s_a85b
M2s_b25c
M2s_b1c8
M2s_b1cf
M2s_b1d4
M2s_b264
%endmacro
%macro M2s_a85b 0
    vmovups ymm14, [c_mone]
    vmovups ymm13, [c_q8o3]
    vmovups ymm12, [c_q8o2]
    vmovups ymm11, [c_q8o1]
%endmacro
%macro M2s_a85c 0
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm11
    vpermps ymm0, ymm8, [r8 + 12]
    vpermps ymm1, ymm8, [r8 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm12
M2s_b991
    vmulps ymm5, ymm0, ymm13
    vpermps ymm0, ymm9, [r13 + 4]
    vpermps ymm1, ymm9, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm5, ymm0, [rcx + 160]
    vpermps ymm0, ymm9, [r13 + 8]
    vpermps ymm1, ymm9, [r13 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm5, ymm0, [rcx + 192]
    vpermps ymm0, ymm9, [r13 + 12]
    vpermps ymm1, ymm9, [r13 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_a85d
M2s_b996
    vpermps ymm0, ymm8, [r9 + 4]
M2s_b999
    vpermps ymm1, ymm8, [r9 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm6, ymm0, ymm11
    vpermps ymm0, ymm8, [r9 + 12]
    vpermps ymm1, ymm8, [r9 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm6, ymm0, ymm12
M2s_b994
    vmulps ymm7, ymm0, ymm13
    vpermps ymm0, ymm9, [r13 + 4]
    vpermps ymm1, ymm9, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm7, ymm0, [rcx + 160]
    vpermps ymm0, ymm9, [r13 + 8]
    vpermps ymm1, ymm9, [r13 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm7, ymm0, [rcx + 192]
    vpermps ymm0, ymm9, [r13 + 12]
    vpermps ymm1, ymm9, [r13 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm7, ymm0, [rcx + 224]
M2s_b118
    vpermpd ymm0, ymm0, 0xd8
%endmacro
%macro M2s_a85d 0
M2s_b9a6
%endmacro
%macro M2s_a85e 0
M2s_b9a5
M2s_b112
M2s_b6f8
%endmacro
%macro M2s_a85f 0
    shl rbx, 2
M2s_b98e
M2s_b99b
    vfmadd231ps ymm4, ymm0, ymm12
    vpermps ymm0, ymm8, [r8 + 8]
    vpermps ymm1, ymm8, [r8 + 40]
%endmacro
%macro M2s_a860 0
    vfmadd231ps ymm4, ymm0, ymm13
M2s_a861
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm4, ymm0, [rcx + 96]
M2s_b99d
    vpermps ymm1, ymm11, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm11
    vmulps ymm5, ymm0, [rcx + 128]
M2s_b99e
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm5, ymm0, [rcx + 160]
M2s_b99f
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm5, ymm0, [rcx + 192]
M2s_a862
    vblendvps ymm0, ymm0, ymm1, ymm11
M2s_b9a6
M2s_b9a2
M2s_b9a0
M2s_b9a3
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_a863
    vpermps ymm1, ymm9, [r9 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm6, ymm0, [rcx + 96]
M2s_b9a4
    vpermps ymm1, ymm11, [r13 + 64]
%endmacro
%macro M2s_a861 0
M2s_b9a7
%endmacro
%macro M2s_a862 0
M2s_b9a8
%endmacro
%macro M2s_a863 0
M2s_b9a9
%endmacro
%macro M2s_a864 0
M2s_b9aa
%endmacro
%macro M2s_a865 0
    vblendvps ymm0, ymm0, ymm1, ymm11
    vmulps ymm7, ymm0, [rcx + 128]
M2s_b99e
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm7, ymm0, [rcx + 160]
M2s_b99f
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm7, ymm0, [rcx + 192]
    vpermps ymm0, ymm10, [r13 + 12]
    vpermps ymm1, ymm10, [r13 + 44]
%endmacro
%macro M2s_a866 0
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm7, ymm0, [rcx + 224]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
%endmacro
%macro M2s_a867 0
    vmovdqu ymm12, [rdx + 128]
    vmovdqu ymm13, [rdx + 160]
    vmovups ymm3, [rcx + 0]
M2s_b8
M2s_b9
M2s_b98b
    vpermps ymm1, ymm8, [r8 + 32]
%endmacro
%macro M2s_a868 0
    vpermps ymm1, ymm10, [r8 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm10
M2s_b990
    vpermps ymm1, ymm9, [r8 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r8 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 32]
M2s_b99c
    vblendvps ymm0, ymm0, ymm1, ymm9
%endmacro
%macro M2s_a869 0
M2s_a868
M2s_a86a
    vpermps ymm1, ymm10, [r8 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 96]
M2s_a86b
    vmulps ymm5, ymm0, [rcx + 128]
M2s_a86d
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 160]
M2s_a86e
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 192]
M2s_a86f
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm13
M2s_b9a6
    vpermps ymm0, ymm8, [r9 + 0]
%endmacro
%macro M2s_a86a 0
    vpermps ymm1, ymm10, [r8 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 64]
M2s_b9a7
    vblendvps ymm0, ymm0, ymm1, ymm9
%endmacro
%macro M2s_a86b 0
    lea r13, [r8 + r14]
M2s_a86c
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm13
%endmacro
%macro M2s_a86c 0
M2s_b9ad
%endmacro
%macro M2s_a86d 0
M2s_b9ae
%endmacro
%macro M2s_a86e 0
M2s_b9af
%endmacro
%macro M2s_a86f 0
M2s_b9b0
%endmacro
%macro M2s_a870 0
    vpermps ymm1, ymm12, [r13 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm13
%endmacro
%macro M2s_a871 0
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm10
M2s_b993
    vpermps ymm1, ymm9, [r9 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r9 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm6, ymm0, [rcx + 32]
M2s_b9a3
%endmacro
%macro M2s_a872 0
M2s_a873
M2s_a876
    vpermps ymm1, ymm10, [r9 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm6, ymm0, [rcx + 96]
M2s_a878
    vmulps ymm7, ymm0, [rcx + 128]
M2s_b9ae
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm7, ymm0, [rcx + 160]
M2s_b9af
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm7, ymm0, [rcx + 192]
M2s_b9b0
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm13
M2s_b9a5
    vaddps ymm0, ymm4, ymm5
%endmacro
%macro M2s_a873 0
M2s_b9b2
M2s_b9b4
    vpermps ymm1, ymm8, [r9 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r9 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm9
%endmacro
%macro M2s_a874 0
M2s_b9b3
    vpermps ymm1, ymm9, [r9 + 72]
M2s_b9b5
    vpermps ymm0, ymm8, [r9 + 12]
    vpermps ymm1, ymm8, [r9 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm8
%endmacro
%macro M2s_a875 0
M2s_b9b5
M2s_b9aa
%endmacro
%macro M2s_a876 0
M2s_b9b6
    vpermps ymm1, ymm8, [r9 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r9 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm9
%endmacro
%macro M2s_a877 0
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r9 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm6, ymm0, [rcx + 96]
%endmacro
%macro M2s_a878 0
    lea r13, [r9 + r14]
M2s_b9ad
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm13
%endmacro
%macro M2s_a879 0
M2s_b265
M2s_b1a7
M2s_b1de
M2s_b1b1
M2s_b1fb
M2s_b1fe
M2s_b1ba
M2s_b701
M2s_b200
    add r9, 576
    sub rcx, 2
M2s_b267
    jz .i2c1e
    vmovups ymm15, [c_xlo]
%endmacro
%macro M2s_a87a 0
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_a87b
    vpermps ymm1, ymm9, [r8 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm4, ymm0, [rcx + 128]
M2s_b99d
    vpermps ymm1, ymm11, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm11
    vmulps ymm5, ymm0, [rcx + 160]
M2s_b99e
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm5, ymm0, [rcx + 192]
M2s_b99f
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm5, ymm0, [rcx + 224]
M2s_b9a8
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2s_a87c
    vblendvps ymm0, ymm0, ymm1, ymm11
M2s_a87d
M2s_b9a0
M2s_b9a3
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_b9a9
    vpermps ymm1, ymm9, [r9 + 76]
%endmacro
%macro M2s_a87b 0
    vfmadd231ps ymm4, ymm0, [rcx + 96]
    vpermps ymm0, ymm8, [r8 + 16]
    vpermps ymm1, ymm8, [r8 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm8
%endmacro
%macro M2s_a87c 0
M2s_b9b9
%endmacro
%macro M2s_a87d 0
M2s_a87e
M2s_b9a2
%endmacro
%macro M2s_a87e 0
M2s_b9ba
%endmacro
%macro M2s_a87f 0
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_a880
    vpermps ymm1, ymm9, [r9 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm6, ymm0, [rcx + 128]
M2s_b9a4
    vpermps ymm1, ymm11, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm11
    vmulps ymm7, ymm0, [rcx + 160]
M2s_b99e
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm7, ymm0, [rcx + 192]
M2s_b99f
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm7, ymm0, [rcx + 224]
M2s_b9a8
    vblendvps ymm0, ymm0, ymm1, ymm11
%endmacro
%macro M2s_a880 0
    vfmadd231ps ymm6, ymm0, [rcx + 96]
    vpermps ymm0, ymm8, [r9 + 16]
    vpermps ymm1, ymm8, [r9 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm8
%endmacro
%macro M2s_a881 0
    vpermps ymm0, ymm8, [r9 + 16]
    vpermps ymm1, ymm8, [r9 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r9 + 80]
%endmacro
%macro M2s_a882 0
    vfmadd231ps ymm7, ymm0, [rcx + 256]
M2s_b9b9
    vblendvps ymm0, ymm0, ymm1, ymm11
    vfmadd231ps ymm7, ymm0, [rcx + 288]
    vshufps ymm2, ymm6, ymm7, 0x88
%endmacro
%macro M2s_a883 0
M2s_a885
M2s_b112
M2s_b6f8
%endmacro
%macro M2s_a884 0
M2s_a883
M2s_b11e
M2s_b121
M2s_b995
M2s_b99a
%endmacro
%macro M2s_a885 0
    vfmadd231ps ymm7, ymm0, [rcx + 288]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
    vmovaps ymm6, ymm2
%endmacro
%macro M2s_a886 0
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r8 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_b9ab
M2s_b9ac
M2s_b9bb
    vpermps ymm1, ymm8, [r8 + 48]
%endmacro
%macro M2s_a887 0
M2s_b9bb
    vpermps ymm1, ymm8, [r8 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm8
M2s_a888
    vfmadd231ps ymm4, ymm0, [rcx + 128]
    lea r13, [r8 + r14]
M2s_b9ad
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vmulps ymm5, ymm0, [rcx + 160]
M2s_b9ae
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 192]
M2s_b9af
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 224]
M2s_b9b0
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2s_a889
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm13
M2s_b9ba
M2s_b9a2
M2s_b9b1
    vpermps ymm0, ymm8, [r9 + 4]
%endmacro
%macro M2s_a888 0
M2s_b9bd
%endmacro
%macro M2s_a889 0
M2s_b9be
%endmacro
%macro M2s_a88a 0
M2s_a88b
M2s_b9b7
    vmulps ymm7, ymm0, [rcx + 160]
M2s_b9ae
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm7, ymm0, [rcx + 192]
M2s_b9af
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm7, ymm0, [rcx + 224]
    vpermps ymm0, ymm11, [r13 + 12]
    vpermps ymm1, ymm11, [r13 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm11
%endmacro
%macro M2s_a88b 0
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r9 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm6, ymm0, [rcx + 128]
%endmacro
%macro M2s_a88c 0
    vfmadd231ps ymm7, ymm0, [rcx + 256]
M2s_b9be
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm13
%endmacro
%macro M2s_a88d 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 128]
M2s_b119
M2s_b1a
M2s_b1c
M2s_a88f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm12
%endmacro
%macro M2s_a88e 0
M2s_a88f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm12
M2s_a890
M2s_a892
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, ymm13
M2s_a894
M2s_a895
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a88f 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 136]
M2s_b646
M2s_b2a
M2s_b2b
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 144]
%endmacro
%macro M2s_a890 0
M2s_b9bf
%endmacro
%macro M2s_a891 0
M2s_b9c0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a892 0
M2s_b9c1
%endmacro
%macro M2s_a893 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a894 0
M2s_b9c2
%endmacro
%macro M2s_a895 0
M2s_b9c3
%endmacro
%macro M2s_a896 0
    vfmadd231ps ymm5, ymm0, [rcx + 192]
M2s_a897
M2s_a898
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 224]
M2s_a899
M2s_a89a
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2s_a89b
M2s_a89d
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b9ba
M2s_ba5
M2s_ba8
    vpermps ymm1, ymm3, [r9 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm6, ymm0, ymm8
%endmacro
%macro M2s_a897 0
M2s_b9c4
%endmacro
%macro M2s_a898 0
M2s_b9c5
%endmacro
%macro M2s_a899 0
M2s_b9c6
%endmacro
%macro M2s_a89a 0
M2s_b9c7
%endmacro
%macro M2s_a89b 0
M2s_b9c8
%endmacro
%macro M2s_a89c 0
M2s_b9c9
    vpermps ymm1, ymm3, [r13 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 112]
%endmacro
%macro M2s_a89d 0
M2s_b9ca
%endmacro
%macro M2s_a89e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a89f 0
    vpermps ymm1, ymm3, [r9 + 128]
M2s_b5f4
M2s_bb9
M2s_bbb
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8a0 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 136]
M2s_b609
M2s_bb4
M2s_bc9
M2s_bcb
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 144]
%endmacro
%macro M2s_a8a1 0
    vfmadd231ps ymm6, ymm0, ymm12
M2s_a8a2
M2s_b9c1
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, ymm13
M2s_b9c2
M2s_b9c3
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 192]
M2s_b9c4
M2s_b9c5
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 224]
M2s_b9c6
M2s_b9c7
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 256]
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm0, ymm3, [r13 + 16]
%endmacro
%macro M2s_a8a2 0
    lea r13, [r9 + r14]
M2s_b9c0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 64]
%endmacro
%macro M2s_a8a3 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 140]
M2s_bb3
M2s_b613
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_a8a4 0
M2s_b9cd
M2s_b6cc
%endmacro
%macro M2s_a8a5 0
    vblendvps ymm0, ymm0, ymm1, ymm8
M2s_b9bd
    vfmadd231ps ymm4, ymm0, [rcx + 128]
    vpermps ymm0, ymm8, [r8 + 20]
    vpermps ymm1, ymm8, [r8 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r8 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r8 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 160]
M2s_b9bc
    vmulps ymm5, ymm0, [rcx + 192]
M2s_b9ae
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 224]
M2s_b9af
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2s_b9b0
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2s_b9be
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_a8a6
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm5, ymm0, [rcx + 352]
    vshufps ymm2, ymm4, ymm5, 0x88
%endmacro
%macro M2s_a8a6 0
M2s_b9ce
%endmacro
%macro M2s_a8a7 0
M2s_b9cf
%endmacro
%macro M2s_a8a8 0
    vpermps ymm0, ymm8, [r9 + 20]
    vpermps ymm1, ymm8, [r9 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r9 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r9 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm6, ymm0, [rcx + 160]
M2s_b9b7
    vmulps ymm7, ymm0, [rcx + 192]
M2s_b9ae
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm7, ymm0, [rcx + 224]
M2s_b9af
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm13
%endmacro
%macro M2s_a8a9 0
    vfmadd231ps ymm7, ymm0, [rcx + 256]
M2s_b9b0
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm13
    vfmadd231ps ymm7, ymm0, [rcx + 288]
M2s_b9be
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm13
%endmacro
%macro M2s_a8aa 0
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_b9ce
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm13
%endmacro
%macro M2s_a8ab 0
M2s_b9d0
%endmacro
%macro M2s_a8ac 0
M2s_a8ab
M2s_b112
M2s_b6f8
%endmacro
%macro M2s_a8ad 0
    vfmadd231ps ymm4, ymm0, ymm13
M2s_b9bf
M2s_b9c1
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 192]
M2s_b9c2
M2s_b9c3
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 224]
M2s_b9c4
M2s_b9c5
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2s_b9c6
M2s_b9c7
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 288]
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm0, ymm3, [r13 + 16]
%endmacro
%macro M2s_a8ae 0
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_a8af
M2s_a8b0
    vpermps ymm1, ymm3, [r13 + 148]
M2s_a8b1
    vmovdqu ymm3, [rdx + 96]
M2s_b9cb
    vfmadd231ps ymm6, ymm0, ymm10
%endmacro
%macro M2s_a8af 0
M2s_b9d1
%endmacro
%macro M2s_a8b0 0
M2s_b9d2
%endmacro
%macro M2s_a8b1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b9cf
M2s_ba5
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8b2 0
    vfmadd231ps ymm6, ymm0, ymm13
M2s_b9cc
M2s_b9c1
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 192]
M2s_b9c2
M2s_b9c3
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 224]
M2s_b9c4
M2s_b9c5
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 256]
M2s_b9c6
M2s_b9c7
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 288]
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm0, ymm3, [r13 + 16]
%endmacro
%macro M2s_a8b3 0
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_b9d1
M2s_b9d2
    vpermps ymm1, ymm3, [r13 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 352]
%endmacro
%macro M2s_a8b4 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b9d0
M2s_b112
M2s_b6f9
M2s_b11f
    vpermps ymm0, ymm3, [r8 + 0]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 32]
%endmacro
%macro M2s_a8b5 0
    vpermps ymm1, ymm3, [r8 + 160]
M2s_b119
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 164]
M2s_b644
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 168]
M2s_b646
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 172]
M2s_b5a5
    vpermps ymm1, ymm3, [r8 + 80]
%endmacro
%macro M2s_a8b6 0
M2s_b9d4
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b647
M2s_b9d5
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 80]
M2s_b2b
M2s_b59f
    vpermps ymm1, ymm3, [r8 + 176]
M2s_b64c
%endmacro
%macro M2s_a8b7 0
M2s_b9d7
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 84]
M2s_b32
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 148]
%endmacro
%macro M2s_a8b8 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm13
%endmacro
%macro M2s_a8b9 0
M2s_a8b8
M2s_a8ba
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 192]
M2s_a8be
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 224]
M2s_a8bf
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2s_b9d8
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8ba 0
M2s_b9d9
    vpermps ymm1, ymm3, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a8bc
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a8bb 0
M2s_b9db
    vpermps ymm1, ymm3, [r13 + 160]
%endmacro
%macro M2s_a8bc 0
M2s_b9dc
%endmacro
%macro M2s_a8bd 0
M2s_b9dd
%endmacro
%macro M2s_a8be 0
M2s_b9de
%endmacro
%macro M2s_a8bf 0
M2s_b9df
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
M2s_a8c0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 168]
%endmacro
%macro M2s_a8c0 0
M2s_b9e0
%endmacro
%macro M2s_a8c1 0
M2s_b9d8
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a8c3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 172]
%endmacro
%macro M2s_a8c2 0
M2s_a8c3
M2s_a8c6
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2s_a8c7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_a8c8
M2s_b9d3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_a8c3 0
M2s_b9e1
%endmacro
%macro M2s_a8c4 0
M2s_b9e2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8c5 0
M2s_b9e3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a8c6 0
M2s_b9e4
%endmacro
%macro M2s_a8c7 0
M2s_b9e5
%endmacro
%macro M2s_a8c8 0
M2s_b9e6
M2s_b9e7
M2s_a8c9
%endmacro
%macro M2s_a8c9 0
M2s_b9e8
%endmacro
%macro M2s_a8ca 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8cb 0
    vpermps ymm1, ymm3, [r9 + 160]
M2s_b5f4
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 164]
M2s_b6bc
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 168]
M2s_b609
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 172]
M2s_bb3
M2s_b612
    vpermps ymm1, ymm3, [r9 + 80]
%endmacro
%macro M2s_a8cc 0
M2s_b9ea
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b603
M2s_b9ec
M2s_b6cc
M2s_b60e
M2s_bcf
    vpermps ymm1, ymm3, [r9 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_a8cd 0
M2s_b9eb
M2s_b603
M2s_b9ec
M2s_b6cc
M2s_b60e
M2s_bcf
M2s_b614
%endmacro
%macro M2s_a8ce 0
M2s_b9ec
M2s_b6cc
M2s_b60e
M2s_bcf
M2s_b616
%endmacro
%macro M2s_a8cf 0
    vpermps ymm1, ymm3, [r9 + 176]
M2s_bce
M2s_bd4
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 148]
%endmacro
%macro M2s_a8d0 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, ymm13
M2s_a8d1
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 192]
M2s_b9de
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 224]
M2s_b9df
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
M2s_b9e0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 256]
M2s_b9d8
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8d1 0
    lea r13, [r9 + r14]
M2s_b9da
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b9dc
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_a8d2 0
    vfmadd231ps ymm7, ymm0, [rcx + 288]
M2s_b9e5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_b9e6
M2s_b9e7
    vpermps ymm1, ymm3, [r13 + 148]
%endmacro
%macro M2s_a8d3 0
    vpermps ymm1, ymm3, [r8 + 148]
M2s_b38
    vfmadd231ps ymm4, ymm0, [rcx + 192]
M2s_b9bf
M2s_b9c1
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 224]
M2s_b9c2
M2s_b9c3
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2s_b9c4
M2s_b9c5
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 288]
%endmacro
%macro M2s_a8d4 0
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_b9c8
M2s_b9ca
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2s_b9d1
M2s_b9d2
    vpermps ymm1, ymm3, [r13 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_a8d5
M2s_a8d7
    vpermps ymm1, ymm3, [r13 + 152]
M2s_a8d9
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 128]
%endmacro
%macro M2s_a8d5 0
    vmovdqu ymm3, [rdx + 128]
M2s_b9f0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8d6 0
M2s_b9f0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a8d7 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_a8d8 0
    vpermps ymm1, ymm3, [r13 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 152]
%endmacro
%macro M2s_a8d9 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_b6b5
M2s_b71c
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8da 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 192]
M2s_b9cc
M2s_b9c1
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 224]
M2s_b9c2
M2s_b9c3
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 256]
M2s_b9c4
M2s_b9c5
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 288]
M2s_b9c6
M2s_b9c7
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8db 0
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_b9c8
M2s_b9ca
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 352]
M2s_b9d1
M2s_b9d2
    vpermps ymm1, ymm3, [r13 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 384]
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_a8dc 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
%endmacro
%macro M2s_a8dd 0
M2s_a8dc
M2s_b11b
M2s_b6f7
M2s_b72a
%endmacro
%macro M2s_a8de 0
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_b118
M2s_b114
M2s_b6fb
M2s_b117
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8df 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 192]
M2s_b9d9
    vpermps ymm1, ymm3, [r13 + 32]
M2s_b9ef
    vpermps ymm1, ymm3, [r13 + 128]
M2s_b9dd
    vmulps ymm5, ymm0, [rcx + 224]
M2s_b9de
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2s_b9df
M2s_b9ed
M2s_b9f5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2s_b9d8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 76]
%endmacro
%macro M2s_a8e0 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_b9e5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2s_b9e6
M2s_b9e7
M2s_b9e8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_a8e1
M2s_b9f1
    vpermps ymm1, ymm3, [r9 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8e1 0
M2s_b9f6
M2s_a8e2
%endmacro
%macro M2s_a8e2 0
M2s_b9f8
%endmacro
%macro M2s_a8e3 0
    vpermps ymm1, ymm3, [r9 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 192]
M2s_b9ee
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 224]
M2s_b9de
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 256]
M2s_b9df
M2s_b9ed
M2s_b9f5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 288]
M2s_b9d8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a8e4 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_b9e5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 352]
M2s_b9e6
M2s_b9e7
%endmacro
%macro M2s_a8e5 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_b9f6
M2s_b9f7
    vpermps ymm1, ymm3, [r13 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8e6 0
    vpermps ymm1, ymm3, [r9 + 180]
M2s_b792
M2s_b61b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 152]
%endmacro
%macro M2s_a8e7 0
    vpermps ymm1, ymm3, [r8 + 196]
M2s_b644
M2s_b1d
    vpermps ymm1, ymm3, [r8 + 200]
M2s_b646
M2s_b27
    vpermps ymm1, ymm3, [r8 + 204]
M2s_b5a4
M2s_b2c
    vpermps ymm1, ymm3, [r8 + 208]
%endmacro
%macro M2s_a8e8 0
M2s_b9fa
M2s_b5a0
    vmovdqu ymm3, [rdx + 160]
M2s_a8e9
M2s_b3f
M2s_b42
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 216]
%endmacro
%macro M2s_a8e9 0
    vpermps ymm1, ymm3, [r8 + 208]
M2s_b64b
M2s_b34
    vpermps ymm1, ymm3, [r8 + 212]
M2s_b37
    vpermps ymm1, ymm3, [r8 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8ea 0
M2s_a8eb
M2s_b43
M2s_b9fc
M2s_a8ec
M2s_b9c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 224]
M2s_a8ee
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a8eb 0
M2s_b9fb
M2s_b3c
%endmacro
%macro M2s_a8ec 0
    lea r13, [r8 + r14]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [r13 + 0]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b98
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_a8ed 0
M2s_b9fe
M2s_b99
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 160]
%endmacro
%macro M2s_a8ee 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_ba0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 164]
%endmacro
%macro M2s_a8ef 0
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 256]
M2s_a8f0
M2s_a8f1
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2s_a8f2
M2s_a8f3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_a8f4
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 208]
%endmacro
%macro M2s_a8f0 0
M2s_ba00
%endmacro
%macro M2s_a8f1 0
M2s_ba01
%endmacro
%macro M2s_a8f2 0
M2s_ba02
%endmacro
%macro M2s_a8f3 0
M2s_ba03
%endmacro
%macro M2s_a8f4 0
M2s_ba04
%endmacro
%macro M2s_a8f5 0
M2s_ba05
%endmacro
%macro M2s_a8f6 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2s_a8f7
M2s_a8f8
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_a8f9
M2s_a8fb
M2s_b9f2
M2s_ba6
M2s_ba8
M2s_bad
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8f7 0
M2s_ba06
%endmacro
%macro M2s_a8f8 0
M2s_ba07
%endmacro
%macro M2s_a8f9 0
M2s_ba09
%endmacro
%macro M2s_a8fa 0
    vpermps ymm1, ymm3, [r13 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 216]
%endmacro
%macro M2s_a8fb 0
M2s_ba0b
%endmacro
%macro M2s_a8fc 0
    vpermps ymm1, ymm3, [r9 + 196]
M2s_b6bc
M2s_bbe
    vpermps ymm1, ymm3, [r9 + 200]
M2s_b609
M2s_bc6
    vpermps ymm1, ymm3, [r9 + 204]
M2s_bb3
M2s_b611
    vpermps ymm1, ymm3, [r9 + 208]
%endmacro
%macro M2s_a8fd 0
M2s_ba0d
M2s_b60e
    vmovdqu ymm3, [rdx + 160]
M2s_a8fe
M2s_bef
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 216]
%endmacro
%macro M2s_a8fe 0
    vpermps ymm1, ymm3, [r9 + 208]
M2s_bce
M2s_bd5
M2s_bd8
    vpermps ymm1, ymm3, [r9 + 212]
M2s_b792
    vpermps ymm1, ymm3, [r9 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a8ff 0
M2s_a900
M2s_bf3
M2s_ba0f
M2s_a901
M2s_b9c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 224]
M2s_b9ff
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a900 0
M2s_ba0e
M2s_b6d3
%endmacro
%macro M2s_a901 0
    lea r13, [r9 + r14]
M2s_b9fe
M2s_b99
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_a902 0
    vfmadd231ps ymm7, ymm0, [rcx + 256]
M2s_ba00
M2s_ba01
    vfmadd231ps ymm7, ymm0, [rcx + 288]
M2s_ba02
M2s_ba03
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_ba04
M2s_ba05
    vfmadd231ps ymm7, ymm0, [rcx + 352]
%endmacro
%macro M2s_a903 0
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_ba08
M2s_ba0a
    vpermps ymm1, ymm3, [r13 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_a904 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 192]
M2s_b119
M2s_b16
M2s_b9f9
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 108]
M2s_b9d6
M2s_b27
%endmacro
%macro M2s_a905 0
M2s_ba11
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b597
M2s_b646
M2s_b27
    vpermps ymm1, ymm3, [r8 + 204]
%endmacro
%macro M2s_a906 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 192]
M2s_b5f4
M2s_bb6
M2s_ba0c
M2s_bc4
M2s_b604
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_a907 0
M2s_ba12
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b5fc
M2s_b609
M2s_bc6
    vpermps ymm1, ymm3, [r9 + 204]
%endmacro
%macro M2s_a908 0
    vpermps ymm1, ymm3, [r8 + 184]
M2s_b47
M2s_b4a
M2s_b4d
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 224]
M2s_b9d9
M2s_b9f3
    vmovdqu ymm3, [rdx + 256]
M2s_b9f4
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 256]
M2s_b9de
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2s_b9df
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a909 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_b9d8
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b9e1
M2s_b9e4
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2s_b9e5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_b9e6
M2s_b9e7
M2s_b9e8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_b9f6
%endmacro
%macro M2s_a90a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_a90b
M2s_a90d
M2s_bac
M2s_b9e9
M2s_b5f9
M2s_bba
    vpermps ymm1, ymm3, [r9 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a90b 0
M2s_ba13
M2s_a90c
%endmacro
%macro M2s_a90c 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 188]
%endmacro
%macro M2s_a90d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_b6b5
M2s_b71c
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a90e 0
    vpermps ymm1, ymm3, [r9 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 224]
M2s_b9ee
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 256]
M2s_b9de
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 288]
M2s_b9df
M2s_b9ed
M2s_b9f5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_b9d8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_a90f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 352]
M2s_b9e5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_b9e6
M2s_b9e7
M2s_b9e8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_b9f6
M2s_b9f8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_ba13
%endmacro
%macro M2s_a910 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
%endmacro
%macro M2s_a911 0
M2s_a910
M2s_b11b
M2s_b6f7
M2s_b72a
%endmacro
%macro M2s_a912 0
    vfmadd231ps ymm7, ymm0, [rcx + 480]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
    vmovaps ymm6, ymm2
%endmacro
%macro M2s_a913 0
M2s_a912
M2s_b112
M2s_b6f9
M2s_b120
%endmacro
%macro M2s_a914 0
M2s_b9fc
M2s_b49
M2s_b4c
%endmacro
%macro M2s_a915 0
    vpermps ymm1, ymm3, [r8 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 224]
M2s_b9fd
M2s_b9c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 256]
M2s_b9ff
M2s_ba2
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2s_ba00
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a916 0
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_ba02
M2s_ba03
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2s_ba04
M2s_ba05
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_ba06
M2s_ba07
    vfmadd231ps ymm5, ymm0, [rcx + 416]
%endmacro
%macro M2s_a917 0
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_a918
M2s_a91a
M2s_ba15
M2s_ba6
M2s_ba8
M2s_bad
M2s_b5f0
M2s_b9d
M2s_b5f5
M2s_b843
    vpermps ymm1, ymm3, [r9 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_a918 0
M2s_ba17
%endmacro
%macro M2s_a919 0
M2s_ba18
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a91a 0
M2s_ba19
%endmacro
%macro M2s_a91b 0
M2s_ba0f
M2s_bfd
M2s_b102
    vfmadd231ps ymm6, ymm0, [rcx + 224]
M2s_ba10
M2s_b9c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 256]
M2s_b9ff
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a91c 0
    vfmadd231ps ymm7, ymm0, [rcx + 288]
M2s_ba00
M2s_ba01
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_ba02
M2s_ba03
    vfmadd231ps ymm7, ymm0, [rcx + 352]
M2s_ba04
M2s_ba05
    vfmadd231ps ymm7, ymm0, [rcx + 384]
%endmacro
%macro M2s_a91d 0
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_ba09
M2s_ba0b
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_ba16
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 124]
%endmacro
%macro M2s_a91e 0
    vmulps ymm5, ymm0, [rcx + 256]
M2s_b73
M2s_b77
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 288]
M2s_b79
M2s_b7e
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_b70
M2s_b80
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a91f 0
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2s_b88
M2s_b8a
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_b8b
M2s_b8c
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_b90
M2s_b92
    vpermps ymm1, ymm3, [r13 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a920 0
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_b94
M2s_b97
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 252]
M2s_ba14
M2s_bac
M2s_ba9
M2s_bae
M2s_b9d
M2s_b5f5
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_a921 0
    vmulps ymm7, ymm0, [rcx + 256]
M2s_b73
M2s_b77
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 288]
M2s_b79
M2s_b7e
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_b70
M2s_b80
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a922 0
    vfmadd231ps ymm7, ymm0, [rcx + 352]
M2s_b88
M2s_b8a
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_b8b
M2s_b8c
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_b90
M2s_b92
    vpermps ymm1, ymm3, [r13 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a923 0
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_b95
M2s_b96
    vpermps ymm1, ymm3, [r13 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a924 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 256]
M2s_b9fd
M2s_b9c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm5, ymm0, [rcx + 288]
M2s_b9ff
M2s_ba2
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_ba00
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 200]
%endmacro
%macro M2s_a925 0
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2s_ba02
M2s_ba03
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_ba04
M2s_ba05
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_ba06
M2s_ba07
    vfmadd231ps ymm5, ymm0, [rcx + 448]
%endmacro
%macro M2s_a926 0
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_ba17
M2s_ba19
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_a927
M2s_a929
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_b6b5
M2s_b71c
M2s_b7dc
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_a927 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_b9dc
M2s_b9dd
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_a928 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a929 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a92a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_ba1a
M2s_ba6
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_a92b 0
    vpermps ymm1, ymm3, [r9 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 256]
M2s_ba10
M2s_b9c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 288]
M2s_b9ff
M2s_ba2
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_ba00
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a92c 0
    vfmadd231ps ymm7, ymm0, [rcx + 352]
M2s_ba02
M2s_ba03
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_ba04
M2s_ba05
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_ba06
M2s_ba07
    vfmadd231ps ymm7, ymm0, [rcx + 448]
%endmacro
%macro M2s_a92d 0
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_ba17
M2s_ba19
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_ba1b
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 128]
%endmacro
%macro M2s_a92e 0
    vfmadd231ps ymm7, ymm0, [rcx + 544]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
    vmovaps ymm6, ymm2
%endmacro
%macro M2s_a92f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
%endmacro
%macro M2s_a930 0
    vmulps ymm5, ymm0, [rcx + 288]
M2s_b73
M2s_b77
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 320]
M2s_b79
M2s_b7e
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 352]
M2s_b70
M2s_b80
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a931 0
    vfmadd231ps ymm5, ymm0, [rcx + 384]
M2s_b88
M2s_b8a
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_b8b
M2s_b8c
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 448]
M2s_b90
M2s_b92
    vpermps ymm1, ymm3, [r13 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a932 0
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_b94
M2s_b97
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 512]
M2s_b110
M2s_b9f
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 256]
M2s_ba1c
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_a933 0
    vmulps ymm7, ymm0, [rcx + 288]
M2s_b73
M2s_b77
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 320]
M2s_b79
M2s_b7e
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 352]
M2s_b70
M2s_b80
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a934 0
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_b88
M2s_b8a
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_b8b
M2s_b8c
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_b90
M2s_b92
    vpermps ymm1, ymm3, [r13 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_a935 0
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_b94
M2s_b97
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_b111
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 96]
%endmacro
%macro M2s_a936 0
    vmovdqu ymm8, [rdx + 0]
    vmovups ymm2, [rcx + 0]
    vmovups ymm3, [rcx + 32]
    vmovups ymm9, [rcx + 64]
%endmacro
%macro M2s_a937 0
M2s_a936
    vmovups ymm10, [rcx + 96]
M2s_b8
M2s_b9
    mov rbx, [rdi + G_gp]
    shl rbx, 2
.hu:
%endmacro
%macro M2s_a938 0
    vmulps ymm4, ymm0, ymm2
    vmulps ymm5, ymm0, ymm3
    vpermps ymm0, ymm8, [r8 + 4]
    vfmadd231ps ymm4, ymm0, ymm9
    vfmadd231ps ymm5, ymm0, ymm10
    vpermps ymm0, ymm8, [r9 + 0]
    vmulps ymm6, ymm0, ymm2
    vmulps ymm7, ymm0, ymm3
%endmacro
%macro M2s_a939 0
    vpermps ymm0, ymm8, [r9 + 4]
    vfmadd231ps ymm6, ymm0, ymm9
    vfmadd231ps ymm7, ymm0, ymm10
    vaddps ymm0, ymm4, ymm5
%endmacro
%macro M2s_a93a 0
    vfmadd231ps ymm6, ymm0, ymm9
    vfmadd231ps ymm7, ymm0, ymm10
    vaddps ymm0, ymm4, ymm5
    vmovups [r10 + 0], ymm0
    vaddps ymm0, ymm6, ymm7
    vmovups [r11 + 0], ymm0
    vaddps ymm4, ymm4, ymm6
    vaddps ymm5, ymm5, ymm7
M2s_b11d
%endmacro
%macro M2s_a93b 0
M2s_ba1d
M2s_b11e
M2s_b121
%endmacro
%macro M2s_a93c 0
    vmovups [r10 + 128], ymm0
    vaddps ymm0, ymm6, ymm7
    vmovups [r11 + 128], ymm0
    vaddps ymm4, ymm4, ymm6
    vaddps ymm5, ymm5, ymm7
M2s_b121
M2s_b126
M2s_b127
M2s_b6fe
M2s_b12a
M2s_b12b
.itl:
    vsubps ymm0, ymm15, [rax + 96]
    vrsqrtps ymm1, ymm0
%endmacro
%macro M2s_a93d 0
M2s_ba1f
%endmacro
%macro M2s_a93e 0
M2s_a93d
    dec rcx
    jnz .itl
M2s_b135
    cmp rcx, 2
    jb .i1l0r
M2s_b136
    vmovups ymm11, [rdi+(G_lom+0)]
    vmovups ymm10, [c_ieq]
.i1l0:
    vmovups ymm0, [rax]
M2s_a93f
M2s_b131
    test rcx, rcx
M2s_b145
    vmovups ymm12, [c_eq]
    vmovups ymm11, [rdi+(G_lom+0)]
    vmovups ymm10, [c_ieq]
%endmacro
%macro M2s_a93f 0
    vmovups ymm1, [rdx]
    vmovups ymm2, [rax+128]
M2s_a940
M2s_b13d
M2s_b229
    add rdx, 64
    add r9, 576
%endmacro
%macro M2s_a940 0
    vmovups ymm3, [rdx+32]
M2s_b138
    vsubps ymm6, ymm4, ymm1
    vsubps ymm7, ymm5, ymm3
    vcmpps ymm8, ymm6, ymm14, 30
%endmacro
%macro M2s_a941 0
    add rax, 256
    add rdx, 64
    add r9, 576
    sub rcx, 2
%endmacro
%macro M2s_a942 0
M2s_ba23
%endmacro
%macro M2s_a943 0
    vmovups ymm10, [c_ieq]
.i1l0s:
M2s_a945
    add rdx, 32
M2s_b157
    cmp rcx, 2
    jb .i1l1r
M2s_b158
    vmovups ymm11, [rdi+(G_lom+32)]
    vmovups ymm10, [c_ieq]
.i1l1:
    vmovups ymm0, [rax+32]
    vmovups ymm1, [rdx]
    vmovups ymm2, [rax+160]
M2s_ba22
M2s_b14c
M2s_b15b
    vfmadd213ps ymm4, ymm12, ymm11
%endmacro
%macro M2s_a944 0
M2s_ba24
M2s_b14d
M2s_b15c
M2s_b142
    vmovaps [r9+128], ymm5
%endmacro
%macro M2s_a945 0
    vmovups ymm0, [rax]
M2s_a946
M2s_b152
M2s_b230
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+32], ymm9
    add rax, 128
%endmacro
%macro M2s_a946 0
M2s_ba27
%endmacro
%macro M2s_a947 0
    add rax, 128
    add rdx, 32
    add r9, 288
    dec rcx
%endmacro
%macro M2s_a948 0
M2s_ba25
M2s_b150
M2s_b15c
M2s_b142
    vmovaps [r9+128], ymm5
    vmovaps [r9+416], ymm4
    add rax, 256
    add rdx, 64
%endmacro
%macro M2s_a949 0
M2s_ba26
M2s_b151
M2s_b15d
M2s_b15f
M2s_ba28
%endmacro
%macro M2s_a94a 0
M2s_a94b
M2s_b630
.i1l2:
    vmovups ymm0, [rax+64]
M2s_a94c
    sub rcx, 2
M2s_b186
    vmovups ymm12, [c_eq]
%endmacro
%macro M2s_a94b 0
M2s_ba2a
%endmacro
%macro M2s_a94c 0
    vmovups ymm1, [rdx]
    vmovups ymm2, [rax+192]
M2s_ba22
M2s_b173
    vfmadd213ps ymm4, ymm12, ymm11
    vmovaps [r9+224], ymm5
M2s_a94d
%endmacro
%macro M2s_a94d 0
    vmovaps [r9+512], ymm4
    add rax, 256
    add rdx, 64
    add r9, 576
%endmacro
%macro M2s_a94e 0
M2s_a94d
M2s_ba29
    vmovups ymm13, [rdi+(G_lrg+64)]
    vmovups ymm12, [c_eq]
M2s_b187
M2s_ba27
M2s_b189
M2s_a950
    add r9, 288
    dec rcx
    jnz .i1l2s
.i1l2e:
M2s_a951
    jb .i2l2r
M2s_b192
.i2l2:
M2s_b19b
M2s_b1a3
M2s_b249
%endmacro
%macro M2s_a94f 0
M2s_ba2c
M2s_b19f
M2s_b1a3
M2s_b249
M2s_b18d
M2s_b1a5
M2s_b1ae
M2s_b1b0
M2s_b1b2
    vmovups ymm7, [rax+192]
    vandps ymm9, ymm10, [r9+256]
%endmacro
%macro M2s_a950 0
M2s_ba2d
%endmacro
%macro M2s_a951 0
M2s_ba2e
%endmacro
%macro M2s_a952 0
    vandps ymm9, ymm10, [r9+256]
    vpsubd ymm6, ymm4, ymm0
    vmovaps [r9+192], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
    vfmadd213ps ymm5, ymm6, ymm14
    vmovaps [r9+224], ymm11
M2s_b1b7
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+512]
%endmacro
%macro M2s_a953 0
M2s_a954
M2s_a957
    sub rcx, 2
M2s_b1c3
M2s_b1a0
M2s_b635
M2s_b1c9
M2s_b1d1
M2s_b1d2
    vandps ymm7, ymm6, [r9+256]
    vmovaps [r9+192], ymm7
    vmovaps [r9+224], ymm4
%endmacro
%macro M2s_a954 0
M2s_ba30
M2s_b1ba
M2s_b1bd
%endmacro
%macro M2s_a955 0
    vmulps ymm8, ymm4, [r9+512]
M2s_a956
    add r9, 576
M2s_ba31
M2s_b1f0
    vmulps ymm4, ymm3, [r9+224]
M2s_a959
    add r9, 288
    dec rcx
    jnz .i2l2s
.i2l2e:
M2s_ba2e
M2s_b1ca
    vmovups ymm12, [c_q8o2]
%endmacro
%macro M2s_a956 0
M2s_ba33
%endmacro
%macro M2s_a957 0
    vmovaps [r9+480], ymm6
    vmovaps [r9+512], ymm8
    add rax, 256
    add r9, 576
%endmacro
%macro M2s_a958 0
    add rax, 256
    add r9, 576
    sub rcx, 2
    cmp rcx, 2
%endmacro
%macro M2s_a959 0
M2s_ba34
%endmacro
%macro M2s_a95a 0
    vmovaps [r9+192], ymm7
    vmovaps [r9+224], ymm4
    add rax, 128
    add r9, 288
%endmacro
%macro M2s_a95b 0
    add rax, 128
M2s_ba32
M2s_b1cb
M2s_b19d
M2s_b1a1
M2s_b256
M2s_b1a7
M2s_b1de
M2s_b1b1
M2s_b1e1
    vpsubd ymm6, ymm4, ymm0
    vmovaps [r9], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
%endmacro
%macro M2s_a95c 0
M2s_a95d
M2s_a960
    sub rcx, 2
    cmp rcx, 2
M2s_b1ed
M2s_b1d3
M2s_b262
    vmovaps [r9], ymm7
    vmovaps [r9+32], ymm4
%endmacro
%macro M2s_a95d 0
M2s_ba36
    vmovaps [r9+32], ymm11
M2s_b1b7
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+320]
    vandps ymm6, ymm3, [r9+352]
%endmacro
%macro M2s_a95e 0
M2s_ba37
    vfmadd213ps ymm0, ymm5, [c_q8o0]
    vfmadd231ps ymm4, ymm9, ymm0
M2s_a95f
M2s_ba35
M2s_b1d1
    vfmadd213ps ymm0, ymm1, [c_q8o0]
M2s_a961
    dec rcx
%endmacro
%macro M2s_a95f 0
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+320]
    vandps ymm6, ymm3, [r9+352]
M2s_a960
    sub rcx, 2
%endmacro
%macro M2s_a960 0
    vmovaps [r9+288], ymm6
    vmovaps [r9+320], ymm8
    add rax, 256
    add r9, 576
%endmacro
%macro M2s_a961 0
M2s_b262
M2s_ba38
%endmacro
%macro M2s_a962 0
    add rax, 128
M2s_b1f3
M2s_ba2e
M2s_b1ec
M2s_b6ff
M2s_b1de
M2s_b1b1
M2s_b1fb
    vpsubd ymm6, ymm4, ymm0
    vmovaps [r9+96], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
%endmacro
%macro M2s_a963 0
    jnz .i2l0s
.i2l0e:
M2s_ba2e
M2s_b1ec
M2s_b6ff
M2s_b1de
M2s_b1b1
M2s_b1fb
M2s_ba39
    vmovaps [r9+128], ymm11
    vmulps ymm4, ymm10, ymm2
%endmacro
%macro M2s_a964 0
M2s_ba39
    vmovaps [r9+128], ymm11
M2s_b1b7
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+416]
    vandps ymm6, ymm3, [r9+448]
%endmacro
%macro M2s_a965 0
    vfmadd213ps ymm5, ymm6, ymm14
M2s_ba3a
M2s_b701
M2s_a967
    sub rcx, 2
    cmp rcx, 2
M2s_b205
M2s_b1d3
M2s_a968
    dec rcx
%endmacro
%macro M2s_a966 0
    vmulps ymm8, ymm4, [r9+416]
    vandps ymm6, ymm3, [r9+448]
M2s_ba3b
M2s_b1cf
    vmulps ymm2, ymm1, ymm3
    vfmadd213ps ymm0, ymm1, ymm11
    vfmadd213ps ymm0, ymm1, [c_q8o0]
M2s_a968
    dec rcx
M2s_b20d
M2s_ba3c
    mov rax, [rbp + 16]
    add rax, rax
    add rax, [rbp + 248]
%endmacro
%macro M2s_a967 0
    vmovaps [r9+384], ymm6
    vmovaps [r9+416], ymm8
    add rax, 256
    add r9, 576
%endmacro
%macro M2s_a968 0
M2s_b26f
M2s_ba3d
%endmacro
%macro M2s_a969 0
M2s_ba3c
M2s_b20e
M2s_b216
    vmulps ymm0, ymm15, [r8 + 192]
    vfmadd231ps ymm0, ymm13, [r8]
    vfmadd231ps ymm0, ymm14, [r8 + 96]
    vmovaps ymm1, ymm12
    vfmadd231ps ymm1, ymm15, [r8 + 224]
    vfmadd231ps ymm1, ymm13, [r8 + 32]
    vfmadd231ps ymm1, ymm14, [r8 + 128]
M2s_b20c
    vmovdqu [rbp + 384], xmm3
M2s_b218
M2s_b219
.elq:
    vmovmskps eax, ymm2
M2s_b21b
    mov [r11], al
    add r8, 288
%endmacro
%macro M2s_a96a 0
M2s_ba3e
M2s_ba3f
M2s_b215
M2s_b21c
M2s_b220
%endmacro
%macro M2s_a96b 0
    dec rcx
M2s_b226
M2s_b22f
    vmovups ymm10, [c_ieq]
.i1c0:
    vmovups ymm0, [rax]
    vmovups ymm1, [rdx]
    vmovups ymm2, [rax+128]
M2s_ba22
M2s_b13d
M2s_b229
M2s_ba23
M2s_b234
M2s_b227
M2s_b22d
    vmovups ymm1, [rdx]
    vandps ymm2, ymm0, ymm15
%endmacro
%macro M2s_a96c 0
.i1c1s:
    vmovups ymm0, [rax+32]
M2s_ba27
M2s_b16b
M2s_ba2a
M2s_b243
    cmp rcx, 2
    jb .i1c2r
M2s_b244
    vmovups ymm11, [rdi+(G_com+64)]
    vmovups ymm10, [c_ieq]
.i1c2:
    vmovups ymm0, [rax+64]
M2s_ba2b
M2s_b179
M2s_b184
%endmacro
%macro M2s_a96d 0
.i1c2s:
    vmovups ymm0, [rax+64]
M2s_ba27
M2s_b189
M2s_ba2d
M2s_b24b
M2s_ba2e
M2s_b248
M2s_b24c
M2s_b1a7
    vpermps ymm10, ymm4, [c_to]
    vpermps ymm9, ymm4, [c_to+32]
%endmacro
%macro M2s_a96e 0
    vmulps ymm4, ymm3, [r9+224]
M2s_ba34
M2s_b250
M2s_ba2e
M2s_b253
M2s_b19d
M2s_b1a1
M2s_b256
M2s_b1a7
M2s_b1de
M2s_b1b1
    vmulps ymm11, ymm3, [r9+32]
    vblendvps ymm3, ymm7, ymm9, ymm6
    vmovups ymm7, [rax+128]
%endmacro
%macro M2s_a96f 0
M2s_b251
    mov r9, r10
    mov rcx, [rbp + 240]
M2s_b252
M2s_b19c
M2s_b1a0
M2s_b1a4
M2s_b1d8
M2s_b191
M2s_b1a6
M2s_b1dc
    vandps ymm9, ymm10, [r9+64]
M2s_ba36
    vmovaps [r9+32], ymm11
%endmacro
%macro M2s_a970 0
M2s_b703
M2s_b70b
    vmulps ymm4, ymm3, [r9+32]
    vandps ymm7, ymm6, [r9+64]
M2s_ba38
M2s_b70c
    mov r9, r10
    mov rcx, [rbp + 240]
M2s_b25f
M2s_b19c
%endmacro
%macro M2s_a971 0
    vfmadd213ps ymm0, ymm1, [c_q8o0]
M2s_b262
M2s_ba38
M2s_b70c
M2s_ba42
M2s_b261
M2s_b19e
M2s_b1a2
M2s_b266
M2s_b18f
M2s_b1aa
M2s_b1ad
    vpslld ymm0, ymm4, 23
    vpermps ymm4, ymm10, [c_rxo]
    vorps ymm10, ymm11, ymm3
%endmacro
%macro M2s_a972 0
M2s_b9b8
M2s_b26a
M2s_b1ce
M2s_b206
M2s_b1f0
    vmulps ymm4, ymm3, [r9+128]
    vandps ymm7, ymm6, [r9+160]
M2s_ba3d
M2s_b279
    mov r8, [rdi + G_sg]
M2s_b273
M2s_b275
    mov rbx, [rbp + 240]
%endmacro
%macro M2s_a973 0
    vmovaps ymm6, [rdi + G_cmx + 64]
    vfmadd231ps ymm0, ymm6, [r8 + 96]
    vmovaps ymm8, [rdi + G_cmx + 0]
    vmovaps ymm7, ymm8
    vfmsub132ps ymm7, ymm0, [r8 + 192]
    vmovaps ymm1, [rdi + G_csb]
    vfmadd231ps ymm1, ymm5, [r8 + 32]
    vfmadd231ps ymm1, ymm6, [r8 + 128]
    vfmadd231ps ymm1, ymm8, [r8 + 224]
M2s_b284
    vpmaxsd ymm9, ymm9, ymm15
    vmovaps ymm5, [rdi + G_cmx + 160]
    vmulps ymm0, ymm5, [r8 + 192]
    vmovaps ymm6, [rdi + G_cmx + 128]
    vfmadd231ps ymm0, ymm6, [r8 + 96]
M2s_b285
    vfmadd231ps ymm1, ymm5, [r8 + 224]
    vfmadd231ps ymm1, ymm6, [r8 + 128]
M2s_b27e
M2s_b27f
M2s_b286
M2s_b292
%endmacro
%macro M2s_a974 0
    cmovb rcx, r10
    bzhi eax, eax, ecx
    mov [r11], al
    add r8, 288
M2s_b289
M2s_b28c
M2s_b735
M2s_b29b
M2s_b29c
M2s_b2a4
%endmacro
%macro M2s_a975 0
    vpermps ymm1, ymm8, [r8 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm8
M2s_ba43
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm9
%endmacro
%macro M2s_a976 0
M2s_ba43
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm9
    vfmadd231ps ymm5, ymm0, ymm10
M2s_a977
    vfmadd231ps ymm6, ymm0, ymm9
%endmacro
%macro M2s_a977 0
M2s_ba44
%endmacro
%macro M2s_a978 0
    vaddps ymm0, ymm4, ymm5
M2s_ba1e
    imul rax, [rbp + 40]
M2s_b6fe
M2s_b12a
M2s_b12b
.itl:
    vsubps ymm0, ymm15, [rax + 96]
%endmacro
%macro M2s_a979 0
    vfmadd213ps ymm1, ymm14, ymm13
M2s_ba1f
M2s_ba20
M2s_ba40
M2s_b131
M2s_ba21
    vmovups ymm13, [rdi+(G_lrg+0)]
    vmovups ymm12, [c_eq]
    vmovups ymm11, [rdi+(G_lom+0)]
%endmacro
%macro M2s_a97a 0
M2s_ba28
    sub rcx, 2
M2s_b167
    vmovups ymm12, [c_eq]
M2s_b169
M2s_ba27
M2s_b16b
M2s_ba2a
M2s_b630
.i1l2:
M2s_ba41
M2s_b23f
    vcmpps ymm0, ymm7, ymm14, 30
%endmacro
%macro M2s_a97b 0
    vmovups ymm7, [rax+192]
M2s_ba2f
M2s_b1b9
    vfmadd213ps ymm0, ymm5, [c_q8o0]
    vfmadd231ps ymm4, ymm9, ymm0
    vorps ymm3, ymm1, ymm4
%endmacro
%macro M2s_a97c 0
M2s_a97b
    vmulps ymm8, ymm4, [r9+512]
M2s_ba33
M2s_b732
M2s_b1cf
M2s_b1d4
    vorps ymm6, ymm9, ymm3
    vmulps ymm4, ymm3, [r9+224]
    vandps ymm7, ymm6, [r9+256]
%endmacro
%macro M2s_a97d 0
    vfmadd231ps ymm5, ymm0, ymm10
M2s_b997
    vfmadd231ps ymm5, ymm0, ymm12
M2s_ba44
    vfmadd231ps ymm6, ymm0, ymm9
    vfmadd231ps ymm7, ymm0, ymm10
%endmacro
%macro M2s_b0 0
    vpmovzxwd ymm0, [rsi + rax*2]
    vpmovzxwd ymm1, [rdx + rax*2]
    vpaddd ymm0, ymm0, ymm7
    vpaddd ymm1, ymm1, ymm7
%endmacro
%macro M2s_b1 0
    vmulps ymm2, ymm2, ymm6
    vfmsub132ps ymm1, ymm2, ymm7
    vunpcklps ymm3, ymm0, ymm1
    vunpckhps ymm4, ymm0, ymm1
%endmacro
%macro M2s_b2 0
    mov rax, [rbp + 88]
    mov [rbp + 136], rax
    mov rax, [rbp + 120]
    mov [rbp + 144], rax
%endmacro
%macro M2s_b3 0
    mov rax, [rbp + 88]
    mov [rbp + 152], rax
    mov rax, [rbp + 120]
    mov [rbp + 160], rax
%endmacro
%macro M2s_b4 0
    mov rax, [rbp + 112]
    xor ecx, ecx
    cmp dword [r15 + Pc_ci], 0
    cmovne rax, [rbp + 104]
%endmacro
%macro M2s_b5 0
    mov rax, [rbp + 96]
    mov [rbp + 136], rax
    mov rax, [rbp + 120]
    mov [rbp + 144], rax
    mov rax, [rbp + 96]
    mov [rbp + 152], rax
    mov rax, [rbp + 120]
    mov [rbp + 160], rax
%endmacro
%macro M2s_b6 0
    mov [rbp + 184], rax
    mov rax, [rbp + 112]
    mov [rbp + 192], rax
    mov qword [rbp + 200], 0
%endmacro
%macro M2s_b7 0
    cmovne rax, [rbp + 96]
    cmovne rcx, [rbp + 120]
    mov [rbp + 152], rax
    mov [rbp + 160], rcx
%endmacro
%macro M2s_b8 0
    mov qword [rbp + 216], 0
.hc:
    mov rdi, [rbp + 8]
    mov rax, [rbp + 216]
    mov r8, [rdi + G_spp]
    imul r8, rax
    shl r8, 2
    add r8, [rdi + G_sb2]
    mov r9, [rdi + G_spp]
    shl r9, 4
    add r9, r8
    shl rax, 5
    mov r10, [rdi + G_cl]
    add r10, rax
    mov r11, [rdi + G_su]
    shl r11, 7
%endmacro
%macro M2s_b9 0
    add r11, r10
    mov r12, [rdi + G_cc]
M2s_ba
    shr rsi, 1
    mov [rbp + 224], rsi
%endmacro
%macro M2s_ba 0
    add r12, rax
    add rax, [rdi + G_oc]
    vmovups ymm14, [rax]
    mov rsi, [rdi + G_su]
%endmacro
%macro M2s_bb 0
M2s_a2c
M2s_a2d
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 132]
%endmacro
%macro M2s_bc 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 0]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 32]
%endmacro
%macro M2s_bd 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_be 0
M2s_a1d
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 224]
M2s_a2b
%endmacro
%macro M2s_bf 0
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 64]
M2s_a24
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b10 0
M2s_a24
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b11 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b12 0
    vpermps ymm1, ymm3, [r8 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 160]
%endmacro
%macro M2s_b13 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b14 0
M2s_c0
%endmacro
%macro M2s_b15 0
M2s_c1
%endmacro
%macro M2s_b16 0
M2s_c2
%endmacro
%macro M2s_b17 0
M2s_c3
%endmacro
%macro M2s_b18 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b19 0
M2s_a34
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b1a 0
M2s_c4
%endmacro
%macro M2s_b1b 0
M2s_c6
%endmacro
%macro M2s_b1c 0
M2s_c7
%endmacro
%macro M2s_b1d 0
M2s_c8
%endmacro
%macro M2s_b1e 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 232]
M2s_c6
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a51
%endmacro
%macro M2s_b1f 0
    vpermps ymm1, ymm3, [r8 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 232]
%endmacro
%macro M2s_b20 0
M2s_a40
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b21 0
M2s_c9
%endmacro
%macro M2s_b22 0
M2s_b21
M2s_b24
%endmacro
%macro M2s_b23 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 12]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 44]
%endmacro
%macro M2s_b24 0
M2s_ca
%endmacro
%macro M2s_b25 0
    vpermps ymm1, ymm3, [r8 + 76]
M2s_a40
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 140]
%endmacro
%macro M2s_b26 0
M2s_cb
%endmacro
%macro M2s_b27 0
M2s_cc
%endmacro
%macro M2s_b28 0
M2s_cd
%endmacro
%macro M2s_b29 0
M2s_a49
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b2a 0
M2s_ce
%endmacro
%macro M2s_b2b 0
M2s_c10
%endmacro
%macro M2s_b2c 0
M2s_c11
%endmacro
%macro M2s_b2d 0
M2s_c12
%endmacro
%macro M2s_b2e 0
M2s_a56
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b2f 0
    vfmadd231ps ymm4, ymm0, ymm12
M2s_b30
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 84]
%endmacro
%macro M2s_b30 0
M2s_c13
%endmacro
%macro M2s_b31 0
    vpermps ymm0, ymm3, [r8 + 20]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b32 0
M2s_c14
%endmacro
%macro M2s_b33 0
M2s_c15
%endmacro
%macro M2s_b34 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_b35 0
    vpermps ymm1, ymm3, [r8 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 244]
%endmacro
%macro M2s_b36 0
M2s_c16
%endmacro
%macro M2s_b37 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c17
%endmacro
%macro M2s_b38 0
M2s_b37
M2s_c18
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b39 0
M2s_c17
    vpermps ymm1, ymm3, [r8 + 88]
%endmacro
%macro M2s_b3a 0
M2s_c19
%endmacro
%macro M2s_b3b 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 24]
    vmovdqu ymm3, [rdx + 0]
M2s_c1a
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b3c 0
    vmovdqu ymm3, [rdx + 32]
M2s_c18
%endmacro
%macro M2s_b3d 0
M2s_c1b
%endmacro
%macro M2s_b3e 0
M2s_c1c
%endmacro
%macro M2s_b3f 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b40 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b41 0
    vpermps ymm1, ymm3, [r8 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a63
M2s_a68
%endmacro
%macro M2s_b42 0
    vpermps ymm1, ymm3, [r8 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 184]
%endmacro
%macro M2s_b43 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b44 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_b45 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b46 0
    vpermps ymm1, ymm3, [r8 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 248]
%endmacro
%macro M2s_b47 0
M2s_c1d
%endmacro
%macro M2s_b48 0
M2s_c1e
    vpermps ymm1, ymm3, [r8 + 60]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 92]
%endmacro
%macro M2s_b49 0
M2s_c1f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b4a 0
M2s_c20
%endmacro
%macro M2s_b4b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b4c 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b4d 0
M2s_c21
%endmacro
%macro M2s_b4e 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b4f 0
M2s_c22
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b50 0
M2s_c23
%endmacro
%macro M2s_b51 0
M2s_c24
%endmacro
%macro M2s_b52 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b53 0
    vpermps ymm1, ymm3, [r8 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 220]
%endmacro
%macro M2s_b54 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b55
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b56
    vpermps ymm1, ymm3, [r8 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b55 0
    vfmadd231ps ymm4, ymm0, [rcx + 224]
M2s_c22
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 96]
%endmacro
%macro M2s_b56 0
M2s_c26
%endmacro
%macro M2s_b57 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c26
    vpermps ymm1, ymm3, [r8 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b58 0
    vpermps ymm1, ymm3, [r8 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 192]
%endmacro
%macro M2s_b59 0
M2s_c28
%endmacro
%macro M2s_b5a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5b 0
    vpermps ymm1, ymm3, [r8 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 224]
%endmacro
%macro M2s_b5c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5d 0
    vpermps ymm1, ymm3, [r8 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 256]
%endmacro
%macro M2s_b5e 0
M2s_b5f
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 68]
M2s_b63
    vpermps ymm1, ymm3, [r8 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5f 0
M2s_c29
%endmacro
%macro M2s_b60 0
M2s_b61
M2s_c2a
%endmacro
%macro M2s_b61 0
    vfmadd231ps ymm4, ymm0, [rcx + 256]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 36]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_b62 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 36]
    vmovdqu ymm3, [rdx + 0]
M2s_c2a
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b63 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c2c
%endmacro
%macro M2s_b64 0
M2s_c2c
    vpermps ymm1, ymm3, [r8 + 164]
%endmacro
%macro M2s_b65 0
M2s_c2d
%endmacro
%macro M2s_b66 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b67 0
M2s_c2e
%endmacro
%macro M2s_b68 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 196]
M2s_a85
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_b69 0
M2s_c2f
%endmacro
%macro M2s_b6a 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm0, ymm3, [r13 + 0]
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6b 0
M2s_b6c
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 128]
%endmacro
%macro M2s_b6c 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b6d 0
M2s_c30
%endmacro
%macro M2s_b6e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6f 0
M2s_c31
%endmacro
%macro M2s_b70 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm0, ymm3, [r13 + 12]
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 44]
%endmacro
%macro M2s_b71 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b72 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b73 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b74
    vpermps ymm1, ymm3, [r13 + 100]
M2s_b76
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 164]
%endmacro
%macro M2s_b74 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b75 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 100]
M2s_b76
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_b76 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b77 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b78 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b79 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm0, ymm3, [r13 + 8]
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b7b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 168]
%endmacro
%macro M2s_b7a 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b7b 0
M2s_b7a
M2s_c32
%endmacro
%macro M2s_b7c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7d 0
M2s_c33
%endmacro
%macro M2s_b7e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b80 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b81
    vpermps ymm1, ymm3, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_b81 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b82 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 108]
M2s_b83
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_b83 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b84 0
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 172]
%endmacro
%macro M2s_b85 0
M2s_aa5
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b86 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b87 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm0, ymm3, [r13 + 16]
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b88 0
M2s_b87
M2s_b89
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 176]
%endmacro
%macro M2s_b89 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_b8a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8b 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm0, ymm3, [r13 + 20]
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 180]
%endmacro
%macro M2s_b8c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8d 0
M2s_aab
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8e 0
M2s_aae
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8f 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_ab0
M2s_ab2
%endmacro
%macro M2s_b90 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm0, ymm3, [r13 + 24]
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b91 0
M2s_b90
M2s_b92
    vpermps ymm1, ymm3, [r13 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 184]
%endmacro
%macro M2s_b92 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_b93 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b94 0
M2s_b95
M2s_b96
    vpermps ymm1, ymm3, [r13 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 188]
%endmacro
%macro M2s_b95 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm0, ymm3, [r13 + 28]
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 60]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b96 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_b97 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b98 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b99
    vpermps ymm1, ymm3, [r13 + 128]
%endmacro
%macro M2s_b99 0
M2s_c34
%endmacro
%macro M2s_b9a 0
    vpermps ymm1, ymm3, [r13 + 192]
M2s_ab6
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 256]
%endmacro
%macro M2s_b9b 0
M2s_c35
%endmacro
%macro M2s_b9c 0
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_b9d 0
M2s_c36
%endmacro
%macro M2s_b9e 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 4]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 36]
%endmacro
%macro M2s_b9f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba0 0
M2s_ba1
M2s_c37
%endmacro
%macro M2s_ba1 0
M2s_c38
%endmacro
%macro M2s_ba2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba3 0
    vfmadd231ps ymm5, ymm0, [rcx + 608]
    vshufps ymm2, ymm4, ymm5, 0x88
    vshufps ymm5, ymm4, ymm5, 0xdd
    vmovaps ymm4, ymm2
%endmacro
%macro M2s_ba4 0
    vshufps ymm2, ymm4, ymm5, 0x88
    vshufps ymm5, ymm4, ymm5, 0xdd
    vmovaps ymm4, ymm2
M2s_ac0
%endmacro
%macro M2s_ba5 0
M2s_c39
M2s_ba6
%endmacro
%macro M2s_ba6 0
M2s_c3a
%endmacro
%macro M2s_ba7 0
M2s_ac9
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba8 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_ba9 0
    vpermps ymm1, ymm3, [r9 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 192]
%endmacro
%macro M2s_baa 0
M2s_acc
M2s_ace
M2s_ad5
M2s_ada
M2s_ae0
    vfmadd231ps ymm6, ymm0, ymm10
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 12]
%endmacro
%macro M2s_bab 0
M2s_c3b
%endmacro
%macro M2s_bac 0
M2s_c3c
%endmacro
%macro M2s_bad 0
M2s_c3d
%endmacro
%macro M2s_bae 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_baf 0
    vmulps ymm6, ymm0, ymm8
M2s_acf
M2s_ad1
    vpermps ymm1, ymm3, [r9 + 132]
%endmacro
%macro M2s_bb0 0
M2s_c3e
%endmacro
%macro M2s_bb1 0
    vpermps ymm1, ymm3, [r9 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_ad3
M2s_ad8
%endmacro
%macro M2s_bb2 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_bb3 0
M2s_c3f
%endmacro
%macro M2s_bb4 0
M2s_c40
%endmacro
%macro M2s_bb5 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 16]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 48]
%endmacro
%macro M2s_bb6 0
M2s_c41
%endmacro
%macro M2s_bb7 0
M2s_c42
%endmacro
%macro M2s_bb8 0
M2s_ad9
M2s_adc
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 136]
%endmacro
%macro M2s_bb9 0
M2s_bba
M2s_c43
%endmacro
%macro M2s_bba 0
M2s_c44
%endmacro
%macro M2s_bbb 0
M2s_c45
%endmacro
%macro M2s_bbc 0
M2s_c46
%endmacro
%macro M2s_bbd 0
    vpermps ymm1, ymm3, [r9 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 232]
%endmacro
%macro M2s_bbe 0
M2s_c47
%endmacro
%macro M2s_bbf 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_bc0 0
M2s_ae4
M2s_ae9
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 140]
%endmacro
%macro M2s_bc1 0
M2s_c48
%endmacro
%macro M2s_bc2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
M2s_ae8
M2s_aef
M2s_af7
M2s_afc
M2s_a105
    vpermps ymm1, ymm3, [r9 + 212]
%endmacro
%macro M2s_bc3 0
M2s_c49
%endmacro
%macro M2s_bc4 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_bc5 0
M2s_c4a
%endmacro
%macro M2s_bc6 0
M2s_c4b
%endmacro
%macro M2s_bc7 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a10e
M2s_a112
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_bc8 0
M2s_af5
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_bc9 0
M2s_c4c
%endmacro
%macro M2s_bca 0
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 80]
M2s_af6
    vpermps ymm1, ymm3, [r9 + 176]
%endmacro
%macro M2s_bcb 0
M2s_c4d
%endmacro
%macro M2s_bcc 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_bcd 0
    vpermps ymm1, ymm3, [r9 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 240]
%endmacro
%macro M2s_bce 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c4e
%endmacro
%macro M2s_bcf 0
M2s_c4f
%endmacro
%macro M2s_bd0 0
M2s_c4e
M2s_a101
%endmacro
%macro M2s_bd1 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 20]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 52]
%endmacro
%macro M2s_bd2 0
    vpermps ymm0, ymm3, [r9 + 20]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_bd3 0
    vmovdqu ymm3, [rdx + 32]
M2s_a101
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 180]
%endmacro
%macro M2s_bd4 0
M2s_c50
%endmacro
%macro M2s_bd5 0
M2s_bd4
M2s_c51
%endmacro
%macro M2s_bd6 0
M2s_c52
%endmacro
%macro M2s_bd7 0
M2s_c53
%endmacro
%macro M2s_bd8 0
M2s_c54
%endmacro
%macro M2s_bd9 0
    vpermps ymm1, ymm3, [r9 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 244]
%endmacro
%macro M2s_bda 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_bdb 0
M2s_c55
%endmacro
%macro M2s_bdc 0
M2s_bdb
M2s_c56
%endmacro
%macro M2s_bdd 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 32]
    vmovdqu ymm3, [rdx + 0]
M2s_c56
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_bde 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_bdf
    vpermps ymm1, ymm3, [r9 + 128]
%endmacro
%macro M2s_bdf 0
M2s_c57
%endmacro
%macro M2s_be0 0
M2s_c58
%endmacro
%macro M2s_be1 0
M2s_c59
%endmacro
%macro M2s_be2 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 244]
M2s_a10d
M2s_a117
%endmacro
%macro M2s_be3 0
M2s_c5a
%endmacro
%macro M2s_be4 0
M2s_c5b
%endmacro
%macro M2s_be5 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c55
    vpermps ymm1, ymm3, [r9 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_be6 0
M2s_be7
M2s_c5d
%endmacro
%macro M2s_be7 0
M2s_c5e
%endmacro
%macro M2s_be8 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 24]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 56]
%endmacro
%macro M2s_be9 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_bea 0
M2s_a112
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_beb 0
M2s_c5f
%endmacro
%macro M2s_bec 0
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 88]
M2s_a112
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_bed 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_bee 0
M2s_c60
%endmacro
%macro M2s_bef 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c5f
    vpermps ymm1, ymm3, [r9 + 184]
%endmacro
%macro M2s_bf0 0
M2s_c63
%endmacro
%macro M2s_bf1 0
M2s_c64
%endmacro
%macro M2s_bf2 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 36]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 68]
%endmacro
%macro M2s_bf3 0
M2s_c65
%endmacro
%macro M2s_bf4 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_bf5 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_bf6 0
    vpermps ymm1, ymm3, [r9 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 248]
%endmacro
%macro M2s_bf7 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_bf8 0
    vmovdqu ymm3, [rdx + 0]
M2s_c66
%endmacro
%macro M2s_bf9 0
M2s_c66
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_bfa 0
M2s_c67
%endmacro
%macro M2s_bfb 0
M2s_c68
%endmacro
%macro M2s_bfc 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_bfd 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 28]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 60]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c67
    vpermps ymm1, ymm3, [r9 + 124]
M2s_c68
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 188]
%endmacro
%macro M2s_bfe 0
    vpermps ymm1, ymm3, [r9 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a123
    vpermps ymm1, ymm3, [r9 + 220]
%endmacro
%macro M2s_bff 0
M2s_c6b
%endmacro
%macro M2s_b100 0
M2s_c6c
%endmacro
%macro M2s_b101 0
    vpermps ymm1, ymm3, [r9 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 220]
%endmacro
%macro M2s_b102 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b103 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b104 0
M2s_c6d
%endmacro
%macro M2s_b105 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 128]
M2s_c6d
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 192]
%endmacro
%macro M2s_b106 0
    vpermps ymm1, ymm3, [r9 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a12d
    vpermps ymm1, ymm3, [r9 + 224]
%endmacro
%macro M2s_b107 0
M2s_c6f
%endmacro
%macro M2s_b108 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b109 0
    vpermps ymm1, ymm3, [r9 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 256]
%endmacro
%macro M2s_b10a 0
M2s_c70
%endmacro
%macro M2s_b10b 0
M2s_c71
M2s_c73
%endmacro
%macro M2s_b10c 0
M2s_c72
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b10d 0
M2s_c74
%endmacro
%macro M2s_b10e 0
M2s_c75
%endmacro
%macro M2s_b10f 0
M2s_c76
%endmacro
%macro M2s_b110 0
M2s_b111
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c34
    vpermps ymm1, ymm3, [r13 + 128]
M2s_c35
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_b111 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm0, ymm3, [r13 + 32]
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 64]
%endmacro
%macro M2s_b112 0
    vaddps ymm0, ymm4, ymm5
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r10 + 0], ymm0
    vaddps ymm0, ymm6, ymm7
%endmacro
%macro M2s_b113 0
M2s_b112
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r11 + 0], ymm0
M2s_a145
M2s_a146
%endmacro
%macro M2s_b114 0
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r10 + 0], ymm0
    vaddps ymm0, ymm6, ymm7
    vpermpd ymm0, ymm0, 0xd8
%endmacro
%macro M2s_b115 0
M2s_a14b
    vmovaps ymm15, ymm4
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 0]
%endmacro
%macro M2s_b116 0
    vmovaps ymm15, ymm4
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 0]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_b117 0
    add r9, rbx
    vmovaps ymm15, ymm4
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 0]
%endmacro
%macro M2s_b118 0
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
    vmovaps ymm6, ymm2
    vaddps ymm0, ymm4, ymm5
%endmacro
%macro M2s_b119 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c0
M2s_c1
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b11a 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b11b 0
    vmovaps ymm6, ymm2
    vaddps ymm0, ymm4, ymm5
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r10 + 0], ymm0
%endmacro
%macro M2s_b11c 0
M2s_c79
%endmacro
%macro M2s_b11d 0
    cmp qword [rbp + 40], 0
    jne .hf
M2s_b11e
    vperm2f128 ymm0, ymm14, ymm5, 0x21
    vpalignr ymm0, ymm5, ymm0, 12
%endmacro
%macro M2s_b11e 0
M2s_c7a
%endmacro
%macro M2s_b11f 0
M2s_c7b
%endmacro
%macro M2s_b120 0
M2s_b11f
    vpermps ymm0, ymm3, [r8 + 0]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b121 0
M2s_c7c
%endmacro
%macro M2s_b122 0
    vaddps ymm4, ymm4, ymm0
    vmovaps ymm14, ymm5
    add r8, rbx
    add r9, rbx
%endmacro
%macro M2s_b123 0
    vaddps ymm0, ymm4, ymm5
M2s_c7d
    vmovups [r11 + 128], ymm0
    vaddps ymm4, ymm4, ymm6
    vaddps ymm5, ymm5, ymm7
%endmacro
%macro M2s_b124 0
M2s_c7d
    vmovups [r11 + 128], ymm0
M2s_c79
M2s_c7c
M2s_a14f
M2s_a151
    vmovaps ymm15, [c_epsf]
%endmacro
%macro M2s_b125 0
M2s_c7e
M2s_c79
M2s_c7c
M2s_a14f
M2s_a151
    vmovaps ymm15, [c_epsf]
    vmovaps ymm14, [rdi + G_lsn]
%endmacro
%macro M2s_b126 0
M2s_c7f
%endmacro
%macro M2s_b127 0
M2s_c80
    mov rdi, [rbp + 8]
    mov rax, [rdi + G_su]
    shl rax, 3
    imul rax, [rbp + 40]
%endmacro
%macro M2s_b128 0
M2s_c81
%endmacro
%macro M2s_b129 0
M2s_c82
%endmacro
%macro M2s_b12a 0
M2s_c83
    mov r10, [rdi + G_sg]
    mov rcx, [rbp + 240]
    mov rdx, r8
    mov rax, rsi
%endmacro
%macro M2s_b12b 0
    vmovaps ymm15, [c_epsf]
    vmovaps ymm14, [rdi + G_lsn]
    vmovaps ymm13, [rdi + G_lan]
    vmovaps ymm12, [rdi + G_lta]
%endmacro
%macro M2s_b12c 0
    vmovaps ymm14, [rdi + G_lsn]
    vmovaps ymm13, [rdi + G_lan]
    vmovaps ymm12, [rdi + G_lta]
.itl:
%endmacro
%macro M2s_b12d 0
M2s_a158
M2s_b12e
M2s_a15e
M2s_b130
.i1l0r:
    test rcx, rcx
%endmacro
%macro M2s_b12e 0
M2s_c85
M2s_a15b
    vmovups ymm11, [rdi+(G_lom+0)]
    vmovups ymm10, [c_ieq]
.i1l0:
%endmacro
%macro M2s_b12f 0
    vmovups ymm11, [rdi+(G_lom+0)]
    vmovups ymm10, [c_ieq]
.i1l0:
M2s_a15e
%endmacro
%macro M2s_b130 0
    add r9, 576
    sub rcx, 2
    cmp rcx, 2
    jae .i1l0
%endmacro
%macro M2s_b131 0
    sub rcx, 2
    cmp rcx, 2
    jae .i1l0
.i1l0r:
%endmacro
%macro M2s_b132 0
    vmovaps ymm12, [rdi + G_lta]
.itl:
M2s_a158
M2s_c85
M2s_a15b
%endmacro
%macro M2s_b133 0
M2s_c87
M2s_c86
%endmacro
%macro M2s_b134 0
    vfmadd213ps ymm1, ymm0, ymm12
    vmovups [rdx + 192], ymm1
    add rax, 128
    add rdx, 224
%endmacro
%macro M2s_b135 0
M2s_c88
%endmacro
%macro M2s_b136 0
M2s_c89
%endmacro
%macro M2s_b137 0
    vmovups ymm3, [rdx+416]
M2s_b138
    vsubps ymm6, ymm4, ymm1
    vsubps ymm7, ymm5, ymm3
    vcmpps ymm8, ymm6, ymm14, 30
%endmacro
%macro M2s_b138 0
M2s_c8a
%endmacro
%macro M2s_b139 0
M2s_c8b
%endmacro
%macro M2s_b13a 0
    vandps ymm5, ymm2, ymm15
    vfmadd231ps ymm3, ymm5, ymm13
    vsubps ymm6, ymm4, ymm1
    vsubps ymm7, ymm5, ymm3
%endmacro
%macro M2s_b13b 0
    vmovaps [r9+64], ymm8
    vandnps ymm6, ymm8, ymm1
    vaddps ymm7, ymm4, ymm6
    vmovaps [r9+352], ymm0
%endmacro
%macro M2s_b13c 0
    vcmpps ymm8, ymm6, ymm14, 30
    vrcpps ymm9, ymm6
    vcmpps ymm0, ymm7, ymm14, 30
    vrcpps ymm2, ymm7
%endmacro
%macro M2s_b13d 0
    vrcpps ymm9, ymm6
M2s_b13e
M2s_b141
    vblendvps ymm5, ymm10, ymm6, ymm8
    vblendvps ymm4, ymm10, ymm9, ymm0
    vfmadd213ps ymm5, ymm12, ymm11
%endmacro
%macro M2s_b13e 0
    vcmpps ymm0, ymm7, ymm14, 30
M2s_b13f
    vmovaps [r9+352], ymm0
    vandnps ymm4, ymm0, ymm3
    vmulps ymm6, ymm1, ymm9
%endmacro
%macro M2s_b13f 0
M2s_c8c
%endmacro
%macro M2s_b140 0
    vandnps ymm4, ymm0, ymm3
    vmulps ymm6, ymm1, ymm9
M2s_b141
    vblendvps ymm5, ymm10, ymm6, ymm8
    vblendvps ymm4, ymm10, ymm9, ymm0
%endmacro
%macro M2s_b141 0
M2s_c8d
%endmacro
%macro M2s_b142 0
M2s_c8e
%endmacro
%macro M2s_b143 0
    vmovaps [r9+32], ymm5
    vmovaps [r9+320], ymm4
    add rax, 256
    add rdx, 448
%endmacro
%macro M2s_b144 0
    add rax, 256
    add rdx, 448
    add r9, 576
    sub rcx, 2
%endmacro
%macro M2s_b145 0
    jz .i1l0e
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xlo]
    vmovups ymm13, [rdi+(G_lrg+0)]
%endmacro
%macro M2s_b146 0
    vmovups ymm11, [rdi+(G_lom+0)]
M2s_c8f
%endmacro
%macro M2s_b147 0
M2s_c8f
    vsubps ymm7, ymm5, ymm3
%endmacro
%macro M2s_b148 0
M2s_c90
.i1l1:
M2s_c91
%endmacro
%macro M2s_b149 0
M2s_c91
M2s_b14b
    vandnps ymm6, ymm8, ymm1
%endmacro
%macro M2s_b14a 0
M2s_c92
M2s_c8a
%endmacro
%macro M2s_b14b 0
    vrcpps ymm9, ymm6
    vcmpps ymm0, ymm7, ymm14, 30
    vrcpps ymm2, ymm7
    vmovaps [r9+160], ymm8
%endmacro
%macro M2s_b14c 0
M2s_b14b
    vandnps ymm6, ymm8, ymm1
    vaddps ymm7, ymm4, ymm6
    vmovaps [r9+448], ymm0
    vandnps ymm4, ymm0, ymm3
%endmacro
%macro M2s_b14d 0
    vcmpps ymm0, ymm7, ymm14, 30
M2s_c94
%endmacro
%macro M2s_b14e 0
M2s_c94
    vaddps ymm1, ymm5, ymm4
%endmacro
%macro M2s_b14f 0
    vmovaps [r9+160], ymm8
    vandnps ymm6, ymm8, ymm1
    vaddps ymm7, ymm4, ymm6
    vmovaps [r9+448], ymm0
%endmacro
%macro M2s_b150 0
    vaddps ymm7, ymm4, ymm6
    vmovaps [r9+448], ymm0
    vandnps ymm4, ymm0, ymm3
    vmulps ymm6, ymm1, ymm9
%endmacro
%macro M2s_b151 0
    vmovaps [r9+448], ymm0
    vandnps ymm4, ymm0, ymm3
    vmulps ymm6, ymm1, ymm9
    vaddps ymm1, ymm5, ymm4
%endmacro
%macro M2s_b152 0
M2s_c95
%endmacro
%macro M2s_b153 0
M2s_c96
%endmacro
%macro M2s_b154 0
    vfmadd231ps ymm1, ymm2, ymm13
    vsubps ymm3, ymm2, ymm1
    vcmpps ymm4, ymm3, ymm14, 30
    vrcpps ymm5, ymm3
%endmacro
%macro M2s_b155 0
    vmulps ymm8, ymm1, ymm5
    vmovaps [r9], ymm7
    vblendvps ymm9, ymm10, ymm8, ymm4
    vfmadd213ps ymm9, ymm12, ymm11
%endmacro
%macro M2s_b156 0
M2s_c97
%endmacro
%macro M2s_b157 0
    add r9, 288
    dec rcx
    jnz .i1l0s
.i1l0e:
M2s_c88
%endmacro
%macro M2s_b158 0
M2s_c99
%endmacro
%macro M2s_b159 0
    vfmadd213ps ymm4, ymm12, ymm11
    vmovaps [r9+128], ymm5
    vmovaps [r9+416], ymm4
    add rax, 256
%endmacro
%macro M2s_b15a 0
    vmovaps [r9+128], ymm5
    vmovaps [r9+416], ymm4
    add rax, 256
    add rdx, 448
%endmacro
%macro M2s_b15b 0
    vmulps ymm6, ymm1, ymm9
M2s_b15c
    vblendvps ymm5, ymm10, ymm6, ymm8
    vblendvps ymm4, ymm10, ymm9, ymm0
    vfmadd213ps ymm5, ymm12, ymm11
%endmacro
%macro M2s_b15c 0
    vaddps ymm1, ymm5, ymm4
    vmovaps [r9+96], ymm7
    vmulps ymm9, ymm3, ymm2
    vmovaps [r9+384], ymm1
%endmacro
%macro M2s_b15d 0
    vmovaps [r9+96], ymm7
    vmulps ymm9, ymm3, ymm2
    vmovaps [r9+384], ymm1
    vblendvps ymm5, ymm10, ymm6, ymm8
%endmacro
%macro M2s_b15e 0
    vmulps ymm9, ymm3, ymm2
    vmovaps [r9+384], ymm1
    vblendvps ymm5, ymm10, ymm6, ymm8
    vblendvps ymm4, ymm10, ymm9, ymm0
%endmacro
%macro M2s_b15f 0
    vblendvps ymm4, ymm10, ymm9, ymm0
    vfmadd213ps ymm5, ymm12, ymm11
    vfmadd213ps ymm4, ymm12, ymm11
    vmovaps [r9+128], ymm5
%endmacro
%macro M2s_b160 0
    vfmadd213ps ymm5, ymm12, ymm11
    vfmadd213ps ymm4, ymm12, ymm11
    vmovaps [r9+128], ymm5
    vmovaps [r9+416], ymm4
%endmacro
%macro M2s_b161 0
    add rdx, 448
    add r9, 576
    sub rcx, 2
    cmp rcx, 2
%endmacro
%macro M2s_b162 0
M2s_a182
    vmovups ymm12, [c_eq]
M2s_a184
M2s_c96
M2s_b163
    add rdx, 224
    add r9, 288
    dec rcx
M2s_a187
    vmovups ymm1, [rdx+192]
%endmacro
%macro M2s_b163 0
M2s_a186
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+128], ymm9
    add rax, 128
%endmacro
%macro M2s_b164 0
M2s_c9a
%endmacro
%macro M2s_b165 0
M2s_c9b
%endmacro
%macro M2s_b166 0
    vmovups ymm2, [rax+192]
    vmovups ymm3, [rdx+416]
    vandps ymm4, ymm0, ymm15
    vfmadd231ps ymm1, ymm4, ymm13
%endmacro
%macro M2s_b167 0
    cmp rcx, 2
M2s_b168
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xlo]
    vmovups ymm13, [rdi+(G_lrg+32)]
%endmacro
%macro M2s_b168 0
    jae .i1l1
.i1l1r:
    test rcx, rcx
    jz .i1l1e
%endmacro
%macro M2s_b169 0
    vmovups ymm11, [rdi+(G_lom+32)]
    vmovups ymm10, [c_ieq]
.i1l1s:
    vmovups ymm0, [rax+32]
%endmacro
%macro M2s_b16a 0
M2s_c9c
%endmacro
%macro M2s_b16b 0
M2s_c9d
%endmacro
%macro M2s_b16c 0
    jnz .i1l1s
.i1l1e:
M2s_c88
    cmp rcx, 2
    jb .i1l2r
%endmacro
%macro M2s_b16d 0
    vmovups ymm11, [rdi+(G_lom+64)]
    vmovups ymm10, [c_ieq]
.i1l2:
    vmovups ymm0, [rax+64]
%endmacro
%macro M2s_b16e 0
M2s_c9f
%endmacro
%macro M2s_b16f 0
    vmovups ymm0, [rax+64]
M2s_c9b
    vfmadd231ps ymm1, ymm4, ymm13
    vandps ymm5, ymm2, ymm15
    vfmadd231ps ymm3, ymm5, ymm13
%endmacro
%macro M2s_b170 0
M2s_a18a
    vfmadd213ps ymm4, ymm12, ymm11
    vmovaps [r9+224], ymm5
    vmovaps [r9+512], ymm4
%endmacro
%macro M2s_b171 0
    vfmadd213ps ymm4, ymm12, ymm11
    vmovaps [r9+224], ymm5
    vmovaps [r9+512], ymm4
    add rax, 256
%endmacro
%macro M2s_b172 0
    vmovaps [r9+224], ymm5
    vmovaps [r9+512], ymm4
    add rax, 256
    add rdx, 448
%endmacro
%macro M2s_b173 0
    vrcpps ymm9, ymm6
M2s_b174
M2s_b178
    vblendvps ymm5, ymm10, ymm6, ymm8
    vblendvps ymm4, ymm10, ymm9, ymm0
    vfmadd213ps ymm5, ymm12, ymm11
%endmacro
%macro M2s_b174 0
M2s_ca1
%endmacro
%macro M2s_b175 0
    vrcpps ymm2, ymm7
M2s_ca2
%endmacro
%macro M2s_b176 0
    vmovaps [r9+256], ymm8
    vandnps ymm6, ymm8, ymm1
    vaddps ymm7, ymm4, ymm6
    vmovaps [r9+544], ymm0
%endmacro
%macro M2s_b177 0
M2s_ca2
    vmovaps [r9+192], ymm7
%endmacro
%macro M2s_b178 0
    vaddps ymm7, ymm4, ymm6
M2s_ca3
    vmovaps [r9+192], ymm7
    vmulps ymm9, ymm3, ymm2
    vmovaps [r9+480], ymm1
%endmacro
%macro M2s_b179 0
M2s_ca3
M2s_b17b
%endmacro
%macro M2s_b17a 0
    vmulps ymm6, ymm1, ymm9
    vaddps ymm1, ymm5, ymm4
M2s_b17b
    vblendvps ymm4, ymm10, ymm9, ymm0
    vfmadd213ps ymm5, ymm12, ymm11
%endmacro
%macro M2s_b17b 0
    vmovaps [r9+192], ymm7
    vmulps ymm9, ymm3, ymm2
    vmovaps [r9+480], ymm1
    vblendvps ymm5, ymm10, ymm6, ymm8
%endmacro
%macro M2s_b17c 0
    vmulps ymm9, ymm3, ymm2
    vmovaps [r9+480], ymm1
    vblendvps ymm5, ymm10, ymm6, ymm8
    vblendvps ymm4, ymm10, ymm9, ymm0
%endmacro
%macro M2s_b17d 0
M2s_a193
    vmovups ymm12, [c_eq]
M2s_a194
M2s_c96
M2s_b17e
    add rdx, 224
M2s_ca5
%endmacro
%macro M2s_b17e 0
M2s_a196
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+224], ymm9
    add rax, 128
%endmacro
%macro M2s_b17f 0
M2s_ca6
%endmacro
%macro M2s_b180 0
    jnz .i1l2s
.i1l2e:
M2s_c88
    cmp rcx, 2
    jb .i2l2r
%endmacro
%macro M2s_b181 0
    cmp rcx, 2
    jb .i2l2r
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_mone]
%endmacro
%macro M2s_b182 0
M2s_a18d
M2s_b183
    sub rcx, 2
M2s_ca4
    vandps ymm2, ymm0, ymm15
    vfmadd231ps ymm1, ymm2, ymm13
    vsubps ymm3, ymm2, ymm1
M2s_a196
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+224], ymm9
%endmacro
%macro M2s_b183 0
    vmovaps [r9+512], ymm4
    add rax, 256
    add rdx, 448
    add r9, 576
%endmacro
%macro M2s_b184 0
    vblendvps ymm4, ymm10, ymm9, ymm0
    vfmadd213ps ymm5, ymm12, ymm11
    vfmadd213ps ymm4, ymm12, ymm11
    vmovaps [r9+224], ymm5
%endmacro
%macro M2s_b185 0
    cmp rcx, 2
    jb .i2l2r
M2s_a198
.i2l2:
%endmacro
%macro M2s_b186 0
M2s_ca7
    jz .i1l2e
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xlo]
    vmovups ymm13, [rdi+(G_lrg+64)]
%endmacro
%macro M2s_b187 0
    vmovups ymm11, [rdi+(G_lom+64)]
    vmovups ymm10, [c_ieq]
.i1l2s:
    vmovups ymm0, [rax+64]
%endmacro
%macro M2s_b188 0
M2s_ca8
%endmacro
%macro M2s_b189 0
M2s_ca9
%endmacro
%macro M2s_b18a 0
M2s_caa
%endmacro
%macro M2s_b18b 0
    vmovups ymm9, [rax+64]
    vblendvps ymm2, ymm5, ymm6, ymm3
    vblendvps ymm5, ymm7, ymm8, ymm3
    vpsubd ymm6, ymm11, ymm0
%endmacro
%macro M2s_b18c 0
M2s_cab
%endmacro
%macro M2s_b18d 0
M2s_b18c
M2s_b190
%endmacro
%macro M2s_b18e 0
    vblendvps ymm8, ymm2, ymm5, ymm4
    vfmadd213ps ymm1, ymm6, ymm14
    vmulps ymm3, ymm8, ymm10
    vandps ymm11, ymm9, [c_sgn]
%endmacro
%macro M2s_b18f 0
M2s_cac
%endmacro
%macro M2s_b190 0
M2s_cad
%endmacro
%macro M2s_b191 0
    vandps ymm11, ymm9, [c_sgn]
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm1, ymm13
    vmulps ymm2, ymm1, ymm3
%endmacro
%macro M2s_b192 0
M2s_cae
%endmacro
%macro M2s_b193 0
    vmovups ymm12, [c_q8o2]
.i2l2:
M2s_caa
M2s_b195
    vmovaps [rdx+128], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
%endmacro
%macro M2s_b194 0
M2s_caf
    vfmadd213ps ymm5, ymm6, ymm14
%endmacro
%macro M2s_b195 0
    vblendvps ymm2, ymm5, ymm6, ymm3
    vblendvps ymm5, ymm7, ymm8, ymm3
M2s_a1a4
M2s_a1ac
M2s_a1ae
    vmovups ymm7, [rax+192]
    vandps ymm9, ymm10, [r9+256]
    vpsubd ymm6, ymm4, ymm0
%endmacro
%macro M2s_b196 0
M2s_cb0
%endmacro
%macro M2s_b197 0
    vpsubd ymm6, ymm4, ymm0
    vmovaps [rdx+128], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
    vfmadd213ps ymm5, ymm6, ymm14
%endmacro
%macro M2s_b198 0
    vblendvps ymm10, ymm1, ymm3, ymm8
    vfmadd213ps ymm5, ymm6, ymm14
    vmovaps [rdx+160], ymm11
M2s_a1b3
%endmacro
%macro M2s_b199 0
    vfmadd213ps ymm5, ymm6, ymm14
    vmovaps [rdx+160], ymm11
M2s_a1b3
    vorps ymm3, ymm1, ymm4
%endmacro
%macro M2s_b19a 0
    vmovaps [rdx+160], ymm11
M2s_a1b3
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+512]
%endmacro
%macro M2s_b19b 0
    vmovups ymm0, [r9+192]
M2s_b19c
    vpermps ymm5, ymm2, [c_to]
    vpermps ymm6, ymm2, [c_to+32]
    vpermps ymm7, ymm2, [c_to+64]
%endmacro
%macro M2s_b19c 0
M2s_cb1
%endmacro
%macro M2s_b19d 0
M2s_cb2
%endmacro
%macro M2s_b19e 0
M2s_cb3
%endmacro
%macro M2s_b19f 0
M2s_cb4
%endmacro
%macro M2s_b1a0 0
M2s_cb5
%endmacro
%macro M2s_b1a1 0
M2s_cb6
%endmacro
%macro M2s_b1a2 0
M2s_cb7
%endmacro
%macro M2s_b1a3 0
M2s_cb8
%endmacro
%macro M2s_b1a4 0
    vpsrld ymm9, ymm1, 20
    vpermps ymm10, ymm9, [c_w8o]
    vpermps ymm11, ymm9, [c_rxo]
    vpslld ymm0, ymm2, 23
%endmacro
%macro M2s_b1a5 0
    vmulps ymm2, ymm1, ymm3
M2s_b1a6
    vpslld ymm8, ymm5, 4
    vpermps ymm10, ymm4, [c_to]
    vpermps ymm9, ymm4, [c_to+32]
%endmacro
%macro M2s_b1a6 0
M2s_cb9
%endmacro
%macro M2s_b1a7 0
M2s_cba
%endmacro
%macro M2s_b1a8 0
M2s_b1a9
M2s_cba
%endmacro
%macro M2s_b1a9 0
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm1, ymm13
    vmulps ymm2, ymm1, ymm3
    vpmaxud ymm5, ymm7, ymm15
%endmacro
%macro M2s_b1aa 0
    vfmadd231ps ymm0, ymm1, ymm13
    vmulps ymm2, ymm1, ymm3
M2s_cb9
    vpslld ymm8, ymm5, 4
    vpermps ymm10, ymm4, [c_to]
%endmacro
%macro M2s_b1ab 0
M2s_a1a9
M2s_a1af
M2s_cb0
    vfmadd213ps ymm5, ymm6, ymm14
    vmovaps [rdx+160], ymm11
%endmacro
%macro M2s_b1ac 0
    vpermps ymm10, ymm4, [c_to]
M2s_a1ab
    vpslld ymm0, ymm4, 23
    vpermps ymm4, ymm10, [c_rxo]
%endmacro
%macro M2s_b1ad 0
    vpermps ymm9, ymm4, [c_to+32]
M2s_b1ae
    vfmadd231ps ymm3, ymm2, ymm0
    vpermps ymm9, ymm4, [c_to+96]
    vpermps ymm2, ymm10, [c_w8o]
%endmacro
%macro M2s_b1ae 0
M2s_cbd
%endmacro
%macro M2s_b1af 0
M2s_cbe
%endmacro
%macro M2s_b1b0 0
    vfmadd231ps ymm3, ymm2, ymm0
    vpermps ymm9, ymm4, [c_to+96]
    vpermps ymm2, ymm10, [c_w8o]
    vpslld ymm0, ymm4, 23
%endmacro
%macro M2s_b1b1 0
    vpermps ymm2, ymm10, [c_w8o]
    vpslld ymm0, ymm4, 23
    vpermps ymm4, ymm10, [c_rxo]
    vorps ymm10, ymm11, ymm3
%endmacro
%macro M2s_b1b2 0
    vpermps ymm4, ymm10, [c_rxo]
    vorps ymm10, ymm11, ymm3
    vmulps ymm11, ymm3, [r9+224]
    vblendvps ymm3, ymm7, ymm9, ymm6
%endmacro
%macro M2s_b1b3 0
    vmulps ymm11, ymm3, [r9+224]
    vblendvps ymm3, ymm7, ymm9, ymm6
    vmovups ymm7, [rax+192]
    vandps ymm9, ymm10, [r9+256]
%endmacro
%macro M2s_b1b4 0
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+512]
    vandps ymm6, ymm3, [r9+544]
    vmovaps [rdx+352], ymm6
%endmacro
%macro M2s_b1b5 0
    vandps ymm6, ymm3, [r9+544]
    vmovaps [rdx+352], ymm6
    vmovaps [rdx+384], ymm8
    add rax, 256
%endmacro
%macro M2s_b1b6 0
    vmovaps [rdx+352], ymm6
    vmovaps [rdx+384], ymm8
    add rax, 256
    add rdx, 448
%endmacro
%macro M2s_b1b7 0
    vmulps ymm4, ymm10, ymm2
M2s_b1b8
    vfmadd213ps ymm0, ymm5, [c_q8o1]
    vfmadd213ps ymm0, ymm5, [c_q8o0]
    vfmadd231ps ymm4, ymm9, ymm0
%endmacro
%macro M2s_b1b8 0
M2s_cbf
%endmacro
%macro M2s_b1b9 0
M2s_cc0
%endmacro
%macro M2s_b1ba 0
M2s_cc1
%endmacro
%macro M2s_b1bb 0
    vmovaps [rdx+384], ymm8
    add rax, 256
    add rdx, 448
    add r9, 576
%endmacro
%macro M2s_b1bc 0
M2s_cc2
%endmacro
%macro M2s_b1bd 0
    vfmadd231ps ymm4, ymm9, ymm0
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+512]
    vandps ymm6, ymm3, [r9+544]
%endmacro
%macro M2s_b1be 0
    add r9, 576
M2s_cc3
M2s_cc6
%endmacro
%macro M2s_b1bf 0
M2s_cc3
M2s_cc6
    mov rcx, [rbp + 240]
%endmacro
%macro M2s_b1c0 0
M2s_cc4
M2s_c88
    cmp rcx, 2
%endmacro
%macro M2s_b1c1 0
M2s_cc7
%endmacro
%macro M2s_b1c2 0
    cmp rcx, 2
    jb .i2l0r
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_mone]
%endmacro
%macro M2s_b1c3 0
    cmp rcx, 2
    jae .i2l2
.i2l2r:
    test rcx, rcx
    jz .i2l2e
M2s_cae
    vmovups ymm11, [c_q8o1]
.i2l2s:
    vmovups ymm0, [r9+192]
M2s_cb1
%endmacro
%macro M2s_b1c4 0
M2s_a1bd
    vpslld ymm9, ymm2, 23
    vblendvps ymm2, ymm5, ymm6, ymm3
    vmovups ymm5, [rax+64]
%endmacro
%macro M2s_b1c5 0
M2s_cca
%endmacro
%macro M2s_b1c6 0
M2s_b1c5
M2s_ccb
%endmacro
%macro M2s_b1c7 0
    vmovups ymm5, [rax+64]
    vblendvps ymm6, ymm7, ymm8, ymm3
    vpsubd ymm7, ymm0, ymm9
    vblendvps ymm8, ymm2, ymm6, ymm4
%endmacro
%macro M2s_b1c8 0
M2s_ccc
%endmacro
%macro M2s_b1c9 0
M2s_ccd
%endmacro
%macro M2s_b1ca 0
    jb .i2l0r
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_mone]
    vmovups ymm13, [c_q8o3]
%endmacro
%macro M2s_b1cb 0
M2s_b1ca
M2s_cce
%endmacro
%macro M2s_b1cc 0
.i2l0:
    vmovups ymm0, [r9]
    vpmaxud ymm1, ymm0, ymm15
    vpsrld ymm2, ymm1, 23
%endmacro
%macro M2s_b1cd 0
M2s_ccf
%endmacro
%macro M2s_b1ce 0
M2s_cd0
%endmacro
%macro M2s_b1cf 0
    vmulps ymm3, ymm8, ymm10
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm1, ymm13
    vandps ymm9, ymm5, [c_sgn]
%endmacro
%macro M2s_b1d0 0
    vmovaps ymm0, ymm12
M2s_a1c1
    vfmadd213ps ymm0, ymm1, [c_q8o0]
    vfmadd231ps ymm3, ymm2, ymm0
%endmacro
%macro M2s_b1d1 0
M2s_cd1
%endmacro
%macro M2s_b1d2 0
    vfmadd213ps ymm0, ymm1, [c_q8o0]
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
    vmulps ymm4, ymm3, [r9+224]
%endmacro
%macro M2s_b1d3 0
M2s_cd2
%endmacro
%macro M2s_b1d4 0
    vmulps ymm2, ymm1, ymm3
    vfmadd213ps ymm0, ymm1, ymm11
    vfmadd213ps ymm0, ymm1, [c_q8o0]
    vfmadd231ps ymm3, ymm2, ymm0
%endmacro
%macro M2s_b1d5 0
.i2l0:
M2s_b1d6
    vpermps ymm11, ymm9, [c_rxo]
M2s_b1d7
    vmulps ymm3, ymm8, ymm10
    vandps ymm11, ymm9, [c_sgn]
%endmacro
%macro M2s_b1d6 0
M2s_a1ca
    vpermps ymm8, ymm2, [c_to+96]
    vpsrld ymm9, ymm1, 20
    vpermps ymm10, ymm9, [c_w8o]
%endmacro
%macro M2s_b1d7 0
M2s_cd3
    vpsubd ymm6, ymm11, ymm0
    vmovups ymm7, [r9+288]
    vblendvps ymm8, ymm2, ymm5, ymm4
    vfmadd213ps ymm1, ymm6, ymm14
%endmacro
%macro M2s_b1d8 0
M2s_cd4
    vmovups ymm7, [r9+288]
    vblendvps ymm8, ymm2, ymm5, ymm4
    vfmadd213ps ymm1, ymm6, ymm14
    vmulps ymm3, ymm8, ymm10
%endmacro
%macro M2s_b1d9 0
M2s_b1da
M2s_cc1
    vfmadd231ps ymm4, ymm9, ymm0
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+320]
    vandps ymm6, ymm3, [r9+352]
%endmacro
%macro M2s_b1da 0
M2s_cd5
%endmacro
%macro M2s_b1db 0
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+320]
    vandps ymm6, ymm3, [r9+352]
    vmovaps [rdx+224], ymm6
%endmacro
%macro M2s_b1dc 0
M2s_b1dd
    vpermps ymm9, ymm4, [c_to+96]
    vpermps ymm2, ymm10, [c_w8o]
M2s_b1df
    vblendvps ymm3, ymm7, ymm9, ymm6
    vmovups ymm7, [rax+128]
%endmacro
%macro M2s_b1dd 0
    vpslld ymm8, ymm5, 4
    vpermps ymm10, ymm4, [c_to]
    vpermps ymm9, ymm4, [c_to+32]
M2s_cbd
    vfmadd231ps ymm3, ymm2, ymm0
%endmacro
%macro M2s_b1de 0
M2s_cd6
M2s_cbe
%endmacro
%macro M2s_b1df 0
    vpslld ymm0, ymm4, 23
    vpermps ymm4, ymm10, [c_rxo]
    vorps ymm10, ymm11, ymm3
    vmulps ymm11, ymm3, [r9+32]
%endmacro
%macro M2s_b1e0 0
    vpermps ymm4, ymm10, [c_rxo]
    vorps ymm10, ymm11, ymm3
    vmulps ymm11, ymm3, [r9+32]
    vblendvps ymm3, ymm7, ymm9, ymm6
%endmacro
%macro M2s_b1e1 0
    vmulps ymm11, ymm3, [r9+32]
    vblendvps ymm3, ymm7, ymm9, ymm6
    vmovups ymm7, [rax+128]
    vandps ymm9, ymm10, [r9+64]
%endmacro
%macro M2s_b1e2 0
M2s_a1cf
M2s_b1e3
    vfmadd213ps ymm0, ymm1, [c_q8o0]
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
%endmacro
%macro M2s_b1e3 0
M2s_cd7
%endmacro
%macro M2s_b1e4 0
    vandps ymm9, ymm10, [r9+64]
M2s_cd5
M2s_cc1
    vfmadd231ps ymm4, ymm9, ymm0
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+320]
%endmacro
%macro M2s_b1e5 0
    vandps ymm6, ymm3, [r9+352]
M2s_b1e6
    add r9, 576
    sub rcx, 2
    cmp rcx, 2
%endmacro
%macro M2s_b1e6 0
    vmovaps [rdx+224], ymm6
    vmovaps [rdx+256], ymm8
    add rax, 256
    add rdx, 448
%endmacro
%macro M2s_b1e7 0
    vmovaps [rdx+256], ymm8
    add rax, 256
    add rdx, 448
    add r9, 576
%endmacro
%macro M2s_b1e8 0
M2s_a1d5
M2s_b1e9
    mov r9, r10
    mov rcx, [rbp + 240]
    cmp rcx, 2
%endmacro
%macro M2s_b1e9 0
M2s_cd9
%endmacro
%macro M2s_b1ea 0
    cmp rcx, 2
    jb .i2l1r
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_mone]
%endmacro
%macro M2s_b1eb 0
    sub rcx, 2
    cmp rcx, 2
M2s_cd7
    vfmadd213ps ymm0, ymm1, [c_q8o0]
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
M2s_a1d5
M2s_cd9
    mov r9, r10
    mov rcx, [rbp + 240]
%endmacro
%macro M2s_b1ec 0
    jb .i2l1r
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_mone]
    vmovups ymm13, [c_q8o3]
%endmacro
%macro M2s_b1ed 0
    jae .i2l0
.i2l0r:
    test rcx, rcx
    jz .i2l0e
M2s_cae
    vmovups ymm11, [c_q8o1]
.i2l0s:
M2s_ccf
M2s_cb4
M2s_cd0
M2s_b1ee
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm1, ymm13
%endmacro
%macro M2s_b1ee 0
    vpslld ymm9, ymm2, 23
    vblendvps ymm2, ymm5, ymm6, ymm3
    vmovups ymm5, [rax]
M2s_ccc
    vmulps ymm3, ymm8, ymm10
%endmacro
%macro M2s_b1ef 0
M2s_cdc
M2s_cdd
%endmacro
%macro M2s_b1f0 0
    vmovaps ymm0, ymm12
M2s_cd1
    vfmadd213ps ymm0, ymm1, [c_q8o0]
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
%endmacro
%macro M2s_b1f1 0
    vmulps ymm4, ymm3, [r9+32]
M2s_b1f2
    add rdx, 224
    add r9, 288
    dec rcx
%endmacro
%macro M2s_b1f2 0
M2s_cde
%endmacro
%macro M2s_b1f3 0
    add r9, 288
    dec rcx
    jnz .i2l0s
.i2l0e:
%endmacro
%macro M2s_b1f4 0
.i2l1:
M2s_a1d9
    vpermps ymm8, ymm2, [c_to+96]
    vpsrld ymm9, ymm1, 20
%endmacro
%macro M2s_b1f5 0
M2s_a1d9
    vpermps ymm8, ymm2, [c_to+96]
    vpsrld ymm9, ymm1, 20
    vpermps ymm10, ymm9, [c_w8o]
%endmacro
%macro M2s_b1f6 0
M2s_ce0
%endmacro
%macro M2s_b1f7 0
M2s_ce1
    vmovups ymm7, [r9+384]
    vblendvps ymm8, ymm2, ymm5, ymm4
    vfmadd213ps ymm1, ymm6, ymm14
    vmulps ymm3, ymm8, ymm10
%endmacro
%macro M2s_b1f8 0
    vpermps ymm11, ymm9, [c_rxo]
    vpslld ymm0, ymm2, 23
M2s_a1db
M2s_a1de
%endmacro
%macro M2s_b1f9 0
M2s_b1fa
M2s_cb4
%endmacro
%macro M2s_b1fa 0
M2s_ce2
%endmacro
%macro M2s_b1fb 0
M2s_ce3
%endmacro
%macro M2s_b1fc 0
M2s_a1df
M2s_b1fd
    vfmadd213ps ymm0, ymm1, [c_q8o0]
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
%endmacro
%macro M2s_b1fd 0
M2s_ce4
%endmacro
%macro M2s_b1fe 0
M2s_ce5
%endmacro
%macro M2s_b1ff 0
    vandps ymm6, ymm3, [r9+448]
M2s_b200
    add r9, 576
    sub rcx, 2
    cmp rcx, 2
%endmacro
%macro M2s_b200 0
M2s_ce6
%endmacro
%macro M2s_b201 0
    vmovaps [rdx+320], ymm8
    add rax, 256
    add rdx, 448
    add r9, 576
%endmacro
%macro M2s_b202 0
M2s_a1e5
M2s_b203
    mov r8, [rdi + G_eb]
    mov rax, [rbp + 16]
    add rax, rax
%endmacro
%macro M2s_b203 0
M2s_ce7
%endmacro
%macro M2s_b204 0
    sub rcx, 2
    cmp rcx, 2
M2s_ce4
    vfmadd213ps ymm0, ymm1, [c_q8o0]
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
M2s_a1e5
M2s_ce7
    mov r8, [rdi + G_eb]
    mov rax, [rbp + 16]
%endmacro
%macro M2s_b205 0
    jae .i2l1
.i2l1r:
    test rcx, rcx
    jz .i2l1e
M2s_cae
    vmovups ymm11, [c_q8o1]
.i2l1s:
M2s_ce2
M2s_cb4
M2s_cd0
M2s_b206
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm1, ymm13
%endmacro
%macro M2s_b206 0
    vpslld ymm9, ymm2, 23
    vblendvps ymm2, ymm5, ymm6, ymm3
    vmovups ymm5, [rax+32]
M2s_ccc
    vmulps ymm3, ymm8, ymm10
%endmacro
%macro M2s_b207 0
M2s_ce9
M2s_cdd
%endmacro
%macro M2s_b208 0
    vmulps ymm4, ymm3, [r9+128]
M2s_b209
    add rdx, 224
    add r9, 288
    dec rcx
%endmacro
%macro M2s_b209 0
M2s_cea
%endmacro
%macro M2s_b20a 0
M2s_a1ed
M2s_b20b
    vfmadd231ps ymm1, ymm15, [r8 + 160]
    vfmadd231ps ymm1, ymm13, [r8 + 32]
    vfmadd231ps ymm1, ymm14, [r8 + 96]
%endmacro
%macro M2s_b20b 0
M2s_ceb
%endmacro
%macro M2s_b20c 0
M2s_cec
%endmacro
%macro M2s_b20d 0
    jnz .i2l1s
.i2l1e:
    mov rdi, [rbp + 8]
    vmovaps ymm13, [rdi + G_lmx]
%endmacro
%macro M2s_b20e 0
    mov rax, [rbp + 16]
    add rax, rax
    add rax, [rbp + 248]
M2s_b20f
M2s_b211
    vmovaps ymm6, [c_half]
%endmacro
%macro M2s_b20f 0
    imul rax, [rdi + G_wo]
M2s_ced
    mov r10, [rdi + G_wo]
    sub r10, [rbp + 232]
    mov rax, [rbp + 248]
%endmacro
%macro M2s_b210 0
M2s_ced
    mov r10, [rdi + G_wo]
    sub r10, [rbp + 232]
    mov rax, [rbp + 248]
    shl rax, 6
%endmacro
%macro M2s_b211 0
    shl rax, 6
    lea r11, [rdi + G_ms + rax]
    mov rbx, [rbp + 240]
    vmovdqu ymm5, [c_absm]
%endmacro
%macro M2s_b212 0
    lea r11, [rdi + G_ms + rax]
    mov rbx, [rbp + 240]
    vmovdqu ymm5, [c_absm]
    vmovaps ymm6, [c_half]
%endmacro
%macro M2s_b213 0
M2s_a1ea
.ed:
M2s_ceb
    vfmadd231ps ymm1, ymm15, [r8 + 160]
    vfmadd231ps ymm1, ymm13, [r8 + 32]
    vfmadd231ps ymm1, ymm14, [r8 + 96]
M2s_cee
%endmacro
%macro M2s_b214 0
M2s_cee
    inc qword [rbp + 248]
%endmacro
%macro M2s_b215 0
    add r9, 16
    sub r10, 8
    inc r11
    dec rbx
%endmacro
%macro M2s_b216 0
    vmovdqu ymm7, [c_i64]
    vmovdqu ymm8, [c_i1023]
    vpxor ymm9, ymm9, ymm9
.ed:
%endmacro
%macro M2s_b217 0
.elq:
    vmovmskps eax, ymm2
M2s_a1f2
    mov [r11], al
%endmacro
%macro M2s_b218 0
M2s_cef
%endmacro
%macro M2s_b219 0
M2s_cf0
%endmacro
%macro M2s_b21a 0
M2s_cf1
%endmacro
%macro M2s_b21b 0
M2s_cf2
%endmacro
%macro M2s_b21c 0
    jnz .ed
    inc qword [rbp + 248]
M2s_cf3
    shr rcx, 1
M2s_c81
    shr rdx, 1
%endmacro
%macro M2s_b21d 0
M2s_cf3
M2s_cf6
    mov rdx, [rdi + G_su]
    shr rdx, 1
    cmp rcx, rdx
    cmova rcx, rdx
%endmacro
%macro M2s_b21e 0
M2s_cf4
M2s_c81
    shr rdx, 1
    cmp rcx, rdx
    cmova rcx, rdx
    mov [rbp + 240], rcx
%endmacro
%macro M2s_b21f 0
M2s_cf5
    add rcx, 7
    shr rcx, 3
    mov rdx, [rdi + G_su]
    shr rdx, 1
M2s_b220
%endmacro
%macro M2s_b220 0
    cmp rcx, rdx
    cmova rcx, rdx
    mov [rbp + 240], rcx
    mov rax, [rdi + G_cc]
%endmacro
%macro M2s_b221 0
    mov [rbp + 240], rcx
    mov rax, [rdi + G_cc]
M2s_c83
    mov r10, [rdi + G_sg]
    mov rcx, [rbp + 240]
%endmacro
%macro M2s_b222 0
M2s_cf7
M2s_c84
%endmacro
%macro M2s_b223 0
    mov rax, rsi
M2s_cf1
M2s_cf8
%endmacro
%macro M2s_b224 0
M2s_cf8
M2s_c8b
    vsubps ymm7, ymm5, ymm3
%endmacro
%macro M2s_b225 0
M2s_a1fb
    vmovups ymm10, [c_ieq]
.i1c0:
    vmovups ymm0, [rax]
    vmovups ymm1, [rdx+192]
    vmovups ymm2, [rax+128]
    vmovups ymm3, [rdx+416]
    vandps ymm4, ymm0, ymm15
%endmacro
%macro M2s_b226 0
    jnz .itc
M2s_c88
    cmp rcx, 2
    jb .i1c0r
    vmovups ymm15, [c_absm]
%endmacro
%macro M2s_b227 0
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xlo]
    vmovups ymm13, [rdi+(G_crg+0)]
    vmovups ymm12, [c_eq]
%endmacro
%macro M2s_b228 0
M2s_cf9
%endmacro
%macro M2s_b229 0
    vfmadd213ps ymm4, ymm12, ymm11
    vmovaps [r9+32], ymm5
    vmovaps [r9+320], ymm4
    add rax, 256
%endmacro
%macro M2s_b22a 0
    add r9, 576
M2s_a1fe
M2s_b22c
.i1c0s:
    vmovups ymm0, [rax]
M2s_c96
M2s_c95
%endmacro
%macro M2s_b22b 0
M2s_cfa
M2s_c95
    vaddps ymm7, ymm2, ymm6
%endmacro
%macro M2s_b22c 0
    vmovups ymm13, [rdi+(G_crg+0)]
    vmovups ymm12, [c_eq]
    vmovups ymm11, [rdi+(G_com+0)]
    vmovups ymm10, [c_ieq]
%endmacro
%macro M2s_b22d 0
    vmovups ymm11, [rdi+(G_com+0)]
    vmovups ymm10, [c_ieq]
.i1c0s:
    vmovups ymm0, [rax]
%endmacro
%macro M2s_b22e 0
M2s_b22d
M2s_c96
%endmacro
%macro M2s_b22f 0
    vmovups ymm14, [c_xlo]
    vmovups ymm13, [rdi+(G_crg+0)]
    vmovups ymm12, [c_eq]
    vmovups ymm11, [rdi+(G_com+0)]
%endmacro
%macro M2s_b230 0
    vaddps ymm7, ymm2, ymm6
    vmulps ymm8, ymm1, ymm5
    vmovaps [r9], ymm7
    vblendvps ymm9, ymm10, ymm8, ymm4
%endmacro
%macro M2s_b231 0
M2s_b230
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+32], ymm9
    add rax, 128
    add rdx, 224
M2s_a202
.i1c1:
M2s_c92
    vandps ymm4, ymm0, ymm15
    vfmadd231ps ymm1, ymm4, ymm13
%endmacro
%macro M2s_b232 0
M2s_cfb
M2s_c93
    vfmadd231ps ymm3, ymm5, ymm13
    vsubps ymm6, ymm4, ymm1
    vsubps ymm7, ymm5, ymm3
    vcmpps ymm8, ymm6, ymm14, 30
%endmacro
%macro M2s_b233 0
M2s_cfc
M2s_c8b
M2s_cf9
%endmacro
%macro M2s_b234 0
    jae .i1c0
.i1c0r:
    test rcx, rcx
    jz .i1c0e
%endmacro
%macro M2s_b235 0
M2s_a207
    vmovups ymm14, [c_xlo]
    vmovups ymm13, [rdi+(G_crg+32)]
    vmovups ymm12, [c_eq]
%endmacro
%macro M2s_b236 0
    vmovups ymm14, [c_xlo]
    vmovups ymm13, [rdi+(G_crg+32)]
    vmovups ymm12, [c_eq]
    vmovups ymm11, [rdi+(G_com+32)]
%endmacro
%macro M2s_b237 0
    vmovups ymm13, [rdi+(G_crg+32)]
    vmovups ymm12, [c_eq]
    vmovups ymm11, [rdi+(G_com+32)]
    vmovups ymm10, [c_ieq]
%endmacro
%macro M2s_b238 0
    jnz .i1c0s
.i1c0e:
M2s_c88
    cmp rcx, 2
    jb .i1c1r
%endmacro
%macro M2s_b239 0
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xlo]
    vmovups ymm13, [rdi+(G_crg+32)]
    vmovups ymm12, [c_eq]
%endmacro
%macro M2s_b23a 0
    sub rcx, 2
    cmp rcx, 2
    jae .i1c1
.i1c1r:
%endmacro
%macro M2s_b23b 0
    jae .i1c1
.i1c1r:
    test rcx, rcx
    jz .i1c1e
%endmacro
%macro M2s_b23c 0
    vmovups ymm11, [rdi+(G_com+32)]
    vmovups ymm10, [c_ieq]
.i1c1s:
M2s_c9c
    vsubps ymm3, ymm2, ymm1
M2s_c9d
M2s_c9a
M2s_a20d
.i1c2:
M2s_ca0
    vsubps ymm6, ymm4, ymm1
    vsubps ymm7, ymm5, ymm3
%endmacro
%macro M2s_b23d 0
M2s_cfd
    add rax, 128
    add rdx, 224
M2s_cfe
    vandps ymm5, ymm2, ymm15
    vfmadd231ps ymm3, ymm5, ymm13
M2s_b23f
%endmacro
%macro M2s_b23e 0
M2s_cfe
    vandps ymm5, ymm2, ymm15
    vfmadd231ps ymm3, ymm5, ymm13
M2s_b23f
    vcmpps ymm0, ymm7, ymm14, 30
    vrcpps ymm2, ymm7
%endmacro
%macro M2s_b23f 0
M2s_cff
%endmacro
%macro M2s_b240 0
    add r9, 576
M2s_a211
    vmovups ymm13, [rdi+(G_crg+64)]
    vmovups ymm12, [c_eq]
%endmacro
%macro M2s_b241 0
M2s_a211
    vmovups ymm13, [rdi+(G_crg+64)]
    vmovups ymm12, [c_eq]
    vmovups ymm11, [rdi+(G_com+64)]
%endmacro
%macro M2s_b242 0
    vmovups ymm13, [rdi+(G_crg+64)]
    vmovups ymm12, [c_eq]
    vmovups ymm11, [rdi+(G_com+64)]
    vmovups ymm10, [c_ieq]
%endmacro
%macro M2s_b243 0
    add r9, 288
    dec rcx
    jnz .i1c1s
.i1c1e:
M2s_c88
%endmacro
%macro M2s_b244 0
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xlo]
    vmovups ymm13, [rdi+(G_crg+64)]
    vmovups ymm12, [c_eq]
%endmacro
%macro M2s_b245 0
    vmovups ymm11, [rdi+(G_com+64)]
    vmovups ymm10, [c_ieq]
.i1c2s:
M2s_ca8
    vsubps ymm3, ymm2, ymm1
M2s_ca9
M2s_ca6
M2s_b247
    mov rcx, [rbp + 240]
    cmp rcx, 2
    jb .i2c2r
M2s_cae
.i2c2:
%endmacro
%macro M2s_b246 0
M2s_c100
    vmovaps [r9+224], ymm9
    add rax, 128
    add rdx, 224
M2s_c101
.i2c2:
    vmovups ymm0, [r9+192]
%endmacro
%macro M2s_b247 0
M2s_a215
    mov rax, rsi
    mov rdx, r8
    mov r9, r10
%endmacro
%macro M2s_b248 0
M2s_c102
    vmovups ymm12, [c_q8o2]
.i2c2:
M2s_cc9
M2s_cb4
    vpermps ymm8, ymm2, [c_to+96]
    vpsrld ymm9, ymm1, 20
%endmacro
%macro M2s_b249 0
M2s_c103
%endmacro
%macro M2s_b24a 0
    jae .i1c2
.i1c2r:
    test rcx, rcx
    jz .i1c2e
%endmacro
%macro M2s_b24b 0
    add r9, 288
    dec rcx
    jnz .i1c2s
.i1c2e:
%endmacro
%macro M2s_b24c 0
    vpermps ymm10, ymm9, [c_w8o]
    vpermps ymm11, ymm9, [c_rxo]
M2s_c103
M2s_cab
M2s_cad
    vmulps ymm2, ymm1, ymm3
    vpmaxud ymm5, ymm7, ymm15
%endmacro
%macro M2s_b24d 0
    cmp rcx, 2
    jae .i2c2
.i2c2r:
    test rcx, rcx
    jz .i2c2e
M2s_cae
    vmovups ymm11, [c_q8o1]
.i2c2s:
M2s_cc9
    vpslld ymm4, ymm1, 4
%endmacro
%macro M2s_b24e 0
M2s_c105
M2s_c106
M2s_cb2
M2s_cb6
    vpermps ymm10, ymm9, [c_w8o]
    vpermps ymm0, ymm9, [c_rxo]
M2s_cca
M2s_ccb
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm1, ymm13
%endmacro
%macro M2s_b24f 0
    vmulps ymm4, ymm3, [r9+224]
M2s_cc7
    add rdx, 224
M2s_b250
M2s_c88
    cmp rcx, 2
    jb .i2c0r
%endmacro
%macro M2s_b250 0
    add r9, 288
    dec rcx
    jnz .i2c2s
.i2c2e:
%endmacro
%macro M2s_b251 0
    dec rcx
    jnz .i2c2s
.i2c2e:
    mov rax, rsi
%endmacro
%macro M2s_b252 0
    cmp rcx, 2
    jb .i2c0r
M2s_cae
.i2c0:
    vmovups ymm0, [r9]
%endmacro
%macro M2s_b253 0
M2s_c109
    vmovups ymm12, [c_q8o2]
.i2c0:
    vmovups ymm0, [r9]
    vpmaxud ymm1, ymm0, ymm15
%endmacro
%macro M2s_b254 0
.i2c0:
    vmovups ymm0, [r9]
    vpmaxud ymm1, ymm0, ymm15
    vpsrld ymm2, ymm1, 23
%endmacro
%macro M2s_b255 0
    vorps ymm6, ymm9, ymm3
M2s_c108
M2s_c97
    jnz .i2c2s
.i2c2e:
M2s_c88
    cmp rcx, 2
%endmacro
%macro M2s_b256 0
    vpermps ymm10, ymm9, [c_w8o]
M2s_b257
M2s_cac
    vfmadd231ps ymm0, ymm1, ymm13
    vmulps ymm2, ymm1, ymm3
    vpmaxud ymm5, ymm7, ymm15
%endmacro
%macro M2s_b257 0
    vpermps ymm11, ymm9, [c_rxo]
M2s_cd3
    vpsubd ymm6, ymm11, ymm0
    vmovups ymm7, [r9+288]
    vblendvps ymm8, ymm2, ymm5, ymm4
%endmacro
%macro M2s_b258 0
    cmp rcx, 2
    jae .i2c0
.i2c0r:
    test rcx, rcx
%endmacro
%macro M2s_b259 0
    jae .i2c0
.i2c0r:
    test rcx, rcx
    jz .i2c0e
%endmacro
%macro M2s_b25a 0
M2s_b259
M2s_cae
    vmovups ymm11, [c_q8o1]
.i2c0s:
M2s_ccf
    vpslld ymm4, ymm1, 4
    vpermps ymm5, ymm2, [c_to]
%endmacro
%macro M2s_b25b 0
M2s_c10b
M2s_cb6
M2s_c107
%endmacro
%macro M2s_b25c 0
M2s_c10c
M2s_cb3
M2s_cb7
    vpermps ymm0, ymm9, [c_rxo]
    vpslld ymm9, ymm2, 23
    vblendvps ymm2, ymm5, ymm6, ymm3
    vmovups ymm5, [rax]
%endmacro
%macro M2s_b25d 0
M2s_c107
%endmacro
%macro M2s_b25e 0
    jnz .i2c0s
.i2c0e:
M2s_c88
M2s_b25f
    vpmaxud ymm1, ymm0, ymm15
    vpsrld ymm2, ymm1, 23
%endmacro
%macro M2s_b25f 0
    cmp rcx, 2
    jb .i2c1r
M2s_cae
.i2c1:
    vmovups ymm0, [r9+96]
%endmacro
%macro M2s_b260 0
M2s_c10f
    vmovups ymm12, [c_q8o2]
.i2c1:
    vmovups ymm0, [r9+96]
    vpmaxud ymm1, ymm0, ymm15
%endmacro
%macro M2s_b261 0
.i2c1:
    vmovups ymm0, [r9+96]
    vpmaxud ymm1, ymm0, ymm15
    vpsrld ymm2, ymm1, 23
%endmacro
%macro M2s_b262 0
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
    vmulps ymm4, ymm3, [r9+32]
    vandps ymm7, ymm6, [r9+64]
%endmacro
%macro M2s_b263 0
M2s_b262
    vmovaps [rdx], ymm7
    vmovaps [rdx+32], ymm4
M2s_c97
M2s_c10d
    mov r9, r10
    mov rcx, [rbp + 240]
M2s_c10e
M2s_cb1
M2s_cb5
%endmacro
%macro M2s_b264 0
    vorps ymm6, ymm9, ymm3
    vmulps ymm4, ymm3, [r9+32]
M2s_cde
    add rdx, 224
    add r9, 288
    dec rcx
M2s_c10d
M2s_c111
    vpermps ymm7, ymm2, [c_to+64]
    vpermps ymm8, ymm2, [c_to+96]
    vpsrld ymm9, ymm1, 20
%endmacro
%macro M2s_b265 0
    vpermps ymm10, ymm9, [c_w8o]
M2s_b266
M2s_cac
    vfmadd231ps ymm0, ymm1, ymm13
    vmulps ymm2, ymm1, ymm3
    vpmaxud ymm5, ymm7, ymm15
%endmacro
%macro M2s_b266 0
    vpermps ymm11, ymm9, [c_rxo]
M2s_cdf
    vpsubd ymm6, ymm11, ymm0
    vmovups ymm7, [r9+384]
    vblendvps ymm8, ymm2, ymm5, ymm4
%endmacro
%macro M2s_b267 0
    cmp rcx, 2
    jae .i2c1
.i2c1r:
    test rcx, rcx
%endmacro
%macro M2s_b268 0
    jae .i2c1
.i2c1r:
    test rcx, rcx
    jz .i2c1e
%endmacro
%macro M2s_b269 0
M2s_b268
M2s_cae
    vmovups ymm11, [c_q8o1]
.i2c1s:
M2s_ce2
    vpslld ymm4, ymm1, 4
    vpermps ymm5, ymm2, [c_to]
%endmacro
%macro M2s_b26a 0
    test rcx, rcx
    jz .i2c1e
M2s_cae
M2s_c113
    vpermps ymm6, ymm2, [c_to+32]
    vpermps ymm7, ymm2, [c_to+64]
%endmacro
%macro M2s_b26b 0
M2s_c113
M2s_cb6
M2s_c107
%endmacro
%macro M2s_b26c 0
M2s_c114
M2s_cb3
M2s_cb7
    vpermps ymm0, ymm9, [c_rxo]
    vpslld ymm9, ymm2, 23
    vblendvps ymm2, ymm5, ymm6, ymm3
    vmovups ymm5, [rax+32]
%endmacro
%macro M2s_b26d 0
M2s_b26e
    add r9, 288
    dec rcx
M2s_b271
    mov rax, [rdi + G_wo]
    shr rax, 1
%endmacro
%macro M2s_b26e 0
M2s_b26f
    vmovaps [rdx+64], ymm7
    vmovaps [rdx+96], ymm4
    add rax, 128
    add rdx, 224
%endmacro
%macro M2s_b26f 0
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
    vmulps ymm4, ymm3, [r9+128]
    vandps ymm7, ymm6, [r9+160]
%endmacro
%macro M2s_b270 0
    vorps ymm6, ymm9, ymm3
    vmulps ymm4, ymm3, [r9+128]
M2s_cea
    add rdx, 224
    add r9, 288
%endmacro
%macro M2s_b271 0
    jnz .i2c1s
.i2c1e:
    mov rdi, [rbp + 8]
    mov r8, [rdi + G_eb]
%endmacro
%macro M2s_b272 0
    mov rdi, [rbp + 8]
    mov r8, [rdi + G_eb]
M2s_b273
M2s_b275
    mov rbx, [rbp + 240]
    vmovdqu ymm2, [c_absm]
%endmacro
%macro M2s_b273 0
    mov rax, [rdi + G_wo]
    shr rax, 1
M2s_c115
    mov r9, [rdi + G_db]
    add r9, rax
%endmacro
%macro M2s_b274 0
M2s_c115
    mov r9, [rdi + G_db]
    add r9, rax
    mov r12, [rdi + G_dr]
    add r12, rax
%endmacro
%macro M2s_b275 0
    mov r12, [rdi + G_dr]
    add r12, rax
    sub r10, [rbp + 232]
    lea r11, [rdi + G_ms + 128]
%endmacro
%macro M2s_b276 0
    sub r10, [rbp + 232]
    lea r11, [rdi + G_ms + 128]
    mov rbx, [rbp + 240]
    vmovdqu ymm2, [c_absm]
%endmacro
%macro M2s_b277 0
    add r9, 288
    dec rcx
    jnz .i2c1s
.i2c1e:
%endmacro
%macro M2s_b278 0
M2s_b279
    mov r8, [rdi + G_eb]
M2s_a222
M2s_a225
    vmulps ymm0, ymm5, [r8]
%endmacro
%macro M2s_b279 0
    dec rcx
    jnz .i2c1s
.i2c1e:
    mov rdi, [rbp + 8]
%endmacro
%macro M2s_b27a 0
    vmovaps ymm3, [c_half]
    vmovdqu ymm13, [c_i512]
M2s_a225
    vmulps ymm0, ymm5, [r8]
%endmacro
%macro M2s_b27b 0
    vmovaps ymm6, [rdi + G_cmx + 64]
M2s_c116
M2s_c118
    vmovaps ymm6, [rdi + G_cmx + 128]
    vfmadd231ps ymm0, ymm6, [r8 + 64]
M2s_a22b
%endmacro
%macro M2s_b27c 0
M2s_c116
M2s_c118
    vmovaps ymm6, [rdi + G_cmx + 128]
    vfmadd231ps ymm0, ymm6, [r8 + 64]
M2s_a22b
    vfmadd231ps ymm1, ymm5, [r8 + 160]
%endmacro
%macro M2s_b27d 0
M2s_c117
M2s_c119
    vfmadd231ps ymm0, ymm6, [r8 + 64]
M2s_a22b
    vfmadd231ps ymm1, ymm5, [r8 + 160]
    vfmadd231ps ymm1, ymm6, [r8 + 96]
%endmacro
%macro M2s_b27e 0
    vfmadd231ps ymm1, ymm8, [r8 + 32]
    vroundps ymm12, ymm7, 8
    vsubps ymm12, ymm7, ymm12
    vandps ymm12, ymm12, ymm2
    vaddps ymm12, ymm12, ymm1
    vcmpps ymm12, ymm12, ymm3, 0x05
    vcvtps2dq ymm11, ymm7
    vpaddd ymm11, ymm11, ymm13
    vpminsd ymm11, ymm11, ymm14
    vpmaxsd ymm11, ymm11, ymm15
    vpor ymm10, ymm10, ymm12
    vextracti128 xmm4, ymm9, 1
    vpackssdw xmm9, xmm9, xmm4
    vextracti128 xmm4, ymm11, 1
    vpackssdw xmm11, xmm11, xmm4
    cmp r10, 8
%endmacro
%macro M2s_b27f 0
    jb .cbp
    vmovdqu [r9], xmm9
    jmp .cbq
.cbp:
    vmovdqu [rbp + 384], xmm9
    push rsi
    push rdi
    mov rcx, r10
%endmacro
%macro M2s_b280 0
    vmovdqu ymm14, [c_i1023]
    vpxor ymm15, ymm15, ymm15
.cd:
    vmovaps ymm5, [rdi + G_cmx + 32]
%endmacro
%macro M2s_b281 0
    vfmadd231ps ymm1, ymm5, [r8 + 160]
    vfmadd231ps ymm1, ymm6, [r8 + 96]
M2s_a22c
    vmovdqu [r12], xmm11
%endmacro
%macro M2s_b282 0
    vfmadd231ps ymm1, ymm6, [r8 + 96]
M2s_a22c
    vmovdqu [r12], xmm11
    jmp .crq
%endmacro
%macro M2s_b283 0
M2s_a22c
    vmovdqu [r12], xmm11
    jmp .crq
.crp:
%endmacro
%macro M2s_b284 0
    vroundps ymm10, ymm7, 8
    vsubps ymm10, ymm7, ymm10
    vandps ymm10, ymm10, ymm2
    vaddps ymm10, ymm10, ymm1
    vcmpps ymm10, ymm10, ymm3, 0x05
    vcvtps2dq ymm9, ymm7
    vpaddd ymm9, ymm9, ymm13
    vpminsd ymm9, ymm9, ymm14
%endmacro
%macro M2s_b285 0
    vmovaps ymm8, [rdi + G_cmx + 96]
    vmovaps ymm7, ymm8
    vfmsub132ps ymm7, ymm0, [r8]
    vmovaps ymm1, [rdi + G_csr]
%endmacro
%macro M2s_b286 0
    lea rsi, [rbp + 384]
M2s_cf0
.cbq:
    cmp r10, 8
    jb .crp
%endmacro
%macro M2s_b287 0
M2s_c11a
%endmacro
%macro M2s_b288 0
M2s_b287
M2s_b28b
M2s_b28d
    vpcmpeqb ymm1, ymm7, [rdi + G_ms + 0]
    vpcmpeqb ymm2, ymm7, [rdi + G_ms + 32]
M2s_a233
    xor rax, -1
%endmacro
%macro M2s_b289 0
M2s_c11b
M2s_c11c
M2s_c11d
%endmacro
%macro M2s_b28a 0
M2s_b289
M2s_b28c
    vpcmpeqb ymm1, ymm7, [rdi + G_ms + 0]
    vpcmpeqb ymm2, ymm7, [rdi + G_ms + 32]
M2s_a233
M2s_b28e
    blsr rax, rax
%endmacro
%macro M2s_b28b 0
M2s_c11d
M2s_c11e
%endmacro
%macro M2s_b28c 0
M2s_c11e
M2s_b28d
%endmacro
%macro M2s_b28d 0
M2s_c11f
%endmacro
%macro M2s_b28e 0
M2s_c120
%endmacro
%macro M2s_b28f 0
M2s_b28e
M2s_c121
%endmacro
%macro M2s_b290 0
    jz .fbe0
.fs0:
    tzcnt rcx, rax
    blsr rax, rax
%endmacro
%macro M2s_b291 0
M2s_c122
%endmacro
%macro M2s_b292 0
    vmovdqu [r12], xmm11
    jmp .crq
.crp:
    vmovdqu [rbp + 384], xmm11
%endmacro
%macro M2s_b293 0
    vmovdqu [rbp + 384], xmm11
    push rsi
    push rdi
    mov rcx, r10
%endmacro
%macro M2s_b294 0
M2s_a230
M2s_c11a
M2s_c11d
M2s_c11e
M2s_c11f
    vpcmpeqb ymm1, ymm7, [rdi + G_ms + 0]
    vpcmpeqb ymm2, ymm7, [rdi + G_ms + 32]
M2s_a233
%endmacro
%macro M2s_b295 0
M2s_a235
    vpermps ymm1, ymm0, [rdx]
    vmovups [r8 + r9*4], ymm1
    vpermps ymm1, ymm0, [rdx + 32]
%endmacro
%macro M2s_b296 0
    mov rdi, r12
    rep movsw
    pop rdi
    pop rsi
.crq:
    vmovmskps eax, ymm10
    mov ecx, 8
    cmp r10, rcx
%endmacro
%macro M2s_b297 0
M2s_c123
%endmacro
%macro M2s_b298 0
    test rax, rax
    jnz .fs0
    mov [rbp + 272], r9
.fbe0:
%endmacro
%macro M2s_b299 0
M2s_c124
%endmacro
%macro M2s_b29a 0
    vmovups [r8 + r9*4 + 65536], ymm1
    vpermps ymm1, ymm0, [rdx + 64]
    vmovups [r8 + r9*4 + 131072], ymm1
    vpermps ymm1, ymm0, [rdx + 96]
%endmacro
%macro M2s_b29b 0
M2s_c125
%endmacro
%macro M2s_b29c 0
M2s_b29d
    vpermps ymm1, ymm0, [rdx + 64]
    vmovups [r8 + r9*4 + 131072], ymm1
    vpermps ymm1, ymm0, [rdx + 96]
    vmovups [r8 + r9*4 + 196608], ymm1
%endmacro
%macro M2s_b29d 0
    vpermps ymm1, ymm0, [rdx]
    vmovups [r8 + r9*4], ymm1
    vpermps ymm1, ymm0, [rdx + 32]
    vmovups [r8 + r9*4 + 65536], ymm1
%endmacro
%macro M2s_b29e 0
    vmovups [r8 + r9*4], ymm1
    vpermps ymm1, ymm0, [rdx + 32]
    vmovups [r8 + r9*4 + 65536], ymm1
    vpermps ymm1, ymm0, [rdx + 64]
%endmacro
%macro M2s_b29f 0
    vpermps ymm1, ymm0, [rdx + 32]
    vmovups [r8 + r9*4 + 65536], ymm1
    vpermps ymm1, ymm0, [rdx + 64]
    vmovups [r8 + r9*4 + 131072], ymm1
%endmacro
%macro M2s_b2a0 0
    vmovups [r8 + r9*4 + 196608], ymm1
M2s_c123
.fbe0:
    mov rsi, [rdi + G_cl]
    mov r10, [rdi + G_su]
    mov rax, r10
    shl rax, 7
    add rsi, rax
    shl r10, 3
    imul r10, [rbp + 40]
    or r10d, 0x10000
    mov r8, [rdi + G_fs]
    mov r9, [rbp + 272]
    vpcmpeqb ymm1, ymm7, [rdi + G_ms + 64]
    vpcmpeqb ymm2, ymm7, [rdi + G_ms + 96]
M2s_c124
    xor rax, -1
    jz .fbe1
.fs1:
    tzcnt rcx, rax
    blsr rax, rax
    movzx ebx, byte [rdi + G_ms + 64 + rcx]
M2s_c122
%endmacro
%macro M2s_b2a1 0
M2s_c126
    or rax, rcx
M2s_c128
    pext rdx, r12, rdx
    vmovq xmm0, rdx
M2s_c125
    vpermps ymm1, ymm0, [rdx]
%endmacro
%macro M2s_b2a2 0
M2s_c127
M2s_c128
M2s_c129
    shl rdx, 7
    add rdx, rsi
    vpermps ymm1, ymm0, [rdx]
    vmovups [r8 + r9*4], ymm1
%endmacro
%macro M2s_b2a3 0
M2s_c12a
%endmacro
%macro M2s_b2a4 0
M2s_b2a3
M2s_b2a7
%endmacro
%macro M2s_b2a5 0
    vmovd xmm1, edx
    vpbroadcastd ymm1, xmm1
    vpaddd ymm1, ymm1, ymm6
    vpermd ymm1, ymm0, ymm1
%endmacro
%macro M2s_b2a6 0
    vpaddd ymm1, ymm1, ymm6
    vpermd ymm1, ymm0, ymm1
    vmovdqu [r8 + r9*4 + 262144], ymm1
    popcnt ebx, ebx
%endmacro
%macro M2s_b2a7 0
M2s_c12b
%endmacro
%macro M2s_b2a8 0
M2s_c12c
%endmacro
%macro M2s_b2a9 0
    vpermps ymm1, ymm0, [rdx + 96]
    vmovups [r8 + r9*4 + 196608], ymm1
M2s_c12a
M2s_c12b
M2s_c12c
    mov rsi, [rdi + G_cc]
    mov r10, [rdi + G_su]
%endmacro
%macro M2s_b2aa 0
M2s_c12d
%endmacro
%macro M2s_b2ab 0
M2s_c12e
%endmacro
%macro M2s_b2ac 0
    mov rsi, [rdi + G_cc]
    mov r10, [rdi + G_su]
M2s_c12d
M2s_c12e
    movzx ebx, byte [rdi + G_ms + 128 + rcx]
M2s_c122
M2s_c125
    vpermps ymm1, ymm0, [rdx]
    vmovups [r8 + r9*4], ymm1
    vpermps ymm1, ymm0, [rdx + 32]
    vmovups [r8 + r9*4 + 16384], ymm1
    vpermps ymm1, ymm0, [rdx + 64]
    vmovups [r8 + r9*4 + 32768], ymm1
    vpermps ymm1, ymm0, [rdx + 96]
    vmovups [r8 + r9*4 + 49152], ymm1
    lea edx, [r10 + rcx*8]
%endmacro
%macro M2s_b2ad 0
M2s_c12f
    vmovups [r8 + r9*4 + 49152], ymm1
M2s_c12a
    vpermd ymm1, ymm0, ymm1
M2s_c130
    vmovdqu [rdi + G_ms + 0], ymm0
    vmovdqu [rdi + G_ms + 32], ymm0
%endmacro
%macro M2s_b2ae 0
M2s_c130
    vmovdqu [rdi + G_ms + 0], ymm0
    vmovdqu [rdi + G_ms + 32], ymm0
M2s_c131
    mov rdi, [rbp + 8]
    inc qword [rbp + 40]
%endmacro
%macro M2s_b2af 0
M2s_c131
    mov rdi, [rbp + 8]
    inc qword [rbp + 40]
    mov rax, [rbp + 40]
    cmp rax, [rdi + G_nst]
%endmacro
%macro M2s_b2b0 0
M2s_b2b1
    je .ble
    mov qword [rbp + 288], 0
.bl:
    mov r15, [rbp + 8]
%endmacro
%macro M2s_b2b1 0
    mov rax, [rbp + 40]
    cmp rax, [rdi + G_nst]
    jb .str
    cmp qword [rbp + 272], 0
%endmacro
%macro M2s_b2b2 0
    jb .str
    cmp qword [rbp + 272], 0
    je .ble
    mov qword [rbp + 288], 0
%endmacro
%macro M2s_b2b3 0
.bl:
M2s_a246
    lea r12, [rbp + 448]
    call .t1l
%endmacro
%macro M2s_b2b4 0
M2s_a246
    lea r12, [rbp + 448]
    call .t1l
    vpackssdw xmm4, xmm4, xmm4
%endmacro
%macro M2s_b2b5 0
M2s_c132
%endmacro
%macro M2s_b2b6 0
M2s_c133
    add rax, [rbp + 304]
    cmp rax, [rbp + 272]
    jae .bln
    mov rdi, [rbp + 8]
%endmacro
%macro M2s_b2b7 0
M2s_c134
%endmacro
%macro M2s_b2b8 0
    mov rsi, [rdi + G_fs]
    mov ecx, [rsi + rax*4 + 262144]
    movzx edx, cx
    shr ecx, 16
%endmacro
%macro M2s_b2b9 0
M2s_c135
M2s_c137
    lea r12, [rbp + 448]
    mov qword [r12 + 1216], 0
    mov [r12 + 1224], rcx
M2s_b2ba
    mov r15, [rbp + 8]
%endmacro
%macro M2s_b2ba 0
    mov [r12 + 1232], rdx
    call .fz
.blo:
M2s_c139
M2s_c13a
.bc:
%endmacro
%macro M2s_b2bb 0
M2s_c139
M2s_c13a
.bc:
    mov r15, [rbp + 8]
    mov rdi, [rbp + 288]
    shl rdi, 2
%endmacro
%macro M2s_b2bc 0
    mov r15, [rbp + 8]
    mov rdi, [rbp + 288]
    shl rdi, 2
    add rdi, [r15 + G_fs]
%endmacro
%macro M2s_b2bd 0
M2s_b2bc
M2s_c13b
%endmacro
%macro M2s_b2be 0
    mov rdi, [rbp + 288]
    shl rdi, 2
    add rdi, [r15 + G_fs]
M2s_c13b
    vmovq [rbp + 312], xmm4
%endmacro
%macro M2s_b2bf 0
M2s_c13c
    vpackssdw xmm4, xmm4, xmm4
    vmovq [rbp + 312], xmm4
    vpackssdw xmm5, xmm5, xmm5
    vmovq [rbp + 320], xmm5
%endmacro
%macro M2s_b2c0 0
    vmovq [rbp + 312], xmm4
    vpackssdw xmm5, xmm5, xmm5
    vmovq [rbp + 320], xmm5
    mov qword [rbp + 304], 0
%endmacro
%macro M2s_b2c1 0
    vpackssdw xmm5, xmm5, xmm5
    vmovq [rbp + 320], xmm5
    mov qword [rbp + 304], 0
.bcj:
%endmacro
%macro M2s_b2c2 0
    shl rdi, 2
    add rdi, [r15 + G_fs]
    lea r12, [rbp + 448]
    call .t1l
M2s_c132
M2s_c134
    shr ecx, 16
M2s_c135
M2s_c137
    lea r12, [rbp + 448]
    mov qword [r12 + 1216], 0
    mov [r12 + 1224], rcx
%endmacro
%macro M2s_b2c3 0
M2s_c13d
M2s_c136
M2s_c138
    mov [r12 + 1224], rcx
    mov [r12 + 1232], rdx
    call .fz
.blo:
%endmacro
%macro M2s_b2c4 0
.bcj:
    mov rax, [rbp + 288]
    add rax, [rbp + 304]
    cmp rax, [rbp + 280]
%endmacro
%macro M2s_b2c5 0
    mov rax, [rbp + 288]
M2s_b2c6
    mov rsi, [rdi + G_fs]
    mov ecx, [rsi + rax*4 + 393216]
    mov edx, ecx
%endmacro
%macro M2s_b2c6 0
    add rax, [rbp + 304]
    cmp rax, [rbp + 280]
    jae .bcn
    mov rdi, [rbp + 8]
%endmacro
%macro M2s_b2c7 0
    cmp rax, [rbp + 280]
    jae .bcn
    mov rdi, [rbp + 8]
    mov rsi, [rdi + G_fs]
%endmacro
%macro M2s_b2c8 0
    jae .bcn
    mov rdi, [rbp + 8]
    mov rsi, [rdi + G_fs]
    mov ecx, [rsi + rax*4 + 393216]
%endmacro
%macro M2s_b2c9 0
M2s_c13e
%endmacro
%macro M2s_b2ca 0
M2s_c13f
%endmacro
%macro M2s_b2cb 0
    mov ecx, [rsi + rax*4 + 393216]
    mov edx, ecx
M2s_c13e
M2s_c13f
M2s_c141
    jb .bc
.bce:
%endmacro
%macro M2s_b2cc 0
M2s_c140
M2s_c142
M2s_c143
    cmp rax, [rbp + 280]
    jb .bc
.bce:
    mov qword [rbp + 272], 0
%endmacro
%macro M2s_b2cd 0
M2s_c141
    jb .bc
.bce:
M2s_c144
M2s_c146
    pop r12
    pop rbx
%endmacro
%macro M2s_b2ce 0
M2s_c144
M2s_c146
    pop r12
    pop rbx
    pop rbp
    vzeroupper
%endmacro
%macro M2s_b2cf 0
M2s_c145
M2s_c147
    pop rbx
    pop rbp
    vzeroupper
    ret
%endmacro
%macro M2s_b2d0 0
    pop rbp
    vzeroupper
M2s_c148
    mov rax, rcx
    shl rax, 5
%endmacro
%macro M2s_b2d1 0
M2s_c148
    mov rax, rcx
    shl rax, 5
    add rax, [rdi + G_rd]
    vbroadcastss ymm12, [rax + Rc_k]
%endmacro
%macro M2s_b2d2 0
M2s_c149
    shl rax, 5
    add rax, [rdi + G_rd]
    vbroadcastss ymm12, [rax + Rc_k]
    vbroadcastss ymm13, [rax + Rc_k + 4]
%endmacro
%macro M2s_b2d3 0
    add rax, [rdi + G_rd]
    vbroadcastss ymm12, [rax + Rc_k]
    vbroadcastss ymm13, [rax + Rc_k + 4]
    vbroadcastss ymm14, [rax + Rc_k + 8]
%endmacro
%macro M2s_b2d4 0
    vbroadcastss ymm13, [rax + Rc_k + 4]
    vbroadcastss ymm14, [rax + Rc_k + 8]
    vbroadcastss ymm15, [rax + Rc_k + 12]
    mov r8d, [rax + Rc_co]
%endmacro
%macro M2s_b2d5 0
    mov r9d, [rax + Rc_co + 4]
    mov r10d, [rax + Rc_co + 8]
    mov r11d, [rax + Rc_co + 12]
    mov rdx, [rbp + 56]
%endmacro
%macro M2s_b2d6 0
    vbroadcastss ymm15, [rax + Rc_k + 12]
M2s_b2d7
    mov rdx, [rbp + 56]
    mov rsi, [rdi + G_cr]
    lea rsi, [rsi + rdx*8]
%endmacro
%macro M2s_b2d7 0
    mov r8d, [rax + Rc_co]
    mov r9d, [rax + Rc_co + 4]
    mov r10d, [rax + Rc_co + 8]
    mov r11d, [rax + Rc_co + 12]
%endmacro
%macro M2s_b2d8 0
M2s_c14a
%endmacro
%macro M2s_b2d9 0
M2s_c14b
%endmacro
%macro M2s_b2da 0
    mov rdx, [rbp + 56]
    mov rsi, [rdi + G_cr]
    lea rsi, [rsi + rdx*8]
M2s_c14a
M2s_c14b
M2s_c14d
M2s_c151
    vmulps ymm1, ymm12, [r8 + rdx*8]
%endmacro
%macro M2s_b2db 0
M2s_c14c
M2s_c14f
M2s_c150
M2s_c152
%endmacro
%macro M2s_b2dc 0
M2s_c14d
M2s_c151
    vmulps ymm1, ymm12, [r8 + rdx*8]
M2s_c153
    vfmadd231ps ymm3, ymm2, ymm8
    vmovaps ymm4, ymm0
    vfmadd231ps ymm4, ymm2, ymm9
%endmacro
%macro M2s_b2dd 0
M2s_c14e
M2s_c152
M2s_c154
M2s_c155
%endmacro
%macro M2s_b2de 0
M2s_c153
    vfmadd231ps ymm3, ymm2, ymm8
M2s_c155
    vmovups [rbx + rdx*4], ymm3
    vmovups [rsi + rdx*4], ymm4
    vmovups [rdi + rdx*4], ymm0
%endmacro
%macro M2s_b2df 0
M2s_c154
M2s_c155
M2s_c156
%endmacro
%macro M2s_b2e0 0
    vfmadd231ps ymm4, ymm1, ymm10
    vfmadd231ps ymm0, ymm1, ymm11
M2s_c156
    cmp rdx, r13
    jb .frl
%endmacro
%macro M2s_b2e1 0
    vmovups [rbx + rdx*4], ymm3
    vmovups [rsi + rdx*4], ymm4
    vmovups [rdi + rdx*4], ymm0
M2s_b2e2
.pf32:
%endmacro
%macro M2s_b2e2 0
    add rdx, 8
    cmp rdx, r13
    jb .frl
    ret
%endmacro
%macro M2s_b2e3 0
    cmp rdx, r13
    jb .frl
    ret
.pf32:
%endmacro
%macro M2s_b2e4 0
M2s_c157
%endmacro
%macro M2s_b2e5 0
    prefetcht0 [rax + 1984]
.pf31:
    prefetcht0 [rax + 1920]
.pf30:
%endmacro
%macro M2s_b2e6 0
.pf31:
    prefetcht0 [rax + 1920]
.pf30:
    prefetcht0 [rax + 1856]
%endmacro
%macro M2s_b2e7 0
    prefetcht0 [rax + 1920]
.pf30:
    prefetcht0 [rax + 1856]
.pf29:
%endmacro
%macro M2s_b2e8 0
    ret
M2s_c157
.pf30:
    prefetcht0 [rax + 1856]
.pf29:
%endmacro
%macro M2s_b2e9 0
.pf30:
    prefetcht0 [rax + 1856]
.pf29:
    prefetcht0 [rax + 1792]
%endmacro
%macro M2s_b2ea 0
    prefetcht0 [rax + 1856]
.pf29:
    prefetcht0 [rax + 1792]
.pf28:
%endmacro
%macro M2s_b2eb 0
M2s_c158
%endmacro
%macro M2s_b2ec 0
    prefetcht0 [rax + 1792]
M2s_c159
.pf26:
    prefetcht0 [rax + 1600]
.pf25:
%endmacro
%macro M2s_b2ed 0
M2s_c159
.pf26:
    prefetcht0 [rax + 1600]
.pf25:
    prefetcht0 [rax + 1536]
%endmacro
%macro M2s_b2ee 0
M2s_c15a
    prefetcht0 [rax + 1600]
.pf25:
    prefetcht0 [rax + 1536]
.pf24:
%endmacro
%macro M2s_b2ef 0
M2s_c15b
%endmacro
%macro M2s_b2f0 0
M2s_c15c
%endmacro
%macro M2s_b2f1 0
    prefetcht0 [rax + 1536]
.pf24:
M2s_c15c
M2s_c15e
M2s_c160
    prefetcht0 [rax + 576]
.pf9:
%endmacro
%macro M2s_b2f2 0
M2s_c15d
M2s_c15f
M2s_c161
.pf10:
    prefetcht0 [rax + 576]
.pf9:
    prefetcht0 [rax + 512]
%endmacro
%macro M2s_b2f3 0
M2s_c15e
M2s_c160
    prefetcht0 [rax + 576]
.pf9:
M2s_c162
    prefetcht0 [rax + 384]
.pf6:
%endmacro
%macro M2s_b2f4 0
M2s_c162
    prefetcht0 [rax + 384]
M2s_c164
%endmacro
%macro M2s_b2f5 0
M2s_c163
M2s_c164
    prefetcht0 [rax + 0]
%endmacro
%macro M2s_b2f6 0
    prefetcht0 [rax + 320]
.pf5:
    prefetcht0 [rax + 256]
.pf4:
    prefetcht0 [rax + 192]
.pf3:
    prefetcht0 [rax + 128]
.pf2:
%endmacro
%macro M2s_b2f7 0
    prefetcht0 [rax + 64]
.pf1:
    prefetcht0 [rax + 0]
    ret
%endmacro
%macro M2s_b2f8 0
    prefetcht0 [rax + 0]
    ret
.rowa:
    mov rax, [rbp + 72]
%endmacro
%macro M2s_b2f9 0
    cmp rax, [rbp + 344]
    je .rqa
    call .fr
.rqa:
%endmacro
%macro M2s_b2fa 0
.rowa:
    mov rax, [rbp + 72]
    cmp rax, [rbp + 344]
    je .rqa
%endmacro
%macro M2s_b2fb 0
    mov rax, [rbp + 72]
    cmp rax, [rbp + 344]
    je .rqa
    call .fr
%endmacro
%macro M2s_b2fc 0
    call .fr
.rqa:
M2s_a268
M2s_a26b
%endmacro
%macro M2s_b2fd 0
.rqa:
M2s_a268
M2s_a26b
    cmp rcx, [rbp + 352]
%endmacro
%macro M2s_b2fe 0
M2s_a268
M2s_a26b
    cmp rcx, [rbp + 352]
    jae .fu
%endmacro
%macro M2s_b2ff 0
    jae .fu
M2s_a26d
M2s_a26f
M2s_a270
%endmacro
%macro M2s_b300 0
M2s_a26d
M2s_a26f
M2s_a270
    jb .fq0r
%endmacro
%macro M2s_b301 0
    cmp rcx, [rbp + 352]
    jae .fu
M2s_a26d
M2s_a26f
%endmacro
%macro M2s_b302 0
    mov rdi, [rbp + 8]
M2s_c15b
    imul rax, rax, 12
    add rbx, rax
    mov r13, [rbp + 64]
%endmacro
%macro M2s_b303 0
M2s_c166
%endmacro
%macro M2s_b304 0
M2s_c167
%endmacro
%macro M2s_b305 0
M2s_c168
%endmacro
%macro M2s_b306 0
M2s_a271
M2s_a277
.fq0:
    vpmovzxwd ymm0, [rcx+rdx*2]
%endmacro
%macro M2s_b307 0
M2s_c169
    vmovaps [rbp + 1184], ymm0
    vbroadcastss ymm0, [rax + Rc_k + 8]
    vmovaps [rbp + 1216], ymm0
M2s_b308
    add rcx, [rdi + G_sy]
M2s_b30b
%endmacro
%macro M2s_b308 0
    vbroadcastss ymm0, [rax + Rc_k + 12]
M2s_c16c
M2s_c16e
    imul rcx, [rdi + G_ys]
    add rcx, rdx
    add rcx, rcx
%endmacro
%macro M2s_b309 0
M2s_c16c
M2s_c16e
M2s_c158
%endmacro
%macro M2s_b30a 0
M2s_c16d
M2s_c16f
    add rcx, rdx
    add rcx, rcx
    add rcx, [rdi + G_sy]
    imul rax, [rdi + G_ys], 2
%endmacro
%macro M2s_b30b 0
    imul rax, [rdi + G_ys], 2
    add rax, rcx
    call [rbp + 328]
    mov eax, [rbp + 344]
%endmacro
%macro M2s_b30c 0
M2s_c170
%endmacro
%macro M2s_b30d 0
    vmulps ymm2, ymm15, [r9+rdx*8+32]
    vfmadd231ps ymm1, ymm14, [r10+rdx*8]
    vpaddd ymm3, ymm0, ymm7
    vfmadd231ps ymm2, ymm14, [r10+rdx*8+32]
%endmacro
%macro M2s_b30e 0
    and eax, 1
    imul rax, [rdi + G_sp]
    imul rax, rax, 12
    add rax, [rdi + G_xb]
    mov r14, [rdi + G_sp]
    shl r14, 2
    lea rsi, [rax + r14]
    lea r14, [rsi + r14]
%endmacro
%macro M2s_b30f 0
    mov rdi, rax
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
%endmacro
%macro M2s_b310 0
M2s_c171
%endmacro
%macro M2s_b311 0
M2s_a277
M2s_c172
M2s_b317
%endmacro
%macro M2s_b312 0
M2s_c172
M2s_b317
    vfmadd231ps ymm2, ymm13, [r11+rdx*8+96]
%endmacro
%macro M2s_b313 0
M2s_c173
    vfmadd231ps ymm2, ymm13, [r11+rdx*8+96]
    vfmadd231ps ymm0, ymm12, [r12+rdx*8+64]
%endmacro
%macro M2s_b314 0
M2s_a283
M2s_b315
M2s_b317
    vfmadd231ps ymm2, ymm13, [r11+rdx*8+96]
    vfmadd231ps ymm0, ymm12, [r12+rdx*8+64]
    vfmadd231ps ymm2, ymm12, [r12+rdx*8+96]
%endmacro
%macro M2s_b315 0
M2s_c174
%endmacro
%macro M2s_b316 0
M2s_c175
    vpaddd ymm1, ymm3, ymm7
    vmulps ymm2, ymm15, [r9+rdx*8+96]
    vfmadd231ps ymm0, ymm14, [r10+rdx*8+64]
    vcvtdq2ps ymm4, ymm1
%endmacro
%macro M2s_b317 0
M2s_c176
%endmacro
%macro M2s_b318 0
    vmovups ymm5, [c_xflr]
.fq0:
M2s_a27a
M2s_a283
M2s_c174
M2s_c176
%endmacro
%macro M2s_b319 0
M2s_c178
%endmacro
%macro M2s_b31a 0
M2s_c179
%endmacro
%macro M2s_b31b 0
    vfmadd231ps ymm0, ymm12, [r12+rdx*8+64]
    vfmadd231ps ymm2, ymm12, [r12+rdx*8+96]
    vmovaps ymm3, ymm4
    vfmadd231ps ymm3, ymm2, ymm11
%endmacro
%macro M2s_b31c 0
M2s_c17a
%endmacro
%macro M2s_b31d 0
M2s_c17b
%endmacro
%macro M2s_b31e 0
    vfmadd231ps ymm2, ymm0, ymm9
    vmovaps [r14+rdx*4+32], ymm4
    vmovups ymm1, [rbx+rdx*4+32]
    vmovaps [rsi+rdx*4+32], ymm2
%endmacro
%macro M2s_b31f 0
    vmovups ymm1, [rbx+rdx*4+32]
    vmovaps [rsi+rdx*4+32], ymm2
    vandps ymm3, ymm1, ymm6
    vxorps ymm0, ymm1, ymm3
%endmacro
%macro M2s_b320 0
    vfmadd231ps ymm2, ymm12, [r12+rdx*8+96]
    vmovaps ymm3, ymm4
M2s_c17a
    vfmadd231ps ymm2, ymm0, ymm9
    vmovaps [r14+rdx*4+32], ymm4
%endmacro
%macro M2s_b321 0
M2s_c17c
M2s_c17d
%endmacro
%macro M2s_b322 0
    vandps ymm3, ymm1, ymm6
    vxorps ymm0, ymm1, ymm3
    vpmaxud ymm4, ymm3, ymm5
    vpsrld ymm2, ymm4, 23
%endmacro
%macro M2s_b323 0
    vpmovzxwd ymm0, [rcx+rdx*2]
M2s_c170
    vfmadd231ps ymm2, ymm14, [r10+rdx*8+32]
M2s_b324
    vfmadd213ps ymm2, ymm10, ymm4
    vfmadd231ps ymm4, ymm1, ymm8
%endmacro
%macro M2s_b324 0
M2s_c17f
%endmacro
%macro M2s_b325 0
    vfmadd213ps ymm2, ymm10, ymm4
    vfmadd231ps ymm4, ymm1, ymm8
M2s_a27d
M2s_c177
    vmulps ymm2, ymm15, [r9+rdx*8+96]
M2s_c176
M2s_c179
M2s_c17a
    vfmadd231ps ymm2, ymm0, ymm9
    vmovaps [r14+rdx*4+32], ymm4
    vmovups ymm1, [rbx+rdx*4+32]
M2s_b326
    vpsrld ymm2, ymm4, 23
%endmacro
%macro M2s_b326 0
    vmovaps [rsi+rdx*4+32], ymm2
    vandps ymm3, ymm1, ymm6
    vxorps ymm0, ymm1, ymm3
    vpmaxud ymm4, ymm3, ymm5
%endmacro
%macro M2s_b327 0
    vpmaddwd ymm1, ymm2, [c_k5]
    vpslld ymm3, ymm2, 23
    vpsrld ymm2, ymm1, 14
    vpsrld ymm1, ymm1, 17
%endmacro
%macro M2s_b328 0
    vpsrld ymm2, ymm1, 14
    vpsrld ymm1, ymm1, 17
    vpermd ymm1, ymm1, [c_p8]
    vpermd ymm2, ymm2, [c_c8]
%endmacro
%macro M2s_b329 0
M2s_b32a
    vandps ymm0, ymm3, ymm6
M2s_b32e
M2s_b32f
    vpermd ymm2, ymm2, [c_c8]
    vpaddd ymm3, ymm3, ymm2
    vorps ymm2, ymm3, ymm1
%endmacro
%macro M2s_b32a 0
    vfmadd231ps ymm2, ymm1, ymm9
    vmovaps [r14+rdx*4], ymm4
    vmovups ymm3, [rbx+rdx*4]
    vmovaps [rsi+rdx*4], ymm2
%endmacro
%macro M2s_b32b 0
    vmovaps [r14+rdx*4], ymm4
M2s_c182
%endmacro
%macro M2s_b32c 0
M2s_c182
    vpslld ymm0, ymm2, 23
%endmacro
%macro M2s_b32d 0
    vmovaps [rsi+rdx*4], ymm2
    vandps ymm0, ymm3, ymm6
M2s_b32e
    vpslld ymm0, ymm2, 23
    vpsrld ymm2, ymm3, 14
%endmacro
%macro M2s_b32e 0
M2s_c183
%endmacro
%macro M2s_b32f 0
M2s_c184
%endmacro
%macro M2s_b330 0
    vpsrld ymm2, ymm3, 14
    vpsrld ymm3, ymm3, 17
    vpermd ymm3, ymm3, [c_p8]
    vpermd ymm2, ymm2, [c_c8]
%endmacro
%macro M2s_b331 0
    vpsrld ymm3, ymm3, 17
    vpermd ymm3, ymm3, [c_p8]
    vpermd ymm2, ymm2, [c_c8]
    vpaddd ymm3, ymm3, ymm2
%endmacro
%macro M2s_b332 0
    vpaddd ymm3, ymm3, ymm2
    vorps ymm2, ymm3, ymm1
    vpsrld ymm3, ymm4, 20
    vpermps ymm1, ymm3, [c_w8e]
%endmacro
%macro M2s_b333 0
    vorps ymm2, ymm3, ymm1
    vpsrld ymm3, ymm4, 20
    vpermps ymm1, ymm3, [c_w8e]
    vpermps ymm3, ymm3, [c_rxe]
%endmacro
%macro M2s_b334 0
    vpsrld ymm3, ymm4, 20
    vpermps ymm1, ymm3, [c_w8e]
    vpermps ymm3, ymm3, [c_rxe]
    vmulps ymm2, ymm2, ymm1
%endmacro
%macro M2s_b335 0
    vpermps ymm3, ymm3, [c_rxe]
    vmulps ymm2, ymm2, ymm1
    vpsubd ymm1, ymm3, ymm0
    vfmadd213ps ymm4, ymm1, [c_mone]
%endmacro
%macro M2s_b336 0
    vmovaps [rdi+rdx*4+32], ymm3
    vfmadd213ps ymm2, ymm10, ymm4
M2s_c17d
    vmovaps [rsi+rdx*4+32], ymm2
    vandps ymm3, ymm1, ymm6
%endmacro
%macro M2s_b337 0
    vandps ymm3, ymm1, ymm6
    vxorps ymm0, ymm1, ymm3
    vpmaxud ymm4, ymm3, ymm5
M2s_a28d
%endmacro
%macro M2s_b338 0
    vpmaxud ymm4, ymm3, ymm5
M2s_a28d
    vmovaps [r8+288], ymm4
    add r8, 576
%endmacro
%macro M2s_b339 0
M2s_a28d
M2s_a291
    jbe .fq0
.fq0r:
    cmp rdx, r13
    jae .fq0e
M2s_c167
M2s_c178
    vmovups ymm7, [c_n64]
    vmovups ymm6, [c_absm]
    vmovups ymm5, [c_xflr]
.fq0s:
M2s_c17e
    vpaddd ymm3, ymm0, ymm7
    vfmadd231ps ymm2, ymm14, [r10+rdx*8+32]
M2s_c17f
%endmacro
%macro M2s_b33a 0
M2s_c186
M2s_c188
M2s_c181
    vmovaps ymm0, ymm4
    vfmadd231ps ymm0, ymm2, ymm11
    vmovaps [rdi+rdx*4], ymm0
    vfmadd213ps ymm2, ymm10, ymm4
%endmacro
%macro M2s_b33b 0
    vpmaxud ymm4, ymm3, ymm5
M2s_c185
M2s_c187
M2s_c180
    vfmadd231ps ymm2, ymm12, [r12+rdx*8+32]
    vmovaps ymm0, ymm4
    vfmadd231ps ymm0, ymm2, ymm11
%endmacro
%macro M2s_b33c 0
M2s_c18a
%endmacro
%macro M2s_b33d 0
M2s_c18b
%endmacro
%macro M2s_b33e 0
    vpermd ymm1, ymm1, [c_p8]
    vpermd ymm2, ymm2, [c_c8]
M2s_c18c
    vpermps ymm1, ymm1, [c_rxe]
    vmulps ymm2, ymm2, ymm0
%endmacro
%macro M2s_b33f 0
M2s_c18c
    vpermps ymm1, ymm1, [c_rxe]
    vmulps ymm2, ymm2, ymm0
    vpsubd ymm0, ymm1, ymm3
    vfmadd213ps ymm4, ymm0, [c_mone]
%endmacro
%macro M2s_b340 0
    vmovaps [r8+320], ymm2
M2s_c186
M2s_c188
M2s_c181
    vmovaps ymm0, ymm4
    vfmadd231ps ymm0, ymm2, ymm11
    vmovaps [rdi+rdx*4], ymm0
%endmacro
%macro M2s_b341 0
    add r8, 288
    add rdx, 8
    cmp rdx, r13
M2s_b342
    lea r15, [r13 - 16]
    vmovups ymm15, [c_absm]
.fp0:
M2s_a296
M2s_a297
%endmacro
%macro M2s_b342 0
M2s_c18d
%endmacro
%macro M2s_b343 0
M2s_a296
M2s_a297
M2s_a298
    cmp rdx, r15
%endmacro
%macro M2s_b344 0
M2s_c18e
%endmacro
%macro M2s_b345 0
    vmovaps [r8+32], ymm2
    vmovaps [r8], ymm4
    add r8, 288
    add rdx, 8
    cmp rdx, r13
M2s_c18d
    lea r15, [r13 - 16]
    vmovups ymm15, [c_absm]
.fp0:
%endmacro
%macro M2s_b346 0
M2s_c18f
M2s_c191
    vpsrld ymm13, ymm0, 14
M2s_b347
    vpermd ymm0, ymm14, [c_p8]
    vpsubd ymm13, ymm8, ymm2
    vfmadd213ps ymm7, ymm13, [c_mone]
%endmacro
%macro M2s_b347 0
    vpsubd ymm9, ymm14, ymm11
    vpsrld ymm14, ymm0, 17
    vpermd ymm11, ymm13, [c_c8]
    vfmadd213ps ymm5, ymm9, [c_mone]
%endmacro
%macro M2s_b348 0
    vpsrld ymm14, ymm0, 17
    vpermd ymm11, ymm13, [c_c8]
    vfmadd213ps ymm5, ymm9, [c_mone]
    vpermd ymm0, ymm14, [c_p8]
%endmacro
%macro M2s_b349 0
M2s_c193
%endmacro
%macro M2s_b34a 0
M2s_c194
%endmacro
%macro M2s_b34b 0
.fp0r:
M2s_c195
M2s_c197
    mov rcx, [rbp + 152]
    xor edx, edx
    mov r8, [rbp + 336]
%endmacro
%macro M2s_b34c 0
M2s_c195
M2s_c197
    mov rcx, [rbp + 152]
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
%endmacro
%macro M2s_b34d 0
M2s_c196
M2s_c198
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .fp1r
%endmacro
%macro M2s_b34e 0
    cmp r13, 16
M2s_c199
%endmacro
%macro M2s_b34f 0
M2s_c199
    vxorps ymm6, ymm0, ymm5
%endmacro
%macro M2s_b350 0
M2s_a2a5
    vmovups ymm12, [c_mone]
.fp1:
M2s_a2a6
%endmacro
%macro M2s_b351 0
    vandps ymm5, ymm0, ymm15
    vxorps ymm6, ymm0, ymm5
    vpmaxud ymm7, ymm5, ymm14
    vfmadd231ps ymm3, ymm1, [c_q8e3]
%endmacro
%macro M2s_b352 0
    vxorps ymm6, ymm0, ymm5
    vpmaxud ymm7, ymm5, ymm14
    vfmadd231ps ymm3, ymm1, [c_q8e3]
    vmulps ymm8, ymm1, ymm2
%endmacro
%macro M2s_b353 0
M2s_c19a
%endmacro
%macro M2s_b354 0
M2s_c19b
%endmacro
%macro M2s_b355 0
M2s_c19c
%endmacro
%macro M2s_b356 0
M2s_c19d
%endmacro
%macro M2s_b357 0
M2s_c19e
%endmacro
%macro M2s_b358 0
M2s_c19f
%endmacro
%macro M2s_b359 0
M2s_c1a0
%endmacro
%macro M2s_b35a 0
M2s_c1a1
%endmacro
%macro M2s_b35b 0
M2s_c1a2
%endmacro
%macro M2s_b35c 0
    vmovups ymm0, [rsi+rdx*4]
    vmovups ymm1, [r8]
    vmovups ymm2, [r8+32]
    vmovups ymm3, [c_q8e2]
%endmacro
%macro M2s_b35d 0
M2s_c1a3
    vpmaddwd ymm0, ymm9, ymm13
    vpslld ymm5, ymm9, 23
    vxorps ymm9, ymm4, ymm11
    vpmaxud ymm4, ymm11, ymm14
%endmacro
%macro M2s_b35e 0
M2s_c1a4
    vpslld ymm5, ymm9, 23
    vxorps ymm9, ymm4, ymm11
    vpmaxud ymm4, ymm11, ymm14
    vfmadd213ps ymm3, ymm1, [c_q8e1]
%endmacro
%macro M2s_b35f 0
    vpmaxud ymm4, ymm11, ymm14
    vfmadd213ps ymm3, ymm1, [c_q8e1]
    vpsrld ymm11, ymm0, 14
    vpsrld ymm0, ymm0, 17
%endmacro
%macro M2s_b360 0
    vfmadd213ps ymm3, ymm1, [c_q8e1]
    vpsrld ymm11, ymm0, 14
    vpsrld ymm0, ymm0, 17
    vpermd ymm0, ymm0, [c_p8]
%endmacro
%macro M2s_b361 0
    vpsrld ymm8, ymm4, 23
M2s_c1a5
M2s_c1a6
M2s_a2b4
    vmovaps [r8+96], ymm7
M2s_a2b5
%endmacro
%macro M2s_b362 0
M2s_c1a5
M2s_c1a6
M2s_c1a7
%endmacro
%macro M2s_b363 0
    vorps ymm2, ymm8, ymm9
M2s_c1a8
    vfmadd213ps ymm3, ymm1, [c_q8e1]
    vfmadd213ps ymm3, ymm1, [c_q8e0]
    vfmadd231ps ymm5, ymm7, ymm3
%endmacro
%macro M2s_b364 0
M2s_c1a8
M2s_c1a9
%endmacro
%macro M2s_b365 0
    vmovaps [rbx+rdx*4+32], ymm5
M2s_a2b6
    cmp rdx, r15
    jbe .fp1
%endmacro
%macro M2s_b366 0
M2s_c1aa
%endmacro
%macro M2s_b367 0
    vfmadd231ps ymm3, ymm1, [c_q8e3]
M2s_c1a3
    vpmaddwd ymm0, ymm9, ymm13
    vpslld ymm5, ymm9, 23
    vxorps ymm9, ymm4, ymm11
%endmacro
%macro M2s_b368 0
M2s_a2af
M2s_c1a5
M2s_c1a6
M2s_c1a7
M2s_c1a8
M2s_c1a9
M2s_c1aa
    cmp rdx, r13
    jae .fp1e
    vmovups ymm15, [c_absm]
%endmacro
%macro M2s_b369 0
    vfmadd213ps ymm3, ymm1, [c_q8e0]
M2s_a2b1
    vorps ymm10, ymm1, ymm6
    vpsrld ymm8, ymm4, 23
%endmacro
%macro M2s_b36a 0
M2s_c1ab
%endmacro
%macro M2s_b36b 0
M2s_c1ac
%endmacro
%macro M2s_b36c 0
M2s_c1ad
%endmacro
%macro M2s_b36d 0
M2s_c1ae
%endmacro
%macro M2s_b36e 0
M2s_c1af
%endmacro
%macro M2s_b36f 0
.fp1s:
    vmovups ymm0, [rsi+rdx*4]
    vmovups ymm1, [r8]
    vmovups ymm2, [r8+32]
M2s_a2b9
M2s_a2bf
M2s_b370
M2s_a2c0
    jb .fp1s
.fp1e:
M2s_a2c1
M2s_b371
    vmovups ymm12, [c_mone]
.fp2:
M2s_a2c5
    vmovups ymm4, [r14+rdx*4+32]
    vandps ymm5, ymm0, ymm15
    vxorps ymm6, ymm0, ymm5
%endmacro
%macro M2s_b370 0
M2s_c1b0
    vmulps ymm1, ymm8, ymm3
    vmovaps [r8+128], ymm1
    vaddps ymm0, ymm2, [rcx+rdx*4]
    vmovaps [rbx+rdx*4], ymm2
%endmacro
%macro M2s_b371 0
M2s_c1b1
M2s_c1a2
%endmacro
%macro M2s_b372 0
M2s_c1b2
%endmacro
%macro M2s_b373 0
    vpslld ymm0, ymm8, 23
    vpermps ymm3, ymm9, [c_w8e]
    vpermps ymm8, ymm9, [c_rxe]
    vfmadd213ps ymm4, ymm1, [c_q8e1]
%endmacro
%macro M2s_b374 0
M2s_c1b3
%endmacro
%macro M2s_b375 0
M2s_c1b4
%endmacro
%macro M2s_b376 0
    vfmadd213ps ymm4, ymm1, [c_q8e1]
    vpsrld ymm9, ymm10, 14
M2s_a2be
    vfmadd213ps ymm6, ymm8, ymm12
%endmacro
%macro M2s_b377 0
M2s_c1b5
%endmacro
%macro M2s_b378 0
M2s_c1b6
%endmacro
%macro M2s_b379 0
M2s_c1b7
%endmacro
%macro M2s_b37a 0
M2s_c1b8
%endmacro
%macro M2s_b37b 0
    vpsrld ymm3, ymm4, 20
    vmovups ymm1, [r8+384]
    vmulps ymm6, ymm10, ymm0
    vpsubd ymm10, ymm11, ymm5
    vmovaps [rsi+rdx*4], ymm2
    vaddps ymm0, ymm2, [rcx+rdx*4]
    vpmaddwd ymm11, ymm8, ymm13
    vmovups ymm5, [r8+416]
M2s_c1ab
    vmovaps [rdi+rdx*4], ymm0
    vmovups ymm3, [c_q8e2]
    vmovaps [r8+224], ymm6
M2s_c1ac
    vmovaps [r8+192], ymm7
M2s_c1ad
    vorps ymm2, ymm8, ymm9
M2s_c1bc
    vfmadd213ps ymm3, ymm1, [c_q8e1]
    vfmadd213ps ymm3, ymm1, [c_q8e0]
    vfmadd231ps ymm5, ymm7, ymm3
%endmacro
%macro M2s_b37c 0
M2s_c1ba
    vpermd ymm11, ymm6, [c_p8]
    vpermd ymm6, ymm0, [c_c8]
M2s_c1bb
M2s_c1bd
    vfmadd231ps ymm5, ymm7, ymm3
    vmovaps [rsi+rdx*4+32], ymm5
%endmacro
%macro M2s_b37d 0
    vfmadd231ps ymm5, ymm7, ymm3
M2s_b37e
M2s_b380
M2s_c1b4
    vpslld ymm0, ymm8, 23
    vpermps ymm3, ymm9, [c_w8e]
    vpermps ymm8, ymm9, [c_rxe]
%endmacro
%macro M2s_b37e 0
    vmovaps [rsi+rdx*4+32], ymm5
M2s_c1ae
    cmp rdx, r15
    jbe .fp2
.fp2r:
    cmp rdx, r13
    jae .fp2e
M2s_c19a
    vmovups ymm11, [c_q8e3]
.fp2s:
%endmacro
%macro M2s_b37f 0
M2s_c1bf
    vmovups ymm12, [c_mone]
    vmovups ymm11, [c_q8e3]
.fp2s:
M2s_c1c0
    vmovaps ymm4, ymm1
%endmacro
%macro M2s_b380 0
M2s_c1c0
    vmovaps ymm4, ymm1
    vfmadd213ps ymm4, ymm11, [c_q8e2]
    vxorps ymm5, ymm0, ymm3
    vpmaxud ymm6, ymm3, ymm14
%endmacro
%macro M2s_b381 0
    vpmaxud ymm6, ymm3, ymm14
M2s_c1b4
    vpslld ymm0, ymm8, 23
    vpermps ymm3, ymm9, [c_w8e]
    vpermps ymm8, ymm9, [c_rxe]
%endmacro
%macro M2s_b382 0
M2s_c1c2
%endmacro
%macro M2s_b383 0
M2s_c1c3
    vmovaps [r8+224], ymm1
    vaddps ymm0, ymm2, [rcx+rdx*4]
    vmovaps [rsi+rdx*4], ymm2
M2s_c1b6
    jb .fp2s
.fp2e:
M2s_a2ca
M2s_b384
    vmovups ymm12, [c_mone]
    vmovups ymm11, [c_q8e3]
%endmacro
%macro M2s_b384 0
M2s_c1c4
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .fp3r
M2s_c1a2
%endmacro
%macro M2s_b385 0
M2s_c1c5
M2s_c19a
%endmacro
%macro M2s_b386 0
    vmovups ymm8, [c_q8e0]
    vmovups ymm7, [c_c8]
.fp3:
M2s_a2cb
M2s_a2cc
    vmovaps ymm0, ymm10
    vfmadd231ps ymm0, ymm3, ymm11
    vmovups ymm2, [rbx+rdx*4+32]
%endmacro
%macro M2s_b387 0
    vmovaps ymm0, ymm10
    vfmadd231ps ymm0, ymm3, ymm11
    vmovups ymm2, [rbx+rdx*4+32]
    vaddps ymm5, ymm1, [rcx+rdx*4]
%endmacro
%macro M2s_b388 0
    vaddps ymm5, ymm1, [rcx+rdx*4]
    vmovaps [rdi+rdx*4], ymm5
    vminps ymm5, ymm1, [u_zero]
    vfmadd213ps ymm0, ymm3, ymm9
%endmacro
%macro M2s_b389 0
M2s_c1c6
%endmacro
%macro M2s_b38a 0
    mov rdi, [rbp + 136]
    mov rcx, [rbp + 152]
M2s_b38b
    imul rax, rax, 2
    add rcx, rax
%endmacro
%macro M2s_b38b 0
    mov rax, [rbp + 144]
    imul rax, rax, 2
    add rdi, rax
    mov rax, [rbp + 160]
%endmacro
%macro M2s_b38c 0
M2s_c1c7
%endmacro
%macro M2s_b38d 0
M2s_c1c8
%endmacro
%macro M2s_b38e 0
M2s_c1cb
%endmacro
%macro M2s_b38f 0
    vfmadd213ps ymm0, ymm3, ymm9
M2s_c1cc
    jbe .fp3
.fp3r:
    cmp rdx, r13
    jae .fp3e
M2s_c19a
M2s_c19b
    vmovups ymm7, [c_c8]
    vmovups ymm6, [c_p8]
    vmovups ymm5, [c_w8e]
%endmacro
%macro M2s_b390 0
M2s_c1cc
M2s_c1ce
M2s_c19b
    vmovups ymm7, [c_c8]
    vmovups ymm6, [c_p8]
    vmovups ymm5, [c_w8e]
.fp3s:
%endmacro
%macro M2s_b391 0
M2s_c1cd
M2s_c1cf
M2s_c1c6
    vmovups ymm6, [c_p8]
    vmovups ymm5, [c_w8e]
.fp3s:
M2s_a2d1
%endmacro
%macro M2s_b392 0
.fp3s:
M2s_c1d0
M2s_c1d2
    jb .fp3s
.fp3e:
    ret
%endmacro
%macro M2s_b393 0
M2s_c1d0
M2s_c1d2
    jb .fp3s
.fp3e:
    ret
.rows:
%endmacro
%macro M2s_b394 0
M2s_c1d1
M2s_c1d3
.fp3e:
    ret
.rows:
    mov rax, [rbp + 72]
%endmacro
%macro M2s_b395 0
.rows:
M2s_b396
.rqs:
    vmovdqu ymm15, [c_absm]
    vmovdqu ymm14, [c_xflr]
%endmacro
%macro M2s_b396 0
    mov rax, [rbp + 72]
    cmp rax, [rbp + 344]
    je .rqs
    call .fr
%endmacro
%macro M2s_b397 0
    cmp rax, [rbp + 344]
    je .rqs
    call .fr
.rqs:
%endmacro
%macro M2s_b398 0
    vmovdqu ymm15, [c_absm]
    vmovdqu ymm14, [c_xflr]
    vmovdqu ymm13, [c_k5]
    vmovaps ymm12, [c_mone]
%endmacro
%macro M2s_b399 0
M2s_c1d4
%endmacro
%macro M2s_b39a 0
    vmovaps ymm12, [c_mone]
M2s_b39b
M2s_b39d
M2s_b39f
    lea rsi, [rbx + r12]
    mov rdi, [rbp + 136]
    mov rcx, [rbp + 152]
%endmacro
%macro M2s_b39b 0
    vmovaps ymm11, [c_q8e3]
M2s_c1d6
M2s_c1d7
    lea rax, [rax + rax*2]
    add rbx, rax
    vbroadcastss ymm6, [rbp + 168]
%endmacro
%macro M2s_b39c 0
M2s_c1d6
M2s_c1d7
    lea rax, [rax + rax*2]
    add rbx, rax
    vbroadcastss ymm6, [rbp + 168]
    vbroadcastss ymm7, [rbp + 208]
%endmacro
%macro M2s_b39d 0
    vbroadcastss ymm7, [rbp + 208]
M2s_c1d8
    mov r9, [rbp + 192]
    xor edx, edx
.ls0:
%endmacro
%macro M2s_b39e 0
M2s_c1d8
    mov r9, [rbp + 192]
    xor edx, edx
.ls0:
M2s_a2d6
%endmacro
%macro M2s_b39f 0
M2s_a2d6
    add rdx, 8
    cmp rdx, r13
    jb .ls0
%endmacro
%macro M2s_b3a0 0
    add rdx, 8
    cmp rdx, r13
    jb .ls0
    lea rsi, [rbx + r12]
%endmacro
%macro M2s_b3a1 0
M2s_c1d9
%endmacro
%macro M2s_b3a2 0
M2s_c1da
%endmacro
%macro M2s_b3a3 0
M2s_c1e1
M2s_b3a4
%endmacro
%macro M2s_b3a4 0
M2s_c1e2
%endmacro
%macro M2s_b3a5 0
M2s_c1e3
%endmacro
%macro M2s_b3a6 0
    mov r8, [rbp + 176]
    mov r9, [rbp + 192]
    mov rax, [rbp + 184]
    imul rax, rax, 1
    add r8, rax
    mov rax, [rbp + 200]
    imul rax, rax, 1
    add r9, rax
    xor edx, edx
.ls1:
M2s_c1da
M2s_c1e1
    vfmadd213ps ymm5, ymm4, ymm9
    vfmadd213ps ymm5, ymm4, ymm8
%endmacro
%macro M2s_b3a7 0
    vorps ymm5, ymm5, ymm0
    vmovups [rsi + rdx*4], ymm5
M2s_c1e3
    vfmadd231ps ymm0, ymm5, ymm7
    vmovups [r8 + rdx*4], ymm0
M2s_c1e6
M2s_c1e7
%endmacro
%macro M2s_b3a8 0
    mov r8, [rbp + 176]
    mov r9, [rbp + 192]
    mov rax, [rbp + 184]
    imul rax, rax, 2
%endmacro
%macro M2s_b3a9 0
M2s_b3a8
    add r8, rax
    mov rax, [rbp + 200]
    imul rax, rax, 2
    add r9, rax
%endmacro
%macro M2s_b3aa 0
    imul rax, rax, 2
    add r8, rax
    mov rax, [rbp + 200]
    imul rax, rax, 2
%endmacro
%macro M2s_b3ab 0
    mov r10, [rbp + 136]
M2s_c1e8
    xor edx, edx
.ls2:
M2s_c1db
M2s_c1de
    vpsrld ymm4, ymm1, 20
%endmacro
%macro M2s_b3ac 0
M2s_c1e8
M2s_c1ea
M2s_c1dc
%endmacro
%macro M2s_b3ad 0
M2s_c1e9
M2s_c1eb
M2s_c1dd
%endmacro
%macro M2s_b3ae 0
    vorps ymm5, ymm5, ymm0
M2s_c1e3
    vfmadd231ps ymm0, ymm5, ymm7
M2s_b3af
    vmovups [r10 + rdx*4], ymm0
    vmovups ymm0, [r15 + rdx*4]
%endmacro
%macro M2s_b3af 0
    vmovups [r8 + rdx*4], ymm0
M2s_c1ed
    vminps ymm1, ymm1, ymm2
    vmovups ymm0, [r11 + rdx*4]
    vfmadd231ps ymm0, ymm1, ymm6
%endmacro
%macro M2s_b3b0 0
M2s_c1ed
    vminps ymm1, ymm1, ymm2
    vmovups ymm0, [r11 + rdx*4]
    vfmadd231ps ymm0, ymm1, ymm6
    vmovups [r10 + rdx*4], ymm0
%endmacro
%macro M2s_b3b1 0
    vmovups [r10 + rdx*4], ymm0
    vmovups ymm0, [r15 + rdx*4]
    vfmadd231ps ymm0, ymm1, ymm7
    vmovups [r14 + rdx*4], ymm0
%endmacro
%macro M2s_b3b2 0
    vmovups ymm0, [r15 + rdx*4]
    vfmadd231ps ymm0, ymm1, ymm7
    vmovups [r14 + rdx*4], ymm0
    add rdx, 8
%endmacro
%macro M2s_b3b3 0
    vfmadd231ps ymm0, ymm1, ymm7
    vmovups [r14 + rdx*4], ymm0
    add rdx, 8
    cmp rdx, r13
%endmacro
%macro M2s_b3b4 0
    vpermps ymm4, ymm4, [c_rxe]
    vmulps ymm3, ymm3, ymm5
M2s_c1e1
M2s_c1e2
M2s_c1ec
    vmovups ymm0, [r9 + rdx*4]
    vfmadd231ps ymm0, ymm5, ymm7
%endmacro
%macro M2s_b3b5 0
M2s_c1ef
    vfmadd213ps ymm5, ymm4, ymm3
M2s_c1ec
    vmovups ymm0, [r9 + rdx*4]
    vfmadd231ps ymm0, ymm5, ymm7
    vmovups [r8 + rdx*4], ymm0
%endmacro
%macro M2s_b3b6 0
    ret
.rowz:
    mov rax, [rbp + 72]
    cmp rax, [rbp + 344]
    je .rqz
    call .fr
.rqz:
M2s_c165
M2s_c168
    cmp rcx, [rbp + 352]
    jae .zu
M2s_c169
    vmovaps [rbp + 1184], ymm0
    vbroadcastss ymm0, [rax + Rc_k + 8]
    vmovaps [rbp + 1216], ymm0
%endmacro
%macro M2s_b3b7 0
M2s_c1f0
    mov [rbp + 336], r9
    mov rcx, [rbp + 72]
M2s_c1f2
M2s_c16b
    vmovaps [rbp + 1216], ymm0
    vbroadcastss ymm0, [rax + Rc_k + 12]
%endmacro
%macro M2s_b3b8 0
M2s_c1f1
M2s_c1f3
M2s_c16a
    vbroadcastss ymm0, [rax + Rc_k + 8]
    vmovaps [rbp + 1216], ymm0
    vbroadcastss ymm0, [rax + Rc_k + 12]
    vmovaps [rbp + 1248], ymm0
%endmacro
%macro M2s_b3b9 0
    jb .zq0r
M2s_c166
M2s_c171
M2s_c17b
.zq0:
M2s_c17e
M2s_c189
    vfmadd231ps ymm0, ymm2, ymm11
    vmovaps [rdi+rdx*4], ymm0
M2s_c18a
%endmacro
%macro M2s_b3ba 0
M2s_c1f4
M2s_c18b
    vmovaps [rsi+rdx*4], ymm2
    vandps ymm0, ymm3, ymm6
M2s_c183
M2s_c184
    vpermd ymm2, ymm2, [c_c8]
    vpaddd ymm3, ymm3, ymm2
%endmacro
%macro M2s_b3bb 0
    cmp rdx, r15
    jbe .zq0
.zq0r:
    cmp rdx, r13
    jae .zq0e
M2s_c167
M2s_c178
    vmovups ymm7, [c_n64]
    vmovups ymm6, [c_absm]
    vmovups ymm5, [c_xflr]
.zq0s:
M2s_c17e
M2s_c189
    vfmadd231ps ymm0, ymm2, ymm11
    vmovaps [rdi+rdx*4], ymm0
    vfmadd213ps ymm2, ymm10, ymm4
%endmacro
%macro M2s_b3bc 0
M2s_c1f6
M2s_c17e
M2s_c189
M2s_c1f5
%endmacro
%macro M2s_b3bd 0
    add r8, 288
    add rdx, 8
    cmp rdx, r13
    jb .zq0s
%endmacro
%macro M2s_b3be 0
    vmulps ymm2, ymm2, ymm1
M2s_c18e
    add r8, 288
    add rdx, 8
    cmp rdx, r13
%endmacro
%macro M2s_b3bf 0
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .zp0r
    lea r15, [r13 - 16]
    vmovups ymm15, [c_absm]
.zp0:
M2s_c18f
M2s_c191
    vpsrld ymm13, ymm0, 14
%endmacro
%macro M2s_b3c0 0
M2s_c1f7
M2s_c190
M2s_c192
    vpermd ymm1, ymm13, [c_p8]
    vpermd ymm10, ymm9, [c_c8]
    vpsrld ymm13, ymm0, 14
    vpsubd ymm9, ymm14, ymm11
%endmacro
%macro M2s_b3c1 0
    cmp rdx, r15
    jbe .zp0
M2s_c1f8
    vmovups ymm14, [c_xflr]
    vmovups ymm13, [c_k5]
%endmacro
%macro M2s_b3c2 0
M2s_c1f8
M2s_c19c
%endmacro
%macro M2s_b3c3 0
    vpsubd ymm13, ymm8, ymm2
    vfmadd213ps ymm7, ymm13, [c_mone]
M2s_c193
M2s_c194
    cmp rdx, r15
    jbe .zp0
%endmacro
%macro M2s_b3c4 0
.zp0s:
    vmovups ymm0, [rbx+rdx*4]
M2s_c19f
M2s_c19e
    vpermd ymm5, ymm4, [c_c8]
    vpsubd ymm4, ymm1, ymm7
    vfmadd213ps ymm3, ymm4, ymm12
M2s_c1a0
    jb .zp0s
.zp0e:
.zw:
M2s_c1a1
%endmacro
%macro M2s_b3c5 0
M2s_c1f9
    mov r12, [rdi + G_sp]
    shl r12, 2
    lea rsi, [rbx + r12]
M2s_b3c6
    vpmaxud ymm3, ymm1, ymm14
    vpsrld ymm4, ymm3, 23
M2s_a2ed
    vpermps ymm9, ymm5, [c_rxe]
    vmovups ymm10, [r8]
    vmovups ymm0, [r8+32]
M2s_a2ee
    vpsubd ymm4, ymm9, ymm7
    vfmadd213ps ymm3, ymm4, ymm12
%endmacro
%macro M2s_b3c6 0
    lea r14, [rbx + r12*2]
    mov rdi, [rbp + 136]
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .zp1r
M2s_c1a2
    vmovups ymm12, [c_mone]
    vmovups ymm11, [c_q8e3]
.zp1:
    vmovups ymm0, [rsi+rdx*4]
    vandps ymm1, ymm0, ymm15
    vxorps ymm2, ymm0, ymm1
%endmacro
%macro M2s_b3c7 0
    vmovups ymm1, [rsi+rdx*4+32]
M2s_c1fa
    vfmadd213ps ymm7, ymm10, [c_q8e1]
    vandps ymm9, ymm1, ymm15
    vmovaps [r8+128], ymm6
%endmacro
%macro M2s_b3c8 0
M2s_c1fa
    vfmadd213ps ymm7, ymm10, [c_q8e1]
    vandps ymm9, ymm1, ymm15
    vmovaps [r8+128], ymm6
M2s_a2f2
%endmacro
%macro M2s_b3c9 0
M2s_a2f2
    vfmadd213ps ymm7, ymm10, [c_q8e0]
    vmovups ymm8, [r8+288]
    vpsubd ymm10, ymm5, ymm1
%endmacro
%macro M2s_b3ca 0
    vfmadd213ps ymm7, ymm10, [c_q8e0]
    vmovups ymm8, [r8+288]
    vpsubd ymm10, ymm5, ymm1
    vmovups ymm5, [r8+320]
%endmacro
%macro M2s_b3cb 0
M2s_c1fb
%endmacro
%macro M2s_b3cc 0
    vpsrld ymm1, ymm6, 14
    vpsrld ymm4, ymm6, 17
    vpermd ymm5, ymm4, [c_p8]
    vpermd ymm6, ymm1, [c_c8]
%endmacro
%macro M2s_b3cd 0
M2s_a2f3
M2s_c1fc
M2s_c1fd
M2s_a2f5
    jbe .zp1
.zp1r:
%endmacro
%macro M2s_b3ce 0
M2s_c1fc
M2s_c1fd
M2s_a2f5
    jbe .zp1
.zp1r:
    cmp rdx, r13
%endmacro
%macro M2s_b3cf 0
    cmp rdx, r13
    jae .zp1e
M2s_c19a
.zp1s:
    vmovups ymm0, [rsi+rdx*4]
%endmacro
%macro M2s_b3d0 0
M2s_c1fe
    vmovups ymm12, [c_mone]
.zp1s:
    vmovups ymm0, [rsi+rdx*4]
    vmovups ymm1, [r8]
%endmacro
%macro M2s_b3d1 0
    vandps ymm4, ymm0, ymm15
    vxorps ymm5, ymm0, ymm4
    vpmaxud ymm6, ymm4, ymm14
    vfmadd231ps ymm3, ymm1, [c_q8e3]
%endmacro
%macro M2s_b3d2 0
M2s_c1ff
%endmacro
%macro M2s_b3d3 0
M2s_c200
%endmacro
%macro M2s_b3d4 0
M2s_b3d5
    vpermd ymm7, ymm4, [c_p8]
    vpermd ymm6, ymm1, [c_c8]
    vmovaps ymm10, ymm8
    vfmadd213ps ymm10, ymm11, [c_q8e2]
%endmacro
%macro M2s_b3d5 0
    vfmadd231ps ymm0, ymm4, ymm7
    vpsrld ymm1, ymm6, 14
    vpsrld ymm4, ymm6, 17
    vfmadd213ps ymm3, ymm10, ymm12
%endmacro
%macro M2s_b3d6 0
M2s_c202
%endmacro
%macro M2s_b3d7 0
M2s_a2fb
M2s_b3d8
    vmovaps [r8+128], ymm8
    vmovaps [rbx+rdx*4], ymm2
M2s_a2fd
%endmacro
%macro M2s_b3d8 0
    vorps ymm11, ymm4, ymm5
    vmovaps [r8+96], ymm6
    vmulps ymm8, ymm11, ymm0
    vfmadd231ps ymm2, ymm7, ymm3
%endmacro
%macro M2s_b3d9 0
M2s_c203
%endmacro
%macro M2s_b3da 0
    jb .zp1s
.zp1e:
    mov rdi, [rbp + 136]
    mov rax, [rbp + 144]
    imul rax, rax, 1
    add rdi, rax
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .zp2r
M2s_c1a2
    vmovups ymm12, [c_mone]
    vmovups ymm11, [c_q8e3]
.zp2:
    vmovups ymm0, [r14+rdx*4]
M2s_c19f
M2s_c1fb
    vpermps ymm9, ymm5, [c_rxe]
    vmovups ymm10, [r8+96]
    vmovups ymm0, [r8+128]
    vpsrld ymm1, ymm6, 14
    vpsrld ymm4, ymm6, 17
    vpermd ymm5, ymm4, [c_p8]
%endmacro
%macro M2s_b3db 0
    vpsubd ymm4, ymm9, ymm7
    vfmadd213ps ymm3, ymm4, ymm12
    vmovups ymm1, [r14+rdx*4+32]
M2s_c1ff
    vorps ymm5, ymm9, ymm2
%endmacro
%macro M2s_b3dc 0
    vpslld ymm11, ymm8, 23
M2s_b3dd
    vpsrld ymm9, ymm10, 17
    vpermd ymm10, ymm9, [c_p8]
    vpermd ymm9, ymm8, [c_c8]
%endmacro
%macro M2s_b3dd 0
    vpermps ymm0, ymm9, [c_w8e]
    vpermps ymm4, ymm9, [c_rxe]
    vfmadd213ps ymm3, ymm1, [c_q8e1]
    vpsrld ymm8, ymm10, 14
%endmacro
%macro M2s_b3de 0
    vfmadd213ps ymm3, ymm1, [c_q8e1]
    vpsrld ymm8, ymm10, 14
    vpsrld ymm9, ymm10, 17
    vpermd ymm10, ymm9, [c_p8]
%endmacro
%macro M2s_b3df 0
    vpermd ymm9, ymm8, [c_c8]
    vpsubd ymm8, ymm4, ymm11
    vfmadd213ps ymm6, ymm8, ymm12
    vfmadd213ps ymm3, ymm1, [c_q8e0]
%endmacro
%macro M2s_b3e0 0
    vpsubd ymm8, ymm4, ymm11
    vfmadd213ps ymm6, ymm8, ymm12
    vfmadd213ps ymm3, ymm1, [c_q8e0]
    vpaddd ymm4, ymm10, ymm9
%endmacro
%macro M2s_b3e1 0
    vmovaps [rdi+rdx*4], ymm2
    add r8, 288
    add rdx, 8
    cmp rdx, r13
%endmacro
%macro M2s_b3e2 0
    vpermd ymm6, ymm1, [c_c8]
    vpsubd ymm4, ymm9, ymm7
    vfmadd213ps ymm3, ymm4, ymm12
    vmovups ymm1, [r14+rdx*4+32]
%endmacro
%macro M2s_b3e3 0
    vmovaps [r8+192], ymm3
    vmulps ymm6, ymm5, ymm8
    vfmadd213ps ymm7, ymm10, [c_q8e1]
    vandps ymm9, ymm1, ymm15
    vmovaps [r8+224], ymm6
M2s_c200
    vfmadd213ps ymm7, ymm10, [c_q8e0]
    vmovups ymm8, [r8+384]
    vpsubd ymm10, ymm5, ymm1
%endmacro
%macro M2s_b3e4 0
M2s_c205
M2s_c201
    vfmadd213ps ymm7, ymm10, [c_q8e0]
    vmovups ymm8, [r8+384]
    vpsubd ymm10, ymm5, ymm1
    vmovups ymm5, [r8+416]
%endmacro
%macro M2s_b3e5 0
M2s_c206
%endmacro
%macro M2s_b3e6 0
    vorps ymm5, ymm9, ymm2
M2s_c204
M2s_c206
M2s_c202
M2s_c207
    vorps ymm1, ymm4, ymm2
    vmovaps [r8+480], ymm3
    vmulps ymm0, ymm8, ymm5
%endmacro
%macro M2s_b3e7 0
M2s_c207
    vorps ymm1, ymm4, ymm2
M2s_c209
    vmovups ymm12, [c_mone]
.zp2s:
M2s_c1b8
    vandps ymm4, ymm0, ymm15
    vxorps ymm5, ymm0, ymm4
%endmacro
%macro M2s_b3e8 0
M2s_c208
M2s_c209
    vmovups ymm12, [c_mone]
M2s_b3ea
%endmacro
%macro M2s_b3e9 0
    vmulps ymm7, ymm1, ymm9
    vfmadd213ps ymm10, ymm8, [c_q8e1]
    vmovaps [r8+512], ymm7
    vfmadd213ps ymm10, ymm8, [c_q8e0]
    vfmadd231ps ymm5, ymm0, ymm10
    vmovaps [rsi+rdx*4+32], ymm5
M2s_c203
    jbe .zp2
.zp2r:
    cmp rdx, r13
    jae .zp2e
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xflr]
%endmacro
%macro M2s_b3ea 0
M2s_c20a
    vmovups ymm3, [c_q8e2]
    vandps ymm4, ymm0, ymm15
    vxorps ymm5, ymm0, ymm4
    vpmaxud ymm6, ymm4, ymm14
%endmacro
%macro M2s_b3eb 0
    vfmadd231ps ymm3, ymm1, [c_q8e3]
    vmulps ymm7, ymm1, ymm2
    vpsrld ymm8, ymm6, 23
    vpsrld ymm9, ymm6, 20
%endmacro
%macro M2s_b3ec 0
M2s_b3eb
    vpmaddwd ymm10, ymm8, ymm13
    vpslld ymm11, ymm8, 23
    vpermps ymm0, ymm9, [c_w8e]
    vpermps ymm4, ymm9, [c_rxe]
%endmacro
%macro M2s_b3ed 0
    vpaddd ymm4, ymm10, ymm9
M2s_c20b
    vmovaps [r8+224], ymm8
    vmovaps [rsi+rdx*4], ymm2
    vmovaps [rdi+rdx*4], ymm2
%endmacro
%macro M2s_b3ee 0
M2s_b3ed
    add r8, 288
    add rdx, 8
    cmp rdx, r13
M2s_b3f1
    imul rax, rax, 2
%endmacro
%macro M2s_b3ef 0
M2s_c20b
    vmovaps [r8+224], ymm8
    vmovaps [rsi+rdx*4], ymm2
    vmovaps [rdi+rdx*4], ymm2
    add r8, 288
%endmacro
%macro M2s_b3f0 0
M2s_c20c
    vmovaps [rsi+rdx*4], ymm2
    vmovaps [rdi+rdx*4], ymm2
    add r8, 288
    add rdx, 8
%endmacro
%macro M2s_b3f1 0
M2s_c20d
%endmacro
%macro M2s_b3f2 0
    add rdx, 8
    cmp rdx, r13
    jb .zp2s
.zp2e:
%endmacro
%macro M2s_b3f3 0
    cmp rdx, r13
M2s_c20d
    imul rax, rax, 2
    add rdi, rax
    mov r11, [rbp + 136]
    mov rax, [rbp + 144]
    imul rax, rax, 3
    add r11, rax
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .zp3r
M2s_c1a2
M2s_c19d
    vmovups ymm8, [c_q8e0]
    vmovups ymm7, [c_c8]
.zp3:
M2s_c1c9
    vmovups ymm4, [r8+512]
    vmovaps ymm5, ymm10
%endmacro
%macro M2s_b3f4 0
M2s_c20e
M2s_c1c6
M2s_c211
M2s_c1ca
M2s_c212
%endmacro
%macro M2s_b3f5 0
M2s_c20f
    vmovups ymm9, [c_q8e1]
M2s_c210
    vmovaps ymm5, ymm10
    vfmadd231ps ymm5, ymm0, ymm11
M2s_c212
    vfmadd231ps ymm1, ymm2, ymm5
%endmacro
%macro M2s_b3f6 0
    vmovaps ymm0, ymm10
    vfmadd231ps ymm0, ymm3, ymm11
    vmovups ymm2, [rbx+rdx*4+32]
    vmovaps [rdi+rdx*4], ymm1
    vminps ymm5, ymm1, [u_zero]
    vfmadd213ps ymm0, ymm3, ymm9
    vminps ymm1, ymm6, ymm5
    vmulps ymm6, ymm3, ymm4
    vminps ymm5, ymm2, [rsi+rdx*4+32]
    vmovaps [r11+rdx*4], ymm1
    vfmadd213ps ymm0, ymm3, ymm8
    vfmadd231ps ymm4, ymm6, ymm0
    vmovaps [rdi+rdx*4+32], ymm4
    vminps ymm2, ymm4, [u_zero]
    vminps ymm1, ymm5, ymm2
    vmovaps [r11+rdx*4+32], ymm1
%endmacro
%macro M2s_b3f7 0
    add r8, 576
M2s_c213
    cmp rdx, r13
    jae .zp3e
    vmovups ymm15, [c_absm]
%endmacro
%macro M2s_b3f8 0
M2s_c213
    cmp rdx, r13
    jae .zp3e
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xflr]
%endmacro
%macro M2s_b3f9 0
M2s_c214
    jae .zp3e
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xflr]
    vmovups ymm13, [c_k5]
%endmacro
%macro M2s_b3fa 0
    vmovups ymm6, [c_p8]
    vmovups ymm5, [c_w8e]
.zp3s:
M2s_c1d4
    vmulps ymm2, ymm0, ymm1
    vfmadd231ps ymm1, ymm2, ymm3
    vmovaps [rdi+rdx*4], ymm1
M2s_b3fb
M2s_c216
M2s_b3fc
    vmovapd ymm13, [r15 + G_dlo]
    vmovapd ymm14, [r15 + G_dhi]
%endmacro
%macro M2s_b3fb 0
M2s_c217
%endmacro
%macro M2s_b3fc 0
M2s_c218
%endmacro
%macro M2s_b3fd 0
    vmovapd ymm13, [r15 + G_dlo]
M2s_c219
%endmacro
%macro M2s_b3fe 0
M2s_c219
    vpsrlq ymm7, ymm5, 48
%endmacro
%macro M2s_b3ff 0
M2s_a30c
M2s_c21a
%endmacro
%macro M2s_b400 0
M2s_c21a
    vpcmpeqq ymm9, ymm9, ymm9
%endmacro
%macro M2s_b401 0
M2s_b402
M2s_b405
%endmacro
%macro M2s_b402 0
M2s_c21b
%endmacro
%macro M2s_b403 0
M2s_c21c
%endmacro
%macro M2s_b404 0
    vblendvpd ymm5, ymm5, ymm1, ymm4
    vpsrlq ymm7, ymm5, 48
    vpand ymm8, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
%endmacro
%macro M2s_b405 0
M2s_c21d
%endmacro
%macro M2s_b406 0
    vmovups ymm8, [c_q8e0]
    vmovups ymm7, [c_c8]
M2s_c215
    vminps ymm4, ymm2, [rsi+rdx*4]
    vfmadd213ps ymm3, ymm0, ymm9
    vfmadd213ps ymm3, ymm0, ymm8
    vmulps ymm2, ymm0, ymm1
    vfmadd231ps ymm1, ymm2, ymm3
    vmovaps [rdi+rdx*4], ymm1
%endmacro
%macro M2s_b407 0
M2s_b406
M2s_c217
M2s_c216
M2s_c218
%endmacro
%macro M2s_b408 0
M2s_c21e
M2s_c1d5
    vmulps ymm2, ymm0, ymm1
    vfmadd231ps ymm1, ymm2, ymm3
    vmovaps [rdi+rdx*4], ymm1
M2s_c217
M2s_c216
M2s_c218
    vmovapd ymm13, [r15 + G_dlo]
%endmacro
%macro M2s_b409 0
M2s_b40a
M2s_c21f
%endmacro
%macro M2s_b40a 0
M2s_c220
%endmacro
%macro M2s_b40b 0
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [rax + ymm8*8 + u_rx - u_rx], ymm9
    vandpd ymm11, ymm5, [u_mant]
M2s_c21f
    vpsrlq ymm7, ymm5, 52
%endmacro
%macro M2s_b40c 0
M2s_b40b
M2s_b412
    vpand ymm7, ymm7, [u_i7]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm8, [rax + ymm7*8 + u_ob - u_rx], ymm9
    vmulpd ymm6, ymm6, ymm8
%endmacro
%macro M2s_b40d 0
M2s_c222
M2s_c224
%endmacro
%macro M2s_b40e 0
M2s_c223
M2s_c225
%endmacro
%macro M2s_b40f 0
M2s_c21f
M2s_b411
%endmacro
%macro M2s_b410 0
    vfmsub213pd ymm11, ymm10, [u_one]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [rax + ymm8*8 + u_ow - u_rx], ymm9
M2s_b411
    vpsrlq ymm7, ymm5, 56
%endmacro
%macro M2s_b411 0
M2s_c226
%endmacro
%macro M2s_b412 0
M2s_c227
%endmacro
%macro M2s_b413 0
M2s_c228
%endmacro
%macro M2s_b414 0
M2s_b413
M2s_b417
%endmacro
%macro M2s_b415 0
M2s_c229
%endmacro
%macro M2s_b416 0
M2s_c22a
%endmacro
%macro M2s_b417 0
M2s_c22b
%endmacro
%macro M2s_b418 0
M2s_c22c
%endmacro
%macro M2s_b419 0
M2s_c22d
%endmacro
%macro M2s_b41a 0
M2s_c22e
%endmacro
%macro M2s_b41b 0
M2s_c230
M2s_b41f
%endmacro
%macro M2s_b41c 0
    vmulpd ymm6, ymm6, ymm10
M2s_c232
%endmacro
%macro M2s_b41d 0
M2s_c232
    vfmadd213pd ymm8, ymm12, ymm9
%endmacro
%macro M2s_b41e 0
    vmovapd ymm7, [u_op3]
M2s_b41f
    vfmadd213pd ymm9, ymm11, [u_op0]
    vfmadd213pd ymm8, ymm12, ymm9
    vmulpd ymm6, ymm6, ymm8
%endmacro
%macro M2s_b41f 0
    vfmadd213pd ymm7, ymm11, [u_op2]
    vmovapd ymm8, [u_op4]
    vfmadd213pd ymm8, ymm12, ymm7
    vmovapd ymm9, [u_op1]
%endmacro
%macro M2s_b420 0
    vmovapd ymm8, [u_op4]
    vfmadd213pd ymm8, ymm12, ymm7
    vmovapd ymm9, [u_op1]
    vfmadd213pd ymm9, ymm11, [u_op0]
%endmacro
%macro M2s_b421 0
    vfmadd213pd ymm8, ymm12, ymm7
    vmovapd ymm9, [u_op1]
    vfmadd213pd ymm9, ymm11, [u_op0]
    vfmadd213pd ymm8, ymm12, ymm9
%endmacro
%macro M2s_b422 0
    vmovapd ymm9, [u_op1]
    vfmadd213pd ymm9, ymm11, [u_op0]
    vfmadd213pd ymm8, ymm12, ymm9
    vmulpd ymm6, ymm6, ymm8
%endmacro
%macro M2s_b423 0
    vgatherqpd ymm6, [rax + ymm7*8 + u_oa - u_rx], ymm9
    vpsrlq ymm7, ymm5, 56
    vpand ymm7, ymm7, [u_i7]
M2s_a318
%endmacro
%macro M2s_b424 0
    vpsrlq ymm7, ymm5, 56
    vpand ymm7, ymm7, [u_i7]
M2s_a318
    vfmadd213pd ymm8, ymm7, [u_omg]
%endmacro
%macro M2s_b425 0
    vpand ymm7, ymm7, [u_i7]
M2s_a318
    vfmadd213pd ymm8, ymm7, [u_omg]
    vmovapd ymm9, ymm6
%endmacro
%macro M2s_b426 0
M2s_a318
    vfmadd213pd ymm8, ymm7, [u_omg]
    vmovapd ymm9, ymm6
    vfnmadd231pd ymm9, ymm8, ymm6
%endmacro
%macro M2s_b427 0
    vfmadd213pd ymm8, ymm7, [u_omg]
    vmovapd ymm9, ymm6
    vfnmadd231pd ymm9, ymm8, ymm6
    vandpd ymm9, ymm9, ymm4
%endmacro
%macro M2s_b428 0
    vmovapd ymm9, ymm6
    vfnmadd231pd ymm9, ymm8, ymm6
    vandpd ymm9, ymm9, ymm4
    vfmadd213pd ymm8, ymm6, ymm6
%endmacro
%macro M2s_b429 0
M2s_a326
    vblendvpd ymm9, ymm9, ymm10, ymm0
M2s_c234
M2s_c21b
    vpsrlq ymm7, ymm5, 48
    vpand ymm8, ymm7, [u_i15]
%endmacro
%macro M2s_b42a 0
M2s_c234
M2s_c21b
M2s_c21d
%endmacro
%macro M2s_b42b 0
M2s_c235
M2s_c21c
M2s_c220
%endmacro
%macro M2s_b42c 0
    vfnmadd231pd ymm9, ymm8, ymm6
    vandpd ymm9, ymm9, ymm4
    vfmadd213pd ymm8, ymm6, ymm6
    vxorpd ymm10, ymm8, [u_mzero]
%endmacro
%macro M2s_b42d 0
    vandpd ymm9, ymm9, ymm4
    vfmadd213pd ymm8, ymm6, ymm6
    vxorpd ymm10, ymm8, [u_mzero]
    vcmppd ymm11, ymm3, [u_zero], 0x1a
%endmacro
%macro M2s_b42e 0
    vmulpd ymm6, ymm6, ymm8
    vdivpd ymm7, ymm2, ymm3
    vandpd ymm7, ymm7, ymm4
    vmovapd ymm8, [u_eq0]
%endmacro
%macro M2s_b42f 0
    vdivpd ymm7, ymm2, ymm3
    vandpd ymm7, ymm7, ymm4
    vmovapd ymm8, [u_eq0]
    vfmadd213pd ymm8, ymm7, [u_omg]
%endmacro
%macro M2s_b430 0
    vfmadd213pd ymm9, ymm11, [u_op0]
    vfmadd213pd ymm8, ymm12, ymm9
    vmulpd ymm6, ymm6, ymm8
    vdivpd ymm7, ymm2, ymm3
%endmacro
%macro M2s_b431 0
M2s_b430
    vandpd ymm7, ymm7, ymm4
    vmovapd ymm8, [u_eq0]
    vfmadd213pd ymm8, ymm7, [u_omg]
    vmovapd ymm9, ymm6
%endmacro
%macro M2s_b432 0
    vfmadd213pd ymm8, ymm12, ymm9
    vmulpd ymm6, ymm6, ymm8
    vdivpd ymm7, ymm2, ymm3
    vandpd ymm7, ymm7, ymm4
%endmacro
%macro M2s_b433 0
    vmulpd ymm6, ymm6, ymm8
M2s_a31e
M2s_c233
M2s_c221
M2s_c227
    vpand ymm7, ymm7, [u_i7]
    vpcmpeqq ymm9, ymm9, ymm9
%endmacro
%macro M2s_b434 0
M2s_c236
M2s_c220
M2s_c21f
M2s_c226
M2s_c22a
%endmacro
%macro M2s_b435 0
    vmovapd ymm8, [u_eq0]
    vfmadd213pd ymm8, ymm7, [u_omg]
    vmovapd ymm9, ymm6
    vfnmadd231pd ymm9, ymm8, ymm6
%endmacro
%macro M2s_b436 0
    vfnmadd231pd ymm9, ymm8, ymm6
    vandpd ymm9, ymm9, ymm4
M2s_a325
    vxorpd ymm11, ymm9, [u_mzero]
%endmacro
%macro M2s_b437 0
    vfmadd213pd ymm8, ymm6, ymm6
    vxorpd ymm10, ymm8, [u_mzero]
    vcmppd ymm11, ymm3, [u_zero], 0x1a
    vblendvpd ymm9, ymm9, ymm10, ymm11
%endmacro
%macro M2s_b438 0
    vxorpd ymm10, ymm8, [u_mzero]
    vcmppd ymm11, ymm3, [u_zero], 0x1a
    vblendvpd ymm9, ymm9, ymm10, ymm11
    vxorpd ymm11, ymm9, [u_mzero]
%endmacro
%macro M2s_b439 0
    vcmppd ymm11, ymm3, [u_zero], 0x1a
    vblendvpd ymm9, ymm9, ymm10, ymm11
    vxorpd ymm11, ymm9, [u_mzero]
    vblendvpd ymm9, ymm9, ymm10, ymm0
%endmacro
%macro M2s_b43a 0
    vblendvpd ymm9, ymm9, ymm10, ymm11
    vxorpd ymm11, ymm9, [u_mzero]
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
%endmacro
%macro M2s_b43b 0
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vfmadd231pd ymm13, ymm9, [r15 + G_dmx + 32]
    vfmadd231pd ymm14, ymm8, [r15 + G_dmx + 32]
    vcvtps2pd ymm0, [rdi + 131072]
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_drg + 64]
M2s_c21b
M2s_c21d
M2s_c223
M2s_c225
M2s_c229
    vgatherqpd ymm8, [rax + ymm7*8 + u_ob - u_rx], ymm9
    vmulpd ymm6, ymm6, ymm8
    vmulpd ymm6, ymm6, ymm10
%endmacro
%macro M2s_b43c 0
M2s_c237
M2s_c223
M2s_c225
M2s_c229
M2s_c22f
%endmacro
%macro M2s_b43d 0
M2s_c238
M2s_c21f
M2s_c226
M2s_c22a
M2s_c230
%endmacro
%macro M2s_b43e 0
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vfmadd231pd ymm13, ymm9, [r15 + G_dmx + 64]
    vfmadd231pd ymm14, ymm8, [r15 + G_dmx + 64]
%endmacro
%macro M2s_b43f 0
M2s_a32c
    vminpd ymm13, ymm13, [u_1023]
    vmovapd ymm1, [u_mone]
    vblendvpd ymm1, ymm1, ymm13, ymm0
%endmacro
%macro M2s_b440 0
M2s_c239
%endmacro
%macro M2s_b441 0
    vcvtpd2dq xmm4, ymm1
    ret
.t1c:
    vcvtps2pd ymm0, [rdi + 49152]
M2s_c22c
    vdivpd ymm2, ymm3, ymm2
    vmovapd ymm15, [r15 + G_esn]
    vfmadd213pd ymm15, ymm2, [r15 + G_ean]
    vfmadd213pd ymm15, ymm1, [r15 + G_eta]
M2s_c22d
    vfmadd231pd ymm2, ymm1, [r15 + G_erg + 0]
M2s_c21b
M2s_c21d
M2s_c223
    vgatherqpd ymm10, [rax + ymm8*8 + u_ow - u_rx], ymm9
    vpsrlq ymm7, ymm5, 52
    vpand ymm7, ymm7, [u_i15]
%endmacro
%macro M2s_b442 0
M2s_c23a
M2s_c21b
M2s_c21d
M2s_c223
M2s_c225
%endmacro
%macro M2s_b443 0
M2s_c23b
M2s_c21c
M2s_c220
M2s_c21f
M2s_c226
%endmacro
%macro M2s_b444 0
    vmovapd [r12 + 736], ymm8
    vcvtps2pd ymm0, [rdi + 16384]
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_erg + 32]
M2s_c21b
M2s_c21d
M2s_c223
M2s_c225
M2s_c229
M2s_c22f
    vmovapd ymm7, [u_op3]
    vfmadd213pd ymm7, ymm11, [u_op2]
%endmacro
%macro M2s_b445 0
M2s_c23c
M2s_c224
M2s_c228
M2s_c22b
M2s_c231
%endmacro
%macro M2s_b446 0
M2s_c23d
M2s_c225
M2s_c229
M2s_c22e
%endmacro
%macro M2s_b447 0
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
M2s_c23e
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
%endmacro
%macro M2s_b448 0
M2s_c23e
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_erg + 64]
    vsubpd ymm3, ymm1, ymm2
%endmacro
%macro M2s_b449 0
    vfmadd231pd ymm2, ymm1, [r15 + G_erg + 64]
    vsubpd ymm3, ymm1, ymm2
    vcmppd ymm4, ymm3, ymm2, 0x1e
    vaddpd ymm5, ymm1, ymm2
%endmacro
%macro M2s_b44a 0
    vblendvpd ymm8, ymm8, ymm11, ymm0
M2s_c23f
M2s_c239
M2s_c240
    vfnmadd231pd ymm13, ymm2, [r15 + G_emx + 128]
    vmovapd ymm2, [r12 + 704]
    vfmadd231pd ymm13, ymm2, [r15 + G_emx + 96]
%endmacro
%macro M2s_b44b 0
M2s_c23f
M2s_c239
M2s_c240
    vfnmadd231pd ymm13, ymm2, [r15 + G_emx + 128]
    vmovapd ymm2, [r12 + 704]
    vfmadd231pd ymm13, ymm2, [r15 + G_emx + 96]
    vmovapd ymm14, [r15 + G_ehi + 32]
%endmacro
%macro M2s_b44c 0
    vmovapd ymm14, [r15 + G_ehi + 32]
    vmovapd ymm2, [r12 + 832]
    vfnmadd231pd ymm14, ymm2, [r15 + G_emx + 160]
    vmovapd ymm2, [r12 + 768]
    vfnmadd231pd ymm14, ymm2, [r15 + G_emx + 128]
    vmovapd ymm2, [r12 + 736]
    vfmadd231pd ymm14, ymm2, [r15 + G_emx + 96]
M2s_c239
M2s_c242
    vpcmpeqd xmm3, xmm3, xmm3
%endmacro
%macro M2s_b44d 0
M2s_c241
    vcmppd ymm0, ymm13, ymm14, 0
    vmaxpd ymm13, ymm13, [u_zero]
M2s_c242
    vpcmpeqd xmm3, xmm3, xmm3
    vpcmpeqd xmm3, xmm3, xmm5
%endmacro
%macro M2s_b44e 0
    vpcmpeqd xmm3, xmm3, xmm5
M2s_c243
    test eax, eax
    jns .fzs
    call .t3
%endmacro
%macro M2s_b44f 0
M2s_c243
    test eax, eax
    jns .fzs
    call .t3
.fzs:
%endmacro
%macro M2s_b450 0
.fzs:
    mov rdi, [rbp + 8]
    mov rcx, [r12 + 1224]
    mov rdx, [r12 + 1232]
%endmacro
%macro M2s_b451 0
    mov rdi, [rbp + 8]
    mov rcx, [r12 + 1224]
    mov rdx, [r12 + 1232]
    cmp qword [r12 + 1216], 0
%endmacro
%macro M2s_b452 0
    mov rsi, [rdi + G_dy]
M2s_c244
M2s_c245
M2s_c246
    xor r13d, r13d
    mov ebx, 1
.t2d:
%endmacro
%macro M2s_b453 0
M2s_c244
M2s_c245
M2s_c246
    xor r13d, r13d
    mov ebx, 1
.t2d:
    lea r14, [rax*4 + 3]
%endmacro
%macro M2s_b454 0
    lea r14, [rax*4 + 3]
M2s_c247
M2s_a340
    xor edx, edx
    div r11
%endmacro
%macro M2s_b455 0
M2s_c247
M2s_a340
    xor edx, edx
    div r11
    mov [r12 + 1296], rax
%endmacro
%macro M2s_b456 0
    mov rdi, [rbp + 8]
    mov r8, [rdi + G_wi]
    mov r9, [rdi + G_wo]
    add r9, r9
%endmacro
%macro M2s_b457 0
M2s_c248
%endmacro
%macro M2s_b458 0
    lea r13, [rax + rax]
    lea r14, [r13 + 2]
    mov r15, rdx
    lea rsi, [rdx + 1]
%endmacro
%macro M2s_b459 0
M2s_c249
%endmacro
%macro M2s_b45a 0
M2s_c24b
%endmacro
%macro M2s_b45b 0
M2s_c24c
%endmacro
%macro M2s_b45c 0
    imul rcx, r11
M2s_c24d
.t2j:
    mov rax, r14
    imul rax, r9
%endmacro
%macro M2s_b45d 0
M2s_c24d
.t2j:
    mov rax, r14
    imul rax, r9
    cmp rax, [r12 + 1248]
%endmacro
%macro M2s_b45e 0
    cmp rax, [r12 + 1248]
    jae .t2n
M2s_a34a
    sub rdx, rcx
%endmacro
%macro M2s_b45f 0
    jae .t2n
M2s_a34a
    sub rdx, rcx
    cmp qword [r12 + 1272], 0
%endmacro
%macro M2s_b460 0
M2s_c24e
M2s_c24f
    vmovups xmm15, [rbx + Rc_k]
    vmovups [r12 + 1312], xmm15
    mov rsi, [rdi + G_cr]
    mov ecx, [rbx + Rc_co + 0]
%endmacro
%macro M2s_b461 0
    mov ecx, [rbx + Rc_co + 0]
M2s_c250
    mov [r12 + 1352], rcx
    mov ecx, [rbx + Rc_co + 8]
    lea rcx, [rsi + rcx*4]
%endmacro
%macro M2s_b462 0
M2s_b461
    mov [r12 + 1360], rcx
    mov ecx, [rbx + Rc_co + 12]
M2s_b464
    add rcx, rcx
    add rcx, [rdi + G_sy]
%endmacro
%macro M2s_b463 0
M2s_c250
    mov [r12 + 1352], rcx
    mov ecx, [rbx + Rc_co + 8]
    lea rcx, [rsi + rcx*4]
    mov [r12 + 1360], rcx
%endmacro
%macro M2s_b464 0
    lea rcx, [rsi + rcx*4]
    mov [r12 + 1368], rcx
    mov rcx, rax
    imul rcx, [rdi + G_ys]
%endmacro
%macro M2s_b465 0
    mov [r12 + 1368], rcx
    mov rcx, rax
    imul rcx, [rdi + G_ys]
    add rcx, rcx
%endmacro
%macro M2s_b466 0
M2s_c251
%endmacro
%macro M2s_b467 0
M2s_c252
%endmacro
%macro M2s_b468 0
M2s_a34d
M2s_c253
M2s_c254
    jmp .t2j
.t2n:
    inc qword [r12 + 1296]
%endmacro
%macro M2s_b469 0
M2s_c253
M2s_c254
    jmp .t2j
.t2n:
    inc qword [r12 + 1296]
    jmp .t2y
%endmacro
%macro M2s_b46a 0
    imul rdx, [r12 + 1304]
M2s_b46b
M2s_b46f
M2s_b473
    mov rcx, [r12 + 1344]
    vmulss xmm0, xmm15, [rcx + rax + 32]
    vshufps xmm1, xmm15, xmm15, 85
%endmacro
%macro M2s_b46b 0
M2s_c255
M2s_c256
M2s_c259
%endmacro
%macro M2s_b46c 0
M2s_c256
M2s_c259
M2s_c25a
%endmacro
%macro M2s_b46d 0
M2s_c257
    lea rax, [rax + rcx*4]
    vmovups xmm15, [r12 + 1312]
    mov rcx, [r12 + 1344]
M2s_c25a
    vshufps xmm1, xmm15, xmm15, 170
%endmacro
%macro M2s_b46e 0
M2s_c258
M2s_c25b
    mov rcx, [r12 + 1352]
    vfmadd231ss xmm0, xmm1, [rcx + rax + 0]
    vshufps xmm1, xmm15, xmm15, 170
    mov rcx, [r12 + 1360]
%endmacro
%macro M2s_b46f 0
M2s_c25a
M2s_c25c
%endmacro
%macro M2s_b470 0
M2s_c25c
M2s_b473
%endmacro
%macro M2s_b471 0
    mov rcx, [r12 + 1360]
M2s_c25d
%endmacro
%macro M2s_b472 0
M2s_c25d
    vmulss xmm0, xmm15, [rcx + rax + 32]
%endmacro
%macro M2s_b473 0
    mov rcx, [r12 + 1368]
    vfmadd231ss xmm0, xmm1, [rcx + rax + 0]
    vcvtss2sd xmm0, xmm0, xmm0
    vmovsd [r12 + 416 + rsi*8], xmm0
%endmacro
%macro M2s_b474 0
    mov rcx, [r12 + 1352]
    vfmadd231ss xmm0, xmm1, [rcx + rax + 32]
    vshufps xmm1, xmm15, xmm15, 170
    mov rcx, [r12 + 1360]
%endmacro
%macro M2s_b475 0
    vshufps xmm1, xmm15, xmm15, 255
M2s_a353
    inc rsi
    mov [r12 + 1288], rsi
%endmacro
%macro M2s_b476 0
M2s_c25e
%endmacro
%macro M2s_b477 0
    jz .t2e
M2s_c25f
M2s_c260
M2s_c261
    vandpd xmm3, xmm2, [u_absm]
    vxorpd xmm3, xmm3, [u_mzero]
    vmovsd xmm4, [r12 + 520]
%endmacro
%macro M2s_b478 0
M2s_c25f
M2s_c260
M2s_c261
    vandpd xmm3, xmm2, [u_absm]
    vxorpd xmm3, xmm3, [u_mzero]
    vmovsd xmm4, [r12 + 520]
    vfmadd132sd xmm4, xmm3, xmm9
%endmacro
%macro M2s_b479 0
    vfmadd132sd xmm4, xmm3, xmm9
M2s_c262
M2s_c263
    vmovsd [r12 + 624], xmm4
    vmovapd ymm0, [r12 + 576]
    vmovapd ymm15, [r12 + 608]
%endmacro
%macro M2s_b47a 0
M2s_c262
M2s_c263
    vmovsd [r12 + 624], xmm4
    vmovapd ymm0, [r12 + 576]
    vmovapd ymm15, [r12 + 608]
    lea rax, [u_rx]
%endmacro
%macro M2s_b47b 0
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [u_rg2]
M2s_c21b
%endmacro
%macro M2s_b47c 0
M2s_c264
M2s_c21c
%endmacro
%macro M2s_b47d 0
M2s_c265
%endmacro
%macro M2s_b47e 0
    vblendvpd ymm8, ymm8, ymm11, ymm0
M2s_c266
M2s_c267
M2s_c268
    vmovsd xmm1, [u_emc5]
    vfnmadd231sd xmm2, xmm1, [r12 + 640 + 8]
    vmovsd xmm1, [u_emc4]
%endmacro
%macro M2s_b47f 0
M2s_c266
M2s_c267
M2s_c268
    vmovsd xmm1, [u_emc5]
    vfnmadd231sd xmm2, xmm1, [r12 + 640 + 8]
    vmovsd xmm1, [u_emc4]
    vfnmadd231sd xmm2, xmm1, [r12 + 640]
%endmacro
%macro M2s_b480 0
    vfnmadd231sd xmm2, xmm1, [r12 + 640]
M2s_b481
M2s_b483
    cmovg edx, esi
    mov esi, -1
    cmp rax, rcx
%endmacro
%macro M2s_b481 0
    vmovsd xmm1, [u_emc3]
    vfmadd231sd xmm2, xmm1, [r12 + 672 + 16]
M2s_c269
    vcvttsd2si edx, xmm0
    xor esi, esi
%endmacro
%macro M2s_b482 0
M2s_c269
M2s_c26b
%endmacro
%macro M2s_b483 0
M2s_c26c
%endmacro
%macro M2s_b484 0
M2s_c26d
%endmacro
%macro M2s_b485 0
    mov r8d, eax
    vmovsd xmm0, [u_clo]
    vmovsd xmm1, [u_emc8]
    vfnmadd231sd xmm0, xmm1, [r12 + 672 + 16]
    vmovsd xmm1, [u_emc7]
    vfnmadd231sd xmm0, xmm1, [r12 + 672 + 8]
    vmovsd xmm1, [u_emc6]
    vfmadd231sd xmm0, xmm1, [r12 + 640]
    vmovsd xmm2, [u_chi]
    vmovsd xmm1, [u_emc8]
    vfnmadd231sd xmm2, xmm1, [r12 + 640 + 16]
    vmovsd xmm1, [u_emc7]
    vfnmadd231sd xmm2, xmm1, [r12 + 640 + 8]
    vmovsd xmm1, [u_emc6]
    vfmadd231sd xmm2, xmm1, [r12 + 672]
M2s_c269
M2s_c26b
M2s_c26d
M2s_c26f
    or ecx, r8d
%endmacro
%macro M2s_b486 0
    or ecx, r8d
M2s_c270
M2s_c271
    vfmadd231pd ymm3, ymm0, [u_lzm0]
    vmovapd ymm4, ymm3
    vfmadd231pd ymm4, ymm2, [u_lzm1]
%endmacro
%macro M2s_b487 0
M2s_c270
M2s_c271
    vfmadd231pd ymm3, ymm0, [u_lzm0]
    vmovapd ymm4, ymm3
    vfmadd231pd ymm4, ymm2, [u_lzm1]
    vmovapd ymm5, ymm3
%endmacro
%macro M2s_b488 0
    vmovapd ymm5, ymm3
M2s_c272
    vandpd ymm6, ymm4, [u_absm]
    vmaxpd ymm6, ymm6, [u_xflr]
    vpsrlq ymm7, ymm6, 52
%endmacro
%macro M2s_b489 0
M2s_c272
    vandpd ymm6, ymm4, [u_absm]
    vmaxpd ymm6, ymm6, [u_xflr]
    vpsrlq ymm7, ymm6, 52
    vpsrlq ymm8, ymm6, 48
%endmacro
%macro M2s_b48a 0
    vmaxpd ymm6, ymm6, [u_xflr]
    vpsrlq ymm7, ymm6, 52
M2s_b48b
    vgatherqpd ymm10, [rax + ymm9*8 + u_tsl - u_rx], ymm11
    vpand ymm9, ymm7, [u_i16]
%endmacro
%macro M2s_b48b 0
M2s_c273
%endmacro
%macro M2s_b48c 0
M2s_c274
%endmacro
%macro M2s_b48d 0
    vpxor ymm11, ymm11, ymm11
M2s_b48e
    vgatherqpd ymm11, [rax + ymm8*8 + u_wsx - u_rx], ymm9
    vmulpd ymm10, ymm10, ymm11
    vpcmpeqq ymm9, ymm9, ymm9
%endmacro
%macro M2s_b48e 0
M2s_c275
%endmacro
%macro M2s_b48f 0
    vmulpd ymm11, ymm10, [u_tsk]
    vblendvpd ymm10, ymm10, ymm11, ymm9
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [rax + ymm8*8 + u_wsx - u_rx], ymm9
%endmacro
%macro M2s_b490 0
    vblendvpd ymm10, ymm10, ymm11, ymm9
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [rax + ymm8*8 + u_wsx - u_rx], ymm9
    vmulpd ymm10, ymm10, ymm11
%endmacro
%macro M2s_b491 0
    vmulpd ymm10, ymm10, ymm11
    vpcmpeqq ymm9, ymm9, ymm9
M2s_a366
    vmulpd ymm12, ymm10, ymm9
    vmulpd ymm12, ymm12, ymm13
    vandpd ymm14, ymm4, [u_mzero]
M2s_a367
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r12 + 512]
    vmovsd [r12 + 512], xmm12
M2s_a368
    vaddsd xmm14, xmm14, [r12 + 544]
    vmovsd [r12 + 544], xmm14
    vandpd ymm6, ymm5, [u_absm]
    vmaxpd ymm6, ymm6, [u_xflr]
    vpsrlq ymm7, ymm6, 52
M2s_c273
    vgatherqpd ymm10, [rax + ymm9*8 + u_tsl - u_rx], ymm11
    vpand ymm9, ymm7, [u_i16]
    vpxor ymm11, ymm11, ymm11
M2s_c275
M2s_c279
    vandpd ymm7, ymm6, [u_mant]
%endmacro
%macro M2s_b492 0
M2s_c276
M2s_c274
M2s_c278
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [rax + ymm8*8 + u_rx - u_rx], ymm9
    vandpd ymm7, ymm6, [u_mant]
    vorpd ymm7, ymm7, [u_oneb]
%endmacro
%macro M2s_b493 0
M2s_c27a
%endmacro
%macro M2s_b494 0
M2s_c27c
M2s_c27e
%endmacro
%macro M2s_b495 0
M2s_c27d
    vfmadd213pd ymm9, ymm7, [u_psx0]
    vmulpd ymm12, ymm10, ymm9
    vmulpd ymm12, ymm12, ymm13
    vandpd ymm14, ymm5, [u_mzero]
%endmacro
%macro M2s_b496 0
    vandpd ymm14, ymm5, [u_mzero]
    vorpd ymm14, ymm14, ymm12
    vextractf128 xmm11, ymm12, 1
    vhaddpd xmm12, xmm12, xmm11
%endmacro
%macro M2s_b497 0
M2s_c27f
%endmacro
%macro M2s_b498 0
M2s_c280
%endmacro
%macro M2s_b499 0
    vmovsd [r12 + 520], xmm12
M2s_c280
    vaddsd xmm14, xmm14, [r12 + 552]
    vmovsd [r12 + 552], xmm14
    vandpd ymm6, ymm3, [u_absm]
M2s_c277
M2s_c27a
%endmacro
%macro M2s_b49a 0
M2s_c281
M2s_c279
M2s_c27b
    vfmadd213pd ymm9, ymm7, [u_psx2]
M2s_c27e
    vandpd ymm14, ymm3, [u_mzero]
    vorpd ymm14, ymm14, ymm12
    vextractf128 xmm11, ymm12, 1
%endmacro
%macro M2s_b49b 0
    vmulpd ymm12, ymm10, ymm9
    vmulpd ymm12, ymm12, ymm13
    vandpd ymm14, ymm3, [u_mzero]
M2s_c27f
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r12 + 528]
    vmovsd [r12 + 528], xmm12
M2s_c280
    vaddsd xmm14, xmm14, [r12 + 560]
    vmovsd [r12 + 560], xmm14
%endmacro
%macro M2s_b49c 0
M2s_c282
    vmovsd [r12 + 560], xmm14
M2s_c283
    vmovapd [r12 + 1120], ymm0
    mov rdi, [rbp + 8]
    mov r8, [rdi + G_wi]
%endmacro
%macro M2s_b49d 0
M2s_c283
    vmovapd [r12 + 1120], ymm0
    mov rdi, [rbp + 8]
    mov r8, [rdi + G_wi]
    mov r9, [rdi + G_wo]
%endmacro
%macro M2s_b49e 0
    add r9, r9
M2s_c248
    mov rax, [r12 + 1232]
    xor ebx, ebx
    test rcx, rcx
%endmacro
%macro M2s_b49f 0
    jnz .t3c
    lea r13, [rax + rax]
    lea r14, [r13 + 2]
    mov r15, rdx
%endmacro
%macro M2s_b4a0 0
    lea rsi, [rdx + 1]
    jmp .t3g
.t3c:
    lea r13, [rax*4 - 1]
    test rax, rax
    jnz .t3d
    xor r13d, r13d
    mov ebx, 1
.t3d:
    lea r14, [rax*4 + 3]
    lea r15, [rdx + rdx]
    lea rsi, [r15 + 2]
.t3g:
M2s_c249
M2s_c24b
M2s_c285
    mov rax, [r12 + 1296]
    mov rcx, rax
    imul rcx, r11
%endmacro
%macro M2s_b4a1 0
M2s_c284
M2s_c24a
M2s_c24b
M2s_c285
M2s_c24c
%endmacro
%macro M2s_b4a2 0
    jae .t3f
M2s_c24e
M2s_c24f
    vmovups xmm15, [rbx + Rc_k]
    vmovups [r12 + 1312], xmm15
    mov rsi, [rdi + G_cr]
%endmacro
%macro M2s_b4a3 0
.t3j:
    mov rax, r14
    imul rax, r9
    cmp rax, [r12 + 1248]
    jae .t3n
M2s_c251
    sub rdx, rcx
    cmp qword [r12 + 1272], 0
    je .t3w
M2s_c252
.t3w:
    imul rdx, [r12 + 1304]
M2s_c255
    mov rcx, [r12 + 1328]
    movzx eax, word [rcx + r14*2]
%endmacro
%macro M2s_b4a4 0
    cmp rsi, 4
    jb .t3x
    push r14
    call .t3b
M2s_c25e
    mov r9, [rdi + G_wo]
    add r9, r9
    mov r11, [rdi + G_ho]
.t3x:
    inc r14
    jmp .t3j
.t3n:
    inc qword [r12 + 1296]
    jmp .t3y
.t3f:
    mov rsi, [r12 + 1288]
    test rsi, rsi
    jz .t3e
    vxorpd xmm0, xmm0, xmm0
.t3z:
M2s_c265
M2s_c28d
.t3e:
%endmacro
%macro M2s_b4a5 0
M2s_c28a
M2s_c28c
    vmovsd [r12 + 448 + rsi*8], xmm0
    vmovsd [r12 + 480 + rsi*8], xmm0
M2s_c28d
.t3e:
    mov rdi, [rbp + 8]
%endmacro
%macro M2s_b4a6 0
.t3e:
M2s_c28f
M2s_c291
    vmulpd ymm4, ymm0, ymm2
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm0, ymm2
%endmacro
%macro M2s_b4a7 0
M2s_c28f
M2s_c291
    vmulpd ymm4, ymm0, ymm2
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm0, ymm2
    vmulpd ymm6, ymm1, ymm2
%endmacro
%macro M2s_b4a8 0
M2s_c290
M2s_c292
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm0, ymm2
    vmulpd ymm6, ymm1, ymm2
    vfmadd231pd ymm6, ymm0, ymm3
%endmacro
%macro M2s_b4a9 0
M2s_a372
M2s_c293
%endmacro
%macro M2s_b4aa 0
M2s_c293
    vmovsd xmm0, [r12 + 1152]
%endmacro
%macro M2s_b4ab 0
    vmovapd [r12 + 1152], ymm14
    vmovapd [r12 + 1184], ymm15
    cmp qword [r12 + 1216], 0
    jne .t3h
%endmacro
%macro M2s_b4ac 0
M2s_c294
%endmacro
%macro M2s_b4ad 0
M2s_c295
%endmacro
%macro M2s_b4ae 0
M2s_c296
M2s_c299
    vsubsd xmm11, xmm9, xmm11
    vmovsd xmm7, [u_kg]
    vmovsd xmm6, [u_kg + 8]
M2s_b4b0
    vsubsd xmm9, xmm7, xmm11
%endmacro
%macro M2s_b4af 0
M2s_c298
    vsubsd xmm14, xmm7, xmm9
%endmacro
%macro M2s_b4b0 0
M2s_c29b
%endmacro
%macro M2s_b4b1 0
M2s_c29c
M2s_c29e
    vsubsd xmm7, xmm12, xmm7
    vaddsd xmm8, xmm8, xmm7
    vaddsd xmm7, xmm11, xmm13
    vsubsd xmm9, xmm7, xmm11
%endmacro
%macro M2s_b4b2 0
M2s_c29d
M2s_c29f
    vaddsd xmm8, xmm8, xmm7
    vaddsd xmm7, xmm11, xmm13
    vsubsd xmm9, xmm7, xmm11
    vsubsd xmm14, xmm7, xmm9
%endmacro
%macro M2s_b4b3 0
    vsubsd xmm9, xmm7, xmm11
M2s_c2a0
    vaddsd xmm9, xmm8, xmm7
    vaddsd xmm7, xmm6, xmm9
    vsubsd xmm8, xmm7, xmm6
%endmacro
%macro M2s_b4b4 0
M2s_c2a0
    vaddsd xmm9, xmm8, xmm7
    vaddsd xmm7, xmm6, xmm9
    vsubsd xmm8, xmm7, xmm6
    vsubsd xmm8, xmm9, xmm8
%endmacro
%macro M2s_b4b5 0
M2s_c2a1
    vaddsd xmm7, xmm6, xmm9
    vsubsd xmm8, xmm7, xmm6
    vsubsd xmm8, xmm9, xmm8
    vaddsd xmm9, xmm8, xmm14
%endmacro
%macro M2s_b4b6 0
    vsubsd xmm8, xmm9, xmm8
    vaddsd xmm9, xmm8, xmm14
    vaddsd xmm14, xmm7, xmm9
    vsubsd xmm8, xmm14, xmm7
%endmacro
%macro M2s_b4b7 0
    vaddsd xmm9, xmm8, xmm14
    vaddsd xmm14, xmm7, xmm9
    vsubsd xmm8, xmm14, xmm7
    vsubsd xmm8, xmm9, xmm8
%endmacro
%macro M2s_b4b8 0
    vaddsd xmm14, xmm7, xmm9
    vsubsd xmm8, xmm14, xmm7
    vsubsd xmm8, xmm9, xmm8
M2s_a379
%endmacro
%macro M2s_b4b9 0
    vmovsd xmm3, [r12 + 1192]
M2s_c296
M2s_c299
    vsubsd xmm11, xmm9, xmm11
    vmovsd xmm7, [u_kg]
    vmovsd xmm6, [u_kg + 8]
M2s_c29b
%endmacro
%macro M2s_b4ba 0
M2s_a379
    vaddsd xmm10, xmm10, xmm13
    vaddsd xmm13, xmm8, xmm7
    vsubsd xmm11, xmm13, xmm8
%endmacro
%macro M2s_b4bb 0
    vaddsd xmm10, xmm10, xmm13
    vaddsd xmm13, xmm8, xmm7
    vsubsd xmm11, xmm13, xmm8
    vsubsd xmm6, xmm13, xmm11
%endmacro
%macro M2s_b4bc 0
    vaddsd xmm13, xmm8, xmm7
    vsubsd xmm11, xmm13, xmm8
    vsubsd xmm6, xmm13, xmm11
    vsubsd xmm6, xmm8, xmm6
%endmacro
%macro M2s_b4bd 0
M2s_c2a4
%endmacro
%macro M2s_b4be 0
    vmovsd xmm12, [u_kb + 8]
M2s_c2a5
    vfmadd231sd xmm9, xmm13, xmm5
    vaddsd xmm10, xmm10, xmm9
    vaddsd xmm9, xmm11, xmm10
%endmacro
%macro M2s_b4bf 0
M2s_c2a5
    vfmadd231sd xmm9, xmm13, xmm5
    vaddsd xmm10, xmm10, xmm9
    vaddsd xmm9, xmm11, xmm10
    vsubsd xmm7, xmm9, xmm11
%endmacro
%macro M2s_b4c0 0
    vsubsd xmm7, xmm9, xmm11
    vsubsd xmm7, xmm10, xmm7
    vaddsd xmm12, xmm14, xmm9
    vsubsd xmm13, xmm12, xmm14
%endmacro
%macro M2s_b4c1 0
    vsubsd xmm7, xmm10, xmm7
    vaddsd xmm12, xmm14, xmm9
    vsubsd xmm13, xmm12, xmm14
    vsubsd xmm10, xmm12, xmm13
%endmacro
%macro M2s_b4c2 0
    vsubsd xmm6, xmm8, xmm6
    vsubsd xmm11, xmm7, xmm11
    vaddsd xmm6, xmm6, xmm11
    vaddsd xmm11, xmm10, xmm13
%endmacro
%macro M2s_b4c3 0
    vsubsd xmm6, xmm13, xmm11
    vsubsd xmm6, xmm8, xmm6
    vsubsd xmm11, xmm7, xmm11
    vaddsd xmm6, xmm6, xmm11
%endmacro
%macro M2s_b4c4 0
M2s_c2a6
M2s_c2a7
    vaddsd xmm3, xmm2, xmm4
    vaddsd xmm4, xmm6, xmm3
    vsubsd xmm2, xmm4, xmm6
M2s_c2a8
    vsubsd xmm2, xmm3, xmm2
%endmacro
%macro M2s_b4c5 0
M2s_c2a8
    vsubsd xmm2, xmm3, xmm2
M2s_c2a9
    vaddsd xmm4, xmm4, xmm3
    vaddsd xmm3, xmm5, xmm5
    vsubsd xmm6, xmm3, xmm5
%endmacro
%macro M2s_b4c6 0
M2s_c2a9
    vaddsd xmm4, xmm4, xmm3
    vaddsd xmm3, xmm5, xmm5
    vsubsd xmm6, xmm3, xmm5
M2s_c2aa
    vaddsd xmm6, xmm4, xmm3
%endmacro
%macro M2s_b4c7 0
M2s_c2aa
    vaddsd xmm6, xmm4, xmm3
    vaddsd xmm3, xmm10, xmm6
    vsubsd xmm4, xmm3, xmm10
    vsubsd xmm4, xmm6, xmm4
%endmacro
%macro M2s_b4c8 0
    vaddsd xmm11, xmm10, xmm13
M2s_c2a4
M2s_c2a6
M2s_c2a7
    vaddsd xmm3, xmm2, xmm4
    vaddsd xmm4, xmm6, xmm3
    vsubsd xmm2, xmm4, xmm6
%endmacro
%macro M2s_b4c9 0
    vaddsd xmm3, xmm10, xmm6
    vsubsd xmm4, xmm3, xmm10
    vsubsd xmm4, xmm6, xmm4
    vaddsd xmm6, xmm4, xmm9
%endmacro
%macro M2s_b4ca 0
    vaddsd xmm9, xmm3, xmm6
    vcmpsd xmm5, xmm9, [u_half], 0x1e
    vandpd xmm5, xmm5, [u_one]
    vcmpsd xmm1, xmm9, [u_mhalf], 0x11
    vandpd xmm1, xmm1, [u_one]
    vaddsd xmm0, xmm0, xmm5
    vsubsd xmm0, xmm0, xmm1
    vcvttsd2si eax, xmm0
M2s_a38a
    cmp eax, ecx
    cmovg eax, ecx
    ret
.t3h:
M2s_c294
M2s_c296
M2s_c299
    vsubsd xmm11, xmm9, xmm11
    vmovsd xmm7, [u_kg]
    vmovsd xmm6, [u_kg + 8]
%endmacro
%macro M2s_b4cb 0
M2s_c2ab
M2s_c296
M2s_c299
M2s_c2a2
%endmacro
%macro M2s_b4cc 0
M2s_c2ac
M2s_c297
M2s_c29a
M2s_c2a3
%endmacro
%macro M2s_b4cd 0
M2s_c2ad
%endmacro
%macro M2s_b4ce 0
    vsubsd xmm10, xmm6, xmm13
M2s_c2ae
M2s_c2b0
M2s_c2b2
    vmulsd xmm11, xmm6, xmm8
    vfmadd231sd xmm11, xmm9, xmm7
    vaddsd xmm14, xmm14, xmm11
%endmacro
%macro M2s_b4cf 0
M2s_c2ae
M2s_c2b0
M2s_c2b2
    vmulsd xmm11, xmm6, xmm8
    vfmadd231sd xmm11, xmm9, xmm7
    vaddsd xmm14, xmm14, xmm11
    vaddsd xmm11, xmm10, xmm14
%endmacro
%macro M2s_b4d0 0
M2s_c2af
M2s_c2b1
M2s_c2b3
    vfmadd231sd xmm11, xmm9, xmm7
    vaddsd xmm14, xmm14, xmm11
    vaddsd xmm11, xmm10, xmm14
    vsubsd xmm13, xmm11, xmm10
%endmacro
%macro M2s_b4d1 0
    vaddsd xmm11, xmm10, xmm14
M2s_c2b4
M2s_c2b6
    vsubsd xmm12, xmm9, xmm10
    vsubsd xmm12, xmm13, xmm12
    vsubsd xmm10, xmm7, xmm10
%endmacro
%macro M2s_b4d2 0
M2s_c2b4
M2s_c2b6
    vsubsd xmm12, xmm9, xmm10
    vsubsd xmm12, xmm13, xmm12
    vsubsd xmm10, xmm7, xmm10
    vaddsd xmm12, xmm12, xmm10
%endmacro
%macro M2s_b4d3 0
M2s_c2b5
M2s_c2b7
    vsubsd xmm12, xmm13, xmm12
    vsubsd xmm10, xmm7, xmm10
    vaddsd xmm12, xmm12, xmm10
    vaddsd xmm10, xmm14, xmm9
%endmacro
%macro M2s_b4d4 0
    vaddsd xmm12, xmm12, xmm10
M2s_c2b8
    vaddsd xmm10, xmm14, xmm12
    vaddsd xmm12, xmm9, xmm10
    vsubsd xmm14, xmm12, xmm9
%endmacro
%macro M2s_b4d5 0
M2s_c2b8
    vaddsd xmm10, xmm14, xmm12
    vaddsd xmm12, xmm9, xmm10
    vsubsd xmm14, xmm12, xmm9
    vsubsd xmm14, xmm10, xmm14
%endmacro
%macro M2s_b4d6 0
M2s_c2b9
    vaddsd xmm12, xmm9, xmm10
    vsubsd xmm14, xmm12, xmm9
    vsubsd xmm14, xmm10, xmm14
    vaddsd xmm8, xmm0, xmm3
%endmacro
%macro M2s_b4d7 0
    vsubsd xmm14, xmm10, xmm14
    vaddsd xmm8, xmm0, xmm3
    vsubsd xmm13, xmm8, xmm0
    vsubsd xmm11, xmm8, xmm13
%endmacro
%macro M2s_b4d8 0
    vaddsd xmm8, xmm0, xmm3
    vsubsd xmm13, xmm8, xmm0
    vsubsd xmm11, xmm8, xmm13
    vsubsd xmm11, xmm0, xmm11
%endmacro
%macro M2s_b4d9 0
    vsubsd xmm13, xmm8, xmm0
    vsubsd xmm11, xmm8, xmm13
    vsubsd xmm11, xmm0, xmm11
    vsubsd xmm13, xmm3, xmm13
%endmacro
%macro M2s_b4da 0
    vsubsd xmm10, xmm13, xmm1
M2s_c2ba
M2s_c2bc
M2s_c2be
    vsubsd xmm3, xmm11, xmm3
    vaddsd xmm2, xmm2, xmm3
    vaddsd xmm3, xmm6, xmm7
%endmacro
%macro M2s_b4db 0
M2s_c2ba
M2s_c2bc
M2s_c2be
    vsubsd xmm3, xmm11, xmm3
    vaddsd xmm2, xmm2, xmm3
    vaddsd xmm3, xmm6, xmm7
    vsubsd xmm13, xmm3, xmm6
%endmacro
%macro M2s_b4dc 0
M2s_c2bb
M2s_c2bd
M2s_c2bf
    vaddsd xmm2, xmm2, xmm3
    vaddsd xmm3, xmm6, xmm7
    vsubsd xmm13, xmm3, xmm6
    vsubsd xmm10, xmm3, xmm13
%endmacro
%macro M2s_b4dd 0
    vsubsd xmm13, xmm3, xmm6
M2s_c2c0
M2s_c2c2
    vmovsd [r12 + 1280], xmm10
    vmovsd [r12 + 1288], xmm2
    vroundsd xmm7, xmm12, xmm12, 8
%endmacro
%macro M2s_b4de 0
M2s_c2c0
M2s_c2c2
    vmovsd [r12 + 1280], xmm10
    vmovsd [r12 + 1288], xmm2
    vroundsd xmm7, xmm12, xmm12, 8
    vsubsd xmm11, xmm12, xmm7
%endmacro
%macro M2s_b4df 0
M2s_c2c1
M2s_c2c3
    vmovsd [r12 + 1288], xmm2
    vroundsd xmm7, xmm12, xmm12, 8
    vsubsd xmm11, xmm12, xmm7
    vxorpd xmm6, xmm6, xmm6
%endmacro
%macro M2s_b4e0 0
    vsubsd xmm11, xmm12, xmm7
M2s_c2c4
    vsubsd xmm3, xmm11, xmm3
    vsubsd xmm13, xmm14, xmm13
    vaddsd xmm3, xmm3, xmm13
%endmacro
%macro M2s_b4e1 0
M2s_c2c4
    vsubsd xmm3, xmm11, xmm3
    vsubsd xmm13, xmm14, xmm13
    vaddsd xmm3, xmm3, xmm13
    vaddsd xmm13, xmm6, xmm6
%endmacro
%macro M2s_b4e2 0
M2s_c2c5
    vsubsd xmm13, xmm14, xmm13
    vaddsd xmm3, xmm3, xmm13
    vaddsd xmm13, xmm6, xmm6
    vsubsd xmm9, xmm13, xmm6
%endmacro
%macro M2s_b4e3 0
    vaddsd xmm13, xmm6, xmm6
    vsubsd xmm9, xmm13, xmm6
    vsubsd xmm15, xmm13, xmm9
    vsubsd xmm15, xmm6, xmm15
%endmacro
%macro M2s_b4e4 0
    vsubsd xmm9, xmm13, xmm6
    vsubsd xmm15, xmm13, xmm9
    vsubsd xmm15, xmm6, xmm15
    vsubsd xmm9, xmm6, xmm9
%endmacro
%macro M2s_b4e5 0
    vsubsd xmm15, xmm13, xmm9
    vsubsd xmm15, xmm6, xmm15
    vsubsd xmm9, xmm6, xmm9
    vaddsd xmm15, xmm15, xmm9
%endmacro
%macro M2s_b4e6 0
    vsubsd xmm3, xmm13, xmm8
    vsubsd xmm3, xmm9, xmm3
    vaddsd xmm9, xmm3, xmm15
    vaddsd xmm15, xmm13, xmm9
    vcmpsd xmm6, xmm15, [u_half], 0x1e
    vandpd xmm6, xmm6, [u_one]
    vcmpsd xmm11, xmm15, [u_mhalf], 0x11
    vandpd xmm11, xmm11, [u_one]
    vaddsd xmm7, xmm7, xmm6
    vsubsd xmm7, xmm7, xmm11
    vcvttsd2si eax, xmm7
M2s_c2ad
    cmp eax, ecx
    cmovg eax, ecx
M2s_c2c8
M2s_c2ca
    vaddsd xmm6, xmm4, xmm4
    vsubsd xmm8, xmm6, xmm4
    vsubsd xmm9, xmm6, xmm8
%endmacro
%macro M2s_b4e7 0
M2s_c2c6
M2s_c2c8
M2s_c2ca
    vaddsd xmm6, xmm4, xmm4
    vsubsd xmm8, xmm6, xmm4
    vsubsd xmm9, xmm6, xmm8
    vsubsd xmm9, xmm4, xmm9
%endmacro
%macro M2s_b4e8 0
M2s_c2c7
M2s_c2c9
M2s_c2cb
    vsubsd xmm8, xmm6, xmm4
    vsubsd xmm9, xmm6, xmm8
    vsubsd xmm9, xmm4, xmm9
    vsubsd xmm8, xmm4, xmm8
%endmacro
%macro M2s_b4e9 0
    vsubsd xmm9, xmm4, xmm9
M2s_c2cc
M2s_c2ce
    vaddsd xmm2, xmm2, xmm4
    vsubsd xmm2, xmm2, xmm3
    vcvttsd2si eax, xmm2
%endmacro
%macro M2s_b4ea 0
M2s_c2cc
M2s_c2ce
    vaddsd xmm2, xmm2, xmm4
    vsubsd xmm2, xmm2, xmm3
    vcvttsd2si eax, xmm2
    xor ecx, ecx
%endmacro
%macro M2s_b4eb 0
M2s_c2cd
M2s_c2cf
    vsubsd xmm2, xmm2, xmm3
    vcvttsd2si eax, xmm2
    xor ecx, ecx
    test eax, eax
%endmacro
%macro M2s_b4ec 0
M2s_c2d0
    ret
.t3b:
    vxorpd ymm0, ymm0, ymm0
    vmovapd ymm1, [r12 + 384]
%endmacro
%macro M2s_b4ed 0
    vxorpd ymm0, ymm0, ymm0
    vmovapd ymm1, [r12 + 384]
    vmovapd ymm2, [r12 + 416]
    vmovapd ymm3, [r12 + 448]
%endmacro
%macro M2s_b4ee 0
    vmovapd ymm2, [r12 + 416]
    vmovapd ymm3, [r12 + 448]
    vbroadcastsd ymm4, [u_ysc]
    vbroadcastsd ymm5, [u_ysc + 8]
%endmacro
%macro M2s_b4ef 0
    cmovs eax, ecx
    mov ecx, 1023
M2s_c2d0
    ret
.t3b:
%endmacro
%macro M2s_b4f0 0
    vmulpd ymm6, ymm1, ymm4
M2s_c2d1
M2s_c2d3
M2s_c2d5
    vsubpd ymm6, ymm11, ymm7
    vsubpd ymm6, ymm10, ymm6
    vbroadcastsd ymm5, [u_rcr]
%endmacro
%macro M2s_b4f1 0
M2s_c2d1
M2s_c2d3
M2s_c2d5
    vsubpd ymm6, ymm11, ymm7
    vsubpd ymm6, ymm10, ymm6
    vbroadcastsd ymm5, [u_rcr]
    vbroadcastsd ymm1, [u_rcr + 8]
%endmacro
%macro M2s_b4f2 0
M2s_c2d2
M2s_c2d4
M2s_c2d6
    vsubpd ymm6, ymm10, ymm6
    vbroadcastsd ymm5, [u_rcr]
    vbroadcastsd ymm1, [u_rcr + 8]
    vmulpd ymm9, ymm5, ymm3
%endmacro
%macro M2s_b4f3 0
    vbroadcastsd ymm1, [u_rcr + 8]
M2s_c2d7
M2s_c2d9
    vsubpd ymm8, ymm11, ymm8
    vsubpd ymm5, ymm10, ymm5
    vaddpd ymm8, ymm8, ymm5
%endmacro
%macro M2s_b4f4 0
M2s_c2d7
M2s_c2d9
    vsubpd ymm8, ymm11, ymm8
    vsubpd ymm5, ymm10, ymm5
    vaddpd ymm8, ymm8, ymm5
    vaddpd ymm5, ymm6, ymm7
%endmacro
%macro M2s_b4f5 0
M2s_c2d8
M2s_c2da
    vsubpd ymm5, ymm10, ymm5
    vaddpd ymm8, ymm8, ymm5
    vaddpd ymm5, ymm6, ymm7
    vsubpd ymm9, ymm5, ymm6
%endmacro
%macro M2s_b4f6 0
    vaddpd ymm5, ymm6, ymm7
M2s_c2db
    vaddpd ymm4, ymm4, ymm9
    vaddpd ymm9, ymm8, ymm5
    vaddpd ymm5, ymm1, ymm9
%endmacro
%macro M2s_b4f7 0
M2s_c2db
    vaddpd ymm4, ymm4, ymm9
    vaddpd ymm9, ymm8, ymm5
    vaddpd ymm5, ymm1, ymm9
    vsubpd ymm8, ymm5, ymm1
%endmacro
%macro M2s_b4f8 0
M2s_c2dc
    vaddpd ymm9, ymm8, ymm5
    vaddpd ymm5, ymm1, ymm9
    vsubpd ymm8, ymm5, ymm1
    vsubpd ymm8, ymm9, ymm8
%endmacro
%macro M2s_b4f9 0
    vsubpd ymm8, ymm5, ymm1
    vsubpd ymm8, ymm9, ymm8
    vaddpd ymm9, ymm8, ymm4
    vaddpd ymm4, ymm5, ymm9
%endmacro
%macro M2s_b4fa 0
    vsubpd ymm8, ymm9, ymm8
    vaddpd ymm9, ymm8, ymm4
    vaddpd ymm4, ymm5, ymm9
    vsubpd ymm8, ymm4, ymm5
%endmacro
%macro M2s_b4fb 0
    vaddpd ymm9, ymm8, ymm4
    vaddpd ymm4, ymm5, ymm9
    vsubpd ymm8, ymm4, ymm5
    vsubpd ymm8, ymm9, ymm8
%endmacro
%macro M2s_b4fc 0
    vbroadcastsd ymm8, [u_gcr]
M2s_c2dd
M2s_c2df
M2s_c2e1
    vsubpd ymm10, ymm1, ymm8
    vsubpd ymm10, ymm7, ymm10
    vbroadcastsd ymm3, [u_gcb]
%endmacro
%macro M2s_b4fd 0
M2s_c2dd
M2s_c2df
M2s_c2e1
    vsubpd ymm10, ymm1, ymm8
    vsubpd ymm10, ymm7, ymm10
    vbroadcastsd ymm3, [u_gcb]
    vbroadcastsd ymm5, [u_gcb + 8]
%endmacro
%macro M2s_b4fe 0
M2s_c2de
M2s_c2e0
M2s_c2e2
    vsubpd ymm10, ymm7, ymm10
    vbroadcastsd ymm3, [u_gcb]
    vbroadcastsd ymm5, [u_gcb + 8]
    vmulpd ymm9, ymm3, ymm2
%endmacro
%macro M2s_b4ff 0
    vbroadcastsd ymm5, [u_gcb + 8]
M2s_c2e3
M2s_c2e5
    vsubpd ymm7, ymm1, ymm7
    vsubpd ymm3, ymm8, ymm3
    vaddpd ymm7, ymm7, ymm3
%endmacro
%macro M2s_b500 0
M2s_c2e3
M2s_c2e5
    vsubpd ymm7, ymm1, ymm7
    vsubpd ymm3, ymm8, ymm3
    vaddpd ymm7, ymm7, ymm3
    vaddpd ymm3, ymm10, ymm4
%endmacro
%macro M2s_b501 0
M2s_c2e4
M2s_c2e6
    vsubpd ymm3, ymm8, ymm3
    vaddpd ymm7, ymm7, ymm3
    vaddpd ymm3, ymm10, ymm4
    vsubpd ymm9, ymm3, ymm10
%endmacro
%macro M2s_b502 0
    vaddpd ymm3, ymm10, ymm4
M2s_c2e7
    vaddpd ymm12, ymm12, ymm9
    vaddpd ymm9, ymm7, ymm3
    vaddpd ymm3, ymm5, ymm9
%endmacro
%macro M2s_b503 0
M2s_c2e7
    vaddpd ymm12, ymm12, ymm9
    vaddpd ymm9, ymm7, ymm3
    vaddpd ymm3, ymm5, ymm9
    vsubpd ymm7, ymm3, ymm5
%endmacro
%macro M2s_b504 0
M2s_c2e8
    vaddpd ymm9, ymm7, ymm3
    vaddpd ymm3, ymm5, ymm9
    vsubpd ymm7, ymm3, ymm5
    vsubpd ymm7, ymm9, ymm7
%endmacro
%macro M2s_b505 0
    vsubpd ymm7, ymm3, ymm5
    vsubpd ymm7, ymm9, ymm7
    vaddpd ymm9, ymm7, ymm12
    vaddpd ymm12, ymm3, ymm9
%endmacro
%macro M2s_b506 0
    vsubpd ymm7, ymm9, ymm7
    vaddpd ymm9, ymm7, ymm12
    vaddpd ymm12, ymm3, ymm9
    vsubpd ymm7, ymm12, ymm3
%endmacro
%macro M2s_b507 0
    vaddpd ymm9, ymm7, ymm12
    vaddpd ymm12, ymm3, ymm9
    vsubpd ymm7, ymm12, ymm3
    vsubpd ymm7, ymm9, ymm7
%endmacro
%macro M2s_b508 0
    vbroadcastsd ymm7, [u_bcb]
M2s_c2e9
M2s_c2eb
M2s_c2ed
    vsubpd ymm1, ymm9, ymm7
    vsubpd ymm1, ymm10, ymm1
    vmovapd [r12 + 832], ymm9
%endmacro
%macro M2s_b509 0
M2s_c2e9
M2s_c2eb
M2s_c2ed
    vsubpd ymm1, ymm9, ymm7
    vsubpd ymm1, ymm10, ymm1
    vmovapd [r12 + 832], ymm9
    vmovapd [r12 + 864], ymm1
%endmacro
%macro M2s_b50a 0
M2s_c2ea
M2s_c2ec
M2s_c2ee
    vsubpd ymm1, ymm10, ymm1
    vmovapd [r12 + 832], ymm9
    vmovapd [r12 + 864], ymm1
    vmovapd ymm14, [r12 + 704]
%endmacro
%macro M2s_b50b 0
    vmovapd [r12 + 864], ymm1
M2s_c2ef
M2s_c2f1
    call .xeo
    vmovapd [r12 + 1024], ymm14
    vmovapd [r12 + 1056], ymm15
%endmacro
%macro M2s_b50c 0
M2s_c2ef
M2s_c2f1
    call .xeo
    vmovapd [r12 + 1024], ymm14
    vmovapd [r12 + 1056], ymm15
    vmovsd xmm0, [r12 + 1088]
%endmacro
%macro M2s_b50d 0
M2s_c2f0
M2s_c2f2
    vmovapd [r12 + 1024], ymm14
    vmovapd [r12 + 1056], ymm15
    vmovsd xmm0, [r12 + 1088]
    vmovsd xmm1, [r12 + 1120]
%endmacro
%macro M2s_b50e 0
    vmovsd xmm0, [r12 + 1088]
M2s_c2f3
%endmacro
%macro M2s_b50f 0
M2s_c2f3
    vfmsub231sd xmm7, xmm2, xmm4
%endmacro
%macro M2s_b510 0
    vmovsd xmm2, [r12 + 896]
    vmovsd xmm3, [r12 + 928]
M2s_b511
    vfmsub231sd xmm7, xmm2, xmm4
    vmulsd xmm8, xmm3, xmm4
%endmacro
%macro M2s_b511 0
M2s_c2f4
%endmacro
%macro M2s_b512 0
M2s_b511
M2s_b515
%endmacro
%macro M2s_b513 0
M2s_c2f5
%endmacro
%macro M2s_b514 0
    vmovapd xmm7, xmm6
M2s_b515
    vaddsd xmm8, xmm6, xmm7
    vsubsd xmm9, xmm8, xmm6
    vsubsd xmm9, xmm7, xmm9
%endmacro
%macro M2s_b515 0
M2s_c2f6
%endmacro
%macro M2s_b516 0
M2s_c2f7
%endmacro
%macro M2s_b517 0
    vfmadd231sd xmm8, xmm2, xmm5
    vaddsd xmm7, xmm7, xmm8
    vaddsd xmm8, xmm6, xmm7
    vsubsd xmm9, xmm8, xmm6
%endmacro
%macro M2s_b518 0
    vaddsd xmm7, xmm7, xmm8
    vaddsd xmm8, xmm6, xmm7
    vsubsd xmm9, xmm8, xmm6
    vsubsd xmm9, xmm7, xmm9
%endmacro
%macro M2s_b519 0
    vaddsd xmm8, xmm6, xmm7
    vsubsd xmm9, xmm8, xmm6
    vsubsd xmm9, xmm7, xmm9
    vaddsd xmm5, xmm0, xmm8
%endmacro
%macro M2s_b51a 0
    vsubsd xmm9, xmm8, xmm6
    vsubsd xmm9, xmm7, xmm9
    vaddsd xmm5, xmm0, xmm8
    vsubsd xmm4, xmm5, xmm0
%endmacro
%macro M2s_b51b 0
    vsubsd xmm9, xmm7, xmm9
    vaddsd xmm5, xmm0, xmm8
    vsubsd xmm4, xmm5, xmm0
    vsubsd xmm3, xmm5, xmm4
%endmacro
%macro M2s_b51c 0
    vsubsd xmm4, xmm5, xmm0
    vsubsd xmm3, xmm5, xmm4
    vsubsd xmm3, xmm0, xmm3
    vsubsd xmm4, xmm8, xmm4
%endmacro
%macro M2s_b51d 0
    vaddsd xmm5, xmm0, xmm8
    vsubsd xmm4, xmm5, xmm0
    vsubsd xmm3, xmm5, xmm4
    vsubsd xmm3, xmm0, xmm3
%endmacro
%macro M2s_b51e 0
M2s_b51d
    vsubsd xmm4, xmm8, xmm4
    vaddsd xmm3, xmm3, xmm4
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm2, xmm4, xmm1
%endmacro
%macro M2s_b51f 0
    vaddsd xmm3, xmm3, xmm4
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm2, xmm4, xmm1
    vsubsd xmm7, xmm4, xmm2
%endmacro
%macro M2s_b520 0
    vsubsd xmm3, xmm5, xmm4
M2s_b521
    vsubsd xmm2, xmm4, xmm1
    vsubsd xmm7, xmm4, xmm2
    vsubsd xmm7, xmm1, xmm7
%endmacro
%macro M2s_b521 0
    vsubsd xmm3, xmm0, xmm3
    vsubsd xmm4, xmm8, xmm4
    vaddsd xmm3, xmm3, xmm4
    vaddsd xmm4, xmm1, xmm9
%endmacro
%macro M2s_b522 0
    vsubsd xmm4, xmm8, xmm4
M2s_c2f8
M2s_c2fa
%endmacro
%macro M2s_b523 0
M2s_c2f8
M2s_c2fa
    vmovsd xmm3, [r12 + 496]
%endmacro
%macro M2s_b524 0
M2s_c2fb
%endmacro
%macro M2s_b525 0
    vmovsd xmm5, [r12 + 944]
M2s_c2fc
    vfmsub231sd xmm1, xmm6, xmm3
    vmulsd xmm0, xmm5, xmm3
    vfmadd231sd xmm0, xmm6, xmm7
%endmacro
%macro M2s_b526 0
M2s_c2fc
M2s_c2fe
%endmacro
%macro M2s_b527 0
M2s_c2fd
M2s_c2ff
%endmacro
%macro M2s_b528 0
    vsubsd xmm3, xmm0, xmm3
    vsubsd xmm4, xmm8, xmm4
M2s_a3ac
M2s_c2fb
M2s_c2f9
    vmovsd xmm6, [r12 + 912]
%endmacro
%macro M2s_b529 0
M2s_c300
%endmacro
%macro M2s_b52a 0
    vsubsd xmm7, xmm1, xmm7
    vsubsd xmm2, xmm9, xmm2
    vaddsd xmm7, xmm7, xmm2
    vaddsd xmm2, xmm3, xmm4
%endmacro
%macro M2s_b52b 0
    vsubsd xmm7, xmm4, xmm2
    vsubsd xmm7, xmm1, xmm7
    vsubsd xmm2, xmm9, xmm2
    vaddsd xmm7, xmm7, xmm2
%endmacro
%macro M2s_b52c 0
    vaddsd xmm7, xmm7, xmm2
    vaddsd xmm2, xmm3, xmm4
M2s_a3b2
    vaddsd xmm7, xmm4, xmm2
%endmacro
%macro M2s_b52d 0
M2s_c301
%endmacro
%macro M2s_b52e 0
M2s_c302
%endmacro
%macro M2s_b52f 0
M2s_c303
%endmacro
%macro M2s_b530 0
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm5, xmm7, xmm3
    vsubsd xmm5, xmm4, xmm5
    vsubsd xmm3, xmm0, xmm3
%endmacro
%macro M2s_b531 0
    vsubsd xmm2, xmm1, xmm2
M2s_c304
M2s_c306
%endmacro
%macro M2s_b532 0
    vaddsd xmm7, xmm4, xmm0
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm5, xmm7, xmm3
    vsubsd xmm5, xmm4, xmm5
%endmacro
%macro M2s_b533 0
M2s_c304
M2s_c306
    vaddsd xmm3, xmm8, xmm2
%endmacro
%macro M2s_b534 0
M2s_c305
M2s_a3c2
M2s_a3c3
M2s_c307
    vmovsd [r12 + 1120], xmm0
    vmovsd xmm0, [r12 + 1096]
%endmacro
%macro M2s_b535 0
M2s_c307
    vmovsd [r12 + 1120], xmm0
    vmovsd xmm0, [r12 + 1096]
    vmovsd xmm1, [r12 + 1128]
    vmovsd xmm2, [r12 + 960]
%endmacro
%macro M2s_b536 0
M2s_c308
    vmovsd xmm0, [r12 + 1096]
    vmovsd xmm1, [r12 + 1128]
    vmovsd xmm2, [r12 + 960]
    vmovsd xmm3, [r12 + 992]
%endmacro
%macro M2s_b537 0
    vmovsd xmm1, [r12 + 1128]
    vmovsd xmm2, [r12 + 960]
    vmovsd xmm3, [r12 + 992]
    vmovsd xmm4, [r12 + 480]
%endmacro
%macro M2s_b538 0
    vmovsd xmm3, [r12 + 992]
    vmovsd xmm4, [r12 + 480]
    vxorpd xmm5, xmm5, xmm5
    vmulsd xmm6, xmm2, xmm4
%endmacro
%macro M2s_b539 0
M2s_c309
    vsubsd xmm1, xmm8, xmm1
    vsubsd xmm6, xmm2, xmm6
    vaddsd xmm1, xmm1, xmm6
    vaddsd xmm6, xmm5, xmm3
%endmacro
%macro M2s_b53a 0
    vaddsd xmm3, xmm7, xmm6
    vsubsd xmm5, xmm3, xmm7
    vsubsd xmm5, xmm6, xmm5
    vaddsd xmm6, xmm5, xmm1
%endmacro
%macro M2s_b53b 0
M2s_c30a
%endmacro
%macro M2s_b53c 0
M2s_c30b
%endmacro
%macro M2s_b53d 0
M2s_c30c
%endmacro
%macro M2s_b53e 0
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm2, xmm3
    vmovsd xmm9, [r12 + 968]
    vmovsd xmm8, [r12 + 1000]
M2s_c301
M2s_c302
M2s_c303
%endmacro
%macro M2s_b53f 0
M2s_c30d
    vsubsd xmm8, xmm0, xmm1
    vsubsd xmm8, xmm7, xmm8
    vsubsd xmm1, xmm5, xmm1
M2s_c302
M2s_c303
    vaddsd xmm4, xmm1, xmm9
%endmacro
%macro M2s_b540 0
M2s_c30e
M2s_c310
    vaddsd xmm4, xmm4, xmm9
    vaddsd xmm9, xmm8, xmm1
M2s_c303
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm8, xmm4, xmm1
%endmacro
%macro M2s_b541 0
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [r12 + 976]
    vmovsd xmm5, [r12 + 1008]
M2s_c2fc
M2s_c2fe
    vaddsd xmm0, xmm9, xmm1
    vsubsd xmm2, xmm0, xmm9
    vsubsd xmm2, xmm1, xmm2
%endmacro
%macro M2s_b542 0
M2s_c312
M2s_c2fe
M2s_c300
%endmacro
%macro M2s_b543 0
M2s_c313
M2s_c2ff
M2s_c314
%endmacro
%macro M2s_b544 0
    vsubsd xmm3, xmm0, xmm3
M2s_c309
    vsubsd xmm1, xmm8, xmm1
    vsubsd xmm6, xmm2, xmm6
    vaddsd xmm1, xmm1, xmm6
%endmacro
%macro M2s_b545 0
    vsubsd xmm5, xmm7, xmm3
    vsubsd xmm5, xmm4, xmm5
M2s_c315
M2s_b546
    vaddsd xmm6, xmm5, xmm1
    vaddsd xmm1, xmm3, xmm6
%endmacro
%macro M2s_b546 0
    vaddsd xmm6, xmm5, xmm3
    vaddsd xmm3, xmm7, xmm6
    vsubsd xmm5, xmm3, xmm7
    vsubsd xmm5, xmm6, xmm5
%endmacro
%macro M2s_b547 0
    vsubsd xmm5, xmm1, xmm3
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [r12 + 984]
    vmovsd xmm0, [r12 + 1016]
M2s_c30a
M2s_c30b
M2s_c30c
%endmacro
%macro M2s_b548 0
M2s_c316
    vsubsd xmm0, xmm4, xmm8
    vsubsd xmm0, xmm1, xmm0
    vsubsd xmm8, xmm7, xmm8
M2s_c30b
M2s_c30c
    vaddsd xmm3, xmm8, xmm2
%endmacro
%macro M2s_b549 0
M2s_c317
M2s_c319
    vaddsd xmm3, xmm3, xmm2
    vaddsd xmm2, xmm0, xmm8
M2s_c30c
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm0, xmm3, xmm8
%endmacro
%macro M2s_b54a 0
    vaddsd xmm3, xmm8, xmm2
M2s_c31b
M2s_c2f4
    vfmsub231sd xmm7, xmm2, xmm4
    vmulsd xmm8, xmm3, xmm4
    vfmadd231sd xmm8, xmm2, xmm5
%endmacro
%macro M2s_b54b 0
M2s_c31b
M2s_c2f4
M2s_c2f6
%endmacro
%macro M2s_b54c 0
M2s_c31c
M2s_c2f5
M2s_c2f7
%endmacro
%macro M2s_b54d 0
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm2, xmm3
    vmovsd xmm9, [r12 + 1032]
    vmovsd xmm8, [r12 + 1064]
M2s_c301
M2s_c302
M2s_c303
%endmacro
%macro M2s_b54e 0
M2s_c31d
M2s_c30f
%endmacro
%macro M2s_b54f 0
M2s_c31e
M2s_c310
M2s_c311
%endmacro
%macro M2s_b550 0
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [r12 + 1040]
    vmovsd xmm5, [r12 + 1072]
M2s_c2fc
M2s_c2fe
    vaddsd xmm0, xmm9, xmm1
    vsubsd xmm2, xmm0, xmm9
    vsubsd xmm2, xmm1, xmm2
%endmacro
%macro M2s_b551 0
M2s_c31f
M2s_c2fe
M2s_c300
%endmacro
%macro M2s_b552 0
M2s_c320
M2s_c2ff
M2s_c314
%endmacro
%macro M2s_b553 0
    vsubsd xmm5, xmm1, xmm3
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [r12 + 1048]
    vmovsd xmm0, [r12 + 1080]
M2s_c30a
M2s_c30b
M2s_c30c
%endmacro
%macro M2s_b554 0
M2s_c321
M2s_c318
%endmacro
%macro M2s_b555 0
M2s_c322
M2s_c319
M2s_c31a
%endmacro
%macro M2s_b556 0
    vaddsd xmm3, xmm8, xmm2
M2s_c323
M2s_c325
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm1, ymm2
    vmulpd ymm6, ymm3, ymm2
%endmacro
%macro M2s_b557 0
M2s_c323
M2s_c325
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm1, ymm2
    vmulpd ymm6, ymm3, ymm2
    vfmadd231pd ymm6, ymm1, ymm0
%endmacro
%macro M2s_b558 0
M2s_c324
M2s_c326
    vfmsub231pd ymm5, ymm1, ymm2
    vmulpd ymm6, ymm3, ymm2
    vfmadd231pd ymm6, ymm1, ymm0
    vaddpd ymm5, ymm5, ymm6
%endmacro
%macro M2s_b559 0
    vfmadd231pd ymm6, ymm1, ymm0
M2s_c295
    vmovapd [r12 + 96], ymm2
    vxorpd ymm2, ymm6, [u_mzero]
    vxorpd ymm3, ymm7, [u_mzero]
%endmacro
%macro M2s_b55a 0
    vmovapd [r12 + 96], ymm2
    vxorpd ymm2, ymm6, [u_mzero]
    vxorpd ymm3, ymm7, [u_mzero]
M2s_b55b
    vsubpd ymm6, ymm2, ymm6
%endmacro
%macro M2s_b55b 0
    vaddpd ymm7, ymm14, ymm2
    vsubpd ymm6, ymm7, ymm14
    vsubpd ymm1, ymm7, ymm6
    vsubpd ymm1, ymm14, ymm1
%endmacro
%macro M2s_b55c 0
    vaddpd ymm1, ymm1, ymm6
    vaddpd ymm6, ymm15, ymm3
    vsubpd ymm5, ymm6, ymm15
    vsubpd ymm4, ymm6, ymm5
%endmacro
%macro M2s_b55d 0
    vsubpd ymm4, ymm6, ymm5
M2s_c327
M2s_c329
M2s_c32b
    vmovapd [r12 + 256 + 32], ymm6
    lea r8, [u_cs]
    .dexp_t:
%endmacro
%macro M2s_b55e 0
M2s_c327
M2s_c329
M2s_c32b
    vmovapd [r12 + 256 + 32], ymm6
    lea r8, [u_cs]
    .dexp_t:
    vmovapd ymm6, [r12 + 256]
%endmacro
%macro M2s_b55f 0
M2s_c328
M2s_c32a
M2s_c32c
    lea r8, [u_cs]
    .dexp_t:
    vmovapd ymm6, [r12 + 256]
    vmovapd ymm7, [r12 + 256 + 32]
%endmacro
%macro M2s_b560 0
    vmovapd ymm6, [r12 + 256]
M2s_c32d
M2s_c32f
    vxorpd ymm4, ymm6, [u_mzero]
    vmulpd ymm1, ymm7, ymm4
    vmovapd ymm2, ymm1
%endmacro
%macro M2s_b561 0
M2s_c32d
M2s_c32f
    vxorpd ymm4, ymm6, [u_mzero]
    vmulpd ymm1, ymm7, ymm4
    vmovapd ymm2, ymm1
    vfmsub231pd ymm2, ymm7, ymm4
%endmacro
%macro M2s_b562 0
M2s_c32e
M2s_c330
    vmulpd ymm1, ymm7, ymm4
    vmovapd ymm2, ymm1
    vfmsub231pd ymm2, ymm7, ymm4
    vmulpd ymm8, ymm0, ymm4
%endmacro
%macro M2s_b563 0
    vfmsub231pd ymm2, ymm7, ymm4
M2s_c331
    vsubpd ymm9, ymm8, ymm1
    vsubpd ymm9, ymm2, ymm9
    vaddpd ymm4, ymm3, ymm8
%endmacro
%macro M2s_b564 0
M2s_c331
    vsubpd ymm9, ymm8, ymm1
    vsubpd ymm9, ymm2, ymm9
    vaddpd ymm4, ymm3, ymm8
    vsubpd ymm2, ymm4, ymm3
%endmacro
%macro M2s_b565 0
M2s_c332
    vsubpd ymm9, ymm2, ymm9
    vaddpd ymm4, ymm3, ymm8
    vsubpd ymm2, ymm4, ymm3
    vsubpd ymm1, ymm4, ymm2
%endmacro
%macro M2s_b566 0
    vsubpd ymm2, ymm4, ymm3
    vsubpd ymm1, ymm4, ymm2
    vsubpd ymm1, ymm3, ymm1
    vsubpd ymm2, ymm8, ymm2
%endmacro
%macro M2s_b567 0
    vsubpd ymm1, ymm4, ymm2
    vsubpd ymm1, ymm3, ymm1
    vsubpd ymm2, ymm8, ymm2
    vaddpd ymm1, ymm1, ymm2
%endmacro
%macro M2s_b568 0
    vsubpd ymm1, ymm3, ymm1
    vsubpd ymm2, ymm8, ymm2
    vaddpd ymm1, ymm1, ymm2
    vaddpd ymm2, ymm5, ymm9
%endmacro
%macro M2s_b569 0
    vsubpd ymm11, ymm5, ymm11
M2s_c333
M2s_c335
M2s_c337
    vsubpd ymm4, ymm8, ymm1
    vsubpd ymm12, ymm8, ymm4
    vsubpd ymm12, ymm1, ymm12
%endmacro
%macro M2s_b56a 0
M2s_c333
M2s_c335
M2s_c337
    vsubpd ymm4, ymm8, ymm1
    vsubpd ymm12, ymm8, ymm4
    vsubpd ymm12, ymm1, ymm12
    vsubpd ymm4, ymm2, ymm4
%endmacro
%macro M2s_b56b 0
M2s_c334
M2s_c336
M2s_c338
    vsubpd ymm12, ymm8, ymm4
    vsubpd ymm12, ymm1, ymm12
    vsubpd ymm4, ymm2, ymm4
    vaddpd ymm12, ymm12, ymm4
%endmacro
%macro M2s_b56c 0
    vsubpd ymm4, ymm2, ymm4
M2s_c339
M2s_c33b
    vsubpd ymm6, ymm5, ymm12
    vsubpd ymm2, ymm5, ymm6
    vsubpd ymm2, ymm12, ymm2
%endmacro
%macro M2s_b56d 0
M2s_c339
M2s_c33b
    vsubpd ymm6, ymm5, ymm12
    vsubpd ymm2, ymm5, ymm6
    vsubpd ymm2, ymm12, ymm2
    vsubpd ymm6, ymm1, ymm6
%endmacro
%macro M2s_b56e 0
M2s_c33a
M2s_c33c
    vsubpd ymm2, ymm5, ymm6
    vsubpd ymm2, ymm12, ymm2
    vsubpd ymm6, ymm1, ymm6
    vaddpd ymm2, ymm2, ymm6
%endmacro
%macro M2s_b56f 0
    vsubpd ymm6, ymm1, ymm6
M2s_c33d
    vsubpd ymm4, ymm11, ymm4
    vsubpd ymm10, ymm0, ymm10
    vaddpd ymm4, ymm4, ymm10
%endmacro
%macro M2s_b570 0
M2s_c33d
    vsubpd ymm4, ymm11, ymm4
    vsubpd ymm10, ymm0, ymm10
    vaddpd ymm4, ymm4, ymm10
    vaddpd ymm10, ymm2, ymm6
%endmacro
%macro M2s_b571 0
M2s_c33e
    vsubpd ymm10, ymm0, ymm10
    vaddpd ymm4, ymm4, ymm10
    vaddpd ymm10, ymm2, ymm6
    vaddpd ymm6, ymm5, ymm10
%endmacro
%macro M2s_b572 0
    vaddpd ymm10, ymm2, ymm6
    vaddpd ymm6, ymm5, ymm10
    vsubpd ymm2, ymm6, ymm5
    vsubpd ymm2, ymm10, ymm2
%endmacro
%macro M2s_b573 0
    vaddpd ymm6, ymm5, ymm10
    vsubpd ymm2, ymm6, ymm5
    vsubpd ymm2, ymm10, ymm2
    vaddpd ymm10, ymm2, ymm4
%endmacro
%macro M2s_b574 0
    vsubpd ymm2, ymm6, ymm5
    vsubpd ymm2, ymm10, ymm2
    vaddpd ymm10, ymm2, ymm4
    vaddpd ymm4, ymm6, ymm10
%endmacro
%macro M2s_b575 0
    vmovapd [r12 + 256], ymm4
M2s_c33f
M2s_c341
M2s_c343
    jne .dexp_t
    vmovapd ymm10, [r12 + 192]
    vmovapd ymm5, [r12 + 192 + 32]
%endmacro
%macro M2s_b576 0
M2s_c33f
M2s_c341
M2s_c343
    jne .dexp_t
    vmovapd ymm10, [r12 + 192]
    vmovapd ymm5, [r12 + 192 + 32]
    mov r8d, 10
%endmacro
%macro M2s_b577 0
M2s_c340
M2s_c342
M2s_c344
    vmovapd ymm10, [r12 + 192]
    vmovapd ymm5, [r12 + 192 + 32]
    mov r8d, 10
    .dexp_q:
%endmacro
%macro M2s_b578 0
    mov r8d, 10
M2s_c345
M2s_c347
    dec r8d
    jnz .dexp_q
    vmovapd ymm7, [r12 + 96]
%endmacro
%macro M2s_b579 0
M2s_c345
M2s_c347
    dec r8d
    jnz .dexp_q
    vmovapd ymm7, [r12 + 96]
    vaddpd ymm7, ymm7, [u_magic]
%endmacro
%macro M2s_b57a 0
M2s_c346
M2s_c348
    jnz .dexp_q
    vmovapd ymm7, [r12 + 96]
    vaddpd ymm7, ymm7, [u_magic]
    vpsllq ymm7, ymm7, 52
%endmacro
%macro M2s_b57b 0
    vaddpd ymm7, ymm7, [u_magic]
M2s_c349
    .dln:
    vmovapd [r12 + 0], ymm14
    vmovapd [r12 + 0 + 32], ymm14
%endmacro
%macro M2s_b57c 0
M2s_c349
    .dln:
    vmovapd [r12 + 0], ymm14
    vmovapd [r12 + 0 + 32], ymm14
    vmovapd [r12 + 0 + 64], ymm15
%endmacro
%macro M2s_b57d 0
M2s_c34a
    vmovapd [r12 + 0], ymm14
    vmovapd [r12 + 0 + 32], ymm14
    vmovapd [r12 + 0 + 64], ymm15
    fldln2
%endmacro
%macro M2s_b57e 0
    vmovapd [r12 + 0 + 64], ymm15
    fldln2
    fld qword [r12 + 0 + 0]
    fyl2x
%endmacro
%macro M2s_b57f 0
    fldln2
    fld qword [r12 + 0 + 0]
    fyl2x
    fstp qword [r12 + 0 + 0]
%endmacro
%macro M2s_b580 0
    fld qword [r12 + 0 + 0]
    fyl2x
    fstp qword [r12 + 0 + 0]
    fldln2
%endmacro
%macro M2s_b581 0
    fstp qword [r12 + 0 + 8]
M2s_c34b
M2s_c34d
M2s_c34f
    vsubpd ymm7, ymm4, ymm3
    vsubpd ymm7, ymm5, ymm7
    vsubpd ymm3, ymm2, ymm3
%endmacro
%macro M2s_b582 0
M2s_c34b
M2s_c34d
M2s_c34f
    vsubpd ymm7, ymm4, ymm3
    vsubpd ymm7, ymm5, ymm7
    vsubpd ymm3, ymm2, ymm3
    vaddpd ymm7, ymm7, ymm3
%endmacro
%macro M2s_b583 0
M2s_c34c
M2s_c34e
M2s_c350
    vsubpd ymm7, ymm5, ymm7
    vsubpd ymm3, ymm2, ymm3
    vaddpd ymm7, ymm7, ymm3
    vaddpd ymm3, ymm6, ymm1
%endmacro
%macro M2s_b584 0
    vaddpd ymm7, ymm7, ymm3
M2s_c351
M2s_c353
    vsubpd ymm7, ymm9, ymm3
    vsubpd ymm7, ymm8, ymm7
    vmovapd ymm6, [r12 + 0]
%endmacro
%macro M2s_b585 0
M2s_c351
M2s_c353
    vsubpd ymm7, ymm9, ymm3
    vsubpd ymm7, ymm8, ymm7
    vmovapd ymm6, [r12 + 0]
    vaddpd ymm5, ymm6, ymm9
%endmacro
%macro M2s_b586 0
M2s_c352
M2s_c354
    vsubpd ymm7, ymm8, ymm7
    vmovapd ymm6, [r12 + 0]
    vaddpd ymm5, ymm6, ymm9
    vsubpd ymm1, ymm5, ymm6
%endmacro
%macro M2s_b587 0
    vaddpd ymm5, ymm6, ymm9
M2s_c355
    vaddpd ymm2, ymm2, ymm1
    vaddpd ymm1, ymm0, ymm7
    vsubpd ymm8, ymm1, ymm0
%endmacro
%macro M2s_b588 0
M2s_c355
    vaddpd ymm2, ymm2, ymm1
    vaddpd ymm1, ymm0, ymm7
    vsubpd ymm8, ymm1, ymm0
    vsubpd ymm3, ymm1, ymm8
%endmacro
%macro M2s_b589 0
M2s_c356
    vaddpd ymm1, ymm0, ymm7
    vsubpd ymm8, ymm1, ymm0
    vsubpd ymm3, ymm1, ymm8
    vsubpd ymm3, ymm0, ymm3
%endmacro
%macro M2s_b58a 0
    vsubpd ymm3, ymm1, ymm8
    vsubpd ymm3, ymm0, ymm3
    vsubpd ymm8, ymm7, ymm8
    vaddpd ymm3, ymm3, ymm8
%endmacro
%macro M2s_b58b 0
    vsubpd ymm3, ymm0, ymm3
    vsubpd ymm8, ymm7, ymm8
    vaddpd ymm3, ymm3, ymm8
    vaddpd ymm8, ymm2, ymm1
%endmacro
%macro M2s_b58c 0
    vsubpd ymm8, ymm7, ymm8
    vaddpd ymm3, ymm3, ymm8
    vaddpd ymm8, ymm2, ymm1
    vaddpd ymm1, ymm5, ymm8
%endmacro
%macro M2s_b58d 0
    vaddpd ymm8, ymm2, ymm3
M2s_c357
M2s_c359
%endmacro
%macro M2s_b58e 0
M2s_c357
M2s_c359
    vmovapd ymm3, ymm2
%endmacro
%macro M2s_b58f 0
M2s_c358
M2s_c35a
    vbroadcastsd ymm0, [u_e512]
    vbroadcastsd ymm1, [u_e512 + 8]
    vmulpd ymm2, ymm0, ymm14
    vmovapd ymm3, ymm2
    vfmsub231pd ymm3, ymm0, ymm14
%endmacro
%macro M2s_b590 0
    vandpd ymm13, ymm14, [u_mzero]
    vxorpd ymm14, ymm14, ymm13
    vxorpd ymm15, ymm15, ymm13
    vmovapd [r12 + 320], ymm13
    vxorpd ymm12, ymm12, ymm12
    vcmppd ymm12, ymm14, ymm12, 0x12
    vmovapd [r12 + 352], ymm12
    vmovapd ymm11, [u_one]
%endmacro
%macro M2s_b591 0
    vmulpd ymm2, ymm0, ymm14
M2s_c35b
%endmacro
%macro M2s_b592 0
M2s_c35b
    vsubpd ymm5, ymm3, ymm5
%endmacro
%macro M2s_b593 0
    vfmsub231pd ymm3, ymm0, ymm14
M2s_b594
    vsubpd ymm5, ymm4, ymm2
    vsubpd ymm5, ymm3, ymm5
    vmovapd ymm14, ymm4
%endmacro
%macro M2s_b594 0
    vmulpd ymm4, ymm1, ymm14
    vfmadd231pd ymm4, ymm0, ymm15
    vaddpd ymm3, ymm3, ymm4
    vaddpd ymm4, ymm2, ymm3
%endmacro
%macro M2s_b595 0
    vpermps ymm1, ymm3, [r8 + 256]
M2s_c77
    vpermps ymm1, ymm3, [r8 + 68]
M2s_c1
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 132]
%endmacro
%macro M2s_b596 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b597 0
M2s_b596
    vpermps ymm1, ymm3, [r8 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 200]
%endmacro
%macro M2s_b598 0
    vpermps ymm1, ymm3, [r8 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c8
    vpermps ymm1, ymm3, [r8 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b599 0
M2s_c35c
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_b59a 0
M2s_c35d
%endmacro
%macro M2s_b59b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b59c 0
M2s_c35e
%endmacro
%macro M2s_b59d 0
M2s_b59f
    vpermps ymm1, ymm3, [r8 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 208]
%endmacro
%macro M2s_b59e 0
M2s_b59d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 240]
M2s_a3f5
    vfmadd231ps ymm4, ymm0, ymm12
M2s_c13
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 84]
M2s_c14
M2s_b5a2
%endmacro
%macro M2s_b59f 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b5a0 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5a1 0
M2s_b5a0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_b5a2 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 148]
M2s_c15
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 212]
%endmacro
%macro M2s_b5a3 0
    vpermps ymm1, ymm3, [r8 + 244]
M2s_a3f6
M2s_c19
    vpermps ymm1, ymm3, [r8 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5a4 0
M2s_b5a5
    vpermps ymm1, ymm3, [r8 + 80]
M2s_c10
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5a5 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_cf
    vpermps ymm1, ymm3, [r8 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_b5a6 0
M2s_c365
%endmacro
%macro M2s_b5a7 0
M2s_c366
%endmacro
%macro M2s_b5a8 0
M2s_c367
%endmacro
%macro M2s_b5a9 0
M2s_c368
%endmacro
%macro M2s_b5aa 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5ab 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 8]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 40]
%endmacro
%macro M2s_b5ac 0
    lea r13, [r8 + r14]
M2s_b5ad
M2s_b5af
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
%endmacro
%macro M2s_b5ad 0
M2s_c369
%endmacro
%macro M2s_b5ae 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b5af
    vpermps ymm1, ymm3, [r13 + 128]
%endmacro
%macro M2s_b5af 0
M2s_c36a
%endmacro
%macro M2s_b5b0 0
M2s_c36b
%endmacro
%macro M2s_b5b1 0
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_b5b2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5b3 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 36]
%endmacro
%macro M2s_b5b4 0
M2s_b5b3
M2s_b5b5
M2s_b5b9
%endmacro
%macro M2s_b5b5 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c36c
    vpermps ymm1, ymm3, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_b5b6 0
M2s_c36c
    vpermps ymm1, ymm3, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 132]
%endmacro
%macro M2s_b5b7 0
M2s_c36d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5b8 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
%endmacro
%macro M2s_b5b9 0
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 164]
%endmacro
%macro M2s_b5ba 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5bb 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5bc 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
%endmacro
%macro M2s_b5bd 0
    vpermps ymm1, ymm3, [r13 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 196]
%endmacro
%macro M2s_b5be 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5bf 0
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b5c0 0
M2s_b5c1
M2s_c36e
%endmacro
%macro M2s_b5c1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5c2 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c36e
    vpermps ymm1, ymm3, [r13 + 136]
%endmacro
%macro M2s_b5c3 0
M2s_c36e
M2s_b5c4
%endmacro
%macro M2s_b5c4 0
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 168]
%endmacro
%macro M2s_b5c5 0
M2s_b5c6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5c6 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 16]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 48]
%endmacro
%macro M2s_b5c7 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 80]
M2s_b5c8
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 144]
%endmacro
%macro M2s_b5c8 0
M2s_c370
%endmacro
%macro M2s_b5c9 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_b5ca 0
    vpermps ymm1, ymm3, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 144]
%endmacro
%macro M2s_b5cb 0
M2s_c371
%endmacro
%macro M2s_b5cc 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5cd 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5ce 0
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 264]
%endmacro
%macro M2s_b5cf 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 12]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b5d0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 172]
%endmacro
%macro M2s_b5d0 0
M2s_c372
%endmacro
%macro M2s_b5d1 0
M2s_c373
%endmacro
%macro M2s_b5d2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5d3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5d4 0
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 268]
%endmacro
%macro M2s_b5d5 0
M2s_c374
%endmacro
%macro M2s_b5d6 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5d7 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5d8 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 208]
M2s_a420
%endmacro
%macro M2s_b5d9 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 176]
M2s_a41f
    vpermps ymm1, ymm3, [r13 + 272]
%endmacro
%macro M2s_b5da 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5db 0
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 272]
%endmacro
%macro M2s_b5dc 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 20]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 52]
%endmacro
%macro M2s_b5dd 0
M2s_b5dc
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 84]
M2s_b5de
    vpermps ymm1, ymm3, [r13 + 180]
%endmacro
%macro M2s_b5de 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
%endmacro
%macro M2s_b5df 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5e0 0
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b5e1 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 24]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 184]
%endmacro
%macro M2s_b5e2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b5e3 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 36]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 68]
%endmacro
%macro M2s_b5e4 0
M2s_b5e6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5e5 0
M2s_b5e4
M2s_b5e8
%endmacro
%macro M2s_b5e6 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 28]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 60]
%endmacro
%macro M2s_b5e7 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c375
    vpermps ymm1, ymm3, [r13 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
%endmacro
%macro M2s_b5e8 0
M2s_c375
    vpermps ymm1, ymm3, [r13 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 188]
%endmacro
%macro M2s_b5e9 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5ea 0
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b5eb 0
M2s_b5ec
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c30
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c31
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_b5ec 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 32]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 64]
%endmacro
%macro M2s_b5ed 0
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b5ee 0
    vpermps ymm1, ymm3, [r13 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 196]
%endmacro
%macro M2s_b5ef 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a432
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5f0 0
M2s_c376
%endmacro
%macro M2s_b5f1 0
M2s_b5f0
M2s_c377
%endmacro
%macro M2s_b5f2 0
M2s_c378
%endmacro
%macro M2s_b5f3 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c36
M2s_b5f5
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b5f4 0
M2s_c379
    vmovdqu ymm3, [rdx + 0]
M2s_b5f5
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5f5 0
    vpermps ymm1, ymm3, [r9 + 36]
M2s_c3e
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5f6 0
M2s_b5f5
    vmovdqu ymm3, [rdx + 96]
M2s_c37b
%endmacro
%macro M2s_b5f7 0
M2s_c37b
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5f8 0
M2s_c37c
%endmacro
%macro M2s_b5f9 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5fa 0
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b5fb 0
M2s_a434
M2s_c44
M2s_c43
M2s_c45
M2s_b5fc
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 232]
M2s_a436
M2s_c3b
    vpermps ymm1, ymm3, [r9 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_b5fc 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 136]
M2s_c46
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 200]
%endmacro
%macro M2s_b5fd 0
M2s_c37d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b5fe 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_b5ff 0
M2s_c37e
%endmacro
%macro M2s_b600 0
M2s_c37f
%endmacro
%macro M2s_b601 0
M2s_b603
    vpermps ymm1, ymm3, [r9 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 204]
%endmacro
%macro M2s_b602 0
M2s_b601
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 236]
M2s_b606
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_b603 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b604 0
    vpermps ymm1, ymm3, [r9 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 172]
%endmacro
%macro M2s_b605 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c4b
    vpermps ymm1, ymm3, [r9 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_b606 0
M2s_a438
    vfmadd231ps ymm6, ymm0, ymm11
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 16]
%endmacro
%macro M2s_b607 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b608 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3b
    vpermps ymm1, ymm3, [r9 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_b609 0
M2s_b608
M2s_c37f
M2s_c382
%endmacro
%macro M2s_b60a 0
M2s_b60c
    vpermps ymm1, ymm3, [r9 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 208]
%endmacro
%macro M2s_b60b 0
M2s_b60a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 240]
M2s_a43a
M2s_c4f
%endmacro
%macro M2s_b60c 0
M2s_c384
%endmacro
%macro M2s_b60d 0
M2s_b60e
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_b60e 0
M2s_c385
%endmacro
%macro M2s_b60f 0
M2s_c383
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_b610 0
M2s_c386
%endmacro
%macro M2s_b611 0
M2s_b613
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c384
    vpermps ymm1, ymm3, [r9 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_b612 0
M2s_c387
%endmacro
%macro M2s_b613 0
M2s_b612
M2s_c388
%endmacro
%macro M2s_b614 0
M2s_c389
%endmacro
%macro M2s_b615 0
M2s_b616
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 148]
M2s_c53
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 212]
%endmacro
%macro M2s_b616 0
M2s_b614
M2s_c52
%endmacro
%macro M2s_b617 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
M2s_c50
M2s_c51
M2s_c54
    vpermps ymm1, ymm3, [r9 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b618 0
M2s_a43d
    vfmadd231ps ymm6, ymm0, ymm13
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 24]
%endmacro
%macro M2s_b619 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b61a 0
M2s_b61b
M2s_c62
    vmovdqu ymm3, [rdx + 128]
M2s_b61c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 248]
%endmacro
%macro M2s_b61b 0
M2s_c38a
%endmacro
%macro M2s_b61c 0
    vpermps ymm1, ymm3, [r9 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 216]
%endmacro
%macro M2s_b61d 0
M2s_a43e
    vfmadd231ps ymm6, ymm0, [rcx + 192]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 28]
%endmacro
%macro M2s_b61e 0
M2s_a440
    vfmadd231ps ymm6, ymm0, [rcx + 224]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 32]
%endmacro
%macro M2s_b61f 0
M2s_c38b
%endmacro
%macro M2s_b620 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b621 0
M2s_c38c
%endmacro
%macro M2s_b622 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b623 0
    vmovdqu ymm3, [rdx + 96]
M2s_c75
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 228]
%endmacro
%macro M2s_b624 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b625 0
    lea r13, [r9 + r14]
M2s_c369
M2s_c36a
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
%endmacro
%macro M2s_b626 0
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b627 0
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b628 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b629 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b62a 0
    vpermps ymm1, ymm3, [r8 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 264]
%endmacro
%macro M2s_b62b 0
M2s_c38d
%endmacro
%macro M2s_b62c 0
    vpermps ymm1, ymm3, [r8 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 292]
%endmacro
%macro M2s_b62d 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 196]
M2s_c76
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 260]
%endmacro
%macro M2s_b62e 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b62f 0
M2s_c38f
%endmacro
%macro M2s_b630 0
    add r9, 288
    dec rcx
M2s_c9e
M2s_c9f
    vmovups ymm11, [rdi+(G_lom+64)]
    vmovups ymm10, [c_ieq]
%endmacro
%macro M2s_b631 0
M2s_cce
M2s_cb2
M2s_cb6
    vpermps ymm10, ymm9, [c_w8o]
M2s_c10a
M2s_cac
M2s_cbb
    vpslld ymm6, ymm5, 5
    vfmadd213ps ymm0, ymm1, [c_q8o1]
    vpslld ymm8, ymm5, 4
%endmacro
%macro M2s_b632 0
    vblendvps ymm3, ymm7, ymm9, ymm6
    vmovups ymm7, [rax+128]
M2s_cd8
M2s_cc0
    vfmadd213ps ymm0, ymm5, [c_q8o0]
    vfmadd231ps ymm4, ymm9, ymm0
%endmacro
%macro M2s_b633 0
M2s_c390
M2s_cbf
M2s_cc2
%endmacro
%macro M2s_b634 0
    sub rcx, 2
M2s_c104
    vmovups ymm12, [c_q8o2]
M2s_c106
    vpsrld ymm2, ymm1, 23
    vpslld ymm3, ymm1, 5
%endmacro
%macro M2s_b635 0
    vpsrld ymm9, ymm1, 20
M2s_c107
    vmovups ymm5, [rax+64]
    vblendvps ymm6, ymm7, ymm8, ymm3
    vpsubd ymm7, ymm0, ymm9
%endmacro
%macro M2s_b636 0
    vmovups ymm12, [c_mone]
M2s_c1af
    vmovups ymm2, [r8+32]
M2s_c1b2
M2s_c1c1
M2s_c1b3
M2s_c1b5
M2s_c1b0
    vmulps ymm1, ymm8, ymm3
    vmovaps [r8+128], ymm1
%endmacro
%macro M2s_b637 0
    jb .fp1s
.fp1e:
M2s_c1d9
M2s_c1b7
M2s_c1b1
    lea r15, [r13 - 16]
    vmovups ymm15, [c_absm]
%endmacro
%macro M2s_b638 0
    vmovups ymm12, [c_mone]
.fp2:
    vmovups ymm0, [r14+rdx*4]
    vmovups ymm1, [r8+96]
%endmacro
%macro M2s_b639 0
    vpsrld ymm8, ymm4, 23
M2s_c1b9
    vpsrld ymm6, ymm11, 17
M2s_c1be
M2s_c1bc
    vfmadd213ps ymm3, ymm1, [c_q8e1]
    vfmadd213ps ymm3, ymm1, [c_q8e0]
%endmacro
%macro M2s_b63a 0
    imul rax, rax, 1
M2s_b63b
M2s_c1e4
M2s_c1e0
    vpermps ymm5, ymm4, [c_w8e]
M2s_c1ee
    vmovaps ymm5, ymm11
    vfmadd213ps ymm5, ymm4, ymm10
%endmacro
%macro M2s_b63b 0
    add rcx, rax
    mov r8, [rbp + 176]
    mov r9, [rbp + 192]
    mov rax, [rbp + 184]
%endmacro
%macro M2s_b63c 0
M2s_c393
M2s_c1df
M2s_c1e1
    vfmadd213ps ymm5, ymm4, ymm9
%endmacro
%macro M2s_b63d 0
    vmulps ymm4, ymm4, ymm3
    vfmadd213ps ymm5, ymm4, ymm3
M2s_c1e5
M2s_c1e6
    mov rdi, [rbp + 136]
    mov rcx, [rbp + 152]
%endmacro
%macro M2s_b63e 0
    mov eax, edx
M2s_c26e
M2s_c26a
    xor esi, esi
M2s_c26c
    cmovg edx, esi
    mov esi, -1
M2s_c26f
%endmacro
%macro M2s_b63f 0
    mov r14, rax
M2s_c286
M2s_c252
M2s_c288
    vcvtsi2sd xmm0, xmm0, rdx
    vmovsd [r12 + 480 + rsi*8], xmm0
    mov rcx, [r12 + 1328]
%endmacro
%macro M2s_b640 0
    vshufps xmm1, xmm15, xmm15, 85
    mov rcx, [r12 + 1352]
    vfmadd231ss xmm0, xmm1, [rcx + rax + 32]
    vshufps xmm1, xmm15, xmm15, 170
%endmacro
%macro M2s_b641 0
    mov [r12 + 1288], rsi
M2s_c289
M2s_c28b
    vmovsd [r12 + 416 + rsi*8], xmm0
M2s_c28e
    jb .t3z
    call .t3b
%endmacro
%macro M2s_b642 0
    vfmadd231pd ymm6, ymm0, ymm3
M2s_c295
    vmovapd ymm14, ymm6
    vmovapd ymm15, ymm7
    call .xoe
%endmacro
%macro M2s_b643 0
    vpermps ymm1, ymm3, [r8 + 288]
M2s_c78
M2s_c2
M2s_c3
M2s_c35d
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b644 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c4
M2s_c7
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b645 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b646 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c9
M2s_ca
M2s_cb
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b647 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b648 0
M2s_b647
    vpermps ymm1, ymm3, [r8 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
M2s_cd
M2s_c35e
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b649 0
    vpermps ymm1, ymm3, [r8 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_cc
M2s_cd
M2s_c35e
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 300]
%endmacro
%macro M2s_b64a 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 300]
M2s_c364
M2s_c362
M2s_c11
M2s_c12
M2s_c365
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 304]
%endmacro
%macro M2s_b64b 0
M2s_b64c
M2s_c360
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b64c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c35f
    vpermps ymm1, ymm3, [r8 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_b64d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 244]
M2s_c366
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b64e 0
M2s_c39b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b64f 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm13
%endmacro
%macro M2s_b650 0
    vmovdqu ymm3, [rdx + 192]
M2s_c38d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 312]
%endmacro
%macro M2s_b651 0
M2s_b650
M2s_c1d
M2s_c20
M2s_c21
M2s_c23
M2s_c24
%endmacro
%macro M2s_b652 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 312]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b653 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 312]
M2s_c1d
M2s_c20
M2s_c21
M2s_c23
M2s_c24
M2s_c367
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 316]
%endmacro
%macro M2s_b654 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 224]
%endmacro
%macro M2s_b655 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 256]
%endmacro
%macro M2s_b656 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 256]
M2s_c368
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 320]
%endmacro
%macro M2s_b657 0
M2s_c39c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b658 0
M2s_c39d
%endmacro
%macro M2s_b659 0
M2s_b658
    vpermps ymm1, ymm3, [r8 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 324]
%endmacro
%macro M2s_b65a 0
M2s_a471
M2s_a474
M2s_a47b
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b65b 0
M2s_c39e
%endmacro
%macro M2s_b65c 0
M2s_b65b
M2s_b65f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b65d 0
M2s_c39f
M2s_c3a1
%endmacro
%macro M2s_b65e 0
M2s_c3a0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b65f 0
M2s_c3a2
%endmacro
%macro M2s_b660 0
M2s_c3a3
%endmacro
%macro M2s_b661 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b662 0
    vpermps ymm1, ymm3, [r8 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 200]
%endmacro
%macro M2s_b663 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b664
    vpermps ymm1, ymm3, [r8 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_b664 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_b665 0
M2s_c3a4
%endmacro
%macro M2s_b666 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b667 0
    vpermps ymm1, ymm3, [r8 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 264]
%endmacro
%macro M2s_b668 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b669 0
    lea r13, [r8 + r14]
M2s_b66a
M2s_b66c
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
%endmacro
%macro M2s_b66a 0
M2s_c3a5
%endmacro
%macro M2s_b66b 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b66c
    vpermps ymm1, ymm3, [r13 + 128]
%endmacro
%macro M2s_b66c 0
M2s_c3a6
%endmacro
%macro M2s_b66d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
M2s_b66e
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b66e 0
M2s_c3a7
%endmacro
%macro M2s_b66f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b670 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b671 0
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_b672 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 288]
M2s_b673
M2s_b675
    vpermps ymm1, ymm3, [r13 + 164]
%endmacro
%macro M2s_b673 0
    vpermps ymm1, ymm3, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3a8
    vpermps ymm1, ymm3, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b674 0
M2s_c3a8
M2s_c3a9
%endmacro
%macro M2s_b675 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
%endmacro
%macro M2s_b676 0
M2s_c3aa
%endmacro
%macro M2s_b677 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
M2s_c3aa
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b678 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 196]
M2s_b679
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b679 0
M2s_c3ac
%endmacro
%macro M2s_b67a 0
M2s_c3ad
%endmacro
%macro M2s_b67b 0
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 292]
%endmacro
%macro M2s_b67c 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 8]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b67d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 168]
%endmacro
%macro M2s_b67d 0
M2s_c3ae
%endmacro
%macro M2s_b67e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 168]
M2s_b67f
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b67f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b680 0
M2s_c3af
%endmacro
%macro M2s_b681 0
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 296]
%endmacro
%macro M2s_b682 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 12]
    vmovdqu ymm3, [rdx + 288]
M2s_b683
M2s_b685
    vpermps ymm1, ymm3, [r13 + 172]
%endmacro
%macro M2s_b683 0
    vpermps ymm1, ymm3, [r13 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3b0
    vpermps ymm1, ymm3, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b684 0
M2s_c3b0
M2s_c3b1
%endmacro
%macro M2s_b685 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
%endmacro
%macro M2s_b686 0
M2s_c3b2
%endmacro
%macro M2s_b687 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 20]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 52]
%endmacro
%macro M2s_b688 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
M2s_c3b2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b689 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 204]
M2s_b68a
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b68a 0
M2s_c3b4
%endmacro
%macro M2s_b68b 0
M2s_c3b5
%endmacro
%macro M2s_b68c 0
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 300]
%endmacro
%macro M2s_b68d 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 16]
M2s_b68e
M2s_b690
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 176]
%endmacro
%macro M2s_b68e 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3b6
    vpermps ymm1, ymm3, [r13 + 112]
%endmacro
%macro M2s_b68f 0
M2s_c3b6
M2s_c3b7
%endmacro
%macro M2s_b690 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b691 0
M2s_c3b8
%endmacro
%macro M2s_b692 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3b8
    vpermps ymm1, ymm3, [r13 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b693 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
M2s_b694
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b694 0
    vpermps ymm1, ymm3, [r13 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 240]
%endmacro
%macro M2s_b695 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b696 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b697 0
M2s_c3ba
%endmacro
%macro M2s_b698 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3bb
    vpermps ymm1, ymm3, [r13 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
%endmacro
%macro M2s_b699 0
M2s_c3bb
M2s_c3bd
%endmacro
%macro M2s_b69a 0
M2s_c3bc
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
%endmacro
%macro M2s_b69b 0
    vpermps ymm1, ymm3, [r13 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 180]
%endmacro
%macro M2s_b69c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 180]
M2s_b69d
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b69d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b69e 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 28]
M2s_c3be
    vpermps ymm1, ymm3, [r13 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b69f 0
M2s_c3be
    vpermps ymm1, ymm3, [r13 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 124]
%endmacro
%macro M2s_b6a0 0
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b6a1 0
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 308]
%endmacro
%macro M2s_b6a2 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 24]
M2s_b6a3
M2s_b6a4
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 184]
%endmacro
%macro M2s_b6a3 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 120]
%endmacro
%macro M2s_b6a4 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6a5 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
M2s_b6a6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b6a6 0
    vpermps ymm1, ymm3, [r13 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 248]
%endmacro
%macro M2s_b6a7 0
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 312]
%endmacro
%macro M2s_b6a8 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 124]
M2s_b6a9
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 188]
%endmacro
%macro M2s_b6a9 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6aa 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
%endmacro
%macro M2s_b6ab 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_c36c
    vpermps ymm1, ymm3, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6ac 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
M2s_b6ad
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b6ad 0
    vpermps ymm1, ymm3, [r13 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 252]
%endmacro
%macro M2s_b6ae 0
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 316]
%endmacro
%macro M2s_b6af 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 32]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c36a
    vpermps ymm1, ymm3, [r13 + 128]
M2s_c36b
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_b6b0 0
M2s_c3bf
%endmacro
%macro M2s_b6b1 0
M2s_c3c0
%endmacro
%macro M2s_b6b2 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_c36f
M2s_c371
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 200]
%endmacro
%macro M2s_b6b3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6b4 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 672]
M2s_c3c1
    vpermps ymm0, ymm3, [r9 + 0]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_b6b5 0
M2s_c3c1
M2s_c3c3
%endmacro
%macro M2s_b6b6 0
M2s_c3c2
    vpermps ymm1, ymm3, [r9 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 64]
%endmacro
%macro M2s_b6b7 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6b8 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b6ba
M2s_b6bc
M2s_c47
    vpermps ymm1, ymm3, [r9 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_b6b9 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b6ba 0
M2s_b6b9
    vpermps ymm1, ymm3, [r9 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 292]
%endmacro
%macro M2s_b6bb 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c44
M2s_c43
M2s_c45
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b6bc 0
M2s_c3c4
    vpermps ymm1, ymm3, [r9 + 72]
M2s_c45
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6bd 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b6be 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b6bf 0
    vpermps ymm1, ymm3, [r9 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 264]
%endmacro
%macro M2s_b6c0 0
    vpermps ymm1, ymm3, [r9 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 288]
%endmacro
%macro M2s_b6c1 0
    vpermps ymm1, ymm3, [r9 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 296]
%endmacro
%macro M2s_b6c2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6c3 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 296]
M2s_c381
M2s_c37f
M2s_c382
M2s_c4b
M2s_c4a
M2s_c386
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 300]
%endmacro
%macro M2s_b6c4 0
M2s_c3c7
M2s_c380
    vpermps ymm1, ymm3, [r9 + 236]
M2s_c386
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6c5 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, ymm11
%endmacro
%macro M2s_b6c6 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, ymm12
%endmacro
%macro M2s_b6c7 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3ca
%endmacro
%macro M2s_b6c8 0
M2s_c3ca
    vpermps ymm1, ymm3, [r9 + 304]
%endmacro
%macro M2s_b6c9 0
M2s_b6ca
M2s_c3cb
%endmacro
%macro M2s_b6ca 0
    vpermps ymm1, ymm3, [r9 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 272]
%endmacro
%macro M2s_b6cb 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b6cc
M2s_c385
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6cc 0
    vmovdqu ymm3, [rdx + 32]
M2s_c388
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 144]
%endmacro
%macro M2s_b6cd 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, ymm13
%endmacro
%macro M2s_b6ce 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b6cf 0
M2s_b6ce
    vpermps ymm1, ymm3, [r9 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 308]
%endmacro
%macro M2s_b6d0 0
    vpermps ymm1, ymm3, [r9 + 244]
M2s_c38b
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6d1 0
M2s_b6d0
M2s_c5e
    vpermps ymm1, ymm3, [r9 + 56]
M2s_b6d2
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6d2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b6d3
M2s_c65
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6d3 0
    vmovdqu ymm3, [rdx + 32]
M2s_c38a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 152]
%endmacro
%macro M2s_b6d4 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 312]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 192]
%endmacro
%macro M2s_b6d5 0
    vpermps ymm1, ymm3, [r9 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 280]
%endmacro
%macro M2s_b6d6 0
M2s_b6d5
M2s_c3cc
%endmacro
%macro M2s_b6d7 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b6d8 0
M2s_b6d7
    vpermps ymm1, ymm3, [r9 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 316]
%endmacro
%macro M2s_b6d9 0
    vpermps ymm1, ymm3, [r9 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 284]
%endmacro
%macro M2s_b6da 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 224]
%endmacro
%macro M2s_b6db 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 256]
%endmacro
%macro M2s_b6dc 0
    vmovdqu ymm3, [rdx + 192]
M2s_c38f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 320]
%endmacro
%macro M2s_b6dd 0
M2s_b6dc
M2s_c63
M2s_c70
M2s_c74
M2s_c38e
%endmacro
%macro M2s_b6de 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6df 0
    vpermps ymm1, ymm3, [r9 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 324]
%endmacro
%macro M2s_b6e0 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 288]
%endmacro
%macro M2s_b6e1 0
M2s_a4cc
M2s_a4d0
M2s_a4d7
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b6e2 0
M2s_b6e3
M2s_b6e6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6e3 0
M2s_c3cd
%endmacro
%macro M2s_b6e4 0
M2s_c3ce
M2s_c3d0
%endmacro
%macro M2s_b6e5 0
M2s_c3cf
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6e6 0
M2s_c3d1
%endmacro
%macro M2s_b6e7 0
M2s_c3d2
%endmacro
%macro M2s_b6e8 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b6e9 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b6ea 0
    vpermps ymm1, ymm3, [r9 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 200]
%endmacro
%macro M2s_b6eb 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b6ec
    vpermps ymm1, ymm3, [r9 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_b6ec 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_b6ed 0
    vpermps ymm1, ymm3, [r9 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 232]
%endmacro
%macro M2s_b6ee 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6ef 0
    vpermps ymm1, ymm3, [r9 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 264]
%endmacro
%macro M2s_b6f0 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b6f1 0
M2s_a4d5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 328]
%endmacro
%macro M2s_b6f2 0
    vpermps ymm1, ymm3, [r9 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 296]
%endmacro
%macro M2s_b6f3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b6f4 0
    lea r13, [r9 + r14]
M2s_c3a5
M2s_c3a6
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
%endmacro
%macro M2s_b6f5 0
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 256]
M2s_c3bf
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 320]
%endmacro
%macro M2s_b6f6 0
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 260]
M2s_c3c0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 324]
%endmacro
%macro M2s_b6f7 0
    vaddps ymm0, ymm6, ymm7
M2s_b6f8
M2s_c7a
    vperm2f128 ymm0, ymm14, ymm5, 0x21
    vpalignr ymm0, ymm5, ymm0, 12
    vaddps ymm4, ymm4, ymm0
%endmacro
%macro M2s_b6f8 0
    vpermpd ymm0, ymm0, 0xd8
M2s_c3d4
%endmacro
%macro M2s_b6f9 0
M2s_c3d3
    vmovaps ymm14, ymm5
%endmacro
%macro M2s_b6fa 0
    vmovups [r11 + 0], ymm0
    vaddps ymm4, ymm4, ymm6
    vaddps ymm5, ymm5, ymm7
    vpermpd ymm4, ymm4, 0xd8
%endmacro
%macro M2s_b6fb 0
M2s_c3d4
M2s_c7a
M2s_c7c
    add r8, rbx
%endmacro
%macro M2s_b6fc 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 672]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
%endmacro
%macro M2s_b6fd 0
M2s_a4e9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 312]
%endmacro
%macro M2s_b6fe 0
    mov [rbp + 232], rax
    mov rcx, [rdi + G_wo]
M2s_c81
    cmp rcx, rdx
    cmova rcx, rdx
M2s_c82
%endmacro
%macro M2s_b6ff 0
    vmovups ymm12, [c_q8o2]
.i2l1:
M2s_ce2
M2s_cb4
M2s_cb8
M2s_ce0
M2s_cad
M2s_cbc
    vfmadd213ps ymm0, ymm1, [c_q8o1]
    vpslld ymm8, ymm5, 4
%endmacro
%macro M2s_b700 0
    vpermps ymm4, ymm10, [c_rxo]
    vorps ymm10, ymm11, ymm3
M2s_ce3
M2s_ce5
    vmulps ymm9, ymm5, ymm4
    vandps ymm1, ymm7, [c_sgn]
%endmacro
%macro M2s_b701 0
    vfmadd231ps ymm4, ymm9, ymm0
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+416]
    vandps ymm6, ymm3, [r9+448]
%endmacro
%macro M2s_b702 0
    sub rcx, 2
    cmp rcx, 2
    jae .i2c0
.i2c0r:
%endmacro
%macro M2s_b703 0
M2s_b702
    test rcx, rcx
    jz .i2c0e
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_mone]
%endmacro
%macro M2s_b704 0
    vmovups ymm12, [c_q8o2]
M2s_c10b
M2s_cb6
M2s_c107
M2s_cdc
M2s_cdd
M2s_cd2
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
    vmulps ymm4, ymm3, [r9+32]
%endmacro
%macro M2s_b705 0
    div r9
M2s_c394
M2s_c287
    add rdx, rcx
M2s_c288
    vcvtsi2sd xmm0, xmm0, rdx
    vmovsd [r12 + 480 + rsi*8], xmm0
%endmacro
%macro M2s_b706 0
    vmulss xmm0, xmm15, [rcx + rax + 32]
    vshufps xmm1, xmm15, xmm15, 85
    mov rcx, [r12 + 1352]
    vfmadd231ss xmm0, xmm1, [rcx + rax + 32]
%endmacro
%macro M2s_b707 0
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b708 0
M2s_b709
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
M2s_c32
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c33
    vpermps ymm1, ymm3, [r13 + 200]
%endmacro
%macro M2s_b709 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 40]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 72]
%endmacro
%macro M2s_b70a 0
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b70b 0
    vmovups ymm13, [c_q8o3]
M2s_c3d5
M2s_cdb
M2s_ccd
M2s_cd1
    vfmadd213ps ymm0, ymm1, [c_q8o0]
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
%endmacro
%macro M2s_b70c 0
M2s_c112
%endmacro
%macro M2s_b70d 0
    vmulps ymm8, ymm4, [r9+416]
    vandps ymm6, ymm3, [r9+448]
M2s_ce6
    add r9, 576
    sub rcx, 2
%endmacro
%macro M2s_b70e 0
    vpermps ymm1, ymm3, [r8 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 216]
%endmacro
%macro M2s_b70f 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 196]
M2s_c2f
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 260]
%endmacro
%macro M2s_b710 0
M2s_c3d6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b711 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b712
    vpermps ymm1, ymm3, [r8 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b712 0
M2s_c3d7
%endmacro
%macro M2s_b713 0
    vmovdqu ymm3, [rdx + 128]
M2s_b714
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 268]
%endmacro
%macro M2s_b714 0
M2s_c3d8
%endmacro
%macro M2s_b715 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b716 0
M2s_c3d9
%endmacro
%macro M2s_b717 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b718 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_c372
M2s_c373
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 204]
%endmacro
%macro M2s_b719 0
M2s_c3da
%endmacro
%macro M2s_b71a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b71b
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b71c
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b71b 0
    vfmadd231ps ymm5, ymm0, [rcx + 736]
M2s_c3c1
    vpermps ymm0, ymm3, [r9 + 0]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 32]
%endmacro
%macro M2s_b71c 0
M2s_c3db
%endmacro
%macro M2s_b71d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b71e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
M2s_c3c9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b71f 0
M2s_c3c8
%endmacro
%macro M2s_b720 0
M2s_c3cc
%endmacro
%macro M2s_b721 0
M2s_c3dc
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b722 0
M2s_c3dd
%endmacro
%macro M2s_b723 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b724 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 352]
%endmacro
%macro M2s_b725 0
M2s_c3de
    vpermps ymm1, ymm3, [r9 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 268]
%endmacro
%macro M2s_b726 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b727 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b728 0
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 268]
M2s_c3da
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 332]
%endmacro
%macro M2s_b729 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 736]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
%endmacro
%macro M2s_b72a 0
    vmovaps ymm14, ymm5
M2s_c7b
    vpermps ymm0, ymm3, [r8 + 0]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 32]
%endmacro
%macro M2s_b72b 0
    vpermps ymm1, ymm3, [r8 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 308]
%endmacro
%macro M2s_b72c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b72d
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3d7
    vpermps ymm1, ymm3, [r8 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b72d 0
    vfmadd231ps ymm4, ymm0, [rcx + 320]
M2s_c3d6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 108]
%endmacro
%macro M2s_b72e 0
M2s_c3cb
%endmacro
%macro M2s_b72f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b730 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b731
M2s_c3dd
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b731 0
    vfmadd231ps ymm6, ymm0, [rcx + 320]
M2s_c3dc
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 108]
%endmacro
%macro M2s_b732 0
    add r9, 576
M2s_c391
M2s_cb4
M2s_cd0
M2s_cca
    vpsubd ymm7, ymm0, ymm9
    vblendvps ymm8, ymm2, ymm6, ymm4
    vfmadd213ps ymm1, ymm7, ymm14
%endmacro
%macro M2s_b733 0
    vmovups ymm12, [c_q8o2]
M2s_c113
M2s_cb6
M2s_c107
M2s_ce9
M2s_cdd
M2s_cd2
    vfmadd231ps ymm3, ymm2, ymm0
    vorps ymm6, ymm9, ymm3
    vmulps ymm4, ymm3, [r9+128]
%endmacro
%macro M2s_b734 0
    vmovaps ymm3, [c_half]
    vmovdqu ymm13, [c_i512]
    vmovdqu ymm14, [c_i1023]
    vpxor ymm15, ymm15, ymm15
%endmacro
%macro M2s_b735 0
    vpcmpeqb ymm1, ymm7, [rdi + G_ms + 0]
    vpcmpeqb ymm2, ymm7, [rdi + G_ms + 32]
M2s_c124
M2s_c120
M2s_c121
    pext rdx, r12, rdx
    vmovq xmm0, rdx
%endmacro
%macro M2s_b736 0
M2s_a544
    vpermps ymm1, ymm3, [r8 + 324]
M2s_c396
    vpermps ymm1, ymm3, [r8 + 72]
M2s_c7
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b737 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b738 0
    vpermps ymm1, ymm3, [r8 + 328]
M2s_c398
M2s_cc
M2s_cd
M2s_c35e
M2s_a548
    vpermps ymm1, ymm3, [r8 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b739 0
    vpermps ymm1, ymm3, [r8 + 332]
M2s_c364
M2s_c361
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 144]
%endmacro
%macro M2s_b73a 0
    vpermps ymm1, ymm3, [r8 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 328]
%endmacro
%macro M2s_b73b 0
    vmovdqu ymm3, [rdx + 288]
M2s_c3e4
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 76]
M2s_cb
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b73c 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b73d 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b73e 0
M2s_c3e6
%endmacro
%macro M2s_b73f 0
    vpermps ymm1, ymm3, [r8 + 336]
M2s_c39a
M2s_c360
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 148]
%endmacro
%macro M2s_b740 0
    vpermps ymm1, ymm3, [r8 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c19
M2s_c1a
M2s_c1c
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 152]
%endmacro
%macro M2s_b741 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b742 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b743 0
    vpermps ymm1, ymm3, [r8 + 344]
M2s_c1d
M2s_c20
M2s_c21
M2s_c23
M2s_c24
M2s_c367
M2s_a551
    vpermps ymm1, ymm3, [r8 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b744 0
    vpermps ymm1, ymm3, [r8 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c25
M2s_c27
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 160]
%endmacro
%macro M2s_b745 0
    vmovdqu ymm3, [rdx + 288]
M2s_c3eb
    vmovdqu ymm3, [rdx + 32]
M2s_c20
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b746 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b747 0
M2s_c3ed
%endmacro
%macro M2s_b748 0
    vpermps ymm1, ymm3, [r8 + 352]
M2s_c29
M2s_c2b
    vpermps ymm1, ymm3, [r8 + 100]
M2s_c2d
    vmovdqu ymm3, [rdx + 96]
M2s_c2e
M2s_c2f
M2s_c39d
    vpermps ymm1, ymm3, [r8 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a557
    vpermps ymm1, ymm3, [r8 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b749 0
M2s_a557
    vpermps ymm1, ymm3, [r8 + 356]
M2s_c39e
M2s_c3a2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b74a 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b74b 0
M2s_c3ee
%endmacro
%macro M2s_b74c 0
M2s_b74d
M2s_c3a4
%endmacro
%macro M2s_b74d 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b74e 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b74f 0
M2s_c3ef
%endmacro
%macro M2s_b750 0
    lea r13, [r8 + r14]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 0]
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_b751 0
M2s_c3f0
%endmacro
%macro M2s_b752 0
M2s_c3f1
%endmacro
%macro M2s_b753 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b754 0
    vpermps ymm1, ymm3, [r8 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 364]
%endmacro
%macro M2s_b755 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a564
M2s_a565
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_b756 0
M2s_c3f2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
M2s_b757
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b757 0
M2s_c3f3
%endmacro
%macro M2s_b758 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b759 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 8]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 40]
%endmacro
%macro M2s_b75a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b75b 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 36]
%endmacro
%macro M2s_b75c 0
M2s_c3f4
M2s_c3f5
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b75d 0
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 260]
%endmacro
%macro M2s_b75e 0
M2s_c3f6
%endmacro
%macro M2s_b75f 0
M2s_c3f7
M2s_c3f8
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b760 0
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
M2s_b761
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b761 0
M2s_c3f9
%endmacro
%macro M2s_b762 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 16]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 48]
%endmacro
%macro M2s_b763 0
M2s_c3fa
%endmacro
%macro M2s_b764 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 12]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 44]
%endmacro
%macro M2s_b765 0
M2s_c3fb
M2s_c3fc
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b766 0
M2s_c3fd
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b767 0
M2s_c3fe
M2s_c3ff
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b768 0
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
M2s_b769
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b769 0
M2s_c400
%endmacro
%macro M2s_b76a 0
M2s_b76b
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b76c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 184]
%endmacro
%macro M2s_b76b 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 24]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 56]
%endmacro
%macro M2s_b76c 0
M2s_c401
%endmacro
%macro M2s_b76d 0
M2s_c402
%endmacro
%macro M2s_b76e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b76f 0
M2s_c403
%endmacro
%macro M2s_b770 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 20]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 52]
%endmacro
%macro M2s_b771 0
M2s_c404
M2s_c405
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b772 0
M2s_c406
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b773 0
M2s_a583
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b774 0
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b775 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 32]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3a6
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
M2s_c3a7
%endmacro
%macro M2s_b776 0
M2s_c407
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 312]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b777 0
M2s_b778
M2s_b779
M2s_b77a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b778 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 28]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 60]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 188]
%endmacro
%macro M2s_b779 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_b77a 0
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 316]
%endmacro
%macro M2s_b77b 0
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 320]
%endmacro
%macro M2s_b77c 0
M2s_b77b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b77d 0
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_b77e 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_c3ae
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 200]
%endmacro
%macro M2s_b77f 0
M2s_b780
M2s_c3ac
M2s_c3ad
M2s_b781
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b780 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_c3a8
M2s_c3a9
M2s_c3ab
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 196]
%endmacro
%macro M2s_b781 0
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 324]
%endmacro
%macro M2s_b782 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3af
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_b783 0
M2s_b782
    vpermps ymm1, ymm3, [r13 + 296]
M2s_b784
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b784 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b785 0
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_b786 0
M2s_b787
M2s_c3b4
M2s_c3b5
M2s_b788
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b787 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_c3b0
M2s_c3b1
M2s_c3b3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 204]
%endmacro
%macro M2s_b788 0
    vpermps ymm1, ymm3, [r13 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 332]
%endmacro
%macro M2s_b789 0
    vpermps ymm1, ymm3, [r9 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 320]
%endmacro
%macro M2s_b78a 0
M2s_a58e
    vpermps ymm1, ymm3, [r9 + 324]
M2s_c3c4
M2s_c3c5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b78b 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b78c 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b78d 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 328]
M2s_c381
M2s_c37f
M2s_c382
M2s_c4b
M2s_c4a
M2s_c386
M2s_a593
    vpermps ymm1, ymm3, [r9 + 332]
%endmacro
%macro M2s_b78e 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b78f 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b790 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b791 0
M2s_a598
    vpermps ymm1, ymm3, [r9 + 340]
M2s_b792
M2s_c38a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b792 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c5e
    vpermps ymm1, ymm3, [r9 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_b793 0
M2s_c408
M2s_c61
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b794 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b795 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 312]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b796 0
    vpermps ymm1, ymm3, [r9 + 344]
M2s_c5a
M2s_c69
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 156]
%endmacro
%macro M2s_b797 0
M2s_a59e
    vpermps ymm1, ymm3, [r9 + 348]
M2s_c5c
M2s_c58
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b798 0
M2s_c40b
M2s_c57
M2s_c6e
%endmacro
%macro M2s_b799 0
    vpermps ymm1, ymm3, [r9 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c6f
    vpermps ymm1, ymm3, [r9 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b79a 0
M2s_c40c
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_b79b 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b79c 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b79d 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 352]
M2s_c63
M2s_c70
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b79e 0
    vpermps ymm1, ymm3, [r9 + 356]
M2s_c3cd
M2s_c3d1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 168]
%endmacro
%macro M2s_b79f 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b7a0 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7a1 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b7a2 0
    vpermps ymm1, ymm3, [r9 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3e2
M2s_c3dd
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 172]
%endmacro
%macro M2s_b7a3 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3de
    vpermps ymm1, ymm3, [r9 + 236]
%endmacro
%macro M2s_b7a4 0
M2s_c40e
M2s_c3df
%endmacro
%macro M2s_b7a5 0
    lea r13, [r9 + r14]
M2s_c3f0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3f2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
%endmacro
%macro M2s_b7a6 0
M2s_c40f
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
M2s_c3f3
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7a7 0
    vpermps ymm1, ymm3, [r9 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 300]
%endmacro
%macro M2s_b7a8 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b7a9 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
M2s_c3f1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_b7aa 0
M2s_c412
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 288]
%endmacro
%macro M2s_b7ab 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3f4
M2s_c3f5
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7ac 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3f7
M2s_c3f8
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7ad 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3fb
M2s_c3fc
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7ae 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3fe
M2s_c3ff
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7af 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c404
M2s_c405
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7b0 0
    vmovdqu ymm3, [rdx + 512]
M2s_c407
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 312]
%endmacro
%macro M2s_b7b1 0
    vpermps ymm1, ymm3, [r13 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 328]
%endmacro
%macro M2s_b7b2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3e6
M2s_c3e7
M2s_c15
M2s_c16
    vpermps ymm1, ymm3, [r8 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b7b3 0
    vmovdqu ymm3, [rdx + 288]
M2s_c3e8
    vmovdqu ymm3, [rdx + 32]
M2s_c1b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b7b4 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_b7b5 0
    vpermps ymm1, ymm3, [r8 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 312]
%endmacro
%macro M2s_b7b6 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c28
    vpermps ymm1, ymm3, [r8 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_b7b7 0
    vfmadd213ps ymm4, ymm1, [c_q8e0]
M2s_c1c2
M2s_c1b6
    jb .fp2s
.fp2e:
M2s_c1e7
M2s_c1c7
M2s_c1c4
    xor edx, edx
%endmacro
%macro M2s_b7b8 0
    vmovups ymm7, [c_c8]
.fp3:
M2s_c1c8
M2s_c1cb
    vmovaps ymm0, ymm10
    vfmadd231ps ymm0, ymm3, ymm11
%endmacro
%macro M2s_b7b9 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 44]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 76]
%endmacro
%macro M2s_b7ba 0
M2s_c414
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7bb 0
M2s_c415
%endmacro
%macro M2s_b7bc 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b7bd 0
M2s_b7be
M2s_b7c0
%endmacro
%macro M2s_b7be 0
M2s_c416
%endmacro
%macro M2s_b7bf 0
    vpermps ymm1, ymm3, [r8 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 240]
%endmacro
%macro M2s_b7c0 0
    vpermps ymm1, ymm3, [r8 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 272]
%endmacro
%macro M2s_b7c1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 800]
    vshufps ymm2, ymm4, ymm5, 0x88
    vshufps ymm5, ymm4, ymm5, 0xdd
%endmacro
%macro M2s_b7c2 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 48]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 80]
M2s_c370
    vmovdqu ymm3, [rdx + 352]
M2s_c374
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 208]
%endmacro
%macro M2s_b7c3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7c4 0
M2s_c417
M2s_c41b
    vpermps ymm1, ymm3, [r9 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 208]
%endmacro
%macro M2s_b7c5 0
    vpermps ymm1, ymm3, [r9 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 240]
%endmacro
%macro M2s_b7c6 0
M2s_b7c5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7c7 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7c8 0
M2s_c41c
%endmacro
%macro M2s_b7c9 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b7ca 0
M2s_c41d
%endmacro
%macro M2s_b7cb 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b7cc 0
    vpermps ymm1, ymm3, [r9 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 336]
%endmacro
%macro M2s_b7cd 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 800]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
%endmacro
%macro M2s_b7ce 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b7cf
M2s_c415
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7cf 0
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2s_c414
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 112]
%endmacro
%macro M2s_b7d0 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b7d1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7d2 0
M2s_c41f
%endmacro
%macro M2s_b7d3 0
    vpermps ymm1, ymm3, [r8 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 304]
%endmacro
%macro M2s_b7d4 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7d5 0
    vpermps ymm1, ymm3, [r13 + 32]
M2s_c40f
M2s_c410
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_b7d6 0
M2s_c420
M2s_c3f9
%endmacro
%macro M2s_b7d7 0
    vmovdqu ymm3, [rdx + 512]
M2s_c3fd
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 300]
%endmacro
%macro M2s_b7d8 0
M2s_c422
M2s_c400
%endmacro
%macro M2s_b7d9 0
    vmovdqu ymm3, [rdx + 512]
M2s_c406
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 308]
%endmacro
%macro M2s_b7da 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7db 0
M2s_b7dc
M2s_c378
    vpermps ymm1, ymm3, [r9 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 256]
%endmacro
%macro M2s_b7dc 0
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3c
    vpermps ymm1, ymm3, [r9 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7dd 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 48]
M2s_c3b6
M2s_c3b7
M2s_c3b9
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 208]
%endmacro
%macro M2s_b7de 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7df 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c6c
M2s_c6b
M2s_c38c
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7e0 0
    vpermps ymm1, ymm3, [r9 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 320]
%endmacro
%macro M2s_b7e1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 352]
M2s_c417
M2s_c41b
    vpermps ymm1, ymm3, [r9 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7e2 0
M2s_c425
M2s_c41a
%endmacro
%macro M2s_b7e3 0
M2s_b7e5
M2s_c41d
M2s_c426
%endmacro
%macro M2s_b7e4 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_b7e5 0
M2s_b7e4
M2s_c41c
%endmacro
%macro M2s_b7e6 0
    vpermps ymm1, ymm3, [r9 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 368]
%endmacro
%macro M2s_b7e7 0
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 320]
%endmacro
%macro M2s_b7e8 0
M2s_c427
%endmacro
%macro M2s_b7e9 0
    vmovdqu ymm3, [rdx + 512]
M2s_c3ba
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 336]
%endmacro
%macro M2s_b7ea 0
M2s_a60e
M2s_c396
M2s_c3e3
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 136]
%endmacro
%macro M2s_b7eb 0
M2s_c428
%endmacro
%macro M2s_b7ec 0
    vpermps ymm1, ymm3, [r8 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 360]
%endmacro
%macro M2s_b7ed 0
    vpermps ymm1, ymm3, [r8 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 364]
%endmacro
%macro M2s_b7ee 0
M2s_a616
M2s_c3e9
M2s_c1b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 152]
%endmacro
%macro M2s_b7ef 0
    vpermps ymm1, ymm3, [r8 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 372]
%endmacro
%macro M2s_b7f0 0
M2s_a61b
M2s_c3ec
    vpermps ymm1, ymm3, [r8 + 96]
M2s_c27
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 160]
%endmacro
%macro M2s_b7f1 0
    vpermps ymm1, ymm3, [r8 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 376]
%endmacro
%macro M2s_b7f2 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 376]
M2s_c1d
M2s_c20
M2s_c21
M2s_c23
M2s_c24
M2s_c367
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 316]
%endmacro
%macro M2s_b7f3 0
    vpermps ymm1, ymm3, [r8 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 380]
%endmacro
%macro M2s_b7f4 0
M2s_a620
M2s_c39e
M2s_c3a2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 168]
%endmacro
%macro M2s_b7f5 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b7f6 0
    vpermps ymm1, ymm3, [r8 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 388]
%endmacro
%macro M2s_b7f7 0
M2s_a625
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c41e
M2s_c415
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 176]
%endmacro
%macro M2s_b7f8 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3e1
M2s_c3e0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
M2s_c3d8
M2s_c3d9
M2s_c3ef
    vpermps ymm1, ymm3, [r8 + 332]
%endmacro
%macro M2s_b7f9 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c416
    vpermps ymm1, ymm3, [r8 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_b7fa 0
    vpermps ymm1, ymm3, [r8 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 396]
%endmacro
%macro M2s_b7fb 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 36]
%endmacro
%macro M2s_b7fc 0
    lea r13, [r8 + r14]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 0]
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_b7fd 0
M2s_c429
%endmacro
%macro M2s_b7fe 0
M2s_b7fd
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a62c
M2s_a62e
    vmovdqu ymm3, [rdx + 640]
%endmacro
%macro M2s_b7ff 0
M2s_c42a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
M2s_b800
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_b800 0
M2s_c42b
%endmacro
%macro M2s_b801 0
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_b802 0
M2s_c42c
M2s_b803
%endmacro
%macro M2s_b803 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b804 0
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_b805 0
M2s_c42d
M2s_c42e
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_b806 0
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b807
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b807 0
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_b808 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 12]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 44]
%endmacro
%macro M2s_b809 0
M2s_b808
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b80a 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b80b
    vpermps ymm1, ymm3, [r13 + 140]
%endmacro
%macro M2s_b80b 0
M2s_c42f
%endmacro
%macro M2s_b80c 0
M2s_c430
%endmacro
%macro M2s_b80d 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 8]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 40]
%endmacro
%macro M2s_b80e 0
M2s_c431
%endmacro
%macro M2s_b80f 0
M2s_b80e
M2s_b810
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_b810 0
M2s_c432
%endmacro
%macro M2s_b811 0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_b812 0
M2s_b811
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 296]
%endmacro
%macro M2s_b813 0
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 264]
%endmacro
%macro M2s_b814 0
M2s_c433
%endmacro
%macro M2s_b815 0
M2s_c434
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_b816 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 20]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 52]
%endmacro
%macro M2s_b817 0
M2s_b818
M2s_b819
%endmacro
%macro M2s_b818 0
M2s_c435
%endmacro
%macro M2s_b819 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b81a 0
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_b81b 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 16]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 48]
%endmacro
%macro M2s_b81c 0
M2s_b81d
M2s_b81e
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_b81d 0
M2s_c436
%endmacro
%macro M2s_b81e 0
M2s_c437
%endmacro
%macro M2s_b81f 0
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 272]
%endmacro
%macro M2s_b820 0
M2s_b81f
M2s_b821
%endmacro
%macro M2s_b821 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b822 0
M2s_c438
%endmacro
%macro M2s_b823 0
M2s_c439
M2s_c43a
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_b824 0
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 276]
%endmacro
%macro M2s_b825 0
M2s_b824
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b826 0
M2s_c43b
%endmacro
%macro M2s_b827 0
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_b828 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 24]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 56]
%endmacro
%macro M2s_b829 0
M2s_c43c
M2s_c43d
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_b82a 0
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 280]
%endmacro
%macro M2s_b82b 0
M2s_b82a
M2s_b82c
%endmacro
%macro M2s_b82c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 312]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b82d 0
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_b82e 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_c3f2
M2s_c411
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_b82f 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 28]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 60]
%endmacro
%macro M2s_b830 0
M2s_c43e
M2s_c43f
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_b831 0
    vpermps ymm1, ymm3, [r13 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 284]
%endmacro
%macro M2s_b832 0
M2s_b831
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b833 0
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 316]
%endmacro
%macro M2s_b834 0
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_b835 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b836 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_c3f7
M2s_c3f8
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 200]
%endmacro
%macro M2s_b837 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_c3f4
M2s_c3f5
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 196]
%endmacro
%macro M2s_b838 0
M2s_b837
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c427
    vpermps ymm1, ymm3, [r13 + 260]
M2s_c3f6
    vmovdqu ymm3, [rdx + 608]
M2s_b839
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b839 0
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 356]
%endmacro
%macro M2s_b83a 0
M2s_b83b
    vpermps ymm1, ymm3, [r13 + 296]
M2s_c3fa
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b83b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c420
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_b83c 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 48]
M2s_c3fe
M2s_c3ff
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 208]
%endmacro
%macro M2s_b83d 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_c3fb
M2s_c3fc
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 204]
%endmacro
%macro M2s_b83e 0
M2s_b83d
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c421
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
M2s_b83f
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b83f 0
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 364]
%endmacro
%macro M2s_b840 0
M2s_b841
    vpermps ymm1, ymm3, [r13 + 304]
M2s_c403
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b841 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c422
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_b842 0
M2s_a675
M2s_c36
M2s_c37a
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b843 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b844 0
M2s_a677
M2s_c3c4
M2s_c3c5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 136]
%endmacro
%macro M2s_b845 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b846 0
M2s_a67a
M2s_c381
M2s_c37f
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 140]
%endmacro
%macro M2s_b847 0
    vpermps ymm1, ymm3, [r9 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 356]
%endmacro
%macro M2s_b848 0
M2s_a67d
M2s_c3f
M2s_c387
M2s_c388
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 144]
%endmacro
%macro M2s_b849 0
    vpermps ymm1, ymm3, [r9 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 360]
%endmacro
%macro M2s_b84a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b84b 0
M2s_a67f
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c4f
M2s_c389
M2s_c52
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 148]
%endmacro
%macro M2s_b84c 0
M2s_c441
%endmacro
%macro M2s_b84d 0
M2s_a682
M2s_c40a
M2s_c38a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 152]
%endmacro
%macro M2s_b84e 0
    vpermps ymm1, ymm3, [r9 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 368]
%endmacro
%macro M2s_b84f 0
M2s_a683
M2s_c5a
M2s_c69
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 156]
%endmacro
%macro M2s_b850 0
    vpermps ymm1, ymm3, [r9 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 372]
%endmacro
%macro M2s_b851 0
    vpermps ymm1, ymm3, [r9 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 376]
%endmacro
%macro M2s_b852 0
M2s_a686
M2s_c5c
M2s_c58
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 160]
%endmacro
%macro M2s_b853 0
M2s_a688
M2s_c63
M2s_c70
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 164]
%endmacro
%macro M2s_b854 0
    vpermps ymm1, ymm3, [r9 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 380]
%endmacro
%macro M2s_b855 0
M2s_a68b
M2s_c3cd
M2s_c3d1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 168]
%endmacro
%macro M2s_b856 0
    vpermps ymm1, ymm3, [r9 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 384]
%endmacro
%macro M2s_b857 0
M2s_a68c
M2s_c40d
    vpermps ymm1, ymm3, [r9 + 108]
M2s_c3dd
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 172]
%endmacro
%macro M2s_b858 0
    vpermps ymm1, ymm3, [r9 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 388]
%endmacro
%macro M2s_b859 0
    vpermps ymm1, ymm3, [r9 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 392]
%endmacro
%macro M2s_b85a 0
M2s_a68f
M2s_c424
M2s_c418
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 176]
%endmacro
%macro M2s_b85b 0
M2s_c426
%endmacro
%macro M2s_b85c 0
    lea r13, [r9 + r14]
M2s_c429
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c42a
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_b85d 0
M2s_c442
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
M2s_c42b
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b85e 0
    vpermps ymm1, ymm3, [r9 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 396]
%endmacro
%macro M2s_b85f 0
    vpermps ymm1, ymm3, [r9 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 400]
%endmacro
%macro M2s_b860 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b861 0
M2s_b860
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_b862 0
    vmovdqu ymm3, [rdx + 544]
M2s_c42c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 288]
%endmacro
%macro M2s_b863 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c42d
M2s_c42e
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b864 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c431
M2s_c432
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b865 0
M2s_b866
    vmovdqu ymm3, [rdx + 544]
M2s_c435
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 300]
%endmacro
%macro M2s_b866 0
    vpermps ymm1, ymm3, [r13 + 140]
M2s_c434
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b867 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c436
M2s_c437
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b868 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c439
M2s_c43a
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b869 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c43c
M2s_c43d
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b86a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c43e
M2s_c43f
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b86b 0
    vpermps ymm1, ymm3, [r8 + 264]
M2s_c41f
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b86c 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_b86d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c448
M2s_c44a
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b86e 0
M2s_c448
M2s_c44a
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b86f 0
M2s_c449
M2s_c44b
    vpermps ymm1, ymm3, [r8 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 212]
%endmacro
%macro M2s_b870 0
    vmovdqu ymm3, [rdx + 128]
M2s_c44c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 276]
%endmacro
%macro M2s_b871 0
M2s_c44c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b872 0
M2s_c44d
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b873 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 308]
M2s_a6a4
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b874 0
    vpermps ymm1, ymm3, [r8 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 372]
%endmacro
%macro M2s_b875 0
M2s_c440
%endmacro
%macro M2s_b876 0
M2s_b875
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b877 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b878 0
M2s_c44e
%endmacro
%macro M2s_b879 0
    vfmadd231ps ymm5, ymm0, [rcx + 864]
M2s_c3c1
M2s_c3c3
M2s_c3db
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b87a 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 52]
M2s_c3bb
M2s_c3bd
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 212]
%endmacro
%macro M2s_b87b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b87c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c44f
M2s_c3a
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b87d 0
M2s_c450
M2s_c453
    vpermps ymm1, ymm3, [r9 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 212]
%endmacro
%macro M2s_b87e 0
M2s_c454
%endmacro
%macro M2s_b87f 0
    vpermps ymm1, ymm3, [r9 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 244]
%endmacro
%macro M2s_b880 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b881 0
M2s_b882
M2s_c455
%endmacro
%macro M2s_b882 0
M2s_c456
%endmacro
%macro M2s_b883 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b884 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b885 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 384]
M2s_c450
M2s_c453
    vpermps ymm1, ymm3, [r9 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b886 0
M2s_b885
M2s_c454
    vpermps ymm1, ymm3, [r9 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c456
M2s_c455
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b887 0
M2s_c457
M2s_c451
%endmacro
%macro M2s_b888 0
    vpermps ymm1, ymm3, [r8 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 404]
%endmacro
%macro M2s_b889 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b88a 0
    vpermps ymm1, ymm3, [r13 + 32]
M2s_c442
M2s_c443
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_b88b 0
M2s_c459
%endmacro
%macro M2s_b88c 0
M2s_c446
%endmacro
%macro M2s_b88d 0
M2s_b88e
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 304]
%endmacro
%macro M2s_b88e 0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_b88f 0
M2s_c45a
%endmacro
%macro M2s_b890 0
M2s_b891
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 312]
%endmacro
%macro M2s_b891 0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_b892 0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_b893 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 52]
M2s_c404
M2s_c405
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 212]
%endmacro
%macro M2s_b894 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c423
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_b895 0
M2s_b894
    vpermps ymm1, ymm3, [r13 + 308]
M2s_c44e
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b896 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_b897 0
    vpermps ymm1, ymm3, [r9 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
M2s_c441
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b898 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b899 0
M2s_c458
%endmacro
%macro M2s_b89a 0
M2s_b89b
M2s_c45b
%endmacro
%macro M2s_b89b 0
M2s_c45c
%endmacro
%macro M2s_b89c 0
M2s_c45d
%endmacro
%macro M2s_b89d 0
M2s_c45e
%endmacro
%macro M2s_b89e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b89f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r9 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8a0 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 384]
M2s_c78
M2s_c2
M2s_c3
M2s_c35d
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 292]
%endmacro
%macro M2s_b8a1 0
M2s_c45f
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c2
M2s_c3
M2s_c35d
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8a2 0
M2s_c460
%endmacro
%macro M2s_b8a3 0
M2s_a6e6
M2s_ce
M2s_c10
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8a4 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8a5 0
    vpermps ymm1, ymm3, [r8 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 340]
%endmacro
%macro M2s_b8a6 0
M2s_a6ea
M2s_c19
M2s_c1a
M2s_c1c
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8a7 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8a8 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8a9 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8aa 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3ed
    vpermps ymm1, ymm3, [r8 + 348]
%endmacro
%macro M2s_b8ab 0
M2s_c461
%endmacro
%macro M2s_b8ac 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c39d
    vpermps ymm1, ymm3, [r8 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b8ad 0
M2s_c462
%endmacro
%macro M2s_b8ae 0
M2s_a6f1
M2s_c39f
M2s_c3a1
M2s_c3a3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8af 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8b0 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8b1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 424]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8b2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8b3 0
    lea r13, [r8 + r14]
M2s_c463
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 64]
%endmacro
%macro M2s_b8b4 0
M2s_b8b3
M2s_b8b8
M2s_c464
%endmacro
%macro M2s_b8b5 0
M2s_b8b6
M2s_b8b9
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 160]
%endmacro
%macro M2s_b8b6 0
M2s_c463
M2s_c465
%endmacro
%macro M2s_b8b7 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 64]
M2s_b8b8
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 128]
%endmacro
%macro M2s_b8b8 0
M2s_c466
%endmacro
%macro M2s_b8b9 0
M2s_c467
%endmacro
%macro M2s_b8ba 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8bb 0
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_b8bc 0
M2s_c468
%endmacro
%macro M2s_b8bd 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b8be 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8bf 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8c0 0
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a6fd
    vpermps ymm1, ymm3, [r13 + 320]
%endmacro
%macro M2s_b8c1 0
    vpermps ymm1, ymm3, [r13 + 320]
M2s_a702
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 384]
%endmacro
%macro M2s_b8c2 0
    vpermps ymm1, ymm3, [r13 + 192]
M2s_b8c4
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8c3 0
M2s_b8c4
M2s_b8c5
%endmacro
%macro M2s_b8c4 0
M2s_c469
%endmacro
%macro M2s_b8c5 0
M2s_c46a
%endmacro
%macro M2s_b8c6 0
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_b8c7 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 8]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 40]
%endmacro
%macro M2s_b8c8 0
M2s_c46b
%endmacro
%macro M2s_b8c9 0
M2s_c46c
%endmacro
%macro M2s_b8ca 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b8cc
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 164]
%endmacro
%macro M2s_b8cb 0
M2s_b8cc
M2s_b8cd
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_b8cc 0
M2s_c46d
%endmacro
%macro M2s_b8cd 0
M2s_c46e
%endmacro
%macro M2s_b8ce 0
M2s_b8cf
M2s_b8d1
%endmacro
%macro M2s_b8cf 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8d0 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8d1 0
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_b8d2 0
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8d3 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b8d4 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c46f
M2s_c470
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8d5 0
M2s_c46f
M2s_c470
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_b8d6 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8d7 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 12]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c471
%endmacro
%macro M2s_b8d8 0
M2s_c472
    vpermps ymm1, ymm3, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 140]
%endmacro
%macro M2s_b8d9 0
M2s_c471
M2s_b8db
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_b8da 0
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b8db 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8dc 0
M2s_b8db
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_b8dd 0
    vpermps ymm1, ymm3, [r13 + 236]
M2s_c473
%endmacro
%macro M2s_b8de 0
M2s_c473
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_b8df 0
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 300]
%endmacro
%macro M2s_b8e0 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a70e
M2s_a710
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b8e1 0
    vmovdqu ymm3, [rdx + 608]
M2s_b8e2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 328]
%endmacro
%macro M2s_b8e2 0
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 296]
%endmacro
%macro M2s_b8e3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8e4 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8e5 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b8e6 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8e7 0
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a717
    vpermps ymm1, ymm3, [r13 + 396]
%endmacro
%macro M2s_b8e8 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 20]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_b8e9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 180]
%endmacro
%macro M2s_b8e9 0
M2s_c474
    vpermps ymm1, ymm3, [r13 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 148]
%endmacro
%macro M2s_b8ea 0
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b8eb 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b8ec 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 16]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c475
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 176]
%endmacro
%macro M2s_b8ed 0
M2s_c475
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 176]
M2s_b8ee
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_b8ee 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8ef 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8f0 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a71b
M2s_a71d
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b8f1 0
    vmovdqu ymm3, [rdx + 608]
M2s_b8f2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 336]
%endmacro
%macro M2s_b8f2 0
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 304]
%endmacro
%macro M2s_b8f3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8f4 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8f5 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b8f6 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_b8f7 0
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8f8 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b8f9 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 24]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c476
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 184]
%endmacro
%macro M2s_b8fa 0
M2s_c476
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 184]
M2s_b8fb
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_b8fb 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8fc 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b8fd 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a728
M2s_a72b
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b8fe 0
    vmovdqu ymm3, [rdx + 608]
M2s_b8ff
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 344]
%endmacro
%macro M2s_b8ff 0
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 312]
%endmacro
%macro M2s_b900 0
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 312]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_b901 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b902 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b903 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b904 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 28]
M2s_c477
M2s_c478
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 188]
%endmacro
%macro M2s_b905 0
M2s_b904
M2s_b907
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 252]
M2s_b909
    vpermps ymm1, ymm3, [r13 + 348]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b906 0
M2s_c477
M2s_c478
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_b907 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b908 0
    vpermps ymm1, ymm3, [r13 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 252]
%endmacro
%macro M2s_b909 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_b90a 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_c42a
M2s_c444
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_b90b 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b90c 0
    vpermps ymm1, ymm3, [r13 + 288]
M2s_c459
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b90d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a735
    vpermps ymm1, ymm3, [r13 + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b90e 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_c431
M2s_c432
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 200]
%endmacro
%macro M2s_b90f 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b910 0
M2s_b911
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c45c
M2s_c45b
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c430
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b911 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_c42d
M2s_c42e
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 196]
%endmacro
%macro M2s_b912 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b913 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b914 0
M2s_b915
    vpermps ymm1, ymm3, [r13 + 296]
M2s_c433
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b915 0
M2s_b913
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_b916 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 48]
M2s_c436
M2s_c437
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 208]
%endmacro
%macro M2s_b917 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b918 0
M2s_b919
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c445
M2s_c45d
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b919 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 44]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c42f
M2s_c447
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 204]
%endmacro
%macro M2s_b91a 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b91b 0
M2s_b91c
    vpermps ymm1, ymm3, [r13 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c438
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b91c 0
M2s_b91d
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_b91d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b91e 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b91f 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 52]
M2s_c439
M2s_c43a
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 212]
%endmacro
%macro M2s_b920 0
M2s_b91f
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c45a
M2s_c43b
M2s_c45e
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b921 0
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 736]
%endmacro
%macro M2s_b922 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 384]
M2s_c379
    vmovdqu ymm3, [rdx + 0]
M2s_c37a
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b923 0
M2s_b922
M2s_c37c
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
M2s_c42
M2s_c37e
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 292]
%endmacro
%macro M2s_b924 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b925 0
M2s_a74a
M2s_c3b
M2s_c48
M2s_c49
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b926 0
M2s_a74c
M2s_c40
M2s_c4c
M2s_c4d
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b927 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b928 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 396]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b929 0
M2s_a74e
M2s_c4f
M2s_c389
M2s_c52
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b92a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b92b 0
M2s_a751
M2s_c5e
M2s_c5d
M2s_c60
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b92c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 404]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b92d 0
M2s_a753
M2s_c5b
M2s_c6a
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b92e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b92f 0
M2s_a755
M2s_c55
M2s_c56
M2s_c59
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b930 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b931 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b932 0
M2s_a758
M2s_c64
M2s_c71
M2s_c73
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b933 0
M2s_a75a
M2s_c3ce
M2s_c3d0
M2s_c3d2
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b934 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b935 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b936 0
M2s_a75d
M2s_c3e2
M2s_c3dd
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b937 0
M2s_a75e
M2s_c425
M2s_c419
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b938 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 424]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b939 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b93a 0
M2s_a760
M2s_c457
M2s_c452
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b93b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b93c 0
    lea r13, [r9 + r14]
M2s_c463
M2s_c465
M2s_c467
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b93d 0
    vpermps ymm1, ymm3, [r9 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 404]
%endmacro
%macro M2s_b93e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r9 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b93f 0
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_b940 0
M2s_c47a
%endmacro
%macro M2s_b941 0
    vmovdqu ymm3, [rdx + 288]
M2s_c428
M2s_c460
M2s_c5
    vpermps ymm1, ymm3, [r8 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_b942 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 380]
M2s_c461
M2s_c25
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b943 0
    vpermps ymm1, ymm3, [r8 + 324]
M2s_c462
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b944 0
M2s_c47c
M2s_c47d
    vpermps ymm1, ymm3, [r8 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 216]
%endmacro
%macro M2s_b945 0
    vpermps ymm1, ymm3, [r8 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 248]
%endmacro
%macro M2s_b946 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b947 0
    vpermps ymm1, ymm3, [r8 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 280]
%endmacro
%macro M2s_b948 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 312]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b949 0
    vpermps ymm1, ymm3, [r8 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 408]
%endmacro
%macro M2s_b94a 0
M2s_c479
%endmacro
%macro M2s_b94b 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 56]
M2s_c401
M2s_c402
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 216]
%endmacro
%macro M2s_b94c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c413
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_b94d 0
    vfmadd231ps ymm5, ymm0, [rcx + 928]
M2s_c3c1
M2s_c3c3
M2s_c3db
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_b94e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c47e
M2s_c3d
M2s_c376
M2s_c377
    vpermps ymm1, ymm3, [r9 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b94f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c47f
M2s_c480
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b950 0
M2s_c47f
M2s_c480
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b951 0
M2s_b952
M2s_b955
%endmacro
%macro M2s_b952 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_b953 0
    vpermps ymm1, ymm3, [r9 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 248]
%endmacro
%macro M2s_b954 0
M2s_b953
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 280]
M2s_a796
%endmacro
%macro M2s_b955 0
    vpermps ymm1, ymm3, [r9 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 280]
%endmacro
%macro M2s_b956 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 312]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b957 0
    vfmadd231ps ymm7, ymm0, [rcx + 928]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
    vmovaps ymm6, ymm2
%endmacro
%macro M2s_b958 0
    vfmadd231ps ymm4, ymm0, [rcx + 416]
M2s_c47c
M2s_c47d
    vpermps ymm1, ymm3, [r8 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_b959 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b95a 0
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_b95b 0
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_b95c 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 56]
M2s_c43c
M2s_c43d
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 216]
%endmacro
%macro M2s_b95d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b95e 0
M2s_b95d
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_b95f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b960 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b961 0
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_b962 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 0]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b963 0
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [r13 + 384]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 416]
%endmacro
%macro M2s_b964 0
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 164]
%endmacro
%macro M2s_b965 0
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 260]
%endmacro
%macro M2s_b966 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b967 0
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 360]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
%endmacro
%macro M2s_b968 0
    vpermps ymm1, ymm3, [r13 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [r13 + 388]
%endmacro
%macro M2s_b969 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 8]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b96a 0
    vpermps ymm1, ymm3, [r13 + 392]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 424]
%endmacro
%macro M2s_b96b 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 16]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 176]
%endmacro
%macro M2s_b96c 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 12]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 172]
%endmacro
%macro M2s_b96d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b96e 0
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b96f 0
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 364]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
%endmacro
%macro M2s_b970 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b971 0
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 372]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
%endmacro
%macro M2s_b972 0
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 368]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [r13 + 400]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 432]
%endmacro
%macro M2s_b973 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 20]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 180]
%endmacro
%macro M2s_b974 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b975 0
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b976 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 28]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 60]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 188]
%endmacro
%macro M2s_b977 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 24]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 280]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 312]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b978 0
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 376]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [r13 + 408]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 800]
    vpermps ymm1, ymm3, [r13 + 440]
%endmacro
%macro M2s_b979 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b97a 0
    vpermps ymm1, ymm3, [r13 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b97b 0
    vmovdqu ymm3, [rdx + 736]
    vpermps ymm1, ymm3, [r13 + 380]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
%endmacro
%macro M2s_b97c 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 32]
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 64]
M2s_c466
M2s_c464
M2s_c468
M2s_c469
M2s_c46a
M2s_c46b
M2s_c46c
%endmacro
%macro M2s_b97d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [r13 + 416]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b97e 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 40]
M2s_c46f
M2s_c470
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 200]
%endmacro
%macro M2s_b97f 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 36]
M2s_c46d
M2s_c46e
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 196]
%endmacro
%macro M2s_b980 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [r13 + 420]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b981 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [r13 + 424]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b982 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 48]
M2s_c475
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 208]
%endmacro
%macro M2s_b983 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 44]
M2s_c472
    vpermps ymm1, ymm3, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b984 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [r13 + 428]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b985 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [r13 + 432]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b986 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 56]
M2s_c476
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 216]
%endmacro
%macro M2s_b987 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm0, ymm3, [r13 + 52]
M2s_c474
    vpermps ymm1, ymm3, [r13 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b988 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [r13 + 436]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b989 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 768]
    vpermps ymm1, ymm3, [r13 + 440]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b98a 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 60]
M2s_c43e
M2s_c43f
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 220]
%endmacro
%macro M2s_b98b 0
    mov rbx, [rdi + G_gp]
    shl rbx, 2
.hu:
    vpermps ymm0, ymm8, [r8 + 0]
%endmacro
%macro M2s_b98c 0
    vfmadd231ps ymm5, ymm0, ymm12
    vshufps ymm2, ymm4, ymm5, 0x88
    vshufps ymm5, ymm4, ymm5, 0xdd
    vmovaps ymm4, ymm2
%endmacro
%macro M2s_b98d 0
    vfmadd231ps ymm7, ymm0, ymm12
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
    vmovaps ymm6, ymm2
%endmacro
%macro M2s_b98e 0
.hu:
    vpermps ymm0, ymm8, [r8 + 0]
    vpermps ymm1, ymm8, [r8 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm8
%endmacro
%macro M2s_b98f 0
    vblendvps ymm0, ymm0, ymm1, ymm8
    vmulps ymm4, ymm0, ymm3
    vpermps ymm0, ymm8, [r8 + 4]
    vpermps ymm1, ymm8, [r8 + 36]
%endmacro
%macro M2s_b990 0
M2s_c481
%endmacro
%macro M2s_b991 0
    lea r13, [r8 + r14]
    vpermps ymm0, ymm9, [r13 + 0]
    vpermps ymm1, ymm9, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm9
%endmacro
%macro M2s_b992 0
    vpermps ymm1, ymm8, [r9 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vmulps ymm6, ymm0, ymm3
    vpermps ymm0, ymm8, [r9 + 4]
%endmacro
%macro M2s_b993 0
M2s_c482
%endmacro
%macro M2s_b994 0
    lea r13, [r9 + r14]
    vpermps ymm0, ymm9, [r13 + 0]
    vpermps ymm1, ymm9, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm9
%endmacro
%macro M2s_b995 0
    add r8, rbx
    add r9, rbx
    vmovaps ymm15, ymm4
    vpermps ymm0, ymm8, [r8 + 0]
%endmacro
%macro M2s_b996 0
    vpermps ymm0, ymm8, [r9 + 0]
    vpermps ymm1, ymm8, [r9 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vmulps ymm6, ymm0, ymm3
%endmacro
%macro M2s_b997 0
    vpermps ymm0, ymm8, [r8 + 8]
    vpermps ymm1, ymm8, [r8 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm11
%endmacro
%macro M2s_b998 0
    vfmadd231ps ymm5, ymm0, [rcx + 160]
    vshufps ymm2, ymm4, ymm5, 0x88
    vshufps ymm5, ymm4, ymm5, 0xdd
    vmovaps ymm4, ymm2
%endmacro
%macro M2s_b999 0
    vpermps ymm1, ymm8, [r9 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm6, ymm0, ymm10
    vpermps ymm0, ymm8, [r9 + 8]
%endmacro
%macro M2s_b99a 0
    vpermps ymm1, ymm8, [r8 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r8 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm9
%endmacro
%macro M2s_b99b 0
    vpermps ymm1, ymm9, [r8 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_c481
    vpermps ymm1, ymm9, [r8 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm9
%endmacro
%macro M2s_b99c 0
M2s_c483
%endmacro
%macro M2s_b99d 0
    lea r13, [r8 + r14]
    vpermps ymm0, ymm10, [r13 + 0]
    vpermps ymm1, ymm10, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm10
%endmacro
%macro M2s_b99e 0
    vpermps ymm0, ymm10, [r13 + 4]
    vpermps ymm1, ymm10, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vpermps ymm1, ymm11, [r13 + 68]
%endmacro
%macro M2s_b99f 0
    vpermps ymm0, ymm10, [r13 + 8]
    vpermps ymm1, ymm10, [r13 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vpermps ymm1, ymm11, [r13 + 72]
%endmacro
%macro M2s_b9a0 0
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_c482
    vpermps ymm1, ymm9, [r9 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm6, ymm0, ymm12
%endmacro
%macro M2s_b9a1 0
    vpermps ymm1, ymm9, [r9 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vfmadd231ps ymm6, ymm0, ymm12
M2s_a857
%endmacro
%macro M2s_b9a2 0
    vpermps ymm0, ymm8, [r9 + 0]
    vpermps ymm1, ymm8, [r9 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r9 + 64]
%endmacro
%macro M2s_b9a3 0
    vpermps ymm0, ymm8, [r9 + 8]
    vpermps ymm1, ymm8, [r9 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r9 + 72]
%endmacro
%macro M2s_b9a4 0
    lea r13, [r9 + r14]
    vpermps ymm0, ymm10, [r13 + 0]
    vpermps ymm1, ymm10, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm10
%endmacro
%macro M2s_b9a5 0
    vfmadd231ps ymm7, ymm0, [rcx + 224]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
    vmovaps ymm6, ymm2
%endmacro
%macro M2s_b9a6 0
    vfmadd231ps ymm5, ymm0, [rcx + 224]
    vshufps ymm2, ymm4, ymm5, 0x88
    vshufps ymm5, ymm4, ymm5, 0xdd
    vmovaps ymm4, ymm2
%endmacro
%macro M2s_b9a7 0
M2s_c484
%endmacro
%macro M2s_b9a8 0
    vpermps ymm0, ymm10, [r13 + 12]
    vpermps ymm1, ymm10, [r13 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vpermps ymm1, ymm11, [r13 + 76]
%endmacro
%macro M2s_b9a9 0
    vfmadd231ps ymm6, ymm0, ymm13
    vpermps ymm0, ymm8, [r9 + 12]
    vpermps ymm1, ymm8, [r9 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm8
%endmacro
%macro M2s_b9aa 0
    vpermps ymm0, ymm8, [r9 + 12]
    vpermps ymm1, ymm8, [r9 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r9 + 76]
%endmacro
%macro M2s_b9ab 0
    vpermps ymm1, ymm10, [r8 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm10
M2s_c481
    vpermps ymm1, ymm9, [r8 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r8 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 32]
M2s_c483
    vblendvps ymm0, ymm0, ymm1, ymm9
%endmacro
%macro M2s_b9ac 0
    vpermps ymm1, ymm10, [r8 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 64]
M2s_c484
    vblendvps ymm0, ymm0, ymm1, ymm9
%endmacro
%macro M2s_b9ad 0
M2s_c485
%endmacro
%macro M2s_b9ae 0
    vpermps ymm0, ymm11, [r13 + 4]
    vpermps ymm1, ymm11, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm11
    vpermps ymm1, ymm12, [r13 + 68]
%endmacro
%macro M2s_b9af 0
    vpermps ymm0, ymm11, [r13 + 8]
    vpermps ymm1, ymm11, [r13 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm11
    vpermps ymm1, ymm12, [r13 + 72]
%endmacro
%macro M2s_b9b0 0
    vpermps ymm0, ymm11, [r13 + 12]
    vpermps ymm1, ymm11, [r13 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm11
    vpermps ymm1, ymm12, [r13 + 76]
%endmacro
%macro M2s_b9b1 0
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vmulps ymm6, ymm0, ymm3
%endmacro
%macro M2s_b9b2 0
    vpermps ymm1, ymm10, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm10
M2s_c482
    vpermps ymm1, ymm9, [r9 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm9
%endmacro
%macro M2s_b9b3 0
    vpermps ymm1, ymm9, [r9 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm9
M2s_b9b4
    vpermps ymm1, ymm8, [r9 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm8
%endmacro
%macro M2s_b9b4 0
    vpermps ymm1, ymm10, [r9 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm6, ymm0, [rcx + 32]
    vpermps ymm0, ymm8, [r9 + 8]
%endmacro
%macro M2s_b9b5 0
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r9 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm6, ymm0, [rcx + 64]
%endmacro
%macro M2s_b9b6 0
    vpermps ymm1, ymm10, [r9 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm6, ymm0, [rcx + 64]
    vpermps ymm0, ymm8, [r9 + 12]
%endmacro
%macro M2s_b9b7 0
    lea r13, [r9 + r14]
M2s_c485
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm13
%endmacro
%macro M2s_b9b8 0
    sub rcx, 2
    cmp rcx, 2
    jae .i2c1
.i2c1r:
%endmacro
%macro M2s_b9b9 0
    vpermps ymm0, ymm10, [r13 + 16]
    vpermps ymm1, ymm10, [r13 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vpermps ymm1, ymm11, [r13 + 80]
%endmacro
%macro M2s_b9ba 0
    vfmadd231ps ymm5, ymm0, [rcx + 288]
    vshufps ymm2, ymm4, ymm5, 0x88
    vshufps ymm5, ymm4, ymm5, 0xdd
    vmovaps ymm4, ymm2
%endmacro
%macro M2s_b9bb 0
    vpermps ymm1, ymm10, [r8 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm10
    vfmadd231ps ymm4, ymm0, [rcx + 96]
    vpermps ymm0, ymm8, [r8 + 16]
%endmacro
%macro M2s_b9bc 0
    lea r13, [r8 + r14]
M2s_c485
    vblendvps ymm0, ymm0, ymm1, ymm12
    vpermps ymm1, ymm13, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm13
%endmacro
%macro M2s_b9bd 0
    vpermps ymm1, ymm9, [r8 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm9
    vpermps ymm1, ymm10, [r8 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm10
%endmacro
%macro M2s_b9be 0
    vpermps ymm0, ymm11, [r13 + 16]
    vpermps ymm1, ymm11, [r13 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm11
    vpermps ymm1, ymm12, [r13 + 80]
%endmacro
%macro M2s_b9bf 0
    lea r13, [r8 + r14]
M2s_b9c0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 64]
%endmacro
%macro M2s_b9c0 0
M2s_c486
%endmacro
%macro M2s_b9c1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9c2 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9c3 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b9c4 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm0, ymm3, [r13 + 8]
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r13 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9c5 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b9c6 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm0, ymm3, [r13 + 12]
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r13 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9c7 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b9c8 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm0, ymm3, [r13 + 16]
M2s_b9c9
    vpermps ymm1, ymm3, [r13 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9c9 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r13 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_b9ca 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b9cb 0
    vpermps ymm1, ymm3, [r9 + 128]
M2s_c379
M2s_c47b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 132]
M2s_c3c4
M2s_c3c6
%endmacro
%macro M2s_b9cc 0
    lea r13, [r9 + r14]
M2s_c486
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 64]
%endmacro
%macro M2s_b9cd 0
    vpermps ymm1, ymm3, [r9 + 140]
M2s_c3f
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9ce 0
    vpermps ymm0, ymm11, [r13 + 20]
    vpermps ymm1, ymm11, [r13 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm11
    vpermps ymm1, ymm12, [r13 + 84]
%endmacro
%macro M2s_b9cf 0
M2s_c488
%endmacro
%macro M2s_b9d0 0
    vfmadd231ps ymm7, ymm0, [rcx + 352]
    vshufps ymm2, ymm6, ymm7, 0x88
    vshufps ymm7, ymm6, ymm7, 0xdd
    vmovaps ymm6, ymm2
%endmacro
%macro M2s_b9d1 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm0, ymm3, [r13 + 20]
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r13 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9d2 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_b9d3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c488
M2s_c39
M2s_c3a
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9d4 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 164]
M2s_c395
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 168]
M2s_c397
M2s_c3e5
%endmacro
%macro M2s_b9d5 0
    vpermps ymm1, ymm3, [r8 + 172]
M2s_c363
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9d6 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9d7 0
    vpermps ymm1, ymm3, [r8 + 176]
M2s_c399
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9d8 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm0, ymm3, [r13 + 12]
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 44]
%endmacro
%macro M2s_b9d9 0
    lea r13, [r8 + r14]
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm0, ymm3, [r13 + 0]
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_b9da 0
M2s_c489
%endmacro
%macro M2s_b9db 0
M2s_b9da
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a8bc
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b9dc 0
M2s_c48a
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 128]
%endmacro
%macro M2s_b9dd 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9de 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 164]
%endmacro
%macro M2s_b9df 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm0, ymm3, [r13 + 8]
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 40]
%endmacro
%macro M2s_b9e0 0
M2s_c48b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9e1 0
    vmovdqu ymm3, [rdx + 192]
M2s_b9e2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 140]
%endmacro
%macro M2s_b9e2 0
    vpermps ymm1, ymm3, [r13 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 108]
%endmacro
%macro M2s_b9e3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9e4 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9e5 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm0, ymm3, [r13 + 16]
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 176]
%endmacro
%macro M2s_b9e6 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm0, ymm3, [r13 + 20]
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9e7 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b9e8 0
    vpermps ymm1, ymm3, [r13 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 180]
%endmacro
%macro M2s_b9e9 0
    vpermps ymm1, ymm3, [r9 + 160]
M2s_c379
M2s_c47b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 132]
%endmacro
%macro M2s_b9ea 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 164]
M2s_c3c4
M2s_c3c6
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 168]
M2s_c381
M2s_c37f
%endmacro
%macro M2s_b9eb 0
M2s_c48c
M2s_c46
M2s_c3b
M2s_c48
M2s_c49
%endmacro
%macro M2s_b9ec 0
    vpermps ymm1, ymm3, [r9 + 172]
M2s_c3f
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9ed 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
M2s_c48b
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b9ee 0
    lea r13, [r9 + r14]
M2s_c489
M2s_b9ef
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_b9ef 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c48a
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b9f0 0
    vpermps ymm0, ymm3, [r13 + 24]
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r13 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9f1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm5, ymm0, [rcx + 416]
M2s_c3c1
    vpermps ymm0, ymm3, [r9 + 0]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_b9f2 0
M2s_c48e
M2s_c39
%endmacro
%macro M2s_b9f3 0
    vpermps ymm1, ymm3, [r13 + 32]
M2s_c48d
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9f4 0
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 160]
%endmacro
%macro M2s_b9f5 0
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 168]
%endmacro
%macro M2s_b9f6 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm0, ymm3, [r13 + 24]
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9f7 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_b9f8 0
M2s_b9f7
    vpermps ymm1, ymm3, [r13 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 184]
%endmacro
%macro M2s_b9f9 0
    vpermps ymm1, ymm3, [r8 + 196]
M2s_c395
M2s_c8
    vpermps ymm1, ymm3, [r8 + 200]
M2s_c397
    vpermps ymm1, ymm3, [r8 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9fa 0
    vpermps ymm1, ymm3, [r8 + 204]
M2s_c364
M2s_c361
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 144]
%endmacro
%macro M2s_b9fb 0
    vpermps ymm1, ymm3, [r8 + 212]
M2s_c3ea
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_b9fc 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 192]
%endmacro
%macro M2s_b9fd 0
    lea r13, [r8 + r14]
M2s_b9fe
M2s_c34
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_b9fe 0
M2s_c490
%endmacro
%macro M2s_b9ff 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [r13 + 4]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c38
M2s_c37
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 164]
%endmacro
%macro M2s_ba00 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [r13 + 8]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 168]
%endmacro
%macro M2s_ba01 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba02 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [r13 + 12]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 172]
%endmacro
%macro M2s_ba03 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba04 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [r13 + 16]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 176]
%endmacro
%macro M2s_ba05 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba06 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [r13 + 20]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 180]
%endmacro
%macro M2s_ba07 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba08 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [r13 + 24]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba09 0
M2s_ba08
M2s_ba0a
    vpermps ymm1, ymm3, [r13 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 184]
%endmacro
%macro M2s_ba0a 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_ba0b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba0c 0
    vpermps ymm1, ymm3, [r9 + 196]
M2s_c3c4
M2s_c3c6
M2s_c47
    vpermps ymm1, ymm3, [r9 + 200]
M2s_c381
    vpermps ymm1, ymm3, [r9 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba0d 0
    vpermps ymm1, ymm3, [r9 + 204]
M2s_c3f
M2s_c387
M2s_c388
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 144]
%endmacro
%macro M2s_ba0e 0
    vpermps ymm1, ymm3, [r9 + 212]
M2s_c409
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba0f 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 216]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 192]
%endmacro
%macro M2s_ba10 0
    lea r13, [r9 + r14]
M2s_c490
M2s_c34
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_ba11 0
    vpermps ymm1, ymm3, [r8 + 192]
M2s_c78
M2s_c2
M2s_c48f
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba12 0
    vpermps ymm1, ymm3, [r9 + 192]
M2s_c379
M2s_c47b
M2s_c487
M2s_c41
M2s_c491
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba13 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm0, ymm3, [r13 + 28]
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 60]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba14 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_ba15
M2s_c3a
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba15 0
    vfmadd231ps ymm5, ymm0, [rcx + 480]
M2s_c3c1
    vpermps ymm0, ymm3, [r9 + 0]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 32]
%endmacro
%macro M2s_ba16 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [r13 + 28]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 60]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba17 0
M2s_ba16
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 124]
M2s_ba18
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 188]
%endmacro
%macro M2s_ba18 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba19 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba1a 0
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_c3c1
    vpermps ymm0, ymm3, [r9 + 0]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 32]
%endmacro
%macro M2s_ba1b 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [r13 + 32]
M2s_c48a
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba1c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c492
M2s_c3a
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_ba1d 0
    vaddps ymm0, ymm4, ymm5
    vmovups [r10 + 0], ymm0
    vaddps ymm0, ymm6, ymm7
    vmovups [r11 + 0], ymm0
    vaddps ymm4, ymm4, ymm6
    vaddps ymm5, ymm5, ymm7
    cmp qword [rbp + 40], 0
    jne .hf
%endmacro
%macro M2s_ba1e 0
    vmovups [r10 + 128], ymm0
    vaddps ymm0, ymm6, ymm7
    vmovups [r11 + 128], ymm0
    vaddps ymm4, ymm4, ymm6
    vaddps ymm5, ymm5, ymm7
M2s_c7c
M2s_c7f
M2s_c80
    mov rdi, [rbp + 8]
    mov rax, [rdi + G_su]
    shl rax, 3
%endmacro
%macro M2s_ba1f 0
    vfmadd213ps ymm1, ymm0, ymm12
    vmovups [rdx], ymm1
    add rax, 128
    add rdx, 32
%endmacro
%macro M2s_ba20 0
    dec rcx
    jnz .itl
M2s_c88
    cmp rcx, 2
    jb .i1l0r
M2s_c89
    vmovups ymm11, [rdi+(G_lom+0)]
    vmovups ymm10, [c_ieq]
.i1l0:
    vmovups ymm0, [rax]
%endmacro
%macro M2s_ba21 0
    test rcx, rcx
    jz .i1l0e
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xlo]
%endmacro
%macro M2s_ba22 0
    vmovups ymm3, [rdx+32]
M2s_c8a
    vsubps ymm6, ymm4, ymm1
    vsubps ymm7, ymm5, ymm3
    vcmpps ymm8, ymm6, ymm14, 30
%endmacro
%macro M2s_ba23 0
    add rdx, 64
    add r9, 576
    sub rcx, 2
    cmp rcx, 2
%endmacro
%macro M2s_ba24 0
.i1l0s:
M2s_a945
    add rdx, 32
M2s_c98
    cmp rcx, 2
    jb .i1l1r
M2s_c99
    vmovups ymm11, [rdi+(G_lom+32)]
    vmovups ymm10, [c_ieq]
.i1l1:
    vmovups ymm0, [rax+32]
    vmovups ymm1, [rdx]
    vmovups ymm2, [rax+160]
M2s_c493
    vrcpps ymm9, ymm6
%endmacro
%macro M2s_ba25 0
M2s_c494
M2s_cff
    vcmpps ymm0, ymm7, ymm14, 30
    vrcpps ymm2, ymm7
    vmovaps [r9+160], ymm8
    vandnps ymm6, ymm8, ymm1
%endmacro
%macro M2s_ba26 0
M2s_c495
M2s_cf9
    vrcpps ymm2, ymm7
    vmovaps [r9+160], ymm8
    vandnps ymm6, ymm8, ymm1
    vaddps ymm7, ymm4, ymm6
%endmacro
%macro M2s_ba27 0
    vmovups ymm1, [rdx]
    vandps ymm2, ymm0, ymm15
    vfmadd231ps ymm1, ymm2, ymm13
    vsubps ymm3, ymm2, ymm1
%endmacro
%macro M2s_ba28 0
    vmovaps [r9+416], ymm4
    add rax, 256
    add rdx, 64
    add r9, 576
%endmacro
%macro M2s_ba29 0
    sub rcx, 2
M2s_ca7
    jz .i1l2e
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xlo]
%endmacro
%macro M2s_ba2a 0
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+128], ymm9
    add rax, 128
    add rdx, 32
%endmacro
%macro M2s_ba2b 0
    vmovups ymm1, [rdx]
    vmovups ymm2, [rax+192]
M2s_c493
    vrcpps ymm9, ymm6
M2s_ca1
    vaddps ymm7, ymm4, ymm6
%endmacro
%macro M2s_ba2c 0
M2s_a950
M2s_ca5
M2s_a951
    jb .i2l2r
M2s_cae
.i2l2:
M2s_cc9
%endmacro
%macro M2s_ba2d 0
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+224], ymm9
    add rax, 128
    add rdx, 32
%endmacro
%macro M2s_ba2e 0
M2s_c497
%endmacro
%macro M2s_ba2f 0
    vandps ymm9, ymm10, [r9+256]
M2s_c498
    vmovaps [r9+224], ymm11
    vmulps ymm4, ymm10, ymm2
    vmovaps ymm0, ymm12
%endmacro
%macro M2s_ba30 0
M2s_c498
    vmovaps [r9+224], ymm11
    vmulps ymm4, ymm10, ymm2
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm5, ymm13
%endmacro
%macro M2s_ba31 0
    sub rcx, 2
M2s_cc8
M2s_cb5
M2s_c392
    vblendvps ymm8, ymm2, ymm6, ymm4
    vfmadd213ps ymm1, ymm7, ymm14
    vmulps ymm3, ymm8, ymm10
%endmacro
%macro M2s_ba32 0
M2s_cc5
M2s_c497
%endmacro
%macro M2s_ba33 0
    vandps ymm6, ymm3, [r9+544]
    vmovaps [r9+480], ymm6
    vmovaps [r9+512], ymm8
    add rax, 256
%endmacro
%macro M2s_ba34 0
    vandps ymm7, ymm6, [r9+256]
    vmovaps [r9+192], ymm7
    vmovaps [r9+224], ymm4
    add rax, 128
%endmacro
%macro M2s_ba35 0
    cmp rcx, 2
M2s_cda
M2s_cb6
M2s_c107
M2s_cdc
    vfmadd213ps ymm1, ymm7, ymm14
    vmulps ymm3, ymm8, ymm10
    vmovaps ymm0, ymm12
%endmacro
%macro M2s_ba36 0
    vpsubd ymm6, ymm4, ymm0
    vmovaps [r9], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
    vfmadd213ps ymm5, ymm6, ymm14
%endmacro
%macro M2s_ba37 0
    vfmadd213ps ymm5, ymm6, ymm14
    vmovaps [r9+32], ymm11
    vmulps ymm4, ymm10, ymm2
M2s_cbf
    vfmadd213ps ymm0, ymm5, [c_q8o1]
%endmacro
%macro M2s_ba38 0
    vmovaps [r9], ymm7
    vmovaps [r9+32], ymm4
    add rax, 128
    add r9, 288
%endmacro
%macro M2s_ba39 0
    vpsubd ymm6, ymm4, ymm0
    vmovaps [r9+96], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
    vfmadd213ps ymm5, ymm6, ymm14
%endmacro
%macro M2s_ba3a 0
    vmovaps [r9+128], ymm11
M2s_c499
    vandps ymm1, ymm7, [c_sgn]
    vfmadd213ps ymm0, ymm5, [c_q8o1]
    vfmadd213ps ymm0, ymm5, [c_q8o0]
%endmacro
%macro M2s_ba3b 0
M2s_a967
    sub rcx, 2
    cmp rcx, 2
M2s_ce8
M2s_cb6
M2s_c107
M2s_ce9
    vfmadd213ps ymm1, ymm7, ymm14
%endmacro
%macro M2s_ba3c 0
    vmovaps ymm14, [rdi + G_lmx + 32]
    vmovaps ymm15, [rdi + G_lmx + 64]
    vmovaps ymm12, [rdi + G_lsl]
    mov r8, [rdi + G_sg]
%endmacro
%macro M2s_ba3d 0
    vmovaps [r9+96], ymm7
    vmovaps [r9+128], ymm4
    add rax, 128
    add r9, 288
%endmacro
%macro M2s_ba3e 0
    vmulps ymm0, ymm15, [r8 + 192]
    vfmadd231ps ymm0, ymm13, [r8]
    vfmadd231ps ymm0, ymm14, [r8 + 96]
    vmovaps ymm1, ymm12
    vfmadd231ps ymm1, ymm15, [r8 + 224]
    vfmadd231ps ymm1, ymm13, [r8 + 32]
    vfmadd231ps ymm1, ymm14, [r8 + 128]
M2s_cec
    vmovdqu [rbp + 384], xmm3
M2s_cef
M2s_cf0
%endmacro
%macro M2s_ba3f 0
.elq:
    vmovmskps eax, ymm2
M2s_cf2
    mov [r11], al
    add r8, 288
%endmacro
%macro M2s_ba40 0
    vmovups ymm1, [rdx]
    vmovups ymm2, [rax+128]
M2s_c493
    vrcpps ymm9, ymm6
    vcmpps ymm0, ymm7, ymm14, 30
M2s_c8c
    vmovaps [r9+352], ymm0
    vandnps ymm4, ymm0, ymm3
    vmulps ymm6, ymm1, ymm9
M2s_c8d
M2s_c8e
    vmovaps [r9+32], ymm5
    vmovaps [r9+320], ymm4
    add rax, 256
    add rdx, 64
    add r9, 576
%endmacro
%macro M2s_ba41 0
    vmovups ymm0, [rax+64]
M2s_c496
    vfmadd231ps ymm1, ymm4, ymm13
    vandps ymm5, ymm2, ymm15
    vfmadd231ps ymm3, ymm5, ymm13
%endmacro
%macro M2s_ba42 0
M2s_c110
%endmacro
%macro M2s_ba43 0
    vmulps ymm4, ymm0, ymm2
    vmulps ymm5, ymm0, ymm3
    vpermps ymm0, ymm8, [r8 + 4]
    vpermps ymm1, ymm8, [r8 + 36]
%endmacro
%macro M2s_ba44 0
    vpermps ymm0, ymm8, [r9 + 0]
    vpermps ymm1, ymm8, [r9 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vmulps ymm6, ymm0, ymm2
    vmulps ymm7, ymm0, ymm3
    vpermps ymm0, ymm8, [r9 + 4]
    vpermps ymm1, ymm8, [r9 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm8
%endmacro
%macro M2s_c0 0
M2s_d0
    vpermps ymm1, ymm3, [r8 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 68]
%endmacro
%macro M2s_c1 0
M2s_d1
%endmacro
%macro M2s_c2 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_c3 0
    vpermps ymm1, ymm3, [r8 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 228]
%endmacro
%macro M2s_c4 0
M2s_c5
    vpermps ymm1, ymm3, [r8 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 72]
%endmacro
%macro M2s_c5 0
M2s_d2
%endmacro
%macro M2s_c6 0
M2s_a3b
M2s_a42
M2s_a45
M2s_a4c
%endmacro
%macro M2s_c7 0
M2s_d3
%endmacro
%macro M2s_c8 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_c9 0
M2s_d4
%endmacro
%macro M2s_ca 0
    vpermps ymm1, ymm3, [r8 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 76]
%endmacro
%macro M2s_cb 0
M2s_d5
%endmacro
%macro M2s_cc 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_cd 0
    vpermps ymm1, ymm3, [r8 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 236]
%endmacro
%macro M2s_ce 0
M2s_cf
    vpermps ymm1, ymm3, [r8 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 80]
%endmacro
%macro M2s_cf 0
    vfmadd231ps ymm4, ymm0, ymm11
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 16]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_c10 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c11 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_c12 0
    vpermps ymm1, ymm3, [r8 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 240]
%endmacro
%macro M2s_c13 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 20]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 52]
%endmacro
%macro M2s_c14 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c15 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c16 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_c17 0
M2s_b3a
    vpermps ymm1, ymm3, [r8 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c18 0
M2s_b3d
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 152]
%endmacro
%macro M2s_c19 0
    vfmadd231ps ymm4, ymm0, ymm13
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 24]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_c1a 0
    vpermps ymm1, ymm3, [r8 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 88]
%endmacro
%macro M2s_c1b 0
    vpermps ymm1, ymm3, [r8 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 120]
%endmacro
%macro M2s_c1c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c1d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c1e
    vpermps ymm1, ymm3, [r8 + 60]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c1e 0
M2s_d6
%endmacro
%macro M2s_c1f 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 28]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 60]
%endmacro
%macro M2s_c20 0
    vpermps ymm1, ymm3, [r8 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 124]
%endmacro
%macro M2s_c21 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c22 0
M2s_d7
%endmacro
%macro M2s_c23 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_c24 0
    vpermps ymm1, ymm3, [r8 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 252]
%endmacro
%macro M2s_c25 0
    vfmadd231ps ymm4, ymm0, [rcx + 224]
M2s_d7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 96]
%endmacro
%macro M2s_c26 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_c27 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c28 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_c29 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 256]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 36]
%endmacro
%macro M2s_c2a 0
    vpermps ymm1, ymm3, [r8 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 100]
%endmacro
%macro M2s_c2b 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c2c 0
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 100]
M2s_b65
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_c2d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c2e 0
M2s_d9
%endmacro
%macro M2s_c2f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c30 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_c31 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
%endmacro
%macro M2s_c32 0
    vpermps ymm1, ymm3, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 136]
%endmacro
%macro M2s_c33 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
%endmacro
%macro M2s_c34 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_c35 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c36 0
    vmulps ymm6, ymm0, ymm8
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 4]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_c37 0
    vpermps ymm1, ymm3, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 132]
%endmacro
%macro M2s_c38 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_c39 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 0]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 32]
%endmacro
%macro M2s_c3a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3b 0
M2s_da
%endmacro
%macro M2s_c3c 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_c3d 0
    vpermps ymm1, ymm3, [r9 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 160]
%endmacro
%macro M2s_c3e 0
M2s_db
%endmacro
%macro M2s_c3f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, ymm11
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 16]
%endmacro
%macro M2s_c40 0
    vfmadd231ps ymm6, ymm0, ymm11
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 16]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_c41 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_c42 0
    vpermps ymm1, ymm3, [r9 + 196]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 228]
%endmacro
%macro M2s_c43 0
    vpermps ymm1, ymm3, [r9 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 72]
%endmacro
%macro M2s_c44 0
M2s_dc
%endmacro
%macro M2s_c45 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c46 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c47 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_c48 0
    vpermps ymm1, ymm3, [r9 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 76]
%endmacro
%macro M2s_c49 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c4a 0
    vpermps ymm1, ymm3, [r9 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 236]
%endmacro
%macro M2s_c4b 0
M2s_dd
%endmacro
%macro M2s_c4c 0
    vpermps ymm1, ymm3, [r9 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 80]
%endmacro
%macro M2s_c4d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c4e 0
M2s_bcf
    vpermps ymm1, ymm3, [r9 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c4f 0
    vfmadd231ps ymm6, ymm0, ymm12
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 20]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_c50 0
    vpermps ymm1, ymm3, [r9 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 116]
%endmacro
%macro M2s_c51 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c52 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c53 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c54 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_c55 0
M2s_de
%endmacro
%macro M2s_c56 0
    vpermps ymm1, ymm3, [r9 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 96]
%endmacro
%macro M2s_c57 0
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
%endmacro
%macro M2s_c58 0
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 128]
%endmacro
%macro M2s_c59 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c5a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 192]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 28]
%endmacro
%macro M2s_c5b 0
    vfmadd231ps ymm6, ymm0, [rcx + 192]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 28]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_c5c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_de
    vpermps ymm1, ymm3, [r9 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c5d 0
    vpermps ymm1, ymm3, [r9 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 88]
%endmacro
%macro M2s_c5e 0
    vfmadd231ps ymm6, ymm0, ymm13
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 24]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_c5f 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_c60 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c61 0
    vpermps ymm1, ymm3, [r9 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 152]
%endmacro
%macro M2s_c62 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c63 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 256]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 36]
%endmacro
%macro M2s_c64 0
    vfmadd231ps ymm6, ymm0, [rcx + 256]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 36]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_c65 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c66 0
    vpermps ymm1, ymm3, [r9 + 60]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_bfa
    vpermps ymm1, ymm3, [r9 + 124]
%endmacro
%macro M2s_c67 0
M2s_d10
%endmacro
%macro M2s_c68 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c69 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 60]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_d10
    vpermps ymm1, ymm3, [r9 + 124]
%endmacro
%macro M2s_c6a 0
M2s_d11
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c6b 0
    vpermps ymm1, ymm3, [r9 + 220]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 252]
%endmacro
%macro M2s_c6c 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_c6d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c6e 0
    vpermps ymm1, ymm3, [r9 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 160]
%endmacro
%macro M2s_c6f 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_c70 0
    vmovdqu ymm3, [rdx + 0]
M2s_c71
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 132]
%endmacro
%macro M2s_c71 0
    vpermps ymm1, ymm3, [r9 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 100]
%endmacro
%macro M2s_c72 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c73 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c74 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c75 0
    vpermps ymm1, ymm3, [r9 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 196]
%endmacro
%macro M2s_c76 0
M2s_d12
%endmacro
%macro M2s_c77 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_d0
    vpermps ymm1, ymm3, [r8 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c78 0
M2s_c77
    vpermps ymm1, ymm3, [r8 + 68]
M2s_d1
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c79 0
    vaddps ymm4, ymm4, ymm6
    vaddps ymm5, ymm5, ymm7
    vpermpd ymm4, ymm4, 0xd8
    vpermpd ymm5, ymm5, 0xd8
%endmacro
%macro M2s_c7a 0
M2s_d15
%endmacro
%macro M2s_c7b 0
    add r8, rbx
    add r9, rbx
    vmovaps ymm15, ymm4
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_c7c 0
    vperm2f128 ymm0, ymm14, ymm5, 0x21
    vpalignr ymm0, ymm5, ymm0, 12
    vaddps ymm4, ymm4, ymm0
    vmovaps ymm14, ymm5
%endmacro
%macro M2s_c7d 0
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r10 + 128], ymm0
    vaddps ymm0, ymm6, ymm7
    vpermpd ymm0, ymm0, 0xd8
%endmacro
%macro M2s_c7e 0
    vmovups [r10 + 128], ymm0
    vaddps ymm0, ymm6, ymm7
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r11 + 128], ymm0
%endmacro
%macro M2s_c7f 0
    add r8, rbx
    add r9, rbx
    vshufps ymm0, ymm15, ymm4, 0x88
    vshufps ymm1, ymm15, ymm4, 0xdd
    vaddps ymm0, ymm0, ymm1
    vpermpd ymm0, ymm0, 0xd8
    vmulps ymm0, ymm0, [rdi + G_cm]
    vmovups [r12], ymm0
    add r10, 256
    add r11, 256
    add r12, 128
    dec rsi
    jnz .hu
    mov rax, [rbp + 216]
    shl rax, 5
    add rax, [rdi + G_oc]
%endmacro
%macro M2s_c80 0
    vmovups [rax], ymm14
    inc qword [rbp + 216]
    cmp qword [rbp + 216], 4
    jb .hc
%endmacro
%macro M2s_c81 0
    sub rcx, rax
    add rcx, 7
    shr rcx, 3
    mov rdx, [rdi + G_su]
%endmacro
%macro M2s_c82 0
    mov [rbp + 240], rcx
    mov qword [rbp + 248], 0
.et:
    mov rdi, [rbp + 8]
    mov rax, [rdi + G_su]
    shl rax, 7
    imul rax, [rbp + 248]
    add rax, [rdi + G_cl]
%endmacro
%macro M2s_c83 0
    mov [rbp + 256], rax
    mov rsi, [rbp + 256]
    mov rdi, [rbp + 8]
    mov r8, [rdi + G_eb]
%endmacro
%macro M2s_c84 0
    mov r8, [rdi + G_eb]
    mov r10, [rdi + G_sg]
    mov rcx, [rbp + 240]
    mov rdx, r8
%endmacro
%macro M2s_c85 0
    jnz .itl
M2s_a15a
    cmp rcx, 2
    jb .i1l0r
%endmacro
%macro M2s_c86 0
    cmp rcx, 2
    jb .i1l0r
M2s_a15b
    vmovups ymm11, [rdi+(G_lom+0)]
%endmacro
%macro M2s_c87 0
.itl:
M2s_a158
    jnz .itl
M2s_a15a
%endmacro
%macro M2s_c88 0
M2s_d16
%endmacro
%macro M2s_c89 0
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xlo]
    vmovups ymm13, [rdi+(G_lrg+0)]
    vmovups ymm12, [c_eq]
%endmacro
%macro M2s_c8a 0
M2s_d17
%endmacro
%macro M2s_c8b 0
M2s_d18
%endmacro
%macro M2s_c8c 0
    vrcpps ymm2, ymm7
    vmovaps [r9+64], ymm8
    vandnps ymm6, ymm8, ymm1
    vaddps ymm7, ymm4, ymm6
%endmacro
%macro M2s_c8d 0
    vaddps ymm1, ymm5, ymm4
    vmovaps [r9], ymm7
    vmulps ymm9, ymm3, ymm2
    vmovaps [r9+288], ymm1
%endmacro
%macro M2s_c8e 0
    vblendvps ymm5, ymm10, ymm6, ymm8
    vblendvps ymm4, ymm10, ymm9, ymm0
    vfmadd213ps ymm5, ymm12, ymm11
    vfmadd213ps ymm4, ymm12, ymm11
%endmacro
%macro M2s_c8f 0
    vmovups ymm10, [c_ieq]
M2s_c90
.i1l1:
M2s_b14a
    vsubps ymm6, ymm4, ymm1
%endmacro
%macro M2s_c90 0
.i1l0s:
M2s_a170
    add rdx, 224
M2s_a178
%endmacro
%macro M2s_c91 0
M2s_b14a
    vsubps ymm6, ymm4, ymm1
    vsubps ymm7, ymm5, ymm3
    vcmpps ymm8, ymm6, ymm14, 30
%endmacro
%macro M2s_c92 0
    vmovups ymm0, [rax+32]
    vmovups ymm1, [rdx+192]
    vmovups ymm2, [rax+160]
    vmovups ymm3, [rdx+416]
%endmacro
%macro M2s_c93 0
    vmovups ymm3, [rdx+416]
    vandps ymm4, ymm0, ymm15
    vfmadd231ps ymm1, ymm4, ymm13
    vandps ymm5, ymm2, ymm15
%endmacro
%macro M2s_c94 0
    vrcpps ymm2, ymm7
M2s_b14f
    vandnps ymm4, ymm0, ymm3
    vmulps ymm6, ymm1, ymm9
%endmacro
%macro M2s_c95 0
    vcmpps ymm4, ymm3, ymm14, 30
    vrcpps ymm5, ymm3
    vmovaps [r9+64], ymm4
    vandnps ymm6, ymm4, ymm1
%endmacro
%macro M2s_c96 0
M2s_d19
%endmacro
%macro M2s_c97 0
    add rax, 128
    add rdx, 224
    add r9, 288
    dec rcx
%endmacro
%macro M2s_c98 0
    add r9, 288
    dec rcx
    jnz .i1l0s
.i1l0e:
M2s_d16
%endmacro
%macro M2s_c99 0
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xlo]
    vmovups ymm13, [rdi+(G_lrg+32)]
    vmovups ymm12, [c_eq]
%endmacro
%macro M2s_c9a 0
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+128], ymm9
    add rax, 128
    add rdx, 224
%endmacro
%macro M2s_c9b 0
M2s_d1a
%endmacro
%macro M2s_c9c 0
M2s_d1b
%endmacro
%macro M2s_c9d 0
M2s_d1c
%endmacro
%macro M2s_c9e 0
    jnz .i1l1s
.i1l1e:
M2s_d16
    cmp rcx, 2
    jb .i1l2r
%endmacro
%macro M2s_c9f 0
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xlo]
    vmovups ymm13, [rdi+(G_lrg+64)]
    vmovups ymm12, [c_eq]
%endmacro
%macro M2s_ca0 0
    vmovups ymm0, [rax+64]
M2s_d1a
    vfmadd231ps ymm1, ymm4, ymm13
    vandps ymm5, ymm2, ymm15
    vfmadd231ps ymm3, ymm5, ymm13
%endmacro
%macro M2s_ca1 0
    vcmpps ymm0, ymm7, ymm14, 30
    vrcpps ymm2, ymm7
    vmovaps [r9+256], ymm8
    vandnps ymm6, ymm8, ymm1
%endmacro
%macro M2s_ca2 0
M2s_b176
    vandnps ymm4, ymm0, ymm3
    vmulps ymm6, ymm1, ymm9
    vaddps ymm1, ymm5, ymm4
%endmacro
%macro M2s_ca3 0
    vmovaps [r9+544], ymm0
    vandnps ymm4, ymm0, ymm3
    vmulps ymm6, ymm1, ymm9
    vaddps ymm1, ymm5, ymm4
%endmacro
%macro M2s_ca4 0
M2s_a193
    vmovups ymm12, [c_eq]
M2s_a194
    vmovups ymm1, [rdx+192]
%endmacro
%macro M2s_ca5 0
    add r9, 288
    dec rcx
    jnz .i1l2s
.i1l2e:
%endmacro
%macro M2s_ca6 0
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+224], ymm9
    add rax, 128
    add rdx, 224
%endmacro
%macro M2s_ca7 0
    cmp rcx, 2
    jae .i1l2
.i1l2r:
    test rcx, rcx
%endmacro
%macro M2s_ca8 0
M2s_d1e
%endmacro
%macro M2s_ca9 0
M2s_d1f
%endmacro
%macro M2s_caa 0
M2s_d20
%endmacro
%macro M2s_cab 0
    vpsubd ymm6, ymm11, ymm0
    vmovups ymm7, [r9+480]
    vblendvps ymm8, ymm2, ymm5, ymm4
    vfmadd213ps ymm1, ymm6, ymm14
%endmacro
%macro M2s_cac 0
    vfmadd213ps ymm1, ymm6, ymm14
    vmulps ymm3, ymm8, ymm10
    vandps ymm11, ymm9, [c_sgn]
    vmovaps ymm0, ymm12
%endmacro
%macro M2s_cad 0
    vmulps ymm3, ymm8, ymm10
    vandps ymm11, ymm9, [c_sgn]
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm1, ymm13
%endmacro
%macro M2s_cae 0
M2s_d21
%endmacro
%macro M2s_caf 0
.i2l2:
M2s_d20
M2s_b195
    vmovaps [rdx+128], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
%endmacro
%macro M2s_cb0 0
    vandps ymm9, ymm10, [r9+256]
    vpsubd ymm6, ymm4, ymm0
    vmovaps [rdx+128], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
%endmacro
%macro M2s_cb1 0
    vpmaxud ymm1, ymm0, ymm15
    vpsrld ymm2, ymm1, 23
    vpslld ymm3, ymm1, 5
    vpslld ymm4, ymm1, 4
%endmacro
%macro M2s_cb2 0
    vpsrld ymm2, ymm1, 23
    vpslld ymm3, ymm1, 5
    vpslld ymm4, ymm1, 4
    vpermps ymm5, ymm2, [c_to]
%endmacro
%macro M2s_cb3 0
M2s_d22
%endmacro
%macro M2s_cb4 0
    vpslld ymm4, ymm1, 4
    vpermps ymm5, ymm2, [c_to]
    vpermps ymm6, ymm2, [c_to+32]
    vpermps ymm7, ymm2, [c_to+64]
%endmacro
%macro M2s_cb5 0
    vpermps ymm5, ymm2, [c_to]
    vpermps ymm6, ymm2, [c_to+32]
    vpermps ymm7, ymm2, [c_to+64]
    vpermps ymm8, ymm2, [c_to+96]
%endmacro
%macro M2s_cb6 0
    vpermps ymm6, ymm2, [c_to+32]
    vpermps ymm7, ymm2, [c_to+64]
    vpermps ymm8, ymm2, [c_to+96]
    vpsrld ymm9, ymm1, 20
%endmacro
%macro M2s_cb7 0
M2s_d23
%endmacro
%macro M2s_cb8 0
    vpermps ymm8, ymm2, [c_to+96]
    vpsrld ymm9, ymm1, 20
    vpermps ymm10, ymm9, [c_w8o]
    vpermps ymm11, ymm9, [c_rxo]
%endmacro
%macro M2s_cb9 0
    vpmaxud ymm5, ymm7, ymm15
    vpsrld ymm4, ymm5, 23
    vpslld ymm6, ymm5, 5
    vfmadd213ps ymm0, ymm1, [c_q8o1]
%endmacro
%macro M2s_cba 0
    vpsrld ymm4, ymm5, 23
    vpslld ymm6, ymm5, 5
    vfmadd213ps ymm0, ymm1, [c_q8o1]
    vpslld ymm8, ymm5, 4
%endmacro
%macro M2s_cbb 0
    vfmadd231ps ymm0, ymm1, ymm13
    vmulps ymm2, ymm1, ymm3
    vpmaxud ymm5, ymm7, ymm15
    vpsrld ymm4, ymm5, 23
%endmacro
%macro M2s_cbc 0
    vmulps ymm2, ymm1, ymm3
    vpmaxud ymm5, ymm7, ymm15
    vpsrld ymm4, ymm5, 23
    vpslld ymm6, ymm5, 5
%endmacro
%macro M2s_cbd 0
    vfmadd213ps ymm0, ymm1, [c_q8o0]
    vpermps ymm7, ymm4, [c_to+64]
    vblendvps ymm1, ymm10, ymm9, ymm6
    vpsrld ymm10, ymm5, 20
%endmacro
%macro M2s_cbe 0
    vblendvps ymm1, ymm10, ymm9, ymm6
    vpsrld ymm10, ymm5, 20
    vfmadd231ps ymm3, ymm2, ymm0
    vpermps ymm9, ymm4, [c_to+96]
%endmacro
%macro M2s_cbf 0
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm5, ymm13
    vmulps ymm9, ymm5, ymm4
    vandps ymm1, ymm7, [c_sgn]
%endmacro
%macro M2s_cc0 0
    vfmadd231ps ymm0, ymm5, ymm13
    vmulps ymm9, ymm5, ymm4
    vandps ymm1, ymm7, [c_sgn]
    vfmadd213ps ymm0, ymm5, [c_q8o1]
%endmacro
%macro M2s_cc1 0
    vmulps ymm9, ymm5, ymm4
    vandps ymm1, ymm7, [c_sgn]
    vfmadd213ps ymm0, ymm5, [c_q8o1]
    vfmadd213ps ymm0, ymm5, [c_q8o0]
%endmacro
%macro M2s_cc2 0
    vfmadd213ps ymm0, ymm5, [c_q8o1]
    vfmadd213ps ymm0, ymm5, [c_q8o0]
    vfmadd231ps ymm4, ymm9, ymm0
    vorps ymm3, ymm1, ymm4
%endmacro
%macro M2s_cc3 0
    sub rcx, 2
M2s_d24
    add r9, 288
    dec rcx
    jnz .i2l2s
%endmacro
%macro M2s_cc4 0
M2s_d24
M2s_cc5
%endmacro
%macro M2s_cc5 0
    add r9, 288
    dec rcx
    jnz .i2l2s
.i2l2e:
%endmacro
%macro M2s_cc6 0
.i2l2e:
    mov rax, rsi
    mov rdx, r8
    mov r9, r10
%endmacro
%macro M2s_cc7 0
    vandps ymm7, ymm6, [r9+256]
    vmovaps [rdx+128], ymm7
    vmovaps [rdx+160], ymm4
    add rax, 128
%endmacro
%macro M2s_cc8 0
    cmp rcx, 2
    jae .i2l2
.i2l2r:
    test rcx, rcx
    jz .i2l2e
M2s_d21
    vmovups ymm11, [c_q8o1]
.i2l2s:
M2s_cc9
    vpslld ymm4, ymm1, 4
%endmacro
%macro M2s_cc9 0
    vmovups ymm0, [r9+192]
    vpmaxud ymm1, ymm0, ymm15
    vpsrld ymm2, ymm1, 23
    vpslld ymm3, ymm1, 5
%endmacro
%macro M2s_cca 0
    vpslld ymm9, ymm2, 23
    vblendvps ymm2, ymm5, ymm6, ymm3
    vmovups ymm5, [rax+64]
    vblendvps ymm6, ymm7, ymm8, ymm3
%endmacro
%macro M2s_ccb 0
    vpsubd ymm7, ymm0, ymm9
    vblendvps ymm8, ymm2, ymm6, ymm4
    vfmadd213ps ymm1, ymm7, ymm14
    vmulps ymm3, ymm8, ymm10
%endmacro
%macro M2s_ccc 0
    vblendvps ymm6, ymm7, ymm8, ymm3
    vpsubd ymm7, ymm0, ymm9
    vblendvps ymm8, ymm2, ymm6, ymm4
    vfmadd213ps ymm1, ymm7, ymm14
%endmacro
%macro M2s_ccd 0
    vblendvps ymm8, ymm2, ymm6, ymm4
    vfmadd213ps ymm1, ymm7, ymm14
    vmulps ymm3, ymm8, ymm10
    vmovaps ymm0, ymm12
%endmacro
%macro M2s_cce 0
    vmovups ymm12, [c_q8o2]
.i2l0:
    vmovups ymm0, [r9]
    vpmaxud ymm1, ymm0, ymm15
%endmacro
%macro M2s_ccf 0
M2s_d25
%endmacro
%macro M2s_cd0 0
    vpermps ymm8, ymm2, [c_to+96]
    vpsrld ymm9, ymm1, 20
    vpermps ymm10, ymm9, [c_w8o]
    vpermps ymm0, ymm9, [c_rxo]
%endmacro
%macro M2s_cd1 0
    vfmadd231ps ymm0, ymm1, ymm13
    vandps ymm9, ymm5, [c_sgn]
    vmulps ymm2, ymm1, ymm3
    vfmadd213ps ymm0, ymm1, ymm11
%endmacro
%macro M2s_cd2 0
    vandps ymm9, ymm5, [c_sgn]
    vmulps ymm2, ymm1, ymm3
    vfmadd213ps ymm0, ymm1, ymm11
    vfmadd213ps ymm0, ymm1, [c_q8o0]
%endmacro
%macro M2s_cd3 0
M2s_d26
%endmacro
%macro M2s_cd4 0
    vmovups ymm9, [rax]
    vblendvps ymm2, ymm5, ymm6, ymm3
    vblendvps ymm5, ymm7, ymm8, ymm3
    vpsubd ymm6, ymm11, ymm0
%endmacro
%macro M2s_cd5 0
M2s_d27
    vmovaps [rdx+32], ymm11
    vmulps ymm4, ymm10, ymm2
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm5, ymm13
%endmacro
%macro M2s_cd6 0
    vpermps ymm10, ymm4, [c_to]
    vpermps ymm9, ymm4, [c_to+32]
    vfmadd213ps ymm0, ymm1, [c_q8o0]
    vpermps ymm7, ymm4, [c_to+64]
%endmacro
%macro M2s_cd7 0
M2s_a1d3
    vandps ymm9, ymm5, [c_sgn]
    vmulps ymm2, ymm1, ymm3
    vfmadd213ps ymm0, ymm1, ymm11
%endmacro
%macro M2s_cd8 0
    vandps ymm9, ymm10, [r9+64]
M2s_d27
    vmovaps [rdx+32], ymm11
    vmulps ymm4, ymm10, ymm2
    vmovaps ymm0, ymm12
%endmacro
%macro M2s_cd9 0
    jnz .i2l0s
.i2l0e:
    mov rax, rsi
    mov rdx, r8
%endmacro
%macro M2s_cda 0
    jae .i2l0
.i2l0r:
    test rcx, rcx
    jz .i2l0e
M2s_d21
    vmovups ymm11, [c_q8o1]
.i2l0s:
M2s_d25
    vpslld ymm4, ymm1, 4
    vpermps ymm5, ymm2, [c_to]
%endmacro
%macro M2s_cdb 0
    vblendvps ymm2, ymm5, ymm6, ymm3
    vmovups ymm5, [rax]
    vblendvps ymm6, ymm7, ymm8, ymm3
    vpsubd ymm7, ymm0, ymm9
%endmacro
%macro M2s_cdc 0
    vmovups ymm5, [rax]
    vblendvps ymm6, ymm7, ymm8, ymm3
    vpsubd ymm7, ymm0, ymm9
    vblendvps ymm8, ymm2, ymm6, ymm4
%endmacro
%macro M2s_cdd 0
    vfmadd213ps ymm1, ymm7, ymm14
    vmulps ymm3, ymm8, ymm10
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm1, ymm13
%endmacro
%macro M2s_cde 0
    vandps ymm7, ymm6, [r9+64]
    vmovaps [rdx], ymm7
    vmovaps [rdx+32], ymm4
    add rax, 128
%endmacro
%macro M2s_cdf 0
    vpslld ymm0, ymm2, 23
    vmovups ymm9, [rax+32]
    vblendvps ymm2, ymm5, ymm6, ymm3
    vblendvps ymm5, ymm7, ymm8, ymm3
%endmacro
%macro M2s_ce0 0
M2s_cdf
    vpsubd ymm6, ymm11, ymm0
    vmovups ymm7, [r9+384]
    vblendvps ymm8, ymm2, ymm5, ymm4
    vfmadd213ps ymm1, ymm6, ymm14
%endmacro
%macro M2s_ce1 0
    vmovups ymm9, [rax+32]
    vblendvps ymm2, ymm5, ymm6, ymm3
    vblendvps ymm5, ymm7, ymm8, ymm3
    vpsubd ymm6, ymm11, ymm0
%endmacro
%macro M2s_ce2 0
M2s_d29
%endmacro
%macro M2s_ce3 0
    vmulps ymm11, ymm3, [r9+128]
    vblendvps ymm3, ymm7, ymm9, ymm6
    vmovups ymm7, [rax+160]
    vandps ymm9, ymm10, [r9+160]
%endmacro
%macro M2s_ce4 0
M2s_a1e3
    vandps ymm9, ymm5, [c_sgn]
    vmulps ymm2, ymm1, ymm3
    vfmadd213ps ymm0, ymm1, ymm11
%endmacro
%macro M2s_ce5 0
    vpsubd ymm6, ymm4, ymm0
    vmovaps [rdx+64], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
    vfmadd213ps ymm5, ymm6, ymm14
    vmovaps [rdx+96], ymm11
    vmulps ymm4, ymm10, ymm2
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm5, ymm13
%endmacro
%macro M2s_ce6 0
    vmovaps [rdx+288], ymm6
    vmovaps [rdx+320], ymm8
    add rax, 256
    add rdx, 448
%endmacro
%macro M2s_ce7 0
M2s_a1e7
    vmovaps ymm14, [rdi + G_lmx + 32]
    vmovaps ymm15, [rdi + G_lmx + 64]
    vmovaps ymm12, [rdi + G_lsl]
%endmacro
%macro M2s_ce8 0
    jae .i2l1
.i2l1r:
    test rcx, rcx
    jz .i2l1e
M2s_d21
    vmovups ymm11, [c_q8o1]
.i2l1s:
M2s_d29
    vpslld ymm4, ymm1, 4
    vpermps ymm5, ymm2, [c_to]
%endmacro
%macro M2s_ce9 0
    vmovups ymm5, [rax+32]
    vblendvps ymm6, ymm7, ymm8, ymm3
    vpsubd ymm7, ymm0, ymm9
    vblendvps ymm8, ymm2, ymm6, ymm4
%endmacro
%macro M2s_cea 0
    vandps ymm7, ymm6, [r9+160]
    vmovaps [rdx+64], ymm7
    vmovaps [rdx+96], ymm4
    add rax, 128
%endmacro
%macro M2s_ceb 0
    vmulps ymm0, ymm15, [r8 + 128]
    vfmadd231ps ymm0, ymm13, [r8]
    vfmadd231ps ymm0, ymm14, [r8 + 64]
    vmovaps ymm1, ymm12
%endmacro
%macro M2s_cec 0
    vroundps ymm2, ymm0, 8
    vsubps ymm2, ymm0, ymm2
    vandps ymm2, ymm2, ymm5
    vaddps ymm2, ymm2, ymm1
    vcmpps ymm2, ymm2, ymm6, 0x05
    vcvtps2dq ymm3, ymm0
    vpaddd ymm3, ymm3, ymm7
    vpminsd ymm3, ymm3, ymm8
    vpmaxsd ymm3, ymm3, ymm9
    vextracti128 xmm4, ymm3, 1
    vpackssdw xmm3, xmm3, xmm4
    cmp r10, 8
    jb .elp
    vmovdqu [r9], xmm3
    jmp .elq
.elp:
%endmacro
%macro M2s_ced 0
    add rax, [rbp + 232]
    add rax, rax
    add rax, [rdi + G_dy]
    mov r9, rax
%endmacro
%macro M2s_cee 0
M2s_a1ee
    add r8, 224
M2s_b215
    jnz .ed
%endmacro
%macro M2s_cef 0
    push rsi
    push rdi
    mov rcx, r10
    lea rsi, [rbp + 384]
%endmacro
%macro M2s_cf0 0
    mov rdi, r9
    rep movsw
    pop rdi
    pop rsi
%endmacro
%macro M2s_cf1 0
M2s_a1f7
    vfmadd213ps ymm1, ymm0, ymm12
    vmovups [rdx + 192], ymm1
    add rax, 128
%endmacro
%macro M2s_cf2 0
    mov ecx, 8
    cmp r10, rcx
    cmovb rcx, r10
    bzhi eax, eax, ecx
%endmacro
%macro M2s_cf3 0
    cmp qword [rbp + 248], 2
M2s_d2a
    imul rax, [rbp + 40]
    mov [rbp + 232], rax
    mov rcx, [rdi + G_wo]
%endmacro
%macro M2s_cf4 0
M2s_d2a
    imul rax, [rbp + 40]
    mov [rbp + 232], rax
    mov rcx, [rdi + G_wo]
    shr rcx, 1
%endmacro
%macro M2s_cf5 0
M2s_d2b
    mov [rbp + 232], rax
    mov rcx, [rdi + G_wo]
    shr rcx, 1
    sub rcx, rax
%endmacro
%macro M2s_cf6 0
    shr rcx, 1
    sub rcx, rax
    add rcx, 7
    shr rcx, 3
%endmacro
%macro M2s_cf7 0
    mov rax, [rdi + G_cc]
    mov [rbp + 256], rax
    mov rsi, [rbp + 256]
    mov rdi, [rbp + 8]
%endmacro
%macro M2s_cf8 0
    add rdx, 224
    dec rcx
M2s_a1f8
M2s_b225
%endmacro
%macro M2s_cf9 0
    vsubps ymm7, ymm5, ymm3
    vcmpps ymm8, ymm6, ymm14, 30
    vrcpps ymm9, ymm6
    vcmpps ymm0, ymm7, ymm14, 30
%endmacro
%macro M2s_cfa 0
M2s_a1fe
M2s_b22c
.i1c0s:
    vmovups ymm0, [rax]
M2s_d19
%endmacro
%macro M2s_cfb 0
    vmovaps [r9+32], ymm9
    add rax, 128
M2s_d2c
    vmovups ymm1, [rdx+192]
    vmovups ymm2, [rax+160]
%endmacro
%macro M2s_cfc 0
M2s_d2c
    vmovups ymm1, [rdx+192]
    vmovups ymm2, [rax+160]
    vmovups ymm3, [rdx+416]
    vandps ymm4, ymm0, ymm15
%endmacro
%macro M2s_cfd 0
.i1c1s:
M2s_d1b
    vsubps ymm3, ymm2, ymm1
M2s_d1c
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+128], ymm9
%endmacro
%macro M2s_cfe 0
M2s_a20d
.i1c2:
M2s_d1d
    vandps ymm4, ymm0, ymm15
    vfmadd231ps ymm1, ymm4, ymm13
%endmacro
%macro M2s_cff 0
    vsubps ymm6, ymm4, ymm1
    vsubps ymm7, ymm5, ymm3
    vcmpps ymm8, ymm6, ymm14, 30
    vrcpps ymm9, ymm6
%endmacro
%macro M2s_c100 0
    vmovups ymm10, [c_ieq]
.i1c2s:
M2s_d1e
    vsubps ymm3, ymm2, ymm1
M2s_d1f
    vfmadd213ps ymm9, ymm12, ymm11
%endmacro
%macro M2s_c101 0
M2s_b247
    mov rcx, [rbp + 240]
    cmp rcx, 2
M2s_c102
    vmovups ymm12, [c_q8o2]
%endmacro
%macro M2s_c102 0
    jb .i2c2r
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_mone]
    vmovups ymm13, [c_q8o3]
%endmacro
%macro M2s_c103 0
    vpslld ymm0, ymm2, 23
    vmovups ymm9, [rax+64]
    vblendvps ymm2, ymm5, ymm6, ymm3
    vblendvps ymm5, ymm7, ymm8, ymm3
%endmacro
%macro M2s_c104 0
M2s_d2d
%endmacro
%macro M2s_c105 0
M2s_d2e
M2s_d21
%endmacro
%macro M2s_c106 0
M2s_d2f
%endmacro
%macro M2s_c107 0
M2s_d30
%endmacro
%macro M2s_c108 0
    vmulps ymm4, ymm3, [r9+224]
    vandps ymm7, ymm6, [r9+256]
    vmovaps [rdx+128], ymm7
    vmovaps [rdx+160], ymm4
%endmacro
%macro M2s_c109 0
    jb .i2c0r
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_mone]
    vmovups ymm13, [c_q8o3]
%endmacro
%macro M2s_c10a 0
    vpermps ymm11, ymm9, [c_rxo]
M2s_d26
    vpsubd ymm6, ymm11, ymm0
    vmovups ymm7, [r9+288]
    vblendvps ymm8, ymm2, ymm5, ymm4
%endmacro
%macro M2s_c10b 0
    vmovups ymm11, [c_q8o1]
M2s_c10c
    vpslld ymm3, ymm1, 5
    vpslld ymm4, ymm1, 4
    vpermps ymm5, ymm2, [c_to]
%endmacro
%macro M2s_c10c 0
M2s_d31
%endmacro
%macro M2s_c10d 0
    jnz .i2c0s
.i2c0e:
    mov rax, rsi
    mov rdx, r8
%endmacro
%macro M2s_c10e 0
    cmp rcx, 2
M2s_c10f
    vmovups ymm12, [c_q8o2]
.i2c1:
    vmovups ymm0, [r9+96]
%endmacro
%macro M2s_c10f 0
M2s_d32
%endmacro
%macro M2s_c110 0
    mov r9, r10
    mov rcx, [rbp + 240]
    cmp rcx, 2
M2s_d32
    vmovups ymm12, [c_q8o2]
%endmacro
%macro M2s_c111 0
M2s_c110
.i2c1:
M2s_d29
    vpslld ymm4, ymm1, 4
    vpermps ymm5, ymm2, [c_to]
    vpermps ymm6, ymm2, [c_to+32]
%endmacro
%macro M2s_c112 0
    dec rcx
    jnz .i2c0s
.i2c0e:
    mov rax, rsi
%endmacro
%macro M2s_c113 0
    vmovups ymm11, [c_q8o1]
M2s_c114
    vpslld ymm3, ymm1, 5
    vpslld ymm4, ymm1, 4
    vpermps ymm5, ymm2, [c_to]
%endmacro
%macro M2s_c114 0
.i2c1s:
    vmovups ymm0, [r9+96]
    vpmaxud ymm1, ymm0, ymm15
    vpsrld ymm2, ymm1, 23
%endmacro
%macro M2s_c115 0
    mov r10, rax
    imul rax, [rbp + 16]
    add rax, [rbp + 232]
    add rax, rax
%endmacro
%macro M2s_c116 0
    vfmadd231ps ymm0, ymm6, [r8 + 64]
M2s_d33
    vfmadd231ps ymm1, ymm5, [r8 + 32]
    vfmadd231ps ymm1, ymm6, [r8 + 96]
    vfmadd231ps ymm1, ymm8, [r8 + 160]
%endmacro
%macro M2s_c117 0
M2s_d33
    vfmadd231ps ymm1, ymm5, [r8 + 32]
    vfmadd231ps ymm1, ymm6, [r8 + 96]
    vfmadd231ps ymm1, ymm8, [r8 + 160]
M2s_a22a
%endmacro
%macro M2s_c118 0
M2s_a22a
    vpmaxsd ymm9, ymm9, ymm15
    vmovaps ymm5, [rdi + G_cmx + 160]
    vmulps ymm0, ymm5, [r8 + 128]
%endmacro
%macro M2s_c119 0
    vpmaxsd ymm9, ymm9, ymm15
    vmovaps ymm5, [rdi + G_cmx + 160]
    vmulps ymm0, ymm5, [r8 + 128]
    vmovaps ymm6, [rdi + G_cmx + 128]
%endmacro
%macro M2s_c11a 0
    cmovb rcx, r10
    bzhi eax, eax, ecx
    mov [r11], al
    add r8, 224
M2s_c11b
M2s_c11c
%endmacro
%macro M2s_c11b 0
    add r9, 16
    add r12, 16
    sub r10, 8
    inc r11
    dec rbx
    jnz .cd
    mov rdi, [rbp + 8]
    vmovdqu ymm0, [rdi + G_ms]
%endmacro
%macro M2s_c11c 0
    vpor ymm0, ymm0, [rdi + G_ms + 32]
    vpor ymm0, ymm0, [rdi + G_ms + 64]
    vpor ymm0, ymm0, [rdi + G_ms + 96]
    vpor ymm0, ymm0, [rdi + G_ms + 128]
%endmacro
%macro M2s_c11d 0
    vptest ymm0, ymm0
    jz .nf
    mov r11, 0x0101010101010101
    mov r12, 0x0706050403020100
%endmacro
%macro M2s_c11e 0
    vmovdqu ymm6, [c_iota]
    vpxor xmm7, xmm7, xmm7
    mov rsi, [rdi + G_cl]
    mov r10, [rdi + G_su]
%endmacro
%macro M2s_c11f 0
    shl r10, 3
    imul r10, [rbp + 40]
    mov r8, [rdi + G_fs]
    mov r9, [rbp + 272]
%endmacro
%macro M2s_c120 0
    xor rax, -1
    jz .fbe0
.fs0:
    tzcnt rcx, rax
%endmacro
%macro M2s_c121 0
    blsr rax, rax
    movzx ebx, byte [rdi + G_ms + 0 + rcx]
    pdep rdx, rbx, r11
    imul rdx, rdx, 255
%endmacro
%macro M2s_c122 0
M2s_d34
%endmacro
%macro M2s_c123 0
M2s_a23b
    test rax, rax
    jnz .fs0
    mov [rbp + 272], r9
%endmacro
%macro M2s_c124 0
M2s_d35
%endmacro
%macro M2s_c125 0
M2s_d36
%endmacro
%macro M2s_c126 0
.fbe0:
M2s_d37
M2s_d38
    vpmovmskb eax, ymm1
    vpmovmskb ecx, ymm2
    shl rcx, 32
%endmacro
%macro M2s_c127 0
M2s_d37
M2s_d38
M2s_d35
%endmacro
%macro M2s_c128 0
    xor rax, -1
    jz .fbe1
.fs1:
    tzcnt rcx, rax
    blsr rax, rax
    movzx ebx, byte [rdi + G_ms + 64 + rcx]
    pdep rdx, rbx, r11
    imul rdx, rdx, 255
%endmacro
%macro M2s_c129 0
    pext rdx, r12, rdx
    vmovq xmm0, rdx
    vpmovzxbd ymm0, xmm0
    mov rdx, rcx
%endmacro
%macro M2s_c12a 0
    lea edx, [r10 + rcx*8]
    vmovd xmm1, edx
    vpbroadcastd ymm1, xmm1
    vpaddd ymm1, ymm1, ymm6
%endmacro
%macro M2s_c12b 0
    vpermd ymm1, ymm0, ymm1
    vmovdqu [r8 + r9*4 + 262144], ymm1
    popcnt ebx, ebx
    add r9, rbx
%endmacro
%macro M2s_c12c 0
    test rax, rax
    jnz .fs1
    mov [rbp + 272], r9
.fbe1:
%endmacro
%macro M2s_c12d 0
    shl r10, 2
    imul r10, [rbp + 40]
    mov r8, [rdi + G_fs]
    add r8, 327680
    mov r9, [rbp + 280]
    vpcmpeqb ymm1, ymm7, [rdi + G_ms + 128]
    vpmovmskb eax, ymm1
    xor eax, -1
%endmacro
%macro M2s_c12e 0
    jz .fbe2
.fs2:
    tzcnt rcx, rax
    blsr rax, rax
%endmacro
%macro M2s_c12f 0
    movzx ebx, byte [rdi + G_ms + 128 + rcx]
M2s_d34
M2s_d36
    vpermps ymm1, ymm0, [rdx]
    vmovups [r8 + r9*4], ymm1
    vpermps ymm1, ymm0, [rdx + 32]
    vmovups [r8 + r9*4 + 16384], ymm1
    vpermps ymm1, ymm0, [rdx + 64]
    vmovups [r8 + r9*4 + 32768], ymm1
    vpermps ymm1, ymm0, [rdx + 96]
%endmacro
%macro M2s_c130 0
    vmovdqu [r8 + r9*4 + 65536], ymm1
    popcnt ebx, ebx
    add r9, rbx
    test rax, rax
    jnz .fs2
    mov [rbp + 280], r9
.fbe2:
    vpxor xmm0, xmm0, xmm0
%endmacro
%macro M2s_c131 0
    vmovdqu [rdi + G_ms + 64], ymm0
    vmovdqu [rdi + G_ms + 96], ymm0
    vmovdqu [rdi + G_ms + 128], ymm0
.nf:
%endmacro
%macro M2s_c132 0
    vpackssdw xmm4, xmm4, xmm4
M2s_c133
    add rax, [rbp + 304]
    cmp rax, [rbp + 272]
    jae .bln
%endmacro
%macro M2s_c133 0
M2s_d39
%endmacro
%macro M2s_c134 0
M2s_d3a
%endmacro
%macro M2s_c135 0
    mov rax, [rbp + 16]
    lea rcx, [rcx + rax*2]
M2s_d3b
    add rsi, rdx
    add rsi, rsi
%endmacro
%macro M2s_c136 0
M2s_d3b
    add rsi, rdx
    add rsi, rsi
    add rsi, [rdi + G_dy]
    mov [rsi], ax
%endmacro
%macro M2s_c137 0
    add rsi, [rdi + G_dy]
    mov [rsi], ax
    cmp ax, -1
    jne .blo
%endmacro
%macro M2s_c138 0
    cmp ax, -1
    jne .blo
    lea r12, [rbp + 448]
    mov qword [r12 + 1216], 0
%endmacro
%macro M2s_c139 0
    inc qword [rbp + 304]
    cmp qword [rbp + 304], 4
    jb .blj
.bln:
    add qword [rbp + 288], 4
    mov rax, [rbp + 288]
    cmp rax, [rbp + 272]
    jb .bl
%endmacro
%macro M2s_c13a 0
.ble:
    cmp qword [rbp + 280], 0
    je .bce
    mov qword [rbp + 288], 0
%endmacro
%macro M2s_c13b 0
    add rdi, 327680
    lea r12, [rbp + 448]
    call .t1c
    vpackssdw xmm4, xmm4, xmm4
%endmacro
%macro M2s_c13c 0
    add rdi, [r15 + G_fs]
    add rdi, 327680
    lea r12, [rbp + 448]
    call .t1c
%endmacro
%macro M2s_c13d 0
    call .t1l
    vpackssdw xmm4, xmm4, xmm4
M2s_d39
    add rax, [rbp + 304]
    cmp rax, [rbp + 272]
    jae .bln
M2s_d3a
    shr ecx, 16
    mov rax, [rbp + 16]
    lea rcx, [rcx + rax*2]
%endmacro
%macro M2s_c13e 0
M2s_d3c
%endmacro
%macro M2s_c13f 0
M2s_d3d
%endmacro
%macro M2s_c140 0
    mov edx, ecx
M2s_d3c
M2s_d3d
    mov [r9 + rsi], r10w
    cmp ax, -1
    jne .bco
%endmacro
%macro M2s_c141 0
    mov [r9 + rsi], r10w
    cmp ax, -1
    jne .bco
M2s_c142
M2s_c143
    cmp rax, [rbp + 280]
%endmacro
%macro M2s_c142 0
    lea r12, [rbp + 448]
    mov qword [r12 + 1216], 1
    mov [r12 + 1224], rcx
    mov [r12 + 1232], rdx
    call .fz
.bco:
    inc qword [rbp + 304]
    cmp qword [rbp + 304], 4
%endmacro
%macro M2s_c143 0
    jb .bcj
.bcn:
    add qword [rbp + 288], 4
    mov rax, [rbp + 288]
%endmacro
%macro M2s_c144 0
    mov qword [rbp + 272], 0
M2s_d3e
    mov rax, [rbp + 16]
    cmp rax, [rbp + 24]
    jb .per
%endmacro
%macro M2s_c145 0
M2s_d3e
    mov rax, [rbp + 16]
    cmp rax, [rbp + 24]
    jb .per
    mov rsp, [rbp + 0]
%endmacro
%macro M2s_c146 0
    mov rsp, [rbp + 0]
    pop r15
    pop r14
    pop r13
%endmacro
%macro M2s_c147 0
    pop r15
    pop r14
    pop r13
    pop r12
%endmacro
%macro M2s_c148 0
    ret
.fr:
    mov rdi, [rbp + 8]
    mov rcx, [rbp + 72]
%endmacro
%macro M2s_c149 0
.fr:
    mov rdi, [rbp + 8]
    mov rcx, [rbp + 72]
    mov rax, rcx
%endmacro
%macro M2s_c14a 0
M2s_d3f
%endmacro
%macro M2s_c14b 0
M2s_d40
%endmacro
%macro M2s_c14c 0
    mov rsi, [rdi + G_cr]
    lea rsi, [rsi + rdx*8]
M2s_d3f
M2s_d40
M2s_d41
    shl rsi, 2
    add rsi, rbx
%endmacro
%macro M2s_c14d 0
M2s_d41
    shl rsi, 2
    add rsi, rbx
M2s_c14f
    vmovaps ymm11, [c_xbcb]
    xor edx, edx
%endmacro
%macro M2s_c14e 0
M2s_d42
M2s_c14f
M2s_c150
%endmacro
%macro M2s_c14f 0
    mov rdi, [rdi + G_sp]
    lea rdi, [rsi + rdi*4]
    mov r13, [rbp + 64]
    shl r13, 3
    vmovdqu ymm7, [c_n64]
    vmovaps ymm8, [c_xrcr]
    vmovaps ymm9, [c_xgcr]
    vmovaps ymm10, [c_xgcb]
%endmacro
%macro M2s_c150 0
    vmovaps ymm11, [c_xbcb]
    xor edx, edx
.frl:
    vpmovzxwd ymm0, [rcx + rdx*2]
%endmacro
%macro M2s_c151 0
.frl:
    vpmovzxwd ymm0, [rcx + rdx*2]
    vpaddd ymm0, ymm0, ymm7
    vcvtdq2ps ymm0, ymm0
%endmacro
%macro M2s_c152 0
    vpaddd ymm0, ymm0, ymm7
    vcvtdq2ps ymm0, ymm0
    vmulps ymm1, ymm12, [r8 + rdx*8]
    vmulps ymm2, ymm12, [r8 + rdx*8 + 32]
%endmacro
%macro M2s_c153 0
    vmulps ymm2, ymm12, [r8 + rdx*8 + 32]
M2s_d43
    vfmadd231ps ymm1, ymm15, [r11 + rdx*8]
    vfmadd231ps ymm2, ymm15, [r11 + rdx*8 + 32]
    vmovaps ymm3, ymm0
%endmacro
%macro M2s_c154 0
M2s_d43
    vfmadd231ps ymm1, ymm15, [r11 + rdx*8]
    vfmadd231ps ymm2, ymm15, [r11 + rdx*8 + 32]
    vmovaps ymm3, ymm0
    vfmadd231ps ymm3, ymm2, ymm8
%endmacro
%macro M2s_c155 0
    vmovaps ymm4, ymm0
    vfmadd231ps ymm4, ymm2, ymm9
    vfmadd231ps ymm4, ymm1, ymm10
    vfmadd231ps ymm0, ymm1, ymm11
%endmacro
%macro M2s_c156 0
    vmovups [rbx + rdx*4], ymm3
    vmovups [rsi + rdx*4], ymm4
    vmovups [rdi + rdx*4], ymm0
    add rdx, 8
%endmacro
%macro M2s_c157 0
.pf32:
    prefetcht0 [rax + 1984]
.pf31:
    prefetcht0 [rax + 1920]
%endmacro
%macro M2s_c158 0
    imul rcx, [rdi + G_ys]
    add rcx, rdx
    add rcx, rcx
    add rcx, [rdi + G_sy]
%endmacro
%macro M2s_c159 0
.pf28:
    prefetcht0 [rax + 1728]
.pf27:
    prefetcht0 [rax + 1664]
%endmacro
%macro M2s_c15a 0
    prefetcht0 [rax + 1728]
.pf27:
    prefetcht0 [rax + 1664]
.pf26:
%endmacro
%macro M2s_c15b 0
M2s_d44
%endmacro
%macro M2s_c15c 0
M2s_d45
%endmacro
%macro M2s_c15d 0
.pf24:
M2s_d45
M2s_d46
    prefetcht0 [rax + 1088]
.pf17:
    prefetcht0 [rax + 1024]
%endmacro
%macro M2s_c15e 0
M2s_d46
    prefetcht0 [rax + 1088]
.pf17:
    prefetcht0 [rax + 1024]
M2s_d47
.pf14:
%endmacro
%macro M2s_c15f 0
M2s_d47
.pf14:
    prefetcht0 [rax + 832]
.pf13:
    prefetcht0 [rax + 768]
%endmacro
%macro M2s_c160 0
    prefetcht0 [rax + 832]
.pf13:
    prefetcht0 [rax + 768]
M2s_c161
.pf10:
%endmacro
%macro M2s_c161 0
.pf12:
    prefetcht0 [rax + 704]
.pf11:
    prefetcht0 [rax + 640]
%endmacro
%macro M2s_c162 0
    prefetcht0 [rax + 512]
.pf8:
    prefetcht0 [rax + 448]
.pf7:
%endmacro
%macro M2s_c163 0
.pf8:
    prefetcht0 [rax + 448]
.pf7:
    prefetcht0 [rax + 384]
%endmacro
%macro M2s_c164 0
.pf6:
M2s_b2f6
    prefetcht0 [rax + 64]
.pf1:
%endmacro
%macro M2s_c165 0
    mov rdi, [rbp + 8]
M2s_d44
    imul rax, rax, 12
    add rbx, rax
    mov r13, [rbp + 64]
%endmacro
%macro M2s_c166 0
    lea r15, [r13 - 16]
    vmovups ymm15, [rbp+1152]
    vmovups ymm14, [rbp+1184]
    vmovups ymm13, [rbp+1216]
%endmacro
%macro M2s_c167 0
M2s_d49
%endmacro
%macro M2s_c168 0
    shl r13, 3
    mov r9, [rdi + G_sg]
    mov [rbp + 336], r9
    mov rcx, [rbp + 72]
%endmacro
%macro M2s_c169 0
M2s_d4a
    add rax, [rdi + G_rd]
    vbroadcastss ymm0, [rax + Rc_k + 0]
    vmovaps [rbp + 1152], ymm0
    vbroadcastss ymm0, [rax + Rc_k + 4]
%endmacro
%macro M2s_c16a 0
    vbroadcastss ymm0, [rax + Rc_k + 0]
    vmovaps [rbp + 1152], ymm0
    vbroadcastss ymm0, [rax + Rc_k + 4]
    vmovaps [rbp + 1184], ymm0
%endmacro
%macro M2s_c16b 0
    vmovaps [rbp + 1152], ymm0
    vbroadcastss ymm0, [rax + Rc_k + 4]
    vmovaps [rbp + 1184], ymm0
    vbroadcastss ymm0, [rax + Rc_k + 8]
%endmacro
%macro M2s_c16c 0
    vmovaps [rbp + 1248], ymm0
M2s_d4b
    mov rdx, [rbp + 56]
    mov rsi, [rdi + G_cr]
    lea rsi, [rsi + rdx*8]
%endmacro
%macro M2s_c16d 0
M2s_d4b
    mov rdx, [rbp + 56]
    mov rsi, [rdi + G_cr]
    lea rsi, [rsi + rdx*8]
    lea r9, [rsi + r9*4]
%endmacro
%macro M2s_c16e 0
    lea r9, [rsi + r9*4]
    lea r10, [rsi + r10*4]
    lea r11, [rsi + r11*4]
    lea r12, [rsi + r12*4]
%endmacro
%macro M2s_c16f 0
    lea r10, [rsi + r10*4]
    lea r11, [rsi + r11*4]
    lea r12, [rsi + r12*4]
    imul rcx, [rdi + G_ys]
%endmacro
%macro M2s_c170 0
    vmulps ymm1, ymm15, [r9+rdx*8]
    vmulps ymm2, ymm15, [r9+rdx*8+32]
    vfmadd231ps ymm1, ymm14, [r10+rdx*8]
    vpaddd ymm3, ymm0, ymm7
%endmacro
%macro M2s_c171 0
M2s_d4c
%endmacro
%macro M2s_c172 0
.fq0:
M2s_a27a
M2s_a283
M2s_b315
%endmacro
%macro M2s_c173 0
M2s_a27a
M2s_a283
M2s_b315
M2s_b317
%endmacro
%macro M2s_c174 0
    vpsubd ymm1, ymm3, ymm0
    vfmadd213ps ymm4, ymm1, [c_mone]
M2s_c175
    vpaddd ymm1, ymm3, ymm7
    vmulps ymm2, ymm15, [r9+rdx*8+96]
%endmacro
%macro M2s_c175 0
M2s_d4d
%endmacro
%macro M2s_c176 0
    vfmadd231ps ymm0, ymm14, [r10+rdx*8+64]
    vcvtdq2ps ymm4, ymm1
    vfmadd231ps ymm2, ymm14, [r10+rdx*8+96]
    vfmadd231ps ymm0, ymm13, [r11+rdx*8+64]
%endmacro
%macro M2s_c177 0
M2s_a283
    vpsubd ymm1, ymm3, ymm0
    vfmadd213ps ymm4, ymm1, [c_mone]
M2s_d4d
    vpaddd ymm1, ymm3, ymm7
%endmacro
%macro M2s_c178 0
M2s_d4e
%endmacro
%macro M2s_c179 0
    vfmadd231ps ymm2, ymm13, [r11+rdx*8+96]
    vfmadd231ps ymm0, ymm12, [r12+rdx*8+64]
    vfmadd231ps ymm2, ymm12, [r12+rdx*8+96]
    vmovaps ymm3, ymm4
%endmacro
%macro M2s_c17a 0
    vfmadd231ps ymm3, ymm2, ymm11
    vmovaps [rdi+rdx*4+32], ymm3
    vfmadd213ps ymm2, ymm10, ymm4
    vfmadd231ps ymm4, ymm0, ymm8
%endmacro
%macro M2s_c17b 0
M2s_d4f
%endmacro
%macro M2s_c17c 0
    vmovaps ymm3, ymm4
    vfmadd231ps ymm3, ymm2, ymm11
    vmovaps [rdi+rdx*4+32], ymm3
    vfmadd213ps ymm2, ymm10, ymm4
%endmacro
%macro M2s_c17d 0
    vfmadd231ps ymm4, ymm0, ymm8
    vfmadd231ps ymm2, ymm0, ymm9
    vmovaps [r14+rdx*4+32], ymm4
    vmovups ymm1, [rbx+rdx*4+32]
%endmacro
%macro M2s_c17e 0
M2s_d50
%endmacro
%macro M2s_c17f 0
M2s_c180
    vfmadd231ps ymm2, ymm12, [r12+rdx*8+32]
    vmovaps ymm0, ymm4
    vfmadd231ps ymm0, ymm2, ymm11
    vmovaps [rdi+rdx*4], ymm0
%endmacro
%macro M2s_c180 0
M2s_d51
%endmacro
%macro M2s_c181 0
    vfmadd231ps ymm1, ymm13, [r11+rdx*8]
    vfmadd231ps ymm2, ymm13, [r11+rdx*8+32]
    vfmadd231ps ymm1, ymm12, [r12+rdx*8]
    vfmadd231ps ymm2, ymm12, [r12+rdx*8+32]
%endmacro
%macro M2s_c182 0
    vmovups ymm3, [rbx+rdx*4]
    vmovaps [rsi+rdx*4], ymm2
    vandps ymm0, ymm3, ymm6
M2s_b32e
%endmacro
%macro M2s_c183 0
    vxorps ymm1, ymm3, ymm0
    vpmaxud ymm4, ymm0, ymm5
    vpsrld ymm2, ymm4, 23
    vpmaddwd ymm3, ymm2, [c_k5]
%endmacro
%macro M2s_c184 0
    vpslld ymm0, ymm2, 23
    vpsrld ymm2, ymm3, 14
    vpsrld ymm3, ymm3, 17
    vpermd ymm3, ymm3, [c_p8]
%endmacro
%macro M2s_c185 0
M2s_a28d
M2s_a291
    jbe .fq0
.fq0r:
    cmp rdx, r13
    jae .fq0e
M2s_d49
M2s_d4e
    vmovups ymm7, [c_n64]
    vmovups ymm6, [c_absm]
%endmacro
%macro M2s_c186 0
M2s_d52
M2s_d4c
M2s_d4f
%endmacro
%macro M2s_c187 0
    vmovups ymm5, [c_xflr]
.fq0s:
M2s_d50
    vpaddd ymm3, ymm0, ymm7
    vfmadd231ps ymm2, ymm14, [r10+rdx*8+32]
%endmacro
%macro M2s_c188 0
M2s_d53
    vfmadd231ps ymm1, ymm14, [r10+rdx*8]
    vpaddd ymm3, ymm0, ymm7
    vfmadd231ps ymm2, ymm14, [r10+rdx*8+32]
    vcvtdq2ps ymm4, ymm3
%endmacro
%macro M2s_c189 0
    vpaddd ymm3, ymm0, ymm7
    vfmadd231ps ymm2, ymm14, [r10+rdx*8+32]
M2s_d51
    vfmadd231ps ymm2, ymm12, [r12+rdx*8+32]
    vmovaps ymm0, ymm4
%endmacro
%macro M2s_c18a 0
    vfmadd213ps ymm2, ymm10, ymm4
    vfmadd231ps ymm4, ymm1, ymm8
    vfmadd231ps ymm2, ymm1, ymm9
    vmovaps [r14+rdx*4], ymm4
%endmacro
%macro M2s_c18b 0
    vfmadd231ps ymm4, ymm1, ymm8
    vfmadd231ps ymm2, ymm1, ymm9
    vmovaps [r14+rdx*4], ymm4
    vmovups ymm3, [rbx+rdx*4]
%endmacro
%macro M2s_c18c 0
    vpaddd ymm1, ymm1, ymm2
    vorps ymm2, ymm1, ymm0
    vpsrld ymm1, ymm4, 20
    vpermps ymm0, ymm1, [c_w8e]
%endmacro
%macro M2s_c18d 0
    jb .fq0s
.fq0e:
    jmp .fw
.fu:
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .fp0r
%endmacro
%macro M2s_c18e 0
    vpsubd ymm1, ymm3, ymm0
    vfmadd213ps ymm4, ymm1, [c_mone]
    vmovaps [r8+32], ymm2
    vmovaps [r8], ymm4
%endmacro
%macro M2s_c18f 0
M2s_d55
    vpsrld ymm8, ymm5, 23
    vpsrld ymm9, ymm5, 20
M2s_d56
    vpermps ymm14, ymm9, [c_rxe]
    vpmaddwd ymm0, ymm13, [c_k5]
%endmacro
%macro M2s_c190 0
M2s_d56
    vpermps ymm14, ymm9, [c_rxe]
    vpmaddwd ymm0, ymm13, [c_k5]
    vpslld ymm2, ymm13, 23
    vpsrld ymm1, ymm7, 20
%endmacro
%macro M2s_c191 0
    vpslld ymm2, ymm13, 23
    vpsrld ymm1, ymm7, 20
M2s_c192
    vpermd ymm1, ymm13, [c_p8]
    vpermd ymm10, ymm9, [c_c8]
%endmacro
%macro M2s_c192 0
    vpermps ymm3, ymm1, [c_w8e]
    vpermps ymm8, ymm1, [c_rxe]
    vpsrld ymm9, ymm10, 14
    vpsrld ymm13, ymm10, 17
%endmacro
%macro M2s_c193 0
    vpaddd ymm9, ymm1, ymm10
    vorps ymm14, ymm9, ymm4
    vmulps ymm8, ymm14, ymm12
    vmovaps [r8], ymm5
    vpaddd ymm2, ymm0, ymm11
    vorps ymm13, ymm2, ymm6
    vmovaps [r8+288], ymm7
    vmulps ymm1, ymm13, ymm3
%endmacro
%macro M2s_c194 0
    vmovaps [r8+32], ymm8
    vmovaps [r8+320], ymm1
    add r8, 576
    add rdx, 16
%endmacro
%macro M2s_c195 0
    cmp rdx, r13
M2s_d57
M2s_a2a3
    jb .fp0s
.fp0e:
%endmacro
%macro M2s_c196 0
M2s_d57
M2s_a2a3
    jb .fp0s
.fp0e:
.fw:
%endmacro
%macro M2s_c197 0
.fw:
M2s_a2a4
    lea r14, [rbx + r12*2]
    mov rdi, [rbp + 136]
%endmacro
%macro M2s_c198 0
M2s_a2a4
    lea r14, [rbx + r12*2]
    mov rdi, [rbp + 136]
    mov rcx, [rbp + 152]
%endmacro
%macro M2s_c199 0
    jb .fp1r
M2s_b350
    vmovups ymm4, [rsi+rdx*4+32]
    vandps ymm5, ymm0, ymm15
%endmacro
%macro M2s_c19a 0
M2s_d58
%endmacro
%macro M2s_c19b 0
    vmovups ymm11, [c_q8e3]
    vmovups ymm10, [c_q8e2]
    vmovups ymm9, [c_q8e1]
    vmovups ymm8, [c_q8e0]
%endmacro
%macro M2s_c19c 0
M2s_d59
%endmacro
%macro M2s_c19d 0
    vmovups ymm12, [c_mone]
    vmovups ymm11, [c_q8e3]
    vmovups ymm10, [c_q8e2]
    vmovups ymm9, [c_q8e1]
%endmacro
%macro M2s_c19e 0
    vpsrld ymm5, ymm3, 20
    vpmaddwd ymm6, ymm4, ymm13
    vpslld ymm7, ymm4, 23
    vpermps ymm0, ymm5, [c_w8e]
    vpermps ymm1, ymm5, [c_rxe]
    vpsrld ymm4, ymm6, 14
    vpsrld ymm5, ymm6, 17
    vpermd ymm6, ymm5, [c_p8]
%endmacro
%macro M2s_c19f 0
    vandps ymm1, ymm0, ymm15
    vxorps ymm2, ymm0, ymm1
    vpmaxud ymm3, ymm1, ymm14
    vpsrld ymm4, ymm3, 23
%endmacro
%macro M2s_c1a0 0
    vpaddd ymm1, ymm6, ymm5
    vorps ymm7, ymm1, ymm2
    vmovaps [r8], ymm3
    vmulps ymm4, ymm7, ymm0
    vmovaps [r8+32], ymm4
    add r8, 288
    add rdx, 8
    cmp rdx, r13
%endmacro
%macro M2s_c1a1 0
    mov rdi, [rbp + 8]
    mov r12, [rdi + G_sp]
    shl r12, 2
    lea rsi, [rbx + r12]
%endmacro
%macro M2s_c1a2 0
M2s_d5a
%endmacro
%macro M2s_c1a3 0
    vmulps ymm8, ymm1, ymm2
    vpsrld ymm9, ymm7, 23
    vpsrld ymm10, ymm7, 20
    vandps ymm11, ymm4, ymm15
%endmacro
%macro M2s_c1a4 0
    vpsrld ymm9, ymm7, 23
    vpsrld ymm10, ymm7, 20
    vandps ymm11, ymm4, ymm15
    vpmaddwd ymm0, ymm9, ymm13
%endmacro
%macro M2s_c1a5 0
    vpsrld ymm3, ymm4, 20
    vmovups ymm1, [r8+288]
    vmulps ymm6, ymm10, ymm0
    vpsubd ymm10, ymm11, ymm5
    vmovaps [rbx+rdx*4], ymm2
    vaddps ymm0, ymm2, [rcx+rdx*4]
    vpmaddwd ymm11, ymm8, ymm13
    vmovups ymm5, [r8+320]
%endmacro
%macro M2s_c1a6 0
M2s_a2b3
    vmovaps [rdi+rdx*4], ymm0
    vmovups ymm3, [c_q8e2]
    vmovaps [r8+128], ymm6
%endmacro
%macro M2s_c1a7 0
M2s_a2b4
    vmovaps [r8+96], ymm7
M2s_a2b5
    vorps ymm2, ymm8, ymm9
%endmacro
%macro M2s_c1a8 0
    vfmadd231ps ymm3, ymm1, [c_q8e3]
    vmulps ymm0, ymm2, ymm10
    vmovaps [r8+384], ymm4
    vmovaps [r8+416], ymm0
%endmacro
%macro M2s_c1a9 0
    vfmadd213ps ymm3, ymm1, [c_q8e1]
    vfmadd213ps ymm3, ymm1, [c_q8e0]
    vfmadd231ps ymm5, ymm7, ymm3
    vmovaps [rbx+rdx*4+32], ymm5
%endmacro
%macro M2s_c1aa 0
M2s_a2b6
    cmp rdx, r15
    jbe .fp1
.fp1r:
%endmacro
%macro M2s_c1ab 0
M2s_d5b
%endmacro
%macro M2s_c1ac 0
    vpsrld ymm0, ymm11, 14
    vpsrld ymm6, ymm11, 17
    vpermd ymm11, ymm6, [c_p8]
    vpermd ymm6, ymm0, [c_c8]
%endmacro
%macro M2s_c1ad 0
M2s_d5c
%endmacro
%macro M2s_c1ae 0
    vaddps ymm11, ymm5, [rcx+rdx*4+32]
    vmovaps [rdi+rdx*4+32], ymm11
    add r8, 576
    add rdx, 16
%endmacro
%macro M2s_c1af 0
    vmovups ymm11, [c_q8e3]
.fp1s:
    vmovups ymm0, [rsi+rdx*4]
    vmovups ymm1, [r8]
%endmacro
%macro M2s_c1b0 0
    vpaddd ymm9, ymm0, ymm10
    vmovaps [r8+96], ymm6
    vorps ymm8, ymm9, ymm5
    vfmadd231ps ymm2, ymm7, ymm4
%endmacro
%macro M2s_c1b1 0
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .fp2r
%endmacro
%macro M2s_c1b2 0
    vandps ymm3, ymm0, ymm15
    vmovaps ymm4, ymm1
    vfmadd213ps ymm4, ymm11, [c_q8e2]
    vxorps ymm5, ymm0, ymm3
%endmacro
%macro M2s_c1b3 0
    vfmadd213ps ymm4, ymm1, [c_q8e1]
    vpsrld ymm9, ymm10, 14
    vpsrld ymm10, ymm10, 17
    vpsubd ymm8, ymm8, ymm0
%endmacro
%macro M2s_c1b4 0
M2s_d5d
%endmacro
%macro M2s_c1b5 0
    vpermd ymm0, ymm10, [c_p8]
    vpermd ymm10, ymm9, [c_c8]
    vfmadd213ps ymm6, ymm8, ymm12
    vfmadd213ps ymm4, ymm1, [c_q8e0]
%endmacro
%macro M2s_c1b6 0
    vmovaps [rdi+rdx*4], ymm0
    add r8, 288
    add rdx, 8
    cmp rdx, r13
%endmacro
%macro M2s_c1b7 0
    add rdi, rax
    mov rax, [rbp + 160]
    imul rax, rax, 1
    add rcx, rax
%endmacro
%macro M2s_c1b8 0
    vmovups ymm0, [r14+rdx*4]
    vmovups ymm1, [r8+96]
    vmovups ymm2, [r8+128]
    vmovups ymm3, [c_q8e2]
%endmacro
%macro M2s_c1b9 0
    vpsrld ymm3, ymm4, 20
    vmovups ymm1, [r8+384]
    vmulps ymm6, ymm10, ymm0
    vpsubd ymm10, ymm11, ymm5
    vmovaps [rsi+rdx*4], ymm2
    vaddps ymm0, ymm2, [rcx+rdx*4]
    vpmaddwd ymm11, ymm8, ymm13
    vmovups ymm5, [r8+416]
M2s_d5b
M2s_d5f
%endmacro
%macro M2s_c1ba 0
M2s_d5e
    vpslld ymm2, ymm8, 23
    vpermps ymm10, ymm3, [c_w8e]
    vpermps ymm8, ymm3, [c_rxe]
M2s_d5f
    vpsrld ymm6, ymm11, 17
%endmacro
%macro M2s_c1bb 0
    vmovaps [r8+192], ymm7
M2s_d5c
    vorps ymm2, ymm8, ymm9
    vfmadd231ps ymm3, ymm1, [c_q8e3]
    vmulps ymm0, ymm2, ymm10
%endmacro
%macro M2s_c1bc 0
    vfmadd231ps ymm3, ymm1, [c_q8e3]
    vmulps ymm0, ymm2, ymm10
    vmovaps [r8+480], ymm4
    vmovaps [r8+512], ymm0
%endmacro
%macro M2s_c1bd 0
    vmovaps [r8+480], ymm4
    vmovaps [r8+512], ymm0
    vfmadd213ps ymm3, ymm1, [c_q8e1]
    vfmadd213ps ymm3, ymm1, [c_q8e0]
%endmacro
%macro M2s_c1be 0
    vpermd ymm11, ymm6, [c_p8]
    vpermd ymm6, ymm0, [c_c8]
M2s_d60
    vpaddd ymm8, ymm11, ymm6
    vorps ymm2, ymm8, ymm9
%endmacro
%macro M2s_c1bf 0
    cmp rdx, r15
    jbe .fp2
.fp2r:
    cmp rdx, r13
    jae .fp2e
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xflr]
    vmovups ymm13, [c_k5]
%endmacro
%macro M2s_c1c0 0
    vmovups ymm0, [r14+rdx*4]
    vmovups ymm1, [r8+96]
    vmovups ymm2, [r8+128]
    vandps ymm3, ymm0, ymm15
%endmacro
%macro M2s_c1c1 0
    vpmaxud ymm6, ymm3, ymm14
M2s_d5d
    vpslld ymm0, ymm8, 23
    vpermps ymm3, ymm9, [c_w8e]
    vpermps ymm8, ymm9, [c_rxe]
%endmacro
%macro M2s_c1c2 0
    vpaddd ymm9, ymm0, ymm10
M2s_c1c3
    vmovaps [r8+224], ymm1
    vaddps ymm0, ymm2, [rcx+rdx*4]
    vmovaps [rsi+rdx*4], ymm2
%endmacro
%macro M2s_c1c3 0
    vmovaps [r8+192], ymm6
    vorps ymm8, ymm9, ymm5
    vfmadd231ps ymm2, ymm7, ymm4
    vmulps ymm1, ymm8, ymm3
%endmacro
%macro M2s_c1c4 0
    mov r11, [rbp + 136]
    mov r10, [rbp + 152]
    mov rax, [rbp + 144]
    imul rax, rax, 3
    add r11, rax
    mov rax, [rbp + 160]
    imul rax, rax, 3
    add r10, rax
%endmacro
%macro M2s_c1c5 0
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .fp3r
    lea r15, [r13 - 16]
%endmacro
%macro M2s_c1c6 0
    vmovups ymm10, [c_q8e2]
    vmovups ymm9, [c_q8e1]
    vmovups ymm8, [c_q8e0]
    vmovups ymm7, [c_c8]
%endmacro
%macro M2s_c1c7 0
    add rdi, rax
    mov rax, [rbp + 160]
    imul rax, rax, 2
    add rcx, rax
%endmacro
%macro M2s_c1c8 0
M2s_c1c9
    vmovups ymm4, [r8+512]
    vmovaps ymm5, ymm10
    vfmadd231ps ymm5, ymm0, ymm11
    vminps ymm6, ymm2, [rsi+rdx*4]
%endmacro
%macro M2s_c1c9 0
    vmovups ymm0, [r8+192]
    vmovups ymm1, [r8+224]
    vmovups ymm2, [rbx+rdx*4]
    vmovups ymm3, [r8+480]
%endmacro
%macro M2s_c1ca 0
    vmovups ymm3, [r8+480]
    vmovups ymm4, [r8+512]
    vmovaps ymm5, ymm10
    vfmadd231ps ymm5, ymm0, ymm11
%endmacro
%macro M2s_c1cb 0
    vfmadd213ps ymm5, ymm0, ymm9
    vfmadd213ps ymm5, ymm0, ymm8
    vmulps ymm2, ymm0, ymm1
    vfmadd231ps ymm1, ymm2, ymm5
%endmacro
%macro M2s_c1cc 0
    vminps ymm1, ymm2, [rsi+rdx*4+32]
M2s_d61
M2s_d62
    add r8, 576
    add rdx, 16
    cmp rdx, r15
%endmacro
%macro M2s_c1cd 0
M2s_d61
M2s_d62
    add r8, 576
    add rdx, 16
    cmp rdx, r15
    jbe .fp3
%endmacro
%macro M2s_c1ce 0
    jbe .fp3
.fp3r:
    cmp rdx, r13
    jae .fp3e
M2s_d58
%endmacro
%macro M2s_c1cf 0
M2s_d63
M2s_d59
%endmacro
%macro M2s_c1d0 0
M2s_a2d1
M2s_d64
    vmovaps [rdi+rdx*4], ymm0
    vminps ymm3, ymm4, ymm2
    vaddps ymm1, ymm3, [r10+rdx*4]
%endmacro
%macro M2s_c1d1 0
M2s_d64
    vmovaps [rdi+rdx*4], ymm0
    vminps ymm3, ymm4, ymm2
    vaddps ymm1, ymm3, [r10+rdx*4]
    vmovaps [r11+rdx*4], ymm1
%endmacro
%macro M2s_c1d2 0
    vmovaps [r11+rdx*4], ymm1
    add r8, 288
    add rdx, 8
    cmp rdx, r13
%endmacro
%macro M2s_c1d3 0
    add r8, 288
    add rdx, 8
    cmp rdx, r13
    jb .fp3s
%endmacro
%macro M2s_c1d4 0
M2s_d65
M2s_c1d5
%endmacro
%macro M2s_c1d5 0
    vfmadd231ps ymm3, ymm0, ymm11
    vminps ymm4, ymm2, [rsi+rdx*4]
    vfmadd213ps ymm3, ymm0, ymm9
    vfmadd213ps ymm3, ymm0, ymm8
%endmacro
%macro M2s_c1d6 0
    vmovaps ymm10, [c_q8e2]
    vmovaps ymm9, [c_q8e1]
    vmovaps ymm8, [c_q8e0]
    mov rdi, [rbp + 8]
    mov rbx, [rdi + G_xb]
    mov r12, [rdi + G_sp]
    shl r12, 2
    mov r13, [rbp + 64]
%endmacro
%macro M2s_c1d7 0
    shl r13, 3
    mov eax, [rbp + 72]
    and eax, 1
    imul rax, r12
%endmacro
%macro M2s_c1d8 0
    mov rsi, rbx
    mov rdi, [rbp + 136]
    mov rcx, [rbp + 152]
    mov r8, [rbp + 176]
%endmacro
%macro M2s_c1d9 0
    mov rdi, [rbp + 136]
    mov rcx, [rbp + 152]
    mov rax, [rbp + 144]
    imul rax, rax, 1
%endmacro
%macro M2s_c1da 0
M2s_c1db
M2s_c1df
%endmacro
%macro M2s_c1db 0
M2s_d66
%endmacro
%macro M2s_c1dc 0
    vpslld ymm2, ymm2, 23
M2s_d6a
%endmacro
%macro M2s_c1dd 0
M2s_d6a
    vpermps ymm4, ymm4, [c_rxe]
%endmacro
%macro M2s_c1de 0
    vpsrld ymm3, ymm3, 17
    vpermd ymm4, ymm4, [c_c8]
    vpermd ymm3, ymm3, [c_p8]
    vpaddd ymm3, ymm3, ymm4
%endmacro
%macro M2s_c1df 0
M2s_c1de
    vpsrld ymm4, ymm1, 20
    vpermps ymm5, ymm4, [c_w8e]
    vpermps ymm4, ymm4, [c_rxe]
    vmulps ymm3, ymm3, ymm5
%endmacro
%macro M2s_c1e0 0
    vpermd ymm4, ymm4, [c_c8]
    vpermd ymm3, ymm3, [c_p8]
    vpaddd ymm3, ymm3, ymm4
    vpsrld ymm4, ymm1, 20
%endmacro
%macro M2s_c1e1 0
M2s_d6b
%endmacro
%macro M2s_c1e2 0
    vfmadd213ps ymm5, ymm4, ymm9
    vfmadd213ps ymm5, ymm4, ymm8
    vmulps ymm4, ymm4, ymm3
    vfmadd213ps ymm5, ymm4, ymm3
%endmacro
%macro M2s_c1e3 0
M2s_d6c
%endmacro
%macro M2s_c1e4 0
    imul rax, rax, 1
    add r8, rax
    mov rax, [rbp + 200]
    imul rax, rax, 1
    add r9, rax
    xor edx, edx
.ls1:
M2s_d66
    vpsrld ymm3, ymm3, 17
%endmacro
%macro M2s_c1e5 0
    vorps ymm5, ymm5, ymm0
    vmovups [rsi + rdx*4], ymm5
M2s_d6c
    vfmadd231ps ymm0, ymm5, ymm7
    vmovups [r8 + rdx*4], ymm0
%endmacro
%macro M2s_c1e6 0
    add rdx, 8
    cmp rdx, r13
    jb .ls1
    lea rsi, [rbx + r12*2]
%endmacro
%macro M2s_c1e7 0
    mov rdi, [rbp + 136]
    mov rcx, [rbp + 152]
    mov rax, [rbp + 144]
    imul rax, rax, 2
%endmacro
%macro M2s_c1e8 0
    mov r11, [rbp + 152]
M2s_d6e
M2s_d6f
    imul rax, rax, 3
    add r15, rax
    lea rax, [rbx + r12]
%endmacro
%macro M2s_c1e9 0
M2s_d6e
M2s_d6f
    imul rax, rax, 3
    add r15, rax
    lea rax, [rbx + r12]
    xor edx, edx
%endmacro
%macro M2s_c1ea 0
    xor edx, edx
.ls2:
M2s_d67
    vpsrld ymm2, ymm1, 23
    vpmaddwd ymm3, ymm2, ymm13
%endmacro
%macro M2s_c1eb 0
M2s_d70
M2s_d69
%endmacro
%macro M2s_c1ec 0
    vorps ymm5, ymm5, ymm0
    vmovups ymm0, [rcx + rdx*4]
    vfmadd231ps ymm0, ymm5, ymm6
    vmovups [rdi + rdx*4], ymm0
%endmacro
%macro M2s_c1ed 0
    vmovups ymm1, [rbx + rdx*4]
    vminps ymm1, ymm1, [rax + rdx*4]
    vxorps ymm2, ymm2, ymm2
    vminps ymm2, ymm5, ymm2
%endmacro
%macro M2s_c1ee 0
    vpermps ymm4, ymm4, [c_rxe]
    vmulps ymm3, ymm3, ymm5
    vpsubd ymm4, ymm4, ymm2
    vfmadd213ps ymm4, ymm1, ymm12
%endmacro
%macro M2s_c1ef 0
    vmulps ymm3, ymm3, ymm5
M2s_d6b
    vfmadd213ps ymm5, ymm4, ymm9
    vfmadd213ps ymm5, ymm4, ymm8
    vmulps ymm4, ymm4, ymm3
%endmacro
%macro M2s_c1f0 0
.rowz:
    mov rax, [rbp + 72]
    cmp rax, [rbp + 344]
    je .rqz
    call .fr
.rqz:
M2s_d48
    shl r13, 3
    mov r9, [rdi + G_sg]
%endmacro
%macro M2s_c1f1 0
M2s_d71
    and eax, 1
    imul rax, [rdi + G_sp]
    imul rax, rax, 12
    add rbx, rax
    mov r13, [rbp + 64]
    shl r13, 3
    mov r9, [rdi + G_sg]
    mov [rbp + 336], r9
%endmacro
%macro M2s_c1f2 0
    cmp rcx, [rbp + 352]
    jae .zu
M2s_d4a
    add rax, [rdi + G_rd]
    vbroadcastss ymm0, [rax + Rc_k + 0]
%endmacro
%macro M2s_c1f3 0
    mov rcx, [rbp + 72]
M2s_d72
    mov rax, rcx
    shl rax, 5
    add rax, [rdi + G_rd]
%endmacro
%macro M2s_c1f4 0
.zq0:
M2s_d50
M2s_d54
    vfmadd231ps ymm0, ymm2, ymm11
    vmovaps [rdi+rdx*4], ymm0
    vfmadd213ps ymm2, ymm10, ymm4
%endmacro
%macro M2s_c1f5 0
    vfmadd231ps ymm0, ymm2, ymm11
    vmovaps [rdi+rdx*4], ymm0
    vfmadd213ps ymm2, ymm10, ymm4
    vfmadd231ps ymm4, ymm1, ymm8
%endmacro
%macro M2s_c1f6 0
    jbe .zq0
.zq0r:
    cmp rdx, r13
    jae .zq0e
M2s_d49
M2s_d4e
    vmovups ymm7, [c_n64]
    vmovups ymm6, [c_absm]
    vmovups ymm5, [c_xflr]
.zq0s:
%endmacro
%macro M2s_c1f7 0
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .zp0r
    lea r15, [r13 - 16]
    vmovups ymm15, [c_absm]
.zp0:
M2s_d55
    vpsrld ymm8, ymm5, 23
    vpsrld ymm9, ymm5, 20
%endmacro
%macro M2s_c1f8 0
.zp0r:
    cmp rdx, r13
    jae .zp0e
    vmovups ymm15, [c_absm]
%endmacro
%macro M2s_c1f9 0
    jb .zp0s
.zp0e:
.zw:
    mov rdi, [rbp + 8]
%endmacro
%macro M2s_c1fa 0
M2s_a2f0
    vorps ymm5, ymm9, ymm2
    vmovaps [r8+96], ymm3
    vmulps ymm6, ymm5, ymm8
%endmacro
%macro M2s_c1fb 0
    vpsrld ymm5, ymm3, 20
    vpmaddwd ymm6, ymm4, ymm13
    vpslld ymm7, ymm4, 23
    vpermps ymm8, ymm5, [c_w8e]
%endmacro
%macro M2s_c1fc 0
    vmovaps [rbx+rdx*4], ymm0
    vmovaps [rdi+rdx*4], ymm0
    vpaddd ymm4, ymm7, ymm6
    vorps ymm1, ymm4, ymm2
    vmovaps [r8+384], ymm3
    vmulps ymm0, ymm8, ymm5
    vmulps ymm7, ymm1, ymm9
    vfmadd213ps ymm10, ymm8, [c_q8e1]
%endmacro
%macro M2s_c1fd 0
    vmovaps [r8+416], ymm7
    vfmadd213ps ymm10, ymm8, [c_q8e0]
    vfmadd231ps ymm5, ymm0, ymm10
    vmovaps [rbx+rdx*4+32], ymm5
%endmacro
%macro M2s_c1fe 0
    jae .zp1e
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xflr]
    vmovups ymm13, [c_k5]
%endmacro
%macro M2s_c1ff 0
    vpaddd ymm9, ymm5, ymm6
    vmovaps ymm7, ymm10
    vfmadd213ps ymm7, ymm11, [c_q8e2]
    vmulps ymm4, ymm10, ymm0
%endmacro
%macro M2s_c200 0
M2s_d73
M2s_c201
%endmacro
%macro M2s_c201 0
M2s_d74
%endmacro
%macro M2s_c202 0
    vfmadd213ps ymm3, ymm10, ymm12
    vpermd ymm7, ymm4, [c_p8]
    vpermd ymm6, ymm1, [c_c8]
    vmovaps ymm10, ymm8
%endmacro
%macro M2s_c203 0
    vmovaps [rdi+rdx*4+32], ymm5
    add r8, 576
    add rdx, 16
    cmp rdx, r15
%endmacro
%macro M2s_c204 0
    vmovaps [r8+192], ymm3
M2s_c205
M2s_d74
    vfmadd213ps ymm7, ymm10, [c_q8e0]
    vmovups ymm8, [r8+384]
    vpsubd ymm10, ymm5, ymm1
%endmacro
%macro M2s_c205 0
    vmulps ymm6, ymm5, ymm8
    vfmadd213ps ymm7, ymm10, [c_q8e1]
    vandps ymm9, ymm1, ymm15
    vmovaps [r8+224], ymm6
M2s_d73
%endmacro
%macro M2s_c206 0
    vmovups ymm5, [r8+416]
    vfmadd231ps ymm0, ymm4, ymm7
    vpsrld ymm1, ymm6, 14
    vpsrld ymm4, ymm6, 17
%endmacro
%macro M2s_c207 0
    vfmadd213ps ymm10, ymm11, [c_q8e2]
    vmovaps [rsi+rdx*4], ymm0
    vmovaps [rdi+rdx*4], ymm0
    vpaddd ymm4, ymm7, ymm6
%endmacro
%macro M2s_c208 0
    vmovaps [rsi+rdx*4], ymm0
    vmovaps [rdi+rdx*4], ymm0
    vpaddd ymm4, ymm7, ymm6
    vorps ymm1, ymm4, ymm2
%endmacro
%macro M2s_c209 0
    vmovaps [r8+480], ymm3
    vmulps ymm0, ymm8, ymm5
M2s_b3e9
    vmovups ymm13, [c_k5]
%endmacro
%macro M2s_c20a 0
.zp2s:
    vmovups ymm0, [r14+rdx*4]
    vmovups ymm1, [r8+96]
    vmovups ymm2, [r8+128]
%endmacro
%macro M2s_c20b 0
    vorps ymm11, ymm4, ymm5
    vmovaps [r8+192], ymm6
    vmulps ymm8, ymm11, ymm0
    vfmadd231ps ymm2, ymm7, ymm3
%endmacro
%macro M2s_c20c 0
    vmovaps [r8+192], ymm6
    vmulps ymm8, ymm11, ymm0
    vfmadd231ps ymm2, ymm7, ymm3
    vmovaps [r8+224], ymm8
%endmacro
%macro M2s_c20d 0
    jb .zp2s
.zp2e:
    mov rdi, [rbp + 136]
    mov rax, [rbp + 144]
%endmacro
%macro M2s_c20e 0
    imul rax, rax, 2
M2s_d75
    jb .zp3r
M2s_d5a
    vmovups ymm12, [c_mone]
    vmovups ymm11, [c_q8e3]
%endmacro
%macro M2s_c20f 0
M2s_d75
M2s_d76
    vmovups ymm13, [c_k5]
    vmovups ymm12, [c_mone]
    vmovups ymm11, [c_q8e3]
    vmovups ymm10, [c_q8e2]
%endmacro
%macro M2s_c210 0
    vmovups ymm8, [c_q8e0]
    vmovups ymm7, [c_c8]
M2s_c211
    vmovups ymm3, [r8+480]
    vmovups ymm4, [r8+512]
%endmacro
%macro M2s_c211 0
.zp3:
    vmovups ymm0, [r8+192]
    vmovups ymm1, [r8+224]
    vmovups ymm2, [rbx+rdx*4]
%endmacro
%macro M2s_c212 0
    vminps ymm6, ymm2, [rsi+rdx*4]
    vfmadd213ps ymm5, ymm0, ymm9
    vfmadd213ps ymm5, ymm0, ymm8
    vmulps ymm2, ymm0, ymm1
%endmacro
%macro M2s_c213 0
    add rdx, 16
    cmp rdx, r15
    jbe .zp3
.zp3r:
%endmacro
%macro M2s_c214 0
    cmp rdx, r15
    jbe .zp3
.zp3r:
    cmp rdx, r13
%endmacro
%macro M2s_c215 0
    vmovups ymm6, [c_p8]
    vmovups ymm5, [c_w8e]
.zp3s:
M2s_d65
    vfmadd231ps ymm3, ymm0, ymm11
%endmacro
%macro M2s_c216 0
    ret
.t1l:
    vcvtps2pd ymm0, [rdi + 196608]
M2s_a30b
%endmacro
%macro M2s_c217 0
    vminps ymm0, ymm1, [u_zero]
    vminps ymm2, ymm4, ymm0
    vmovaps [r11+rdx*4], ymm2
    add r8, 288
    add rdx, 8
    cmp rdx, r13
    jb .zp3s
.zp3e:
%endmacro
%macro M2s_c218 0
    vdivpd ymm2, ymm3, ymm2
    vmovapd ymm15, [r15 + G_dsn]
    vfmadd213pd ymm15, ymm2, [r15 + G_dan]
    vfmadd213pd ymm15, ymm1, [r15 + G_dta]
%endmacro
%macro M2s_c219 0
    vmovapd ymm14, [r15 + G_dhi]
M2s_a30c
    vfmadd231pd ymm2, ymm1, [r15 + G_drg + 0]
M2s_b402
%endmacro
%macro M2s_c21a 0
    vfmadd231pd ymm2, ymm1, [r15 + G_drg + 0]
M2s_b402
    vpsrlq ymm7, ymm5, 48
    vpand ymm8, ymm7, [u_i15]
%endmacro
%macro M2s_c21b 0
M2s_d78
%endmacro
%macro M2s_c21c 0
M2s_d79
%endmacro
%macro M2s_c21d 0
M2s_d7a
%endmacro
%macro M2s_c21e 0
    vmovups ymm7, [c_c8]
M2s_d77
    vmovups ymm1, [r8+224]
    vmovups ymm2, [rbx+rdx*4]
    vmovaps ymm3, ymm10
%endmacro
%macro M2s_c21f 0
    vorpd ymm11, ymm11, [u_oneb]
    vfmsub213pd ymm11, ymm10, [u_one]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [rax + ymm8*8 + u_ow - u_rx], ymm9
%endmacro
%macro M2s_c220 0
M2s_d7b
%endmacro
%macro M2s_c221 0
    vpcmpeqq ymm9, ymm9, ymm9
M2s_c222
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [rax + ymm8*8 + u_ow - u_rx], ymm9
    vpsrlq ymm7, ymm5, 52
%endmacro
%macro M2s_c222 0
    vgatherqpd ymm10, [rax + ymm8*8 + u_rx - u_rx], ymm9
    vandpd ymm11, ymm5, [u_mant]
    vorpd ymm11, ymm11, [u_oneb]
    vfmsub213pd ymm11, ymm10, [u_one]
%endmacro
%macro M2s_c223 0
M2s_d7c
%endmacro
%macro M2s_c224 0
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [rax + ymm8*8 + u_ow - u_rx], ymm9
    vpsrlq ymm7, ymm5, 52
    vpand ymm7, ymm7, [u_i15]
%endmacro
%macro M2s_c225 0
    vgatherqpd ymm10, [rax + ymm8*8 + u_ow - u_rx], ymm9
    vpsrlq ymm7, ymm5, 52
    vpand ymm7, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
%endmacro
%macro M2s_c226 0
    vpsrlq ymm7, ymm5, 52
    vpand ymm7, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm6, [rax + ymm7*8 + u_oa - u_rx], ymm9
%endmacro
%macro M2s_c227 0
    vpand ymm7, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm6, [rax + ymm7*8 + u_oa - u_rx], ymm9
    vpsrlq ymm7, ymm5, 56
%endmacro
%macro M2s_c228 0
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm6, [rax + ymm7*8 + u_oa - u_rx], ymm9
    vpsrlq ymm7, ymm5, 56
    vpand ymm7, ymm7, [u_i7]
%endmacro
%macro M2s_c229 0
    vgatherqpd ymm6, [rax + ymm7*8 + u_oa - u_rx], ymm9
    vpsrlq ymm7, ymm5, 56
    vpand ymm7, ymm7, [u_i7]
    vpcmpeqq ymm9, ymm9, ymm9
%endmacro
%macro M2s_c22a 0
    vpsrlq ymm7, ymm5, 56
    vpand ymm7, ymm7, [u_i7]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm8, [rax + ymm7*8 + u_ob - u_rx], ymm9
%endmacro
%macro M2s_c22b 0
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm8, [rax + ymm7*8 + u_ob - u_rx], ymm9
    vmulpd ymm6, ymm6, ymm8
    vmulpd ymm6, ymm6, ymm10
%endmacro
%macro M2s_c22c 0
M2s_d7d
%endmacro
%macro M2s_c22d 0
M2s_d7e
%endmacro
%macro M2s_c22e 0
M2s_c22f
    vmovapd ymm7, [u_op3]
    vfmadd213pd ymm7, ymm11, [u_op2]
    vmovapd ymm8, [u_op4]
    vfmadd213pd ymm8, ymm12, ymm7
%endmacro
%macro M2s_c22f 0
    vgatherqpd ymm8, [rax + ymm7*8 + u_ob - u_rx], ymm9
    vmulpd ymm6, ymm6, ymm8
    vmulpd ymm6, ymm6, ymm10
    vmulpd ymm12, ymm11, ymm11
%endmacro
%macro M2s_c230 0
    vmulpd ymm6, ymm6, ymm8
    vmulpd ymm6, ymm6, ymm10
    vmulpd ymm12, ymm11, ymm11
    vmovapd ymm7, [u_op3]
%endmacro
%macro M2s_c231 0
    vmulpd ymm12, ymm11, ymm11
    vmovapd ymm7, [u_op3]
    vfmadd213pd ymm7, ymm11, [u_op2]
    vmovapd ymm8, [u_op4]
%endmacro
%macro M2s_c232 0
    vmulpd ymm12, ymm11, ymm11
    vmovapd ymm7, [u_op3]
M2s_b41f
    vfmadd213pd ymm9, ymm11, [u_op0]
%endmacro
%macro M2s_c233 0
M2s_a326
    vblendvpd ymm9, ymm9, ymm10, ymm0
M2s_c234
M2s_d78
    vpsrlq ymm7, ymm5, 48
    vpand ymm8, ymm7, [u_i15]
%endmacro
%macro M2s_c234 0
M2s_d7f
%endmacro
%macro M2s_c235 0
M2s_d80
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_drg + 32]
    vsubpd ymm3, ymm1, ymm2
%endmacro
%macro M2s_c236 0
M2s_a31e
M2s_a326
    vblendvpd ymm9, ymm9, ymm10, ymm0
M2s_d7f
M2s_d78
    vpsrlq ymm7, ymm5, 48
%endmacro
%macro M2s_c237 0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vfmadd231pd ymm13, ymm9, [r15 + G_dmx + 32]
    vfmadd231pd ymm14, ymm8, [r15 + G_dmx + 32]
    vcvtps2pd ymm0, [rdi + 131072]
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_drg + 64]
M2s_d78
M2s_d7a
%endmacro
%macro M2s_c238 0
M2s_d81
M2s_d79
M2s_d7b
%endmacro
%macro M2s_c239 0
    vroundpd ymm13, ymm13, 8
    vroundpd ymm14, ymm14, 8
    vcmppd ymm0, ymm13, ymm14, 0
    vmaxpd ymm13, ymm13, [u_zero]
%endmacro
%macro M2s_c23a 0
    ret
.t1c:
    vcvtps2pd ymm0, [rdi + 49152]
M2s_d7d
    vdivpd ymm2, ymm3, ymm2
    vmovapd ymm15, [r15 + G_esn]
    vfmadd213pd ymm15, ymm2, [r15 + G_ean]
    vfmadd213pd ymm15, ymm1, [r15 + G_eta]
M2s_d7e
    vfmadd231pd ymm2, ymm1, [r15 + G_erg + 0]
%endmacro
%macro M2s_c23b 0
M2s_d82
M2s_d83
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_erg + 0]
    vsubpd ymm3, ymm1, ymm2
%endmacro
%macro M2s_c23c 0
    vcvtps2pd ymm0, [rdi + 16384]
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_erg + 32]
M2s_d78
M2s_d7a
    vandpd ymm11, ymm5, [u_mant]
    vorpd ymm11, ymm11, [u_oneb]
    vfmsub213pd ymm11, ymm10, [u_one]
%endmacro
%macro M2s_c23d 0
M2s_d84
M2s_d7a
M2s_d7c
%endmacro
%macro M2s_c23e 0
    vmovapd [r12 + 768], ymm9
    vmovapd [r12 + 800], ymm8
    vcvtps2pd ymm0, [rdi + 32768]
    lea rax, [u_rx]
%endmacro
%macro M2s_c23f 0
    vmovapd [r12 + 832], ymm9
    vmovapd [r12 + 864], ymm8
    vmovapd ymm13, [r15 + G_elo]
    vmovapd ymm2, [r12 + 800]
    vfnmadd231pd ymm13, ymm2, [r15 + G_emx + 64]
    vmovapd ymm2, [r12 + 736]
    vfnmadd231pd ymm13, ymm2, [r15 + G_emx + 32]
    vmovapd ymm2, [r12 + 832]
    vfmadd231pd ymm13, ymm2, [r15 + G_emx + 0]
    vmovapd ymm14, [r15 + G_ehi]
    vmovapd ymm2, [r12 + 768]
    vfnmadd231pd ymm14, ymm2, [r15 + G_emx + 64]
    vmovapd ymm2, [r12 + 704]
    vfnmadd231pd ymm14, ymm2, [r15 + G_emx + 32]
    vmovapd ymm2, [r12 + 864]
    vfmadd231pd ymm14, ymm2, [r15 + G_emx + 0]
%endmacro
%macro M2s_c240 0
    vminpd ymm13, ymm13, [u_1023]
    vmovapd ymm1, [u_mone]
    vblendvpd ymm1, ymm1, ymm13, ymm0
    vcvtpd2dq xmm4, ymm1
    vmovapd ymm13, [r15 + G_elo + 32]
    vmovapd ymm2, [r12 + 864]
    vfnmadd231pd ymm13, ymm2, [r15 + G_emx + 160]
    vmovapd ymm2, [r12 + 800]
%endmacro
%macro M2s_c241 0
    vmovapd ymm2, [r12 + 832]
    vfnmadd231pd ymm14, ymm2, [r15 + G_emx + 160]
    vmovapd ymm2, [r12 + 768]
    vfnmadd231pd ymm14, ymm2, [r15 + G_emx + 128]
    vmovapd ymm2, [r12 + 736]
    vfmadd231pd ymm14, ymm2, [r15 + G_emx + 96]
    vroundpd ymm13, ymm13, 8
    vroundpd ymm14, ymm14, 8
%endmacro
%macro M2s_c242 0
    vminpd ymm13, ymm13, [u_1023]
    vmovapd ymm1, [u_mone]
    vblendvpd ymm1, ymm1, ymm13, ymm0
    vcvtpd2dq xmm5, ymm1
%endmacro
%macro M2s_c243 0
    vpor xmm4, xmm4, xmm3
    ret
.fz:
    call .t2
%endmacro
%macro M2s_c244 0
    mov [rsi + rcx*2], ax
    ret
.fzc:
    mov rsi, [rdi + G_wo]
    shr rsi, 1
    imul rcx, rsi
    add rcx, rdx
    mov rsi, [rdi + G_db]
    mov [rsi + rcx*2], ax
    shr eax, 16
    mov rsi, [rdi + G_dr]
    mov [rsi + rcx*2], ax
    ret
.t2:
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r12 + 512], ymm0
%endmacro
%macro M2s_c245 0
    vmovapd [r12 + 544], ymm0
M2s_a33d
    mov rax, [r12 + 1232]
    xor ebx, ebx
    test rcx, rcx
    jnz .t2c
M2s_a33e
    jmp .t2g
%endmacro
%macro M2s_c246 0
.t2c:
    lea r13, [rax*4 - 1]
    test rax, rax
    jnz .t2d
%endmacro
%macro M2s_c247 0
    lea r15, [rdx + rdx]
    lea rsi, [r15 + 2]
.t2g:
M2s_a33f
%endmacro
%macro M2s_c248 0
    mov r10, [rdi + G_hi]
    mov r11, [rdi + G_ho]
    mov rcx, [r12 + 1216]
    mov rdx, [r12 + 1224]
%endmacro
%macro M2s_c249 0
M2s_d85
M2s_c24a
%endmacro
%macro M2s_c24a 0
    mov [r12 + 1240], r13
    mov [r12 + 1248], r14
    mov [r12 + 1256], r15
    mov [r12 + 1264], rsi
%endmacro
%macro M2s_c24b 0
    mov [r12 + 1272], rbx
    mov qword [r12 + 1280], 0
    mov qword [r12 + 1288], 0
    mov rax, r15
%endmacro
%macro M2s_c24c 0
    mov rax, [r12 + 1296]
    mov rcx, rax
    imul rcx, r11
    cmp rcx, [r12 + 1264]
%endmacro
%macro M2s_c24d 0
    cmp rcx, [r12 + 1264]
    jae .t2f
M2s_a345
M2s_a349
%endmacro
%macro M2s_c24e 0
    lea rdx, [rcx + r11]
    mov rbx, [r12 + 1264]
    cmp rdx, rbx
    cmova rdx, rbx
    mov rbx, [r12 + 1256]
    cmp rcx, rbx
    cmovb rcx, rbx
    sub rdx, rcx
%endmacro
%macro M2s_c24f 0
    mov [r12 + 1304], rdx
    mov rbx, rax
    shl rbx, 5
    add rbx, [rdi + G_rd]
%endmacro
%macro M2s_c250 0
    lea rcx, [rsi + rcx*4]
    mov [r12 + 1344], rcx
    mov ecx, [rbx + Rc_co + 4]
    lea rcx, [rsi + rcx*4]
%endmacro
%macro M2s_c251 0
M2s_d86
%endmacro
%macro M2s_c252 0
M2s_d88
    xor ebx, ebx
    test rcx, rcx
    cmovs rcx, rbx
    add rdx, rcx
%endmacro
%macro M2s_c253 0
M2s_a350
M2s_a355
    cmp rsi, 4
    jb .t2x
    push r14
    call .t2b
M2s_a356
    mov r9, [rdi + G_wo]
%endmacro
%macro M2s_c254 0
    add r9, r9
    mov r11, [rdi + G_ho]
.t2x:
    inc r14
%endmacro
%macro M2s_c255 0
    add [r12 + 1280], rdx
    mov rsi, [r12 + 1288]
    vcvtsi2sd xmm0, xmm0, rdx
    vmovsd [r12 + 480 + rsi*8], xmm0
%endmacro
%macro M2s_c256 0
    mov rcx, [r12 + 1328]
M2s_d89
    shr rax, 3
    shl rax, 6
    mov rcx, r14
%endmacro
%macro M2s_c257 0
M2s_d89
    shr rax, 3
    shl rax, 6
    mov rcx, r14
    and ecx, 7
%endmacro
%macro M2s_c258 0
M2s_d8a
    shl rax, 6
    mov rcx, r14
    and ecx, 7
    lea rax, [rax + rcx*4]
%endmacro
%macro M2s_c259 0
    and ecx, 7
    lea rax, [rax + rcx*4]
    vmovups xmm15, [r12 + 1312]
    mov rcx, [r12 + 1344]
%endmacro
%macro M2s_c25a 0
    vmulss xmm0, xmm15, [rcx + rax + 0]
    vshufps xmm1, xmm15, xmm15, 85
    mov rcx, [r12 + 1352]
    vfmadd231ss xmm0, xmm1, [rcx + rax + 0]
%endmacro
%macro M2s_c25b 0
    vmovups xmm15, [r12 + 1312]
    mov rcx, [r12 + 1344]
    vmulss xmm0, xmm15, [rcx + rax + 0]
    vshufps xmm1, xmm15, xmm15, 85
%endmacro
%macro M2s_c25c 0
    vshufps xmm1, xmm15, xmm15, 170
    mov rcx, [r12 + 1360]
    vfmadd231ss xmm0, xmm1, [rcx + rax + 0]
    vshufps xmm1, xmm15, xmm15, 255
%endmacro
%macro M2s_c25d 0
    vfmadd231ss xmm0, xmm1, [rcx + rax + 0]
    vshufps xmm1, xmm15, xmm15, 255
M2s_b473
    mov rcx, [r12 + 1344]
%endmacro
%macro M2s_c25e 0
M2s_d8b
%endmacro
%macro M2s_c25f 0
    vxorpd xmm0, xmm0, xmm0
.t2z:
M2s_a35a
    inc rsi
    cmp rsi, 4
    jb .t2z
    call .t2b
.t2e:
    vcvtsi2sd xmm0, xmm0, qword [r12 + 1280]
    vmovsd xmm1, [u_one]
    vdivsd xmm9, xmm1, xmm0
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r12 + 576], ymm0
    vbroadcastsd ymm1, [u_tab]
    vmovapd [r12 + 608], ymm1
    vmovsd xmm2, [r12 + 544]
%endmacro
%macro M2s_c260 0
    vmulsd xmm2, xmm2, xmm9
    vmovsd [r12 + 576], xmm2
    vandpd xmm3, xmm2, [u_absm]
    vxorpd xmm3, xmm3, [u_mzero]
    vmovsd xmm4, [r12 + 512]
    vfmadd132sd xmm4, xmm3, xmm9
    vmovsd xmm5, [u_tab]
    vfmadd132sd xmm4, xmm5, [u_rg2]
%endmacro
%macro M2s_c261 0
    vmovsd [r12 + 608], xmm4
    vmovsd xmm2, [r12 + 552]
    vmulsd xmm2, xmm2, xmm9
    vmovsd [r12 + 584], xmm2
%endmacro
%macro M2s_c262 0
    vmovsd xmm5, [u_tab]
    vfmadd132sd xmm4, xmm5, [u_rg2]
    vmovsd [r12 + 616], xmm4
    vmovsd xmm2, [r12 + 560]
    vmulsd xmm2, xmm2, xmm9
    vmovsd [r12 + 592], xmm2
    vandpd xmm3, xmm2, [u_absm]
    vxorpd xmm3, xmm3, [u_mzero]
%endmacro
%macro M2s_c263 0
    vmovsd xmm4, [r12 + 528]
    vfmadd132sd xmm4, xmm3, xmm9
    vmovsd xmm5, [u_tab]
    vfmadd132sd xmm4, xmm5, [u_rg2]
%endmacro
%macro M2s_c264 0
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [u_rg2]
    vsubpd ymm3, ymm1, ymm2
%endmacro
%macro M2s_c265 0
    vmovsd [r12 + 384 + rsi*8], xmm0
    vmovsd [r12 + 416 + rsi*8], xmm0
    vmovsd [r12 + 448 + rsi*8], xmm0
    vmovsd [r12 + 480 + rsi*8], xmm0
%endmacro
%macro M2s_c266 0
    vmovapd [r12 + 640], ymm9
    vmovapd [r12 + 672], ymm8
    cmp qword [r12 + 1216], 0
    jne .t2h
    vmovsd xmm0, [u_ylo]
    vmovsd xmm1, [u_emc0]
    vfmadd231sd xmm0, xmm1, [r12 + 640]
    vmovsd xmm1, [u_emc1]
    vfmadd231sd xmm0, xmm1, [r12 + 640 + 8]
    vmovsd xmm1, [u_emc2]
    vfmadd231sd xmm0, xmm1, [r12 + 640 + 16]
    vmovsd xmm2, [u_yhi]
    vmovsd xmm1, [u_emc0]
    vfmadd231sd xmm2, xmm1, [r12 + 672]
    vmovsd xmm1, [u_emc1]
    vfmadd231sd xmm2, xmm1, [r12 + 672 + 8]
%endmacro
%macro M2s_c267 0
    vmovsd xmm1, [u_emc2]
M2s_a35e
    ret
.t2h:
    vmovsd xmm0, [u_clo]
    vmovsd xmm1, [u_emc5]
    vfnmadd231sd xmm0, xmm1, [r12 + 672 + 8]
    vmovsd xmm1, [u_emc4]
%endmacro
%macro M2s_c268 0
    vfnmadd231sd xmm0, xmm1, [r12 + 672]
    vmovsd xmm1, [u_emc3]
    vfmadd231sd xmm0, xmm1, [r12 + 640 + 16]
    vmovsd xmm2, [u_chi]
%endmacro
%macro M2s_c269 0
    vroundsd xmm0, xmm0, xmm0, 8
    vroundsd xmm2, xmm2, xmm2, 8
    vmovq rax, xmm0
    vmovq rcx, xmm2
%endmacro
%macro M2s_c26a 0
    vroundsd xmm2, xmm2, xmm2, 8
    vmovq rax, xmm0
    vmovq rcx, xmm2
    vcvttsd2si edx, xmm0
%endmacro
%macro M2s_c26b 0
    vcvttsd2si edx, xmm0
    xor esi, esi
    test edx, edx
    cmovs edx, esi
%endmacro
%macro M2s_c26c 0
    test edx, edx
    cmovs edx, esi
    mov esi, 1023
    cmp edx, esi
%endmacro
%macro M2s_c26d 0
    mov esi, 1023
    cmp edx, esi
    cmovg edx, esi
    mov esi, -1
%endmacro
%macro M2s_c26e 0
    mov r8d, eax
    vmovsd xmm0, [u_clo]
    vmovsd xmm1, [u_emc8]
    vfnmadd231sd xmm0, xmm1, [r12 + 672 + 16]
    vmovsd xmm1, [u_emc7]
    vfnmadd231sd xmm0, xmm1, [r12 + 672 + 8]
    vmovsd xmm1, [u_emc6]
    vfmadd231sd xmm0, xmm1, [r12 + 640]
    vmovsd xmm2, [u_chi]
    vmovsd xmm1, [u_emc8]
    vfnmadd231sd xmm2, xmm1, [r12 + 640 + 16]
    vmovsd xmm1, [u_emc7]
    vfnmadd231sd xmm2, xmm1, [r12 + 640 + 8]
    vmovsd xmm1, [u_emc6]
    vfmadd231sd xmm2, xmm1, [r12 + 672]
    vroundsd xmm0, xmm0, xmm0, 8
%endmacro
%macro M2s_c26f 0
    cmp rax, rcx
    cmovne edx, esi
    mov eax, edx
    mov ecx, eax
%endmacro
%macro M2s_c270 0
    shl eax, 16
    or eax, r8d
    test ecx, ecx
    mov ecx, -1
    cmovs eax, ecx
    ret
.t2b:
    lea rax, [u_rx]
%endmacro
%macro M2s_c271 0
    vmovapd ymm0, [r12 + 384]
    vmovapd ymm1, [r12 + 416]
    vmovapd ymm2, [r12 + 448]
    vmovapd ymm3, [u_lzm5]
%endmacro
%macro M2s_c272 0
    vfmadd231pd ymm5, ymm2, [u_lzm2]
    vfmadd231pd ymm5, ymm1, [u_lzm3]
    vfmadd231pd ymm3, ymm1, [u_lzm4]
    vmovapd ymm13, [r12 + 480]
%endmacro
%macro M2s_c273 0
M2s_d8c
%endmacro
%macro M2s_c274 0
    vpand ymm8, ymm8, [u_i15]
    vpand ymm9, ymm7, [u_i15]
    vpcmpeqq ymm11, ymm11, ymm11
    vgatherqpd ymm10, [rax + ymm9*8 + u_tsl - u_rx], ymm11
%endmacro
%macro M2s_c275 0
M2s_d8d
%endmacro
%macro M2s_c276 0
    vpcmpeqq ymm9, ymm9, ymm9
M2s_a366
    vmulpd ymm12, ymm10, ymm9
    vmulpd ymm12, ymm12, ymm13
    vandpd ymm14, ymm4, [u_mzero]
M2s_a367
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r12 + 512]
    vmovsd [r12 + 512], xmm12
M2s_a368
    vaddsd xmm14, xmm14, [r12 + 544]
    vmovsd [r12 + 544], xmm14
    vandpd ymm6, ymm5, [u_absm]
    vmaxpd ymm6, ymm6, [u_xflr]
    vpsrlq ymm7, ymm6, 52
    vpsrlq ymm8, ymm6, 48
%endmacro
%macro M2s_c277 0
    vmaxpd ymm6, ymm6, [u_xflr]
    vpsrlq ymm7, ymm6, 52
M2s_d8c
    vgatherqpd ymm10, [rax + ymm9*8 + u_tsl - u_rx], ymm11
M2s_c278
    vpcmpeqq ymm9, ymm9, ymm9
%endmacro
%macro M2s_c278 0
    vpand ymm9, ymm7, [u_i16]
    vpxor ymm11, ymm11, ymm11
M2s_d8d
    vgatherqpd ymm11, [rax + ymm8*8 + u_wsx - u_rx], ymm9
    vmulpd ymm10, ymm10, ymm11
%endmacro
%macro M2s_c279 0
    vgatherqpd ymm11, [rax + ymm8*8 + u_wsx - u_rx], ymm9
    vmulpd ymm10, ymm10, ymm11
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [rax + ymm8*8 + u_rx - u_rx], ymm9
%endmacro
%macro M2s_c27a 0
    vgatherqpd ymm11, [rax + ymm8*8 + u_rx - u_rx], ymm9
M2s_c27b
    vfmadd213pd ymm9, ymm7, [u_psx2]
    vfmadd213pd ymm9, ymm7, [u_psx1]
    vfmadd213pd ymm9, ymm7, [u_psx0]
%endmacro
%macro M2s_c27b 0
    vandpd ymm7, ymm6, [u_mant]
    vorpd ymm7, ymm7, [u_oneb]
    vfmsub213pd ymm7, ymm11, [u_one]
    vaddpd ymm9, ymm7, [u_psx3]
%endmacro
%macro M2s_c27c 0
    vorpd ymm7, ymm7, [u_oneb]
    vfmsub213pd ymm7, ymm11, [u_one]
    vaddpd ymm9, ymm7, [u_psx3]
    vfmadd213pd ymm9, ymm7, [u_psx2]
%endmacro
%macro M2s_c27d 0
    vfmsub213pd ymm7, ymm11, [u_one]
    vaddpd ymm9, ymm7, [u_psx3]
    vfmadd213pd ymm9, ymm7, [u_psx2]
    vfmadd213pd ymm9, ymm7, [u_psx1]
%endmacro
%macro M2s_c27e 0
    vfmadd213pd ymm9, ymm7, [u_psx1]
    vfmadd213pd ymm9, ymm7, [u_psx0]
    vmulpd ymm12, ymm10, ymm9
    vmulpd ymm12, ymm12, ymm13
%endmacro
%macro M2s_c27f 0
    vorpd ymm14, ymm14, ymm12
    vextractf128 xmm11, ymm12, 1
    vhaddpd xmm12, xmm12, xmm11
    vpermilpd xmm11, xmm12, 1
%endmacro
%macro M2s_c280 0
M2s_d90
%endmacro
%macro M2s_c281 0
    vaddsd xmm14, xmm14, [r12 + 552]
    vmovsd [r12 + 552], xmm14
    vandpd ymm6, ymm3, [u_absm]
M2s_d8e
    vpand ymm9, ymm7, [u_i15]
    vpcmpeqq ymm11, ymm11, ymm11
    vgatherqpd ymm10, [rax + ymm9*8 + u_tsl - u_rx], ymm11
M2s_d8f
    vblendvpd ymm10, ymm10, ymm11, ymm9
    vpcmpeqq ymm9, ymm9, ymm9
%endmacro
%macro M2s_c282 0
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r12 + 528]
    vmovsd [r12 + 528], xmm12
M2s_d90
    vaddsd xmm14, xmm14, [r12 + 560]
%endmacro
%macro M2s_c283 0
    ret
.t3:
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r12 + 1088], ymm0
%endmacro
%macro M2s_c284 0
    jmp .t3g
.t3c:
    lea r13, [rax*4 - 1]
    test rax, rax
    jnz .t3d
    xor r13d, r13d
    mov ebx, 1
.t3d:
    lea r14, [rax*4 + 3]
    lea r15, [rdx + rdx]
    lea rsi, [r15 + 2]
.t3g:
M2s_d85
%endmacro
%macro M2s_c285 0
    xor edx, edx
    div r11
    mov [r12 + 1296], rax
.t3y:
%endmacro
%macro M2s_c286 0
.t3j:
    mov rax, r14
    imul rax, r9
    cmp rax, [r12 + 1248]
    jae .t3n
M2s_d86
    sub rdx, rcx
    cmp qword [r12 + 1272], 0
    je .t3w
%endmacro
%macro M2s_c287 0
    je .t3w
M2s_d88
    xor ebx, ebx
    test rcx, rcx
    cmovs rcx, rbx
%endmacro
%macro M2s_c288 0
.t3w:
    imul rdx, [r12 + 1304]
    add [r12 + 1280], rdx
    mov rsi, [r12 + 1288]
%endmacro
%macro M2s_c289 0
    cmp rsi, 4
    jb .t3x
    push r14
    call .t3b
M2s_d8b
    mov r9, [rdi + G_wo]
M2s_d93
    jmp .t3j
.t3n:
    inc qword [r12 + 1296]
%endmacro
%macro M2s_c28a 0
M2s_d92
M2s_d93
    jmp .t3j
.t3n:
    inc qword [r12 + 1296]
    jmp .t3y
%endmacro
%macro M2s_c28b 0
    jmp .t3y
M2s_d94
    vxorpd xmm0, xmm0, xmm0
.t3z:
    vmovsd [r12 + 384 + rsi*8], xmm0
%endmacro
%macro M2s_c28c 0
M2s_d94
    vxorpd xmm0, xmm0, xmm0
.t3z:
    vmovsd [r12 + 384 + rsi*8], xmm0
    vmovsd [r12 + 416 + rsi*8], xmm0
%endmacro
%macro M2s_c28d 0
    inc rsi
    cmp rsi, 4
    jb .t3z
    call .t3b
%endmacro
%macro M2s_c28e 0
    vmovsd [r12 + 448 + rsi*8], xmm0
    vmovsd [r12 + 480 + rsi*8], xmm0
    inc rsi
    cmp rsi, 4
%endmacro
%macro M2s_c28f 0
    mov rdi, [rbp + 8]
M2s_d95
    jmp .t3r
.t3q:
    vbroadcastsd ymm2, [rdi + G_dnc]
%endmacro
%macro M2s_c290 0
M2s_d95
    jmp .t3r
.t3q:
    vbroadcastsd ymm2, [rdi + G_dnc]
    vbroadcastsd ymm3, [rdi + G_dnc + 8]
%endmacro
%macro M2s_c291 0
    vbroadcastsd ymm3, [rdi + G_dnc + 8]
.t3r:
    vmovapd ymm0, [r12 + 1088]
    vmovapd ymm1, [r12 + 1120]
%endmacro
%macro M2s_c292 0
.t3r:
    vmovapd ymm0, [r12 + 1088]
    vmovapd ymm1, [r12 + 1120]
    vmulpd ymm4, ymm0, ymm2
%endmacro
%macro M2s_c293 0
    vmovapd ymm14, ymm6
    vmovapd ymm15, ymm7
    call .xoe
M2s_b4ab
%endmacro
%macro M2s_c294 0
M2s_d96
%endmacro
%macro M2s_c295 0
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm4, ymm5
    vsubpd ymm7, ymm6, ymm4
    vsubpd ymm7, ymm5, ymm7
%endmacro
%macro M2s_c296 0
    vmovsd xmm4, [r12 + 1168]
M2s_d97
    vmovapd xmm9, xmm8
    vfmsub231sd xmm9, xmm6, xmm0
    vmulsd xmm10, xmm7, xmm0
%endmacro
%macro M2s_c297 0
M2s_d97
    vmovapd xmm9, xmm8
    vfmsub231sd xmm9, xmm6, xmm0
    vmulsd xmm10, xmm7, xmm0
    vfmadd231sd xmm10, xmm6, xmm1
%endmacro
%macro M2s_c298 0
M2s_c297
M2s_c29a
    vmovsd xmm7, [u_kg]
    vmovsd xmm6, [u_kg + 8]
M2s_b4b0
    vsubsd xmm9, xmm7, xmm11
%endmacro
%macro M2s_c299 0
    vfmadd231sd xmm10, xmm6, xmm1
    vaddsd xmm9, xmm9, xmm10
    vaddsd xmm10, xmm8, xmm9
    vsubsd xmm11, xmm10, xmm8
%endmacro
%macro M2s_c29a 0
    vaddsd xmm9, xmm9, xmm10
    vaddsd xmm10, xmm8, xmm9
    vsubsd xmm11, xmm10, xmm8
    vsubsd xmm11, xmm9, xmm11
%endmacro
%macro M2s_c29b 0
    vmulsd xmm9, xmm7, xmm2
M2s_c29c
M2s_c29e
    vsubsd xmm7, xmm12, xmm7
    vaddsd xmm8, xmm8, xmm7
    vaddsd xmm7, xmm11, xmm13
%endmacro
%macro M2s_c29c 0
    vmovapd xmm8, xmm9
M2s_d98
    vaddsd xmm12, xmm9, xmm8
    vsubsd xmm13, xmm12, xmm9
    vsubsd xmm13, xmm8, xmm13
%endmacro
%macro M2s_c29d 0
M2s_d98
    vaddsd xmm12, xmm9, xmm8
    vsubsd xmm13, xmm12, xmm9
    vsubsd xmm13, xmm8, xmm13
    vaddsd xmm6, xmm10, xmm12
%endmacro
%macro M2s_c29e 0
    vaddsd xmm6, xmm10, xmm12
    vsubsd xmm7, xmm6, xmm10
    vsubsd xmm8, xmm6, xmm7
    vsubsd xmm8, xmm10, xmm8
%endmacro
%macro M2s_c29f 0
    vsubsd xmm7, xmm6, xmm10
    vsubsd xmm8, xmm6, xmm7
    vsubsd xmm8, xmm10, xmm8
    vsubsd xmm7, xmm12, xmm7
%endmacro
%macro M2s_c2a0 0
    vsubsd xmm14, xmm7, xmm9
    vsubsd xmm14, xmm11, xmm14
    vsubsd xmm9, xmm13, xmm9
    vaddsd xmm14, xmm14, xmm9
%endmacro
%macro M2s_c2a1 0
    vsubsd xmm14, xmm11, xmm14
    vsubsd xmm9, xmm13, xmm9
    vaddsd xmm14, xmm14, xmm9
    vaddsd xmm9, xmm8, xmm7
%endmacro
%macro M2s_c2a2 0
    vsubsd xmm11, xmm9, xmm11
    vmovsd xmm7, [u_kg]
    vmovsd xmm6, [u_kg + 8]
    vmulsd xmm9, xmm7, xmm2
%endmacro
%macro M2s_c2a3 0
    vmovsd xmm7, [u_kg]
    vmovsd xmm6, [u_kg + 8]
    vmulsd xmm9, xmm7, xmm2
    vmovapd xmm8, xmm9
%endmacro
%macro M2s_c2a4 0
M2s_a383
    vaddsd xmm6, xmm13, xmm11
    vsubsd xmm10, xmm6, xmm13
    vsubsd xmm10, xmm11, xmm10
%endmacro
%macro M2s_c2a5 0
    vmulsd xmm11, xmm13, xmm4
    vmovapd xmm10, xmm11
    vfmsub231sd xmm10, xmm13, xmm4
    vmulsd xmm9, xmm12, xmm4
%endmacro
%macro M2s_c2a6 0
    vxorpd xmm5, xmm5, xmm5
    vmovsd xmm4, [u_876]
    vmulsd xmm3, xmm4, xmm6
    vmovapd xmm2, xmm3
    vfmsub231sd xmm2, xmm4, xmm6
    vmulsd xmm1, xmm5, xmm6
    vfmadd231sd xmm1, xmm4, xmm10
    vaddsd xmm2, xmm2, xmm1
    vaddsd xmm1, xmm3, xmm2
    vsubsd xmm0, xmm1, xmm3
    vsubsd xmm0, xmm2, xmm0
    vmovsd xmm10, [u_64]
    vaddsd xmm6, xmm1, xmm10
    vsubsd xmm4, xmm6, xmm1
    vsubsd xmm2, xmm6, xmm4
    vsubsd xmm2, xmm1, xmm2
%endmacro
%macro M2s_c2a7 0
    vsubsd xmm4, xmm10, xmm4
    vaddsd xmm2, xmm2, xmm4
    vaddsd xmm4, xmm0, xmm5
    vsubsd xmm3, xmm4, xmm0
    vsubsd xmm7, xmm4, xmm3
    vsubsd xmm7, xmm0, xmm7
    vsubsd xmm3, xmm5, xmm3
    vaddsd xmm7, xmm7, xmm3
%endmacro
%macro M2s_c2a8 0
    vsubsd xmm2, xmm3, xmm2
    vaddsd xmm3, xmm2, xmm7
    vaddsd xmm7, xmm4, xmm3
    vsubsd xmm2, xmm7, xmm4
%endmacro
%macro M2s_c2a9 0
    vroundsd xmm0, xmm7, xmm7, 8
    vsubsd xmm1, xmm7, xmm0
    vxorpd xmm5, xmm5, xmm5
    vaddsd xmm10, xmm1, xmm2
    vsubsd xmm3, xmm10, xmm1
    vsubsd xmm4, xmm10, xmm3
    vsubsd xmm4, xmm1, xmm4
    vsubsd xmm3, xmm2, xmm3
%endmacro
%macro M2s_c2aa 0
    vsubsd xmm9, xmm3, xmm6
    vsubsd xmm9, xmm5, xmm9
    vsubsd xmm6, xmm5, xmm6
    vaddsd xmm9, xmm9, xmm6
%endmacro
%macro M2s_c2ab 0
    vcmpsd xmm5, xmm9, [u_half], 0x1e
M2s_d99
    cmovg eax, ecx
    ret
.t3h:
M2s_d96
%endmacro
%macro M2s_c2ac 0
M2s_d99
M2s_d9a
    vmovsd xmm1, [r12 + 1184]
    vmovsd xmm2, [r12 + 1160]
    vmovsd xmm3, [r12 + 1192]
    vmovsd xmm4, [r12 + 1168]
%endmacro
%macro M2s_c2ad 0
M2s_d9b
%endmacro
%macro M2s_c2ae 0
    vsubsd xmm10, xmm11, xmm10
M2s_d9c
M2s_d9d
    vsubsd xmm9, xmm2, xmm9
    vaddsd xmm8, xmm8, xmm9
    vaddsd xmm9, xmm7, xmm6
%endmacro
%macro M2s_c2af 0
M2s_d9c
M2s_d9d
    vsubsd xmm9, xmm2, xmm9
    vaddsd xmm8, xmm8, xmm9
    vaddsd xmm9, xmm7, xmm6
    vaddsd xmm6, xmm10, xmm9
%endmacro
%macro M2s_c2b0 0
    vaddsd xmm6, xmm10, xmm9
M2s_d9e
    vsubsd xmm7, xmm8, xmm6
    vsubsd xmm7, xmm9, xmm7
    vmovsd xmm9, [u_cbs]
%endmacro
%macro M2s_c2b1 0
M2s_d9e
    vsubsd xmm7, xmm8, xmm6
    vsubsd xmm7, xmm9, xmm7
    vmovsd xmm9, [u_cbs]
    vmovsd xmm6, [u_cbs + 8]
%endmacro
%macro M2s_c2b2 0
    vmovsd xmm6, [u_cbs + 8]
    vmulsd xmm10, xmm9, xmm8
    vmovapd xmm14, xmm10
    vfmsub231sd xmm14, xmm9, xmm8
%endmacro
%macro M2s_c2b3 0
    vmulsd xmm10, xmm9, xmm8
    vmovapd xmm14, xmm10
    vfmsub231sd xmm14, xmm9, xmm8
    vmulsd xmm11, xmm6, xmm8
%endmacro
%macro M2s_c2b4 0
    vsubsd xmm13, xmm11, xmm10
M2s_d9f
    vsubsd xmm9, xmm6, xmm11
    vsubsd xmm14, xmm6, xmm9
    vsubsd xmm14, xmm11, xmm14
%endmacro
%macro M2s_c2b5 0
M2s_d9f
    vsubsd xmm9, xmm6, xmm11
    vsubsd xmm14, xmm6, xmm9
    vsubsd xmm14, xmm11, xmm14
    vsubsd xmm9, xmm8, xmm9
%endmacro
%macro M2s_c2b6 0
    vsubsd xmm9, xmm8, xmm9
    vaddsd xmm14, xmm14, xmm9
    vaddsd xmm9, xmm13, xmm7
    vsubsd xmm10, xmm9, xmm13
%endmacro
%macro M2s_c2b7 0
    vaddsd xmm14, xmm14, xmm9
    vaddsd xmm9, xmm13, xmm7
    vsubsd xmm10, xmm9, xmm13
    vsubsd xmm12, xmm9, xmm10
%endmacro
%macro M2s_c2b8 0
    vaddsd xmm10, xmm14, xmm9
    vaddsd xmm9, xmm6, xmm10
    vsubsd xmm14, xmm9, xmm6
    vsubsd xmm14, xmm10, xmm14
%endmacro
%macro M2s_c2b9 0
    vaddsd xmm9, xmm6, xmm10
    vsubsd xmm14, xmm9, xmm6
    vsubsd xmm14, xmm10, xmm14
    vaddsd xmm10, xmm14, xmm12
%endmacro
%macro M2s_c2ba 0
    vsubsd xmm9, xmm13, xmm10
M2s_da0
M2s_da1
    vmovsd xmm3, [u_crs + 8]
    vmulsd xmm10, xmm2, xmm9
    vmovapd xmm13, xmm10
%endmacro
%macro M2s_c2bb 0
M2s_da0
M2s_da1
    vmovsd xmm3, [u_crs + 8]
    vmulsd xmm10, xmm2, xmm9
    vmovapd xmm13, xmm10
    vfmsub231sd xmm13, xmm2, xmm9
%endmacro
%macro M2s_c2bc 0
    vfmsub231sd xmm13, xmm2, xmm9
M2s_da2
    vsubsd xmm6, xmm8, xmm10
    vsubsd xmm6, xmm13, xmm6
    vmovsd xmm11, [u_512]
%endmacro
%macro M2s_c2bd 0
M2s_da2
    vsubsd xmm6, xmm8, xmm10
    vsubsd xmm6, xmm13, xmm6
    vmovsd xmm11, [u_512]
    vaddsd xmm9, xmm8, xmm11
%endmacro
%macro M2s_c2be 0
    vaddsd xmm9, xmm8, xmm11
    vsubsd xmm3, xmm9, xmm8
    vsubsd xmm2, xmm9, xmm3
    vsubsd xmm2, xmm8, xmm2
%endmacro
%macro M2s_c2bf 0
    vsubsd xmm3, xmm9, xmm8
    vsubsd xmm2, xmm9, xmm3
    vsubsd xmm2, xmm8, xmm2
    vsubsd xmm3, xmm11, xmm3
%endmacro
%macro M2s_c2c0 0
    vsubsd xmm10, xmm3, xmm13
M2s_da3
    vaddsd xmm3, xmm9, xmm13
    vsubsd xmm2, xmm3, xmm9
    vsubsd xmm2, xmm13, xmm2
%endmacro
%macro M2s_c2c1 0
M2s_da3
    vaddsd xmm3, xmm9, xmm13
    vsubsd xmm2, xmm3, xmm9
    vsubsd xmm2, xmm13, xmm2
    vaddsd xmm13, xmm2, xmm10
%endmacro
%macro M2s_c2c2 0
    vaddsd xmm13, xmm2, xmm10
    vaddsd xmm10, xmm3, xmm13
    vsubsd xmm2, xmm10, xmm3
    vsubsd xmm2, xmm13, xmm2
%endmacro
%macro M2s_c2c3 0
    vaddsd xmm10, xmm3, xmm13
    vsubsd xmm2, xmm10, xmm3
    vsubsd xmm2, xmm13, xmm2
    vmovsd [r12 + 1280], xmm10
%endmacro
%macro M2s_c2c4 0
    vxorpd xmm6, xmm6, xmm6
    vaddsd xmm8, xmm11, xmm14
    vsubsd xmm13, xmm8, xmm11
    vsubsd xmm3, xmm8, xmm13
%endmacro
%macro M2s_c2c5 0
    vaddsd xmm8, xmm11, xmm14
    vsubsd xmm13, xmm8, xmm11
    vsubsd xmm3, xmm8, xmm13
    vsubsd xmm3, xmm11, xmm3
%endmacro
%macro M2s_c2c6 0
    vsubsd xmm3, xmm9, xmm3
M2s_da4
    vcvttsd2si eax, xmm7
M2s_d9b
    cmp eax, ecx
    cmovg eax, ecx
%endmacro
%macro M2s_c2c7 0
M2s_da4
M2s_da5
    mov ecx, 1023
    cmp eax, ecx
    cmovg eax, ecx
    mov [r12 + 1296], eax
%endmacro
%macro M2s_c2c8 0
    mov [r12 + 1296], eax
M2s_da6
    vxorpd xmm4, xmm4, xmm4
    vaddsd xmm5, xmm3, xmm1
    vsubsd xmm6, xmm5, xmm3
%endmacro
%macro M2s_c2c9 0
M2s_da6
    vxorpd xmm4, xmm4, xmm4
    vaddsd xmm5, xmm3, xmm1
    vsubsd xmm6, xmm5, xmm3
    vsubsd xmm7, xmm5, xmm6
%endmacro
%macro M2s_c2ca 0
    vsubsd xmm7, xmm5, xmm6
    vsubsd xmm7, xmm3, xmm7
    vsubsd xmm6, xmm1, xmm6
    vaddsd xmm7, xmm7, xmm6
%endmacro
%macro M2s_c2cb 0
    vsubsd xmm7, xmm3, xmm7
    vsubsd xmm6, xmm1, xmm6
    vaddsd xmm7, xmm7, xmm6
    vaddsd xmm6, xmm4, xmm4
%endmacro
%macro M2s_c2cc 0
    vsubsd xmm8, xmm4, xmm8
M2s_da7
    vsubsd xmm7, xmm8, xmm7
    vaddsd xmm8, xmm7, xmm9
    vaddsd xmm9, xmm6, xmm8
%endmacro
%macro M2s_c2cd 0
M2s_da7
    vsubsd xmm7, xmm8, xmm7
    vaddsd xmm8, xmm7, xmm9
    vaddsd xmm9, xmm6, xmm8
    vcmpsd xmm4, xmm9, [u_half], 0x1e
%endmacro
%macro M2s_c2ce 0
    vcmpsd xmm4, xmm9, [u_half], 0x1e
    vandpd xmm4, xmm4, [u_one]
    vcmpsd xmm3, xmm9, [u_mhalf], 0x11
    vandpd xmm3, xmm3, [u_one]
%endmacro
%macro M2s_c2cf 0
    vandpd xmm4, xmm4, [u_one]
    vcmpsd xmm3, xmm9, [u_mhalf], 0x11
    vandpd xmm3, xmm3, [u_one]
    vaddsd xmm2, xmm2, xmm4
%endmacro
%macro M2s_c2d0 0
    cmp eax, ecx
    cmovg eax, ecx
    shl eax, 16
    or eax, [r12 + 1296]
%endmacro
%macro M2s_c2d1 0
    vmovapd ymm7, ymm6
M2s_da8
M2s_da9
    vsubpd ymm6, ymm8, ymm6
    vsubpd ymm7, ymm1, ymm7
    vaddpd ymm6, ymm6, ymm7
%endmacro
%macro M2s_c2d2 0
M2s_da8
M2s_da9
    vsubpd ymm6, ymm8, ymm6
    vsubpd ymm7, ymm1, ymm7
    vaddpd ymm6, ymm6, ymm7
    vaddpd ymm7, ymm9, ymm5
%endmacro
%macro M2s_c2d3 0
    vaddpd ymm7, ymm9, ymm5
M2s_daa
    vaddpd ymm11, ymm11, ymm10
    vaddpd ymm10, ymm6, ymm7
    vaddpd ymm7, ymm4, ymm10
%endmacro
%macro M2s_c2d4 0
M2s_daa
    vaddpd ymm11, ymm11, ymm10
    vaddpd ymm10, ymm6, ymm7
    vaddpd ymm7, ymm4, ymm10
    vsubpd ymm6, ymm7, ymm4
%endmacro
%macro M2s_c2d5 0
    vsubpd ymm6, ymm7, ymm4
    vsubpd ymm6, ymm10, ymm6
    vaddpd ymm10, ymm6, ymm11
    vaddpd ymm11, ymm7, ymm10
%endmacro
%macro M2s_c2d6 0
    vsubpd ymm6, ymm10, ymm6
    vaddpd ymm10, ymm6, ymm11
    vaddpd ymm11, ymm7, ymm10
    vsubpd ymm6, ymm11, ymm7
%endmacro
%macro M2s_c2d7 0
    vmulpd ymm9, ymm5, ymm3
M2s_dab
    vaddpd ymm8, ymm8, ymm10
    vaddpd ymm10, ymm9, ymm8
    vsubpd ymm7, ymm10, ymm9
%endmacro
%macro M2s_c2d8 0
M2s_dab
    vaddpd ymm8, ymm8, ymm10
    vaddpd ymm10, ymm9, ymm8
    vsubpd ymm7, ymm10, ymm9
    vsubpd ymm7, ymm8, ymm7
%endmacro
%macro M2s_c2d9 0
    vsubpd ymm7, ymm8, ymm7
    vaddpd ymm1, ymm11, ymm10
    vsubpd ymm5, ymm1, ymm11
    vsubpd ymm8, ymm1, ymm5
%endmacro
%macro M2s_c2da 0
    vaddpd ymm1, ymm11, ymm10
    vsubpd ymm5, ymm1, ymm11
    vsubpd ymm8, ymm1, ymm5
    vsubpd ymm8, ymm11, ymm8
%endmacro
%macro M2s_c2db 0
    vsubpd ymm9, ymm5, ymm6
    vsubpd ymm4, ymm5, ymm9
    vsubpd ymm4, ymm6, ymm4
    vsubpd ymm9, ymm7, ymm9
%endmacro
%macro M2s_c2dc 0
    vsubpd ymm4, ymm5, ymm9
    vsubpd ymm4, ymm6, ymm4
    vsubpd ymm9, ymm7, ymm9
    vaddpd ymm4, ymm4, ymm9
%endmacro
%macro M2s_c2dd 0
    vbroadcastsd ymm4, [u_gcr + 8]
M2s_dac
M2s_dad
    vsubpd ymm10, ymm11, ymm10
    vsubpd ymm8, ymm9, ymm8
    vaddpd ymm10, ymm10, ymm8
%endmacro
%macro M2s_c2de 0
M2s_dac
M2s_dad
    vsubpd ymm10, ymm11, ymm10
    vsubpd ymm8, ymm9, ymm8
    vaddpd ymm10, ymm10, ymm8
    vaddpd ymm8, ymm6, ymm5
%endmacro
%macro M2s_c2df 0
    vaddpd ymm8, ymm6, ymm5
M2s_dae
    vaddpd ymm1, ymm1, ymm7
    vaddpd ymm7, ymm10, ymm8
    vaddpd ymm8, ymm4, ymm7
%endmacro
%macro M2s_c2e0 0
M2s_dae
    vaddpd ymm1, ymm1, ymm7
    vaddpd ymm7, ymm10, ymm8
    vaddpd ymm8, ymm4, ymm7
    vsubpd ymm10, ymm8, ymm4
%endmacro
%macro M2s_c2e1 0
    vsubpd ymm10, ymm8, ymm4
    vsubpd ymm10, ymm7, ymm10
    vaddpd ymm7, ymm10, ymm1
    vaddpd ymm1, ymm8, ymm7
%endmacro
%macro M2s_c2e2 0
    vsubpd ymm10, ymm7, ymm10
    vaddpd ymm7, ymm10, ymm1
    vaddpd ymm1, ymm8, ymm7
    vsubpd ymm10, ymm1, ymm8
%endmacro
%macro M2s_c2e3 0
    vmulpd ymm9, ymm3, ymm2
M2s_daf
    vaddpd ymm7, ymm7, ymm8
    vaddpd ymm8, ymm9, ymm7
    vsubpd ymm4, ymm8, ymm9
%endmacro
%macro M2s_c2e4 0
M2s_daf
    vaddpd ymm7, ymm7, ymm8
    vaddpd ymm8, ymm9, ymm7
    vsubpd ymm4, ymm8, ymm9
    vsubpd ymm4, ymm7, ymm4
%endmacro
%macro M2s_c2e5 0
    vsubpd ymm4, ymm7, ymm4
    vaddpd ymm5, ymm1, ymm8
    vsubpd ymm3, ymm5, ymm1
    vsubpd ymm7, ymm5, ymm3
%endmacro
%macro M2s_c2e6 0
    vaddpd ymm5, ymm1, ymm8
    vsubpd ymm3, ymm5, ymm1
    vsubpd ymm7, ymm5, ymm3
    vsubpd ymm7, ymm1, ymm7
%endmacro
%macro M2s_c2e7 0
    vsubpd ymm9, ymm3, ymm10
    vsubpd ymm12, ymm3, ymm9
    vsubpd ymm12, ymm10, ymm12
    vsubpd ymm9, ymm4, ymm9
%endmacro
%macro M2s_c2e8 0
    vsubpd ymm12, ymm3, ymm9
    vsubpd ymm12, ymm10, ymm12
    vsubpd ymm9, ymm4, ymm9
    vaddpd ymm12, ymm12, ymm9
%endmacro
%macro M2s_c2e9 0
    vbroadcastsd ymm12, [u_bcb + 8]
M2s_db0
M2s_db1
    vsubpd ymm1, ymm11, ymm1
    vsubpd ymm7, ymm4, ymm7
    vaddpd ymm1, ymm1, ymm7
%endmacro
%macro M2s_c2ea 0
M2s_db0
M2s_db1
    vsubpd ymm1, ymm11, ymm1
    vsubpd ymm7, ymm4, ymm7
    vaddpd ymm1, ymm1, ymm7
    vaddpd ymm7, ymm6, ymm8
%endmacro
%macro M2s_c2eb 0
    vaddpd ymm7, ymm6, ymm8
M2s_db2
    vaddpd ymm9, ymm9, ymm10
    vaddpd ymm10, ymm1, ymm7
    vaddpd ymm7, ymm12, ymm10
%endmacro
%macro M2s_c2ec 0
M2s_db2
    vaddpd ymm9, ymm9, ymm10
    vaddpd ymm10, ymm1, ymm7
    vaddpd ymm7, ymm12, ymm10
    vsubpd ymm1, ymm7, ymm12
%endmacro
%macro M2s_c2ed 0
    vsubpd ymm1, ymm7, ymm12
    vsubpd ymm1, ymm10, ymm1
    vaddpd ymm10, ymm1, ymm9
    vaddpd ymm9, ymm7, ymm10
%endmacro
%macro M2s_c2ee 0
    vsubpd ymm1, ymm10, ymm1
    vaddpd ymm10, ymm1, ymm9
    vaddpd ymm9, ymm7, ymm10
    vsubpd ymm1, ymm9, ymm7
%endmacro
%macro M2s_c2ef 0
    vmovapd ymm14, [r12 + 704]
M2s_db3
    vmovapd ymm14, [r12 + 768]
    vmovapd ymm15, [r12 + 800]
    call .xeo
%endmacro
%macro M2s_c2f0 0
M2s_db3
    vmovapd ymm14, [r12 + 768]
    vmovapd ymm15, [r12 + 800]
    call .xeo
    vmovapd [r12 + 960], ymm14
%endmacro
%macro M2s_c2f1 0
    vmovapd [r12 + 960], ymm14
    vmovapd [r12 + 992], ymm15
    vmovapd ymm14, [r12 + 832]
    vmovapd ymm15, [r12 + 864]
%endmacro
%macro M2s_c2f2 0
    vmovapd [r12 + 992], ymm15
    vmovapd ymm14, [r12 + 832]
    vmovapd ymm15, [r12 + 864]
    call .xeo
%endmacro
%macro M2s_c2f3 0
    vmovsd xmm1, [r12 + 1120]
    vmovsd xmm2, [r12 + 896]
    vmovsd xmm3, [r12 + 928]
M2s_b511
%endmacro
%macro M2s_c2f4 0
    vmovsd xmm4, [r12 + 480]
    vxorpd xmm5, xmm5, xmm5
    vmulsd xmm6, xmm2, xmm4
    vmovapd xmm7, xmm6
%endmacro
%macro M2s_c2f5 0
    vxorpd xmm5, xmm5, xmm5
    vmulsd xmm6, xmm2, xmm4
    vmovapd xmm7, xmm6
    vfmsub231sd xmm7, xmm2, xmm4
%endmacro
%macro M2s_c2f6 0
    vfmsub231sd xmm7, xmm2, xmm4
    vmulsd xmm8, xmm3, xmm4
    vfmadd231sd xmm8, xmm2, xmm5
    vaddsd xmm7, xmm7, xmm8
%endmacro
%macro M2s_c2f7 0
    vmulsd xmm8, xmm3, xmm4
    vfmadd231sd xmm8, xmm2, xmm5
    vaddsd xmm7, xmm7, xmm8
    vaddsd xmm8, xmm6, xmm7
%endmacro
%macro M2s_c2f8 0
M2s_a3ac
M2s_b524
M2s_db4
M2s_a3b7
    vaddsd xmm4, xmm1, xmm9
%endmacro
%macro M2s_c2f9 0
M2s_db4
M2s_a3b7
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
%endmacro
%macro M2s_c2fa 0
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [r12 + 912]
    vmovsd xmm5, [r12 + 944]
%endmacro
%macro M2s_c2fb 0
M2s_a3b2
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm2, xmm3
%endmacro
%macro M2s_c2fc 0
M2s_db5
%endmacro
%macro M2s_c2fd 0
M2s_db6
%endmacro
%macro M2s_c2fe 0
    vfmsub231sd xmm1, xmm6, xmm3
    vmulsd xmm0, xmm5, xmm3
    vfmadd231sd xmm0, xmm6, xmm7
    vaddsd xmm1, xmm1, xmm0
%endmacro
%macro M2s_c2ff 0
    vmulsd xmm0, xmm5, xmm3
    vfmadd231sd xmm0, xmm6, xmm7
    vaddsd xmm1, xmm1, xmm0
    vaddsd xmm0, xmm9, xmm1
%endmacro
%macro M2s_c300 0
    vaddsd xmm0, xmm9, xmm1
    vsubsd xmm2, xmm0, xmm9
    vsubsd xmm2, xmm1, xmm2
    vaddsd xmm7, xmm4, xmm0
%endmacro
%macro M2s_c301 0
M2s_db7
M2s_db9
    vsubsd xmm1, xmm0, xmm7
    vsubsd xmm8, xmm0, xmm1
    vsubsd xmm8, xmm7, xmm8
    vsubsd xmm1, xmm5, xmm1
%endmacro
%macro M2s_c302 0
M2s_dba
    vsubsd xmm4, xmm3, xmm4
    vsubsd xmm9, xmm6, xmm9
    vaddsd xmm4, xmm4, xmm9
    vaddsd xmm9, xmm8, xmm1
%endmacro
%macro M2s_c303 0
M2s_dbb
%endmacro
%macro M2s_c304 0
M2s_b532
    vsubsd xmm3, xmm0, xmm3
M2s_dbc
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [r12 + 920]
%endmacro
%macro M2s_c305 0
M2s_dbc
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [r12 + 920]
    vmovsd xmm0, [r12 + 952]
M2s_a3c1
%endmacro
%macro M2s_c306 0
    vmovsd xmm0, [r12 + 952]
M2s_a3c1
M2s_a3c2
M2s_a3c3
%endmacro
%macro M2s_c307 0
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm0, xmm3, xmm8
    vsubsd xmm0, xmm2, xmm0
    vmovsd [r12 + 1088], xmm3
%endmacro
%macro M2s_c308 0
    vsubsd xmm0, xmm3, xmm8
    vsubsd xmm0, xmm2, xmm0
    vmovsd [r12 + 1088], xmm3
    vmovsd [r12 + 1120], xmm0
%endmacro
%macro M2s_c309 0
M2s_dbd
%endmacro
%macro M2s_c30a 0
M2s_dbe
M2s_dc0
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm0, xmm4, xmm8
    vsubsd xmm0, xmm1, xmm0
    vsubsd xmm8, xmm7, xmm8
%endmacro
%macro M2s_c30b 0
M2s_dc1
    vsubsd xmm3, xmm5, xmm3
    vsubsd xmm2, xmm9, xmm2
    vaddsd xmm3, xmm3, xmm2
    vaddsd xmm2, xmm0, xmm8
%endmacro
%macro M2s_c30c 0
M2s_dc2
%endmacro
%macro M2s_c30d 0
    vsubsd xmm3, xmm2, xmm3
    vmovsd xmm9, [r12 + 968]
    vmovsd xmm8, [r12 + 1000]
M2s_db7
M2s_db9
    vsubsd xmm1, xmm0, xmm7
%endmacro
%macro M2s_c30e 0
M2s_dc3
M2s_db8
%endmacro
%macro M2s_c30f 0
    vsubsd xmm8, xmm0, xmm1
M2s_c310
    vaddsd xmm4, xmm4, xmm9
    vaddsd xmm9, xmm8, xmm1
M2s_dbb
    vaddsd xmm4, xmm1, xmm9
%endmacro
%macro M2s_c310 0
    vsubsd xmm8, xmm7, xmm8
    vsubsd xmm1, xmm5, xmm1
M2s_dba
    vsubsd xmm4, xmm3, xmm4
    vsubsd xmm9, xmm6, xmm9
%endmacro
%macro M2s_c311 0
M2s_dc4
    vsubsd xmm8, xmm9, xmm8
    vaddsd xmm9, xmm8, xmm4
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm8, xmm4, xmm1
%endmacro
%macro M2s_c312 0
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [r12 + 976]
    vmovsd xmm5, [r12 + 1008]
M2s_db5
%endmacro
%macro M2s_c313 0
M2s_dc5
M2s_db6
%endmacro
%macro M2s_c314 0
    vsubsd xmm2, xmm0, xmm9
    vsubsd xmm2, xmm1, xmm2
    vaddsd xmm7, xmm4, xmm0
    vsubsd xmm3, xmm7, xmm4
%endmacro
%macro M2s_c315 0
    vsubsd xmm3, xmm0, xmm3
M2s_dbd
    vsubsd xmm1, xmm8, xmm1
    vsubsd xmm6, xmm2, xmm6
    vaddsd xmm1, xmm1, xmm6
%endmacro
%macro M2s_c316 0
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [r12 + 984]
    vmovsd xmm0, [r12 + 1016]
M2s_dbe
M2s_dc0
    vsubsd xmm8, xmm4, xmm1
%endmacro
%macro M2s_c317 0
M2s_dc6
M2s_dbf
%endmacro
%macro M2s_c318 0
    vsubsd xmm0, xmm4, xmm8
M2s_c319
    vaddsd xmm3, xmm3, xmm2
    vaddsd xmm2, xmm0, xmm8
M2s_dc2
    vaddsd xmm3, xmm8, xmm2
%endmacro
%macro M2s_c319 0
    vsubsd xmm0, xmm1, xmm0
    vsubsd xmm8, xmm7, xmm8
M2s_dc1
    vsubsd xmm3, xmm5, xmm3
    vsubsd xmm2, xmm9, xmm2
%endmacro
%macro M2s_c31a 0
M2s_dc7
    vsubsd xmm0, xmm2, xmm0
    vaddsd xmm2, xmm0, xmm3
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm0, xmm3, xmm8
%endmacro
%macro M2s_c31b 0
    vsubsd xmm0, xmm3, xmm8
M2s_dc8
    vmovsd xmm1, [r12 + 1136]
    vmovsd xmm2, [r12 + 1024]
    vmovsd xmm3, [r12 + 1056]
%endmacro
%macro M2s_c31c 0
M2s_dc8
    vmovsd xmm1, [r12 + 1136]
    vmovsd xmm2, [r12 + 1024]
    vmovsd xmm3, [r12 + 1056]
    vmovsd xmm4, [r12 + 480]
%endmacro
%macro M2s_c31d 0
    vsubsd xmm3, xmm2, xmm3
    vmovsd xmm9, [r12 + 1032]
    vmovsd xmm8, [r12 + 1064]
M2s_db7
M2s_db9
    vsubsd xmm1, xmm0, xmm7
%endmacro
%macro M2s_c31e 0
M2s_dc9
M2s_db8
%endmacro
%macro M2s_c31f 0
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [r12 + 1040]
    vmovsd xmm5, [r12 + 1072]
M2s_db5
%endmacro
%macro M2s_c320 0
M2s_dca
M2s_db6
%endmacro
%macro M2s_c321 0
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [r12 + 1048]
    vmovsd xmm0, [r12 + 1080]
M2s_dbe
M2s_dc0
    vsubsd xmm8, xmm4, xmm1
%endmacro
%macro M2s_c322 0
M2s_dcb
M2s_dbf
%endmacro
%macro M2s_c323 0
    vsubsd xmm0, xmm3, xmm8
M2s_dcc
    .dexp:
    vxorpd ymm0, ymm0, ymm0
    vdivpd ymm1, ymm14, [u_ln2]
%endmacro
%macro M2s_c324 0
M2s_dcc
    .dexp:
    vxorpd ymm0, ymm0, ymm0
    vdivpd ymm1, ymm14, [u_ln2]
    vroundpd ymm2, ymm1, 8
%endmacro
%macro M2s_c325 0
    vroundpd ymm2, ymm1, 8
    vbroadcastsd ymm1, [u_ln2d]
    vbroadcastsd ymm3, [u_ln2d + 8]
    vmulpd ymm4, ymm1, ymm2
%endmacro
%macro M2s_c326 0
    vbroadcastsd ymm1, [u_ln2d]
    vbroadcastsd ymm3, [u_ln2d + 8]
    vmulpd ymm4, ymm1, ymm2
    vmovapd ymm5, ymm4
%endmacro
%macro M2s_c327 0
    vsubpd ymm4, ymm15, ymm4
M2s_dcd
M2s_dce
    vmovapd ymm5, ymm2
    vfmsub231pd ymm5, ymm4, ymm3
    vmulpd ymm6, ymm1, ymm3
%endmacro
%macro M2s_c328 0
M2s_dcd
M2s_dce
    vmovapd ymm5, ymm2
    vfmsub231pd ymm5, ymm4, ymm3
    vmulpd ymm6, ymm1, ymm3
    vfmadd231pd ymm6, ymm4, ymm0
%endmacro
%macro M2s_c329 0
    vfmadd231pd ymm6, ymm4, ymm0
M2s_dcf
    vmovapd [r12 + 128], ymm6
    vmovapd [r12 + 128 + 32], ymm7
    vbroadcastsd ymm7, [u_one]
%endmacro
%macro M2s_c32a 0
M2s_dcf
    vmovapd [r12 + 128], ymm6
    vmovapd [r12 + 128 + 32], ymm7
    vbroadcastsd ymm7, [u_one]
    vmovapd ymm6, ymm0
%endmacro
%macro M2s_c32b 0
    vmovapd ymm6, ymm0
    vmovapd [r12 + 192], ymm7
    vmovapd [r12 + 192 + 32], ymm6
    vmovapd [r12 + 256], ymm7
%endmacro
%macro M2s_c32c 0
    vmovapd [r12 + 192], ymm7
    vmovapd [r12 + 192 + 32], ymm6
    vmovapd [r12 + 256], ymm7
    vmovapd [r12 + 256 + 32], ymm6
%endmacro
%macro M2s_c32d 0
    vmovapd ymm7, [r12 + 256 + 32]
M2s_dd0
    vfmadd231pd ymm3, ymm6, [r12 + 128 + 32]
    vaddpd ymm4, ymm4, ymm3
    vaddpd ymm3, ymm1, ymm4
%endmacro
%macro M2s_c32e 0
M2s_dd0
    vfmadd231pd ymm3, ymm6, [r12 + 128 + 32]
    vaddpd ymm4, ymm4, ymm3
    vaddpd ymm3, ymm1, ymm4
    vsubpd ymm5, ymm3, ymm1
%endmacro
%macro M2s_c32f 0
    vsubpd ymm5, ymm3, ymm1
    vsubpd ymm5, ymm4, ymm5
    vbroadcastsd ymm7, [r8]
    vdivpd ymm6, ymm3, ymm7
%endmacro
%macro M2s_c330 0
    vsubpd ymm5, ymm4, ymm5
    vbroadcastsd ymm7, [r8]
    vdivpd ymm6, ymm3, ymm7
    vxorpd ymm4, ymm6, [u_mzero]
%endmacro
%macro M2s_c331 0
    vmulpd ymm8, ymm0, ymm4
    vfmadd231pd ymm8, ymm7, ymm0
    vaddpd ymm2, ymm2, ymm8
    vaddpd ymm8, ymm1, ymm2
%endmacro
%macro M2s_c332 0
    vfmadd231pd ymm8, ymm7, ymm0
    vaddpd ymm2, ymm2, ymm8
    vaddpd ymm8, ymm1, ymm2
    vsubpd ymm9, ymm8, ymm1
%endmacro
%macro M2s_c333 0
    vsubpd ymm10, ymm9, ymm10
M2s_dd1
M2s_dd2
    vmovapd ymm8, ymm9
    vfmsub231pd ymm8, ymm7, ymm3
    vmulpd ymm10, ymm0, ymm3
%endmacro
%macro M2s_c334 0
M2s_dd1
M2s_dd2
    vmovapd ymm8, ymm9
    vfmsub231pd ymm8, ymm7, ymm3
    vmulpd ymm10, ymm0, ymm3
    vfmadd231pd ymm10, ymm7, ymm0
%endmacro
%macro M2s_c335 0
    vfmadd231pd ymm10, ymm7, ymm0
M2s_dd3
    vaddpd ymm3, ymm11, ymm10
    vsubpd ymm8, ymm3, ymm11
    vsubpd ymm9, ymm3, ymm8
%endmacro
%macro M2s_c336 0
M2s_dd3
    vaddpd ymm3, ymm11, ymm10
    vsubpd ymm8, ymm3, ymm11
    vsubpd ymm9, ymm3, ymm8
    vsubpd ymm9, ymm11, ymm9
%endmacro
%macro M2s_c337 0
    vsubpd ymm9, ymm11, ymm9
    vsubpd ymm8, ymm10, ymm8
    vaddpd ymm9, ymm9, ymm8
    vaddpd ymm8, ymm1, ymm2
%endmacro
%macro M2s_c338 0
    vsubpd ymm8, ymm10, ymm8
    vaddpd ymm9, ymm9, ymm8
    vaddpd ymm8, ymm1, ymm2
    vsubpd ymm4, ymm8, ymm1
%endmacro
%macro M2s_c339 0
    vaddpd ymm12, ymm12, ymm4
M2s_dd4
    vaddpd ymm4, ymm9, ymm12
    vaddpd ymm12, ymm8, ymm4
    vdivpd ymm1, ymm12, ymm7
%endmacro
%macro M2s_c33a 0
M2s_dd4
    vaddpd ymm4, ymm9, ymm12
    vaddpd ymm12, ymm8, ymm4
    vdivpd ymm1, ymm12, ymm7
    vaddpd ymm12, ymm6, ymm5
%endmacro
%macro M2s_c33b 0
    vaddpd ymm12, ymm6, ymm5
    vsubpd ymm11, ymm12, ymm6
    vsubpd ymm11, ymm5, ymm11
    vaddpd ymm5, ymm12, ymm1
%endmacro
%macro M2s_c33c 0
    vsubpd ymm11, ymm12, ymm6
    vsubpd ymm11, ymm5, ymm11
    vaddpd ymm5, ymm12, ymm1
    vsubpd ymm6, ymm5, ymm12
%endmacro
%macro M2s_c33d 0
    vaddpd ymm2, ymm2, ymm6
    vaddpd ymm6, ymm11, ymm0
    vsubpd ymm10, ymm6, ymm11
    vsubpd ymm4, ymm6, ymm10
%endmacro
%macro M2s_c33e 0
    vaddpd ymm6, ymm11, ymm0
    vsubpd ymm10, ymm6, ymm11
    vsubpd ymm4, ymm6, ymm10
    vsubpd ymm4, ymm11, ymm4
%endmacro
%macro M2s_c33f 0
    vmovapd [r12 + 256 + 32], ymm2
M2s_dd5
M2s_dd6
    vsubpd ymm6, ymm2, ymm6
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm10, ymm12
%endmacro
%macro M2s_c340 0
M2s_dd5
M2s_dd6
    vsubpd ymm6, ymm2, ymm6
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm10, ymm12
    vaddpd ymm12, ymm11, ymm6
%endmacro
%macro M2s_c341 0
    vaddpd ymm12, ymm11, ymm6
M2s_dd7
    vsubpd ymm10, ymm5, ymm12
    vsubpd ymm10, ymm6, ymm10
    vmovapd [r12 + 192], ymm5
%endmacro
%macro M2s_c342 0
M2s_dd7
    vsubpd ymm10, ymm5, ymm12
    vsubpd ymm10, ymm6, ymm10
    vmovapd [r12 + 192], ymm5
    vmovapd [r12 + 192 + 32], ymm10
%endmacro
%macro M2s_c343 0
    vmovapd [r12 + 192 + 32], ymm10
    add r8, 8
    lea r9, [u_cs + 104]
    cmp r8, r9
%endmacro
%macro M2s_c344 0
    add r8, 8
    lea r9, [u_cs + 104]
    cmp r8, r9
    jne .dexp_t
%endmacro
%macro M2s_c345 0
    .dexp_q:
M2s_dd8
    vfmadd231pd ymm1, ymm10, ymm5
    vaddpd ymm4, ymm4, ymm1
    vaddpd ymm1, ymm2, ymm4
%endmacro
%macro M2s_c346 0
M2s_dd8
    vfmadd231pd ymm1, ymm10, ymm5
    vaddpd ymm4, ymm4, ymm1
    vaddpd ymm1, ymm2, ymm4
    vsubpd ymm7, ymm1, ymm2
%endmacro
%macro M2s_c347 0
    vsubpd ymm7, ymm1, ymm2
    vsubpd ymm7, ymm4, ymm7
    vmovapd ymm10, ymm1
    vmovapd ymm5, ymm7
%endmacro
%macro M2s_c348 0
    vsubpd ymm7, ymm4, ymm7
    vmovapd ymm10, ymm1
    vmovapd ymm5, ymm7
    dec r8d
%endmacro
%macro M2s_c349 0
    vpsllq ymm7, ymm7, 52
    vmulpd ymm14, ymm10, ymm7
    vmulpd ymm15, ymm5, ymm7
    ret
%endmacro
%macro M2s_c34a 0
    vmulpd ymm14, ymm10, ymm7
    vmulpd ymm15, ymm5, ymm7
    ret
    .dln:
%endmacro
%macro M2s_c34b 0
    fldln2
M2s_dd9
M2s_dda
    vmovapd ymm1, [r12 + 0 + 32]
    vmovapd ymm2, [r12 + 0 + 64]
    vmulpd ymm3, ymm1, ymm14
%endmacro
%macro M2s_c34c 0
M2s_dd9
M2s_dda
    vmovapd ymm1, [r12 + 0 + 32]
    vmovapd ymm2, [r12 + 0 + 64]
    vmulpd ymm3, ymm1, ymm14
    vmovapd ymm4, ymm3
%endmacro
%macro M2s_c34d 0
    vmovapd ymm4, ymm3
M2s_ddb
    vaddpd ymm5, ymm3, ymm4
    vsubpd ymm6, ymm5, ymm3
    vsubpd ymm6, ymm4, ymm6
%endmacro
%macro M2s_c34e 0
M2s_ddb
    vaddpd ymm5, ymm3, ymm4
    vsubpd ymm6, ymm5, ymm3
    vsubpd ymm6, ymm4, ymm6
    vbroadcastsd ymm2, [u_mone]
%endmacro
%macro M2s_c34f 0
    vbroadcastsd ymm2, [u_mone]
    vbroadcastsd ymm1, [u_mzero]
    vaddpd ymm4, ymm5, ymm2
    vsubpd ymm3, ymm4, ymm5
%endmacro
%macro M2s_c350 0
    vbroadcastsd ymm1, [u_mzero]
    vaddpd ymm4, ymm5, ymm2
    vsubpd ymm3, ymm4, ymm5
    vsubpd ymm7, ymm4, ymm3
%endmacro
%macro M2s_c351 0
    vaddpd ymm3, ymm6, ymm1
M2s_ddc
    vaddpd ymm9, ymm9, ymm8
    vaddpd ymm8, ymm7, ymm3
    vaddpd ymm3, ymm4, ymm8
%endmacro
%macro M2s_c352 0
M2s_ddc
    vaddpd ymm9, ymm9, ymm8
    vaddpd ymm8, ymm7, ymm3
    vaddpd ymm3, ymm4, ymm8
    vsubpd ymm7, ymm3, ymm4
%endmacro
%macro M2s_c353 0
    vsubpd ymm7, ymm3, ymm4
    vsubpd ymm7, ymm8, ymm7
    vaddpd ymm8, ymm7, ymm9
    vaddpd ymm9, ymm3, ymm8
%endmacro
%macro M2s_c354 0
    vsubpd ymm7, ymm8, ymm7
    vaddpd ymm8, ymm7, ymm9
    vaddpd ymm9, ymm3, ymm8
    vsubpd ymm7, ymm9, ymm3
%endmacro
%macro M2s_c355 0
    vsubpd ymm1, ymm5, ymm6
    vsubpd ymm2, ymm5, ymm1
    vsubpd ymm2, ymm6, ymm2
    vsubpd ymm1, ymm9, ymm1
%endmacro
%macro M2s_c356 0
    vsubpd ymm2, ymm5, ymm1
    vsubpd ymm2, ymm6, ymm2
    vsubpd ymm1, ymm9, ymm1
    vaddpd ymm2, ymm2, ymm1
%endmacro
%macro M2s_c357 0
    vaddpd ymm3, ymm1, ymm8
M2s_ddd
M2s_dde
M2s_a3e9
    vxorpd ymm15, ymm15, [r12 + 320]
    ret
%endmacro
%macro M2s_c358 0
M2s_ddd
M2s_dde
M2s_a3e9
    vxorpd ymm15, ymm15, [r12 + 320]
    ret
    .xoe:
%endmacro
%macro M2s_c359 0
    .xoe:
M2s_c35a
    vbroadcastsd ymm0, [u_e512]
    vbroadcastsd ymm1, [u_e512 + 8]
    vmulpd ymm2, ymm0, ymm14
%endmacro
%macro M2s_c35a 0
M2s_b590
    vblendvpd ymm14, ymm14, ymm11, ymm12
    vandnpd ymm15, ymm12, ymm15
    call .dln
%endmacro
%macro M2s_c35b 0
    vmovapd ymm3, ymm2
    vfmsub231pd ymm3, ymm0, ymm14
M2s_b594
    vsubpd ymm5, ymm4, ymm2
%endmacro
%macro M2s_c35c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c35d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c35e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c35f 0
    vfmadd231ps ymm4, ymm0, ymm12
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 20]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_c360 0
M2s_ddf
%endmacro
%macro M2s_c361 0
    vpermps ymm1, ymm3, [r8 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 112]
%endmacro
%macro M2s_c362 0
M2s_c361
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c363 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm11
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 16]
%endmacro
%macro M2s_c364 0
M2s_c363
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c365 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c366 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c367 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c368 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c369 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm0, ymm3, [r13 + 0]
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c36a 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_c36b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c36c 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_c36d 0
    vpermps ymm1, ymm3, [r13 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 100]
%endmacro
%macro M2s_c36e 0
M2s_de0
%endmacro
%macro M2s_c36f 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_de0
    vpermps ymm1, ymm3, [r13 + 136]
%endmacro
%macro M2s_c370 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c371 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c372 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 140]
%endmacro
%macro M2s_c373 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c374 0
    vpermps ymm1, ymm3, [r13 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 176]
%endmacro
%macro M2s_c375 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_c376 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c377 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_c378 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_c379 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm6, ymm0, ymm8
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 4]
%endmacro
%macro M2s_c37a 0
    vpermps ymm1, ymm3, [r9 + 36]
M2s_db
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c37b 0
M2s_b5f8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 196]
%endmacro
%macro M2s_c37c 0
    vpermps ymm1, ymm3, [r9 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 164]
%endmacro
%macro M2s_c37d 0
    vpermps ymm1, ymm3, [r9 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 168]
%endmacro
%macro M2s_c37e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c37f 0
M2s_de2
%endmacro
%macro M2s_c380 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_dd
    vpermps ymm1, ymm3, [r9 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_c381 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_da
    vpermps ymm1, ymm3, [r9 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c382 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c383 0
M2s_a43a
    vfmadd231ps ymm6, ymm0, ymm12
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 20]
%endmacro
%macro M2s_c384 0
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_c385 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c386 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c387 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 48]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c388 0
    vpermps ymm1, ymm3, [r9 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 112]
%endmacro
%macro M2s_c389 0
    vpermps ymm1, ymm3, [r9 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 84]
%endmacro
%macro M2s_c38a 0
    vpermps ymm1, ymm3, [r9 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 120]
%endmacro
%macro M2s_c38b 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c38c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 284]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c38d 0
    vpermps ymm1, ymm3, [r8 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 280]
%endmacro
%macro M2s_c38e 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 196]
M2s_d12
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 260]
%endmacro
%macro M2s_c38f 0
    vpermps ymm1, ymm3, [r9 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 288]
%endmacro
%macro M2s_c390 0
    vmovups ymm7, [rax+128]
M2s_d28
    vfmadd213ps ymm5, ymm6, ymm14
    vmovaps [rdx+32], ymm11
    vmulps ymm4, ymm10, ymm2
%endmacro
%macro M2s_c391 0
    sub rcx, 2
M2s_d2d
    vmovups ymm12, [c_q8o2]
M2s_d2f
    vpsrld ymm2, ymm1, 23
    vpslld ymm3, ymm1, 5
%endmacro
%macro M2s_c392 0
    vpsrld ymm9, ymm1, 20
M2s_d30
    vmovups ymm5, [rax+64]
    vblendvps ymm6, ymm7, ymm8, ymm3
    vpsubd ymm7, ymm0, ymm9
%endmacro
%macro M2s_c393 0
M2s_b63b
M2s_d6d
M2s_d68
    vpmaddwd ymm3, ymm2, ymm13
    vpslld ymm2, ymm2, 23
    vpsrld ymm4, ymm3, 14
%endmacro
%macro M2s_c394 0
    mov r14, rax
M2s_d91
M2s_d87
    cmovb rcx, rbx
    sub rdx, rcx
    cmp qword [r12 + 1272], 0
%endmacro
%macro M2s_c395 0
M2s_c396
    vpermps ymm1, ymm3, [r8 + 72]
M2s_d3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c396 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_d2
    vpermps ymm1, ymm3, [r8 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c397 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_d4
    vpermps ymm1, ymm3, [r8 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c398 0
M2s_c397
    vpermps ymm1, ymm3, [r8 + 76]
M2s_d5
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c399 0
M2s_de8
%endmacro
%macro M2s_c39a 0
M2s_c399
M2s_de9
%endmacro
%macro M2s_c39b 0
    vpermps ymm1, ymm3, [r8 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 276]
%endmacro
%macro M2s_c39c 0
    vpermps ymm1, ymm3, [r8 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 288]
%endmacro
%macro M2s_c39d 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_c39e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c39f
    vpermps ymm1, ymm3, [r8 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c39f 0
    vfmadd231ps ymm4, ymm0, [rcx + 288]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 40]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_c3a0 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 40]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 72]
%endmacro
%macro M2s_c3a1 0
    vpermps ymm1, ymm3, [r8 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 104]
%endmacro
%macro M2s_c3a2 0
    vpermps ymm1, ymm3, [r8 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 136]
%endmacro
%macro M2s_c3a3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3a4 0
    vpermps ymm1, ymm3, [r8 + 200]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 232]
%endmacro
%macro M2s_c3a5 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm0, ymm3, [r13 + 0]
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3a6 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
%endmacro
%macro M2s_c3a7 0
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_c3a8 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_c3a9 0
    vpermps ymm1, ymm3, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 132]
%endmacro
%macro M2s_c3aa 0
    vpermps ymm1, ymm3, [r13 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 196]
%endmacro
%macro M2s_c3ab 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3ac 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3ad 0
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_c3ae 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 136]
%endmacro
%macro M2s_c3af 0
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_c3b0 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_c3b1 0
    vpermps ymm1, ymm3, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 140]
%endmacro
%macro M2s_c3b2 0
    vpermps ymm1, ymm3, [r13 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 204]
%endmacro
%macro M2s_c3b3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3b4 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3b5 0
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_c3b6 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_c3b7 0
    vpermps ymm1, ymm3, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 144]
%endmacro
%macro M2s_c3b8 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
%endmacro
%macro M2s_c3b9 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3ba 0
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 304]
%endmacro
%macro M2s_c3bb 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_c3bc 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3bd 0
    vpermps ymm1, ymm3, [r13 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 148]
%endmacro
%macro M2s_c3be 0
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r13 + 60]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
%endmacro
%macro M2s_c3bf 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3c0 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3c1 0
M2s_dea
%endmacro
%macro M2s_c3c2 0
    vmovaps ymm4, ymm2
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 0]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_c3c3 0
M2s_deb
%endmacro
%macro M2s_c3c4 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_dc
    vpermps ymm1, ymm3, [r9 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c3c5 0
M2s_dee
%endmacro
%macro M2s_c3c6 0
M2s_c3c5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3c7 0
    vpermps ymm1, ymm3, [r9 + 296]
M2s_de3
M2s_de2
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 140]
%endmacro
%macro M2s_c3c8 0
M2s_c3c9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3c9 0
    vpermps ymm1, ymm3, [r9 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 268]
%endmacro
%macro M2s_c3ca 0
    vmovdqu ymm3, [rdx + 192]
M2s_b6ca
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_c3cb 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3cc 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 312]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3cd 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_c3ce
    vpermps ymm1, ymm3, [r9 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c3ce 0
    vfmadd231ps ymm6, ymm0, [rcx + 288]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 40]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_c3cf 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 40]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 72]
%endmacro
%macro M2s_c3d0 0
    vpermps ymm1, ymm3, [r9 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 104]
%endmacro
%macro M2s_c3d1 0
    vpermps ymm1, ymm3, [r9 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 136]
%endmacro
%macro M2s_c3d2 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 136]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3d3 0
M2s_b6f8
M2s_d15
    vperm2f128 ymm0, ymm14, ymm5, 0x21
    vpalignr ymm0, ymm5, ymm0, 12
    vaddps ymm4, ymm4, ymm0
%endmacro
%macro M2s_c3d4 0
M2s_b6fa
    vpermpd ymm5, ymm5, 0xd8
    cmp qword [rbp + 40], 0
    jne .hf
%endmacro
%macro M2s_c3d5 0
    vmovups ymm12, [c_q8o2]
    vmovups ymm11, [c_q8o1]
M2s_d31
M2s_d22
M2s_d23
    vpermps ymm0, ymm9, [c_rxo]
    vpslld ymm9, ymm2, 23
%endmacro
%macro M2s_c3d6 0
M2s_def
%endmacro
%macro M2s_c3d7 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_c3d8 0
    vpermps ymm1, ymm3, [r8 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 236]
%endmacro
%macro M2s_c3d9 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r8 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3da 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3db 0
M2s_df0
%endmacro
%macro M2s_c3dc 0
M2s_df1
%endmacro
%macro M2s_c3dd 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3de 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_c3df 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
%endmacro
%macro M2s_c3e0 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3e1 0
    vfmadd231ps ymm4, ymm0, [rcx + 320]
M2s_def
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 108]
%endmacro
%macro M2s_c3e2 0
    vfmadd231ps ymm6, ymm0, [rcx + 320]
M2s_df1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 108]
%endmacro
%macro M2s_c3e3 0
M2s_de4
%endmacro
%macro M2s_c3e4 0
    vpermps ymm1, ymm3, [r8 + 328]
M2s_de6
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3e5 0
M2s_de7
%endmacro
%macro M2s_c3e6 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_c3e7 0
    vpermps ymm1, ymm3, [r8 + 336]
M2s_de8
M2s_de9
M2s_ddf
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 148]
%endmacro
%macro M2s_c3e8 0
    vpermps ymm1, ymm3, [r8 + 340]
M2s_df3
%endmacro
%macro M2s_c3e9 0
M2s_df3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c3ea 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm13
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 24]
%endmacro
%macro M2s_c3eb 0
    vpermps ymm1, ymm3, [r8 + 344]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_d6
    vpermps ymm1, ymm3, [r8 + 60]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3ec 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_d8
    vpermps ymm1, ymm3, [r8 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c3ed 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 316]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_c3ee 0
    vmovdqu ymm3, [rdx + 96]
M2s_d9
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 228]
%endmacro
%macro M2s_c3ef 0
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r8 + 300]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
%endmacro
%macro M2s_c3f0 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm0, ymm3, [r13 + 0]
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 32]
%endmacro
%macro M2s_c3f1 0
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 256]
%endmacro
%macro M2s_c3f2 0
M2s_df4
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 128]
%endmacro
%macro M2s_c3f3 0
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_c3f4 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 132]
%endmacro
%macro M2s_c3f5 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3f6 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 292]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3f7 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 136]
%endmacro
%macro M2s_c3f8 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3f9 0
    vpermps ymm1, ymm3, [r13 + 264]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 296]
%endmacro
%macro M2s_c3fa 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3fb 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 140]
%endmacro
%macro M2s_c3fc 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c3fd 0
M2s_df5
%endmacro
%macro M2s_c3fe 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 144]
%endmacro
%macro M2s_c3ff 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c400 0
    vpermps ymm1, ymm3, [r13 + 272]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 304]
%endmacro
%macro M2s_c401 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 152]
%endmacro
%macro M2s_c402 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c403 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c404 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 148]
%endmacro
%macro M2s_c405 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c406 0
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 276]
%endmacro
%macro M2s_c407 0
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 280]
%endmacro
%macro M2s_c408 0
M2s_b792
    vpermps ymm1, ymm3, [r9 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
%endmacro
%macro M2s_c409 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, ymm13
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 24]
%endmacro
%macro M2s_c40a 0
M2s_c409
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c40b 0
    vpermps ymm1, ymm3, [r9 + 348]
M2s_df
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c40c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 192]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c40d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_df2
    vpermps ymm1, ymm3, [r9 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c40e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 204]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c40f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_df4
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
%endmacro
%macro M2s_c410 0
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 160]
%endmacro
%macro M2s_c411 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c412 0
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_c413 0
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_c414 0
M2s_df6
%endmacro
%macro M2s_c415 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c416 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 208]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_c417 0
M2s_df7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c418 0
    vpermps ymm1, ymm3, [r9 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 144]
%endmacro
%macro M2s_c419 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c41a 0
M2s_c419
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_c41b 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 144]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_c41c 0
    vpermps ymm1, ymm3, [r9 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 272]
%endmacro
%macro M2s_c41d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r9 + 304]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c41e 0
    vfmadd231ps ymm4, ymm0, [rcx + 352]
M2s_df6
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 112]
%endmacro
%macro M2s_c41f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r8 + 296]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c420 0
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_c421 0
    vmovdqu ymm3, [rdx + 512]
M2s_df5
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 300]
%endmacro
%macro M2s_c422 0
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_c423 0
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_c424 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 352]
M2s_df7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_c425 0
M2s_df9
M2s_df8
%endmacro
%macro M2s_c426 0
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
%endmacro
%macro M2s_c427 0
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
%endmacro
%macro M2s_c428 0
    vpermps ymm1, ymm3, [r8 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r8 + 356]
%endmacro
%macro M2s_c429 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm0, ymm3, [r13 + 0]
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 32]
%endmacro
%macro M2s_c42a 0
M2s_dfa
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 128]
%endmacro
%macro M2s_c42b 0
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_c42c 0
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 256]
%endmacro
%macro M2s_c42d 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 132]
%endmacro
%macro M2s_c42e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c42f 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
%endmacro
%macro M2s_c430 0
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_c431 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 136]
%endmacro
%macro M2s_c432 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c433 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 328]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c434 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c435 0
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 268]
%endmacro
%macro M2s_c436 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 144]
%endmacro
%macro M2s_c437 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 176]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c438 0
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 336]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
%endmacro
%macro M2s_c439 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 148]
%endmacro
%macro M2s_c43a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c43b 0
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 308]
%endmacro
%macro M2s_c43c 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 152]
%endmacro
%macro M2s_c43d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 184]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c43e 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 124]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 156]
%endmacro
%macro M2s_c43f 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 188]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c440 0
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 292]
%endmacro
%macro M2s_c441 0
    vpermps ymm1, ymm3, [r9 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r9 + 364]
%endmacro
%macro M2s_c442 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_dfa
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
%endmacro
%macro M2s_c443 0
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 160]
%endmacro
%macro M2s_c444 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c445 0
M2s_c446
    vpermps ymm1, ymm3, [r13 + 268]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 300]
%endmacro
%macro M2s_c446 0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_c447 0
    vpermps ymm1, ymm3, [r13 + 140]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 172]
%endmacro
%macro M2s_c448 0
    vfmadd231ps ymm4, ymm0, [rcx + 384]
M2s_dfb
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 116]
%endmacro
%macro M2s_c449 0
M2s_dfb
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c44a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c44b 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_c44c 0
    vpermps ymm1, ymm3, [r8 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 244]
%endmacro
%macro M2s_c44d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r8 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c44e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c44f 0
    vfmadd231ps ymm5, ymm0, [rcx + 864]
M2s_dea
    vpermps ymm0, ymm3, [r9 + 0]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 32]
%endmacro
%macro M2s_c450 0
M2s_dfc
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 116]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c451 0
M2s_c452
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 180]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
%endmacro
%macro M2s_c452 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c453 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 148]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_c454 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 212]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_c455 0
    vpermps ymm1, ymm3, [r9 + 308]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 256]
    vpermps ymm1, ymm3, [r9 + 340]
%endmacro
%macro M2s_c456 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_c457 0
    vfmadd231ps ymm6, ymm0, [rcx + 384]
M2s_dfc
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 116]
%endmacro
%macro M2s_c458 0
    vpermps ymm1, ymm3, [r9 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r9 + 276]
%endmacro
%macro M2s_c459 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 320]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c45a 0
M2s_dfd
%endmacro
%macro M2s_c45b 0
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 292]
%endmacro
%macro M2s_c45c 0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_c45d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 332]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c45e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 340]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c45f 0
    vpermps ymm1, ymm3, [r8 + 384]
M2s_d13
M2s_d14
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r8 + 132]
%endmacro
%macro M2s_c460 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 388]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c461 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r8 + 412]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c462 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 288]
    vpermps ymm1, ymm3, [r8 + 356]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c463 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm0, ymm3, [r13 + 0]
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 32]
%endmacro
%macro M2s_c464 0
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 128]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
%endmacro
%macro M2s_c465 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c466 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c467 0
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
%endmacro
%macro M2s_c468 0
    vpermps ymm1, ymm3, [r13 + 160]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 192]
%endmacro
%macro M2s_c469 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c46a 0
    vmovdqu ymm3, [rdx + 608]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
%endmacro
%macro M2s_c46b 0
    vpermps ymm1, ymm3, [r13 + 288]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 672]
    vpermps ymm1, ymm3, [r13 + 320]
%endmacro
%macro M2s_c46c 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 704]
    vpermps ymm1, ymm3, [r13 + 352]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c46d 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 132]
%endmacro
%macro M2s_c46e 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c46f 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 136]
%endmacro
%macro M2s_c470 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 168]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c471 0
M2s_b8d8
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 512]
    vpermps ymm1, ymm3, [r13 + 172]
%endmacro
%macro M2s_c472 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
%endmacro
%macro M2s_c473 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
M2s_b8df
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c474 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
%endmacro
%macro M2s_c475 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 112]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 144]
%endmacro
%macro M2s_c476 0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 152]
%endmacro
%macro M2s_c477 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 60]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 448]
    vpermps ymm1, ymm3, [r13 + 124]
%endmacro
%macro M2s_c478 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 480]
    vpermps ymm1, ymm3, [r13 + 156]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c479 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 640]
    vpermps ymm1, ymm3, [r13 + 324]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c47a 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_dfd
    vpermps ymm1, ymm3, [r13 + 276]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 608]
%endmacro
%macro M2s_c47b 0
    vmovdqu ymm3, [rdx + 0]
M2s_de1
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 100]
%endmacro
%macro M2s_c47c 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 56]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r8 + 120]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c47d 0
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_c47e 0
    vfmadd231ps ymm5, ymm0, [rcx + 928]
M2s_dea
M2s_deb
M2s_df0
    vpermps ymm1, ymm3, [r9 + 96]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
%endmacro
%macro M2s_c47f 0
    vfmadd231ps ymm6, ymm0, [rcx + 416]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 56]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 88]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 120]
%endmacro
%macro M2s_c480 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 152]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c481 0
    vmulps ymm4, ymm0, ymm3
    vpermps ymm0, ymm8, [r8 + 4]
    vpermps ymm1, ymm8, [r8 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm8
%endmacro
%macro M2s_c482 0
    vmulps ymm6, ymm0, ymm3
    vpermps ymm0, ymm8, [r9 + 4]
    vpermps ymm1, ymm8, [r9 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm8
%endmacro
%macro M2s_c483 0
    vpermps ymm0, ymm8, [r8 + 8]
    vpermps ymm1, ymm8, [r8 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r8 + 72]
%endmacro
%macro M2s_c484 0
    vpermps ymm0, ymm8, [r8 + 12]
    vpermps ymm1, ymm8, [r8 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vpermps ymm1, ymm9, [r8 + 76]
%endmacro
%macro M2s_c485 0
    vpermps ymm0, ymm11, [r13 + 0]
    vpermps ymm1, ymm11, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm11
    vpermps ymm1, ymm12, [r13 + 64]
%endmacro
%macro M2s_c486 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm0, ymm3, [r13 + 0]
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r13 + 32]
%endmacro
%macro M2s_c487 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c488 0
    vfmadd231ps ymm5, ymm0, [rcx + 352]
    vshufps ymm2, ymm4, ymm5, 0x88
    vshufps ymm5, ymm4, ymm5, 0xdd
    vmovaps ymm4, ymm2
%endmacro
%macro M2s_c489 0
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm0, ymm3, [r13 + 0]
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r13 + 32]
%endmacro
%macro M2s_c48a 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
%endmacro
%macro M2s_c48b 0
    vpermps ymm1, ymm3, [r13 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 104]
%endmacro
%macro M2s_c48c 0
    vpermps ymm1, ymm3, [r9 + 164]
M2s_ded
M2s_dee
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 136]
%endmacro
%macro M2s_c48d 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c48e 0
    vfmadd231ps ymm5, ymm0, [rcx + 416]
    vshufps ymm2, ymm4, ymm5, 0x88
    vshufps ymm5, ymm4, ymm5, 0xdd
    vmovaps ymm4, ymm2
%endmacro
%macro M2s_c48f 0
    vpermps ymm1, ymm3, [r8 + 196]
M2s_de5
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c490 0
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm0, ymm3, [r13 + 0]
    vmovdqu ymm3, [rdx + 192]
    vpermps ymm1, ymm3, [r13 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 224]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c491 0
    vpermps ymm1, ymm3, [r9 + 196]
M2s_dec
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_c492 0
    vfmadd231ps ymm5, ymm0, [rcx + 544]
M2s_dea
    vpermps ymm0, ymm3, [r9 + 0]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 32]
%endmacro
%macro M2s_c493 0
    vmovups ymm3, [rdx+32]
M2s_d17
    vsubps ymm6, ymm4, ymm1
    vsubps ymm7, ymm5, ymm3
    vcmpps ymm8, ymm6, ymm14, 30
%endmacro
%macro M2s_c494 0
    vmovups ymm0, [rax+32]
    vmovups ymm1, [rdx]
    vmovups ymm2, [rax+160]
M2s_dfe
    vfmadd231ps ymm3, ymm5, ymm13
%endmacro
%macro M2s_c495 0
M2s_dff
M2s_d18
%endmacro
%macro M2s_c496 0
    vmovups ymm1, [rdx]
    vmovups ymm2, [rax+192]
    vmovups ymm3, [rdx+32]
    vandps ymm4, ymm0, ymm15
%endmacro
%macro M2s_c497 0
    mov rax, rsi
    mov r9, r10
    mov rcx, [rbp + 240]
    cmp rcx, 2
%endmacro
%macro M2s_c498 0
    vpsubd ymm6, ymm4, ymm0
    vmovaps [r9+192], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
    vfmadd213ps ymm5, ymm6, ymm14
%endmacro
%macro M2s_c499 0
    vmulps ymm4, ymm10, ymm2
    vmovaps ymm0, ymm12
    vfmadd231ps ymm0, ymm5, ymm13
    vmulps ymm9, ymm5, ymm4
%endmacro
%macro M2s_d0 0
M2s_e0
%endmacro
%macro M2s_d1 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_d2 0
    vfmadd231ps ymm4, ymm0, ymm9
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 8]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_d3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_d4 0
    vfmadd231ps ymm4, ymm0, ymm10
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 12]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_d5 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 108]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_d6 0
    vfmadd231ps ymm4, ymm0, [rcx + 192]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 28]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_d7 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 32]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 64]
%endmacro
%macro M2s_d8 0
    vfmadd231ps ymm4, ymm0, [rcx + 224]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 32]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_d9 0
    vpermps ymm1, ymm3, [r8 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r8 + 196]
%endmacro
%macro M2s_da 0
M2s_e1
%endmacro
%macro M2s_db 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_dc 0
    vfmadd231ps ymm6, ymm0, ymm9
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 8]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_dd 0
    vmovdqu ymm3, [rdx + 128]
    vpermps ymm1, ymm3, [r9 + 172]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
%endmacro
%macro M2s_de 0
    vfmadd231ps ymm6, ymm0, [rcx + 224]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 32]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_df 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 224]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 32]
%endmacro
%macro M2s_d10 0
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 92]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
%endmacro
%macro M2s_d11 0
    vpermps ymm1, ymm3, [r9 + 60]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 92]
%endmacro
%macro M2s_d12 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 160]
    vpermps ymm1, ymm3, [r9 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_d13 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_e0
    vpermps ymm1, ymm3, [r8 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_d14 0
    vpermps ymm1, ymm3, [r8 + 68]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 100]
%endmacro
%macro M2s_d15 0
    cmp rsi, [rbp + 224]
    jne .hf
    vbroadcastss ymm14, xmm4
.hf:
%endmacro
%macro M2s_d16 0
    mov rax, rsi
    mov rdx, r8
    mov r9, r10
    mov rcx, [rbp + 240]
%endmacro
%macro M2s_d17 0
    vandps ymm4, ymm0, ymm15
    vfmadd231ps ymm1, ymm4, ymm13
    vandps ymm5, ymm2, ymm15
    vfmadd231ps ymm3, ymm5, ymm13
%endmacro
%macro M2s_d18 0
    vfmadd231ps ymm1, ymm4, ymm13
    vandps ymm5, ymm2, ymm15
    vfmadd231ps ymm3, ymm5, ymm13
    vsubps ymm6, ymm4, ymm1
%endmacro
%macro M2s_d19 0
    vmovups ymm1, [rdx+192]
    vandps ymm2, ymm0, ymm15
    vfmadd231ps ymm1, ymm2, ymm13
    vsubps ymm3, ymm2, ymm1
%endmacro
%macro M2s_d1a 0
    vmovups ymm1, [rdx+192]
    vmovups ymm2, [rax+192]
    vmovups ymm3, [rdx+416]
    vandps ymm4, ymm0, ymm15
%endmacro
%macro M2s_d1b 0
    vmovups ymm0, [rax+32]
    vmovups ymm1, [rdx+192]
    vandps ymm2, ymm0, ymm15
    vfmadd231ps ymm1, ymm2, ymm13
%endmacro
%macro M2s_d1c 0
    vcmpps ymm4, ymm3, ymm14, 30
    vrcpps ymm5, ymm3
    vmovaps [r9+160], ymm4
    vandnps ymm6, ymm4, ymm1
    vaddps ymm7, ymm2, ymm6
    vmulps ymm8, ymm1, ymm5
    vmovaps [r9+96], ymm7
    vblendvps ymm9, ymm10, ymm8, ymm4
%endmacro
%macro M2s_d1d 0
    vmovups ymm0, [rax+64]
    vmovups ymm1, [rdx+192]
    vmovups ymm2, [rax+192]
    vmovups ymm3, [rdx+416]
%endmacro
%macro M2s_d1e 0
    vmovups ymm0, [rax+64]
    vmovups ymm1, [rdx+192]
    vandps ymm2, ymm0, ymm15
    vfmadd231ps ymm1, ymm2, ymm13
%endmacro
%macro M2s_d1f 0
    vcmpps ymm4, ymm3, ymm14, 30
    vrcpps ymm5, ymm3
    vmovaps [r9+256], ymm4
    vandnps ymm6, ymm4, ymm1
    vaddps ymm7, ymm2, ymm6
    vmulps ymm8, ymm1, ymm5
    vmovaps [r9+192], ymm7
    vblendvps ymm9, ymm10, ymm8, ymm4
%endmacro
%macro M2s_d20 0
M2s_a19d
    vpermps ymm8, ymm2, [c_to+96]
M2s_a1a3
    vmovups ymm9, [rax+64]
%endmacro
%macro M2s_d21 0
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_mone]
    vmovups ymm13, [c_q8o3]
    vmovups ymm12, [c_q8o2]
%endmacro
%macro M2s_d22 0
    vpslld ymm3, ymm1, 5
    vpslld ymm4, ymm1, 4
    vpermps ymm5, ymm2, [c_to]
    vpermps ymm6, ymm2, [c_to+32]
%endmacro
%macro M2s_d23 0
    vpermps ymm7, ymm2, [c_to+64]
    vpermps ymm8, ymm2, [c_to+96]
    vpsrld ymm9, ymm1, 20
    vpermps ymm10, ymm9, [c_w8o]
%endmacro
%macro M2s_d24 0
M2s_a1ba
M2s_a1c2
M2s_b1c1
    add rdx, 224
%endmacro
%macro M2s_d25 0
    vmovups ymm0, [r9]
    vpmaxud ymm1, ymm0, ymm15
    vpsrld ymm2, ymm1, 23
    vpslld ymm3, ymm1, 5
%endmacro
%macro M2s_d26 0
    vpslld ymm0, ymm2, 23
    vmovups ymm9, [rax]
    vblendvps ymm2, ymm5, ymm6, ymm3
    vblendvps ymm5, ymm7, ymm8, ymm3
%endmacro
%macro M2s_d27 0
    vpsubd ymm6, ymm4, ymm0
    vmovaps [rdx], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
    vfmadd213ps ymm5, ymm6, ymm14
%endmacro
%macro M2s_d28 0
    vandps ymm9, ymm10, [r9+64]
    vpsubd ymm6, ymm4, ymm0
    vmovaps [rdx], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
%endmacro
%macro M2s_d29 0
    vmovups ymm0, [r9+96]
    vpmaxud ymm1, ymm0, ymm15
    vpsrld ymm2, ymm1, 23
    vpslld ymm3, ymm1, 5
%endmacro
%macro M2s_d2a 0
    jb .et
    mov rdi, [rbp + 8]
    mov rax, [rdi + G_su]
    shl rax, 2
%endmacro
%macro M2s_d2b 0
    mov rdi, [rbp + 8]
    mov rax, [rdi + G_su]
    shl rax, 2
    imul rax, [rbp + 40]
%endmacro
%macro M2s_d2c 0
    add rdx, 224
M2s_a202
.i1c1:
    vmovups ymm0, [rax+32]
%endmacro
%macro M2s_d2d 0
    cmp rcx, 2
M2s_d2e
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_mone]
    vmovups ymm13, [c_q8o3]
%endmacro
%macro M2s_d2e 0
    jae .i2c2
.i2c2r:
    test rcx, rcx
    jz .i2c2e
%endmacro
%macro M2s_d2f 0
    vmovups ymm11, [c_q8o1]
.i2c2s:
    vmovups ymm0, [r9+192]
    vpmaxud ymm1, ymm0, ymm15
%endmacro
%macro M2s_d30 0
    vpermps ymm10, ymm9, [c_w8o]
    vpermps ymm0, ymm9, [c_rxo]
    vpslld ymm9, ymm2, 23
    vblendvps ymm2, ymm5, ymm6, ymm3
%endmacro
%macro M2s_d31 0
.i2c0s:
    vmovups ymm0, [r9]
    vpmaxud ymm1, ymm0, ymm15
    vpsrld ymm2, ymm1, 23
%endmacro
%macro M2s_d32 0
    jb .i2c1r
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_mone]
    vmovups ymm13, [c_q8o3]
%endmacro
%macro M2s_d33 0
    vmovaps ymm8, [rdi + G_cmx + 0]
    vmovaps ymm7, ymm8
    vfmsub132ps ymm7, ymm0, [r8 + 128]
    vmovaps ymm1, [rdi + G_csb]
%endmacro
%macro M2s_d34 0
    pdep rdx, rbx, r11
    imul rdx, rdx, 255
    pext rdx, r12, rdx
    vmovq xmm0, rdx
%endmacro
%macro M2s_d35 0
    vpmovmskb eax, ymm1
    vpmovmskb ecx, ymm2
    shl rcx, 32
    or rax, rcx
%endmacro
%macro M2s_d36 0
    vpmovzxbd ymm0, xmm0
    mov rdx, rcx
    shl rdx, 7
    add rdx, rsi
%endmacro
%macro M2s_d37 0
    mov rsi, [rdi + G_cl]
    mov r10, [rdi + G_su]
    mov rax, r10
    shl rax, 7
    add rsi, rax
    shl r10, 3
    imul r10, [rbp + 40]
    or r10d, 0x10000
%endmacro
%macro M2s_d38 0
    mov r8, [rdi + G_fs]
    mov r9, [rbp + 272]
    vpcmpeqb ymm1, ymm7, [rdi + G_ms + 64]
    vpcmpeqb ymm2, ymm7, [rdi + G_ms + 96]
%endmacro
%macro M2s_d39 0
    vmovq [rbp + 312], xmm4
    mov qword [rbp + 304], 0
.blj:
    mov rax, [rbp + 288]
%endmacro
%macro M2s_d3a 0
    mov rdi, [rbp + 8]
    mov rsi, [rdi + G_fs]
    mov ecx, [rsi + rax*4 + 262144]
    movzx edx, cx
%endmacro
%macro M2s_d3b 0
    mov r8, [rbp + 304]
    movzx eax, word [rbp + 312 + r8*2]
    mov rsi, rcx
    imul rsi, [rdi + G_wo]
%endmacro
%macro M2s_d3c 0
    mov rcx, [rbp + 16]
    mov r8, [rbp + 304]
    movzx eax, word [rbp + 312 + r8*2]
    mov rsi, [rdi + G_wo]
    shr rsi, 1
    imul rsi, rcx
    add rsi, rdx
    add rsi, rsi
%endmacro
%macro M2s_d3d 0
    mov r9, [rdi + G_db]
    mov [r9 + rsi], ax
    movzx r10d, word [rbp + 320 + r8*2]
    mov r9, [rdi + G_dr]
%endmacro
%macro M2s_d3e 0
    mov qword [rbp + 280], 0
    mov r15, [rbp + 48]
    add r15, PCS
    inc qword [rbp + 16]
%endmacro
%macro M2s_d3f 0
    lea r8, [rsi + r8*4]
    lea r9, [rsi + r9*4]
    lea r10, [rsi + r10*4]
    lea r11, [rsi + r11*4]
%endmacro
%macro M2s_d40 0
M2s_a259
    imul rax, [rdi + G_ys], 2
    add rax, rcx
    call [rbp + 328]
%endmacro
%macro M2s_d41 0
M2s_a25b
    imul rax, rax, 12
    add rbx, rax
    mov rsi, [rdi + G_sp]
%endmacro
%macro M2s_d42 0
    add rbx, rax
    mov rsi, [rdi + G_sp]
    shl rsi, 2
    add rsi, rbx
%endmacro
%macro M2s_d43 0
    vfmadd231ps ymm1, ymm13, [r9 + rdx*8]
    vfmadd231ps ymm2, ymm13, [r9 + rdx*8 + 32]
    vfmadd231ps ymm1, ymm14, [r10 + rdx*8]
    vfmadd231ps ymm2, ymm14, [r10 + rdx*8 + 32]
%endmacro
%macro M2s_d44 0
M2s_e2
%endmacro
%macro M2s_d45 0
    prefetcht0 [rax + 1472]
.pf23:
    prefetcht0 [rax + 1408]
.pf22:
%endmacro
%macro M2s_d46 0
    prefetcht0 [rax + 1344]
.pf21:
    prefetcht0 [rax + 1280]
.pf20:
    prefetcht0 [rax + 1216]
.pf19:
    prefetcht0 [rax + 1152]
.pf18:
%endmacro
%macro M2s_d47 0
.pf16:
    prefetcht0 [rax + 960]
.pf15:
    prefetcht0 [rax + 896]
%endmacro
%macro M2s_d48 0
    mov rdi, [rbp + 8]
M2s_e2
    imul rax, rax, 12
    add rbx, rax
    mov r13, [rbp + 64]
%endmacro
%macro M2s_d49 0
    vmovups ymm15, [rbp+1152]
    vmovups ymm14, [rbp+1184]
    vmovups ymm13, [rbp+1216]
    vmovups ymm12, [rbp+1248]
%endmacro
%macro M2s_d4a 0
    inc rcx
    mov [rbp + 344], rcx
    mov rax, rcx
    shl rax, 5
%endmacro
%macro M2s_d4b 0
    mov r9d, [rax + Rc_co]
    mov r10d, [rax + Rc_co + 4]
    mov r11d, [rax + Rc_co + 8]
    mov r12d, [rax + Rc_co + 12]
%endmacro
%macro M2s_d4c 0
    vmovups ymm12, [rbp+1248]
    vmovups ymm11, [c_xrcr]
    vmovups ymm10, [c_xgcr]
    vmovups ymm9, [c_xgcb]
%endmacro
%macro M2s_d4d 0
    vpmovzxwd ymm3, [rcx+rdx*2+16]
    vmovaps [r8+32], ymm2
    vmulps ymm0, ymm15, [r9+rdx*8+64]
    vmovaps [r8], ymm4
%endmacro
%macro M2s_d4e 0
    vmovups ymm11, [c_xrcr]
    vmovups ymm10, [c_xgcr]
    vmovups ymm9, [c_xgcb]
    vmovups ymm8, [c_xbcb]
%endmacro
%macro M2s_d4f 0
    vmovups ymm8, [c_xbcb]
    vmovups ymm7, [c_n64]
    vmovups ymm6, [c_absm]
    vmovups ymm5, [c_xflr]
%endmacro
%macro M2s_d50 0
    vpmovzxwd ymm0, [rcx+rdx*2]
    vmulps ymm1, ymm15, [r9+rdx*8]
    vmulps ymm2, ymm15, [r9+rdx*8+32]
    vfmadd231ps ymm1, ymm14, [r10+rdx*8]
%endmacro
%macro M2s_d51 0
M2s_e3
%endmacro
%macro M2s_d52 0
M2s_a291
    jbe .fq0
.fq0r:
    cmp rdx, r13
    jae .fq0e
    vmovups ymm15, [rbp+1152]
    vmovups ymm14, [rbp+1184]
    vmovups ymm13, [rbp+1216]
%endmacro
%macro M2s_d53 0
.fq0s:
    vpmovzxwd ymm0, [rcx+rdx*2]
    vmulps ymm1, ymm15, [r9+rdx*8]
    vmulps ymm2, ymm15, [r9+rdx*8+32]
%endmacro
%macro M2s_d54 0
    vpaddd ymm3, ymm0, ymm7
    vfmadd231ps ymm2, ymm14, [r10+rdx*8+32]
M2s_e3
    vfmadd231ps ymm2, ymm12, [r12+rdx*8+32]
    vmovaps ymm0, ymm4
%endmacro
%macro M2s_d55 0
    vmovups ymm0, [rbx+rdx*4]
    vmovups ymm1, [rbx+rdx*4+32]
    vandps ymm2, ymm0, ymm15
    vandps ymm3, ymm1, ymm15
    vxorps ymm4, ymm0, ymm2
    vpmaxud ymm5, ymm2, [c_xflr]
    vxorps ymm6, ymm1, ymm3
    vpmaxud ymm7, ymm3, [c_xflr]
%endmacro
%macro M2s_d56 0
    vpmaddwd ymm10, ymm8, [c_k5]
    vpslld ymm11, ymm8, 23
    vpermps ymm12, ymm9, [c_w8e]
    vpsrld ymm13, ymm7, 23
%endmacro
%macro M2s_d57 0
    jae .fp0e
M2s_a29e
.fp0s:
M2s_a2a1
%endmacro
%macro M2s_d58 0
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xflr]
    vmovups ymm13, [c_k5]
    vmovups ymm12, [c_mone]
%endmacro
%macro M2s_d59 0
    vmovups ymm14, [c_xflr]
    vmovups ymm13, [c_k5]
    vmovups ymm12, [c_mone]
    vmovups ymm11, [c_q8e3]
%endmacro
%macro M2s_d5a 0
    lea r15, [r13 - 16]
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xflr]
    vmovups ymm13, [c_k5]
%endmacro
%macro M2s_d5b 0
    vfmadd213ps ymm7, ymm10, ymm12
    vpslld ymm2, ymm8, 23
    vpermps ymm10, ymm3, [c_w8e]
    vpermps ymm8, ymm3, [c_rxe]
%endmacro
%macro M2s_d5c 0
    vpsubd ymm0, ymm8, ymm2
    vfmadd213ps ymm4, ymm0, ymm12
    vmulps ymm7, ymm1, ymm5
    vpaddd ymm8, ymm11, ymm6
%endmacro
%macro M2s_d5d 0
    vmulps ymm7, ymm1, ymm2
    vpsrld ymm8, ymm6, 23
    vpsrld ymm9, ymm6, 20
    vpmaddwd ymm10, ymm8, ymm13
%endmacro
%macro M2s_d5e 0
    vmovups ymm1, [r8+384]
    vmulps ymm6, ymm10, ymm0
    vpsubd ymm10, ymm11, ymm5
    vmovaps [rsi+rdx*4], ymm2
    vaddps ymm0, ymm2, [rcx+rdx*4]
    vpmaddwd ymm11, ymm8, ymm13
    vmovups ymm5, [r8+416]
    vfmadd213ps ymm7, ymm10, ymm12
%endmacro
%macro M2s_d5f 0
    vmovaps [rdi+rdx*4], ymm0
    vmovups ymm3, [c_q8e2]
    vmovaps [r8+224], ymm6
    vpsrld ymm0, ymm11, 14
%endmacro
%macro M2s_d60 0
    vmovaps [r8+192], ymm7
    vpsubd ymm0, ymm8, ymm2
    vfmadd213ps ymm4, ymm0, ymm12
    vmulps ymm7, ymm1, ymm5
%endmacro
%macro M2s_d61 0
    vminps ymm2, ymm6, ymm5
    vmulps ymm6, ymm3, ymm4
    vaddps ymm5, ymm2, [r10+rdx*4]
    vfmadd213ps ymm0, ymm3, ymm8
    vmovaps [r11+rdx*4], ymm5
    vfmadd231ps ymm4, ymm6, ymm0
    vaddps ymm2, ymm4, [rcx+rdx*4+32]
    vminps ymm3, ymm4, [u_zero]
%endmacro
%macro M2s_d62 0
    vmovaps [rdi+rdx*4+32], ymm2
    vminps ymm5, ymm1, ymm3
    vaddps ymm6, ymm5, [r10+rdx*4+32]
    vmovaps [r11+rdx*4+32], ymm6
%endmacro
%macro M2s_d63 0
.fp3r:
    cmp rdx, r13
    jae .fp3e
    vmovups ymm15, [c_absm]
%endmacro
%macro M2s_d64 0
    vmulps ymm2, ymm0, ymm1
    vfmadd231ps ymm1, ymm2, ymm3
    vaddps ymm0, ymm1, [rcx+rdx*4]
    vminps ymm2, ymm1, [u_zero]
%endmacro
%macro M2s_d65 0
    vmovups ymm0, [r8+192]
    vmovups ymm1, [r8+224]
    vmovups ymm2, [rbx+rdx*4]
    vmovaps ymm3, ymm10
%endmacro
%macro M2s_d66 0
M2s_d67
    vpsrld ymm2, ymm1, 23
    vpmaddwd ymm3, ymm2, ymm13
    vpslld ymm2, ymm2, 23
    vpsrld ymm4, ymm3, 14
%endmacro
%macro M2s_d67 0
    vmovups ymm0, [rsi + rdx*4]
    vandps ymm1, ymm0, ymm15
    vxorps ymm0, ymm0, ymm1
    vpmaxud ymm1, ymm1, ymm14
%endmacro
%macro M2s_d68 0
    vandps ymm1, ymm0, ymm15
    vxorps ymm0, ymm0, ymm1
    vpmaxud ymm1, ymm1, ymm14
    vpsrld ymm2, ymm1, 23
%endmacro
%macro M2s_d69 0
    vpmaxud ymm1, ymm1, ymm14
    vpsrld ymm2, ymm1, 23
    vpmaddwd ymm3, ymm2, ymm13
    vpslld ymm2, ymm2, 23
%endmacro
%macro M2s_d6a 0
    vpsrld ymm4, ymm3, 14
M2s_c1de
    vpsrld ymm4, ymm1, 20
    vpermps ymm5, ymm4, [c_w8e]
%endmacro
%macro M2s_d6b 0
    vpsubd ymm4, ymm4, ymm2
    vfmadd213ps ymm4, ymm1, ymm12
    vmovaps ymm5, ymm11
    vfmadd213ps ymm5, ymm4, ymm10
%endmacro
%macro M2s_d6c 0
    vmovups ymm0, [rcx + rdx*4]
    vfmadd231ps ymm0, ymm5, ymm6
    vmovups [rdi + rdx*4], ymm0
    vmovups ymm0, [r9 + rdx*4]
%endmacro
%macro M2s_d6d 0
    imul rax, rax, 1
    add r8, rax
    mov rax, [rbp + 200]
    imul rax, rax, 1
    add r9, rax
    xor edx, edx
.ls1:
    vmovups ymm0, [rsi + rdx*4]
%endmacro
%macro M2s_d6e 0
    mov rax, [rbp + 144]
    imul rax, rax, 3
    add r10, rax
    mov rax, [rbp + 160]
    imul rax, rax, 3
    add r11, rax
    mov r14, [rbp + 176]
    mov r15, [rbp + 192]
%endmacro
%macro M2s_d6f 0
    mov rax, [rbp + 184]
    imul rax, rax, 3
    add r14, rax
    mov rax, [rbp + 200]
%endmacro
%macro M2s_d70 0
.ls2:
    vmovups ymm0, [rsi + rdx*4]
    vandps ymm1, ymm0, ymm15
    vxorps ymm0, ymm0, ymm1
%endmacro
%macro M2s_d71 0
    mov rax, [rbp + 72]
    cmp rax, [rbp + 344]
    je .rqz
    call .fr
.rqz:
    mov rdi, [rbp + 8]
    mov rbx, [rdi + G_xb]
    mov eax, [rbp + 72]
%endmacro
%macro M2s_d72 0
    cmp rcx, [rbp + 352]
    jae .zu
    inc rcx
    mov [rbp + 344], rcx
%endmacro
%macro M2s_d73 0
    vxorps ymm2, ymm1, ymm9
    vpmaxud ymm3, ymm9, ymm14
    vpsrld ymm5, ymm3, 23
    vpsrld ymm8, ymm3, 20
%endmacro
%macro M2s_d74 0
    vpmaddwd ymm6, ymm5, ymm13
    vpslld ymm1, ymm5, 23
    vpermps ymm9, ymm8, [c_w8e]
    vpermps ymm5, ymm8, [c_rxe]
%endmacro
%macro M2s_d75 0
    add rdi, rax
    mov r11, [rbp + 136]
    mov rax, [rbp + 144]
    imul rax, rax, 3
    add r11, rax
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
%endmacro
%macro M2s_d76 0
    jb .zp3r
    lea r15, [r13 - 16]
    vmovups ymm15, [c_absm]
    vmovups ymm14, [c_xflr]
%endmacro
%macro M2s_d77 0
    vmovups ymm6, [c_p8]
    vmovups ymm5, [c_w8e]
.zp3s:
    vmovups ymm0, [r8+192]
%endmacro
%macro M2s_d78 0
M2s_e4
%endmacro
%macro M2s_d79 0
    vcmppd ymm4, ymm3, ymm2, 0x1e
    vaddpd ymm5, ymm1, ymm2
    vblendvpd ymm5, ymm5, ymm1, ymm4
    vpsrlq ymm7, ymm5, 48
%endmacro
%macro M2s_d7a 0
    vpsrlq ymm7, ymm5, 48
    vpand ymm8, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [rax + ymm8*8 + u_rx - u_rx], ymm9
%endmacro
%macro M2s_d7b 0
    vpand ymm8, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [rax + ymm8*8 + u_rx - u_rx], ymm9
    vandpd ymm11, ymm5, [u_mant]
%endmacro
%macro M2s_d7c 0
    vandpd ymm11, ymm5, [u_mant]
    vorpd ymm11, ymm11, [u_oneb]
    vfmsub213pd ymm11, ymm10, [u_one]
    vpcmpeqq ymm9, ymm9, ymm9
%endmacro
%macro M2s_d7d 0
M2s_e5
%endmacro
%macro M2s_d7e 0
    vcvtps2pd ymm0, [rdi]
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
%endmacro
%macro M2s_d7f 0
    vblendvpd ymm8, ymm8, ymm11, ymm0
M2s_d80
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_drg + 32]
%endmacro
%macro M2s_d80 0
    vfmadd231pd ymm13, ymm9, [r15 + G_dmx + 0]
    vfmadd231pd ymm14, ymm8, [r15 + G_dmx + 0]
    vcvtps2pd ymm0, [rdi + 65536]
    lea rax, [u_rx]
%endmacro
%macro M2s_d81 0
    vfmadd231pd ymm13, ymm9, [r15 + G_dmx + 32]
    vfmadd231pd ymm14, ymm8, [r15 + G_dmx + 32]
    vcvtps2pd ymm0, [rdi + 131072]
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_drg + 64]
    vsubpd ymm3, ymm1, ymm2
%endmacro
%macro M2s_d82 0
.t1c:
    vcvtps2pd ymm0, [rdi + 49152]
M2s_e5
    vdivpd ymm2, ymm3, ymm2
    vmovapd ymm15, [r15 + G_esn]
%endmacro
%macro M2s_d83 0
    vfmadd213pd ymm15, ymm2, [r15 + G_ean]
    vfmadd213pd ymm15, ymm1, [r15 + G_eta]
    vcvtps2pd ymm0, [rdi]
    lea rax, [u_rx]
%endmacro
%macro M2s_d84 0
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_erg + 32]
M2s_e4
%endmacro
%macro M2s_d85 0
    imul r13, r8
    imul r14, r8
    imul r15, r10
    imul rsi, r10
%endmacro
%macro M2s_d86 0
    lea rdx, [rax + r9]
    mov rbx, [r12 + 1248]
    cmp rdx, rbx
M2s_d87
    cmovb rcx, rbx
%endmacro
%macro M2s_d87 0
    cmova rdx, rbx
    mov rbx, [r12 + 1240]
    mov rcx, rax
    cmp rcx, rbx
%endmacro
%macro M2s_d88 0
    lea rcx, [rax + r9]
    cmp rcx, r8
    cmova rcx, r8
    sub rcx, rax
%endmacro
%macro M2s_d89 0
    movzx eax, word [rcx + r14*2]
    vcvtsi2sd xmm0, xmm0, eax
    vmovsd [r12 + 384 + rsi*8], xmm0
    mov rax, r14
%endmacro
%macro M2s_d8a 0
    vcvtsi2sd xmm0, xmm0, eax
    vmovsd [r12 + 384 + rsi*8], xmm0
    mov rax, r14
    shr rax, 3
%endmacro
%macro M2s_d8b 0
M2s_e6
%endmacro
%macro M2s_d8c 0
    vpsrlq ymm8, ymm6, 48
    vpand ymm8, ymm8, [u_i15]
    vpand ymm9, ymm7, [u_i15]
    vpcmpeqq ymm11, ymm11, ymm11
%endmacro
%macro M2s_d8d 0
    vpcmpeqq ymm9, ymm9, ymm11
    vmulpd ymm11, ymm10, [u_tsk]
    vblendvpd ymm10, ymm10, ymm11, ymm9
    vpcmpeqq ymm9, ymm9, ymm9
%endmacro
%macro M2s_d8e 0
    vmaxpd ymm6, ymm6, [u_xflr]
    vpsrlq ymm7, ymm6, 52
    vpsrlq ymm8, ymm6, 48
    vpand ymm8, ymm8, [u_i15]
%endmacro
%macro M2s_d8f 0
    vpand ymm9, ymm7, [u_i16]
    vpxor ymm11, ymm11, ymm11
    vpcmpeqq ymm9, ymm9, ymm11
    vmulpd ymm11, ymm10, [u_tsk]
%endmacro
%macro M2s_d90 0
    vextractf128 xmm11, ymm14, 1
    vhaddpd xmm14, xmm14, xmm11
    vpermilpd xmm11, xmm14, 1
    vaddsd xmm14, xmm14, xmm11
%endmacro
%macro M2s_d91 0
.t3j:
    mov rax, r14
    imul rax, r9
    cmp rax, [r12 + 1248]
    jae .t3n
    lea rdx, [rax + r9]
    mov rbx, [r12 + 1248]
    cmp rdx, rbx
%endmacro
%macro M2s_d92 0
    jb .t3x
    push r14
    call .t3b
M2s_e6
    mov r9, [rdi + G_wo]
%endmacro
%macro M2s_d93 0
    add r9, r9
    mov r11, [rdi + G_ho]
.t3x:
    inc r14
%endmacro
%macro M2s_d94 0
.t3f:
    mov rsi, [r12 + 1288]
    test rsi, rsi
    jz .t3e
%endmacro
%macro M2s_d95 0
    cmp qword [r12 + 1216], 0
    jne .t3q
    vbroadcastsd ymm2, [rdi + G_dnl]
    vbroadcastsd ymm3, [rdi + G_dnl + 8]
%endmacro
%macro M2s_d96 0
    vmovsd xmm0, [r12 + 1152]
    vmovsd xmm1, [r12 + 1184]
    vmovsd xmm2, [r12 + 1160]
    vmovsd xmm3, [r12 + 1192]
%endmacro
%macro M2s_d97 0
    vmovsd xmm5, [r12 + 1200]
    vmovsd xmm6, [u_kr]
    vmovsd xmm7, [u_kr + 8]
    vmulsd xmm8, xmm6, xmm0
%endmacro
%macro M2s_d98 0
    vfmsub231sd xmm8, xmm7, xmm2
    vmulsd xmm12, xmm6, xmm2
    vfmadd231sd xmm12, xmm7, xmm3
    vaddsd xmm8, xmm8, xmm12
%endmacro
%macro M2s_d99 0
    vandpd xmm5, xmm5, [u_one]
    vcmpsd xmm1, xmm9, [u_mhalf], 0x11
    vandpd xmm1, xmm1, [u_one]
    vaddsd xmm0, xmm0, xmm5
    vsubsd xmm0, xmm0, xmm1
    vcvttsd2si eax, xmm0
M2s_a38a
    cmp eax, ecx
%endmacro
%macro M2s_d9a 0
    cmovg eax, ecx
    ret
.t3h:
    vmovsd xmm0, [r12 + 1152]
%endmacro
%macro M2s_d9b 0
    xor ecx, ecx
    test eax, eax
    cmovs eax, ecx
    mov ecx, 1023
%endmacro
%macro M2s_d9c 0
    vxorpd xmm3, xmm6, [u_mzero]
    vxorpd xmm2, xmm10, [u_mzero]
    vaddsd xmm10, xmm4, xmm3
    vsubsd xmm6, xmm10, xmm4
    vsubsd xmm7, xmm10, xmm6
    vsubsd xmm7, xmm4, xmm7
    vsubsd xmm6, xmm3, xmm6
    vaddsd xmm7, xmm7, xmm6
%endmacro
%macro M2s_d9d 0
    vaddsd xmm6, xmm5, xmm2
    vsubsd xmm9, xmm6, xmm5
    vsubsd xmm8, xmm6, xmm9
    vsubsd xmm8, xmm5, xmm8
%endmacro
%macro M2s_d9e 0
    vsubsd xmm7, xmm6, xmm10
    vsubsd xmm7, xmm9, xmm7
    vaddsd xmm9, xmm7, xmm8
    vaddsd xmm8, xmm6, xmm9
%endmacro
%macro M2s_d9f 0
    vsubsd xmm13, xmm14, xmm13
    vxorpd xmm7, xmm7, xmm7
    vmovsd xmm8, [u_512]
    vaddsd xmm6, xmm11, xmm8
%endmacro
%macro M2s_da0 0
    vsubsd xmm9, xmm1, xmm9
    vsubsd xmm10, xmm2, xmm10
    vaddsd xmm9, xmm9, xmm10
    vaddsd xmm10, xmm11, xmm13
    vaddsd xmm13, xmm8, xmm10
    vsubsd xmm11, xmm13, xmm8
    vsubsd xmm11, xmm10, xmm11
    vaddsd xmm10, xmm11, xmm9
%endmacro
%macro M2s_da1 0
    vaddsd xmm9, xmm13, xmm10
    vsubsd xmm11, xmm9, xmm13
    vsubsd xmm11, xmm10, xmm11
    vmovsd xmm2, [u_crs]
%endmacro
%macro M2s_da2 0
    vmulsd xmm8, xmm3, xmm9
    vfmadd231sd xmm8, xmm2, xmm11
    vaddsd xmm13, xmm13, xmm8
    vaddsd xmm8, xmm10, xmm13
%endmacro
%macro M2s_da3 0
    vsubsd xmm10, xmm6, xmm10
    vsubsd xmm13, xmm7, xmm13
    vaddsd xmm10, xmm10, xmm13
    vaddsd xmm13, xmm2, xmm3
%endmacro
%macro M2s_da4 0
    vaddsd xmm9, xmm3, xmm15
    vaddsd xmm15, xmm13, xmm9
    vcmpsd xmm6, xmm15, [u_half], 0x1e
    vandpd xmm6, xmm6, [u_one]
    vcmpsd xmm11, xmm15, [u_mhalf], 0x11
    vandpd xmm11, xmm11, [u_one]
    vaddsd xmm7, xmm7, xmm6
    vsubsd xmm7, xmm7, xmm11
%endmacro
%macro M2s_da5 0
    vcvttsd2si eax, xmm7
    xor ecx, ecx
    test eax, eax
    cmovs eax, ecx
%endmacro
%macro M2s_da6 0
    vmovsd xmm0, [r12 + 1280]
    vmovsd xmm1, [r12 + 1288]
    vroundsd xmm2, xmm0, xmm0, 8
    vsubsd xmm3, xmm0, xmm2
%endmacro
%macro M2s_da7 0
    vaddsd xmm9, xmm9, xmm8
    vaddsd xmm8, xmm7, xmm6
    vaddsd xmm6, xmm5, xmm8
    vsubsd xmm7, xmm6, xmm5
%endmacro
%macro M2s_da8 0
    vfmsub231pd ymm7, ymm1, ymm4
    vmulpd ymm8, ymm0, ymm4
    vfmadd231pd ymm8, ymm1, ymm5
    vaddpd ymm7, ymm7, ymm8
    vaddpd ymm8, ymm6, ymm7
    vsubpd ymm9, ymm8, ymm6
    vsubpd ymm9, ymm7, ymm9
    vbroadcastsd ymm1, [u_yof]
%endmacro
%macro M2s_da9 0
    vbroadcastsd ymm5, [u_yof + 8]
    vaddpd ymm4, ymm8, ymm1
    vsubpd ymm7, ymm4, ymm8
    vsubpd ymm6, ymm4, ymm7
%endmacro
%macro M2s_daa 0
    vsubpd ymm10, ymm7, ymm9
    vsubpd ymm11, ymm7, ymm10
    vsubpd ymm11, ymm9, ymm11
    vsubpd ymm10, ymm5, ymm10
%endmacro
%macro M2s_dab 0
    vmovapd ymm8, ymm9
    vfmsub231pd ymm8, ymm5, ymm3
    vmulpd ymm10, ymm1, ymm3
    vfmadd231pd ymm10, ymm5, ymm0
%endmacro
%macro M2s_dac 0
    vmulpd ymm7, ymm8, ymm3
    vmovapd ymm10, ymm7
    vfmsub231pd ymm10, ymm8, ymm3
    vmulpd ymm9, ymm4, ymm3
    vfmadd231pd ymm9, ymm8, ymm0
    vaddpd ymm10, ymm10, ymm9
    vaddpd ymm9, ymm7, ymm10
    vsubpd ymm5, ymm9, ymm7
%endmacro
%macro M2s_dad 0
    vsubpd ymm5, ymm10, ymm5
    vaddpd ymm4, ymm11, ymm9
    vsubpd ymm8, ymm4, ymm11
    vsubpd ymm10, ymm4, ymm8
%endmacro
%macro M2s_dae 0
    vsubpd ymm7, ymm8, ymm6
    vsubpd ymm1, ymm8, ymm7
    vsubpd ymm1, ymm6, ymm1
    vsubpd ymm7, ymm5, ymm7
%endmacro
%macro M2s_daf 0
    vmovapd ymm7, ymm9
    vfmsub231pd ymm7, ymm3, ymm2
    vmulpd ymm8, ymm5, ymm2
    vfmadd231pd ymm8, ymm3, ymm0
%endmacro
%macro M2s_db0 0
    vmulpd ymm10, ymm7, ymm2
    vmovapd ymm1, ymm10
    vfmsub231pd ymm1, ymm7, ymm2
    vmulpd ymm4, ymm12, ymm2
    vfmadd231pd ymm4, ymm7, ymm0
    vaddpd ymm1, ymm1, ymm4
    vaddpd ymm4, ymm10, ymm1
    vsubpd ymm8, ymm4, ymm10
%endmacro
%macro M2s_db1 0
    vsubpd ymm8, ymm1, ymm8
    vaddpd ymm12, ymm11, ymm4
    vsubpd ymm7, ymm12, ymm11
    vsubpd ymm1, ymm12, ymm7
%endmacro
%macro M2s_db2 0
    vsubpd ymm10, ymm7, ymm6
    vsubpd ymm9, ymm7, ymm10
    vsubpd ymm9, ymm6, ymm9
    vsubpd ymm10, ymm8, ymm10
%endmacro
%macro M2s_db3 0
    vmovapd ymm15, [r12 + 736]
    call .xeo
    vmovapd [r12 + 896], ymm14
    vmovapd [r12 + 928], ymm15
%endmacro
%macro M2s_db4 0
    vmovsd xmm9, [r12 + 904]
    vmovsd xmm8, [r12 + 936]
M2s_a3b5
M2s_a3b6
%endmacro
%macro M2s_db5 0
    vmovsd xmm3, [r12 + 496]
    vxorpd xmm7, xmm7, xmm7
    vmulsd xmm9, xmm6, xmm3
    vmovapd xmm1, xmm9
%endmacro
%macro M2s_db6 0
    vxorpd xmm7, xmm7, xmm7
    vmulsd xmm9, xmm6, xmm3
    vmovapd xmm1, xmm9
    vfmsub231sd xmm1, xmm6, xmm3
%endmacro
%macro M2s_db7 0
M2s_e7
    vfmsub231sd xmm4, xmm9, xmm1
    vmulsd xmm5, xmm8, xmm1
    vfmadd231sd xmm5, xmm9, xmm0
    vaddsd xmm4, xmm4, xmm5
%endmacro
%macro M2s_db8 0
    vfmadd231sd xmm5, xmm9, xmm0
    vaddsd xmm4, xmm4, xmm5
M2s_db9
    vsubsd xmm1, xmm0, xmm7
    vsubsd xmm8, xmm0, xmm1
%endmacro
%macro M2s_db9 0
    vaddsd xmm5, xmm2, xmm4
    vsubsd xmm6, xmm5, xmm2
    vsubsd xmm6, xmm4, xmm6
    vaddsd xmm0, xmm7, xmm5
%endmacro
%macro M2s_dba 0
    vaddsd xmm8, xmm8, xmm1
    vaddsd xmm1, xmm3, xmm6
    vsubsd xmm9, xmm1, xmm3
    vsubsd xmm4, xmm1, xmm9
%endmacro
%macro M2s_dbb 0
    vaddsd xmm1, xmm0, xmm9
    vsubsd xmm8, xmm1, xmm0
    vsubsd xmm8, xmm9, xmm8
    vaddsd xmm9, xmm8, xmm4
%endmacro
%macro M2s_dbc 0
M2s_a3bd
M2s_a3be
    vaddsd xmm1, xmm3, xmm6
    vsubsd xmm5, xmm1, xmm3
%endmacro
%macro M2s_dbd 0
    vaddsd xmm5, xmm5, xmm3
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm6, xmm3, xmm8
    vsubsd xmm1, xmm3, xmm6
%endmacro
%macro M2s_dbe 0
M2s_e8
    vfmsub231sd xmm3, xmm2, xmm8
    vmulsd xmm7, xmm0, xmm8
    vfmadd231sd xmm7, xmm2, xmm4
    vaddsd xmm3, xmm3, xmm7
%endmacro
%macro M2s_dbf 0
    vfmadd231sd xmm7, xmm2, xmm4
    vaddsd xmm3, xmm3, xmm7
M2s_dc0
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm0, xmm4, xmm8
%endmacro
%macro M2s_dc0 0
    vaddsd xmm7, xmm6, xmm3
    vsubsd xmm9, xmm7, xmm6
    vsubsd xmm9, xmm3, xmm9
    vaddsd xmm4, xmm1, xmm7
%endmacro
%macro M2s_dc1 0
    vaddsd xmm0, xmm0, xmm8
    vaddsd xmm8, xmm5, xmm9
    vsubsd xmm2, xmm8, xmm5
    vsubsd xmm3, xmm8, xmm2
%endmacro
%macro M2s_dc2 0
    vaddsd xmm8, xmm4, xmm2
    vsubsd xmm0, xmm8, xmm4
    vsubsd xmm0, xmm2, xmm0
    vaddsd xmm2, xmm0, xmm3
%endmacro
%macro M2s_dc3 0
    vmovsd xmm9, [r12 + 968]
    vmovsd xmm8, [r12 + 1000]
M2s_e7
    vfmsub231sd xmm4, xmm9, xmm1
    vmulsd xmm5, xmm8, xmm1
%endmacro
%macro M2s_dc4 0
    vaddsd xmm4, xmm4, xmm9
    vaddsd xmm9, xmm8, xmm1
    vaddsd xmm1, xmm0, xmm9
    vsubsd xmm8, xmm1, xmm0
%endmacro
%macro M2s_dc5 0
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [r12 + 976]
    vmovsd xmm5, [r12 + 1008]
    vmovsd xmm3, [r12 + 496]
%endmacro
%macro M2s_dc6 0
    vmovsd xmm2, [r12 + 984]
    vmovsd xmm0, [r12 + 1016]
M2s_e8
    vfmsub231sd xmm3, xmm2, xmm8
    vmulsd xmm7, xmm0, xmm8
%endmacro
%macro M2s_dc7 0
    vaddsd xmm3, xmm3, xmm2
    vaddsd xmm2, xmm0, xmm8
    vaddsd xmm8, xmm4, xmm2
    vsubsd xmm0, xmm8, xmm4
%endmacro
%macro M2s_dc8 0
    vsubsd xmm0, xmm2, xmm0
    vmovsd [r12 + 1096], xmm3
    vmovsd [r12 + 1128], xmm0
    vmovsd xmm0, [r12 + 1104]
%endmacro
%macro M2s_dc9 0
    vmovsd xmm9, [r12 + 1032]
    vmovsd xmm8, [r12 + 1064]
M2s_e7
    vfmsub231sd xmm4, xmm9, xmm1
    vmulsd xmm5, xmm8, xmm1
%endmacro
%macro M2s_dca 0
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [r12 + 1040]
    vmovsd xmm5, [r12 + 1072]
    vmovsd xmm3, [r12 + 496]
%endmacro
%macro M2s_dcb 0
    vmovsd xmm2, [r12 + 1048]
    vmovsd xmm0, [r12 + 1080]
M2s_e8
    vfmsub231sd xmm3, xmm2, xmm8
    vmulsd xmm7, xmm0, xmm8
%endmacro
%macro M2s_dcc 0
    vsubsd xmm0, xmm2, xmm0
    vmovsd [r12 + 1104], xmm3
    vmovsd [r12 + 1136], xmm0
    ret
%endmacro
%macro M2s_dcd 0
    vsubpd ymm5, ymm3, ymm5
    vaddpd ymm4, ymm4, ymm5
    vaddpd ymm5, ymm1, ymm6
    vaddpd ymm6, ymm7, ymm5
    vsubpd ymm1, ymm6, ymm7
    vsubpd ymm1, ymm5, ymm1
    vaddpd ymm5, ymm1, ymm4
    vaddpd ymm4, ymm6, ymm5
%endmacro
%macro M2s_dce 0
    vsubpd ymm1, ymm4, ymm6
    vsubpd ymm1, ymm5, ymm1
    vbroadcastsd ymm3, [u_i1024]
    vmulpd ymm2, ymm4, ymm3
%endmacro
%macro M2s_dcf 0
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm2, ymm5
    vsubpd ymm7, ymm6, ymm2
    vsubpd ymm7, ymm5, ymm7
%endmacro
%macro M2s_dd0 0
    vmulpd ymm1, ymm6, [r12 + 128]
    vmovapd ymm4, ymm1
    vfmsub231pd ymm4, ymm6, [r12 + 128]
    vmulpd ymm3, ymm7, [r12 + 128]
%endmacro
%macro M2s_dd1 0
    vaddpd ymm11, ymm11, ymm10
    vaddpd ymm10, ymm1, ymm2
    vaddpd ymm2, ymm4, ymm10
    vsubpd ymm1, ymm2, ymm4
    vsubpd ymm1, ymm10, ymm1
    vaddpd ymm10, ymm1, ymm11
    vaddpd ymm11, ymm2, ymm10
    vsubpd ymm1, ymm11, ymm2
%endmacro
%macro M2s_dd2 0
    vsubpd ymm1, ymm10, ymm1
    vdivpd ymm5, ymm11, ymm7
    vxorpd ymm3, ymm5, [u_mzero]
    vmulpd ymm9, ymm7, ymm3
%endmacro
%macro M2s_dd3 0
    vaddpd ymm8, ymm8, ymm10
    vaddpd ymm10, ymm9, ymm8
    vsubpd ymm2, ymm10, ymm9
    vsubpd ymm2, ymm8, ymm2
%endmacro
%macro M2s_dd4 0
    vaddpd ymm4, ymm9, ymm8
    vaddpd ymm8, ymm3, ymm4
    vsubpd ymm9, ymm8, ymm3
    vsubpd ymm9, ymm4, ymm9
%endmacro
%macro M2s_dd5 0
    vmovapd ymm7, [r12 + 192]
    vmovapd ymm1, [r12 + 192 + 32]
    vaddpd ymm11, ymm7, ymm4
    vsubpd ymm12, ymm11, ymm7
    vsubpd ymm10, ymm11, ymm12
    vsubpd ymm10, ymm7, ymm10
    vsubpd ymm12, ymm4, ymm12
    vaddpd ymm10, ymm10, ymm12
%endmacro
%macro M2s_dd6 0
    vaddpd ymm12, ymm1, ymm2
    vsubpd ymm6, ymm12, ymm1
    vsubpd ymm5, ymm12, ymm6
    vsubpd ymm5, ymm1, ymm5
%endmacro
%macro M2s_dd7 0
    vsubpd ymm10, ymm12, ymm11
    vsubpd ymm10, ymm6, ymm10
    vaddpd ymm6, ymm10, ymm5
    vaddpd ymm5, ymm12, ymm6
%endmacro
%macro M2s_dd8 0
    vmulpd ymm2, ymm10, ymm10
    vmovapd ymm4, ymm2
    vfmsub231pd ymm4, ymm10, ymm10
    vmulpd ymm1, ymm5, ymm10
%endmacro
%macro M2s_dd9 0
    fld qword [r12 + 0 + 16]
    fyl2x
    fstp qword [r12 + 0 + 16]
    fldln2
    fld qword [r12 + 0 + 24]
    fyl2x
    fstp qword [r12 + 0 + 24]
    vmovapd ymm14, [r12 + 0]
%endmacro
%macro M2s_dda 0
    vxorpd ymm14, ymm14, [u_mzero]
    vxorpd ymm15, ymm15, ymm15
    call .dexp
    vxorpd ymm0, ymm0, ymm0
%endmacro
%macro M2s_ddb 0
    vfmsub231pd ymm4, ymm1, ymm14
    vmulpd ymm5, ymm2, ymm14
    vfmadd231pd ymm5, ymm1, ymm15
    vaddpd ymm4, ymm4, ymm5
%endmacro
%macro M2s_ddc 0
    vsubpd ymm8, ymm3, ymm6
    vsubpd ymm9, ymm3, ymm8
    vsubpd ymm9, ymm6, ymm9
    vsubpd ymm8, ymm1, ymm8
%endmacro
%macro M2s_ddd 0
    vsubpd ymm2, ymm3, ymm1
    vsubpd ymm2, ymm8, ymm2
    vmovapd ymm14, ymm3
    vmovapd ymm15, ymm2
    ret
    .xeo:
M2s_a3e8
    vblendvpd ymm14, ymm14, ymm11, ymm12
%endmacro
%macro M2s_dde 0
    vandnpd ymm15, ymm12, ymm15
    call .dln
    vbroadcastsd ymm0, [u_e125]
    vbroadcastsd ymm1, [u_e125 + 8]
%endmacro
%macro M2s_ddf 0
    vpermps ymm1, ymm3, [r8 + 84]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 116]
%endmacro
%macro M2s_de0 0
    vmovdqu ymm3, [rdx + 320]
    vpermps ymm1, ymm3, [r13 + 104]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 352]
%endmacro
%macro M2s_de1 0
    vpermps ymm1, ymm3, [r9 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 68]
%endmacro
%macro M2s_de2 0
    vpermps ymm1, ymm3, [r9 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 108]
%endmacro
%macro M2s_de3 0
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_e1
    vpermps ymm1, ymm3, [r9 + 44]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_de4 0
    vpermps ymm1, ymm3, [r8 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 104]
%endmacro
%macro M2s_de5 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm9
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 8]
%endmacro
%macro M2s_de6 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm10
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 12]
%endmacro
%macro M2s_de7 0
    vpermps ymm1, ymm3, [r8 + 76]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r8 + 108]
%endmacro
%macro M2s_de8 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, ymm12
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 20]
%endmacro
%macro M2s_de9 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 52]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_dea 0
    vshufps ymm2, ymm4, ymm5, 0x88
    vshufps ymm5, ymm4, ymm5, 0xdd
    vmovaps ymm4, ymm2
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_deb 0
    vpermps ymm0, ymm3, [r9 + 0]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 32]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_dec 0
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, ymm9
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 8]
%endmacro
%macro M2s_ded 0
M2s_dec
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
%endmacro
%macro M2s_dee 0
    vpermps ymm1, ymm3, [r9 + 72]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 104]
%endmacro
%macro M2s_def 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 44]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 76]
%endmacro
%macro M2s_df0 0
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
%endmacro
%macro M2s_df1 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 44]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 76]
%endmacro
%macro M2s_df2 0
    vfmadd231ps ymm6, ymm0, [rcx + 320]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 44]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_df3 0
M2s_c3ea
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 56]
    vblendvps ymm0, ymm0, ymm1, ymm3
%endmacro
%macro M2s_df4 0
    vmovdqu ymm3, [rdx + 352]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 384]
%endmacro
%macro M2s_df5 0
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 268]
%endmacro
%macro M2s_df6 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 48]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 80]
%endmacro
%macro M2s_df7 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 48]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 80]
%endmacro
%macro M2s_df8 0
    vpermps ymm1, ymm3, [r9 + 80]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 112]
%endmacro
%macro M2s_df9 0
    vfmadd231ps ymm6, ymm0, [rcx + 352]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 48]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_dfa 0
    vmovdqu ymm3, [rdx + 384]
    vpermps ymm1, ymm3, [r13 + 64]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 416]
%endmacro
%macro M2s_dfb 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 52]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r8 + 84]
%endmacro
%macro M2s_dfc 0
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 52]
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm1, ymm3, [r9 + 84]
%endmacro
%macro M2s_dfd 0
    vmovdqu ymm3, [rdx + 544]
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 576]
%endmacro
%macro M2s_dfe 0
    vmovups ymm3, [rdx+32]
    vandps ymm4, ymm0, ymm15
    vfmadd231ps ymm1, ymm4, ymm13
    vandps ymm5, ymm2, ymm15
%endmacro
%macro M2s_dff 0
    vmovups ymm1, [rdx]
    vmovups ymm2, [rax+160]
    vmovups ymm3, [rdx+32]
    vandps ymm4, ymm0, ymm15
%endmacro
%macro M2s_e0 0
    vmulps ymm4, ymm0, ymm8
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r8 + 4]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_e1 0
    vfmadd231ps ymm6, ymm0, ymm10
    vmovdqu ymm3, [rdx + 0]
    vpermps ymm0, ymm3, [r9 + 12]
    vmovdqu ymm3, [rdx + 0]
%endmacro
%macro M2s_e2 0
    mov rbx, [rdi + G_xb]
    mov eax, [rbp + 72]
    and eax, 1
    imul rax, [rdi + G_sp]
%endmacro
%macro M2s_e3 0
    vcvtdq2ps ymm4, ymm3
    vfmadd231ps ymm1, ymm13, [r11+rdx*8]
    vfmadd231ps ymm2, ymm13, [r11+rdx*8+32]
    vfmadd231ps ymm1, ymm12, [r12+rdx*8]
%endmacro
%macro M2s_e4 0
    vsubpd ymm3, ymm1, ymm2
    vcmppd ymm4, ymm3, ymm2, 0x1e
    vaddpd ymm5, ymm1, ymm2
    vblendvpd ymm5, ymm5, ymm1, ymm4
%endmacro
%macro M2s_e5 0
    vmovapd ymm1, [u_epsn]
    vsubpd ymm1, ymm1, ymm0
    vsqrtpd ymm2, ymm1
    vmovapd ymm3, [u_one]
%endmacro
%macro M2s_e6 0
    pop r14
    mov qword [r12 + 1288], 0
    mov rdi, [rbp + 8]
    mov r8, [rdi + G_wi]
%endmacro
%macro M2s_e7 0
    vmovsd xmm1, [r12 + 488]
    vxorpd xmm0, xmm0, xmm0
    vmulsd xmm2, xmm9, xmm1
    vmovapd xmm4, xmm2
%endmacro
%macro M2s_e8 0
    vmovsd xmm8, [r12 + 504]
    vxorpd xmm4, xmm4, xmm4
    vmulsd xmm6, xmm2, xmm8
    vmovapd xmm3, xmm6
%endmacro
