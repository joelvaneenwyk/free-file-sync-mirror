#!/bin/bash

set -eaux
VERSION="${VERSION:-${1:-3.0.0}}"
wget "https://www.openssl.org/source/openssl-$VERSION.tar.gz"
tar xvf "openssl-$VERSION.tar.gz"
cd "openssl-$VERSION" || exit
mkdir -p build
cd build || exit
../config
make -j "$(nproc)"
sudo make install
sudo ldconfig
