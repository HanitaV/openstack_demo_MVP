#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/_common.sh"
require_openrc; user_openrc

image_file=${CIRROS_IMAGE_FILE:-/tmp/cirros.img}
cirros_url=${CIRROS_URL:-https://download.cirros-cloud.net/0.6.3/cirros-0.6.3-x86_64-disk.img}
if ! exists openstack image show mvp-cirros; then
  curl --fail --location --retry 3 -o "$image_file" "$cirros_url"
  openstack image create --disk-format qcow2 --container-format bare --file "$image_file" mvp-cirros
fi
wait_for 'mvp-cirros to become active' "[[ \$(openstack image show -f value -c status mvp-cirros) == active ]]"
openstack image list --name mvp-cirros
