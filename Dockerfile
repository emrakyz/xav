FROM nvidia/cuda:12.4.1-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Base build + runtime dependencies for xav
# - SVT-AV1 encoder (SvtAv1EncApp)
# - mkvmerge (from mkvtoolnix)
# - FFMS2 (libffms2-dev)
# - toolchain + headers for Rust/C++/CUDA builds
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      build-essential \
      pkg-config \
      clang \
      nasm \
      cmake \
      svt-av1 \
      mkvtoolnix \
      libffms2-dev \
      libssl-dev \
      libclang-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Rust nightly via rustup (xav targets nightly in its README)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --default-toolchain nightly

ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /opt

# Build and install Vship (GPU metric library used for TQ with CVVDP / SSIMULACRA2 / Butteraugli).
# Follows the Make-based instructions from the Vship README:
#   make buildcuda && make install PREFIX=/usr
# The sed removes a newer nvcc flag (--compress-mode=balance) that isn't
# supported on all CUDA toolchains (e.g. CUDA 12.4 in this base image).
RUN git clone https://github.com/Line-fr/Vship.git && \
    cd Vship && \
    sed -i 's/ --compress-mode=balance//g' Makefile && \
    make buildcuda && \
    make install PREFIX=/usr

# Copy xav source into the image and build it
WORKDIR /opt/xav
COPY . .

# Dynamic build: relies on system FFMS2 + Vship + SVT-AV1
RUN cargo build --release

# Default to showing help; override in docker run if needed
ENTRYPOINT ["./target/release/xav"]
CMD ["-h"]


