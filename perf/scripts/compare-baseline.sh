#!/usr/bin/env bash
# Compare two committed baseline folders (local↔local or QA↔QA only).
# Usage: yarn perf:compare perf/baselines/<before> perf/baselines/<after>
set -euo pipefail

BASELINE_A="${1:?usage: compare-baseline.sh <baseline-a-dir> <baseline-b-dir>}"
BASELINE_B="${2:?usage: compare-baseline.sh <baseline-a-dir> <baseline-b-dir>}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
node "$SCRIPT_DIR/compare-baselines.js" "$BASELINE_A" "$BASELINE_B"
