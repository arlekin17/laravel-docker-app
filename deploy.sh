
#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

COMPOSE_FILE="docker-compose.prod.yml"
SEVERITY="HIGH,CRITICAL"

check_requirements() {
  for cmd in docker trivy; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "Missing required command: $cmd" >&2
      exit 1
    fi
  done
  docker compose version >/dev/null 2>&1

  if [ ! -f "$COMPOSE_FILE" ]; then
    echo "Compose file not found: $COMPOSE_FILE" >&2
    exit 1
  fi
}

build_prod_images() {
  echo "=== Building production images ==="
  DOCKER_BUILDKIT=1 docker compose -f "$COMPOSE_FILE" build --no-cache --progress=plain
}

scan_images_and_fs() {
  local images=(
    "app-php:prod"
    "app-nginx:prod"
    "app-postgres:prod"
    "app-pgadmin:prod"
  )

  for img in "${images[@]}"; do
    echo "=== Scanning image: $img ==="
    trivy image --skip-version-check --ignore-unfixed --severity "$SEVERITY" "$img" || true
  done

  echo "=== Scanning project filesystem ==="
  trivy fs --skip-version-check --scanners vuln,secret --severity "$SEVERITY" . || true
}

start_services() {
  echo "=== Starting production stack ==="
  docker compose -f "$COMPOSE_FILE" up -d --remove-orphans
  docker compose -f "$COMPOSE_FILE" ps
}

main() {
  check_requirements
  build_prod_images
  scan_images_and_fs
  start_services
}

main "$@"
chmod +x deploy.sh
