#!/bin/bash

set -eux
./build-gcc.sh
./build-curl.sh
./build-openssl.sh
./build-wxwidgets.sh
