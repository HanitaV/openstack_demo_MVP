#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/_common.sh"
require_openrc; user_openrc
os() { timeout "$OPENSTACK_COMMAND_TIMEOUT" openstack "$@"; }

echo 'Checking or creating mvp-net...'
if ! exists openstack network show mvp-net; then os network create mvp-net; fi
echo 'Checking or creating mvp-subnet...'
if ! exists openstack subnet show mvp-subnet; then
  os subnet create --network mvp-net --subnet-range 192.168.100.0/24 --dns-nameserver 1.1.1.1 mvp-subnet
fi
echo 'Checking or creating mvp-router...'
if ! exists openstack router show mvp-router; then os router create mvp-router; fi
echo 'Attaching mvp-subnet to mvp-router...'
os router add subnet mvp-router mvp-subnet 2>/dev/null || true

admin_openrc
echo 'Checking the optional public network gateway...'
if exists openstack network show public; then
  os router set --external-gateway public mvp-router
else
  echo 'No public external network found; Horizon console access remains available for the MVP.'
fi

user_openrc
echo 'Adding ICMP and SSH rules to the default security group...'
default_group=$(os security group list --project "$(os project show -f value -c id "$PROJECT_NAME")" -f value -c ID | head -n1)
if [[ -n "$default_group" ]]; then
  os security group rule create --protocol icmp "$default_group" 2>/dev/null || true
  os security group rule create --protocol tcp --dst-port 22 "$default_group" 2>/dev/null || true
fi
echo 'Network setup complete.'
os network show mvp-net
