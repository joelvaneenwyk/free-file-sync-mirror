#!/bin/bash

set -eaux
CURL_VERSION="${CURL_VERSION:-${1:-8.10.1}}"
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../ && pwd)"
BUILD_DIR="$REPO_ROOT/.build"
ARCHIVE_DIR="$REPO_ROOT/.build/archives"
INSTALL_DIR="$REPO_ROOT/.build/lib"
SOURCE_DIR="$REPO_ROOT/.build/src"
FILENAME="curl-$CURL_VERSION.tar.gz"
if [ ! -e "$ARCHIVE_DIR/$FILENAME" ]; then
  mkdir -p "$ARCHIVE_DIR"
  wget \
    "https://curl.se/download/$FILENAME" \
    -O "$ARCHIVE_DIR/$FILENAME"
fi
TARGET_DIR="$SOURCE_DIR/curl-$CURL_VERSION"
TARGET_BUILD_DIR="$BUILD_DIR/tmp/curl"
mkdir -p "$TARGET_BUILD_DIR" "$INSTALL_DIR" "$SOURCE_DIR"
if [ ! -d "$TARGET_DIR" ]; then
  tar xvf "$ARCHIVE_DIR/$FILENAME" -C "$SOURCE_DIR"
fi
cd "$TARGET_BUILD_DIR" || exit
if [ ! -e "$TARGET_BUILD_DIR/Makefile" ]; then
  "$TARGET_DIR/configure" --prefix="$INSTALL_DIR" --with-openssl --with-libssh2 --enable-versioned-symbols
fi
make -j "$(nproc)"
make install
