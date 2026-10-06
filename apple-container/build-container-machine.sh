#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MACHINE_NAME="claude"
IMAGE_NAME="local/ubuntu-machine"
VERSION="$(grep -m1 '^ARG VERSION=' "${SCRIPT_DIR}/Dockerfile" | cut -d= -f2)"
IMAGE="${IMAGE_NAME}:${VERSION}"
PROJECTS_DIR="${HOME}/Documents/projects"
CONFIG_FILE="${HOME}/.config/container/config.toml"

# 1. build golden image: ubuntu + systemd + machine/init.sh
container build --arch arm64 -t "${IMAGE}" -t "${IMAGE_NAME}:latest" "${SCRIPT_DIR}/machine"

# 3. launch machine from golden image
#    machine can only mount the whole $HOME (rw|ro|none), at the same path.
#    ~/Documents/projects is visible inside at the same path.
container machine create "${IMAGE}" \
  --name "${MACHINE_NAME}" \
  --cpus 1 --memory 1G \
  --home-mount rw

# 4. use it
# container machine run -n "${MACHINE_NAME}" -w "${PROJECTS_DIR}" -- ls
# container machine run -n "${MACHINE_NAME}"     # login shell
# container machine stop "${MACHINE_NAME}"
# container machine rm "${MACHINE_NAME}"        # deletes its disk

