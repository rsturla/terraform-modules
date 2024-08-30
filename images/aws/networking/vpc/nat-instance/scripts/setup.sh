#!/usr/bin/env bash

set -euox pipefail

shopt -s nullglob
scripts=(/tmp/scripts/base/*.sh)

if [[ ${#scripts[@]} -gt 0 ]]; then
  for script in "${scripts[@]}"; do
    echo "Running $script"
    bash "$script"
  done
else
  echo "No scripts found in /tmp/scripts/base/"
fi
