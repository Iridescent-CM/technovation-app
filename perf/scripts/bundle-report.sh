#!/usr/bin/env bash
# Build webpack stats + HTML bundle report; optionally write bundles.json to a baseline dir.
# Usage: yarn perf:bundle
#        PERF_BASELINE_DIR=perf/baselines/2026-06-25-abc123 yarn perf:bundle
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$ROOT_DIR"

mkdir -p tmp

echo "perf:bundle: compiling stats.json"
NODE_ENV=production bin/shakapacker --json stats.json

OUT="${PERF_BASELINE_DIR:+${PERF_BASELINE_DIR}/bundles.json}"
node "$SCRIPT_DIR/extract-bundles.js" stats.json ${OUT:+"$OUT"}

echo "perf:bundle: writing tmp/bundle-report.html"
npx webpack-bundle-analyzer stats.json \
  --mode static \
  --no-open \
  --report tmp/bundle-report.html

echo "perf:bundle: done"
