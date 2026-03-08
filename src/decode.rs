use std::{collections::HashSet, path::Path, sync::Arc, thread::available_parallelism};

use crossbeam_channel::Sender;

use crate::{
    chunk::Chunk,
    error::fatal,
    ffms::{
        DecodeStrat,
        DecodeStrat::{
            B8Crop, B8CropFast, B8CropStride, B8Fast, B8Stride, B10Crop, B10CropFast,
            B10CropFastRem, B10CropRem, B10CropStride, B10CropStrideRem, B10Fast, B10FastRem,
            B10Raw, B10RawCrop, B10RawCropFast, B10RawCropStride, B10RawStride, B10Stride,
            B10StrideRem, HwNv12, HwNv12Crop, HwP010CropPack, HwP010Pack, HwP010Raw, HwP010RawCrop,
        },
        VidInf, VideoDecoder, calc_8bit_size, calc_packed_size, extr_8bit, extr_8bit_crop,
        extr_8bit_crop_fast, extr_8bit_fast, extr_8bit_stride, extr_10bit_crop,
        extr_10bit_crop_fast, extr_10bit_crop_fast_rem, extr_10bit_crop_pack_stride,
        extr_10bit_crop_pack_stride_rem, extr_10bit_crop_rem, extr_10bit_pack, extr_10bit_pack_rem,
        extr_10bit_pack_stride, extr_10bit_pack_stride_rem, extr_10bit_raw, extr_10bit_raw_crop,
        extr_10bit_raw_crop_fast, extr_10bit_raw_crop_stride, extr_10bit_raw_stride, extr_hw_nv12,
        extr_hw_nv12_crop, extr_hw_p010_raw, extr_hw_p010_raw_crop, pack_10bit, pack_10bit_rem,
    },
    util::assume_unreachable,
    worker::{Semaphore, WorkPkg},
    y4m::PipeReader,
};

#[derive(Debug, Clone, Copy)]
pub struct CropCalc {
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
        let mut pos = 0;

        for row in 0..self.new_h as usize {
            let off = self.y_start + row * self.y_stride;
            dst[pos..pos + self.y_len].copy_from_slice(&src[off..off + self.y_len]);
            pos += self.y_len;
        }

        for row in 0..self.new_h as usize / 2 {
            let off = self.u_start + row * self.uv_stride;
            dst[pos..pos + self.uv_len].copy_from_slice(&src[off..off + self.uv_len]);
            pos += self.uv_len;
        }

        for row in 0..self.new_h as usize / 2 {
            let off = self.v_start + row * self.uv_stride;
            dst[pos..pos + self.uv_len].copy_from_slice(&src[off..off + self.uv_len]);
            pos += self.uv_len;
        }
    }
}

pub fn decode_chunks(
    chunks: &[Chunk],
    path: &Path,
    inf: &VidInf,
    tx: &Sender<WorkPkg>,
    skip: &HashSet<usize>,
    strat: DecodeStrat,
    sem: &Arc<Semaphore>,
) {
    let thr = unsafe { available_parallelism().unwrap_unchecked().get() as i32 };
    let dec = if strat.is_hw() {
        VideoDecoder::new_hw(path, thr)
    } else {
        VideoDecoder::new(path, thr)
    };
    let mut dec = match dec {
        Ok(d) => d,
        Err(e) => fatal(e),
    };
    let filtered: Vec<Chunk> = chunks
        .iter()
        .filter(|c| !skip.contains(&c.idx))
        .cloned()
        .collect();
    match strat {
        B8Fast
        | B8Stride
        | B8CropFast { .. }
        | B8Crop { .. }
        | B8CropStride { .. }
        | HwNv12
        | HwNv12Crop { .. } => {
            dispatch_8bit(&filtered, &mut dec, inf, tx, strat, sem);
        }
        HwP010Raw | HwP010RawCrop { .. } => {
            dispatch_hw_10bit_raw(&filtered, &mut dec, inf, tx, strat, sem);
        }
        HwP010Pack | HwP010CropPack { .. } => {
            dispatch_hw_10bit_pack(&filtered, &mut dec, inf, tx, strat, sem);
        }
        _ => dispatch_10bit(&filtered, &mut dec, inf, tx, strat, sem),
    }
}

fn dispatch_10bit(
    filtered: &[Chunk],
    dec: &mut VideoDecoder,
    inf: &VidInf,
    tx: &Sender<WorkPkg>,
    strat: DecodeStrat,
    sem: &Arc<Semaphore>,
) {
    if strat.is_raw() {
        dispatch_10bit_raw(filtered, dec, inf, tx, strat, sem);
        return;
    }
    match strat {
        B10Fast => {
            let f = calc_packed_size(inf.width, inf.height);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_10_fast(ch, dec, inf, inf.width, inf.height, f));
            }
        }
        B10FastRem => {
            let f = calc_packed_size(inf.width, inf.height);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_10_fast_rem(ch, dec, inf, inf.width, inf.height, f));
            }
        }
        B10Stride => {
            let f = calc_packed_size(inf.width, inf.height);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_10_stride(ch, dec, inf, inf.width, inf.height, f));
            }
        }
        B10StrideRem => {
            let f = calc_packed_size(inf.width, inf.height);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_10_stride_rem(ch, dec, inf, inf.width, inf.height, f));
            }
        }
        B10CropFast { cc } => {
            let f = calc_packed_size(cc.new_w, cc.new_h);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_10_crop_fast(ch, dec, &cc, cc.new_w, cc.new_h, f));
            }
        }
        B10CropFastRem { cc } => {
            let f = calc_packed_size(cc.new_w, cc.new_h);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_10_crop_fast_rem(ch, dec, &cc, cc.new_w, cc.new_h, f));
            }
        }
        B10Crop { cc } => {
            let f = calc_packed_size(cc.new_w, cc.new_h);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_10_crop(ch, dec, &cc, cc.new_w, cc.new_h, f));
            }
        }
        B10CropRem { cc } => {
            let f = calc_packed_size(cc.new_w, cc.new_h);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_10_crop_rem(ch, dec, &cc, cc.new_w, cc.new_h, f));
            }
        }
        B10CropStride { cc } => {
            let f = calc_packed_size(cc.new_w, cc.new_h);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_10_crop_stride(ch, dec, &cc, cc.new_w, cc.new_h, f));
            }
        }
        B10CropStrideRem { cc } => {
            let f = calc_packed_size(cc.new_w, cc.new_h);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_10_crop_stride_rem(ch, dec, &cc, cc.new_w, cc.new_h, f));
            }
        }
        _ => assume_unreachable(),
    }
}

fn dispatch_10bit_raw(
    filtered: &[Chunk],
    dec: &mut VideoDecoder,
    inf: &VidInf,
    tx: &Sender<WorkPkg>,
    strat: DecodeStrat,
    sem: &Arc<Semaphore>,
) {
    match strat {
        B10Raw => {
            let f = (inf.width as usize * inf.height as usize) * 3;
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_10_raw(ch, dec, inf, inf.width, inf.height, f));
            }
        }
        B10RawStride => {
            let f = (inf.width as usize * inf.height as usize) * 3;
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_10_raw_stride(ch, dec, inf, inf.width, inf.height, f));
            }
        }
        B10RawCropFast { cc } => {
            let f = (cc.new_w as usize * cc.new_h as usize) * 3;
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_10_raw_crop_fast(ch, dec, &cc, cc.new_w, cc.new_h, f));
            }
        }
        B10RawCrop { cc } => {
            let f = (cc.new_w as usize * cc.new_h as usize) * 3;
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_10_raw_crop(ch, dec, &cc, cc.new_w, cc.new_h, f));
            }
        }
        B10RawCropStride { cc } => {
            let f = (cc.new_w as usize * cc.new_h as usize) * 3;
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_10_raw_crop_stride(ch, dec, &cc, cc.new_w, cc.new_h, f));
            }
        }
        _ => assume_unreachable(),
    }
}

fn dispatch_8bit(
    filtered: &[Chunk],
    dec: &mut VideoDecoder,
    inf: &VidInf,
    tx: &Sender<WorkPkg>,
    strat: DecodeStrat,
    sem: &Arc<Semaphore>,
) {
    match strat {
        B8Fast => {
            let f = calc_8bit_size(inf.width, inf.height);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_8_fast(ch, dec, inf, inf.width, inf.height, f));
            }
        }
        B8Stride => {
            let f = calc_8bit_size(inf.width, inf.height);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_8_stride(ch, dec, inf, inf.width, inf.height, f));
            }
        }
        B8CropFast { cc } => {
            let f = calc_8bit_size(cc.new_w, cc.new_h);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_8_crop_fast(ch, dec, &cc, cc.new_w, cc.new_h, f));
            }
        }
        B8Crop { cc } => {
            let f = calc_8bit_size(cc.new_w, cc.new_h);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_8_crop(ch, dec, &cc, cc.new_w, cc.new_h, f));
            }
        }
        B8CropStride { cc } => {
            let f = calc_8bit_size(cc.new_w, cc.new_h);
            let mut buf = vec![0u8; calc_8bit_size(inf.width, inf.height)];
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_8_crop_stride(ch, dec, inf, &cc, f, &mut buf));
            }
        }
        HwNv12 => {
            let f = calc_8bit_size(inf.width, inf.height);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_hw_nv12(ch, dec, inf, inf.width, inf.height, f));
            }
        }
        HwNv12Crop { cc } => {
            let f = calc_8bit_size(cc.new_w, cc.new_h);
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_hw_nv12_crop(ch, dec, &cc, cc.new_w, cc.new_h, f));
            }
        }
        _ => assume_unreachable(),
    }
}

fn dispatch_hw_10bit_raw(
    filtered: &[Chunk],
    dec: &mut VideoDecoder,
    inf: &VidInf,
    tx: &Sender<WorkPkg>,
    strat: DecodeStrat,
    sem: &Arc<Semaphore>,
) {
    match strat {
        HwP010Raw => {
            let f = (inf.width as usize * inf.height as usize) * 3;
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_hw_p010_raw(ch, dec, inf, inf.width, inf.height, f));
            }
        }
        HwP010RawCrop { cc } => {
            let f = (cc.new_w as usize * cc.new_h as usize) * 3;
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_hw_p010_raw_crop(ch, dec, &cc, cc.new_w, cc.new_h, f));
            }
        }
        _ => assume_unreachable(),
    }
}

fn dispatch_hw_10bit_pack(
    filtered: &[Chunk],
    dec: &mut VideoDecoder,
    inf: &VidInf,
    tx: &Sender<WorkPkg>,
    strat: DecodeStrat,
    sem: &Arc<Semaphore>,
) {
    let (w, h) = match strat {
        HwP010CropPack { cc } => (cc.new_w, cc.new_h),
        _ => (inf.width, inf.height),
    };
    let fsz = calc_packed_size(w, h);
    let raw_fsz = (w as usize * h as usize) * 3;
    let mut raw_buf = vec![0u8; raw_fsz];

    match strat {
        HwP010Pack => {
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_hw_p010_pack(ch, dec, inf, w, h, fsz, &mut raw_buf));
            }
        }
        HwP010CropPack { cc } => {
            for ch in filtered {
                sem.acquire();
                _ = tx.send(dec_hw_p010_crop_pack(ch, dec, &cc, w, h, fsz, &mut raw_buf));
            }
        }
        _ => assume_unreachable(),
    }
}

#[inline]
fn dec_hw_p010_pack(
    ch: &Chunk,
    dec: &mut VideoDecoder,
    inf: &VidInf,
    w: u32,
    h: u32,
    fsz: usize,
    raw_buf: &mut [u8],
) -> WorkPkg {
    dec.skip_to(ch.start);
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for i in 0..len {
        let frame = dec.decode_next();
        extr_hw_p010_raw(frame, raw_buf, inf);
        if w.is_multiple_of(8) {
            let y_raw = (w as usize * h as usize) * 2;
            let uv_raw = y_raw / 4;
            let y_pack = (w as usize * h as usize * 5) / 4;
            let uv_pack = (w as usize * h as usize / 4 * 5) / 4;
            let dst = &mut dat[i * fsz..(i + 1) * fsz];
            pack_10bit(&raw_buf[..y_raw], &mut dst[..y_pack]);
            pack_10bit(
                &raw_buf[y_raw..y_raw + uv_raw],
                &mut dst[y_pack..y_pack + uv_pack],
            );
            pack_10bit(
                &raw_buf[y_raw + uv_raw..y_raw + 2 * uv_raw],
                &mut dst[y_pack + uv_pack..],
            );
        } else {
            pack_10bit_rem(
                raw_buf,
                &mut dat[i * fsz..(i + 1) * fsz],
                w as usize,
                h as usize,
            );
        }
    }
    WorkPkg::new(ch.clone(), dat, len, w, h)
}

#[inline]
fn dec_hw_p010_crop_pack(
    ch: &Chunk,
    dec: &mut VideoDecoder,
    cc: &CropCalc,
    w: u32,
    h: u32,
    fsz: usize,
    raw_buf: &mut [u8],
) -> WorkPkg {
    dec.skip_to(ch.start);
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for i in 0..len {
        let frame = dec.decode_next();
        extr_hw_p010_raw_crop(frame, raw_buf, cc);
        if w.is_multiple_of(8) {
            let y_raw = (w as usize * h as usize) * 2;
            let uv_raw = y_raw / 4;
            let y_pack = (w as usize * h as usize * 5) / 4;
            let uv_pack = (w as usize * h as usize / 4 * 5) / 4;
            let dst = &mut dat[i * fsz..(i + 1) * fsz];
            pack_10bit(&raw_buf[..y_raw], &mut dst[..y_pack]);
            pack_10bit(
                &raw_buf[y_raw..y_raw + uv_raw],
                &mut dst[y_pack..y_pack + uv_pack],
            );
            pack_10bit(
                &raw_buf[y_raw + uv_raw..y_raw + 2 * uv_raw],
                &mut dst[y_pack + uv_pack..],
            );
        } else {
            pack_10bit_rem(
                raw_buf,
                &mut dat[i * fsz..(i + 1) * fsz],
                w as usize,
                h as usize,
            );
        }
    }
    WorkPkg::new(ch.clone(), dat, len, w, h)
}

macro_rules! dec_linear {
    ($name:ident, $extr_fn:ident, $ctx_ty:ty, $ctx_arg:ident) => {
        #[inline]
        fn $name(
            ch: &Chunk,
            dec: &mut VideoDecoder,
            $ctx_arg: $ctx_ty,
            w: u32,
            h: u32,
            fsz: usize,
        ) -> WorkPkg {
            dec.skip_to(ch.start);
            let len = ch.end - ch.start;
            let mut dat = vec![0u8; len * fsz];
            for i in 0..len {
                let frame = dec.decode_next();
                $extr_fn(frame, &mut dat[i * fsz..(i + 1) * fsz], $ctx_arg);
            }
            WorkPkg::new(ch.clone(), dat, len, w, h)
        }
    };
}

dec_linear!(dec_10_fast, extr_10bit_pack, &VidInf, inf);
dec_linear!(dec_10_stride, extr_10bit_pack_stride, &VidInf, inf);
dec_linear!(dec_10_crop_fast, extr_10bit_crop_fast, &CropCalc, cc);
dec_linear!(dec_10_crop, extr_10bit_crop, &CropCalc, cc);
dec_linear!(dec_10_fast_rem, extr_10bit_pack_rem, &VidInf, inf);
dec_linear!(dec_10_stride_rem, extr_10bit_pack_stride_rem, &VidInf, inf);
dec_linear!(
    dec_10_crop_fast_rem,
    extr_10bit_crop_fast_rem,
    &CropCalc,
    cc
);
dec_linear!(dec_10_crop_rem, extr_10bit_crop_rem, &CropCalc, cc);
dec_linear!(dec_10_raw, extr_10bit_raw, &VidInf, inf);
dec_linear!(dec_10_raw_stride, extr_10bit_raw_stride, &VidInf, inf);
dec_linear!(
    dec_10_raw_crop_fast,
    extr_10bit_raw_crop_fast,
    &CropCalc,
    cc
);
dec_linear!(dec_10_raw_crop, extr_10bit_raw_crop, &CropCalc, cc);
dec_linear!(
    dec_10_raw_crop_stride,
    extr_10bit_raw_crop_stride,
    &CropCalc,
    cc
);
dec_linear!(
    dec_10_crop_stride,
    extr_10bit_crop_pack_stride,
    &CropCalc,
    cc
);
dec_linear!(
    dec_10_crop_stride_rem,
    extr_10bit_crop_pack_stride_rem,
    &CropCalc,
    cc
);
dec_linear!(dec_8_fast, extr_8bit_fast, &VidInf, inf);
dec_linear!(dec_8_stride, extr_8bit_stride, &VidInf, inf);
dec_linear!(dec_8_crop_fast, extr_8bit_crop_fast, &CropCalc, cc);
dec_linear!(dec_8_crop, extr_8bit_crop, &CropCalc, cc);
dec_linear!(dec_hw_nv12, extr_hw_nv12, &VidInf, inf);
dec_linear!(dec_hw_nv12_crop, extr_hw_nv12_crop, &CropCalc, cc);
dec_linear!(dec_hw_p010_raw, extr_hw_p010_raw, &VidInf, inf);
dec_linear!(dec_hw_p010_raw_crop, extr_hw_p010_raw_crop, &CropCalc, cc);

#[inline]
fn dec_8_crop_stride(
    ch: &Chunk,
    dec: &mut VideoDecoder,
    inf: &VidInf,
    cc: &CropCalc,
    fsz: usize,
    buf: &mut [u8],
) -> WorkPkg {
    dec.skip_to(ch.start);
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for i in 0..len {
        let frame = dec.decode_next();
        extr_8bit(frame, buf, inf);
        cc.crop(buf, &mut dat[i * fsz..(i + 1) * fsz]);
    }
    WorkPkg::new(ch.clone(), dat, len, cc.new_w, cc.new_h)
}

pub fn decode_pipe(
    chunks: &[Chunk],
    reader: &mut PipeReader,
    inf: &VidInf,
    tx: &Sender<WorkPkg>,
    skip: &HashSet<usize>,
    strat: DecodeStrat,
    sem: &Arc<Semaphore>,
) {
    let cc = match strat {
        B10CropFast { cc }
        | B10CropFastRem { cc }
        | B10Crop { cc }
        | B10CropRem { cc }
        | B10CropStride { cc }
        | B10CropStrideRem { cc }
        | B8CropFast { cc }
        | B8Crop { cc }
        | B8CropStride { cc }
        | B10RawCropFast { cc }
        | B10RawCrop { cc }
        | B10RawCropStride { cc }
        | HwNv12Crop { cc }
        | HwP010RawCrop { cc }
        | HwP010CropPack { cc } => Some(cc),
        _ => None,
    };

    let (w, h) = cc.map_or((inf.width, inf.height), |c| (c.new_w, c.new_h));
    let raw_fsz = reader.frame_size;

    if strat.is_raw() {
        let fsz = w as usize * h as usize * 3;
        if let Some(cc) = cc {
            pipe_loop(chunks, reader, skip, sem, tx, raw_fsz, |ch, raw| {
                dec_pipe_raw_crop(ch, raw, raw_fsz, &cc, fsz)
            });
        } else {
            pipe_loop(chunks, reader, skip, sem, tx, raw_fsz, |ch, raw| {
                dec_pipe_raw(ch, raw, fsz, w, h)
            });
        }
        return;
    }

    let fsz = if inf.is_10bit {
        calc_packed_size(w, h)
    } else {
        calc_8bit_size(w, h)
    };
    let has_rem = inf.is_10bit && !w.is_multiple_of(8);

    match (inf.is_10bit, cc, has_rem) {
        (true, Some(cc), false) => {
            let mut crop_buf = vec![0u8; cc.new_w as usize * cc.new_h as usize * 3];
            pipe_loop(chunks, reader, skip, sem, tx, raw_fsz, |ch, raw| {
                dec_pipe_10_crop(ch, raw, raw_fsz, &cc, fsz, &mut crop_buf)
            });
        }
        (true, Some(cc), true) => {
            let mut crop_buf = vec![0u8; cc.new_w as usize * cc.new_h as usize * 3];
            pipe_loop(chunks, reader, skip, sem, tx, raw_fsz, |ch, raw| {
                dec_pipe_10_crop_rem(ch, raw, raw_fsz, &cc, fsz, &mut crop_buf)
            });
        }
        (true, None, false) => {
            pipe_loop(chunks, reader, skip, sem, tx, raw_fsz, |ch, raw| {
                dec_pipe_10(ch, raw, raw_fsz, w, h, fsz)
            });
        }
        (true, None, true) => {
            pipe_loop(chunks, reader, skip, sem, tx, raw_fsz, |ch, raw| {
                dec_pipe_10_rem(ch, raw, raw_fsz, w, h, fsz)
            });
        }
        (false, Some(cc), _) => {
            pipe_loop(chunks, reader, skip, sem, tx, raw_fsz, |ch, raw| {
                dec_pipe_8_crop(ch, raw, raw_fsz, &cc, fsz)
            });
        }
        (false, None, _) => {
            pipe_loop(chunks, reader, skip, sem, tx, raw_fsz, |ch, raw| {
                dec_pipe_8(ch, raw, fsz, w, h)
            });
        }
    }
}

#[inline]
fn pipe_loop<F>(
    chunks: &[Chunk],
    reader: &mut PipeReader,
    skip: &HashSet<usize>,
    sem: &Arc<Semaphore>,
    tx: &Sender<WorkPkg>,
    raw_fsz: usize,
    mut decode: F,
) where
    F: FnMut(&Chunk, &[u8]) -> WorkPkg,
{
    for ch in chunks {
        let len = ch.end - ch.start;

        if skip.contains(&ch.idx) {
            reader.skip_frames(len);
            continue;
        }

        sem.acquire();

        let mut raw = vec![0u8; len * raw_fsz];
        for i in 0..len {
            if !reader.read_frame(&mut raw[i * raw_fsz..(i + 1) * raw_fsz]) {
                return;
            }
        }

        _ = tx.send(decode(ch, &raw));
    }
}

#[inline]
fn dec_pipe_10(ch: &Chunk, data: &[u8], raw_fsz: usize, w: u32, h: u32, fsz: usize) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    let y_raw = (w * h * 2) as usize;
    let uv_raw = y_raw / 4;
    let y_pack = (w as usize * h as usize * 5) / 4;
    let uv_pack = y_pack / 4;
    for i in 0..len {
        let src = &data[i * raw_fsz..(i + 1) * raw_fsz];
        let dst = &mut dat[i * fsz..(i + 1) * fsz];
        pack_10bit(&src[..y_raw], &mut dst[..y_pack]);
        pack_10bit(
            &src[y_raw..y_raw + uv_raw],
            &mut dst[y_pack..y_pack + uv_pack],
        );
        pack_10bit(&src[y_raw + uv_raw..], &mut dst[y_pack + uv_pack..]);
    }
    WorkPkg::new(ch.clone(), dat, len, w, h)
}

#[inline]
fn dec_pipe_10_rem(ch: &Chunk, data: &[u8], raw_fsz: usize, w: u32, h: u32, fsz: usize) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    let y_raw = (w * h * 2) as usize;
    for i in 0..len {
        let src = &data[i * raw_fsz..(i + 1) * raw_fsz];
        let dst = &mut dat[i * fsz..(i + 1) * fsz];
        pack_10bit_rem(&src[..y_raw], dst, w as usize, h as usize);
    }
    WorkPkg::new(ch.clone(), dat, len, w, h)
}

#[inline]
fn dec_pipe_10_crop(
    ch: &Chunk,
    data: &[u8],
    raw_fsz: usize,
    cc: &CropCalc,
    fsz: usize,
    crop_buf: &mut [u8],
) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    let y_pack = (cc.new_w as usize * cc.new_h as usize * 5) / 4;
    let uv_pack = y_pack / 4;
    for i in 0..len {
        let src = &data[i * raw_fsz..(i + 1) * raw_fsz];
        cc.crop(src, crop_buf);
        let y_raw = (cc.new_w * cc.new_h * 2) as usize;
        let uv_raw = y_raw / 4;
        let dst = &mut dat[i * fsz..(i + 1) * fsz];
        pack_10bit(&crop_buf[..y_raw], &mut dst[..y_pack]);
        pack_10bit(
            &crop_buf[y_raw..y_raw + uv_raw],
            &mut dst[y_pack..y_pack + uv_pack],
        );
        pack_10bit(&crop_buf[y_raw + uv_raw..], &mut dst[y_pack + uv_pack..]);
    }
    WorkPkg::new(ch.clone(), dat, len, cc.new_w, cc.new_h)
}

#[inline]
fn dec_pipe_10_crop_rem(
    ch: &Chunk,
    data: &[u8],
    raw_fsz: usize,
    cc: &CropCalc,
    fsz: usize,
    crop_buf: &mut [u8],
) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for i in 0..len {
        let src = &data[i * raw_fsz..(i + 1) * raw_fsz];
        cc.crop(src, crop_buf);
        let y_raw = (cc.new_w * cc.new_h * 2) as usize;
        let dst = &mut dat[i * fsz..(i + 1) * fsz];
        pack_10bit_rem(
            &crop_buf[..y_raw],
            dst,
            cc.new_w as usize,
            cc.new_h as usize,
        );
    }
    WorkPkg::new(ch.clone(), dat, len, cc.new_w, cc.new_h)
}

#[inline]
fn dec_pipe_8(ch: &Chunk, data: &[u8], fsz: usize, w: u32, h: u32) -> WorkPkg {
    let len = ch.end - ch.start;
    let dat = data[..len * fsz].to_vec();
    WorkPkg::new(ch.clone(), dat, len, w, h)
}

#[inline]
fn dec_pipe_8_crop(ch: &Chunk, data: &[u8], raw_fsz: usize, cc: &CropCalc, fsz: usize) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for i in 0..len {
        let src = &data[i * raw_fsz..(i + 1) * raw_fsz];
        cc.crop(src, &mut dat[i * fsz..(i + 1) * fsz]);
    }
    WorkPkg::new(ch.clone(), dat, len, cc.new_w, cc.new_h)
}

#[inline]
fn dec_pipe_raw(ch: &Chunk, data: &[u8], fsz: usize, w: u32, h: u32) -> WorkPkg {
    let len = ch.end - ch.start;
    let dat = data[..len * fsz].to_vec();
    WorkPkg::new(ch.clone(), dat, len, w, h)
}

#[inline]
fn dec_pipe_raw_crop(
    ch: &Chunk,
    data: &[u8],
    raw_fsz: usize,
    cc: &CropCalc,
    fsz: usize,
) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for i in 0..len {
        cc.crop(
            &data[i * raw_fsz..(i + 1) * raw_fsz],
            &mut dat[i * fsz..(i + 1) * fsz],
        );
    }
    WorkPkg::new(ch.clone(), dat, len, cc.new_w, cc.new_h)
}
