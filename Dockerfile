FROM ubuntu:latest


# Prerequisites
RUN apt-get update
RUN apt-get install -y git python3 python3-pip qt5-default
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install numpy==1.17.3
RUN python3 -m pip install pyptv --index-url https://pypi.fury.io/pyptv --extra-index-url https://pypi.org/simple --ignore-installed pyxdg

RUN git clone --depth 1 -b master --single-branch https://github.com/OpenPTV/test_cavity.git

ENV DISPLAY=host.docker.internal:0.0

CMD ["pyptv test_cavity"]

