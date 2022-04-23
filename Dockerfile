# How to use this Dockerfile:
#   git clone https://github.com/alexlib/dockerfiles
#   cd dockerfiles
#   docker build -t openptv-vnc .
#   docker run -p 25901:5901 -p 26901:6901 -v /dev/shm:/dev/shm openptv-vnc
#
# Open your browser with the link: 
#
#       http://localhost:26901/vnc_lite.html?password=headless
#
# Open: Applications -> Terminal
# Type: 
#       pyptv test_cavity
# 
# Dont' forget the remove the container that might run in the background: 
# docker stop $(docker ps -a -q)
# docker rm $(docker ps -a -q)
#
# Read about possible configurations on https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc

FROM accetto/ubuntu-vnc-xfce-g3:latest 

LABEL maintainer="Alex Liberzon"

ARG CONDA_PYTHON_VERSION=3
ARG CONDA_DIR=/opt/conda
ARG USERNAME=docker
ARG USERID=1000

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    curl \ 
    git \
    g++ \
    libx11-dev \
    libqt5gui5 \
    libglu1-mesa-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## Install miniconda
ENV PATH $CONDA_DIR/bin:$PATH
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda$CONDA_PYTHON_VERSION-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    echo 'export PATH=$CONDA_DIR/bin:$PATH' > /etc/profile.d/conda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm -rf /tmp/*

# Create the user
RUN useradd --create-home -s /bin/bash --no-user-group -u $USERID $USERNAME && \
    chown $USERNAME $CONDA_DIR -R && \
    adduser $USERNAME sudo && \
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER $USERNAME
WORKDIR /home/$USERNAME

# Install mamba
RUN conda install -y mamba -c conda-forge

ADD ./env.yaml .
RUN mamba env update --file ./env.yaml &&\
    conda clean -tipy

# For interactive shell
RUN conda init bash
RUN echo "conda activate base" >> /home/$USERNAME/.bashrc

RUN git clone --depth 1 -b master --single-branch https://github.com/OpenPTV/test_cavity.git
