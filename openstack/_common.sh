#!/usr/bin/env bash
# Shared shell helpers for the OpenStack MVP scripts.
set -Eeuo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
DEVSTACK_DIR=${DEVSTACK_DIR:-$HOME/devstack}
OPENRC=${OPENRC:-$DEVSTACK_DIR/openrc}
PROJECT_NAME=${PROJECT_NAME:-mvp-project}
PROJECT_USER=${PROJECT_USER:-mvp-user}
PROJECT_PASSWORD=${PROJECT_PASSWORD:-openstack}
OPENSTACK_COMMAND_TIMEOUT=${OPENSTACK_COMMAND_TIMEOUT:-90}

source_openrc() {
  set +u
  source "$OPENRC" "$@"
  set -u
}
admin_openrc() { source_openrc admin admin; }
user_openrc() { source_openrc "$PROJECT_USER" "$PROJECT_NAME"; }
exists() { timeout "$OPENSTACK_COMMAND_TIMEOUT" "$@" >/dev/null 2>&1; }
wait_for() {
  local description=$1 command=$2 attempts=${3:-30}
  for ((attempt=1; attempt<=attempts; attempt++)); do
    if eval "$command"; then return 0; fi
    sleep 2
  done
  echo "Timed out waiting for ${description}." >&2
  return 1
}
require_openrc() { [[ -r "$OPENRC" ]] || { echo "OpenRC file not found: $OPENRC" >&2; exit 1; }; }
