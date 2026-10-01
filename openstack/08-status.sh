#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/_common.sh"
require_openrc; user_openrc

openstack token issue
openstack image list --name mvp-cirros
openstack server list --name mvp-vm01
openstack volume list --name mvp-volume01
openstack network show mvp-net
