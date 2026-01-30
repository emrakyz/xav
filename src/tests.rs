use std::collections::HashSet;
use std::path::Path;
use std::sync::Arc;
use std::thread;

use crossbeam_channel::bounded;
use ffms2_sys::FFMS_VideoSource;

use crate::chunk::Chunk;
use crate::decode::decode_chunks;
use crate::encode::get_frame;
use crate::ffms::{self, VidInf, calc_8bit_size, destroy_vid_src, get_raw_frame, thr_vid_src};
use crate::pipeline::Pipeline;

fn extr_raw_data(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    inf: &VidInf,
    crop: (u32, u32),
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let pix_sz = if inf.is_10bit { 2 } else { 1 };
        let width = inf.width as usize;
        let height = inf.height as usize;
        let crop_v = crop.0 as usize;
        let crop_h = crop.1 as usize;
        let cropped_width = width - crop_h * 2;
        let cropped_height = height - crop_v * 2;

        let y_linesize = (*frame).Linesize[0] as usize;
        let u_linesize = (*frame).Linesize[1] as usize;
        let v_linesize = (*frame).Linesize[2] as usize;

        let mut pos = 0;

        for row in 0..cropped_height {
            let src_off = (crop_h * pix_sz) + ((row + crop_v) * y_linesize);
            let len = cropped_width * pix_sz;
            std::ptr::copy_nonoverlapping(
                (*frame).Data[0].add(src_off),
                output.as_mut_ptr().add(pos),
                len,
            );
            pos += len;
        }

        for row in 0..cropped_height / 2 {
            let src_off = (crop_h / 2 * pix_sz) + ((row + crop_v / 2) * u_linesize);
            let len = cropped_width / 2 * pix_sz;
            std::ptr::copy_nonoverlapping(
                (*frame).Data[1].add(src_off),
                output.as_mut_ptr().add(pos),
                len,
            );
            pos += len;
        }

        for row in 0..cropped_height / 2 {
            let src_off = (crop_h / 2 * pix_sz) + ((row + crop_v / 2) * v_linesize);
            let len = cropped_width / 2 * pix_sz;
            std::ptr::copy_nonoverlapping(
                (*frame).Data[2].add(src_off),
                output.as_mut_ptr().add(pos),
                len,
            );
            pos += len;
        }
    }
}

fn test_roundtrip(filename: &str, crop: (u32, u32)) {
    let input = Path::new(env!("CARGO_MANIFEST_DIR")).join("test_files").join(filename);

    let idx = ffms::VidIdx::new(&input, false).unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let decode_strat = ffms::get_decode_strat(&idx, &inf, crop).unwrap();
    let (tx, rx) = bounded::<crate::worker::WorkPkg>(1);
    let sem = Arc::new(crate::worker::Semaphore::new(1));

    let idx_c = Arc::clone(&idx);
    let inf_c = inf.clone();
    let sem_c = Arc::clone(&sem);
    thread::spawn(move || {
        decode_chunks(
            &[Chunk { idx: 0, start: 0, end: 10, params: None }],
            &idx_c,
            &inf_c,
            &tx,
            &HashSet::new(),
            decode_strat,
            &sem_c,
        );
    });

    let pkg = rx.recv().unwrap();
    let frame_size = pkg.yuv.len() / pkg.frame_count;
    let Ok(source) = thr_vid_src(&idx, 1) else {
        panic!("Failed to create video source");
    };

    let final_w = (inf.width - crop.1 * 2) as usize;
    let final_h = (inf.height - crop.0 * 2) as usize;

    let pipe = Pipeline::new(
        &inf,
        decode_strat,
        #[cfg(feature = "vship")]
        None,
    );
    let mut unpacked_buf = vec![0u8; pipe.conv_buf_size];
    let mut decoded_frame = if inf.is_10bit {
        vec![0u8; final_w * final_h * 3 / 2 * 2]
    } else {
        vec![0u8; calc_8bit_size(final_w as u32, final_h as u32)]
    };

    for i in 0..10 {
        let frame_data = get_frame(&pkg.yuv, i, frame_size);

        let roundtrip_frame = if inf.is_10bit {
            (pipe.unpack)(frame_data, &mut unpacked_buf, &pipe);
            &unpacked_buf[..decoded_frame.len()]
        } else {
            frame_data
        };

        extr_raw_data(source, i, &mut decoded_frame, &inf, crop);

        assert_eq!(roundtrip_frame.len(), decoded_frame.len(), "Frame {i} length mismatch");

        let row_size = final_w * if inf.is_10bit { 2 } else { 1 };
        for row in 0..final_h {
            let start = row * row_size;
            let end = start + row_size;
            assert_eq!(
                &roundtrip_frame[start..end],
                &decoded_frame[start..end],
                "Frame {i} Y plane row {row} mismatch",
            );
        }
    }

    destroy_vid_src(source);
}

#[test]
fn test_8bit_mod8() {
    test_roundtrip("akiyo_8bit_mod8.mkv", (0, 0));
}

#[test]
fn test_8bit_mod4w_mod8h() {
    test_roundtrip("akiyo_8bit_mod4w_mod8h.mkv", (0, 0));
}

#[test]
fn test_8bit_mod2w_mod8h() {
    test_roundtrip("akiyo_8bit_mod2w_mod8h.mkv", (0, 0));
}

#[test]
fn test_8bit_mod2w_mod2h() {
    test_roundtrip("akiyo_8bit_mod2w_mod2h.mkv", (0, 0));
}

#[test]
fn test_10bit_mod8() {
    test_roundtrip("akiyo_10bit_mod8.mkv", (0, 0));
}

#[test]
fn test_10bit_mod4w_mod8h() {
    test_roundtrip("akiyo_10bit_mod4w_mod8h.mkv", (0, 0));
}

#[test]
fn test_10bit_mod2w_mod8h() {
    test_roundtrip("akiyo_10bit_mod2w_mod8h.mkv", (0, 0));
}

#[test]
fn test_10bit_mod2w_mod2h() {
    test_roundtrip("akiyo_10bit_mod2w_mod2h.mkv", (0, 0));
}

#[test]
fn test_8bit_mod8_crop() {
    test_roundtrip("akiyo_8bit_mod8.mkv", (8, 8));
}

#[test]
fn test_8bit_mod4w_mod8h_crop() {
    test_roundtrip("akiyo_8bit_mod4w_mod8h.mkv", (8, 8));
}

#[test]
fn test_8bit_mod2w_mod8h_crop() {
    test_roundtrip("akiyo_8bit_mod2w_mod8h.mkv", (8, 8));
}

#[test]
fn test_8bit_mod2w_mod2h_crop() {
    test_roundtrip("akiyo_8bit_mod2w_mod2h.mkv", (8, 8));
}

#[test]
fn test_10bit_mod8_crop() {
    test_roundtrip("akiyo_10bit_mod8.mkv", (8, 8));
}

#[test]
fn test_10bit_mod4w_mod8h_crop() {
    test_roundtrip("akiyo_10bit_mod4w_mod8h.mkv", (8, 8));
}

#[test]
fn test_10bit_mod2w_mod8h_crop() {
    test_roundtrip("akiyo_10bit_mod2w_mod8h.mkv", (8, 8));
}

#[test]
fn test_10bit_mod2w_mod2h_crop() {
    test_roundtrip("akiyo_10bit_mod2w_mod2h.mkv", (8, 8));
}
