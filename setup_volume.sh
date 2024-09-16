#!/bin/bash

# Create base directory
mkdir -p AIDOCS/models
mkdir -p AIDOCS/custom_nodes

# Create all subdirectories
subdirs=(
    "checkpoints"
    "clip"
    "clip_vision"
    "configs"
    "controlnet"
    "embeddings"
    "loras"
    "upscale_models"
    "vae"
    "insightface"
    "unet"
)

for subdir in "${subdirs[@]}"; do
    mkdir -p "AIDOCS/models/$subdir"
done

# Clone custom nodes
NODES=(
    #"https://github.com/ltdrdata/ComfyUI-Manager"
    #"https://github.com/cubiq/ComfyUI_essentials"
    #"https://github.com/chrisgoringe/cg-use-everywhere"
    #"https://github.com/melMass/comfy_mtb"
    #"https://github.com/giriss/comfy-image-saver"
    #"https://github.com/BlenderNeko/ComfyUI_ADV_CLIP_emb"
    #"https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes"
    #"https://github.com/Fannovel16/comfyui_controlnet_aux"
    #"https://github.com/kinfolk0117/ComfyUI_GradientDeepShrink"
    #"https://github.com/cubiq/ComfyUI_IPAdapter_plus"
    #"https://github.com/JPS-GER/ComfyUI_JPS-Nodes"
    #"https://github.com/storyicon/comfyui_segment_anything"
    #"https://github.com/TinyTerra/ComfyUI_tinyterraNodes"
    #"https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet"
    #"https://github.com/talesofai/comfyui-browser"
    #"https://github.com/pythongosssss/ComfyUI-Custom-Scripts"
    #"https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    #"https://github.com/ltdrdata/ComfyUI-Inspire-Pack"
    #"https://github.com/kijai/ComfyUI-KJNodes"
    #"https://github.com/theUpsider/ComfyUI-Logic"
    #"https://github.com/Nuked88/ComfyUI-N-Sidebar"
    #"https://github.com/receyuki/comfyui-prompt-reader-node"
    #"https://github.com/Gourieff/comfyui-reactor-node"
    #"https://github.com/shiimizu/ComfyUI-TiledDiffusion"
    #"https://github.com/jags111/efficiency-nodes-comfyui"
    #"https://github.com/blib-la/blibla-comfyui-extensions"
    #"https://github.com/jitcoder/lora-info"
    #"https://github.com/rgthree/rgthree-comfy"
    #"https://github.com/WASasquatch/was-node-suite-comfyui"
)

for node in "${NODES[@]}"; do
    node_name=$(basename "$node")
    if [ ! -d "AIDOCS/custom_nodes/$node_name" ]; then
        echo "Cloning $node_name..."
        git clone "$node" "AIDOCS/custom_nodes/$node_name"
    else
        echo "$node_name already exists, skipping clone."
    fi
done

# Download models
download_model() {
    local url=$1
    local dir=$2
    local filename=$(basename "$url")
    if [ ! -f "$dir/$filename" ]; then
        echo "Downloading $filename..."
        wget -O "$dir/$filename" "$url"
    else
        echo "$filename already exists, skipping download."
    fi
}

UNET_MODELS=(
    "https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/flux1-schnell.safetensors"
)

CLIP_MODELS=(
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors"
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors"
)

VAE_MODELS=(
    "https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors"
    "https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"
    "https://huggingface.co/madebyollin/sdxl-vae-fp16-fix/resolve/main/sdxl_vae.safetensors"
)

for model in "${UNET_MODELS[@]}"; do
    download_model "$model" "AIDOCS/models/unet"
done

for model in "${CLIP_MODELS[@]}"; do
    download_model "$model" "AIDOCS/models/clip"
done

for model in "${VAE_MODELS[@]}"; do
    download_model "$model" "AIDOCS/models/vae"
done

# Additional model categories (commented out by default)
# Uncomment and add URLs as needed

#civitai key: baa885d09b6692dad706f82d61a62a13

CHECKPOINT_MODELS=(
    #SDXL1.0
    "https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors"
    #DucHaiten-Pony-Real PONY
    "https://civitai.com/api/download/models/695106?type=Model&format=SafeTensor&size=pruned&fp=fp16&token=baa885d09b6692dad706f82d61a62a13"
    #Hassaku XL (sfw&nsfw) SDXL
    "https://civitai.com/api/download/models/378499?type=Model&format=SafeTensor&size=pruned&fp=bf16&token=baa885d09b6692dad706f82d61a62a13"
    #KarenDiffusion_V1 [NSFW] [XL]
    "https://civitai.com/api/download/models/784834?type=Model&format=SafeTensor&size=pruned&fp=fp16&token=baa885d09b6692dad706f82d61a62a13"
    #DonutsDeliveryMix XL V2 - NSFW Photorealism
    "https://civitai.com/api/download/models/743355?type=Model&format=SafeTensor&size=pruned&fp=fp16&token=baa885d09b6692dad706f82d61a62a13"
)

LORA_MODELS=(
    #FLUX NSFW unlock
    "https://civitai.com/api/download/models/780667?type=Model&format=SafeTensor&token=baa885d09b6692dad706f82d61a62a13"

)

ESRGAN_MODELS=(
    #4x NMKD Superscale
    "https://civitai.com/api/download/models/156841?type=Model&format=PickleTensor&token=baa885d09b6692dad706f82d61a62a13"
    #
)

# CONTROLNET_MODELS=()

for model in "${CHECKPOINT_MODELS[@]}"; do
    download_model "$model" "AIDOCS/models/checkpoints"
done

for model in "${LORA_MODELS[@]}"; do
    download_model "$model" "AIDOCS/models/loras"
 done

for model in "${ESRGAN_MODELS[@]}"; do
    download_model "$model" "AIDOCS/models/upscale_models"
done

# for model in "${CONTROLNET_MODELS[@]}"; do
#     download_model "$model" "AIDOCS/models/controlnet"
# done

echo "Volume setup completed successfully!"
