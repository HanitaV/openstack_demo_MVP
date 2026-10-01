#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/../openstack/_common.sh"
require_openrc; user_openrc

echo '1. OpenStack services'
openstack service list
echo -e '\n2. GLANCE — Imaging service'
openstack image list
echo -e '\n3. NOVA — Compute service'
openstack server list
echo -e '\n4. CINDER — Block Storage service'
openstack volume list
echo -e '\n5. Instance details'
openstack server show mvp-vm01
echo -e '\n6. Volume details'
openstack volume show mvp-volume01
cat <<'EOF'

======================================

OPENSTACK MVP VIVA READY

Imaging:
Glance      PASS

Compute:
Nova        PASS

Storage:
Cinder      PASS

======================================
EOF
