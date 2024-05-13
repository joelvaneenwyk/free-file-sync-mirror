#!/bin/bash
# https://raw.githubusercontent.com/Subere/build-FreeFileSync-on-raspberry-pi/master/build_gcc.sh

set -eux

#
#  This is the new GCC version to install.
#
# takes about 4 hours (Raspberry Pi 4, 4GB)
#
VERSION="${VERSION:-${1:-10.1.0}}"

#
#  For the Pi or any computer with less than 2GB of memory.
#
if [ -f /etc/dphys-swapfile ]; then
    sudo sed -i 's/^CONF_SWAPSIZE=[0-9]*$/CONF_SWAPSIZE=1024/' /etc/dphys-swapfile
    sudo /etc/init.d/dphys-swapfile restart
fi

if [ -d "gcc-$VERSION" ]; then
    cd "gcc-$VERSION" || exit
    rm -rf obj
else
    wget "ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-$VERSION/gcc-$VERSION.tar.xz"
    tar xf "gcc-$VERSION.tar.xz"
    rm -f "gcc-$VERSION.tar.xz"
    cd "gcc-$VERSION" || exit
    contrib/download_prerequisites
fi
mkdir -p obj
cd obj || exit

#
#  Now run the ./configure which must be checked/edited beforehand.
#  Uncomment the sections below depending on your platform.  You may build
#  on a Pi3 for a target Pi Zero by uncommenting the Pi Zero section.
#  To alter the target directory set --prefix=<dir>
#

# Pi4
../configure --enable-languages=c,c++ --with-cpu=cortex-a72 \
    --with-fpu=neon-fp-armv8 --with-float=hard --build=arm-linux-gnueabihf \
    --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-checking=no

# Pi3+, Pi3, and new Pi2
#../configure --enable-languages=c,c++ --with-cpu=cortex-a53 \
#  --with-fpu=neon-fp-armv8 --with-float=hard --build=arm-linux-gnueabihf \
#  --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-checking=no

# Pi Zero's
#../configure --enable-languages=c,d,c++,fortran --with-cpu=arm1176jzf-s \
#  --with-fpu=vfp --with-float=hard --build=arm-linux-gnueabihf \
#  --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-checking=no

# x86_64
#../configure --disable-multilib --enable-languages=c,d,c++,fortran --enable-checking=no

# Odroid-C2 AArch64
#../configure --enable-languages=c,d,c++,fortran --with-cpu=cortex-a53 --enable-checking=no

# Old Pi2
#../configure --enable-languages=c,d,c++,fortran --with-cpu=cortex-a7 \
#  --with-fpu=neon-vfpv4 --with-float=hard --build=arm-linux-gnueabihf \
#  --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-checking=no

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
