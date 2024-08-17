#!/bin/bash

set -eaux
CURL_VERSION="${CURL_VERSION:-${1:-8.9.1}}"
REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && cd ../../ && pwd)
BUILD_DIR="$REPO_ROOT/.build"
FILENAME="curl-$CURL_VERSION.tar.gz"
if [ ! -e "$BUILD_DIR/$FILENAME" ]; then
  wget \
    "https://curl.se/download/$FILENAME" \
    -O "$BUILD_DIR/$FILENAME"
fi
tar xvf "$BUILD_DIR/$FILENAME" -C "$BUILD_DIR"
cd "$BUILD_DIR/curl-$CURL_VERSION/" || exit
mkdir -p build
cd build/ || exit
../configure --with-openssl --with-libssh2 --enable-versioned-symbols
make -j "$(nproc)"
sudo make install
