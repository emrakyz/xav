use super::{
    block_group::block_group_size,
    cluster::cluster_size,
    cues::cues_size,
    ebml_header::EBML_HEADER,
    element::uint_size,
    seek_head::{SeekTable, seek_head_size},
    segment::segment_size,
    simple_block::simple_block_size,
};
use crate::byte_range::ByteRange;

pub struct ClusterPlan {
    pub base_frame: u64,
    pub ts: u64,
    pub bg_total: usize,
    pub sb_total: usize,  // audio SimpleBlock octets; 0 until assign_audio
    pub sub_total: usize, // subtitle BlockGroup octets; 0 until assign_subs
    pub size: usize,      // full octets; filled by layout
    pub position: u64,    // Segment Position; filled by layout
    pub prev_size: u64,   // predecessor octets, 0=first; filled by layout
}

#[inline]
pub fn pts_ms(frame: u64, fps_num: u32, fps_den: u32) -> u64 {
    let num = u64::from(fps_num);
    (frame * u64::from(fps_den) * 1000 + num / 2) / num
}

#[inline]
pub fn nal_timing(base: u64, disp: u32, ts: u64, fps_num: u32, fps_den: u32) -> (i16, u64) {
    let f = base + u64::from(disp);
    let abs = pts_ms(f, fps_num, fps_den);
    ((abs - ts) as i16, pts_ms(f + 1, fps_num, fps_den) - abs)
}

#[must_use]
pub fn plan_cluster<const IS_NAL: bool>(
    blocks: &[ByteRange],
    disp: &[u32],
    base_frame: u64,
    fps_num: u32,
    fps_den: u32,
) -> ClusterPlan {
    let num = u64::from(fps_num);
    let step = u64::from(fps_den) * 1000;
    let (ms_step, rem_step) = (step / num, step % num);
    let r0 = base_frame * step + num / 2;
    let (mut ms, mut rem) = (r0 / num, r0 % num);
    let ts = ms;
    let mut bg_total = 0;
    for (i, b) in blocks.iter().enumerate() {
        let (rel, dur) = if IS_NAL {
            nal_timing(
                base_frame,
                unsafe { *disp.get_unchecked(i) },
                ts,
                fps_num,
                fps_den,
            )
        } else {
            ((ms - ts) as i16, ms_step + u64::from(rem + rem_step >= num))
        };
        bg_total += block_group_size(1, b.len, i == 0, rel, dur);
        ms += ms_step;
        rem += rem_step;
        if rem >= num {
            ms += 1;
            rem -= num;
        }
    }
    ClusterPlan {
        base_frame,
        ts,
        bg_total,
        sb_total: 0,
        sub_total: 0,
        size: 0,
        position: 0,
        prev_size: 0,
    }
}

#[must_use]
pub fn assign_audio(
    plans: &mut [ClusterPlan],
    ts_ms: &[u64],
    lens: &[usize],
    track: u64,
) -> Vec<usize> {
    let n = plans.len();
    let mut bounds = vec![0usize; n + 1];
    let mut ci = 0;
    // ci+1 < n guards plans/bounds[ci+1]; ci stays < n; bounds.len() == n+1
    for (pi, (&ts, &len)) in ts_ms.iter().zip(lens).enumerate() {
        while ci + 1 < n && ts >= unsafe { plans.get_unchecked(ci + 1) }.ts {
            unsafe { *bounds.get_unchecked_mut(ci + 1) = pi };
            ci += 1;
        }
        unsafe { plans.get_unchecked_mut(ci) }.sb_total += simple_block_size(track, len);
    }
    for b in unsafe { bounds.get_unchecked_mut(ci + 1..=n) } {
        *b = ts_ms.len();
    }
    bounds
}

#[must_use]
pub fn assign_subs(
    plans: &mut [ClusterPlan],
    ts_ms: &[u64],
    lens: &[usize],
    durs: &[u64],
    track: u64,
) -> Vec<usize> {
    let n = plans.len();
    let mut bounds = vec![0usize; n + 1];
    let mut ci = 0;
    // ci+1 < n guards plans/bounds[ci+1]; ci stays < n; bounds.len() == n+1
    for (pi, ((&ts, &len), &dur)) in ts_ms.iter().zip(lens).zip(durs).enumerate() {
        while ci + 1 < n && ts >= unsafe { plans.get_unchecked(ci + 1) }.ts {
            unsafe { *bounds.get_unchecked_mut(ci + 1) = pi };
            ci += 1;
        }
        unsafe { plans.get_unchecked_mut(ci) }.sub_total +=
            block_group_size(track, len, true, 0, dur);
    }
    for b in unsafe { bounds.get_unchecked_mut(ci + 1..=n) } {
        *b = ts_ms.len();
    }
    bounds
}

#[must_use]
pub fn plan_clusters(
    chunks: &[&[ByteRange]],
    disp: &[&[u32]],
    fps_num: u32,
    fps_den: u32,
) -> Vec<ClusterPlan> {
    let mut plans = Vec::with_capacity(chunks.len());
    let mut base = 0;
    if disp.is_empty() {
        for blocks in chunks {
            plans.push(plan_cluster::<false>(blocks, &[], base, fps_num, fps_den));
            base += blocks.len() as u64;
        }
    } else {
        for (blocks, d) in chunks.iter().zip(disp) {
            plans.push(plan_cluster::<true>(blocks, d, base, fps_num, fps_den));
            base += blocks.len() as u64;
        }
    }
    plans
}

pub struct Layout {
    pub seek: SeekTable, // SeekHead offsets
    pub segment_content: usize,
    pub file_size: u64,
    pub pos_width: usize,
    pub frame_dur: u64, // per-frame duration ticks, for the Cues element
}

// fixpoint: SeekHead/Cues/Position widths depend on file_size, which depends on them
#[must_use]
pub fn layout(
    info_size: usize,
    tracks_size: usize,
    chapters_size: usize,
    tags_size: usize,
    clusters: &mut [ClusterPlan],
    fps_num: u32,
    fps_den: u32,
) -> Layout {
    let frame_dur = pts_ms(1, fps_num, fps_den);

    let mut sh_size = 0;
    let mut cues_len = 0;
    let mut pos_width = 1;
    loop {
        let mut total = 0u64;
        let mut prev = 0u64;
        for c in clusters.iter_mut() {
            c.prev_size = prev;
            c.size = cluster_size(c.ts, c.bg_total + c.sb_total + c.sub_total, pos_width, prev);
            prev = c.size as u64;
            total += c.size as u64;
        }

        let info_off = sh_size as u64;
        let tracks_off = info_off + info_size as u64;
        let chapters_off = tracks_off + tracks_size as u64;
        let tags_off = chapters_off + chapters_size as u64;
        let cues_off = tags_off + tags_size as u64;
        let clusters_off = cues_off + cues_len as u64;

        let mut off = 0u64;
        for c in clusters.iter_mut() {
            c.position = clusters_off + off;
            off += c.size as u64;
        }

        let seek = SeekTable {
            info: info_off,
            tracks: tracks_off,
            chapters: (chapters_size > 0).then_some(chapters_off),
            cues: cues_off,
            tags: tags_off,
        };
        let new_sh = seek_head_size(&seek);
        let new_cues = cues_size(clusters, pos_width, frame_dur);

        let segment_content = new_sh
            + info_size
            + tracks_size
            + chapters_size
            + tags_size
            + new_cues
            + total as usize;
        let file_size = (EBML_HEADER.len() + segment_size(segment_content)) as u64;
        let new_pos_width = uint_size(file_size);

        if new_sh == sh_size && new_cues == cues_len && new_pos_width == pos_width {
            return Layout {
                seek,
                segment_content,
                file_size,
                pos_width,
                frame_dur,
            };
        }
        sh_size = new_sh;
        cues_len = new_cues;
        pos_width = new_pos_width;
    }
}
