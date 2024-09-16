ARG CUDA_VERSION="12.1.1"
ARG CUDNN_VERSION="8"
ARG UBUNTU_VERSION="22.04"
ARG DOCKER_FROM=nvidia/cuda:$CUDA_VERSION-cudnn$CUDNN_VERSION-devel-ubuntu$UBUNTU_VERSION

# Base NVidia CUDA Ubuntu image
FROM $DOCKER_FROM AS base

# Install Python plus openssh, which is our minimum set of required packages.
RUN apt-get update -y && \
    apt-get install -y python3 python3-pip python3-venv && \
    apt-get install -y --no-install-recommends openssh-server openssh-client git git-lfs wget vim && \
    python3 -m pip install --upgrade pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install nginx
RUN apt-get update && \
    apt-get install -y nginx

ENV PATH="/usr/local/cuda/bin:${PATH}"

# Install pytorch
ARG PYTORCH="2.4.0"
ARG CUDA="121"
RUN pip3 install --no-cache-dir -U torch==$PYTORCH torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu$CUDA

# create work
RUN mkdir /sho_workspace

WORKDIR /sho_workspace

# Clone the git repo and install requirements in the same RUN command to ensure they are in the same layer
RUN git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd ComfyUI && \
    pip3 install -r requirements.txt

RUN pip3 install jupyterlab jupyter_server_terminals mediapipe insightface opencv-python opencv-python-headless
RUN pip3 install ffmpeg 

# Expose the port
EXPOSE 8188

# Add Jupyter port
EXPOSE 8888

#add local executables files to the pod
COPY --chmod=755 start.sh .
#COPY --chmod=755 init.sh .
#COPY --chmod=755 entrypoint.sh .

#copy local config files to the pod
COPY --chmod=644 extra_model_paths.yaml ./ComfyUI

#correct windows line endings
RUN sed -i -e 's/\r$//' ./start.sh
#RUN sed -i -e 's/\r$//' ./init.sh
#RUN sed -i -e 's/\r$//' ./entrypoint.sh

#EXPOSE 22
EXPOSE 22

# Nodes that have to be installed before hand because of required libraries+
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager ./ComfyUI/custom_nodes/ComfyUI-Manager && \
  pip3 install -r ./ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt

RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack ./ComfyUI/custom_nodes/ComfyUI-Impact-Pack && \
  pip3 install -r ./ComfyUI/custom_nodes/ComfyUI-Impact-Pack/requirements.txt

RUN git clone https://github.com/Fannovel16/comfyui_controlnet_aux ./ComfyUI/custom_nodes/comfyui_controlnet_aux && \
  pip3 install -r ./ComfyUI/custom_nodes/comfyui_controlnet_aux/requirements.txt

RUN git clone https://github.com/WASasquatch/was-node-suite-comfyui ./ComfyUI/custom_nodes/was-node-suite-comfyui && \
  pip3 install -r ./ComfyUI/custom_nodes/was-node-suite-comfyui/requirements.txt

RUN git clone https://github.com/storyicon/comfyui_segment_anything ./ComfyUI/custom_nodes/comfyui_segment_anything && \
  pip3 install -r ./ComfyUI/custom_nodes/comfyui_segment_anything/requirements.txt

RUN git clone --recursive https://github.com/receyuki/comfyui-prompt-reader-node ./ComfyUI/custom_nodes/comfyui-prompt-reader-node && \
  pip3 install -r ./ComfyUI/custom_nodes/comfyui-prompt-reader-node/requirements.txt


#one line example
#RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git && cd ComfyUI-Impact-Pack && ( pip install -r requirements.txt || true ) 

  

# Set the entrypoint script as the entrypoint for the container
CMD ["./start.sh"]