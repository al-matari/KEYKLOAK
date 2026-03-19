#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
secrets_dir="${repo_root}/secrets/dev"

mkdir -p "$secrets_dir"

for file in keycloak-admin-password.txt keycloak-db-password.txt kafka-password.txt smtp-password.txt; do
  path="${secrets_dir}/${file}"
  if [[ ! -f "$path" ]]; then
    printf 'change-me\n' >"$path"
    echo "Created ${path}"
  fi
done
