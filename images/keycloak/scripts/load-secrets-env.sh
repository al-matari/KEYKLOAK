#!/usr/bin/env bash
set -euo pipefail

file_env() {
  local var_name="$1"
  local file_var_name="${var_name}_FILE"
  local value="${!var_name-}"
  local file_path="${!file_var_name-}"

  if [[ -n "$value" && -n "$file_path" ]]; then
    echo "Both ${var_name} and ${file_var_name} are set." >&2
    exit 1
  fi

  if [[ -n "$file_path" ]]; then
    if [[ ! -f "$file_path" ]]; then
      echo "Secret file ${file_path} for ${file_var_name} does not exist." >&2
      exit 1
    fi

    value="$(<"$file_path")"
  fi

  if [[ -n "$value" ]]; then
    export "${var_name}=${value}"
  fi

  unset "$file_var_name"
}

file_env KC_BOOTSTRAP_ADMIN_PASSWORD
file_env KC_DB_PASSWORD
