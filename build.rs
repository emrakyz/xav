use std::{env, error::Error, fs, path::Path, process::Command};

const SYS_PATHS: [&str; 6] = [
    "/usr/lib64",
    "/usr/lib",
    "/usr/local/lib64",
    "/usr/local/lib",
    "/lib64",
    "/lib",
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

fn git(dir: &str, args: &[&str]) -> String {
    Command::new("git")
        .args(["-C", dir])
        .args(args)
        .output()
        .ok()
        .filter(|o| o.status.success())
        .map_or_else(String::new, |o| {
            String::from_utf8_lossy(&o.stdout).trim().to_owned()
        })
}

fn field(path: &str, key: &str) -> Option<String> {
    let t = fs::read_to_string(path).ok()?;
    t.lines()
        .find_map(|l| l.trim_start().strip_prefix(key))
        .and_then(|r| {
            r.split([' ', '\t', '\'', '"', ',', ')'])
                .find(|s| !s.is_empty())
        })
        .map(str::to_owned)
}

fn stamp(var: &str, ver: Option<String>, dir: &str) {
    let v = ver.unwrap_or_default();
    let h = git(dir, &["rev-parse", "--short", "HEAD"]);
    println!(
        "cargo:rustc-env=XAV_V_{var}={}{}{h}",
        if v.is_empty() { "unknown" } else { v.as_str() },
        if h.is_empty() { "" } else { "-" }
    );
    println!(
        "cargo:rustc-env=XAV_D_{var}={}",
        git(dir, &["log", "-1", "--format=%cs"])
    );
    for f in ["HEAD", "logs/HEAD"] {
        let p = format!("{dir}/.git/{f}");
        if Path::new(&p).exists() {
            println!("cargo:rerun-if-changed={p}");
        }
    }
}

fn triple(path: &str, key: &str, parts: [&str; 3]) -> Option<String> {
    let p = |k: &str| field(path, &format!("{key}{k}"));
    match (p(parts[0]), p(parts[1]), p(parts[2])) {
        (Some(a), Some(b), Some(c)) => Some(format!("{a}.{b}.{c}")),
        _ => None,
    }
}

#[cfg(all(feature = "vship", feature = "cuda"))]
fn cuda_ver() -> String {
    ["/opt/cuda", "/usr/local/cuda"]
        .iter()
        .find_map(|d| {
            field(
                &format!("{d}/include/cuda_runtime_api.h"),
                "#define CUDART_VERSION",
            )
        })
        .and_then(|v| v.parse::<u32>().ok())
        .map_or_else(
            || "unknown".to_owned(),
            |n| format!("{}.{}.{}", n / 1000, n % 1000 / 10, n % 10),
        )
}

#[cfg(feature = "vship")]
fn mesa() -> Option<String> {
    [
        "/usr/lib64/pkgconfig/dri.pc",
        "/usr/lib/pkgconfig/dri.pc",
        "/usr/share/pkgconfig/dri.pc",
    ]
    .iter()
    .find_map(|p| field(p, "Version:"))
    .or_else(|| {
        Command::new("pkg-config")
            .args(["--modversion", "dri"])
            .output()
            .ok()
            .filter(|o| o.status.success())
            .map(|o| String::from_utf8_lossy(&o.stdout).trim().to_owned())
            .filter(|s| !s.is_empty())
    })
}

#[cfg(feature = "vship")]
fn gpu() -> String {
    let ids: Vec<String> = fs::read_dir("/sys/class/drm")
        .into_iter()
        .flatten()
        .flatten()
        .filter_map(|e| fs::read_to_string(e.path().join("device/vendor")).ok())
        .map(|v| v.trim().to_owned())
        .collect();
    for (id, name) in [("0x10de", "NVIDIA"), ("0x1002", "AMD"), ("0x8086", "Intel")] {
        if ids.iter().any(|v| v.as_str() == id) {
            return if id == "0x10de" {
                fs::read_to_string("/sys/module/nvidia/version")
                    .map_or_else(|_| name.to_owned(), |v| format!("{name} {}", v.trim()))
            } else {
                mesa().map_or_else(|| name.to_owned(), |m| format!("{name} Mesa {m}"))
            };
        }
    }
    "unknown".to_owned()
}

#[cfg(feature = "vvenc")]
const VVENC_LAYOUT: &str = r#"#include <cstddef>
#include "vvenc/vvencCfg.h"
static_assert(sizeof(vvenc_config)==CFG_SIZE,"");
static_assert(offsetof(vvenc_config,m_SourceWidth)==0,"");
static_assert(offsetof(vvenc_config,m_SourceHeight)==4,"");
static_assert(offsetof(vvenc_config,m_FrameRate)==8,"");
static_assert(offsetof(vvenc_config,m_FrameScale)==12,"");
static_assert(offsetof(vvenc_config,m_TicksPerSecond)==16,"");
static_assert(offsetof(vvenc_config,m_framesToBeEncoded)==20,"");
static_assert(offsetof(vvenc_config,m_inputBitDepth)==24,"");
static_assert(offsetof(vvenc_config,m_numThreads)==32,"");
static_assert(offsetof(vvenc_config,m_QP)==36,"");
"#;

#[cfg(feature = "vvenc")]
fn check_vvenc_layout(dir: &str) -> Result<(), Box<dyn Error + Send + Sync>> {
    let hdr = format!("{dir}/include/vvenc/vvencCfg.h");
    println!("cargo:rerun-if-changed={hdr}");
    println!("cargo:rerun-if-changed=src/vvenc.rs");
    let sz = field("src/vvenc.rs", "pub const VVENC_CFG_SIZE: usize =")
        .ok_or("src/vvenc.rs: VVENC_CFG_SIZE not found")?;
    let src = VVENC_LAYOUT.replace("CFG_SIZE", sz.trim_end_matches(';'));
    Command::new("clang++")
        .args(["-std=c++20", "-fsyntax-only"])
        .arg(format!("-I{dir}/include"))
        .arg(&src_file("vvenc_layout.cpp", &src)?)
        .status()
        .is_ok_and(|s| s.success())
        .then_some(())
        .ok_or_else(|| "vvenc_config layout changed: update src/vvenc.rs".into())
}

#[cfg(feature = "x265")]
const X265_LAYOUT: &str = r#"#include <cstddef>
#include "x265.h"
static_assert(sizeof(x265_param)==PARAM_SIZE,"");
static_assert(sizeof(x265_picture)==PIC_SIZE,"");
static_assert(offsetof(x265_param,totalFrames)==OFF_TOTAL_FRAMES,"");
static_assert(offsetof(x265_param,rc.rfConstant)==OFF_RF_CONSTANT,"");
static_assert(offsetof(x265_param,sourceBitDepth)==OFF_SOURCE_BIT_DEPTH,"");
static_assert(offsetof(x265_picture,planes)==32,"");
static_assert(offsetof(x265_picture,stride)==64,"");
static_assert(offsetof(x265_picture,bitDepth)==80,"");
static_assert(offsetof(x265_picture,forceqp)==96,"");
static_assert(offsetof(x265_picture,analysisData)==104,"");
static_assert(sizeof(x265_nal)==16,"");
"#;

#[cfg(feature = "x265")]
fn check_x265_layout(dir: &str, build: &str) -> Result<(), Box<dyn Error + Send + Sync>> {
    println!("cargo:rerun-if-changed={dir}/source/x265.h");
    println!("cargo:rerun-if-changed=src/x265.rs");
    let mut src = X265_LAYOUT.to_owned();
    for k in [
        "PARAM_SIZE",
        "PIC_SIZE",
        "OFF_TOTAL_FRAMES",
        "OFF_RF_CONSTANT",
        "OFF_SOURCE_BIT_DEPTH",
    ] {
        let key = format!("pub const X265_{k}: usize =");
        let v = field("src/x265.rs", &key)
            .or_else(|| field("src/x265.rs", &format!("pub const {k}: usize =")))
            .ok_or_else(|| format!("src/x265.rs: {k} not found"))?;
        src = src.replace(k, v.trim_end_matches(';'));
    }
    Command::new("clang++")
        .args(["-std=c++20", "-fsyntax-only"])
        .arg(format!("-I{dir}/source"))
        .arg(format!("-I{build}"))
        .arg(&src_file("x265_layout.cpp", &src)?)
        .status()
        .is_ok_and(|s| s.success())
        .then_some(())
        .ok_or_else(|| "x265 public struct layout changed: update src/x265.rs".into())
}

#[cfg(feature = "x264")]
const X264_LAYOUT: &str = r#"#include <stdint.h>
#include <stddef.h>
#include "x264.h"
_Static_assert(sizeof(x264_param_t)==PARAM_SIZE,"");
_Static_assert(sizeof(x264_picture_t)==PIC_SIZE,"");
_Static_assert(offsetof(x264_param_t,i_width)==OFF_WIDTH,"");
_Static_assert(offsetof(x264_param_t,i_height)==OFF_WIDTH+4,"");
_Static_assert(offsetof(x264_param_t,i_frame_total)==OFF_FRAME_TOTAL,"");
_Static_assert(offsetof(x264_param_t,i_log_level)==OFF_LOG_LEVEL,"");
_Static_assert(offsetof(x264_param_t,rc.f_rf_constant)==OFF_RF_CONSTANT,"");
_Static_assert(offsetof(x264_picture_t,i_pts)==16,"");
_Static_assert(offsetof(x264_picture_t,img.i_csp)==40,"");
_Static_assert(offsetof(x264_picture_t,img.i_stride)==48,"");
_Static_assert(offsetof(x264_picture_t,img.plane)==64,"");
_Static_assert(offsetof(x264_picture_t,prop)==96,"");
_Static_assert(sizeof(x264_nal_t)==40,"");
_Static_assert(offsetof(x264_nal_t,p_payload)==24,"");
_Static_assert(X264_CSP_I420==2,"");
_Static_assert(X264_CSP_HIGH_DEPTH==0x2000,"");
_Static_assert(X264_LOG_WARNING==1,"");
"#;

#[cfg(feature = "x264")]
fn check_x264_layout(dir: &str) -> Result<(), Box<dyn Error + Send + Sync>> {
    println!("cargo:rerun-if-changed={dir}/x264.h");
    println!("cargo:rerun-if-changed=src/x264.rs");
    let mut src = X264_LAYOUT.to_owned();
    for k in [
        "PARAM_SIZE",
        "PIC_SIZE",
        "OFF_WIDTH",
        "OFF_FRAME_TOTAL",
        "OFF_LOG_LEVEL",
        "OFF_RF_CONSTANT",
    ] {
        let key = format!("pub const X264_{k}: usize =");
        let v = field("src/x264.rs", &key)
            .or_else(|| field("src/x264.rs", &format!("pub const {k}: usize =")))
            .ok_or_else(|| format!("src/x264.rs: {k} not found"))?;
        src = src.replace(k, v.trim_end_matches(';'));
    }
    Command::new("clang")
        .args(["-std=c11", "-fsyntax-only"])
        .arg(format!("-I{dir}"))
        .arg(&src_file("x264_layout.c", &src)?)
        .status()
        .is_ok_and(|s| s.success())
        .then_some(())
        .ok_or_else(|| "x264 public struct layout changed: update src/x264.rs".into())
}

#[cfg(any(feature = "vvenc", feature = "x264", feature = "x265"))]
fn src_file(name: &str, src: &str) -> Result<String, Box<dyn Error + Send + Sync>> {
    let probe = format!("{}/{name}", env::var("OUT_DIR")?);
    fs::write(&probe, src)?;
    Ok(probe)
}

fn stamp_versions(home: &str) -> Result<(), Box<dyn Error + Send + Sync>> {
    let src = format!("{home}/.local/src");

    stamp(
        "XAV",
        env::var("CARGO_PKG_VERSION").ok(),
        &env::var("CARGO_MANIFEST_DIR")?,
    );

    let svt = format!("{src}/SVT-AV1");
    let url = git(&svt, &["remote", "get-url", "origin"]);
    let base = url
        .rsplit('/')
        .next()
        .unwrap_or_default()
        .trim_end_matches(".git");
    let fork = base
        .strip_prefix("SVT-AV1-")
        .or_else(|| base.strip_prefix("svt-av1-"))
        .map_or_else(String::new, |f| format!("-{f}"));
    stamp(
        "SVT",
        triple(
            &format!("{svt}/Source/API/EbSvtAv1.h"),
            "#define SVT_AV1_VERSION_",
            ["MAJOR", "MINOR", "PATCHLEVEL"],
        )
        .map(|v| v + &fork),
        &svt,
    );

    let dav1d = format!("{src}/dav1d");
    stamp(
        "DAV1D",
        field(&format!("{dav1d}/meson.build"), "version:"),
        &dav1d,
    );

    #[cfg(feature = "avm")]
    {
        let avm = format!("{src}/avm");
        stamp(
            "AVM",
            field(
                &format!("{avm}/build/config/avm_version.h"),
                "#define VERSION_STRING_NOSP",
            )
            .map(|v| v.trim_start_matches('v').to_owned()),
            &avm,
        );
    }

    #[cfg(feature = "vvenc")]
    {
        let vvenc = format!("{src}/vvenc");
        stamp(
            "VVENC",
            field(&format!("{vvenc}/CMakeLists.txt"), "project( vvenc VERSION"),
            &vvenc,
        );
        check_vvenc_layout(&vvenc)?;

        #[cfg(feature = "vship")]
        {
            let vvdec = format!("{src}/vvdec");
            stamp(
                "VVDEC",
                field(&format!("{vvdec}/CMakeLists.txt"), "project( vvdec VERSION"),
                &vvdec,
            );
        }
    }

    #[cfg(feature = "x265")]
    {
        let x265 = format!("{src}/x265_git");
        stamp(
            "X265",
            field(&format!("{x265}/x265Version.txt"), "releasetag:"),
            &x265,
        );
        check_x265_layout(&x265, &format!("{x265}/source/build-xav"))?;
    }

    #[cfg(feature = "x264")]
    {
        let x264 = format!("{src}/x264");
        stamp(
            "X264",
            field(&format!("{x264}/x264.h"), "#define X264_BUILD"),
            &x264,
        );
        check_x264_layout(&x264)?;
    }

    #[cfg(feature = "vship")]
    {
        let vship = format!("{src}/Vship");
        stamp(
            "VSHIP",
            triple(
                &format!("{vship}/Makefile"),
                "VSHIP_VERSION_",
                ["MAJOR=", "MINOR=", "MINORMINOR="],
            ),
            &vship,
        );

        #[cfg(feature = "cuda")]
        println!("cargo:rustc-env=XAV_V_CUDA={}", cuda_ver());

        #[cfg(not(feature = "cuda"))]
        {
            let vk = format!("{src}/vulkan/Vulkan-Loader");
            stamp(
                "VULKAN",
                field(
                    &format!("{vk}/CMakeLists.txt"),
                    "project(VULKAN_LOADER VERSION",
                ),
                &vk,
            );
        }

        println!("cargo:rustc-env=XAV_V_GPU={}", gpu());
    }

    Ok(())
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
            b.file("asm/dec.asm");
            b.file("asm/pb.asm");
            b.file("asm/pbf.asm");
            b.file("asm/crop_detect.asm");
            for k in [
                "pack",
                "unpack",
                "conv",
                "deint_p010",
                "deint_nv12",
                "deint_nv12_10b",
                "shift_p010",
                "nal_scan",
                "fmath",
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
            for k in ["frame_u8", "frame_u16", "samp"] {
                b.file(format!("asm/{set}/crop/{k}.asm"));
            }
            for k in ["cost", "split", "deque", "refine", "step", "run", "feed"] {
                b.file(format!("asm/{set}/scd/{k}.asm"));
            }
            for k in ["atou", "atof", "atof2", "scan"] {
                b.file(format!("asm/{set}/atofu/{k}.asm"));
            }
            for k in ["mix", "loud"] {
                b.file(format!("asm/{set}/norm/{k}.asm"));
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
                b.file("asm/sync/svt_drain_win.asm");
                println!("cargo:rustc-link-lib=dylib=synchronization");
            } else {
                b.file("asm/sync/sem.asm");
                if env::var("CARGO_CFG_TARGET_OS").as_deref() == Ok("linux") {
                    b.file("asm/vdso.asm");
                    b.file("asm/sync/svt_drain.asm");
                    b.file("asm/sync/ring_spsc.asm");
                    b.file("asm/sync/ring_spmc.asm");
                    b.file("asm/sync/ring_mpmc.asm");
                    b.file("asm/sync/ring_mpsc.asm");
                    b.file("asm/sync/thread.asm");
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

    stamp_versions(&home)?;
    build_asm()?;

    println!("cargo:rustc-link-search=native={home}/.local/src/FFmpeg/install/lib");
    println!("cargo:rustc-link-search=native={home}/.local/src/dav1d/build/src");

    println!("cargo:rustc-link-lib=static=swresample");
    println!("cargo:rustc-link-lib=static=avformat");
    println!("cargo:rustc-link-lib=static=avcodec");
    println!("cargo:rustc-link-lib=static=avutil");
    println!("cargo:rustc-link-lib=static=dav1d");

    #[cfg(not(feature = "cuda"))]
    {
        println!("cargo:rustc-link-search=native={home}/.local/src/vulkan/install/lib");
        println!("cargo:rustc-link-lib=static=vulkan");
    }

    fd_static_libs(
        &[format!("{home}/.local/src/opus/install/lib")],
        "libopus.a",
    );
    println!("cargo:rustc-link-lib=static=opus");

    fd_static_libs(
        &[format!("{home}/.local/src/SVT-AV1/Bin/Release")],
        "libSvtAv1Enc.a",
    );
    println!("cargo:rustc-link-lib=static=SvtAv1Enc");

    #[cfg(feature = "avm")]
    {
        let avm_dir = format!("{home}/.local/src/avm/build");
        if !Path::new(&format!("{avm_dir}/libavm_full.a")).exists() {
            return Err(format!("{avm_dir}/libavm_full.a not found").into());
        }
        println!("cargo:rustc-link-search=native={avm_dir}");
        println!("cargo:rustc-link-lib=static=avm_full");
    }

    #[cfg(feature = "vvenc")]
    {
        let vvenc_dir = format!("{home}/.local/src/vvenc/lib/release-static");
        if !Path::new(&format!("{vvenc_dir}/libvvenc.a")).exists() {
            return Err(format!("{vvenc_dir}/libvvenc.a not found").into());
        }
        println!("cargo:rustc-link-search=native={vvenc_dir}");
        println!("cargo:rustc-link-lib=static=vvenc");

        #[cfg(feature = "vship")]
        {
            let vvdec_dir = format!("{home}/.local/src/vvdec/lib/release-static");
            if !Path::new(&format!("{vvdec_dir}/libvvdec.a")).exists() {
                return Err(format!("{vvdec_dir}/libvvdec.a not found").into());
            }
            println!("cargo:rustc-link-search=native={vvdec_dir}");
            println!("cargo:rustc-link-lib=static=vvdec");
        }
    }

    #[cfg(feature = "x265")]
    {
        let x265_dir = format!("{home}/.local/src/x265_git/source/build-xav");
        if !Path::new(&format!("{x265_dir}/libx265.a")).exists() {
            return Err(format!("{x265_dir}/libx265.a not found").into());
        }
        println!("cargo:rustc-link-search=native={x265_dir}");
        println!("cargo:rustc-link-lib=static=x265");
    }

    #[cfg(feature = "x264")]
    {
        let x264_dir = format!("{home}/.local/src/x264");
        if !Path::new(&format!("{x264_dir}/libx264.a")).exists() {
            return Err(format!("{x264_dir}/libx264.a not found").into());
        }
        println!("cargo:rustc-link-search=native={x264_dir}");
        println!("cargo:rustc-link-lib=static=x264");
    }

    #[cfg(feature = "vship")]
    {
        let vship_dir = format!("{home}/.local/src/Vship");
        if !Path::new(&format!("{vship_dir}/libvship.a")).exists() {
            return Err(format!("{vship_dir}/libvship.a not found").into());
        }
        println!("cargo:rustc-link-search=native={vship_dir}");
        println!("cargo:rustc-link-lib=static=vship");

        #[cfg(feature = "cuda")]
        {
            fd_static_libs(
                &[
                    "/opt/cuda/lib64".to_owned(),
                    "/usr/local/cuda/lib64".to_owned(),
                ],
                "libcudart_static.a",
            );
            println!("cargo:rustc-link-lib=static=cudart_static");
            println!("cargo:rustc-link-lib=dylib=cuda");
        }
    }

    #[cfg(any(
        feature = "vship",
        feature = "avm",
        feature = "vvenc",
        feature = "x265"
    ))]
    if env::var("CARGO_CFG_TARGET_OS").as_deref() == Ok("linux") {
        println!("cargo:rustc-link-arg=-l:libstdc++.a");
    }

    if env::var("CARGO_CFG_TARGET_OS").as_deref() == Ok("windows") {
        // Our asm indexes rodata tables as [table + reg*scale] amd64
        // cant encode rip-relative; nasm emits a 32-bit absolute
        // displacement (ADDR32)
        let args: &[&str] = if env::var("CARGO_CFG_TARGET_ENV").as_deref() == Ok("msvc") {
            &["/BASE:0x10000000", "/FIXED"]
        } else {
            &[
                "-Wl,--image-base=0x10000000",
                "-Wl,--disable-dynamicbase",
                "-Wl,--disable-reloc-section",
            ]
        };
        for a in args {
            println!("cargo:rustc-link-arg={a}");
        }
    }

    if env::var("CARGO_CFG_TARGET_OS").as_deref() == Ok("linux") {
        let stat = env::var("CARGO_CFG_TARGET_FEATURE")
            .is_ok_and(|f| f.split(',').any(|x| x == "crt-static"));
        println!(
            "cargo:rustc-link-lib={}=m",
            if stat { "static" } else { "dylib" }
        );
    }
    Ok(())
}
