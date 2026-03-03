#!/bin/bash

# Build aapt2 for Linux (x86_64 or x86).
# Usage: ./build.sh <architecture>
# Architectures: x86_64, x86
# Output: aapt2_64 (64-bit) or aapt2 (32-bit)

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

root="$(pwd)"

# Install protobuf compiler.
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

build_directory="build"
aapt_binary_path="$root/$build_directory/cmake/aapt2"

# Switch to cmake build directory.
mkdir -p "$build_directory" && cd "$build_directory" || exit 1

# Set compiler flags for architecture.
if [[ "$architecture" == "x86" ]]; then
    arch_c_flags="-m32"
    arch_cxx_flags="-m32"
    arch_linker_flags="-m32"
else
    arch_c_flags=""
    arch_cxx_flags=""
    arch_linker_flags=""
fi

# Run cmake for the target architecture.
cmake -GNinja \
-DCMAKE_C_COMPILER=gcc \
-DCMAKE_CXX_COMPILER=g++ \
-DCMAKE_C_FLAGS="$arch_c_flags" \
-DCMAKE_CXX_FLAGS="$arch_cxx_flags" \
-DCMAKE_EXE_LINKER_FLAGS="$arch_linker_flags" \
-DCMAKE_BUILD_WITH_INSTALL_RPATH=True \
-DCMAKE_BUILD_TYPE=Release \
-DTARGET_ARCH="$architecture" \
-DPROTOC_PATH="/usr/local/bin/protoc" \
.. || exit 1

ninja || exit 1

strip --strip-unneeded "$aapt_binary_path"

# Determine output binary name.
if [[ "$architecture" == "x86_64" ]]; then
    output_name="aapt2_64"
else
    output_name="aapt2"
fi

# Create bin directory.
bin_directory="$root/dist/linux-$architecture"
mkdir -p "$bin_directory"

# Copy aapt2 to bin directory with the appropriate name.
cp "$aapt_binary_path" "$bin_directory/$output_name"
echo "Built $output_name -> $bin_directory/$output_name"
