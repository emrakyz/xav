use std::{env, error::Error, path::Path};

const SYS_PATHS: [&str; 7] = [
    "/usr/lib64",
    "/usr/lib",
    "/usr/local/lib64",
    "/usr/local/lib",
    "/lib64",
    "/lib",
    "/opt/homebrew/lib",
];

fn fd_static_libs(primary_paths: &[String], lib_name: &str) {
    for path in primary_paths
        .iter()
        .map(String::as_str)
        .chain(SYS_PATHS.iter().copied())
    {
        if Path::new(&format!("{path}/{lib_name}")).exists() {
            println!("cargo:rustc-link-search=native={path}");
            return;
        }
    }
}

fn build_asm() -> Result<(), Box<dyn Error + Send + Sync>> {
    if env::var("CARGO_CFG_TARGET_ARCH").as_deref() == Ok("x86_64") {
        let feats = env::var("CARGO_CFG_TARGET_FEATURE").unwrap_or_default();
        let has = |f: &str| feats.split(',').any(|x| x == f);
        let set = if has("avx512bw") {
            Some("avx512")
        } else if has("avx2") {
            Some("avx2")
        } else {
            None
        };
        if let Some(set) = set {
            let mut b = nasm_rs::Build::new();
            b.include("asm");
            for k in [
                "pack",
                "unpack",
                "conv",
                "deint_p010",
                "deint_nv12",
                "deint_nv12_10b",
                "shift_p010",
                "nal_scan",
            ] {
                b.file(format!("asm/{set}/{k}.asm"));
            }
            for k in [
                "pack",
                "unpack",
                "conv",
                "deint_p010",
                "deint_nv12",
                "deint_nv12_10b",
                "shift_p010",
            ] {
                b.file(format!("asm/{set}/rem/{k}_rem.asm"));
            }
            for k in [
                "crop_row_stats_u8",
                "crop_row_stats_u16",
                "crop_col_stats_u8",
                "crop_col_stats_u16",
                "calc_samp_frames",
            ] {
                b.file(format!("asm/{set}/{k}.asm"));
            }
            for k in [
                "satd",
                "satd16",
                "satd_dc",
                "satd16_dc",
                "importance",
                "importance16",
            ] {
                b.file(format!("asm/{set}/scd/{k}.asm"));
            }
            for k in ["atou", "atof", "atof2", "scan"] {
                b.file(format!("asm/{set}/atofu/{k}.asm"));
            }
            for k in ["pchip", "fc_spline", "lerp", "bs"] {
                b.file(format!("asm/avx2/interp/{k}.asm"));
            }
            if set == "avx512" {
                b.file("asm/avx512/crc32.asm");
                b.file("asm/avx512/crc32_combine.asm");
            } else if set == "avx2" && has("vpclmulqdq") {
                b.file("asm/avx2/crc32.asm");
                b.file("asm/avx2/crc32_combine.asm");
            } else if set == "avx2" && has("pclmulqdq") {
                b.file("asm/avx2/crc32_pclmul.asm");
                b.file("asm/avx2/crc32_combine.asm");
            }
            if env::var("CARGO_CFG_TARGET_OS").as_deref() == Ok("windows") {
                b.file("asm/sync/sem_win.asm");
                b.file("asm/sync/ring_spsc_win.asm");
                b.file("asm/sync/ring_spmc_win.asm");
                b.file("asm/sync/ring_mpmc_win.asm");
                b.file("asm/sync/ring_mpsc_win.asm");
                println!("cargo:rustc-link-lib=dylib=synchronization");
            } else {
                b.file("asm/sync/sem.asm");
                if env::var("CARGO_CFG_TARGET_OS").as_deref() == Ok("linux") {
                    b.file("asm/sync/ring_spsc.asm");
                    b.file("asm/sync/ring_spmc.asm");
                    b.file("asm/sync/ring_mpmc.asm");
                    b.file("asm/sync/ring_mpsc.asm");
                }
            }
            b.compile("xavasm")?;
            println!("cargo:rustc-link-lib=static=xavasm");
        }
        println!("cargo:rerun-if-changed=asm");
    }
    Ok(())
}

fn main() -> Result<(), Box<dyn Error + Send + Sync>> {
    let home = env::var("HOME")?;

    build_asm()?;

    println!("cargo:rustc-link-search=native={home}/.local/src/FFmpeg/install/lib");
    println!("cargo:rustc-link-search=native={home}/.local/src/dav1d/build/src");
    println!("cargo:rustc-link-search=native={home}/.local/src/vulkan/install/lib");

    println!("cargo:rustc-link-lib=static=swresample");
    println!("cargo:rustc-link-lib=static=avformat");
    println!("cargo:rustc-link-lib=static=avcodec");
    println!("cargo:rustc-link-lib=static=avutil");
    println!("cargo:rustc-link-lib=static=vulkan");
    println!("cargo:rustc-link-lib=static=dav1d");

    fd_static_libs(
        &[format!("{home}/.local/src/opus/install/lib")],
        "libopus.a",
    );
    fd_static_libs(
        &[format!("{home}/.local/src/libopusenc/install/lib")],
        "libopusenc.a",
    );
    println!("cargo:rustc-link-lib=static=opusenc");
    println!("cargo:rustc-link-lib=static=opus");

    fd_static_libs(
        &[format!("{home}/.local/src/SVT-AV1/Bin/Release")],
        "libSvtAv1Enc.a",
    );
    println!("cargo:rustc-link-lib=static=SvtAv1Enc");

    #[cfg(feature = "vship")]
    {
        let vship_dir = format!("{home}/.local/src/Vship");
        if Path::new(&format!("{vship_dir}/libvship.a")).exists() {
            println!("cargo:rustc-link-search=native={vship_dir}");
            println!("cargo:rustc-link-lib=static=vship");
        } else {
            println!("cargo:rustc-link-lib=dylib=vship");
            return Ok(());
        }
        println!("cargo:rustc-link-lib=static=stdc++");
        println!("cargo:rustc-link-lib=static=cudart_static");
        println!("cargo:rustc-link-search=native=/opt/cuda/lib64");
        println!("cargo:rustc-link-lib=dylib=cuda");
    }
    Ok(())
}
