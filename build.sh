#!/usr/bin/env bash

set -Eeuo pipefail

install_deps() {
        ((UID != 0)) && { for i in sudo doas; do command -v "${i}" > /dev/null 2>&1 && priv="${i}"; done; }

        for i in pacman dnf emerge; do command -v "${i}" > /dev/null 2>&1 && pm="${i}"; done

        case "${pm}" in
                "pacman")
                        pkgs=(base-devel rustup nasm clang compiler-rt cmake ffms2 llvm lld ninja)
                        "${priv:-}" pacman -S --needed --noconfirm "${pkgs[@]}"
                        ;;
                "dnf")
                        pkgs=(
                                glibc-static libstdc++-static nasm rustup clang clang-libs
                                llvm lld compiler-rt llvm-libunwind-static autoconf automake
                                libtool cmake ninja-build pkgconf
                        )
                        "${priv:-}" dnf install -y "${pkgs[@]}"
                        ;;
                "emerge")
                        echo "You need Rust Nightly (-9999), nasm, clang/llvm toolchain"
                        echo "USEFLAGS needed for toolchain: atomic-builtins profile static-libs sanitize compiler-rt"
                        ;;
                *)
                        echo "ERROR: You need Rust Nightly, nasm, clang/llvm/lld/compiler-rt toolchain and FFMS2"
                        ;;
        esac

        command -v rustup > /dev/null 2>&1 && {
                rustup toolchain install nightly
                rustup default nightly
                rustup update
        }
}

cargo clean > /dev/null 2>&1
rm -f Cargo.lock

BUILD_DIR="${HOME}/.local/src"
XAV_DIR="$(pwd)"

R='\e[1;91m' B='\e[1;94m' P='\e[1;95m' Y='\e[1;93m'
N='\033[0m' C='\e[1;96m' G='\e[1;92m' W='\e[1;97m'

loginf() {
        sleep "0.1"

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

        LIBUNWIND_STATIC_PATH="$(find_lib libunwind.a "${CLANG_LIB_DIRS[@]}" "${ALL_STATIC_DIRS[@]}" || true)"
        [[ -n "${LIBUNWIND_STATIC_PATH}" ]] && HAS_LIBUNWIND_STATIC=true || HAS_LIBUNWIND_STATIC=false

        COMPILERRT_STATIC_PATH="${COMPILERRT_PATH}"
        [[ -n "${COMPILERRT_STATIC_PATH}" ]] && HAS_COMPILERRT_STATIC=true || HAS_COMPILERRT_STATIC=false

        RUST_SYSROOT="$(rustc --print sysroot 2> /dev/null || true)"
        RUST_STDLIB_PATH=""
        if [[ -n "${RUST_SYSROOT}" ]]; then
                RUST_STDLIB_PATH="$(find "${RUST_SYSROOT}" -name 'libstd-*.rlib' -print -quit 2> /dev/null || true)"
        fi
        [[ -n "${RUST_STDLIB_PATH}" ]] && HAS_RUST_STDLIB=true || HAS_RUST_STDLIB=false

        HAS_STATIC_LIBS=true
        for req in HAS_GLIBC_STATIC HAS_LIBSTDCXX_STATIC HAS_LIBUNWIND_STATIC HAS_COMPILERRT_STATIC; do
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

        LLVM_LIB_DIRS=()
        while IFS= read -r d; do
                LLVM_LIB_DIRS+=("${d}")
        done < <(find /usr/lib/llvm /usr/lib64/llvm -maxdepth 3 -type d -name "lib64" -o -type d -name "lib" 2> /dev/null || true)
        POLLY_PATH="$(find_lib libPolly.so "${SYS_LIB_DIRS[@]}" "${LLVM_LIB_DIRS[@]}" || true)"
        [[ -z "${POLLY_PATH}" ]] && POLLY_PATH="$(find_lib LLVMPolly.so "${SYS_LIB_DIRS[@]}" "${LLVM_LIB_DIRS[@]}" || true)"
        [[ -n "${POLLY_PATH}" ]] && HAS_POLLY=true || HAS_POLLY=false

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
                [[ "${HAS_STATIC_LIBS}" == true && "${HAS_VSHIP_STATIC}" == true ]] && ELIGIBLE+=(true) || ELIGIBLE+=(false)
                [[ "${HAS_STATIC_LIBS}" == true ]] && ELIGIBLE+=(true) || ELIGIBLE+=(false)
                [[ "${HAS_FFMS2}" == true && "${HAS_VSHIP}" == true ]] && ELIGIBLE+=(true) || ELIGIBLE+=(false)
                [[ "${HAS_FFMS2}" == true ]] && ELIGIBLE+=(true) || ELIGIBLE+=(false)
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
        [[ ! " ${ELIGIBLE[*]} " =~ " true " ]] && install_deps && detect_deps

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
        printf "  ${Y}%-30b${N} %b\n" "libunwind static:" "$(dep_status "${HAS_LIBUNWIND_STATIC}" "${LIBUNWIND_STATIC_PATH}")"
        printf "  ${Y}%-30b${N} %b\n" "compiler-rt static:" "$(dep_status "${HAS_COMPILERRT_STATIC}" "${COMPILERRT_STATIC_PATH}")"
        printf "  ${Y}%-30b${N} %b\n" "Rust STDLIB static:" "$(dep_status "${HAS_RUST_STDLIB}" "${RUST_STDLIB_PATH}")"
        printf "  ${Y}%-30b${N} %b\n" "(Optional) VSHIP static:" "$(dep_status_locations "${HAS_VSHIP_STATIC}" "${VSHIP_STATIC_PATH}" "${VSHIP_SEARCH_DIRS[@]}")"
        echo

        echo -e "${C}╔═══════════════════════════════════════════════════════════════════════╗${N}"
        echo -e "${C}║${W}  Dynamic Build Requirements                                           ${C}║${N}"
        echo -e "${C}╚═══════════════════════════════════════════════════════════════════════╝${N}"
        printf "  ${Y}%-30b${N} %b\n" "FFMS2:" "$(dep_status "${HAS_FFMS2}" "${FFMS2_PATH}")"
        printf "  ${Y}%-30b${N} %b\n" "(Optional) VSHIP:" "$(dep_status "${HAS_VSHIP}" "${VSHIP_PATH}")"
        echo

        echo -e "${C}╔═══════════════════════════════════════════════════════════════════════╗${N}"
        echo -e "${C}║${W}  Runtime Requirements                                                 ${C}║${N}"
        echo -e "${C}╚═══════════════════════════════════════════════════════════════════════╝${N}"
        printf "  ${Y}%-30b${N} %b\n" "ffmpeg (Always needed for final muxing):" " $(dep_status "${HAS_FFMPEG}" "${FFMPEG_PATH}" "${FFMPEG_VERSION}")"
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
        local dirs=("dav1d" "FFmpeg" "ffms2" "zlib" "opus" "libopusenc" "SVT-AV1")
        local found=()

        for dir in "${dirs[@]}"; do
                [[ -d "${BUILD_DIR}/${dir}" ]] && found+=("${dir}")
        done

        [[ ${#found[@]} -eq 0 ]] && return

        echo -e "\n${Y}Found existing build directories:${N}"
        printf "  ${P}- %s${N}\n" "${found[@]}"

        if [[ -n "${preset}" ]]; then
                loginf b "Using existing builds"
        else
                echo -ne "\n${C}Remove and rebuild? (y/n): ${N}"
                read -r choice

                [[ "${choice}" =~ ^[Yy]$ ]] && {
                        for dir in "${found[@]}"; do
                                loginf b "Removing ${BUILD_DIR}/${dir}"
                                rm -rf "${BUILD_DIR:?}/${dir}" > "/dev/null" 2>&1
                        done
                        loginf g "Cleanup complete"
                } || loginf b "Using existing builds"
        fi

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
                --enable-decoder=aac \
                --enable-decoder=aac_latm \
                --enable-decoder=ac3 \
                --enable-decoder=eac3 \
                --enable-decoder=dca \
                --enable-decoder=truehd \
                --enable-decoder=mlp \
                --enable-decoder=mp1 \
                --enable-decoder=mp1float \
                --enable-decoder=mp2 \
                --enable-decoder=mp2float \
                --enable-decoder=mp3 \
                --enable-decoder=mp3float \
                --enable-decoder=opus \
                --enable-decoder=vorbis \
                --enable-decoder=flac \
                --enable-decoder=alac \
                --enable-decoder=ape \
                --enable-decoder=tak \
                --enable-decoder=tta \
                --enable-decoder=wavpack \
                --enable-decoder=wmalossless \
                --enable-decoder=wmapro \
                --enable-decoder=wmav1 \
                --enable-decoder=wmav2 \
                --enable-decoder=mpc7 \
                --enable-decoder=mpc8 \
                --enable-decoder=dsd_lsbf \
                --enable-decoder=dsd_lsbf_planar \
                --enable-decoder=dsd_msbf \
                --enable-decoder=dsd_msbf_planar \
                --enable-decoder=pcm_s16le \
                --enable-decoder=pcm_s16be \
                --enable-decoder=pcm_s24le \
                --enable-decoder=pcm_s24be \
                --enable-decoder=pcm_s32le \
                --enable-decoder=pcm_s32be \
                --enable-decoder=pcm_f32le \
                --enable-decoder=pcm_f32be \
                --enable-decoder=pcm_f64le \
                --enable-decoder=pcm_f64be \
                --enable-decoder=pcm_bluray \
                --enable-decoder=pcm_dvd \
                --enable-libdav1d \
                --enable-parser=h264 \
                --enable-parser=hevc \
                --enable-parser=mpeg4video \
                --enable-parser=mpegvideo \
                --enable-parser=av1 \
                --enable-parser=vp9 \
                --enable-parser=vvc \
                --enable-parser=vc1 \
                --enable-parser=aac \
                --enable-parser=ac3 \
                --enable-parser=dca \
                --enable-parser=mpegaudio \
                --enable-parser=opus \
                --enable-parser=vorbis \
                --enable-parser=flac >> "${logfile}" 2>&1

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

build_opus() {
        [[ -d "${BUILD_DIR}/opus" ]] && return

        loginf b "Building opus"

        local logfile="/tmp/build_opus_$.log"

        git clone https://gitlab.xiph.org/xiph/opus.git "${BUILD_DIR}/opus" > "${logfile}" 2>&1
        cd "${BUILD_DIR}/opus"
        cmake -B build -G Ninja \
                -DCMAKE_BUILD_TYPE=Release \
                -DCMAKE_INSTALL_PREFIX="${BUILD_DIR}/opus/install" \
                -DCMAKE_C_COMPILER="${CC}" \
                -DCMAKE_C_FLAGS="${CFLAGS}" \
                -DCMAKE_INSTALL_LIBDIR=lib \
                -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY \
                -DOPUS_BUILD_TESTING=OFF \
                -DOPUS_BUILD_SHARED_LIBRARY=OFF \
                -DOPUS_BUILD_PROGRAMS=OFF \
                -DOPUS_ENABLE_FLOAT_API=ON \
                -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=TRUE >> "${logfile}" 2>&1
        ninja -C build >> "${logfile}" 2>&1
        ninja -C build install >> "${logfile}" 2>&1 && {
                rm -f "${logfile}"
                loginf g "opus built successfully"
        } || {
                echo -e "\n${R}Build failed! Output:${N}\n"
                cat "${logfile}"
                rm -f "${logfile}"
                exit 1
        }
}

build_opusenc() {
        [[ -d "${BUILD_DIR}/libopusenc" ]] && return

        loginf b "Building libopusenc"

        local logfile="/tmp/build_opusenc_$.log"

        git clone https://gitlab.xiph.org/xiph/libopusenc.git "${BUILD_DIR}/libopusenc" > "${logfile}" 2>&1
        cd "${BUILD_DIR}/libopusenc"
        ./autogen.sh >> "${logfile}" 2>&1
        PKG_CONFIG_PATH="${BUILD_DIR}/opus/install/lib/pkgconfig" \
                CC="${CC}" \
                CFLAGS="${CFLAGS} -I${BUILD_DIR}/opus/install/include" \
                LDFLAGS="-L${BUILD_DIR}/opus/install/lib" \
                ./configure \
                --enable-static \
                --disable-shared \
                --disable-doc \
                --disable-examples \
                --prefix="${BUILD_DIR}/libopusenc/install" >> "${logfile}" 2>&1
        make -j"$(nproc)" >> "${logfile}" 2>&1
        make install >> "${logfile}" 2>&1 && {
                rm -f "${logfile}"
                loginf g "libopusenc built successfully"
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
                LDFLAGS="-L${BUILD_DIR}/FFmpeg/install/lib -L${BUILD_DIR}/zlib/install/lib" \
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

build_svtav1() {
        [[ -d "${BUILD_DIR}/SVT-AV1" ]] && return

        loginf b "Building SVT-AV1 (${svt_fork_name})"

        local logfile="/tmp/build_svtav1_$.log"

        git clone "${svt_fork_url}" "${BUILD_DIR}/SVT-AV1" > "${logfile}" 2>&1
        cd "${BUILD_DIR}/SVT-AV1"

        sed -i 's/set(CMAKE_POSITION_INDEPENDENT_CODE ON)/set(CMAKE_POSITION_INDEPENDENT_CODE OFF)/' CMakeLists.txt
        sed -i 's/set(CMAKE_C_STANDARD 99)/set(CMAKE_C_STANDARD 23)/' CMakeLists.txt
        sed -i 's/set(CMAKE_CXX_STANDARD 11)/set(CMAKE_CXX_STANDARD 23)/' CMakeLists.txt
        sed -i '/relro/s/^/#/' CMakeLists.txt
        sed -i '/mno-avx/s/^/#/' CMakeLists.txt
        sed -i '/fstack-protector-strong/s/^/#/' CMakeLists.txt
        sed -i '/FORTIFY_SOURCE/s/^/#/' CMakeLists.txt
        sed -i '/gdwarf/s/^/#/' CMakeLists.txt
        sed -i '/gnull/s/^/#/' CMakeLists.txt

        cd Build/linux
        grep -q avx512f /proc/cpuinfo && HAS_512="enable-avx512" || HAS_512="disable-avx512"
        export LLVM_PROFILE_FILE="${BUILD_DIR}/SVT-AV1/Build/linux/Release/%p.profraw"
        ./build.sh asm=nasm static enable-lto "${HAS_512}" native jobs="$(nproc)" release verbose log-quiet enable-pgo >> "${logfile}" 2>&1 && {
                rm -f "${logfile}"
                loginf g "SVT-AV1 built successfully"
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

        [[ "${HAS_POLLY}" == true ]] && export POLLY_FLAGS="-mllvm -polly \
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
        export CXXFLAGS="${COMMON_FLAGS} -stdlib=libstdc++"
        unset LDFLAGS
}

SVT_FORK_NAMES=("hdr" "essential" "5fish" "mainline")
SVT_FORK_URLS=(
        "https://github.com/juliobbv-p/svt-av1-hdr"
        "https://github.com/nekotrix/SVT-AV1-Essential"
        "https://github.com/5fish/svt-av1-psy"
        "https://gitlab.com/AOMediaCodec/SVT-AV1"
)

main() {
        preset="${1:-}"
        svt_fork="${2:-}"

        case "$preset" in
                static_tq)
                        mode_choice=1
                        ;;
                dynamic_tq)
                        mode_choice=2
                        ;;
                static_notq)
                        mode_choice=3
                        ;;
                dynamic_notq)
                        mode_choice=4
                        ;;
                static_tq_lib)
                        mode_choice=5
                        ;;
                static_notq_lib)
                        mode_choice=6
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
                "Build statically with TQ"
                "Build dynamically with TQ"
                "Build statically without TQ"
                "Build dynamically without TQ"
                "Build statically with TQ + libsvtav1"
                "Build statically without TQ + libsvtav1"
                "Build dynamically with TQ + libsvtav1"
                "Build dynamically without TQ + libsvtav1"
        )

        BUILD_DESCS=(
                "Clone and compile ${G}decoder${P} libraries, ${G}zlib${P}, ${G}ffms2${P}, ${G}opus${P} and ${G}xav${P}; all statically (you need to have the static library for ${G}vship${P} yourself)."
                "Build ${G}opus${P} and compile ${G}xav${P} by using ${G}ffms2${P} / ${G}vship${P} libraries from your system."
                "Clone and compile ${G}decoder${P} libraries, ${G}zlib${P}, ${G}ffms2${P}, ${G}opus${P} and ${G}xav${P} (without target quality feature)."
                "Build ${G}opus${P} and compile ${G}xav${P} by using ${G}ffms2${P} library from your system (without target quality feature)."
                "Clone and compile ${G}decoder${P} libraries, ${G}zlib${P}, ${G}ffms2${P}, ${G}opus${P}, ${G}SVT-AV1${P} and ${G}xav${P}; all statically (you need to have the static library for ${G}vship${P} yourself)."
                "Clone and compile ${G}decoder${P} libraries, ${G}zlib${P}, ${G}ffms2${P}, ${G}opus${P}, ${G}SVT-AV1${P} and ${G}xav${P}; all statically without TQ."
                "Build ${G}opus${P}, ${G}SVT-AV1${P} and compile ${G}xav${P} by using ${G}ffms2${P} / ${G}vship${P} libraries from your system."
                "Build ${G}opus${P}, ${G}SVT-AV1${P} and compile ${G}xav${P} by using ${G}ffms2${P} library from your system without TQ."
        )

        [[ "${preset}" ]] && detect_deps || {
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
                        cargo_features="--no-default-features --features static,vship"
                        build_static=true
                        ;;
                2)
                        config_file=".cargo/config.toml.dynamic"
                        cargo_features="--no-default-features --features vship"
                        build_static=false
                        ;;
                3)
                        config_file=".cargo/config.toml.static_notq"
                        cargo_features="--no-default-features --features static"
                        build_static=true
                        ;;
                4)
                        config_file=".cargo/config.toml.dynamic_notq"
                        cargo_features="--no-default-features"
                        build_static=false
                        ;;
                5)
                        config_file=".cargo/config.toml.static"
                        cargo_features="--no-default-features --features static,vship,libsvtav1"
                        build_static=true
                        ;;
                6)
                        config_file=".cargo/config.toml.static_notq"
                        cargo_features="--no-default-features --features static,libsvtav1"
                        build_static=true
                        ;;
                7)
                        config_file=".cargo/config.toml.dynamic"
                        cargo_features="--no-default-features --features vship,libsvtav1"
                        build_static=false
                        ;;
                8)
                        config_file=".cargo/config.toml.dynamic_notq"
                        cargo_features="--no-default-features --features libsvtav1"
                        build_static=false
                        ;;
        esac

        use_svtav1=false
        [[ "${mode_choice}" -ge 5 && "${mode_choice}" -le 8 ]] && use_svtav1=true

        if [[ "${use_svtav1}" == true ]]; then
                if [[ -n "${svt_fork}" ]]; then
                        local fork_idx=-1
                        for i in "${!SVT_FORK_NAMES[@]}"; do
                                [[ "${SVT_FORK_NAMES[i]}" == "${svt_fork}" ]] && {
                                        fork_idx="${i}"
                                        break
                                }
                        done
                        [[ "${fork_idx}" -eq -1 ]] && {
                                echo -e "${R}Unknown SVT-AV1 fork: ${svt_fork}${N}"
                                echo "Valid forks: ${SVT_FORK_NAMES[*]}"
                                exit 1
                        }
                else
                        echo -e "\n${C}Select SVT-AV1 fork:${N}"
                        for i in "${!SVT_FORK_NAMES[@]}"; do
                                printf "  ${Y}%d) ${P}%s${N}\n" "$((i + 1))" "${SVT_FORK_NAMES[i]}"
                        done
                        echo
                        while true; do
                                echo -ne "${C}Fork: ${N}"
                                read -r fork_choice
                                [[ "${fork_choice}" =~ ^[1-4]$ ]] && {
                                        fork_idx=$((fork_choice - 1))
                                        break
                                }
                        done
                fi
                svt_fork_name="${SVT_FORK_NAMES[fork_idx]}"
                svt_fork_url="${SVT_FORK_URLS[fork_idx]}"
                loginf g "SVT-AV1 fork: ${svt_fork_name}"
        fi

        cleanup_existing

        setup_toolchain

        build_opus
        build_opusenc

        [[ "${use_svtav1}" == true ]] && build_svtav1

        [[ "${build_static}" == true ]] && {
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
