#!/usr/bin/env bash

((BASH_VERSINFO[0] >= 5)) || {
        echo "You need Bash 5+."
        exit 1
}

set -Eeuo pipefail

has_nvidia() { grep -qx 0x10de /sys/bus/pci/devices/*/vendor 2> /dev/null; }

install_deps() {
        ((UID != 0)) && { for i in sudo doas; do command -v "${i}" > /dev/null 2>&1 && priv="${i}"; done; }

        pm="unknown"
        for i in pacman dnf emerge; do command -v "${i}" > /dev/null 2>&1 && pm="${i}"; done

        case "${pm}" in
                "pacman")
                        pkgs=(base-devel rustup nasm clang compiler-rt cmake llvm lld ninja meson ffmpeg curl gcc)
                        ((${mode_choice:-0} == 1)) && pkgs+=(cuda)
                        mapfile -t needed_pkgs < <(pacman -T "${pkgs[@]}" 2>/dev/null || true)
                        if ((${#needed_pkgs[@]} > 0 && ${#needed_pkgs[0]} > 0)); then
                                ${priv:-} pacman -S --needed --noconfirm "${needed_pkgs[@]}"
                        fi
                        ;;
                "dnf")
                        pkgs=(
                                glibc-static libstdc++-static nasm rustup clang clang-libs
                                llvm lld compiler-rt llvm-libunwind-static autoconf automake
                                libtool cmake ninja-build pkgconf meson ffmpeg curl gcc
                        )
                        ((${mode_choice:-0} == 1)) && pkgs+=(cuda-toolkit)
                        ${priv:-} dnf install -y "${pkgs[@]}"
                        ;;
                "emerge")
                        echo "You need Rust Nightly (-9999), nasm, clang/llvm toolchain"
                        echo "USEFLAGS needed for toolchain: atomic-builtins profile static-libs sanitize compiler-rt"
                        ;;
                *)
                        echo "ERROR: You need Rust Nightly, nasm, clang/llvm/lld/compiler-rt toolchain"
                        ;;
        esac

        command -v rustup > /dev/null 2>&1 && {
                rustup-init || true
                rustup toolchain install nightly
                rustup default nightly
                rustup update
        }
}

BUILD_DIR="${HOME}/.local/src"
mkdir -p "${BUILD_DIR}"
XAV_DIR="$(pwd)"
export PATH="/opt/cuda/bin:/usr/local/cuda/bin:${PATH}"

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
trap 'kill $(jobs -p) 2> /dev/null || true' EXIT

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
        CLANG_RESOURCE_DIR="$(clang -print-resource-dir 2> /dev/null || true)"
        CLANG_LIB_DIRS=()
        [[ -n "${CLANG_RT_DIR}" && -d "${CLANG_RT_DIR}" ]] && CLANG_LIB_DIRS+=("${CLANG_RT_DIR}")
        [[ -n "${CLANG_RESOURCE_DIR}" ]] && CLANG_LIB_DIRS+=(
                "${CLANG_RESOURCE_DIR}/lib/linux"
                "${CLANG_RESOURCE_DIR}/lib"
        )
        while IFS= read -r d; do
                CLANG_LIB_DIRS+=("${d}")
        done < <(find /usr/lib/clang /usr/lib64/clang /usr/lib/llvm /usr/lib64/llvm -type d \( -name "linux" -o -name "lib" \) 2> /dev/null || true)

        ALL_STATIC_DIRS=("${SYS_LIB_DIRS[@]}" "${GCC_LIB_DIRS[@]}" "${CLANG_LIB_DIRS[@]}")

        RUSTC_VERSION="$(rustc --version 2> /dev/null || true)"

        COMPILERRT_PATH=""
        for rt_name in libclang_rt.builtins.a libclang_rt.builtins-x86_64.a libclang_rt.builtins-aarch64.a; do
                COMPILERRT_PATH="$(find_lib "${rt_name}" "${CLANG_LIB_DIRS[@]}" "${ALL_STATIC_DIRS[@]}" || true)"
                [[ -n "${COMPILERRT_PATH}" ]] && break
        done

        HAS_HARD_REQS=true
        [[ "${RUSTC_VERSION}" == *nightly* && -n "${COMPILERRT_PATH}" &&
                -n "$(find_bin nasm)" && -n "$(find_bin ld.lld)" &&
                -n "$(find_bin clang)" && -n "$(find_bin llvm-ar)" ]] || HAS_HARD_REQS=false

        has_nvidia && HW=cuda || HW=vulkan
}

show_build_menu() {
        detect_deps
        "${HAS_HARD_REQS}" || {
                install_deps
                detect_deps
        }

        for i in cargo ffmpeg clang pkgconf ninja meson cmake; do
                command -v "${i}" > /dev/null 2>&1 || {
                        echo "Missing from PATH: ${i}"
                        echo "You should restart your terminal to update PATH"
                        exit 1
                }
        done

        cargo clean > /dev/null 2>&1
        rm -f Cargo.lock

        for i in "${!BUILD_MODES[@]}"; do
                printf "  ${Y}%d) ${P}%b${N}\n" "$((i + 1))" "${BUILD_MODES[i]}"
        done
        echo
}

select_encoders() {
        local n="${#ENCODER_NAMES[@]}" key i e mark

        echo -e "\n${C}Enabled Encoders ${W}(number toggles, enter confirms)${N}"
        printf "  ${G}[X] ${P}SVT-AV1${N}\n"

        while true; do
                for ((i = 0; i < n; i++)); do
                        ((ENC_ON[${ENCODER_FEATS[i]}])) && mark="${G}[X]" || mark="${R}[ ]"
                        printf "  ${mark} ${P}%s ${Y}(%d)${N}\n" "${ENCODER_NAMES[i]}" "$((i + 1))"
                done

                read -rsn1 key
                [[ "${key}" ]] || break
                [[ "${key}" =~ ^[1-9]$ ]] && ((key <= n)) && {
                        e="${ENCODER_FEATS[key - 1]}"
                        ENC_ON["${e}"]=$((1 - ENC_ON[${e}]))
                }
                printf "\e[%dA" "${n}"
        done
}

cleanup_existing() {
        local -A artifacts=(
                [dav1d]="lib/pkgconfig/dav1d.pc"
                [FFmpeg]="install/lib/libavcodec.a"
                [opus]="install/lib/libopus.a"
                ["SVT-AV1"]="Bin/Release/libSvtAv1Enc.a"
                [vulkan]="install/lib/pkgconfig/vulkan.pc"
                ["nv-codec-headers"]="install/lib/pkgconfig/ffnvcodec.pc"
                [Vship]="libvship.a"
                [avm]="build/libavm_full.a"
        )

        local successful=() incomplete=()
        local dir dirs=(dav1d FFmpeg opus SVT-AV1)

        [[ "${HW}" == cuda ]] && dirs+=(nv-codec-headers) || dirs+=(vulkan)
        ((mode_choice == 1)) && dirs+=(Vship)
        ((ENC_ON[avm])) && dirs+=(avm)

        for dir in "${dirs[@]}"; do
                [[ -d "${BUILD_DIR}/${dir}" ]] || continue
                [[ -f "${BUILD_DIR}/${dir}/${artifacts[${dir}]}" ]] && successful+=("${dir}") || incomplete+=("${dir}")
        done

        ((${#successful[@]} == 0 && ${#incomplete[@]} == 0)) && return

        ((${#successful[@]})) && {
                echo -e "\n${G}Successful builds:${N}"
                printf "  ${G}✓ %s${N}\n" "${successful[@]}"
        }

        ((${#incomplete[@]})) && {
                echo -e "\n${Y}Incomplete builds (will be deleted and rebuilt):${N}"
                printf "  ${Y}✗ %s${N}\n" "${incomplete[@]}"
        }

        [[ -z "${preset}" ]] && ((${#successful[@]})) && {
                echo -ne "\n${C}Update them too (re-clone latest from git)? (y/N): ${N}"
                read -r choice
                [[ "${choice}" =~ ^[Yy]$ ]] && {
                        incomplete+=("${successful[@]}")
                        successful=()
                }
        }

        for dir in "${incomplete[@]}"; do
                rm -rf "${BUILD_DIR:?}/${dir}"
        done

        echo
}

clone_async() {
        local target="${1}" url="${2}" extra="${3:-}"
        [[ -d "${target}" ]] && return
        (
                logfile="/tmp/clone_$(basename "${target}")_$$.log"
                git clone ${extra} "${url}" "${target}" > "${logfile}" 2>&1
                rm -f "${logfile}"
        ) &
        pids+=("${!}")
}

clone_phase() {
        loginf b "Cloning repositories in parallel"

        local pids=()

        clone_async "${BUILD_DIR}/opus" "https://gitlab.xiph.org/xiph/opus.git"
        clone_async "${BUILD_DIR}/SVT-AV1" "${svt_fork_url}"
        clone_async "${BUILD_DIR}/dav1d" "https://code.videolan.org/videolan/dav1d.git"
        clone_async "${BUILD_DIR}/FFmpeg" "https://github.com/FFmpeg/FFmpeg"

        [[ "${HW}" == cuda ]] && clone_async "${BUILD_DIR}/nv-codec-headers" "https://github.com/FFmpeg/nv-codec-headers" "--depth 1" || {
                mkdir -p "${BUILD_DIR}/vulkan"
                clone_async "${BUILD_DIR}/vulkan/Vulkan-Headers" "https://github.com/KhronosGroup/Vulkan-Headers.git" "--depth 1"
                clone_async "${BUILD_DIR}/vulkan/Vulkan-Loader" "https://github.com/KhronosGroup/Vulkan-Loader.git" "--depth 1"
        }

        ((mode_choice == 1)) && clone_async "${BUILD_DIR}/Vship" "https://codeberg.org/Line-fr/Vship" "--depth 1"
        ((ENC_ON[avm])) && clone_async "${BUILD_DIR}/avm" "https://github.com/AOMediaCodec/avm" "--depth 1"

        local pid rc=0
        for pid in "${pids[@]}"; do
                wait "${pid}" || rc="${?}"
        done
        ((rc)) && exit 1

        loginf g "Clones complete"
}

build_dav1d() {
        [[ -f "${BUILD_DIR}/dav1d/lib/pkgconfig/dav1d.pc" ]] && return

        loginf b "Building dav1d"

        local logfile="/tmp/build_dav1d_$.log"
        : > "${logfile}"

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

build_vulkan() {
        [[ -f "${BUILD_DIR}/vulkan/install/lib/pkgconfig/vulkan.pc" ]] && return

        loginf b "Building Vulkan (headers + loader)"

        local logfile="/tmp/build_vulkan_$.log"
        local install_dir="${BUILD_DIR}/vulkan/install"
        : > "${logfile}"

        cmake -S "${BUILD_DIR}/vulkan/Vulkan-Headers" -B "${BUILD_DIR}/vulkan/Vulkan-Headers/build" \
                -G Ninja \
                -DCMAKE_INSTALL_PREFIX="${install_dir}" >> "${logfile}" 2>&1
        ninja -C "${BUILD_DIR}/vulkan/Vulkan-Headers/build" install >> "${logfile}" 2>&1

        sed -i 's/add_library(vulkan SHARED)/add_library(vulkan STATIC)/' \
                "${BUILD_DIR}/vulkan/Vulkan-Loader/loader/CMakeLists.txt"
        sed -i '/install(TARGETS vulkan EXPORT/d; /install(EXPORT VulkanLoaderConfig/d' \
                "${BUILD_DIR}/vulkan/Vulkan-Loader/loader/CMakeLists.txt"

        cmake -S "${BUILD_DIR}/vulkan/Vulkan-Loader" -B "${BUILD_DIR}/vulkan/Vulkan-Loader/build" \
                -G Ninja \
                -DCMAKE_BUILD_TYPE=Release \
                -DCMAKE_C_COMPILER="${CC}" \
                -DCMAKE_C_FLAGS="${CFLAGS}" \
                -DCMAKE_INSTALL_PREFIX="${install_dir}" \
                -DCMAKE_INSTALL_LIBDIR=lib \
                -DBUILD_SHARED_LIBS=OFF \
                -DBUILD_WSI_XCB_SUPPORT=OFF \
                -DBUILD_WSI_XLIB_SUPPORT=OFF \
                -DBUILD_WSI_WAYLAND_SUPPORT=OFF \
                -DBUILD_WSI_DIRECTFB_SUPPORT=OFF \
                -DVULKAN_HEADERS_INSTALL_DIR="${install_dir}" \
                -DCMAKE_ASM_COMPILER="${CC}" \
                -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=TRUE >> "${logfile}" 2>&1
        ninja -C "${BUILD_DIR}/vulkan/Vulkan-Loader/build" >> "${logfile}" 2>&1
        mkdir -p "${install_dir}/lib/pkgconfig"
        cp "${BUILD_DIR}/vulkan/Vulkan-Loader/build/loader/libvulkan.a" "${install_dir}/lib/"
        cat > "${install_dir}/lib/pkgconfig/vulkan.pc" <<- VKPC
	prefix=${install_dir}
	includedir=\${prefix}/include
	libdir=\${prefix}/lib

	Name: Vulkan-Loader
	Description: Vulkan Loader
	Version: 1.4
	Libs: -L\${libdir} -lvulkan
	Libs.private: -ldl -lpthread -lm
	Cflags: -I\${includedir}
	VKPC
        [[ -f "${install_dir}/lib/libvulkan.a" ]] && {
                rm -f "${logfile}"
                loginf g "Vulkan built successfully"
        } || {
                echo -e "\n${R}Build failed! Output:${N}\n"
                cat "${logfile}"
                rm -f "${logfile}"
                exit 1
        }
}

build_nvheaders() {
        [[ -f "${BUILD_DIR}/nv-codec-headers/install/lib/pkgconfig/ffnvcodec.pc" ]] && return

        loginf b "Installing nv-codec-headers"

        local logfile="/tmp/build_nvheaders_$.log"
        : > "${logfile}"

        make -C "${BUILD_DIR}/nv-codec-headers" PREFIX="${BUILD_DIR}/nv-codec-headers/install" install >> "${logfile}" 2>&1 && {
                rm -f "${logfile}"
                loginf g "nv-codec-headers installed"
        } || {
                echo -e "\n${R}Build failed! Output:${N}\n"
                cat "${logfile}"
                rm -f "${logfile}"
                exit 1
        }
}

build_vship() {
        [[ -f "${BUILD_DIR}/Vship/libvship.a" ]] && return

        loginf b "Building Vship (${HW})"

        local logfile="/tmp/build_vship_$.log"
        : > "${logfile}"

        cp -f "${XAV_DIR}/vship.mk" "${BUILD_DIR}/Vship/xav.mk"

        make -C "${BUILD_DIR}/Vship" -f xav.mk "build${HW}" >> "${logfile}" 2>&1 && {
                rm -f "${logfile}"
                loginf g "Vship built successfully"
        } || {
                echo -e "\n${R}Build failed! Output:${N}\n"
                cat "${logfile}"
                rm -f "${logfile}"
                exit 1
        }
}

build_ffmpeg() {
        [[ -f "${BUILD_DIR}/FFmpeg/install/lib/libavcodec.a" ]] && return

        loginf b "Building FFmpeg"

        export PKG_CONFIG_PATH="${BUILD_DIR}/dav1d/lib/pkgconfig:${BUILD_DIR}/FFmpeg/install/lib/pkgconfig"

        local logfile="/tmp/build_ffmpeg_$.log"
        : > "${logfile}"

        cd "${BUILD_DIR}/FFmpeg"

        local hw_args=() hw_cflags="" hw_ldflags=""

        [[ "${HW}" == cuda ]] && {
                PKG_CONFIG_PATH+=":${BUILD_DIR}/nv-codec-headers/install/lib/pkgconfig"
                hw_args=(
                        --enable-ffnvcodec
                        --enable-nvdec
                        --enable-cuvid
                        --enable-decoder=h264_cuvid
                        --enable-decoder=hevc_cuvid
                        --enable-decoder=av1_cuvid
                        --enable-decoder=vp9_cuvid
                        --enable-decoder=vc1_cuvid
                )
        } || {
                PKG_CONFIG_PATH+=":${BUILD_DIR}/vulkan/install/lib/pkgconfig"
                hw_cflags=" -I${BUILD_DIR}/vulkan/install/include"
                hw_ldflags=" -L${BUILD_DIR}/vulkan/install/lib"
                hw_args=(
                        --enable-vulkan
                        --enable-vulkan-static
                        --enable-hwaccel=h264_vulkan
                        --enable-hwaccel=hevc_vulkan
                        --enable-hwaccel=av1_vulkan
                        --enable-hwaccel=vp9_vulkan
                )
        }

        ./configure \
                --cc="${CC}" \
                --cxx="${CXX}" \
                --ar="${AR}" \
                --nm="${NM}" \
                --ranlib="${RANLIB}" \
                --strip="${STRIP}" \
                --extra-cflags="${CFLAGS}${hw_cflags}" \
                --extra-cxxflags="${CXXFLAGS}${hw_cflags}" \
                --extra-ldflags="-fuse-ld=lld -flto=thin${hw_ldflags}" \
                --disable-shared \
                --enable-static \
                --pkg-config-flags="--static" \
                --disable-network \
                --disable-autodetect \
                --disable-all \
                --enable-avcodec \
                --enable-avformat \
                --enable-avutil \
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
                --enable-decoder=ffv1 \
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
                --enable-parser=flac \
                --enable-bsf=extract_extradata \
                --enable-demuxer=ogg \
                "${hw_args[@]}" >> "${logfile}" 2>&1

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
        [[ -f "${BUILD_DIR}/opus/install/lib/libopus.a" ]] && return

        loginf b "Building opus"

        local logfile="/tmp/build_opus_$.log"
        : > "${logfile}"

        cd "${BUILD_DIR}/opus"
        cmake -B build -G Ninja \
                -DCMAKE_BUILD_TYPE=Release \
                -DCMAKE_INSTALL_PREFIX="${BUILD_DIR}/opus/install" \
                -DCMAKE_C_COMPILER="${CC}" \
                -DCMAKE_C_FLAGS="${CFLAGS/ -ffast-math/}" \
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

build_svtav1() {
        [[ -f "${BUILD_DIR}/SVT-AV1/Bin/Release/libSvtAv1Enc.a" ]] && return

        loginf b "Building SVT-AV1 (${svt_fork_name})"

        local logfile="/tmp/build_svtav1_$.log"
        local pgo_dir="${BUILD_DIR}/SVT-AV1/pgo"
        : > "${logfile}"

        pgo_params=(
                --preset 1 --tune 0 --keyint 0 --scd 0 --scm 0 --tile-rows 0 --tile-columns 0 --rc 0
                --width 1920 --height 1080 --frames 96 --fps-num 60 --fps-denom 1 --input-depth 10 --profile 0
                --color-format 1 --color-range 0 --color-primaries 1 --transfer-characteristics 1
                --matrix-coefficients 1 --chroma-sample-position 1 --progress 0 --lp 5 --enable-qm 1
                --enable-variance-boost 1 --luminance-qp-bias 0 --sharpness 1
        )

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
        sed -i 's|"${LLVM_PROFDATA} merge --sparse=true \*.profraw -o default.profdata"|"cd ${SVT_AV1_PGO_DIR} \&\& ${LLVM_PROFDATA} merge --sparse=true *.profraw -o default.profdata"|' CMakeLists.txt

        # 8 MB thread stacks (default 1 MiB overflows with PGO)
        sed -i 's|0, // default stack size|8 * 1024 * 1024, // default stack size|' Source/Lib/Codec/svt_threads.c
        sed -i 's|0, // thread active when created|STACK_SIZE_PARAM_IS_A_RESERVATION, // thread active when created|' Source/Lib/Codec/svt_threads.c
        sed -i 's|const size_t min_stack_size = 1024 \* 1024;|const size_t min_stack_size = 8 * 1024 * 1024;|' Source/Lib/Codec/svt_threads.c

        mkdir -p "${pgo_dir}"
        loginf b "Downloading PGO training video"
        curl -L "https://media.xiph.org/video/derf/webm/Netflix_FoodMarket2_4096x2160_60fps_10bit_420.webm" -o "${pgo_dir}/i.webm" >> "${logfile}" 2>&1
        ffmpeg -hide_banner -v error -stats -y -nostdin -i "${pgo_dir}/i.webm" -frames:v 96 -vf "scale=1920:1080:flags=lanczos+accurate_rnd+full_chroma_int:param0=4" -pix_fmt yuv420p10le -strict -1 -f rawvideo "${pgo_dir}/i.yuv" >> "${logfile}" 2>&1
        rm -f "${pgo_dir}/i.webm"

        cd Build/linux
        grep -q avx512f /proc/cpuinfo && HAS_512="enable-avx512" || HAS_512="disable-avx512"
        export LLVM_PROFILE_FILE="${pgo_dir}/%p.profraw"
        loginf b "SVT-AV1 PGO generate"
        ./build.sh asm=nasm static enable-lto "${HAS_512}" native jobs="$(nproc)" release verbose log-quiet enable-pgo pgo-dir="${pgo_dir}" pgo-compile-gen >> "${logfile}" 2>&1
        loginf b "Running PGO training encode"
        "${BUILD_DIR}/SVT-AV1/Bin/Release/SvtAv1EncApp" -i "${pgo_dir}/i.yuv" -b /dev/null "${pgo_params[@]}" >> "${logfile}" 2>&1
        loginf b "SVT-AV1 PGO use"
        ./build.sh asm=nasm static enable-lto "${HAS_512}" native jobs="$(nproc)" release verbose log-quiet enable-pgo pgo-dir="${pgo_dir}" pgo-compile-use >> "${logfile}" 2>&1 && {
                rm -f "${logfile}"
                loginf g "SVT-AV1 built successfully"
                rm -f "${pgo_dir}/i.yuv"
        } || {
                echo -e "\n${R}Build failed! Output:${N}\n"
                cat "${logfile}"
                rm -f "${logfile}"
                exit 1
        }
}

build_avm() {
        [[ -f "${BUILD_DIR}/avm/build/libavm_full.a" ]] && return

        loginf b "Building AVM (AV2 + TFLite)"

        local logfile="/tmp/build_avm_$.log"
        : > "${logfile}"

        cd "${BUILD_DIR}/avm"
        cmake -B build -G Ninja \
                -DCMAKE_BUILD_TYPE=Release \
                -DCMAKE_C_COMPILER="${CC}" \
                -DCMAKE_CXX_COMPILER="${CXX}" \
                -DCMAKE_C_FLAGS="${CFLAGS}" \
                -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
                -DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld -flto=thin" \
                -DBUILD_SHARED_LIBS=OFF \
                -DENABLE_APPS=0 \
                -DENABLE_EXAMPLES=0 \
                -DENABLE_TOOLS=0 \
                -DENABLE_TESTS=0 \
                -DENABLE_DOCS=0 \
                -DENABLE_NASM=1 \
                -DCONFIG_AV2_ENCODER=1 \
                -DCONFIG_AV2_DECODER=0 \
                -DCONFIG_WEBM_IO=0 \
                -DCONFIG_TENSORFLOW_LITE=1 >> "${logfile}" 2>&1
        ninja -C build avm >> "${logfile}" 2>&1

        {
                echo "create build/libavm_full.a"
                echo "addlib build/libavm.a"
                find build -name "*.a" ! -name "libavm.a" ! -name "libavm_full.a" -printf "addlib %p\n"
                echo save
                echo end
        } | "${AR}" -M >> "${logfile}" 2>&1

        [[ -f "${BUILD_DIR}/avm/build/libavm_full.a" ]] && {
                rm -f "${logfile}"
                loginf g "AVM built successfully"
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
        export VULKAN_SDK="${BUILD_DIR}/vulkan/install"

        export COMMON_FLAGS="-O3 -ffast-math -march=native -mtune=native \
	-flto=thin -fno-semantic-interposition \
	-fno-stack-protector -fno-stack-clash-protection -fno-sanitize=all \
	-fno-dwarf2-cfi-asm -fno-pic -fno-pie -fno-unwind-tables \
	-fno-asynchronous-unwind-tables -fno-plt -fno-stack-check \
	-fno-threadsafe-statics -mno-vzeroupper -mno-retpoline -mno-lvi-cfi \
	-mharden-sls=none -mno-lvi-hardening -ftls-model=local-exec \
	-fno-use-cxa-atexit -D_FORTIFY_SOURCE=0"
        export CFLAGS="${COMMON_FLAGS}"
        export CXXFLAGS="${COMMON_FLAGS} -stdlib=libstdc++"
        unset LDFLAGS
}

ENCODER_NAMES=("AVM")
ENCODER_FEATS=("avm")
declare -A ENC_ON=()
for i in "${!ENCODER_FEATS[@]}"; do ENC_ON["${ENCODER_FEATS[i]}"]=0; done

SVT_FORK_NAMES=("hdr" "essential" "mainline")
SVT_FORK_URLS=(
        "https://github.com/juliobbv-p/svt-av1-hdr"
        "https://github.com/nekotrix/SVT-AV1-Essential"
        "https://gitlab.com/AOMediaCodec/SVT-AV1"
)

main() {
        preset="${1:-}"
        svt_fork="${2:-}"
        encoders="${3:-}"

        case "$preset" in
                static_tq) mode_choice=1 ;;
                static_notq) mode_choice=2 ;;
                "") ;;
                *)
                        echo -e "Unknown preset: $preset"
                        echo "Valid presets:"
                        echo "  static_tq"
                        echo "  static_notq"
                        exit 1
                        ;;
        esac

        BUILD_MODES=(
                "With TQ"
                "Without TQ"
        )

        [[ "${preset}" ]] && detect_deps || {
                show_build_menu

                while true; do
                        echo -ne "${C}Build Mode: ${N}"
                        read -r mode_choice
                        [[ "${mode_choice}" =~ ^[1-2]$ ]] && {
                                loginf g "Mode: ${BUILD_MODES[mode_choice - 1]}"
                                break
                        }
                done
        }

        [[ "${preset}" ]] && {
                for e in ${encoders//,/ }; do
                        [[ -v ENC_ON[${e}] ]] || {
                                echo -e "${R}Unknown encoder: ${e}${N}"
                                echo "Valid encoders: ${ENCODER_FEATS[*]}"
                                exit 1
                        }
                        ENC_ON["${e}"]=1
                done
        } || select_encoders

        config_file=".cargo/config.toml.static"

        case "${mode_choice}" in
                1)
                        [[ "${HW}" == cuda ]] && feats="vship,cuda" || feats="vship"
                        ;;
                2)
                        [[ "${HW}" == cuda ]] && feats="cuda" || feats=""
                        ;;
        esac
        cargo_features="--no-default-features${feats:+ --features ${feats}}"

        enc_list="SVT-AV1"
        for i in "${!ENCODER_FEATS[@]}"; do
                ((ENC_ON[${ENCODER_FEATS[i]}])) && {
                        enc_list+=", ${ENCODER_NAMES[i]}"
                        cargo_features+=" --features ${ENCODER_FEATS[i]}"
                }
        done
        loginf g "Encoders: ${enc_list}"

        ((mode_choice == 1)) && [[ "${HW}" == cuda && -z "$(find_bin nvcc)" ]] && install_deps

        loginf g "Hardware backend: ${HW}"

        [[ -n "${svt_fork}" ]] && {
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
                :
        } || {
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
        }
        svt_fork_name="${SVT_FORK_NAMES[fork_idx]}"
        [[ "${svt_fork_name}" == "essential" ]] && cargo_features+=" --features svt-essential"
        svt_fork_url="${SVT_FORK_URLS[fork_idx]}"
        loginf g "SVT-AV1 fork: ${svt_fork_name}"

        cleanup_existing

        setup_toolchain

        clone_phase

        ((ENC_ON[avm])) && {
                build_avm &
                PID_AVM="${!}"
        }

        build_opus &
        PID_OPUS="${!}"
        build_dav1d &
        PID_DAV1D="${!}"
        build_svtav1 &
        PID_SVTAV1="${!}"

        [[ "${HW}" == cuda ]] && {
                build_nvheaders &
                PID_HW="${!}"
        } || {
                build_vulkan &
                PID_HW="${!}"
        }

        wait "${PID_DAV1D}" && wait "${PID_HW}" || exit 1
        build_ffmpeg &
        PID_FFMPEG="${!}"

        ((mode_choice == 1)) && {
                build_vship &
                PID_VSHIP="${!}"
        }

        wait "${PID_OPUS}" && wait "${PID_FFMPEG}" && wait "${PID_SVTAV1}" || exit 1
        ((mode_choice == 1)) && { wait "${PID_VSHIP}" || exit 1; }
        ((ENC_ON[avm])) && { wait "${PID_AVM}" || exit 1; }

        cd "${XAV_DIR}"

        loginf b "Configuring cargo"
        cp -f "${config_file}" ".cargo/config.toml"

        loginf b "Building XAV"

        local logfile="/tmp/build_cargo_$.log"

        cargo build --release ${cargo_features} > "${logfile}" 2>&1 && {
                rm -f "${logfile}"
                loginf g "Build complete: ${XAV_DIR}/target/release/xav"
                ls -la "${XAV_DIR}/target/release/xav" --color=always
        } || {
                echo -e "\n${R}Build failed! Output:${N}\n"
                cat "${logfile}"
                rm -f "${logfile}"
                exit 1
        }
}

main "${@}"
