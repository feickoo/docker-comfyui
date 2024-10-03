#!/bin/bash

set -Eeuo pipefail

declare -A MOUNTS

MOUNTS["${ROOT}"]="/root"

for to_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  from_path="${MOUNTS[${to_path}]}"
  rm -rf "${to_path}"
  if [ ! -f "$from_path" ]; then
    mkdir -vp "$from_path"
  fi
  mkdir -vp "$(dirname "${to_path}")"
  ln -sT "${from_path}" "${to_path}"
  echo Mounted $(basename "${from_path}")
done

# Clone ComfyUI into /workspace if not already present in ${ROOT}
if [ ! -f "${ROOT}/main.py" ]; then
  echo "main.py not found in ${ROOT}, cloning into /workspace..."
  git clone https://github.com/comfyanonymous/ComfyUI.git /workspace --depth 1

  # Move contents of /workspace to ${ROOT}
  echo "Moving files from /workspace to ${ROOT}..."
  mv /workspace/* ${ROOT}/
  mv /workspace/.[^.]* ${ROOT}/ # Move hidden files (like .git)

  echo "Files moved to ${ROOT}"
else
  echo "main.py found in ${ROOT}."
fi

# Check if ComfyUI-Manager exists
if [ ! -d "${ROOT}/custom_nodes/ComfyUI-Manager" ]; then
  echo "ComfyUI-Manager not found, cloning..."
  git clone https://github.com/ltdrdata/ComfyUI-Manager.git ${ROOT}/custom_nodes/ComfyUI-Manager --depth 1
else
  echo "ComfyUI-Manager found."
fi

exec "$@"
