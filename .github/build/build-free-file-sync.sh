#!/bin/bash

if [ -e "/etc/profile" ]; then
  # shellcheck disable=SC1091
  source /etc/profile || true
fi

set -eaux
CURL_VERSION="${CURL_VERSION:-${1:-8.10.1}}"
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../ && pwd)"
BUILD_DIR="$REPO_ROOT/.build"
INSTALL_DIR="$REPO_ROOT/.build/lib"
SOURCE_DIR="$REPO_ROOT/FreeFileSync/Source"
PATH="$BUILD_DIR/lib/bin:${PATH:-}"
TARGET_BUILD_DIR="$BUILD_DIR/tmp/freefilesync"
mkdir -p "$TARGET_BUILD_DIR" "$INSTALL_DIR"
cd "$SOURCE_DIR" || exit
make -j "$(nproc)" all
# make -C "$REPO_ROOT/FreeFileSync/Source" install
