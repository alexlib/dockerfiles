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


FROM conda/miniconda2
MAINTAINER Alex Liberzon <alexlib@tauex.tau.ac.il>

# ENV LANG en-US

WORKDIR /home

RUN apt-get update 
RUN apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libglu1-mesa \
    libgl1-mesa-dev \
    mesa-common-dev \
    freeglut3-dev \
    libgtk2.0-dev

RUN conda update -y conda && \
    conda install -y \
    pip \
    gcc_linux-64 \
    gxx_linux-64 \
    gfortran_linux-64 \
    numpy=1.16.1 \
    scipy \
    cython \
    qt=4 \
    swig \
    nose \
    kiwisolver \
    future && \
    conda clean --tarballs && \
    conda clean --packages

RUN cd /home && \
    git clone --depth 1 -b master --single-branch https://github.com/OpenPTV/openptv.git

RUN cd /home/openptv/py_bind  && python setup.py prepare && python setup.py install

RUN cd /home/openptv/py_bind/test && nosetests --verbose

RUN conda install cloudpickle dask[array] networkx PyWavelets matplotlib scikit-image --no-deps

RUN pip install chaco enable 

RUN cd /home && \
    git clone --depth 1 -b master --single-branch https://github.com/alexlib/pyptv.git && \
    cd /home/pyptv && \
    python setup.py install && \
    cd tests && \
    nosetests --verbose

RUN cd /home && \
    git clone --depth 1 -b master --single-branch https://github.com/OpenPTV/test_cavity.git
    
# ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}

WORKDIR /home/pyptv/pyptv/

# CMD python pyptv_gui.py /home/test_cavity

CMD ["python", "./pyptv_gui.py", "../../test_cavity"]

