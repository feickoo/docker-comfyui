#!/bin/bash

# Use provided PUID and PGID, or default to 1000 if not set
PUID=${PUID:-1000}
PGID=${PGID:-1000}
USER_NAME="containeruser"
USER_HOME="/home/${USER_NAME}"

# Create a group and user with the specified PUID and PGID
if ! getent group ${PGID} >/dev/null; then
    groupadd -g ${PGID} ${USER_NAME}
fi

if ! id -u ${PUID} >/dev/null 2>&1; then
    useradd -u ${PUID} -g ${PGID} -m -d ${USER_HOME} -s /bin/bash ${USER_NAME}
    chown -R ${PUID}:${PGID} /comfyui /forge /workspace
fi

# Set the correct PATH for the user
export PATH="${USER_HOME}/.local/bin:$PATH"

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
mkdir -p ${FORGE} ${TEMP_DIR}

# Run the appropriate service based on UI variable
if [ "${UI}" = "forge" ]; then
    echo "Running ForgeUI..."
    exec /workspace/run_forge.sh
else
    echo "Running ComfyUI..."
    exec /workspace/run_comfy.sh
fi
