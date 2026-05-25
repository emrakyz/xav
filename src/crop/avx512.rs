unsafe extern "C" {
    fn xav_crop_row_stats_u8(
        row: *const u8,
        n: usize,
        c: u8,
        s: *mut u32,
        mn: *mut u8,
        mx: *mut u8,
    );
    fn xav_crop_row_stats_u16(
        row: *const u16,
        n: usize,
        c: u16,
        s: *mut u32,
        mn: *mut u16,
        mx: *mut u16,
    );
    fn xav_crop_col_stats_u8(
        p: *const u8,
        stride: usize,
        n: usize,
        c: u8,
        s: *mut u32,
        mn: *mut u8,
        mx: *mut u8,
    );
    fn xav_crop_col_stats_u16(
        p: *const u16,
        stride: usize,
        n: usize,
        c: u16,
        s: *mut u32,
        mn: *mut u16,
        mx: *mut u16,
    );
    fn xav_calc_samp_frames(step_bits: u32, tot: usize, cnt: usize, out: *mut u32);
}

fn calc_samp_frames(tot_frames: usize, sample_cnt: usize) -> Vec<u32> {
    if tot_frames <= sample_cnt {
        return (0..tot_frames as u32).collect();
    }
    let cap = sample_cnt.next_multiple_of(16);
    let mut frames: Vec<u32> = Vec::with_capacity(cap);
    let step = tot_frames as f32 / (sample_cnt + 1) as f32;
    unsafe {
        xav_calc_samp_frames(step.to_bits(), tot_frames, sample_cnt, frames.as_mut_ptr());
        frames.set_len(sample_cnt);
    }
    frames
}

trait Px: Copy + Ord + 'static {
    const CLAMP: Self;
    const DARK: u32;
    const VAR: u32;
    const MN_INIT: Self;
    const MX_INIT: Self;
    const PIX_PER_CHUNK: usize;
    const ROW_UNROLL: usize;
    const COL_UNROLL: usize;
    fn as_u32(self) -> u32;
    unsafe fn row_kernel(
        row: *const Self,
        n: usize,
        c: Self,
        s: *mut u32,
        mn: *mut Self,
        mx: *mut Self,
    );
    unsafe fn col_kernel(
        p: *const Self,
        stride: usize,
        n: usize,
        c: Self,
        s: *mut u32,
        mn: *mut Self,
        mx: *mut Self,
    );
}

impl Px for u8 {
    const CLAMP: Self = 16;
    const COL_UNROLL: usize = 16;
    const DARK: u32 = 32;
    const MN_INIT: Self = Self::MAX;
    const MX_INIT: Self = 0;
    const PIX_PER_CHUNK: usize = 64;
    const ROW_UNROLL: usize = 6;
    const VAR: u32 = 16;

    #[inline(always)]
    fn as_u32(self) -> u32 {
        u32::from(self)
    }

    #[inline(always)]
    unsafe fn row_kernel(
        row: *const Self,
        n: usize,
        c: Self,
        s: *mut u32,
        mn: *mut Self,
        mx: *mut Self,
    ) {
        unsafe {
            xav_crop_row_stats_u8(row, n, c, s, mn, mx);
        }
    }

    #[inline(always)]
    unsafe fn col_kernel(
        p: *const Self,
        stride: usize,
        n: usize,
        c: Self,
        s: *mut u32,
        mn: *mut Self,
        mx: *mut Self,
    ) {
        unsafe {
            xav_crop_col_stats_u8(p, stride, n, c, s, mn, mx);
        }
    }
}

impl Px for u16 {
    const CLAMP: Self = 64;
    const COL_UNROLL: usize = 16;
    const DARK: u32 = 128;
    const MN_INIT: Self = Self::MAX;
    const MX_INIT: Self = 0;
    const PIX_PER_CHUNK: usize = 32;
    const ROW_UNROLL: usize = 2;
    const VAR: u32 = 64;

    #[inline(always)]
    fn as_u32(self) -> u32 {
        u32::from(self)
    }

    #[inline(always)]
    unsafe fn row_kernel(
        row: *const Self,
        n: usize,
        c: Self,
        s: *mut u32,
        mn: *mut Self,
        mx: *mut Self,
    ) {
        unsafe {
            xav_crop_row_stats_u16(row, n, c, s, mn, mx);
        }
    }

    #[inline(always)]
    unsafe fn col_kernel(
        p: *const Self,
        stride: usize,
        n: usize,
        c: Self,
        s: *mut u32,
        mn: *mut Self,
        mx: *mut Self,
    ) {
        unsafe {
            xav_crop_col_stats_u16(p, stride, n, c, s, mn, mx);
        }
    }
}

#[inline(always)]
unsafe fn row_stats<P: Px>(row: *const P, w: usize) -> (u32, P, P) {
    let chnks = w / P::PIX_PER_CHUNK;
    let n_safe = chnks - chnks % P::ROW_UNROLL;
    let mut s = 0u32;
    let mut mn = P::MN_INIT;
    let mut mx = P::MX_INIT;
    if n_safe > 0 {
        unsafe {
            P::row_kernel(row, n_safe, P::CLAMP, &raw mut s, &raw mut mn, &raw mut mx);
        }
    }
    let bulk = n_safe * P::PIX_PER_CHUNK;
    if bulk < w {
        unsafe {
            row_tail::<P>(row, bulk, w - bulk, &mut s, &mut mn, &mut mx);
        }
    }
    (s, mn, mx)
}

#[cold]
#[inline(never)]
unsafe fn row_tail<P: Px>(
    row: *const P,
    start: usize,
    n: usize,
    s: &mut u32,
    mn: &mut P,
    mx: &mut P,
) {
    for i in start..start + n {
        let v = unsafe { *row.add(i) }.max(P::CLAMP);
        *s += v.as_u32();
        if v < *mn {
            *mn = v;
        }
        if v > *mx {
            *mx = v;
        }
    }
}

#[inline(always)]
unsafe fn col_stats<P: Px>(
    p: *const P,
    stride: usize,
    h: usize,
    sums: &mut [u32; 64],
    mins: &mut [P; 64],
    maxs: &mut [P; 64],
) {
    *sums = [0; 64];
    *mins = [P::MN_INIT; 64];
    *maxs = [P::MX_INIT; 64];
    let h_safe = h - h % P::COL_UNROLL;
    if h_safe > 0 {
        unsafe {
            P::col_kernel(
                p,
                stride,
                h_safe,
                P::CLAMP,
                sums.as_mut_ptr(),
                mins.as_mut_ptr(),
                maxs.as_mut_ptr(),
            );
        }
    }
    if h_safe < h {
        unsafe {
            col_row_tail::<P>(p, stride, h_safe, h - h_safe, sums, mins, maxs);
        }
    }
}

#[cold]
#[inline(never)]
unsafe fn col_row_tail<P: Px>(
    p: *const P,
    stride: usize,
    row_start: usize,
    n_rows: usize,
    sums: &mut [u32; 64],
    mins: &mut [P; 64],
    maxs: &mut [P; 64],
) {
    let stride_pix = stride / size_of::<P>();
    for row in row_start..row_start + n_rows {
        for c in 0..64 {
            let v = unsafe { *p.add(row * stride_pix + c) }.max(P::CLAMP);
            sums[c] += v.as_u32();
            if v < mins[c] {
                mins[c] = v;
            }
            if v > maxs[c] {
                maxs[c] = v;
            }
        }
    }
}

#[cold]
#[inline(never)]
unsafe fn col_narrow<P: Px>(
    p: *const P,
    stride: usize,
    h: usize,
    n_cols: usize,
    sums: &mut [u32; 64],
    mins: &mut [P; 64],
    maxs: &mut [P; 64],
) {
    let stride_pix = stride / size_of::<P>();
    for c in 0..n_cols {
        let mut s = 0u32;
        let mut mn = P::MN_INIT;
        let mut mx = P::MX_INIT;
        for row in 0..h {
            let v = unsafe { *p.add(row * stride_pix + c) }.max(P::CLAMP);
            s += v.as_u32();
            if v < mn {
                mn = v;
            }
            if v > mx {
                mx = v;
            }
        }
        sums[c] = s;
        mins[c] = mn;
        maxs[c] = mx;
    }
}

#[inline(always)]
fn trip<P: Px>(sum: u32, mn: P, mx: P, n: u32) -> bool {
    let avg = sum / n;
    avg >= P::DARK
        || avg.saturating_sub(mn.as_u32()) > P::VAR
        || mx.as_u32().saturating_sub(avg) > P::VAR
}

unsafe fn detect_top<P: Px>(data: *const P, w: usize, h: usize, stride: usize) -> Option<u32> {
    let stride_pix = stride / size_of::<P>();
    for row in 0..h {
        let p = unsafe { data.add(row * stride_pix) };
        let (s, mn, mx) = unsafe { row_stats::<P>(p, w) };
        if trip::<P>(s, mn, mx, w as u32) {
            return Some(row as u32);
        }
    }
    None
}

unsafe fn detect_bot<P: Px>(data: *const P, w: usize, h: usize, stride: usize) -> Option<u32> {
    let stride_pix = stride / size_of::<P>();
    for row in (0..h).rev() {
        let p = unsafe { data.add(row * stride_pix) };
        let (s, mn, mx) = unsafe { row_stats::<P>(p, w) };
        if trip::<P>(s, mn, mx, w as u32) {
            return Some((h - 1 - row) as u32);
        }
    }
    None
}

unsafe fn detect_left<P: Px>(data: *const P, w: usize, h: usize, stride: usize) -> Option<u32> {
    let n_full = w / 64;
    let mut sums = [0u32; 64];
    let mut mins = [P::MN_INIT; 64];
    let mut maxs = [P::MX_INIT; 64];
    for sidx in 0..n_full {
        let off = sidx * 64;
        unsafe {
            col_stats::<P>(data.add(off), stride, h, &mut sums, &mut mins, &mut maxs);
        }
        for c in 0..64 {
            if trip::<P>(sums[c], mins[c], maxs[c], h as u32) {
                return Some((off + c) as u32);
            }
        }
    }
    let tail_cols = w - n_full * 64;
    if tail_cols > 0 {
        let off = n_full * 64;
        unsafe {
            col_narrow::<P>(
                data.add(off),
                stride,
                h,
                tail_cols,
                &mut sums,
                &mut mins,
                &mut maxs,
            );
        }
        for c in 0..tail_cols {
            if trip::<P>(sums[c], mins[c], maxs[c], h as u32) {
                return Some((off + c) as u32);
            }
        }
    }
    None
}

unsafe fn detect_right<P: Px>(data: *const P, w: usize, h: usize, stride: usize) -> Option<u32> {
    let n_full = w / 64;
    let tail_cols = w - n_full * 64;
    let mut sums = [0u32; 64];
    let mut mins = [P::MN_INIT; 64];
    let mut maxs = [P::MX_INIT; 64];
    if tail_cols > 0 {
        let off = n_full * 64;
        unsafe {
            col_narrow::<P>(
                data.add(off),
                stride,
                h,
                tail_cols,
                &mut sums,
                &mut mins,
                &mut maxs,
            );
        }
        for c in (0..tail_cols).rev() {
            if trip::<P>(sums[c], mins[c], maxs[c], h as u32) {
                return Some((w - 1 - (off + c)) as u32);
            }
        }
    }
    for sidx in (0..n_full).rev() {
        let off = sidx * 64;
        unsafe {
            col_stats::<P>(data.add(off), stride, h, &mut sums, &mut mins, &mut maxs);
        }
        for c in (0..64).rev() {
            if trip::<P>(sums[c], mins[c], maxs[c], h as u32) {
                return Some((w - 1 - (off + c)) as u32);
            }
        }
    }
    None
}

fn detect_frame_crop(
    frame: *const ffms::VidFrame,
    inf: &VidInf,
    _min_pix: usize,
) -> Option<CropResult> {
    unsafe {
        let f = &*frame;
        let y_data = f.data[0];
        let stride = f.linesize[0] as usize;
        let w = inf.width as usize;
        let h = inf.height as usize;
        if inf.is_10b {
            let d = y_data.cast::<u16>();
            Some(CropResult {
                top: detect_top(d, w, h, stride)?,
                bottom: detect_bot(d, w, h, stride)?,
                left: detect_left(d, w, h, stride)?,
                right: detect_right(d, w, h, stride)?,
            })
        } else {
            Some(CropResult {
                top: detect_top(y_data, w, h, stride)?,
                bottom: detect_bot(y_data, w, h, stride)?,
                left: detect_left(y_data, w, h, stride)?,
                right: detect_right(y_data, w, h, stride)?,
            })
        }
    }
}
