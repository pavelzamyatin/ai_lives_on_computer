#!/bin/bash

set -euo pipefail

APP_HOME="${APP_HOME:-/app}"
AI_HOME="${AI_HOME:-/data/ai_home}"
RUN_MODE="${1:-loop}"

seed_file_if_missing() {
    local source_path="$1"
    local target_path="$2"

    if [ ! -e "$target_path" ] && [ -e "$source_path" ]; then
        mkdir -p "$(dirname "$target_path")"
        cp "$source_path" "$target_path"
    fi
}

seed_ai_home() {
    mkdir -p "$AI_HOME/state" "$AI_HOME/logs" "$AI_HOME/knowledge" "$AI_HOME/projects" "$AI_HOME/tools"

    seed_file_if_missing "$APP_HOME/SYSTEM_PROMPT.md" "$AI_HOME/SYSTEM_PROMPT.md"
    seed_file_if_missing "$APP_HOME/ai_home/config.sh" "$AI_HOME/config.sh"
    seed_file_if_missing "$APP_HOME/ai_home/state/current_plan.md" "$AI_HOME/state/current_plan.md"
    seed_file_if_missing "$APP_HOME/ai_home/state/last_session.md" "$AI_HOME/state/last_session.md"
    seed_file_if_missing "$APP_HOME/ai_home/state/external_messages.md" "$AI_HOME/state/external_messages.md"
    seed_file_if_missing "$APP_HOME/ai_home/state/session_counter.txt" "$AI_HOME/state/session_counter.txt"
    seed_file_if_missing "$APP_HOME/ai_home/logs/history.md" "$AI_HOME/logs/history.md"
    seed_file_if_missing "$APP_HOME/ai_home/logs/consolidated_history.md" "$AI_HOME/logs/consolidated_history.md"
}

run_once() {
    "$APP_HOME/run_ai.sh" openrouter
}

run_loop() {
    local interval_minutes="${SESSION_INTERVAL_MINUTES:-15}"
    local sleep_seconds=$((interval_minutes * 60))

    while true; do
        run_once
        sleep "$sleep_seconds"
    done
}

seed_ai_home

case "$RUN_MODE" in
    once)
        run_once
        ;;
    loop)
        run_loop
        ;;
    *)
        exec "$@"
        ;;
esac
