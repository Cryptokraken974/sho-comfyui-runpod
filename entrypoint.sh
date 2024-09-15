#!/bin/bash

set -e

echo ">>> sho-comfyui-runpod@entrypoint.sh started"
echo ">>> sho-comfyui-runpod@start.sh Starting init.sh..."

# Execute the initialization script
./init.sh

echo ">>> sho-comfyui-runpod@entrypoint.sh Starting SSH..."

# Start the SSH daemon in the background
/usr/sbin/sshd -D &

echo ">>> sho-comfyui-runpod@start.sh Starting start.sh..."

# Execute the start script
./start.sh &

echo ">>> sho-comfyui-runpod@start.sh Starting waiting all process to end..."

# Use 'wait' to keep the entrypoint script running until all background processes finish
wait