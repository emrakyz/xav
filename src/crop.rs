use crate::{
    error::Xerr,
    ffms::{VidDecoder, VidInf},
    path::Path,
};

unsafe extern "C" {
    fn xav_crop_detect(
        dc: *mut VidDecoder,
        frames: usize,
        w: usize,
        h: usize,
        is10b: usize,
        line: usize,
        out: *mut u32,
    );
}

pub fn detect_crop(
    path: &Path,
    inf: &VidInf,
    threads: i32,
    line: usize,
) -> Result<(u32, u32), Xerr> {
    let mut dec = VidDecoder::new(path, threads)?;
    let mut out = [0u32; 2];
    unsafe {
        xav_crop_detect(
            &raw mut dec,
            inf.frames,
            inf.width as usize,
            inf.height as usize,
            usize::from(inf.is_10b),
            line,
            out.as_mut_ptr(),
        );
    }
    Ok(out.into())
}
