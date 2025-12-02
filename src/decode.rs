use std::collections::HashSet;
use std::sync::Arc;

use crossbeam_channel::Sender;

use crate::chunk::Chunk;
use crate::ffms::{
    DecodeStrat, VidIdx, VidInf, calc_8bit_size, calc_packed_size, destroy_vid_src, extr_8bit_crop,
    extr_8bit_crop_fast, extr_8bit_fast, extr_8bit_stride, extr_10bit_crop, extr_10bit_crop_fast,
    extr_10bit_crop_pack_stride, extr_10bit_pack, extr_10bit_pack_stride, thr_vid_src,
};
use crate::worker::{Semaphore, WorkPkg};

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

        Self { new_w, new_h, y_stride, uv_stride, y_start, u_start, v_start, y_len, uv_len, uv_off }
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
    idx: &Arc<VidIdx>,
    inf: &VidInf,
    tx: &Sender<WorkPkg>,
    skip: &HashSet<usize>,
    strat: DecodeStrat,
    sem: Option<&Arc<Semaphore>>,
) {
    let thr = std::thread::available_parallelism().map_or(8, |n| n.get().try_into().unwrap_or(8));
    let Ok(src) = thr_vid_src(idx, thr) else { return };

    let filtered: Vec<Chunk> = chunks.iter().filter(|c| !skip.contains(&c.idx)).cloned().collect();

    match strat {
        DecodeStrat::B10Fast => {
            let fsz = calc_packed_size(inf);
            for ch in &filtered {
                if let Some(s) = sem {
                    s.acquire();
                }
                tx.send(dec_10_fast(ch, src, inf, inf.width, inf.height, fsz)).ok();
            }
        }
        DecodeStrat::B10Stride => {
            let fsz = calc_packed_size(inf);
            for ch in &filtered {
                if let Some(s) = sem {
                    s.acquire();
                }
                tx.send(dec_10_stride(ch, src, inf, inf.width, inf.height, fsz)).ok();
            }
        }
        DecodeStrat::B10CropFast { cc } => {
            let fsz = calc_packed_crop(cc.new_w, cc.new_h);
            for ch in &filtered {
                if let Some(s) = sem {
                    s.acquire();
                }
                tx.send(dec_10_crop_fast(ch, src, &cc, cc.new_w, cc.new_h, fsz)).ok();
            }
        }
        DecodeStrat::B10Crop { cc } => {
            let fsz = calc_packed_crop(cc.new_w, cc.new_h);
            for ch in &filtered {
                if let Some(s) = sem {
                    s.acquire();
                }
                tx.send(dec_10_crop(ch, src, &cc, cc.new_w, cc.new_h, fsz)).ok();
            }
        }
        DecodeStrat::B10CropStride { cc } => {
            let fsz = calc_packed_crop(cc.new_w, cc.new_h);
            for ch in &filtered {
                if let Some(s) = sem {
                    s.acquire();
                }
                tx.send(dec_10_crop_stride(ch, src, &cc, cc.new_w, cc.new_h, fsz)).ok();
            }
        }
        DecodeStrat::B8Fast => {
            let fsz = calc_8bit_size(inf);
            for ch in &filtered {
                if let Some(s) = sem {
                    s.acquire();
                }
                tx.send(dec_8_fast(ch, src, inf, inf.width, inf.height, fsz)).ok();
            }
        }
        DecodeStrat::B8Stride => {
            let fsz = calc_8bit_size(inf);
            for ch in &filtered {
                if let Some(s) = sem {
                    s.acquire();
                }
                tx.send(dec_8_stride(ch, src, inf, inf.width, inf.height, fsz)).ok();
            }
        }
        DecodeStrat::B8CropFast { cc } => {
            let fsz = calc_8bit_crop(cc.new_w, cc.new_h);
            for ch in &filtered {
                if let Some(s) = sem {
                    s.acquire();
                }
                tx.send(dec_8_crop_fast(ch, src, &cc, cc.new_w, cc.new_h, fsz)).ok();
            }
        }
        DecodeStrat::B8Crop { cc } => {
            let fsz = calc_8bit_crop(cc.new_w, cc.new_h);
            for ch in &filtered {
                if let Some(s) = sem {
                    s.acquire();
                }
                tx.send(dec_8_crop(ch, src, &cc, cc.new_w, cc.new_h, fsz)).ok();
            }
        }
        DecodeStrat::B8CropStride { cc } => {
            let fsz = calc_8bit_crop(cc.new_w, cc.new_h);
            let mut buf = vec![0u8; calc_8bit_size(inf)];
            for ch in &filtered {
                if let Some(s) = sem {
                    s.acquire();
                }
                tx.send(dec_8_crop_stride(ch, src, inf, &cc, cc.new_w, cc.new_h, fsz, &mut buf))
                    .ok();
            }
        }
    }

    destroy_vid_src(src);
}

#[inline]
const fn calc_packed_crop(w: u32, h: u32) -> usize {
    let y = (w * h * 2) as usize;
    let uv = (w * h / 2) as usize;
    ((y + uv * 2) * 5).div_ceil(4)
}

#[inline]
const fn calc_8bit_crop(w: u32, h: u32) -> usize {
    let y = (w * h) as usize;
    let uv = (w * h / 4) as usize;
    y + uv * 2
}

#[inline]
fn dec_10_fast(
    ch: &Chunk,
    src: *mut std::ffi::c_void,
    inf: &VidInf,
    w: u32,
    h: u32,
    fsz: usize,
) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for (i, idx) in (ch.start..ch.end).enumerate() {
        extr_10bit_pack(src, idx, &mut dat[i * fsz..(i + 1) * fsz], inf);
    }
    WorkPkg::new(ch.clone(), dat, len, w, h)
}

#[inline]
fn dec_10_stride(
    ch: &Chunk,
    src: *mut std::ffi::c_void,
    inf: &VidInf,
    w: u32,
    h: u32,
    fsz: usize,
) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for (i, idx) in (ch.start..ch.end).enumerate() {
        extr_10bit_pack_stride(src, idx, &mut dat[i * fsz..(i + 1) * fsz], inf);
    }
    WorkPkg::new(ch.clone(), dat, len, w, h)
}

#[inline]
fn dec_10_crop_fast(
    ch: &Chunk,
    src: *mut std::ffi::c_void,
    cc: &CropCalc,
    w: u32,
    h: u32,
    fsz: usize,
) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for (i, idx) in (ch.start..ch.end).enumerate() {
        extr_10bit_crop_fast(src, idx, &mut dat[i * fsz..(i + 1) * fsz], cc);
    }
    WorkPkg::new(ch.clone(), dat, len, w, h)
}

#[inline]
fn dec_10_crop(
    ch: &Chunk,
    src: *mut std::ffi::c_void,
    cc: &CropCalc,
    w: u32,
    h: u32,
    fsz: usize,
) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for (i, idx) in (ch.start..ch.end).enumerate() {
        extr_10bit_crop(src, idx, &mut dat[i * fsz..(i + 1) * fsz], cc);
    }
    WorkPkg::new(ch.clone(), dat, len, w, h)
}

#[inline]
fn dec_10_crop_stride(
    ch: &Chunk,
    src: *mut std::ffi::c_void,
    cc: &CropCalc,
    w: u32,
    h: u32,
    fsz: usize,
) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for (i, idx) in (ch.start..ch.end).enumerate() {
        extr_10bit_crop_pack_stride(src, idx, &mut dat[i * fsz..(i + 1) * fsz], cc);
    }
    WorkPkg::new(ch.clone(), dat, len, w, h)
}

#[inline]
fn dec_8_fast(
    ch: &Chunk,
    src: *mut std::ffi::c_void,
    inf: &VidInf,
    w: u32,
    h: u32,
    fsz: usize,
) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for (i, idx) in (ch.start..ch.end).enumerate() {
        extr_8bit_fast(src, idx, &mut dat[i * fsz..(i + 1) * fsz], inf);
    }
    WorkPkg::new(ch.clone(), dat, len, w, h)
}

#[inline]
fn dec_8_stride(
    ch: &Chunk,
    src: *mut std::ffi::c_void,
    inf: &VidInf,
    w: u32,
    h: u32,
    fsz: usize,
) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for (i, idx) in (ch.start..ch.end).enumerate() {
        extr_8bit_stride(src, idx, &mut dat[i * fsz..(i + 1) * fsz], inf);
    }
    WorkPkg::new(ch.clone(), dat, len, w, h)
}

#[inline]
fn dec_8_crop_fast(
    ch: &Chunk,
    src: *mut std::ffi::c_void,
    cc: &CropCalc,
    w: u32,
    h: u32,
    fsz: usize,
) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for (i, idx) in (ch.start..ch.end).enumerate() {
        extr_8bit_crop_fast(src, idx, &mut dat[i * fsz..(i + 1) * fsz], cc);
    }
    WorkPkg::new(ch.clone(), dat, len, w, h)
}

#[inline]
fn dec_8_crop(
    ch: &Chunk,
    src: *mut std::ffi::c_void,
    cc: &CropCalc,
    w: u32,
    h: u32,
    fsz: usize,
) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for (i, idx) in (ch.start..ch.end).enumerate() {
        extr_8bit_crop(src, idx, &mut dat[i * fsz..(i + 1) * fsz], cc);
    }
    WorkPkg::new(ch.clone(), dat, len, w, h)
}

#[inline]
fn dec_8_crop_stride(
    ch: &Chunk,
    src: *mut std::ffi::c_void,
    inf: &VidInf,
    cc: &CropCalc,
    w: u32,
    h: u32,
    fsz: usize,
    buf: &mut [u8],
) -> WorkPkg {
    let len = ch.end - ch.start;
    let mut dat = vec![0u8; len * fsz];
    for (i, idx) in (ch.start..ch.end).enumerate() {
        crate::ffms::extr_8bit(src, idx, buf, inf);
        cc.crop(buf, &mut dat[i * fsz..(i + 1) * fsz]);
    }
    WorkPkg::new(ch.clone(), dat, len, w, h)
}
