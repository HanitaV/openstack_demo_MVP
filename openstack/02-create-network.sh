#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/_common.sh"
require_openrc; user_openrc

if ! exists openstack network show mvp-net; then openstack network create mvp-net; fi
if ! exists openstack subnet show mvp-subnet; then
  openstack subnet create --network mvp-net --subnet-range 192.168.100.0/24 --dns-nameserver 1.1.1.1 mvp-subnet
fi
if ! exists openstack router show mvp-router; then openstack router create mvp-router; fi
openstack router add subnet mvp-router mvp-subnet 2>/dev/null || true

admin_openrc
if exists openstack network show public; then
  openstack router set --external-gateway public mvp-router
else
  echo 'No public external network found; Horizon console access remains available for the MVP.'
fi

user_openrc
default_group=$(openstack security group list --project "$(openstack project show -f value -c id "$PROJECT_NAME")" -f value -c ID | head -n1)
if [[ -n "$default_group" ]]; then
  openstack security group rule create --protocol icmp "$default_group" 2>/dev/null || true
  openstack security group rule create --protocol tcp --dst-port 22 "$default_group" 2>/dev/null || true
fi
openstack network show mvp-net
