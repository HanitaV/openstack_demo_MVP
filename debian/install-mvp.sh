#!/usr/bin/env bash
# Debian entry point for the OpenStack MVP.
set -Eeuo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
legacy_installer="$script_dir/../ubuntu/install-mvp.sh"

if [[ ! -r /etc/os-release ]]; then
  echo 'ERROR: Cannot identify the operating system.' >&2
  exit 1
fi
source /etc/os-release
if [[ $ID != debian ]]; then
  echo "ERROR: This installer is for Debian; detected ${PRETTY_NAME}." >&2
  exit 1
fi

exec "$legacy_installer"
