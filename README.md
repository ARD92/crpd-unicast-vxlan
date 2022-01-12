# Docker compose packaged unicast-vxlan feature for cRPD

This package is a docker-compose based package used to bring up cRPD with unicast-vxlan feature additionally with the existing feature set. In order to use this ensure cRPD is first loaded into docker-images.

Ensure the below packages are installed 
* docker
* docker-compose

The docker-compose version used in this package is 3.0 and has been tested wth the below versions
```
root@ubuntu:/opt/aprabh# docker version
Client: Docker Engine - Community
 Version:           20.10.9
 API version:       1.41
 Go version:        go1.16.8
 Git commit:        c2ea9bc
 Built:             Mon Oct  4 16:08:29 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.9
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.16.8
  Git commit:       79ea9d3
  Built:            Mon Oct  4 16:06:37 2021
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.4.11
  GitCommit:        5b46e404f6b9f661a205e28d59c982d3634148f8
 runc:
  Version:          1.0.2
  GitCommit:        v1.0.2-0-g52b36a2
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0

root@ubuntu:/opt/aprabh/# docker-compose version
docker-compose version 1.25.0, build unknown
docker-py version: 4.1.0
CPython version: 3.8.10
OpenSSL version: OpenSSL 1.1.1f  31 Mar 2020
```

## Load the cRPD docker image
```
docker load -i <latest crpd image>
```

## git clone the package
```
git clone <package>
```

## Start the container using the docker-compose files added
```
docker-compose up -d --build
```
