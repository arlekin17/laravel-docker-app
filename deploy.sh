#!/bin/bash
set -e

ENV=${1:-dev}
COMPOSE_FILE="docker-compose.${ENV}.yml"

echo "=== Запуск деплоя в режиме: $ENV ==="

docker compose -f "$COMPOSE_FILE" down --remove-orphans
docker compose -f "$COMPOSE_FILE" up -d --build

echo "=== Готово ==="
docker compose -f "$COMPOSE_FILE" ps
