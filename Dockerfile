# DESCRIPTION:	  Create OpenPTV container with its dependencies
# AUTHOR:		  Alex Liberzon <alexlib@eng.tau.ac.il>
# COMMENTS:
#	This file describes how to build an OpenPTV and OpenPTV-Python container with all
#	dependencies installed. It uses native X11 unix socket.
#	Tested on Mac OS X
# USAGE:
#	# Download Dockerfile
#	# Build openptv image
#	docker build -t openptv .
#
#	docker run -v /tmp/.X11-unix:/tmp/.X11-unix \
#		--device=/dev/sda:/dev/sda \
#		-e DISPLAY=unix$DISPLAY openptv
#
#
#    On Mac OS X: 
#    # read https://blog.bennycornelissen.nl/bwc-gui-apps-in-docker-on-osx/
#    # use a simple version by those steps:
#     
#    open -a XQuartz
#    IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
#    xhost + $IP
#    docker run --rm -it --name openptv -e DISPLAY=$IP:0 -v /tmp/.X11-unix:/tmp/.X11-unix openptv
# 
#   Save these commands in a run_openptv.sh and make it executable
# -------------------------------------------------------------------
#   On Windows:
#   # read https://dev.to/darksmile92/run-gui-app-in-linux-docker-container-on-windows-host-4kde
# 
# USAGE:
#   # Use PowerShell in administrtive mode
#   # Run Docker Linux Containers
#	# Download Dockerfile
# 
#   ipconfig
#   set-variable -name DISPLAY -value XX.XX.XXX.XXX:0.0
#   # Run VcXSRV 
#	docker build -t openptv .
#   docker run --rm -it --name openptv -e DISPLAY=$DISPLAY openptv
#   # Now in bash:
#       python pyptv_gui.py ../../test_cavity
#
#   # If error, you may need to fix the dask/ufunc.py as shown above

FROM ubuntu:18.04
MAINTAINER "Alex Liberzon" <alexlib@tauex.tau.ac.il>

WORKDIR /home

# Prerequisites
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y python python-pip python-dev

RUN pip install numpy==1.16.1 cython nose pyyaml fonttools
RUN pip install optv==0.2.4
RUN apt-get -y install python-qt4-gl libx11-dev g++ libpcre3 libpcre3-dev swig && \
    apt-get -y install libglu1-mesa libgl1-mesa-dev mesa-common-dev freeglut3-dev libgtk2.0-dev
# RUN apt-get -y install python-enable
# RUN apt-get -y install python-chaco
RUN pip install enable
RUN pip install chaco
RUN apt-get -y install git
# RUN pip install pyptv


RUN cd /home && \
    git clone --depth 1 -b master --single-branch https://github.com/alexlib/pyptv.git && \
    cd /home/pyptv && \
    pip install . && \
    cd tests && \
    nosetests --verbose

RUN cd /home && \
    git clone --depth 1 -b master --single-branch https://github.com/OpenPTV/test_cavity.git
    
# ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}

WORKDIR /home/

# CMD python pyptv_gui.py /home/test_cavity

CMD ["ptvgui", "test_cavity"]
