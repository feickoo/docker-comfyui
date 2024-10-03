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

# Check if main.py exists
if [ ! -f "main.py" ]; then
  echo "main.py not found, cloning..."
  git clone https://github.com/comfyanonymous/ComfyUI.git ${ROOT} --depth 1 
else
  echo "main.py found." 
fi

# Check if ComfyUI-Manager exists
if [ ! -d /custom_nodes/ComfyUI-Manager ]; then
  echo "main.py not found, cloning..."
  git clone https://github.com/ltdrdata/ComfyUI-Manager.git ${ROOT}/custom_nodes/ComfyUI-Manager --depth 1
else
  echo "ComfyUI-Manager found." 
fi

exec "$@"
