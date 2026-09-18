use alloc::collections::BTreeSet;
#[cfg(target_os = "linux")]
use alloc::vec::Vec;
use core::{
    hint::cold_path,
    ptr::copy_nonoverlapping,
    slice::{from_raw_parts, from_raw_parts_mut},
};

use crate::{
    chan::{Semaphore, sem_acq, sem_release},
    chunk::{Chunk, MAX_CHNK_FRAMES},
    error::fatal,
    ffms::{
        DecStrat,
        DecStrat::{
            B8Crop, B8CropFast, B8CropStride, B8Fast, B8Stride, B10Crop, B10CropFast,
            B10CropFastRem, B10CropRem, B10CropStride, B10CropStrideRem, B10Fast, B10FastRem,
            B10Raw, B10RawCrop, B10RawCropFast, B10RawCropStride, B10RawStride, B10StrideRem,
            HwNv12, HwNv12Crop, HwNv12CropTo10, HwNv12Stride, HwNv12To10, HwNv12To10Stride,
            HwP010CropPack, HwP010CropPackPkRem, HwP010CropPackRem, HwP010CropPackRemPkRem,
            HwP010Pack, HwP010PackPkRem, HwP010PackRem, HwP010PackRemPkRem,
            HwP010PackRemPkRemStride, HwP010Raw, HwP010RawCrop, HwP010RawCropRem, HwP010RawRem,
            HwP010RawRemStride,
        },
        VidDecoder, VidInf, extr_8b_crop, extr_8b_crop_fast, extr_8b_crop_stride, extr_8b_fast,
        extr_8b_stride, extr_10b_crop, extr_10b_crop_fast, extr_10b_crop_fast_rem,
        extr_10b_crop_pack_stride, extr_10b_crop_pack_stride_rem, extr_10b_crop_rem, extr_10b_pack,
        extr_10b_pack_rem, extr_10b_pack_stride_rem, extr_10b_raw, extr_10b_raw_crop,
        extr_10b_raw_crop_fast, extr_10b_raw_crop_stride, extr_10b_raw_stride, extr_hw_nv12,
        extr_hw_nv12_crop, extr_hw_nv12_crop_to10, extr_hw_nv12_stride, extr_hw_nv12_to10,
        extr_hw_nv12_to10_stride, extr_hw_p010_raw, extr_hw_p010_raw_crop,
        extr_hw_p010_raw_crop_rem, extr_hw_p010_raw_rem, extr_hw_p010_raw_rem_stride,
    },
    pack::{
        PACK_CHUNK, calc_8b_sz, calc_packed_sz, pack_10b, pack_10b_rem, pack_stride,
        pack_stride_rem, packed_row_sz,
    },
    path::Path,
    thread::available_parallelism,
    util::assume_unreachable,
    worker::{PkgPool, WorkPkg},
    y4m::PipeReader,
};

#[derive(Debug, Clone, Copy)]
pub struct CropCalc {
    pub g: Geom,
    pub new_w: u32,
    pub new_h: u32,
    pub y_stride: usize,
    pub uv_stride: usize,
    pub y_start: usize,
    pub u_start: usize,
    pub v_start: usize,
    pub y_len: usize,
    pub uv_len: usize,
    pub uv_off: usize,
    pub crop_v: u32,
    pub crop_h: u32,
}

impl CropCalc {
    pub const fn new(inf: &VidInf, crop: (u32, u32), pix_sz: usize) -> Self {
        let (cv, ch) = crop;
        let new_w = inf.width - ch * 2;
        let new_h = inf.height - cv * 2;

        let y_stride = (inf.width * pix_sz as u32) as usize;
        let uv_stride = (inf.width / 2 * pix_sz as u32) as usize;
        let y_start = ((cv * inf.width + ch) as usize) * pix_sz;
        let y_plane = (inf.width * inf.height) as usize * pix_sz;
        let uv_plane = (inf.width / 2 * inf.height / 2) as usize * pix_sz;
        let uv_off = (cv / 2 * inf.width / 2 + ch / 2) as usize * pix_sz;
        let u_start = y_plane + uv_off;
        let v_start = y_plane + uv_plane + uv_off;
        let y_len = (new_w * pix_sz as u32) as usize;
        let uv_len = (new_w / 2 * pix_sz as u32) as usize;

        Self {
            g: Geom::new(new_w, new_h, pix_sz),
            new_w,
            new_h,
            y_stride,
            uv_stride,
            y_start,
            u_start,
            v_start,
            y_len,
            uv_len,
            uv_off,
            crop_v: cv,
            crop_h: ch,
        }
    }

    #[inline]
    pub fn crop(&self, src: &[u8], dst: &mut [u8]) {
        let mut d = dst.as_mut_ptr();
        for (start, len, rows, stride) in [
            (self.y_start, self.y_len, self.g.hu, self.y_stride),
            (self.u_start, self.uv_len, self.g.hh, self.uv_stride),
            (self.v_start, self.uv_len, self.g.hh, self.uv_stride),
        ] {
            let mut s = unsafe { src.as_ptr().add(start) };
            for _ in 0..rows {
                unsafe {
                    copy_nonoverlapping(s, d, len);
                    s = s.add(stride);
                    d = d.add(len);
                }
            }
        }
    }
}

#[derive(Debug, Clone, Copy)]
pub struct Geom {
    pub w: u32,
    pub h: u32,
    pub wu: usize,
    pub hu: usize,
    pub hw: usize,
    pub hh: usize,
    pub y_stride: usize,
    pub c_stride: usize,
    pub y_sz: usize,
    pub uv_sz: usize,
    pub cr_off: usize,
    pub fsz: usize,
    pub y_pack: usize,
    pub cr_pack: usize,
    pub pack_fsz: usize,
}

impl Geom {
    pub const fn new(w: u32, h: u32, pix_sz: usize) -> Self {
        let (wu, hu) = (w as usize, h as usize);
        let (hw, hh) = (wu / 2, hu / 2);
        let y_stride = wu * pix_sz;
        let c_stride = hw * pix_sz;
        let y_sz = y_stride * hu;
        let uv_sz = c_stride * hh;
        let y_pack = packed_row_sz(wu) * hu;
        let uv_pack = packed_row_sz(hw) * hh;
        Self {
            w,
            h,
            wu,
            hu,
            hw,
            hh,
            y_stride,
            c_stride,
            y_sz,
            uv_sz,
            cr_off: y_sz + uv_sz,
            fsz: y_sz + uv_sz * 2,
            y_pack,
            cr_pack: y_pack + uv_pack,
            pack_fsz: calc_packed_sz(w, h),
        }
    }
}

pub struct Bufs {
    sem: Semaphore,
    pool: PkgPool,
}

impl Bufs {
    #[cold]
    #[inline(never)]
    #[must_use]
    pub fn new(n: usize, cap: usize) -> Self {
        Self {
            sem: Semaphore::new(n),
            pool: PkgPool::new(n, cap),
        }
    }

    #[must_use]
    pub const fn sink<'a>(&'a self, tx: &'a dyn Fn(*mut WorkPkg)) -> Sink<'a> {
        Sink { b: self, tx }
    }

    pub fn give(&self, p: *mut WorkPkg) {
        self.pool.give(p);
        sem_release(&self.sem);
    }
}

pub struct Sink<'a> {
    b: &'a Bufs,
    tx: &'a dyn Fn(*mut WorkPkg),
}

#[inline]
fn emit(sk: &Sink, f: impl FnOnce(&mut WorkPkg)) {
    sem_acq(&sk.b.sem);
    let p = sk.b.pool.take();
    f(unsafe { &mut *p });
    (sk.tx)(p);
}

pub fn dec_chnks(
    chnks: &[Chunk],
    path: &Path,
    inf: &VidInf,
    skip: &BTreeSet<u16>,
    strat: DecStrat,
    sk: &Sink,
) {
    let thr = available_parallelism() as i32;
    let dec = if strat.is_hw() {
        VidDecoder::new_hw(path, thr)
    } else {
        VidDecoder::new(path, thr)
    };
    let mut dec = match dec {
        Ok(d) => d,
        Err(e) => fatal(e),
    };
    let filtered: Vec<Chunk> = chnks
        .iter()
        .filter(|c| !skip.contains(&c.idx))
        .copied()
        .collect();
    match strat {
        B8Fast
        | B8Stride
        | B8Crop { .. }
        | B8CropFast { .. }
        | B8CropStride { .. }
        | HwNv12
        | HwNv12Stride
        | HwNv12Crop { .. }
        | HwNv12To10
        | HwNv12To10Stride
        | HwNv12CropTo10 { .. } => {
            disp_8b(&filtered, &mut dec, inf, strat, sk);
        }
        HwP010Raw
        | HwP010RawRem
        | HwP010RawRemStride
        | HwP010RawCrop { .. }
        | HwP010RawCropRem { .. } => {
            disp_hw_10b_raw(&filtered, &mut dec, inf, strat, sk);
        }
        HwP010Pack
        | HwP010PackPkRem
        | HwP010PackRem
        | HwP010PackRemPkRem
        | HwP010PackRemPkRemStride
        | HwP010CropPack { .. }
        | HwP010CropPackPkRem { .. }
        | HwP010CropPackRem { .. }
        | HwP010CropPackRemPkRem { .. } => {
            disp_hw_10b_pack(&filtered, &mut dec, inf, strat, sk);
        }
        _ => disp_10b(&filtered, &mut dec, inf, strat, sk),
    }
}

fn disp_10b(filtered: &[Chunk], dec: &mut VidDecoder, inf: &VidInf, strat: DecStrat, sk: &Sink) {
    let g = Geom::new(inf.width, inf.height, 2);
    if strat.is_raw() {
        disp_10b_raw(filtered, dec, inf, strat, sk);
        return;
    }
    match strat {
        B10Fast => {
            let f = g.pack_fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_10_fast(ch, dec, &g, g.w, g.h, f, p);
                });
            }
        }
        B10FastRem => {
            let f = g.pack_fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_10_fast_rem(ch, dec, &g, g.w, g.h, f, p);
                });
            }
        }
        B10StrideRem => {
            let f = g.pack_fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_10_stride_rem(ch, dec, &g, g.w, g.h, f, p);
                });
            }
        }
        B10CropFast { cc } => {
            let f = cc.g.pack_fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_10_crop_fast(ch, dec, &cc, cc.new_w, cc.new_h, f, p);
                });
            }
        }
        B10CropFastRem { cc } => {
            let f = cc.g.pack_fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_10_crop_fast_rem(ch, dec, &cc, cc.new_w, cc.new_h, f, p);
                });
            }
        }
        B10Crop { cc } => {
            let f = cc.g.pack_fsz;
            for ch in filtered {
                emit(sk, |p| dec_10_crop(ch, dec, &cc, cc.new_w, cc.new_h, f, p));
            }
        }
        B10CropRem { cc } => {
            let f = cc.g.pack_fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_10_crop_rem(ch, dec, &cc, cc.new_w, cc.new_h, f, p);
                });
            }
        }
        B10CropStride { cc } => {
            let f = cc.g.pack_fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_10_crop_stride(ch, dec, &cc, cc.new_w, cc.new_h, f, p);
                });
            }
        }
        B10CropStrideRem { cc } => {
            let f = cc.g.pack_fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_10_crop_stride_rem(ch, dec, &cc, cc.new_w, cc.new_h, f, p);
                });
            }
        }
        _ => assume_unreachable(),
    }
}

fn disp_10b_raw(
    filtered: &[Chunk],
    dec: &mut VidDecoder,
    inf: &VidInf,
    strat: DecStrat,
    sk: &Sink,
) {
    let g = Geom::new(inf.width, inf.height, 2);
    match strat {
        B10Raw => {
            let f = g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_10_raw(ch, dec, &g, g.w, g.h, f, p);
                });
            }
        }
        B10RawStride => {
            let f = g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_10_raw_stride(ch, dec, &g, g.w, g.h, f, p);
                });
            }
        }
        B10RawCropFast { cc } => {
            let f = cc.g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_10_raw_crop_fast(ch, dec, &cc, cc.new_w, cc.new_h, f, p);
                });
            }
        }
        B10RawCrop { cc } => {
            let f = cc.g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_10_raw_crop(ch, dec, &cc, cc.new_w, cc.new_h, f, p);
                });
            }
        }
        B10RawCropStride { cc } => {
            let f = cc.g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_10_raw_crop_stride(ch, dec, &cc, cc.new_w, cc.new_h, f, p);
                });
            }
        }
        _ => assume_unreachable(),
    }
}

fn disp_8b(filtered: &[Chunk], dec: &mut VidDecoder, inf: &VidInf, strat: DecStrat, sk: &Sink) {
    let g = Geom::new(inf.width, inf.height, 1);
    match strat {
        B8Fast => {
            let f = g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_8_fast(ch, dec, &g, g.w, g.h, f, p);
                });
            }
        }
        B8Stride => {
            let f = g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_8_stride(ch, dec, &g, g.w, g.h, f, p);
                });
            }
        }
        B8CropFast { cc } => {
            let f = cc.g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_8_crop_fast(ch, dec, &cc, cc.new_w, cc.new_h, f, p);
                });
            }
        }
        B8Crop { cc } => {
            let f = cc.g.fsz;
            for ch in filtered {
                emit(sk, |p| dec_8_crop(ch, dec, &cc, cc.new_w, cc.new_h, f, p));
            }
        }
        B8CropStride { cc } => {
            let f = cc.g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_8_crop_stride(ch, dec, &cc, cc.new_w, cc.new_h, f, p);
                });
            }
        }
        HwNv12 => {
            let f = g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_hw_nv12(ch, dec, &g, g.w, g.h, f, p);
                });
            }
        }
        HwNv12Stride => {
            let f = g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_hw_nv12_stride(ch, dec, &g, g.w, g.h, f, p);
                });
            }
        }
        HwNv12Crop { cc } => {
            let f = cc.g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_hw_nv12_crop(ch, dec, &cc, cc.new_w, cc.new_h, f, p);
                });
            }
        }
        HwNv12To10 => {
            let f = g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_hw_nv12_to10(ch, dec, &g, g.w, g.h, f, p);
                });
            }
        }
        HwNv12To10Stride => {
            let f = g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_hw_nv12_to10_stride(ch, dec, &g, g.w, g.h, f, p);
                });
            }
        }
        HwNv12CropTo10 { cc } => {
            let f = cc.g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_hw_nv12_crop_to10(ch, dec, &cc, cc.new_w, cc.new_h, f, p);
                });
            }
        }
        _ => assume_unreachable(),
    }
}

fn disp_hw_10b_raw(
    filtered: &[Chunk],
    dec: &mut VidDecoder,
    inf: &VidInf,
    strat: DecStrat,
    sk: &Sink,
) {
    let g = Geom::new(inf.width, inf.height, 2);
    match strat {
        HwP010Raw => {
            let f = g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_hw_p010_raw(ch, dec, &g, g.w, g.h, f, p);
                });
            }
        }
        HwP010RawRem => {
            let f = g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_hw_p010_raw_rem(ch, dec, &g, g.w, g.h, f, p);
                });
            }
        }
        HwP010RawRemStride => {
            let f = g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_hw_p010_raw_rem_stride(ch, dec, &g, g.w, g.h, f, p);
                });
            }
        }
        HwP010RawCrop { cc } => {
            let f = cc.g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_hw_p010_raw_crop(ch, dec, &cc, cc.new_w, cc.new_h, f, p);
                });
            }
        }
        HwP010RawCropRem { cc } => {
            let f = cc.g.fsz;
            for ch in filtered {
                emit(sk, |p| {
                    dec_hw_p010_raw_crop_rem(ch, dec, &cc, cc.new_w, cc.new_h, f, p);
                });
            }
        }
        _ => assume_unreachable(),
    }
}

fn disp_hw_10b_pack(
    filtered: &[Chunk],
    dec: &mut VidDecoder,
    inf: &VidInf,
    strat: DecStrat,
    sk: &Sink,
) {
    let (w, h) = match strat {
        HwP010CropPack { cc }
        | HwP010CropPackPkRem { cc }
        | HwP010CropPackRem { cc }
        | HwP010CropPackRemPkRem { cc } => (cc.new_w, cc.new_h),
        _ => (inf.width, inf.height),
    };
    let g = Geom::new(w, h, 2);
    let mut raw_buf = vec![0u8; g.fsz];

    macro_rules! run {
        ($dec_fn:ident, $ctx:expr) => {
            for ch in filtered {
                emit(sk, |p| $dec_fn(ch, dec, $ctx, &g, &mut raw_buf, p));
            }
        };
    }
    match strat {
        HwP010Pack => run!(dec_hw_p010_pack, &g),
        HwP010PackPkRem => run!(dec_hw_p010_pack_pkrem, &g),
        HwP010PackRem => run!(dec_hw_p010_pack_rem, &g),
        HwP010PackRemPkRem => run!(dec_hw_p010_pack_rem_pkrem, &g),
        HwP010PackRemPkRemStride => run!(dec_hw_p010_pack_rem_pkrem_stride, &g),
        HwP010CropPack { cc } => run!(dec_hw_p010_crop_pack, &cc),
        HwP010CropPackPkRem { cc } => run!(dec_hw_p010_crop_pack_pkrem, &cc),
        HwP010CropPackRem { cc } => run!(dec_hw_p010_crop_pack_rem, &cc),
        HwP010CropPackRemPkRem { cc } => run!(dec_hw_p010_crop_pack_rem_pkrem, &cc),
        _ => assume_unreachable(),
    }
}

#[inline]
fn pack_hw_planes(raw_buf: &[u8], dst: &mut [u8], g: &Geom) {
    pack_10b(&raw_buf[..g.y_sz], &mut dst[..g.y_pack]);
    pack_10b(&raw_buf[g.y_sz..g.cr_off], &mut dst[g.y_pack..g.cr_pack]);
    pack_10b(
        &raw_buf[g.cr_off..g.cr_off + g.uv_sz],
        &mut dst[g.cr_pack..],
    );
}

#[inline]
fn pack_hw_planes_rem(raw_buf: &[u8], dst: &mut [u8], g: &Geom) {
    pack_10b_rem(&raw_buf[..g.y_sz], dst, g.wu, g.hu);
    pack_10b_rem(
        &raw_buf[g.y_sz..g.cr_off],
        &mut dst[g.y_pack..g.cr_pack],
        g.hw,
        g.hh,
    );
    pack_10b_rem(
        &raw_buf[g.cr_off..g.cr_off + g.uv_sz],
        &mut dst[g.cr_pack..],
        g.hw,
        g.hh,
    );
}

macro_rules! dec_hw_pack {
    ($name:ident, $extr:ident, $pack:ident, $ctx_ty:ty, $ctx_field:ident) => {
        fn $name(
            ch: &Chunk,
            dec: &mut VidDecoder,
            $ctx_field: $ctx_ty,
            g: &Geom,
            raw_buf: &mut [u8],
            pkg: &mut WorkPkg,
        ) {
            dec.skip_to(ch.start);
            let len = ch.end - ch.start;
            let fsz = g.pack_fsz;
            let mut actual = len;
            let mut dst = pkg.fit(len * fsz);
            for i in 0..len {
                let frame = dec.dec_next_hw();
                if dec.is_eof() {
                    cold_path();
                    actual = pkg.truncate(i, fsz);
                    break;
                }
                $extr(frame, raw_buf, $ctx_field);
                $pack(raw_buf, unsafe { from_raw_parts_mut(dst, fsz) }, g);
                dst = unsafe { dst.add(fsz) };
            }
            pkg.set(*ch, actual, g.w, g.h);
        }
    };
}

dec_hw_pack!(dec_hw_p010_pack, extr_hw_p010_raw, pack_hw_planes, &Geom, g);
dec_hw_pack!(
    dec_hw_p010_pack_pkrem,
    extr_hw_p010_raw,
    pack_hw_planes_rem,
    &Geom,
    g
);
dec_hw_pack!(
    dec_hw_p010_pack_rem,
    extr_hw_p010_raw_rem,
    pack_hw_planes,
    &Geom,
    g
);
dec_hw_pack!(
    dec_hw_p010_pack_rem_pkrem,
    extr_hw_p010_raw_rem,
    pack_hw_planes_rem,
    &Geom,
    g
);
dec_hw_pack!(
    dec_hw_p010_crop_pack,
    extr_hw_p010_raw_crop,
    pack_hw_planes,
    &CropCalc,
    cc
);
dec_hw_pack!(
    dec_hw_p010_crop_pack_pkrem,
    extr_hw_p010_raw_crop,
    pack_hw_planes_rem,
    &CropCalc,
    cc
);
dec_hw_pack!(
    dec_hw_p010_crop_pack_rem,
    extr_hw_p010_raw_crop_rem,
    pack_hw_planes,
    &CropCalc,
    cc
);
dec_hw_pack!(
    dec_hw_p010_crop_pack_rem_pkrem,
    extr_hw_p010_raw_crop_rem,
    pack_hw_planes_rem,
    &CropCalc,
    cc
);
dec_hw_pack!(
    dec_hw_p010_pack_rem_pkrem_stride,
    extr_hw_p010_raw_rem_stride,
    pack_hw_planes_rem,
    &Geom,
    g
);

macro_rules! dec_linear {
    ($name:ident, $extr_fn:ident, $ctx_ty:ty, $ctx_arg:ident) => {
        dec_linear!($name, $extr_fn, $ctx_ty, $ctx_arg, dec_next);
    };
    ($name:ident, $extr_fn:ident, $ctx_ty:ty, $ctx_arg:ident, $next:ident) => {
        #[inline]
        fn $name(
            ch: &Chunk,
            dec: &mut VidDecoder,
            $ctx_arg: $ctx_ty,
            w: u32,
            h: u32,
            fsz: usize,
            pkg: &mut WorkPkg,
        ) {
            dec.skip_to(ch.start);
            let len = ch.end - ch.start;
            let mut actual = len;
            let mut dst = pkg.fit(len * fsz);
            for i in 0..len {
                let frame = dec.$next();
                if dec.is_eof() {
                    cold_path();
                    actual = pkg.truncate(i, fsz);
                    break;
                }
                $extr_fn(frame, unsafe { from_raw_parts_mut(dst, fsz) }, $ctx_arg);
                dst = unsafe { dst.add(fsz) };
            }
            pkg.set(*ch, actual, w, h);
        }
    };
}

dec_linear!(dec_10_fast, extr_10b_pack, &Geom, g);
dec_linear!(dec_10_crop_fast, extr_10b_crop_fast, &CropCalc, cc);
dec_linear!(dec_10_crop_fast_rem, extr_10b_crop_fast_rem, &CropCalc, cc);
dec_linear!(dec_10_crop, extr_10b_crop, &CropCalc, cc);
dec_linear!(dec_10_fast_rem, extr_10b_pack_rem, &Geom, g);
dec_linear!(dec_10_stride_rem, extr_10b_pack_stride_rem, &Geom, g);
dec_linear!(dec_10_crop_rem, extr_10b_crop_rem, &CropCalc, cc);
dec_linear!(dec_10_raw, extr_10b_raw, &Geom, g);
dec_linear!(dec_10_raw_stride, extr_10b_raw_stride, &Geom, g);
dec_linear!(dec_10_raw_crop_fast, extr_10b_raw_crop_fast, &CropCalc, cc);
dec_linear!(dec_10_raw_crop, extr_10b_raw_crop, &CropCalc, cc);
dec_linear!(
    dec_10_raw_crop_stride,
    extr_10b_raw_crop_stride,
    &CropCalc,
    cc
);
dec_linear!(dec_10_crop_stride, extr_10b_crop_pack_stride, &CropCalc, cc);
dec_linear!(
    dec_10_crop_stride_rem,
    extr_10b_crop_pack_stride_rem,
    &CropCalc,
    cc
);
dec_linear!(dec_8_fast, extr_8b_fast, &Geom, g);
dec_linear!(dec_8_stride, extr_8b_stride, &Geom, g);
dec_linear!(dec_8_crop_fast, extr_8b_crop_fast, &CropCalc, cc);
dec_linear!(dec_8_crop, extr_8b_crop, &CropCalc, cc);
dec_linear!(dec_hw_nv12, extr_hw_nv12, &Geom, g, dec_next_hw);
dec_linear!(
    dec_hw_nv12_stride,
    extr_hw_nv12_stride,
    &Geom,
    g,
    dec_next_hw
);
dec_linear!(
    dec_hw_nv12_crop,
    extr_hw_nv12_crop,
    &CropCalc,
    cc,
    dec_next_hw
);
dec_linear!(dec_hw_nv12_to10, extr_hw_nv12_to10, &Geom, g, dec_next_hw);
dec_linear!(
    dec_hw_nv12_to10_stride,
    extr_hw_nv12_to10_stride,
    &Geom,
    g,
    dec_next_hw
);
dec_linear!(
    dec_hw_nv12_crop_to10,
    extr_hw_nv12_crop_to10,
    &CropCalc,
    cc,
    dec_next_hw
);
dec_linear!(dec_hw_p010_raw, extr_hw_p010_raw, &Geom, g, dec_next_hw);
dec_linear!(
    dec_hw_p010_raw_crop,
    extr_hw_p010_raw_crop,
    &CropCalc,
    cc,
    dec_next_hw
);
dec_linear!(
    dec_hw_p010_raw_rem,
    extr_hw_p010_raw_rem,
    &Geom,
    g,
    dec_next_hw
);
dec_linear!(
    dec_hw_p010_raw_rem_stride,
    extr_hw_p010_raw_rem_stride,
    &Geom,
    g,
    dec_next_hw
);
dec_linear!(
    dec_hw_p010_raw_crop_rem,
    extr_hw_p010_raw_crop_rem,
    &CropCalc,
    cc,
    dec_next_hw
);

dec_linear!(dec_8_crop_stride, extr_8b_crop_stride, &CropCalc, cc);

pub fn dec_pipe(
    chnks: &[Chunk],
    reader: &mut PipeReader,
    inf: &VidInf,
    skip: &BTreeSet<u16>,
    strat: DecStrat,
    sk: &Sink,
) {
    let chnks = chnks.get(reader.start_idx..).unwrap_or(chnks);
    let cc = match strat {
        B10Crop { cc }
        | B10CropRem { cc }
        | B10CropFast { cc }
        | B10CropFastRem { cc }
        | B10CropStride { cc }
        | B10CropStrideRem { cc }
        | B8Crop { cc }
        | B8CropFast { cc }
        | B8CropStride { cc }
        | B10RawCrop { cc }
        | B10RawCropFast { cc }
        | B10RawCropStride { cc }
        | HwNv12Crop { cc }
        | HwNv12CropTo10 { cc }
        | HwP010RawCrop { cc }
        | HwP010RawCropRem { cc }
        | HwP010CropPack { cc }
        | HwP010CropPackPkRem { cc }
        | HwP010CropPackRem { cc }
        | HwP010CropPackRemPkRem { cc } => Some(cc),
        _ => None,
    };

    let (w, h) = cc.map_or((inf.width, inf.height), |c| (c.new_w, c.new_h));
    let raw_fsz = reader.frame_sz;

    if strat.is_raw() {
        let fsz = w as usize * h as usize * 3;
        if let Some(cc) = cc {
            pipe_loop(chnks, reader, skip, sk, raw_fsz, |ch, raw, pkg| {
                dec_pipe_raw_crop(ch, raw, raw_fsz, &cc, fsz, pkg);
            });
        } else {
            pipe_direct(chnks, reader, skip, sk, fsz, w, h);
        }
        return;
    }

    let fsz = if inf.is_10b {
        calc_packed_sz(w, h)
    } else {
        calc_8b_sz(w, h)
    };
    let has_rem = inf.is_10b && !(w as usize).is_multiple_of(PACK_CHUNK);

    match (inf.is_10b, cc, has_rem) {
        (true, Some(cc), false) => {
            let g = Geom::new(w, h, 2);
            pipe_loop(chnks, reader, skip, sk, raw_fsz, |ch, raw, pkg| {
                dec_pipe_10_crop(ch, raw, raw_fsz, &cc, &g, pkg);
            });
        }
        (true, Some(cc), true) => {
            let g = Geom::new(w, h, 2);
            pipe_loop(chnks, reader, skip, sk, raw_fsz, |ch, raw, pkg| {
                dec_pipe_10_crop_rem(ch, raw, raw_fsz, &cc, &g, pkg);
            });
        }
        (true, None, false) => {
            let g = Geom::new(w, h, 2);
            pipe_loop(chnks, reader, skip, sk, raw_fsz, |ch, raw, pkg| {
                dec_pipe_10(ch, raw, raw_fsz, &g, pkg);
            });
        }
        (true, None, true) => {
            let g = Geom::new(w, h, 2);
            pipe_loop(chnks, reader, skip, sk, raw_fsz, |ch, raw, pkg| {
                dec_pipe_10_rem(ch, raw, raw_fsz, &g, pkg);
            });
        }
        (false, Some(cc), _) => {
            pipe_loop(chnks, reader, skip, sk, raw_fsz, |ch, raw, pkg| {
                dec_pipe_8_crop(ch, raw, raw_fsz, &cc, fsz, pkg);
            });
        }
        (false, None, _) => pipe_direct(chnks, reader, skip, sk, fsz, w, h),
    }
}

#[inline]
fn pipe_loop<F>(
    chnks: &[Chunk],
    reader: &mut PipeReader,
    skip: &BTreeSet<u16>,
    sk: &Sink,
    raw_fsz: usize,
    mut dec: F,
) where
    F: FnMut(&Chunk, &[u8], &mut WorkPkg),
{
    let mut raw = vec![0u8; MAX_CHNK_FRAMES * raw_fsz];
    for ch in chnks {
        let len = ch.end - ch.start;

        if skip.contains(&ch.idx) {
            reader.skip_frames(len);
            continue;
        }

        sem_acq(&sk.b.sem);

        let mut dst = raw.as_mut_ptr();
        for _ in 0..len {
            if !reader.read_frame(unsafe { from_raw_parts_mut(dst, raw_fsz) }) {
                return;
            }
            dst = unsafe { dst.add(raw_fsz) };
        }

        let p = sk.b.pool.take();
        let src = unsafe { from_raw_parts(raw.as_ptr(), len * raw_fsz) };
        dec(ch, src, unsafe { &mut *p });
        (sk.tx)(p);
    }
}

#[inline]
fn pipe_direct(
    chnks: &[Chunk],
    reader: &mut PipeReader,
    skip: &BTreeSet<u16>,
    sk: &Sink,
    fsz: usize,
    w: u32,
    h: u32,
) {
    for ch in chnks {
        let len = ch.end - ch.start;

        if skip.contains(&ch.idx) {
            reader.skip_frames(len);
            continue;
        }

        sem_acq(&sk.b.sem);

        let p = sk.b.pool.take();
        let pkg = unsafe { &mut *p };
        let mut dst = pkg.fit(len * fsz);
        for _ in 0..len {
            if !reader.read_frame(unsafe { from_raw_parts_mut(dst, fsz) }) {
                sk.b.pool.give(p);
                return;
            }
            dst = unsafe { dst.add(fsz) };
        }
        pkg.set(*ch, len, w, h);
        (sk.tx)(p);
    }
}

macro_rules! dec_pipe_pack {
    ($name:ident, $pack:ident) => {
        #[inline]
        fn $name(ch: &Chunk, data: &[u8], raw_fsz: usize, g: &Geom, pkg: &mut WorkPkg) {
            let len = ch.end - ch.start;
            let mut src = data.as_ptr();
            let mut dst = pkg.fit(len * g.pack_fsz);
            for _ in 0..len {
                $pack(
                    unsafe { from_raw_parts(src, raw_fsz) },
                    unsafe { from_raw_parts_mut(dst, g.pack_fsz) },
                    g,
                );
                src = unsafe { src.add(raw_fsz) };
                dst = unsafe { dst.add(g.pack_fsz) };
            }
            pkg.set(*ch, len, g.w, g.h);
        }
    };
}

dec_pipe_pack!(dec_pipe_10, pack_hw_planes);
dec_pipe_pack!(dec_pipe_10_rem, pack_hw_planes_rem);

macro_rules! dec_pipe_crop_pack {
    ($name:ident, $pack:ident) => {
        #[inline]
        fn $name(
            ch: &Chunk,
            data: &[u8],
            raw_fsz: usize,
            cc: &CropCalc,
            g: &Geom,
            pkg: &mut WorkPkg,
        ) {
            let len = ch.end - ch.start;
            let mut src = data.as_ptr();
            let mut dst = pkg.fit(len * g.pack_fsz);
            for _ in 0..len {
                unsafe {
                    $pack(src.add(cc.y_start), cc.y_stride, g.wu, g.hu, dst);
                    $pack(
                        src.add(cc.u_start),
                        cc.uv_stride,
                        g.hw,
                        g.hh,
                        dst.add(g.y_pack),
                    );
                    $pack(
                        src.add(cc.v_start),
                        cc.uv_stride,
                        g.hw,
                        g.hh,
                        dst.add(g.cr_pack),
                    );
                    src = src.add(raw_fsz);
                    dst = dst.add(g.pack_fsz);
                }
            }
            pkg.set(*ch, len, g.w, g.h);
        }
    };
}

dec_pipe_crop_pack!(dec_pipe_10_crop, pack_stride);
dec_pipe_crop_pack!(dec_pipe_10_crop_rem, pack_stride_rem);

#[inline]
fn dec_pipe_8_crop(
    ch: &Chunk,
    data: &[u8],
    raw_fsz: usize,
    cc: &CropCalc,
    fsz: usize,
    pkg: &mut WorkPkg,
) {
    let len = ch.end - ch.start;
    let mut src = data.as_ptr();
    let mut dst = pkg.fit(len * fsz);
    for _ in 0..len {
        cc.crop(unsafe { from_raw_parts(src, raw_fsz) }, unsafe {
            from_raw_parts_mut(dst, fsz)
        });
        src = unsafe { src.add(raw_fsz) };
        dst = unsafe { dst.add(fsz) };
    }
    pkg.set(*ch, len, cc.new_w, cc.new_h);
}

#[inline]
fn dec_pipe_raw_crop(
    ch: &Chunk,
    data: &[u8],
    raw_fsz: usize,
    cc: &CropCalc,
    fsz: usize,
    pkg: &mut WorkPkg,
) {
    let len = ch.end - ch.start;
    let mut src = data.as_ptr();
    let mut dst = pkg.fit(len * fsz);
    for _ in 0..len {
        cc.crop(unsafe { from_raw_parts(src, raw_fsz) }, unsafe {
            from_raw_parts_mut(dst, fsz)
        });
        src = unsafe { src.add(raw_fsz) };
        dst = unsafe { dst.add(fsz) };
    }
    pkg.set(*ch, len, cc.new_w, cc.new_h);
}
