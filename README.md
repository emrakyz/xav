# xav - eXtreme AOMedia Video

The Most Efficient Chunked or Target Quality AV1/AV2 Encoding Framework

## Table of Contents

1. [Dependencies](#dependencies)
2. [Description](#description)
3. [Features](#features)
4. [Design Decisions](#design-decisions)
5. [Why Is It Fast and Minimal Especially Compared to Av1an](#why-is-it-fast-and-minimal-especially-compared-to-av1an)
6. [Installation](#installation)
7. [Usage](#usage)
8. [Building](#building)
9. [Video Showcase](#video-showcase)
10. [Credits](#credits)

## Dependencies

- Nothing really, (except svt-av1 for actual encoding and `mkvmerge` to concat video streams) if you use the pre-compiled binaries or build it statically with the provided tool.
- Naturally, TQ feature would require [VSHIP](https://github.com/Line-fr/Vship) library being installed (no need for VapourSynth) since it's based on CUDA/HIP.
- Currently, only forks ([SVT-AV1-HDR](https://github.com/juliobbv-p/svt-av1-hdr) and [-PSYEX](https://github.com/BlueSwordM/svt-av1-psyex)) support `--progress 3` if progress monitoring is desired.

## Description

`xav` aims to be the fastest, most minimal AV1 (and potentially AV2) encoding framework. By keeping its feature scope limited, the potential for the best encoder and the best video quality metric can be maximized without getting limited by extensive features.

As the author has been involved with the `av1an` project since its inception as a user and continues to develop it; creating a direct competitor without purpose was not the objective. `xav` is a faster, more minimal alternative to Av1an's most popular features and the author acknowledges that `av1an` is the most powerful & feature-rich video encoding framework. This tool was developed with a strong interest and focus on the "av1an" concept.

## Features

- Parses `--progress 3` output of `svt-av1` (WIP feature for mainline and available on forks such as ([SVT-AV1-HDR](https://github.com/juliobbv-p/svt-av1-hdr) and [-PSYEX](https://github.com/BlueSwordM/svt-av1-psyex))
- Parses color and video metadata (container & frame based) to encoders automatically, including HDR metadata (Dolby Vision RPU automation for chunking is considered), FPS and resolution.
- Offers fun process monitoring with almost no overhead for indexing, SCD, and encoding processes.

## Design Decisions

It sets sane defaults without offering flags such as auto setting up the SCD algorithm.

```text
min_dist = (fps_num + fps_den / 2) / fps_den;
max_dist = ((fps_num * 10 + fps_den / 2) / fps_den).min(300);
```

- Here we simply utilize 1 second to 10 second min/max scene durations and maximum 5 second scene duration for 60+ FPS content. Max SCD duration has also an additional purpose here: Since the frame data is buffered up-front, instead of streamed; very long chunks can easily create memory explosion.
- Overwhelming options such as different chunking methods, orders, pixel formats, or similar options are removed or not offered.
- `xav` takes a stance that is similar to [SVT-AV1-Essential](https://github.com/nekotrix/SVT-AV1-Essential) on 10bit only encoding: It does not allow 8bit encoding.

## Why Is It Fast and Minimal Especially Compared to Av1an

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
- TQ (WIP): Can directly use already handled frames for encoding, for metric comparison as well by utilizing `vship` API directly instead of using VapourSynth based SSIMU2 with inefficient seeking/decoding/computing.

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

## Installation

Download the binary specific to your arch from the Releases page and extract them in your PATH. The pre-compiled binaries have all the dependencies and built statically with extensive optimizations.

## Usage

Usage is very simple. Can be seen from the tool's help output:

<img width="1500" height="808" alt="a" src="https://github.com/user-attachments/assets/7fba8d8b-ac19-47d4-a100-4a54170f5ac7" />


## Building

Run the `build_all_static.sh` script to build ffms2 statically and build the main tool with it. This is the indended way for maximum performance.

For dynamic builds, you need ffmpegsource (ffms2) installed on your system and ffmpeg (for av-scenechange) and run `build_dynamic.sh`.

**NOTE:** Building this tool statically requires you to have static libraries in your system for the C library (glibc), CXX library (libstdc++ or libc++), llvm-libunwind, compiler-rt. They are usually found with `-static`, `-dev`, `-git` suffixes in package managers. 

## Video Showcase

<video
  width="1200px" controls preload="metadata" type="video/mp4"
  src="https://github.com/user-attachments/assets/228a4f22-b687-449d-9eb6-d0d2e7630e83">
</video>

## Software Used by This Project

- [SVT-AV1](https://gitlab.com/AOMediaCodec/SVT-AV1) / [SVT-AV1-HDR](https://github.com/juliobbv-p/svt-av1-hdr) / [SVT-AV1-PSYEX](https://github.com/BlueSwordM/svt-av1-psyex)
- [FFMS2](https://github.com/FFMS/ffms2)
- (WIP) [ZIMG](https://github.com/sekrit-twc/zimg) (for RGB conversion needed by VSHIP SSIMULACRA2 computation)
- (WIP) [VSHIP](https://github.com/Line-fr/Vship)

## Credits

Huge thanks to [Soda](https://github.com/GreatValueCreamSoda) for the tremendous help & motivation & support to build this tool, and more importantly, for his friendship along the way. He is the partner in crime.
