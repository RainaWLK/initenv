#!/bin/bash

container run -d \
  --name claude \
  --cpus 1 --memory 1G \
  --user ubuntu \
  --cap-drop ALL \
  --init \
  --volume "${HOME}/Documents/projects:/home/ubuntu/projects" \
  --volume "${HOME}/.claude:/home/ubuntu/.claude" \
  --env "CLAUDE_CONFIG_DIR=/home/ubuntu/.claude" \
  --workdir "/home/ubuntu/projects" \
  --entrypoint /bin/sleep \
  "local/claude-code:latest" infinity

