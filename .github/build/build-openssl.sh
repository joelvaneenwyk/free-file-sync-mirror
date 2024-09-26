#!/bin/bash

set -eaux
OPENSSL_VERSION="${OPENSSL_VERSION:-${1:-3.0.0}}"
REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../ && pwd)
BUILD_DIR="$REPO_ROOT/.build"
FILENAME="openssl-$OPENSSL_VERSION.tar.gz"
if [ ! -e "$BUILD_DIR/$FILENAME" ]; then
  wget \
    "https://www.openssl.org/source/$FILENAME" \
    -O "$BUILD_DIR/$FILENAME"
fi
tar xvf "$BUILD_DIR/$FILENAME" -C "$BUILD_DIR"
cd "$BUILD_DIR/openssl-$OPENSSL_VERSION" || exit
mkdir -p build
cd build || exit
../config
make -j "$(nproc)"
# sudo make install
# sudo ldconfig
