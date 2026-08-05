#[cfg(target_feature = "avx512bw")]
include!("avx512.rs");
#[cfg(all(target_feature = "avx2", not(target_feature = "avx512bw")))]
include!("avx2.rs");

#[cfg(target_os = "linux")]
use alloc::vec::Vec;
use core::hint::cold_path;

#[cfg(all(target_os = "linux", not(test)))]
use crate::fmath::{FloatExt as _, Log10 as _};

#[inline(always)]
pub fn downmix(src: &[f32], dst: &mut [f32], ch: usize, n: usize) {
    match ch {
        6 => mix6(src, dst, n),
        7 => mix7(src, dst, n),
        8 => mix8(src, dst, n),
        _ => {
            cold_path();
            downmix_rare(src, dst, ch, n);
        }
    }
}

#[cold]
#[inline(never)]
fn downmix_rare(src: &[f32], dst: &mut [f32], ch: usize, n: usize) {
    for i in 0..n {
        let b = i * ch;
        let fc = src[b + 2];
        dst[2 * i] = 0.707f32.mul_add(fc, src[b]);
        dst[2 * i + 1] = 0.707f32.mul_add(fc, src[b + 1]);
    }
}

const HOP: usize = 4800;
const ABS_Z: f64 = 1.172_510_988_627_791_1e-7;
const RA1: f64 = -1.990_047_454_833_979_7;
const RA2: f64 = 0.990_072_250_366_209_9;
const PA1: f64 = -1.690_659_293_182_410_3;
const PA2: f64 = 0.732_480_774_215_850_1;
const PB0: f64 = 1.535_124_859_586_970_2;
const PB1: f64 = -2.691_696_189_406_380_7;
const PB2: f64 = 1.198_392_810_852_85;

#[inline(always)]
fn loud(src: *const f32, n: usize, stride: usize, st: &mut [f64; 32], out: &mut [f64; 4]) {
    unsafe { xav_loud(src, n, stride, st.as_mut_ptr(), out.as_mut_ptr()) };
}

pub fn measure(stereo: &[f32]) -> (f32, f32) {
    let total = stereo.len() / 2;
    let nsub = total / HOP;
    if nsub == 0 {
        cold_path();
        return (-70.0, 0.0);
    }
    let per = nsub / 4;
    let extra = nsub - 4 * per;
    let stride = per * HOP;
    let mut s: Vec<f64> = Vec::with_capacity(nsub);
    let mut st = [0f64; 32];
    let mut o = [0f64; 4];
    let sp = s.spare_capacity_mut();
    for sb in 0..per {
        loud(
            unsafe { stereo.as_ptr().add(sb * HOP * 2) },
            HOP,
            stride,
            &mut st,
            &mut o,
        );
        unsafe {
            sp.get_unchecked_mut(sb).write(o[0]);
            sp.get_unchecked_mut(per + sb).write(o[1]);
            sp.get_unchecked_mut(2 * per + sb).write(o[2]);
            sp.get_unchecked_mut(3 * per + sb).write(o[3]);
        }
    }
    unsafe { s.set_len(4 * per) };
    remainder(stereo, 4 * per, extra, &st, &mut s);
    (integrated(&s) as f32, range(&s) as f32)
}

#[cold]
#[inline(never)]
fn remainder(stereo: &[f32], start: usize, extra: usize, st: &[f64; 32], s: &mut Vec<f64>) {
    let (mut w1l, mut w1r, mut w2l, mut w2r, mut v1l, mut v1r, mut v2l, mut v2r) =
        (st[6], st[7], st[14], st[15], st[22], st[23], st[30], st[31]);
    for e in 0..extra {
        let base = (start + e) * HOP;
        let mut acc = 0f64;
        for i in 0..HOP {
            let x = (base + i) * 2;
            let xl = f64::from(unsafe { *stereo.get_unchecked(x) });
            let w0 = RA1.mul_add(-w1l, RA2.mul_add(-w2l, xl));
            let yh = (w0 - w1l) - (w1l - w2l);
            let v0 = PA1.mul_add(-v1l, PA2.mul_add(-v2l, yh));
            let y = PB2.mul_add(v2l, PB1.mul_add(v1l, PB0 * v0));
            w2l = w1l;
            w1l = w0;
            v2l = v1l;
            v1l = v0;
            acc = y.mul_add(y, acc);
            let xr = f64::from(unsafe { *stereo.get_unchecked(x + 1) });
            let w0 = RA1.mul_add(-w1r, RA2.mul_add(-w2r, xr));
            let yh = (w0 - w1r) - (w1r - w2r);
            let v0 = PA1.mul_add(-v1r, PA2.mul_add(-v2r, yh));
            let y = PB2.mul_add(v2r, PB1.mul_add(v1r, PB0 * v0));
            w2r = w1r;
            w1r = w0;
            v2r = v1r;
            v1r = v0;
            acc = y.mul_add(y, acc);
        }
        s.push(acc);
    }
}

#[cold]
#[inline(never)]
fn integrated(s: &[f64]) -> f64 {
    if s.len() < 4 {
        return -70.0;
    }
    let nb = s.len() - 3;
    let block = |j: usize| (s[j] + s[j + 1] + s[j + 2] + s[j + 3]) / 19200.0;
    let mut sum = 0f64;
    let mut cnt = 0usize;
    for j in 0..nb {
        let z = block(j);
        if z >= ABS_Z {
            sum += z;
            cnt += 1;
        }
    }
    if cnt == 0 {
        return -70.0;
    }
    let rel = sum / cnt as f64 / 10.0;
    let mut sum2 = 0f64;
    let mut cnt2 = 0usize;
    for j in 0..nb {
        let z = block(j);
        if z >= ABS_Z && z >= rel {
            sum2 += z;
            cnt2 += 1;
        }
    }
    if cnt2 == 0 {
        return -70.0;
    }
    0.691f64.mul_add(-1.0, 10.0 * (sum2 / cnt2 as f64).log10())
}

#[cold]
#[inline(never)]
fn range(s: &[f64]) -> f64 {
    if s.len() < 30 {
        return 0.0;
    }
    let nwin = (s.len() - 30) / 10 + 1;
    let mut q: Vec<f64> = (0..nwin)
        .map(|m| s[10 * m..10 * m + 30].iter().sum::<f64>() / 144_000.0)
        .collect();
    q.sort_unstable_by(f64::total_cmp);
    let power = q.iter().sum::<f64>() / q.len() as f64;
    let integ = power * 0.01;
    let relgated = q.iter().take_while(|&&v| v < integ).count();
    let rs = q.len() - relgated;
    if rs < 1 {
        return 0.0;
    }
    let rs1 = (rs - 1) as f64;
    let hi = q[relgated + rs1.mul_add(0.95, 0.5) as usize];
    let lo = q[relgated + rs1.mul_add(0.10, 0.5) as usize];
    10.0 * (hi / lo).log10()
}
