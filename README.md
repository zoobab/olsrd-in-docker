About
=====

Run OLSRD routing daemon inside a docker container.

Why?
====

* Run many olsrd on multiple containers
* Load testing
* Simulations
* Generate packet loss and latency via netem module  
* Etc...

Status
======

Working, all the hosts appear in "route -n" after a while:

```
/ # route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         172.17.0.1      0.0.0.0         UG    0      0        0 eth0
172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 eth0
172.17.0.4      172.17.0.4      255.255.255.255 UGH   2      0        0 eth0
172.17.0.5      172.17.0.5      255.255.255.255 UGH   2      0        0 eth0
172.17.0.6      172.17.0.6      255.255.255.255 UGH   2      0        0 eth0
172.17.0.7      172.17.0.7      255.255.255.255 UGH   2      0        0 eth0
172.17.0.8      172.17.0.8      255.255.255.255 UGH   2      0        0 eth0
```

Pre-built image
===============

If you want to try, here is a oneliner:

```
$ docker run --privileged zoobab/olsrd-in-docker
ADD OUTPUT HERE
```
