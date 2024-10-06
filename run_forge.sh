#!/bin/bash

# Ensure ForgeUI is installed
if [ ! -d "${FORGE}" ] || [ -z "$(ls -A ${FORGE})" ]; then
  echo "ForgeUI not found or empty, installing..."
  git clone ${FORGE_GIT} ${TEMP_DIR} --depth 1 -q
  cp -rf ${TEMP_DIR}/* ${FORGE}/
  cp -rf ${TEMP_DIR}/.[^.]* ${FORGE}/  # Also copy hidden files
  echo "ForgeUI installed successfully."
fi

# Set permissions for the /forge directory
chown -R ${APPUSER}:${APPUSER} ${FORGE}

# Start ForgeUI service
exec gosu ${APPUSER} ${FORGE}/webui.sh --listen 0.0.0.0
