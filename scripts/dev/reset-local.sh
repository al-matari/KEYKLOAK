#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

make down-all
echo "Local stack stopped. Remove volumes manually if you want a full data reset."
