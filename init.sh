#!/bin/bash

echo ">>> sho-comfyui-runpod@init.sh started"

# Install required pip packages
PIP_PACKAGES=(
    "insightface"
    "addict"
    "mediapipe"
)


for package in "${PIP_PACKAGES[@]}"; do
    echo ">>> sho-comfyui-runpod@init.sh Trying to install $package..."
    if pip show "$package" > /dev/null 2>&1; then
        echo ">>> sho-comfyui-runpod@init.sh $package is already installed, skipping."
    else
        echo ">>> sho-comfyui-runpod@init.sh Installing $package..."
        pip install "$package"
    fi
done

echo ">>> sho-comfyui-runpod@init.sh Package installation completed successfully!"
