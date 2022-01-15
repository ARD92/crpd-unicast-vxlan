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
Note that tag might be different on the version you intend to load. The docker file has to use this cRPD image. currently it is used as `crpd:latest`. Change accordingly if needed.

```
docker load -i crpd:21.3-20210331.421
```

## git clone the package
```
git clone --branch v1.2-docker-compose https://github.com/aprabh92/crpd-unicast-vxlan.git
```

## Start the container using the docker-compose files added
```
docker-compose up -d --build
```

The above command will build the container and start it. Once started please verify if the processes are running. The package itself is included in the directory `/var/opt/unicast-vxlan`

```
root@acf436c2d929:/# ls -l /var/opt/unicast-vxlan/
total 24
-rwxr-xr-x 1 root root  313 Jan 12 13:44 basic-crpd-config
-rw-r--r-- 1 root root   87 Jan 12 13:44 load-config.sh
-rwxr-xr-x 1 root root 9697 Jan 12 13:44 unicast-vxlan.py
-rwxr-xr-x 1 root root 2800 Jan 12 13:44 unicast-vxlan.yang
```

### Verify processes
Below processes are must without which the package may not function as expected 

```
root@acf436c2d929:/# sv status unicast-vxlan
run: unicast-vxlan: (pid 100) 433s
root@acf436c2d929:/# sv status uipubd
run: uipubd: (pid 104) 437s
root@acf436c2d929:/# sv status mosquitto
run: mosquitto: (pid 102) 446s

root@acf436c2d929:/# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root        89  0.0  0.0   4408   816 ?        Ss   16:05   0:00 runsv uipubd
root        90  0.0  0.0   4408   816 ?        Ss   16:05   0:00 runsv mosquitto
root        91  0.0  0.0   4408   768 ?        Ss   16:05   0:00 runsv unicast-vxlan
root       100  0.0  0.0  81100 23612 ?        S    16:05   0:00 python3 /var/opt/unicast-vxlan/unicast-vxlan.py
root       101  0.0  0.0   4408   788 ?        Ss   16:05   0:00 runsv ppmd
nobody     102  1.5  0.0  53932 14288 ?        S    16:05   0:07 /usr/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf
root       103  0.0  0.0   4408   784 ?        Ss   16:05   0:00 runsv mgd
root       104  0.0  0.0 782104  7288 ?        S    16:05   0:00 /usr/libexec/ui-pubd -N
```

## Configuration examples
For examples for configuring VXLAN tunnels , refer to document [test-configs](./test-configs.md)

