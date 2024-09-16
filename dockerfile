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

RUN git clone https://github.com/cubiq/ComfyUI_essentials ./ComfyUI/custom_nodes/ComfyUI_essentials && \
  pip3 install -r ./ComfyUI/custom_nodes/ComfyUI_essentials/requirements.txt

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

RUN git clone https://github.com/melMass/comfy_mtb ./ComfyUI/custom_nodes/comfy_mtb && \
  pip3 install -r ./ComfyUI/custom_nodes/comfy_mtb/requirements.txt

RUN git clone https://github.com/giriss/comfy-image-saver ./ComfyUI/custom_nodes/comfy-image-saver && \
  pip3 install -r ./ComfyUI/custom_nodes/comfy-image-saver/requirements.txt

RUN git clone https://github.com/talesofai/comfyui-browser ./ComfyUI/custom_nodes/comfyui-browser && \
  pip3 install -r ./ComfyUI/custom_nodes/comfyui-browser/requirements.txt

RUN git clone https://github.com/ltdrdata/ComfyUI-Inspire-Pack ./ComfyUI/custom_nodes/ComfyUI-Inspire-Pack && \
  pip3 install -r ./ComfyUI/custom_nodes/ComfyUI-Inspire-Pack/requirements.txt

 RUN git clone https://github.com/kijai/ComfyUI-KJNodes ./ComfyUI/custom_nodes/ComfyUI-KJNodes && \
  pip3 install -r ./ComfyUI/custom_nodes/ComfyUI-KJNodes/requirements.txt

RUN git clone https://github.com/Gourieff/comfyui-reactor-node ./ComfyUI/custom_nodes/comfyui-reactor-node && \
  pip3 install -r ./ComfyUI/custom_nodes/comfyui-reactor-node/requirements.txt

RUN git clone https://github.com/jags111/efficiency-nodes-comfyui ./ComfyUI/custom_nodes/efficiency-nodes-comfyui && \
  pip3 install -r ./ComfyUI/custom_nodes/efficiency-nodes-comfyui/requirements.txt

RUN git clone https://github.com/rgthree/rgthree-comfy ./ComfyUI/custom_nodes/rgthree-comfy && \
  pip3 install -r ./ComfyUI/custom_nodes/rgthree-comfy/requirements.txt

RUN git clone https://github.com/blib-la/blibla-comfyui-extensions ./ComfyUI/custom_nodes/blibla-comfyui-extensions
RUN git clone https://github.com/chrisgoringe/cg-use-everywhere ./ComfyUI/custom_nodes/cg-use-everywhere
RUN git clone https://github.com/BlenderNeko/ComfyUI_ADV_CLIP_emb ./ComfyUI/custom_nodes/ComfyUI_ADV_CLIP_emb
RUN git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes ./ComfyUI/custom_nodes/ComfyUI_Comfyroll_CustomNodes
RUN git clone https://github.com/kinfolk0117/ComfyUI_GradientDeepShrink ./ComfyUI/custom_nodes/ComfyUI_GradientDeepShrink
RUN git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus ./ComfyUI/custom_nodes/ComfyUI_IPAdapter_plus
RUN git clone https://github.com/JPS-GER/ComfyUI_JPS-Nodes ./ComfyUI/custom_nodes/ComfyUI_JPS
RUN git clone https://github.com/TinyTerra/ComfyUI_tinyterraNodes ./ComfyUI/custom_nodes/ComfyUI_tinyterraNodes
RUN git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet ./ComfyUI/custom_nodes/ComfyUI-Advanced-ControlNet
RUN git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts ./ComfyUI/custom_nodes/ComfyUI-Custom-Scripts
RUN git clone https://github.com/theUpsider/ComfyUI-Logic ./ComfyUI/custom_nodes/ComfyUI-Logic
RUN git clone https://github.com/Nuked88/ComfyUI-N-Sidebar ./ComfyUI/custom_nodes/ComfyUI-N-Sidebar
RUN git clone https://github.com/shiimizu/ComfyUI-TiledDiffusion ./ComfyUI/custom_nodes/ComfyUI-TiledDiffusion
RUN git clone https://github.com/jitcoder/lora-info ./ComfyUI/custom_nodes/lora-info


#one line example
#RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git && cd ComfyUI-Impact-Pack && ( pip install -r requirements.txt || true ) 

  

# Set the entrypoint script as the entrypoint for the container
CMD ["./start.sh"]