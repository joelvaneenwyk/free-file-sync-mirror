#!/bin/bash

set -eaux
WXWIDGETS_VERSION="${WXWIDGETS_VERSION:-${1:-3.2.3}}"
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../ && pwd)"
BUILD_DIR="$REPO_ROOT/.build"
INSTALL_DIR="$REPO_ROOT/.build/lib"
FILENAME="wxWidgets-$WXWIDGETS_VERSION.tar.bz2"
if [ ! -e "$BUILD_DIR/$FILENAME" ]; then
  # e.g., https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.3/wxWidgets-3.2.3.tar.bz2
  mkdir -p "$BUILD_DIR"
  wget \
    "https://github.com/wxWidgets/wxWidgets/releases/download/v$WXWIDGETS_VERSION/$FILENAME" \
    -O "$BUILD_DIR/$FILENAME"
fi
tar xf "$BUILD_DIR/$FILENAME" -C "$BUILD_DIR"
TARGET_DIR="$BUILD_DIR/wxWidgets-$WXWIDGETS_VERSION"
TARGET_BUILD_DIR="$BUILD_DIR/tmp/wx"
mkdir -p "$TARGET_BUILD_DIR" "$INSTALL_DIR"
cd "$TARGET_BUILD_DIR" || exit
if [ ! -e "$TARGET_BUILD_DIR/Makefile" ]; then
  "$TARGET_DIR/configure" \
    --prefix="$INSTALL_DIR" \
    --disable-shared \
    --enable-unicode \
    --enable-no_exceptions
fi
make -j "$(nproc)"
make install
