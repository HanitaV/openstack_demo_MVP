#!/usr/bin/env bash
set -Eeuo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
devstack_dir=${DEVSTACK_DIR:-$HOME/devstack}

if [[ $EUID -eq 0 ]]; then
  echo 'Run this script as a non-root sudo-enabled Debian user.' >&2
  exit 1
fi
source /etc/os-release
case "${ID}:${VERSION_ID}" in
  debian:12|debian:13) ;;
  *) echo "ERROR: Debian 12 or 13 is supported; detected ${PRETTY_NAME}." >&2; exit 1 ;;
esac

"$script_dir/01-check-vm.sh"
curl --fail --silent --show-error --connect-timeout 10 https://opendev.org/ >/dev/null
"$script_dir/02-install-dependencies.sh"
"$script_dir/03-install-devstack.sh"
"$script_dir/04-configure-openstack.sh"

echo 'Starting DevStack. This can take 20–45 minutes.'
"$devstack_dir/stack.sh"
set +u
source "$devstack_dir/openrc" admin admin
set -u
openstack token issue >/dev/null
for service in nova glance cinderv3 keystone neutron; do
  openstack endpoint list --service "$service" -f value -c ID | grep -q . || {
    echo "ERROR: no endpoint registered for required service: $service" >&2
    exit 1
  }
done
vm_ip=$(hostname -I | awk '{print $1}')
cat <<EOF

============================================

OPENSTACK MVP INSTALLED

Horizon:
http://${vm_ip}/dashboard

Core exam services:

Nova    OK
Glance  OK
Cinder  OK

Support:

Keystone OK
Neutron  OK
Horizon  OK

============================================
EOF
echo 'Next: run ../openstack/01-create-project.sh through 07-attach-volume.sh.'
