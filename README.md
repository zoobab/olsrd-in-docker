About
=====

Trying to run babel routing daemon inside a docker container.

Why?
====

* Run many babeld on multiple containers
* Load testing
* Simulations
* Generate packet loss and latency via netem module  
* Etc...

Status
======

WIP, I can't make 2 containers to see each other, don't know why...

Pre-built image
===============

If you want to try, here is a oneliner:

```
$ docker run --privileged zoobab/babeld-in-docker
Warning: couldn't find router id -- using random value.
Type: 0
Noticed ifindex change for eth0.
Noticed status change for eth0.
Sending seqno 49393 from address 0x61b070 (dump)
Netlink message: [multi] {seq:49393}(msg -> "found address on interface lo(1): 127.0.0.1
" 0), [multi] {seq:49393}(msg -> "found address on interface eth0(44): 172.17.0.2
[...]
```

Docker with IPv6
================

You need to configure Docker to use IPv6, which is not by default:

https://docs.docker.com/engine/userguide/networking/default_network/ipv6/

In my case, it means adding this config file "/etc/docker/daemon.json":

```
{
  "ipv6": true,
  "fixed-cidr-v6": "2001:db8:1::/64"
}
```

And then restart the docker daemon with:

```
$ systemctl restart docker
```

Then start a container and check that eth0 has an IPv6 address:

```
$ docker run -it alpine:3.6 ifconfig eth0
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:06
          inet addr:172.17.0.6  Bcast:0.0.0.0  Mask:255.255.0.0
          inet6 addr: fe80::42:acff:fe11:6/64 Scope:Link
          inet6 addr: 2001:db8:1::242:ac11:6/64 Scope:Global
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:6 errors:0 dropped:0 overruns:0 frame:0
          TX packets:3 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:594 (594.0 B)  TX bytes:266 (266.0 B)
```

Run babel inside docker
=======================

By default we use a LEDE image to build a rootfs with babeld 1.8.0 inside (see the Dockerfile).

If you want to build it, do:

```
$ docker build -t babeld .
```

This will produce an image called "babeld:latest":

```
$ docker images | grep babeld
babeld    	latest              10f14f275ae2        14 minutes ago      8.13MB
```

Now run the image:

```
$ docker run --privileged babeld
Warning: couldn't find router id -- using random value.
Noticed ifindex change for eth0.
Noticed status change for eth0.
Type: 0
Sending seqno 48915 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48915}(msg -> "found address on interface lo(1): 127.0.0.1
" 0), [multi] {seq:48915}(msg -> "found address on interface eth0(42): 172.17.0.2
" 0),
Netlink message: [multi] {seq:48915}(msg -> "found address on interface lo(1): ::1
" 0), [multi] {seq:48915}(msg -> "found address on interface eth0(42): 2001:db8:1::242:ac11:2
" 0), [multi] {seq:48915}(msg -> "found address on interface eth0(42): fe80::42:acff:fe11:2
" 1),
Netlink message: [multi] {seq:48915}(done)

Noticed IPv4 change for eth0.
Upped interface eth0 (cost=96, channel=-2, IPv4).
Sending hello 34789 (400) to eth0.
Sending self update to eth0.
Sending update to eth0 for any.
Sending self update to eth0.
Sending update to eth0 for any.
sending request to eth0 for any.
sending request to eth0 for any specific.
Sending seqno 48916 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48916}(msg -> "found address on interface lo(1): 127.0.0.1
" 0), [multi] {seq:48916}(msg -> "found address on interface eth0(42): 172.17.0.2
" 0),
Netlink message: [multi] {seq:48916}(msg -> "found address on interface lo(1): ::1
" 0), [multi] {seq:48916}(msg -> "found address on interface eth0(42): 2001:db8:1::242:ac11:2
" 0), [multi] {seq:48916}(msg -> "found address on interface eth0(42): fe80::42:acff:fe11:2
" 1),
Netlink message: [multi] {seq:48916}(done)


Checking kernel routes.
Sending seqno 48917 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48917}(msg -> "found address on interface lo(1): 127.0.0.1
" 1), [multi] {seq:48917}(msg -> "found address on interface eth0(42): 172.17.0.2
" 1),
Netlink message: [multi] {seq:48917}(msg -> "found address on interface lo(1): ::1
" 1), [multi] {seq:48917}(msg -> "found address on interface eth0(42): 2001:db8:1::242:ac11:2
" 1), [multi] {seq:48917}(msg -> "found address on interface eth0(42): fe80::42:acff:fe11:2
" 0),
Netlink message: [multi] {seq:48917}(done)

Sending seqno 48918 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48918}(msg -> "Add kernel route: dest: 2001:db8:1::/64 gw: :: metric: 256 if: eth0 (proto: 2, type: 1, from: ::/0)" 0), [multi] {seq:48918}(msg -> "Add kernel route: dest: fe80::/64 gw: :: metric: 256 if: eth0 (proto: 2, type: 1, from: ::/0)" 0), [multi] {seq:48918}(msg -> "Add kernel route: dest: ::/0 gw: 2001:db8:1::1 metric: 1024 if: eth0 (proto: 3, type: 1, from: ::/0)" 0), [multi] {seq:48918}(msg -> "" 0), [multi] {seq:48918}(msg -> "" 0), [multi] {seq:48918}(msg -> "" 0), [multi] {seq:48918}(msg -> "" 0),
Netlink message: [multi] {seq:48918}(done)

Sending seqno 48919 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48919}(msg -> "Add kernel route: dest: ::ffff:0.0.0.0/96 gw: ::ffff:172.17.0.1 metric: 0 if: eth0 (proto: 3, type: 1, from: ::/0)" 0), [multi] {seq:48919}(msg -> "Add kernel route: dest: ::ffff:172.17.0.0/112 gw: :: metric: 0 if: eth0 (proto: 2, type: 1, from: ::/0)" 0), [multi] {seq:48919}(msg -> "" 0), [multi] {seq:48919}(msg -> "" 0), [multi] {seq:48919}(msg -> "" 0), [multi] {seq:48919}(msg -> "" 0), [multi] {seq:48919}(msg -> "" 0), [multi] {seq:48919}(msg -> "" 0), [multi] {seq:48919}(msg -> "" 0),
Netlink message: [multi] {seq:48919}(done)

Sending seqno 48920 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48920}(msg -> "found address on interface lo(1): 127.0.0.1
" 1), [multi] {seq:48920}(msg -> "found address on interface eth0(42): 172.17.0.2
" 1),
Netlink message: [multi] {seq:48920}(msg -> "found address on interface lo(1): ::1
" 1), [multi] {seq:48920}(msg -> "found address on interface eth0(42): 2001:db8:1::242:ac11:2
" 1), [multi] {seq:48920}(msg -> "found address on interface eth0(42): fe80::42:acff:fe11:2
" 0),
Netlink message: [multi] {seq:48920}(done)

Sending seqno 48921 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48921}(msg -> "Add kernel route: dest: 2001:db8:1::/64 gw: :: metric: 256 if: eth0 (proto: 2, type: 1, from: ::/0)" 0), [multi] {seq:48921}(msg -> "Add kernel route: dest: fe80::/64 gw: :: metric: 256 if: eth0 (proto: 2, type: 1, from: ::/0)" 0), [multi] {seq:48921}(msg -> "Add kernel route: dest: ::/0 gw: 2001:db8:1::1 metric: 1024 if: eth0 (proto: 3, type: 1, from: ::/0)" 0), [multi] {seq:48921}(msg -> "" 0), [multi] {seq:48921}(msg -> "" 0), [multi] {seq:48921}(msg -> "" 0), [multi] {seq:48921}(msg -> "" 0),
Netlink message: [multi] {seq:48921}(done)

Sending seqno 48922 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48922}(msg -> "Add kernel route: dest: ::ffff:0.0.0.0/96 gw: ::ffff:172.17.0.1 metric: 0 if: eth0 (proto: 3, type: 1, from: ::/0)" 0), [multi] {seq:48922}(msg -> "Add kernel route: dest: ::ffff:172.17.0.0/112 gw: :: metric: 0 if: eth0 (proto: 2, type: 1, from: ::/0)" 0), [multi] {seq:48922}(msg -> "" 0), [multi] {seq:48922}(msg -> "" 0), [multi] {seq:48922}(msg -> "" 0), [multi] {seq:48922}(msg -> "" 0), [multi] {seq:48922}(msg -> "" 0), [multi] {seq:48922}(msg -> "" 0), [multi] {seq:48922}(msg -> "" 0),
Netlink message: [multi] {seq:48922}(done)

Sending seqno 48923 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48923}(msg -> "filter_rules: Unknown rule attribute: 14.
filter_rules: from ::/0 prio -1 table 255
" 0), [multi] {seq:48923}(msg -> "filter_rules: Unknown rule attribute: 14.
filter_rules: from ::/0 prio 32766 table 254
" 0),
Netlink message: [multi] {seq:48923}(done)

Sending seqno 48924 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48924}(msg -> "filter_rules: Unknown rule attribute: 14.
filter_rules: from ::/0 prio -1 table 255
" 0), [multi] {seq:48924}(msg -> "filter_rules: Unknown rule attribute: 14.
filter_rules: from ::/0 prio 32766 table 254
" 0), [multi] {seq:48924}(msg -> "filter_rules: Unknown rule attribute: 14.
filter_rules: from ::/0 prio 32767 table 253
" 0),
Netlink message: [multi] {seq:48924}(done)

  (flushing 17 buffered bytes on eth0)
Sending hello 34790 (400) to eth0.
  (flushing 20 buffered bytes on eth0)
Sending hello 34791 (400) to eth0.
Sending self update to eth0.
Sending update to eth0 for 172.17.0.2/32 from ::/0.
Sending update to eth0 for 2001:db8:1::242:ac11:2/128 from ::/0.
  (flushing 2 buffered updates on eth0 (42))
sending request to eth0 for any.
sending request to eth0 for any specific.
  (flushing 93 buffered bytes on eth0)
Entering main loop.

Received changes in kernel tables.
Netlink message: {seq:0}(msg -> "found address on interface eth0(42): fe80::42:acff:fe11:2
" -1),
Sending seqno 48925 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48925}(msg -> "found address on interface lo(1): 127.0.0.1
" 0), [multi] {seq:48925}(msg -> "found address on interface eth0(42): 172.17.0.2
" 0),
Netlink message: [multi] {seq:48925}(msg -> "found address on interface lo(1): ::1
" 0), [multi] {seq:48925}(msg -> "found address on interface eth0(42): 2001:db8:1::242:ac11:2
" 0), [multi] {seq:48925}(msg -> "found address on interface eth0(42): fe80::42:acff:fe11:2
" 1),
Netlink message: [multi] {seq:48925}(done)


Checking kernel routes.
Sending seqno 48926 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48926}(msg -> "found address on interface lo(1): 127.0.0.1
" 1), [multi] {seq:48926}(msg -> "found address on interface eth0(42): 172.17.0.2
" 1),
Netlink message: [multi] {seq:48926}(msg -> "found address on interface lo(1): ::1
" 1), [multi] {seq:48926}(msg -> "found address on interface eth0(42): 2001:db8:1::242:ac11:2
" 1), [multi] {seq:48926}(msg -> "found address on interface eth0(42): fe80::42:acff:fe11:2
" 0),
Netlink message: [multi] {seq:48926}(done)

Sending seqno 48927 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48927}(msg -> "Add kernel route: dest: 2001:db8:1::/64 gw: :: metric: 256 if: eth0 (proto: 2, type: 1, from: ::/0)" 0), [multi] {seq:48927}(msg -> "Add kernel route: dest: fe80::/64 gw: :: metric: 256 if: eth0 (proto: 2, type: 1, from: ::/0)" 0), [multi] {seq:48927}(msg -> "Add kernel route: dest: ::/0 gw: 2001:db8:1::1 metric: 1024 if: eth0 (proto: 3, type: 1, from: ::/0)" 0), [multi] {seq:48927}(msg -> "" 0), [multi] {seq:48927}(msg -> "" 0), [multi] {seq:48927}(msg -> "" 0), [multi] {seq:48927}(msg -> "" 0), [multi] {seq:48927}(msg -> "" 0), [multi] {seq:48927}(msg -> "" 0),
Netlink message: [multi] {seq:48927}(done)

Sending seqno 48928 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48928}(msg -> "Add kernel route: dest: ::ffff:0.0.0.0/96 gw: ::ffff:172.17.0.1 metric: 0 if: eth0 (proto: 3, type: 1, from: ::/0)" 0), [multi] {seq:48928}(msg -> "Add kernel route: dest: ::ffff:172.17.0.0/112 gw: :: metric: 0 if: eth0 (proto: 2, type: 1, from: ::/0)" 0), [multi] {seq:48928}(msg -> "" 0), [multi] {seq:48928}(msg -> "" 0), [multi] {seq:48928}(msg -> "" 0), [multi] {seq:48928}(msg -> "" 0), [multi] {seq:48928}(msg -> "" 0), [multi] {seq:48928}(msg -> "" 0), [multi] {seq:48928}(msg -> "" 0),
Netlink message: [multi] {seq:48928}(done)

Sending seqno 48929 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48929}(msg -> "filter_rules: Unknown rule attribute: 14.
filter_rules: from ::/0 prio -1 table 255
" 0), [multi] {seq:48929}(msg -> "filter_rules: Unknown rule attribute: 14.
filter_rules: from ::/0 prio 32766 table 254
" 0),
Netlink message: [multi] {seq:48929}(done)

Sending seqno 48930 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48930}(msg -> "filter_rules: Unknown rule attribute: 14.
filter_rules: from ::/0 prio -1 table 255
" 0), [multi] {seq:48930}(msg -> "filter_rules: Unknown rule attribute: 14.
filter_rules: from ::/0 prio 32766 table 254
" 0), [multi] {seq:48930}(msg -> "filter_rules: Unknown rule attribute: 14.
filter_rules: from ::/0 prio 32767 table 253
" 0),
Netlink message: [multi] {seq:48930}(done)


Received changes in kernel tables.
Netlink message: {seq:0}(msg -> "" 0),

Received changes in kernel tables.
Netlink message: {seq:0}(msg -> "" 0),

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
Sending hello 34792 (400) to eth0.

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
  (flushing 8 buffered bytes on eth0)

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
Checking neighbours.

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
Sending hello 34793 (400) to eth0.
  (flushing 8 buffered bytes on eth0)

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
Sending hello 34794 (400) to eth0.

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
  (flushing 8 buffered bytes on eth0)

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
Sending hello 34795 (400) to eth0.

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
Sending self update to eth0.
Sending update to eth0 for 172.17.0.2/32 from ::/0.
Sending update to eth0 for 2001:db8:1::242:ac11:2/128 from ::/0.
Sending update to eth0 for any.
Sending self update to eth0.
Sending update to eth0 for 172.17.0.2/32 from ::/0.
Sending update to eth0 for 2001:db8:1::242:ac11:2/128 from ::/0.
Sending update to eth0 for any.

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
  (flushing 4 buffered updates on eth0 (42))
  (flushing 72 buffered bytes on eth0)

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
Sending hello 34796 (400) to eth0.
  (flushing 8 buffered bytes on eth0)

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
Sending hello 34797 (400) to eth0.

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
  (flushing 8 buffered bytes on eth0)

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
Sending seqno 48931 from address 0x61b070 (dump)
Netlink message: [multi] {seq:48931}(msg -> "found address on interface lo(1): 127.0.0.1
" 0), [multi] {seq:48931}(msg -> "found address on interface eth0(42): 172.17.0.2
" 0),
Netlink message: [multi] {seq:48931}(msg -> "found address on interface lo(1): ::1
" 0), [multi] {seq:48931}(msg -> "
My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
found address on interface eth0(42): 2001:db8:1::242:ac11:2
" 0), [multi] {seq:48931}(msg -> "found address on interface eth0(42): fe80::42:acff:fe11:2
" 1),
Netlink message: [multi] {seq:48931}(done)


My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
Sending hello 34798 (400) to eth0.

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
  (flushing 8 buffered bytes on eth0)
Sending hello 34799 (400) to eth0.
Sending self update to eth0.
Sending update to eth0 for 172.17.0.2/32 from ::/0.
Sending update to eth0 for 2001:db8:1::242:ac11:2/128 from ::/0.
Sending update to eth0 for any.
Sending self update to eth0.
Sending update to eth0 for 172.17.0.2/32 from ::/0.
Sending update to eth0 for 2001:db8:1::242:ac11:2/128 from ::/0.
Sending update to eth0 for any.

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
  (flushing 4 buffered updates on eth0 (42))
  (flushing 72 buffered bytes on eth0)

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
Sending hello 34800 (400) to eth0.
  (flushing 8 buffered bytes on eth0)

My id c0:9d:c1:19:a7:ef:2d:88 seqno 14312
172.17.0.2/32 metric 0 (exported)
2001:db8:1::242:ac11:2/128 metric 0 (exported)
```
