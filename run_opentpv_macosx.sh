open -a XQuartz
IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
xhost + $IP
docker run --rm -it --name openptv -e DISPLAY=$IP:0 -v /tmp/.X11-unix:/tmp/.X11-unix openptv
