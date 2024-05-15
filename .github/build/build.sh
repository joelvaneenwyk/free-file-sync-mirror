#!/bin/bash

# Use BASH_SOURCE to get the current directory of the script
REPO_ROOT="$(dirname "${BASH_SOURCE[0]}")"

set -eaux
"$REPO_ROOT/build-gcc.sh"
"$REPO_ROOT/build-curl.sh"
"$REPO_ROOT/build-openssl.sh"
"$REPO_ROOT/build-wxwidgets.sh"
