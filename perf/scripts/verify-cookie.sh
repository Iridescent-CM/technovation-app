#!/usr/bin/env bash
# Verify a role cookie reaches the audited page (200, not /signin redirect).
# Usage: PERF_BASE_URL=http://localhost:3000 ./perf/scripts/verify-cookie.sh <role>
set -euo pipefail

ROLE="${1:?usage: verify-cookie.sh <role>}"
BASE="${PERF_BASE_URL:-http://localhost:3000}"

case "$ROLE" in
  public)
    echo "verify-cookie: public role needs no cookie — skip"
    exit 0
    ;;
  student)
    EMAIL="student@student.com"
    PATH_TO_CHECK="/student/team_submission_overview"
    ;;
  mentor)
    EMAIL="mentor@mentor.com"
    PATH_TO_CHECK="/mentor/dashboard"
    ;;
  judge)
    EMAIL="judge@judge.com"
    PATH_TO_CHECK="/judge/dashboard"
    ;;
  chapter_ambassador)
    EMAIL="chapter-ambassador@chapter-ambassador.com"
    PATH_TO_CHECK="/chapter_ambassador/dashboard"
    ;;
  admin)
    EMAIL="admin@admin.com"
    PATH_TO_CHECK="/admin/participants"
    ;;
  *)
    echo "verify-cookie: unknown role '$ROLE'" >&2
    exit 1
    ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COOKIE="$("$SCRIPT_DIR/../generate-cookie.sh" "$EMAIL" "$EMAIL")"

if [ -z "$COOKIE" ]; then
  echo "verify-cookie: empty cookie for $ROLE ($EMAIL)" >&2
  exit 1
fi

RESULT="$(curl -s -L -o /dev/null -w '%{http_code} %{url_effective}' \
  -H "Cookie: $COOKIE" \
  "${BASE}${PATH_TO_CHECK}")"

CODE="${RESULT%% *}"
URL="${RESULT#* }"

echo "$ROLE: $CODE $URL"

if [[ "$URL" == *"/signin"* ]] || [[ "$URL" == *"/login"* ]]; then
  echo "verify-cookie: landed on sign-in page for $ROLE ($EMAIL)" >&2
  echo "  Likely cause: account missing or wrong password in local DB (not a script bug)." >&2
  echo "  Fix:" >&2
  echo "    bundle exec rails db:seed" >&2
  echo "    ./perf/scripts/check-seeds.sh" >&2
  echo "    ./perf/scripts/verify-cookie.sh $ROLE" >&2
  exit 1
fi

if [ "$CODE" != "200" ]; then
  echo "verify-cookie: expected HTTP 200 after redirects for $ROLE at ${PATH_TO_CHECK}, got $CODE" >&2
  echo "  Fix: ensure Rails server is running at $BASE and the account exists (db:seed)." >&2
  exit 1
fi

if [ "$URL" != "${BASE}${PATH_TO_CHECK}" ]; then
  echo "verify-cookie: note — $ROLE redirected to $URL (authenticated; OK for T0.4)"
fi
