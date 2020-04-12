# NeoVim on Docker

## how to use

 1. `sh env_generator.sh`
 2. `docker-compose build`
 3. `docker-compose run --rm nvim nvim <file>`


## clipboard

### WSL2

 1. install [VcXsrv X Server](http://vcxsrv.sourceforge.net)
 2. set environment variable (DISPLAY) in WSL  
```
export DISPLAY=`ip route | grep 'default via' | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'`:0
```
 3. share UNIX domain socket (`/tmp/.X11-unix`) between WSL and container

