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

    if cfg!(feature = "static") {
        println!("cargo:rustc-link-search=native={home}/.local/src/FFmpeg/install/lib");
        println!("cargo:rustc-link-search=native={home}/.local/src/dav1d/build/src");
        println!("cargo:rustc-link-search=native={home}/.local/src/zlib/install/lib");

        println!("cargo:rustc-link-lib=static=swscale");
        println!("cargo:rustc-link-lib=static=swresample");
        println!("cargo:rustc-link-lib=static=avformat");
        println!("cargo:rustc-link-lib=static=avcodec");
        println!("cargo:rustc-link-lib=static=avutil");
        println!("cargo:rustc-link-lib=static=dav1d");
        println!("cargo:rustc-link-lib=static=z");
        println!("cargo:rustc-link-lib=static=stdc++");

        #[cfg(feature = "vship")]
        {
            find_static_lib(&[format!("{home}/.local/src/Vship")], "libvship.a");
            println!("cargo:rustc-link-lib=static=vship");
            println!("cargo:rustc-link-lib=static=cudart_static");
            println!("cargo:rustc-link-search=native=/opt/cuda/lib64");
            println!("cargo:rustc-link-lib=dylib=cuda");
        }
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
