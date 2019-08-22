#!/bin/sh

status_file=${STATUS_FILE:-/run/openvpn.status}
pid_file=${PID_FILE:-/run/openvpn.pid}
tun_interface=${TUN_INTERFACE:-tun0}

## create tun device
## https://caveofcode.com/2017/06/how-to-setup-a-vpn-connection-from-inside-a-pod-in-kubernetes/
mkdir -p /dev/net
mknod -m 600 /dev/net/tun c 10 200
openvpn --mktun --dev $tun_interface --dev-type tun --user root --group nobody

## start
openvpn_cmd="exec openvpn \
  "$@" \
  --dev $tun_interface \
  --status $status_file 10 \
  --writepid $pid_file"

rm -f $status_file $pid_file
exec sg nobody -c "$openvpn_cmd"
