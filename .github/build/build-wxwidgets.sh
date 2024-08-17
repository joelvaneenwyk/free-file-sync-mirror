#!/bin/bash

set -eaux
WXWIDGETS_VERSION="${WXWIDGETS_VERSION:-${1:-3.2.3}}"
wget "https://github.com/wxWidgets/wxWidgets/releases/download/v$WXWIDGETS_VERSION/wxWidgets-$WXWIDGETS_VERSION.tar.bz2"
tar xvf "wxWidgets-$WXWIDGETS_VERSION.tar.bz2"
cd "wxWidgets-$WXWIDGETS_VERSION/" || exit
mkdir -p gtk-build
cd gtk-build/ || exit
../configure --disable-shared --enable-unicode --enable-no_exceptions
make -j "$(nproc)"
sudo make install
