#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

COMPOSE_FILE="docker-compose.prod.yml"
SEVERITY="HIGH,CRITICAL"

check_tools() {
  for cmd in docker trivy; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "Missing required tool: $cmd" >&2
      exit 1
    fi
  done
  docker compose version >/dev/null 2>&1
}

check_structure() {
  local required_files=(
    "$COMPOSE_FILE"
    "laravel/composer.json"
    "laravel/package.json"
    "laravel/package-lock.json"
    "Deploy/prod/php/Dockerfile"
    "Deploy/prod/nginx/Dockerfile"
    "Deploy/prod/nginx/default.conf"
    "Deploy/prod/postgres/Dockerfile"
    "Deploy/prod/pgadmin/Dockerfile"
  )

  for f in "${required_files[@]}"; do
    if [ ! -f "$f" ]; then
      echo "Missing required file: $f" >&2
      exit 1
    fi
  done
}

build_images() {
  DOCKER_BUILDKIT=1 docker compose -f "$COMPOSE_FILE" build --no-cache --progress=plain
}

inspect_images() {
  local images=(
    "app-php:prod"
    "app-nginx:prod"
    "app-postgres:prod"
    "app-pgadmin:prod"
  )

  for img in "${images[@]}"; do
    echo "=== IMAGE: $img ==="
    docker image inspect "$img" --format 'ID={{.Id}} Created={{.Created}} Size={{.Size}} User={{.Config.User}}'
    docker history --no-trunc "$img"
  done
}

verify_cleanup_in_php() {
  echo "=== VERIFYING CLEANUP IN app-php:prod ==="
  docker run --rm --entrypoint sh app-php:prod -c '
    test -d /var/www/html/vendor
    test -d /var/www/html/public/build
    ! command -v npm >/dev/null 2>&1
    ! command -v composer >/dev/null 2>&1
    test -z "$(ls -A /var/cache/apk 2>/dev/null || true)"
  '
}

scan_security() {
  local images=(
    "app-php:prod"
    "app-nginx:prod"
    "app-postgres:prod"
    "app-pgadmin:prod"
  )

  for img in "${images[@]}"; do
    echo "=== TRIVY IMAGE SCAN: $img ==="
    trivy image --skip-version-check --ignore-unfixed --severity "$SEVERITY" "$img" || true
  done

  echo "=== TRIVY FILESYSTEM SCAN ==="
  trivy fs --skip-version-check --scanners vuln,secret --severity "$SEVERITY" . || true
}

main() {
  check_tools
  check_structure
  build_images
  inspect_images
  verify_cleanup_in_php
  scan_security
}

main "$@"
