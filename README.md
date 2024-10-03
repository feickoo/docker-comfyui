# ComfyUI in Docker

## What’s in the container?

The image is based on  pytorch:2.4.1-cuda12.4-cudnn9-runtime. Once spin up the app, it will git clone ComfyUI and ComfyUI-Manager. And I’ve added auto update feature every once you run the container.

This docker app is configured for Nvidia GPU only. 



All the support please go visit each relative GitHub page



## Docker Compose


```yaml
services:
  comfyui:
    image: feickoo/comfyui:latest
    container_name: comfyui
    ports:
      - 8188:8188
    volumes:
      - /comfyui:/comfy
    deploy:
      resources:
        reservations:
          devices:
            - capabilities:
                - gpu
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
```


## Intention

I was using another docker container for ComfyUI for a while but it’s lack of update got me frustrated. While there are some other options, I wasn’t content with other projects, so I created this project. I’m not sure if I will keep maintaining/updating this but this is a start. A start of my coding journey.

This is my very first docker app. I wrote all the codes with the assistance of GPT/Gemini (or maybe it’s the other way around lol).
