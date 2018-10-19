#!/bin/bash
socat -v TCP-LISTEN:25826,fork UNIX-CONNECT:/var/run/collectd.sock&
exec /usr/sbin/collectd -f
