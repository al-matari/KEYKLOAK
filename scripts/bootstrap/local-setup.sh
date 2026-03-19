#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

cd "$repo_root"

if [[ ! -f .env.local ]]; then
  cp .env.example .env.local
fi

make up
make provision-local
