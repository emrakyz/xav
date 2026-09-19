#[cfg(target_os = "linux")]
use alloc::vec::Vec;

use super::{
    block_group::{block_group_size, pad_group_size},
    cluster::cluster_size,
    cues::{cues_content, cues_size},
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
    pub sb_total: usize,  // audio block octets; 0 until assign_audio
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

#[must_use]
pub fn pts_table(frames: usize, fps_num: u32, fps_den: u32) -> Vec<u64> {
    let num = u64::from(fps_num);
    let step = u64::from(fps_den) * 1000;
    let (ms_step, rem_step) = (step / num, step % num);
    let (mut ms, mut rem) = (0, num / 2);
    let mut tab = Vec::with_capacity(frames + 1);
    for _ in 0..=frames {
        tab.push(ms);
        ms += ms_step;
        rem += rem_step;
        if rem >= num {
            ms += 1;
            rem -= num;
        }
    }
    tab
}

#[inline]
#[must_use]
pub fn timing(tab: &[u64], f: u64, ts: u64) -> (i16, u64) {
    let i = f as usize;
    let abs = unsafe { *tab.get_unchecked(i) };
    (
        (abs - ts) as i16,
        unsafe { *tab.get_unchecked(i + 1) } - abs,
    )
}

#[must_use]
pub fn plan_cluster<const IS_NAL: bool>(
    blocks: &[ByteRange],
    disp: &[u32],
    base_frame: u64,
    tab: &[u64],
) -> ClusterPlan {
    let ts = unsafe { *tab.get_unchecked(base_frame as usize) };
    let mut bg_total = 0;
    for (i, b) in blocks.iter().enumerate() {
        let f = if IS_NAL {
            base_frame + u64::from(unsafe { *disp.get_unchecked(i) })
        } else {
            base_frame + i as u64
        };
        let (rel, dur) = timing(tab, f, ts);
        bg_total += block_group_size(1, b.len, i == 0, rel, dur);
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
pub fn assign_audio<F: Fn(usize) -> usize>(
    plans: &mut [ClusterPlan],
    ts_ms: &[u64],
    len_of: F,
    pads: &[(u32, i64)],
    track: u64,
) -> Vec<usize> {
    let n = plans.len();
    let mut bounds = vec![0usize; n + 1];
    let mut ci = 0;
    let mut pk = 0;
    // ci+1 < n guards plans/bounds[ci+1]; ci stays < n; bounds.len() == n+1
    for (pi, &ts) in ts_ms.iter().enumerate() {
        while ci + 1 < n && ts >= unsafe { plans.get_unchecked(ci + 1) }.ts {
            unsafe { *bounds.get_unchecked_mut(ci + 1) = pi };
            ci += 1;
        }
        let len = len_of(pi);
        let octets = match pads.get(pk) {
            Some(&(at, pad)) if at as usize == pi => {
                pk += 1;
                pad_group_size(track, len, pad)
            }
            _ => simple_block_size(track, len),
        };
        unsafe { plans.get_unchecked_mut(ci) }.sb_total += octets;
    }
    for b in unsafe { bounds.get_unchecked_mut(ci + 1..=n) } {
        *b = ts_ms.len();
    }
    bounds
}

#[must_use]
pub fn assign_subs<F: Fn(usize) -> usize>(
    plans: &mut [ClusterPlan],
    ts_ms: &[u64],
    len_of: F,
    durs: &[u64],
    track: u64,
) -> Vec<usize> {
    let n = plans.len();
    let mut bounds = vec![0usize; n + 1];
    let mut ci = 0;
    // ci+1 < n guards plans/bounds[ci+1]; ci stays < n; bounds.len() == n+1
    for (pi, (&ts, &dur)) in ts_ms.iter().zip(durs).enumerate() {
        while ci + 1 < n && ts >= unsafe { plans.get_unchecked(ci + 1) }.ts {
            unsafe { *bounds.get_unchecked_mut(ci + 1) = pi };
            ci += 1;
        }
        unsafe { plans.get_unchecked_mut(ci) }.sub_total +=
            block_group_size(track, len_of(pi), true, 0, dur);
    }
    for b in unsafe { bounds.get_unchecked_mut(ci + 1..=n) } {
        *b = ts_ms.len();
    }
    bounds
}

#[must_use]
pub fn plan_clusters(chunks: &[&[ByteRange]], disp: &[&[u32]], tab: &[u64]) -> Vec<ClusterPlan> {
    let mut plans = Vec::with_capacity(chunks.len());
    let mut base = 0;
    if disp.is_empty() {
        for blocks in chunks {
            plans.push(plan_cluster::<false>(blocks, &[], base, tab));
            base += blocks.len() as u64;
        }
    } else {
        for (blocks, d) in chunks.iter().zip(disp) {
            plans.push(plan_cluster::<true>(blocks, d, base, tab));
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
    pub frame_dur: u64,
    pub cues_content: usize,
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
        let cues_inner = cues_content(clusters, pos_width, frame_dur);
        let new_cues = cues_size(cues_inner);

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
                cues_content: cues_inner,
            };
        }
        sh_size = new_sh;
        cues_len = new_cues;
        pos_width = new_pos_width;
    }
}
