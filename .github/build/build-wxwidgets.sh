#!/bin/bash

set -eaux
WXWIDGETS_VERSION="${WXWIDGETS_VERSION:-${1:-3.2.3}}"
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../ && pwd)"
BUILD_DIR="$REPO_ROOT/.build"
ARCHIVE_DIR="$REPO_ROOT/.build/archives"
INSTALL_DIR="$REPO_ROOT/.build/lib"
SOURCE_DIR="$REPO_ROOT/.build/src"
FILENAME="wxWidgets-$WXWIDGETS_VERSION.tar.bz2"
if [ ! -e "$ARCHIVE_DIR/$FILENAME" ]; then
  # e.g., https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.3/wxWidgets-3.2.3.tar.bz2
  mkdir -p "$ARCHIVE_DIR"
  wget \
    "https://github.com/wxWidgets/wxWidgets/releases/download/v$WXWIDGETS_VERSION/$FILENAME" \
    -O "$ARCHIVE_DIR/$FILENAME"
fi
TARGET_DIR="$SOURCE_DIR/wxWidgets-$WXWIDGETS_VERSION"
if [ ! -d "$TARGET_DIR" ]; then
  mkdir -p "$SOURCE_DIR"
  tar xf "$ARCHIVE_DIR/$FILENAME" -C "$SOURCE_DIR"
fi
TARGET_BUILD_DIR="$BUILD_DIR/tmp/wx"
mkdir -p "$TARGET_BUILD_DIR" "$INSTALL_DIR"
cd "$TARGET_BUILD_DIR" || exit
if [ ! -e "$TARGET_BUILD_DIR/Makefile" ]; then
  CONFIG="$(realpath -s --relative-to="$TARGET_BUILD_DIR" "$TARGET_DIR/configure")"
  "$CONFIG" \
    --prefix="$INSTALL_DIR" \
    --disable-shared \
    --disable-stc \
    --enable-unicode \
    --enable-no_exceptions
fi
make -j "$(nproc)"
make install
