# ComfyUI Docker Setup

This repository contains the necessary files to set up a Docker environment for ComfyUI with custom configurations and models.

## Files

1. `docker-compose.yml`: Docker Compose configuration file for setting up the ComfyUI environment.
2. `setup_volume.sh`: Script for setting up the volume, including creating directories and downloading models.
3. `install_packages.sh`: Script for installing required Python packages.
4. `.env`: Environment variable file for customizing the Docker build and run settings.

## File Contents

### docker-compose.yml

This file defines the Docker service for ComfyUI. It includes:
- Build context and arguments
- Volume mounts
- Port mappings
- Environment variables
- Command to run on container start

### setup_volume.sh

This script:
- Creates necessary directories for ComfyUI models and custom nodes
- Clones custom node repositories
- Downloads specified models (UNET, CLIP, VAE, etc.)

### install_packages.sh

This script installs required Python packages, including:
- insightface
- addict
- mediapipe

# DETAILS

- The `extra_model_paths.yaml` file is automatically downloaded to the `ComfyUI` directory in the container on first run.
- Custom nodes are cloned into the `comfyui_network/custom_nodes` directory.
- Models are downloaded into their respective directories under `comfyui_network/models/`.

For more detailed information about the setup and customization options, refer to the comments in each file.

# Access

Access ComfyUI through your web browser at `http://localhost:8188` (or the port specified by RunPod).

Note: The other parameters (like `PYTHON_VERSION`, `PYTORCH_VERSION`, etc.) are set by RunPod and don't need to be specified in the build command.


## How to Use

# Setup the Volume

#Inside the volume terminal

> chmod +x setup_volume.sh
> ./setup_volume.sh

## Building and Running the Container

To build the Docker image with a custom name:

> docker build -t sho974/sho-runpod-worker-comfy:v1 .

To push the image the docker hub
> docker push sho974/sho-runpod-worker-comfy:v1
