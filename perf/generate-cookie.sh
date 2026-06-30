#!/usr/bin/env bash
# Print a Cookie header value after CSRF-aware sign-in.
# Usage: PERF_BASE_URL=http://localhost:3000 ./perf/generate-cookie.sh <email> <password>
set -euo pipefail

EMAIL="$1"
PASSWORD="$2"
BASE="${PERF_BASE_URL:-http://localhost:3000}"
JAR="$(mktemp)"
trap 'rm -f "$JAR"' EXIT

HTML="$(curl -s -c "$JAR" "${BASE}/signin")"
TOKEN="$(printf '%s' "$HTML" | grep -oE 'name="authenticity_token"[^>]*value="[^"]*"' \
  | head -1 | sed -E 's/.*value="([^"]*)".*/\1/')"

if [ -z "$TOKEN" ]; then
  echo "generate-cookie: could not find authenticity_token on ${BASE}/signin" >&2
  exit 1
fi

curl -s -b "$JAR" -c "$JAR" -o /dev/null \
  --data-urlencode "authenticity_token=$TOKEN" \
  --data-urlencode "account[email]=$EMAIL" \
  --data-urlencode "account[password]=$PASSWORD" \
  --data-urlencode "remember_me=1" \
  "${BASE}/signins"

awk -F'\t' 'NF==7 { printf "%s%s=%s", (s?"; ":""), $6, $7; s=1 }' "$JAR"
