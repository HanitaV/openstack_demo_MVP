#!/usr/bin/env bash
set -Eeuo pipefail

required_ram_gb=8
required_disk_gb=50
source /etc/os-release
ram_gb=$(( $(awk '/MemTotal/ { print $2 }' /proc/meminfo) / 1024 / 1024 ))
disk_gb=$(df -BG --output=avail / | tail -1 | tr -dc '0-9')

echo "Debian: ${PRETTY_NAME}"
echo "RAM available: ${ram_gb} GB (recommended: ${required_ram_gb}+ GB)"
echo "Disk free: ${disk_gb} GB (recommended: ${required_disk_gb}+ GB)"
if [[ -e /dev/kvm ]]; then
  echo 'KVM available: Nova will use hardware virtualization.'
else
  echo 'KVM unavailable. Using QEMU. VM boot will be slower but suitable for MVP demo.' >&2
fi

[[ $ram_gb -ge $required_ram_gb ]] || { echo "ERROR: at least ${required_ram_gb} GB RAM is required." >&2; exit 1; }
[[ $disk_gb -ge $required_disk_gb ]] || { echo "ERROR: at least ${required_disk_gb} GB free disk is required." >&2; exit 1; }
