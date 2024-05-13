#!/bin/bash

set -eux
wget https://curl.se/download/curl-8.4.0.tar.gz
tar xvf curl-8.4.0.tar.gz
cd curl-8.4.0/ || exit
mkdir -p build
cd build/ || exit
../configure --with-openssl --with-libssh2 --enable-versioned-symbols
make -j "$(nproc)"
sudo make install
