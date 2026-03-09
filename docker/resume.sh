#!/bin/bash

set -euo pipefail

AI_HOME="${AI_HOME:-/data/ai_home}"
PAUSE_FLAG_FILE="${PAUSE_FLAG_FILE:-$AI_HOME/state/paused.flag}"

rm -f "$PAUSE_FLAG_FILE"
echo "Resumed loop"
