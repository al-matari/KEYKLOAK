#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ "$#" -ne 2 ]; then
  echo "Usage: import/import-realm.sh <resource_address> <import_id>" >&2
  echo "Example: import/import-realm.sh module.realm.module.realm_settings.keycloak_realm.this demo-local" >&2
  exit 1
fi

terraform import "$1" "$2"
