#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/../openstack/_common.sh"
require_openrc; user_openrc

failures=0
check() { local label=$1 command=$2; if eval "$command"; then echo "PASS: $label"; else echo "FAIL: $label" >&2; failures=$((failures + 1)); fi; }
check 'OpenStack CLI and Keystone token' 'openstack token issue >/dev/null'
check 'mvp-cirros is active' '[[ $(openstack image show -f value -c status mvp-cirros 2>/dev/null) == active ]]'
check 'mvp-vm01 is ACTIVE' '[[ $(openstack server show -f value -c status mvp-vm01 2>/dev/null) == ACTIVE ]]'
check 'mvp-volume01 is in-use' '[[ $(openstack volume show -f value -c status mvp-volume01 2>/dev/null) == in-use ]]'
check 'mvp-net exists' 'openstack network show mvp-net >/dev/null 2>&1'
if [[ $failures -eq 0 ]]; then echo 'MVP READY FOR VIVA'; else echo "$failures verification check(s) failed." >&2; exit 1; fi
