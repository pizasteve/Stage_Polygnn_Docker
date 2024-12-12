
# # # Start with CUDA 12.3 base image (matching the host CUDA version)
# # FROM nvidia/cuda:11.3.1-devel-ubuntu20.04



# # # Avoid interactive prompts during package installation
# # ENV DEBIAN_FRONTEND=noninteractive

# # # Set working directory
# # WORKDIR /workspace

# # # Install system dependencies
# # RUN apt-get -y update \
# # && apt-get install -y software-properties-common \
# # && apt-get -y update \
# # && add-apt-repository universe
# # RUN apt-get -y update


# # # Install Mambaforge with retry options
# # RUN wget --retry-connrefused --timeout=20 --tries=3 -q "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh" -O mambaforge.sh \
# #     && bash mambaforge.sh -b -p /opt/conda \
# #     && rm mambaforge.sh

# # # Add conda/mamba to path
# # ENV PATH=/opt/conda/bin:$PATH

# # # Initialize conda for shell interaction
# # RUN conda init bash

# # # Create and activate environment with Python 3.10
# # RUN conda create --name polygnn python=3.10 -y

# # # Install packages using mamba
# # RUN conda run -n polygnn mamba install -y \
# #         pytorch \
# #         torchvision \
# #         sage=10.0 \
# #         pytorch-cuda=11.7 \
# #         pyg=2.3 \
# #         pytorch-scatter \
# #         pytorch-sparse \
# #         pytorch-cluster \
# #         torchmetrics \
# #         rtree \
# #         -c pyg \
# #         -c pytorch \
# #         -c nvidia \
# #         -c conda-forge \
# #     && conda clean -a -y


# # # Install pip packages including omegaconf
# # RUN conda run -n polygnn pip install \
# #         abspy \
# #         hydra-core \
# #         hydra-colorlog \
# #         omegaconf \
# #         trimesh \
# #         tqdm \
# #         wandb \
# #         plyfile \
# #         torch-geometric \
# #         sympy==1.13.1 \
# #         gdown \
# #     && conda clean -a -y


# # # Clean conda caches
# # RUN conda clean -a -y

# # # Make RUN commands use the new environment
# # SHELL ["conda", "run", "-n", "polygnn", "/bin/bash", "-c"]

# # # Set up environment activation
# # RUN echo "conda activate polygnn" >> ~/.bashrc

# # # Set the default command
# # CMD [ "/bin/bash" ]

# # # Create a shared volume for data persistence
# # VOLUME /workspace/data

# # # Set environment variables for CUDA
# # ENV NVIDIA_VISIBLE_DEVICES=all
# # ENV CUDA_VISIBLE_DEVICES=all

# # Start with the CUDA base image (11.7-devel for compatibility with PyTorch 2.x)
# FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04

# # Set non-interactive mode for apt-get
# ENV DEBIAN_FRONTEND noninteractive

# # Set the working directory inside the container
# WORKDIR /app

# # Copy all files from the host machine into the container
# COPY . /app

# # Install required system dependencies
# RUN apt-get -y update && \
#     apt-get install -y software-properties-common && \
#     apt-get -y update && \
#     add-apt-repository universe && \
#     apt-get -y update && \
#     apt-get -y install \
#     nano \
#     git \
#     python3 \
#     python3-pip \
#     wget \
#     libgl1-mesa-glx \
#     libegl1-mesa \
#     libxrandr2 \
#     libxss1 \
#     libxcursor1 \
#     libxcomposite1 \
#     libasound2 \
#     libxi6 \
#     libxtst6 \
#     curl \
#     sagemath

# # # Install Mambaforge with retry options
# RUN wget --retry-connrefused --timeout=20 --tries=3 -q "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh" -O mambaforge.sh \
#     && bash mambaforge.sh -b -p /opt/conda \
#     && rm mambaforge.sh


# # Add conda/mamba to path
# ENV PATH=/opt/conda/bin:$PATH

# # Initialize conda for shell interaction
# RUN conda init bash

# # Create and activate environment with Python 3.10
# RUN conda create --name polygnn python=3.10 -y


# # Install dependencies using Mamba (with CUDA 11.7 support)
# RUN conda run -n polygnn mamba install -y \
#     pytorch=2.3.0 cudatoolkit=11.7 torchvision=0.14.0 torchaudio=2.0.0 \
#     pyg=2.3 \
#     pytorch-scatter=2.0.9 pytorch-sparse=0.6.9 pytorch-cluster=1.5.9 \
#     torchmetrics rtree \
#     sage=10.0 \
#     -c pyg \
#     -c pytorch \
#     -c nvidia \
#     -c conda-forge

# # Install remaining dependencies with pip (as mamba can't handle these)
# RUN conda run -n polygnn pip install \
#     abspy \
#     hydra-core \
#     hydra-colorlog \
#     omegaconf \
#     trimesh \
#     tqdm \
#     wandb \
#     plyfile










# # Start with the CUDA base image
# FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04

# # Set shell and working directory
# SHELL ["/bin/bash", "-c"]
# WORKDIR /app

# # Set environment variables
# ENV DEBIAN_FRONTEND=noninteractive \
#     CONDA_DIR=/opt/conda \
#     PATH=/opt/conda/bin:$PATH \
#     PYTHONUNBUFFERED=1 \
#     PYTHONUTF8=1 \
#     LANG=C.UTF-8 \
#     LC_ALL=C.UTF-8

# # Install system dependencies in a single RUN to reduce layers
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     git \
#     wget \
#     curl \
#     nano \
#     python3-pip \
#     libgl1-mesa-glx \
#     libegl1-mesa \
#     libxrandr2 \
#     libxss1 \
#     libxcursor1 \
#     libxcomposite1 \
#     libasound2 \
#     libxi6 \
#     libxtst6 \
#     && rm -rf /var/lib/apt/lists/*

# # Install Mambaforge and initialize with retry mechanism
# RUN wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 5 \
#     https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh \
#     -O /tmp/mambaforge.sh \
#     && chmod +x /tmp/mambaforge.sh \
#     && /tmp/mambaforge.sh -b -p ${CONDA_DIR} \
#     && rm /tmp/mambaforge.sh \
#     && ${CONDA_DIR}/bin/conda init bash

# # Create conda environment and install packages directly
# RUN conda create -n polygnn python=3.10 -y \
#     && . ${CONDA_DIR}/bin/activate polygnn \
#     && mamba install -y \
#         pytorch \
#         torchvision \
#         pytorch-cuda=11.7 \
#         pyg=2.3 \
#         pytorch-scatter \
#         pytorch-sparse \
#         pytorch-cluster \
#         torchmetrics \
#         rtree \
#         sage=10.0 \
#         -c pytorch \
#         -c nvidia \
#         -c pyg \
#         -c conda-forge \
#     && pip install \
#         abspy \
#         hydra-core \
#         hydra-colorlog \
#         omegaconf \
#         trimesh \
#         tqdm \
#         wandb \
#         plyfile \
#     && conda clean -afy \
#     && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
#     && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete \
#     && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete

# # Set up environment activation
# RUN echo "conda activate polygnn" >> ~/.bashrc

# # Create a non-root user
# RUN useradd -m -s /bin/bash appuser \
#     && chown -R appuser:appuser /app
# USER appuser

# # Copy application files
# COPY --chown=appuser:appuser . /app/

# # Set environment variables for the conda environment
# ENV CONDA_DEFAULT_ENV=polygnn \
#     PATH=/opt/conda/envs/polygnn/bin:$PATH

# # Set default command
# CMD ["/bin/bash"]



# Start with the CUDA base image
FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04

# Set shell and working directory
SHELL ["/bin/bash", "-c"]
WORKDIR /app


# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    CONDA_DIR=/opt/conda \
    PATH=/opt/conda/bin:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONUTF8=1 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 
    

# Install system dependencies in a single RUN to reduce layers
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    curl \
    nano \
    python3-pip \
    libgl1-mesa-glx \
    libegl1-mesa \
    libxrandr2 \
    libxss1 \
    libxcursor1 \
    libxcomposite1 \
    libasound2 \
    libxi6 \
    libxtst6 \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash appuser

# Install Mambaforge and initialize for the user
RUN wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 5 \
    https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh \
    -O /tmp/mambaforge.sh \
    && chmod +x /tmp/mambaforge.sh \
    && bash /tmp/mambaforge.sh -b -p ${CONDA_DIR} \
    && rm /tmp/mambaforge.sh \
    && chown -R appuser:appuser ${CONDA_DIR}

# Switch to the non-root user
USER appuser

# Initialize conda in the user's environment
RUN ${CONDA_DIR}/bin/conda init bash && \
    echo "conda activate polygnn" >> ~/.bashrc

# Separate Conda environment creation
RUN ${CONDA_DIR}/bin/conda create -n polygnn python=3.10 -y

# Retry logic for Sage and rtree installation to handle network issues
RUN retry_count=5; \
    while [ $retry_count -gt 0 ]; do \
        ${CONDA_DIR}/bin/conda install -n polygnn -y -c conda-forge sage=10.0 rtree --strict-channel-priority && break || retry_count=$((retry_count - 1)); \
        echo "Retrying conda install... ($retry_count attempts left)"; \
        sleep 5; \
    done

# Retry logic for PyTorch and torchvision installation
RUN retry_count=5; \
    while [ $retry_count -gt 0 ]; do \
        ${CONDA_DIR}/bin/conda run -n polygnn pip install pytorch==2.1.0+cu117 cudatoolkit=11.7 torchvision==0.16.0+cu117 --index-url https://download.pytorch.org/whl/cu117 && break || retry_count=$((retry_count - 1)); \
        echo "Retrying pip install torch and torchvision... ($retry_count attempts left)"; \
        sleep 5; \
    done

# Install torch-geometric and related packages with retry logic
RUN retry_count=5; \
    while [ $retry_count -gt 0 ]; do \
        ${CONDA_DIR}/bin/conda run -n polygnn pip install torch-scatter torch-sparse torch-cluster torch-geometric==2.3.0 -f https://data.pyg.org/whl/torch-2.1.0+cu117.html && break || retry_count=$((retry_count - 1)); \
        echo "Retrying pip install torch-geometric packages... ($retry_count attempts left)"; \
        sleep 5; \
    done

# Install remaining Python packages with retry logic
RUN retry_count=5; \
    while [ $retry_count -gt 0 ]; do \
        ${CONDA_DIR}/bin/conda run -n polygnn pip install torchmetrics abspy hydra-core hydra-colorlog omegaconf trimesh tqdm wandb plyfile && break || retry_count=$((retry_count - 1)); \
        echo "Retrying pip install additional packages... ($retry_count attempts left)"; \
        sleep 5; \
    done

# Clean up Conda cache and unnecessary files
RUN ${CONDA_DIR}/bin/conda clean -afy && \
    find ${CONDA_DIR} -follow -type f -name '*.a' -delete && \
    find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete && \
    find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete

# # Copy application files
COPY --chown=appuser:appuser . /app/


# Set environment variables for the conda environment
ENV CONDA_DEFAULT_ENV=polygnn \
    PATH=/opt/conda/envs/polygnn/bin:$PATH

# Make sure we use bash and source conda
SHELL ["/bin/bash", "--login", "-c"]
ENTRYPOINT ["/bin/bash", "--login", "-c"]

# Default command
CMD ["/bin/bash", "--login"]

