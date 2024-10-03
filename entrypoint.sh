#!/bin/bash

set -Eeuo pipefail

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
