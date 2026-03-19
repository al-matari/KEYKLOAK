#!/usr/bin/env bash
set -euo pipefail

host="${KC_DB_URL_HOST:-postgres}"
port="${KC_DB_URL_PORT:-5432}"
timeout_seconds="${KC_DB_WAIT_TIMEOUT:-60}"
deadline=$((SECONDS + timeout_seconds))

until (echo >"/dev/tcp/${host}/${port}") >/dev/null 2>&1; do
  if (( SECONDS >= deadline )); then
    echo "Database ${host}:${port} was not reachable within ${timeout_seconds}s." >&2
    exit 1
  fi

  sleep 2
done
