#!/bin/bash

# Shared hook helpers for JSON extraction and path normalization.

extract_json_field() {
  local input="$1"
  local expr="$2"
  printf '%s' "$input" | jq -r "$expr // empty"
}

normalize_hook_path() {
  local path="$1"
  path="${path//$'\r'/}"
  path="${path//\\//}"

  if [[ -z "$path" ]]; then
    printf ''
    return
  fi

  if [[ "$path" =~ ^([A-Za-z]):(/.*)?$ ]]; then
    local drive="${BASH_REMATCH[1],,}"
    local rest="${BASH_REMATCH[2]}"
    printf '/mnt/%s%s' "$drive" "${rest:-}"
    return
  fi

  if [[ "$path" =~ ^/([A-Za-z])(/.*)?$ ]]; then
    local drive="${BASH_REMATCH[1],,}"
    local rest="${BASH_REMATCH[2]}"
    printf '/mnt/%s%s' "$drive" "${rest:-}"
    return
  fi

  if [[ "$path" =~ ^//([A-Za-z])(/.*)?$ ]]; then
    local drive="${BASH_REMATCH[1],,}"
    local rest="${BASH_REMATCH[2]}"
    printf '/mnt/%s%s' "$drive" "${rest:-}"
    return
  fi

  printf '%s' "$path"
}

derive_project_root() {
  local normalized_path="$1"

  if [[ "$normalized_path" =~ ^(.+)/(00_项目基础|01_世界观|02_人物|03_大纲|04_章纲|05_正文|06_追踪|08_灵感|\.claude)/.*$ ]]; then
    printf '%s' "${BASH_REMATCH[1]}"
    return
  fi

  printf ''
}
