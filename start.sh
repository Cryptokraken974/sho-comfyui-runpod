#!/bin/bash

echo "$$$ sho-comfyui-runpod@start.sh started"

if [[ $PUBLIC_KEY ]]
then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    cd ~/.ssh
    echo $PUBLIC_KEY >> authorized_keys
    chmod 700 -R ~/.ssh
    cd /
    service ssh start
fi

if [[ $JUPYTER_PASSWORD ]]
then
    echo "$$$ sho-comfyui-runpod@start.sh: Starting Jupyterlab"
    cd /
    jupyter lab --allow-root --no-browser --port=8888 --ip=* --ServerApp.terminado_settings='{"shell_command":["/bin/bash"]}' --ServerApp.token=$JUPYTER_PASSWORD --ServerApp.allow_origin=* --ServerApp.preferred_dir=/workspace &
else
    sleep infinity
fi

echo "$$$ sho-comfyui-runpod@start.sh: Starting ComfyUI"
python3 /comfyui/main.py &
