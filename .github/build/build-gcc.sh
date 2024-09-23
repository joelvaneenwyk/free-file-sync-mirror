#!/bin/bash
# https://raw.githubusercontent.com/Subere/build-FreeFileSync-on-raspberry-pi/master/build_gcc.sh
# cspell:ignore dphys,gnueabihf,neon,SWAPSIZE,swapfile,armv,Odroid,vfpv,multilib

set -eaux
REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../ && pwd)

#
#  This is the new GCC version to install.
#
# takes about 4 hours (Raspberry Pi 4, 4GB)
#

#
#  For the Pi or any computer with less than 2GB of memory.
#
if [ -f /etc/dphys-swapfile ]; then
  sudo sed -i 's/^CONF_SWAPSIZE=[0-9]*$/CONF_SWAPSIZE=1024/' /etc/dphys-swapfile
  sudo /etc/init.d/dphys-swapfile restart
fi

GCC_VERSION="${GCC_VERSION:-${1:-12.1.0}}"
BUILD_DIR="$REPO_ROOT/.build"
FILENAME="gcc-$GCC_VERSION.tar.xz"
if [ ! -e "$BUILD_DIR/$FILENAME" ]; then
  mkdir -p "$BUILD_DIR"
  wget \
    "ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz" \
    -O "$BUILD_DIR/$FILENAME"
fi

GCC_BUILD_DIR="$BUILD_DIR/gcc-$GCC_VERSION"
if [ ! -d "$GCC_BUILD_DIR" ]; then
  tar xf "$BUILD_DIR/$FILENAME" -C "$BUILD_DIR"
fi

cd "$BUILD_DIR/gcc-$GCC_VERSION" || exit
./contrib/download_prerequisites
cd "$GCC_BUILD_DIR" || exit
mkdir -p obj
cd obj || exit 34

#
#  Now run the ./configure which must be checked/edited beforehand.
#  Uncomment the sections below depending on your platform.  You may build
#  on a Pi3 for a target Pi Zero by uncommenting the Pi Zero section.
#  To alter the target directory set --prefix=<dir>
#

PLATFORM="$(uname -m)"
# Pi4
if [ "$PLATFORM" = "Pi4" ]; then
  ../configure --enable-languages=c,c++ --with-cpu=cortex-a72 \
    --with-fpu=neon-fp-armv8 --with-float=hard --build=arm-linux-gnueabihf \
    --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-checking=no
# Pi3+, Pi3, and new Pi2
elif [ "$PLATFORM" = "Pi3" ]; then
  ../configure --enable-languages=c,c++ --with-cpu=cortex-a53 \
    --with-fpu=neon-fp-armv8 --with-float=hard --build=arm-linux-gnueabihf \
    --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-checking=no
# Pi Zero's
elif [ "$PLATFORM" = "PiZero" ]; then
  ../configure --enable-languages=c,d,c++,fortran --with-cpu=arm1176jzf-s \
    --with-fpu=vfp --with-float=hard --build=arm-linux-gnueabihf \
    --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-checking=no
# x86_64
elif [ "$PLATFORM" = "x86_64" ] || [ "$PLATFORM" = "MINGW64_NT-10.0-22631" ]; then
  ../configure --disable-multilib --enable-languages=c,d,c++,fortran --enable-checking=no
elif [ "$PLATFORM" = "Pi3" ]; then
  # Odroid-C2 AArch64
  ../configure --enable-languages=c,d,c++,fortran --with-cpu=cortex-a53 --enable-checking=no
elif [ "$PLATFORM" = "Pi3" ]; then
  # Old Pi2
  ../configure --enable-languages=c,d,c++,fortran --with-cpu=cortex-a7 \
    --with-fpu=neon-vfpv4 --with-float=hard --build=arm-linux-gnueabihf \
    --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-checking=no
fi

#
#  Now build GCC which will take a long time.  This could range from
#  4.5 hours on a Pi3B+ up to about 50 hours on a Pi Zero.  It can be
#  left to complete overnight (or over the weekend for a Pi Zero :-)
#  The most likely causes of failure are lack of disk space, lack of
#  swap space or memory, or the wrong configure section uncommented.
#  The new compiler is placed in /usr/local/bin, the existing compiler remains
#  in /usr/bin and may be used by giving its version gcc-6 (say).
#
if make -j "$(nproc)"; then
  echo
  read -r -p "Do you wish to install the new GCC (y/n)? " yn
  case $yn in
  [Yy]*) sudo make install ;;
  *) exit ;;
  esac
fi
