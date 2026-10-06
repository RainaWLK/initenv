#!/bin/bash
# runs once at image build time (as root) -> baked into the golden image
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

apt-get update

# systemd + base tools (required: container machine boots /sbin/init as PID 1)
apt-get install -y --no-install-recommends \
  dbus \
  systemd \
  systemd-sysv \
  sudo \
  ca-certificates \
  iproute2 \
  iputils-ping \
  net-tools \
  curl \
  wget \
  vim-tiny \
  man-db

# your packages
apt-get install -y --no-install-recommends \
  git \
  jq \
  unzip \
  python3

# add more setup below
curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash -s -- --system

