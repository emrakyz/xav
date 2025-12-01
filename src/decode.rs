//! Decoder functions abstracted away from the underlying implementation,
//! intended for direct use in the xav decoding workflow.

use std::collections::HashSet;
use std::sync::Arc;

use crossbeam_channel::Sender;

use crate::chunk::Chunk;
use crate::ffms::{
    FrameLayout, VidIdx, VidInf, calc_8bit_size, calc_packed_size, destroy_vid_src, extr_8bit,
    extr_8bit_crop, extr_8bit_fast, extr_8bit_stride, extr_10bit_crop_pack_stride, extr_10bit_pack,
    extr_10bit_pack_stride, extr_pack_10bit_crop, thr_vid_src,
};
use crate::worker::{Semaphore, WorkPkg};

pub fn decode_chunks(
    chunks: &[Chunk],
    idx: &Arc<VidIdx>,
    inf: &VidInf,
    tx: &Sender<crate::worker::WorkPkg>,
    skip_indices: &HashSet<usize>,
    crop: (u32, u32),
    frame_layout: Option<FrameLayout>,
    permits: Option<&Arc<Semaphore>>,
) {
    let threads =
        std::thread::available_parallelism().map_or(8, |n| n.get().try_into().unwrap_or(8));
    let Ok(source) = thr_vid_src(idx, threads) else { return };
    let filtered: Vec<Chunk> =
        chunks.iter().filter(|c| !skip_indices.contains(&c.idx)).cloned().collect();

    if inf.is_10bit {
        decode_chunks_internal::<10>(&filtered, source, inf, tx, crop, frame_layout, permits);
    } else {
        decode_chunks_internal::<8>(&filtered, source, inf, tx, crop, frame_layout, permits);
    }

    destroy_vid_src(source);
}

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
}

impl CropCalc {
    const fn new(inf: &VidInf, crop: (u32, u32), pixel_sz: usize) -> Self {
        let (crop_v, crop_h) = crop;
        let new_w = inf.width - crop_h * 2;
        let new_h = inf.height - crop_v * 2;

        let y_stride = (inf.width * pixel_sz as u32) as usize;
        let uv_stride = (inf.width / 2 * pixel_sz as u32) as usize;
        let y_start = ((crop_v * inf.width + crop_h) as usize) * pixel_sz;
        let y_plane_sz = (inf.width * inf.height) as usize * pixel_sz;
        let uv_plane_sz = (inf.width / 2 * inf.height / 2) as usize * pixel_sz;
        let u_start = y_plane_sz + ((crop_v / 2 * inf.width / 2 + crop_h / 2) as usize * pixel_sz);
        let v_start = y_plane_sz
            + uv_plane_sz
            + ((crop_v / 2 * inf.width / 2 + crop_h / 2) as usize * pixel_sz);
        let y_len = (new_w * pixel_sz as u32) as usize;
        let uv_len = (new_w / 2 * pixel_sz as u32) as usize;

        Self { new_w, new_h, y_stride, uv_stride, y_start, u_start, v_start, y_len, uv_len }
    }

    fn crop_frame(&self, src: &[u8], dst: &mut [u8]) {
        let mut pos = 0;

        for row in 0..self.new_h {
            let src_off = self.y_start + row as usize * self.y_stride;
            dst[pos..pos + self.y_len].copy_from_slice(&src[src_off..src_off + self.y_len]);
            pos += self.y_len;
        }

        for row in 0..self.new_h / 2 {
            let src_off = self.u_start + row as usize * self.uv_stride;
            dst[pos..pos + self.uv_len].copy_from_slice(&src[src_off..src_off + self.uv_len]);
            pos += self.uv_len;
        }

        for row in 0..self.new_h / 2 {
            let src_off = self.v_start + row as usize * self.uv_stride;
            dst[pos..pos + self.uv_len].copy_from_slice(&src[src_off..src_off + self.uv_len]);
            pos += self.uv_len;
        }
    }
}

fn decode_chunks_internal<const BITS: usize>(
    chunks: &[Chunk],
    source: *mut std::ffi::c_void,
    inf: &VidInf,
    tx: &Sender<crate::worker::WorkPkg>,
    crop: (u32, u32),
    frame_layout: Option<FrameLayout>,
    permits: Option<&Arc<Semaphore>>,
) {
    let crop_calc = (crop != (0, 0)).then(|| CropCalc::new(inf, crop, 2));
    let (width, height, packed_sz) = crop_calc.as_ref().map_or_else(
        || {
            (
                inf.width,
                inf.height,
                if BITS == 10 {
                    calc_packed_size(inf)
                } else if BITS == 8 {
                    calc_8bit_size(inf)
                } else {
                    unreachable!()
                },
            )
        },
        |c| {
            if BITS == 10 {
                let new_y_sz = (c.new_w * c.new_h * 2) as usize;
                let new_uv_sz = (c.new_w * c.new_h / 2) as usize;
                let new_frame_sz = new_y_sz + new_uv_sz * 2;
                (c.new_w, c.new_h, (new_frame_sz * 5).div_ceil(4))
            } else if BITS == 8 {
                let new_y_sz = (c.new_w * c.new_h) as usize;
                let new_uv_sz = (c.new_w * c.new_h / 4) as usize;
                (c.new_w, c.new_h, new_y_sz + new_uv_sz * 2)
            } else {
                unreachable!()
            }
        },
    );

    for chunk in chunks {
        match (crop == (0, 0), frame_layout) {
            (true, Some(fl)) if !fl.has_padding => {
                if let Some(sem) = permits {
                    sem.acquire();
                }

                let pkg = decode_chunk_no_crop_no_padding::<BITS>(
                    chunk, source, inf, width, height, packed_sz,
                );
                tx.send(pkg).ok();
            }

            (false, Some(fl)) if !fl.has_padding => {
                if let Some(sem) = permits {
                    sem.acquire();
                }

                let pkg = decode_chunk_yes_crop_no_padding::<BITS>(
                    chunk,
                    source,
                    crop_calc.as_ref().unwrap(),
                    width,
                    height,
                    packed_sz,
                );
                tx.send(pkg).ok();
            }

            (true, _) => {
                if let Some(sem) = permits {
                    sem.acquire();
                }

                let pkg = decode_chunk_no_crop_yes_padding::<BITS>(
                    chunk, source, inf, width, height, packed_sz,
                );
                tx.send(pkg).ok();
            }

            (false, _) => {
                if let Some(sem) = permits {
                    sem.acquire();
                }

                let pkg = decode_chunk_yes_crop_yes_padding::<BITS>(
                    chunk,
                    source,
                    inf,
                    crop_calc.as_ref().unwrap(),
                    width,
                    height,
                    packed_sz,
                );
                tx.send(pkg).ok();
            }
        }
    }
}

fn decode_chunk_no_crop_no_padding<const BITS: usize>(
    chunk: &Chunk,
    source: *mut std::ffi::c_void,
    inf: &VidInf,
    width: u32,
    height: u32,
    packed_sz: usize,
) -> WorkPkg {
    let chunk_len = chunk.end - chunk.start;
    let mut frames_data = vec![0u8; chunk_len * packed_sz];

    for (i, idx) in (chunk.start..chunk.end).enumerate() {
        let dst = &mut frames_data[i * packed_sz..(i + 1) * packed_sz];
        if BITS == 10 {
            extr_10bit_pack(source, idx, dst, inf);
        } else if BITS == 8 {
            extr_8bit_fast(source, idx, dst, inf);
        } else {
            unreachable!();
        }
    }

    crate::worker::WorkPkg::new(chunk.clone(), frames_data, chunk_len, width, height)
}

fn decode_chunk_yes_crop_no_padding<const BITS: usize>(
    chunk: &Chunk,
    source: *mut std::ffi::c_void,
    crop_calc: &CropCalc,
    width: u32,
    height: u32,
    packed_sz: usize,
) -> WorkPkg {
    let chunk_len = chunk.end - chunk.start;
    let mut frames_data = vec![0u8; chunk_len * packed_sz];

    for (i, idx) in (chunk.start..chunk.end).enumerate() {
        let dst = &mut frames_data[i * packed_sz..(i + 1) * packed_sz];
        if BITS == 10 {
            extr_pack_10bit_crop(
                source,
                idx,
                crop_calc.new_w,
                crop_calc.new_h,
                crop_calc.y_start,
                crop_calc.u_start,
                dst,
            );
        } else if BITS == 8 {
            extr_8bit_crop(source, idx, dst, crop_calc);
        } else {
            unreachable!();
        }
    }

    crate::worker::WorkPkg::new(chunk.clone(), frames_data, chunk_len, width, height)
}

fn decode_chunk_no_crop_yes_padding<const BITS: usize>(
    chunk: &Chunk,
    source: *mut std::ffi::c_void,
    inf: &VidInf,
    width: u32,
    height: u32,
    packed_sz: usize,
) -> WorkPkg {
    let chunk_len = chunk.end - chunk.start;
    let mut frames_data = vec![0u8; chunk_len * packed_sz];

    for (i, idx) in (chunk.start..chunk.end).enumerate() {
        let dst = &mut frames_data[i * packed_sz..(i + 1) * packed_sz];
        if BITS == 10 {
            extr_10bit_pack_stride(source, idx, dst, inf);
        } else if BITS == 8 {
            extr_8bit_stride(source, idx, dst, inf);
        } else {
            unreachable!();
        }
    }

    crate::worker::WorkPkg::new(chunk.clone(), frames_data, chunk_len, width, height)
}

fn decode_chunk_yes_crop_yes_padding<const BITS: usize>(
    chunk: &Chunk,
    source: *mut std::ffi::c_void,
    inf: &VidInf,
    crop_calc: &CropCalc,
    width: u32,
    height: u32,
    packed_sz: usize,
) -> WorkPkg {
    let chunk_len = chunk.end - chunk.start;
    let mut frame_buf = if BITS == 8 {
        vec![0u8; calc_8bit_size(inf)]
    } else {
        // Unused
        Vec::new()
    };
    let mut frames_data = vec![0u8; chunk_len * packed_sz];

    for (i, idx) in (chunk.start..chunk.end).enumerate() {
        let dst = &mut frames_data[i * packed_sz..(i + 1) * packed_sz];
        if BITS == 10 {
            extr_10bit_crop_pack_stride(source, idx, dst, crop_calc);
        } else if BITS == 8 {
            extr_8bit(source, idx, &mut frame_buf, inf);
            crop_calc.crop_frame(&frame_buf, dst);
        } else {
            unreachable!();
        }
    }

    crate::worker::WorkPkg::new(chunk.clone(), frames_data, chunk_len, width, height)
}
