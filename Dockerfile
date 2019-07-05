# How to use this Dockerfile:
# git clone https://github.com/alexlib/dockerfiles
# cd dockerfiles
# docker build -t openptv-vnc .
# docker run -d -p 5901:5901 -p 6901:6901 openptv-vnc
# Open your browser with the link: 
# http://localhost:6901/vnc.html
# Click on the connect - enter the default password:  vncpassword
# Open: Applications -> Terminal
# Type: 
# ptvgui test_cavity
# 
# Dont' forget the remove the container that might run in the background: 
# docker stop $(docker ps -a -q)
# docker rm $(docker ps -a -q)

FROM consol/ubuntu-xfce-vnc
ENV REFRESHED_AT 2019-07-05

# Switch to root user to install additional software
USER 0

# Prerequisites
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-dev libqt4-dev git && \
    apt-get -y install python3-pyqt4 python3-pyqt4.qtopengl libx11-dev g++ libpcre3 libpcre3-dev swig && \
    apt-get -y install libglu1-mesa libgl1-mesa-dev mesa-common-dev freeglut3-dev libgtk2.0-dev

RUN pip3 install --upgrade pip
RUN pip install numpy
RUN pip install pyptv --index-url https://pypi.fury.io/pyptv --extra-index-url https://pypi.org/simple

USER 1000

RUN git clone --depth 1 -b master --single-branch https://github.com/OpenPTV/test_cavity.git

