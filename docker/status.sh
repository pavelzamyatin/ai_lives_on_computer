#!/bin/bash

set -euo pipefail

AI_HOME="${AI_HOME:-/data/ai_home}"

echo "AI_HOME: $AI_HOME"
echo "Session counter: $(cat "$AI_HOME/state/session_counter.txt" 2>/dev/null || echo "missing")"
echo "Lock file: $([ -f "$AI_HOME/state/session.lock" ] && echo present || echo absent)"
echo "Last session:"
tail -n 20 "$AI_HOME/state/last_session.md" 2>/dev/null || echo "(missing)"
echo
echo "Recent runner log:"
tail -n 20 "$AI_HOME/logs/runner.log" 2>/dev/null || echo "(missing)"
