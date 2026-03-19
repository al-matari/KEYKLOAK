#!/usr/bin/env bash
set -euo pipefail

port="${KEYCLOAK_HEALTH_PORT:-9000}"
timeout_seconds="${KEYCLOAK_WAIT_TIMEOUT:-120}"
url="${1:-http://localhost:${port}/health/ready}"
deadline=$((SECONDS + timeout_seconds))

until curl -fsS "$url" >/dev/null; do
  if (( SECONDS >= deadline )); then
    echo "Keycloak did not become ready within ${timeout_seconds}s: ${url}" >&2
    exit 1
  fi

  sleep 3
done

echo "Keycloak is ready: ${url}"
