#!/bin/bash

set -eaux
CURL_VERSION="${CURL_VERSION:-${1:-8.10.1}}"
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../ && pwd)"
BUILD_DIR="$REPO_ROOT/.build"
FILENAME="curl-$CURL_VERSION.tar.gz"
if [ ! -e "$BUILD_DIR/$FILENAME" ]; then
  wget \
    "https://curl.se/download/$FILENAME" \
    -O "$BUILD_DIR/$FILENAME"
fi
tar xvf "$BUILD_DIR/$FILENAME" -C "$BUILD_DIR"
TARGET_DIR="$BUILD_DIR/curl-$CURL_VERSION"
mkdir -p "$TARGET_DIR/build" "$BUILD_DIR/install"
cd "$TARGET_DIR/build" || exit
if [ ! -e "$TARGET_DIR/build/Makefile" ]; then
  "$TARGET_DIR/configure" --prefix="$BUILD_DIR/install" --with-openssl --with-libssh2 --enable-versioned-symbols
fi
make -j "$(nproc)"

make install
