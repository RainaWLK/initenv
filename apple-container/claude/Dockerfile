FROM ubuntu:24.04

ARG VERSION=0.0.2

# make `a | b` fail the build if `a` fails (e.g. curl download error)
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# ---- root steps: system packages ----
USER root
COPY init.sh /tmp/init.sh
RUN bash /tmp/init.sh && \
    rm -f /tmp/init.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ---- match ubuntu's UID to the macOS user (after init.sh for better caching) ----
ARG HOST_UID=501
RUN set -e; \
    owner="$(getent passwd "${HOST_UID}" | cut -d: -f1 || true)"; \
    if [ -n "$owner" ] && [ "$owner" != "ubuntu" ]; then \
      echo "UID ${HOST_UID} already used by $owner" >&2; exit 1; \
    fi; \
    usermod -u "${HOST_UID}" ubuntu; \
    mkdir -p /home/ubuntu/projects; \
    chown -R ubuntu:ubuntu /home/ubuntu; \
    gpasswd -d ubuntu sudo 2>/dev/null || true

# ---- user steps: everything below runs as ubuntu ----
USER ubuntu
ENV PATH="/home/ubuntu/.local/bin:${PATH}"
WORKDIR /home/ubuntu/projects

RUN curl -fsSL https://claude.ai/install.sh | bash && \
    claude --version && \
    echo "export CLAUDE_CODE_DISABLE_MOUSE_CLICKS=1" >> /home/ubuntu/.bash_profile