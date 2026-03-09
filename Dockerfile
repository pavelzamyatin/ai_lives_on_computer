FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    APP_HOME=/app \
    AI_HOME=/data/ai_home \
    AGENT_ROOT_DIR=/app \
    AGENT_CONFIG_DIR=/app/config

RUN apt-get update \
    && apt-get install -y --no-install-recommends bash coreutils curl ca-certificates procps \
    && rm -rf /var/lib/apt/lists/*

RUN pip install mini-swe-agent

WORKDIR /app

COPY run_ai.sh setup-openrouter.sh SYSTEM_PROMPT.md /app/
COPY config /app/config
COPY ai_home /app/ai_home
COPY docker /app/docker

RUN chmod +x /app/run_ai.sh /app/setup-openrouter.sh /app/docker/*.sh \
    && mkdir -p /data/ai_home/state /data/ai_home/logs /data/ai_home/knowledge /data/ai_home/projects /data/ai_home/tools

ENTRYPOINT ["/app/docker/entrypoint.sh"]
CMD ["loop"]
