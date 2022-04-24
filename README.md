# Dockerfile for OpenPTV

[![](https://images.microbadger.com/badges/image/alexlib/openptv-python.svg)](https://microbadger.com/images/alexlib/openptv-python "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/alexlib/openptv-python.svg)](https://microbadger.com/images/alexlib/openptv-python "Get your own version badge on microbadger.com")
[![Docker Image CI](https://github.com/alexlib/dockerfiles/actions/workflows/docker-image.yml/badge.svg)](https://github.com/alexlib/dockerfiles/actions/workflows/docker-image.yml)

OpenPTV is an open source software for 3D particle tracking velocimetry https://en.wikipedia.org/wiki/Particle_tracking_velocimetry

More information is on our website:  http://www.openptv.net Everyone is welcome to join our forum: https://groups.google.com/forum/#!forum/openptv and contribute on http://github.com/OpenPTV

This is an attempt to create a simpler installation option that is uniform for all platforms, Windows, Mac OS X and Linux and does
not require full VM like our Virtualbox image (3.5 Gb)


## Installation with Docker image from DockerHub, on Windows
1. Install Docker for Windows https://docs.docker.com/docker-for-windows/
2. Open PowerShell or Command Prompt
3. Run and wait for about 5 min (it's approximately 900 Mb download)  

       docker pull alexlib/openptv-python
       docker run -p 25901:5901 -p 26901:6901 -v /dev/shm:/dev/shm alexlib/openptv-python
       
4. Open your browser with the link: http://localhost:26901/vnc_lite.html?password=headless
5. Open: `Applications -> Terminal` (command shell) and type:

       source /venv/bin/activate
       pyptv test_cavity

6. Dont' forget the remove the container that might run in the background:  

       docker stop $(docker ps -a -q)
       docker rm $(docker ps -a -q) 

## Installation with Docker image from DockerHub, on Mac OS X
1. Install Docker https://docs.docker.com/docker-for-mac, the rest is the same as for Windows

## If you want to build the image instead of pulling it from DockerHub:
2. Clone the repository `git clone https://github.com/alexlib/dockerfiles` or download this repository as a zip file, https://github.com/alexlib/dockerfiles/archive/master.zip
3. Unzip it and run the in the terminal:  

       docker build -t openptv-vnc .
       docker run -p 6080:80 -v /dev/shm:/dev/shm openptv-vnc
       open http://127.0.0.1:6080/

4. Open: `Applications -> Terminal` and type: 
             
       pyptv test_cavity

### Dont' forget the remove the container that might run in the background: 

       docker stop $(docker ps -a -q)
       docker rm $(docker ps -a -q)

See the screencast:

<img src="https://github.com/alexlib/gifs/blob/master/screencast_dockerfile.gif" width="400" />


