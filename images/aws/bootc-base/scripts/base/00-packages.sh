#!/usr/bin/env bash

set -euox pipefail

echo "Installing General Packages..."
dnf install -y \
  epel-release \
  unzip
