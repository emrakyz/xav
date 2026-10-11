%include "dav1d_x86inc.asm"

SECTION_RODATA 64

const ro
    ALIGN 64
c_tx: dd 0x3a153f18, 0x3b44ee90, 0x3c81ed35, 0x3dab706d, 0x3ee23720, 0x40153f18, 0x4144ee90, 0x4281ed35
    dd 0x43ab706d, 0x44e23720, 0x46153f18, 0x20e23720, 0x22153f18, 0x2344ee90, 0x2481ed35, 0x25ab706d
    dd 0x26e23720, 0x28153f18, 0x2944ee90, 0x2a81ed35, 0x2bab706d, 0x2ce23720, 0x2e153f18, 0x2f44ee90
    dd 0x3081ed35, 0x31ab706d, 0x32e23720, 0x34153f18, 0x3544ee90, 0x3681ed35, 0x37ab706d, 0x38e23720
    ALIGN 64
c_wx: dd 0x3f89cc00, 0x3f9eb703, 0x3fb572dd, 0x3fcdc515, 0x3fe80480, 0x40020161, 0x4010f029, 0x4020fdd2
    dd 0x4031e720, 0x4043cdf1, 0x4056bdec, 0x406a9370, 0x407fec72, 0x408adb51, 0x409665a9, 0x40a2b5ff
    ALIGN 64
c_rx: dd 0x3f7840c0, 0x3f6a0e61, 0x3f5d5bd7, 0x3f520e55, 0x3f47ce8f, 0x3f3e8b8a, 0x3f361aea, 0x3f2e4e7b
    dd 0x3f273372, 0x3f20a72c, 0x3f1a972f, 0x3f1500ee, 0x3f0fb169, 0x3f0ae217, 0x3f0656d4, 0x3f020171
    ALIGN 64
c_to: dd 0x3fd6b0c1, 0x400f49e7, 0x403f4477, 0x407f4fb8, 0x40aa6661, 0x40e374e4, 0x4117cf1f, 0x414aa40b
    dd 0x41873f1b, 0x41b4884d, 0x41f0fb5c, 0x4220d60b, 0x4256b0c1, 0x428f49e7, 0x42bf4477, 0x42ff4fb8
    dd 0x3c873f1b, 0x3cb4884d, 0x3cf0fb5c, 0x3d20d60b, 0x3d56b0c1, 0x3d8f49e7, 0x3dbf4477, 0x3dff4fb8
    dd 0x3e2a6661, 0x3e6374e4, 0x3e97cf1f, 0x3ecaa40b, 0x3f073f1b, 0x3f34884d, 0x3f70fb5c, 0x3fa0d60b
    ALIGN 64
c_wo: dd 0x3f81a673, 0x3f84e0ac, 0x3f87fc57, 0x3f8b023f, 0x3f8df100, 0x3f90c737, 0x3f938784, 0x3f963743
    dd 0x3f98d7f5, 0x3f9b6d00, 0x3f9df214, 0x3fa064a1, 0x3fa2c8ee, 0x3fa52786, 0x3fa772fb, 0x3fa9c435
    ALIGN 64
c_ro: dd 0x3f783fdc, 0x3f6a0603, 0x3f5d641d, 0x3f5202e2, 0x3f47bf71, 0x3f3e7bab, 0x3f36119f, 0x3f2e5a03
    dd 0x3f273e78, 0x3f20a724, 0x3f1a91f7, 0x3f14f848, 0x3f0fc547, 0x3f0adea7, 0x3f065896, 0x3f01fca4
    ALIGN 64
c_s2: dd 0x40000000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000
    dd 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000
    ALIGN 64
c_ones: times 16 dd 0x3f800000
    ALIGN 64
c_onesw: times 16 dd 1
    ALIGN 64
c_n64w: times 32 dw -64
    ALIGN 64
c_qx0: dd 0x4019999a
c_qx1: dd 0x3fd70961
c_qx2: dd 0x3e6569c3
c_qo0: dd 0x3ed55555
c_qo1: dd 0xbdf8f484
c_qo2: dd 0x3d836e66
c_xflr: dd 0x35800000
c_xlo: dd 0x38000000
c_eq: dd 0x3ed562ab
c_ieq: dd 0x4019b74c
c_epsf: dd 0x0da24260
c_xrcr: dd 0x3fc51331
c_xgcr: dd 0xbeea5463
c_xgcb: dd 0xbe3b89d2
c_xbcb: dd 0x3fe83710
c_kh0: dd 0xbd400000
c_kh1: dd 0x3f0c0000
c_kh2: dd 0x3cc00000
c_kh3: dd 0xbea40000
c_kh4: dd 0x3e980000
c_kh5: dd 0xbcc00000
c_h0625: dd 0x3d800000
c_h5625: dd 0x3f100000
c_one: dd 0x3f800000
c_half: dd 0x3f000000
c_rgl0: dd 0x34ceb8df
c_rgl1: dd 0x350dc2f0
c_rgl2: dd 0x34ceb8df
c_oml0: dd 0x34a3a5ba
c_oml1: dd 0x3483a5a5
c_oml2: dd 0x34c3a5cf
c_anegl: dd 0x358dc34d
c_snegl: dd 0x375c7448
c_tabsl: dd 0x2fa43252
c_mtl0: dd 0x4088a915
c_mtl1: dd 0x4165de07
c_mtl2: dd 0x3fb9a46c
c_slkl: dd 0x3786d510
c_rgh0: dd 0x35075c87
c_rgh1: dd 0x352dc308
c_rgh2: dd 0x35075c87
c_omh0: dd 0x34c3a5cf
c_omh1: dd 0x34a3a5ba
c_omh2: dd 0x34c3a5cf
c_anegh: dd 0x35adc37a
c_snegh: dd 0x37dc7448
c_tabsh: dd 0x30a43252
c_mth0: dd 0x40b87fe1
c_mth1: dd 0x3fa91ba6
c_mth2: dd 0x408e38f8
c_mth4: dd 0x40a794fe
c_mth5: dd 0x3f07571c
c_slkh0: dd 0x37814176
c_slkh1: dd 0x37b78fd4
c_sign: dd 0x80000000
c_absm: dd 0x7fffffff
c_i64: dd 64
c_i512: dd 512
c_i1023: dd 1023
c_zero: dd 0
c_m1: dd -1
    ALIGN 64
c_pkw: dw 0, 2, 8, 10, 16, 18, 24, 26, 4, 6, 12, 14, 20, 22, 28, 30
    times 16 dw 0
    ALIGN 64
t_oa: dq 0x3ff0000000000000, 0x3ff55b8108f0ec5e, 0x3ffc823e074ec129, 0x400306fe0a31b715, 0x400965fea53d6e3d, 0x4010f38f92d97963, 0x4016a09e667f3bcd, 0x401e3437e7101344, 0x402428a2f98d728b, 0x402ae89f995ad3ad, 0x4031f59ac3c7d6c0, 0x4037f910d768cfb0, 0x4040000000000000, 0x40455b8108f0ec5e, 0x404c823e074ec129, 0x405306fe0a31b715
    ALIGN 64
t_ob: dq 0x3ff55b8108f0ec5e, 0x3d0ae89f995ad3ad, 0x3d755b8108f0ec5e, 0x3de0f38f92d97963, 0x3e4ae89f995ad3ad, 0x3eb55b8108f0ec5e, 0x3f20f38f92d97963, 0x3f8ae89f995ad3ad
    ALIGN 64
t_ow: dq 0x3ff034dae33d2513, 0x3ff09bd444ecbfc7, 0x3ff0ff6ccdf729fe, 0x3ff15fed75e356b9, 0x3ff1bd95a53cf85d, 0x3ff2189cd11a12f7, 0x3ff27133f24e1985, 0x3ff2c78674186ae1, 0x3ff31bbaed16c926, 0x3ff36df401e38c70, 0x3ff3be50ec4f2493, 0x3ff40cedcd83f513, 0x3ff459e41f1dd6e4, 0x3ff4a54b31dd20b6, 0x3ff4ef3841597f2a, 0x3ff537be9ed40652
    ALIGN 64
t_rx: dq 0x3fef07c200000000, 0x3fed41d420000000, 0x3febacf920000000, 0x3fea41a420000000, 0x3fe8f9c180000000, 0x3fe7d05f40000000, 0x3fe6c16c20000000, 0x3fe5c98820000000, 0x3fe4e5e0a0000000, 0x3fe4141420000000, 0x3fe3521d00000000, 0x3fe29e4120000000, 0x3fe1f70480000000, 0x3fe15b1e60000000, 0x3fe0c97140000000, 0x3fe0410420000000
    ALIGN 64
t_tsl: dq 0x3dd51cb453b9536c, 0x3dfbdb8cdadbe120, 0x3e22611186bae675, 0x3e48406003b2ae5c, 0x3e70000000000000, 0x3e951cb453b9536c, 0x3ebbdb8cdadbe120, 0x3ee2611186bae675, 0x3f08406003b2ae5c, 0x3f30000000000000, 0x3f551cb453b9536c, 0x3f7bdb8cdadbe120, 0x3fa2611186bae675, 0x3fc8406003b2ae5c, 0x3ff0000000000000, 0x40151cb453b9536c
    ALIGN 64
t_wsx: dq 0xbfa2884e4caaa8b5, 0xbfa557e5cc562f5c, 0xbfa8636e86025bc6, 0xbfabac41c03660b9, 0xbfaf33ad92170f1c, 0xbfb17d7a9ef3c7d0, 0xbfb381a9d5f0cf36, 0xbfb5a6fd9f98b664, 0xbfb7ee0a667b1b6e, 0xbfba576153447ca6, 0xbfbce39084da1457, 0xbfbf932227654437, 0xbfc1334e72239053, 0xbfc2af42d88adfc4, 0xbfc43daf1baf4812, 0xbfc5ded1f9a2855c
    ALIGN 32
t_iota: dd 0, 1, 2, 3, 4, 5, 6, 7
t_k75: dd 0xbcc00000, 0x3e680000, 0x3f5e0000, 0xbd900000
t_k25: dd 0xbd900000, 0x3f5e0000, 0x3e680000, 0xbcc00000
t_k50: dd 0xbd800000, 0x3f100000, 0x3f100000, 0xbd800000
    ALIGN 16
t_one2: dq 0x3ff0000000000000, 0x3ff0000000000000
t_sgn2: dq 0x8000000000000000, 0x8000000000000000
t_abs2: dq 0x7fffffffffffffff, 0x7fffffffffffffff
t_q2i: dd 0, 6, 1, 7
t_q2j: dd 5, 0, 0, 0
    ALIGN 8
t_one: dq 0x3ff0000000000000
t_eq0: dq 0x3fdaac5555555556
t_omg: dq 0x3ddb7cdfd9d7bdbb
t_epsn: dq 0x07e0e7c9eebc444a
t_rg2: dq 0x3dde3c8fd606ea4e
t_tab: dq 0x3bc79ca10c924223
t_xflr: dq 0x3e00000000000000
t_tsk: dq 0x3d88406003b2ae5c
t_mone: dq 0xbff0000000000000
t_mzero: dq 0x8000000000000000
t_zero: dq 0x0000000000000000
t_half: dq 0x3fe0000000000000
t_mhalf: dq 0xbfe0000000000000
t_ln2: dq 0x3fe62e42fefa39ef
t_i1024: dq 0x3f50000000000000
t_876: dq 0x408b600000000000
t_64: dq 0x4050000000000000
t_512: dq 0x4080000000000000
t_quart: dq 0x3fd0000000000000
t_six: dq 0x3fb0000000000000
t_ylo: dq 0x404ffffffffdda3f
t_yhi: dq 0x40500000000112e1
t_clo: dq 0x407fffffffffbb48
t_chi: dq 0x408000000000225c
t_c1: dq 0x3ff0000000000000
t_c2: dq 0x4000000000000000
t_c3: dq 0x4008000000000000
t_c4: dq 0x4010000000000000
t_c5: dq 0x4014000000000000
t_c6: dq 0x4018000000000000
t_c7: dq 0x401c000000000000
t_c8: dq 0x4020000000000000
t_c9: dq 0x4022000000000000
t_c10: dq 0x4024000000000000
t_c11: dq 0x4026000000000000
t_c12: dq 0x4028000000000000
t_c13: dq 0x402a000000000000
t_lzm0: dq 0x3f42b404ad012b40
t_lzm1: dq 0x3f4ccbdd201fd4ef
t_lzm2: dq 0xbf311eb693d07d97
t_lzm3: dq 0xbf1b67222a46d1ad
t_lzm4: dq 0x3f50f72a125f9cc3
t_lzm5: dq 0xbfa2b404ad012b40
t_emc0: dq 0x4067479a6b50b0f2
t_emc1: dq 0x4083941f212d7732
t_emc2: dq 0x404f9fa43fe5c91d
t_emc3: dq 0x407c000000000000
t_emc4: dq 0x4059aa05d97b3a00
t_emc5: dq 0x4075957e89a13180
t_emc6: dq 0x407c000000000000
t_emc7: dq 0x40796ebc709f2dd8
t_emc8: dq 0x40448a1c7b069144
t_psx0: dq 0xc03dbea9bbad8eee
t_psx1: dq 0xc051d8cc3d0ddf6c
t_psx2: dq 0xc048fc51264891a4
t_psx3: dq 0xc01aa71d26143139
t_op0: dq 0x3fefffffffffc441
t_op1: dq 0x3fdaaaaaa242d844
t_op2: dq 0xbfbf1c716de3f83a
t_op3: dq 0x3fb06db0f52d1c57
t_op4: dq 0xbfa53afd84e96ced
t_rgl0: dq 0x3e99d70c9fca5d88
t_rgl1: dq 0x3ea1b8538621a5de
t_rgl2: dq 0x3e99d70c9fca5d88
t_mtl0: dq 0x401576fc202d13ce
t_mtl1: dq 0x40320d5ec231f3c2
t_mtl2: dq 0x3ffd287eb5f19d31
t_slol0: dq 0x404fffff792922a4
t_shil0: dq 0x40500000436b6eae
t_anegl: dq 0x3eb1b85f230ee769
t_snegl: dq 0x3eeb8e76f9ee5729
t_tabsl: dq 0x3df4863cd212ebcd
t_rgh0: dq 0x3ea0eb86ee1cf3c5
t_rgh1: dq 0x3ea5b85424596adf
t_rgh2: dq 0x3ea0eb86ee1cf3c5
t_mth0: dq 0x401cfa8be2377e73
t_mth1: dq 0x3ffa8faafb61d389
t_mth2: dq 0x401656a1235f0990
t_mth3: dq 0x401cfa8be2377e73
t_mth4: dq 0x401a524f11bfd53d
t_mth5: dq 0x3fe541e683bd49b5
t_sloh0: dq 0x407fffffefd79720
t_sloh1: dq 0x407fffffe90dcfd6
t_shih0: dq 0x4080000008143470
t_shih1: dq 0x408000000b791815
t_anegh: dq 0x3eb5b862605dc537
t_snegh: dq 0x3efb8e76f9ee5729
t_tabsh: dq 0x3e14863cd212ebcd
t_sign: dq 0x8000000000000000
t_q1023: dq 1023
t_q16: dq 16
t_ln2d: dq 0x3fe62e42fefa39ef, 0x3c7abc9e3b39803f
t_e125: dq 0x4003333333333333, 0x3c9999999999999a
t_e512: dq 0x3fdaaaaaaaaaaaab, 0xbc75555555555555
t_kr: dq 0x3fcb367a0f9096bc, 0xbc69ce075f6fd220
t_kg: dq 0x3fe6e2eb1c432ca5, 0x3c8e9e1b089a0275
t_kb: dq 0x3fb27bb2fec56d5d, 0xbc154c985f06f694
t_ysc: dq 0x3f52b404ad012b40, 0x3bf2b404ad012b40
t_yof: dq 0xbfb2b404ad012b40, 0xbc52b404ad012b40
t_rcr: dq 0x3f5ccbdd201fd4ef, 0xbbbc52277049f660
t_gcr: dq 0xbf411eb693d07d97, 0xbbde532a5948ad92
t_gcb: dq 0xbf2b67222a46d1ad, 0x3bc308379ea66878
t_bcb: dq 0x3f60f72a125f9cc3, 0xbc0fe7a8766ed378
t_cbs: dq 0x407e2dcd8fc14f85, 0x3d1149570691227d
t_crs: dq 0x4081c7b0691438f6, 0x3cfa450e3d8348a1
    ALIGN 64
t_wid: dw 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
t_w32: times 32 dw 32
t_ones: times 64 db 0xff
t_l2d: dd 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30
t_c2d: dd 0, 2, 16, 18, 4, 6, 20, 22, 8, 10, 24, 26, 12, 14, 28, 30

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
