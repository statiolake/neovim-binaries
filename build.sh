#!/bin/bash
set -euo pipefail

ARCH=${1:-$(uname -m)}
NEOVIM_VERSION=${2:-"latest"}
CMAKE_BUILD_TYPE=${3:-"Release"}

echo "Building Neovim for architecture: $ARCH"

# Get latest version if not specified
if [ "$NEOVIM_VERSION" = "latest" ]; then
    NEOVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name"' | sed 's/.*"tag_name": "\([^"]*\)".*/\1/')
    echo "Latest Neovim version: $NEOVIM_VERSION"
fi

# Clone Neovim source with shallow checkout for specific version
if [ ! -d "neovim" ]; then
    git clone --depth 1 --branch "$NEOVIM_VERSION" https://github.com/neovim/neovim.git
else
    cd neovim
    git fetch --depth 1 origin "$NEOVIM_VERSION"
    git checkout "$NEOVIM_VERSION"
    cd ..
fi

cd neovim

# Clean previous builds
rm -rf build .deps

# Build dependencies using CMake (following official workflow)
echo "Building dependencies..."
cmake -S cmake.deps -B .deps -G Ninja \
    -D CMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE"
cmake --build .deps

# Build Neovim using CMake (following official workflow)
echo "Building Neovim..."
cmake -B build -G Ninja \
    -D CMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE"
cmake --build build

# Package using cpack (following official workflow)
echo "Packaging..."
cpack --config build/CPackConfig.cmake -G TGZ

# Move the generated tarball to expected location
mv build/nvim-linux-${ARCH}.tar.gz ../

cd ..

echo "Build completed: nvim-linux-${ARCH}.tar.gz"