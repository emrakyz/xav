// src/tq_prior.rs
//! Prior for the first two target-quality probes of a chunk, learned from the
//! chunks already finished in this run. Rounds 3+ are unchanged.
//!
//! Round 1: frame-weighted median of recent final CRFs, snapped to the range
//! edge when close to it -- a probe exactly at the ceiling completes every
//! chunk whose score there is at or above the band, a probe just below it
//! completes only the band hits.
//! Round 2: the k recent chunks whose score at crf1 is nearest to what was just
//! measured, each curve shifted vertically through (crf1, s1), read where it
//! crosses the target, median.
//!
//! Standalone: `rustc --edition 2024 --test src/tq_prior.rs -o /tmp/tq_prior && /tmp/tq_prior`

#[cfg(test)]
extern crate alloc;
use alloc::vec::Vec;

const PRIOR_MIN: usize = 4;
const P1_WINDOW: usize = 16;
const P1_SNAP: f32 = 4.0;
const P2_WINDOW: usize = 64;
const P2_K: usize = 5;

/// One completed chunk as the prior sees it. `probes` are (crf, score, bytes) in search order.
#[derive(Clone, Copy)]
pub struct Done<'a> {
    pub crf: f32,
    pub frames: usize,
    pub probes: &'a [(f32, f32, u64)],
}

/// A round-2 candidate: distance from s1, its estimated score at crf1, its probes.
type Cand<'a> = (f32, f32, &'a [(f32, f32, u64)]);

/// Weighted median: the value at which the cumulative weight first reaches half.
fn weighted_median(items: &mut [(f32, f32)]) -> Option<f32> {
    if items.is_empty() {
        return None;
    }
    items.sort_unstable_by(|a, b| a.0.total_cmp(&b.0));
    let half = items.iter().map(|x| x.1).sum::<f32>() / 2.0;
    let mut acc = 0.0;
    for &(v, w) in items.iter() {
        acc += w;
        if acc >= half {
            return Some(v);
        }
    }
    // Unreachable with positive weights -- the loop's own accumulation reaches the half sum.
    // Kept as a value rather than a panic because `clippy::unreachable` is denied.
    items.last().map(|x| x.0)
}

fn median(v: &mut [f32]) -> Option<f32> {
    if v.is_empty() {
        return None;
    }
    v.sort_unstable_by(f32::total_cmp);
    let n = v.len();
    Some(if n % 2 == 1 {
        v[n / 2]
    } else {
        f32::midpoint(v[n / 2 - 1], v[n / 2])
    })
}

/// Linear interpolation of y at x over points sorted by x; extrapolates from the
/// nearest pair outside the span. `pts` must have >= 2 entries.
fn lerp_at(pts: &[(f32, f32)], x: f32) -> f32 {
    assert!(pts.len() >= 2, "lerp_at needs two points");
    let n = pts.len();
    let i = pts.partition_point(|p| p.0 < x);
    let (a, b) = if i == 0 {
        (pts[0], pts[1])
    } else if i >= n {
        (pts[n - 2], pts[n - 1])
    } else {
        (pts[i - 1], pts[i])
    };
    // On the score axis the divisor has no quantisation floor (CRFs are 0.25-quantised,
    // scores are not), so two near-identical scores can make an exact-equality guard miss
    // and blow the slope up; an epsilon guard is required, not just tidier.
    if (b.0 - a.0).abs() < 1e-3 {
        return a.1;
    }
    a.1 + (x - a.0) * (b.1 - a.1) / (b.0 - a.0)
}

/// Score this chunk would have at `crf`, from its own probes.
fn score_at(probes: &[(f32, f32, u64)], crf: f32) -> f32 {
    let mut pts: Vec<(f32, f32)> = probes.iter().map(|p| (p.0, p.1)).collect();
    pts.sort_unstable_by(|a, b| a.0.total_cmp(&b.0));
    lerp_at(&pts, crf)
}

/// CRF at which this chunk's curve reaches `score`. On a non-monotone probe set the
/// inverse is a consistent-but-unsound approximation, damped by the k-median in
/// `second_probe` -- the same limitation as the crate's `interpolate_crf`.
fn crf_at(probes: &[(f32, f32, u64)], score: f32) -> f32 {
    let mut pts: Vec<(f32, f32)> = probes.iter().map(|p| (p.1, p.0)).collect();
    pts.sort_unstable_by(|a, b| a.0.total_cmp(&b.0));
    lerp_at(&pts, score)
}

/// Round-1 CRF. `logs` yields completed chunks MOST RECENT FIRST. None below `PRIOR_MIN`.
pub fn first_probe<'a, I: Iterator<Item = Done<'a>>>(
    logs: I,
    qp_min: f32,
    qp_max: f32,
) -> Option<f32> {
    let mut items: Vec<(f32, f32)> = logs
        .take(P1_WINDOW)
        .map(|d| (d.crf, d.frames.max(1) as f32))
        .collect();
    if items.len() < PRIOR_MIN {
        return None;
    }
    let crf = weighted_median(&mut items)?;
    // Snapping only means something while the two edge bands are disjoint. On a range of 8 or
    // narrower they overlap, every prior is inside one of them, and snapping would pin the whole
    // file to an edge on the strength of the check that happens to run first -- so don't snap.
    if qp_max - qp_min <= 2.0 * P1_SNAP {
        return Some(crf);
    }
    Some(if crf >= qp_max - P1_SNAP {
        qp_max
    } else if crf <= qp_min + P1_SNAP {
        qp_min
    } else {
        crf
    })
}

/// Round-2 CRF after round 1 measured (crf1, s1) and missed. None below `PRIOR_MIN` candidates.
/// The caller clamps into the live bracket and rounds.
pub fn second_probe<'a, I: Iterator<Item = Done<'a>>>(
    logs: I,
    crf1: f32,
    s1: f32,
    target: f32,
) -> Option<f32> {
    let mut cands: Vec<Cand<'a>> = logs
        .take(P2_WINDOW)
        .filter(|d| d.probes.len() >= 2)
        .map(|d| {
            let est = score_at(d.probes, crf1);
            ((est - s1).abs(), est, d.probes)
        })
        .collect();
    if cands.len() < PRIOR_MIN {
        return None;
    }
    // Stable sort: on a distance tie, keep candidates in `logs` order (most recent first)
    // so the more recent chunk wins the tie rather than an arbitrary reshuffle.
    cands.sort_by(|a, b| a.0.total_cmp(&b.0));
    let mut crossings: Vec<f32> = cands
        .iter()
        .take(P2_K)
        .map(|&(_, est, probes)| crf_at(probes, target - s1 + est))
        .collect();
    median(&mut crossings)
}

#[cfg(test)]
#[allow(clippy::unwrap_used, clippy::missing_assert_message)]
mod tests {
    use super::*;

    fn done(crf: f32, frames: usize, probes: &[(f32, f32, u64)]) -> Done<'_> {
        Done {
            crf,
            frames,
            probes,
        }
    }

    #[test]
    fn first_probe_needs_prior_min() {
        let p = [(20.0, 75.0, 0)];
        let logs = [done(20.0, 100, &p); 3];
        assert!(first_probe(logs.iter().copied(), 5.0, 25.0).is_none());
    }

    #[test]
    fn first_probe_weighted_median_and_window() {
        let p = [(10.0, 75.0, 0)];
        let mut logs: Vec<Done> = Vec::new();
        for _ in 0..4 {
            logs.push(done(20.0, 10, &p)); // most recent first
        }
        for _ in 0..20 {
            logs.push(done(10.0, 1000, &p));
        }
        // window 16: 4 chunks at 20 (w 10 each) vs 12 at 10 (w 1000 each) -> 10; no snap (5+4 < 10)
        assert_eq!(first_probe(logs.iter().copied(), 5.0, 40.0), Some(10.0));
        // only the 4 recent ones visible -> 20
        assert_eq!(
            first_probe(logs.iter().take(4).copied(), 5.0, 40.0),
            Some(20.0)
        );
    }

    #[test]
    fn first_probe_snaps_to_edges() {
        let p = [(20.0, 75.0, 0)];
        let top = [done(22.0, 1, &p); 4];
        assert_eq!(first_probe(top.iter().copied(), 5.0, 25.0), Some(25.0));
        let bottom = [done(8.0, 1, &p); 4];
        assert_eq!(first_probe(bottom.iter().copied(), 5.0, 25.0), Some(5.0));
        let mid = [done(15.0, 1, &p); 4];
        assert_eq!(first_probe(mid.iter().copied(), 5.0, 25.0), Some(15.0));
    }

    #[test]
    fn first_probe_no_snap_on_narrow_range() {
        let p = [(22.0, 75.0, 0)];
        let logs = [done(22.0, 1, &p); 4];
        // range 5 wide: both edge bands cover 22, so the weighted median stands unsnapped
        assert_eq!(first_probe(logs.iter().copied(), 20.0, 25.0), Some(22.0));
        // range 20 wide: the bands are disjoint again and 22 is inside the ceiling's
        assert_eq!(first_probe(logs.iter().copied(), 5.0, 25.0), Some(25.0));
    }

    #[test]
    fn second_probe_curve_shift_crossing() {
        // neighbours: score = 95 - crf; current chunk measured (20, 78) = shifted +3 -> crosses 75 at 23
        let p = [(15.0, 80.0, 0), (25.0, 70.0, 0)];
        let logs = [done(20.0, 1, &p); 5];
        let c = second_probe(logs.iter().copied(), 20.0, 78.0, 75.0).unwrap();
        assert!((c - 23.0).abs() < 1e-4, "{c}");
    }

    #[test]
    fn second_probe_picks_nearest_by_score_at_crf1() {
        let near = [(15.0, 80.0, 0), (25.0, 70.0, 0)]; // est at 20 = 75
        let far = [(15.0, 60.0, 0), (25.0, 40.0, 0)]; // est at 20 = 50, slope -2
        let mut logs: Vec<Done> = Vec::new();
        for _ in 0..5 {
            logs.push(done(20.0, 1, &far));
        }
        for _ in 0..5 {
            logs.push(done(20.0, 1, &near));
        }
        let c = second_probe(logs.iter().copied(), 20.0, 78.0, 75.0).unwrap();
        assert!((c - 23.0).abs() < 1e-4, "{c}");
    }

    #[test]
    fn second_probe_needs_min_candidates_with_two_probes() {
        let one = [(20.0, 76.0, 0)];
        let logs = [done(20.0, 1, &one); 10];
        assert!(second_probe(logs.iter().copied(), 20.0, 78.0, 75.0).is_none());
        let two = [(15.0, 80.0, 0), (25.0, 70.0, 0)];
        let logs = [done(20.0, 1, &two); 3];
        assert!(second_probe(logs.iter().copied(), 20.0, 78.0, 75.0).is_none());
    }

    #[test]
    fn lerp_extrapolates_outside_span() {
        let pts = [(15.0, 80.0), (25.0, 70.0)];
        assert!((lerp_at(&pts, 30.0) - 65.0).abs() < 1e-5);
        assert!((lerp_at(&pts, 10.0) - 85.0).abs() < 1e-5);
    }

    #[test]
    fn lerp_interior_with_three_points() {
        let p = [(15.0, 80.0, 0), (20.0, 78.0, 0), (25.0, 75.0, 0)];
        assert!((score_at(&p, 22.5) - 76.5).abs() < 1e-4);
        assert!((crf_at(&p, 76.5) - 22.5).abs() < 1e-4);
        assert!((score_at(&p, 20.0) - 78.0).abs() < 1e-4);
    }
}
