## Table of Contents

1. [Description](#description)
2. [Dependencies](#dependencies)
3. [Usage](#usage)
4. [Building](#building)
5. [Credits](#credits)

## Description
A totally broken, completely experimental and research-only video encoding framework specifically for power users and highest degree encoding enthusiasts.
**DO NOT USE** if you don't know what you are doing and are not extremely experienced in video encoding and its frameworks or if you have production goals.

The tool is extremely opinionated and strict and this will likely not change.
Backwards compatibility is ignored. Anything can break/removed/modified with updates.

I may possibly conflict with my reasonings in the future. I am not entitled with anything. And I have no obligations to continue with my initial reasoning or design goals I declared. Anything can change and you shouldn't care.

Building this tool is extremely complicated. Support should not be expected and releases will not be provided anytime soon. If you are not experienced in software compilation with cross-language dependencies, simply skip.

Intended for Linux-only usage. It technically works on other platforms but I do not care and handle any specific cases for compilation or runtime.

For normal use; use better, safer, more stable, less opinionated, more featureful and professional tools:
- [Av1an](https://github.com/rust-av/Av1an)
- [HandBrake](https://handbrake.fr)
- [StaxRip](https://github.com/staxrip/staxrip)
- [nmkoder](https://github.com/n00mkrad/nmkoder)
- [alabamaEncoder](https://github.com/kingstefan26/alabamaEncoder)
- [ab-av1](https://github.com/alexheretic/ab-av1)
- [aviator](https://github.com/gianni-rosato/aviator)

## Dependencies

- [SVT-AV1](https://gitlab.com/AOMediaCodec/SVT-AV1) (mainline or a fork)
- [mkvmerge](https://mkvtoolnix.download/source.html) (to concatenate chunks)
- [FFMS2](https://github.com/FFMS/ffms2) (a hard dependency for decoding)
- [VSHIP](https://github.com/Line-fr/Vship) (optional - needed for target quality encoding)
- Rust Nightly, NASM, Clang (building dependencies)

## Usage

<img width="1522" height="1076" alt="image" src="https://github.com/user-attachments/assets/890dffee-a05a-4a20-a7c8-49aa5f871cfb" />

## Building

Build script is only for Linux. You are on your own otherwise.

Run the `build.sh` script: It will guide you. You can select static or dynamic.

Building dependencies statically (handled by the script) and building the main tool with them, is the intended way for maximum performance but it's **ONLY** for advanced users due to compiler complexities.

**NOTE:** Building this tool statically requires you to have static libraries in your system for the C library (glibc), CXX library (libstdc++), llvm-libunwind, compiler-rt. They are usually found with `-static`, `-dev`, `-git` suffixes in package managers. Some package managers do not provide them, in this case; they need to be compiled manually.

## Credits

Huge thanks to [Soda](https://github.com/GreatValueCreamSoda) for the tremendous help & motivation & support to build this tool, and more importantly, for his friendship along the way. He is the partner in crime.

Also thanks [Lumen](https://github.com/Line-fr) for her great contributions on GPU based accessible state-of-the-art metric implementations and general help around the tooling.
