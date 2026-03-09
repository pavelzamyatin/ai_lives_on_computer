set dotenv-load := true

compose := "docker compose"
service := "ai-agent"
runtime_ai_home := "runtime/ai_home"

default:
    just --list

build:
    {{compose}} build

up:
    {{compose}} up --build

up-detached:
    {{compose}} up --build -d

down:
    {{compose}} down

restart:
    {{compose}} restart {{service}}

logs:
    {{compose}} logs -f {{service}}

ps:
    {{compose}} ps

config:
    {{compose}} config

status:
    {{compose}} exec -T {{service}} /app/docker/status.sh

pause:
    {{compose}} exec -T {{service}} /app/docker/pause.sh

resume:
    {{compose}} exec -T {{service}} /app/docker/resume.sh

reset:
    {{compose}} exec -T {{service}} /app/docker/reset.sh

run-once:
    {{compose}} run --rm {{service}} once

wake-now:
    {{compose}} exec -T {{service}} /app/docker/wake-now.sh

shell:
    {{compose}} exec {{service}} bash

seed:
    rm -rf {{runtime_ai_home}}
    mkdir -p {{runtime_ai_home}}
    {{compose}} run --rm --build {{service}} seed

init:
    cp -n .env.example .env || true
    mkdir -p workspace
    mkdir -p {{runtime_ai_home}}

dev:
    just init
    just up
