#!/bin/bash

set -eaux
OPENSSL_VERSION="${OPENSSL_VERSION:-${1:-3.0.0}}"
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../ && pwd)"
BUILD_DIR="$REPO_ROOT/.build"
ARCHIVE_DIR="$REPO_ROOT/.build/archives"
INSTALL_DIR="$REPO_ROOT/.build/lib"
SOURCE_DIR="$REPO_ROOT/.build/src"
FILENAME="openssl-$OPENSSL_VERSION.tar.gz"
if [ ! -e "$ARCHIVE_DIR/$FILENAME" ]; then
  wget \
    "https://www.openssl.org/source/$FILENAME" \
    -O "$ARCHIVE_DIR/$FILENAME"
fi
TARGET_DIR="$SOURCE_DIR/openssl-$OPENSSL_VERSION"
if [ ! -d "$TARGET_DIR" ]; then
  tar xvf "$ARCHIVE_DIR/$FILENAME" -C "$SOURCE_DIR"
fi
TARGET_BUILD_DIR="$BUILD_DIR/tmp/openssl"
mkdir -p "$TARGET_BUILD_DIR" "$INSTALL_DIR"
cd "$TARGET_BUILD_DIR" || exit 21
"$TARGET_DIR/config" --prefix="$INSTALL_DIR"
make -j "$(nproc)"
make install
# sudo ldconfig
