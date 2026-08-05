#[cfg(target_feature = "avx512bw")]
include!("avx512.rs");
#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
include!("avx2.rs");

use alloc::sync::Arc;
#[cfg(target_os = "linux")]
use alloc::{string::ToString as _, vec::Vec};

use crate::{
    chan::SpscRing,
    error::Xerr,
    ffms::{VidDecoder, VidInf},
    fs::write as fs_write,
    path::Path,
    progs::ProgsBar,
    thread::{available_parallelism, spawn},
};

fn detect<const HW: bool>(
    dec: &mut VidDecoder,
    dims: u64,
    tot: usize,
    line: usize,
    md: usize,
) -> Vec<u8> {
    let ring = Arc::new(SpscRing::new());
    let ring2 = Arc::clone(&ring);
    let det = spawn(move || {
        let mut kf: Vec<usize> = Vec::with_capacity(tot + 1);
        let mut wt: Vec<f32> = Vec::with_capacity(tot);
        let mut out: Vec<u8> = Vec::with_capacity((tot + tot / 75 + 3) * 21);
        let n = unsafe {
            [xav_scd_run, xav_scd_run16, xav_scd_run16s][md](
                (&raw const *ring2).cast(),
                dims,
                tot,
                kf.as_mut_ptr(),
                wt.as_mut_ptr(),
                out.as_mut_ptr(),
            )
        };
        unsafe { out.set_len(n) };
        out
    });
    let (rp, mut pb) = (Arc::as_ptr(&ring).cast(), ProgsBar::new());
    let p = (&raw mut pb).cast();
    unsafe {
        if HW {
            xav_scd_feed_hw(dec, rp, tot, line, p);
        } else {
            xav_scd_feed(dec, rp, tot, line, p);
        }
    }
    det.join()
}

pub fn fd_scenes(
    vid_path: &Path,
    sc_file: &Path,
    inf: &VidInf,
    crop: (u32, u32),
    line: usize,
    hwdec: bool,
) -> Result<(), Xerr> {
    let tot = inf.frames;
    let (cv, ch) = crop;
    let dims = (u64::from(inf.width - ch * 2) << 48)
        | (u64::from(inf.height - cv * 2) << 32)
        | (u64::from(cv) << 16)
        | u64::from(ch);

    let thr = available_parallelism() as i32;
    let mut dec = if hwdec {
        VidDecoder::new_hw(vid_path, thr)
    } else {
        VidDecoder::new(vid_path, thr)
    }
    .map_err(|e| e.to_string())?;

    let md = usize::from(inf.is_10b) << usize::from(hwdec);
    let content = if hwdec {
        detect::<true>(&mut dec, dims, tot, line, md)
    } else {
        detect::<false>(&mut dec, dims, tot, line, md)
    };

    fs_write(sc_file, content)?;
    Ok(())
}
