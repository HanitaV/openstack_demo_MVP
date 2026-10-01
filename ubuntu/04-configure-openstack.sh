#!/usr/bin/env bash
set -Eeuo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
devstack_dir=${DEVSTACK_DIR:-$HOME/devstack}
[[ -d "$devstack_dir" ]] || { echo "DevStack not found at $devstack_dir" >&2; exit 1; }
cp "$script_dir/local.conf.example" "$devstack_dir/local.conf"
vm_ip=$(hostname -I | awk '{print $1}')
network_interface=$(ip route show default | awk '/default/ {print $5; exit}')
sed -i "s/^HOST_IP=.*/HOST_IP=${vm_ip}/; s/^PUBLIC_INTERFACE=.*/PUBLIC_INTERFACE=${network_interface}/" "$devstack_dir/local.conf"
if [[ ! -e /dev/kvm ]]; then
  sed -i 's/^#LIBVIRT_TYPE=qemu/LIBVIRT_TYPE=qemu/' "$devstack_dir/local.conf"
fi
echo "Generated $devstack_dir/local.conf"
