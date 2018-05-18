#!/bin/bash
socat -v TCP-LISTEN:8888,fork UNIX-CONNECT:/var/run/collectd.sock&
exec /usr/sbin/collectd -f
