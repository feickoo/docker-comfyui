# Use the official PyTorch image as the base
FROM pytorch/pytorch:2.4.1-cuda12.4-cudnn9-runtime

# Install Git and any necessary system dependencies
RUN apt-get update && apt-get install -y git

# Set the working directory to /comfy
WORKDIR /comfy

# Clone the ComfyUI repository into /comfy
RUN git clone https://github.com/comfyanonymous/ComfyUI.git . && \
    git checkout master && \
    pip install -r requirements.txt

# Expose port 8188 to make the UI accessible
EXPOSE 8188

# Command to run the application and listen on all interfaces (0.0.0.0)
CMD ["python", "main.py", "--listen", "0.0.0.0"]