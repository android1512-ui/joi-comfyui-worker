FROM runpod/worker-comfyui:5.4.0-base

# Install custom nodes
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/sipie800/ComfyUI-PuLID-Flux-Enhanced.git --depth=1 && \
    git clone https://github.com/rgthree/rgthree-comfy.git --depth=1 && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git --depth=1 && \
    git clone https://github.com/jps-yes/ComfyUI-Easy-Use.git --depth=1 && \
    git clone https://github.com/Jonseed/ComfyUI-Detail-Daemon.git --depth=1 && \
    git clone https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git --depth=1 && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git --depth=1 && \
    git clone https://github.com/Gourieff/ComfyUI-ReActor.git --depth=1 && \
    git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git --depth=1 && \
    git clone https://github.com/Extraltodeus/ComfyUI_JPS-Nodes.git --depth=1

# Install requirements for custom nodes
RUN cd /comfyui/custom_nodes/ComfyUI-PuLID-Flux-Enhanced && pip install -r requirements.txt --no-cache-dir 2>/dev/null || true
RUN cd /comfyui/custom_nodes/ComfyUI-ReActor && pip install -r requirements.txt --no-cache-dir 2>/dev/null || true
RUN pip install insightface onnxruntime-gpu --no-cache-dir 2>/dev/null || true

# Disable ReActor NSFW checker
RUN sed -i 's/if not sfw.nsfw_image(img_byte_arr, NSFWDET_MODEL_PATH):/if True: # NSFW check disabled/' \
    /comfyui/custom_nodes/ComfyUI-ReActor/nodes.py 2>/dev/null || true

# Models will be loaded from network volume at /runpod-volume
# The worker-comfyui image handles model path configuration
