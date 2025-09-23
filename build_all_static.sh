#!/usr/bin/env bash

set -Eeuo pipefail

BUILD_DIR="${HOME}/.local/src"

XAV_DIR="$(pwd)"

R='\e[1;91m' B='\e[1;94m'
P='\e[1;95m' Y='\e[1;93m' N='\033[0m'
C='\e[1;96m' G='\e[1;92m'

loginf() {
        sleep "0.3"

        case "${1}" in
                r) COL="${R}" MSG="ERROR!" ;;
        esac

        RAWMSG="${2}"

        DATE="$(date "+%Y-%m-%d ${C}/${P} %H:%M:%S")"

        LOG="${C}[${P}${DATE}${C}] ${Y}>>>${COL}${MSG}${Y}<<< - ${COL}${RAWMSG}${N}"

        [[ "${1}" == "c" ]] && echo -e "\n\n${LOG}" || echo -e "${LOG}"
}

handle_err() {
        stat="${?}"
        cmd="${BASH_COMMAND}"
        line="${LINENO}"
        loginf r "Line ${B}${line}${R}: cmd ${B}'${cmd}'${R} exited with ${B}\"${stat}\""
}

trap 'handle_err' ERR RETURN

show_opts() {
        opts=("${@}")

        for i in "${!opts[@]}"; do
                printf "${Y}%2d) ${P}%-15s${N}" "$((i + 1))" "${opts[i]}"
                (((i + 1) % 3 == 0)) && echo
        done

        ((${#opts[@]} % 3 != 0)) && echo
}

CXX_LIBS=(libc++ libstdc++)

while true; do
        show_opts "${CXX_LIBS[@]}"

        echo -ne "${C}Select a CXX LIB: ${N}"
        read -r cxx_choice

        [[ "${cxx_choice}" == "1" || "${cxx_choice}" == "2" ]] && {
                selected_cxx="${CXX_LIBS[cxx_choice - 1]}"
                echo -e "${G}Selected: ${selected_cxx}${N}"
                break
        }
done

echo ""

OPTS=(ON OFF)

while true; do
        show_opts "${OPTS[@]}"

        echo -ne "${C}Polly Optimizations: ${N}"
        read -r polly_choice

        polly="${OPTS[polly_choice - 1]}"
        echo -e "${G}Selected: ${polly_choice}${N}"

        [[ "${polly_choice}" == "1" || "${polly_choice}" == "2" ]] && {
                polly="${OPTS[polly_choice - 1]}"
                echo -e "${G}Selected: ${polly}${N}"
                break
        }
done

[[ ${polly} == "ON" ]] && export POLLY_FLAGS="-mllvm -polly \
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

export CC="clang"
export CXX="clang++"
export LD="ld.lld"
export AR="llvm-ar"
export NM="llvm-nm"
export RANLIB="llvm-ranlib"
export STRIP="llvm-strip"
export OBJCOPY="llvm-objcopy"
export OBJDUMP="llvm-objdump"

export COMMON_FLAGS="-O3 -ffast-math -march=native -mtune=native -flto=thin -pipe -fno-math-errno -fomit-frame-pointer -fno-semantic-interposition -fno-stack-protector -fno-stack-clash-protection -fno-sanitize=all -fno-dwarf2-cfi-asm ${POLLY_FLAGS:-} -fstrict-aliasing -fstrict-overflow -fno-zero-initialized-in-bss -static"
export CFLAGS="${COMMON_FLAGS}"
export CXXFLAGS="${COMMON_FLAGS} -stdlib=${selected_cxx}"
export LDFLAGS="-fuse-ld=lld -rtlib=compiler-rt -unwindlib=libunwind -Wl,-O3 -Wl,--lto-O3 -Wl,--as-needed -Wl,-z,norelro -Wl,--build-id=none -Wl,--relax -Wl,-z,noseparate-code -Wl,--strip-all -Wl,--no-eh-frame-hdr -Wl,-znow -Wl,--gc-sections -Wl,--discard-all -Wl,--icf=all -static"

mkdir -pv "${BUILD_DIR}"
cd "${BUILD_DIR}"

git clone "https://github.com/FFmpeg/FFmpeg"

cd "FFmpeg"

git checkout n7.1 # av-decoders 4.0 and ffmpeg-the-third currently need this

echo "=== Building FFmpeg with custom flags ==="

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
        --disable-programs \
        --disable-doc \
        --disable-htmlpages \
        --disable-manpages \
        --disable-podpages \
        --disable-txtpages \
        --disable-network \
        --disable-autodetect \
        --disable-postproc \
        --disable-avdevice \
        --disable-avfilter \
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
        --enable-decoder=h264 \
        --enable-decoder=hevc \
        --enable-decoder=av1 \
        --enable-decoder=vp8 \
        --enable-decoder=vp9 \
        --enable-decoder=mpeg2video \
        --enable-decoder=mpeg1video \
        --enable-decoder=mpeg4 \
        --enable-parser=h264 \
        --enable-parser=hevc \
        --enable-parser=av1 \
        --enable-parser=vp8 \
        --enable-parser=vp9 \
        --enable-parser=mpeg4video \
        --enable-parser=mpegvideo

echo "=== Building FFmpeg ==="
make -j"$(nproc)"

echo "=== FFmpeg static libraries created ==="
ls -la libav*/*.a

mkdir -p lib
cp libavcodec/libavcodec.a lib/
cp libavformat/libavformat.a lib/
cp libavutil/libavutil.a lib/
cp libswscale/libswscale.a lib/
cp libswresample/libswresample.a lib/

FFMPEG_SRC_DIR="${HOME}/.local/src/FFmpeg"

echo "=== Cloning and building ffms2 ==="
cd ..
git clone https://github.com/FFMS/ffms2.git
cd ffms2

mkdir -p src/config

autoreconf -fiv

echo "=== Configuring ffms2 with custom flags ==="
PKG_CONFIG_PATH="${FFMPEG_SRC_DIR}/libavcodec:${FFMPEG_SRC_DIR}/libavformat:${FFMPEG_SRC_DIR}/libavutil:${FFMPEG_SRC_DIR}/libswscale:${FFMPEG_SRC_DIR}/libswresample" \
        CC="${CC}" \
        CXX="${CXX}" \
        AR="${AR}" \
        RANLIB="${RANLIB}" \
        CFLAGS="${CFLAGS}" \
        CXXFLAGS="${CXXFLAGS}" \
        LDFLAGS="${LDFLAGS} -L${FFMPEG_SRC_DIR}/libavcodec -L${FFMPEG_SRC_DIR}/libavformat -L${FFMPEG_SRC_DIR}/libavutil -L${FFMPEG_SRC_DIR}/libswscale -L${FFMPEG_SRC_DIR}/libswresample" \
        LIBS="-lpthread -lm -lz" \
        ./configure \
        --enable-static \
        --disable-shared

echo "=== Building ffms2 ==="
make -j"$(nproc)"

echo "=== Build complete ==="
echo "FFmpeg static libraries: ${FFMPEG_SRC_DIR}/lib/*.a"
echo "ffms2 static library: $(pwd)/src/core/.libs/libffms2.a"

cd "${XAV_DIR}"

export PKG_CONFIG_ALL_STATIC=1
export FFMPEG_DIR="${HOME}/.local/src/FFmpeg"
cargo build --release
