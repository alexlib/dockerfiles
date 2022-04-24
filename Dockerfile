# How to use this Dockerfile
#   docker build -t openptv-python -f Dockerfile .  --no-cache
#   docker run -p 25901:5901 -p 26901:6901 -v /dev/shm:/dev/shm openptv-python
#
# Open your browser with the link: 
#
#       http://localhost:26901/vnc_lite.html?password=headless
#
# Open the command shell (the Icon of the Terminal at the bottom or Applications -> Terminal)
#
# Run these two commands in the shell: 
#       source /venv/bin/activate 
#       pyptv test_cavity
# 
# Dont' forget the remove the container that might run in the background: 
# docker stop $(docker ps -a -q)
# docker rm $(docker ps -a -q) 

# The build-stage image:
FROM continuumio/miniconda3 AS build

# USER root

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


# Install the package as normal:
COPY environment.yml .
RUN conda env create -f environment.yml

# Install conda-pack:
RUN conda install -c conda-forge conda-pack

# Use conda-pack to create a standalone enviornment
# in /venv:
RUN conda-pack -n pyptv -o /tmp/env.tar && \
  mkdir /venv && cd /venv && tar xf /tmp/env.tar && \
  rm /tmp/env.tar

# We've put venv in same path it'll be in final image,
# so now fix up paths:
RUN /venv/bin/conda-unpack

# SHELL ["/bin/bash", "-c"]
# RUN source /venv/bin/activate
# RUN export ETS_TOOLKIT=qt
# RUN python /venv/lib/python3.8/site-packages/kiva/examples/kiva/kiva_explorer.py

# The runtime-stage image; we can use Debian as the
# base image since the Conda env also includes Python
# for us.
FROM accetto/ubuntu-vnc-xfce-g3:latest AS runtime

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    libx11-dev \
    libqt5gui5 \
    libglu1-mesa-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy /venv from the previous stage:
COPY --from=build /venv /venv

# When image is run, run the code with the environment
# activated:
SHELL ["/bin/bash", "-c"]
RUN source /venv/bin/activate && git clone --depth 1 -b master --single-branch https://github.com/OpenPTV/test_cavity.git 
# ENTRYPOINT source /venv/bin/activate && \
#           python -c "import numpy; print('success!')"



