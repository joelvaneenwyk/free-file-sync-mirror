#!/bin/bash

set -eaux
WXWIDGETS_VERSION="${WXWIDGETS_VERSION:-${1:-3.2.3}}"
REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && cd ../../ && pwd)
BUILD_DIR="$REPO_ROOT/.build"
FILENAME="wxWidgets-$WXWIDGETS_VERSION.tar.gz"
if [ ! -e "$BUILD_DIR/$FILENAME" ]; then
  wget \
    "https://github.com/wxWidgets/wxWidgets/releases/download/v$WXWIDGETS_VERSION/wxWidgets-$WXWIDGETS_VERSION.tar.bz2" \
    -O "$BUILD_DIR/$FILENAME"
fi
tar xvf "wxWidgets-$WXWIDGETS_VERSION.tar.bz2"
cd "wxWidgets-$WXWIDGETS_VERSION/" || exit
mkdir -p gtk-build
cd gtk-build/ || exit
../configure --disable-shared --enable-unicode --enable-no_exceptions
make -j "$(nproc)"
sudo make install
