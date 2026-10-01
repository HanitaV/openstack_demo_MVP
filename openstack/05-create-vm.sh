#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/_common.sh"
require_openrc; user_openrc

if ! exists openstack server show mvp-vm01; then
  openstack server create --flavor mvp.nano --image mvp-cirros --network mvp-net --wait mvp-vm01
fi
wait_for 'mvp-vm01 to become ACTIVE' "[[ \$(openstack server show -f value -c status mvp-vm01) == ACTIVE ]]" 60
openstack server show mvp-vm01
