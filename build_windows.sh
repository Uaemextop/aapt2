#!/bin/bash

# Build aapt2 for Windows using mingw-w64 cross-compilation.
# Usage: ./build_windows.sh <architecture>
# Architectures: x86_64, x86
# Output: aapt2_64.exe (64-bit) or aapt2.exe (32-bit)

architecture=$1

if [[ -z "$architecture" ]]; then
    echo "Usage: $0 <architecture>"
    echo "Supported architectures: x86_64, x86"
    exit 1
fi

if [[ "$architecture" != "x86_64" && "$architecture" != "x86" ]]; then
    echo "Unsupported architecture: $architecture"
    echo "Supported architectures: x86_64, x86"
    exit 1
fi

# Prerequisites.
sudo apt-get update -y
sudo apt-get install \
ninja-build \
automake \
autoconf \
libtool \
build-essential \
nasm \
-y || exit 1

# Install mingw-w64 cross-compiler.
if [[ "$architecture" == "x86_64" ]]; then
    sudo apt-get install gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 -y || exit 1
    cross_prefix="x86_64-w64-mingw32"
else
    sudo apt-get install gcc-mingw-w64-i686 g++-mingw-w64-i686 -y || exit 1
    cross_prefix="i686-w64-mingw32"
fi

root="$(pwd)"

# Install protobuf compiler (host version for code generation).
cd "src/protobuf" || exit 1
./autogen.sh
./configure
make -j"$(nproc)"
sudo make install
sudo ldconfig

# Go back.
cd "$root" || exit 1

# Apply essential patches (skip Android-specific: boringssl.patch, libpng.patch).
git apply patches/aapt2.patch --whitespace=fix
git apply patches/androidfw.patch --whitespace=fix
git apply patches/incremental_delivery.patch --whitespace=fix
git apply patches/protobuf.patch --whitespace=fix
git apply patches/selinux.patch --whitespace=fix

build_directory="build-windows-$architecture"
aapt_binary_path="$root/$build_directory/cmake/aapt2.exe"

# Switch to cmake build directory.
mkdir -p "$build_directory" && cd "$build_directory" || exit 1

# Run cmake for the target architecture.
cmake -GNinja \
-DCMAKE_C_COMPILER="${cross_prefix}-gcc" \
-DCMAKE_CXX_COMPILER="${cross_prefix}-g++" \
-DCMAKE_SYSTEM_NAME=Windows \
-DCMAKE_BUILD_WITH_INSTALL_RPATH=True \
-DCMAKE_BUILD_TYPE=Release \
-DTARGET_ARCH="$architecture" \
-DPROTOC_PATH="/usr/local/bin/protoc" \
.. || exit 1

ninja || exit 1

"${cross_prefix}-strip" --strip-unneeded "$aapt_binary_path"

# Determine output binary name.
if [[ "$architecture" == "x86_64" ]]; then
    output_name="aapt2_64.exe"
else
    output_name="aapt2.exe"
fi

# Create bin directory.
bin_directory="$root/dist/windows-$architecture"
mkdir -p "$bin_directory"

# Copy aapt2 to bin directory with the appropriate name.
cp "$aapt_binary_path" "$bin_directory/$output_name"
echo "Built $output_name -> $bin_directory/$output_name"
