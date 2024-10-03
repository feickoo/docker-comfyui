#!/bin/bash

# Temporary directory for cloning
TEMP_DIR="/gitclone"

# Clone the repository if main.py is not found in the current directory
if [ ! -f "main.py" ]; then 
  echo "main.py not found, cloning into ${TEMP_DIR}..."
  
  # Remove the temporary directory if it exists
  rm -rf ${TEMP_DIR}
  
  # Clone the repository into the temporary directory
  git clone https://github.com/comfyanonymous/ComfyUI.git ${TEMP_DIR} --depth 1
  
  # Get the latest version or commit hash (you can modify this if needed)
  cd ${TEMP_DIR}
  LATEST_COMMIT=$(git rev-parse HEAD)
  echo "Cloned latest version with commit hash: ${LATEST_COMMIT}"
  
  # Move back to the root
  cd -

  # Copy the contents of the cloned directory to the /comfyui directory, overwriting if necessary
  echo "Copying ${TEMP_DIR} to /comfyui..."
  cp -rf ${TEMP_DIR}/* /comfyui/
  cp -rf ${TEMP_DIR}/.[^.]* /comfyui/ # Also copy hidden files and directories (like .git)

  echo "Files copied to /comfyui successfully."
else
  echo "main.py found, no need to clone."
fi

# Execute any passed command (like starting main.py)
exec "$@"
