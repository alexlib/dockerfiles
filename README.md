# Dockerfile for OpenPTV

[![](https://images.microbadger.com/badges/image/alexlib/openptv-python.svg)](https://microbadger.com/images/alexlib/openptv-python "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/alexlib/openptv-python.svg)](https://microbadger.com/images/alexlib/openptv-python "Get your own version badge on microbadger.com")

OpenPTV is an open source software for 3D particle tracking velocimetry https://en.wikipedia.org/wiki/Particle_tracking_velocimetry

More information is on our website:  http://www.openptv.net Everyone is welcome to join our forum: https://groups.google.com/forum/#!forum/openptv and contribute on http://github.com/OpenPTV

This is an attempt to create a simpler installation option that is uniform for all platforms, Windows, Mac OS X and Linux and does
not require full VM like our Virtualbox image (3.5 Gb)


## Installation with Docker image from DockerHub, on Windows in 7 steps
1. Install Docker for Windows https://docs.docker.com/docker-for-windows/
2. Open PowerShell in Adminstrative Mode
3. Run and wait for about 5 min (it's approximately 900 Mb download)  
       `docker pull alexlib/openptv-python`
4. Find out your IP using (here XX.XX.XXX.XXX):  
       `ipconfig`
5. Define `DISPLAY` variable  
       `set-variable -name DISPLAY -value XX.XX.XXX.XXX:0.0`  
6. Install Xserver, e.g. following https://dev.to/darksmile92/run-gui-app-in-linux-docker-container-on-windows-host-4kde
5. Run Xserver and run PyPTV:  
       `docker run --rm -it --name openptv -e DISPLAY=$DISPLAY openptv`  
6. You should see that you're now inside the `(base) root@594fb74c31f1:/home/pyptv/pyptv#` or similar environment.  
7. Run the software:  
       `python pyptv_gui.py ../../test_cavity`
 

## If you don't want to pull the image, you can build the docker image locally (10 min)
2. Clone the repository `git clone https://github.com/alexlib/dockerfiles` or download this repository as a zip file, https://github.com/alexlib/dockerfiles/archive/master.zip
3. Unzip it and run the in the terminal: `bash run_openptv_macosx.sh`

See the screencast:

<img src="https://github.com/alexlib/gifs/blob/master/screencast_dockerfile.gif" width="400" />


