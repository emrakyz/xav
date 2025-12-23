const MAX_TAU2: f64 = 9.0;

pub fn lerp(x: &[f64; 2], y: &[f64; 2], xi: f64) -> Option<f64> {
    if x[1] <= x[0] {
        return None;
    }
    let t = (xi - x[0]) / (x[1] - x[0]);
    Some(t.mul_add(y[1] - y[0], y[0]))
}

pub fn pchip(x: &[f64; 4], y: &[f64; 4], xi: f64) -> Option<f64> {
    for i in 0..3 {
        if x[i + 1] <= x[i] {
            return None;
        }
    }

    let k = (0..3).find(|&i| xi >= x[i] && xi <= x[i + 1]).unwrap_or(0);

    let s0 = (y[1] - y[0]) / (x[1] - x[0]);
    let s1 = (y[2] - y[1]) / (x[2] - x[1]);
    let s2 = (y[3] - y[2]) / (x[3] - x[2]);

    let mut d = [0.0; 4];
    d[0] = s0;
    d[3] = s2;

    let params = [(s0, s1, x[1] - x[0], x[2] - x[1]), (s1, s2, x[2] - x[1], x[3] - x[2])];
    for (i, &(s_prev, s_next, h_prev, h_next)) in params.iter().enumerate() {
        let idx = i + 1;
        if s_prev * s_next <= 0.0 {
            d[idx] = 0.0;
        } else {
            let w1 = 2.0f64.mul_add(h_next, h_prev);
            let w2 = 2.0f64.mul_add(h_prev, h_next);
            d[idx] = (w1 + w2) / (w1 / s_prev + w2 / s_next);
        }
    }

    let slopes = [s0, s1, s2];
    for i in 0..3 {
        if slopes[i] == 0.0 {
            d[i] = 0.0;
            d[i + 1] = 0.0;
        } else {
            let alpha = d[i] / slopes[i];
            let beta = d[i + 1] / slopes[i];
            let tau = alpha.mul_add(alpha, beta * beta);

            if tau > MAX_TAU2 {
                let scale = 3.0 / tau.sqrt();
                d[i] = scale * alpha * slopes[i];
                d[i + 1] = scale * beta * slopes[i];
            }
        }
    }

    let h = x[k + 1] - x[k];
    let t = (xi - x[k]) / h;
    let t2 = t * t;
    let t3 = t2 * t;

    let h00 = 2.0f64.mul_add(t3, -3.0 * t2) + 1.0;
    let h10 = 2.0f64.mul_add(-t2, t3) + t;
    let h01 = (-2.0f64).mul_add(t3, 3.0 * t2);
    let h11 = t3 - t2;

    Some(h00.mul_add(y[k], (h10 * h).mul_add(d[k], (h11 * h).mul_add(d[k + 1], h01 * y[k + 1]))))
}

pub fn akima(x: &[f64], y: &[f64], xi: f64) -> Option<f64> {
    let n = x.len();
    if n < 5 || y.len() != n {
        return None;
    }

    for i in 0..n - 1 {
        if x[i + 1] <= x[i] {
            return None;
        }
    }

    if xi < x[0] || xi > x[n - 1] {
        return None;
    }

    let k = (0..n - 1).rev().find(|&i| xi >= x[i]).unwrap_or(0);

    let mut m = vec![0.0; n + 1];
    for i in 0..n - 1 {
        m[i + 1] = (y[i + 1] - y[i]) / (x[i + 1] - x[i]);
    }

    m[0] = 2.0f64.mul_add(m[1], -m[2]);
    m[n] = 2.0f64.mul_add(m[n - 1], -m[n - 2]);

    let mut t = vec![0.0; n];
    for i in 0..n - 1 {
        let w1 = (m[i + 2] - m[i + 1]).abs();
        let w2 = (m[i] - m[i + 1]).abs();

        if w1 + w2 < 1e-10 {
            t[i] = 0.5 * (m[i] + m[i + 1]);
        } else {
            t[i] = w1.mul_add(m[i], w2 * m[i + 1]) / (w1 + w2);
        }
    }

    t[n - 1] = m[n - 1];

    let h = x[k + 1] - x[k];
    let s = (xi - x[k]) / h;
    let s2 = s * s;
    let s3 = s2 * s;

    let h00 = 2.0f64.mul_add(s3, -3.0 * s2) + 1.0;
    let h10 = 2.0f64.mul_add(-s2, s3) + s;
    let h01 = (-2.0f64).mul_add(s3, 3.0 * s2);
    let h11 = s3 - s2;

    Some(h00.mul_add(y[k], (h10 * h).mul_add(t[k], (h11 * h).mul_add(t[k + 1], h01 * y[k + 1]))))
}

pub fn fritsch_carlson(x: &[f64], y: &[f64], xi: f64) -> Option<f64> {
    let n = x.len();
    if n != 3 || xi < x[0] || xi > x[n - 1] {
        return None;
    }

    let k = (0..2).find(|&i| xi >= x[i] && xi <= x[i + 1]).unwrap_or(0);

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
        let w1 = 2.0f64.mul_add(h1, h0);
        let w2 = 2.0f64.mul_add(h0, h1);
        m[1] = (w1 + w2) / (w1 / d0 + w2 / d1);
    }

    let h = x[k + 1] - x[k];
    let t = (xi - x[k]) / h;
    let t2 = t * t;
    let t3 = t2 * t;

    let h00 = 2.0f64.mul_add(t3, 3.0f64.mul_add(-t2, 1.0));
    let h10 = 2.0f64.mul_add(-t2, t3.mul_add(1.0, t));
    let h01 = (-2.0f64).mul_add(t3, 3.0 * t2);
    let h11 = t3 - t2;

    Some((h11 * h).mul_add(m[k + 1], h00.mul_add(y[k], h10.mul_add(h * m[k], h01 * y[k + 1]))))
}
