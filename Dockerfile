FROM pytorch/pytorch:2.4.1-cuda12.4-cudnn9-runtime

RUN apt-get update && apt-get install -y git wget

WORKDIR /workspace

RUN --mount=type=cache,target=/root/.cache/pip \
    wget https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt && \
    pip install -r requirements.txt && \
    pip install "numpy<2" numba ffmpy scikit-image scikit-learn scipy tqdm \
    GitPython imageio joblib matplotlib timm==1.0.9 rembg onnxruntime==1.19.2 \
    git+https://github.com/WASasquatch/ffmpy.git \
    git+https://github.com/WASasquatch/cstr.git

RUN wget https://raw.githubusercontent.com/feickoo/docker-comfyui/refs/heads/master/entrypoint.sh \
    && chmod u+x entrypoint.sh

ENV NVIDIA_VISIBLE_DEVICES=all 
ENV PIP_USER=true
ENV PIP_ROOT_USER_ACTION=ignore
ENV PATH="/root/.local/bin:$PATH"
ENTRYPOINT ["/workspace/entrypoint.sh"]
CMD ["python", "-u", "/comfyui/main.py", "--listen", "0.0.0.0"]
