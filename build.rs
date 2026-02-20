use std::env;

fn main() {
    if cfg!(feature = "static") {
        let home = env::var("HOME").expect("HOME environment variable not set");
        println!("cargo:rustc-link-search=native={home}/.local/src/FFmpeg/install/lib");
        println!("cargo:rustc-link-search=native={home}/.local/src/dav1d/build/src");
        println!("cargo:rustc-link-search=native={home}/.local/src/zlib/install/lib");

        println!("cargo:rustc-link-lib=static=swscale");
        println!("cargo:rustc-link-lib=static=avformat");
        println!("cargo:rustc-link-lib=static=avcodec");
        println!("cargo:rustc-link-lib=static=avutil");
        println!("cargo:rustc-link-lib=static=dav1d");
        println!("cargo:rustc-link-lib=static=z");
        println!("cargo:rustc-link-lib=static=stdc++");

        #[cfg(feature = "vship")]
        {
            let vship_paths = [
                format!("{home}/.local/src/Vship"),
                "/usr/lib64".to_string(),
                "/usr/lib".to_string(),
                "/usr/local/lib64".to_string(),
                "/usr/local/lib".to_string(),
                "/lib64".to_string(),
                "/lib".to_string(),
            ];
            for path in &vship_paths {
                if std::path::Path::new(&format!("{path}/libvship.a")).exists() {
                    println!("cargo:rustc-link-search=native={path}");
                    break;
                }
            }

            println!("cargo:rustc-link-lib=static=vship");

            println!("cargo:rustc-link-lib=static=cudart_static");
            println!("cargo:rustc-link-search=native=/opt/cuda/lib64");

            println!("cargo:rustc-link-lib=dylib=cuda");
        }
    }

    if cfg!(feature = "libsvtav1") {
        let home = env::var("HOME").expect("HOME environment variable not set");
        let search_paths = [
            format!("{home}/.local/src/svt-av1-hdr/Bin/Release"),
            format!("{home}/.local/src/SVT-AV1/Bin/Release"),
            "/usr/lib64".to_string(),
            "/usr/lib".to_string(),
            "/usr/local/lib64".to_string(),
            "/usr/local/lib".to_string(),
            "/lib64".to_string(),
            "/lib".to_string(),
        ];
        for path in &search_paths {
            if std::path::Path::new(&format!("{path}/libSvtAv1Enc.a")).exists() {
                println!("cargo:rustc-link-search=native={path}");
                break;
            }
        }
        println!("cargo:rustc-link-lib=static=SvtAv1Enc");
    }
}
