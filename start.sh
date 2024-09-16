#!/bin/bash

echo ">>> sho-comfyui-runpod@start.sh started"

echo ">>> sho-comfyui-runpod@start.sh: Starting Jupyter Lab"

jupyter lab --allow-root --no-browser --port=8888 --ip=* --NotebookApp.token='' --NotebookApp.allow_origin='*' &

echo ">>> sho-comfyui-runpod@start.sh: Starting ComfyUI"
python3 ComfyUI/main.py --listen 0.0.0.0