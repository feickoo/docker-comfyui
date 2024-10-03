#!/bin/bash

set -Eeuo pipefail

  git clone https://github.com/comfyanonymous/ComfyUI.git /workspace --depth 1

  # Move contents of /workspace to ${ROOT}
  echo "Moving files from /workspace to ${ROOT}..."
  mv /workspace/* ${ROOT}/
  mv /workspace/.[^.]* ${ROOT}/ # Move hidden files (like .git)

exec "$@"
