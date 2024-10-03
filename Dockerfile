FROM pytorch/pytorch:2.4.1-cuda12.4-cudnn9-runtime

RUN apt-get update && apt-get install -y git wget unzip

ENV ROOT=/comfyui

WORKDIR /workspace
RUN --mount=type=cache,target=/root/.cache/pip \
  wget https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt && \
  pip install -r requirements.txt
 
RUN wget https://raw.githubusercontent.com/feickoo/docker-comfyui/refs/heads/master/entrypoint.sh \
    && chmod u+x entrypoint.sh

WORKDIR ${ROOT}

ENTRYPOINT ["/workspace/entrypoint.sh"]
ENV NVIDIA_VISIBLE_DEVICES=all PYTHONPATH="${PYTHONPATH}:${PWD}" CLI_ARGS=""
CMD python -u "/comfyui/main.py" --listen "0.0.0.0" ${CLI_ARGS}
