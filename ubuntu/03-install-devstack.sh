#!/usr/bin/env bash
set -Eeuo pipefail

devstack_dir=${DEVSTACK_DIR:-$HOME/devstack}
if [[ ! -d "$devstack_dir/.git" ]]; then
  git clone https://opendev.org/openstack/devstack.git "$devstack_dir"
else
  git -C "$devstack_dir" pull --ff-only
fi
echo "DevStack is available at $devstack_dir"
