#!/bin/bash
set -euo pipefail

ARCH=${1:-$(uname -m)}
NEOVIM_VERSION=${2:-"latest"}

echo "Building Neovim for architecture: $ARCH"

# Get latest version if not specified
if [ "$NEOVIM_VERSION" = "latest" ]; then
    NEOVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name"' | sed 's/.*"tag_name": "\([^"]*\)".*/\1/')
    echo "Latest Neovim version: $NEOVIM_VERSION"
fi

# Clone or update Neovim source
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

# Build dependencies
make CMAKE_BUILD_TYPE=Release deps

# Build Neovim
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/tmp/nvim-install

# Install to temporary directory
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/tmp/nvim-install install

# Create the target directory structure
mkdir -p "../nvim-linux-${ARCH}"
cp -r /tmp/nvim-install/bin "../nvim-linux-${ARCH}/"
cp -r /tmp/nvim-install/share "../nvim-linux-${ARCH}/"

cd ..

# Create tarball
tar -czf "nvim-linux-${ARCH}.tar.gz" "nvim-linux-${ARCH}"

echo "Build completed: nvim-linux-${ARCH}.tar.gz"
echo "Contents:"
ls -la "nvim-linux-${ARCH}/"