#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/_common.sh"
require_openrc; user_openrc

if ! exists openstack volume show mvp-volume01; then openstack volume create --size 1 mvp-volume01; fi
wait_for 'mvp-volume01 to become available' "[[ \$(openstack volume show -f value -c status mvp-volume01) == available ]]" 60
openstack volume show mvp-volume01
