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

ARG BASE_IMAGE=accetto/ubuntu-vnc-xfce-g3:latest

# ARG BASE_IMAGE=debian:bullseye-slim



# Mutli-stage build to keep final image small. Otherwise end up with
# curl and openssl installed
FROM --platform=$BUILDPLATFORM $BASE_IMAGE AS stage1
ARG VERSION=0.22.0
USER root
RUN apt-get update && apt-get install -y \
    bzip2 \
    ca-certificates \
    curl \
    wget \
    git \
    g++ \
    libx11-dev \
    libqt5gui5 \
    libglu1-mesa-dev \   
    && rm -rf /var/lib/{apt,dpkg,cache,log}

ARG TARGETARCH
RUN test "$TARGETARCH" = 'amd64' && export ARCH='64'; \
    test "$TARGETARCH" = 'arm64' && export ARCH='aarch64'; \
    test "$TARGETARCH" = 'ppc64le' && export ARCH='ppc64le'; \
    curl -L "https://micromamba.snakepit.net/api/micromamba/linux-${ARCH}/${VERSION}" | \
    tar -xj -C "/tmp" "bin/micromamba"

FROM $BASE_IMAGE

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV ENV_NAME="base"
ENV MAMBA_ROOT_PREFIX="/opt/conda"
ENV MAMBA_EXE="/bin/micromamba"

COPY --from=stage1 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=stage1 /tmp/bin/micromamba "$MAMBA_EXE"

ARG MAMBA_USER=mambauser
ARG MAMBA_USER_ID=0
ARG MAMBA_USER_GID=0
ENV MAMBA_USER=$MAMBA_USER

RUN echo "source /usr/local/bin/_activate_current_env.sh" >> ~/.bashrc && \
    echo "source /usr/local/bin/_activate_current_env.sh" >> /etc/skel/.bashrc && \
    groupadd -g "${MAMBA_USER_GID}" "${MAMBA_USER}" && \
    useradd -u "${MAMBA_USER_ID}" -g "${MAMBA_USER_GID}" -ms /bin/bash "${MAMBA_USER}" && \
    echo "${MAMBA_USER}" > "/etc/arg_mamba_user" && \
    mkdir -p "$MAMBA_ROOT_PREFIX/conda-meta" && \
    chmod -R a+rwx "$MAMBA_ROOT_PREFIX" "/home" "/etc/arg_mamba_user" && \
    :

USER $MAMBA_USER

WORKDIR /tmp

# Script which launches commands passed to "docker run"
COPY _entrypoint.sh /usr/local/bin/_entrypoint.sh
COPY _activate_current_env.sh /usr/local/bin/_activate_current_env.sh
ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]

# Default command for "docker run"
CMD ["/bin/bash"]

# Script which launches RUN commands in Dockerfile
COPY _dockerfile_shell.sh /usr/local/bin/_dockerfile_shell.sh
SHELL ["/usr/local/bin/_dockerfile_shell.sh"]

COPY --chown=$MAMBA_USER:$MAMBA_USER env.yaml /tmp/env.yaml
RUN micromamba install -y -f /tmp/env.yaml && \
    micromamba clean --all --yes

RUN git clone --depth 1 -b master --single-branch https://github.com/OpenPTV/test_cavity.git


