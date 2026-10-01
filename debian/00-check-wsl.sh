#!/usr/bin/env bash
set -Eeuo pipefail

if ! grep -qi microsoft /proc/version; then
  echo 'Not running under WSL; continuing with standard Debian prerequisites.'
  exit 0
fi

echo 'WSL environment detected.'
if [[ $(ps -p 1 -o comm= | tr -d ' ') != systemd ]]; then
  cat >&2 <<'EOF'
ERROR: systemd is not enabled in this WSL distribution.

Inside Debian, run:
  sudo apt-get update && sudo apt-get install -y systemd systemd-sysv
  printf '[boot]\nsystemd=true\n' | sudo tee /etc/wsl.conf

Then, in Windows PowerShell, run:
  wsl --shutdown

Reopen Debian and run this check again.
EOF
  exit 1
fi

ram_gb=$(( $(awk '/MemTotal/ { print $2 }' /proc/meminfo) / 1024 / 1024 ))
if [[ $ram_gb -lt 5 ]]; then
  cat >&2 <<EOF
ERROR: WSL currently has ${ram_gb} GB RAM; this MVP requires at least 5 GB and recommends 6 GB.

In Windows, create %USERPROFILE%\\.wslconfig:
  [wsl2]
  memory=6GB
  processors=2
  swap=8GB
  localhostForwarding=true

Run 'wsl --shutdown' in PowerShell, then reopen Debian.
EOF
  exit 1
fi

if [[ ! -e /dev/kvm ]]; then
  echo 'KVM unavailable. Using QEMU. VM boot will be slower but suitable for MVP demo.' >&2
fi
echo 'WSL preflight passed: systemd is active and memory is sufficient.'
