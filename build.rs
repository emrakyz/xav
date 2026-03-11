use std::{env, path::Path, process};

const SYS_PATHS: [&str; 6] = [
    "/usr/lib64",
    "/usr/lib",
    "/usr/local/lib64",
    "/usr/local/lib",
    "/lib64",
    "/lib",
];

fn find_static_lib(primary_paths: &[String], lib_name: &str) {
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

fn main() {
    let home = env::var("HOME").unwrap_or_else(|_| {
        println!("cargo:warning=HOME environment variable not set");
        process::exit(1);
    });

    println!("cargo:rustc-link-search=native={home}/.local/src/FFmpeg/install/lib");
    println!("cargo:rustc-link-search=native={home}/.local/src/dav1d/build/src");
    println!("cargo:rustc-link-search=native={home}/.local/src/vulkan/install/lib");

    println!("cargo:rustc-link-lib=static=swresample");
    println!("cargo:rustc-link-lib=static=avformat");
    println!("cargo:rustc-link-lib=static=avcodec");
    println!("cargo:rustc-link-lib=static=avutil");
    println!("cargo:rustc-link-lib=static=vulkan");
    println!("cargo:rustc-link-lib=static=dav1d");

    #[cfg(feature = "vship")]
    {
        let vship_dir = format!("{home}/.local/src/Vship");
        if Path::new(&format!("{vship_dir}/libvship.a")).exists() {
            println!("cargo:rustc-link-search=native={vship_dir}");
            println!("cargo:rustc-link-lib=static=vship");
        } else {
            println!("cargo:rustc-link-lib=dylib=vship");
            return;
        }
        println!("cargo:rustc-link-lib=static=stdc++");
        println!("cargo:rustc-link-lib=static=cudart_static");
        println!("cargo:rustc-link-search=native=/opt/cuda/lib64");
        println!("cargo:rustc-link-lib=dylib=cuda");
    }

    find_static_lib(
        &[format!("{home}/.local/src/opus/install/lib")],
        "libopus.a",
    );
    find_static_lib(
        &[format!("{home}/.local/src/libopusenc/install/lib")],
        "libopusenc.a",
    );
    println!("cargo:rustc-link-lib=static=opusenc");
    println!("cargo:rustc-link-lib=static=opus");

    find_static_lib(
        &[format!("{home}/.local/src/SVT-AV1/Bin/Release")],
        "libSvtAv1Enc.a",
    );
    println!("cargo:rustc-link-lib=static=SvtAv1Enc");
}
