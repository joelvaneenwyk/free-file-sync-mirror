#!/bin/bash

set -eaux

# Use BASH_SOURCE to get the current directory of the script
REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../ && pwd)

# shellcheck source=./build-gcc.sh
source "$REPO_ROOT/.github/build/build-gcc.sh"

# shellcheck source=./build-openssl.sh
source "$REPO_ROOT/.github/build/build-openssl.sh"

# Curl depends on OpenSSL hence why this comes after 'build-openssl.sh'
# shellcheck source=./build-curl.sh
source "$REPO_ROOT/.github/build/build-curl.sh"

# shellcheck source=./build-wxwidgets.sh
source "$REPO_ROOT/.github/build/build-wxwidgets.sh"
