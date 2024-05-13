#!/bin/bash

set -eaux
VERSION="${VERSION:-${1:-3.2.3}}"
wget "https://github.com/wxWidgets/wxWidgets/releases/download/v$VERSION/wxWidgets-$VERSION.tar.bz2"
tar xvf "wxWidgets-$VERSION.tar.bz2"
cd "wxWidgets-$VERSION/" || exit
mkdir -p gtk-build
cd gtk-build/ || exit
../configure --disable-shared --enable-unicode --enable-no_exceptions
make -j "$(nproc)"
sudo make install
