#!/bin/bash

run_comfy() {
    echo "UI is empty or not set to forge. Proceeding with ComfyUI installation..."

    if [ -f "${COMFY}/main.py" ]; then
      echo "ComfyUI is already installed."
    else
      echo "ComfyUI not found, installing..."
      git clone ${COMFY_GIT} ${TEMP_DIR} --depth 1 -q
      cp -rf ${TEMP_DIR}/* ${COMFY}/
      cp -rf ${TEMP_DIR}/.[^.]* ${COMFY}/
      echo "ComfyUI installed successfully."
    fi

    if [ -d "${COMFY}/custom_nodes/ComfyUI-Manager" ]; then
      echo "ComfyUI-Manager is already installed."
    else
      git clone ${C_M_GIT} ${COMFY}/custom_nodes/ComfyUI-Manager --depth 1 -q
      echo "ComfyUI-Manager installed successfully."
    fi

    # Set permissions for the /comfyui directory
    chown -R ${APPUSER}:${APPUSER} ${COMFY}

    # Start the ComfyUI service as APPUSER
    exec gosu ${APPUSER} python -u ${COMFY}/main.py --listen 0.0.0.0
}
