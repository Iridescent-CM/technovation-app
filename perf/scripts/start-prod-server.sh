#!/usr/bin/env bash
# Start Rails in perf mode for local Lighthouse captures (port 3001 by default).
# Uses development DB + .env — production DB is not required.
# Usage: ./perf/scripts/start-prod-server.sh
set -euo pipefail

PORT="${PERF_PROD_PORT:-3001}"
PIDFILE="tmp/pids/perf-prod-server.pid"

export USE_DOTENV=true
export FORCE_SSL=false
export RAILS_SERVE_STATIC_FILES=true
export SECRET_KEY_BASE="${SECRET_KEY_BASE:-local-perf-secret-key-base}"
export MEMCACHEDCLOUD_SERVERS="${MEMCACHEDCLOUD_SERVERS:-127.0.0.1:11211}"
export MEMCACHEDCLOUD_USERNAME="${MEMCACHEDCLOUD_USERNAME:-}"
export MEMCACHEDCLOUD_PASSWORD="${MEMCACHEDCLOUD_PASSWORD:-}"
export DATABASE_URL="${DATABASE_URL:-postgres://127.0.0.1/technovation-app_development}"
export WEB_CONCURRENCY="${WEB_CONCURRENCY:-0}"
export RAILS_LOG_TO_STDOUT=1

mkdir -p tmp/pids

if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  echo "start-prod-server: already running on port $PORT (pid $(cat "$PIDFILE"))"
  exit 0
fi

echo "start-prod-server: booting perf on http://localhost:$PORT"
echo "  DATABASE_URL=$DATABASE_URL"

bundle exec rails server -p "$PORT" -e perf &
echo $! > "$PIDFILE"
sleep 5

if curl -s -o /dev/null -w '%{http_code}' "http://localhost:$PORT/" | grep -q 200; then
  echo "start-prod-server: ready"
else
  echo "start-prod-server: failed health check on /" >&2
  exit 1
fi
