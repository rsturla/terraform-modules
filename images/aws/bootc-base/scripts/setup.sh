#!/usr/bin/env bash

set -euox pipefail

for script in /tmp/scripts/base/*.sh; do
  if [[ -f "$script" ]]; then
    echo "Running $script"
    bash "$script"
  fi
done
