#!/usr/bin/env bash
# Capture Lighthouse medians for one PERF_ROLE into perf/baselines/<date>-<sha>/.
# Usage: PERF_ROLE=judge yarn perf:baseline
set -euo pipefail

ROLE="${PERF_ROLE:?Set PERF_ROLE (public|student|mentor|judge|chapter_ambassador|admin)}"
BASE="${PERF_BASE_URL:-http://localhost:3000}"
DATE="${PERF_BASELINE_DATE:-$(date +%Y-%m-%d)}"
SHA="${PERF_BASELINE_SHA:-$(git rev-parse --short HEAD)}"
SUFFIX="${PERF_BASELINE_SUFFIX:-}"
BASELINE_DIR="${PERF_BASELINE_DIR:-perf/baselines/${DATE}-${SHA}${SUFFIX}}"
export LHCI_OUTPUT_DIR="tmp/lhci/${DATE}-${SHA}${SUFFIX}/${ROLE}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$ROOT_DIR"

export PERF_BASELINE_SHA="$SHA"
export PERF_ENVIRONMENT="${PERF_ENVIRONMENT:-local}"

declare -a URLS=()
case "$ROLE" in
  public)
    export LH_AUTH_COOKIE=""
    URLS=("/" "/signup")
    ;;
  student)
    export LH_AUTH_COOKIE="$("$ROOT_DIR/perf/generate-cookie.sh" student@student.com student@student.com)"
    URLS=("/student/team_submission_overview")
    "$SCRIPT_DIR/check-seeds.sh"
    "$SCRIPT_DIR/verify-cookie.sh" student
    ;;
  mentor)
    export LH_AUTH_COOKIE="$("$ROOT_DIR/perf/generate-cookie.sh" mentor@mentor.com mentor@mentor.com)"
    URLS=("/mentor/dashboard")
    "$SCRIPT_DIR/check-seeds.sh"
    "$SCRIPT_DIR/verify-cookie.sh" mentor
    ;;
  judge)
    export LH_AUTH_COOKIE="$("$ROOT_DIR/perf/generate-cookie.sh" judge@judge.com judge@judge.com)"
    if [ "$PERF_ENVIRONMENT" = "qa" ]; then
      URLS=("/chapterable_account_assignments/new")
    else
      URLS=("/judge/dashboard")
    fi
    "$SCRIPT_DIR/check-seeds.sh"
    "$SCRIPT_DIR/verify-cookie.sh" judge
    ;;
  chapter_ambassador)
    export LH_AUTH_COOKIE="$("$ROOT_DIR/perf/generate-cookie.sh" chapter-ambassador@chapter-ambassador.com chapter-ambassador@chapter-ambassador.com)"
    URLS=("/chapter_ambassador/dashboard")
    "$SCRIPT_DIR/check-seeds.sh"
    "$SCRIPT_DIR/verify-cookie.sh" chapter_ambassador
    ;;
  admin)
    export LH_AUTH_COOKIE="$("$ROOT_DIR/perf/generate-cookie.sh" admin@admin.com admin@admin.com)"
    URLS=("/admin/participants")
    "$SCRIPT_DIR/check-seeds.sh"
    "$SCRIPT_DIR/verify-cookie.sh" admin
    ;;
  *)
    echo "capture-baseline: unknown PERF_ROLE '$ROLE'" >&2
    exit 1
    ;;
esac

mkdir -p "$BASELINE_DIR" "$LHCI_OUTPUT_DIR"

echo "capture-baseline: warming ${#URLS[@]} URL(s) at $BASE"
for url_path in "${URLS[@]}"; do
  curl -s -L -o /dev/null \
    ${LH_AUTH_COOKIE:+-H "Cookie: $LH_AUTH_COOKIE"} \
    "${BASE}${url_path}"
done

if [ "$PERF_ENVIRONMENT" = "qa" ]; then
  echo "capture-baseline: QA extra warmup (5 hits, 3s apart)"
  for _ in 1 2 3 4 5; do
    for url_path in "${URLS[@]}"; do
      curl -s -L -o /dev/null \
        ${LH_AUTH_COOKIE:+-H "Cookie: $LH_AUTH_COOKIE"} \
        "${BASE}${url_path}"
    done
    sleep 3
  done
  sleep 5
fi

export PERF_ROLE PERF_BASE_URL LHCI_OUTPUT_DIR LH_AUTH_COOKIE

echo "capture-baseline: lhci autorun → $LHCI_OUTPUT_DIR"
npx lhci autorun --config=perf/lighthouserc.js

node "$SCRIPT_DIR/summarize-lhci.js" "$LHCI_OUTPUT_DIR" "$ROLE" "$BASELINE_DIR/${ROLE}.json"

echo "capture-baseline: done → $BASELINE_DIR/${ROLE}.json"
