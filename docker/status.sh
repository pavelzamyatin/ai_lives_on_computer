#!/bin/bash

set -euo pipefail

AI_HOME="${AI_HOME:-/data/ai_home}"
PAUSE_FLAG_FILE="${PAUSE_FLAG_FILE:-$AI_HOME/state/paused.flag}"

echo "AI_HOME: $AI_HOME"
echo "Session counter: $(cat "$AI_HOME/state/session_counter.txt" 2>/dev/null || echo "missing")"
echo "Lock file: $([ -f "$AI_HOME/state/session.lock" ] && echo present || echo absent)"
echo "Paused: $([ -f "$PAUSE_FLAG_FILE" ] && echo yes || echo no)"
echo "Last session:"
tail -n 20 "$AI_HOME/state/last_session.md" 2>/dev/null || echo "(missing)"
echo
echo "Recent runner log:"
tail -n 20 "$AI_HOME/logs/runner.log" 2>/dev/null || echo "(missing)"
