#!/bin/bash

set -euo pipefail

APP_HOME="${APP_HOME:-/app}"
AI_HOME="${AI_HOME:-/data/ai_home}"
PAUSE_FLAG_FILE="${PAUSE_FLAG_FILE:-$AI_HOME/state/paused.flag}"

mkdir -p "$(dirname "$PAUSE_FLAG_FILE")"
touch "$PAUSE_FLAG_FILE"
trap 'rm -f "$PAUSE_FLAG_FILE"' EXIT

"$APP_HOME/run_ai.sh" openrouter
