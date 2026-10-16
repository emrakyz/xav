%include "dav1d_x86inc.asm"

SECTION_RODATA 64

const pql
c_rq8: dd 0x3f70f0f1, 0x3f579436, 0x3f430c31, 0x3f321643, 0x3f23d70a, 0x3f17b426, 0x3f0d3dcb, 0x3f042108
c_vq8: dd 0x3a49a543, 0x3b0f0004, 0x3b626cdd, 0x3b972c73, 0x3bba0183, 0x3bda304f, 0x3bf8194e, 0x3c0a04da
c_uq0: dd 0x3e33ed8c, 0x3e2c652f, 0x3e24cbca, 0x3e1d2138, 0x3e156552, 0x3e0d97f0, 0x3e05b8ea, 0x3dfb9034
c_uq1: dd 0x3deb8aad, 0x3ddb60ef, 0x3dcb12a7, 0x3dba9f83, 0x3daa072f, 0x3d994958, 0x3d8865a9, 0x3d6eb799
c_uq2: dd 0x3d4c56d7, 0x3d29a85f, 0x3d06ab80, 0x3cc6bf16, 0x3c7f0f2e, 0x7fc00000, 0x7fc00000, 0x7fc00000
c_t68: dd 0x498545d0, 0x4ca186ee, 0x4fc3c580, 0x52ed469e, 0x560fca27, 0x592e460f, 0x5c53386c, 0x7fc00000
c_w68: dd 0x3fbb4734, 0x403c3a6a, 0x40b0672a, 0x411c214e, 0x4183c1e1, 0x41d5980a, 0x422740ae, 0x427e3550
c_tll: dd 0x3f688ddf, 0x3f81da1f, 0x3f910306, 0x3fa1f102, 0x3fb4d8f8, 0x3fc9f5fa, 0x3fe18a01, 0x3ffbdeb7
c_tlh: dd 0x3f3a78fa, 0x3f503e1a, 0x3f688ddf, 0x3f81da1f, 0x3f910306, 0x3fa1f102, 0x3fb4d8f8, 0x3fc9f5fa
c_thi: dd 0x3f800000, 0x401ad0fd, 0x40bb4035, 0x41627af9, 0x3cef3eab, 0x3d90af02, 0x3e2efec8, 0x3ed3a840
c_w1q: dd 0x3f813d44, 0x3f838ea1, 0x3f85ab83, 0x3f879faa, 0x3f896e02, 0x3f8b21d7, 0x3f8cbab3, 0x3f8e3b95
c_r1q: dd 0x3f70f976, 0x3f578816, 0x3f4304a7, 0x3f320a28, 0x3f23da2f, 0x3f17aa6f, 0x3f0d2de9, 0x3f0411a2
c_t2q: dd 0x3f8df150, 0x3ebd9597, 0x3df953fa, 0x3d215c39, 0x3c4d7708, 0x3b80a003, 0x3a9e454a, 0x39bf4b8d
c_rkq: dd 0x3e280000, 0x3e2a5a84, 0x3e2cc626, 0x3e2f43a5, 0x3e31d3ca, 0x3e347768, 0x3e372f61, 0x3e39fca5
c_rpq: dd 0x00000000, 0x3c65876e, 0x3ce8ca4e, 0x3d311bef, 0x3d6f9951, 0x3d97f8c3, 0x3db91d04, 0x3ddb44cd
c_s2: dd 0x40000000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000
c_one: times 8 dd 0x3f800000
c_flq: times 8 dd 0x3da2f9ef
c_pu0: times 8 dd 0x3c4fcd9c
c_pu1: times 8 dd 0xbbcd2ad9
c_pu2: times 8 dd 0x3b88551b
c_pu3: times 8 dd 0xbb4bb48f
c_c1q: times 8 dd 0x3f811fae
c_aq: times 8 dd 0x3c17895c
c_bq: times 8 dd 0x3d5b2f17
c_q60: times 8 dd 0x40c8dffc
c_q61: times 8 dd 0x41848358
c_q62: times 8 dd 0x41bd4d92
c_q63: times 8 dd 0x419ae21a
c_anl: times 8 dd 0x36b88001
c_tbl: times 8 dd 0x4a871ba5
c_rgl: times 8 dd 0x36387f88
c_xll: times 8 dd 0x50800000
c_onl: times 8 dd 0x60800000
c_oml0: times 8 dd 0x35000054
c_oml1: times 8 dd 0x34e00093
c_oml2: times 8 dd 0x3510005e
c_mtl0: times 8 dd 0x434f8549
c_mtl1: times 8 dd 0x4405e5a4
c_mtl2: times 8 dd 0x423b6079
c_anh: times 8 dd 0x36c0800c
c_tbh: times 8 dd 0x4b871ba5
c_rgh: times 8 dd 0x36407f8e
c_xlh: times 8 dd 0x51800000
c_onh: times 8 dd 0x61800000
c_mth0: times 8 dd 0x43c9ff42
c_mth1: times 8 dd 0x42e1a392
c_mth2: times 8 dd 0x4391965e
c_mth4: times 8 dd 0x43b9c032
c_mth5: times 8 dd 0x4201f883
c_nieq: times 8 dd 0xbfbcbe96
c_eqp: times 8 dd 0x3f2d9c42
c_q10: times 8 dd 0x3e231ffc
c_q11: times 8 dd 0xbd8950a7
c_q12: times 8 dd 0x3d28a557
c_s1q: times 8 dd 0x3f81da1f
c_c3: times 8 dd 0x41958000
c_hq: times 8 dd 0x413e0000
c_mag: times 8 dd 0x4b400000
c_p20: times 8 dd 0xc29db00e
c_p21: times 8 dd 0x453fcbf6
c_p22: times 8 dd 0xc799807c
c_p23: times 8 dd 0x49b5ec4a
c_p24: times 8 dd 0xcbacc630
c_p25: times 8 dd 0x4d845d1f
c_oa: times 8 dd 0x33c17d7f
c_sl: times 8 dd 0x34800000
c_half: times 8 dd 0x3f000000
c_h0625: times 8 dd 0x3d800000
c_h5625: times 8 dd 0x3f100000
c_krh: times 8 dd 0x41b80000
c_krl: times 8 dd 0x3d8920d4
c_grh: times 8 dd 0x41100000
c_grl: times 8 dd 0xbd7f9c07
c_gbh: times 8 dd 0x40200000
c_gbl: times 8 dd 0x3d97b7cf
c_kbh: times 8 dd 0x41e80000
c_kbl: times 8 dd 0x3edc66c0
c_sign: times 8 dd 0x80000000
c_mant: times 8 dd 0x007fffff
c_zero: times 8 dd 0x00000000
c_i64: times 8 dd 0x00000040
c_i512: times 8 dd 0x00000200
c_w1023: times 8 dd 0x03ff03ff
c_n64w: times 8 dd 0x00400040
c_pd8: dd 0, 4, 1, 5, 2, 6, 3, 7
t_c2d: dd 0, 2, 8, 10, 4, 6, 12, 14
t_cmp: db 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0
    db 1, 0, 0, 0, 0, 0, 0, 0
    db 0, 1, 0, 0, 0, 0, 0, 0
    db 2, 0, 0, 0, 0, 0, 0, 0
    db 0, 2, 0, 0, 0, 0, 0, 0
    db 1, 2, 0, 0, 0, 0, 0, 0
    db 0, 1, 2, 0, 0, 0, 0, 0
    db 3, 0, 0, 0, 0, 0, 0, 0
    db 0, 3, 0, 0, 0, 0, 0, 0
    db 1, 3, 0, 0, 0, 0, 0, 0
    db 0, 1, 3, 0, 0, 0, 0, 0
    db 2, 3, 0, 0, 0, 0, 0, 0
    db 0, 2, 3, 0, 0, 0, 0, 0
    db 1, 2, 3, 0, 0, 0, 0, 0
    db 0, 1, 2, 3, 0, 0, 0, 0
    db 4, 0, 0, 0, 0, 0, 0, 0
    db 0, 4, 0, 0, 0, 0, 0, 0
    db 1, 4, 0, 0, 0, 0, 0, 0
    db 0, 1, 4, 0, 0, 0, 0, 0
    db 2, 4, 0, 0, 0, 0, 0, 0
    db 0, 2, 4, 0, 0, 0, 0, 0
    db 1, 2, 4, 0, 0, 0, 0, 0
    db 0, 1, 2, 4, 0, 0, 0, 0
    db 3, 4, 0, 0, 0, 0, 0, 0
    db 0, 3, 4, 0, 0, 0, 0, 0
    db 1, 3, 4, 0, 0, 0, 0, 0
    db 0, 1, 3, 4, 0, 0, 0, 0
    db 2, 3, 4, 0, 0, 0, 0, 0
    db 0, 2, 3, 4, 0, 0, 0, 0
    db 1, 2, 3, 4, 0, 0, 0, 0
    db 0, 1, 2, 3, 4, 0, 0, 0
    db 5, 0, 0, 0, 0, 0, 0, 0
    db 0, 5, 0, 0, 0, 0, 0, 0
    db 1, 5, 0, 0, 0, 0, 0, 0
    db 0, 1, 5, 0, 0, 0, 0, 0
    db 2, 5, 0, 0, 0, 0, 0, 0
    db 0, 2, 5, 0, 0, 0, 0, 0
    db 1, 2, 5, 0, 0, 0, 0, 0
    db 0, 1, 2, 5, 0, 0, 0, 0
    db 3, 5, 0, 0, 0, 0, 0, 0
    db 0, 3, 5, 0, 0, 0, 0, 0
    db 1, 3, 5, 0, 0, 0, 0, 0
    db 0, 1, 3, 5, 0, 0, 0, 0
    db 2, 3, 5, 0, 0, 0, 0, 0
    db 0, 2, 3, 5, 0, 0, 0, 0
    db 1, 2, 3, 5, 0, 0, 0, 0
    db 0, 1, 2, 3, 5, 0, 0, 0
    db 4, 5, 0, 0, 0, 0, 0, 0
    db 0, 4, 5, 0, 0, 0, 0, 0
    db 1, 4, 5, 0, 0, 0, 0, 0
    db 0, 1, 4, 5, 0, 0, 0, 0
    db 2, 4, 5, 0, 0, 0, 0, 0
    db 0, 2, 4, 5, 0, 0, 0, 0
    db 1, 2, 4, 5, 0, 0, 0, 0
    db 0, 1, 2, 4, 5, 0, 0, 0
    db 3, 4, 5, 0, 0, 0, 0, 0
    db 0, 3, 4, 5, 0, 0, 0, 0
    db 1, 3, 4, 5, 0, 0, 0, 0
    db 0, 1, 3, 4, 5, 0, 0, 0
    db 2, 3, 4, 5, 0, 0, 0, 0
    db 0, 2, 3, 4, 5, 0, 0, 0
    db 1, 2, 3, 4, 5, 0, 0, 0
    db 0, 1, 2, 3, 4, 5, 0, 0
    db 6, 0, 0, 0, 0, 0, 0, 0
    db 0, 6, 0, 0, 0, 0, 0, 0
    db 1, 6, 0, 0, 0, 0, 0, 0
    db 0, 1, 6, 0, 0, 0, 0, 0
    db 2, 6, 0, 0, 0, 0, 0, 0
    db 0, 2, 6, 0, 0, 0, 0, 0
    db 1, 2, 6, 0, 0, 0, 0, 0
    db 0, 1, 2, 6, 0, 0, 0, 0
    db 3, 6, 0, 0, 0, 0, 0, 0
    db 0, 3, 6, 0, 0, 0, 0, 0
    db 1, 3, 6, 0, 0, 0, 0, 0
    db 0, 1, 3, 6, 0, 0, 0, 0
    db 2, 3, 6, 0, 0, 0, 0, 0
    db 0, 2, 3, 6, 0, 0, 0, 0
    db 1, 2, 3, 6, 0, 0, 0, 0
    db 0, 1, 2, 3, 6, 0, 0, 0
    db 4, 6, 0, 0, 0, 0, 0, 0
    db 0, 4, 6, 0, 0, 0, 0, 0
    db 1, 4, 6, 0, 0, 0, 0, 0
    db 0, 1, 4, 6, 0, 0, 0, 0
    db 2, 4, 6, 0, 0, 0, 0, 0
    db 0, 2, 4, 6, 0, 0, 0, 0
    db 1, 2, 4, 6, 0, 0, 0, 0
    db 0, 1, 2, 4, 6, 0, 0, 0
    db 3, 4, 6, 0, 0, 0, 0, 0
    db 0, 3, 4, 6, 0, 0, 0, 0
    db 1, 3, 4, 6, 0, 0, 0, 0
    db 0, 1, 3, 4, 6, 0, 0, 0
    db 2, 3, 4, 6, 0, 0, 0, 0
    db 0, 2, 3, 4, 6, 0, 0, 0
    db 1, 2, 3, 4, 6, 0, 0, 0
    db 0, 1, 2, 3, 4, 6, 0, 0
    db 5, 6, 0, 0, 0, 0, 0, 0
    db 0, 5, 6, 0, 0, 0, 0, 0
    db 1, 5, 6, 0, 0, 0, 0, 0
    db 0, 1, 5, 6, 0, 0, 0, 0
    db 2, 5, 6, 0, 0, 0, 0, 0
    db 0, 2, 5, 6, 0, 0, 0, 0
    db 1, 2, 5, 6, 0, 0, 0, 0
    db 0, 1, 2, 5, 6, 0, 0, 0
    db 3, 5, 6, 0, 0, 0, 0, 0
    db 0, 3, 5, 6, 0, 0, 0, 0
    db 1, 3, 5, 6, 0, 0, 0, 0
    db 0, 1, 3, 5, 6, 0, 0, 0
    db 2, 3, 5, 6, 0, 0, 0, 0
    db 0, 2, 3, 5, 6, 0, 0, 0
    db 1, 2, 3, 5, 6, 0, 0, 0
    db 0, 1, 2, 3, 5, 6, 0, 0
    db 4, 5, 6, 0, 0, 0, 0, 0
    db 0, 4, 5, 6, 0, 0, 0, 0
    db 1, 4, 5, 6, 0, 0, 0, 0
    db 0, 1, 4, 5, 6, 0, 0, 0
    db 2, 4, 5, 6, 0, 0, 0, 0
    db 0, 2, 4, 5, 6, 0, 0, 0
    db 1, 2, 4, 5, 6, 0, 0, 0
    db 0, 1, 2, 4, 5, 6, 0, 0
    db 3, 4, 5, 6, 0, 0, 0, 0
    db 0, 3, 4, 5, 6, 0, 0, 0
    db 1, 3, 4, 5, 6, 0, 0, 0
    db 0, 1, 3, 4, 5, 6, 0, 0
    db 2, 3, 4, 5, 6, 0, 0, 0
    db 0, 2, 3, 4, 5, 6, 0, 0
    db 1, 2, 3, 4, 5, 6, 0, 0
    db 0, 1, 2, 3, 4, 5, 6, 0
    db 7, 0, 0, 0, 0, 0, 0, 0
    db 0, 7, 0, 0, 0, 0, 0, 0
    db 1, 7, 0, 0, 0, 0, 0, 0
    db 0, 1, 7, 0, 0, 0, 0, 0
    db 2, 7, 0, 0, 0, 0, 0, 0
    db 0, 2, 7, 0, 0, 0, 0, 0
    db 1, 2, 7, 0, 0, 0, 0, 0
    db 0, 1, 2, 7, 0, 0, 0, 0
    db 3, 7, 0, 0, 0, 0, 0, 0
    db 0, 3, 7, 0, 0, 0, 0, 0
    db 1, 3, 7, 0, 0, 0, 0, 0
    db 0, 1, 3, 7, 0, 0, 0, 0
    db 2, 3, 7, 0, 0, 0, 0, 0
    db 0, 2, 3, 7, 0, 0, 0, 0
    db 1, 2, 3, 7, 0, 0, 0, 0
    db 0, 1, 2, 3, 7, 0, 0, 0
    db 4, 7, 0, 0, 0, 0, 0, 0
    db 0, 4, 7, 0, 0, 0, 0, 0
    db 1, 4, 7, 0, 0, 0, 0, 0
    db 0, 1, 4, 7, 0, 0, 0, 0
    db 2, 4, 7, 0, 0, 0, 0, 0
    db 0, 2, 4, 7, 0, 0, 0, 0
    db 1, 2, 4, 7, 0, 0, 0, 0
    db 0, 1, 2, 4, 7, 0, 0, 0
    db 3, 4, 7, 0, 0, 0, 0, 0
    db 0, 3, 4, 7, 0, 0, 0, 0
    db 1, 3, 4, 7, 0, 0, 0, 0
    db 0, 1, 3, 4, 7, 0, 0, 0
    db 2, 3, 4, 7, 0, 0, 0, 0
    db 0, 2, 3, 4, 7, 0, 0, 0
    db 1, 2, 3, 4, 7, 0, 0, 0
    db 0, 1, 2, 3, 4, 7, 0, 0
    db 5, 7, 0, 0, 0, 0, 0, 0
    db 0, 5, 7, 0, 0, 0, 0, 0
    db 1, 5, 7, 0, 0, 0, 0, 0
    db 0, 1, 5, 7, 0, 0, 0, 0
    db 2, 5, 7, 0, 0, 0, 0, 0
    db 0, 2, 5, 7, 0, 0, 0, 0
    db 1, 2, 5, 7, 0, 0, 0, 0
    db 0, 1, 2, 5, 7, 0, 0, 0
    db 3, 5, 7, 0, 0, 0, 0, 0
    db 0, 3, 5, 7, 0, 0, 0, 0
    db 1, 3, 5, 7, 0, 0, 0, 0
    db 0, 1, 3, 5, 7, 0, 0, 0
    db 2, 3, 5, 7, 0, 0, 0, 0
    db 0, 2, 3, 5, 7, 0, 0, 0
    db 1, 2, 3, 5, 7, 0, 0, 0
    db 0, 1, 2, 3, 5, 7, 0, 0
    db 4, 5, 7, 0, 0, 0, 0, 0
    db 0, 4, 5, 7, 0, 0, 0, 0
    db 1, 4, 5, 7, 0, 0, 0, 0
    db 0, 1, 4, 5, 7, 0, 0, 0
    db 2, 4, 5, 7, 0, 0, 0, 0
    db 0, 2, 4, 5, 7, 0, 0, 0
    db 1, 2, 4, 5, 7, 0, 0, 0
    db 0, 1, 2, 4, 5, 7, 0, 0
    db 3, 4, 5, 7, 0, 0, 0, 0
    db 0, 3, 4, 5, 7, 0, 0, 0
    db 1, 3, 4, 5, 7, 0, 0, 0
    db 0, 1, 3, 4, 5, 7, 0, 0
    db 2, 3, 4, 5, 7, 0, 0, 0
    db 0, 2, 3, 4, 5, 7, 0, 0
    db 1, 2, 3, 4, 5, 7, 0, 0
    db 0, 1, 2, 3, 4, 5, 7, 0
    db 6, 7, 0, 0, 0, 0, 0, 0
    db 0, 6, 7, 0, 0, 0, 0, 0
    db 1, 6, 7, 0, 0, 0, 0, 0
    db 0, 1, 6, 7, 0, 0, 0, 0
    db 2, 6, 7, 0, 0, 0, 0, 0
    db 0, 2, 6, 7, 0, 0, 0, 0
    db 1, 2, 6, 7, 0, 0, 0, 0
    db 0, 1, 2, 6, 7, 0, 0, 0
    db 3, 6, 7, 0, 0, 0, 0, 0
    db 0, 3, 6, 7, 0, 0, 0, 0
    db 1, 3, 6, 7, 0, 0, 0, 0
    db 0, 1, 3, 6, 7, 0, 0, 0
    db 2, 3, 6, 7, 0, 0, 0, 0
    db 0, 2, 3, 6, 7, 0, 0, 0
    db 1, 2, 3, 6, 7, 0, 0, 0
    db 0, 1, 2, 3, 6, 7, 0, 0
    db 4, 6, 7, 0, 0, 0, 0, 0
    db 0, 4, 6, 7, 0, 0, 0, 0
    db 1, 4, 6, 7, 0, 0, 0, 0
    db 0, 1, 4, 6, 7, 0, 0, 0
    db 2, 4, 6, 7, 0, 0, 0, 0
    db 0, 2, 4, 6, 7, 0, 0, 0
    db 1, 2, 4, 6, 7, 0, 0, 0
    db 0, 1, 2, 4, 6, 7, 0, 0
    db 3, 4, 6, 7, 0, 0, 0, 0
    db 0, 3, 4, 6, 7, 0, 0, 0
    db 1, 3, 4, 6, 7, 0, 0, 0
    db 0, 1, 3, 4, 6, 7, 0, 0
    db 2, 3, 4, 6, 7, 0, 0, 0
    db 0, 2, 3, 4, 6, 7, 0, 0
    db 1, 2, 3, 4, 6, 7, 0, 0
    db 0, 1, 2, 3, 4, 6, 7, 0
    db 5, 6, 7, 0, 0, 0, 0, 0
    db 0, 5, 6, 7, 0, 0, 0, 0
    db 1, 5, 6, 7, 0, 0, 0, 0
    db 0, 1, 5, 6, 7, 0, 0, 0
    db 2, 5, 6, 7, 0, 0, 0, 0
    db 0, 2, 5, 6, 7, 0, 0, 0
    db 1, 2, 5, 6, 7, 0, 0, 0
    db 0, 1, 2, 5, 6, 7, 0, 0
    db 3, 5, 6, 7, 0, 0, 0, 0
    db 0, 3, 5, 6, 7, 0, 0, 0
    db 1, 3, 5, 6, 7, 0, 0, 0
    db 0, 1, 3, 5, 6, 7, 0, 0
    db 2, 3, 5, 6, 7, 0, 0, 0
    db 0, 2, 3, 5, 6, 7, 0, 0
    db 1, 2, 3, 5, 6, 7, 0, 0
    db 0, 1, 2, 3, 5, 6, 7, 0
    db 4, 5, 6, 7, 0, 0, 0, 0
    db 0, 4, 5, 6, 7, 0, 0, 0
    db 1, 4, 5, 6, 7, 0, 0, 0
    db 0, 1, 4, 5, 6, 7, 0, 0
    db 2, 4, 5, 6, 7, 0, 0, 0
    db 0, 2, 4, 5, 6, 7, 0, 0
    db 1, 2, 4, 5, 6, 7, 0, 0
    db 0, 1, 2, 4, 5, 6, 7, 0
    db 3, 4, 5, 6, 7, 0, 0, 0
    db 0, 3, 4, 5, 6, 7, 0, 0
    db 1, 3, 4, 5, 6, 7, 0, 0
    db 0, 1, 3, 4, 5, 6, 7, 0
    db 2, 3, 4, 5, 6, 7, 0, 0
    db 0, 2, 3, 4, 5, 6, 7, 0
    db 1, 2, 3, 4, 5, 6, 7, 0
    db 0, 1, 2, 3, 4, 5, 6, 7
ALIGN 64
d_qa: dq 0x3ff0000000000000, 0x3ff1de319919c21c, 0x3ff3f437064906bc, 0x3ff64894ccfcbd7b, 0x3ff8e2923dea5e85, 0x3ffbca5032e29c46, 0x3fff08e27453c641, 0x400154360ae9be90
    dq 0x40035a1f912671b1, 0x40059c7ffd64702f, 0x400822666b29d368, 0x400af3b4ef34cb10, 0x400e193938df06c8, 0x4010ce6409d179ce, 0x4012c4ae0f59d4f5, 0x4014f59c0d507726
ALIGN 64
d_qw: dq 0x3ff01420b6386eae, 0x3ff03ae42abf992e, 0x3ff05fd5cfa98838, 0x3ff08323028502d9, 0x3ff0a4f2a4d1421c, 0x3ff0c56649698dda, 0x3ff0e49b3120fcfe, 0x3ff102aafc0ae0bc
    dq 0x3ff11fac34abacad, 0x3ff13bb2da57c65c, 0x3ff156d0bfb9e461, 0x3ff17115ce7f9e68, 0x3ff18a904e7d996f, 0x3ff1a34d2b0e8883, 0x3ff1bb58104b2c06, 0x3ff1d2bb8cb43c8c
ALIGN 64
d_rx: dq 0x3fef07c200000000, 0x3fed41d420000000, 0x3febacf920000000, 0x3fea41a420000000, 0x3fe8f9c180000000, 0x3fe7d05f40000000, 0x3fe6c16c20000000, 0x3fe5c98820000000
    dq 0x3fe4e5e0a0000000, 0x3fe4141420000000, 0x3fe3521d00000000, 0x3fe29e4120000000, 0x3fe1f70480000000, 0x3fe15b1e60000000, 0x3fe0c97140000000, 0x3fe0410420000000
ALIGN 64
d_qr: dq 0x3ff0000000000000, 0x3ff4afd6a052bf5b, 0x3ff446f86562d9fb, 0x3ff3e22cbce4a902, 0x3ff3813813813814, 0x3ff323e34a2b10bf, 0x3ff2c9fb4d812ca0, 0x3ff27350b8812735
    dq 0x3ff21fb78121fb78, 0x3ff1cf06ada2811d, 0x3ff1811811811812, 0x3ff135c81135c811, 0x3ff0ecf56be69c90, 0x3ff0a6810a6810a7, 0x3ff0624dd2f1a9fc, 0x3ff0204081020408
ALIGN 64
d_qm: dq 0x0000000000000000, 0xc03d3910e415f736, 0xc03af2a8d08b69ad, 0xc038b7ac6146fda2, 0xc03687ab20f18534, 0xc034623af7fca31e, 0xc03246f7b3e4a94d, 0xc0303582996cf6ac
    dq 0xc02c5b0401534c23, 0xc0285d41f39cba61, 0xc024711df3b3e005, 0xc02095ff1ca43abf, 0xc01996a85d6a3742, 0xc01221261e1bf9bb, 0xc00594e146d4b4ad, 0xbfec8c6ccec5c86e
ALIGN 64
d_qt: dq 0x3ff0000000000000, 0x3ff0b5586cf9890f, 0x3ff172b83c7d517b, 0x3ff2387a6e756238, 0x3ff306fe0a31b715, 0x3ff3dea64c123422, 0x3ff4bfdad5362a27, 0x3ff5ab07dd485429
    dq 0x3ff6a09e667f3bcd, 0x3ff7a11473eb0187, 0x3ff8ace5422aa0db, 0x3ff9c49182a3f090, 0x3ffae89f995ad3ad, 0x3ffc199bdd85529c, 0x3ffd5818dcfba487, 0x3ffea4afa2a490da
ALIGN 64
d_t2l: dq 0x3fec0be94824afdd, 0x3fec4b4f9f91d8c7, 0x3fec8b454806e693, 0x3feccbcb857c2e1c, 0x3fed0ce39ec65b96, 0x3fed4e8edd9cea02, 0x3fed90ce8ea0a946, 0x3fedd3a401625306
    dq 0x3fee171088692e58, 0x3fee5b157939c281, 0x3fee9fb42c5c98cf, 0x3feee4edfd650dbd, 0x3fef2ac44af83184, 0x3fef713876d3b82e, 0x3fefb84be5d4f964, 0x3ff0000000000000
ALIGN 64
d_w2x: dq 0x4032b1de1410921a, 0x4032b570c3a4a345, 0x4032b8d13bce6432, 0x4032bc04bee397f7, 0x4032bf0fc5ac8874, 0x4032c1f625636a69, 0x4032c4bb2ea9dbad, 0x4032c761c3cdf6a5
    dq 0x4032c9ec6a42ad2e, 0x4032cc5d5ae8d5f1, 0x4032ceb68d9f6649, 0x4032d0f9c1d98f74, 0x4032d32887008882, 0x4032d544443e6597, 0x4032d74e3c8352c5, 0x4032d94792afcef9
ALIGN 64
d_rxl: dq 0x3fd62167110ab973, 0x3fd4ddaa496b7d1b, 0x3fd3bced36dcd37e, 0x3fd2b9cd57ec33ca, 0x3fd1cff5381de607, 0x3fd0fbddf1aa2edf, 0x3fd03aa0e8d7b395, 0x3fcf13abd733cb7c
    dq 0x3fcdcef33745df28, 0x3fcca3b29135b224, 0x3fcb8f0790bf555b, 0x3fca8e7b92a9ef0d, 0x3fc99ff090dc3ad7, 0x3fc8c1919f52e377, 0x3fc7f1c782e763b2, 0x3fc72f2f1087d41d
ALIGN 64
d_t1e: dq 0x3eab209157fb20ce, 0x3f10706c2631ef18, 0x3f73eca01f14802a, 0x3fd825faaede3a7d, 0x39f599803b0b693a, 0x3a5a2dc72cc3a4f2, 0x3abfba95302085b5, 0x3b233a4d4ff155a4
    dq 0x3b874dd9b68b7562, 0x3bec3ea2aed13ac4, 0x3c511dc7b462d726, 0x3cb4bebc53a069ba, 0x3d1924a23600f4fd, 0x3d7e793a06b5576f, 0x3de2778f3ddac989, 0x3e4661d25f65e8e6
ALIGN 64
d_w1m: dq 0x40255efa6cba6a19, 0x402eeb7f8516ed9a, 0x4035e9c46465e922, 0x403e7ea414a5e956, 0x4044deded8f8be79, 0x404c24c460811344, 0x4052b8286c237055, 0x405898403eca4e6b
    dq 0x405ff2d6e48c0443, 0x406488d99e96993b, 0x406a2495b08fa0e9, 0x40707e486aa7836a, 0x4074a384a91a397b, 0x4079a08eb4202877, 0x407f97add849df9e, 0x4083579632797cb4
ALIGN 64
d_qb: dq 0x3ff1de319919c21c, 0x3ed3f05391b43b71, 0x3efd2b1a7d4dbc0e, 0x3f2555cd268661b4, 0x3f4f360d6d3072da, 0x3f76d44fc48194aa, 0x3fa0b2d00fa8ade2, 0x3fc86d9c44e16362
ALIGN 64
d_lgt: dq 0x3ff734f0c3e0de9f, 0xbfd7cc7f79e69000, 0x3ff713786a2ce91f, 0xbfd76feec20d0000, 0x3ff6f26008fab5a0, 0xbfd713e31351e000, 0x3ff6d1a61f138c7d, 0xbfd6b85b38287800
    dq 0x3ff6b1490bc5b4d1, 0xbfd65d5590807800, 0x3ff69147332f0cba, 0xbfd602d076180000, 0x3ff6719f18224223, 0xbfd5a8ca86909000, 0x3ff6524f99a51ed9, 0xbfd54f4356035000
    dq 0x3ff63356aa8f24c4, 0xbfd4f637c36b4000, 0x3ff614b36b9ddc14, 0xbfd49da7fda85000, 0x3ff5f66452c65c4c, 0xbfd445923989a800, 0x3ff5d867b5912c4f, 0xbfd3edf439b0b800
    dq 0x3ff5babccb5b90de, 0xbfd396ce448f7000, 0x3ff59d61f2d91a78, 0xbfd3401e17bda000, 0x3ff5805612465687, 0xbfd2e9e2ef468000, 0x3ff56397cee76bd3, 0xbfd2941b3830e000
    dq 0x3ff54725e2a77f93, 0xbfd23ec58cda8800, 0x3ff52aff42064583, 0xbfd1e9e129279000, 0x3ff50f22dbb2bddf, 0xbfd1956d2b48f800, 0x3ff4f38f4734ded7, 0xbfd141679ab9f800
    dq 0x3ff4d843cfde2840, 0xbfd0edd094ef9800, 0x3ff4bd3ec078a3c8, 0xbfd09aa518db1000, 0x3ff4a27fc3e0258a, 0xbfd047e65263b800, 0x3ff4880524d48434, 0xbfcfeb224586f000
    dq 0x3ff46dce1b192d0b, 0xbfcf474a7517b000, 0x3ff453d9d3391854, 0xbfcea4443d103000, 0x3ff43a2744b4845a, 0xbfce020d44e9b000, 0x3ff420b54115f8fb, 0xbfcd60a22977f000
    dq 0x3ff40782da3ef4b1, 0xbfccc00104959000, 0x3ff3ee8f5d57fe8f, 0xbfcc202956891000, 0x3ff3d5d9a00b4ce9, 0xbfcb81178d811000, 0x3ff3bd60c010c12b, 0xbfcae2c9ccd3d000
    dq 0x3ff3a5242b75dab8, 0xbfca45402e129000, 0x3ff38d22cd9fd002, 0xbfc9a877681df000, 0x3ff3755bc5847a1c, 0xbfc90c6d69483000, 0x3ff35dce49ad36e2, 0xbfc87120a645c000
    dq 0x3ff34679984dd440, 0xbfc7d68fb4143000, 0x3ff32f5cceffcb24, 0xbfc73cb83c627000, 0x3ff3187775a10d49, 0xbfc6a39a9b376000, 0x3ff301c8373e3990, 0xbfc60b3154b7a000
    dq 0x3ff2eb4ebb95f841, 0xbfc5737d76243000, 0x3ff2d50a0219a9d1, 0xbfc4dc7b8fc23000, 0x3ff2bef9a8b7fd2a, 0xbfc4462c51d20000, 0x3ff2a91c7a0c1bab, 0xbfc3b08abc830000
    dq 0x3ff293726014b530, 0xbfc31b996b490000, 0x3ff27dfa5757a1f5, 0xbfc2875490a44000, 0x3ff268b39b1d3bbf, 0xbfc1f3b9f879a000, 0x3ff2539d838ff5bd, 0xbfc160c8252ca000
    dq 0x3ff23eb7aac9083b, 0xbfc0ce7f57f72000, 0x3ff22a012ba940b6, 0xbfc03cdc49fea000, 0x3ff2157996cc4132, 0xbfbf57bdbc4b8000, 0x3ff201201dd2fc9b, 0xbfbe370896404000
    dq 0x3ff1ecf4494d480b, 0xbfbd17983ef94000, 0x3ff1d8f5528f6569, 0xbfbbf9674ed8a000, 0x3ff1c52311577e7c, 0xbfbadc79202f6000, 0x3ff1b17c74cb26e9, 0xbfb9c0c3e7288000
    dq 0x3ff19e010c2c1ab6, 0xbfb8a646b372c000, 0x3ff18ab07bb670bd, 0xbfb78d01b3ac0000, 0x3ff1778a25efbcb6, 0xbfb674f145380000, 0x3ff1648d354c31da, 0xbfb55e0e6d878000
    dq 0x3ff151b990275fdd, 0xbfb4485cdea1e000, 0x3ff13f0ea432d24c, 0xbfb333d94d6aa000, 0x3ff12c8b7210f9da, 0xbfb22079f8c56000, 0x3ff11a3028ecb531, 0xbfb10e4698622000
    dq 0x3ff107fbda8434af, 0xbfaffa6c6ad20000, 0x3ff0f5ee0f4e6bb3, 0xbfadda8d4a774000, 0x3ff0e4065d2a9fce, 0xbfabbcece4850000, 0x3ff0d244632ca521, 0xbfa9a1894012c000
    dq 0x3ff0c0a77ce2981a, 0xbfa788583302c000, 0x3ff0af2f83c636d1, 0xbfa5715e67d68000, 0x3ff09ddb98a01339, 0xbfa35c8a49658000, 0x3ff08cabaf52e7df, 0xbfa149e364154000
    dq 0x3ff07b9f2f4e28fb, 0xbf9e72c082eb8000, 0x3ff06ab58c358f19, 0xbf9a55f152528000, 0x3ff059eea5ecf92c, 0xbf963d62cf818000, 0x3ff04949cdd12c90, 0xbf9228fb8caa0000
    dq 0x3ff038c6c6f0ada9, 0xbf8c317b20f90000, 0x3ff02865137932a9, 0xbf8419355daa0000, 0x3ff0182427ea7348, 0xbf781203c2ec0000, 0x3ff008040614b195, 0xbf60040979240000
    dq 0x3fefe01ff726fa1a, 0x3f6feff384900000, 0x3fefa11cc261ea74, 0x3f87dc41353d0000, 0x3fef6310b081992e, 0x3f93cea3c4c28000, 0x3fef25f63ceeadcd, 0x3f9b9fc114890000
    dq 0x3feee9c8039113e7, 0x3fa1b0d8ce110000, 0x3feeae8078cbb1ab, 0x3fa58a5bd001c000, 0x3fee741aa29d0c9b, 0x3fa95c8340d88000, 0x3fee3a91830a99b5, 0x3fad276aef578000
    dq 0x3fee01e009609a56, 0x3fb07598e598c000, 0x3fedca01e577bb98, 0x3fb253f5e30d2000, 0x3fed92f20b7c9103, 0x3fb42edd8b380000, 0x3fed5cac66fb5cce, 0x3fb606598757c000
    dq 0x3fed272caa5ede9d, 0x3fb7da76356a0000, 0x3fecf26e3e6b2ccd, 0x3fb9ab434e1c6000, 0x3fecbe6da2a77902, 0x3fbb78c7bb0d6000, 0x3fec8b266d37086d, 0x3fbd431332e72000
    dq 0x3fec5894bd5d5804, 0x3fbf0a3171de6000, 0x3fec26b533bb9f8c, 0x3fc067152b914000, 0x3febf583eeece73f, 0x3fc147858292b000, 0x3febc4fd75db96c1, 0x3fc2266ecdca3000
    dq 0x3feb951e0c864a28, 0x3fc303d7a6c55000, 0x3feb65e2c5ef3e2c, 0x3fc3dfc33c331000, 0x3feb374867c9888b, 0x3fc4ba366b7a8000, 0x3feb094b211d304a, 0x3fc5933928d1f000
    dq 0x3feadbe885f2ef7e, 0x3fc66acd2418f000, 0x3feaaf1d31603da2, 0x3fc740f8ec669000, 0x3fea82e63fd358a7, 0x3fc815c0f51af000, 0x3fea5740ef09738b, 0x3fc8e92954f68000
    dq 0x3fea2c2a90ab4b27, 0x3fc9bb3602f84000, 0x3fea01a01393f2d1, 0x3fca8bed1c2c0000, 0x3fe9d79f24db3c1b, 0x3fcb5b515c01d000, 0x3fe9ae2505c7b190, 0x3fcc2967ccbcc000
    dq 0x3fe9852ef297ce2f, 0x3fccf635d5486000, 0x3fe95cbaeea44b75, 0x3fcdc1bd3446c000, 0x3fe934c69de74838, 0x3fce8c01b8cfe000, 0x3fe90d4f2f6752e6, 0x3fcf5509c0179000
    dq 0x3fe8e6528effd79d, 0x3fd00e6c121fb800, 0x3fe8bfce9fcc007c, 0x3fd071b80e93d000, 0x3fe899c0dabec30e, 0x3fd0d46b9e867000, 0x3fe87427aa2317fb, 0x3fd13687334bd000
    dq 0x3fe84f00acb39a08, 0x3fd1980d67234800, 0x3fe82a49e8653e55, 0x3fd1f8ffe0cc8000, 0x3fe8060195f40260, 0x3fd2595fd7636800, 0x3fe7e22563e0a329, 0x3fd2b9300914a800
    dq 0x3fe7beb377dcb5ad, 0x3fd3187210436000, 0x3fe79baa679725c2, 0x3fd377266dec1800, 0x3fe77907f2170657, 0x3fd3d54ffbaf3000, 0x3fe756cadbd6130c, 0x3fd432eee32fe000
d_ln2: dq 0x3fe62e42fefa39ef, 0x3c7abc9e3b39803f
d_ysc: dq 0x3f52b404ad012b40, 0x3bf2b404ad012b40
d_yof: dq 0xbfb2b404ad012b40, 0xbc52b404ad012b40
d_rcr: dq 0x3f5af6d0319ebfcf, 0x3bf43b3769bc3d8c
d_gcr: dq 0xbf44e52bd4e4f7de, 0x3bca053cacc5f3b8
d_gcb: dq 0xbf28125fa148db8c, 0x3b96528147fe1ce0
d_bcb: dq 0x3f61338d13f41026, 0x3c08a9ececa1bbc5
d_kr: dq 0x3fd0d013a92a3055, 0x3c6930be0ded288d
d_kg: dq 0x3fe5b22d0e560419, 0xbc8b22d0e560418a
d_kb: dq 0x3fae5c91d14e3bcd, 0x3c3ad42c3c9eecc0
d_cbs: dq 0x407dc3db88960099, 0x3d1126c795f9a1c9
d_crs: dq 0x4082fcfab00971b6, 0x3d24928617f52abf
d_im2: dq 0x3f89f9b5860989b1, 0xbc26321fdc48a668
d_im1: dq 0x40191c0d56e7162b, 0xbcae1ca3ff371f95
d_k12: dq 0x40231bbd7150945f, 0xbcc6f2d9a4fd8920
d_m12d: dq 0x40291eb180000000, 0x0000000000000000
ALIGN 64
d_ex: dq 0x3ff0000000000000, 0x0000000000000000, 0x3ff0000000000000, 0x0000000000000000, 0x3fe0000000000000, 0x0000000000000000, 0x3fc5555555555555, 0x3c65555555555555
    dq 0x3fa5555555555555, 0x3c45555555555555, 0x3f81111111111111, 0x3c01111111111111, 0x3f56c16c16c16c17, 0xbbef49f49f49f49f, 0x3f2a01a01a01a01a, 0x3b6a01a01a01a01a
    dq 0x3efa01a01a01a01a, 0x3b3a01a01a01a01a
d_lg0: dq 0x3fe62e42fefa3800
d_lg1: dq 0x3d2ef35793c76730
d_lg2: dq 0xbfe0000000000001
d_lg3: dq 0x3fd555555551305b
d_lg4: dq 0xbfcfffffffeb4590
d_lg5: dq 0x3fc999b324f10111
d_lg6: dq 0xbfc55575e506c89f
d_lg7: dq 0xbfe0000000000000
d_lg8: dq 0x3fd5555555555577
d_lg9: dq 0xbfcffffffffffdcb
d_lg10: dq 0x3fc999999995dd0c
d_lg11: dq 0xbfc55555556745a7
d_lg12: dq 0x3fc24924a344de30
d_lg13: dq 0xbfbfffffa4423d65
d_lg14: dq 0x3fbc7184282ad6ca
d_lg15: dq 0xbfb999eb43b068ff
d_lg16: dq 0x3fb78182f7afd085
d_lg17: dq 0xbfb5521375d145cd
d_mc1: dq 0xbfeac00000000000
d_mone: dq 0xbff0000000000000
d_mzero: dq 0x8000000000000000
d_2p20: dq 0x4130000000000000
d_i1024: dq 0x3f50000000000000
d_1024: dq 0x4090000000000000
d_ys: dq 0x408b600000000000
d_yb: dq 0x4050000000000000
d_512: dq 0x4080000000000000
d_120: dq 0x405e000000000000
d_1023: dq 0x408ff80000000000
d_16: dq 0x4030000000000000
d_q4: dq 0x3fd0000000000000
d_q16: dq 0x3fb0000000000000
d_2p27: dq 0x41a0000000000000
d_m63: dq 0xc3e0000000000000
d_p63: dq 0x43e0000000000000
d_epd: dq 0x3bc79ca10c924223
d_tab: dq 0x3d30e374a4f8e0b4
d_tab2: dq 0x3a095a5efea6b347
d_omg: dq 0x3ddb7cdfd9d7bdbb
d_eq0: dq 0x3fe5b3883126e979
d_rg2: dq 0x3dde3c8fd606ea4e
d_c1: dq 0x3feac00000000000
d_c2: dq 0x4032da0000000000
d_c3: dq 0x4032b00000000000
d_m1: dq 0x3fc4640000000000
d_m2: dq 0x4053b60000000000
d_c13: dq 0x402f3e4000000000
d_c2c: dq 0x4009d70000000000
d_laq: dq 0x3fd6d2723e29d620
d_t2k: dq 0x3febcd11009d0551
d_zz: dq 0x3e10000000000000
d_m12: dq 0x3fbacb6800000000
d_flo: dq 0x3f40000000000000
d_qtk: dq 0x42f8000000000000
d_k7: dq 0x400f1bc14e5e0a73
d_k7s: dq 0x4040a1b646d223fe
d_k7m: dq 0x400f3cd0bd7d6344
d_sga: dq 0x3eb0000000000000
d_rgl: dq 0x3ec70fe360118d25
d_anl: dq 0x3ab70ff27d3d9fde
d_kvl: dq 0x3bd0000000000000
d_sll: dq 0x404ffffffffdda3f
d_shl: dq 0x40500000000112e1
d_rgh: dq 0x3ec80fe3879f7e66
d_anh: dq 0x3a980ff34c915753
d_kvh: dq 0x3bb0000000000000
d_slh: dq 0x407fffffffffbb48
d_shh: dq 0x408000000000225c
d_abs: dq 0x7fffffffffffffff
d_mant: dq 0x000fffffffffffff
d_hm: dq 0x3fdfffffffffffff
d_q1023: dq 0x00000000000003ff
d_i15: dq 0x000000000000000f
d_i16: dq 0x0000000000000010
d_lmx: dq 0x4012000000000000
d_lhx: dq 0x8003090000000000
d_lof: dq 0xc01a000000000000
d_lfe: dq 0x00000000000000fe
d_lhm: dq 0xfff0000000000000
d_xys: dq 0x000000000000036c
d_xyb: dq 0x0000000000000040
d_xec: dq 0x0000088b80000000
d_xdr: dq 0x001d3d5a00000000
d_xdg: dq 0x0664db9800000000, 0x0000000000000003
d_qp0: dq 0x3feffffffffff097
d_qp1: dq 0x3fc46400000165ce
d_qp2: dq 0xbfb12471bb2051ea
d_qp3: dq 0x3fa50933190a13a2
d_qp4: dq 0xbf9de76696e41750
d_qp5: dq 0x3f96fb03e0af34c6
d_ql0: dq 0x405c6fd6d44277ae
d_ql1: dq 0xc04c6fd6d3ba234b
d_ql2: dq 0x4042f539e8af943e
d_ql3: dq 0xc03c706e7b8e30dd
d_ql4: dq 0x4036bdffc98133bb
d_qe0: dq 0x3feffffffffffe6c
d_qe1: dq 0x3fe62e42fec39e1c
d_qe2: dq 0x3fcebfbe00336db2
d_qe3: dq 0x3fac6b3f73e213d6
d_qe4: dq 0x3f83b292330a1d9b
d_q2x0: dq 0xbfa235f3e7069aca
d_q2x1: dq 0x3fa935dc3d576fd0
d_q2x2: dq 0xbfb76a9a56aedcd5
d_q2x3: dq 0x3fc8855b936361e4
d_q2x4: dq 0xbfdb744cd90af0cf
d_p1m0: dq 0x3fbd100c0ed9ca12
d_p1m1: dq 0x3fe6ce03937ea8e3
d_p1m2: dq 0x3ffe16602048862b
d_p1m3: dq 0x40057304b0a6fcf8
d_p1m4: dq 0x400193a8174864b6
d_emc0: dq 0x406cc401a36e2eb2
d_emc1: dq 0x40828f6c8b439581
d_emc2: dq 0x4049f930be0ded29
d_emc3: dq 0x407c000000000000
d_emc4: dq 0x405f46f241cd8bb0
d_emc5: dq 0x40742e436f8c9d14
d_emc7: dq 0x4079bf7ce4774d65
d_emc8: dq 0x40420418dc4594da
ALIGN 32
d_iot: dd 0, 1, 2, 3, 4, 5, 6, 7
d_pi1: dd 1, 2, 3, 4, 5, 6, 7, 7
d_po: dd 0, 2, 1, 3, 0, 0, 0, 0
d_yp: db 0, 1, 0, 1, 2, 3, 4, 5, 8, 9, 8, 9, 10, 11, 12, 13, 0, 1, 0, 1, 2, 3, 4, 5, 8, 9, 8, 9, 10, 11, 12, 13

ALIGN 64
const pqf
 dd 0x3f70f0f1, 0x3f579436, 0x3f430c31, 0x3f321643, 0x3f23d70a, 0x3f17b426, 0x3f0d3dcb, 0x3f042108
 dd 0x3a49a543, 0x3b0f0004, 0x3b626cdd, 0x3b972c73, 0x3bba0183, 0x3bda304f, 0x3bf8194e, 0x3c0a04da
 dd 0x3e359ace, 0x3e2e163b, 0x3e2680aa, 0x3e1ed9f3, 0x3e1721f1, 0x3e0f587c, 0x3e077d6d, 0x3dff2136
 dd 0x3def23bf, 0x3ddf0223, 0x3dcebc0f, 0x3dbe5132, 0x3dadc139, 0x3d9d0bce, 0x3d8c309f, 0x3d765eaa
 dd 0x3d540f34, 0x3d317230, 0x3d0e86ec, 0x3cd69974, 0x3c8f85cb, 0x7fc00000, 0x7fc00000, 0x7fc00000
 dd 0x498545d0, 0x4ca186ee, 0x4fc3c580, 0x52ed469e, 0x560fca27, 0x592e460f, 0x5c53386c, 0x7fc00000
 dd 0x3fbb4734, 0x403c3a6a, 0x40b0672a, 0x411c214e, 0x4183c1e1, 0x41d5980a, 0x422740ae, 0x427e3550
 dd 0x3f688ddf, 0x3f81da1f, 0x3f910306, 0x3fa1f102, 0x3fb4d8f8, 0x3fc9f5fa, 0x3fe18a01, 0x3ffbdeb7
 dd 0x3f3a78fa, 0x3f503e1a, 0x3f688ddf, 0x3f81da1f, 0x3f910306, 0x3fa1f102, 0x3fb4d8f8, 0x3fc9f5fa
 dd 0x3f800000, 0x401ad0fd, 0x40bb4035, 0x41627af9, 0x3cef3eab, 0x3d90af02, 0x3e2efec8, 0x3ed3a840
 dd 0x3f813d44, 0x3f838ea1, 0x3f85ab83, 0x3f879faa, 0x3f896e02, 0x3f8b21d7, 0x3f8cbab3, 0x3f8e3b95
 dd 0x3f70f976, 0x3f578816, 0x3f4304a7, 0x3f320a28, 0x3f23da2f, 0x3f17aa6f, 0x3f0d2de9, 0x3f0411a2
 dd 0x3f8df150, 0x3ebd9597, 0x3df953fa, 0x3d215c39, 0x3c4d7708, 0x3b80a003, 0x3a9e454a, 0x39bf4b8d
 dd 0x3e280000, 0x3e2a5a84, 0x3e2cc626, 0x3e2f43a5, 0x3e31d3ca, 0x3e347768, 0x3e372f61, 0x3e39fca5
 dd 0x00000000, 0x3c65876e, 0x3ce8ca4e, 0x3d311bef, 0x3d6f9951, 0x3d97f8c3, 0x3db91d04, 0x3ddb44cd
 dd 0x40000000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000, 0x3f800000
 times 8 dd 0x3f800000
 times 8 dd 0x3dbe533b
 times 8 dd 0x3c4fcd9c
 times 8 dd 0xbbcd2ad9
 times 8 dd 0x3b88551b
 times 8 dd 0xbb4bb48f
 times 8 dd 0x3f811fae
 times 8 dd 0x3c17895c
 times 8 dd 0x3d5b2f17
 times 8 dd 0x40c8dffc
 times 8 dd 0x41848358
 times 8 dd 0x41bd4d92
 times 8 dd 0x419ae21a
 times 8 dd 0x36a6bc67
 times 8 dd 0x4a871ba5
 times 8 dd 0x3626bbf9
 times 8 dd 0x50800000
 times 8 dd 0x60800000
 times 8 dd 0x35000054
 times 8 dd 0x34e00093
 times 8 dd 0x3510005e
 times 8 dd 0x43725825
 times 8 dd 0x441c5db5
 times 8 dd 0x425ad1fa
 times 8 dd 0x36aebc72
 times 8 dd 0x4b871ba5
 times 8 dd 0x362ebbff
 times 8 dd 0x51800000
 times 8 dd 0x61800000
 times 8 dd 0x43e6a0de
 times 8 dd 0x4300cf85
 times 8 dd 0x43a6391c
 times 8 dd 0x43d4144b
 times 8 dd 0x42146497
 times 8 dd 0xbfbcbe96
 times 8 dd 0x3f2d9c42
 times 8 dd 0x3e231ffc
 times 8 dd 0xbd8950a7
 times 8 dd 0x3d28a557
 times 8 dd 0x3f81da1f
 times 8 dd 0x41958000
 times 8 dd 0x413e0000
 times 8 dd 0x4b400000
 times 8 dd 0xc29db00e
 times 8 dd 0x453fcbf6
 times 8 dd 0xc799807c
 times 8 dd 0x49b5ec4a
 times 8 dd 0xcbacc630
 times 8 dd 0x4d845d1f
 times 8 dd 0x33c17d7f
 times 8 dd 0x34800000
 times 8 dd 0x3f000000
 times 8 dd 0x3d800000
 times 8 dd 0x3f100000
 times 8 dd 0x41c00000
 times 8 dd 0xbed013a9
 times 8 dd 0x41100000
 times 8 dd 0x3e110cb5
 times 8 dd 0x40200000
 times 8 dd 0x3e0809d7
 times 8 dd 0x41f00000
 times 8 dd 0x3dd1b717
 times 8 dd 0x80000000
 times 8 dd 0x007fffff
 times 8 dd 0x00000000
 times 8 dd 0x00000000
 times 8 dd 0x00000200
 times 8 dd 0x03ff03ff
 times 8 dd 0x00000000
 dd 0, 4, 1, 5, 2, 6, 3, 7
 dd 0, 2, 8, 10, 4, 6, 12, 14
 db 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0
    db 1, 0, 0, 0, 0, 0, 0, 0
    db 0, 1, 0, 0, 0, 0, 0, 0
    db 2, 0, 0, 0, 0, 0, 0, 0
    db 0, 2, 0, 0, 0, 0, 0, 0
    db 1, 2, 0, 0, 0, 0, 0, 0
    db 0, 1, 2, 0, 0, 0, 0, 0
    db 3, 0, 0, 0, 0, 0, 0, 0
    db 0, 3, 0, 0, 0, 0, 0, 0
    db 1, 3, 0, 0, 0, 0, 0, 0
    db 0, 1, 3, 0, 0, 0, 0, 0
    db 2, 3, 0, 0, 0, 0, 0, 0
    db 0, 2, 3, 0, 0, 0, 0, 0
    db 1, 2, 3, 0, 0, 0, 0, 0
    db 0, 1, 2, 3, 0, 0, 0, 0
    db 4, 0, 0, 0, 0, 0, 0, 0
    db 0, 4, 0, 0, 0, 0, 0, 0
    db 1, 4, 0, 0, 0, 0, 0, 0
    db 0, 1, 4, 0, 0, 0, 0, 0
    db 2, 4, 0, 0, 0, 0, 0, 0
    db 0, 2, 4, 0, 0, 0, 0, 0
    db 1, 2, 4, 0, 0, 0, 0, 0
    db 0, 1, 2, 4, 0, 0, 0, 0
    db 3, 4, 0, 0, 0, 0, 0, 0
    db 0, 3, 4, 0, 0, 0, 0, 0
    db 1, 3, 4, 0, 0, 0, 0, 0
    db 0, 1, 3, 4, 0, 0, 0, 0
    db 2, 3, 4, 0, 0, 0, 0, 0
    db 0, 2, 3, 4, 0, 0, 0, 0
    db 1, 2, 3, 4, 0, 0, 0, 0
    db 0, 1, 2, 3, 4, 0, 0, 0
    db 5, 0, 0, 0, 0, 0, 0, 0
    db 0, 5, 0, 0, 0, 0, 0, 0
    db 1, 5, 0, 0, 0, 0, 0, 0
    db 0, 1, 5, 0, 0, 0, 0, 0
    db 2, 5, 0, 0, 0, 0, 0, 0
    db 0, 2, 5, 0, 0, 0, 0, 0
    db 1, 2, 5, 0, 0, 0, 0, 0
    db 0, 1, 2, 5, 0, 0, 0, 0
    db 3, 5, 0, 0, 0, 0, 0, 0
    db 0, 3, 5, 0, 0, 0, 0, 0
    db 1, 3, 5, 0, 0, 0, 0, 0
    db 0, 1, 3, 5, 0, 0, 0, 0
    db 2, 3, 5, 0, 0, 0, 0, 0
    db 0, 2, 3, 5, 0, 0, 0, 0
    db 1, 2, 3, 5, 0, 0, 0, 0
    db 0, 1, 2, 3, 5, 0, 0, 0
    db 4, 5, 0, 0, 0, 0, 0, 0
    db 0, 4, 5, 0, 0, 0, 0, 0
    db 1, 4, 5, 0, 0, 0, 0, 0
    db 0, 1, 4, 5, 0, 0, 0, 0
    db 2, 4, 5, 0, 0, 0, 0, 0
    db 0, 2, 4, 5, 0, 0, 0, 0
    db 1, 2, 4, 5, 0, 0, 0, 0
    db 0, 1, 2, 4, 5, 0, 0, 0
    db 3, 4, 5, 0, 0, 0, 0, 0
    db 0, 3, 4, 5, 0, 0, 0, 0
    db 1, 3, 4, 5, 0, 0, 0, 0
    db 0, 1, 3, 4, 5, 0, 0, 0
    db 2, 3, 4, 5, 0, 0, 0, 0
    db 0, 2, 3, 4, 5, 0, 0, 0
    db 1, 2, 3, 4, 5, 0, 0, 0
    db 0, 1, 2, 3, 4, 5, 0, 0
    db 6, 0, 0, 0, 0, 0, 0, 0
    db 0, 6, 0, 0, 0, 0, 0, 0
    db 1, 6, 0, 0, 0, 0, 0, 0
    db 0, 1, 6, 0, 0, 0, 0, 0
    db 2, 6, 0, 0, 0, 0, 0, 0
    db 0, 2, 6, 0, 0, 0, 0, 0
    db 1, 2, 6, 0, 0, 0, 0, 0
    db 0, 1, 2, 6, 0, 0, 0, 0
    db 3, 6, 0, 0, 0, 0, 0, 0
    db 0, 3, 6, 0, 0, 0, 0, 0
    db 1, 3, 6, 0, 0, 0, 0, 0
    db 0, 1, 3, 6, 0, 0, 0, 0
    db 2, 3, 6, 0, 0, 0, 0, 0
    db 0, 2, 3, 6, 0, 0, 0, 0
    db 1, 2, 3, 6, 0, 0, 0, 0
    db 0, 1, 2, 3, 6, 0, 0, 0
    db 4, 6, 0, 0, 0, 0, 0, 0
    db 0, 4, 6, 0, 0, 0, 0, 0
    db 1, 4, 6, 0, 0, 0, 0, 0
    db 0, 1, 4, 6, 0, 0, 0, 0
    db 2, 4, 6, 0, 0, 0, 0, 0
    db 0, 2, 4, 6, 0, 0, 0, 0
    db 1, 2, 4, 6, 0, 0, 0, 0
    db 0, 1, 2, 4, 6, 0, 0, 0
    db 3, 4, 6, 0, 0, 0, 0, 0
    db 0, 3, 4, 6, 0, 0, 0, 0
    db 1, 3, 4, 6, 0, 0, 0, 0
    db 0, 1, 3, 4, 6, 0, 0, 0
    db 2, 3, 4, 6, 0, 0, 0, 0
    db 0, 2, 3, 4, 6, 0, 0, 0
    db 1, 2, 3, 4, 6, 0, 0, 0
    db 0, 1, 2, 3, 4, 6, 0, 0
    db 5, 6, 0, 0, 0, 0, 0, 0
    db 0, 5, 6, 0, 0, 0, 0, 0
    db 1, 5, 6, 0, 0, 0, 0, 0
    db 0, 1, 5, 6, 0, 0, 0, 0
    db 2, 5, 6, 0, 0, 0, 0, 0
    db 0, 2, 5, 6, 0, 0, 0, 0
    db 1, 2, 5, 6, 0, 0, 0, 0
    db 0, 1, 2, 5, 6, 0, 0, 0
    db 3, 5, 6, 0, 0, 0, 0, 0
    db 0, 3, 5, 6, 0, 0, 0, 0
    db 1, 3, 5, 6, 0, 0, 0, 0
    db 0, 1, 3, 5, 6, 0, 0, 0
    db 2, 3, 5, 6, 0, 0, 0, 0
    db 0, 2, 3, 5, 6, 0, 0, 0
    db 1, 2, 3, 5, 6, 0, 0, 0
    db 0, 1, 2, 3, 5, 6, 0, 0
    db 4, 5, 6, 0, 0, 0, 0, 0
    db 0, 4, 5, 6, 0, 0, 0, 0
    db 1, 4, 5, 6, 0, 0, 0, 0
    db 0, 1, 4, 5, 6, 0, 0, 0
    db 2, 4, 5, 6, 0, 0, 0, 0
    db 0, 2, 4, 5, 6, 0, 0, 0
    db 1, 2, 4, 5, 6, 0, 0, 0
    db 0, 1, 2, 4, 5, 6, 0, 0
    db 3, 4, 5, 6, 0, 0, 0, 0
    db 0, 3, 4, 5, 6, 0, 0, 0
    db 1, 3, 4, 5, 6, 0, 0, 0
    db 0, 1, 3, 4, 5, 6, 0, 0
    db 2, 3, 4, 5, 6, 0, 0, 0
    db 0, 2, 3, 4, 5, 6, 0, 0
    db 1, 2, 3, 4, 5, 6, 0, 0
    db 0, 1, 2, 3, 4, 5, 6, 0
    db 7, 0, 0, 0, 0, 0, 0, 0
    db 0, 7, 0, 0, 0, 0, 0, 0
    db 1, 7, 0, 0, 0, 0, 0, 0
    db 0, 1, 7, 0, 0, 0, 0, 0
    db 2, 7, 0, 0, 0, 0, 0, 0
    db 0, 2, 7, 0, 0, 0, 0, 0
    db 1, 2, 7, 0, 0, 0, 0, 0
    db 0, 1, 2, 7, 0, 0, 0, 0
    db 3, 7, 0, 0, 0, 0, 0, 0
    db 0, 3, 7, 0, 0, 0, 0, 0
    db 1, 3, 7, 0, 0, 0, 0, 0
    db 0, 1, 3, 7, 0, 0, 0, 0
    db 2, 3, 7, 0, 0, 0, 0, 0
    db 0, 2, 3, 7, 0, 0, 0, 0
    db 1, 2, 3, 7, 0, 0, 0, 0
    db 0, 1, 2, 3, 7, 0, 0, 0
    db 4, 7, 0, 0, 0, 0, 0, 0
    db 0, 4, 7, 0, 0, 0, 0, 0
    db 1, 4, 7, 0, 0, 0, 0, 0
    db 0, 1, 4, 7, 0, 0, 0, 0
    db 2, 4, 7, 0, 0, 0, 0, 0
    db 0, 2, 4, 7, 0, 0, 0, 0
    db 1, 2, 4, 7, 0, 0, 0, 0
    db 0, 1, 2, 4, 7, 0, 0, 0
    db 3, 4, 7, 0, 0, 0, 0, 0
    db 0, 3, 4, 7, 0, 0, 0, 0
    db 1, 3, 4, 7, 0, 0, 0, 0
    db 0, 1, 3, 4, 7, 0, 0, 0
    db 2, 3, 4, 7, 0, 0, 0, 0
    db 0, 2, 3, 4, 7, 0, 0, 0
    db 1, 2, 3, 4, 7, 0, 0, 0
    db 0, 1, 2, 3, 4, 7, 0, 0
    db 5, 7, 0, 0, 0, 0, 0, 0
    db 0, 5, 7, 0, 0, 0, 0, 0
    db 1, 5, 7, 0, 0, 0, 0, 0
    db 0, 1, 5, 7, 0, 0, 0, 0
    db 2, 5, 7, 0, 0, 0, 0, 0
    db 0, 2, 5, 7, 0, 0, 0, 0
    db 1, 2, 5, 7, 0, 0, 0, 0
    db 0, 1, 2, 5, 7, 0, 0, 0
    db 3, 5, 7, 0, 0, 0, 0, 0
    db 0, 3, 5, 7, 0, 0, 0, 0
    db 1, 3, 5, 7, 0, 0, 0, 0
    db 0, 1, 3, 5, 7, 0, 0, 0
    db 2, 3, 5, 7, 0, 0, 0, 0
    db 0, 2, 3, 5, 7, 0, 0, 0
    db 1, 2, 3, 5, 7, 0, 0, 0
    db 0, 1, 2, 3, 5, 7, 0, 0
    db 4, 5, 7, 0, 0, 0, 0, 0
    db 0, 4, 5, 7, 0, 0, 0, 0
    db 1, 4, 5, 7, 0, 0, 0, 0
    db 0, 1, 4, 5, 7, 0, 0, 0
    db 2, 4, 5, 7, 0, 0, 0, 0
    db 0, 2, 4, 5, 7, 0, 0, 0
    db 1, 2, 4, 5, 7, 0, 0, 0
    db 0, 1, 2, 4, 5, 7, 0, 0
    db 3, 4, 5, 7, 0, 0, 0, 0
    db 0, 3, 4, 5, 7, 0, 0, 0
    db 1, 3, 4, 5, 7, 0, 0, 0
    db 0, 1, 3, 4, 5, 7, 0, 0
    db 2, 3, 4, 5, 7, 0, 0, 0
    db 0, 2, 3, 4, 5, 7, 0, 0
    db 1, 2, 3, 4, 5, 7, 0, 0
    db 0, 1, 2, 3, 4, 5, 7, 0
    db 6, 7, 0, 0, 0, 0, 0, 0
    db 0, 6, 7, 0, 0, 0, 0, 0
    db 1, 6, 7, 0, 0, 0, 0, 0
    db 0, 1, 6, 7, 0, 0, 0, 0
    db 2, 6, 7, 0, 0, 0, 0, 0
    db 0, 2, 6, 7, 0, 0, 0, 0
    db 1, 2, 6, 7, 0, 0, 0, 0
    db 0, 1, 2, 6, 7, 0, 0, 0
    db 3, 6, 7, 0, 0, 0, 0, 0
    db 0, 3, 6, 7, 0, 0, 0, 0
    db 1, 3, 6, 7, 0, 0, 0, 0
    db 0, 1, 3, 6, 7, 0, 0, 0
    db 2, 3, 6, 7, 0, 0, 0, 0
    db 0, 2, 3, 6, 7, 0, 0, 0
    db 1, 2, 3, 6, 7, 0, 0, 0
    db 0, 1, 2, 3, 6, 7, 0, 0
    db 4, 6, 7, 0, 0, 0, 0, 0
    db 0, 4, 6, 7, 0, 0, 0, 0
    db 1, 4, 6, 7, 0, 0, 0, 0
    db 0, 1, 4, 6, 7, 0, 0, 0
    db 2, 4, 6, 7, 0, 0, 0, 0
    db 0, 2, 4, 6, 7, 0, 0, 0
    db 1, 2, 4, 6, 7, 0, 0, 0
    db 0, 1, 2, 4, 6, 7, 0, 0
    db 3, 4, 6, 7, 0, 0, 0, 0
    db 0, 3, 4, 6, 7, 0, 0, 0
    db 1, 3, 4, 6, 7, 0, 0, 0
    db 0, 1, 3, 4, 6, 7, 0, 0
    db 2, 3, 4, 6, 7, 0, 0, 0
    db 0, 2, 3, 4, 6, 7, 0, 0
    db 1, 2, 3, 4, 6, 7, 0, 0
    db 0, 1, 2, 3, 4, 6, 7, 0
    db 5, 6, 7, 0, 0, 0, 0, 0
    db 0, 5, 6, 7, 0, 0, 0, 0
    db 1, 5, 6, 7, 0, 0, 0, 0
    db 0, 1, 5, 6, 7, 0, 0, 0
    db 2, 5, 6, 7, 0, 0, 0, 0
    db 0, 2, 5, 6, 7, 0, 0, 0
    db 1, 2, 5, 6, 7, 0, 0, 0
    db 0, 1, 2, 5, 6, 7, 0, 0
    db 3, 5, 6, 7, 0, 0, 0, 0
    db 0, 3, 5, 6, 7, 0, 0, 0
    db 1, 3, 5, 6, 7, 0, 0, 0
    db 0, 1, 3, 5, 6, 7, 0, 0
    db 2, 3, 5, 6, 7, 0, 0, 0
    db 0, 2, 3, 5, 6, 7, 0, 0
    db 1, 2, 3, 5, 6, 7, 0, 0
    db 0, 1, 2, 3, 5, 6, 7, 0
    db 4, 5, 6, 7, 0, 0, 0, 0
    db 0, 4, 5, 6, 7, 0, 0, 0
    db 1, 4, 5, 6, 7, 0, 0, 0
    db 0, 1, 4, 5, 6, 7, 0, 0
    db 2, 4, 5, 6, 7, 0, 0, 0
    db 0, 2, 4, 5, 6, 7, 0, 0
    db 1, 2, 4, 5, 6, 7, 0, 0
    db 0, 1, 2, 4, 5, 6, 7, 0
    db 3, 4, 5, 6, 7, 0, 0, 0
    db 0, 3, 4, 5, 6, 7, 0, 0
    db 1, 3, 4, 5, 6, 7, 0, 0
    db 0, 1, 3, 4, 5, 6, 7, 0
    db 2, 3, 4, 5, 6, 7, 0, 0
    db 0, 2, 3, 4, 5, 6, 7, 0
    db 1, 2, 3, 4, 5, 6, 7, 0
    db 0, 1, 2, 3, 4, 5, 6, 7
ALIGN 64
 dq 0x3ff0000000000000, 0x3ff1de319919c21c, 0x3ff3f437064906bc, 0x3ff64894ccfcbd7b, 0x3ff8e2923dea5e85, 0x3ffbca5032e29c46, 0x3fff08e27453c641, 0x400154360ae9be90
    dq 0x40035a1f912671b1, 0x40059c7ffd64702f, 0x400822666b29d368, 0x400af3b4ef34cb10, 0x400e193938df06c8, 0x4010ce6409d179ce, 0x4012c4ae0f59d4f5, 0x4014f59c0d507726
ALIGN 64
 dq 0x3ff01420b6386eae, 0x3ff03ae42abf992e, 0x3ff05fd5cfa98838, 0x3ff08323028502d9, 0x3ff0a4f2a4d1421c, 0x3ff0c56649698dda, 0x3ff0e49b3120fcfe, 0x3ff102aafc0ae0bc
    dq 0x3ff11fac34abacad, 0x3ff13bb2da57c65c, 0x3ff156d0bfb9e461, 0x3ff17115ce7f9e68, 0x3ff18a904e7d996f, 0x3ff1a34d2b0e8883, 0x3ff1bb58104b2c06, 0x3ff1d2bb8cb43c8c
ALIGN 64
 dq 0x3fef07c200000000, 0x3fed41d420000000, 0x3febacf920000000, 0x3fea41a420000000, 0x3fe8f9c180000000, 0x3fe7d05f40000000, 0x3fe6c16c20000000, 0x3fe5c98820000000
    dq 0x3fe4e5e0a0000000, 0x3fe4141420000000, 0x3fe3521d00000000, 0x3fe29e4120000000, 0x3fe1f70480000000, 0x3fe15b1e60000000, 0x3fe0c97140000000, 0x3fe0410420000000
ALIGN 64
 dq 0x3ff0000000000000, 0x3ff4afd6a052bf5b, 0x3ff446f86562d9fb, 0x3ff3e22cbce4a902, 0x3ff3813813813814, 0x3ff323e34a2b10bf, 0x3ff2c9fb4d812ca0, 0x3ff27350b8812735
    dq 0x3ff21fb78121fb78, 0x3ff1cf06ada2811d, 0x3ff1811811811812, 0x3ff135c81135c811, 0x3ff0ecf56be69c90, 0x3ff0a6810a6810a7, 0x3ff0624dd2f1a9fc, 0x3ff0204081020408
ALIGN 64
 dq 0x0000000000000000, 0xc03d3910e415f736, 0xc03af2a8d08b69ad, 0xc038b7ac6146fda2, 0xc03687ab20f18534, 0xc034623af7fca31e, 0xc03246f7b3e4a94d, 0xc0303582996cf6ac
    dq 0xc02c5b0401534c23, 0xc0285d41f39cba61, 0xc024711df3b3e005, 0xc02095ff1ca43abf, 0xc01996a85d6a3742, 0xc01221261e1bf9bb, 0xc00594e146d4b4ad, 0xbfec8c6ccec5c86e
ALIGN 64
 dq 0x3ff0000000000000, 0x3ff0b5586cf9890f, 0x3ff172b83c7d517b, 0x3ff2387a6e756238, 0x3ff306fe0a31b715, 0x3ff3dea64c123422, 0x3ff4bfdad5362a27, 0x3ff5ab07dd485429
    dq 0x3ff6a09e667f3bcd, 0x3ff7a11473eb0187, 0x3ff8ace5422aa0db, 0x3ff9c49182a3f090, 0x3ffae89f995ad3ad, 0x3ffc199bdd85529c, 0x3ffd5818dcfba487, 0x3ffea4afa2a490da
ALIGN 64
 dq 0x3fec0be94824afdd, 0x3fec4b4f9f91d8c7, 0x3fec8b454806e693, 0x3feccbcb857c2e1c, 0x3fed0ce39ec65b96, 0x3fed4e8edd9cea02, 0x3fed90ce8ea0a946, 0x3fedd3a401625306
    dq 0x3fee171088692e58, 0x3fee5b157939c281, 0x3fee9fb42c5c98cf, 0x3feee4edfd650dbd, 0x3fef2ac44af83184, 0x3fef713876d3b82e, 0x3fefb84be5d4f964, 0x3ff0000000000000
ALIGN 64
 dq 0x4032b1de1410921a, 0x4032b570c3a4a345, 0x4032b8d13bce6432, 0x4032bc04bee397f7, 0x4032bf0fc5ac8874, 0x4032c1f625636a69, 0x4032c4bb2ea9dbad, 0x4032c761c3cdf6a5
    dq 0x4032c9ec6a42ad2e, 0x4032cc5d5ae8d5f1, 0x4032ceb68d9f6649, 0x4032d0f9c1d98f74, 0x4032d32887008882, 0x4032d544443e6597, 0x4032d74e3c8352c5, 0x4032d94792afcef9
ALIGN 64
 dq 0x3fd62167110ab973, 0x3fd4ddaa496b7d1b, 0x3fd3bced36dcd37e, 0x3fd2b9cd57ec33ca, 0x3fd1cff5381de607, 0x3fd0fbddf1aa2edf, 0x3fd03aa0e8d7b395, 0x3fcf13abd733cb7c
    dq 0x3fcdcef33745df28, 0x3fcca3b29135b224, 0x3fcb8f0790bf555b, 0x3fca8e7b92a9ef0d, 0x3fc99ff090dc3ad7, 0x3fc8c1919f52e377, 0x3fc7f1c782e763b2, 0x3fc72f2f1087d41d
ALIGN 64
 dq 0x3eab209157fb20ce, 0x3f10706c2631ef18, 0x3f73eca01f14802a, 0x3fd825faaede3a7d, 0x39f599803b0b693a, 0x3a5a2dc72cc3a4f2, 0x3abfba95302085b5, 0x3b233a4d4ff155a4
    dq 0x3b874dd9b68b7562, 0x3bec3ea2aed13ac4, 0x3c511dc7b462d726, 0x3cb4bebc53a069ba, 0x3d1924a23600f4fd, 0x3d7e793a06b5576f, 0x3de2778f3ddac989, 0x3e4661d25f65e8e6
ALIGN 64
 dq 0x40255efa6cba6a19, 0x402eeb7f8516ed9a, 0x4035e9c46465e922, 0x403e7ea414a5e956, 0x4044deded8f8be79, 0x404c24c460811344, 0x4052b8286c237055, 0x405898403eca4e6b
    dq 0x405ff2d6e48c0443, 0x406488d99e96993b, 0x406a2495b08fa0e9, 0x40707e486aa7836a, 0x4074a384a91a397b, 0x4079a08eb4202877, 0x407f97add849df9e, 0x4083579632797cb4
ALIGN 64
 dq 0x3ff1de319919c21c, 0x3ed3f05391b43b71, 0x3efd2b1a7d4dbc0e, 0x3f2555cd268661b4, 0x3f4f360d6d3072da, 0x3f76d44fc48194aa, 0x3fa0b2d00fa8ade2, 0x3fc86d9c44e16362
ALIGN 64
 dq 0x3ff734f0c3e0de9f, 0xbfd7cc7f79e69000, 0x3ff713786a2ce91f, 0xbfd76feec20d0000, 0x3ff6f26008fab5a0, 0xbfd713e31351e000, 0x3ff6d1a61f138c7d, 0xbfd6b85b38287800
    dq 0x3ff6b1490bc5b4d1, 0xbfd65d5590807800, 0x3ff69147332f0cba, 0xbfd602d076180000, 0x3ff6719f18224223, 0xbfd5a8ca86909000, 0x3ff6524f99a51ed9, 0xbfd54f4356035000
    dq 0x3ff63356aa8f24c4, 0xbfd4f637c36b4000, 0x3ff614b36b9ddc14, 0xbfd49da7fda85000, 0x3ff5f66452c65c4c, 0xbfd445923989a800, 0x3ff5d867b5912c4f, 0xbfd3edf439b0b800
    dq 0x3ff5babccb5b90de, 0xbfd396ce448f7000, 0x3ff59d61f2d91a78, 0xbfd3401e17bda000, 0x3ff5805612465687, 0xbfd2e9e2ef468000, 0x3ff56397cee76bd3, 0xbfd2941b3830e000
    dq 0x3ff54725e2a77f93, 0xbfd23ec58cda8800, 0x3ff52aff42064583, 0xbfd1e9e129279000, 0x3ff50f22dbb2bddf, 0xbfd1956d2b48f800, 0x3ff4f38f4734ded7, 0xbfd141679ab9f800
    dq 0x3ff4d843cfde2840, 0xbfd0edd094ef9800, 0x3ff4bd3ec078a3c8, 0xbfd09aa518db1000, 0x3ff4a27fc3e0258a, 0xbfd047e65263b800, 0x3ff4880524d48434, 0xbfcfeb224586f000
    dq 0x3ff46dce1b192d0b, 0xbfcf474a7517b000, 0x3ff453d9d3391854, 0xbfcea4443d103000, 0x3ff43a2744b4845a, 0xbfce020d44e9b000, 0x3ff420b54115f8fb, 0xbfcd60a22977f000
    dq 0x3ff40782da3ef4b1, 0xbfccc00104959000, 0x3ff3ee8f5d57fe8f, 0xbfcc202956891000, 0x3ff3d5d9a00b4ce9, 0xbfcb81178d811000, 0x3ff3bd60c010c12b, 0xbfcae2c9ccd3d000
    dq 0x3ff3a5242b75dab8, 0xbfca45402e129000, 0x3ff38d22cd9fd002, 0xbfc9a877681df000, 0x3ff3755bc5847a1c, 0xbfc90c6d69483000, 0x3ff35dce49ad36e2, 0xbfc87120a645c000
    dq 0x3ff34679984dd440, 0xbfc7d68fb4143000, 0x3ff32f5cceffcb24, 0xbfc73cb83c627000, 0x3ff3187775a10d49, 0xbfc6a39a9b376000, 0x3ff301c8373e3990, 0xbfc60b3154b7a000
    dq 0x3ff2eb4ebb95f841, 0xbfc5737d76243000, 0x3ff2d50a0219a9d1, 0xbfc4dc7b8fc23000, 0x3ff2bef9a8b7fd2a, 0xbfc4462c51d20000, 0x3ff2a91c7a0c1bab, 0xbfc3b08abc830000
    dq 0x3ff293726014b530, 0xbfc31b996b490000, 0x3ff27dfa5757a1f5, 0xbfc2875490a44000, 0x3ff268b39b1d3bbf, 0xbfc1f3b9f879a000, 0x3ff2539d838ff5bd, 0xbfc160c8252ca000
    dq 0x3ff23eb7aac9083b, 0xbfc0ce7f57f72000, 0x3ff22a012ba940b6, 0xbfc03cdc49fea000, 0x3ff2157996cc4132, 0xbfbf57bdbc4b8000, 0x3ff201201dd2fc9b, 0xbfbe370896404000
    dq 0x3ff1ecf4494d480b, 0xbfbd17983ef94000, 0x3ff1d8f5528f6569, 0xbfbbf9674ed8a000, 0x3ff1c52311577e7c, 0xbfbadc79202f6000, 0x3ff1b17c74cb26e9, 0xbfb9c0c3e7288000
    dq 0x3ff19e010c2c1ab6, 0xbfb8a646b372c000, 0x3ff18ab07bb670bd, 0xbfb78d01b3ac0000, 0x3ff1778a25efbcb6, 0xbfb674f145380000, 0x3ff1648d354c31da, 0xbfb55e0e6d878000
    dq 0x3ff151b990275fdd, 0xbfb4485cdea1e000, 0x3ff13f0ea432d24c, 0xbfb333d94d6aa000, 0x3ff12c8b7210f9da, 0xbfb22079f8c56000, 0x3ff11a3028ecb531, 0xbfb10e4698622000
    dq 0x3ff107fbda8434af, 0xbfaffa6c6ad20000, 0x3ff0f5ee0f4e6bb3, 0xbfadda8d4a774000, 0x3ff0e4065d2a9fce, 0xbfabbcece4850000, 0x3ff0d244632ca521, 0xbfa9a1894012c000
    dq 0x3ff0c0a77ce2981a, 0xbfa788583302c000, 0x3ff0af2f83c636d1, 0xbfa5715e67d68000, 0x3ff09ddb98a01339, 0xbfa35c8a49658000, 0x3ff08cabaf52e7df, 0xbfa149e364154000
    dq 0x3ff07b9f2f4e28fb, 0xbf9e72c082eb8000, 0x3ff06ab58c358f19, 0xbf9a55f152528000, 0x3ff059eea5ecf92c, 0xbf963d62cf818000, 0x3ff04949cdd12c90, 0xbf9228fb8caa0000
    dq 0x3ff038c6c6f0ada9, 0xbf8c317b20f90000, 0x3ff02865137932a9, 0xbf8419355daa0000, 0x3ff0182427ea7348, 0xbf781203c2ec0000, 0x3ff008040614b195, 0xbf60040979240000
    dq 0x3fefe01ff726fa1a, 0x3f6feff384900000, 0x3fefa11cc261ea74, 0x3f87dc41353d0000, 0x3fef6310b081992e, 0x3f93cea3c4c28000, 0x3fef25f63ceeadcd, 0x3f9b9fc114890000
    dq 0x3feee9c8039113e7, 0x3fa1b0d8ce110000, 0x3feeae8078cbb1ab, 0x3fa58a5bd001c000, 0x3fee741aa29d0c9b, 0x3fa95c8340d88000, 0x3fee3a91830a99b5, 0x3fad276aef578000
    dq 0x3fee01e009609a56, 0x3fb07598e598c000, 0x3fedca01e577bb98, 0x3fb253f5e30d2000, 0x3fed92f20b7c9103, 0x3fb42edd8b380000, 0x3fed5cac66fb5cce, 0x3fb606598757c000
    dq 0x3fed272caa5ede9d, 0x3fb7da76356a0000, 0x3fecf26e3e6b2ccd, 0x3fb9ab434e1c6000, 0x3fecbe6da2a77902, 0x3fbb78c7bb0d6000, 0x3fec8b266d37086d, 0x3fbd431332e72000
    dq 0x3fec5894bd5d5804, 0x3fbf0a3171de6000, 0x3fec26b533bb9f8c, 0x3fc067152b914000, 0x3febf583eeece73f, 0x3fc147858292b000, 0x3febc4fd75db96c1, 0x3fc2266ecdca3000
    dq 0x3feb951e0c864a28, 0x3fc303d7a6c55000, 0x3feb65e2c5ef3e2c, 0x3fc3dfc33c331000, 0x3feb374867c9888b, 0x3fc4ba366b7a8000, 0x3feb094b211d304a, 0x3fc5933928d1f000
    dq 0x3feadbe885f2ef7e, 0x3fc66acd2418f000, 0x3feaaf1d31603da2, 0x3fc740f8ec669000, 0x3fea82e63fd358a7, 0x3fc815c0f51af000, 0x3fea5740ef09738b, 0x3fc8e92954f68000
    dq 0x3fea2c2a90ab4b27, 0x3fc9bb3602f84000, 0x3fea01a01393f2d1, 0x3fca8bed1c2c0000, 0x3fe9d79f24db3c1b, 0x3fcb5b515c01d000, 0x3fe9ae2505c7b190, 0x3fcc2967ccbcc000
    dq 0x3fe9852ef297ce2f, 0x3fccf635d5486000, 0x3fe95cbaeea44b75, 0x3fcdc1bd3446c000, 0x3fe934c69de74838, 0x3fce8c01b8cfe000, 0x3fe90d4f2f6752e6, 0x3fcf5509c0179000
    dq 0x3fe8e6528effd79d, 0x3fd00e6c121fb800, 0x3fe8bfce9fcc007c, 0x3fd071b80e93d000, 0x3fe899c0dabec30e, 0x3fd0d46b9e867000, 0x3fe87427aa2317fb, 0x3fd13687334bd000
    dq 0x3fe84f00acb39a08, 0x3fd1980d67234800, 0x3fe82a49e8653e55, 0x3fd1f8ffe0cc8000, 0x3fe8060195f40260, 0x3fd2595fd7636800, 0x3fe7e22563e0a329, 0x3fd2b9300914a800
    dq 0x3fe7beb377dcb5ad, 0x3fd3187210436000, 0x3fe79baa679725c2, 0x3fd377266dec1800, 0x3fe77907f2170657, 0x3fd3d54ffbaf3000, 0x3fe756cadbd6130c, 0x3fd432eee32fe000
 dq 0x3fe62e42fefa39ef, 0x3c7abc9e3b39803f
 dq 0x3f50040100401004, 0x3b90040100401004
 dq 0x0000000000000000, 0x0000000000000000
 dq 0x3f579ddda2d39cbd, 0xbbfa82d037892c70
 dq 0xbf424d19a0b08503, 0xbbea857c193b0171
 dq 0xbf25155903609841, 0x3bce68a04bf2c7dc
 dq 0x3f5e21bf52bfcc36, 0x3bed1a03bd255a8b
 dq 0x3fd0d013a92a3055, 0x3c6930be0ded288d
 dq 0x3fe5b22d0e560419, 0xbc8b22d0e560418a
 dq 0x3fae5c91d14e3bcd, 0x3c3ad42c3c9eecc0
 dq 0x4080fdf3c0f90f7c, 0x3d014ed69b9bbe94
 dq 0x4085adfacab3ecf9, 0x3ce586f62c833f1c
 dq 0x3f89f9b5860989b1, 0xbc26321fdc48a668
 dq 0x40191c0d56e7162b, 0xbcae1ca3ff371f95
 dq 0x40231bbd7150945f, 0xbcc6f2d9a4fd8920
 dq 0x40291eb180000000, 0x0000000000000000
ALIGN 64
 dq 0x3ff0000000000000, 0x0000000000000000, 0x3ff0000000000000, 0x0000000000000000, 0x3fe0000000000000, 0x0000000000000000, 0x3fc5555555555555, 0x3c65555555555555
    dq 0x3fa5555555555555, 0x3c45555555555555, 0x3f81111111111111, 0x3c01111111111111, 0x3f56c16c16c16c17, 0xbbef49f49f49f49f, 0x3f2a01a01a01a01a, 0x3b6a01a01a01a01a
    dq 0x3efa01a01a01a01a, 0x3b3a01a01a01a01a
 dq 0x3fe62e42fefa3800
 dq 0x3d2ef35793c76730
 dq 0xbfe0000000000001
 dq 0x3fd555555551305b
 dq 0xbfcfffffffeb4590
 dq 0x3fc999b324f10111
 dq 0xbfc55575e506c89f
 dq 0xbfe0000000000000
 dq 0x3fd5555555555577
 dq 0xbfcffffffffffdcb
 dq 0x3fc999999995dd0c
 dq 0xbfc55555556745a7
 dq 0x3fc24924a344de30
 dq 0xbfbfffffa4423d65
 dq 0x3fbc7184282ad6ca
 dq 0xbfb999eb43b068ff
 dq 0x3fb78182f7afd085
 dq 0xbfb5521375d145cd
 dq 0xbfeac00000000000
 dq 0xbff0000000000000
 dq 0x8000000000000000
 dq 0x4130000000000000
 dq 0x3f50000000000000
 dq 0x4090000000000000
 dq 0x408ff80000000000
 dq 0x0000000000000000
 dq 0x4080000000000000
 dq 0x405e000000000000
 dq 0x408ff80000000000
 dq 0x4030000000000000
 dq 0x3fd0000000000000
 dq 0x3fb0000000000000
 dq 0x41a0000000000000
 dq 0xc3e0000000000000
 dq 0x43e0000000000000
 dq 0x3bc79ca10c924223
 dq 0x3d30e374a4f8e0b4
 dq 0x3a095a5efea6b347
 dq 0x3ddb7cdfd9d7bdbb
 dq 0x3fe5b3883126e979
 dq 0x3dde3c8fd606ea4e
 dq 0x3feac00000000000
 dq 0x4032da0000000000
 dq 0x4032b00000000000
 dq 0x3fc4640000000000
 dq 0x4053b60000000000
 dq 0x402f3e4000000000
 dq 0x4009d70000000000
 dq 0x3fd6d2723e29d620
 dq 0x3febcd11009d0551
 dq 0x3e10000000000000
 dq 0x3fbacb6800000000
 dq 0x3f40000000000000
 dq 0x42f8000000000000
 dq 0x400f1bc14e5e0a73
 dq 0x4040a1b646d223fe
 dq 0x400f3cd0bd7d6344
 dq 0x3eb0000000000000
 dq 0x3ec4d772dda5cf1c
 dq 0x3ab4d78086498fa3
 dq 0x3bd0000000000000
 dq 0xbe112e0be826d695
 dq 0x3e112e0be826d695
 dq 0x3ec5d7730533c05d
 dq 0x3a95d781559d4718
 dq 0x3bb0000000000000
 dq 0x407fffffffffbb48
 dq 0x408000000000225c
 dq 0x7fffffffffffffff
 dq 0x000fffffffffffff
 dq 0x3fdfffffffffffff
 dq 0x00000000000003ff
 dq 0x000000000000000f
 dq 0x0000000000000010
 dq 0x4012000000000000
 dq 0x8003090000000000
 dq 0xc01a000000000000
 dq 0x00000000000000fe
 dq 0xfff0000000000000
 dq 0x00000000000003ff
 dq 0x0000000000000000
 dq 0x000009c18f000000
 dq 0x0026fc7a71000000
 dq 0x0886bac8bc000000, 0x0000000000000004
 dq 0x3feffffffffff097
 dq 0x3fc46400000165ce
 dq 0xbfb12471bb2051ea
 dq 0x3fa50933190a13a2
 dq 0xbf9de76696e41750
 dq 0x3f96fb03e0af34c6
 dq 0x405c6fd6d44277ae
 dq 0xc04c6fd6d3ba234b
 dq 0x4042f539e8af943e
 dq 0xc03c706e7b8e30dd
 dq 0x4036bdffc98133bb
 dq 0x3feffffffffffe6c
 dq 0x3fe62e42fec39e1c
 dq 0x3fcebfbe00336db2
 dq 0x3fac6b3f73e213d6
 dq 0x3f83b292330a1d9b
 dq 0xbfa235f3e7069aca
 dq 0x3fa935dc3d576fd0
 dq 0xbfb76a9a56aedcd5
 dq 0x3fc8855b936361e4
 dq 0xbfdb744cd90af0cf
 dq 0x3fbd100c0ed9ca12
 dq 0x3fe6ce03937ea8e3
 dq 0x3ffe16602048862b
 dq 0x40057304b0a6fcf8
 dq 0x400193a8174864b6
 dq 0x4070cbdfa43fe5c9
 dq 0x4085acc083126e98
 dq 0x404e54faacd9e83e
 dq 0x407ff80000000000
 dq 0x4061daee02fe5708
 dq 0x40770a88fe80d47c
 dq 0x407d65c5bcd95aef
 dq 0x404491d219352885
ALIGN 32
 dd 0, 1, 2, 3, 4, 5, 6, 7
 dd 1, 2, 3, 4, 5, 6, 7, 7
 dd 0, 2, 1, 3, 0, 0, 0, 0
 db 0, 1, 0, 1, 2, 3, 4, 5, 8, 9, 8, 9, 10, 11, 12, 13, 0, 1, 0, 1, 2, 3, 4, 5, 8, 9, 8, 9, 10, 11, 12, 13

%assign m 11
%rep 110
cextern pq2_ %+ m
%assign m m+1
%endrep

const pq2
%assign m 11
%rep 110
    dq pq2_ %+ m
%assign m m+1
%endrep
