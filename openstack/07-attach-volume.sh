#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/_common.sh"
require_openrc; user_openrc

volume_status=$(openstack volume show -f value -c status mvp-volume01)
if [[ $volume_status == available ]]; then openstack server add volume mvp-vm01 mvp-volume01; fi
wait_for 'mvp-volume01 to become in-use' "[[ \$(openstack volume show -f value -c status mvp-volume01) == in-use ]]" 60
openstack volume show mvp-volume01
