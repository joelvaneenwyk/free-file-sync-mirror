#!/bin/bash

set -eaux
WXWIDGETS_VERSION="${WXWIDGETS_VERSION:-${1:-3.2.3}}"
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../ && pwd)"
BUILD_DIR="$REPO_ROOT/.build"
FILENAME="wxWidgets-$WXWIDGETS_VERSION.tar.bz2"
if [ ! -e "$BUILD_DIR/$FILENAME" ]; then
  # e.g., https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.3/wxWidgets-3.2.3.tar.bz2
  wget \
    "https://github.com/wxWidgets/wxWidgets/releases/download/v$WXWIDGETS_VERSION/$FILENAME" \
    -O "$BUILD_DIR/$FILENAME"
fi
tar xvf "$BUILD_DIR/$FILENAME" -C "$BUILD_DIR"
TARGET_DIR="$BUILD_DIR/wxWidgets-$WXWIDGETS_VERSION"
mkdir -p "$TARGET_DIR/gtk-build" "$BUILD_DIR/install"
cd "$TARGET_DIR/gtk-build" || exit
if [ ! -e "$TARGET_DIR/gtk-build/Makefile" ]; then
  "$TARGET_DIR/configure" \
    --disable-shared \
    --enable-unicode \
    --enable-no_exceptions \
    --prefix="$BUILD_DIR/install"
fi
make -j "$(nproc)"
make install
