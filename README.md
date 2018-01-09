# Dockerfile for OpenPTV

[![](https://images.microbadger.com/badges/image/alexlib/openptv-python.svg)](https://microbadger.com/images/alexlib/openptv-python "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/alexlib/openptv-python.svg)](https://microbadger.com/images/alexlib/openptv-python "Get your own version badge on microbadger.com")


OpenPTV is an open source software for 3D particle tracking velocimetry https://en.wikipedia.org/wiki/Particle_tracking_velocimetry

More information is on our website:  http://www.openptv.net Everyone is welcome to join our forum: https://groups.google.com/forum/#!forum/openptv and contribute on http://github.com/OpenPTV

This is an attempt to create a single click installation. 

## Installation using Docker (about 15 min)
1. Install Docker, from https://www.docker.com 
2. Download this repository as a zip file, https://github.com/alexlib/dockerfiles/archive/master.zip
3. Open the zip file and run the `run_openptv_macosx.sh`
4. In the shell you will see that you're in the pyptv_gui directory and ready to run the code. for the test use  

      `python pyptv_gui.py /home/test_cavity`
      
5. In order to work on a folder what is on the host machine, you have add it to /Users if you're on Mac or C:\Users if you're on Windows. Then it's easy to access that folder, e.g.   

    `python pyptv_gui.py /host/Users/alex/Downloads/test_cavity`
    
then everything is saved and persistent

If you experience the following error:
```
File "/opt/conda/lib/python2.7/site-packages/dask/array/ufunc.py", line 138, in <module>
    cbrt = ufunc(np.cbrt)
```
the workaround (for the moment, before numpy will be updated inside miniconda docker) is to open the file using `nano` editor
``` 
      nano /opt/conda/lib/python2.7/site-packages/dask/array/ufunc.py
```
and comment out the line 138:
```
    #cbrt = ufunc(np.cbrt)
 ```

This image is built automatically on the DockerHub hub.docker.com/r/alexlib/openptv-python

See the screencast:

<img src="https://github.com/alexlib/gifs/blob/master/screencast_dockerfile.gif" width="400" />


