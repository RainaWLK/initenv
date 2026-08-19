paths:
  - "*/Dockerfile"


# Dockerfile Guidelines

## basic
default base image is ubuntu, latest stable version

default entrypoint is `/bin/bash -c`

## definition of steps
for example, the image needs to install python, then do gcloud auth login
step1: commands to install python
step2: commands to install gcloud
step3: run gcloud auth

## coding style
- For layer optimization, for same purpose, combine multiple `RUN` to single.
- For clear steps, use separate `RUN`
- use ENV to set environment variables, avoid as much as possible to define variables in `RUN`
- use ENV for single variable
- the docker should be clear: if it will fail by some variables missing, don't check it first
- if env var only be used once, and it's low opportunity to changes, don't use env var, write value in line directly

### For `RUN`
- almost 100 chars per line, varify by words. If needs line break, use ` && \` at tails of line
- don't use more than 1 `&& \` in single line, if needs more than 1, break to multiple lines

for example:
```
RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    apt-get install -y --no-install-recommends curl
```

## version
use semitic version, add 1 to patch number

# Verify stage
prepare docker-compose to verify this image

# create push.sh
scripts for push to container registry
for example:
```
#!/bin/bash
#set -euo pipefail

IMAGE_NAME="ubuntu-docker"
TAG="$(date -u +%Y%m%d-%H%M%S)"
VERSION="$(grep -m1 '^ARG VERSION=' "./Dockerfile" | cut -d= -f2)"

REGISTRY="<registry url>"
PROJECT_ID="<gcp project name>"
REPO="<repo name>"
IMAGE="${REGISTRY}/${PROJECT_ID}/${REPO}/${IMAGE_NAME}"

gcloud auth configure-docker "$REGISTRY" --quiet
docker build --provenance=false -t "${IMAGE}:${TAG}" \
  -t "${IMAGE}:${VERSION}" \
  -t "${IMAGE}:latest" \
  .
docker push "${IMAGE}:${TAG}"
docker push "${IMAGE}:${VERSION}"
docker push "${IMAGE}:latest"

echo "Pushed ${IMAGE}:${TAG}"
echo "Pushed ${IMAGE}:${VERSION}"
echo "Pushed ${IMAGE}:latest"
```

# don't do
- push image

