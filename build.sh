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
                        needed=$(pacman -T "${pkgs[@]}") || ${priv:-} pacman -S --needed --noconfirm ${needed}
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
                [vvenc]="lib/release-static/libvvenc.a"
                [vvdec]="lib/release-static/libvvdec.a"
                [x265_git]="source/build-xav/libx265.a"
                [x264]="libx264.a"
        )

        local successful=() incomplete=()
        local dir dirs=(dav1d FFmpeg opus SVT-AV1)

        [[ "${HW}" == cuda ]] && dirs+=(nv-codec-headers) || dirs+=(vulkan)
        ((mode_choice == 1)) && dirs+=(Vship)
        ((ENC_ON[avm])) && dirs+=(avm)
        ((ENC_ON[vvenc])) && dirs+=(vvenc)
        ((ENC_ON[vvenc] && mode_choice == 1)) && dirs+=(vvdec)
        ((ENC_ON[x265])) && dirs+=(x265_git)
        ((ENC_ON[x264])) && dirs+=(x264)

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

        clone_async "${BUILD_DIR}/opus" "https://github.com/xiph/opus"
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
        ((ENC_ON[vvenc])) && clone_async "${BUILD_DIR}/vvenc" "https://github.com/fraunhoferhhi/vvenc" "--depth 1"
        ((ENC_ON[vvenc] && mode_choice == 1)) && clone_async "${BUILD_DIR}/vvdec" "https://github.com/fraunhoferhhi/vvdec" "--depth 1"
        ((ENC_ON[x265])) && clone_async "${BUILD_DIR}/x265_git" "https://bitbucket.org/multicoreware/x265_git" "--depth 1"
        ((ENC_ON[x264])) && clone_async "${BUILD_DIR}/x264" "https://code.videolan.org/videolan/x264.git" "--depth 1"

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
                -DCMAKE_ASM_COMPILER="${CC}" >> "${logfile}" 2>&1
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
				--enable-decoder=utvideo \
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
                -DOPUS_ENABLE_FLOAT_API=ON >> "${logfile}" 2>&1
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
                --width 1024 --height 576 --frames 300 --fps-num 60 --fps-denom 1 --input-depth 10 --profile 0
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

        sed -i '/^    svt_aom_setup_common_rtcd_internal(scs->static_config.use_cpu_flags);$/,/^    svt_aom_build_blk_geom(scs->svt_aom_geom_idx, scs->blk_geom_mds);$/c\
    return_error = svt_shared_setup(scs);\
    if (return_error != EB_ErrorNone)\
        return return_error;' Source/Lib/Globals/enc_handle.c
        grep -q init_shared_rtcd Source/Lib/Globals/enc_handle.c || sed -i '/^DEFINE_ONCE(global_tables_once);$/a\
\
static uint64_t          shared_cpu_flags;\
static uint32_t          shared_geom_idx;\
static uint16_t          shared_geom_cnt;\
static struct BlockGeom *shared_blk_geom;\
static uint32_t          shared_blk_geom_idx;\
\
static ONCE_ROUTINE(init_shared_rtcd) {\
    svt_aom_setup_common_rtcd_internal(shared_cpu_flags);\
    svt_aom_setup_rtcd_internal(shared_cpu_flags);\
    ONCE_ROUTINE_EPILOG;\
}\
DEFINE_ONCE(shared_rtcd_once);\
\
static ONCE_ROUTINE(init_shared_blk_geom) {\
    shared_blk_geom_idx = shared_geom_idx;\
    EB_MALLOC_ARRAY_NO_CHECK(shared_blk_geom, shared_geom_cnt);\
    if (shared_blk_geom)\
        svt_aom_build_blk_geom(shared_blk_geom_idx, shared_blk_geom);\
    ONCE_ROUTINE_EPILOG;\
}\
DEFINE_ONCE(shared_blk_geom_once);\
\
static EbErrorType svt_shared_setup(SequenceControlSet *scs) {\
    shared_cpu_flags = scs->static_config.use_cpu_flags;\
    svt_run_once(\&shared_rtcd_once, init_shared_rtcd);\
    svt_run_once(\&global_tables_once, init_global_tables);\
    shared_geom_idx = scs->svt_aom_geom_idx;\
    shared_geom_cnt = scs->max_block_cnt;\
    svt_run_once(\&shared_blk_geom_once, init_shared_blk_geom);\
    if (shared_blk_geom \&\& shared_blk_geom_idx == scs->svt_aom_geom_idx) {\
        scs->blk_geom_mds = shared_blk_geom;\
        return EB_ErrorNone;\
    }\
    EB_MALLOC_ARRAY(scs->blk_geom_mds, scs->max_block_cnt);\
    svt_aom_build_blk_geom(scs->svt_aom_geom_idx, scs->blk_geom_mds);\
    return EB_ErrorNone;\
}' Source/Lib/Globals/enc_handle.c
        sed -i 's|handle->scs_instance->scs->blk_geom_mds != NULL) {|handle->scs_instance->scs->blk_geom_mds != NULL \&\& handle->scs_instance->scs->blk_geom_mds != shared_blk_geom) {|' Source/Lib/Globals/enc_handle.c
        sed -i 's|^        return_error = svt_av1_set_default_params(config_ptr);$|        return_error = config_ptr ? svt_av1_set_default_params(config_ptr) : EB_ErrorNone;|' Source/Lib/Globals/enc_handle.c
        grep -q avx2 /proc/cpuinfo && sed -i '/^#ifndef CONFIG_X86_AVX2_IS_GUARANTEED$/,/^#endif$/s/       0$/       1/' Source/API/EbConfigMacros.h
        sed -i 's|^        SET_FUNCTIONS_X86(ptr, neon, neon_dotprod, neon_i8mm, sve, sve2) *\\$|        SET_FUNCTIONS_X86(ptr, mmx, sse, sse2, sse3, ssse3, sse4_1, sse4_2, avx, avx2, avx512) \\|' Source/Lib/Codec/aom_dsp_rtcd.c Source/Lib/Codec/common_dsp_rtcd.c

        sed -i 's|^    if (scs->static_config.encoder_bit_depth == EB_EIGHT_BIT) {$|    if (0) {|' Source/Lib/Globals/enc_handle.c
        sed -i 's|^    if (validate_on_the_fly_settings(p_buffer,scs, enc_handle_ptr->scs_instance->config_mutex)) {$|    if (0) {|' Source/Lib/Globals/enc_handle.c
        sed -i 's|^    EbErrorType return_error = svt_av1_verify_settings(scs);$|    EbErrorType return_error = EB_ErrorNone;|' Source/Lib/Globals/enc_handle.c
        sed -i 's|^            if (svt_aom_copy_metadata_buffer(dst, src->metadata) != EB_ErrorNone)$|            if (1)|' Source/Lib/Globals/enc_handle.c

        mkdir -p "${pgo_dir}"
        loginf b "Downloading PGO training video"
        curl -L "https://media.xiph.org/video/derf/webm/Netflix_FoodMarket2_4096x2160_60fps_10bit_420.webm" -o "${pgo_dir}/i.webm" >> "${logfile}" 2>&1
        ffmpeg -hide_banner -v error -stats -y -nostdin -i "${pgo_dir}/i.webm" -frames:v 300 -vf "scale=1024:576:flags=lanczos+accurate_rnd+full_chroma_int:param0=4,setsar=1,setdar=16/9" -pix_fmt yuv420p10le -strict -1 -f rawvideo "${pgo_dir}/i.yuv" >> "${logfile}" 2>&1
        rm -f "${pgo_dir}/i.webm"

        cd Build/linux
        grep -q avx512f /proc/cpuinfo && HAS_512="enable-avx512" || HAS_512="disable-avx512"
        export LLVM_PROFILE_FILE="${pgo_dir}/%p.profraw"
        loginf b "SVT-AV1 PGO generate"
        ./build.sh asm=nasm static enable-lto "${HAS_512}" native jobs="$(nproc)" release verbose log-quiet enable-pgo pgo-dir="${pgo_dir}" pgo-compile-gen -- -DCMAKE_C_FLAGS="${CFLAGS}" >> "${logfile}" 2>&1
        loginf b "Running PGO training encode"
        "${BUILD_DIR}/SVT-AV1/Bin/Release/SvtAv1EncApp" -i "${pgo_dir}/i.yuv" -b /dev/null "${pgo_params[@]}" >> "${logfile}" 2>&1
        loginf b "SVT-AV1 PGO use"
        ./build.sh asm=nasm static enable-lto "${HAS_512}" native jobs="$(nproc)" release verbose log-quiet enable-pgo pgo-dir="${pgo_dir}" pgo-compile-use -- -DCMAKE_C_FLAGS="${CFLAGS}" >> "${logfile}" 2>&1 && {
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

        grep -q tls_part_split av2/encoder/part_split_prune_tflite.cc || sed -i '/^static void ensure_tflite_init(void \*\*context, MODEL_TYPE model_type) {$/i\
static thread_local PartSplitContext *tls_part_split;' av2/encoder/part_split_prune_tflite.cc
        sed -i 's|^  if (\*context == nullptr) \*context = new PartSplitContext();$|  if (*context == nullptr) {\n    if (tls_part_split == nullptr) tls_part_split = new PartSplitContext();\n    *context = tls_part_split;\n  }|' av2/encoder/part_split_prune_tflite.cc
        sed -i '/^extern "C" void av2_part_prune_tflite_close(void \*\*context) {$/,/^}$/c\
extern "C" void av2_part_prune_tflite_close(void **context) { *context = nullptr; }' av2/encoder/part_split_prune_tflite.cc
        grep -q tls_dip av2/encoder/intra_dip_mode_prune_tflite.cc || sed -i '/^static void ensure_tflite_init(void \*\*context, int model_index) {$/i\
static thread_local DipContext *tls_dip;' av2/encoder/intra_dip_mode_prune_tflite.cc
        sed -i 's|^    \*context = new DipContext();$|    if (tls_dip == nullptr) tls_dip = new DipContext();\n    *context = tls_dip;|' av2/encoder/intra_dip_mode_prune_tflite.cc
        sed -i '/^extern "C" void intra_dip_mode_prune_close(void \*\*context) {$/,/^}$/c\
extern "C" void intra_dip_mode_prune_close(void **context) { *context = nullptr; }' av2/encoder/intra_dip_mode_prune_tflite.cc

        sed -i '\|generic/avm_scale.c"$|d;\|generic/gen_scalers.c"$|d' avm_scale/avm_scale.cmake

        sed -i 's/^#if ARCH_X86 || ARCH_X86_64$/#if 0/' avm/src/avm_encoder.c
        sed -i 's/if (!ctx || (img \&\& !duration))/if (0)/' avm/src/avm_encoder.c
        sed -i 's/if (!ctx->iface || !ctx->priv)/if (0)/g' avm/src/avm_encoder.c
        sed -i 's/if (!(ctx->iface->caps \& AVM_CODEC_CAP_ENCODER))/if (0)/g' avm/src/avm_encoder.c
        sed -i 's/if (!iter)/if (0)/' avm/src/avm_encoder.c
        sed -i 's|^                                    const avm_image_t \*img) {$|                                    const avm_image_t *img) { return AVM_CODEC_OK;|' av2/av2_cx_iface.c
        sed -i 's|^                                       const struct av2_extracfg \*extra_cfg) {$|                                       const struct av2_extracfg *extra_cfg) { return AVM_CODEC_OK;|' av2/av2_cx_iface.c
        grep -q '^    if (ctx->cx_data == NULL) {$' av2/av2_cx_iface.c || sed -i '/^static avm_codec_err_t encoder_encode(/,/^    if (res == AVM_CODEC_OK) {$/s|^    if (res == AVM_CODEC_OK) {$|    if (ctx->cx_data == NULL) {|' av2/av2_cx_iface.c

        cmake -B build -G Ninja \
                -DCMAKE_BUILD_TYPE=Release \
                -DCMAKE_C_COMPILER="${CC}" \
                -DCMAKE_CXX_COMPILER="${CXX}" \
                -DCMAKE_C_FLAGS="${CFLAGS}" \
                -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
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
                -DCONFIG_RUNTIME_CPU_DETECT=0 \
                -DCONFIG_MULTITHREAD=0 \
                -DCONFIG_LIBYUV=0 \
                -DCONFIG_LANCZOS_RESAMPLE=0 \
                -DCONFIG_SPATIAL_RESAMPLING=0 \
                -DCONFIG_12BIT_PROFILE=0 \
                -DCONFIG_DENOISE=0 \
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

build_vvenc() {
        [[ -f "${BUILD_DIR}/vvenc/lib/release-static/libvvenc.a" ]] && return

        loginf b "Building VVenC"

        local logfile="/tmp/build_vvenc_$.log"
        : > "${logfile}"

        cd "${BUILD_DIR}/vvenc"

        sed -i 's/set( CMAKE_POSITION_INDEPENDENT_CODE TRUE )/set( CMAKE_POSITION_INDEPENDENT_CODE FALSE )/' CMakeLists.txt
        sed -i 's/set( CMAKE_CXX_STANDARD 14 )/set( CMAKE_CXX_STANDARD 20 )/' CMakeLists.txt

        sed -i '/setSIMDExtension( nullptr );/d' source/Lib/vvenc/vvencimpl.cpp
        sed -i '/m_cEncoderInfo = createEncoderInfoStr();/d' source/Lib/vvenc/vvencimpl.cpp
        sed -i '/m_cVVEncCfgExt = \*config;/d' source/Lib/vvenc/vvencimpl.cpp
        sed -i '/vvenc_config           m_cVVEncCfgExt;/d' source/Lib/vvenc/vvencimpl.h
        sed -i 's/if ( vvenc_init_config_parameter(&m_cVVEncCfg) )/if ( !m_cVVEncCfg.m_configDone \&\& vvenc_init_config_parameter(\&m_cVVEncCfg) )/' source/Lib/vvenc/vvencimpl.cpp
        sed -i '/malloc_trim(0);/d' source/Lib/vvenc/vvencimpl.cpp
        sed -i 's/! xConvertVerifyYUVBuffer( pcYUVBuffer )/false/' source/Lib/vvenc/vvencimpl.cpp
        grep -q 'false && !m_bInitialized' source/Lib/vvenc/vvencimpl.cpp || {
                sed -i '/^int VVEncImpl::encode(/,/^  int iRet= VVENC_OK;$/s|^  if(|  if( false \&\& |' source/Lib/vvenc/vvencimpl.cpp
                sed -i '/^    if( m_eState == INTERNAL_STATE_FLUSHING ) { m_cErrorString = "encoder already received flush indication/,/^    if ( false )$/s|^    if(|    if( false \&\& |' source/Lib/vvenc/vvencimpl.cpp
        }
        sed -i '/memset( accessUnit->infoString, 0, sizeof( accessUnit->infoString ) );/d' source/Lib/vvenc/vvenc.cpp
        sed -i -e '/^  accessUnit->cts             = 0;$/d' -e '/^  accessUnit->dts             = 0;$/d' \
                -e '/^  accessUnit->ctsValid        = false;$/d' -e '/^  accessUnit->dtsValid        = false;$/d' \
                -e '/^  accessUnit->sliceType       = VVENC_NUMBER_OF_SLICE_TYPES;$/d' \
                -e '/^  accessUnit->refPic          = false;$/d' -e '/^  accessUnit->temporalLayer   = 0;$/d' \
                -e '/^  accessUnit->poc             = 0;$/d' -e '/^  accessUnit->status          = 0;$/d' \
                -e '/accessUnit->infoString\[0\]/d' source/Lib/vvenc/vvenc.cpp
        sed -i '/^VVENC_DECL void vvenc_accessUnit_reset/,/^}/s|^  if( nullptr == accessUnit )$|  if( false )|' source/Lib/vvenc/vvenc.cpp
        sed -i 's|^  if ( ! bflag )$|  if ( true )|' source/Lib/vvenc/vvencCfg.cpp
        sed -i 's/m_nalUnitData\.str()\.c_str()/m_nalUnitData.view().data()/g' source/Lib/vvenc/vvencimpl.cpp source/Lib/EncoderLib/EncGOP.cpp
        sed -i 's/m_nalUnitData\.str()\.size()/m_nalUnitData.view().size()/g' source/Lib/vvenc/vvencimpl.cpp source/Lib/EncoderLib/EncGOP.cpp
        sed -i '/xPrintPictureInfo ( pic, au, digestStr, m_pcEncCfg->m_printFrameMSE, isEncodeLtRef );/d' source/Lib/EncoderLib/EncGOP.cpp
        sed -i '/xCalcDistortion( pic, \*slice->sps );/d' source/Lib/EncoderLib/EncPicture.cpp
        sed -i 's|^#define CHECK(c,x)          if(c){ THROW(x); }$|#define CHECK(c,x)|' source/Lib/CommonLib/TypeDef.h

        cmake -B build -G Ninja \
                -DCMAKE_BUILD_TYPE=Release \
                -DCMAKE_C_COMPILER="${CC}" \
                -DCMAKE_CXX_COMPILER="${CXX}" \
                -DCMAKE_C_FLAGS="${CFLAGS}" \
                -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
                -DBUILD_SHARED_LIBS=OFF \
                -DVVENC_ENABLE_WERROR=OFF \
                -DVVENC_ENABLE_INSTALL=OFF \
                -DVVENC_ENABLE_LINK_TIME_OPT=OFF \
                -DVVENC_ENABLE_UNSTABLE_API=OFF \
                -DVVENC_ENABLE_TRACING=OFF >> "${logfile}" 2>&1
        ninja -C build vvenc >> "${logfile}" 2>&1

        [[ -f "${BUILD_DIR}/vvenc/lib/release-static/libvvenc.a" ]] && {
                rm -f "${logfile}"
                loginf g "VVenC built successfully"
        } || {
                echo -e "\n${R}Build failed! Output:${N}\n"
                cat "${logfile}"
                rm -f "${logfile}"
                exit 1
        }
}

build_x265() {
        [[ -f "${BUILD_DIR}/x265_git/source/build-xav/libx265.a" ]] && return

        loginf b "Building x265"

        local logfile="/tmp/build_x265_$.log"
        : > "${logfile}"

        cd "${BUILD_DIR}/x265_git/source"

        # 1 memcpy per param clone; no cpu_detect, default fill, 350 field walk
        grep -q 'memcpy(param, p, sizeof(x265_param))' encoder/api.cpp || sed -i '/^    if(param) PARAM_NS::x265_param_default(param);$/,/^    x265_copy_params(zoneParam, p);$/c\
    if (!param || !latestParam || !zoneParam)\
        goto fail;\
    memcpy(param, p, sizeof(x265_param));\
    memcpy(latestParam, p, sizeof(x265_param));\
    memcpy(zoneParam, p, sizeof(x265_param));' encoder/api.cpp
        sed -i '/x265_log(param, X265_LOG_INFO, "HEVC encoder version/d' encoder/api.cpp
        sed -i '/x265_log(param, X265_LOG_INFO, "build info/d' encoder/api.cpp
        sed -i '/^    x265_print_params(param);$/d' encoder/api.cpp
        sed -i '/^    x265_setup_primitives(param);$/d' encoder/api.cpp

        # asm tables become process wide
        sed -i '/^    x265_report_simd(param);$/d' common/primitives.cpp
        grep -q xav_x265_setup common/primitives.cpp || cat >> common/primitives.cpp <<- 'X265SETUP'

	extern "C" void xav_x265_setup(x265_param *param) { X265_NS::x265_setup_primitives(param); }
	X265SETUP

        # these land in xav's sink; never build a buffer
        grep -q xav_x265_log common/common.cpp || {
                sed -i 's|^void general_log(const x265_param\* param, const char\* caller, int level, const char\* fmt, ...)$|extern "C" void xav_x265_log(const char *msg, int len);\nvoid general_log(const x265_param* param, const char* caller, int level, const char* fmt, ...)|' common/common.cpp
                sed -i 's|^    if (param \&\& level > param->logLevel)$|    if (level > X265_LOG_WARNING)|' common/common.cpp
                sed -i 's|^    vsnprintf(buffer + p, bufferSize - p, fmt, arg);$|    p += vsnprintf(buffer + p, bufferSize - p, fmt, arg);\n    if (p >= bufferSize) p = bufferSize - 1;|' common/common.cpp
                sed -i 's|^    fputs(buffer, stderr);$|    xav_x265_log(buffer, p);|' common/common.cpp
                sed -i 's|^        fputs(buffer, stderr);$|        xav_x265_log(buffer, p);|' common/common.cpp
        }

        # scalar per-pixel luma/chroma histogram per frame; remove
        sed -i 's@^    if (param.csvLogLevel >= 2 || param.maxCLL || param.maxFALL)$@    if (0)@' common/picyuv.cpp
        sed -i 's@^    if (param.csvLogLevel >= 2)$@    if (0)@' common/picyuv.cpp

        # remove per frame free, re-malloc
        grep -q 'xav swap' encoder/nal.cpp || sed -i '/^void NALList::takeContents(NALList& other)$/,/^}$/c\
void NALList::takeContents(NALList\& other)\
{\
    /* xav swap: both lists keep a buffer, neither hits the allocator */\
    uint8_t* buf = m_buffer;\
    uint32_t alloc = m_allocSize;\
\
    m_buffer = other.m_buffer;\
    m_allocSize = other.m_allocSize;\
    m_occupancy = other.m_occupancy;\
\
    m_numNal = other.m_numNal;\
    memcpy(m_nal, other.m_nal, sizeof(x265_nal) * m_numNal);\
\
    other.m_numNal = 0;\
    other.m_occupancy = 0;\
    other.m_buffer = buf;\
    other.m_allocSize = alloc;\
}' encoder/nal.cpp

        sed -i 's|^%if FORMAT_ELF$|%if 0 ; xav: non-PIC build has no GOT; the lea is a plain abs32|' common/x86/pixel-util8.asm

        # frame encoder; runs on the caller; a worker is one thread; encode order is fixed
        grep -q setupInPlace encoder/frameencoder.h || sed -i '/^class FrameEncoder : public WaveFront, public Thread$/,/^public:$/s|^public:$|public:\n\n    /* xav: nothing here is threaded; threadMain is only this encoder'"'"'s setup now */\n    void setupInPlace() { threadMain(); }\n|' encoder/frameencoder.h
        grep -q 'xav: compress in place' encoder/frameencoder.cpp || sed -i 's|^    m_enable.trigger();$|    /* xav: compress in place. the bCTUInfo and AVC_INFO waits that guarded this\n     * in threadMain only ever complete from another thread, and there is none */\n    for (int layer = 0; layer < m_param->numLayers; layer++)\n        compressFrame(layer);|' encoder/frameencoder.cpp
        sed -i '/^    m_done.trigger();     \/\* signal that thread is initialized \*\/$/,/^}$/c\
}' encoder/frameencoder.cpp
        sed -i '/^        \/\* block here until worker thread completes \*\/$/d' encoder/frameencoder.cpp
        sed -i '/^        m_done.wait();$/d' encoder/frameencoder.cpp
        sed -i '/^        m_frameEncoder\[i\]->start();$/,/^        m_frameEncoder\[i\]->m_done.wait(); \/\* wait for thread to initialize \*\/$/c\
        m_frameEncoder[i]->setupInPlace();' encoder/encoder.cpp
        sed -i '/^            m_frameEncoder\[i\]->m_enable.trigger();$/d' encoder/encoder.cpp

        # with no pool, the numaPools strlen+strcmp per encoder goes
        sed -i 's|^    bool allowPools = !strlen(p->numaPools) \|\| strcmp(p->numaPools, "none");$|    bool allowPools = false; /* xav: this build has no worker pool to allocate */|' encoder/encoder.cpp
        sed -i 's|^    if (m_param->lookaheadThreads > 0)$|    if (0) /* xav: the lookahead runs on the caller, like everything else */|' encoder/encoder.cpp

        # match lookahead with xav cap
        sed -i 's|^#define X265_LOOKAHEAD_MAX 250$|#define X265_LOOKAHEAD_MAX 300|' x265.h

        sed -i 's@^    pps->numRefIdxDefault\[0\] = 1 + !!m_param->bEnableSCC;;$@    /* xav: the qp a frame of base complexity gets, which is the anchor the\n     * rate factor is built on in RateControl::init and getQScale */\n    double anchor = m_param->rc.rfConstant;\n    if (m_param->rc.cuTree \&\& !m_param->rc.hevcAq)\n        anchor += (1.0 - m_param->rc.qCompress) * (13.5 + 6.0 * X265_LOG2(BASE_FRAME_DURATION /\n                  CLIP_DURATION((double)m_param->fpsDenom / m_param->fpsNum)));\n    m_iPPSQpMinus26 = x265_clip3(-(26 + QP_BD_OFFSET), 25, (int)(anchor + 0.5) - 26);\n\n    pps->numRefIdxDefault[0] = X265_MIN(m_param->maxNumReferences, MAX_NUM_REF - 1);@' encoder/encoder.cpp
        sed -i 's@^    pps->numRefIdxDefault\[1\] = 1;$@    pps->numRefIdxDefault[1] = 1 + !!m_param->bBPyramid;@' encoder/encoder.cpp

        cmake -S . -B build-xav -G Ninja \
                -DCMAKE_BUILD_TYPE=Release \
                -DCMAKE_C_COMPILER="${CC}" \
                -DCMAKE_CXX_COMPILER="${CXX}" \
                -DCMAKE_C_FLAGS="${CFLAGS}" \
                -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
                -DHIGH_BIT_DEPTH=ON \
                -DMAIN12=OFF \
                -DEXPORT_C_API=ON \
                -DENABLE_SHARED=OFF \
                -DENABLE_CLI=OFF \
                -DENABLE_PIC=OFF \
                -DENABLE_ASSEMBLY=ON \
                -DENABLE_LIBNUMA=OFF \
                -DENABLE_HDR10_PLUS=OFF \
                -DENABLE_SVT_HEVC=OFF \
                -DENABLE_LIBVMAF=OFF \
                -DENABLE_ALPHA=OFF \
                -DENABLE_MULTIVIEW=OFF \
                -DENABLE_SCC_EXT=OFF \
                -DENABLE_TESTS=OFF \
                -DDETAILED_CU_STATS=OFF \
                -DCHECKED_BUILD=OFF \
                -DWARNINGS_AS_ERRORS=OFF >> "${logfile}" 2>&1
        ninja -C build-xav x265-static >> "${logfile}" 2>&1

        [[ -f "${BUILD_DIR}/x265_git/source/build-xav/libx265.a" ]] && {
                rm -f "${logfile}"
                loginf g "x265 built successfully"
        } || {
                echo -e "\n${R}Build failed! Output:${N}\n"
                cat "${logfile}"
                rm -f "${logfile}"
                exit 1
        }
}

build_x264() {
        [[ -f "${BUILD_DIR}/x264/libx264.a" ]] && return

        loginf b "Building x264"

        local logfile="/tmp/build_x264_$.log"
        : > "${logfile}"

        cd "${BUILD_DIR}/x264"

        # match lookahead with xav cap
        sed -i 's|^#define X264_LOOKAHEAD_MAX 250$|#define X264_LOOKAHEAD_MAX 300|' common/base.h

        # these land in xav's sink; stderr holds the progress frame
        grep -q xav_x264_log common/base.c || sed -i '/^    fprintf( stderr, "x264 \[%s\]: ", psz_prefix );$/,/^    x264_vfprintf( stderr, psz_fmt, arg );$/c\
    extern void xav_x264_log( const char *msg, int len );\
    char buf[4096];\
    int n = snprintf( buf, sizeof(buf), "x264 [%s]: ", psz_prefix );\
    n += vsnprintf( buf + n, sizeof(buf) - n, psz_fmt, arg );\
    if( n >= (int)sizeof(buf) ) n = (int)sizeof(buf) - 1;\
    xav_x264_log( buf, n );' common/base.c

        # c++ flags break its -fno-lto probes
        local x264_cflags="${CFLAGS//-fwhole-program-vtables/}"
        # c++ libs get split units from -fwhole-program-vtables
        export CFLAGS="${x264_cflags//-fvisibility-inlines-hidden/} -fsplit-lto-unit"

        # xav = -march=native & never redistributed ; make it constant
        sed -i '/^        uint32_t cpuflags = x264_cpu_detect();$/c\
        uint32_t cpuflags = X264_CPU_SSE2_IS_FAST\
        #ifdef __MMX__\
                          | X264_CPU_MMX\
        #endif\
        #ifdef __SSE__\
                          | X264_CPU_MMX2 | X264_CPU_SSE\
        #endif\
        #ifdef __SSE2__\
                          | X264_CPU_SSE2\
        #endif\
        #ifdef __LZCNT__\
                          | X264_CPU_LZCNT\
        #endif\
        #ifdef __SSE3__\
                          | X264_CPU_SSE3\
        #endif\
        #ifdef __SSSE3__\
                          | X264_CPU_SSSE3\
        #endif\
        #ifdef __SSE4_1__\
                          | X264_CPU_SSE4\
        #endif\
        #ifdef __SSE4_2__\
                          | X264_CPU_SSE42\
        #endif\
        #ifdef __AVX__\
                          | X264_CPU_AVX\
        #endif\
        #ifdef __XOP__\
                          | X264_CPU_XOP\
        #endif\
        #ifdef __FMA4__\
                          | X264_CPU_FMA4\
        #endif\
        #ifdef __FMA__\
                          | X264_CPU_FMA3\
        #endif\
        #ifdef __BMI__\
                          | X264_CPU_BMI1\
        #endif\
        #ifdef __BMI2__\
                          | X264_CPU_BMI2\
        #endif\
        #ifdef __AVX2__\
                          | X264_CPU_AVX2\
        #endif\
        #if defined(__AVX512F__) \&\& defined(__AVX512CD__) \&\& defined(__AVX512BW__) \&\& defined(__AVX512DQ__) \&\& defined(__AVX512VL__)\
                          | X264_CPU_AVX512\
        #endif\
                          ;' encoder/encoder.c

        # we want the highest simd build target has
        grep -q 'xav: keep avx512' encoder/encoder.c || sed -i '/^#if (ARCH_X86 || ARCH_X86_64) \&\& HIGH_BIT_DEPTH$/,/^#endif$/c\
    /* xav: keep avx512; upstream drops it here for hbd */' encoder/encoder.c

        # process wide cpu-dispatch; build the tables once
        grep -q xav_x264_setup encoder/encoder.c || {
                sed -i '/^\/\/#define DEBUG_MB_TYPE$/i\
typedef struct\
{\
    x264_predict_t            predict_16x16[4+3];\
    x264_predict8x8_t         predict_8x8[9+3];\
    x264_predict_t            predict_4x4[9+3];\
    x264_predict_t            predict_8x8c[4+3];\
    x264_predict_t            predict_8x16c[4+3];\
    x264_predict_8x8_filter_t predict_8x8_filter;\
    x264_pixel_function_t     pixf;\
    x264_mc_functions_t       mc;\
    x264_dct_function_t       dctf;\
    x264_zigzag_function_t    zigzagf_progressive;\
    x264_quant_function_t     quantf[2];\
    x264_deblock_function_t   loopf;\
    x264_bitstream_function_t bsf;\
} xav_x264_fns;\
\
static xav_x264_fns xav_fns;\
\
typedef char xav_x264_run_check[\
    offsetof(x264_t, predict_8x8) == offsetof(x264_t, predict_16x16) + sizeof(xav_fns.predict_16x16)\
 \&\& offsetof(x264_t, predict_4x4) == offsetof(x264_t, predict_8x8) + sizeof(xav_fns.predict_8x8)\
 \&\& offsetof(x264_t, predict_8x16c) == offsetof(x264_t, predict_8x8c) + sizeof(xav_fns.predict_8x8c)\
 \&\& offsetof(x264_t, predict_8x8_filter) == offsetof(x264_t, predict_8x16c) + sizeof(xav_fns.predict_8x16c)\
 \&\& offsetof(x264_t, pixf) == offsetof(x264_t, predict_8x8_filter) + sizeof(xav_fns.predict_8x8_filter)\
 \&\& offsetof(x264_t, mc) == offsetof(x264_t, pixf) + sizeof(xav_fns.pixf)\
 \&\& offsetof(x264_t, dctf) == offsetof(x264_t, mc) + sizeof(xav_fns.mc)\
 \&\& offsetof(x264_t, bsf) == offsetof(x264_t, loopf) + sizeof(xav_fns.loopf)\
 \&\& offsetof(xav_x264_fns, predict_8x8) == offsetof(xav_x264_fns, predict_16x16) + sizeof(xav_fns.predict_16x16)\
 \&\& offsetof(xav_x264_fns, predict_4x4) == offsetof(xav_x264_fns, predict_8x8) + sizeof(xav_fns.predict_8x8)\
 \&\& offsetof(xav_x264_fns, predict_8x16c) == offsetof(xav_x264_fns, predict_8x8c) + sizeof(xav_fns.predict_8x8c)\
 \&\& offsetof(xav_x264_fns, predict_8x8_filter) == offsetof(xav_x264_fns, predict_8x16c) + sizeof(xav_fns.predict_8x16c)\
 \&\& offsetof(xav_x264_fns, pixf) == offsetof(xav_x264_fns, predict_8x8_filter) + sizeof(xav_fns.predict_8x8_filter)\
 \&\& offsetof(xav_x264_fns, mc) == offsetof(xav_x264_fns, pixf) + sizeof(xav_fns.pixf)\
 \&\& offsetof(xav_x264_fns, dctf) == offsetof(xav_x264_fns, mc) + sizeof(xav_fns.mc)\
 \&\& offsetof(xav_x264_fns, bsf) == offsetof(xav_x264_fns, loopf) + sizeof(xav_fns.loopf)\
 ? 1 : -1];\
\
void xav_x264_setup( x264_param_t *param )\
{\
    uint32_t cpu = param->cpu;\
    x264_predict_16x16_init( cpu, xav_fns.predict_16x16 );\
    x264_predict_8x8c_init( cpu, xav_fns.predict_8x8c );\
    x264_predict_8x16c_init( cpu, xav_fns.predict_8x16c );\
    x264_predict_8x8_init( cpu, xav_fns.predict_8x8, \&xav_fns.predict_8x8_filter );\
    x264_predict_4x4_init( cpu, xav_fns.predict_4x4 );\
    x264_pixel_init( cpu, \&xav_fns.pixf );\
    x264_dct_init( cpu, \&xav_fns.dctf );\
    x264_zigzag_function_t zigzag_il;\
    x264_zigzag_init( cpu, \&xav_fns.zigzagf_progressive, \&zigzag_il );\
    x264_mc_init( cpu, \&xav_fns.mc, param->b_cpu_independent );\
    x264_t *q = calloc( 1, sizeof(x264_t) );\
    q->param = *param;\
    q->param.i_cqm_preset = X264_CQM_FLAT;\
    x264_quant_init( q, cpu, \&xav_fns.quantf[0] );\
    q->param.i_cqm_preset = X264_CQM_JVT;\
    x264_quant_init( q, cpu, \&xav_fns.quantf[1] );\
    free( q );\
    x264_deblock_init( cpu, \&xav_fns.loopf, PARAM_INTERLACED );\
    x264_bitstream_init( cpu, \&xav_fns.bsf );\
}\
' encoder/encoder.c

                sed -i '/^    x264_predict_16x16_init( h->param.cpu, h->predict_16x16 );$/,/^    x264_bitstream_init( h->param.cpu, \&h->bsf );$/c\
    /* xav: xav_x264_fns mirrors this field order, so each unbroken run is one\
     * memcpy; predict_chroma, zigzagf and quantf are the breaks */\
    memcpy( h->predict_16x16, xav_fns.predict_16x16,\
            sizeof(h->predict_16x16) + sizeof(h->predict_8x8) + sizeof(h->predict_4x4) );\
    memcpy( h->predict_8x8c, xav_fns.predict_8x8c,\
            sizeof(h->predict_8x8c) + sizeof(h->predict_8x16c) + sizeof(h->predict_8x8_filter)\
            + sizeof(h->pixf) + sizeof(h->mc) + sizeof(h->dctf) );\
    memcpy( \&h->zigzagf_progressive, \&xav_fns.zigzagf_progressive, sizeof(h->zigzagf_progressive) );\
    memcpy( \&h->loopf, \&xav_fns.loopf, sizeof(h->loopf) + sizeof(h->bsf) );\
    h->zigzagf = xav_fns.zigzagf_progressive;\
    h->quantf = xav_fns.quantf[h->param.i_cqm_preset != X264_CQM_FLAT];' encoder/encoder.c
        }

        ./configure \
                --disable-cli \
                --enable-static \
                --disable-opencl \
                --disable-thread \
                --disable-interlaced \
                --disable-avs \
                --disable-swscale \
                --disable-lavf \
                --disable-ffms \
                --disable-gpac \
                --disable-lsmash \
                --disable-bashcompletion \
                --bit-depth=10 \
                --chroma-format=420 \
                --extra-ldflags="${LDFLAGS}" >> "${logfile}" 2>&1
        make -j"$(nproc)" libx264.a >> "${logfile}" 2>&1

        [[ -f "${BUILD_DIR}/x264/libx264.a" ]] && {
                rm -f "${logfile}"
                loginf g "x264 built successfully"
        } || {
                echo -e "\n${R}Build failed! Output:${N}\n"
                cat "${logfile}"
                rm -f "${logfile}"
                exit 1
        }
}

build_vvdec() {
        [[ -f "${BUILD_DIR}/vvdec/lib/release-static/libvvdec.a" ]] && return

        loginf b "Building VVdeC"

        local logfile="/tmp/build_vvdec_$.log"
        : > "${logfile}"

        cd "${BUILD_DIR}/vvdec"

        sed -i 's/set( CMAKE_POSITION_INDEPENDENT_CODE TRUE )/set( CMAKE_POSITION_INDEPENDENT_CODE FALSE )/' CMakeLists.txt
        sed -i 's/set( CMAKE_CXX_STANDARD 14 )/set( CMAKE_CXX_STANDARD 20 )/' CMakeLists.txt

        grep -q 'false && !m_bInitialized' source/Lib/vvdec/vvdecimpl.cpp || {
                sed -i '/^int VVDecImpl::decode(/,/not supported feature detected/s|^  if(|  if( false \&\& |' source/Lib/vvdec/vvdecimpl.cpp
                sed -i '/^  if( !rcAccessUnit.payload )$/,/^  int iRet = VVDEC_OK;$/s|^  if(|  if( false \&\& |' source/Lib/vvdec/vvdecimpl.cpp
        }
        sed -i '/^      bool bStartCodeFound = false;$/,/^      iAUEndPosVec.push_back( iLastPos );$/c\
      const size_t iStartCodeSizeVec[1] = { rcAccessUnit.payload[2] == 1 ? (size_t)3 : (size_t)4 };\
      const size_t iStartCodePosVec[1] = { iStartCodeSizeVec[0] };\
      int iLastPos = rcAccessUnit.payloadUsedSize;\
      while( iLastPos > 0 \&\& rcAccessUnit.payload[iLastPos-1] == 0 )\
      {\
        iLastPos--;\
      }\
      const size_t iAUEndPosVec[1] = { (size_t)iLastPos };' source/Lib/vvdec/vvdecimpl.cpp
        sed -i 's/!iStartCodePosVec.empty() && iStartCodePosVec\[0\] != iStartCodeSizeVec\[0\]/false/' source/Lib/vvdec/vvdecimpl.cpp
        sed -i 's/iAU < iStartCodePosVec.size()/iAU < 1/' source/Lib/vvdec/vvdecimpl.cpp
        sed -i 's|parserFrameDelay = std::min<int>( ( numDecThreads \* DEFAULT_PARSE_DELAY_FACTOR ) >> 4, DEFAULT_PARSE_DELAY_MAX );|parserFrameDelay = (int) m_decLibRecon.size();|' source/Lib/DecoderLib/DecLib.cpp

        cmake -B build -G Ninja \
                -DCMAKE_BUILD_TYPE=Release \
                -DCMAKE_C_COMPILER="${CC}" \
                -DCMAKE_CXX_COMPILER="${CXX}" \
                -DCMAKE_C_FLAGS="${CFLAGS}" \
                -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
                -DBUILD_SHARED_LIBS=OFF \
                -DVVDEC_LIBRARY_ONLY=ON \
                -DVVDEC_ENABLE_WERROR=OFF \
                -DVVDEC_ENABLE_LINK_TIME_OPT=OFF \
                -DVVDEC_ENABLE_UNSTABLE_API=OFF \
                -DVVDEC_ENABLE_TRACING=OFF >> "${logfile}" 2>&1
        ninja -C build vvdec >> "${logfile}" 2>&1

        [[ -f "${BUILD_DIR}/vvdec/lib/release-static/libvvdec.a" ]] && {
                rm -f "${logfile}"
                loginf g "VVdeC built successfully"
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
	-fno-use-cxa-atexit -D_FORTIFY_SOURCE=0 -fvisibility=hidden -fvisibility-inlines-hidden -fwhole-program-vtables"
        export CFLAGS="${COMMON_FLAGS}"
        export CXXFLAGS="${COMMON_FLAGS} -stdlib=libstdc++"
        export LDFLAGS="-fuse-ld=lld -Wl,-O3 -Wl,--lto-O3 -Wl,--as-needed -Wl,--gc-sections -Wl,--icf=all -Wl,--strip-all -Wl,-z,norelro -Wl,--build-id=none -Wl,--relax -Wl,-z,noseparate-code -Wl,-znow -Wl,--discard-all"
}

ENCODER_NAMES=("AVM" "VVenC" "x265" "x264")
ENCODER_FEATS=("avm" "vvenc" "x265" "x264")
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

        ((ENC_ON[vvenc])) && {
                build_vvenc &
                PID_VVENC="${!}"
        }

        ((ENC_ON[vvenc] && mode_choice == 1)) && {
                build_vvdec &
                PID_VVDEC="${!}"
        }

        ((ENC_ON[x265])) && {
                build_x265 &
                PID_X265="${!}"
        }

        ((ENC_ON[x264])) && {
                build_x264 &
                PID_X264="${!}"
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
        ((ENC_ON[vvenc])) && { wait "${PID_VVENC}" || exit 1; }
        ((ENC_ON[vvenc] && mode_choice == 1)) && { wait "${PID_VVDEC}" || exit 1; }
        ((ENC_ON[x265])) && { wait "${PID_X265}" || exit 1; }
        ((ENC_ON[x264])) && { wait "${PID_X264}" || exit 1; }

        cd "${XAV_DIR}"

        loginf b "Configuring cargo"
        cp -f "${config_file}" ".cargo/config.toml"

        loginf b "Building XAV"

        local logfile="/tmp/build_cargo_$.log"

        cargo build --release ${cargo_features} > "${logfile}" 2>&1 && {
                rm -f "${logfile}"
                loginf g "Build complete: ${XAV_DIR}/target/x86_64-unknown-linux-gnu/release/xav"
                ls -la "${XAV_DIR}/target/x86_64-unknown-linux-gnu/release/xav" --color=always
        } || {
                echo -e "\n${R}Build failed! Output:${N}\n"
                cat "${logfile}"
                rm -f "${logfile}"
                exit 1
        }
}

main "${@}"
