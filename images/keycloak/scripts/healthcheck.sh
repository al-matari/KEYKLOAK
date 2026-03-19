#!/usr/bin/env bash
set -euo pipefail

port="${KC_HEALTH_PORT:-9000}"

response="$(
  {
    exec 3<>"/dev/tcp/127.0.0.1/${port}"
    printf 'GET /health/ready HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n' >&3
    cat <&3
  } 2>/dev/null || true
)"

[[ "$response" == *"200 OK"* ]]
