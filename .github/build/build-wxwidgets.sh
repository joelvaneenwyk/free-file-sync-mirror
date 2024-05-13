#!/bin/bash

set -eux
wget https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.3/wxWidgets-3.2.3.tar.bz2
tar xvf wxWidgets-3.2.3.tar.bz2
cd wxWidgets-3.2.3/ || exit
mkdir gtk-build
cd gtk-build/ || exit
../configure --disable-shared --enable-unicode --enable-no_exceptions
make -j "$(nproc)"
sudo make install
