#!/bin/bash

# 0. arm64 only: disable Rosetta in builder VM (no x86 emulation needed)
mkdir -p "$(dirname "${CONFIG_FILE}")"
cat > "${CONFIG_FILE}" <<'EOF'
[build]
rosetta = false
EOF
container system stop || true
container system start
container builder delete 2>/dev/null || true   # recreate builder with new config