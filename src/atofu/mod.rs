#[cfg(target_feature = "avx512bw")]
include!("avx512.rs");
#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
include!("avx2.rs");
#[cfg(not(any(target_feature = "avx2", target_feature = "avx512bw")))]
include!("scalar.rs");

const WSIZE: usize = 60000;

pub struct TqChunkLine {
    pub id: usize,
    pub r: usize,
    pub f: usize,
    pub po: usize,
    pub pn: usize,
    pub fc: f32,
    pub fs: f32,
    pub fz: u64,
}

#[inline(always)]
fn pad(v: &mut Vec<u16>) {
    let last = *v.last().unwrap_or(&0);
    while !v.len().is_multiple_of(WIDTH) {
        v.push(last);
    }
}

pub fn parse_chunks(buf: &[u8]) -> (Vec<TqChunkLine>, Vec<(f32, f32, u64)>) {
    let flen = buf.len().saturating_sub(16);
    let base0 = buf.as_ptr();
    let mut out = Vec::new();
    let mut tri: Vec<(f32, f32, u64)> = Vec::new();
    let mut num: Vec<u16> = vec![0; WSIZE + 64];
    let mut nls: Vec<u16> = vec![0; WSIZE + 64];
    let mut uo: Vec<u16> = Vec::new();
    let mut f2o: Vec<u16> = Vec::new();
    let mut f4o: Vec<u16> = Vec::new();
    let mut uv: Vec<u64> = Vec::new();
    let mut f2v: Vec<f32> = Vec::new();
    let mut f4v: Vec<f32> = Vec::new();
    let mut ns: Vec<usize> = Vec::new();
    let mut wstart = 0;
    while wstart < flen {
        let wlen = (flen - wstart).min(WSIZE);
        let wbase = unsafe { base0.add(wstart) };
        let packed = unsafe { scan(wbase, wlen, num.as_mut_ptr(), nls.as_mut_ptr()) };
        let nc = packed as u32 as usize;
        let nl = (packed >> 32) as usize;
        if nl == 0 {
            break;
        }
        let last_nl = nls[nl - 1] as usize;
        uo.clear();
        f2o.clear();
        f4o.clear();
        ns.clear();
        let mut ni = 0;
        for &nl_off in nls.iter().take(nl) {
            let nlp = nl_off as usize;
            let ls = ni;
            while ni < nc && (num[ni] as usize) < nlp {
                ni += 1;
            }
            let cnt = ni - ls;
            if cnt < 6 || !(cnt - 6).is_multiple_of(3) {
                continue;
            }
            ns.push((cnt - 6) / 3);
            for j in 0..cnt {
                let off = num[ls + j];
                let cat = if j < 3 {
                    0u8
                } else if j >= cnt - 3 {
                    [1u8, 2, 0][j - (cnt - 3)]
                } else {
                    [1u8, 2, 0][(j - 3) % 3]
                };
                match cat {
                    0 => uo.push(off),
                    1 => f2o.push(off),
                    _ => f4o.push(off),
                }
            }
        }
        pad(&mut uo);
        pad(&mut f2o);
        pad(&mut f4o);
        uv.clear();
        uv.resize(uo.len(), 0);
        f2v.clear();
        f2v.resize(f2o.len(), 0.0);
        f4v.clear();
        f4v.resize(f4o.len(), 0.0);
        unsafe {
            atou_batch(wbase, uo.as_ptr(), uo.len(), uv.as_mut_ptr());
            atof2_batch(wbase, f2o.as_ptr(), f2o.len(), f2v.as_mut_ptr());
            atof4_batch(wbase, f4o.as_ptr(), f4o.len(), f4v.as_mut_ptr());
        }
        let mut ui = 0;
        let mut fi = 0;
        let mut gi = 0;
        for &n in &ns {
            let po = tri.len();
            for k in 0..n {
                tri.push((f2v[fi + k], f4v[gi + k], uv[ui + 3 + k]));
            }
            out.push(TqChunkLine {
                id: uv[ui] as usize,
                r: uv[ui + 1] as usize,
                f: uv[ui + 2] as usize,
                po,
                pn: n,
                fc: f2v[fi + n],
                fs: f4v[gi + n],
                fz: uv[ui + 3 + n],
            });
            ui += 3 + n + 1;
            fi += n + 1;
            gi += n + 1;
        }
        wstart += last_nl + 1;
    }
    (out, tri)
}
