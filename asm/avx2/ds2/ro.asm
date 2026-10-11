%include "dav1d_x86inc.asm"

SECTION_RODATA 64

const ro
    ALIGN 64
c_to: dd 0x3fd6b0c1, 0x400f49e7, 0x403f4477, 0x407f4fb8, 0x40aa6661, 0x40e374e4, 0x4117cf1f, 0x414aa40b
    dd 0x41873f1b, 0x41b4884d, 0x41f0fb5c, 0x4220d60b, 0x4256b0c1, 0x428f49e7, 0x42bf4477, 0x42ff4fb8
    dd 0x3c873f1b, 0x3cb4884d, 0x3cf0fb5c, 0x3d20d60b, 0x3d56b0c1, 0x3d8f49e7, 0x3dbf4477, 0x3dff4fb8
    dd 0x3e2a6661, 0x3e6374e4, 0x3e97cf1f, 0x3ecaa40b, 0x3f073f1b, 0x3f34884d, 0x3f70fb5c, 0x3fa0d60b
    ALIGN 32
c_w8e: dd 0x3f9488ae, 0x3fbfffaa, 0x3ff68ab1, 0x401ae8f8, 0x4039f643, 0x4063845e, 0x40841f2c, 0x409df647
c_w8o: dd 0x3f83467d, 0x3f898b8c, 0x3f8f4de9, 0x3f9498d9, 0x3f99e756, 0x3f9f2c4e, 0x3fa3b9bb, 0x3fa8fd87
c_r8o: dd 0x3f70effc, 0x3f576a31, 0x3f4337ff, 0x3f32f1e6, 0x3f247e1d, 0x3f17b994, 0x3f0dcbd5, 0x3f036c99
c_r8x: dd 0x7ef09c9a, 0x7ed83501, 0x7ec2d0b8, 0x7eb12034, 0x7ea42488, 0x7e96e9a7, 0x7e8dca50, 0x7e839ebe
c_c8e: dd 0x3681ed35, 0x37ab706d, 0, 0x38e23720, 0x3a153f18, 0, 0x3b44ee90, 0
c_p8e: dd 0xfa000000, 0, 0x06000000, 0x0c000000, 0x12000000, 0xe8000000, 0xee000000, 0xf4000000
c_pd8: dd 0, 4, 1, 5, 2, 6, 3, 7
c_s2: dd 0x40000000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000
c_ones: times 8 dd 0x3f800000
c_onesw: times 8 dd 1
c_n64w: times 16 dw -64
c_q8e0: times 8 dd 0x40199999
c_q8e1: times 8 dd 0x3fd70a3f
c_q8e2: times 8 dd 0x3e656e54
c_q8e3: times 8 dd 0xbd09fd74
c_q8o0: times 8 dd 0x3ed5554f
c_q8o1: times 8 dd 0xbdf8e37b
c_q8o2: times 8 dd 0x3d83ac9a
c_q8o3: times 8 dd 0xbd2a296f
c_eq: times 8 dd 0x3ed57359
c_ieq: times 8 dd 0x40198401
c_snegl: times 8 dd 0x375c8583
c_snegh: times 8 dd 0x37dc8583
c_k5e: times 8 dd 26215
c_xflr: times 8 dd 0x35800000
c_xlo: times 8 dd 0x38000000
c_epsf: times 8 dd 0x0da24260
c_xrcr: times 8 dd 0x3fc51331
c_xgcr: times 8 dd 0xbeea5463
c_xgcb: times 8 dd 0xbe3b89d2
c_xbcb: times 8 dd 0x3fe83710
c_kh0: times 8 dd 0xbd400000
c_kh1: times 8 dd 0x3f0c0000
c_kh2: times 8 dd 0x3cc00000
c_kh3: times 8 dd 0xbea40000
c_kh4: times 8 dd 0x3e980000
c_kh5: times 8 dd 0xbcc00000
c_h0625: times 8 dd 0x3d800000
c_h5625: times 8 dd 0x3f100000
c_one: times 8 dd 0x3f800000
c_half: times 8 dd 0x3f000000
c_rgl0: times 8 dd 0x34ceb8df
c_rgl1: times 8 dd 0x350dc2f0
c_rgl2: times 8 dd 0x34ceb8df
c_oml0: times 8 dd 0x34a3a5ba
c_oml1: times 8 dd 0x3483a5a5
c_oml2: times 8 dd 0x34c3a5cf
c_anegl: times 8 dd 0x358dc34d
c_tabsl: times 8 dd 0x2fa43252
c_mtl0: times 8 dd 0x4088a915
c_mtl1: times 8 dd 0x4165de07
c_mtl2: times 8 dd 0x3fb9a46c
c_slkl: times 8 dd 0x3786d510
c_rgh0: times 8 dd 0x35075c87
c_rgh1: times 8 dd 0x352dc308
c_rgh2: times 8 dd 0x35075c87
c_omh0: times 8 dd 0x34c3a5cf
c_omh1: times 8 dd 0x34a3a5ba
c_omh2: times 8 dd 0x34c3a5cf
c_anegh: times 8 dd 0x35adc37a
c_tabsh: times 8 dd 0x30a43252
c_mth0: times 8 dd 0x40b87fe1
c_mth1: times 8 dd 0x3fa91ba6
c_mth2: times 8 dd 0x408e38f8
c_mth3: times 8 dd 0x40b87fe1
c_mth4: times 8 dd 0x40a794fe
c_mth5: times 8 dd 0x3f07571c
c_slkh0: times 8 dd 0x37814176
c_slkh1: times 8 dd 0x37b78fd4
c_sign: times 8 dd 0x80000000
c_i64: times 8 dd 64
c_i512: times 8 dd 512
c_i1023: times 8 dd 1023
c_zero: times 8 dd 0
    ALIGN 32
u_rx: dq 0x3fef07c200000000, 0x3fed41d420000000, 0x3febacf920000000, 0x3fea41a420000000, 0x3fe8f9c180000000, 0x3fe7d05f40000000, 0x3fe6c16c20000000, 0x3fe5c98820000000, 0x3fe4e5e0a0000000, 0x3fe4141420000000, 0x3fe3521d00000000, 0x3fe29e4120000000, 0x3fe1f70480000000, 0x3fe15b1e60000000, 0x3fe0c97140000000, 0x3fe0410420000000
u_oa: dq 0x3ff0000000000000, 0x3ff55b8108f0ec5e, 0x3ffc823e074ec129, 0x400306fe0a31b715, 0x400965fea53d6e3d, 0x4010f38f92d97963, 0x4016a09e667f3bcd, 0x401e3437e7101344, 0x402428a2f98d728b, 0x402ae89f995ad3ad, 0x4031f59ac3c7d6c0, 0x4037f910d768cfb0, 0x4040000000000000, 0x40455b8108f0ec5e, 0x404c823e074ec129, 0x405306fe0a31b715
u_ob: dq 0x3ff55b8108f0ec5e, 0x3d0ae89f995ad3ad, 0x3d755b8108f0ec5e, 0x3de0f38f92d97963, 0x3e4ae89f995ad3ad, 0x3eb55b8108f0ec5e, 0x3f20f38f92d97963, 0x3f8ae89f995ad3ad
u_ow: dq 0x3ff034dae33d2513, 0x3ff09bd444ecbfc7, 0x3ff0ff6ccdf729fe, 0x3ff15fed75e356b9, 0x3ff1bd95a53cf85d, 0x3ff2189cd11a12f7, 0x3ff27133f24e1985, 0x3ff2c78674186ae1, 0x3ff31bbaed16c926, 0x3ff36df401e38c70, 0x3ff3be50ec4f2493, 0x3ff40cedcd83f513, 0x3ff459e41f1dd6e4, 0x3ff4a54b31dd20b6, 0x3ff4ef3841597f2a, 0x3ff537be9ed40652
u_tsl: dq 0x3dd51cb453b9536c, 0x3dfbdb8cdadbe120, 0x3e22611186bae675, 0x3e48406003b2ae5c, 0x3e70000000000000, 0x3e951cb453b9536c, 0x3ebbdb8cdadbe120, 0x3ee2611186bae675, 0x3f08406003b2ae5c, 0x3f30000000000000, 0x3f551cb453b9536c, 0x3f7bdb8cdadbe120, 0x3fa2611186bae675, 0x3fc8406003b2ae5c, 0x3ff0000000000000, 0x40151cb453b9536c
u_wsx: dq 0xbfa2884e4caaa8b5, 0xbfa557e5cc562f5c, 0xbfa8636e86025bc6, 0xbfabac41c03660b9, 0xbfaf33ad92170f1c, 0xbfb17d7a9ef3c7d0, 0xbfb381a9d5f0cf36, 0xbfb5a6fd9f98b664, 0xbfb7ee0a667b1b6e, 0xbfba576153447ca6, 0xbfbce39084da1457, 0xbfbf932227654437, 0xbfc1334e72239053, 0xbfc2af42d88adfc4, 0xbfc43daf1baf4812, 0xbfc5ded1f9a2855c
u_prm: dd 0, 1, 4, 5, 2, 3, 6, 7
u_iota: dd 0, 1, 2, 3, 4, 5, 6, 7
u_k75: dd 0xbcc00000, 0x3e680000, 0x3f5e0000, 0xbd900000
u_k25: dd 0xbd900000, 0x3f5e0000, 0x3e680000, 0xbcc00000
u_k50: dd 0xbd800000, 0x3f100000, 0x3f100000, 0xbd800000
    ALIGN 32
u_cs: dq 0x3ff0000000000000, 0x4000000000000000, 0x4008000000000000, 0x4010000000000000, 0x4014000000000000, 0x4018000000000000, 0x401c000000000000, 0x4020000000000000, 0x4022000000000000, 0x4024000000000000, 0x4026000000000000, 0x4028000000000000, 0x402a000000000000
    ALIGN 32
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
u_lzm0: times 4 dq 0x3f42b404ad012b40
u_lzm1: times 4 dq 0x3f4ccbdd201fd4ef
u_lzm2: times 4 dq 0xbf311eb693d07d97
u_lzm3: times 4 dq 0xbf1b67222a46d1ad
u_lzm4: times 4 dq 0x3f50f72a125f9cc3
u_lzm5: times 4 dq 0xbfa2b404ad012b40
u_emc0: times 4 dq 0x4067479a6b50b0f2
u_emc1: times 4 dq 0x4083941f212d7732
u_emc2: times 4 dq 0x404f9fa43fe5c91d
u_emc3: times 4 dq 0x407c000000000000
u_emc4: times 4 dq 0x4059aa05d97b3a00
u_emc5: times 4 dq 0x4075957e89a13180
u_emc6: times 4 dq 0x407c000000000000
u_emc7: times 4 dq 0x40796ebc709f2dd8
u_emc8: times 4 dq 0x40448a1c7b069144
u_psx0: times 4 dq 0xc03dbea9bbad8eee
u_psx1: times 4 dq 0xc051d8cc3d0ddf6c
u_psx2: times 4 dq 0xc048fc51264891a4
u_psx3: times 4 dq 0xc01aa71d26143139
u_tsk: times 4 dq 0x3d88406003b2ae5c
u_xflr: times 4 dq 0x3e00000000000000
u_rg2: times 4 dq 0x3dde3c8fd606ea4e
u_tab: times 4 dq 0x3bc79ca10c924223
u_quart: times 4 dq 0x3fd0000000000000
u_six: times 4 dq 0x3fb0000000000000
u_ylo: times 4 dq 0x404ffffffffdda3f
u_yhi: times 4 dq 0x40500000000112e1
u_clo: times 4 dq 0x407fffffffffbb48
u_chi: times 4 dq 0x408000000000225c
u_512: times 4 dq 0x4080000000000000
u_ln2: times 4 dq 0x3fe62e42fefa39ef
u_i1024: times 4 dq 0x3f50000000000000
u_876: times 4 dq 0x408b600000000000
u_64: times 4 dq 0x4050000000000000
u_half: times 4 dq 0x3fe0000000000000
u_mhalf: times 4 dq 0xbfe0000000000000
u_magic: times 4 dq 0x43380000000003ff
u_anegl: times 4 dq 0x3eb1b85f230ee769
u_snegl: times 4 dq 0x3eeb8e76f9ee5729
u_tabsl: times 4 dq 0x3df4863cd212ebcd
u_rgl0: times 4 dq 0x3e99d70c9fca5d88
u_rgl1: times 4 dq 0x3ea1b8538621a5de
u_rgl2: times 4 dq 0x3e99d70c9fca5d88
u_mtl0: times 4 dq 0x401576fc202d13ce
u_mtl1: times 4 dq 0x40320d5ec231f3c2
u_mtl2: times 4 dq 0x3ffd287eb5f19d31
u_slol0: times 4 dq 0x404fffff792922a4
u_shil0: times 4 dq 0x40500000436b6eae
u_anegh: times 4 dq 0x3eb5b862605dc537
u_snegh: times 4 dq 0x3efb8e76f9ee5729
u_tabsh: times 4 dq 0x3e14863cd212ebcd
u_rgh0: times 4 dq 0x3ea0eb86ee1cf3c5
u_rgh1: times 4 dq 0x3ea5b85424596adf
u_rgh2: times 4 dq 0x3ea0eb86ee1cf3c5
u_mth0: times 4 dq 0x401cfa8be2377e73
u_mth1: times 4 dq 0x3ffa8faafb61d389
u_mth2: times 4 dq 0x401656a1235f0990
u_mth3: times 4 dq 0x401cfa8be2377e73
u_mth4: times 4 dq 0x401a524f11bfd53d
u_mth5: times 4 dq 0x3fe541e683bd49b5
u_sloh0: times 4 dq 0x407fffffefd79720
u_sloh1: times 4 dq 0x407fffffe90dcfd6
u_shih0: times 4 dq 0x4080000008143470
u_shih1: times 4 dq 0x408000000b791815
u_absm: times 4 dq 0x7fffffffffffffff
u_mzero: times 4 dq 0x8000000000000000
u_mant: times 4 dq 0x000fffffffffffff
u_oneb: times 4 dq 0x3ff0000000000000
u_i15: times 4 dq 15
u_i7: times 4 dq 7
u_i16: times 4 dq 16
u_ln2d: dq 0x3fe62e42fefa39ef, 0x3c7abc9e3b39803f
u_e125: dq 0x4003333333333333, 0x3c9999999999999a
u_e512: dq 0x3fdaaaaaaaaaaaab, 0xbc75555555555555
u_kr: dq 0x3fcb367a0f9096bc, 0xbc69ce075f6fd220
u_kg: dq 0x3fe6e2eb1c432ca5, 0x3c8e9e1b089a0275
u_kb: dq 0x3fb27bb2fec56d5d, 0xbc154c985f06f694
u_ysc: dq 0x3f52b404ad012b40, 0x3bf2b404ad012b40
u_yof: dq 0xbfb2b404ad012b40, 0xbc52b404ad012b40
u_rcr: dq 0x3f5ccbdd201fd4ef, 0xbbbc52277049f660
u_gcr: dq 0xbf411eb693d07d97, 0xbbde532a5948ad92
u_gcb: dq 0xbf2b67222a46d1ad, 0x3bc308379ea66878
u_bcb: dq 0x3f60f72a125f9cc3, 0xbc0fe7a8766ed378
u_cbs: dq 0x407e2dcd8fc14f85, 0x3d1149570691227d
u_crs: dq 0x4081c7b0691438f6, 0x3cfa450e3d8348a1

%assign m 11
%rep 110
cextern ds2_ %+ m
%assign m m+1
%endrep

ALIGN 8
const ds2
%assign m 11
%rep 110
    dq ds2_ %+ m
%assign m m+1
%endrep
