use std::{
    collections::HashSet,
    env,
    fs::{self, File},
    io::{BufWriter, Write},
    mem::{size_of, zeroed},
    path::{Path, PathBuf},
    process::{self, Command, Stdio},
    ptr::null_mut,
    slice::from_raw_parts,
    sync::{
        Arc, Once,
        atomic::{AtomicUsize, Ordering::Relaxed},
    },
    thread,
};

use crossbeam_channel::bounded;

#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
use crate::avx2::{PACK_CHUNK, SHIFT_CHUNK, UNPACK_CHUNK};
#[cfg(target_feature = "avx512bw")]
use crate::avx512::{PACK_CHUNK, SHIFT_CHUNK, UNPACK_CHUNK};
#[cfg(not(any(target_feature = "avx2", target_feature = "avx512bw")))]
use crate::scalar::{PACK_CHUNK, SHIFT_CHUNK, UNPACK_CHUNK};
#[cfg(feature = "vship")]
use crate::vship::{VshipProcessor, init_device};
use crate::{
    chunk::{chunkify, load_scenes},
    decode::decode_chunks,
    encode::get_frame,
    encoder::{EncConfig, set_svt_config},
    ffms::{self, DecodeStrat, VidInf, VideoDecoder, get_vidinf},
    pack::{calc_8b_size, calc_packed_size},
    pipeline::{
        Pipeline, UnpackFn, WriteFn, write_frames_8b, write_frames_8b_rem, write_frames_10b,
    },
    svt::{
        EB_BUFFERFLAG_EOS, EB_ERROR_NONE, EbBufferHeaderType, EbComponentType,
        EbSvtAv1EncConfiguration, EbSvtIOFormat, svt_av1_enc_deinit, svt_av1_enc_deinit_handle,
        svt_av1_enc_get_packet, svt_av1_enc_init, svt_av1_enc_init_handle,
        svt_av1_enc_release_out_buffer, svt_av1_enc_send_picture, svt_av1_enc_set_parameter,
    },
    worker::{Semaphore, WorkPkg},
};

static TEST_ID: AtomicUsize = AtomicUsize::new(0);

#[cfg(feature = "vship")]
static INIT_DEVICE: Once = Once::new();

macro_rules! sw {
    ($name:ident, $file:expr, $crop:expr, $buf:literal, $strat:pat) => {
        #[test]
        fn $name() {
            use DecodeStrat::*;
            let strat = run_test($file, $crop, false, false, $buf, false);
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
            use DecodeStrat::*;
            let strat = run_test($file, $crop, true, $tq, $buf, false);
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

fn temp_ivf() -> PathBuf {
    let id = TEST_ID.fetch_add(1, Relaxed);
    env::temp_dir().join(format!("xav_test_{}_{id}.ivf", process::id()))
}

fn write_ivf_header(out: &mut impl Write, w: u32, h: u32, fps_num: u32, fps_den: u32) {
    let mut hdr = [0u8; 32];
    hdr[0..4].copy_from_slice(b"DKIF");
    hdr[6..8].copy_from_slice(&32u16.to_le_bytes());
    hdr[8..12].copy_from_slice(b"AV01");
    hdr[12..14].copy_from_slice(&(w as u16).to_le_bytes());
    hdr[14..16].copy_from_slice(&(h as u16).to_le_bytes());
    hdr[16..20].copy_from_slice(&fps_num.to_le_bytes());
    hdr[20..24].copy_from_slice(&fps_den.to_le_bytes());
    out.write_all(&hdr).unwrap();
}

fn svt_init(cfg: &EncConfig) -> *mut EbComponentType {
    let mut handle: *mut EbComponentType = null_mut();
    let mut config = unsafe { zeroed::<EbSvtAv1EncConfiguration>() };
    assert_eq!(
        unsafe { svt_av1_enc_init_handle(&raw mut handle, &raw mut config) },
        EB_ERROR_NONE
    );
    set_svt_config(&raw mut config, cfg);
    assert_eq!(
        unsafe { svt_av1_enc_set_parameter(handle, &raw mut config) },
        EB_ERROR_NONE
    );
    assert_eq!(unsafe { svt_av1_enc_init(handle) }, EB_ERROR_NONE);
    handle
}

fn svt_drain(handle: *mut EbComponentType, out: &mut impl Write, done: bool) {
    loop {
        let mut pkt: *mut EbBufferHeaderType = null_mut();
        let ret = unsafe { svt_av1_enc_get_packet(handle, &raw mut pkt, u8::from(done)) };
        if ret != EB_ERROR_NONE {
            break;
        }
        let p = unsafe { &*pkt };
        if p.n_filled_len > 0 {
            let data = unsafe { from_raw_parts(p.p_buffer, p.n_filled_len as usize) };
            _ = out.write_all(&(data.len() as u32).to_le_bytes());
            _ = out.write_all(&p.pts.cast_unsigned().to_le_bytes());
            _ = out.write_all(data);
        }
        let eos = p.flags & EB_BUFFERFLAG_EOS != 0;
        unsafe { svt_av1_enc_release_out_buffer(&raw mut pkt) };
        if eos {
            break;
        }
    }
}

fn ffmpeg_reference(input: &Path, w: usize, h: usize, crop: (u32, u32)) -> Vec<u8> {
    let mut cmd = Command::new("ffmpeg");
    cmd.args(["-i", input.to_str().unwrap()]);
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
    let output = cmd.output().unwrap();
    assert!(
        output.status.success(),
        "ffmpeg reference extraction failed"
    );
    output.stdout
}

fn prod_convert(all_yuv: &[u8], pipe: &Pipeline, frame_count: usize) -> Vec<u8> {
    if pipe.conv_buf_size == 0 {
        return all_yuv[..frame_count * pipe.frame_size].to_vec();
    }
    let mut child = Command::new("cat")
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::null())
        .spawn()
        .unwrap();
    let stdin = child.stdin.take().unwrap();
    thread::scope(|s| {
        s.spawn(move || {
            let mut stdin = stdin;
            let mut buf = vec![0u8; pipe.conv_buf_size];
            (pipe.write_frames)(&mut stdin, all_yuv, frame_count, &mut buf, pipe);
        });
        child.wait_with_output().unwrap().stdout
    })
}

fn svt_encode(converted: &[u8], pipe: &Pipeline, inf: &VidInf, frame_count: usize, output: &Path) {
    let w = pipe.final_w;
    let h = pipe.final_h;
    let y_size = w * h * 2;
    let uv_size = (w / 2) * (h / 2) * 2;
    let enc_frame_size = y_size + uv_size * 2;

    let cfg = EncConfig {
        inf,
        params: "--preset 7 --lp 5 --scm 0",
        zone_params: None,
        crf: 20.0,
        output,
        grain_table: None,
        chunk_idx: 0,
        width: w as u32,
        height: h as u32,
        frames: frame_count,
    };
    let handle = svt_init(&cfg);

    let mut out = BufWriter::new(File::create(output).unwrap());
    write_ivf_header(&mut out, cfg.width, cfg.height, inf.fps_num, inf.fps_den);

    let mut io_fmt = EbSvtIOFormat {
        luma: null_mut(),
        cb: null_mut(),
        cr: null_mut(),
        y_stride: w as u32,
        cb_stride: (w / 2) as u32,
        cr_stride: (w / 2) as u32,
    };
    let io_ptr = &raw mut io_fmt;

    let mut in_hdr = unsafe { zeroed::<EbBufferHeaderType>() };
    in_hdr.size = size_of::<EbBufferHeaderType>() as u32;
    in_hdr.p_buffer = io_ptr.cast::<u8>();
    in_hdr.n_filled_len = enc_frame_size as u32;
    in_hdr.n_alloc_len = in_hdr.n_filled_len;

    for i in 0..frame_count {
        let off = i * enc_frame_size;
        unsafe {
            (*io_ptr).luma = converted[off..].as_ptr().cast_mut();
            (*io_ptr).cb = converted[off + y_size..].as_ptr().cast_mut();
            (*io_ptr).cr = converted[off + y_size + uv_size..].as_ptr().cast_mut();
        }

        in_hdr.pts = i as i64;
        in_hdr.flags = 0;
        assert_eq!(
            unsafe { svt_av1_enc_send_picture(handle, &raw mut in_hdr) },
            EB_ERROR_NONE
        );
        svt_drain(handle, &mut out, false);
    }

    let mut eos = unsafe { zeroed::<EbBufferHeaderType>() };
    eos.flags = EB_BUFFERFLAG_EOS;
    unsafe { svt_av1_enc_send_picture(handle, &raw mut eos) };
    svt_drain(handle, &mut out, true);

    drop(out);
    unsafe {
        svt_av1_enc_deinit(handle);
        svt_av1_enc_deinit_handle(handle);
    }
}

fn verify_pixels(reference: &[u8], production: &[u8], pipe: &Pipeline) {
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
        let w = pipe.final_w;
        let h = pipe.final_h;
        let y_bytes = w * h * 2;
        let uv_bytes = w / 2 * (h / 2) * 2;
        let (plane, plane_pos) = if pos < y_bytes {
            ("Y", pos)
        } else if pos < y_bytes + uv_bytes {
            ("U", pos - y_bytes)
        } else {
            ("V", pos - y_bytes - uv_bytes)
        };
        let plane_w = if plane == "Y" { w } else { w / 2 };
        let px = (plane_pos / 2) % plane_w;
        let py = (plane_pos / 2) / plane_w;
        let ref_val =
            u16::from(reference[pos]) | (u16::from(reference[pos.saturating_add(1)]) << 8);
        let prod_val =
            u16::from(production[pos]) | (u16::from(production[pos.saturating_add(1)]) << 8);
        panic!("pixel mismatch in {plane} plane at ({px},{py}) ref={ref_val} prod={prod_val}");
    }
}

fn verify_dispatch(strat: DecodeStrat, pipe: &Pipeline, inf: &VidInf, tq_mode: bool) {
    use DecodeStrat::*;

    use crate::{encode::test_access as enc_ta, pipeline::test_access as pipe_ta};

    let name = format!("{strat:?}");
    let is_nv12_to_10 = matches!(strat, HwNv12To10 | HwNv12To10Stride | HwNv12CropTo10 { .. });

    let (exp_unpack, exp_write): (UnpackFn, WriteFn) = if is_nv12_to_10 {
        let y_ok = (pipe.final_w * pipe.final_h).is_multiple_of(SHIFT_CHUNK);
        let uv_ok = (pipe.final_w / 2 * (pipe.final_h / 2)).is_multiple_of(SHIFT_CHUNK * 2);
        if y_ok && uv_ok {
            (pipe_ta::NV12_TO_10B, write_frames_10b)
        } else {
            (pipe_ta::NV12_TO_10B_REM, write_frames_10b)
        }
    } else if strat.is_raw() {
        (pipe_ta::UNPACK_NOOP, write_frames_10b)
    } else if !inf.is_10b {
        if pipe.frame_size.is_multiple_of(SHIFT_CHUNK) {
            (pipe_ta::UNPACK_NOOP, write_frames_8b)
        } else {
            (pipe_ta::UNPACK_NOOP, write_frames_8b_rem)
        }
    } else if !pipe.final_w.is_multiple_of(PACK_CHUNK)
        || !pipe.frame_size.is_multiple_of(UNPACK_CHUNK)
    {
        (pipe_ta::UNPACK_10B_REM, write_frames_10b)
    } else {
        (pipe_ta::UNPACK_10B, write_frames_10b)
    };
    assert_eq!(
        pipe.unpack as usize, exp_unpack as usize,
        "wrong unpack fn for {name}"
    );
    assert_eq!(
        pipe.write_frames as usize, exp_write as usize,
        "wrong write_frames fn for {name}"
    );

    if !tq_mode {
        let actual_enc = enc_ta::resolve_svt_enc_addr(strat, is_nv12_to_10, inf, pipe);
        let expected_enc = if strat.is_raw() {
            enc_ta::enc_svt_direct_addr()
        } else if is_nv12_to_10 {
            let y_ok = (pipe.final_w * pipe.final_h).is_multiple_of(SHIFT_CHUNK);
            let uv_ok = (pipe.final_w / 2 * (pipe.final_h / 2)).is_multiple_of(SHIFT_CHUNK * 2);
            if y_ok && uv_ok {
                enc_ta::enc_svt_nv12_drop_addr()
            } else {
                enc_ta::enc_svt_nv12_drop_rem_addr()
            }
        } else if !inf.is_10b && !pipe.frame_size.is_multiple_of(SHIFT_CHUNK) {
            enc_ta::enc_svt_drop_rem_addr()
        } else {
            enc_ta::enc_svt_drop_addr()
        };
        assert_eq!(actual_enc, expected_enc, "wrong SVT encode fn for {name}");
    }

    #[cfg(feature = "vship")]
    if tq_mode {
        use crate::{
            pipeline::CalcMetricsFn,
            tq::{calc_metrics_8b, calc_metrics_10b},
        };

        assert_eq!(
            pipe.compute_metric as usize,
            pipe_ta::COMPUTE_CVVDP as usize,
            "wrong compute_metric for {name}"
        );

        let expected_calc = if inf.is_10b {
            (calc_metrics_10b as CalcMetricsFn) as usize
        } else {
            (calc_metrics_8b as CalcMetricsFn) as usize
        };
        assert_eq!(
            pipe.calc_metrics as usize, expected_calc,
            "wrong calc_metrics fn for {name}"
        );
    }
}

fn verify_pipeline(pipe: &Pipeline, inf: &VidInf, crop: (u32, u32), strat: DecodeStrat) {
    let has_crop = crop != (0, 0);
    let (expected_w, expected_h) = if has_crop {
        (
            (inf.width - crop.1 * 2) as usize,
            (inf.height - crop.0 * 2) as usize,
        )
    } else {
        (inf.width as usize, inf.height as usize)
    };

    assert_eq!(pipe.final_w, expected_w, "pipeline width mismatch");
    assert_eq!(pipe.final_h, expected_h, "pipeline height mismatch");

    if strat.is_raw() {
        assert_eq!(
            pipe.frame_size,
            expected_w * expected_h * 3,
            "raw frame_size mismatch"
        );
        assert_eq!(pipe.conv_buf_size, 0, "raw conv_buf_size should be 0");
    } else if inf.is_10b {
        assert_eq!(
            pipe.frame_size,
            calc_packed_size(expected_w as u32, expected_h as u32),
            "packed frame_size mismatch"
        );
    } else {
        assert_eq!(
            pipe.frame_size,
            calc_8b_size(expected_w as u32, expected_h as u32),
            "8b frame_size mismatch"
        );
    }

    let pixel_size = if inf.is_10b { 2 } else { 1 };
    assert_eq!(
        pipe.y_size,
        expected_w * expected_h * pixel_size,
        "y_size mismatch"
    );
    assert_eq!(pipe.uv_size, pipe.y_size / 4, "uv_size mismatch");
}

#[cfg(feature = "vship")]
fn validate_tq(
    all_yuv: &[u8],
    pipe: &Pipeline,
    inf: &VidInf,
    total_frames: usize,
    ivf: &Path,
    filename: &str,
) {
    let display_json = test_path("display.json");
    let config_str = display_json.to_str().expect("non-UTF8 path");

    INIT_DEVICE.call_once(|| init_device().unwrap());

    let vship = VshipProcessor::new(
        pipe.final_w as u32,
        pipe.final_h as u32,
        inf,
        true,
        false,
        Some("xav"),
        Some(config_str),
    )
    .unwrap();
    vship.reset_cvvdp();

    let threads = thread::available_parallelism().map_or(1, |n| n.get() as i32);
    let mut probe_dec = VideoDecoder::new(ivf, threads).unwrap();

    let pixel_size = if inf.is_10b { 2 } else { 1 };
    let y_sz = pipe.final_w * pipe.final_h * pixel_size;
    let uv_sz = y_sz / 4;
    let ys = (pipe.final_w * pixel_size) as i64;
    let cs = (pipe.final_w / 2 * pixel_size) as i64;

    let mut unpacked_buf = vec![0u8; pipe.conv_buf_size];
    let mut last_score = 0.0;

    for i in 0..total_frames {
        let input_frame = get_frame(all_yuv, i, pipe.frame_size);
        let of = probe_dec.decode_next();

        let input_yuv: &[u8] = if inf.is_10b {
            (pipe.unpack)(input_frame, &mut unpacked_buf, pipe);
            &unpacked_buf
        } else {
            input_frame
        };

        let input_planes = [
            input_yuv.as_ptr(),
            input_yuv[y_sz..].as_ptr(),
            input_yuv[y_sz + uv_sz..].as_ptr(),
        ];

        let of = unsafe { &*of };
        let output_planes = [
            of.data[0].cast_const(),
            of.data[1].cast_const(),
            of.data[2].cast_const(),
        ];
        let output_strides = [
            i64::from(of.linesize[0]),
            i64::from(of.linesize[1]),
            i64::from(of.linesize[2]),
        ];

        last_score = (pipe.compute_metric)(
            &vship,
            input_planes,
            output_planes,
            [ys, cs, cs],
            output_strides,
        );
    }

    assert!(
        last_score > 9.0,
        "CVVDP score {last_score:.4} < 9.0 for {filename}"
    );
}

fn run_test(
    filename: &str,
    crop: (u32, u32),
    hwaccel: bool,
    tq: bool,
    buffer: usize,
    tq_mode: bool,
) -> DecodeStrat {
    let input = test_path(filename);
    let mut inf = get_vidinf(&input).unwrap();
    if hwaccel {
        let mut dec = VideoDecoder::new_hw(&input, 1).unwrap();
        inf.y_linesize = unsafe { (*dec.decode_next()).linesize[0] as usize };
    }

    let mut strat = ffms::get_decode_strat(&inf, crop, hwaccel, tq);
    if buffer == 0 {
        strat = strat.to_raw();
    }

    let pipe = Pipeline::new(
        &inf,
        strat,
        #[cfg(feature = "vship")]
        tq_mode.then_some("8-10"),
    );

    verify_dispatch(strat, &pipe, &inf, tq_mode);
    verify_pipeline(&pipe, &inf, crop, strat);

    let scenes_path = test_path("scenes.txt");
    let scenes = load_scenes(&scenes_path, inf.frames).unwrap();
    let chunks = chunkify(&scenes);

    let (tx, rx) = bounded::<WorkPkg>(1);
    let sem = Arc::new(Semaphore::new(1));
    let handle = thread::spawn({
        let input = input.clone();
        let inf = inf.clone();
        let sem = Arc::clone(&sem);
        move || {
            decode_chunks(&chunks, &input, &inf, &tx, &HashSet::new(), strat, &sem);
        }
    });

    let mut all_yuv = Vec::new();
    let mut total_frames = 0usize;
    while let Ok(pkg) = rx.recv() {
        total_frames += pkg.frame_count;
        all_yuv.extend_from_slice(&pkg.yuv);
        sem.release();
    }
    handle.join().unwrap();

    assert!(total_frames > 0);
    assert_eq!(all_yuv.len(), total_frames * pipe.frame_size);

    let converted = prod_convert(&all_yuv, &pipe, total_frames);
    let reference = ffmpeg_reference(&input, pipe.final_w, pipe.final_h, crop);
    let enc_frame_size = pipe.final_w * pipe.final_h * 3;
    verify_pixels(&reference, &converted[..enc_frame_size], &pipe);

    let ivf = temp_ivf();
    svt_encode(&converted, &pipe, &inf, total_frames, &ivf);
    let ivf_size = fs::metadata(&ivf).map_or(0, |m| m.len());
    assert!(ivf_size > 32, "IVF file too small: {ivf_size}");

    #[cfg(feature = "vship")]
    if tq_mode {
        validate_tq(&all_yuv, &pipe, &inf, total_frames, &ivf, filename);
    }
    #[cfg(not(feature = "vship"))]
    let _ = tq_mode;

    _ = fs::remove_file(&ivf);
    strat
}

#[test]
fn strat_coverage() {
    use DecodeStrat::*;
    fn _exhaustive(s: DecodeStrat) {
        match s {
            B10Fast
            | B10FastRem
            | B10StrideRem
            | B10Crop { .. }
            | B10CropRem { .. }
            | B10CropFast { .. }
            | B10CropFastRem { .. }
            | B10CropStride { .. }
            | B10CropStrideRem { .. }
            | B10Raw
            | B10RawStride
            | B10RawCrop { .. }
            | B10RawCropFast { .. }
            | B10RawCropStride { .. }
            | B8Fast
            | B8Stride
            | B8Crop { .. }
            | B8CropFast { .. }
            | B8CropStride { .. }
            | HwNv12
            | HwNv12Stride
            | HwNv12Crop { .. }
            | HwNv12To10
            | HwNv12To10Stride
            | HwNv12CropTo10 { .. }
            | HwP010Raw
            | HwP010RawRem
            | HwP010RawRemStride
            | HwP010RawCrop { .. }
            | HwP010RawCropRem { .. }
            | HwP010Pack
            | HwP010PackRem
            | HwP010PackPkRem
            | HwP010PackRemPkRem
            | HwP010PackRemPkRemStride
            | HwP010CropPack { .. }
            | HwP010CropPackRem { .. }
            | HwP010CropPackPkRem { .. }
            | HwP010CropPackRemPkRem { .. } => {}
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
    B8CropStride { .. }
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
    B10CropStride { .. }
);
sw!(
    sw_b10_crop_stride_rem,
    "10b_720x480.mp4",
    (0, 4),
    1,
    B10CropStrideRem { .. }
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
    B10RawCropStride { .. }
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
    B10CropStrideRem { .. }
);
sw!(
    dim_8b_2w2h_crop,
    "8b_718x478.mp4",
    (0, 2),
    1,
    B8CropStride { .. }
);
sw!(
    dim_10b_4w8h_crop,
    "10b_720x480.mp4",
    (0, 2),
    1,
    B10CropStrideRem { .. }
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
    "10b_960x480.mp4",
    (0, 0),
    false,
    1,
    HwP010PackPkRem
);
hw!(
    hw_p010_pack_rem,
    "10b_768x480.mp4",
    (0, 0),
    false,
    1,
    HwP010PackRem
);
hw!(
    hw_p010_pack_rem_pk_rem,
    "10b_704x480.mp4",
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
    "10b_968x480.mp4",
    (0, 4),
    false,
    1,
    HwP010CropPackPkRem { .. }
);
hw!(
    hw_p010_crop_pack_rem,
    "10b_776x480.mp4",
    (0, 4),
    false,
    1,
    HwP010CropPackRem { .. }
);
hw!(
    hw_p010_crop_pack_rem_pk_rem,
    "10b_1920x1080.mp4",
    (0, 4),
    false,
    1,
    HwP010CropPackRemPkRem { .. }
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
    "10b_768x480.mp4",
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
    hw_p010_raw_crop_rem,
    "10b_776x480.mp4",
    (0, 4),
    false,
    0,
    HwP010RawCropRem { .. }
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
                use DecodeStrat::*;
                let strat = run_test($file, $crop, false, false, 1, true);
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
                use DecodeStrat::*;
                let strat = run_test($file, $crop, true, $tq, 1, true);
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
    tq_sw!(
        sw_b8_crop_stride,
        "8b_718x480.mp4",
        (0, 2),
        B8CropStride { .. }
    );

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
        B10CropStride { .. }
    );
    tq_sw!(
        sw_b10_crop_stride_rem,
        "10b_720x480.mp4",
        (0, 4),
        B10CropStrideRem { .. }
    );

    tq_hw!(hw_nv12, "8b_1920x1080.mp4", (0, 0), true, HwNv12);
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
        "10b_960x480.mp4",
        (0, 0),
        false,
        HwP010PackPkRem
    );
    tq_hw!(
        hw_p010_pack_rem,
        "10b_768x480.mp4",
        (0, 0),
        false,
        HwP010PackRem
    );
    tq_hw!(
        hw_p010_pack_rem_pk_rem,
        "10b_704x480.mp4",
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
        "10b_968x480.mp4",
        (0, 4),
        false,
        HwP010CropPackPkRem { .. }
    );
    tq_hw!(
        hw_p010_crop_pack_rem,
        "10b_776x480.mp4",
        (0, 4),
        false,
        HwP010CropPackRem { .. }
    );
    tq_hw!(
        hw_p010_crop_pack_rem_pk_rem,
        "10b_1920x1080.mp4",
        (0, 4),
        false,
        HwP010CropPackRemPkRem { .. }
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
        B10CropStrideRem { .. }
    );
    tq_sw!(
        dim_8b_2w2h_crop,
        "8b_718x478.mp4",
        (0, 2),
        B8CropStride { .. }
    );
    tq_sw!(
        dim_10b_4w8h_crop,
        "10b_720x480.mp4",
        (0, 2),
        B10CropStrideRem { .. }
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
