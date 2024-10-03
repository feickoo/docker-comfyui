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

# Check if /comfyui is a git repository
if [ -d "${ROOT}/.git" ]; then
echo "Checking updates for ComfyUI..."

# Move into the /comfyui directory
cd ${ROOT}

# Fetch the latest changes from the remote repository quietly
git fetch --tags -q

# Get the latest local tag
LOCAL_TAG=$(git describe --tags $(git rev-list --tags --max-count=1) 2>/dev/null || git rev-parse --short HEAD)
# Get the latest remote tag directly from the repository URL
REMOTE_TAG=$(git ls-remote --tags ${COMFY_GIT} | grep -o 'refs/tags/[vV]*[0-9.]*' | sort -V | tail -n1 | sed 's/refs\/tags\///')

echo "Current version (local): ${LOCAL_TAG}"
echo "Latest version (remote): ${REMOTE_TAG}"

# If the local and remote versions don't match, pull the latest changes
if [ "${LOCAL_TAG}" != "${REMOTE_TAG}" ]; then
echo "New version available, pulling the latest changes..."
git reset --hard origin/master
git pull --rebase
echo "Updated to version ${REMOTE_TAG}"
else
echo "Already up-to-date with the latest version."
fi
else
echo "Installing ComfyUI, cloning..."

# Clone the repository into /comfyui and include the .git directory
git clone ${COMFY_GIT} ${TEMP_DIR} --depth 1 --tags -q
cd ${ROOT}

# Move the files from the temporary directory to /comfyui
cp -rf ${TEMP_DIR}/* ${ROOT}/
cp -rf ${TEMP_DIR}/.[^.]* ${ROOT}/ # Also copy hidden files
echo "Cloned and moved files to /comfyui successfully."
fi

# Check if ComfyUI-Manager exists and update or clone it
if [ -d "${ROOT}/custom_nodes/ComfyUI-Manager/.git" ]; then
echo "Checking updates for ComfyUI-Manager..."

# Move into the ComfyUI-Manager directory
cd ${ROOT}/custom_nodes/ComfyUI-Manager

# Fetch the latest changes from the remote repository quietly
git fetch --tags -q

# Get the latest local and remote tags
LOCAL_TAG=$(git describe --tags $(git rev-list --tags --max-count=1) 2>/dev/null || git rev-parse --short HEAD)
REMOTE_TAG=$(git ls-remote --tags ${C_M_GIT} | grep -o 'refs/tags/[vV]*[0-9.]*' | sort -V | tail -n1 | sed 's/refs\/tags\///')

echo "Current ComfyUI-Manager version (local): ${LOCAL_TAG}"
echo "Latest ComfyUI-Manager version (remote): ${REMOTE_TAG}"

# If the versions don't match, pull the latest changes
if [ "${LOCAL_TAG}" != "${REMOTE_TAG}" ]; then
echo "New version of ComfyUI-Manager available, pulling the latest changes..."
git reset --hard origin/master
git pull --rebase
echo "Updated ComfyUI-Manager to version ${REMOTE_TAG}"
else
     echo "ComfyUI-Manager is already up-to-date."
     echo "ComfyUI-Manager is up-to-date."
fi
else
echo "ComfyUI-Manager not found, cloning..."
git clone ${C_M_GIT} ${ROOT}/custom_nodes/ComfyUI-Manager --depth 1 -q
   echo "ComfyUI-Manager cloned successfully."
   echo "ComfyUI-Manager installed successfully."
fi

# Execute any passed command (like starting main.py)
exec "$@"
