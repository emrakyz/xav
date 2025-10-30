use std::path::Path;

use av1_grain::{NoiseGenArgs, TransferFunction, generate_photon_noise_params, write_grain_table};

use crate::ffms::VidInf;

pub fn gen_table(iso: u32, inf: &VidInf, output: &Path) -> Result<(), Box<dyn std::error::Error>> {
    let transfer = if inf.transfer_characteristics == Some(16) {
        TransferFunction::SMPTE2084
    } else {
        TransferFunction::BT1886
    };

    let args = NoiseGenArgs {
        iso_setting: iso,
        width: inf.width,
        height: inf.height,
        transfer_function: transfer,
        chroma_grain: true,
        random_seed: None,
    };

    let duration = inf.frames as u64 * u64::from(inf.fps_den) * 10_000_000 / u64::from(inf.fps_num);
    let segment = generate_photon_noise_params(0, duration, args);

    write_grain_table(output, &[segment])?;
    Ok(())
}
