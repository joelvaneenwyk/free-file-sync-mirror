#!/bin/bash

if [ -e "/etc/profile" ]; then
  # shellcheck disable=SC1091
  source /etc/profile || true
fi

set -eaux
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../ && pwd)"
BUILD_DIR="$REPO_ROOT/.build"
INSTALL_DIR="$REPO_ROOT/.build/lib"
TARGET_BUILD_DIR="$BUILD_DIR/tmp/freefilesync"
mkdir -p "$TARGET_BUILD_DIR" "$INSTALL_DIR"

PATH="$BUILD_DIR/lib/bin:${PATH:-}"

SOURCE_DIR="$REPO_ROOT/FreeFileSync/Source"
SOURCE_DIR_REL="$(realpath -s --relative-to="$TARGET_BUILD_DIR" "$SOURCE_DIR")"
cd "$TARGET_BUILD_DIR" || exit
make -C "$SOURCE_DIR_REL" -j "$(nproc)" all
# make -C "$REPO_ROOT/FreeFileSync/Source" install
