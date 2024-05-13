#!/bin/bash

set -eaux
VERSION="${VERSION:-${1:-8.4.0}}"
wget "https://curl.se/download/curl-$VERSION.tar.gz"
tar xvf "curl-$VERSION.tar.gz"
cd "curl-$VERSION/" || exit
mkdir -p build
cd build/ || exit
../configure --with-openssl --with-libssh2 --enable-versioned-symbols
make -j "$(nproc)"
sudo make install
