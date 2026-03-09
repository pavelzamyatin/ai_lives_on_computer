#!/bin/bash

set -euo pipefail

AI_HOME="${AI_HOME:-/data/ai_home}"

rm -f "$AI_HOME/state/session.lock"
rm -f "$AI_HOME/state/last_sessions_hash.txt"
rm -f "$AI_HOME/state/token_error.flag"

mkdir -p "$AI_HOME/state" "$AI_HOME/logs" "$AI_HOME/knowledge" "$AI_HOME/projects" "$AI_HOME/tools"

: > "$AI_HOME/logs/runner.log"
: > "$AI_HOME/logs/history.md"
: > "$AI_HOME/logs/consolidated_history.md"
: > "$AI_HOME/state/current_plan.md"
: > "$AI_HOME/state/last_session.md"
: > "$AI_HOME/state/external_messages.md"
echo "0" > "$AI_HOME/state/session_counter.txt"

find "$AI_HOME/knowledge" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
find "$AI_HOME/projects" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
find "$AI_HOME/tools" -mindepth 1 -maxdepth 1 -exec rm -rf {} +

echo "Reset complete for $AI_HOME"
