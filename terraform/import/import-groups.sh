#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ "$#" -ne 2 ]; then
  echo "Usage: import/import-groups.sh <resource_address> <import_id>" >&2
  echo "Example: import/import-groups.sh 'module.realm.module.groups.keycloak_group.groups[\"admins\"]' <import_id>" >&2
  exit 1
fi

terraform import "$1" "$2"
