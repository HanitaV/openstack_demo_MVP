#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $EUID -eq 0 ]]; then
  echo 'Run as the non-root sudo-enabled Debian user.' >&2
  exit 1
fi
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y git curl ca-certificates lvm2 qemu-system-x86 libvirt-daemon-system
sudo usermod -aG libvirt,kvm "$USER"
echo 'Dependencies installed. Log out and back in if group membership was newly added.'
