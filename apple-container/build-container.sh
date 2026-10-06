#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONTAINER_NAME="claude"
IMAGE_NAME="local/claude-code"
VERSION="$(grep -m1 '^ARG VERSION=' "${SCRIPT_DIR}/${CONTAINER_NAME}/Dockerfile" | cut -d= -f2)"
IMAGE="${IMAGE_NAME}:${VERSION}"

GUEST_HOME="/home/ubuntu"

# 1. build golden image (ubuntu gets the same UID as your macOS user)
container build --arch arm64 \
  --build-arg "HOST_UID=$(id -u)" \
  -t "${IMAGE}" \
  -t "${IMAGE_NAME}:latest" \
  "${SCRIPT_DIR}/claude"

# 2. recreate the container from the fresh image
container delete --force "${CONTAINER_NAME}" 2>/dev/null || true
