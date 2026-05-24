const MAX_TAU2: f32 = 9.0;

#[inline]
pub fn lerp(x: &[f32], y: &[f32], xi: f32) -> f32 {
    let t = (xi - x[0]) / (x[1] - x[0]);
    t.mul_add(y[1] - y[0], y[0])
}

pub fn pchip(x: &[f32], y: &[f32], xi: f32) -> f32 {
    let n = x.len();
    let k = (0..n - 1)
        .find(|&i| xi >= x[i] && xi <= x[i + 1])
        .unwrap_or(0);

    let s: Vec<f32> = (0..n - 1)
        .map(|i| (y[i + 1] - y[i]) / (x[i + 1] - x[i]))
        .collect();

    let mut d = vec![0.0; n];
    d[0] = s[0];
    d[n - 1] = s[n - 2];

    for i in 1..n - 1 {
        let s_prev = s[i - 1];
        let s_next = s[i];
        if s_prev * s_next <= 0.0 {
            d[i] = 0.0;
        } else {
            let h_prev = x[i] - x[i - 1];
            let h_next = x[i + 1] - x[i];
            let w1 = 2.0f32.mul_add(h_next, h_prev);
            let w2 = 2.0f32.mul_add(h_prev, h_next);
            d[i] = (w1 + w2) / (w1 / s_prev + w2 / s_next);
        }
    }

    for i in 0..n - 1 {
        if s[i] == 0.0 {
            d[i] = 0.0;
            d[i + 1] = 0.0;
        } else {
            let alpha = d[i] / s[i];
            let beta = d[i + 1] / s[i];
            let tau = alpha.mul_add(alpha, beta * beta);

            if tau > MAX_TAU2 {
                let scale = 3.0 / tau.sqrt();
                d[i] = scale * alpha * s[i];
                d[i + 1] = scale * beta * s[i];
            }
        }
    }

    let h = x[k + 1] - x[k];
    let t = (xi - x[k]) / h;
    let t2 = t * t;
    let t3 = t2 * t;

    let h00 = 2.0f32.mul_add(t3, -3.0 * t2) + 1.0;
    let h10 = 2.0f32.mul_add(-t2, t3) + t;
    let h01 = (-2.0f32).mul_add(t3, 3.0 * t2);
    let h11 = t3 - t2;

    h00.mul_add(
        y[k],
        (h10 * h).mul_add(d[k], (h11 * h).mul_add(d[k + 1], h01 * y[k + 1])),
    )
}

pub fn fc_spline(x: &[f32], y: &[f32], xi: f32) -> f32 {
    let k = usize::from(xi >= x[1] && xi <= x[2]);

    let d0 = (y[1] - y[0]) / (x[1] - x[0]);
    let d1 = (y[2] - y[1]) / (x[2] - x[1]);

    let mut m = [0.0; 3];

    m[0] = d0;
    m[2] = d1;

    if d0 * d1 <= 0.0 {
        m[1] = 0.0;
    } else {
        let h0 = x[1] - x[0];
        let h1 = x[2] - x[1];
        let w1 = 2.0f32.mul_add(h1, h0);
        let w2 = 2.0f32.mul_add(h0, h1);
        m[1] = (w1 + w2) / (w1 / d0 + w2 / d1);
    }

    let h = x[k + 1] - x[k];
    let t = (xi - x[k]) / h;
    let t2 = t * t;
    let t3 = t2 * t;

    let h00 = 2.0f32.mul_add(t3, 3.0f32.mul_add(-t2, 1.0));
    let h10 = 2.0f32.mul_add(-t2, t3.mul_add(1.0, t));
    let h01 = (-2.0f32).mul_add(t3, 3.0 * t2);
    let h11 = t3 - t2;

    (h11 * h).mul_add(
        m[k + 1],
        h00.mul_add(y[k], h10.mul_add(h * m[k], h01 * y[k + 1])),
    )
}

fn round_crf(crf: f32) -> f32 {
    (crf * 4.0).round() / 4.0
}

pub fn bisect(min: f32, max: f32) -> f32 {
    round_crf(f32::midpoint(min, max))
}
