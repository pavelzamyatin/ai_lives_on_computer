set dotenv-load := true

compose := "docker compose"
service := "ai-agent"

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
    {{compose}} exec {{service}} /app/docker/status.sh

reset:
    {{compose}} exec {{service}} /app/docker/reset.sh

run-once:
    {{compose}} run --rm {{service}} once

shell:
    {{compose}} exec {{service}} bash

seed:
    {{compose}} run --rm {{service}} bash -lc /app/docker/entrypoint.sh\ once

init:
    cp -n .env.example .env || true
    mkdir -p workspace

dev:
    just init
    just up
