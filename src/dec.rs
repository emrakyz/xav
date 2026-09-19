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
            B8Crop, B8CropFast, B8Fast, B8Stride, B10Crop, B10CropFast, B10CropFastRem, B10CropRem,
            B10Fast, B10FastRem, B10Raw, B10RawCrop, B10RawCropFast, B10RawStride, B10StrideRem,
            HwNv12, HwNv12Crop, HwNv12CropTo10, HwNv12Rem, HwNv12Stride, HwNv12To10,
            HwNv12To10Stride, HwP010CropPack, HwP010CropPackPkRem, HwP010Pack, HwP010PackPkRem,
            HwP010PackRem, HwP010PackRemPkRem, HwP010PackRemPkRemStride, HwP010Raw, HwP010RawCrop,
            HwP010RawRem, HwP010RawRemStride,
        },
        VidDecoder, VidInf, extr_10b_crop, extr_10b_crop_fast, extr_10b_crop_fast_rem,
        extr_10b_crop_rem, extr_10b_pack, extr_10b_pack_rem, extr_10b_pack_stride_rem,
        extr_hw_nv12, extr_hw_nv12_crop, extr_hw_nv12_crop_to10, extr_hw_nv12_rem,
        extr_hw_nv12_stride, extr_hw_nv12_to10, extr_hw_nv12_to10_stride, extr_hw_p010_raw,
        extr_hw_p010_raw_crop, extr_hw_p010_raw_rem, extr_hw_p010_raw_rem_stride, extr_raw,
        extr_raw_crop, extr_raw_crop_fast, extr_raw_stride,
    },
    pack::{
        PACK_CHUNK, SHIFT_CHUNK, calc_8b_sz, calc_packed_sz, pack_stride, packed_row_sz,
        xav_pack_10b, xav_pack_10b_rem,
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
    pub y_start_ls: usize,
    pub uv_off_ls: usize,
}

impl CropCalc {
    pub const fn new(inf: &VidInf, crop: (u32, u32), pix_sz: usize, nv: bool) -> Self {
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
        let chb = ch as usize * pix_sz;
        let (cv, chb_c) = (cv as usize, if nv { chb } else { chb / 2 });

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
            y_start_ls: cv * inf.y_linesz + chb,
            uv_off_ls: cv / 2 * inf.uv_linesz + chb_c,
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
    pub uv_pack: usize,
    pub cr_pack: usize,
    pub pack_fsz: usize,
    pub y_row_pack: usize,
    pub c_row_pack: usize,
    pub y_iters: usize,
    pub c_iters: usize,
    pub y_row_iters: usize,
    pub c_row_iters: usize,
    pub shift_iters: usize,
    pub deint_iters: usize,
}

impl Geom {
    pub const fn new(w: u32, h: u32, pix_sz: usize) -> Self {
        let (wu, hu) = (w as usize, h as usize);
        let (hw, hh) = (wu / 2, hu / 2);
        let y_stride = wu * pix_sz;
        let c_stride = hw * pix_sz;
        let y_sz = y_stride * hu;
        let uv_sz = c_stride * hh;
        let y_row_pack = packed_row_sz(wu);
        let c_row_pack = packed_row_sz(hw);
        let y_pack = y_row_pack * hu;
        let uv_pack = c_row_pack * hh;
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
            uv_pack,
            cr_pack: y_pack + uv_pack,
            pack_fsz: calc_packed_sz(w, h),
            y_row_pack,
            c_row_pack,
            y_iters: y_sz / PACK_CHUNK,
            c_iters: uv_sz / PACK_CHUNK,
            y_row_iters: y_stride / PACK_CHUNK,
            c_row_iters: c_stride / PACK_CHUNK,
            shift_iters: y_sz / (2 * SHIFT_CHUNK),
            deint_iters: uv_sz / (2 * SHIFT_CHUNK),
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

#[inline(always)]
fn run<C: Copy>(
    filtered: &[Chunk],
    dec: &mut VidDecoder,
    sk: &Sink,
    ctx: C,
    f: fn(&Chunk, &mut VidDecoder, C, &mut WorkPkg),
) {
    for ch in filtered {
        emit(sk, |p| f(ch, dec, ctx, p));
    }
}

pub fn dec_chnks(
    chnks: &[Chunk],
    path: &Path,
    inf: &VidInf,
    skip: &BTreeSet<u16>,
    strat: &DecStrat,
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
    match *strat {
        B8Fast
        | B8Stride
        | B8Crop { .. }
        | B8CropFast { .. }
        | B10Raw
        | B10RawStride
        | B10RawCrop { .. }
        | B10RawCropFast { .. }
        | HwNv12
        | HwNv12Rem
        | HwNv12Stride
        | HwNv12Crop { .. }
        | HwNv12To10
        | HwNv12To10Stride
        | HwNv12CropTo10 { .. } => {
            disp_raw(&filtered, &mut dec, inf, strat, sk);
        }
        HwP010Raw | HwP010RawRem | HwP010RawRemStride | HwP010RawCrop { .. } => {
            disp_hw_10b_raw(&filtered, &mut dec, inf, strat, sk);
        }
        HwP010Pack
        | HwP010PackPkRem
        | HwP010PackRem
        | HwP010PackRemPkRem
        | HwP010PackRemPkRemStride
        | HwP010CropPack { .. }
        | HwP010CropPackPkRem { .. } => {
            disp_hw_10b_pack(&filtered, &mut dec, inf, strat, sk);
        }
        _ => disp_10b(&filtered, &mut dec, inf, strat, sk),
    }
}

fn disp_10b(filtered: &[Chunk], dec: &mut VidDecoder, inf: &VidInf, strat: &DecStrat, sk: &Sink) {
    let g = Geom::new(inf.width, inf.height, 2);
    match *strat {
        B10Fast => run(filtered, dec, sk, &g, dec_10_fast),
        B10FastRem => run(filtered, dec, sk, &g, dec_10_fast_rem),
        B10StrideRem => run(filtered, dec, sk, &g, dec_10_stride_rem),
        B10CropFast { ref cc } => run(filtered, dec, sk, cc, dec_10_crop_fast),
        B10CropFastRem { ref cc } => run(filtered, dec, sk, cc, dec_10_crop_fast_rem),
        B10Crop { ref cc } => run(filtered, dec, sk, cc, dec_10_crop),
        B10CropRem { ref cc } => run(filtered, dec, sk, cc, dec_10_crop_rem),
        _ => assume_unreachable(),
    }
}

fn disp_raw(filtered: &[Chunk], dec: &mut VidDecoder, inf: &VidInf, strat: &DecStrat, sk: &Sink) {
    let g = Geom::new(inf.width, inf.height, if inf.is_10b { 2 } else { 1 });
    match *strat {
        B8Fast | B10Raw => run(filtered, dec, sk, &g, dec_raw),
        B8Stride | B10RawStride => run(filtered, dec, sk, &g, dec_raw_stride),
        B8CropFast { ref cc } | B10RawCropFast { ref cc } => {
            run(filtered, dec, sk, cc, dec_raw_crop_fast);
        }
        B8Crop { ref cc } | B10RawCrop { ref cc } => run(filtered, dec, sk, cc, dec_raw_crop),
        HwNv12 => run(filtered, dec, sk, &g, dec_hw_nv12),
        HwNv12Rem => run(filtered, dec, sk, &g, dec_hw_nv12_rem),
        HwNv12Stride => run(filtered, dec, sk, &g, dec_hw_nv12_stride),
        HwNv12Crop { ref cc } => run(filtered, dec, sk, cc, dec_hw_nv12_crop),
        HwNv12To10 => run(filtered, dec, sk, &g, dec_hw_nv12_to10),
        HwNv12To10Stride => run(filtered, dec, sk, &g, dec_hw_nv12_to10_stride),
        HwNv12CropTo10 { ref cc } => run(filtered, dec, sk, cc, dec_hw_nv12_crop_to10),
        _ => assume_unreachable(),
    }
}

fn disp_hw_10b_raw(
    filtered: &[Chunk],
    dec: &mut VidDecoder,
    inf: &VidInf,
    strat: &DecStrat,
    sk: &Sink,
) {
    let g = Geom::new(inf.width, inf.height, 2);
    match *strat {
        HwP010Raw => run(filtered, dec, sk, &g, dec_hw_p010_raw),
        HwP010RawRem => run(filtered, dec, sk, &g, dec_hw_p010_raw_rem),
        HwP010RawRemStride => run(filtered, dec, sk, &g, dec_hw_p010_raw_rem_stride),
        HwP010RawCrop { ref cc } => run(filtered, dec, sk, cc, dec_hw_p010_raw_crop),
        _ => assume_unreachable(),
    }
}

fn disp_hw_10b_pack(
    filtered: &[Chunk],
    dec: &mut VidDecoder,
    inf: &VidInf,
    strat: &DecStrat,
    sk: &Sink,
) {
    let g = match *strat {
        HwP010CropPack { ref cc } | HwP010CropPackPkRem { ref cc } => cc.g,
        _ => Geom::new(inf.width, inf.height, 2),
    };
    let mut raw_buf = Vec::new();
    #[expect(clippy::uninit_vec, reason = "decode fills every byte")]
    unsafe {
        raw_buf.reserve(g.fsz);
        raw_buf.set_len(g.fsz);
    }

    macro_rules! run {
        ($dec_fn:ident, $ctx:expr) => {
            for ch in filtered {
                emit(sk, |p| $dec_fn(ch, dec, $ctx, &g, &mut raw_buf, p));
            }
        };
    }
    match *strat {
        HwP010Pack => run!(dec_hw_p010_pack, &g),
        HwP010PackPkRem => run!(dec_hw_p010_pack_pkrem, &g),
        HwP010PackRem => run!(dec_hw_p010_pack_rem, &g),
        HwP010PackRemPkRem => run!(dec_hw_p010_pack_rem_pkrem, &g),
        HwP010PackRemPkRemStride => run!(dec_hw_p010_pack_rem_pkrem_stride, &g),
        HwP010CropPack { ref cc } => run!(dec_hw_p010_crop_pack, cc),
        HwP010CropPackPkRem { ref cc } => run!(dec_hw_p010_crop_pack_pkrem, cc),
        _ => assume_unreachable(),
    }
}

#[inline]
fn pack_hw_planes(raw_buf: &[u8], dst: &mut [u8], g: &Geom) {
    let (s, d) = (raw_buf.as_ptr(), dst.as_mut_ptr());
    unsafe {
        xav_pack_10b(s, d, g.y_iters);
        xav_pack_10b(s.add(g.y_sz), d.add(g.y_pack), g.c_iters);
        xav_pack_10b(s.add(g.cr_off), d.add(g.cr_pack), g.c_iters);
    }
}

#[inline]
fn pack_hw_planes_rem(raw_buf: &[u8], dst: &mut [u8], g: &Geom) {
    let (s, d) = (raw_buf.as_ptr(), dst.as_mut_ptr());
    let (w, h) = (g.wu, g.hu);
    let (hw, hh) = (w / 2, h / 2);
    unsafe {
        xav_pack_10b_rem(s, w * 2, w, h, d);
        xav_pack_10b_rem(s.add(g.y_sz), w, hw, hh, d.add(g.y_pack));
        xav_pack_10b_rem(s.add(g.cr_off), w, hw, hh, d.add(g.cr_pack));
    }
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
    dec_hw_p010_pack_rem_pkrem_stride,
    extr_hw_p010_raw_rem_stride,
    pack_hw_planes_rem,
    &Geom,
    g
);

macro_rules! dec_linear {
    ($name:ident, $extr_fn:ident, $ctx_ty:ty, $ctx_arg:ident, $g:expr, $fsz:ident) => {
        dec_linear!($name, $extr_fn, $ctx_ty, $ctx_arg, $g, $fsz, dec_next);
    };
    ($name:ident, $extr_fn:ident, $ctx_ty:ty, $ctx_arg:ident, $g:expr, $fsz:ident, $next:ident) => {
        #[inline]
        fn $name(ch: &Chunk, dec: &mut VidDecoder, $ctx_arg: $ctx_ty, pkg: &mut WorkPkg) {
            dec.skip_to(ch.start);
            let len = ch.end - ch.start;
            let fsz = $g.$fsz;
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
            pkg.set(*ch, actual, $g.w, $g.h);
        }
    };
}

dec_linear!(dec_10_fast, extr_10b_pack, &Geom, g, g, pack_fsz);
dec_linear!(
    dec_10_crop_fast,
    extr_10b_crop_fast,
    &CropCalc,
    cc,
    cc.g,
    pack_fsz
);
dec_linear!(
    dec_10_crop_fast_rem,
    extr_10b_crop_fast_rem,
    &CropCalc,
    cc,
    cc.g,
    pack_fsz
);
dec_linear!(dec_10_crop, extr_10b_crop, &CropCalc, cc, cc.g, pack_fsz);
dec_linear!(dec_10_fast_rem, extr_10b_pack_rem, &Geom, g, g, pack_fsz);
dec_linear!(
    dec_10_stride_rem,
    extr_10b_pack_stride_rem,
    &Geom,
    g,
    g,
    pack_fsz
);
dec_linear!(
    dec_10_crop_rem,
    extr_10b_crop_rem,
    &CropCalc,
    cc,
    cc.g,
    pack_fsz
);
dec_linear!(dec_raw, extr_raw, &Geom, g, g, fsz);
dec_linear!(dec_raw_stride, extr_raw_stride, &Geom, g, g, fsz);
dec_linear!(
    dec_raw_crop_fast,
    extr_raw_crop_fast,
    &CropCalc,
    cc,
    cc.g,
    fsz
);
dec_linear!(dec_raw_crop, extr_raw_crop, &CropCalc, cc, cc.g, fsz);
dec_linear!(dec_hw_nv12, extr_hw_nv12, &Geom, g, g, fsz, dec_next_hw);
dec_linear!(
    dec_hw_nv12_rem,
    extr_hw_nv12_rem,
    &Geom,
    g,
    g,
    fsz,
    dec_next_hw
);
dec_linear!(
    dec_hw_nv12_stride,
    extr_hw_nv12_stride,
    &Geom,
    g,
    g,
    fsz,
    dec_next_hw
);
dec_linear!(
    dec_hw_nv12_crop,
    extr_hw_nv12_crop,
    &CropCalc,
    cc,
    cc.g,
    fsz,
    dec_next_hw
);
dec_linear!(
    dec_hw_nv12_to10,
    extr_hw_nv12_to10,
    &Geom,
    g,
    g,
    fsz,
    dec_next_hw
);
dec_linear!(
    dec_hw_nv12_to10_stride,
    extr_hw_nv12_to10_stride,
    &Geom,
    g,
    g,
    fsz,
    dec_next_hw
);
dec_linear!(
    dec_hw_nv12_crop_to10,
    extr_hw_nv12_crop_to10,
    &CropCalc,
    cc,
    cc.g,
    fsz,
    dec_next_hw
);
dec_linear!(
    dec_hw_p010_raw,
    extr_hw_p010_raw,
    &Geom,
    g,
    g,
    fsz,
    dec_next_hw
);
dec_linear!(
    dec_hw_p010_raw_crop,
    extr_hw_p010_raw_crop,
    &CropCalc,
    cc,
    cc.g,
    fsz,
    dec_next_hw
);
dec_linear!(
    dec_hw_p010_raw_rem,
    extr_hw_p010_raw_rem,
    &Geom,
    g,
    g,
    fsz,
    dec_next_hw
);
dec_linear!(
    dec_hw_p010_raw_rem_stride,
    extr_hw_p010_raw_rem_stride,
    &Geom,
    g,
    g,
    fsz,
    dec_next_hw
);

pub fn dec_pipe(
    chnks: &[Chunk],
    reader: &mut PipeReader,
    inf: &VidInf,
    skip: &BTreeSet<u16>,
    strat: &DecStrat,
    sk: &Sink,
) {
    let chnks = chnks.get(reader.start_idx..).unwrap_or(chnks);
    let cc = match *strat {
        B10Crop { ref cc }
        | B10CropRem { ref cc }
        | B10CropFast { ref cc }
        | B10CropFastRem { ref cc }
        | B8Crop { ref cc }
        | B8CropFast { ref cc }
        | B10RawCrop { ref cc }
        | B10RawCropFast { ref cc }
        | HwNv12Crop { ref cc }
        | HwNv12CropTo10 { ref cc }
        | HwP010RawCrop { ref cc }
        | HwP010CropPack { ref cc }
        | HwP010CropPackPkRem { ref cc } => Some(cc),
        _ => None,
    };

    let (w, h) = cc.map_or((inf.width, inf.height), |c| (c.new_w, c.new_h));
    let raw_fsz = reader.frame_sz;

    if strat.is_raw() {
        let fsz = w as usize * h as usize * 3;
        if let Some(cc) = cc {
            pipe_loop(chnks, reader, skip, sk, raw_fsz, |ch, raw, pkg| {
                dec_pipe_crop(ch, raw, raw_fsz, cc, fsz, pkg);
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
            pipe_loop(chnks, reader, skip, sk, raw_fsz, |ch, raw, pkg| {
                dec_pipe_10_crop(ch, raw, raw_fsz, cc, pkg);
            });
        }
        (true, Some(cc), true) => {
            pipe_loop(chnks, reader, skip, sk, raw_fsz, |ch, raw, pkg| {
                dec_pipe_10_crop_rem(ch, raw, raw_fsz, cc, pkg);
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
                dec_pipe_crop(ch, raw, raw_fsz, cc, fsz, pkg);
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
    let mut raw = Vec::new();
    #[expect(clippy::uninit_vec, reason = "read_frame fills every byte")]
    unsafe {
        raw.reserve(MAX_CHNK_FRAMES * raw_fsz);
        raw.set_len(MAX_CHNK_FRAMES * raw_fsz);
    }
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
    ($name:ident, $pack:ident, $g:ident, ($($y:expr),*), ($($c:expr),*)) => {
        #[inline]
        fn $name(ch: &Chunk, data: &[u8], raw_fsz: usize, cc: &CropCalc, pkg: &mut WorkPkg) {
            let $g = &cc.g;
            let len = ch.end - ch.start;
            let mut src = data.as_ptr();
            let mut dst = pkg.fit(len * $g.pack_fsz);
            for _ in 0..len {
                unsafe {
                    $pack(src.add(cc.y_start), cc.y_stride, $($y,)* dst);
                    $pack(src.add(cc.u_start), cc.uv_stride, $($c,)* dst.add($g.y_pack));
                    $pack(src.add(cc.v_start), cc.uv_stride, $($c,)* dst.add($g.cr_pack));
                    src = src.add(raw_fsz);
                    dst = dst.add($g.pack_fsz);
                }
            }
            pkg.set(*ch, len, $g.w, $g.h);
        }
    };
}

dec_pipe_crop_pack!(
    dec_pipe_10_crop,
    pack_stride,
    g,
    (g.hu, g.y_row_iters, g.y_row_pack),
    (g.hh, g.c_row_iters, g.c_row_pack)
);
dec_pipe_crop_pack!(
    dec_pipe_10_crop_rem,
    xav_pack_10b_rem,
    g,
    (g.wu, g.hu),
    (g.hw, g.hh)
);

#[inline]
fn dec_pipe_crop(
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
