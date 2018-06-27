#!/bin/bash
## load all zones
file_opts=''
config_path='/etc/openvpn'
status_path='/run/openvpn.status'
pid_path='/run/openvpn.pid'

## create tun device
## https://caveofcode.com/2017/06/how-to-setup-a-vpn-connection-from-inside-a-pod-in-kubernetes/
mkdir -p /dev/net
mknod -m 600 /dev/net/tun c 10 200
openvpn --mktun --dev tun0 --dev-type tun --user root --group nobody

## start
openvpn_cmd="exec openvpn \
  "$@" \
  "$file_opts" \
  --dev tun0 \
  --cd "$config_path" \
  --status "$status_path" 10 \
  --writepid "$pid_path""

rm -f $status_path $pid_path
exec sg nobody -c "$openvpn_cmd"
