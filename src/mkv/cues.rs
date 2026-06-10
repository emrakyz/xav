use super::{
    crc32::{CRC_ELEMENT_LEN, Crc32, patch_crc, write_crc_placeholder},
    ebml::vint_encode,
    element::{master_size, uint_size, write_id, write_uint},
    mux::ClusterPlan,
};

const CUES_ID: u32 = 0x1C53_BB6B;

struct Cue {
    time_ticks: u64,
    cluster_position: u64,
    relative_position: u64,
    duration_ticks: u64,
}

// relative_position = first-BlockGroup offset in the cluster: CRC 6 + Timestamp(2+uint)
// + Position(2+pos_width) + PrevSize
#[inline]
const fn cue_of(p: &ClusterPlan, pos_width: usize, frame_dur: u64) -> Cue {
    let prevsz = if p.prev_size > 0 {
        2 + uint_size(p.prev_size)
    } else {
        0
    };
    Cue {
        time_ticks: p.ts,
        cluster_position: p.position,
        relative_position: (8 + uint_size(p.ts) + 2 + pos_width + prevsz) as u64,
        duration_ticks: frame_dur,
    }
}

#[must_use]
pub fn cues_size(plans: &[ClusterPlan], pos_width: usize, frame_dur: u64) -> usize {
    let mut content = CRC_ELEMENT_LEN;
    for p in plans {
        content += cue_point_size(&cue_of(p, pos_width, frame_dur));
    }
    master_size(CUES_ID, content)
}

#[must_use]
pub fn write_cues(
    out: &mut [u8],
    plans: &[ClusterPlan],
    pos_width: usize,
    frame_dur: u64,
) -> usize {
    let mut content = CRC_ELEMENT_LEN;
    for p in plans {
        content += cue_point_size(&cue_of(p, pos_width, frame_dur));
    }

    let mut n = write_id(CUES_ID, out);
    let crc_offset;
    let children_start;
    unsafe {
        n += vint_encode(content as u64, out.get_unchecked_mut(n..));
        crc_offset = n + 2;
        n += write_crc_placeholder(out.get_unchecked_mut(n..));
        children_start = n;
        for p in plans {
            n += write_cue_point(out.get_unchecked_mut(n..), &cue_of(p, pos_width, frame_dur));
        }
        let mut crc = Crc32::new();
        crc.update(out.get_unchecked(children_start..n));
        patch_crc(out, crc_offset, crc.finalize());
    }
    n
}

#[inline]
const fn cue_point_size(cue: &Cue) -> usize {
    22 + uint_size(cue.time_ticks)
        + uint_size(cue.cluster_position)
        + uint_size(cue.relative_position)
        + uint_size(cue.duration_ticks)
}

fn write_cue_point(out: &mut [u8], cue: &Cue) -> usize {
    let tp_content = 16
        + uint_size(cue.cluster_position)
        + uint_size(cue.relative_position)
        + uint_size(cue.duration_ticks);
    let cue_content = 2 + uint_size(cue.time_ticks) + 2 + tp_content;

    // caller sizes `out` from cue_point_size(cue) -> every store is in bounds
    let mut n = 2;
    unsafe {
        *out.get_unchecked_mut(0) = 0xBB; // CuePoint
        *out.get_unchecked_mut(1) = 0x80 | cue_content as u8;
        n += write_uint(0xB3, cue.time_ticks, out.get_unchecked_mut(n..));
        *out.get_unchecked_mut(n) = 0xB7; // CueTrackPositions
        *out.get_unchecked_mut(n + 1) = 0x80 | tp_content as u8;
        n += 2;
        n += write_uint(0xF7, 1, out.get_unchecked_mut(n..)); // CueTrack = 1
        n += write_uint(0xF1, cue.cluster_position, out.get_unchecked_mut(n..));
        n += write_uint(0xF0, cue.relative_position, out.get_unchecked_mut(n..));
        n += write_uint(0xB2, cue.duration_ticks, out.get_unchecked_mut(n..));
        n += write_uint(0x5378, 1, out.get_unchecked_mut(n..)); // CueBlockNumber = 1
        n += write_uint(0xEA, 0, out.get_unchecked_mut(n..)); // CueCodecState = 0
    }
    n
}
