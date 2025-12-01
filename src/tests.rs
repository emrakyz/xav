use std::collections::HashSet;
use std::path::Path;
use std::sync::Arc;
use std::thread;

use crossbeam_channel::bounded;

use crate::chunk::Chunk;
use crate::decode::decode_chunks;
use crate::ffms::{
    self, VidInf, calc_8bit_size, calc_10bit_size, get_raw_frame, thr_vid_src, unpack_10bit,
};
use crate::svt::get_frame;

pub fn extr_raw_data(
    vid_src: *mut libc::c_void,
    frame_idx: usize,
    output: &mut [u8],
    inf: &VidInf,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let width = inf.width as usize * if inf.is_10bit { 2 } else { 1 };
        let height = inf.height as usize;
        let y_stride = (*frame).linesize[0] as usize;
        let u_stride = (*frame).linesize[1] as usize;
        let v_stride = (*frame).linesize[2] as usize;

        for y in 0..height {
            let in_start = y * y_stride;
            let out_start = y * width;
            std::ptr::copy_nonoverlapping(
                (*frame).data[0].add(in_start),
                output.as_mut_ptr().add(out_start),
                width,
            );
        }
        for y in 0..(height / 2) {
            let in_start = y * u_stride;
            let out_start = y * width / 2;
            std::ptr::copy_nonoverlapping(
                (*frame).data[1].add(in_start),
                output.as_mut_ptr().add(width * height).add(out_start),
                width / 2,
            );
        }
        for y in 0..(height / 2) {
            let in_start = y * v_stride;
            let out_start = y * width / 2;
            std::ptr::copy_nonoverlapping(
                (*frame).data[2].add(in_start),
                output.as_mut_ptr().add(width * height).add(width / 2 * height / 2).add(out_start),
                width / 2,
            );
        }
    }
}

#[test]
fn roundtrip_test_8bit_mod8() {
    let input =
        Path::new(env!("CARGO_MANIFEST_DIR")).join("test_files").join("akiyo_8bit_mod8.mkv");

    let idx = ffms::VidIdx::new(&input, true).unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_layout = Some(ffms::get_frame_layout(&idx, &inf).unwrap());
    let (tx, rx) = bounded::<crate::worker::WorkPkg>(0);

    let idx_c = Arc::clone(&idx);
    let w = inf.width as usize;
    let h = inf.height as usize;
    thread::spawn(move || {
        decode_chunks(
            &[Chunk { idx: 0, start: 0, end: 10 }],
            &idx_c,
            &inf,
            &tx,
            &HashSet::new(),
            (0, 0),
            frame_layout,
            None,
        )
    });

    let pkg = rx.recv().unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_size = pkg.yuv.len() / pkg.frame_count;
    let Ok(source) = thr_vid_src(&idx, 1) else { return };
    let mut decoded_frame = vec![0; calc_8bit_size(&inf)];
    for i in 0..10 {
        let roundtrip_frame = get_frame(&pkg.yuv, i, frame_size);
        extr_raw_data(source, i, &mut decoded_frame, &inf);
        assert_eq!(roundtrip_frame.len(), decoded_frame.len());
        // Go row by row to make this easier to interpret
        for i in 0..h {
            let start = i * w;
            let end = start + w;
            assert_eq!(&roundtrip_frame[start..end], &decoded_frame[start..end]);
        }
    }
}

#[test]
fn roundtrip_test_8bit_mod4w_mod8h() {
    let input =
        Path::new(env!("CARGO_MANIFEST_DIR")).join("test_files").join("akiyo_8bit_mod4w_mod8h.mkv");

    let idx = ffms::VidIdx::new(&input, true).unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_layout = Some(ffms::get_frame_layout(&idx, &inf).unwrap());
    let (tx, rx) = bounded::<crate::worker::WorkPkg>(0);

    let idx_c = Arc::clone(&idx);
    let w = inf.width as usize;
    let h = inf.height as usize;
    thread::spawn(move || {
        decode_chunks(
            &[Chunk { idx: 0, start: 0, end: 10 }],
            &idx_c,
            &inf,
            &tx,
            &HashSet::new(),
            (0, 0),
            frame_layout,
            None,
        )
    });

    let pkg = rx.recv().unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_size = pkg.yuv.len() / pkg.frame_count;
    let Ok(source) = thr_vid_src(&idx, 1) else { return };
    let mut decoded_frame = vec![0; calc_8bit_size(&inf)];
    for i in 0..10 {
        let roundtrip_frame = get_frame(&pkg.yuv, i, frame_size);
        extr_raw_data(source, i, &mut decoded_frame, &inf);
        assert_eq!(roundtrip_frame.len(), decoded_frame.len());
        // Go row by row to make this easier to interpret
        for i in 0..h {
            let start = i * w;
            let end = start + w;
            assert_eq!(&roundtrip_frame[start..end], &decoded_frame[start..end]);
        }
    }
}

#[test]
fn roundtrip_test_8bit_mod2w_mod8h() {
    let input =
        Path::new(env!("CARGO_MANIFEST_DIR")).join("test_files").join("akiyo_8bit_mod2w_mod8h.mkv");

    let idx = ffms::VidIdx::new(&input, true).unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_layout = Some(ffms::get_frame_layout(&idx, &inf).unwrap());
    let (tx, rx) = bounded::<crate::worker::WorkPkg>(0);

    let idx_c = Arc::clone(&idx);
    let w = inf.width as usize;
    let h = inf.height as usize;
    thread::spawn(move || {
        decode_chunks(
            &[Chunk { idx: 0, start: 0, end: 10 }],
            &idx_c,
            &inf,
            &tx,
            &HashSet::new(),
            (0, 0),
            frame_layout,
            None,
        )
    });

    let pkg = rx.recv().unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_size = pkg.yuv.len() / pkg.frame_count;
    let Ok(source) = thr_vid_src(&idx, 1) else { return };
    let mut decoded_frame = vec![0; calc_8bit_size(&inf)];
    for i in 0..10 {
        let roundtrip_frame = get_frame(&pkg.yuv, i, frame_size);
        extr_raw_data(source, i, &mut decoded_frame, &inf);
        assert_eq!(roundtrip_frame.len(), decoded_frame.len());
        // Go row by row to make this easier to interpret
        for i in 0..h {
            let start = i * w;
            let end = start + w;
            assert_eq!(&roundtrip_frame[start..end], &decoded_frame[start..end]);
        }
    }
}

#[test]
fn roundtrip_test_8bit_mod2w_mod2h() {
    let input =
        Path::new(env!("CARGO_MANIFEST_DIR")).join("test_files").join("akiyo_8bit_mod2w_mod2h.mkv");

    let idx = ffms::VidIdx::new(&input, true).unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_layout = Some(ffms::get_frame_layout(&idx, &inf).unwrap());
    let (tx, rx) = bounded::<crate::worker::WorkPkg>(0);

    let idx_c = Arc::clone(&idx);
    let w = inf.width as usize;
    let h = inf.height as usize;
    thread::spawn(move || {
        decode_chunks(
            &[Chunk { idx: 0, start: 0, end: 10 }],
            &idx_c,
            &inf,
            &tx,
            &HashSet::new(),
            (0, 0),
            frame_layout,
            None,
        )
    });

    let pkg = rx.recv().unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_size = pkg.yuv.len() / pkg.frame_count;
    let Ok(source) = thr_vid_src(&idx, 1) else { return };
    let mut decoded_frame = vec![0; calc_8bit_size(&inf)];
    for i in 0..10 {
        let roundtrip_frame = get_frame(&pkg.yuv, i, frame_size);
        extr_raw_data(source, i, &mut decoded_frame, &inf);
        assert_eq!(roundtrip_frame.len(), decoded_frame.len());
        // Go row by row to make this easier to interpret
        for i in 0..h {
            let start = i * w;
            let end = start + w;
            assert_eq!(&roundtrip_frame[start..end], &decoded_frame[start..end]);
        }
    }
}

#[test]
fn roundtrip_test_10bit_mod8() {
    let input =
        Path::new(env!("CARGO_MANIFEST_DIR")).join("test_files").join("akiyo_10bit_mod8.mkv");

    let idx = ffms::VidIdx::new(&input, true).unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_layout = Some(ffms::get_frame_layout(&idx, &inf).unwrap());
    let (tx, rx) = bounded::<crate::worker::WorkPkg>(0);

    let idx_c = Arc::clone(&idx);
    let w = inf.width as usize;
    let h = inf.height as usize;
    thread::spawn(move || {
        decode_chunks(
            &[Chunk { idx: 0, start: 0, end: 10 }],
            &idx_c,
            &inf,
            &tx,
            &HashSet::new(),
            (0, 0),
            frame_layout,
            None,
        )
    });

    let pkg = rx.recv().unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_size = pkg.yuv.len() / pkg.frame_count;
    let Ok(source) = thr_vid_src(&idx, 1) else { return };
    let mut roundtrip_frame = vec![0; calc_10bit_size(&inf)];
    let mut decoded_frame = vec![0; calc_10bit_size(&inf)];
    for i in 0..10 {
        let packed_frame = get_frame(&pkg.yuv, i, frame_size);
        unpack_10bit(packed_frame, &mut roundtrip_frame);
        extr_raw_data(source, i, &mut decoded_frame, &inf);
        assert_eq!(roundtrip_frame.len(), decoded_frame.len());
        // Go row by row to make this easier to interpret
        for i in 0..h {
            let start = i * w;
            let end = start + w;
            assert_eq!(&roundtrip_frame[start..end], &decoded_frame[start..end]);
        }
    }
}

#[test]
fn roundtrip_test_10bit_mod4w_mod8h() {
    let input = Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("test_files")
        .join("akiyo_10bit_mod4w_mod8h.mkv");

    let idx = ffms::VidIdx::new(&input, true).unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_layout = Some(ffms::get_frame_layout(&idx, &inf).unwrap());
    let (tx, rx) = bounded::<crate::worker::WorkPkg>(0);

    let idx_c = Arc::clone(&idx);
    let w = inf.width as usize;
    let h = inf.height as usize;
    thread::spawn(move || {
        decode_chunks(
            &[Chunk { idx: 0, start: 0, end: 10 }],
            &idx_c,
            &inf,
            &tx,
            &HashSet::new(),
            (0, 0),
            frame_layout,
            None,
        )
    });

    let pkg = rx.recv().unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_size = pkg.yuv.len() / pkg.frame_count;
    let Ok(source) = thr_vid_src(&idx, 1) else { return };
    let mut roundtrip_frame = vec![0; calc_10bit_size(&inf)];
    let mut decoded_frame = vec![0; calc_10bit_size(&inf)];
    for i in 0..10 {
        let packed_frame = get_frame(&pkg.yuv, i, frame_size);
        unpack_10bit(packed_frame, &mut roundtrip_frame);
        extr_raw_data(source, i, &mut decoded_frame, &inf);
        assert_eq!(roundtrip_frame.len(), decoded_frame.len());
        // Go row by row to make this easier to interpret
        for i in 0..h {
            let start = i * w;
            let end = start + w;
            assert_eq!(&roundtrip_frame[start..end], &decoded_frame[start..end]);
        }
    }
}

#[test]
fn roundtrip_test_10bit_mod2w_mod8h() {
    let input = Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("test_files")
        .join("akiyo_10bit_mod2w_mod8h.mkv");

    let idx = ffms::VidIdx::new(&input, true).unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_layout = Some(ffms::get_frame_layout(&idx, &inf).unwrap());
    let (tx, rx) = bounded::<crate::worker::WorkPkg>(0);

    let idx_c = Arc::clone(&idx);
    let w = inf.width as usize;
    let h = inf.height as usize;
    thread::spawn(move || {
        decode_chunks(
            &[Chunk { idx: 0, start: 0, end: 10 }],
            &idx_c,
            &inf,
            &tx,
            &HashSet::new(),
            (0, 0),
            frame_layout,
            None,
        )
    });

    let pkg = rx.recv().unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_size = pkg.yuv.len() / pkg.frame_count;
    let Ok(source) = thr_vid_src(&idx, 1) else { return };
    let mut roundtrip_frame = vec![0; calc_10bit_size(&inf)];
    let mut decoded_frame = vec![0; calc_10bit_size(&inf)];
    for i in 0..10 {
        let packed_frame = get_frame(&pkg.yuv, i, frame_size);
        unpack_10bit(packed_frame, &mut roundtrip_frame);
        extr_raw_data(source, i, &mut decoded_frame, &inf);
        assert_eq!(roundtrip_frame.len(), decoded_frame.len());
        // Go row by row to make this easier to interpret
        for i in 0..h {
            let start = i * w;
            let end = start + w;
            assert_eq!(&roundtrip_frame[start..end], &decoded_frame[start..end]);
        }
    }
}

#[test]
fn roundtrip_test_10bit_mod2w_mod2h() {
    let input = Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("test_files")
        .join("akiyo_10bit_mod2w_mod2h.mkv");

    let idx = ffms::VidIdx::new(&input, true).unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_layout = Some(ffms::get_frame_layout(&idx, &inf).unwrap());
    let (tx, rx) = bounded::<crate::worker::WorkPkg>(0);

    let idx_c = Arc::clone(&idx);
    let w = inf.width as usize;
    let h = inf.height as usize;
    thread::spawn(move || {
        decode_chunks(
            &[Chunk { idx: 0, start: 0, end: 10 }],
            &idx_c,
            &inf,
            &tx,
            &HashSet::new(),
            (0, 0),
            frame_layout,
            None,
        )
    });

    let pkg = rx.recv().unwrap();
    let inf = ffms::get_vidinf(&idx).unwrap();
    let frame_size = pkg.yuv.len() / pkg.frame_count;
    let Ok(source) = thr_vid_src(&idx, 1) else { return };
    let mut roundtrip_frame = vec![0; calc_10bit_size(&inf)];
    let mut decoded_frame = vec![0; calc_10bit_size(&inf)];
    for i in 0..10 {
        let packed_frame = get_frame(&pkg.yuv, i, frame_size);
        unpack_10bit(packed_frame, &mut roundtrip_frame);
        extr_raw_data(source, i, &mut decoded_frame, &inf);
        assert_eq!(roundtrip_frame.len(), decoded_frame.len());
        // Go row by row to make this easier to interpret
        for i in 0..h {
            let start = i * w;
            let end = start + w;
            assert_eq!(&roundtrip_frame[start..end], &decoded_frame[start..end]);
        }
    }
}
