#!/bin/bash

# Check if main.py exists
if [ ! -f "main.py" ]; then
  echo "main.py not found, cloning..."
  git clone https://github.com/comfyanonymous/ComfyUI.git
else
  echo "main.py found." 
fi

# Start ComfyUI
python main.py --listen 0.0.0.0
