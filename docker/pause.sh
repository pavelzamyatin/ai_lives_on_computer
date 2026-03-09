#!/bin/bash

set -euo pipefail

AI_HOME="${AI_HOME:-/data/ai_home}"
PAUSE_FLAG_FILE="${PAUSE_FLAG_FILE:-$AI_HOME/state/paused.flag}"

mkdir -p "$(dirname "$PAUSE_FLAG_FILE")"
touch "$PAUSE_FLAG_FILE"
echo "Paused loop via $PAUSE_FLAG_FILE"
