#!/usr/bin/env bash
set -euo pipefail

source /opt/keycloak/scripts/load-secrets-env.sh
/opt/keycloak/scripts/wait-for-db.sh

start_mode="${KC_START_MODE:-start-dev}"

rm -rf /opt/keycloak/data/import
mkdir -p /opt/keycloak/data/import

if [[ -d /opt/keycloak/data/import-source ]]; then
  shopt -s nullglob
  for file in /opt/keycloak/data/import-source/realm-*.json /opt/keycloak/data/import-source/realm-*.yaml /opt/keycloak/data/import-source/realm-*.yml; do
    cp "$file" /opt/keycloak/data/import/
  done
  shopt -u nullglob
fi

import_flag="$("/opt/keycloak/scripts/import-realms.sh")"

extra_args=()
if [[ -n "${KC_EXTRA_ARGS:-}" ]]; then
  # shellcheck disable=SC2206
  extra_args=(${KC_EXTRA_ARGS})
fi

if [[ -n "$import_flag" ]]; then
  extra_args+=("$import_flag")
fi

exec /opt/keycloak/bin/kc.sh "$start_mode" "${extra_args[@]}" "$@"
