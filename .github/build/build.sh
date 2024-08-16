#!/bin/bash

# Use BASH_SOURCE to get the current directory of the script
REPO_ROOT="$(dirname "${BASH_SOURCE[0]}")"

set -eaux

# shellcheck source=./build-gcc.sh
source "$REPO_ROOT/build-gcc.sh"

# shellcheck source=./build-curl.sh
source "$REPO_ROOT/build-curl.sh"

# shellcheck source=./build-openssl.sh
source "$REPO_ROOT/build-openssl.sh"

# shellcheck source=./build-wxwidgets.sh
source "$REPO_ROOT/build-wxwidgets.sh"
