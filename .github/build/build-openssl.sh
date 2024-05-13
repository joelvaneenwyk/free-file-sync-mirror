#!/bin/bash

set -eux
wget https://www.openssl.org/source/openssl-3.0.0.tar.gz
tar xvf openssl-3.0.0.tar.gz
cd openssl-3.0.0 || exit
mkdir -p build
cd build || exit
../config
make -j "$(nproc)"
sudo make install
sudo ldconfig
