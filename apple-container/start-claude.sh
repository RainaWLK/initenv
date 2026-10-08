#!/bin/bash
# Note: copy this to ~/.local/bin/claude-tab.sh

set -uo pipefail
# iTerm2 starts commands with a minimal PATH, so add where `container` lives
export PATH="/usr/local/bin:${PATH}"

# keep the tab open on errors so the message is readable
fail() { echo "ERROR: $*" >&2; read -rp "Press Enter to close..."; exit 1; }

container system status >/dev/null 2>&1 || container system start \
  || fail "could not start the container service"

if container list --all --quiet | grep -qx claude; then
  container start claude >/dev/null 2>&1 || true   # no-op if already running
else
  echo "Creating container claude..."
  container run -d \
    --name "claude" \
    --cpus 1 --memory 1G \
    --user ubuntu \
    --cap-drop ALL \
    --init \
    --volume "${HOME}/Documents/projects:/home/ubuntu/projects" \
    --volume "${HOME}/.claude:/home/ubuntu/.claude" \
    --env "CLAUDE_CONFIG_DIR=/home/ubuntu/.claude" \
    --workdir "/home/ubuntu/projects" \
    --entrypoint /bin/sleep \
    local/claude-code:latest infinity >/dev/null
fi

exec container exec -it -u ubuntu -w /home/ubuntu/projects claude bash -l