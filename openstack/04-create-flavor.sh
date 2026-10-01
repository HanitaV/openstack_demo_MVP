#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/_common.sh"
require_openrc; admin_openrc

if ! exists openstack flavor show mvp.nano; then
  openstack flavor create --ram 512 --vcpus 1 --disk 1 --public mvp.nano
fi
openstack flavor show mvp.nano
