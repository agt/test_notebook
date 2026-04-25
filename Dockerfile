FROM ghcr.io/ucsd-ets/datascience-notebook:2026.1-main

USER root

# tensorflow, pytorch stable versions
# https://pytorch.org/get-started/previous-versions/

ARG TORCH_VERSION=2.11.0

# apt deps
RUN apt-get update && \
  apt-get install -y \
  libtinfo5 build-essential && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

USER jovyan

RUN pip3 install --no-cache-dir --upgrade uv

RUN uv pip install --system \
        --extra-index-url https://pypi.nvidia.com \
        --extra-index-url https://download.pytorch.org/whl/cu128 \
        nvidia-cuda-nvcc-cu12 \
        nvidia-nccl-cu12 \
        cuda-python \
        opencv-python \
        PyQt5 \
        pycocotools \
        pillow \
        scapy \
        nvidia-cudnn-cu12 \
        torch==$TORCH_VERSION \
        torchvision \
        torchaudio \
        transformers \
        datasets \
        accelerate \
        huggingface-hub \
        timm \
    && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER && \
    uv cache clean

USER $NB_UID:$NB_GID
ENV PATH=${PATH}:/usr/local/nvidia/bin:/opt/conda/bin

