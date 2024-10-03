#!/bin/bash

set -Eeuo pipefail

# Check if main.py exists
if [ ! -f "./ComfyUI/main.py" ]; then
  echo "main.py not found, cloning..."
  git clone https://github.com/comfyanonymous/ComfyUI.git
else
  echo "main.py found." 
fi

# Check if ComfyUI-Manager exists
if [ ! -d ${ROOT}/custom_nodes/ComfyUI-Manager ]; then
  echo "ComfyUI-Manager not found, cloning..."
  git clone https://github.com/ltdrdata/ComfyUI-Manager.git ${ROOT}/custom_nodes/ComfyUI-Manager --depth 1
else
  echo "ComfyUI-Manager found." 
fi

exec "$@"
