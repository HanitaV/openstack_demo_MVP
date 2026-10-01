#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/_common.sh"
require_openrc; user_openrc

if exists openstack volume show mvp-volume01; then
  volume_status=$(openstack volume show -f value -c status mvp-volume01)
  if [[ $volume_status == in-use ]] && exists openstack server show mvp-vm01; then
    openstack server remove volume mvp-vm01 mvp-volume01 || true
    wait_for 'volume detachment' "[[ \$(openstack volume show -f value -c status mvp-volume01) == available ]]" 60 || true
  fi
fi
if exists openstack server show mvp-vm01; then openstack server delete --wait mvp-vm01; fi
if exists openstack volume show mvp-volume01; then openstack volume delete mvp-volume01; fi
wait_for 'volume deletion' "! openstack volume show mvp-volume01 >/dev/null 2>&1" 60 || true

if exists openstack router show mvp-router; then
  openstack router remove subnet mvp-router mvp-subnet 2>/dev/null || true
  openstack router delete mvp-router
fi
if exists openstack subnet show mvp-subnet; then openstack subnet delete mvp-subnet; fi
if exists openstack network show mvp-net; then openstack network delete mvp-net; fi
if exists openstack image show mvp-cirros; then openstack image delete mvp-cirros; fi

admin_openrc
if exists openstack flavor show mvp.nano; then openstack flavor delete mvp.nano; fi
if exists openstack user show "$PROJECT_USER"; then openstack user delete "$PROJECT_USER"; fi
if exists openstack project show "$PROJECT_NAME"; then openstack project delete "$PROJECT_NAME"; fi
echo 'MVP resources cleaned up.'
