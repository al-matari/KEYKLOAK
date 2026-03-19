#!/usr/bin/env bash
set -euo pipefail

shopt -s nullglob
files=(/opt/keycloak/data/import/*.json /opt/keycloak/data/import/*.yaml /opt/keycloak/data/import/*.yml)

if (( ${#files[@]} > 0 )); then
  echo "--import-realm"
fi
