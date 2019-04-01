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

WORKDIR /home/pyptv/pyptv/

# CMD python pyptv_gui.py /home/test_cavity

CMD ["python", "./pyptv_gui.py", "../../test_cavity"]
