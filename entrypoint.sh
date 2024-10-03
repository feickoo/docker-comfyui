#!/bin/bash

if [ ! -f "main.py" ]; then
  echo "main.py not found, cloning..."
  git clone https://github.com/comfyanonymous/ComfyUI.git
else
  echo "main.py found." 
fi

exec "$@"
