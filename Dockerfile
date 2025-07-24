FROM debian:stretch

# Use archive.debian.org for old Debian versions
RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list && \
    apt-get update && apt-get install -y \
    build-essential \
    cmake \
    curl \
    gettext \
    git \
    libtool \
    libtool-bin \
    pkg-config \
    unzip \
    wget \
    autoconf \
    automake \
    ninja-build \
    python3-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install newer CMake for better support (3.13+ required for Neovim)
RUN wget -O cmake.tar.gz https://cmake.org/files/v3.20/cmake-3.20.6-linux-x86_64.tar.gz \
    && tar -xzf cmake.tar.gz -C /opt \
    && ln -sf /opt/cmake-3.20.6-linux-x86_64/bin/cmake /usr/local/bin/cmake \
    && ln -sf /opt/cmake-3.20.6-linux-x86_64/bin/cpack /usr/local/bin/cpack \
    && rm cmake.tar.gz

WORKDIR /build