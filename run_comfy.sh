#!/bin/bash

# Check if ComfyUI is installed
if [ -f "${COMFY}/main.py" ]; then
  echo "ComfyUI is already installed."
else
  echo "ComfyUI not found, installing..."
  git clone ${COMFY_GIT} ${TEMP_DIR} --depth 1 -q
  cp -rf ${TEMP_DIR}/* ${COMFY}/
  cp -rf ${TEMP_DIR}/.[^.]* ${COMFY}/
  echo "ComfyUI installed successfully."
fi

# Check if ComfyUI-Manager is installed
if [ -d "${COMFY}/custom_nodes/ComfyUI-Manager" ]; then
  echo "ComfyUI-Manager is already installed."
else
  git clone ${C_M_GIT} ${COMFY}/custom_nodes/ComfyUI-Manager --depth 1 -q
  echo "ComfyUI-Manager installed successfully."
fi

# Set permissions for the /comfyui directory
chown -R ${APPUSER}:${APPUSER} ${COMFY}

# Start the ComfyUI service as APPUSER
exec gosu ${PUID}:${PGID} python -u ${COMFY}/main.py --listen 0.0.0.0
