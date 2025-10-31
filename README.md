# xav - eXtreme AOMedia Video

The Most Efficient Chunked or Target Quality AV1/AV2 Encoding Framework

<img width="1772" height="680" alt="image_2025-10-26_01-18-55" src="https://github.com/user-attachments/assets/7652c8e2-4a9a-4660-b276-c345e22b932f" />

**Input:** Lossless intermediate (8bit) of a full-length TV show episode (100k frames).

Peak RSS difference might be related to the tool not parsing the sub-process data (av1an's resources are on vspipe and ffmpeg)

Chunked Encoding Only Test (No TQ): The test includes indexing and scene change detection too.

av1an's wrapper script for the above test:
```
av1an -i i.mkv -o o.mkv -q --log-level error --force --no-defaults --workers 8 -s s.json --split-method av-scenechange -e svt-av1 --video-params "--input-depth 10 --width 1920 --forced-max-frame-width 1920 --height 1080 --forced-max-frame-height 1080 --fps-num 24000 --fps-denom 1001 --keyint -1 --rc 0 --scd 0 --scm 0 --color-primaries 1 --transfer-characteristics 1 --matrix-coefficients 1 --color-range 0 --preset 10 --lp 3 --crf 63" --chunk-method ffms2 --pix-format yuv420p10le --extra-split 240 --min-scene-len 24

rm -f s.json *index *idx o.mkv
```

`xav` wrapper script for the above test:
```
# Other parameters are auto-applied by xav including 8 workers and --lp 3 on my machine
xav -q -p "--preset 10 --crf 63" i.mkv

rm -rf i_av1.mkv *txt *idx *index
```

## Table of Contents

1. [Dependencies](#dependencies)
2. [Description](#description)
3. [Features](#features)
4. [Design Decisions](#design-decisions)
5. [Usage](#usage)
6. [Building](#building)
7. [Video Showcase](#video-showcase)
8. [How TQ Works](#how-tq-works)
9. [Credits](#credits)
10. [Minimal and Faster Than Av1an](#minimal-and-faster-than-av1an)

## Dependencies

- [SVT-AV1](https://gitlab.com/AOMediaCodec/SVT-AV1) (mainline or a fork)
- [mkvmerge](https://mkvtoolnix.download/source.html) (to concatenate chunks)
- [FFMS2](https://github.com/FFMS/ffms2) (a hard dependency)
- [VSHIP](https://github.com/Line-fr/Vship) (optional - needed for target quality encoding with CVVDP)
- [ZIMG](https://github.com/sekrit-twc/zimg) (optional - provides color conversion features needed by VSHIP)

## Description

`xav` aims to be the fastest, most minimal AV1/AV2 encoding framework. By keeping its feature scope limited, the potential for the best encoder and the best video quality metric can be maximized without getting limited by extensive features.

As the author has been involved with the `av1an` project since its inception as a user and continues to develop it; creating a direct competitor without purpose was not the objective. `xav` is a faster, more minimal alternative to Av1an's most popular features and the author acknowledges that `av1an` is the most powerful & feature-rich video encoding framework. This tool was developed with a strong interest and focus on the "av1an" concept.

For this reason, adding `xav` features to `av1an` and `av1an` features to `xav`, do not make sense.

## Features

- Parses the new fancy progress output on SVT-AV1 encoders (there is an example in the below video).
- Parses color and video metadata (container & frame based) to encoders automatically, including HDR metadata (Dolby Vision RPU automation for chunking is considered), FPS and resolution.
- Offers fun process monitoring with almost no overhead for indexing, SCD, encoding, TQ processes.
- Fastest chunked encoding with `svt-av1`.
- Fastest target quality encoding with `CVVDP`.
- Photon noise generation support.

## Design Decisions

- Uses only absolute bleeding-edge tools with an opinionated setup.
- No flexibility or extensive feature support (such as VapourSynth filtering, zoning, different encoders, chunking methods, scaling, configurable SC parameters, probing with different parameters than actual encoding for TQ).
- `yuv420p` & `yuv420p10le` input AND `yuv420p10le` output only. No 8 (output) or 12bit support, as well as yuv422, yuv444 support.
- TQ aim is to: Get exactly what you requested in the most accurate / fastest way possible with no chance of deviation.
- Chunked encoding's aim is to optimize internally and reduce overhead as much as possible to get the fastest possible encoding speed overall.
- The tool's general aim is to achieve the previous 2 points, using as little characters in CLI, as possible: `xav -t 9.4-9.6 i.mkv`

These help me make the tool's already present features closer to perfect with each day. So I am constantly trying to reduce extra options and code-size.

## Usage

<img width="1526" height="626" alt="image" src="https://github.com/user-attachments/assets/22ce28e8-257c-4655-bf5b-e1830194691c" />

## Building

Run the `build.sh` script: It will guide you.

Building dependencies statically and building the main tool with them, is the intended way for maximum performance but it's for advanced users due to compiler complexities.

For dynamic builds, you need ffmpegsource (ffms2) installed on your system. That's all.

For TQ support, you need `zimg`, `ffms2`, `vship` installed on your system.

**NOTE:** Building this tool statically requires you to have static libraries in your system for the C library (glibc), CXX library (libstdc++), llvm-libunwind, compiler-rt. They are usually found with `-static`, `-dev`, `-git` suffixes in package managers. Some package managers do not provide them, in this case; they need to be compiled manually.

Rust Nightly is also needed for `-Z` based optimizations.

## Video Showcase

<video
  width="1200px" controls preload="metadata" type="video/mp4"
  src="https://github.com/user-attachments/assets/228a4f22-b687-449d-9eb6-d0d2e7630e83">
</video>

## How TQ Works
Target quality logic comes from [my pull requests](https://github.com/rust-av/Av1an/pulls?q=is%3Apr+is%3Aclosed+author%3Aemrakyz) on `av1an` and it includes a little bit improvement on top of those.

The tool gets the allowed target and CRF range from the user, such as:
- `CRF = 12.25 - 44.75` - This means the tool will never use a CRF lower than `12.25` or higher than `44.75`.
- `TQ = 9.49-9.51` - This means the allowed TQ range is very narrow and we target for a CVVDP score of `9.5` for each chunk separately.

**Convergence rounds:**
1) Binary Search
2) Binary Search
3) Linear Interpolation
4) Natural Cubic Spline Interpolation
5) PCHIP Interpolation
6) AKIMA Interpolation
7) Falls back to Binary Search

It constantly uses higher-order interpolation methods to increase accuracy with additional data. And after each round, we shrink the search space.

For example, if the user allows the whole CRF range (0 70), the first binary search tries CRF 35 and if it's lower than the target quality, then we limit the next search within CRF 0 to 34.75.

Interpolation + search space shrinkage + intelligently used `--tq` and `--qp` parameters make the tool as fast as possible while keeping the accuracy.

**Early Exit Conditions:**
- It found the target.
- Impossible to find (picks the closest candidate). This can be because of very narrow TQ range or an absurd CRF range (you allowed CRF 60-70 but requested a visually transparent quality).

## Credits

Huge thanks to [Soda](https://github.com/GreatValueCreamSoda) for the tremendous help & motivation & support to build this tool, and more importantly, for his friendship along the way. He is the partner in crime.

Also thanks [Lumen](https://github.com/Line-fr) for her great contributions on GPU based accessible state-of-the-art metric implementations and general help around the tooling.

## Minimal and Faster Than Av1an

- Uses a direct memory pipeline (zero external process overhead). Everything runs within one Rust process with direct memory access.
- Direct C FFI bindings to FFMS2. FFMS2 is currently the most efficient library to open/index/decode videos. With this way, we also get rid of Python/Vapoursynth/FFMPEG dependencies.
- Frames flow directly from decoder -> memory buffers -> encoder stdin via pipes.
- Uses zero-copy frame handling.
- If the input is 10bit, custom 4-pixel-to-5-byte packing reduces memory by `37.5%`. The bit packing overhead is literally 0.
- If the input is 8bit, we can store the chunk in memory as 8bit reducing almost `50%`.
- On demand 10bit conversion is only done efficiently when needed.
- Uses contiguous YUV420 layout optimized for cache locality.
- The producer-consumer pipeline is lockless.
- Single thread extracts frames using FFMS2 -> Multiple encoder threads process chunks in parallel -> Lockless MPSC crossbeam channel communication with backpressure
- There is no thread contention: Single decoder eliminates seeking conflicts.
- Bounded channels prevent memory explosion.
- Workers operate on independent memory regions.
- All components share the same address space.
- OS can optimize single-process thread scheduling in an easier way.
- Minimal data movement between processing stages.
- Sequential memory access
- Only a single index needed for SCD/encoding.
- No interpreter overhead.
- TQ: Can directly use already handled frames for encoding, for metric comparison as well by utilizing `vship` API directly instead of using VapourSynth based CVVDP with inefficient seeking/decoding/computing.

**`Av1an` on the other hand:**
Relies on Python -> Vapoursynth -> FFmpeg -> Encoder and it means multiple pipe/subprocess calls with serialization overhead. And it must also parse and execute `.vpy` scripts.
The whole overhead can be summed up as:

- Python interpreter startup
- VapourSynth initialization
- FFmpeg subprocess spawning
- Multiple encoder process creation
- Python objects <-> VapourSynth frames
- FFmpeg -> VapourSynth -> Encoder pipes and inter process communication between them. Let's say you use 32 workers: It means 32 independent ffmpeg instances, 32 vapoursynth instances and also 32 encoder instances (96 processes communicating with each other and creating memory explosion)
- If you add TQ into the equation, separate decoding/seeking and using VapourSynth based metrics create extra significant overhead
