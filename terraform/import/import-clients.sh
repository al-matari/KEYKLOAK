#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ "$#" -ne 2 ]; then
  echo "Usage: import/import-clients.sh <resource_address> <import_id>" >&2
  echo "Example: import/import-clients.sh 'module.clients.keycloak_openid_client.public[\"spa\"]' <import_id>" >&2
  exit 1
fi

terraform import "$1" "$2"
