#!/bin/bash

set -euo pipefail

APP_HOME="${APP_HOME:-/app}"
AI_HOME="${AI_HOME:-$HOME/ai_home}"
MINI_CONFIG_DIR="${MINI_CONFIG_DIR:-$HOME/.config/mini-swe-agent}"
MINI_GLOBAL_ENV_FILE="${MINI_GLOBAL_ENV_FILE:-$MINI_CONFIG_DIR/.env}"
PAUSE_FLAG_FILE="${PAUSE_FLAG_FILE:-$AI_HOME/state/paused.flag}"
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

write_mini_global_config() {
    local model="${OPENROUTER_MODEL:-meta-llama/llama-3.3-70b-instruct:free}"
    local cost_tracking="${MSWEA_COST_TRACKING:-ignore_errors}"

    mkdir -p "$MINI_CONFIG_DIR"

    cat > "$MINI_GLOBAL_ENV_FILE" <<EOF
MSWEA_CONFIGURED=true
MSWEA_MODEL_NAME=openai/${model}
MSWEA_COST_TRACKING=${cost_tracking}
OPENAI_API_KEY=${OPENROUTER_API_KEY:-}
OPENAI_BASE_URL=${OPENROUTER_BASE_URL:-https://openrouter.ai/api/v1}
EOF
}

run_once() {
    "$APP_HOME/run_ai.sh" openrouter
}

run_loop() {
    local interval_minutes="${SESSION_INTERVAL_MINUTES:-15}"
    local sleep_seconds=$((interval_minutes * 60))
    local retry_seconds="${SESSION_RETRY_SECONDS:-60}"

    while true; do
        if [ -f "$PAUSE_FLAG_FILE" ]; then
            sleep "$retry_seconds"
            continue
        fi

        if run_once; then
            sleep "$sleep_seconds"
        else
            sleep "$retry_seconds"
        fi
    done
}

seed_ai_home
write_mini_global_config

case "$RUN_MODE" in
    seed)
        exit 0
        ;;
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
