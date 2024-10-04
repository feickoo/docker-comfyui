#!/bin/bash

# Define the directory for temporary cloning
TEMP_DIR="/gitclone"
ROOT="/comfyui"

# Mark directories as safe for Git
git config --global --add safe.directory /comfyui
git config --global --add safe.directory /comfyui/custom_nodes/ComfyUI-Manager

# Repository URL for ComfyUI
COMFY_GIT="https://github.com/comfyanonymous/ComfyUI.git"
C_M_GIT="https://github.com/ltdrdata/ComfyUI-Manager.git"

# Check if /comfyui exists (but don't try to update it)
if [ -d "${ROOT}/main.py" ]; then
  echo "ComfyUI is already installed."
else
  echo "ComfyUI not found, installing..."
  
  # Clone the repository into /comfyui if it doesn't exist
  git clone ${COMFY_GIT} ${TEMP_DIR} --depth 1 -q
  cp -rf ${TEMP_DIR}/* ${ROOT}/
  cp -rf ${TEMP_DIR}/.[^.]* ${ROOT}/ # Also copy hidden files
  echo "ComfyUI installed successfully."
fi

# Check if ComfyUI-Manager exists (but don't try to update it)
if [ -d "${ROOT}/custom_nodes/ComfyUI-Manager" ]; then
  echo "ComfyUI-Manager is already installed."
else
  echo "ComfyUI-Manager not found, installing..."
  
  # Clone ComfyUI-Manager if it doesn't exist
  git clone ${C_M_GIT} ${ROOT}/custom_nodes/ComfyUI-Manager --depth 1 -q
  echo "ComfyUI-Manager installed successfully."
fi

chown -R 777 /comfyui

exec su - comfy-artist -c "python -u /comfyui/main.py --listen 0.0.0.0"
