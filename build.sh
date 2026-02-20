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
                printf "${Y}%2d) ${P}%-70b${N}\n" "$((i + 1))" "${opts[i]}"
        done

        echo
}

find_lib() {
        local name="${1}"
        local search_dirs=("${@:2}")

        for dir in "${search_dirs[@]}"; do
                [[ -f "${dir}/${name}" ]] && {
                        echo "${dir}/${name}"
                        return 0
                }
        done
        return 1
}

find_bin() {
        command -v "${1}" 2> /dev/null
}

detect_deps() {
        SYS_LIB_DIRS=("/usr/lib64" "/usr/lib" "/usr/local/lib64" "/usr/local/lib" "/lib64" "/lib")
        GCC_LIB_DIRS=()
        while IFS= read -r d; do
                GCC_LIB_DIRS+=("${d}")
        done < <(find /usr/lib/gcc /usr/lib64/gcc -maxdepth 2 -type d 2> /dev/null || true)

        CLANG_RT_DIR="$(clang --print-runtime-dir 2> /dev/null || true)"
        CLANG_LIB_DIRS=()
        [[ -n "${CLANG_RT_DIR}" && -d "${CLANG_RT_DIR}" ]] && CLANG_LIB_DIRS+=("${CLANG_RT_DIR}")
        while IFS= read -r d; do
                CLANG_LIB_DIRS+=("${d}")
        done < <(find /usr/lib/clang /usr/lib64/clang -type d -name "linux" -o -type d -name "lib" 2> /dev/null || true)

        ALL_STATIC_DIRS=("${SYS_LIB_DIRS[@]}" "${GCC_LIB_DIRS[@]}" "${CLANG_LIB_DIRS[@]}")

        RUST_NIGHTLY_PATH="$(find_bin rustc || true)"
        RUSTC_VERSION=""
        if [[ -n "${RUST_NIGHTLY_PATH}" ]]; then
                RUSTC_VERSION="$(rustc --version 2> /dev/null || true)"
                [[ "${RUSTC_VERSION}" == *nightly* ]] && HAS_RUST_NIGHTLY=true || HAS_RUST_NIGHTLY=false
        else
                HAS_RUST_NIGHTLY=false
        fi

        NASM_PATH="$(find_bin nasm || true)"
        NASM_VERSION=""
        if [[ -n "${NASM_PATH}" ]]; then
                HAS_NASM=true
                NASM_VERSION="$(nasm --version 2> /dev/null | head -1 || true)"
        else
                HAS_NASM=false
        fi

        LLD_PATH="$(find_bin ld.lld || true)"
        [[ -n "${LLD_PATH}" ]] && HAS_LLD=true || HAS_LLD=false

        CLANG_PATH="$(find_bin clang || true)"
        [[ -n "${CLANG_PATH}" ]] && HAS_CLANG=true || HAS_CLANG=false

        LLVM_PATH="$(find_bin llvm-ar || true)"
        [[ -n "${LLVM_PATH}" ]] && HAS_LLVM=true || HAS_LLVM=false

        COMPILERRT_PATH="$(find_lib libclang_rt.builtins.a "${CLANG_LIB_DIRS[@]}" "${ALL_STATIC_DIRS[@]}" || true)"
        if [[ -z "${COMPILERRT_PATH}" ]]; then
                COMPILERRT_PATH="$(find_lib libclang_rt.builtins-x86_64.a "${CLANG_LIB_DIRS[@]}" "${ALL_STATIC_DIRS[@]}" || true)"
        fi
        [[ -n "${COMPILERRT_PATH}" ]] && HAS_COMPILERRT=true || HAS_COMPILERRT=false

        LIBUNWIND_PATH="$(find_lib libunwind.so "${SYS_LIB_DIRS[@]}" || true)"
        if [[ -z "${LIBUNWIND_PATH}" ]]; then
                LIBUNWIND_PATH="$(find_lib libunwind.a "${ALL_STATIC_DIRS[@]}" || true)"
        fi
        [[ -n "${LIBUNWIND_PATH}" ]] && HAS_LIBUNWIND=true || HAS_LIBUNWIND=false

        HAS_HARD_REQS=true
        for req in HAS_RUST_NIGHTLY HAS_NASM HAS_COMPILERRT HAS_LIBUNWIND HAS_LLD HAS_CLANG HAS_LLVM; do
                [[ "${!req}" == false ]] && {
                        HAS_HARD_REQS=false
                        break
                }
        done

        GLIBC_STATIC_PATH="$(find_lib libc.a "${ALL_STATIC_DIRS[@]}" || true)"
        [[ -n "${GLIBC_STATIC_PATH}" ]] && HAS_GLIBC_STATIC=true || HAS_GLIBC_STATIC=false

        LIBSTDCXX_STATIC_PATH="$(find_lib libstdc++.a "${ALL_STATIC_DIRS[@]}" || true)"
        [[ -n "${LIBSTDCXX_STATIC_PATH}" ]] && HAS_LIBSTDCXX_STATIC=true || HAS_LIBSTDCXX_STATIC=false

        LLVM_LIBUNWIND_STATIC_PATH="$(find_lib libunwind.a "${CLANG_LIB_DIRS[@]}" "${ALL_STATIC_DIRS[@]}" || true)"
        [[ -n "${LLVM_LIBUNWIND_STATIC_PATH}" ]] && HAS_LLVM_LIBUNWIND_STATIC=true || HAS_LLVM_LIBUNWIND_STATIC=false

        COMPILERRT_STATIC_PATH="${COMPILERRT_PATH}"
        [[ -n "${COMPILERRT_STATIC_PATH}" ]] && HAS_COMPILERRT_STATIC=true || HAS_COMPILERRT_STATIC=false

        RUST_SYSROOT="$(rustc --print sysroot 2> /dev/null || true)"
        RUST_STDLIB_PATH=""
        if [[ -n "${RUST_SYSROOT}" ]]; then
                RUST_STDLIB_PATH="$(find "${RUST_SYSROOT}" -name 'libstd-*.rlib' -print -quit 2> /dev/null || true)"
        fi
        [[ -n "${RUST_STDLIB_PATH}" ]] && HAS_RUST_STDLIB=true || HAS_RUST_STDLIB=false

        HAS_STATIC_LIBS=true
        for req in HAS_GLIBC_STATIC HAS_LIBSTDCXX_STATIC HAS_LLVM_LIBUNWIND_STATIC HAS_COMPILERRT_STATIC; do
                [[ "${!req}" == false ]] && {
                        HAS_STATIC_LIBS=false
                        break
                }
        done

        VSHIP_SEARCH_DIRS=(
                "${HOME}/.local/src/Vship"
                "/usr/lib64"
                "/usr/lib"
                "/usr/local/lib64"
                "/usr/local/lib"
                "/lib64"
                "/lib"
        )
        VSHIP_STATIC_PATH="$(find_lib libvship.a "${VSHIP_SEARCH_DIRS[@]}" || true)"
        [[ -n "${VSHIP_STATIC_PATH}" ]] && HAS_VSHIP_STATIC=true || HAS_VSHIP_STATIC=false

        SVT_SEARCH_DIRS=(
                "${HOME}/.local/src/svt-av1-hdr/Bin/Release"
                "${HOME}/.local/src/SVT-AV1/Bin/Release"
                "/usr/lib64"
                "/usr/lib"
                "/usr/local/lib64"
                "/usr/local/lib"
                "/lib64"
                "/lib"
        )
        SVT_STATIC_PATH="$(find_lib libSvtAv1Enc.a "${SVT_SEARCH_DIRS[@]}" || true)"
        [[ -n "${SVT_STATIC_PATH}" ]] && HAS_SVT_STATIC=true || HAS_SVT_STATIC=false

        FFMS2_PATH="$(find_lib libffms2.so "${SYS_LIB_DIRS[@]}" || true)"
        [[ -n "${FFMS2_PATH}" ]] && HAS_FFMS2=true || HAS_FFMS2=false

        VSHIP_PATH="$(find_lib libvship.so "${SYS_LIB_DIRS[@]}" || true)"
        [[ -n "${VSHIP_PATH}" ]] && HAS_VSHIP=true || HAS_VSHIP=false

        FFMPEG_PATH="$(find_bin ffmpeg || true)"
        FFMPEG_VERSION=""
        if [[ -n "${FFMPEG_PATH}" ]]; then
                HAS_FFMPEG=true
                FFMPEG_VERSION="$(ffmpeg -version 2> /dev/null | head -1 || true)"
        else
                HAS_FFMPEG=false
        fi

        MP4BOX_PATH="$(find_bin MP4Box || true)"
        MP4BOX_VERSION=""
        if [[ -n "${MP4BOX_PATH}" ]]; then
                HAS_MP4BOX=true
                MP4BOX_VERSION="$(MP4Box -version 2>&1 | head -1 || true)"
        else
                HAS_MP4BOX=false
        fi

        MKVMERGE_PATH="$(find_bin mkvmerge || true)"
        MKVMERGE_VERSION=""
        if [[ -n "${MKVMERGE_PATH}" ]]; then
                HAS_MKVMERGE=true
                MKVMERGE_VERSION="$(mkvmerge --version 2> /dev/null | head -1 || true)"
        else
                HAS_MKVMERGE=false
        fi

        SVTAV1ENC_PATH="$(find_bin SvtAv1EncApp || true)"
        SVTAV1ENC_VERSION=""
        if [[ -n "${SVTAV1ENC_PATH}" ]]; then
                HAS_SVTAV1ENC=true
                SVTAV1ENC_VERSION="$(SvtAv1EncApp --version 2>&1 | head -1 || true)"
        else
                HAS_SVTAV1ENC=false
        fi

        AVMENC_PATH="$(find_bin avmenc || true)"
        AVMENC_VERSION=""
        if [[ -n "${AVMENC_PATH}" ]]; then
                HAS_AVMENC=true
                AVMENC_VERSION="$(avmenc --help 2>&1 | head -1 || true)"
        else
                HAS_AVMENC=false
        fi

        VVENCFFAPP_PATH="$(find_bin vvencFFapp || true)"
        VVENCFFAPP_VERSION=""
        if [[ -n "${VVENCFFAPP_PATH}" ]]; then
                HAS_VVENCFFAPP=true
                VVENCFFAPP_VERSION="$(vvencFFapp --version 2>&1 | head -1 || true)"
        else
                HAS_VVENCFFAPP=false
        fi

        X265_PATH="$(find_bin x265 || true)"
        X265_VERSION=""
        if [[ -n "${X265_PATH}" ]]; then
                HAS_X265=true
                X265_VERSION="$(x265 --version 2>&1 | head -1 || true)"
        else
                HAS_X265=false
        fi

        X264_PATH="$(find_bin x264 || true)"
        X264_VERSION=""
        if [[ -n "${X264_PATH}" ]]; then
                HAS_X264=true
                X264_VERSION="$(x264 --version 2>&1 | head -1 || true)"
        else
                HAS_X264=false
        fi

        ELIGIBLE=()
        if [[ "${HAS_HARD_REQS}" == true ]]; then
                [[ "${HAS_STATIC_LIBS}" == true && "${HAS_VSHIP_STATIC}" == true ]] && ELIGIBLE+=(true) || ELIGIBLE+=(false)
                [[ "${HAS_FFMS2}" == true && "${HAS_VSHIP}" == true ]] && ELIGIBLE+=(true) || ELIGIBLE+=(false)
                [[ "${HAS_STATIC_LIBS}" == true ]] && ELIGIBLE+=(true) || ELIGIBLE+=(false)
                [[ "${HAS_FFMS2}" == true ]] && ELIGIBLE+=(true) || ELIGIBLE+=(false)
                [[ "${HAS_STATIC_LIBS}" == true && "${HAS_VSHIP_STATIC}" == true && "${HAS_SVT_STATIC}" == true ]] && ELIGIBLE+=(true) || ELIGIBLE+=(false)
                [[ "${HAS_STATIC_LIBS}" == true && "${HAS_SVT_STATIC}" == true ]] && ELIGIBLE+=(true) || ELIGIBLE+=(false)
                [[ "${HAS_FFMS2}" == true && "${HAS_VSHIP}" == true && "${HAS_SVT_STATIC}" == true ]] && ELIGIBLE+=(true) || ELIGIBLE+=(false)
                [[ "${HAS_FFMS2}" == true && "${HAS_SVT_STATIC}" == true ]] && ELIGIBLE+=(true) || ELIGIBLE+=(false)
        else
                ELIGIBLE=(false false false false false false false false)
        fi
}

dep_status() {
        local has="${1}" path="${2}" ver="${3:-}"
        local NF="${R}  Not Found${N}"

        if [[ "${has}" == true ]]; then
                [[ -n "${ver}" ]] && echo -e "${G}✅ ${path} ${W}(${ver})${N}" || echo -e "${G}✅ ${path}${N}"
        else
                echo -e "${NF}"
        fi
}

dep_status_locations() {
        local has="${1}" path="${2}"
        shift 2
        local search_dirs=("${@}")

        if [[ "${has}" == true ]]; then
                echo -e "${G}✅ ${path}${N}"
        else
                echo -e "${R}  Not Found in:${N}"
                for dir in "${search_dirs[@]}"; do
                        echo -e "      ${R}- ${dir}${N}"
                done
        fi
}

show_build_menu() {
        detect_deps

        echo -e "${C}╔═══════════════════════════════════════════════════════════════════════╗${N}"
        echo -e "${C}║${W}  Required Compiler Toolchain (needed for all build types)             ${C}║${N}"
        echo -e "${C}╚═══════════════════════════════════════════════════════════════════════╝${N}"
        printf "  ${Y}%-30b${N} %b\n" "Rust Nightly:" "$(dep_status "${HAS_RUST_NIGHTLY}" "${RUST_NIGHTLY_PATH}" "${RUSTC_VERSION}")"
        printf "  ${Y}%-30b${N} %b\n" "NASM:" "$(dep_status "${HAS_NASM}" "${NASM_PATH}" "${NASM_VERSION}")"
        printf "  ${Y}%-30b${N} %b\n" "compiler-rt:" "$(dep_status "${HAS_COMPILERRT}" "${COMPILERRT_PATH}")"
        printf "  ${Y}%-30b${N} %b\n" "libunwind:" "$(dep_status "${HAS_LIBUNWIND}" "${LIBUNWIND_PATH}")"
        printf "  ${Y}%-30b${N} %b\n" "lld:" "$(dep_status "${HAS_LLD}" "${LLD_PATH}")"
        printf "  ${Y}%-30b${N} %b\n" "clang:" "$(dep_status "${HAS_CLANG}" "${CLANG_PATH}")"
        printf "  ${Y}%-30b${N} %b\n" "llvm:" "$(dep_status "${HAS_LLVM}" "${LLVM_PATH}")"
        echo

        echo -e "${C}╔═══════════════════════════════════════════════════════════════════════╗${N}"
        echo -e "${C}║${W}  Fully Static Build Time Requirements                                 ${C}║${N}"
        echo -e "${C}╚═══════════════════════════════════════════════════════════════════════╝${N}"
        printf "  ${Y}%-30b${N} %b\n" "Glibc static:" "$(dep_status "${HAS_GLIBC_STATIC}" "${GLIBC_STATIC_PATH}")"
        printf "  ${Y}%-30b${N} %b\n" "libstdc++ static:" "$(dep_status "${HAS_LIBSTDCXX_STATIC}" "${LIBSTDCXX_STATIC_PATH}")"
        printf "  ${Y}%-30b${N} %b\n" "llvm-libunwind static:" "$(dep_status "${HAS_LLVM_LIBUNWIND_STATIC}" "${LLVM_LIBUNWIND_STATIC_PATH}")"
        printf "  ${Y}%-30b${N} %b\n" "compiler-rt static:" "$(dep_status "${HAS_COMPILERRT_STATIC}" "${COMPILERRT_STATIC_PATH}")"
        printf "  ${Y}%-30b${N} %b\n" "Rust STDLIB static:" "$(dep_status "${HAS_RUST_STDLIB}" "${RUST_STDLIB_PATH}")"
        printf "  ${Y}%-30b${N} %b\n" "(Optional) SVT-AV1 static:" "$(dep_status_locations "${HAS_SVT_STATIC}" "${SVT_STATIC_PATH}" "${SVT_SEARCH_DIRS[@]}")"
        printf "  ${Y}%-30b${N} %b\n" "(Optional) VSHIP static:" "$(dep_status_locations "${HAS_VSHIP_STATIC}" "${VSHIP_STATIC_PATH}" "${VSHIP_SEARCH_DIRS[@]}")"
        echo

        echo -e "${C}╔═══════════════════════════════════════════════════════════════════════╗${N}"
        echo -e "${C}║${W}  Dynamic Build Requirements                                           ${C}║${N}"
        echo -e "${C}╚═══════════════════════════════════════════════════════════════════════╝${N}"
        printf "  ${Y}%-30b${N} %b\n" "FFMS2:" "$(dep_status "${HAS_FFMS2}" "${FFMS2_PATH}")"
        printf "  ${Y}%-30b${N} %b\n" "(Optional) VSHIP:" "$(dep_status "${HAS_VSHIP}" "${VSHIP_PATH}")"
        printf "  ${Y}%-30b${N} %b\n" "(Optional) SVT-AV1 static:" "$(dep_status_locations "${HAS_SVT_STATIC}" "${SVT_STATIC_PATH}" "${SVT_SEARCH_DIRS[@]}")"
        echo -e "  ${P}Note: Even with dynamic builds, SVT-AV1 library (libSvtAv1Enc.a) is linked statically.${N}"
        echo

        echo -e "${C}╔═══════════════════════════════════════════════════════════════════════╗${N}"
        echo -e "${C}║${W}  Runtime Requirements                                                 ${C}║${N}"
        echo -e "${C}╚═══════════════════════════════════════════════════════════════════════╝${N}"
        printf "  ${Y}%-30b${N} %b\n" "ffmpeg (Always needed for final muxing and audio encoding):" " $(dep_status "${HAS_FFMPEG}" "${FFMPEG_PATH}" "${FFMPEG_VERSION}")"
        printf "  ${Y}%-30b${N} %b\n" "(Optional) MP4Box (create VVC timestamps):                 " " $(dep_status "${HAS_MP4BOX}" "${MP4BOX_PATH}" "${MP4BOX_VERSION}")"
        printf "  ${Y}%-30b${N} %b\n" "(Optional) mkvmerge (create h26* timestamps):" "               $(dep_status "${HAS_MKVMERGE}" "${MKVMERGE_PATH}" "${MKVMERGE_VERSION}")"
        echo
        echo -e "  ${W}Encoder Binaries (Optional):${N}"
        printf "  ${Y}%-30b${N} %b\n" "SvtAv1EncApp:" "$(dep_status "${HAS_SVTAV1ENC}" "${SVTAV1ENC_PATH}" "${SVTAV1ENC_VERSION}")"
        printf "  ${Y}%-30b${N} %b\n" "avmenc:" "$(dep_status "${HAS_AVMENC}" "${AVMENC_PATH}" "${AVMENC_VERSION}")"
        printf "  ${Y}%-30b${N} %b\n" "vvencFFapp:" "$(dep_status "${HAS_VVENCFFAPP}" "${VVENCFFAPP_PATH}" "${VVENCFFAPP_VERSION}")"
        printf "  ${Y}%-30b${N} %b\n" "x265:" "$(dep_status "${HAS_X265}" "${X265_PATH}" "${X265_VERSION}")"
        printf "  ${Y}%-30b${N} %b\n" "x264:" "$(dep_status "${HAS_X264}" "${X264_PATH}" "${X264_VERSION}")"
        echo

        echo -e "\n${C}╔═══════════════════════════════════════════════════════════════════════╗${N}"
        echo -e "${C}║${W}                         Build Configuration                           ${C}║${N}"
        echo -e "${C}╚═══════════════════════════════════════════════════════════════════════╝${N}\n"

        echo -e "  ${W}[x]${N} ${Y}= Eligible to build${N}\n"

        for i in "${!BUILD_MODES[@]}"; do
                local idx=$((i + 1))
                if [[ "${ELIGIBLE[i]}" == true ]]; then
                        printf "  ${G}[x] ${Y}%d) ${P}%b${N}\n" "${idx}" "${BUILD_MODES[i]}"
                else
                        printf "  ${R}[ ] ${Y}%d) ${P}%b${N}\n" "${idx}" "${BUILD_MODES[i]}"
                fi
        done
        echo

        for i in "${!BUILD_DESCS[@]}"; do
                printf "  ${Y}%d) ${P}%b${N}\n" "$((i + 1))" "${BUILD_DESCS[i]}"
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
                --enable-demuxer=flv \
                --enable-demuxer=avi \
                --enable-demuxer=ivf \
                --enable-demuxer=yuv4mpegpipe \
                --enable-demuxer=h264 \
                --enable-demuxer=hevc \
                --enable-demuxer=vvc \
                --enable-decoder=rawvideo \
                --enable-decoder=h264 \
                --enable-decoder=hevc \
                --enable-decoder=mpeg2video \
                --enable-decoder=mpeg1video \
                --enable-decoder=mpeg4 \
                --enable-decoder=av1 \
                --enable-decoder=libdav1d \
                --enable-decoder=vp9 \
                --enable-decoder=vc1 \
                --enable-decoder=vvc \
                --enable-libdav1d \
                --enable-parser=h264 \
                --enable-parser=hevc \
                --enable-parser=mpeg4video \
                --enable-parser=mpegvideo \
                --enable-parser=av1 \
                --enable-parser=vp9 \
                --enable-parser=vvc \
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
-mllvm -enable-loop-distribute \
-mllvm -enable-unroll-and-jam \
-mllvm -polly-ast-use-context \
-mllvm -polly-invariant-load-hoisting \
-mllvm -polly-run-inliner \
-mllvm -polly-run-dce"

        export COMMON_FLAGS="-O3 -march=native -mtune=native -flto=thin -pipe -fno-math-errno -fomit-frame-pointer -fno-semantic-interposition -fno-stack-protector -fno-stack-clash-protection -fno-sanitize=all -fno-dwarf2-cfi-asm ${POLLY_FLAGS:-} -static -fno-pic -fno-pie"
        export CFLAGS="${COMMON_FLAGS}"
        export CXXFLAGS="${COMMON_FLAGS} -stdlib=${selected_cxx}"
        export LDFLAGS="-fuse-ld=lld -rtlib=compiler-rt -unwindlib=libunwind -Wl,-O3 -Wl,--lto-O3 -Wl,--as-needed -Wl,-z,norelro -Wl,--build-id=none -Wl,--relax -Wl,-z,noseparate-code -Wl,--strip-all -Wl,--no-eh-frame-hdr -Wl,-znow -Wl,--gc-sections -Wl,--discard-all -Wl,--icf=safe -static -fno-pic -fno-pie"
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
                static_tq_lib)
                        mode_choice=5
                        polly="ON"
                        ;;
                static_notq_lib)
                        mode_choice=6
                        polly="ON"
                        ;;
                dynamic_tq_lib)
                        mode_choice=7
                        ;;
                dynamic_notq_lib)
                        mode_choice=8
                        ;;
                "") ;;
                *)
                        echo -e "Unknown preset: $preset"
                        echo "Valid presets:"
                        echo "  static_tq"
                        echo "  dynamic_tq"
                        echo "  static_notq"
                        echo "  dynamic_notq"
                        echo "  static_tq_lib"
                        echo "  static_notq_lib"
                        echo "  dynamic_tq_lib"
                        echo "  dynamic_notq_lib"
                        exit 1
                        ;;
        esac

        BUILD_MODES=(
                "Build everything statically with TQ"
                "Build dynamically with TQ"
                "Build statically without TQ"
                "Build dynamically without TQ"
                "Build statically with TQ + libsvtav1"
                "Build statically without TQ + libsvtav1"
                "Build dynamically with TQ + libsvtav1"
                "Build dynamically without TQ + libsvtav1"
        )

        BUILD_DESCS=(
                "Clone and compile ${G}decoder${P} libraries, ${G}zlib${P}, ${G}ffms2${P} and ${G}xav${P}; all statically (you need to have the static library for ${G}vship${P} yourself)."
                "Just compile ${G}xav${P} by using ${G}ffms2${P} / ${G}vship${P} libraries from your system."
                "Clone and compile ${G}decoder${P} libraries, ${G}zlib${P}, ${G}ffms2${P} and ${G}xav${P} (without target quality feature)."
                "Just compile ${G}xav${P} by using ${G}ffms2${P} library from your system (without target quality feature)."
                "Clone and compile ${G}decoder${P} libraries, ${G}zlib${P}, ${G}ffms2${P} and ${G}xav${P}; all statically (you need to have the static libraries for ${G}vship${P} and ${G}libsvtav1${P} yourself)."
                "Clone and compile ${G}decoder${P} libraries, ${G}zlib${P}, ${G}ffms2${P} and ${G}xav${P}; all statically (you need to have the static library for ${G}libsvtav1${P} yourself) without TQ."
                "Just compile ${G}xav${P} by using ${G}ffms2${P} / ${G}vship${P} / ${G}libsvtav1${P} libraries from your system."
                "Just compile ${G}xav${P} by using ${G}ffms2${P} / ${G}libsvtav1${P} libraries from your system without TQ."
        )

        [[ "${preset}" ]] || {
                show_build_menu

                while true; do
                        echo -ne "${C}Build Mode: ${N}"
                        read -r mode_choice
                        [[ "${mode_choice}" =~ ^[1-8]$ ]] && {
                                if [[ "${ELIGIBLE[mode_choice - 1]}" == false ]]; then
                                        echo -e "${R}Mode ${mode_choice} is not eligible on this system.${N}"
                                        continue
                                fi
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
                5)
                        config_file=".cargo/config.toml.static"
                        cargo_features="--features static,vship,libsvtav1"
                        build_static=true
                        ;;
                6)
                        config_file=".cargo/config.toml.static_notq"
                        cargo_features="--features static,libsvtav1"
                        build_static=true
                        ;;
                7)
                        config_file=".cargo/config.toml.dynamic"
                        cargo_features="--features vship,libsvtav1"
                        build_static=false
                        ;;
                8)
                        config_file=".cargo/config.toml.dynamic_notq"
                        cargo_features="--features libsvtav1"
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
                export FFMS_INCLUDE_DIR="${BUILD_DIR}/ffms2/include"
                export FFMS_LIB_DIR="${BUILD_DIR}/ffms2/src/core/.libs"
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
