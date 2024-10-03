#!/bin/bash

# Define the directory for temporary cloning
TEMP_DIR="/gitclone"

# Check if /comfyui is a git repository
if [ -d "${ROOT}/.git" ]; then
  echo "Checking updates for ComfyUI..."
  
  # Move into the /comfyui directory
  cd ${ROOT}
  
  # Fetch the latest changes from the remote repository
  git fetch --tags
  
  # Get the latest local and remote tags
  LOCAL_TAG=$(git describe --tags $(git rev-list --tags --max-count=1) 2>/dev/null)
  REMOTE_TAG=$(git ls-remote --tags origin | grep -o 'refs/tags/[vV]*[0-9.]*' | sort -V | tail -n1 | sed 's/refs\/tags\///')

  echo "Current version (local): ${LOCAL_TAG}"
  echo "Latest version (remote): ${REMOTE_TAG}"
  
  # If the versions don't match, pull the latest changes
  if [ "${LOCAL_TAG}" != "${REMOTE_TAG}" ]; then
    echo "New version available, pulling the latest changes..."
    git reset --hard origin/master
    git pull --rebase
    echo "Updated to version ${REMOTE_TAG}"
  else
    echo "ComfyUI is up-to-date."
  fi
else
  echo "Installing ComfyUI, cloning..."
  
  # Clone the repository into /comfyui and include the .git directory
  git clone https://github.com/comfyanonymous/ComfyUI.git ${TEMP_DIR} --depth 1 --tags -q
  cd ${ROOT}
  
  # Move the files from the temporary directory to /comfyui
  cp -rf ${TEMP_DIR}/* ${ROOT}/
  cp -rf ${TEMP_DIR}/.[^.]* ${ROOT}/ # Also copy hidden files
  echo "Cloned and moved files to /comfyui successfully."
fi

# Check if ComfyUI-Manager exists and update or clone it
if [ -d "${ROOT}/custom_nodes/ComfyUI-Manager/.git" ]; then
   echo "Checking updates for ComfyUI-Manager..."

   cd ${ROOT}/custom_nodes/ComfyUI-Manager
   git fetch --tags
   LOCAL_TAG=$(git describe --tags $(git rev-list --tags --max-count=1) 2>/dev/null)
   REMOTE_TAG=$(git ls-remote --tags origin | grep -o 'refs/tags/[vV]*[0-9.]*' | sort -V | tail -n1 | sed 's/refs\/tags\///')
   echo "Current ComfyUI-Manager version (local): ${LOCAL_TAG}"
   echo "Latest ComfyUI-Manager version (remote): ${REMOTE_TAG}"   
   
   # If the versions don't match, pull the latest changes
   if [ "${LOCAL_TAG}" != "${REMOTE_TAG}" ]; then
     echo "New version of ComfyUI-Manager available, pulling the latest changes..."
     git reset --hard origin/master
     git pull --rebase
     echo "Updated ComfyUI-Manager to version ${REMOTE_TAG}"
   else
     echo "ComfyUI-Manager is up-to-date."
   fi
else
   echo "ComfyUI-Manager not found, installing..."
   git clone https://github.com/ltdrdata/ComfyUI-Manager.git ${ROOT}/custom_nodes/ComfyUI-Manager --depth 1
   echo "ComfyUI-Manager installed successfully."
fi

# Execute any passed command (like starting main.py)
exec "$@"
