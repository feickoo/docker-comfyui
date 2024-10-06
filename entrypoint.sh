#!/bin/bash

# Define directories
COMFY="/comfyui"
FORGE="/forge"
TEMP_DIR="/gitclone"

# Mark directories as safe for Git
git config --global --add safe.directory ${COMFY}
git config --global --add safe.directory ${COMFY}/custom_nodes/ComfyUI-Manager
git config --global --add safe.directory ${FORGE}

# Repository URLs
COMFY_GIT="https://github.com/comfyanonymous/ComfyUI.git"
C_M_GIT="https://github.com/ltdrdata/ComfyUI-Manager.git"
FORGE_GIT="https://github.com/lllyasviel/stable-diffusion-webui-forge.git"

# Ensure required directories exist
mkdir -p ${COMFY} ${FORGE} ${TEMP_DIR}

# Check which UI to use based on the environment variable UI
if [ "${UI}" = "forge" ]; then
    # ForgeUI flow
    echo "UI is set to forge. Checking ForgeUI installation..."

    # Check if ForgeUI is installed
    if [ -d "${FORGE}" ] && [ "$(ls -A ${FORGE})" ]; then
      echo "ForgeUI is already installed."
    else
      echo "ForgeUI not found or empty, installing..."

      # Clone the repository into a temporary directory and copy it to /forge
      git clone ${FORGE_GIT} ${TEMP_DIR} --depth 1 -q
      cp -rf ${TEMP_DIR}/* ${FORGE}/
      cp -rf ${TEMP_DIR}/.[^.]* ${FORGE}/  # Also copy hidden files
      echo "ForgeUI installed successfully."
    fi

    # Set permissions for the /forge directory
    chown -R 777 ${FORGE}

    # Switch to the non-root user and start the ForgeUI service
    exec gosu appuser ${FORGE}/webui.sh --listen 0.0.0.0

else
    # ComfyUI flow
    echo "UI is empty or not set to forge. Proceeding with ComfyUI installation..."

    # Check if ComfyUI is installed
    if [ -f "${COMFY}/main.py" ]; then
      echo "ComfyUI is already installed."
    else
      echo "ComfyUI not found, installing..."
      
      # Clone the repository into a temporary directory and copy it to /comfyui
      git clone ${COMFY_GIT} ${TEMP_DIR} --depth 1 -q
      cp -rf ${TEMP_DIR}/* ${COMFY}/
      cp -rf ${TEMP_DIR}/.[^.]* ${COMFY}/  # Also copy hidden files
      echo "ComfyUI installed successfully."
    fi

    # Check if ComfyUI-Manager is installed
    if [ -d "${COMFY}/custom_nodes/ComfyUI-Manager" ]; then
      echo "ComfyUI-Manager is already installed."
    else
      echo "ComfyUI-Manager not found, installing..."
      
      # Clone ComfyUI-Manager if it doesn't exist
      git clone ${C_M_GIT} ${COMFY}/custom_nodes/ComfyUI-Manager --depth 1 -q
      echo "ComfyUI-Manager installed successfully."
    fi

    # Set permissions for the /comfyui directory
    chown -R 777 ${COMFY}

    # Switch to the non-root user and start the ComfyUI service
    exec gosu appuser python -u ${COMFY}/main.py --listen 0.0.0.0
fi
