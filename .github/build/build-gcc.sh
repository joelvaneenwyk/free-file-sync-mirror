#!/bin/bash
# https://raw.githubusercontent.com/Subere/build-FreeFileSync-on-raspberry-pi/master/build_gcc.sh
# cspell:ignore dphys,gnueabihf,neon,SWAPSIZE,swapfile,armv,Odroid,vfpv,multilib

set -eaux
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../ && pwd)"
BUILD_DIR="$REPO_ROOT/.build"
ARCHIVE_DIR="$REPO_ROOT/.build/archives"
INSTALL_DIR="$REPO_ROOT/.build/lib"
SOURCE_DIR="$REPO_ROOT/.build/src"
GCC_VERSION="${GCC_VERSION:-${1:-12.1.0}}"
FILENAME="gcc-$GCC_VERSION.tar.xz"
#
#  For the Pi or any computer with less than 2GB of memory.
#
if [ -f /etc/dphys-swapfile ]; then
  sudo sed -i 's/^CONF_SWAPSIZE=[0-9]*$/CONF_SWAPSIZE=1024/' /etc/dphys-swapfile
  sudo /etc/init.d/dphys-swapfile restart
fi

if [ ! -e "$ARCHIVE_DIR/$FILENAME" ]; then
  mkdir -p "$ARCHIVE_DIR"
  wget \
    "ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz" \
    -O "$ARCHIVE_DIR/$FILENAME"
fi

TARGET_DIR="$SOURCE_DIR/gcc-$GCC_VERSION"
if [ ! -d "$TARGET_DIR" ]; then
  tar xf "$ARCHIVE_DIR/$FILENAME" -C "$SOURCE_DIR"
fi
TARGET_BUILD_DIR="$BUILD_DIR/tmp/gcc"
mkdir -p "$TARGET_BUILD_DIR" "$INSTALL_DIR"

cd "$TARGET_DIR" || exit 11
"$TARGET_DIR/contrib/download_prerequisites"

#
#  Now run the ./configure which must be checked/edited beforehand.
#  Uncomment the sections below depending on your platform.  You may build
#  on a Pi3 for a target Pi Zero by uncommenting the Pi Zero section.
#  To alter the target directory set --prefix=<dir>
#

PLATFORM="$(uname -m)"

CONFIGURE_ARGS=()
CONFIGURE_ARGS+=(--prefix="$INSTALL_DIR")
CONFIGURE_ARGS+=(--disable-werror)

# x86_64
if [ "$PLATFORM" = "x86_64" ] || [ "$PLATFORM" = "MINGW64_NT-10.0-22631" ] || [ "$PLATFORM" = "MSYS_NT-10.0-22631" ]; then
  CONFIGURE_ARGS+=(
    --enable-languages="c,c++,lto,objc"
    --enable-checking=no
    --disable-multilib
  )
# Pi4
elif [ "$PLATFORM" = "Pi4" ]; then
  CONFIGURE_ARGS+=(--enable-languages="c,c++" --with-cpu=cortex-a72
    --with-fpu=neon-fp-armv8 --with-float=hard --build=arm-linux-gnueabihf
    --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-checking=no)
# Pi3+, Pi3, and new Pi2
elif [ "$PLATFORM" = "Pi3" ]; then
  CONFIGURE_ARGS+=(--enable-languages="c,c++" --with-cpu=cortex-a53
    --with-fpu=neon-fp-armv8 --with-float=hard --build=arm-linux-gnueabihf
    --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-checking=no)
# Pi Zero's
elif [ "$PLATFORM" = "PiZero" ]; then
  CONFIGURE_ARGS+=(--enable-languages="c,d,c++,fortran" --with-cpu=arm1176jzf-s
    --with-fpu=vfp --with-float=hard --build=arm-linux-gnueabihf
    --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-checking=no)
elif [ "$PLATFORM" = "Pi3" ]; then
  # Odroid-C2 AArch64
  CONFIGURE_ARGS+=(--enable-languages="c,d,c++,fortran" --with-cpu=cortex-a53 --enable-checking=no)
elif [ "$PLATFORM" = "Pi3" ]; then
  # Old Pi2
  CONFIGURE_ARGS+=(--enable-languages="c,d,c++,fortran" --with-cpu=cortex-a7
    --with-fpu=neon-vfpv4 --with-float=hard --build=arm-linux-gnueabihf
    --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-checking=no)
fi

cd "$TARGET_BUILD_DIR" || exit 12
export CFLAGS="-Wno-error"
export CXXFLAGS="-Wno-error"
CONFIG="$(realpath -s --relative-to="$TARGET_BUILD_DIR" "$TARGET_DIR/configure")"
"$CONFIG" "${CONFIGURE_ARGS[@]}"

#
#  Now build GCC which will take a long time.  This could range from
#  4.5 hours on a Pi3B+ up to about 50 hours on a Pi Zero.  It can be
#  left to complete overnight (or over the weekend for a Pi Zero :-)
#  The most likely causes of failure are lack of disk space, lack of
#  swap space or memory, or the wrong configure section uncommented.
#  The new compiler is placed in /usr/local/bin, the existing compiler remains
#  in /usr/bin and may be used by giving its version gcc-6 (say).
#
cd "$TARGET_BUILD_DIR" || exit 13
make -v -j "$(nproc)"
make -j "$(nproc)" install
