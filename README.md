# Aapt2 package build workflow

[![build workflow](https://github.com/Uaemextop/aapt2/actions/workflows/build.yml/badge.svg)](https://github.com/Uaemextop/aapt2/actions/workflows/build.yml)

This repository contains a workflow to build the aapt2 binaries for Linux and Windows (for use with apktool).

## Android version

Built from **Android 16** (API level 36, codename Baklava) AOSP sources, branch `android-16.0.0_r2`.

- **TOOLS_VERSION**: 36.0.0
- **AOSP tag**: `android-16.0.0_r2`

## Build targets

| Platform | Architecture | Output binary |
|----------|-------------|---------------|
| Linux    | x86_64      | aapt2_64      |
| Linux    | x86         | aapt2         |
| Windows  | x86_64      | aapt2_64.exe  |
| Windows  | x86         | aapt2.exe     |

## Building locally

### Linux

```bash
# Build 64-bit
./build.sh x86_64

# Build 32-bit
./build.sh x86
```

### Windows (cross-compilation from Linux)

```bash
# Build 64-bit
./build_windows.sh x86_64

# Build 32-bit
./build_windows.sh x86
```

## Requirements

- GCC/G++ (build-essential)
- CMake 3.14.2+
- Ninja build system
- NASM assembler
- For 32-bit Linux builds: gcc-multilib, g++-multilib
- For Windows builds: mingw-w64

## CI Runner

The CI workflow runs on a self-hosted runner labeled `aapt2` (16 vCPU, 600GB).
