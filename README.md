# Neovim Binaries with Old GLIBC Support

This repository provides Neovim binaries compiled with old GLIBC for compatibility with older Linux distributions.

## Problem

Official Neovim binaries require newer GLIBC versions that are not available on older Linux distributions like CentOS 7, Ubuntu 16.04, or Debian 8.

## Solution

We compile Neovim in a Debian Jessie environment to ensure maximum compatibility with older systems.

## Available Architectures

- **x86_64**: Intel/AMD 64-bit systems
- **arm64**: ARM 64-bit systems (aarch64)

## Downloads

Check the [Releases](https://github.com/YOUR_USERNAME/neovim-binaries/releases) page for the latest binaries.

## Installation

1. Download the appropriate tarball for your architecture:
   ```bash
   wget https://github.com/YOUR_USERNAME/neovim-binaries/releases/latest/download/nvim-linux-x86_64.tar.gz
   ```

2. Extract the tarball:
   ```bash
   tar -xzf nvim-linux-x86_64.tar.gz
   ```

3. Add to your PATH or copy to a system directory:
   ```bash
   # Option 1: Add to PATH
   export PATH="$PWD/nvim-linux-x86_64/bin:$PATH"
   
   # Option 2: Copy to system directory
   sudo cp -r nvim-linux-x86_64/* /usr/local/
   ```

## Directory Structure

Each release contains:
```
nvim-linux-{arch}/
├── bin/
│   └── nvim
└── share/
    └── nvim/
        ├── runtime/
        └── ...
```

## Automated Builds

- Builds are automatically triggered daily to check for new Neovim releases
- If a new version is detected, binaries are built and released automatically
- Manual builds can be triggered via GitHub Actions

## Building Locally

To build locally:

```bash
# For x86_64
./build.sh x86_64

# For arm64 (requires Docker with multi-arch support)
./build.sh arm64
```

## Compatibility

These binaries are built on Debian Jessie and should work on:
- CentOS/RHEL 7+
- Ubuntu 16.04+
- Debian 8+
- Most other Linux distributions from ~2015 onwards

## License

This repository contains build scripts and automation. Neovim itself is licensed under Apache 2.0 / MIT.