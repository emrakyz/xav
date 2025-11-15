#!/usr/bin/env bash

set -Eeuo pipefail

cargo clean > /dev/null 2>&1
rm -f Cargo.lock

BUILD_DIR="${HOME}/.local/src"
XAV_DIR="$(pwd)"

R='\e[1;91m' B='\e[1;94m' P='\e[1;95m' Y='\e[1;93m'
N='\033[0m' C='\e[1;96m' G='\e[1;92m' W='\e[1;97m'

loginf() {
        sleep "0.3"

        case "${1}" in
                g) COL="${G}" MSG="DONE!" ;;
                r) COL="${R}" MSG="ERROR!" ;;
                b) COL="${B}" MSG="STARTING." ;;
                c) COL="${B}" MSG="RUNNING." ;;
        esac

        RAWMSG="${2}"
        DATE="$(date "+%Y-%m-%d ${C}/${P} %H:%M:%S")"
        LOG="${C}[${P}${DATE}${C}] ${Y}>>>${COL}${MSG}${Y}<<< - ${COL}${RAWMSG}${N}"

        [[ "${1}" == "c" ]] && echo -e "\n\n${LOG}" || echo -e "${LOG}"
}

handle_err() {
        local exit_code="${?}"
        local failed_command="${BASH_COMMAND}"
        local failed_line="${BASH_LINENO[0]}"

        trap - ERR INT

        [[ "${exit_code}" -eq 130 ]] && {
                echo -e "\n${R}Interrupted by user${N}"
                exit 130
        }

        loginf r "Line ${B}${failed_line}${R}: cmd ${B}'${failed_command}'${R} exited with ${B}\"${exit_code}\""

        [[ -f "${logfile:-}" ]] && {
                echo -e "\n${R}Output:${N}\n"
                cat "${logfile}"
        }

        exit "${exit_code}"
}

handle_int() {
        echo -e "\n${R}Interrupted by user${N}"
        exit 130
}

trap 'handle_err' ERR
trap 'handle_int' INT

show_opts() {
        opts=("${@}")

        for i in "${!opts[@]}"; do
                printf "${Y}%2d) ${P}%-70s${N}\n" "$((i + 1))" "${opts[i]}"
        done

        echo
}

cleanup_existing() {
        [[ "${build_static}" == false ]] && return 0

        local dirs=("dav1d" "FFmpeg" "ffms2" "zlib")
        local found=()

        for dir in "${dirs[@]}"; do
                [[ -d "${BUILD_DIR}/${dir}" ]] && found+=("${dir}")
        done

        [[ ${#found[@]} -eq 0 ]] && return

        echo -e "\n${Y}Found existing build directories:${N}"
        printf "  ${P}- %s${N}\n" "${found[@]}"

        echo -ne "\n${C}Remove and rebuild? (y/n): ${N}"
        read -r choice

        [[ "${choice}" =~ ^[Yy]$ ]] && {
                for dir in "${found[@]}"; do
                        loginf b "Removing ${BUILD_DIR}/${dir}"
                        rm -rf "${BUILD_DIR:?}/${dir}" > "/dev/null" 2>&1
                done
                loginf g "Cleanup complete"
        } || loginf b "Using existing builds"

        echo
}

build_zlib() {
        [[ -d "${BUILD_DIR}/zlib" ]] && return

        loginf b "Building zlib"

        local logfile="/tmp/build_zlib_$.log"

        git clone https://github.com/madler/zlib.git "${BUILD_DIR}/zlib" > "${logfile}" 2>&1
        cd "${BUILD_DIR}/zlib"
        ./configure --static --prefix="${BUILD_DIR}/zlib/install" >> "${logfile}" 2>&1
        make -j"$(nproc)" >> "${logfile}" 2>&1
        make install >> "${logfile}" 2>&1 && {
                rm -f "${logfile}"
                loginf g "zlib built successfully"
        } || {
                echo -e "\n${R}Build failed! Output:${N}\n"
                cat "${logfile}"
                rm -f "${logfile}"
                exit 1
        }
}

build_dav1d() {
        [[ -d "${BUILD_DIR}/dav1d" ]] && return

        loginf b "Building dav1d"

        local logfile="/tmp/build_dav1d_$.log"

        git clone https://code.videolan.org/videolan/dav1d.git "${BUILD_DIR}/dav1d" > "${logfile}" 2>&1
        cd "${BUILD_DIR}/dav1d"
        meson setup build --default-library=static \
                --buildtype=release \
                -Denable_tools=false \
                -Denable_examples=false \
                -Dbitdepths=8,16 \
                -Denable_asm=true >> "${logfile}" 2>&1
        ninja -C build >> "${logfile}" 2>&1

        mkdir -p "${BUILD_DIR}/dav1d/lib/pkgconfig"
        cp "${BUILD_DIR}/dav1d/build/meson-private/dav1d.pc" "/tmp/dav1d.pc"
        sed -i "s|prefix=/usr/local|prefix=${BUILD_DIR}/dav1d|g" "/tmp/dav1d.pc"
        sed -i "s|includedir=\${prefix}/include|includedir=\${prefix}/include|g" "/tmp/dav1d.pc"
        sed -i "s|libdir=\${prefix}/lib64|libdir=\${prefix}/build/src|g" "/tmp/dav1d.pc" 2> /dev/null || true
        sed -i "s|libdir=\${prefix}/lib|libdir=\${prefix}/build/src|g" "/tmp/dav1d.pc" 2> /dev/null || true
        cp /tmp/dav1d.pc "${BUILD_DIR}/dav1d/lib/pkgconfig/" && {
                rm -f "${logfile}"
                loginf g "dav1d built successfully"
        } || {
                echo -e "\n${R}Build failed! Output:${N}\n"
                cat "${logfile}"
                rm -f "${logfile}"
                exit 1
        }
}

build_ffmpeg() {
        [[ -d "${BUILD_DIR}/FFmpeg" ]] && return

        loginf b "Building FFmpeg"

        export PKG_CONFIG_PATH="${BUILD_DIR}/dav1d/lib/pkgconfig:${BUILD_DIR}/FFmpeg/install/lib/pkgconfig"

        local logfile="/tmp/build_ffmpeg_$.log"

        cd "${BUILD_DIR}"
        git clone "https://github.com/FFmpeg/FFmpeg" > "${logfile}" 2>&1
        cd "FFmpeg"
        git checkout n8.0 >> "${logfile}" 2>&1

        ./configure \
                --cc="${CC}" \
                --cxx="${CXX}" \
                --ar="${AR}" \
                --ranlib="${RANLIB}" \
                --strip="${STRIP}" \
                --extra-cflags="${CFLAGS}" \
                --extra-cxxflags="${CXXFLAGS}" \
                --extra-ldflags="${LDFLAGS}" \
                --disable-shared \
                --enable-static \
                --pkg-config-flags="--static" \
                --disable-programs \
                --disable-doc \
                --disable-htmlpages \
                --disable-manpages \
                --disable-podpages \
                --disable-txtpages \
                --disable-network \
                --disable-autodetect \
                --disable-all \
                --disable-everything \
                --enable-avcodec \
                --enable-avformat \
                --enable-avutil \
                --enable-swscale \
                --enable-swresample \
                --enable-protocol=file \
                --enable-demuxer=matroska \
                --enable-demuxer=mov \
                --enable-demuxer=mpegts \
                --enable-demuxer=mpegps \
                --enable-demuxer=avi \
                --enable-demuxer=flv \
                --enable-demuxer=ivf \
                --enable-decoder=h264 \
                --enable-decoder=hevc \
                --enable-decoder=mpeg2video \
                --enable-decoder=mpeg1video \
                --enable-decoder=mpeg4 \
                --enable-decoder=av1 \
                --enable-decoder=libdav1d \
                --enable-decoder=vp9 \
                --enable-decoder=vc1 \
                --enable-libdav1d \
                --enable-parser=h264 \
                --enable-parser=hevc \
                --enable-parser=mpeg4video \
                --enable-parser=mpegvideo \
                --enable-parser=av1 \
                --enable-parser=vp9 \
                --enable-parser=vc1 >> "${logfile}" 2>&1

        make -j"$(nproc)" >> "${logfile}" 2>&1
        make install DESTDIR="${BUILD_DIR}/FFmpeg/install" prefix="" >> "${logfile}" 2>&1 && {
                rm -f "${logfile}"
                loginf g "FFmpeg built successfully"
        } || {
                echo -e "\n${R}Build failed! Output:${N}\n"
                cat "${logfile}"
                rm -f "${logfile}"
                exit 1
        }
}

build_ffms2() {
        [[ -d "${BUILD_DIR}/ffms2" ]] && return

        loginf b "Building ffms2"

        local logfile="/tmp/build_ffms2_$.log"

        cd "${BUILD_DIR}"
        git clone https://github.com/FFMS/ffms2.git > "${logfile}" 2>&1
        cd ffms2
        mkdir -p src/config
        autoreconf -fiv >> "${logfile}" 2>&1

        PKG_CONFIG_PATH="${BUILD_DIR}/FFmpeg/install/lib/pkgconfig:${BUILD_DIR}/zlib/install/lib/pkgconfig" \
                CC="${CC}" \
                CXX="${CXX}" \
                AR="${AR}" \
                RANLIB="${RANLIB}" \
                CFLAGS="${CFLAGS} -I${BUILD_DIR}/FFmpeg/install/include -I${BUILD_DIR}/zlib/install/include" \
                CXXFLAGS="${CXXFLAGS} -I${BUILD_DIR}/FFmpeg/install/include -I${BUILD_DIR}/zlib/install/include" \
                LDFLAGS="${LDFLAGS} -L${BUILD_DIR}/FFmpeg/install/lib -L${BUILD_DIR}/zlib/install/lib" \
                LIBS="-lpthread -lm -lz" \
                ./configure \
                --enable-static \
                --disable-shared \
                --with-zlib="${BUILD_DIR}/zlib/install" >> "${logfile}" 2>&1

        make -j"$(nproc)" >> "${logfile}" 2>&1 && {
                rm -f "${logfile}"
                loginf g "ffms2 built successfully"
        } || {
                echo -e "\n${R}Build failed! Output:${N}\n"
                cat "${logfile}"
                rm -f "${logfile}"
                exit 1
        }
}

setup_toolchain() {
        export CC="clang"
        export CXX="clang++"
        export LD="ld.lld"
        export AR="llvm-ar"
        export NM="llvm-nm"
        export RANLIB="llvm-ranlib"
        export STRIP="llvm-strip"
        export OBJCOPY="llvm-objcopy"
        export OBJDUMP="llvm-objdump"

        [[ "${polly}" == "ON" ]] && export POLLY_FLAGS="-mllvm -polly \
-mllvm -polly-position=before-vectorizer \
-mllvm -polly-parallel \
-mllvm -polly-omp-backend=LLVM \
-mllvm -polly-vectorizer=stripmine \
-mllvm -polly-tiling \
-mllvm -polly-register-tiling \
-mllvm -polly-2nd-level-tiling \
-mllvm -polly-detect-keep-going \
-mllvm -polly-enable-delicm=true \
-mllvm -polly-dependences-computeout=2 \
-mllvm -polly-postopts=true \
-mllvm -polly-pragma-based-opts \
-mllvm -polly-pattern-matching-based-opts=true \
-mllvm -polly-reschedule=true \
-mllvm -polly-process-unprofitable \
-mllvm -enable-loop-distribute \
-mllvm -enable-unroll-and-jam \
-mllvm -polly-ast-use-context \
-mllvm -polly-invariant-load-hoisting \
-mllvm -polly-loopfusion-greedy \
-mllvm -polly-run-inliner \
-mllvm -polly-run-dce"

        export COMMON_FLAGS="-O3 -ffast-math -march=native -mtune=native -flto=thin -pipe -fno-math-errno -fomit-frame-pointer -fno-semantic-interposition -fno-stack-protector -fno-stack-clash-protection -fno-sanitize=all -fno-dwarf2-cfi-asm ${POLLY_FLAGS:-} -fstrict-aliasing -fstrict-overflow -fno-zero-initialized-in-bss -static -fno-pic -fno-pie"
        export CFLAGS="${COMMON_FLAGS}"
        export CXXFLAGS="${COMMON_FLAGS} -stdlib=${selected_cxx}"
        export LDFLAGS="-fuse-ld=lld -rtlib=compiler-rt -unwindlib=libunwind -Wl,-O3 -Wl,--lto-O3 -Wl,--as-needed -Wl,-z,norelro -Wl,--build-id=none -Wl,--relax -Wl,-z,noseparate-code -Wl,--strip-all -Wl,--no-eh-frame-hdr -Wl,-znow -Wl,--gc-sections -Wl,--discard-all -Wl,--icf=all -static -fno-pic -fno-pie"
}

main() {
        preset="${1:-}"

        selected_cxx="libstdc++"

        case "$preset" in
                static_tq)
                        mode_choice=1
                        polly="ON"
                        ;;
                dynamic_tq)
                        mode_choice=2
                        ;;
                static_notq)
                        mode_choice=3
                        polly="ON"
                        ;;
                dynamic_notq)
                        mode_choice=4
                        ;;
                "") ;;
                *)
                        echo -e "Unknown preset: $preset"
                        echo "Valid presets:"
                        echo "  static_tq"
                        echo "  dynamic_tq"
                        echo "  static_notq"
                        echo "  dynamic_notq"
                        exit 1
                        ;;
        esac

        echo -e "\n${C}╔═══════════════════════════════════════════════════════════════════════╗${N}"
        echo -e "${C}║${W}                         Build Configuration                           ${C}║${N}"
        echo -e "${C}╚═══════════════════════════════════════════════════════════════════════╝${N}\n"

        BUILD_MODES=(
                "Build everything statically (ffms2) with TQ"
                "Build dynamically (requires ffms2, vship installed) with TQ"
                "Build statically without TQ (no vship)"
                "Build dynamically without TQ (requires ffms2 only)"
        )

        [[ "${preset}" ]] || {
                while true; do
                        show_opts "${BUILD_MODES[@]}"
                        echo -ne "${C}Build Mode: ${N}"
                        read -r mode_choice
                        [[ "${mode_choice}" =~ ^[1-4]$ ]] && {
                                loginf g "Mode: ${BUILD_MODES[mode_choice - 1]}"
                                break
                        }
                done
        }

        case "${mode_choice}" in
                1)
                        config_file=".cargo/config.toml.static"
                        cargo_features="--features static,vship"
                        build_static=true
                        ;;
                2)
                        config_file=".cargo/config.toml.dynamic"
                        cargo_features="--features vship"
                        build_static=false
                        ;;
                3)
                        config_file=".cargo/config.toml.static_notq"
                        cargo_features="--features static"
                        build_static=true
                        ;;
                4)
                        config_file=".cargo/config.toml.dynamic_notq"
                        cargo_features=""
                        build_static=false
                        ;;
        esac

        [[ "${build_static}" == true && -z "${preset}" ]] && {
                OPTS=("ON" "OFF")

                while true; do
                        show_opts "${OPTS[@]}"
                        echo -ne "${C}Polly Optimizations: ${N}"
                        read -r polly_choice

                        [[ "${polly_choice}" =~ ^[12]$ ]] && {
                                polly="${OPTS[polly_choice - 1]}"
                                loginf g "Polly: ${polly}"
                                break
                        }
                done

                echo
        }

        cleanup_existing

        [[ "${build_static}" == true ]] && {
                setup_toolchain

                loginf b "Starting static build process"

                build_zlib
                build_dav1d
                build_ffmpeg
                build_ffms2

                export PKG_CONFIG_ALL_STATIC=1
                export FFMPEG_DIR="${BUILD_DIR}/FFmpeg/install"
        }

        cd "${XAV_DIR}"

        loginf b "Configuring cargo"
        cp -f "${config_file}" ".cargo/config.toml"

        loginf b "Building XAV"

        local logfile="/tmp/build_cargo_$.log"
        local binary_path

        [[ "${build_static}" == true ]] && binary_path="target/x86_64-unknown-linux-gnu/release/xav" || binary_path="target/release/xav"

        cargo build --release ${cargo_features} > "${logfile}" 2>&1 && {
                rm -f "${logfile}"
                loginf g "Build complete"
                loginf g "Binary: ${XAV_DIR}/${binary_path}"
        } || {
                echo -e "\n${R}Build failed! Output:${N}\n"
                cat "${logfile}"
                rm -f "${logfile}"
                exit 1
        }
}

main "${@}"
