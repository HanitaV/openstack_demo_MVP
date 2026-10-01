#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/_common.sh"
require_openrc; admin_openrc

if ! exists openstack project show "$PROJECT_NAME"; then
  openstack project create --description 'University OpenStack MVP demo' "$PROJECT_NAME"
fi
if ! exists openstack user show "$PROJECT_USER"; then
  openstack user create --project "$PROJECT_NAME" --password "$PROJECT_PASSWORD" "$PROJECT_USER"
fi
openstack role add --project "$PROJECT_NAME" --user "$PROJECT_USER" member
echo "Project ${PROJECT_NAME} and user ${PROJECT_USER} are ready."
