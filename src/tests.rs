use std::{collections::BTreeSet, sync::Arc};

use crate::{
    chan::{SpscRing, spsc_close, spsc_recv, spsc_send},
    chunk::{MAX_CHNK_FRAMES, chnkify, load_scenes},
    dec::{Bufs, dec_chnks},
    enc::test_access::run_chunk,
    ffms::{DecStrat, VidDecoder, VidInf, get_dec_strat, get_vidinf},
    path::{Path, PathBuf},
    pipeline::Pipeline,
    process::{Command, Stdio, ok_status},
    thread::pspawn,
    worker::WorkPkg,
};

const ENC_PARAMS: &str = "--preset 7 --lp 5 --scm 0";

macro_rules! sw {
    ($name:ident, $file:expr, $crop:expr, $buf:literal, $strat:pat) => {
        #[test]
        fn $name() {
            use DecStrat::*;
            let strat = run_test($file, $crop, false, false, $buf);
            assert!(
                matches!(strat, $strat),
                "expected {}, got {strat:?}",
                stringify!($strat)
            );
        }
    };
}

macro_rules! hw {
    ($name:ident, $file:expr, $crop:expr, $tq:literal, $buf:literal, $strat:pat) => {
        #[test]
        fn $name() {
            use DecStrat::*;
            let strat = run_test($file, $crop, true, $tq, $buf);
            assert!(
                matches!(strat, $strat),
                "expected {}, got {strat:?}",
                stringify!($strat)
            );
        }
    };
}

fn test_path(filename: &str) -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("test_files")
        .join(filename)
}

fn ffmpeg_reference(inp: &Path, w: usize, h: usize, crop: (u32, u32)) -> Vec<u8> {
    let mut cmd = Command::new("ffmpeg");
    cmd.args(["-i", inp.to_str().unwrap()]);
    if crop != (0, 0) {
        cmd.args(["-vf", &format!("crop={}:{}:{}:{}", w, h, crop.1, crop.0)]);
    }
    cmd.args([
        "-pix_fmt",
        "yuv420p10le",
        "-f",
        "rawvideo",
        "-frames:v",
        "1",
        "pipe:1",
    ]);
    cmd.stdout(Stdio::piped()).stderr(Stdio::null());
    let out = cmd.output().unwrap();
    assert!(
        ok_status(out.status),
        "ffmpeg reference extraction failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    out.stdout
}

fn verify_pix(reference: &[u8], production: &[u8], pipe: &Pipeline) {
    assert_eq!(
        reference.len(),
        production.len(),
        "size mismatch (ref={} prod={})",
        reference.len(),
        production.len()
    );

    if reference != production {
        let pos = reference
            .iter()
            .zip(production.iter())
            .position(|(a, b)| a != b)
            .unwrap();
        let (plane, plane_pos) = if pos < pipe.enc.y_sz {
            ("Y", pos)
        } else if pos < pipe.enc.cr_off {
            ("U", pos - pipe.enc.y_sz)
        } else {
            ("V", pos - pipe.enc.cr_off)
        };
        let plane_w = if plane == "Y" {
            pipe.final_w
        } else {
            pipe.half_w
        };
        let ref_val =
            u16::from(reference[pos]) | (u16::from(reference[pos.saturating_add(1)]) << 8);
        let prod_val =
            u16::from(production[pos]) | (u16::from(production[pos.saturating_add(1)]) << 8);
        panic!(
            "pixel mismatch in {plane} plane at ({},{}) ref={ref_val} prod={prod_val}",
            (plane_pos / 2) % plane_w,
            (plane_pos / 2) / plane_w
        );
    }
}

fn verify_pipeline(pipe: &Pipeline, inf: &VidInf, crop: (u32, u32), strat: DecStrat) {
    let (expected_w, expected_h) = if crop == (0, 0) {
        (inf.width as usize, inf.height as usize)
    } else {
        (
            (inf.width - crop.1 * 2) as usize,
            (inf.height - crop.0 * 2) as usize,
        )
    };

    assert_eq!(pipe.final_w, expected_w, "pipeline width mismatch");
    assert_eq!(pipe.final_h, expected_h, "pipeline height mismatch");

    if strat.is_raw() {
        assert_eq!(pipe.conv_buf_sz, 0, "raw conv_buf_size should be 0");
    }
}

fn run_test(filename: &str, crop: (u32, u32), hwdec: bool, tq: bool, buffer: usize) -> DecStrat {
    let inp = test_path(filename);
    let mut inf = get_vidinf(&inp).unwrap();
    if hwdec {
        let mut dec = VidDecoder::new_hw(&inp, 1).unwrap();
        let f = unsafe { &*dec.dec_next_hw() };
        inf.y_linesz = f.linesize[0] as usize;
        inf.uv_linesz = f.linesize[1] as usize;
    }

    let mut strat = get_dec_strat(&inf, crop, hwdec, tq);
    if buffer == 0 {
        strat = strat.to_raw();
    }

    let pipe = Pipeline::new(&inf, &strat);

    verify_pipeline(&pipe, &inf, crop, strat);

    let scenes = load_scenes(&test_path("scenes.txt"), inf.frames, false).unwrap();
    let chnks = chnkify(&scenes);

    let ring = Arc::new(SpscRing::new());
    let ring2 = Arc::clone(&ring);
    let bufs = Arc::new(Bufs::new(1, MAX_CHNK_FRAMES * pipe.frame_sz));
    let handle = pspawn({
        let inp = inp.clone();
        let inf = inf.clone();
        let bufs = Arc::clone(&bufs);
        move || {
            let rp = Arc::as_ptr(&ring);
            let send = move |p: *mut WorkPkg| unsafe { spsc_send(rp, p as u64) };
            dec_chnks(
                &chnks,
                &inp,
                &inf,
                &BTreeSet::new(),
                &strat,
                &bufs.sink(&send),
            );
            unsafe { spsc_close(rp) };
        }
    });

    let mut all_yuv = Vec::new();
    let mut tot_frames = 0usize;
    loop {
        let m = unsafe { spsc_recv(Arc::as_ptr(&ring2)) };
        if m == 0 {
            break;
        }
        let slot = m as *mut WorkPkg;
        let pkg = unsafe { &*slot };
        tot_frames += pkg.frame_cnt;
        all_yuv.extend_from_slice(&pkg.yuv);
        bufs.give(slot);
    }
    handle.join();

    assert!(tot_frames > 0);
    assert_eq!(all_yuv.len(), tot_frames * pipe.frame_sz);

    let mut frame0 = all_yuv[..pipe.frame_sz].to_vec();
    let mut bitstream = Vec::new();
    let conv = run_chunk(
        &inf,
        &pipe,
        strat,
        &mut frame0,
        1,
        ENC_PARAMS,
        &mut bitstream,
    );
    assert!(!bitstream.is_empty(), "encoder emitted no bitstream");

    let reference = ffmpeg_reference(&inp, pipe.final_w, pipe.final_h, crop);
    let fed = if conv.is_empty() { &all_yuv } else { &conv };
    verify_pix(&reference, &fed[..reference.len()], &pipe);

    strat
}

#[test]
fn strat_coverage() {
    use DecStrat::*;
    fn _exhaustive(s: DecStrat) {
        match s {
            B10Fast
            | B10FastRem
            | B10StrideRem
            | B10Crop { .. }
            | B10CropRem { .. }
            | B10CropFast { .. }
            | B10CropFastRem { .. }
            | B10Raw
            | B10RawStride
            | B10RawCrop { .. }
            | B10RawCropFast { .. }
            | B8Fast
            | B8Stride
            | B8Crop { .. }
            | B8CropFast { .. }
            | HwNv12
            | HwNv12Rem
            | HwNv12Stride
            | HwNv12Crop { .. }
            | HwNv12To10
            | HwNv12To10Stride
            | HwNv12CropTo10 { .. }
            | HwP010Raw
            | HwP010RawRem
            | HwP010RawRemStride
            | HwP010RawCrop { .. }
            | HwP010Pack
            | HwP010PackRem
            | HwP010PackPkRem
            | HwP010PackRemPkRem
            | HwP010PackRemPkRemStride
            | HwP010CropPack { .. }
            | HwP010CropPackPkRem { .. } => {}
        }
    }
}

sw!(sw_b8_fast, "8b_768x480.mp4", (0, 0), 1, B8Fast);
sw!(sw_b8_stride, "8b_718x480.mp4", (0, 0), 1, B8Stride);
sw!(
    sw_b8_crop_fast,
    "8b_768x480.mp4",
    (4, 0),
    1,
    B8CropFast { .. }
);
sw!(sw_b8_crop, "8b_768x480.mp4", (0, 4), 1, B8Crop { .. });
sw!(
    sw_b8_crop_stride,
    "8b_718x480.mp4",
    (0, 2),
    1,
    B8Crop { .. }
);

sw!(sw_b10_fast, "10b_768x480.mp4", (0, 0), 1, B10Fast);
sw!(sw_b10_fast_rem, "10b_704x480.mp4", (0, 0), 1, B10FastRem);
sw!(
    sw_b10_stride_rem,
    "10b_718x480.mp4",
    (0, 0),
    1,
    B10StrideRem
);
sw!(
    sw_b10_crop_fast,
    "10b_768x480.mp4",
    (4, 0),
    1,
    B10CropFast { .. }
);
sw!(
    sw_b10_crop_fast_rem,
    "10b_704x480.mp4",
    (4, 0),
    1,
    B10CropFastRem { .. }
);
sw!(sw_b10_crop, "10b_832x480.mp4", (0, 32), 1, B10Crop { .. });
sw!(
    sw_b10_crop_rem,
    "10b_1920x1080.mp4",
    (0, 4),
    1,
    B10CropRem { .. }
);
sw!(
    sw_b10_crop_stride,
    "10b_1936x1080.mp4",
    (0, 8),
    1,
    B10Crop { .. }
);
sw!(
    sw_b10_crop_stride_rem,
    "10b_720x480.mp4",
    (0, 4),
    1,
    B10CropRem { .. }
);

sw!(sw_b10_raw, "10b_768x480.mp4", (0, 0), 0, B10Raw);
sw!(
    sw_b10_raw_stride,
    "10b_718x480.mp4",
    (0, 0),
    0,
    B10RawStride
);
sw!(
    sw_b10_raw_crop_fast,
    "10b_768x480.mp4",
    (4, 0),
    0,
    B10RawCropFast { .. }
);
sw!(
    sw_b10_raw_crop,
    "10b_1920x1080.mp4",
    (0, 4),
    0,
    B10RawCrop { .. }
);
sw!(
    sw_b10_raw_crop_stride,
    "10b_1936x1080.mp4",
    (0, 8),
    0,
    B10RawCrop { .. }
);

sw!(dim_10b_2w2h, "10b_718x478.mp4", (0, 0), 1, B10StrideRem);
sw!(dim_8b_2w2h, "8b_718x478.mp4", (0, 0), 1, B8Stride);
sw!(dim_10b_4w8h, "10b_716x480.mp4", (0, 0), 1, B10StrideRem);
sw!(dim_8b_4w8h, "8b_716x480.mp4", (0, 0), 1, B8Stride);
sw!(dim_10b_8w8h, "10b_776x480.mp4", (0, 0), 1, B10StrideRem);
sw!(
    dim_10b_2w2h_crop,
    "10b_718x478.mp4",
    (0, 2),
    1,
    B10CropRem { .. }
);
sw!(dim_8b_2w2h_crop, "8b_718x478.mp4", (0, 2), 1, B8Crop { .. });
sw!(
    dim_10b_4w8h_crop,
    "10b_720x480.mp4",
    (0, 2),
    1,
    B10CropRem { .. }
);
sw!(dim_8b_4w8h_crop, "8b_768x480.mp4", (0, 2), 1, B8Crop { .. });
sw!(
    dim_10b_8w8h_crop,
    "10b_768x480.mp4",
    (0, 4),
    1,
    B10CropRem { .. }
);
sw!(
    dim_10b_1920_crop,
    "10b_1920x1080.mp4",
    (0, 4),
    1,
    B10CropRem { .. }
);
sw!(
    dim_8b_8w8h_crop,
    "8b_1920x1080.mp4",
    (0, 4),
    1,
    B8Crop { .. }
);

hw!(hw_nv12, "8b_1920x1080.mp4", (0, 0), true, 1, HwNv12);
hw!(hw_nv12_rem, "8b_1024x576.mp4", (0, 0), true, 1, HwNv12Rem);
hw!(
    hw_nv12_stride,
    "8b_718x480.mp4",
    (0, 0),
    true,
    1,
    HwNv12Stride
);
hw!(
    hw_nv12_crop,
    "8b_1920x1080.mp4",
    (0, 4),
    true,
    1,
    HwNv12Crop { .. }
);
hw!(
    hw_nv12_to10,
    "8b_1920x1080.mp4",
    (0, 0),
    false,
    1,
    HwNv12To10
);
hw!(
    hw_nv12_to10_stride,
    "8b_718x480.mp4",
    (0, 0),
    false,
    1,
    HwNv12To10Stride
);
hw!(
    hw_nv12_crop_to10,
    "8b_1920x1080.mp4",
    (0, 4),
    false,
    1,
    HwNv12CropTo10 { .. }
);

hw!(
    hw_p010_pack,
    "10b_1920x1080.mp4",
    (0, 0),
    false,
    1,
    HwP010Pack
);
hw!(
    hw_p010_pack_pk_rem,
    "10b_1280x720.mp4",
    (0, 0),
    false,
    1,
    HwP010PackPkRem
);
hw!(
    hw_p010_pack_rem,
    "10b_768x432.mp4",
    (0, 0),
    false,
    1,
    HwP010PackRem
);
hw!(
    hw_p010_pack_rem_pk_rem,
    "10b_1024x576.mp4",
    (0, 0),
    false,
    1,
    HwP010PackRemPkRem
);
hw!(
    hw_p010_pack_rem_pk_rem_stride,
    "10b_718x480.mp4",
    (0, 0),
    false,
    1,
    HwP010PackRemPkRemStride
);

hw!(
    hw_p010_crop_pack,
    "10b_1936x1080.mp4",
    (0, 8),
    false,
    1,
    HwP010CropPack { .. }
);
hw!(
    hw_p010_crop_pack_pk_rem,
    "10b_1288x720.mp4",
    (0, 4),
    false,
    1,
    HwP010CropPackPkRem { .. }
);
hw!(
    hw_p010_crop_pack_776,
    "10b_776x480.mp4",
    (0, 4),
    false,
    1,
    HwP010CropPack { .. }
);
hw!(
    hw_p010_crop_pack_pk_rem_1920,
    "10b_1920x1080.mp4",
    (0, 4),
    false,
    1,
    HwP010CropPackPkRem { .. }
);

hw!(
    hw_p010_raw,
    "10b_1920x1080.mp4",
    (0, 0),
    false,
    0,
    HwP010Raw
);
hw!(
    hw_p010_raw_rem,
    "10b_768x432.mp4",
    (0, 0),
    false,
    0,
    HwP010RawRem
);
hw!(
    hw_p010_raw_rem_stride,
    "10b_718x480.mp4",
    (0, 0),
    false,
    0,
    HwP010RawRemStride
);
hw!(
    hw_p010_raw_crop,
    "10b_1936x1080.mp4",
    (0, 8),
    false,
    0,
    HwP010RawCrop { .. }
);
hw!(
    hw_p010_raw_crop_776,
    "10b_776x480.mp4",
    (0, 4),
    false,
    0,
    HwP010RawCrop { .. }
);

hw!(
    dim_hw_10b_2w2h,
    "10b_718x478.mp4",
    (0, 0),
    false,
    1,
    HwP010PackRemPkRemStride
);
hw!(
    dim_hw_10b_4w8h,
    "10b_716x480.mp4",
    (0, 0),
    false,
    1,
    HwP010PackRemPkRemStride
);
hw!(
    dim_hw_8b_2w2h_notq,
    "8b_718x478.mp4",
    (0, 0),
    false,
    1,
    HwNv12To10Stride
);
hw!(
    dim_hw_8b_2w2h_tq,
    "8b_718x478.mp4",
    (0, 0),
    true,
    1,
    HwNv12Stride
);
hw!(
    dim_hw_8b_4w8h_notq,
    "8b_716x480.mp4",
    (0, 0),
    false,
    1,
    HwNv12To10Stride
);
hw!(
    dim_hw_8b_4w8h_tq,
    "8b_716x480.mp4",
    (0, 0),
    true,
    1,
    HwNv12Stride
);

#[cfg(feature = "vship")]
mod tq {
    use super::*;

    macro_rules! tq_sw {
        ($name:ident, $file:expr, $crop:expr, $strat:pat) => {
            #[test]
            fn $name() {
                use DecStrat::*;
                let strat = run_test($file, $crop, false, false, 1);
                assert!(
                    matches!(strat, $strat),
                    "expected {}, got {strat:?}",
                    stringify!($strat)
                );
            }
        };
    }

    macro_rules! tq_hw {
        ($name:ident, $file:expr, $crop:expr, $tq:literal, $strat:pat) => {
            #[test]
            fn $name() {
                use DecStrat::*;
                let strat = run_test($file, $crop, true, $tq, 1);
                assert!(
                    matches!(strat, $strat),
                    "expected {}, got {strat:?}",
                    stringify!($strat)
                );
            }
        };
    }

    tq_sw!(sw_b8_fast, "8b_768x480.mp4", (0, 0), B8Fast);
    tq_sw!(sw_b8_stride, "8b_718x480.mp4", (0, 0), B8Stride);
    tq_sw!(sw_b8_crop_fast, "8b_768x480.mp4", (4, 0), B8CropFast { .. });
    tq_sw!(sw_b8_crop, "8b_768x480.mp4", (0, 4), B8Crop { .. });
    tq_sw!(sw_b8_crop_stride, "8b_718x480.mp4", (0, 2), B8Crop { .. });

    tq_sw!(sw_b10_fast, "10b_768x480.mp4", (0, 0), B10Fast);
    tq_sw!(sw_b10_fast_rem, "10b_704x480.mp4", (0, 0), B10FastRem);
    tq_sw!(sw_b10_stride_rem, "10b_718x480.mp4", (0, 0), B10StrideRem);
    tq_sw!(
        sw_b10_crop_fast,
        "10b_768x480.mp4",
        (4, 0),
        B10CropFast { .. }
    );
    tq_sw!(
        sw_b10_crop_fast_rem,
        "10b_704x480.mp4",
        (4, 0),
        B10CropFastRem { .. }
    );
    tq_sw!(sw_b10_crop, "10b_832x480.mp4", (0, 32), B10Crop { .. });
    tq_sw!(
        sw_b10_crop_rem,
        "10b_1920x1080.mp4",
        (0, 4),
        B10CropRem { .. }
    );
    tq_sw!(
        sw_b10_crop_stride,
        "10b_1936x1080.mp4",
        (0, 8),
        B10Crop { .. }
    );
    tq_sw!(
        sw_b10_crop_stride_rem,
        "10b_720x480.mp4",
        (0, 4),
        B10CropRem { .. }
    );

    tq_hw!(hw_nv12, "8b_1920x1080.mp4", (0, 0), true, HwNv12);
    tq_hw!(hw_nv12_rem, "8b_1024x576.mp4", (0, 0), true, HwNv12Rem);
    tq_hw!(hw_nv12_stride, "8b_718x480.mp4", (0, 0), true, HwNv12Stride);
    tq_hw!(
        hw_nv12_crop,
        "8b_1920x1080.mp4",
        (0, 4),
        true,
        HwNv12Crop { .. }
    );

    tq_hw!(hw_p010_pack, "10b_1920x1080.mp4", (0, 0), false, HwP010Pack);
    tq_hw!(
        hw_p010_pack_pk_rem,
        "10b_1280x720.mp4",
        (0, 0),
        false,
        HwP010PackPkRem
    );
    tq_hw!(
        hw_p010_pack_rem,
        "10b_768x432.mp4",
        (0, 0),
        false,
        HwP010PackRem
    );
    tq_hw!(
        hw_p010_pack_rem_pk_rem,
        "10b_1024x576.mp4",
        (0, 0),
        false,
        HwP010PackRemPkRem
    );
    tq_hw!(
        hw_p010_pack_rem_pk_rem_stride,
        "10b_718x480.mp4",
        (0, 0),
        false,
        HwP010PackRemPkRemStride
    );

    tq_hw!(
        hw_p010_crop_pack,
        "10b_1936x1080.mp4",
        (0, 8),
        false,
        HwP010CropPack { .. }
    );
    tq_hw!(
        hw_p010_crop_pack_pk_rem,
        "10b_1288x720.mp4",
        (0, 4),
        false,
        HwP010CropPackPkRem { .. }
    );
    tq_hw!(
        hw_p010_crop_pack_776,
        "10b_776x480.mp4",
        (0, 4),
        false,
        HwP010CropPack { .. }
    );
    tq_hw!(
        hw_p010_crop_pack_pk_rem_1920,
        "10b_1920x1080.mp4",
        (0, 4),
        false,
        HwP010CropPackPkRem { .. }
    );

    tq_sw!(dim_10b_2w2h, "10b_718x478.mp4", (0, 0), B10StrideRem);
    tq_sw!(dim_8b_2w2h, "8b_718x478.mp4", (0, 0), B8Stride);
    tq_sw!(dim_10b_4w8h, "10b_716x480.mp4", (0, 0), B10StrideRem);
    tq_sw!(dim_8b_4w8h, "8b_716x480.mp4", (0, 0), B8Stride);
    tq_sw!(dim_10b_8w8h, "10b_776x480.mp4", (0, 0), B10StrideRem);
    tq_sw!(
        dim_10b_2w2h_crop,
        "10b_718x478.mp4",
        (0, 2),
        B10CropRem { .. }
    );
    tq_sw!(dim_8b_2w2h_crop, "8b_718x478.mp4", (0, 2), B8Crop { .. });
    tq_sw!(
        dim_10b_4w8h_crop,
        "10b_720x480.mp4",
        (0, 2),
        B10CropRem { .. }
    );
    tq_sw!(dim_8b_4w8h_crop, "8b_768x480.mp4", (0, 2), B8Crop { .. });
    tq_sw!(
        dim_10b_8w8h_crop,
        "10b_768x480.mp4",
        (0, 4),
        B10CropRem { .. }
    );
    tq_sw!(
        dim_10b_1920_crop,
        "10b_1920x1080.mp4",
        (0, 4),
        B10CropRem { .. }
    );
    tq_sw!(dim_8b_8w8h_crop, "8b_1920x1080.mp4", (0, 4), B8Crop { .. });

    tq_hw!(
        dim_hw_10b_2w2h,
        "10b_718x478.mp4",
        (0, 0),
        false,
        HwP010PackRemPkRemStride
    );
    tq_hw!(
        dim_hw_10b_4w8h,
        "10b_716x480.mp4",
        (0, 0),
        false,
        HwP010PackRemPkRemStride
    );
    tq_hw!(dim_hw_8b_2w2h, "8b_718x478.mp4", (0, 0), true, HwNv12Stride);
    tq_hw!(dim_hw_8b_4w8h, "8b_716x480.mp4", (0, 0), true, HwNv12Stride);
}
