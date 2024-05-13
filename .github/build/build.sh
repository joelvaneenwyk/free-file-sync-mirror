#!/bin/bash

set -eaux
./build-gcc.sh
./build-curl.sh
./build-openssl.sh
./build-wxwidgets.sh
